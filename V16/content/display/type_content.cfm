

<cfset getComponent = createObject('component','V16.content.cfc.get_content_dashboard')>
<cfset GET_CONTENT_ = getComponent.GET_CONTENT_DASHBOARD(type:1)>
    <div class="col col-6">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57630.Tip'></th>
                    <th><cf_get_lang dictionary_id="57493.Aktif "><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                    <th><cf_get_lang dictionary_id="57494.Pasif"><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                </tr>
            </thead>
            <tbody>
                <cfif GET_CONTENT_.recordcount>
                    <cfoutput query="GET_CONTENT_">
                        <tr>
                        <td>#NAME#</td>
                        <td style="text-align:right;">#ACTIVE_TOTAL#</td>
                        <td style="text-align:right;">#PASSIVE_TOTAL#</td>
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
    <div class="col col-3">
        <div class="col-12" style="margin-left:auto;margin-right:auto;">
            <center><p class="phead"><cf_get_lang dictionary_id ='57493.aktif'><cf_get_lang dictionary_id ='57653.içerik'></p></center>
            <cfif get_content_.recordcount>
                <cfquery name="sum_orders_count" dbtype="query">
                    SELECT
                        SUM(ACTIVE_TOTAL) AS TOTAL_RECORD_ 
                    FROM
                        get_content_
                </cfquery>
                <cfoutput query="get_content_">
                    <cfset 'item_#currentrow#' = "#NAME#">
                    <cfset 'value_#currentrow#' = "#ACTIVE_TOTAL#">
                </cfoutput>
                <canvas id="active_type" style="height:100%;"></canvas>
                <script>
                    var active_type = document.getElementById('active_type');
                    var active_type_pie = new Chart(active_type, {
                        type: 'pie',
                        data: {
                                labels: [<cfloop from="1" to="#get_content_.recordcount#" index="i">
                                    <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "<cf_get_lang dictionary_id="62545.Tiplerine Göre Aktif ve Pasif İçerik Sayıları">%",
                                    backgroundColor: [<cfloop from="1" to="#get_content_.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_content_.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_orders_count.TOTAL_RECORD_)#"</cfoutput>,</cfloop>],
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
    <div class="col col-3">
        <div class="col-12" style="margin-left:auto;margin-right:auto;">
            <center><p class="phead" class="center"><cf_get_lang dictionary_id ='57494.Pasif'><cf_get_lang dictionary_id ='57653.içerik'></p></center>
            <cfif get_content_.recordcount>
                <cfquery name="sum_orders_count" dbtype="query">
                    SELECT
                        SUM(PASSIVE_TOTAL) AS TOTAL_RECORD_
                    FROM
                        get_content_
                </cfquery>
                <cfoutput query="get_content_">
                    <cfset 'item_#currentrow#' = "#NAME#">
                    <cfset 'value_#currentrow#' = "#PASSIVE_TOTAL#">
                </cfoutput>
                <canvas id="passive_type" style="height:100%;"></canvas>
                <script>
                    var passive_type = document.getElementById('passive_type');
                    var passive_type_pie = new Chart(passive_type, {
                        type: 'pie',
                        data: {
                                labels: [<cfloop from="1" to="#get_content_.recordcount#" index="i">
                                    <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "<cf_get_lang dictionary_id="62545.Tiplerine Göre Aktif ve Pasif İçerik Sayıları"></cf_get_lang>%",
                                    backgroundColor: [<cfloop from="1" to="#get_content_.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_content_.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_orders_count.TOTAL_RECORD_)#"</cfoutput>,</cfloop>],
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