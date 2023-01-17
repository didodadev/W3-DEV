<div id="list_salary_by_month">
    <script src="JS/Chart.min.js"></script>
    <cfset dashboard_cmp = createObject("component","V16.hr.cfc.hr_dashboard") />
    <cfparam name="attributes.active_year" default="#year(now())#">
    <cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS(
        company_id : session.ep.company_id
    )/>
    <cfset get_year_salary = dashboard_cmp.GET_YEAR_SALARY(
        active_year : attributes.active_year
    )/>
    <cfquery name="total_amounts" dbtype="query">
        SELECT
            SUM(MAAS) AS TOTAL_MAAS,
            SUM(ODENEK) AS TOTAL_ODENEK,
            SUM(KESINTI) AS TOTAL_KESINTI
        FROM
            get_year_salary
    </cfquery>
    <cf_box_elements>
    <div class="col col-4 col-xs-12">
        <div class="form-group" id="sel_active_year">
            <label class="col col-12"><cf_get_lang dictionary_id="57493.Aktif"><cf_get_lang dictionary_id="58455.Yıl"></label>
            <div class="col col-12">
                <select name="active_year" id="active_year" onChange="change_active_year();">
                    <cfoutput query="get_period_years">
                        <option value="#PERIOD_YEAR#" <cfif attributes.active_year eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
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
                    <th><cf_get_lang dictionary_id="29434.Şubeler"></th>
                    <th><cf_get_lang dictionary_id="39384.Maaş"></th>
                    <th><cf_get_lang dictionary_id="40073.Ödenek"></th>
                    <th><cf_get_lang dictionary_id="39992.Kesinti"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_year_salary.recordcount>
                    <cfoutput query="get_year_salary">
                        <tr>
                            <td>
                                <a href="#request.self#?fuseaction=hr.list_branches&event=upd&id=#BRANCH_ID#" target="_blank">#BRANCH_NAME#</a>
                            </td>
                            <td class="text-right">#TLFormat(MAAS)#</td>
                            <td class="text-right">#TLFormat(ODENEK)#</td>
                            <td class="text-right">#TLFormat(KESINTI)#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </div>
    <cfif get_year_salary.recordcount>
        <cfoutput query="get_year_salary">
            <cfset 'item_#currentrow#' = "#BRANCH_NAME#">
            <cfset 'value_maas_#currentrow#' = "#MAAS#">
            <cfset 'value_odenek_#currentrow#' = "#ODENEK#">
            <cfset 'value_kesinti_#currentrow#' = "#KESINTI#">
        </cfoutput>
        <canvas id="salary_amounts" style="height:100%;"></canvas>
        <script>
            var salary_amounts = document.getElementById('salary_amounts');
            var salary_amounts_pie = new Chart(salary_amounts, {
                type: 'line',
                data:   {
                            labels: [<cfloop from="1" to="#get_year_salary.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "<cf_get_lang dictionary_id="39384.Maaş">%",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_year_salary.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_year_salary.recordcount#" index="x"><cfoutput><cfif total_amounts.TOTAL_MAAS neq 0>"#wrk_round(evaluate("value_maas_#x#")*100/total_amounts.TOTAL_MAAS)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
                            },
                            {
                                label: "<cf_get_lang dictionary_id="40073.Ödenek">%",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_year_salary.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_year_salary.recordcount#" index="x"><cfoutput><cfif total_amounts.TOTAL_ODENEK neq 0>"#wrk_round(evaluate("value_odenek_#x#")*100/total_amounts.TOTAL_ODENEK)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
                            },
                            {
                                label: "<cf_get_lang dictionary_id="39992.Kesinti">%",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_year_salary.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_year_salary.recordcount#" index="x"><cfoutput><cfif total_amounts.TOTAL_KESINTI neq 0>"#wrk_round(evaluate("value_kesinti_#x#")*100/total_amounts.TOTAL_KESINTI)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
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
	function change_active_year()
	{
        active_year = $("#active_year").val();
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_dashboard_salary_group_by_branches&active_year='+active_year,'list_salary_by_month',1);
		return true;
	}
</script>