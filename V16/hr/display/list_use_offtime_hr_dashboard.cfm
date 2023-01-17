<div id="dashboard_list_use_offtime">
    <script src="JS/Chart.min.js"></script>
    <cfset dashboard_cmp = createObject("component","V16.hr.cfc.hr_dashboard") />
    <cfparam name="attributes.active_year_offtime" default="#year(now())#">
    <cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS(
        company_id : session.ep.company_id
    )/>
    <cfset get_use_offime = dashboard_cmp.GET_USE_OFFTIME(
        active_year : attributes.active_year_offtime
    )/>
    <cfquery name="total_count_offtime" dbtype="query">
        SELECT
            SUM(COUNT_OFFTIME) AS TOTAL_COUNT
        FROM
            get_use_offime
    </cfquery>
<cf_box_elements>
    <div class="col col-4 col-xs-12">
        <div class="form-group" id="sel_active_year">
            <label class="col col-12"><cf_get_lang dictionary_id="57493.Aktif"><cf_get_lang dictionary_id="58455.Yıl"></label>
            <div class="col col-12">
                <select name="active_year_offtime" id="active_year_offtime" onChange="change_active_year_offtime();">
                    <cfoutput query="get_period_years">
                        <option value="#PERIOD_YEAR#" <cfif attributes.active_year_offtime eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
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
                    <th><cf_get_lang dictionary_id="57486.Kategori"></th>
                    <th><cf_get_lang dictionary_id="31405.Kullanılan izin"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_use_offime.recordcount>
                    <cfoutput query="get_use_offime">
                        <tr>
                            <td>#OFFTIMECAT#</td>
                            <td>#COUNT_OFFTIME#</td>
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
    <cfif get_use_offime.recordcount>
        <cfoutput query="get_use_offime">
            <cfset 'item_#currentrow#' = "#OFFTIMECAT#">
            <cfset 'value_#currentrow#' = "#COUNT_OFFTIME#">
        </cfoutput>
        <canvas id="count_offtime_graph" style="max-height:250px;max-width:250px;margin-right:auto;margin-left:auto;"></canvas>
        <script>
            var count_offtime_graph = document.getElementById('count_offtime_graph');
            var count_offtime_graph_pie = new Chart(count_offtime_graph, {
                type: 'pie',
                data:   {
                            labels: [<cfloop from="1" to="#get_use_offime.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "<cf_get_lang dictionary_id="31405.Kullanılan izin">%",
                                backgroundColor: [<cfloop from="1" to="#get_use_offime.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_use_offime.recordcount#" index="x"><cfoutput><cfif total_count_offtime.TOTAL_COUNT neq 0>"#wrk_round(evaluate("value_#x#")*100/total_count_offtime.TOTAL_COUNT)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
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
	function change_active_year_offtime()
	{
        active_year_offtime = $("#active_year_offtime").val();
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_dashboard_list_use_offtime&active_year_offtime='+active_year_offtime,'dashboard_list_use_offtime',1);
		return true;
	}
</script>