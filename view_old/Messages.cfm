<cfset MessageLog = application.slat.messageManager.getMessageLog() />

<cfoutput>
	<table class="stripe">
		<tbody>
			<tr>
				<th>LogID</th>
				<th>Date Create</th>
				<th>Message Code</th>
				<th>Form Name</th>
				<th>Input Name</th>
				<th>Custom ID</th>
				<th>Process</th>
				<th>Shown</th>
				<th>DT Shown</th>
				<th>Session</th>
				<th>Form</th>
				<th>CGI</th>
			</tr>
		</tbody>
		<cfloop query="MessageLog" startrow="1" endrow="15"> 
			<tr>
				<td>#MessageLog.MessageLogID#</td>
				<td>#MessageLog.DTCreated#</td>
				<td>#MessageLog.MessageCode#</td>
				<td>#MessageLog.FormName#</td>
				<td>#MessageLog.InputName#</td>
				<td>#MessageLog.CustomID#</td>
				<td>#MessageLog.slatProcess#</td>
				<td>#MessageLog.Shown#</td>
				<td>#MessageLog.DTShown#</td>
				<td class="administration">
					<ul class="one">
						<li class="preview"><a onclick="getMessageLogDetail('#MessageLog.MessageLogID#', 'CurrentSession')" href="##MessageDetail" title="Preview">&nbsp;</a></li>
					</ul>
				</td>
				<td class="administration">
					<ul class="one">
						<li class="preview"><a onclick="getMessageLogDetail('#MessageLog.MessageLogID#', 'CurrentForm')" href="##MessageDetail" title="Preview">&nbsp;</a></li>
					</ul>
				</td>
				<td class="administration">
					<ul class="one">
						<li class="preview"><a onclick="getMessageLogDetail('#MessageLog.MessageLogID#', 'CurrentCGI')" href="##MessageDetail" title="Preview">&nbsp;</a></li>
					</ul>
				</td>
				
			</tr>
		</cfloop>
	</table>
	<a name="MessageLogDetail">
	<style type="text/css">
		.cfdump_struct {width:650px !Important;}
		.cfdump_struct td {white-space: normal !Important; text-align:left;}
	</style>
	<div id="MessageLogDetail"></div>
</cfoutput>