<cfsilent>
	<cfset request.isEditor=(listFind(session.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite(request.siteid).getPrivateUserPoolID()#')
			and application.permUtility.getnodePerm(request.crumbdata) neq 'none')
			or listFind(session.mura.memberships,'S2')>
	<cfset AlreadyReviewed=0 />
</cfsilent>
<cfset rsComments = "">
<cfquery name="rsComments" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select
		*
	from
		tcontentcomments
	where
		UserID='#Session.Mura.UserID#'
</cfquery>
<!--- <cfset rsComments=application.contentManager.readComments('ProductID_#url.ProductID#',request.siteid,request.isEditor) /> --->
<div id="ProductReviews">
	<cfif rsComments.recordcount>
		<form id="updateComment" method="post" name="updateComment" action="" >
			<input type="hidden" id="updateCommentID" name="CommentID" value="" />
			<input type="hidden" id="updateCommentProcess" name="Process" value="" /> 
			<cfoutput query="rsComments"  startrow="#request.startrow#">
				<cfset ThisProductID = Replace(rsComments.contentID, "ProductID_", "", "all") />
				<cfset Product = application.Slat.productManager.read('#ThisProductID#') />
				<cfif rsComments.userid eq session.mura.userid>
					<cfset AlreadyReviewed=1>
				</cfif>
				<cfset class=iif(rsComments.currentrow eq 1,de('first'),de(iif(rsComments.currentrow eq rsComments.recordcount,de('last'),de('')))) />
				<dl class="#class#" id="comment-#rscomments.commentid#">
					<cfset ThisUser = application.userManager.read(userid=rsComments.userid) />
					<dt class="image">
						<a href="/index.cfm/product/?ProductID=#ThisProductID#">
							<cfimage source="../../../prodimages/#Product.getDefaultImageID()#-DEFAULT-S.jpg" action="resize" name="productimage" width="60" height="60" />
							<cfimage source="#productimage#" action="writeToBrowser" />
						</a>
					</dt>
					<dt class="rating">
						#application.Slat.productManager.dspUserRating(Product.getUserProductRating(rsComments.userid))#
					</dt>
					<dt class="name">
						<a href="/index.cfm/product/?ProductID=#ThisProductID#">
							#Product.getBrand()# #Product.getProductName()#
						</a>
					</dt>				
					<dd class="dateTime">
						<cfif rsComments.entered neq "">#LSDateFormat(rsComments.entered,"long")#, #LSTimeFormat(rsComments.entered,"short")#</cfif>
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
			</cfoutput>
		</form>
	<cfelse>
		<p>There are no Product Reviews Written by this Account.</p>
	</cfif>
	
</div>