    <cfset month_list = "#getLang('main',180)#,#getLang('main',181)#,#getLang('main',182)#,#getLang('main',183)#,#getLang('main',184)#,#getLang('main',185)#,#getLang('main',186)#,#getLang('main',187)#,#getLang('main',188)#,#getLang('main',189)#,#getLang('main',190)#,#getLang('main',191)#">
    <!---E-Fatura Panel--->
	<cfif isDefined('session.ep.our_company_info.is_efatura') and session.ep.our_company_info.is_efatura eq 1>
	<!---GELEN E-Fatura--->
        <cfquery name="GET_EINVOICE_RECEIVING" datasource="#dsn2#">                        
            SELECT
                MONTH(ISSUE_DATE) AS TEMP_MONTH,
                COUNT(MONTH(ISSUE_DATE)) AS MONTH_COUNT     
            FROM 
                EINVOICE_RECEIVING_DETAIL
            GROUP BY 
                MONTH(ISSUE_DATE)
            ORDER BY
                TEMP_MONTH ASC
        </cfquery>
        
        <cfquery name="GET_EINVOICE_RECEIVING_ALL" dbtype="query">
            SELECT 
                SUM(MONTH_COUNT) YEAR_COUNT
            FROM
                GET_EINVOICE_RECEIVING
        </cfquery> 
        
        <cfquery name="GET_EINVOICE_RECEIVING_MONTH" dbtype="query">                      
            SELECT
                MONTH_COUNT 
            FROM 
                GET_EINVOICE_RECEIVING
            WHERE
                TEMP_MONTH = #Month(now())#
        </cfquery>
        
        <!---GİDEN E-Fatura--->
        <cfquery name="GET_EINVOICE_SENDING" datasource="#dsn2#">
            SELECT 
                MONTH(ACTION_DATE) AS TEMP_MONTH,
                COUNT(MONTH(ACTION_DATE)) AS MONTH_COUNT	
            FROM 
                (SELECT
                    CASE WHEN(ER.ACTION_TYPE = 'INVOICE' ) THEN
                        I.INVOICE_DATE
                    ELSE
                        EIP.EXPENSE_DATE
                    END AS ACTION_DATE
                FROM
                    EINVOICE_RELATION ER
                        LEFT JOIN INVOICE I ON ER.ACTION_TYPE = 'INVOICE' AND ER.ACTION_ID = I.INVOICE_ID 
                        LEFT JOIN EXPENSE_ITEM_PLANS EIP ON ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND ER.ACTION_ID = EIP.EXPENSE_ID
                 ) T1
            WHERE 
                ACTION_DATE IS NOT NULL
            GROUP BY 
                MONTH(ACTION_DATE)
        </cfquery>
        
        <cfquery name="GET_EINVOICE_SENDING_ALL" dbtype="query">
            SELECT 
                SUM(MONTH_COUNT) YEAR_COUNT
            FROM
                GET_EINVOICE_SENDING
        </cfquery> 
        
        <cfquery name="GET_EINVOICE_SENDING_MONTH" dbtype="query">                      
            SELECT
                MONTH_COUNT 
            FROM 
                GET_EINVOICE_SENDING
            WHERE
                TEMP_MONTH = #Month(now())#        
        </cfquery>
    </cfif>

    <!--- e arşiv panel --->

    <cfif isDefined('session.ep.our_company_info.is_earchive') and session.ep.our_company_info.is_earchive eq 1>
        <!---GİDEN E-arşiv--->
        <cfquery name="GET_EARCHIVE_SENDING" datasource="#dsn2#">
            SELECT 
                MONTH(ACTION_DATE) AS TEMP_MONTH,
                COUNT(MONTH(ACTION_DATE)) AS MONTH_COUNT	
            FROM 
                (SELECT
                    CASE WHEN(ER.ACTION_TYPE = 'INVOICE' ) THEN
                        I.INVOICE_DATE
                    ELSE
                        EIP.EXPENSE_DATE
                    END AS ACTION_DATE
                FROM
                    EARCHIVE_RELATION ER
                        LEFT JOIN INVOICE I ON ER.ACTION_TYPE = 'INVOICE' AND ER.ACTION_ID = I.INVOICE_ID 
                        LEFT JOIN EXPENSE_ITEM_PLANS EIP ON ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND ER.ACTION_ID = EIP.EXPENSE_ID
                 ) T1
            WHERE 
                ACTION_DATE IS NOT NULL
            GROUP BY 
                MONTH(ACTION_DATE)
        </cfquery>
        
        <cfquery name="GET_EARCHIVE_SENDING_ALL" dbtype="query">
            SELECT 
                SUM(MONTH_COUNT) YEAR_COUNT
            FROM
                GET_EARCHIVE_SENDING
        </cfquery> 
        
        <cfquery name="GET_EARCHIVE_SENDING_MONTH" dbtype="query">                      
            SELECT
                MONTH_COUNT 
            FROM 
                GET_EARCHIVE_SENDING
            WHERE
                TEMP_MONTH = #Month(now())#        
        </cfquery>
    </cfif>

    <!--- e-irsaliye panell --->
    <cfif isDefined('session.ep.our_company_info.is_eshipment') and session.ep.our_company_info.is_eshipment eq 1>
        <cfquery name="GET_ESHIPMENT_SENDING" datasource="#dsn2#">                        
            SELECT
                MONTH(SHIP_DATE) AS TEMP_MONTH,
                COUNT(MONTH(SHIP_DATE)) AS MONTH_COUNT	   
            FROM 
                ESHIPMENT_RELATION ER
                LEFT JOIN SHIP SH ON ER.ACTION_ID = SH.SHIP_ID 
            WHERE 
                SHIP_DATE IS NOT NULL
            GROUP BY 
                MONTH(SHIP_DATE)
            ORDER BY
                TEMP_MONTH ASC
        </cfquery>

        <cfquery name="GET_ESHIPMENT_SENDING_ALL" dbtype="query">
            SELECT 
                SUM(MONTH_COUNT) YEAR_COUNT
            FROM
                GET_ESHIPMENT_SENDING
        </cfquery> 

        <cfquery name="GET_ESHIPMENT_SENDING_MONTH" dbtype="query">                      
            SELECT
                MONTH_COUNT 
            FROM 
                GET_ESHIPMENT_SENDING
            WHERE
                TEMP_MONTH = #Month(now())#        
        </cfquery>


        <cfquery name="GET_ESHIPMENT_RECEIVING" datasource="#dsn2#">                        
            SELECT
                MONTH(ISSUE_DATE) AS TEMP_MONTH,
                COUNT(MONTH(ISSUE_DATE)) AS MONTH_COUNT     
            FROM 
                ESHIPMENT_RECEIVING_DETAIL
            GROUP BY 
                MONTH(ISSUE_DATE)
            ORDER BY
                TEMP_MONTH ASC
        </cfquery>

        <cfquery name="GET_ESHIPMENT_RECEIVING_MONTH" dbtype="query">                      
            SELECT
                MONTH_COUNT 
            FROM 
                GET_ESHIPMENT_RECEIVING
            WHERE
                TEMP_MONTH = #Month(now())#
        </cfquery>

        <cfquery name="GET_ESHIPMENT_RECEIVING_ALL" dbtype="query">
            SELECT 
                SUM(MONTH_COUNT) YEAR_COUNT
            FROM
                GET_ESHIPMENT_RECEIVING
        </cfquery> 
    </cfif>

    <!---E-Defter Panel--->
    <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1>
        <cfquery name="GET_EDEFTER_DATA" datasource="#dsn2#">
            SELECT ISNULL((
                        SELECT COUNT(*)
                        FROM NETBOOKS
                        WHERE STATUS = 1
                        ), 0) AS PERIOD_EDEFTER_COUNT
                ,ISNULL((
                        SELECT SUM(BILL_FINISH_NUMBER - BILL_START_NUMBER + 1)
                        FROM NETBOOKS
                        WHERE STATUS = 1
                        ), 0) AS PERIOD_ROW_COUNT
                ,ISNULL((
                        SELECT TOP 1 CONVERT(VARCHAR(10), START_DATE, 103) + ' - ' + CONVERT(VARCHAR(10), FINISH_DATE, 103)
                        FROM NETBOOKS
                        WHERE STATUS = 1
                        ORDER BY FINISH_DATE DESC
                        ), '-') AS LAST_PERIOD_INFO
                ,ISNULL((
                        SELECT TOP 1
                                DATEPART(MONTH, DATEADD(month, DATEDIFF(month, 0, DATEADD(DAY, 1, FINISH_DATE)), 0))
                        FROM NETBOOKS
                        WHERE STATUS = 1
                        ORDER BY FINISH_DATE DESC
                        ), 1) AS NEXT_MONTH
        </cfquery>
    </cfif>
    <script src="JS/Chart.min.js"></script>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="34046.Grafiklerde kullanılan tarih değerleri belge tarihleri baz alınarak hazırlanmıştır"></cfsavecontent>
    <cfsavecontent variable="message2"><cf_get_lang dictionary_id="58975.Giden"></cfsavecontent>
    <cfsavecontent variable="message3"><cf_get_lang dictionary_id="58974.Gelen"></cfsavecontent>
    <cfset type_index = ( session.ep.our_company_info.is_eshipment eq 1 ) ? 'E-Fatura,E-Arşiv,E-İrsaliye' : 'E-Fatura,E-Arşiv'>
    <cfset type_index2 = ( session.ep.our_company_info.is_eshipment eq 1 ) ? 'E-Fatura,E-İrsaliye' : 'E-Fatura'>
    <cfset sendEinvoiceStruct = structNew()>
    <cfset sendEshipmentStruct = structNew()>
    <cfset sendEArchiveStruct = structNew()>
    <cfset receivingEinvoiceStruct = structNew()>
    <cfset receivingEshipmentStruct = structNew()>
    <cfset eDefterRows = structNew()>
    <cfset eDefterTotal = structNew()>
    
    <cfoutput query="GET_EINVOICE_SENDING"> <!--- Giden E-Fatura Ay -> Sayı şeklinde Dolduruluyor --->
        <cfset sendEinvoiceStruct[TEMP_MONTH] = MONTH_COUNT >
    </cfoutput>

    <cfoutput query="GET_EARCHIVE_SENDING"> <!--- Giden E-Arşiv Ay -> Sayı şeklinde Dolduruluyor --->
        <cfset sendEArchiveStruct[TEMP_MONTH] = MONTH_COUNT >
    </cfoutput>

    <cfoutput query="GET_EINVOICE_RECEIVING"> <!--- Gelen E-Fatura Ay -> Sayı şeklinde Dolduruluyor --->
        <cfset receivingEinvoiceStruct[TEMP_MONTH] = MONTH_COUNT >
    </cfoutput>

    <cfif isDefined('session.ep.our_company_info.is_eshipment') and session.ep.our_company_info.is_eshipment eq 1>
        <cfoutput query="GET_ESHIPMENT_SENDING"> <!--- Giden E-irsaliye Ay -> Sayı şeklinde Dolduruluyor --->
            <cfset sendEshipmentStruct[TEMP_MONTH] = MONTH_COUNT >
        </cfoutput>

        <cfoutput query="GET_ESHIPMENT_RECEIVING"> <!--- Giden E-irsaliye Ay -> Sayı şeklinde Dolduruluyor --->
            <cfset receivingEshipmentStruct[TEMP_MONTH] = MONTH_COUNT >
        </cfoutput>
    </cfif>

    <div class="col col-12">
        <cfsavecontent  variable="head"> <cf_get_lang dictionary_id="61997.E-Devlet Dashboard">
        </cfsavecontent>
        <cf_box title="#head#">
            <div class="dashboard-box dasboard-box-clr3">
                <div class="dashboard-box-label-count" style="font-size: 12px;  padding-left:22px; padding-top:10px;  text-align:left;"><cfif get_einvoice_sending_all.recordcount> <cfoutput>#get_einvoice_sending_all.year_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='29872.E-Fatura'></div>
                <div class="dashboard-box-label-count" style="font-size: 12px;  padding-left:22px;   padding-bottom: 3px;text-align:left;"><cfif get_earchive_sending_all.recordcount><cfoutput>#get_earchive_sending_all.year_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='57145.E-Arşiv'></div>
                <cfif session.ep.our_company_info.is_eshipment eq 1> <div class="dashboard-box-label-count" style="font-size: 12px;  padding-left:22px; padding-bottom: 5px;  text-align:left;"><cfif GET_ESHIPMENT_SENDING_ALL.recordcount><cfoutput>#GET_ESHIPMENT_SENDING_ALL.year_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='60911.E-İrsaliye'></div></cfif>
                <div class="dashboard-box-label-text"><cfoutput>#session.ep.period_year#</cfoutput> <cf_get_lang dictionary_id="33596.Dönemi"><cf_get_lang dictionary_id="58975.Giden"></div>            
            </div>
        
            <div class="dashboard-box dasboard-box-clr4">
                 <div class="dashboard-box-label-count" style="font-size: 12px; padding-bottom: 4px;   padding-left:22px; padding-top:10px;  text-align:left;"><cfif get_einvoice_sending_month.recordcount><cfoutput>#get_einvoice_sending_month.month_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='29872.E-Fatura'></div>
                 <div class="dashboard-box-label-count" style="font-size: 12px; padding-bottom: 4px;   padding-left:22px;   text-align:left;"><cfif get_earchive_sending_month.recordcount><cfoutput>#get_earchive_sending_month.month_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='57145.E-Arşiv'></div>
                <cfif session.ep.our_company_info.is_eshipment eq 1> <div class="dashboard-box-label-count" style="font-size: 12px; padding-bottom: 5px;   padding-left:22px;   text-align:left;"><cfif GET_ESHIPMENT_SENDING_MONTH.recordcount><cfoutput>#GET_ESHIPMENT_SENDING_MONTH.month_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='60911.E-İrsaliye'></div></cfif>
                <div class="dashboard-box-label-text"><cfoutput>#listgetat(month_list,Month(now()))# - #session.ep.period_year#</cfoutput> <cf_get_lang dictionary_id="58975.Giden"></div> 
            </div>  
        
            <div class="dashboard-box dasboard-box-clr1">
                <div class="dashboard-box-label-count" style="font-size: 12px; padding-bottom: 4px;   padding-left:22px; padding-top:10px;  text-align:left;"><cfif get_einvoice_receiving_month.recordcount><cfoutput>#get_einvoice_receiving_month.month_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='29872.E-Fatura'></div>
                <cfif session.ep.our_company_info.is_eshipment eq 1><div class="dashboard-box-label-count" style="font-size: 12px; padding-bottom: 4px;   padding-left:22px;  text-align:left;"><cfif GET_ESHIPMENT_RECEIVING_MONTH.recordcount><cfoutput>#GET_ESHIPMENT_RECEIVING_MONTH.month_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='60911.E-İrsaliye'></div></cfif>
                <div class="dashboard-box-label-text"><cfoutput>#listgetat(month_list,Month(now()))# - #session.ep.period_year#</cfoutput> <cf_get_lang dictionary_id="58974.Gelen"></div> 
            </div>
        
            <div class="dashboard-box dasboard-box-clr2">
                <div class="dashboard-box-label-count" style="font-size: 12px; padding-bottom: 4px;   padding-left:22px; padding-top:10px;  text-align:left;"><cfif get_einvoice_receiving_all.recordcount><cfoutput>#get_einvoice_receiving_all.year_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='29872.E-Fatura'></div>
                <cfif session.ep.our_company_info.is_eshipment eq 1><div class="dashboard-box-label-count" style="font-size: 12px; padding-bottom: 4px;   padding-left:22px;   text-align:left;"><cfif GET_ESHIPMENT_RECEIVING_ALL.recordcount><cfoutput>#GET_ESHIPMENT_RECEIVING_ALL.year_count#</cfoutput><cfelse>0</cfif> <cf_get_lang dictionary_id ='60911.E-İrsaliye'></div></cfif>
                <div class="dashboard-box-label-text"><cfoutput>#session.ep.period_year#</cfoutput> <cf_get_lang dictionary_id="33596.Dönemi"><cf_get_lang dictionary_id="58974.Gelen"></div> 
            </div> 
        </cf_box>
    </div>
    <div class="col col-12 col-xs-12">
        <div class="col col-6">
            <cf_box>
                <cfif GET_EINVOICE_SENDING.recordcount eq 0><cf_get_lang dictionary_id="57484.Kayıt Yok	"></cfif>
                    <canvas id="myChart1" style="float:left;"></canvas>
                    <script>
                        var ctx = document.getElementById('myChart1');
                        var data = {
                                    labels : [<cfloop list="#month_list#" index="month_ii"><cfoutput>'#month_ii#'</cfoutput>,</cfloop>],
                                    datasets : [<cfloop list="#type_index#" index="xx_index">
                                        {
                                            label:"<cfif xx_index eq 'E-Fatura'>
														<cf_get_lang dictionary_id ='29872.E-Fatura'>
													<cfelseif xx_index eq 'E-İrsaliye'>
                                                        <cf_get_lang dictionary_id ='60911.E-İrsaliye'>
                                                    <cfelseif xx_index eq 'E-Arşiv'>
                                                        <cf_get_lang dictionary_id ='57145.E-Arşiv'>
                                                    </cfif>",
                                            fill: false,
											lineTension: 0.1,
                                            backgroundColor: "rgba(225,0,0,0.4)",
                                            borderColor: [<cfloop list="#type_index#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderCapStyle: 'square',
											borderDashOffset: 0.0,
											borderJoinStyle: 'miter',
											pointBorderColor: "black",
											pointBackgroundColor: "white",
											pointBorderWidth: 1,
											pointHoverRadius: 8,
											pointHoverBackgroundColor: "orange",
											pointHoverBorderColor: "brown",
											pointHoverBorderWidth: 2,
											pointRadius: 4,
											pointHitRadius: 10,
                                            data : [
                                                    <cfif xx_index eq 'E-Fatura'>
                                                        <cfloop list="#month_list#" index="sayac" item="month_ii">
                                                            <cfoutput>#structKeyExists(sendEinvoiceStruct,sayac) ? sendEinvoiceStruct[sayac] : 0#,</cfoutput>
                                                        </cfloop>
                                                    <cfelseif xx_index eq 'E-İrsaliye'>
                                                        <cfloop list="#month_list#" index="sayac" item="month_ii">
                                                            <cfoutput>#structKeyExists(sendEshipmentStruct,sayac) ? sendEshipmentStruct[sayac] : 0#,</cfoutput>
                                                        </cfloop>
                                                    <cfelseif xx_index eq 'E-Arşiv'>
                                                        <cfloop list="#month_list#" index="sayac" item="month_ii">
                                                            <cfoutput>#structKeyExists(sendEArchiveStruct,sayac) ? sendEArchiveStruct[sayac] : 0#,</cfoutput>
                                                        </cfloop>
                                                    </cfif>
                                                ],
                                            spanGaps: true,
                                    }, </cfloop>
                                ]
                            };
                            var options = {
									scales: {
											yAxes: [{
												scaleLabel: {
													display: true,
													labelString: '<cfoutput>#message2#</cfoutput>',
													fontSize: 16 
													}
											}],
											xAxes:[{
												ticks: {
													beginAtZero:true
												},
												scaleLabel: {
													display: true,
													labelString: '<cfoutput>#message#</cfoutput>',
													fontSize: 14
													}
											}]         
										}
								};

                        var myChart1 = new Chart(ctx, {
                                    type: 'line',
                                    data: data,
                                    options: options
                                });
                    </script>
            </cf_box>
        </div>

        <div class="col col-6">
            <cf_box>
                <cfif GET_EINVOICE_RECEIVING.recordcount eq 0><cf_get_lang dictionary_id="57484.Kayıt Yok"></cfif>
                    <canvas id="myChart2" style="float:left;"></canvas>
                    <script>
                        var ctx = document.getElementById('myChart2');
                        var data = {
                                    labels : [<cfloop list="#month_list#" index="month_ii"><cfoutput>'#month_ii#'</cfoutput>,</cfloop>],
                                    datasets : [<cfloop list="#type_index2#" index="xx_index">
                                        {
                                            label:"<cfif xx_index eq 'E-Fatura'>
														<cf_get_lang dictionary_id ='29872.E-Fatura'>
													<cfelseif xx_index eq 'E-İrsaliye'>
														<cf_get_lang dictionary_id ='60911.E-İrsaliye'>
                                                    </cfif>",
                                            fill: false,
											lineTension: 0.1,
                                            backgroundColor: "rgba(225,0,0,0.4)",
                                            borderColor: [<cfloop list="#type_index2#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderCapStyle: 'square',
											borderDashOffset: 0.0,
											borderJoinStyle: 'miter',
											pointBorderColor: "black",
											pointBackgroundColor: "white",
											pointBorderWidth: 1,
											pointHoverRadius: 8,
											pointHoverBackgroundColor: "orange",
											pointHoverBorderColor: "brown",
											pointHoverBorderWidth: 2,
											pointRadius: 4,
											pointHitRadius: 10,
                                            data : [
                                                    <cfif xx_index eq 'E-Fatura'>
                                                        <cfloop list="#month_list#" index="sayac" item="month_ii">
                                                            <cfoutput>#structKeyExists(receivingEinvoiceStruct,sayac) ? receivingEinvoiceStruct[sayac] : 0#,</cfoutput>
                                                        </cfloop>
                                                    <cfelseif xx_index eq 'E-İrsaliye'>
                                                        <cfloop list="#month_list#" index="sayac" item="month_ii">
                                                            <cfoutput>#structKeyExists(receivingEshipmentStruct,sayac) ? receivingEshipmentStruct[sayac] : 0#,</cfoutput>
                                                        </cfloop>
                                                    </cfif>
                                                ],
                                            spanGaps: true,
                                    }, </cfloop>
                                ]
                            };
                            var options = {
									scales: {
											yAxes: [{
												scaleLabel: {
													display: true,
													labelString: '<cfoutput>#message3#</cfoutput>',
													fontSize: 16 
													}
											}],
											xAxes:[{
												ticks: {
													beginAtZero:true
												},
												scaleLabel: {
													display: true,
													labelString: '<cfoutput>#message#</cfoutput>',
													fontSize: 14
													}
											}]         
										}
								};

                        var myChart2 = new Chart(ctx, {
                                            type: 'line',
                                            data: data,
                                            options: options
                                        });
                    </script>
            </cf_box>
        </div>
    </div>

    <div class="col col-12">
        <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1>
            <cf_box>
                <div class="dashboard-box dasboard-box-clr5">
                    <div class="dashboard-box-label-count">
                        <cfoutput>#GET_EDEFTER_DATA.PERIOD_EDEFTER_COUNT#</cfoutput>
                    </div>
                    <div class="dashboard-box-label-text"><cfoutput>#session.ep.period_year#</cfoutput> <cf_get_lang dictionary_id="34254.Toplam E-Defter"></div>            
                </div>
                
                <div class="dashboard-box dasboard-box-clr6">
                    <div class="dashboard-box-label-count">                   		
                        <cfoutput>#GET_EDEFTER_DATA.PERIOD_ROW_COUNT#</cfoutput>
                    </div>
                    <div class="dashboard-box-label-text"><cfoutput>#session.ep.period_year#</cfoutput> <cf_get_lang dictionary_id="34228.Toplam Satır"></div> 
                </div>  
                
                <div class="dashboard-box dasboard-box-clr7">
                    <div class="dashboard-box-label-count" style="font-size: 19px; padding-bottom: 38px; padding-top: 9px;">
                        <cfoutput>#GET_EDEFTER_DATA.LAST_PERIOD_INFO#</cfoutput>
                    </div>
                    <div class="dashboard-box-label-text"><cfoutput>#session.ep.period_year#</cfoutput> <cf_get_lang dictionary_id="34227.Son Dönem"></div> 
                </div>
                
                <div class="dashboard-box dasboard-box-clr8">
                    <div class="dashboard-box-label-count" style="font-size: 19px; padding-bottom: 38px; padding-top: 9px;">
                        <cfoutput>#DaysInMonth(CreateDate(session.ep.period_year,(GET_EDEFTER_DATA.NEXT_MONTH+3)%12,1))#/#NumberFormat((GET_EDEFTER_DATA.NEXT_MONTH+3)%12,09)#/#session.ep.period_year + int((GET_EDEFTER_DATA.NEXT_MONTH+2)/12)# </cfoutput>		
                    </div>
                    <div class="dashboard-box-label-text"><cfoutput>#session.ep.period_year# - #listgetat(month_list,GET_EDEFTER_DATA.NEXT_MONTH)#</cfoutput> <cf_get_lang dictionary_id="34226.Son Gönderim Tarihi"></div> 
                </div> 
            </cf_box>
        <cfelse>
            <cfoutput><cf_get_lang dictionary_id="34223.İlgili Şirket veya Dönemde E-Defter Entegrasyon Tipi bulunmamaktadır">.</cfoutput>
        </cfif>
    </div>

    <div class="col col-12 col-xs-12">
        <div class="col col-6">
            <cf_box>
                <cfquery name="GET_EDEFTER_ROWS" datasource="#dsn2#">
                    Select * From (SELECT
                        SUM(ACR.AMOUNT * (1 - ACR.BA)) MONTH_TOTAL,
                        COUNT(*) AS MONTH_ROW_COUNT,
                        MONTH(AC.ACTION_DATE) AS MONTH_NO
                    FROM
                        ACCOUNT_CARD_ROWS ACR
                            LEFT JOIN ACCOUNT_CARD AC ON AC.CARD_ID = ACR.CARD_ID
                    GROUP BY
                        MONTH(AC.ACTION_DATE)) T1
                    ORDER BY MONTH_NO ASC
                </cfquery>
                <cfoutput query="GET_EDEFTER_ROWS">
                    <cfset eDefterRows[MONTH_NO] = MONTH_ROW_COUNT >
                    <cfset eDefterTotal[MONTH_NO] = MONTH_TOTAL >
                </cfoutput>
                <cfif GET_EDEFTER_ROWS.recordcount eq 0><cf_get_lang dictionary_id="57484.Kayıt Yok"></cfif>
                    <canvas id="myChart3" style="float:left;"></canvas>
                    <script>
                        var ctx = document.getElementById('myChart3');
                        var data = {
                                    labels : [<cfloop list="#month_list#" index="month_ii"><cfoutput>'#month_ii#'</cfoutput>,</cfloop>],
                                    datasets : [
                                        {
                                            label:"<cf_get_lang dictionary_id="34225.E-Defter Satırlar">",
                                            fill: false,
											lineTension: 0.1,
                                            backgroundColor: "rgba(225,0,0,0.4)",
                                            borderColor: [<cfloop list="#type_index#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderCapStyle: 'square',
											borderDashOffset: 0.0,
											borderJoinStyle: 'miter',
											pointBorderColor: "black",
											pointBackgroundColor: "white",
											pointBorderWidth: 1,
											pointHoverRadius: 8,
											pointHoverBackgroundColor: "orange",
											pointHoverBorderColor: "brown",
											pointHoverBorderWidth: 2,
											pointRadius: 4,
											pointHitRadius: 10,
                                            data : [
                                                    <cfloop list="#month_list#" index="sayac" item="month_ii">
                                                        <cfoutput>#structKeyExists(eDefterRows,sayac) ? eDefterRows[sayac] : 0#,</cfoutput>
                                                    </cfloop>
                                                ],
                                            spanGaps: true,
                                    },
                                ]
                            };
                            var options = {
									scales: {
											xAxes:[{
												ticks: {
													beginAtZero:true
												},
												scaleLabel: {
													display: true,
													labelString: '<cf_get_lang dictionary_id="34225.E-Defter Satırlar">',
													fontSize: 14
													}
											}]         
										}
								};

                        var myChart1 = new Chart(ctx, {
                                    type: 'line',
                                    data: data,
                                    options: options
                                });
                    </script>
            </cf_box>
        </div>
        <div class="col col-6">
            <cf_box>
                <canvas id="myChart4" style="float:left;"></canvas>
                <script>
                    var ctx = document.getElementById('myChart4');
                        var data = {
                                    labels : [<cfloop list="#month_list#" index="month_ii"><cfoutput>'#month_ii#'</cfoutput>,</cfloop>],
                                    datasets : [
                                        {
                                            label:"<cf_get_lang dictionary_id="34224.E-Defter Tutarlar">",
                                            fill: false,
											lineTension: 0.1,
                                            backgroundColor: "rgba(225,0,0,0.4)",
                                            borderColor: [<cfloop list="#type_index#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderCapStyle: 'square',
											borderDashOffset: 0.0,
											borderJoinStyle: 'miter',
											pointBorderColor: "black",
											pointBackgroundColor: "white",
											pointBorderWidth: 1,
											pointHoverRadius: 8,
											pointHoverBackgroundColor: "orange",
											pointHoverBorderColor: "brown",
											pointHoverBorderWidth: 2,
											pointRadius: 4,
											pointHitRadius: 10,
                                            data : [
                                                    <cfloop list="#month_list#" index="sayac" item="month_ii">
                                                        <cfoutput>#structKeyExists(eDefterTotal,sayac) ? eDefterTotal[sayac] : 0#,</cfoutput>
                                                    </cfloop>
                                                ],
                                            spanGaps: true,
                                    },
                                ]
                            };
                            var options = {
									scales: {
                                            yAxes: [{
												ticks: {
													beginAtZero:true,
													userCallback: function(value, index, values) {
														// Convert the number to a string and splite the string every 3 charaters from the end
														value = value.toString();
														value = value.split(/(?=(?:...)*$)/);
														
														// Convert the array to a string and format the output
														value = value.join('.');
														return value;
														}
												}
											}],
											xAxes:[{
												ticks: {
													beginAtZero:true
												},
												scaleLabel: {
													display: true,
													labelString: '<cf_get_lang dictionary_id="34224.E-Defter Tutarlar">',
													fontSize: 14
													}
											}]         
                                        },
									tooltips: {
										callbacks: {
											label : function(tooltipItem, data){
												return data.datasets[tooltipItem.datasetIndex].label + ': '+ tooltipItem.yLabel.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
											}
										}
									}
								};

                        var myChart1 = new Chart(ctx, {
                                    type: 'line',
                                    data: data,
                                    options: options
                                });
                    </script>
            </cf_box>
        </div>
    </div>

<script type="text/javascript">
$(function(){
	$("tr.dashboardTab").css("display","none");
	$("a.dashboardNav").click(function(){	
		$("tr.dashboardTab").removeClass("tabActive");
		$("tr#"+this.id).addClass("tabActive");
		
		});
});//ready
</script>    
   





