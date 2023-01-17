<cfif not isdefined("attributes.startdate")><cfset attributes.startdate = ''><cfelse><cfset attributes.startdate = dateformat(attributes.startdate,dateformat_style)></cfif>
<cfif not isdefined("attributes.finishdate")><cfset attributes.finishdate = ''><cfelse><cfset attributes.finishdate = dateformat(attributes.finishdate,dateformat_style)></cfif>
        
    
    
    
    <div class="row">
        <div class="col col-12 col-xs-12 form-inline">
              <div class="col col-12 col-xs-12">
                    <div class="col col-6 col-xs-12">
                        <h3>Numune Dashboards</h3>
                    </div>
                    <div class="col col-6 col-xs-12" style="text-align:right;">
                    <div class="form-group" id="item-status">
                        <div class="input-group">
                        <cfform name="list_dashboard" action="">
                                <label class="col col-2 col-xs-12"><cf_get_lang_main no='330.Tarih'></label>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="startdate" id="startdate" value="<cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput>" message="#message#" validate="<cfoutput>#validate_style#</cfoutput>">
                                        <span class="input-group-addon"> <cf_wrk_date_image date_field="startdate"> </span>
                                    </div>
                                </div>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="finishdate" id="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput>"  validate="<cfoutput>#validate_style#</cfoutput>" maxlength="10" message="#message1#">
                                        <span class="input-group-addon"> <cf_wrk_date_image date_field="finishdate"> </span>
                                    </div>
                                </div>
                                <div class="col col-1 col-xs-12">
                                <cf_wrk_search_button button_type='0' is_excel='0'>
                                </div>
                        </cfform>
                        </div>
                    </div>	
            </div>
            
        
        
        
        
        
    <cfquery name="GET_MY_WORKS_DATA" datasource="#DSN#">
            SET language turkish
            SELECT 
                 R.REQ_ID
                ,R.REQ_STAGE
                ,R.REQ_DATE
                ,MONTH(R.REQ_DATE) AS MONTH2
                ,datename(month,R.REQ_DATE) as REQ_MONTH
                ,R.PRODUCT_CAT_ID
                ,R.REQ_TYPE_ID
                ,C.FULLNAME
                ,E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS MT
                ,PTR.STAGE
            FROM
                workcube_akarteks_1.TEXTILE_SAMPLE_REQUEST R
                left JOIN workcube_akarteks.COMPANY C on R.COMPANY_ID=C.COMPANY_ID
                LEFT JOIN workcube_akarteks.PRO_PROJECTS PP ON PP.PROJECT_ID=R.PROJECT_ID
                LEFT JOIN workcube_akarteks.EMPLOYEES E ON R.SALES_EMP_ID=E.EMPLOYEE_ID
                left JOIN workcube_akarteks.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=R.REQ_STAGE
            WHERE R.REQ_STATUS=1
            <!----
            SELECT 
                COUNT(PW.WORK_ID) WORK_COUNT,
                PWC.WORK_CAT  WORK_CAT
            FROM 
                PRO_WORKS PW,
                PRO_WORK_CAT PWC
            WHERE 
                PW.WORK_CAT_ID = PWC.WORK_CAT_ID AND
                PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
            GROUP BY	
                PWC.WORK_CAT	
            ------>			
    </cfquery>	
        
        
        
        
        
        
        <!--------KPİ------------>
        
        <div class="row myhomeBox">	
    
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                <div class="dashboard-stat2 ">
                    <div class="display">
                        <div class="number">
                            <h4 class="font-green-sharp">
                            
                                <span data-counter="counterup"><cfoutput>#GET_MY_WORKS_DATA.RECORDCOUNT#</cfoutput></span>
                                <small class="font-green-sharp"></small>
                            </h4>
                            <small>Dönem İçi Numune Sayısı</small>
                        </div>
                        <div class="icon">
                            <i class="icon-level-up"></i>
                        </div>
                    </div>
                   
    
                    <div class="progress-info">
                        <div class="progress">
                            <span style="width: 100%;" class="progress-bar progress-bar-success green-sharp">
                            </span>
                        </div>
                        <div class="status">
                            <div class="status-title">BBBB</div>
                            <div class="status-number">
                            <cfoutput>600</cfoutput>
                            </div>
                        </div>
                    </div>
                </div>
            </div>   
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                <div class="dashboard-stat2 ">
                    <div class="display">
                        <div class="number">
                            <h4 class="font-red-haze">
                                <span data-counter="counterup">
									<cfoutput>400</cfoutput>
                                </span>
                                <small class="font-red-haze"></small>
                            </h4>
                            <small>Onay Bekleyen Numune Sayısı</small>
                        </div>
                        <div class="icon">
                            <i class="icon-level-down"></i>
                        </div>
                    </div>
                    <div class="progress-info">
                        <div class="progress">
                            <span style="width: 100%;" class="progress-bar progress-bar-success red-haze">                        
                            </span>
                        </div>
                        <div class="status">
                            <div class="status-title">DDDD</div>
                            <div class="status-number">
                                <cfoutput>800</cfoutput>	
                             </div>
                        </div>
                    </div>
                </div>
            </div>  
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                <div class="dashboard-stat2 ">
                    <div class="display">
                        <div class="number">
                            <h4 class="font-blue-sharp">
                                <span data-counter="counterup" data-value="567">                    
                                    <cfoutput>100</cfoutput>
                                </span>
                                <small></small>
                            </h4>
                            <small>Devam Eden (İş Oluştur)</small>
                        </div>
                    </div>
                    <div class="progress-info">
                        <div class="progress">
                            <span style="width: 100%;" class="progress-bar progress-bar-success blue-sharp">                        
                            </span>
                        </div>
                        <div class="status">
                            <div class="status-title">OOOOOOOO</div>
                            <div class="status-number"><cfoutput>222</cfoutput></div>
                        </div>
                    </div>
                </div>
            </div>  
        </div>
            
            
    <!------/KPİ---------->
            
            
            
            
        <script src="JS/Chart.min.js"></script>
        
        
        
        
        
        <cfquery name="GET_MY_WORKS" dbtype="query">
                SELECT 
                    MONTH2
                    ,REQ_MONTH
                    ,COUNT(*) AS REQ_COUNT
                FROM GET_MY_WORKS_DATA 
                GROUP BY REQ_MONTH,MONTH2
                ORDER BY MONTH2
                    
        </cfquery>
        
        
    
        <div class="col col-12 col-xs-12" id="graphs" style="margin-top:5%;">
                <div class="col col-12 col-xs-12">
                    <div class="col col-12 col-xs-12">
                    
                        <div class="col col-6 col-xs-12" id="cat_work_summary" style="border:solid 1px #c3c3c3;">
                            
                            
                                                
                                        <div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"><h5>Aylara göre Numune Sayısı</h5></div>
                                        <div class="col col-12 col-xs-12">
                                        
                                                
                                            
                                                <cfoutput query="get_my_works">
                                                    <cfset 'item_#currentrow#' = "#get_my_works.REQ_MONTH# #get_my_works.REQ_COUNT#">
                                                    <cfset 'value_#currentrow#' = "#get_my_works.REQ_COUNT#">
                                                </cfoutput>
                                                <canvas id="myChart1"></canvas>
                                                    <script>
                                                        var ctx = document.getElementById('myChart1');
                                                        var myChart1 = new Chart(ctx, {
                                                            type: 'bar',
                                                            data: {
                                                                    labels: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">
                                                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                                    datasets: [{
                                                                    label: "<cfoutput>Numune Sayısı</cfoutput>",
                                                                    backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                                    data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                                        }]
                                                                    },
                                                            options: {}
                                                        });
                                                    </script> 
                                        </div>
                                                                
                            
                            
                            
                            
                        </div>
                        
                        <!---/1.grafik------->
                        
                        
                        <cfquery name="GET_MY_WORKS2" dbtype="query">
                                SELECT 
                                    MT
                                    ,COUNT(*) AS REQ_COUNT
                                FROM GET_MY_WORKS_DATA 
                                GROUP BY MT	
                                ORDER BY 2 DESC
                        </cfquery>
                        
                        
                        
                        
                        <div class="col col-6 col-xs-12" id="stage_work_summary" style="border:solid 1px #c3c3c3;">
                            <!------2.grafik--------->
                            <div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"><h5>Müşteri Temsilcisine göre Numune Sayısı</h5></div>
                            <div class="col col-12 col-xs-12">
                                                <cfoutput query="get_my_works2">
                                                    <cfset 'item_#currentrow#' = "#get_my_works2.MT#">
                                                    <cfset 'value_#currentrow#' = "#get_my_works2.REQ_COUNT#">
                                                </cfoutput>
                                                <canvas id="myChart2"></canvas>
                                                    <script>
                                                        var ctx = document.getElementById('myChart2');
                                                        var myChart2 = new Chart(ctx, 
														{
                                                            type: 'bar',
                                                            data: {
                                                                    labels: [<cfloop from="1" to="#get_my_works2.recordcount#" index="jj">
                                                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                                    datasets: [{
                                                                    label: "<cfoutput>Numune sayısı</cfoutput>",
                                                                    backgroundColor: [<cfloop from="1" to="#get_my_works2.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                                    data: [<cfloop from="1" to="#get_my_works2.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                                        }]
                                                                    },
                                                            options: 
																{
                                                                
																  scales: 
																	{
																			yAxes: [{
																				ticks: {
																					beginAtZero: true
																				}
																			}]
																	}
																}
                                                        });
                                                    </script> 
                                        </div>
                            
                            
                            <!------/2.grafik--------->
                            
                            
                        </div>
                    </div>
                    
                    
                    <!-------
                        data: {
                                    labels: [<cfloop from="1" to="#get_my_works2.recordcount#" index="jj">
                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                    datasets: [{
                                    label: "<cfoutput>Numune sayısı</cfoutput>",
                                    backgroundColor: [<cfloop from="1" to="#get_my_works2.recordcount#" index="jj">'rgba(200,120,180,0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_my_works2.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                        },
                                        {
                                    label: "<cfoutput>Numune Toplam</cfoutput>",
                                    backgroundColor: [<cfloop from="1" to="#get_my_works2.recordcount#" index="jj">'rgba(100,120,80,0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_my_works2.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                        }]
                                    },
                            
                            
                            options: {
                                scales: {
                                    yAxes: [{ticks: {mirror: true}}]
                                }
                            }
                        
                            
                            
                            
                        });
    
                    ----->
    
                    
                    <cfquery name="GET_MY_WORKS3" dbtype="query">
                            SELECT 
                                STAGE
                                ,COUNT(*) AS REQ_COUNT
                            FROM GET_MY_WORKS_DATA 
                            GROUP BY STAGE	
                    </cfquery>
                    
                    
                        
                    <div class="col col-12 col-xs-12">
                        <div class="col col-6 col-xs-12" id="fin_rate_mywork_summary" style="border:solid 1px #c3c3c3;">
                            
                            
                            <!------3.grafik--------->
                            <div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"><h5>Sürece göre Numune Sayısı</h5></div>
                            <div class="col col-12 col-xs-12">
                                    <!-----örnek%
                                        <cfset 'temp_stage_rate_#currentrow#' = (STAGE_TOTAL*100)/customer_total_offer>
                                        <cfset 'item_#currentrow#'="#STAGE# (%#wrk_round(evaluate('temp_stage_rate_#currentrow#'))#)">
                                        <cfset 'value_#currentrow#'="#wrk_round(evaluate('temp_stage_rate_#currentrow#')/100)#">
                                    ----->
                            
                                                <cfoutput query="get_my_works3">
                                                    <cfset 'item_#currentrow#' = "#get_my_works3.STAGE# (#get_my_works3.REQ_COUNT# Adet)">
                                                    <cfset 'value_#currentrow#' = "#get_my_works3.REQ_COUNT#">
                                                </cfoutput>
                                                <canvas id="myChart3"></canvas>
                                                    <script>
                                                        var ctx = document.getElementById('myChart3');
                                                        var myChart3 = new Chart(ctx, 
                                                        {
                                                            type: 'pie',
                                                            data: {
                                                                    labels: [<cfloop from="1" to="#get_my_works3.recordcount#" index="jj">
                                                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                                    datasets: [{
                                                                    label: "<cfoutput>Numune Sayısı</cfoutput>",
                                                                    
                                                                    
                                                                    backgroundColor: [<cfloop from="1" to="#get_my_works3.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                                    data: [<cfloop from="1" to="#get_my_works3.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                                        }]
                                                                    },
                                                                    
                                                                                                
                                                            options : {
            responsive: true,
            maintainAspectRatio: false,
            legend: {
                position : 'bottom',
                labels : {
                    fontColor: 'rgb(154, 154, 154)',
                    fontSize: 11,
                    usePointStyle : true,
                    padding: 20
                }
            },
           
            tooltips: false,
            layout: {
                padding: {
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 20
                }
            }
        }
        
        
                                                        });
                                                        
                                                        
                                                        
                                                        
                                                    </script> 
                            </div>
                            
                            
                            <!------3.grafik--------->
                            
                        </div>
                        
                        <cfquery name="GET_MY_WORKS4" dbtype="query">
                            SELECT 
                                FULLNAME
                                ,COUNT(*) AS REQ_COUNT
                            FROM GET_MY_WORKS_DATA 
                            GROUP BY FULLNAME	
                            ORDER BY 2 DESC
                        </cfquery>
                       
                        <!----4.GRAFİK------------>
                        <div class="col col-6 col-xs-12" id="time_cost_summary" style="border:solid 1px #c3c3c3;">
                            <div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"><h5>Firmaya göre Numune Sayısı</h5></div>
                            <div class="col col-12 col-xs-12">
                                                <cfoutput query="get_my_works4">
                                                    <cfset 'item_#currentrow#' = "#get_my_works4.FULLNAME#">
                                                    <cfset 'value_#currentrow#' = "#get_my_works4.REQ_COUNT#">
                                                </cfoutput>
                                                <canvas id="myChart4"></canvas>
                                                    <script>
                                                        var ctx = document.getElementById('myChart4');
                                                        var myChart4 = new Chart(ctx, {
                                                            type: 'horizontalBar',
                                                            data: {
                                                                    labels: [<cfloop from="1" to="#get_my_works4.recordcount#" index="jj">
                                                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                                    datasets: [{
                                                                    label: "<cfoutput>Numune sayısı</cfoutput>",
                                                                    backgroundColor: [<cfloop from="1" to="#get_my_works4.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                                    data: [<cfloop from="1" to="#get_my_works4.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                                        }]
                                                                    },
                                                            options: {
                                                                scales: {
                                                                    yAxes: [{ticks: {mirror: true}}]
                                                                },
                                                                
                                                                
                                                                pieceLabel: {
                render: 'percentage',
                fontColor: 'white',
                fontSize: 14,
            },
                                                                
                                                                
                                                            }
                                                        });
                                                    </script> 
                            </div>
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        </div>
                        <!----4.GRAFİK------------>
                    </div>
                    
                    <!-----
                    <div class="col col-12 col-xs-12">
                        <div class="col col-6 col-xs-12" id="mytermin_summary" style="border:solid 1px #c3c3c3;">
                            <script type="text/javascript">
                                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_termin_summary&type=1','mytermin_summary');
                            </script>
                        </div>
                        <div class="col col-6 col-xs-12" id="priority_summary" style="border:solid 1px #c3c3c3;">
                            <script type="text/javascript">
                                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_priority_work_summary','priority_summary');
                            </script>
                        </div>
                    </div>
                    <div class="col col-12 col-xs-12">
                        <div class="col col-6 col-xs-12" id="record_summary" style="border:solid 1px #c3c3c3;">
                            <script type="text/javascript">
                                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_record_work_summary','record_summary');
                            </script>
                        </div>
                        <div class="col col-6 col-xs-12" id="proj_emp_summary" style="border:solid 1px #c3c3c3;">
                            <script type="text/javascript">
                                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_project_emp_summary','proj_emp_summary');
                            </script>
                        </div>
                    </div>
                    <div class="col col-12 col-xs-12">
                        <div class="col col-6 col-xs-12" id="fin_rate_work_summary" style="border:solid 1px #c3c3c3;">
                            <script type="text/javascript">
                                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_fin_work_summary&type=2','fin_rate_work_summary');
                            </script>
                        </div>
                        <div class="col col-6 col-xs-12" id="all_time_cost_summary" style="border:solid 1px #c3c3c3;">
                            <script type="text/javascript">
                                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_time_cost_summary&type=2','all_time_cost_summary');
                            </script>
                        </div>
                    </div>
                    <div class="col col-12 col-xs-12">
                        <div class="col col-6 col-xs-12" id="termin_summary" style="border:solid 1px #c3c3c3;">
                            <script type="text/javascript">
                                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_termin_summary&type=2','termin_summary');
                            </script>
                        </div>
                    </div>
                </div>
                ---->
        </div>
        
        
        
        <!---
        <div class="col col-10 col-xs-12" id="rel_table" style="display:none;margin-top:1%;">
            <div class="col col-12 col-xs-12">
                <cfsavecontent variable="message1">Delege Edilen İşler - İş Tamamlanma Oranları</cfsavecontent>
                <cf_box
                    id="rec_table_summary"
                    unload_body="1"
                    closable="0"
                    title="#message1#"
                    box_page="#request.self#?fuseaction=report.popup_rec_table_work_summary">
                </cf_box>
            </div>
            <div class="col col-12 col-xs-12">
                <cfsavecontent variable="message2">Delege Edilen İşler - <cfoutput>#getLang('main',157)#</cfoutput></cfsavecontent>
                <cf_box
                    id="rec_emp_summary"
                    unload_body="1"
                    closable="0"
                    title="#message2#"
                    box_page="#request.self#?fuseaction=report.popup_rec_emp_work_summary">
                </cf_box>
            </div>
            <div class="col col-12 col-xs-12">
                <cfsavecontent variable="message3"><cfoutput>#getLang('myhome',74)#</cfoutput> - <cfoutput>#getLang('main',149)#</cfoutput></cfsavecontent>
                <cf_box
                    id="rec_time_cost_summary"
                    unload_body="1"
                    closable="0"
                    title="#message3#"
                    box_page="#request.self#?fuseaction=report.popup_record_time_cost_sum&type=1">
                </cf_box>
            </div>
            <div class="col col-12 col-xs-12">
                <cfsavecontent variable="message4">Kişilere Göre İşler - <cfoutput>#getLang('assetcare',421)#</cfoutput></cfsavecontent>
                <cf_box
                    id="rec_out_of_date_summary"
                    unload_body="1"
                    closable="0"
                    title="#message4#"
                    box_page="#request.self#?fuseaction=report.popup_table_out_of_work">
                </cf_box>
            </div>
            <div class="col col-12 col-xs-12">
                <cfsavecontent variable="message5"><cfoutput>#getLang('report',1455)# #getLang('main',608)#</cfoutput> - <cfoutput>#getLang('assetcare',392)#</cfoutput></cfsavecontent>
                <cf_box
                    id="fin_rate_table_summary"
                    unload_body="1"
                    closable="0"
                    title="#message5#"
                    box_page="#request.self#?fuseaction=report.popup_finish_rate_table_work&type=1">
                </cf_box>
            </div>
            <div class="col col-12 col-xs-12">
                <cfsavecontent variable="message6"><cfoutput>#getLang('report',1456)# #getLang('main',608)#</cfoutput> - <cfoutput>#getLang('assetcare',392)#</cfoutput></cfsavecontent>
                <cf_box
                    id="fin_rate_table2_summary"
                    unload_body="1"
                    closable="0"
                    title="#message6#"
                    box_page="#request.self#?fuseaction=report.popup_finish_rate_table_work&type=2">
                </cf_box>
            </div>
            <div class="col col-12 col-xs-12">
                <cfsavecontent variable="message7"><cfoutput>#getLang('report',1456)# #getLang('main',608)#</cfoutput> - <cfoutput>#getLang('main',149)#</cfoutput></cfsavecontent>
                <cf_box
                    id="rec_time_cost2_summary"
                    unload_body="1"
                    closable="0"
                    title="#message7#"
                    box_page="#request.self#?fuseaction=report.popup_record_time_cost_sum&type=2">
                </cf_box>
            </div>
        </div>
        --->
        
        </div>
    </div>
    
    <!-- Styles -->
    <style>
    #chartdiv {
      width: 100%;
      height: 500px;
    }
    
    </style>
    
  
    