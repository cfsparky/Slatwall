<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	UPDATE tslatsettings SET SettingValue='#Form.SettingIntegrationDSN#' where SettingName='IntegrationDSN'
	UPDATE tslatsettings SET SettingValue='#Form.SettingIntegrationDBUsername#' where SettingName='IntegrationDBUsername'
	UPDATE tslatsettings SET SettingValue='#Form.SettingIntegrationDBPassword#' where SettingName='IntegrationDBPassword'
	UPDATE tslatsettings SET SettingValue='#Form.SettingIntegrationType#' where SettingName='IntegrationType'
</cfquery>
<cflocation url="/admin/index.cfm?appreload&reload=appreload" addtoken="false" />