<cfparam name="attributes.order_show_ids" default="">
<cfparam name="attributes.order_hide_ids" default="">
<cfset dashboard_cmp = createObject("component","V16.purchase.cfc.purchase_dashboard") />
<cfset get_active_orders = dashboard_cmp.GET_ACTIVE_ORDERS(
    order_show_ids : iIf(len(attributes.order_show_ids),"attributes.order_show_ids",DE("")),
    order_hide_ids : iIf(len(attributes.order_hide_ids),"attributes.order_hide_ids",DE(""))
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
            <cfif get_active_orders.recordcount>
                <cfoutput query="get_active_orders">
                    <tr>
                        <td>
                            <a href="#request.self#?fuseaction=purchase.list_order&form_varmi=1&order_stage=#ORDER_STAGE#" target="_blank"><cf_workcube_process type="color-status" process_stage="#ORDER_STAGE#" fuseaction="purchase.list_order"></a>
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
        <cfif get_active_orders.recordcount>
            <cfquery name="sum_orders_count" dbtype="query">
                SELECT
                    SUM(COUNT_RECORD) AS TOTAL_RECORD 
                FROM
                    get_active_orders
            </cfquery>
            <cfoutput query="get_active_orders">
                <cfset 'item_#currentrow#' = "#STAGE#">
                <cfset 'value_#currentrow#' = "#COUNT_RECORD#">
            </cfoutput>
            <canvas id="active_orders" style="height:100%;"></canvas>
            <script>
                var active_orders = document.getElementById('active_orders');
                var active_orders_pie = new Chart(active_orders, {
                    type: 'pie',
                    data: {
                            labels: [<cfloop from="1" to="#get_active_orders.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "<cf_get_lang dictionary_id='60884.Aktif Satınalma Siparişleri'>%",
                                backgroundColor: [<cfloop from="1" to="#get_active_orders.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_active_orders.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_orders_count.TOTAL_RECORD)#"</cfoutput>,</cfloop>],
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