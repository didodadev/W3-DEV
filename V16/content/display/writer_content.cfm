
<cfset getComponent = createObject('component','V16.content.cfc.get_content_dashboard')>
<cfset GET_CONTENT_WRITER = getComponent.GET_CONTENT_DASHBOARD(writer:1)>
    <div class="col col-6">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='50545.Yazar'></th>
                    <th><cf_get_lang dictionary_id="57493.Aktif "><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                    <th><cf_get_lang dictionary_id="57494.Pasif"><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                </tr>
            </thead>
            <tbody>
                <cfif GET_CONTENT_WRITER.recordcount>
                    <cfoutput query="GET_CONTENT_WRITER">
                        <tr>
                            <td>
                                <cfif len(outhor_emp_id)>
                                    #get_emp_info(outhor_emp_id,0,0)#
                                <cfelseif len(outhor_cons_id)>
                                    #get_cons_info(outhor_cons_id,0,0)#
                                    <cfelseif len(outhor_par_id) or len(OUTHOR_COMPANY_PAR_ID)>
                                        #get_par_info(OUTHOR_COMPANY_PAR_ID,0,1,0)#- #get_par_info(outhor_par_id,0,-1,0)#
                                <cfelse>
                                    <cf_get_lang dictionary_id="58156.Diğer">
                                </cfif>
                            </td>
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
                <cfsavecontent variable="diger"><cf_get_lang dictionary_id="58156.Diğer"></cfsavecontent>
                    
                <cfif GET_CONTENT_WRITER.recordcount>
                <cfquery name="sum_writer_count" dbtype="query">
                    SELECT
                        SUM(ACTIVE_TOTAL) AS TOTAL_RECORD__ 
                    FROM
                    GET_CONTENT_WRITER
                </cfquery>
                <cfoutput query="GET_CONTENT_WRITER">
                    <cfif len (outhor_emp_id) >
                        <cfset 'item_#currentrow#' = "#get_emp_info(outhor_emp_id,0,0)#">  
                    <cfelseif len(outhor_cons_id)>
                        <cfset 'item_#currentrow#' = "#get_cons_info(outhor_cons_id,0,0)#">  
                    <cfelseif len(outhor_par_id) or len(OUTHOR_COMPANY_PAR_ID)>
                        <cfset 'item_#currentrow#' = "#get_par_info(OUTHOR_COMPANY_PAR_ID,0,1,0)##get_par_info(outhor_par_id,0,-1,0)#">   
                    <cfelse>
                        <cfset 'item_#currentrow#' = "#diger#">
                    </cfif>
                    <cfset 'value_#currentrow#' = "#ACTIVE_TOTAL#">
                </cfoutput>
                <canvas id="active_writer" style="height:100%;"></canvas>
                <script>
                    var active_writer = document.getElementById('active_writer');
                    var active_writer_pie = new Chart(active_writer, {
                        type: 'pie',
                        data: {
                        
                                labels: [<cfloop from="1" to="#GET_CONTENT_WRITER.recordcount#" index="i">
                                    <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                
                                datasets: [{
                                    label: "<cf_get_lang dictionary_id="62546.Yazarlara Göre Aktif ve Pasif İçerik Sayıları">%",
                                    backgroundColor: [<cfloop from="1" to="#GET_CONTENT_WRITER.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#GET_CONTENT_WRITER.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_writer_count.TOTAL_RECORD__)#"</cfoutput>,</cfloop>],
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
            <cfif get_content_WRITER.recordcount>
                <cfquery name="sum_writer_count" dbtype="query">
                    SELECT
                        SUM(PASSIVE_TOTAL) AS TOTAL_RECORD
                    FROM
                        get_content_WRITER
                </cfquery>
                <cfoutput query="get_content_WRITER">
                    <cfif len (outhor_emp_id) >
                        <cfset 'item_#currentrow#' = "#get_emp_info(outhor_emp_id,0,0)#">  
                    <cfelseif len(outhor_cons_id)>
                        <cfset 'item_#currentrow#' = "#get_cons_info(outhor_cons_id,0,0)#">  
                    <cfelseif len(outhor_par_id) or len(OUTHOR_COMPANY_PAR_ID)>
                        <cfset 'item_#currentrow#' = "#get_par_info(OUTHOR_COMPANY_PAR_ID,0,1,0)##get_par_info(outhor_par_id,0,-1,0)#">   
                    <cfelse>
                        <cfset 'item_#currentrow#' = "#diger#">
                    </cfif>
                    <cfset 'value_#currentrow#' = "#PASSIVE_TOTAL#">
                </cfoutput>
                <canvas id="passive_language" style="height:100%;"></canvas>
                <script>
                    var passive_language = document.getElementById('passive_language');
                    var passive_language_pie = new Chart(passive_language, {
                        type: 'pie',
                        data: {
                                labels: [<cfloop from="1" to="#get_content_WRITER.recordcount#" index="i">
                                    <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "<cf_get_lang dictionary_id="62546.Yazarlara Göre Aktif ve Pasif İçerik Sayıları">%",
                                    backgroundColor: [<cfloop from="1" to="#get_content_WRITER.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_content_WRITER.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_writer_count.TOTAL_RECORD)#"</cfoutput>,</cfloop>],
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