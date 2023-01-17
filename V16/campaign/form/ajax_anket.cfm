<cfinclude template="../query/get_survey_alts.cfm">
<cfparam name="attributes.chart_type" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform method="post" action="#request.self#?fuseaction=campaign.form_vote_survey&survey_id=#attributes.survey_id#">
        <cf_box_search>
            <div class="form-group large">
                <select name="chart_type" id="chart_type">
                    <option value="polarArea" <cfif attributes.chart_type is "area">selected</cfif>><cf_get_lang dictionary_id='57662.Alan'></option>
                    <option value="bar" <cfif attributes.chart_type is "bar">selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                    <option value="line" <cfif attributes.chart_type is "line">selected</cfif>><cf_get_lang dictionary_id='57667.Çizgi'></option>
                    <option value="pie" <cfif attributes.chart_type is "pie">selected</cfif>><cf_get_lang dictionary_id='57668.Pay'></option>
                </select>
            </div>
            <div class="form-group">
                <cf_wrk_search_button is_excel = '0' button_type="4" search_function="ajax_function()">
            </div>
        </cf_box_search>
        <cf_ajax_list> 
            <tbody>
                <tr>
                    <td>
                        <cfif get_survey_alts.recordcount>
                            <cfoutput query="get_survey_alts">
                                <cfif len(alt) GT 35>
                                    <cfset 'item_#currentrow#'="#Left(alt,35)#...">
                                    <cfset 'value_#currentrow#'="#vote_count#">
                                <cfelse>
                                    <cfset 'item_#currentrow#'="#alt#">
                                    <cfset 'value_#currentrow#'="#vote_count#">
                                </cfif>
                            </cfoutput>
                                <script src="JS/Chart.min.js"></script>
                                <canvas id="myChart1" style="float:left;max-height:450px;max-width:450px;"></canvas>
                                <script>
                                    var ctx = document.getElementById('myChart1');
                                    var myChart1 = new Chart(ctx, {
                                        type: '<cfoutput>#attributes.chart_type#</cfoutput>',
                                        data: {
                                                labels: [<cfloop from="1" to="#get_survey_alts.recordcount#" index="jj">
                                                    <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                datasets: [{
                                                label: "Anket",
                                                backgroundColor: [<cfloop from="1" to="#get_survey_alts.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                data: [<cfloop from="1" to="#get_survey_alts.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                    }]
                                                },
                                        options: {}
                                    });
                                </script>
                        
                        </cfif>
                    </td>
                </tr>
            </tbody>
        </cf_ajax_list>
    </cfform>
</div>
<script>
    function ajax_function()
	{
        var x = $('#chart_type').val();
	 <cfoutput>
        <cfif attributes.chart_type eq 0>
			var url_str = "#request.self#?fuseaction=campaign.popup_ajax_anket&survey_id=#attributes.survey_id#&iframe=1";
        <cfelse>
			var url_str = "#request.self#?fuseaction=campaign.popup_ajax_anket&survey_id=#attributes.survey_id#&chart_type=" + x;
        </cfif>
		AjaxPageLoad(url_str,'yeni',1,'Yükleniyor');
	</cfoutput>
	}
</script>