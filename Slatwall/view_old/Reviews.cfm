<cfquery name="rsComments" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select
		*
	from
		tcontentcomments
	where
		isApproved=0
</cfquery>

<div id="ProductReviews">
	<cfif rsComments.recordcount>
		<form id="updateComment" method="post" name="updateComment" action="" >
			<input type="hidden" id="updateCommentID" name="CommentID" value="" />
			<input type="hidden" id="updateCommentProcess" name="Process" value="" /> 
			<cfoutput query="rsComments">
				<cfset ThisProductID = Replace(rsComments.contentID, "ProductID_", "", "all") />
				<cfset Product = application.Slat.productManager.read('#ThisProductID#') />
				<cfif rsComments.userid eq session.mura.userid>
					<cfset AlreadyReviewed=1>
				</cfif>
				<cfset class=iif(rsComments.currentrow eq 1,de('first'),de(iif(rsComments.currentrow eq rsComments.recordcount,de('last'),de('')))) />
				<dl class="#class#" id="comment-#rscomments.commentid#">
					<cfset ThisUser = application.userManager.read(userid=rsComments.userid) />
					<dt class="image">
						<a href="/index.cfm/product/?ProductID=#ThisProductID#" target="reviewpopup">
							<cfimage source="../../../prodimages/#Product.getDefaultImageID()#-DEFAULT-S.jpg" action="resize" name="productimage" width="40" height="50" />
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
						#LSDateFormat(rsComments.entered,"long")#, #LSTimeFormat(rsComments.entered,"short")#
					</dd>
					<dd class="review">
						#rsComments.comments#
					</dd>
				</dl>
				<hr class="clear" />
			</cfoutput>
		</form>
	<cfelse>
		<p>There are no Un-Approved Product Reviews.</p>
	</cfif>
	
</div>