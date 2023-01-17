<cf_xml_page_edit fuseact="report.product_sample">
<cfif not isdefined("attributes.startdate")><cfset attributes.startdate = ''><cfelse><cfset attributes.startdate = dateformat(attributes.startdate,dateformat_style)></cfif>
    <cfif not isdefined("attributes.finishdate")><cfset attributes.finishdate = ''><cfelse><cfset attributes.finishdate = dateformat(attributes.finishdate,dateformat_style)></cfif>
        <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            <cf_date tarih="attributes.startdate">
        </cfif>
        <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            <cf_date tarih="attributes.finishdate">
        </cfif> 
        <cf_catalystHeader>
            <cf_box>
                <cfform name="list_dashboard" action="">
                    <cf_box_search>
                        <div class="form-group" id="item-startdate">
                            <div class="input-group">
                                <input type="text" name="startdate" id="startdate" placeholder="<cf_get_lang dictionary_id='58690.Tarih Aralığı'>" value="<cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput>" message="#message#" validate="<cfoutput>#validate_style#</cfoutput>">
                                <span class="input-group-addon"> <cf_wrk_date_image date_field="startdate"> </span>
                            </div>
                        </div>
                        <div class="form-group" id="item-finishdate">
                            <div class="input-group">
                                <input type="text" name="finishdate" id="finishdate" placeholder="<cf_get_lang dictionary_id='58690.Tarih Aralığı'>" value="<cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput>"  validate="<cfoutput>#validate_style#</cfoutput>" maxlength="10" message="#message1#">
                                <span class="input-group-addon"> <cf_wrk_date_image date_field="finishdate"> </span>
                            </div>
                        </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type='4' is_excel='0'>
                        </div>
                    </cf_box_search>
                </cfform>
            </cf_box>
               
        <cfquery name="GET_MY_WORKS_DATA" datasource="#DSN#">
                SET language turkish
                SELECT 
                    PR.PRODUCT_SAMPLE_ID
                    ,PR.PROCESS_STAGE_ID
                    ,PR.TARGET_DELIVERY_DATE
                    ,MONTH(PR.TARGET_DELIVERY_DATE) AS MONTH2
                    ,datename(month, PR.TARGET_DELIVERY_DATE) as REQ_MONTH
                    ,PR.PRODUCT_SAMPLE_CAT_ID
                    ,OP.SALES_EMP_ID
                    ,C.FULLNAME
                    ,E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS MT
                    ,PTR.STAGE
                    ,PR.OPPORTUNITY_ID
                FROM
                    #dsn3#.PRODUCT_SAMPLE PR
                    left JOIN COMPANY C ON PR.COMPANY_ID=C.COMPANY_ID
                    LEFT JOIN #dsn3#.OPPORTUNITIES OP ON OP.OPP_ID=PR.OPPORTUNITY_ID
                    LEFT JOIN EMPLOYEES E ON OP.SALES_EMP_ID=E.EMPLOYEE_ID
                    LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=PR.PROCESS_STAGE_ID
                    
                WHERE 1=1
                <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                    AND TARGET_DELIVERY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                </cfif>
                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                    AND TARGET_DELIVERY_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                </cfif>
        </cfquery>	
                        
            <!--------KPİ------------>
            
            <div class="row myhomeBox">	
        
                <div class="col col-4 col-md-3 col-sm-6 col-xs-12">
                    <div class="dashboard-stat2 ">
                        <div class="display">
                            <div class="number">
                                <h4 class="font-green-sharp">
                                    <span data-counter="counterup"><cfoutput>#GET_MY_WORKS_DATA.RECORDCOUNT#</cfoutput></span>
                                    <small class="font-green-sharp"></small>
                                </h4>
                                <small><cf_get_lang dictionary_id="62663.Dönem İçi"> <cf_get_lang dictionary_id="37453.Numune Sayısı"></small>
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
                <div class="col col-4 col-md-3 col-sm-6 col-xs-12">
                    <div class="dashboard-stat2 ">
                        <div class="display">
                            <div class="number">
                                <h4 class="font-red-haze">
                                    <span data-counter="counterup">
                                        <cfquery name="GET_MY_WORKS_DATA_"  dbtype="query">
                                            select * from GET_MY_WORKS_DATA where PROCESS_STAGE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#product_sample_stage_id#" list="yes">)
                                        </cfquery>
                                        <cfoutput>#GET_MY_WORKS_DATA_.RECORDCOUNT#</cfoutput>
                                    </span>
                                    <small class="font-red-haze"></small>
                                </h4>
                                <small><cf_get_lang dictionary_id="31469.Onay Bekleyen"> <cf_get_lang dictionary_id="37453.Numune Sayısı"></small>
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
                <div class="col col-4 col-md-3 col-sm-6 col-xs-12">
                    <div class="dashboard-stat2 ">
                        <div class="display">
                            <div class="number">
                                <h4 class="font-blue-sharp">
                                    <span data-counter="counterup" data-value="567">                    
                                        <cfoutput>#GET_MY_WORKS_DATA.RECORDCOUNT#</cfoutput>
                                    </span>
                                    <small></small>
                                </h4>
                                <small><cf_get_lang dictionary_id="62658.Devam Eden (İş Oluştur)"></small>
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
         
        <cfsavecontent  variable="message"><cf_get_lang dictionary_id="29675.Aylara göre"><cf_get_lang dictionary_id="37453.Numune Sayısı">
        </cfsavecontent>
            <div class="col col-6 col-xs-12">
                <cf_box title="#message#" >
                    <div class="col col-12 col-xs-12" id="cat_work_summary">
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
                                            label: "<cfoutput><cf_get_lang dictionary_id="37453.Numune Sayısı"></cfoutput>",
                                            backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                }]
                                            },
                                    options: {}
                                });
                            </script> 
                        </div>
                    </div>
                </cf_box>
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
             <cfsavecontent  variable="message"><cf_get_lang dictionary_id="62661.Müşteri Temsilcisine göre"><cf_get_lang dictionary_id="37453.Numune Sayısı">
             </cfsavecontent>
            <div  class="col col-6 col-xs-12">
                <cf_box title="#message#" >
                    <div class="col col-12 col-xs-12" id="stage_work_summary">
                        <!------2.grafik--------->
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
                                            label: "<cfoutput><cf_get_lang dictionary_id="37453.Numune Sayısı"></cfoutput>",
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
                    </div>
                </cf_box>
            </div>
                <!------/2.grafik--------->         
            <cfquery name="GET_MY_WORKS3" dbtype="query">
                    SELECT 
                        STAGE
                        ,COUNT(*) AS REQ_COUNT
                    FROM GET_MY_WORKS_DATA 
                    GROUP BY STAGE	
            </cfquery>
            <cfsavecontent  variable="message"><cf_get_lang dictionary_id="62660.Sürece Göre"><cf_get_lang dictionary_id="37453.Numune Sayısı">
            </cfsavecontent>
            <div class="col col-6 col-xs-12">
                <cf_box title="#message#" >
                    <div class="col col-12 col-xs-12" id="fin_rate_mywork_summary">
                    <div class="col col-12 col-xs-12">
                        <cfoutput query="get_my_works3">
                            <cfset 'item_#currentrow#' = "#get_my_works3.STAGE# (#get_my_works3.REQ_COUNT# Adet)">
                            <cfset 'value_#currentrow#' = "#get_my_works3.REQ_COUNT#">
                        </cfoutput>
                        <canvas id="get_adet" style="height:100%;"></canvas>
                        <script>
                            var get_adet = document.getElementById('get_adet');
                            var get_adet_pie = new Chart(get_adet, 
                            {
                                type: 'pie',
                                data: {
                                        labels: [<cfloop from="1" to="#get_my_works3.recordcount#" index="jj">
                                            <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                        label: "<cfoutput><cf_get_lang dictionary_id="37453.Numune Sayısı"></cfoutput>",
                                        
                                        
                                        backgroundColor: [<cfloop from="1" to="#get_my_works3.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#get_my_works3.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                    }]
                                    },
                                options: {
                                    legend: {
                                        display: false
                                    }
                                }
                            });
                        </script>
                        </div>
                    </div>  
                </cf_box>
            </div>
            <!------3.grafik--------->
            <cfquery name="GET_MY_WORKS4" dbtype="query">
                SELECT 
                    FULLNAME
                    ,COUNT(*) AS REQ_COUNT
                FROM GET_MY_WORKS_DATA 
                GROUP BY FULLNAME	
                ORDER BY 2 DESC
            </cfquery>
            <!----4.GRAFİK------------>
            <cfsavecontent  variable="message"><cf_get_lang dictionary_id="62659.Firmaya göre"><cf_get_lang dictionary_id="37453.Numune Sayısı">
            </cfsavecontent>
            <div class="col col-6 col-xs-12">
                <cf_box title="#message#">
                    <div class="col col-12 col-xs-12" id="time_cost_summary"  style="margin-left:auto;margin-right:auto;">
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
                                            label: "<cfoutput><cf_get_lang dictionary_id="37453.Numune Sayısı"></cfoutput>",
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
                </cf_box>
            </div> 
            <!----4.GRAFİK------------>
                    
     
        <style>
        #chartdiv {
          width: 100%;
          height: 500px;
        }
        
        </style>
        
      
        