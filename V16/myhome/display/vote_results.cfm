<cfinclude template="../query/get_survey2.cfm">	
<cfinclude template="../query/get_survey_alts.cfm">	
<cfif not isdefined("attributes.chart_type")>
  <cfset attributes.chart_type = "pie">
</cfif>
<cfsavecontent variable="txt">
    <cfform method="post">
        <select name="chart_type" id="chart_type" style="width:75px;">
            
            <option value="bar" <cfif attributes.chart_type is "bar">selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
            <option value="polarArea" <cfif attributes.chart_type is "polarArea">selected</cfif>><cf_get_lang dictionary_id='57664.Koni'></option>
            <option value="curve" <cfif attributes.chart_type is "curve">selected</cfif>><cf_get_lang dictionary_id='57665.Eğri'></option>
            <option value="cylinder" <cfif attributes.chart_type is "cylinder">selected</cfif>><cf_get_lang dictionary_id='57666.Silindir'></option>
            <option value="line" <cfif attributes.chart_type is "line">selected</cfif>><cf_get_lang dictionary_id='57667.Çizgi'></option>
            <option value="pie" <cfif attributes.chart_type is "pie">selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
            <option value="pyramid" <cfif attributes.chart_type is "pyramid">selected</cfif>><cf_get_lang dictionary_id='30908.Piramid'></option>
            <option value="scatter" <cfif attributes.chart_type is "scatter">selected</cfif>><cf_get_lang dictionary_id='30957.Noktalama'></option>
            <option value="step" <cfif attributes.chart_type is "step">selected</cfif>><cf_get_lang dictionary_id='57671.Basamak'></option>
        </select>
        <cf_wrk_search_button is_excel='0'>
    </cfform>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31048.Anket Sonucu'></cfsavecontent>
<cf_popup_box title="#message#" right_images="#txt#">
    <table align="center" width="100%">
        <tr>
			<cfset my_height = ((GET_SURVEY_VOTES_COUNT.recordcount*20)+100)>
            <td bgcolor="#FFFFFF">
            
                <cfoutput query="get_survey_votes_count">
                    <cfif len(alt) GT 30>
                        <cfset 'item_#currentrow#'="#Left(alt,30)#..." ><cfset 'value_#currentrow#'="#vote_count#">
                    <cfelse>
                        <cfset  'item_#currentrow#'="#alt#"> <cfset 'value_#currentrow#'="#vote_count#">
                    </cfif>
                    </cfoutput>
                     <script src="JS/Chart.min.js"></script>
                <canvas id="myChartvoteresult" style="float:left;max-height:300px;max-width:300px;"></canvas>
				<script>
					var ctx = document.getElementById('myChartvoteresult');
						var myChartvoteresult = new Chart(ctx, {
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
</cf_popup_box>


