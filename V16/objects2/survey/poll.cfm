<cfinclude template="../query/get_survey.cfm">
<cfif isdefined("get_find_survey.recordcount") and get_find_survey.recordcount and len(get_find_survey.survey_id)>
	<cfset sonuc_goster = 1>
</cfif>
<cfif isdefined("get_survey") and get_survey.recordcount and not isdefined('sonuc_goster')>
	<table style="margin:5px;">
	<cfoutput query="get_survey">
	<cfform name="vote_survey" method="post" action="#request.self#?fuseaction=objects2.emptypopup_vote_survey">
		<input type="Hidden" name="survey_id" id="survey_id" value="#survey_id#">
		<tr> 
			<td class="headbold" colspan="2">#survey#</td>
		</tr>
		<cfloop query="get_survey_alts">
			<tr>
				<td width="15">
					<cfif get_survey.survey_type IS 2>
						<input type="Checkbox" name="answer" id="answer" value="#alt_id#">
				  	<cfelseif get_survey.survey_type IS 1>
						<input type="radio" name="answer" id="answer" value="#alt_id#">
				  	</cfif>
				</td>
				<td>#alt#</td>
			</tr>
		</cfloop>
		<tr>
			<td colspan="2">
				<cfif isdefined("get_find_survey.recordcount") and get_find_survey.recordcount>
					<img src="../image/arrow_org.gif" border="0" align="absmiddle">&nbsp; <font color="FF0000"><cf_get_lang no='221.Oy kullandınız'></font>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_vote_results&survey_id=#get_survey.survey_id#','small');" class="tableyazi"><cf_get_lang no='276.Sonuçları Göster'></a>
				<cfelse>
					<input type="image" src="../../images/hand.gif" border="0" alt="<cf_get_lang no='278.Oy Ver'>" title="<cf_get_lang no='278.Oy Ver'>" align="absmiddle"><cf_get_lang no='278.Oy Ver'>
				</cfif>
			</td>
		</tr>
	</cfform>
	</table>
	</cfoutput>	
</cfif>
<cfif isdefined("sonuc_goster") and sonuc_goster eq 1>
	<cfset attributes.survey_id = attributes.poll_id>
	<cfinclude template="../query/get_survey2.cfm">	
	<cfinclude template="../query/get_survey_alts.cfm">	
	<table width="100%">
		<tr>
			<td colspan="2" style="text-align:center"><font class="txtbold"><cfoutput>#get_survey.survey#</cfoutput></font><br/>
				<cf_get_lang no='106.Toplam'> : <cfoutput>#get_survey_votes_count.TOTAL_VOTE_COUNT#</cfoutput>
			</td>
		</tr>
        	<tr valign="top">
			<td>
				<cfoutput query="get_survey_votes_count">
                    <cfif len(alt) GT 30>
                        <cfset 'item_#currentrow#'="#Left(alt,30)#..." ><cfset 'value_#currentrow#'="#vote_count#">
                    <cfelse>
                        <cfset  'item_#currentrow#'="#alt#"> <cfset 'value_#currentrow#'="#vote_count#">
                    </cfif>
                    </cfoutput>
                     <script src="JS/Chart.min.js"></script>
                <canvas id="myChart" style="float:left;max-height:300px;max-width:300px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#attributes.chart_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_survey_votes_count.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "grafik yuzdesi",
									backgroundColor: [<cfloop from="1" to="#get_survey_votes_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_survey_votes_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>	
			</td>
		</tr>
	</table>
</cfif>
<cfset attributes.poll_id = "">
