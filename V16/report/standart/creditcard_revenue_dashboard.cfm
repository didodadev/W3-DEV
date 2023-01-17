<!--- 12.02.2020 Safa Taşkın - Kredi Kartı Çekimlerinden oluşan verilerle Dashboard tasarlandı. --->

<cfparam name="attributes.branch" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.onlinePos" default="1">

<script src="JS/Chart.min.js"></script>
<script src="JS/holisticJs/core.js"></script>
<script src="JS/holisticJs/charts.js"></script>
<script src="JS/holisticJs/maps.js"></script>
<script src="JS/holisticJs/themes/animated.js"></script>
<script src="JS/holisticJs/themes/spiritedaway.js"></script>
<script src="JS/holisticJs/themes/kelly.js"></script>
<script src="JS/holisticJs/themes/dark.js"></script>
<script src="JS/holisticJs/plugins/forceDirected.js"></script>
<script src="JS/holisticJs/plugins/timeline.js"></script>
<script src="JS/holisticJs/geodata/turkeyHigh.js"></script>

<cfif attributes.report_type eq 1>
    <cfset rType = "COUNT">
<cfelseif attributes.report_type eq 2>
    <cfset rType = "SUM">
</cfif>

<cfset pre = "">

<cfif isdefined('attributes.date1') and len(attributes.date1)>
	<cf_date tarih='attributes.date1'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST eq 1>
		<cfset attributes.date1=''>
	<cfelse>
        <cfset attributes.date1 = date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif  isdefined('attributes.date2') and len(attributes.date2)>
	<cf_date tarih='attributes.date2'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.date2=''>
	<cfelse>
        <cfset attributes.date2 = wrk_get_today()>
	</cfif>
</cfif>

<cfquery name="dayBased" datasource="#dsn3#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
    SELECT 
        DAY(STORE_REPORT_DATE) DAY1, 
        #rType#(SALES_CREDIT) PIECE
    FROM 
        CREDIT_CARD_BANK_PAYMENTS
    WHERE 
        1=1
        <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
            <cfif attributes.onlinePos eq 0>
                AND IS_ONLINE_POS IS NULL
            <cfelse>
                AND IS_ONLINE_POS = #attributes.onlinePos#
            </cfif>
        </cfif>
        <cfif isdefined("attributes.branch") and len(attributes.branch)>
            AND TO_BRANCH_ID = #attributes.branch#
        </cfif>
        <cfif session.ep.ISBRANCHAUTHORIZATION>
            AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
        <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
        <cfif len(attributes.date2)>AND STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif>
    GROUP BY DAY(STORE_REPORT_DATE)
    ORDER BY DAY(STORE_REPORT_DATE)
</cfquery>

<cfquery name="instalmentBased" datasource="#dsn3#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
    SELECT 
        NUMBER_OF_INSTALMENT INSTALMENT, 
        #rType#(SALES_CREDIT) TOTAL
    FROM CREDIT_CARD_BANK_PAYMENTS
    WHERE
        1=1
        <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
            <cfif attributes.onlinePos eq 0>
                AND IS_ONLINE_POS IS NULL
            <cfelse>
                AND IS_ONLINE_POS = #attributes.onlinePos#
            </cfif>
        </cfif>
        <cfif isdefined("attributes.branch") and len(attributes.branch)>
            AND TO_BRANCH_ID = #attributes.branch#
        </cfif>
        <cfif session.ep.ISBRANCHAUTHORIZATION>
            AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
        <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
        <cfif len(attributes.date2)>AND STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif>
    GROUP BY NUMBER_OF_INSTALMENT
    ORDER BY NUMBER_OF_INSTALMENT ASC
</cfquery>

<cfquery name="bankBased" datasource="#dsn3#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
    SELECT 
        A.ACCOUNT_NAME BANK, 
        #rType#(SALES_CREDIT) TOTAL
    FROM CREDIT_CARD_BANK_PAYMENTS CP
    LEFT JOIN CREDITCARD_PAYMENT_TYPE CPT ON CP.PAYMENT_TYPE_ID = CPT.PAYMENT_TYPE_ID
    LEFT JOIN ACCOUNTS A ON CPT.BANK_ACCOUNT = A.ACCOUNT_ID
    WHERE 
        1=1
        <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
            <cfif attributes.onlinePos eq 0>
                AND IS_ONLINE_POS IS NULL
            <cfelse>
                AND IS_ONLINE_POS = #attributes.onlinePos#
            </cfif>
        </cfif>
        <cfif isdefined("attributes.branch") and len(attributes.branch)>
            AND TO_BRANCH_ID = #attributes.branch#
        </cfif>
        <cfif session.ep.ISBRANCHAUTHORIZATION>
            AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
        <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
        <cfif len(attributes.date2)>AND STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif>
    GROUP BY A.ACCOUNT_NAME
    ORDER BY ACCOUNT_NAME
</cfquery>

<cfquery name="dayNameBased" datasource="#dsn3#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
    SELECT TOP 7
        (CASE WHEN DATEPART (DW,STORE_REPORT_DATE) = 2 THEN 'Pazartesi'
        WHEN DATEPART (DW,STORE_REPORT_DATE) = 3 THEN 'Salı'
        WHEN DATEPART (DW,STORE_REPORT_DATE) = 4 THEN 'Çarşamba'
        WHEN DATEPART (DW,STORE_REPORT_DATE) = 5 THEN 'Perşembe'
        WHEN DATEPART (DW,STORE_REPORT_DATE) = 6 THEN 'Cuma'
        WHEN DATEPART (DW,STORE_REPORT_DATE) = 7 THEN 'Cumartesi'
        WHEN DATEPART (DW,STORE_REPORT_DATE) = 1 THEN 'Pazar'
        ELSE ''
        END) AS WEEKDAY,
        #rType#(SALES_CREDIT) TOTAL
    FROM CREDIT_CARD_BANK_PAYMENTS
    WHERE
        1=1
        <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
            <cfif attributes.onlinePos eq 0>
                AND IS_ONLINE_POS IS NULL
            <cfelse>
                AND IS_ONLINE_POS = #attributes.onlinePos#
            </cfif>
        </cfif>
        <cfif isdefined("attributes.branch") and len(attributes.branch)>
            AND TO_BRANCH_ID = #attributes.branch#
        </cfif>
        <cfif session.ep.ISBRANCHAUTHORIZATION>
            AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
        <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
        <cfif len(attributes.date2)>AND STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif>
    GROUP BY DATEPART(DW,STORE_REPORT_DATE)
    ORDER BY 2 DESC
</cfquery>

<cfquery name="bankBasedTree" datasource="#dsn3#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
    SELECT
        A.ACCOUNT_NAME,
        CP.NUMBER_OF_INSTALMENT,
        #rType#(SALES_CREDIT) TOTAL
    FROM
        CREDIT_CARD_BANK_PAYMENTS CP
    LEFT JOIN CREDITCARD_PAYMENT_TYPE CPT ON CP.PAYMENT_TYPE_ID = CPT.PAYMENT_TYPE_ID
    LEFT JOIN ACCOUNTS A ON CPT.BANK_ACCOUNT = A.ACCOUNT_ID
    WHERE
        1=1
        <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
            <cfif attributes.onlinePos eq 0>
                AND IS_ONLINE_POS IS NULL
            <cfelse>
                AND IS_ONLINE_POS = #attributes.onlinePos#
            </cfif>
        </cfif>
        <cfif isdefined("attributes.branch") and len(attributes.branch)>
            AND TO_BRANCH_ID = #attributes.branch#
        </cfif>
        <cfif session.ep.ISBRANCHAUTHORIZATION>
            AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
        <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
        <cfif len(attributes.date2)>AND STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif>
    GROUP BY A.ACCOUNT_NAME, CP.NUMBER_OF_INSTALMENT
    ORDER BY ACCOUNT_NAME, NUMBER_OF_INSTALMENT
</cfquery>

<cfquery name="timeSeries" datasource="#dsn3#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
    SELECT
        STORE_REPORT_DATE,
        #rType#(SALES_CREDIT) TOTAL
    FROM
        CREDIT_CARD_BANK_PAYMENTS
    WHERE
        1=1
        <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
            <cfif attributes.onlinePos eq 0>
                AND IS_ONLINE_POS IS NULL
            <cfelse>
                AND IS_ONLINE_POS = #attributes.onlinePos#
            </cfif>
        </cfif>
        <cfif isdefined("attributes.branch") and len(attributes.branch)>
            AND TO_BRANCH_ID = #attributes.branch#
        </cfif>
        <cfif session.ep.ISBRANCHAUTHORIZATION>
            AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
        <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
        <cfif len(attributes.date2)>AND STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif>
    GROUP BY STORE_REPORT_DATE
    ORDER BY STORE_REPORT_DATE
</cfquery>

<cfquery name="yearBased" datasource="#dsn3#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
    SELECT
        YEAR(STORE_REPORT_DATE) YEAR1,
        #rType#(SALES_CREDIT) TOTAL
    FROM
        CREDIT_CARD_BANK_PAYMENTS
    WHERE
        1=1
        <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
            <cfif attributes.onlinePos eq 0>
                AND IS_ONLINE_POS IS NULL
            <cfelse>
                AND IS_ONLINE_POS = #attributes.onlinePos#
            </cfif>
        </cfif>
        <cfif isdefined("attributes.branch") and len(attributes.branch)>
            AND TO_BRANCH_ID = #attributes.branch#
        </cfif>
        <cfif session.ep.ISBRANCHAUTHORIZATION>
            AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
        <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
        <cfif len(attributes.date2)>AND STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif>
    GROUP BY YEAR(STORE_REPORT_DATE)
    ORDER BY YEAR(STORE_REPORT_DATE)
</cfquery>

<cfquery name="get_city_based" datasource="#dsn3#">
    SELECT
        PLATE_CODE,
        #rType#(SALES_CREDIT) TOTAL
    FROM(
        SELECT
            SC.PLATE_CODE,
            SALES_CREDIT 
        FROM
            CREDIT_CARD_BANK_PAYMENTS CP
        LEFT JOIN #dsn#.COMPANY C ON CP.ACTION_FROM_COMPANY_ID = C.COMPANY_ID
        LEFT JOIN #dsn#.SETUP_CITY SC ON C.CITY = SC.CITY_ID
        WHERE C.CITY IS NOT NULL
            <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
                <cfif attributes.onlinePos eq 0>
                    AND IS_ONLINE_POS IS NULL
                <cfelse>
                    AND IS_ONLINE_POS = #attributes.onlinePos#
                </cfif>
            </cfif>
            <cfif isdefined("attributes.branch") and len(attributes.branch)>
                AND TO_BRANCH_ID = #attributes.branch#
            </cfif>
            <cfif session.ep.ISBRANCHAUTHORIZATION>
                AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
            </cfif>
            <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
            <cfif len(attributes.date2)>AND STORE_REPORT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif>

        UNION ALL

        SELECT
            SC.PLATE_CODE,
            SALES_CREDIT 
        FROM
            CREDIT_CARD_BANK_PAYMENTS CP
        LEFT JOIN #dsn#.CONSUMER C ON CP.CONSUMER_ID = C.CONSUMER_ID
        LEFT JOIN #dsn#.SETUP_CITY SC ON C.TAX_CITY_ID = SC.CITY_ID
        WHERE C.TAX_CITY_ID IS NOT NULL
            <cfif isdefined("attributes.onlinePos") and  len(attributes.onlinePos)>
                <cfif attributes.onlinePos eq 0>
                    AND IS_ONLINE_POS IS NULL
                <cfelse>
                    AND IS_ONLINE_POS = #attributes.onlinePos#
                </cfif>
            </cfif>
            <cfif isdefined("attributes.branch") and len(attributes.branch)>
                AND TO_BRANCH_ID = #attributes.branch#
            </cfif>
            <cfif session.ep.ISBRANCHAUTHORIZATION>
                AND TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
            </cfif>
            <cfif len(attributes.date1)>AND STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
    )K
    GROUP BY PLATE_CODE
</cfquery>

<cfquery name="branch" datasource="#dsn#" cachedWithin="#createTimeSpan( 0, 1, 0, 0 )#">
    SELECT 
        BRANCH_ID, 
        BRANCH_NAME
    FROM 
        BRANCH
    WHERE 
        COMPANY_ID = #session.ep.COMPANY_ID# 
        AND BRANCH_STATUS = 1 
    ORDER BY BRANCH_NAME ASC
</cfquery>

<cfform name="order_form" method="post" action="">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='60282.Kredi Kartı Tahsilatları Dashboard'></cfsavecontent>
    <cf_report_list_search title="#title#"> 
            <cf_report_list_search_area>
                <div class="row">
                    <div class="col col-12 col-xs-12">
                        <div class="row formContent">
                            <div class="row" type="row">
                                <div class="col col-3 col-md-6 col-sm-6 col-xs-12">                                
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58690.Tarih Aralığı'></label>
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="date1" id="date1" value="#dateformat(attributes.date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="date2" id="date2" value="#dateformat(attributes.date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
											</div>
										</div>
									</div>
                                </div>
                                <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                            <div class="col col-12 col-xs-12">
                                                <select name="report_type" id="report_type" style="width:150px;">
                                                    <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58082.Adet'><cf_get_lang dictionary_id ='58601.Bazında'></option>
                                                    <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='57882.İşlem Tutarı'><cf_get_lang dictionary_id ='58601.Bazında'></option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58929.Tahsilat Tipi'></label>
                                            <div class="col col-12 col-xs-12">
                                                <select name="onlinePos" id="onlinePos" style="width:150px;">
                                                    <option value="" <cfif not len(attributes.onlinePos)>selected</cfif>><cf_get_lang dictionary_id ='57708.Tümü'></option>
                                                    <option value="0" <cfif attributes.onlinePos eq 0>selected</cfif>><cf_get_lang dictionary_id ='58927.Sanal'><cf_get_lang dictionary_id ='57679.POS'><cf_get_lang dictionary_id ='30056.Olmayanlar'></option>
                                                    <option value="1" <cfif attributes.onlinePos eq 1>selected</cfif>><cf_get_lang dictionary_id ='58927.Sanal'><cf_get_lang dictionary_id ='57679.POS'></option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <cfif not session.ep.isBranchAuthorization>
                                    <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
                                        <div class="col col-12 col-xs-12">
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='29434.Şubeler'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <select name="branch" id="branch" tabindex="12">
                                                        <option value=""><cf_get_lang dictionary_id ='30126.Şube Seçiniz'></option>
                                                        <cfoutput query="branch">
                                                            <option value="#branch.BRANCH_ID#" <cfif attributes.branch eq branch.BRANCH_ID>selected</cfif>>#branch.BRANCH_NAME#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </cfif>
                            </div>
                            <div class="row ReportContentBorder">
                                <div class="ReportContentFooter">
                                    <cf_wrk_report_search_button button_type='1' is_excel="1"> 
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>

    <div class="row">
        <div class="col col-4 col-xs-12" id="id_myChart5">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57490.Gün'> <cf_get_lang dictionary_id ='58601.Bazında'>
            </cfsavecontent>
            <cf_box title="#message#">
                <div class="col col-12 col-xs-12" >
                    <div id="chartdiv" style="width: 100%; height: 500px;"></div>	
                </div>
            </cf_box>
        </div>
        <div class="col col-4 col-xs-12"  id="id_myChart5">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30132.Taksit Sayısı'> <cf_get_lang dictionary_id ='58601.Bazında'></cfsavecontent>
            <cf_box title="#message#">
            <div class="col col-12 col-xs-12">
                <div id="chartdiv4" style="width: 100%; height: 500px;"></div>
            </div>
        </cf_box>
        </div>
        <div class="col col-4 col-xs-12" id="id_myChart5" >
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57490.Gün'>  <cf_get_lang dictionary_id ='58601.Bazında'></cfsavecontent>
            <cf_box title="#message#">
                <div class="col col-12 col-xs-12">
                    <div id="chartdiv7" style="width: 100%; height: 500px;"></div>
                </div>
            </cf_box>
        </div>
        <div class="col col-8 col-xs-12" id="id_myChart5" >
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='29449.Banka Hesabı'> <cf_get_lang dictionary_id ='58601.Bazında'></cfsavecontent>
            <cf_box title="#message#">
                <div class="col col-12 col-xs-12">
                    <div id="chartdiv5" style="width: 100%; height: 500px;"></div>
                </div>
            </cf_box>
        </div>
        <div class="col col-4 col-xs-12" id="id_myChart5" >
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58455.Yıl'> <cf_get_lang dictionary_id ='58601.Bazında'></cfsavecontent>
            <cf_box title="#message#">
                <div class="col col-12 col-xs-12">
                    <div id="yearBased" style="width: 100%; height: 500px;"></div>	
                </div>
        </cf_box>
        </div>
        <div class="col col-12 col-xs-12" id="id_myChart5" >
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57490.Gün'> <cf_get_lang dictionary_id ='58601.Bazında'></cfsavecontent>
            <cf_box title="#message#">
                <div class="col col-12 col-xs-12">
                    <div id="timeSeries" style="width: 100%; height: 500px;"></div>	
                </div>
        </cf_box>
        </div>
        <div class="col col-12 col-xs-12" id="id_myChart5" >
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='29449.Banka Hesabı'> <cf_get_lang dictionary_id ='57989.Ve'> <cf_get_lang dictionary_id ='30132.Taksit Sayısı'> <cf_get_lang dictionary_id ='58601.Bazında'></cfsavecontent>
            <cf_box title="#message#">
                <div class="col col-12 col-xs-12">
                    <div id="bankBasedTree" style="width: 100%; height: 500px;"></div>	
                </div>
        </cf_box>
        </div>
        <div class="col col-12 col-xs-12" id="id_myChart5" >
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57457.Müşteri'> <cf_get_lang dictionary_id ='57971.Şehir'> <cf_get_lang dictionary_id ='58601.Bazında'></cfsavecontent>
            <cf_box title="#message#">
                <div class="col col-12 col-xs-12">
                        <div id="cityBased" style="width: 100%; height: 500px;"></div>	
                </div>
            </cf_box>
        </div>
    </div>

<script type="text/javascript">

    /* Gün Bazında */
    am4core.ready(function() {
        am4core.useTheme(am4themes_animated);

        var chart = am4core.create("chartdiv", am4charts.RadarChart);
        chart.scrollbarX = new am4core.Scrollbar();

        var data = [];

        <cfoutput query="dayBased">
            data.push({category: #DAY1#, value: #PIECE#});
        </cfoutput>

        chart.data = data;
        chart.radius = am4core.percent(100);
        chart.innerRadius = am4core.percent(50);

        var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
        categoryAxis.dataFields.category = "category";
        categoryAxis.renderer.grid.template.location = 0;
        categoryAxis.renderer.minGridDistance = 30;
        categoryAxis.tooltip.disabled = true;
        categoryAxis.renderer.minHeight = 110;
        categoryAxis.renderer.grid.template.disabled = true;
        let labelTemplate = categoryAxis.renderer.labels.template;
        labelTemplate.radius = am4core.percent(-60);
        labelTemplate.location = 0.5;
        labelTemplate.relativeRotation = 90;

        var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
        valueAxis.renderer.grid.template.disabled = true;
        valueAxis.renderer.labels.template.disabled = true;
        valueAxis.tooltip.disabled = true;

        var series = chart.series.push(new am4charts.RadarColumnSeries());
        series.sequencedInterpolation = true;
        series.dataFields.valueY = "value";
        series.dataFields.categoryX = "category";
        series.columns.template.strokeWidth = 0;
        series.tooltipText = "{valueY}";
        series.columns.template.radarColumn.cornerRadius = 10;
        series.columns.template.radarColumn.innerCornerRadius = 0;

        series.tooltip.pointerOrientation = "vertical";

        let hoverState = series.columns.template.radarColumn.states.create("hover");
        hoverState.properties.cornerRadius = 0;
        hoverState.properties.fillOpacity = 1;


        series.columns.template.adapter.add("fill", function(fill, target) {
        return chart.colors.getIndex(target.dataItem.index);
        })

        chart.cursor = new am4charts.RadarCursor();
        chart.cursor.innerRadius = am4core.percent(50);
        chart.cursor.lineY.disabled = true;
    });

    /* Taksit Bazında */
    am4core.ready(function() {
        am4core.useTheme(am4themes_animated);

        var chart = am4core.create("chartdiv4", am4charts.PieChart3D);
        chart.hiddenState.properties.opacity = 0;

        chart.legend = new am4charts.Legend();

        chart.data = [
            <cfoutput query="instalmentBased">
                {
                    Taksit: "#INSTALMENT#",
                    Komisyon: #TOTAL#
                }<cfif currentrow neq instalmentBased.recordcount>,</cfif>
            </cfoutput>
        ];

        chart.innerRadius = 100;

        var series = chart.series.push(new am4charts.PieSeries3D());
        series.dataFields.value = "Komisyon";
        series.dataFields.category = "Taksit";
    });

    /* Banka Bazında */
    am4core.ready(function() {
        am4core.useTheme(am4themes_animated);

        var chart = am4core.create("chartdiv5", am4charts.PieChart3D);
        chart.hiddenState.properties.opacity = 0;

        chart.legend = new am4charts.Legend();

        chart.data = [
            <cfoutput query="bankBased">
                {
                    Banka: "#BANK#",
                    Tutar: #TOTAL#
                }<cfif currentrow neq bankBased.recordcount>,</cfif>
            </cfoutput>
        ];

        chart.innerRadius = 100;

        var series = chart.series.push(new am4charts.PieSeries3D());
        series.dataFields.value = "Tutar";
        series.dataFields.category = "Banka";
    });

    /* Gün Bazlı */
    am4core.ready(function() {

        am4core.useTheme(am4themes_animated);

        var chart = am4core.create("chartdiv7", am4charts.PieChart);
        chart.hiddenState.properties.opacity = 0;

        chart.data = [
            <cfoutput query="dayNameBased">
            {
                country:"#WEEKDAY#",
                value:#TOTAL#
            }<cfif dayNameBased.currentrow neq dayNameBased.RecordCount>, </cfif>
            </cfoutput>
        ];

        var series = chart.series.push(new am4charts.PieSeries());
        series.dataFields.value = "value";
        series.dataFields.radiusValue = "value";
        series.dataFields.category = "country";
        series.slices.template.cornerRadius = 10;
        series.colors.step = 3;

        series.hiddenState.properties.endAngle = -90;

        chart.legend = new am4charts.Legend();
    });

    /* Zaman Serisi */
    am4core.ready(function() {

        am4core.useTheme(am4themes_animated);

        var chart = am4core.create("timeSeries", am4charts.XYChart);

        chart.data = [
            <cfoutput query="timeSeries">
                {
                    date: "#STORE_REPORT_DATE#",
                    value: #TOTAL#
                }<cfif timeSeries.currentrow neq timeSeries.RecordCount>, </cfif>
            </cfoutput>
        ];

        var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
        dateAxis.renderer.minGridDistance = 60;

        var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());

        var series = chart.series.push(new am4charts.LineSeries());
        series.dataFields.valueY = "value";
        series.dataFields.dateX = "date";
        series.tooltipText = "{value}"

        series.tooltip.pointerOrientation = "vertical";

        chart.cursor = new am4charts.XYCursor();
        chart.cursor.snapToSeries = series;
        chart.cursor.xAxis = dateAxis;

        chart.scrollbarX = new am4core.Scrollbar();

    });

    /* Tree */
    am4core.ready(function() {

        am4core.useTheme(am4themes_animated);

        var data = {
            <cfoutput query="bankBasedTree">
                <cfif pre eq ACCOUNT_NAME>
                    , "#NUMBER_OF_INSTALMENT#": #TOTAL#
                <cfelse>
                    <cfif bankBasedTree.currentrow eq 1>
                        "#ACCOUNT_NAME#": {"#NUMBER_OF_INSTALMENT#": #TOTAL#
                    <cfelse>
                        }, 
                        "#ACCOUNT_NAME#": {"#NUMBER_OF_INSTALMENT#": #TOTAL#
                    </cfif>
                    <cfset pre = "#ACCOUNT_NAME#">
                </cfif><cfif bankBasedTree.currentrow eq bankBasedTree.RecordCount>}</cfif>
            </cfoutput>
        }

        function processData(data) {
            var treeData = [];

            var smallBrands = { name: "Other", children: [] };

            for (var brand in data) {
                var brandData = { name: brand, children: [] }
                var brandTotal = 0;
                for (var model in data[brand]) {
                    brandTotal += data[brand][model];
                }

                for (var model in data[brand]) {
                    if (data[brand][model] > 0) {
                        brandData.children.push({ name: model, count: data[brand][model] });
                    }
                }

                if (brandTotal > 0) {
                    treeData.push(brandData);
                }
            }

            return treeData;
        }

        var chart = am4core.create("bankBasedTree", am4charts.TreeMap);
        chart.padding(0,0,0,0);
        chart.hiddenState.properties.opacity = 0;

        chart.maxLevels = 2;
        chart.dataFields.value = "count";
        chart.dataFields.name = "name";
        chart.dataFields.children = "children";

        chart.navigationBar = new am4charts.NavigationBar();
        chart.zoomable = false;

        var level0SeriesTemplate = chart.seriesTemplates.create("0");
        level0SeriesTemplate.strokeWidth = 2;

        level0SeriesTemplate.bulletsContainer.hiddenState.properties.opacity = 1;
        level0SeriesTemplate.bulletsContainer.hiddenState.properties.visible = true;

        var columnTemplate = level0SeriesTemplate.columns.template;
        var hoverState = columnTemplate.states.create("hover");

        hoverState.adapter.add("fill", function (fill, target) {
            if (fill instanceof am4core.Color) {
                return am4core.color(am4core.colors.brighten(fill.rgb, -0.2));
            }
            return fill;
        })

        var level1SeriesTemplate = chart.seriesTemplates.create("1");
        level1SeriesTemplate.columns.template.fillOpacity = 0;
        level1SeriesTemplate.columns.template.strokeOpacity = 0.4;

        var bullet1 = level1SeriesTemplate.bullets.push(new am4charts.LabelBullet());
        bullet1.locationX = 0.5;
        bullet1.locationY = 0.5;
        bullet1.label.text = "{name}";
        bullet1.label.fill = am4core.color("#ffffff");
        bullet1.label.fontSize = 9;
        bullet1.label.fillOpacity = 0.7;

        chart.data = processData(data);

    });

    /* Yıl Bazında */
    am4core.ready(function() {

        am4core.useTheme(am4themes_animated);

        var chart = am4core.create("yearBased", am4plugins_timeline.CurveChart);
        chart.curveContainer.padding(0, 100, 0, 120);
        chart.maskBullets = false;

        var colorSet = new am4core.ColorSet();

        chart.data = [
            <cfoutput query="yearBased">
                {
                    "category":"",
                    "year":"#YEAR1#",
                    "size":#TOTAL#,
                    "text":"#YEAR1#"
                }<cfif yearBased.currentrow neq yearBased.RecordCount>, </cfif>
            </cfoutput>
        ];

        chart.dateFormatter.inputDateFormat = "yyyy";

        chart.fontSize = 11;
        chart.tooltipContainer.fontSize = 11;

        var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
        categoryAxis.dataFields.category = "category";
        categoryAxis.renderer.grid.template.disabled = true;

        var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
        dateAxis.renderer.points = [{ x: -400, y: 0 }, { x: 0, y: 50 }, { x: 400, y: 0 }]
        dateAxis.renderer.polyspline.tensionX = 0.8;
        dateAxis.renderer.grid.template.disabled = true;
        dateAxis.renderer.line.strokeDasharray = "1,4";
        dateAxis.baseInterval = {period:"day", count:1};

        dateAxis.renderer.labels.template.disabled = true;

        var series = chart.series.push(new am4plugins_timeline.CurveLineSeries());
        series.strokeOpacity = 0;
        series.dataFields.dateX = "year";
        series.dataFields.categoryY = "category";
        series.dataFields.value = "size";
        series.baseAxis = categoryAxis;

        var interfaceColors = new am4core.InterfaceColorSet();

        series.tooltip.pointerOrientation = "down";

        var distance = 100;
        var angle = 60;

        var bullet = series.bullets.push(new am4charts.Bullet());

        var line = bullet.createChild(am4core.Line);
        line.adapter.add("stroke", function(fill, target) {
        if (target.dataItem) {
            return chart.colors.getIndex(target.dataItem.index)
        }
        });

        line.x1 = 0;
        line.y1 = 0;
        line.y2 = 0;
        line.x2 = distance - 10;
        line.strokeDasharray = "1,3";

        var circle = bullet.createChild(am4core.Circle);
        circle.radius = 30;
        circle.fillOpacity = 1;
        circle.strokeOpacity = 0;

        var circleHoverState = circle.states.create("hover");
        circleHoverState.properties.scale = 1.3;

        series.heatRules.push({ target: circle, min: 20, max: 50, property: "radius" });
        circle.adapter.add("fill", function(fill, target) {
        if (target.dataItem) {
            return chart.colors.getIndex(target.dataItem.index)
        }
        });
        circle.tooltipText = "{text}: {value}";
        circle.adapter.add("tooltipY", function(tooltipY, target){
        return -target.pixelRadius - 4;
        });

        var yearLabel = bullet.createChild(am4core.Label);
        yearLabel.text = "{year}";
        yearLabel.strokeOpacity = 0;
        yearLabel.fill = am4core.color("#fff");
        yearLabel.horizontalCenter = "middle";
        yearLabel.verticalCenter = "middle";
        yearLabel.interactionsEnabled = false;

        var label = bullet.createChild(am4core.Label);
        label.propertyFields.text = "text";
        label.strokeOpacity = 0;
        label.horizontalCenter = "right";
        label.verticalCenter = "middle";

        label.adapter.add("opacity", function(opacity, target) {
        if(target.dataItem){
            var index = target.dataItem.index;
            var line = target.parent.children.getIndex(0);

            if (index % 2 == 0) {
            target.y = -distance * am4core.math.sin(-angle);
            target.x = -distance * am4core.math.cos(-angle);
            line.rotation = -angle - 180;
            target.rotation = -angle;
            }
            else {
            target.y = -distance * am4core.math.sin(angle);
            target.x = -distance * am4core.math.cos(angle);
            line.rotation = angle - 180;
            target.rotation = angle;
            }
        }
        return 1;
        });

        var outerCircle = bullet.createChild(am4core.Circle);
        outerCircle.radius = 30;
        outerCircle.fillOpacity = 0;
        outerCircle.strokeOpacity = 0;
        outerCircle.strokeDasharray = "1,3";

        var hoverState = outerCircle.states.create("hover");
        hoverState.properties.strokeOpacity = 0.8;
        hoverState.properties.scale = 1.5;

        outerCircle.events.on("over", function(event){
        var circle = event.target.parent.children.getIndex(1);
        circle.isHover = true;
        event.target.stroke = circle.fill;
        event.target.radius = circle.pixelRadius;
        event.target.animate({property: "rotation", from: 0, to: 360}, 4000, am4core.ease.sinInOut);
        });

        outerCircle.events.on("out", function(event){
        var circle = event.target.parent.children.getIndex(1);
        circle.isHover = false;
        });

        chart.scrollbarX = new am4core.Scrollbar();
        chart.scrollbarX.opacity = 0.5;
        chart.scrollbarX.width = am4core.percent(50);
        chart.scrollbarX.align = "center";

    });

    /* Şehir Bazında Harita */
    am4core.ready(function() {       
        am4core.useTheme(am4themes_animated);
        
        var chart = am4core.create("cityBased", am4maps.MapChart);
        
        chart.geodata = am4geodata_turkeyHigh;
       
        var polygonSeries = chart.series.push(new am4maps.MapPolygonSeries());
        
        polygonSeries.heatRules.push({
            property: "fill",
            target: polygonSeries.mapPolygons.template,
            min: chart.colors.getIndex(1).brighten(1.8), //Bar rengi Az olan Kısım
            max: chart.colors.getIndex(5).brighten(-0.6) // Bar rengi Çok olan Kısım
        });
        
        polygonSeries.useGeodata = true;
        
        polygonSeries.data = [
            <cfoutput query="get_city_based">
                {
                    id: "TR-#PLATE_CODE#",
                    value: #TOTAL#
                }<cfif get_city_based.currentrow neq get_city_based.RecordCount>, </cfif>
            </cfoutput>
        ];
        
        let heatLegend = chart.createChild(am4maps.HeatLegend);
        heatLegend.series = polygonSeries;
        heatLegend.align = "right";
        heatLegend.valign = "bottom";
        heatLegend.width = am4core.percent(20); //Az-Çok barın uzuluğu
        heatLegend.marginRight = am4core.percent(4); //Az-Çok barın konumu
        heatLegend.minValue = 0;
        heatLegend.maxValue = 40000000;
        
        var minRange = heatLegend.valueAxis.axisRanges.create();
        minRange.value = heatLegend.minValue;
        minRange.label.text = "Az";
        var maxRange = heatLegend.valueAxis.axisRanges.create();
        maxRange.value = heatLegend.maxValue;
        maxRange.label.text = "Çok";
        
        heatLegend.valueAxis.renderer.labels.template.adapter.add("text", function(labelText) {
            return "";
        });
        
        var polygonTemplate = polygonSeries.mapPolygons.template;
        polygonTemplate.tooltipText = "{name}: {value}";
        polygonTemplate.nonScalingStroke = true;
        polygonTemplate.strokeWidth = 0.7; //Şehirlerin sınırlarının kalınlığı
        
        var hs = polygonTemplate.states.create("hover");
        hs.properties.fill = am4core.color("#3c5bdc");
    });
</script>