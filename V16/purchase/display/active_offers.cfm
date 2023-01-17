<cfparam name="attributes.offer_show_ids" default="">
<cfparam name="attributes.offer_hide_ids" default="">
<cfset dashboard_cmp = createObject("component","V16.purchase.cfc.purchase_dashboard") />
<cfset get_active_offers = dashboard_cmp.GET_ACTIVE_OFFERS(
    offer_show_ids : iIf(len(attributes.offer_show_ids),"attributes.offer_show_ids",DE("")),
    offer_hide_ids : iIf(len(attributes.offer_hide_ids),"attributes.offer_hide_ids",DE(""))
)/>
<div class="col col-12">
    <cf_grid_list sort="1">
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="57482.Aşama"></th>
                <th><cf_get_lang dictionary_id="61199.Ana Teklif Sayısı"></th>
                <th><cf_get_lang dictionary_id="61200.Alt Teklif Sayısı"></th>
                <th><cf_get_lang dictionary_id="29534.Toplam Tutar"></th>
                <th><cf_get_lang dictionary_id="34434.Para Br"></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_active_offers.recordcount>
                <cfoutput query="get_active_offers">
                    <tr>
                        <td>
                            <a href="#request.self#?fuseaction=purchase.list_offer&is_form_submit=1&assc_offers=2&offer_stage=#OFFER_STAGE#" target="_blank"><cf_workcube_process type="color-status" process_stage="#OFFER_STAGE#" fuseaction="purchase.list_offer"></a>
                        </td>
                        <td style="text-align:right;">#COUNT_RECORD#</td>
                        <td style="text-align:right;">#COUNT_ALT_RECORD#</td>
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
        <cfif get_active_offers.recordcount>
            <cfquery name="sum_offers_count" dbtype="query">
                SELECT
                    SUM(COUNT_RECORD) AS TOTAL_RECORD 
                FROM
                    get_active_offers
            </cfquery>
            <cfoutput query="get_active_offers">
                <cfset 'item_#currentrow#' = "#STAGE#">
                <cfset 'value_#currentrow#' = "#COUNT_RECORD#">
            </cfoutput>
            <canvas id="active_offers" style="height:100%;"></canvas>
            <script>
                var active_offers = document.getElementById('active_offers');
                var active_offers_pie = new Chart(active_offers, {
                    type: 'pie',
                    data: {
                            labels: [<cfloop from="1" to="#get_active_offers.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "<cf_get_lang dictionary_id='60883.Aktif Satınalma Teklifleri'>%",
                                backgroundColor: [<cfloop from="1" to="#get_active_offers.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_active_offers.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_offers_count.TOTAL_RECORD)#"</cfoutput>,</cfloop>],
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