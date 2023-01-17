<cfparam name="attributes.demand_show_ids" default="">
<cfparam name="attributes.demand_hide_ids" default="">
<cfset dashboard_cmp = createObject("component","V16.purchase.cfc.purchase_dashboard") />
<cfset get_active_demands = dashboard_cmp.GET_ACTIVE_DEMANDS(
    demand_show_ids : iIf(len(attributes.demand_show_ids),"attributes.demand_show_ids",DE("")),
    demand_hide_ids : iIf(len(attributes.demand_hide_ids),"attributes.demand_hide_ids",DE(""))
)/>

<div class="col col-12">
    <cf_grid_list sort="1">
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="57482.Aşama"></th>
                <th><cf_get_lang dictionary_id="58829.Kayıt Sayısı"></th>
                <th><cf_get_lang dictionary_id="29534.Toplam Tutar"></th>
                <th><cf_get_lang dictionary_id="34434.Para Br"></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_active_demands.recordcount>
                <cfoutput query="get_active_demands">
                    <tr>
                        <td>
                            <a href="#request.self#?fuseaction=purchase.list_purchasedemand&is_submit=1&internaldemand_stage=#INTERNALDEMAND_STAGE#" target="_blank"><cf_workcube_process type="color-status" process_stage="#INTERNALDEMAND_STAGE#" fuseaction="purchase.list_purchasedemand"></a>
                        </td>
                        <td style="text-align:right;">#COUNT_RECORD#</td>
                        <td style="text-align:right;">#TLFormat(SUM_RECORD)#</td>
                        <td>#session.ep.money#</td>
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
<div class="col col-12">
    <div class="col-8" style="margin-left:auto;margin-right:auto;">
        <cfif get_active_demands.recordcount>
            <cfquery name="sum_demands_count" dbtype="query">
                SELECT
                    SUM(COUNT_RECORD) AS TOTAL_RECORD 
                FROM
                    get_active_demands
            </cfquery>
            <cfoutput query="get_active_demands">
                <cfset 'item_#currentrow#' = "#STAGE#">
                <cfset 'value_#currentrow#' = "#COUNT_RECORD#">
            </cfoutput>
            <canvas id="active_demands" style="height:100%;"></canvas>
            <script>
                var active_demands = document.getElementById('active_demands');
                var active_demands_pie = new Chart(active_demands, {
                    type: 'pie',
                    data: {
                            labels: [<cfloop from="1" to="#get_active_demands.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "<cf_get_lang dictionary_id='60885.Aktif Satınalma Talepleri'>%",
                                backgroundColor: [<cfloop from="1" to="#get_active_demands.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_active_demands.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_demands_count.TOTAL_RECORD)#"</cfoutput>,</cfloop>],
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
</div>