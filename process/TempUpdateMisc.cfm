<cfquery name="update_web_style_info" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
	update
		tb_web_style_info
	set
		size_chart='#form.size_chart#',
		geometry='#form.geometry#',
		ingredients='#form.ingredients#',
		misc_1='#form.misc_1#',
		misc_2='#form.misc_2#'
	where
		style_id=#url.ProductID#
</cfquery>