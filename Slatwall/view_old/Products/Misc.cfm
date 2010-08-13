<cfquery name="get_web_style_info" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
	select count(*) as cnt from tb_web_style_info where style_id=#url.ProductID#
</cfquery>

<cfif get_web_style_info.cnt eq 0>
	<cfquery name="get_new_web_style_info" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
	select max(WEB_STYLE_INFO_ID) as new_id from tb_web_style_info
	</cfquery>

	<cfset get_new_web_style_info.new_id=val(get_new_web_style_info.new_id)+1>
	<cfquery name="insert_web_style_info" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
	insert into tb_web_style_info (style_id, COMPONENTS,FULL_DESCRIPTION,GEOMETRY,INGREDIENTS, MISC_1,MISC_2,MISC_3,MISC_4,MISC_5,SIZE_CHART,SPECIFICATIONS,WEB_STYLE_INFO_ID)
	values (#url.ProductID#,'','','','','','','','','','','',#val(get_new_web_style_info.new_id)#)
	</cfquery>
</cfif>

<cfquery name="get_web_style_info" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
select * from tb_web_style_info where style_id=#url.ProductID#
</cfquery>
<cfoutput>
<form action="?slatView=Products&slatDetail=ProductDetail&ProductID=#url.ProductID#" method="post">
	<input type="hidden" name="slatProcess" value="TempUpdateMisc" />
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><strong>Size Chart: </strong></td>
    <td><textarea name="size_chart" rows="5" cols="80">#get_web_style_info.size_chart#</textarea></td>
  </tr>
  <tr>
      <td><strong>Geometry: </strong></td>
      <td><textarea name="geometry" rows="5" cols="80">#get_web_style_info.geometry#</textarea></td>
  </tr>
  <tr>
      <td><strong>Ingredients: </strong></td>
      <td><textarea name="ingredients" rows="5" cols="80">#get_web_style_info.ingredients#</textarea></td>
  </tr>
  <tr>
      <td><strong>Wheel Info: </strong></td>
      <td><textarea name="misc_1" rows="5" cols="80">#get_web_style_info.misc_1#</textarea></td>
  </tr>
   <tr>
       <td><strong>Nutrition Info: </strong></td>
       <td><textarea name="misc_2" rows="5" cols="80">#get_web_style_info.misc_2#</textarea></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="Submit" value="Save" /></td>
  </tr>
</table>
</form>
</cfoutput>