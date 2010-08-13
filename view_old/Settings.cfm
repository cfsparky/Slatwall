<cfoutput>
	<form name="updateSettings" method="post">
		<input type="hidden" name="slatProcess" value="UpdateSlatSettings" />
		<dl class="oneColumn">
			<dt class="first">Integration Type</dt>
			<dd>
				<select name="SettingIntegrationType">
					<option value="Celerant" <cfif application.slatsettings.getSetting('IntegrationType') eq "Celerant">selected="selected"</cfif>>Celerant</option>
					<option value="Quickbooks" <cfif application.slatsettings.getSetting('IntegrationType') eq "Quickbooks">selected="selected"</cfif>>Quickbooks</option>
				</select>
			</dd>
			<dt>Integration DSN</dt>
			<dd><input type="text" name="SettingIntegrationDSN" value="#application.slatsettings.getSetting('IntegrationDSN')#" /></dd>
			<dt>Integration Database Username</dt>
			<dd><input type="text" name="SettingIntegrationDBUsername" value="#application.slatsettings.getSetting('IntegrationDBUsername')#" /></dd>
			<dt>Integration Database Password</dt>
			<dd><input type="password" name="SettingIntegrationDBPassword" value="#application.slatsettings.getSetting('IntegrationDBPassword')#" /></dd>
		</dl>
		<a onclick="$('form[name=updateSettings]').submit();" href="javascript:;" class="submit"><span>Update</span></a>
	</form>
</cfoutput>