<cfsilent>
	<cfset request.isEditor=(listFind(session.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite(request.siteid).getPrivateUserPoolID()#')
			and application.permUtility.getnodePerm(request.crumbdata) neq 'none')
			or listFind(session.mura.memberships,'S2')>
	<cfset AlreadyReviewed=0 />
</cfsilent>
<cfset rsComments=application.contentManager.readComments('ProductID_#url.ProductID#',request.siteid,1) />
<div id="ProductReviews">
	<a name="comments"></a>
	<cfif rsComments.recordcount>
		<form id="updateComment" method="post" name="updateComment" action="" >
			<input type="hidden" id="updateCommentID" name="CommentID" value="" />
			<input type="hidden" id="updateCommentProcess" name="slatProcess" value="" /> 
			<cfoutput query="rsComments"  startrow="#request.startrow#">
				<cfif rsComments.isapproved or rsComments.userid eq session.mura.userid or request.isEditor>
					<cfif rsComments.userid eq session.mura.userid>
						<cfset AlreadyReviewed=1>
					</cfif>
					<cfset class=iif(rsComments.currentrow eq 1,de('first'),de(iif(rsComments.currentrow eq rsComments.recordcount,de('last'),de('')))) />
					<dl class="#class#" id="comment-#rscomments.commentid#">
						<cfset ThisUser = application.userManager.read(userid=rsComments.userid) />
						<dt class="image">
							<cfif len(ThisUser.getPhotoFileID()) lt 1 or rsComments.name eq "Anonymous">
								<cfimage source="../images/misc/default_avatar.jpg" action="resize" name="avatar" width="60" height="60" />
								<cfimage source="#avatar#" action="writeToBrowser" />
							<cfelse>
								<cfset ImageLocation="/default/cache/file/#ThisUser.getPhotoFileID()#.JPG" />
								#application.PowerImage.dspImage(Image="#ImageLocation#", width=60, height=60)#
								<!--- <img src="#application.configBean.getContext()#/tasks/render/small/?fileid=#ThisUser.getPhotoFileID()#" alt="Avatar" /> --->	
							</cfif>
						</dt>
						<dt class="rating">
							#application.Slat.productManager.dspUserRating(request.slat.Product.getUserProductRating(rsComments.userid))#
						</dt>
						<dt class="name">
							<cfif rsComments.name eq "Anonymous">
								Anonymous
							<cfelse>
								#ThisUser.getfname()# #ThisUser.getlname()#
							</cfif>  
						</dt>				
						<dd class="dateTime">
							#LSDateFormat(rsComments.entered,"long")#, #LSTimeFormat(rsComments.entered,"short")#
							<cfif request.isEditor>
								| <a href="javascript: void(0);" onClick="updateHiddenValue('##updateCommentID', '#rscomments.commentid#'); updateHiddenValue('##updateCommentProcess', 'DeleteReview'); submitSlatForm('##updateComment');">Delete</a>
								<cfif rsComments.isApproved neq 1>
									| <a href="javascript: void(0);" onClick="updateHiddenValue('##updateCommentID', '#rscomments.commentid#'); updateHiddenValue('##updateCommentProcess', 'ApproveReview'); submitSlatForm('##updateComment');">Approve</a>
								</cfif>
							<cfelseif session.mura.userid eq rsComments.userid>
								| <a href="javascript: void(0);" onClick="updateHiddenValue('##updateCommentID', '#rscomments.commentid#'); updateHiddenValue('##updateCommentProcess', 'DeleteReview'); submitSlatForm('##updateComment');">Delete</a>
							</cfif>
						</dd>
						<dd class="review">
							#rsComments.comments#
						</dd>
					</dl>
					<hr class="clear" />
				</cfif>
			</cfoutput>
		</form>
	</cfif>

	<cfif $.currentUser("isLoggedIn")>
		<cfif AlreadyReviewed>
			<h2>Write A Review</h2>
			<div class="AlreadyReviewed">
				<p>You have already written a review on this Item.  Please delete your previous review first.</p>
			</div>
		<cfelse>
			<cfoutput>
				<h2>Write A Review</h2>
				<form id="postcomment" method="post" name="addComment" action="#cgi.script_name##cgi.path_info#?#cgi.query_string#" onsubmit="return validate(this);" >
					<label class="RatingLabel">Rating</label>
					#application.Slat.productManager.dspRating('#request.Slat.Product.getProductID()#', session.mura.userid, request.Slat.Product.getUserProductRating(session.mura.userid), 0)#
					<label for="txtReview" class="ReviewLable">Review</label>
					<textarea id="txtReview" name="review"></textarea>
					<label for="chkAnonymous" class="AnonymousLable">Anonymous</label>
					<input type="checkbox" id="chkAnonymous" name="name" value="Anonymous" />
					<div class="buttons">
						<input type="hidden" name="slatProcess" value="AddReview" />
						<input type="hidden" name="UserID" value="#session.mura.userID#" />
						<input type="hidden" name="ContentID" value="ProductID_#url.ProductID#" />
						<input type="hidden" name="OnSuccess" value="#cgi.script_name##cgi.path_info#?#cgi.query_string#" />
						<input type="hidden" name="onError" value="#cgi.script_name##cgi.path_info#?#cgi.query_string#" />
						<input type="hidden" name="ReviewID" value="#createuuid()#" />
						<button class="slatButton btnAddReview" type="submit">Add Review</button>
					</div>
				</form>
			</cfoutput>
		</cfif>
	<cfelse>
		<cfoutput>
			<cfset DisplaySettings = structnew() />
			<cfset DisplaySettings.CustomClass = "Review_Signin" />
			<cfset DisplaySettings.SigninText = "Login to write a Review" />
			<cfset DisplaySettings.SmallButtons = 1 />
			#application.Slat.dspManager.get(Display="AccountLoginForm",DisplaySettings=DisplaySettings)#
		</cfoutput>
	</cfif>
</div>