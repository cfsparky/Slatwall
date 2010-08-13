<cfoutput>
<cffunction name="createoptionlist">
	<cfargument name="column" type="string" required="true">
	<cfset output = "">
	
	<cfquery name="get_web_compare_list" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
		select #column# as thisc from tb_web_compare group by #column#
	</cfquery>
	
	<cfloop query="get_web_compare_list">
		<cfset output = output.concat("<option value='") >
		<cfset output = output.concat(get_web_compare_list.thisc) >
		<cfset output = output.concat("' />") >
		<cfset output = output.concat(get_web_compare_list.thisc) >
		<cfset output = output.concat("</output>") >
	</cfloop>
	
	<cfreturn output>
</cffunction>

<cfquery name="get_web_compare_count" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
	select count(*) as cnt from tb_web_compare where style_id=#url.ProductID#
</cfquery>

<cfif get_web_compare_count.cnt eq 0>
	<cfquery name="insert_web_compare" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
		insert into tb_web_compare (style_id)
		values (#url.ProductID#)
	</cfquery>
</cfif>

	<style>
		.alt{
			background-color:##DDDDDD;
		}
		select{
			width:350px;
		}
		textarea{
			width:350px;
			height: 100px;
		}
	</style>
	<cfquery name="get_web_compare" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
		select * from tb_web_compare where style_id=#url.ProductID#
	</cfquery>
	<form action="?slatView=Products&slatDetail=ProductDetail&ProductID=#url.ProductID#" method="post">
		<input type="hidden" name="slatProcess" value="TempUpdateSpecifications" />
		<table>
			<tr>
				<th>Field</th>
				<th>Value</th>
				<th>URL</th>
			</tr>
			<tr>
				<td>TOTAL WEIGHT:</td>
				<td>
					<input type="text" name="TOTAL_WEIGHT_LBS" value="#get_web_compare.TOTAL_WEIGHT_LBS#" />lbs<br />
					<input type="text" name="TOTAL_WEIGHT_KGS" value="#get_web_compare.TOTAL_WEIGHT_KGS#" />kgs<br />
					<input type="text" name="TOTAL_WEIGHT_GRAMS" value="#get_web_compare.TOTAL_WEIGHT_GRAMS#" />grams<br />
				</td>
				<td></td>
			</tr>
			<tr class="alt">
				<td>FRAME:</td>
				<td><textarea id="FRAME" name="FRAME">#get_web_compare.FRAME#</textarea></td>
				<td><input type="text" name="FRAME_URL" value="#get_web_compare.FRAME_URL#" /></td>
			</tr>
			<tr>
				<td>FORK:</td>
				<td><select onchange="document.getElementById('FORK').value = this.value;this.style.display ='none';">#createoptionlist("FORK")#</select><br /><textarea id="FORK" name="FORK">#get_web_compare.FORK#</textarea></td>
				<td><input type="text" name="FORK_URL" value="#get_web_compare.FORK_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>WHEELS:</td>
				<td><select onchange="document.getElementById('WHEELS').value = this.value;this.style.display ='none';">#createoptionlist("WHEELS")#</select><br /><textarea id="WHEELS" name="WHEELS">#get_web_compare.WHEELS#</textarea></td>
				<td><input type="text" name="WHEELS_URL" value="#get_web_compare.WHEELS_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>RIMS:</td>
				<td><select onchange="document.getElementById('RIMS').value = this.value;this.style.display ='none';">#createoptionlist("RIMS")#</select><br /><textarea id="RIMS" name="RIMS">#get_web_compare.RIMS#</textarea></td>
				<td><input type="text" name="RIMS_URL" value="#get_web_compare.RIMS_URL#" /></td>
			</tr>
			<tr>
				<td>HUBS:</td>
				<td><select onchange="document.getElementById('HUBS').value = this.value;this.style.display ='none';">#createoptionlist("HUBS")#</select><br /><textarea id="HUBS" name="HUBS">#get_web_compare.HUBS#</textarea></td>
				<td><input type="text" name="HUBS_URL" value="#get_web_compare.HUBS_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>SPOKES:</td>
				<td><select onchange="document.getElementById('SPOKES').value = this.value;this.style.display ='none';">#createoptionlist("SPOKES")#</select><br /><textarea id="SPOKES" name="SPOKES">#get_web_compare.SPOKES#</textarea></td>
				<td><input type="text" name="SPOKES_URL" value="#get_web_compare.SPOKES_URL#" /></td>
			</tr>
			<tr>
				<td>TIRES:</td>
				<td><select onchange="document.getElementById('TIRES').value = this.value;this.style.display ='none';">#createoptionlist("TIRES")#</select><br /><textarea id="TIRES" name="TIRES">#get_web_compare.TIRES#</textarea></td>
				<td><input type="text" name="TIRES_URL" value="#get_web_compare.TIRES_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>CHAIN:</td>
				<td><select onchange="document.getElementById('CHAIN').value = this.value;this.style.display ='none';">#createoptionlist("CHAIN")#</select><br /><textarea id="CHAIN" name="CHAIN">#get_web_compare.CHAIN#</textarea></td>
				<td><input type="text" name="CHAIN_URL" value="#get_web_compare.CHAIN_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>STEM:</td>
				<td><select onchange="document.getElementById('STEM').value = this.value;this.style.display ='none';">#createoptionlist("STEM")#</select><br /><textarea id="STEM" name="STEM">#get_web_compare.STEM#</textarea></td>
				<td><input type="text" name="STEM_URL" value="#get_web_compare.STEM_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>HANDLEBAR:</td>
				<td><select onchange="document.getElementById('HANDLEBAR').value = this.value;this.style.display ='none';">#createoptionlist("HANDLEBAR")#</select><br /><textarea id="HANDLEBAR" name="HANDLEBAR">#get_web_compare.HANDLEBAR#</textarea></td>
				<td><input type="text" name="HANDLEBAR_URL" value="#get_web_compare.HANDLEBAR_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>FRONT_DERAILLEUR:</td>
				<td><select onchange="document.getElementById('FRONT_DERAILLEUR').value = this.value;this.style.display ='none';">#createoptionlist("FRONT_DERAILLEUR")#</select><br /><textarea id="FRONT_DERAILLEUR" name="FRONT_DERAILLEUR">#get_web_compare.FRONT_DERAILLEUR#</textarea></td>
				<td><input type="text" name="FRONT_DERAILLEUR_URL" value="#get_web_compare.FRONT_DERAILLEUR_URL#" /></td>
			</tr>
			<tr>
				<td>REAR_DERAILLEUR:</td>
				<td><select onchange="document.getElementById('REAR_DERAILLEUR').value = this.value;this.style.display ='none';">#createoptionlist("REAR_DERAILLEUR")#</select><br /><textarea id="REAR_DERAILLEUR" name="REAR_DERAILLEUR">#get_web_compare.REAR_DERAILLEUR#</textarea></td>
				<td><input type="text" name="REAR_DERAILLEUR_URL" value="#get_web_compare.REAR_DERAILLEUR_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>SHIFTERS:</td>
				<td><select onchange="document.getElementById('SHIFTERS').value = this.value;this.style.display ='none';">#createoptionlist("SHIFTERS")#</select><br /><textarea id="SHIFTERS" name="SHIFTERS">#get_web_compare.SHIFTERS#</textarea></td>
				<td><input type="text" name="SHIFTERS_URL" value="#get_web_compare.SHIFTERS_URL#" /></td>
			</tr>
			<tr>
				<td>CRANK:</td>
				<td><select onchange="document.getElementById('CRANK').value = this.value;this.style.display ='none';">#createoptionlist("CRANK")#</select><br /><textarea id="CRANK" name="CRANK">#get_web_compare.CRANK#</textarea></td>
				<td><input type="text" name="CRANK_URL" value="#get_web_compare.CRANK_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>BOTTOM_BRACKET:</td>
				<td><select onchange="document.getElementById('BOTTOM_BRACKET').value = this.value;this.style.display ='none';">#createoptionlist("BOTTOM_BRACKET")#</select><br /><textarea id="BOTTOM_BRACKET" name="BOTTOM_BRACKET">#get_web_compare.BOTTOM_BRACKET#</textarea></td>
				<td><input type="text" name="BOTTOM_BRACKET_URL" value="#get_web_compare.BOTTOM_BRACKET_URL#" /></td>
			</tr>
			<tr>
				<td>CASSETTE:</td>
				<td><select onchange="document.getElementById('CASSETTE').value = this.value;this.style.display ='none';">#createoptionlist("CASSETTE")#</select><br /><textarea id="CASSETTE" name="CASSETTE">#get_web_compare.CASSETTE#</textarea></td>
				<td><input type="text" name="CASSETTE_URL" value="#get_web_compare.CASSETTE_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>SADDLE:</td>
				<td><select onchange="document.getElementById('SADDLE').value = this.value;this.style.display ='none';">#createoptionlist("SADDLE")#</select><br /><textarea id="SADDLE" name="SADDLE">#get_web_compare.SADDLE#</textarea></td>
				<td><input type="text" name="SADDLE_URL" value="#get_web_compare.SADDLE_URL#" /></td>
			</tr>
			<tr>
				<td>SEAT_POST:</td>
				<td><select onchange="document.getElementById('SEAT_POST').value = this.value;this.style.display ='none';">#createoptionlist("SEAT_POST")#</select><br /><textarea id="SEAT_POST" name="SEAT_POST">#get_web_compare.SEAT_POST#</textarea></td>
				<td><input type="text" name="SEAT_POST_URL" value="#get_web_compare.SEAT_POST_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>HEADSET:</td>
				<td><select onchange="document.getElementById('HEADSET').value = this.value;this.style.display ='none';">#createoptionlist("HEADSET")#</select><br /><textarea id="HEADSET" name="HEADSET">#get_web_compare.HEADSET#</textarea></td>
				<td><input type="text" name="HEADSET_URL" value="#get_web_compare.HEADSET_URL#" /></td>
			</tr>
			<tr>
				<td>BRAKE_CALIPERS:</td>
				<td><select onchange="document.getElementById('BRAKE_CALIPERS').value = this.value;this.style.display ='none';">#createoptionlist("BRAKE_CALIPERS")#</select><br /><textarea id="BRAKE_CALIPERS" name="BRAKE_CALIPERS">#get_web_compare.BRAKE_CALIPERS#</textarea></td>
				<td><input type="text" name="BRAKE_CALIPERS_URL" value="#get_web_compare.BRAKE_CALIPERS_URL#" /></td>
			</tr>
			<tr class="alt">
				<td>BRAKE_LEVERS:</td>
				<td><select onchange="document.getElementById('BRAKE_LEVERS').value = this.value;this.style.display ='none';">#createoptionlist("BRAKE_LEVERS")#</select><br /><textarea id="BRAKE_LEVERS" name="BRAKE_LEVERS">#get_web_compare.BRAKE_LEVERS#</textarea></td>
				<td><input type="text" name="BRAKE_LEVERS_URL" value="#get_web_compare.BRAKE_LEVERS_URL#" /></td>
			</tr>
			<tr>
				<td colspan="3" /><input type="submit" name="Submit" value="Save" /></td>
			</tr>
		</table>
	</form>
</cfoutput>