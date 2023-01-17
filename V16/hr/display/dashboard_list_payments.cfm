<div id="dashboard_list_use_offtime">
    <script src="JS/Chart.min.js"></script>
    <cfset dashboard_cmp = createObject("component","V16.hr.cfc.hr_dashboard") />
    <cfparam name="attributes.active_year_payments" default="#year(now())#">
    <cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS(
        company_id : session.ep.company_id
    )/>
    <cfset get_payments = dashboard_cmp.GET_PAYMENTS(
        active_year : attributes.active_year_payments
    )/>
    <cfquery name="get_total_odenek" dbtype="query">
        SELECT
            SUM(ODENEK) AS TOTAL_ODENEK
        FROM
            get_payments
    </cfquery>
<cf_box_elements>
    <div class="col col-4 col-xs-12">
        <div class="form-group" id="sel_active_year">
            <label class="col col-12"><cf_get_lang dictionary_id="57493.Aktif"><cf_get_lang dictionary_id="58455.Yıl"></label>
            <div class="col col-12">
                <select name="active_year_payments" id="active_year_payments" onChange="change_active_year_payments();">
                    <cfoutput query="get_period_years">
                        <option value="#PERIOD_YEAR#" <cfif attributes.active_year_payments eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
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
                    <th><cf_get_lang dictionary_id="38970.Ödenek Türü"></th>
                    <th><cf_get_lang dictionary_id="29534.Toplam Tutar"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_payments.recordcount>
                    <cfoutput query="get_payments">
                        <tr>
                            <td>#COMMENT_PAY#</td>
                            <td>#TLFormat(ODENEK)#</td>
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
    <cfif get_payments.recordcount>
        <cfoutput query="get_payments">
            <cfset 'item_#currentrow#' = "#COMMENT_PAY#">
            <cfset 'value_#currentrow#' = "#ODENEK#">
        </cfoutput>
        <canvas id="list_payments_graph" style="height:100%;"></canvas>
        <script>
            var list_payments_graph = document.getElementById('list_payments_graph');
            var list_payments_graph_pie = new Chart(list_payments_graph, {
                type: 'bar',
                data:   {
                            labels: [<cfloop from="1" to="#get_payments.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "<cf_get_lang dictionary_id="38970.Ödenek Türü">%",
                                backgroundColor: [<cfloop from="1" to="#get_payments.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_payments.recordcount#" index="x"><cfoutput><cfif get_total_odenek.TOTAL_ODENEK neq 0>"#wrk_round(evaluate("value_#x#")*100/get_total_odenek.TOTAL_ODENEK)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
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
	function change_active_year_payments()
	{
        active_year_payments = $("#active_year_payments").val();
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_dashboard_list_payments&active_year_payments='+active_year_payments,'dashboard_list_use_offtime',1);
		return true;
	}
</script>