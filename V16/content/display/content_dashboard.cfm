<!---
    File:V16/content/display/content_dashboard.cfm
    Author: Workcube-Fatma Zehra Dere
    Date: 04.04.2021
    Controller: ContentDashboardController.cfm
    Description: -
--->
<cfset getComponent = createObject('component','V16.content.cfc.get_content_dashboard')>
<cfset GET_CONTENT_ = getComponent.GET_CONTENT_DASHBOARD(content_cat:1)>
<cfset GET_CONTENT_CHAPTER = getComponent.GET_CONTENT_DASHBOARD(chapter:1)>
<cfset GET_CONTENT_T = getComponent.GET_CONTENT_DASHBOARD(type:1)>
<cfset GET_CONTENT_WRITER = getComponent.GET_CONTENT_DASHBOARD(writer:1)>
<cfset GET_CONTENT_DASHBOARD = getComponent.GET_CONTENT_DASHBOARD(language:1)>

<cf_catalystHeader> 
<div class="col col-12 col-xs-12">
<!--- Kategorilere Göre Aktif ve Pasif İçerik Sayıları --->
    <cfsavecontent variable="active_demands"><cf_get_lang dictionary_id="62504.Kategorilere Göre Aktif ve Pasif İçerik Sayıları"></cfsavecontent>
    <cf_box id="box_content_category" closable="0" collapsable="1" title="#active_demands#" uidrop="1">
        <div class="col col-6">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th><cf_get_lang dictionary_id="57493.Aktif "><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                        <th><cf_get_lang dictionary_id="57494.Pasif"><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_CONTENT_.recordcount>
                        <cfoutput query="GET_CONTENT_">
                            <tr>
                            <td>#contentcat#</td>
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
                            SUM(ACTIVE_TOTAL) AS TOTAL_RECORD 
                        FROM
                            get_content_
                    </cfquery>
                    <cfoutput query="get_content_">
                        <cfset 'item_#currentrow#' = "#contentcat#">
                        <cfset 'value_#currentrow#' = "#ACTIVE_TOTAL#">
                    </cfoutput>
                    <canvas id="active_orders" style="height:100%;"></canvas>
                    <script>
                        var active_orders = document.getElementById('active_orders');
                        var active_orders_pie = new Chart(active_orders, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#get_content_.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id="62504.Kategorilere Göre Aktif ve Pasif İçerik Sayıları">%",
                                        backgroundColor: [<cfloop from="1" to="#get_content_.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#get_content_.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_orders_count.TOTAL_RECORD)#"</cfoutput>,</cfloop>],
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
                        <cfset 'item_#currentrow#' = "#contentcat#">
                        <cfset 'value_#currentrow#' = "#PASSIVE_TOTAL#">
                    </cfoutput>
                    <canvas id="passive_orders" style="height:100%;"></canvas>
                    <script>
                        var passive_orders = document.getElementById('passive_orders');
                        var passive_orders_pie = new Chart(passive_orders, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#get_content_.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id="62504.Kategorilere Göre Aktif ve Pasif İçerik Sayıları">%",
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
    </cf_box>
<!--- Bölümlere Göre Aktif ve Pasif İçerik Sayıları --->
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="62539.Bölümlere göre aktif ve pasif içerik sayılar"></cfsavecontent>
    <cf_box id="box_content_chapter" closable="0" collapsable="1" title="#message#" uidrop="1">
        <div class="col col-6">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57995.Bölüm'></th>
                        <th><cf_get_lang dictionary_id="57493.Aktif "><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                        <th><cf_get_lang dictionary_id="57494.Pasif"><cf_get_lang dictionary_id="62341. İçerik Sayısı"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_CONTENT_CHAPTER.recordcount>
                        <cfoutput query="GET_CONTENT_CHAPTER">
                            <tr>
                                <td>#CHAPTER#</td>
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
                    <script src="JS/Chart.min.js"></script> 
                <cfif GET_CONTENT_CHAPTER.recordcount>
                    <cfquery name="sum_orders_count" dbtype="query">
                        SELECT
                            SUM(ACTIVE_TOTAL) AS TOTAL_RECORD
                        FROM
                        GET_CONTENT_CHAPTER
                    </cfquery>
                    <cfoutput query="GET_CONTENT_CHAPTER">
                        <cfset 'item_#currentrow#' = "#CHAPTER#">
                        <cfset 'value_#currentrow#' = "#ACTIVE_TOTAL#">
                    </cfoutput>
                    <canvas id="active_chapter" style="height:100%;"></canvas>
                    <script>
                        var active_chapter = document.getElementById('active_chapter');
                        var active_chapter_pie = new Chart(active_chapter, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#GET_CONTENT_CHAPTER.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id="62539.Bölümlere göre aktif ve pasif içerik sayılar">%",
                                        backgroundColor: [<cfloop from="1" to="#GET_CONTENT_CHAPTER.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#GET_CONTENT_CHAPTER.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_orders_count.TOTAL_RECORD)#"</cfoutput>,</cfloop>],
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
                <cfif GET_CONTENT_CHAPTER.recordcount>
                    <cfquery name="sum_orders_count" dbtype="query">
                        SELECT
                            SUM(PASSIVE_TOTAL) AS TOTAL_RECORD_
                        FROM
                        GET_CONTENT_CHAPTER
                    </cfquery>
                    <cfoutput query="GET_CONTENT_CHAPTER">
                        <cfset 'item_#currentrow#' = "#CHAPTER#">
                        <cfset 'value_#currentrow#' = "#PASSIVE_TOTAL#">
                    </cfoutput>
                    <canvas id="passive_chapter" style="height:100%;"></canvas>
                    <script>
                        var passive_chapter = document.getElementById('passive_chapter');
                        var passive_chapter_pie = new Chart(passive_chapter, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#GET_CONTENT_CHAPTER.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id="62539.Bölümlere göre aktif ve pasif içerik sayılar">%",
                                        backgroundColor: [<cfloop from="1" to="#GET_CONTENT_CHAPTER.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#GET_CONTENT_CHAPTER.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_orders_count.TOTAL_RECORD_)#"</cfoutput>,</cfloop>],
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
    </cf_box>
<!--- Tiplerine Göre Aktif ve Pasif İçerik Sayıları --->
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="62545.Tiplerine Göre Aktif ve Pasif İçerik Sayıları"></cfsavecontent>
    <cf_box id="box_content_type" closable="0" collapsable="1" title="#message#" uidrop="1">
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
                    <cfif GET_CONTENT_T.recordcount>
                        <cfoutput query="GET_CONTENT_T">
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
                <cfif get_content_t.recordcount>
                    <cfquery name="sum_orders_count" dbtype="query">
                        SELECT
                            SUM(ACTIVE_TOTAL) AS TOTAL_RECORD_ 
                        FROM
                            get_content_
                    </cfquery>
                    <cfoutput query="get_content_t">
                        <cfset 'item_#currentrow#' = "#NAME#">
                        <cfset 'value_#currentrow#' = "#ACTIVE_TOTAL#">
                    </cfoutput>
                    <canvas id="active_type" style="height:100%;"></canvas>
                    <script>
                        var active_type = document.getElementById('active_type');
                        var active_type_pie = new Chart(active_type, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#get_content_t.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id="62545.Tiplerine Göre Aktif ve Pasif İçerik Sayıları">%",
                                        backgroundColor: [<cfloop from="1" to="#get_content_t.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#get_content_t.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_orders_count.TOTAL_RECORD_)#"</cfoutput>,</cfloop>],
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
                <cfif get_content_t.recordcount>
                    <cfquery name="sum_orders_count" dbtype="query">
                        SELECT
                            SUM(PASSIVE_TOTAL) AS TOTAL_RECORD_
                        FROM
                            get_content_
                    </cfquery>
                    <cfoutput query="get_content_t">
                        <cfset 'item_#currentrow#' = "#NAME#">
                        <cfset 'value_#currentrow#' = "#PASSIVE_TOTAL#">
                    </cfoutput>
                    <canvas id="passive_type" style="height:100%;"></canvas>
                    <script>
                        var passive_type = document.getElementById('passive_type');
                        var passive_type_pie = new Chart(passive_type, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#get_content_t.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id="62545.Tiplerine Göre Aktif ve Pasif İçerik Sayıları"></cf_get_lang>%",
                                        backgroundColor: [<cfloop from="1" to="#get_content_t.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#get_content_t.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/sum_orders_count.TOTAL_RECORD_)#"</cfoutput>,</cfloop>],
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
    </cf_box>
<!--- Yazarlara Göre Aktif ve Pasif İçerik Sayıları --->
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="62546.Yazarlara Göre Aktif ve Pasif İçerik Sayıları"></cfsavecontent>
    <cf_box id="box_content_writer" closable="0" collapsable="1" title="#message#" uidrop="1">
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
    </cf_box>
<!--- Dile Göre Aktif ve Pasif İçerik Sayıları --->
    <cfsavecontent variable="message1"><cf_get_lang dictionary_id="62547.Dile Göre Aktif ve Pasif İçerik Sayıları"></cfsavecontent>
    <cf_box id="box_content_language" closable="0" collapsable="1" title="#message1#" uidrop="1">
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
    </cf_box>
</div>