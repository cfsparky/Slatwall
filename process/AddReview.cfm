<cfset commentdata = structnew() />
<cfset commentdata.commentid = form.ReviewID />
<cfset commentdata.contentID = form.ContentID />
<cfset commentdata.siteID = request.siteID />
<cfset commentdata.comments = form.review />
<cfset commentdata.name = form.name />
<cfset commentdata.userID = form.userID />
<cfset commentBean=application.contentManager.saveComment(commentdata) />

