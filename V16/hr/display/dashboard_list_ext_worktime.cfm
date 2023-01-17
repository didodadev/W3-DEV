<div id="dashboard_list_use_offtime">
    <script src="JS/Chart.min.js"></script>
    <cfset dashboard_cmp = createObject("component","V16.hr.cfc.hr_dashboard") />
    <cfparam name="attributes.active_year_ext_worktime" default="#year(now())#">
    <cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS(
        company_id : session.ep.company_id
    )/>
    <cfset get_ext_worktime = dashboard_cmp.GET_EXT_WORKTIME(
        active_year : attributes.active_year_ext_worktime
    )/>
    <cfquery name="total_ext_worktime_min" dbtype="query">
        SELECT
            SUM(TOTAL_MINUTE) AS TOTAL_MINUTE
        FROM
            get_ext_worktime
    </cfquery>
<cf_box_elements>
    <div class="col col-4 col-xs-12">
        <div class="form-group" id="sel_active_year">
            <label class="col col-12"><cf_get_lang dictionary_id="57493.Aktif"><cf_get_lang dictionary_id="58455.Yıl"></label>
            <div class="col col-12">
                <select name="active_year_ext_worktime" id="active_year_ext_worktime" onChange="change_active_year_ext_worktime();">
                    <cfoutput query="get_period_years">
                        <option value="#PERIOD_YEAR#" <cfif attributes.active_year_ext_worktime eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
    </div>
</cf_box_elements>
    <div class="col col-12">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="57630.Tip"></th>
                    <th><cf_get_lang dictionary_id="46028.Toplam Süre"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_ext_worktime.recordcount>
                    <cfoutput query="get_ext_worktime">
                        <tr>
                            <td>
                                <cfif DAY_TYPE eq 0>
                                    <cf_get_lang Dictionary_id='53727.Çalışma Günü'>
                                <cfelseif DAY_TYPE eq 1>
                                    <cf_get_lang Dictionary_id='58867.Hafta Tatili'>
                                <cfelseif DAY_TYPE eq 2>
                                    <cf_get_lang Dictionary_id='31473.Resmi Tatil'>
                                <cfelseif DAY_TYPE eq 3>
                                    <cf_get_lang Dictionary_id='54251.Gece Çalışması'>
                                </cfif>
                            </td>
                            <td>
                                <cfset toplam_dk = TOTAL_MINUTE>
                                <cfset saat = int(toplam_dk / 60)>
                                #saat# <cf_get_lang dictionary_id="57491.saat">
                                <cfif saat * 60 lt toplam_dk>
                                    <cfset dakika = toplam_dk - (saat * 60)>
                                    #dakika# <cf_get_lang dictionary_id="58827.dk">
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="2"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </div>
    <cfif get_ext_worktime.recordcount>
        <cfoutput query="get_ext_worktime">
            <cfsavecontent variable="item_text">
                <cfif DAY_TYPE eq 0>
                    <cf_get_lang Dictionary_id='53727.Çalışma Günü'>
                <cfelseif DAY_TYPE eq 1>
                    <cf_get_lang Dictionary_id='58867.Hafta Tatili'>
                <cfelseif DAY_TYPE eq 2>
                    <cf_get_lang Dictionary_id='31473.Resmi Tatil'>
                <cfelseif DAY_TYPE eq 3>
                    <cf_get_lang Dictionary_id='54251.Gece Çalışması'>
                </cfif>
            </cfsavecontent>
            <cfset 'item_#currentrow#' = "#item_text#">
            <cfset 'value_#currentrow#' = "#TOTAL_MINUTE#">
        </cfoutput>
        <canvas id="ext_worktime_graph" style="max-height:250px;max-width:250px;margin-right:auto;margin-left:auto;"></canvas>
        <script>
            var ext_worktime_graph = document.getElementById('ext_worktime_graph');
            var ext_worktime_graph_pie = new Chart(ext_worktime_graph, {
                type: 'pie',
                data:   {
                            labels: [<cfloop from="1" to="#get_ext_worktime.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "<cf_get_lang dictionary_id="52970.Fazla Mesailer">%",
                                backgroundColor: [<cfloop from="1" to="#get_ext_worktime.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_ext_worktime.recordcount#" index="x"><cfoutput><cfif total_ext_worktime_min.TOTAL_MINUTE neq 0>"#wrk_round(evaluate("value_#x#")*100/total_ext_worktime_min.TOTAL_MINUTE)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
                            }]
                        },
                options: {
                    legend: {
                        display: false
                    }
                }
            });
        </script>
    </cfif>
</div>
<script type="text/javascript">
	function change_active_year_ext_worktime()
	{
        active_year_ext_worktime = $("#active_year_ext_worktime").val();
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_dashboard_list_ext_worktime&active_year_ext_worktime='+active_year_ext_worktime,'dashboard_list_use_offtime',1);
		return true;
	}
</script>