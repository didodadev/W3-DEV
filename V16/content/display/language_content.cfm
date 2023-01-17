<cfset getComponent = createObject('component','V16.content.cfc.get_content_dashboard')>
<cfset GET_CONTENT_DASHBOARD = getComponent.GET_CONTENT_DASHBOARD(language:1)>
    <div class="col col-6">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58996.Dil'></th>
                    <th><cf_get_lang dictionary_id="57493.Aktif "><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                    <th><cf_get_lang dictionary_id="57494.Pasif"><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                </tr>
            </thead>
            <tbody>
                <cfif GET_CONTENT_DASHBOARD.recordcount>
                    <cfoutput query="GET_CONTENT_DASHBOARD">
                        <tr>
                            <td>#language_set#</td>
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
            <cfif GET_CONTENT_DASHBOARD.recordcount>
                <cfquery name="sum_writer_count" dbtype="query">
                    SELECT
                        SUM(ACTIVE_TOTAL) AS TOTAL_RECORD_
                    FROM
                    GET_CONTENT_DASHBOARD
                </cfquery>
                <cfoutput query="GET_CONTENT_DASHBOARD">
                    <cfset 'item_#currentrow#' = "#language_set#">
                    <cfset 'value_#currentrow#' = "#ACTIVE_TOTAL#">
                </cfoutput>
                <canvas id="active_language" style="height:100%;"></canvas>
                <script>
                    var active_language = document.getElementById('active_language');
                    var active_language_pie = new Chart(active_language, {
                        type: 'pie',
                        data: {
                                labels: [<cfloop from="1" to="#GET_CONTENT_DASHBOARD.recordcount#" index="i">
                                    <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "<cf_get_lang dictionary_id="62547.Dile Göre Aktif ve Pasif İçerik Sayıları">%",
                                    backgroundColor: [<cfloop from="1" to="#GET_CONTENT_DASHBOARD.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#GET_CONTENT_DASHBOARD.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_writer_count.TOTAL_RECORD_)#"</cfoutput>,</cfloop>],
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
            <cfif GET_CONTENT_DASHBOARD.recordcount>
                <cfquery name="sum_writer_count" dbtype="query">
                    SELECT
                        SUM(PASSIVE_TOTAL) AS TOTAL_RECORD_PASSIVE
                    FROM
                    GET_CONTENT_DASHBOARD
                </cfquery>
                <cfoutput query="GET_CONTENT_DASHBOARD">
                    <cfset 'item_#currentrow#' = "#language_set#">
                    <cfset 'value_#currentrow#' = "#PASSIVE_TOTAL#">
                </cfoutput>
                <canvas id="passive_languagee" style="height:100%;"></canvas>
                <script>
                    var passive_languagee = document.getElementById('passive_languagee');
                    var passive_languagee_pie = new Chart(passive_languagee, {
                        type: 'pie',
                        data: {
                                labels: [<cfloop from="1" to="#GET_CONTENT_DASHBOARD.recordcount#" index="i">
                                    <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "<cf_get_lang dictionary_id="62547.Dile Göre Aktif ve Pasif İçerik Sayıları">%",
                                    backgroundColor: [<cfloop from="1" to="#GET_CONTENT_DASHBOARD.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#GET_CONTENT_DASHBOARD.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_writer_count.TOTAL_RECORD_PASSIVE)#"</cfoutput>,</cfloop>],
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