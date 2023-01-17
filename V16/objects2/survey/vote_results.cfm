<cfif not isdefined("attributes.chart_type")>
	<cfset attributes.chart_type = "pie">
</cfif>
<cfform method="post">
	<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
  		<tr class="color-list">
    		<td height="35">	 
				<table width="100%"> 
					<tr>
	  					<td class="headbold"><cf_get_lang no ='277.Anket Sonucu'></td>
      					<td width="75">
                            <select name="chart_type" id="chart_type" style="width:75px;">
                                <option value="area" <cfif attributes.chart_type is "area">selected</cfif>><cf_get_lang_main no='250.Alan'></option>
                                <option value="bar" <cfif attributes.chart_type is "bar">selected</cfif>><cf_get_lang_main no='251.Bar'></option>
                                <option value="cone" <cfif attributes.chart_type is "cone">selected</cfif>><cf_get_lang_main no='252.Koni'></option>
                                <option value="curve" <cfif attributes.chart_type is "curve">selected</cfif>><cf_get_lang_main no='253.Eğri'></option>
                                <option value="cylinder" <cfif attributes.chart_type is "cylinder">selected</cfif>><cf_get_lang_main no='254.Silindir'></option>
                                <option value="line" <cfif attributes.chart_type is "line">selected</cfif>><cf_get_lang_main no='255.Çizgi'></option>
                                <option value="pie" <cfif attributes.chart_type is "pie">selected</cfif>><cf_get_lang_main no='1316.Pasta'></option>
                                <option value="pyramid" <cfif attributes.chart_type is "pyramid">selected</cfif>><cf_get_lang_main no='257.Piramid'></option>
                                <option value="scatter" <cfif attributes.chart_type is "scatter">selected</cfif>><cf_get_lang_main no='258.Noktalama'></option>
                                <option value="step" <cfif attributes.chart_type is "step">selected</cfif>><cf_get_lang_main no='259.Basamak'></option>
                            </select>
						</td>
      					<td width="18"><cf_wrk_search_button></td>
					</tr>
				</table>
			</td>
  		</tr>  
		<tr>
			<td bgcolor="#FFFFFF">
				
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
</cfform>

