<cf_xml_page_edit fuseact="purchase.purchase_dashboard">
<cfset dashboard_cmp = createObject("component","V16.purchase.cfc.purchase_dashboard") />
<cfset get_top_suppliers = dashboard_cmp.GET_TOP_SUPPLIERS(
    order_show_ids : iIf(len(x_order_show_ids),"x_order_show_ids",DE("")),
    order_hide_ids : iIf(len(x_order_hide_ids),"x_order_hide_ids",DE(""))
)/>
<cfset get_nettotal_orders = dashboard_cmp.GET_NETTOTAL_ORDERS(
    order_show_ids : iIf(len(x_order_show_ids),"x_order_show_ids",DE("")),
    order_hide_ids : iIf(len(x_order_hide_ids),"x_order_hide_ids",DE(""))
)/>
<cfquery name="sum_total_get_top_suppliers" dbtype="query">
    SELECT SUM(NETTOTAL) AS NETTOTAL FROM get_top_suppliers
</cfquery>
<div class="col col-12">
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="29533.Tedarikçi"></th>
                <th><cf_get_lang dictionary_id="29534.Toplam Tutar"></th>
                <th><cf_get_lang dictionary_id="34434.Para Br"></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_top_suppliers.recordcount>
                <cfoutput query="get_top_suppliers">
                    <tr>
                        <td>
                            <cfif len(company_id)>
                                #get_par_info(company_id,1,1,0)#
                            <cfelseif len(consumer_id)>
                                #get_cons_info(consumer_id,2,0)#>
                            </cfif>
                        </td>
                        <td style="text-align:right;">#TLFormat(NETTOTAL)#</td>
                        <td>#session.ep.money#</td>
                    </tr>
                </cfoutput>
                <cfoutput>
                    <tr>
                        <td><cf_get_lang dictionary_id="58156.Diğer"></td>
                        <td style="text-align:right;">#TLFormat(get_nettotal_orders.NETTOTAL - sum_total_get_top_suppliers.NETTOTAL)#</td>
                        <td>#session.ep.money#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <td colspan="3"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
            </cfif>
        </tbody>
    </cf_grid_list>
</div>
<div class="col col-12">
    <div class="col-8" style="margin-left:auto;margin-right:auto;">
        <cfsavecontent variable="diger"><cf_get_lang dictionary_id="58156.Diğer"></cfsavecontent>
        <cfif get_top_suppliers.recordcount>
        <cfoutput>
            <cfset 'item_0' = "#diger#">
            <cfset 'value_0' = "#get_nettotal_orders.NETTOTAL - sum_total_get_top_suppliers.NETTOTAL#">
        </cfoutput>
        <cfoutput query="get_top_suppliers">
            <cfset 'item_#currentrow#' = "#iif(len(company_id),'get_par_info(company_id,1,1,0)','get_cons_info(consumer_id,2,0)')#">
            <cfset 'value_#currentrow#' = "#NETTOTAL#">
        </cfoutput>
        <canvas id="top_suppliers" style="height:100%;"></canvas>
        <script>
            var top_suppliers = document.getElementById('top_suppliers');
            var top_suppliers_pie = new Chart(top_suppliers, {
                type: 'pie',
                data: {
                        labels: [<cfloop from="0" to="#get_top_suppliers.recordcount#" index="i">
                            <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                        datasets: [{
                            label: "<cf_get_lang dictionary_id='60884.Aktif Satınalma Siparişleri'>%",
                            backgroundColor: [<cfloop from="0" to="#get_top_suppliers.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                            data: [<cfloop from="0" to="#get_top_suppliers.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/get_nettotal_orders.NETTOTAL)#"</cfoutput>,</cfloop>],
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