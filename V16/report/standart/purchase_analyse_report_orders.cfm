<cfparam name="attributes.module_id_control" default="20,12">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.purchase_analyse_report_orders">
<cfparam name="attributes.hierarcy" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.max_rows" default="20">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.total_event" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.is_stock_active" default="1">
<cfparam name="attributes.stock_status_level" default="">
<cfparam name="attributes.date1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.termin_date1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.termin_date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.is_money2" default="0">
<cfparam name="attributes.kdv_dahil" default="">
<cfparam name="attributes.kontrol_type" default="0">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.model_name" default="">
<cfparam name="attributes.model_id" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.order_employee" default="">
<cfparam name="attributes.order_employee_id" default="">
<cfparam name="attributes.order_stage" default="">
<cfparam name="attributes.order_process_cat" default="">
<cfparam name="attributes.is_project" default="">
<cfparam name="attributes.is_spect_info" default="">
<cfparam name="attributes.is_discount" default="0">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.extra_info_type" default="">
<cf_date tarih='attributes.date1'>
<cf_date tarih='attributes.date2'>
<cf_date tarih='attributes.termin_date1'>
<cf_date tarih='attributes.termin_date2'>
<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.form_add_order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_extra_info_type" datasource="#dsn3#">
    SELECT
        BASKET_INFO_TYPE_ID,
        BASKET_INFO_TYPE
    FROM
        SETUP_BASKET_INFO_TYPES
    WHERE
        OPTION_NUMBER IN(2,3) AND
        6 IN (SELECT * FROM #dsn#.fnSplit((BASKET_ID), ','))
    ORDER BY
        BASKET_INFO_TYPE
</cfquery>
<!---tutarlarin yuvarlama sayilari satinalma basket sablonundan aliniyor --->
<cfquery name="getBasketPriceRoundNumber" datasource="#DSN3#">
    SELECT PRICE_ROUND_NUMBER,AMOUNT_ROUND FROM SETUP_BASKET WHERE B_TYPE = 1 AND BASKET_ID = 6
</cfquery>
<cfif getBasketPriceRoundNumber.recordcount>
	<cfset price_round_number = getBasketPriceRoundNumber.PRICE_ROUND_NUMBER>
	<cfset amount_round = getBasketPriceRoundNumber.amount_round>
<cfelse>
	<cfset price_round_number = 2>
    <cfset amount_round = 0>
</cfif>
<cfif attributes.report_type eq 5>
	<cfset project_id_list=''>
	<cfquery name="get_project" datasource="#dsn#">
		SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS
	</cfquery>
	<cfset project_id_list = valuelist(get_project.project_id,',')>
</cfif>
<cfquery name="check_company_risk_type" datasource="#dsn#"><!--- şirkette detaylı risk takibi yapılıyor mu kontrol ediliyor --->
	SELECT ISNULL(IS_DETAILED_RISK_INFO,0) IS_DETAILED_RISK_INFO  FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="get_money" datasource="#dsn#"><!--- Onceki Donemlerin Para Birimleri De Gerektiginden Dsnden Cekiliyor FBS --->
	SELECT MONEY FROM SETUP_MONEY GROUP BY MONEY
</cfquery>
<cfif attributes.report_type eq 5>
	<cfset stage_list_name_id=''>
	<cfoutput query="get_process_type">
		<cfset stage_list_name_id=listappend(stage_list_name_id,get_process_type.PROCESS_ROW_ID,',')>
		<cfset stage_list_name_id=listappend(stage_list_name_id,get_process_type.STAGE,',')>
	</cfoutput>
</cfif>	 
<cfif len(attributes.department_id)>
    <cfquery name="check_table" datasource="#dsn3#">
        IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME='####parodept_gtp2_#session.ep.userid#')
        DROP TABLE ####parodept_gtp2_#session.ep.userid#
    </cfquery>
    <cfquery name="CREATE_TABLE_DEPT" datasource="#dsn3#">
        CREATE TABLE ####parodept_gtp2_#session.ep.userid# (DEPT_ID INT,LOC_ID INT)
    </cfquery>
    <cfquery name="SET_TABLE_DEPT" datasource="#dsn3#">
        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
            INSERT INTO ####parodept_gtp2_#session.ep.userid# (DEPT_ID,LOC_ID) VALUES (#listfirst(dept_i,'-')#,#listlast(dept_i,'-')#)
        </cfloop>
    </cfquery>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfif attributes.report_type eq 5>
        <cfquery name="check_table_1" datasource="#dsn3#">
            IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME='####TMP_DLVR_AMNT_#session.ep.userid#')
            DROP TABLE ####TMP_DLVR_AMNT_#session.ep.userid#
        </cfquery>
        <cfquery name="check_table_2" datasource="#dsn3#">
            IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME='####TMP_DLVR_AMNT_1_#session.ep.userid#')
            DROP TABLE ####TMP_DLVR_AMNT_1_#session.ep.userid#
        </cfquery>
        <cfquery name="Get_All_Ship_Dept" datasource="#dsn3#">
            SELECT * INTO ####TMP_DLVR_AMNT_#session.ep.userid# FROM GET_ALL_SHIP_ROW SR
        </cfquery>
        <cfquery name="Get_All_Invoice_Dept" datasource="#dsn3#">
            SELECT * INTO ####TMP_DLVR_AMNT_1_#session.ep.userid# FROM GET_ALL_INVOICE_ROW SR
        </cfquery>
        <cfquery name="Create_Ship_Dept" datasource="#dsn3#">
            CREATE CLUSTERED INDEX TMP_DLVR_AMNT ON  ####TMP_DLVR_AMNT_#session.ep.userid# (WRK_ROW_RELATION_ID)
        </cfquery>
        <cfquery name="Create_Invoice_Dept" datasource="#dsn3#">
            CREATE CLUSTERED INDEX TMP_DLVR_AMNT1 ON ####TMP_DLVR_AMNT_1_#session.ep.userid# (WRK_ROW_RELATION_ID)
        </cfquery>
    </cfif>    
    <cfquery name="get_total_purchase_2"  datasource="#DSN3#">
        SELECT
            DISTINCT
            <cfif attributes.is_money2 eq 1>
                <cfif attributes.report_type eq 3>
                    SUM(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>) AS PRICE,
                    SUM((((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>)/OM.RATE2) AS PRICE_DOVIZ,
                <cfelse>
                    <cfif attributes.is_discount eq 1>
                        ISNULL(SUM((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE)-((ORD_ROW.QUANTITY*PU.MULTIPLIER*(ORD_ROW.PRICE-ORD_ROW.DISCOUNT_COST))*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5)*(100-ORD_ROW.DISCOUNT_6)*(100-ORD_ROW.DISCOUNT_7)*(100-ORD_ROW.DISCOUNT_8)*(100-ORD_ROW.DISCOUNT_9)*(100-ORD_ROW.DISCOUNT_10)/100000000000000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE)-(ORD_ROW.QUANTITY*PU.MULTIPLIER*(ORD_ROW.PRICE-ORD_ROW.DISCOUNT_COST)))*((100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5)*(100-ORD_ROW.DISCOUNT_6)*(100-ORD_ROW.DISCOUNT_7)*(100-ORD_ROW.DISCOUNT_8)*(100-ORD_ROW.DISCOUNT_9)*(100-ORD_ROW.DISCOUNT_10)/100000000000000000000)*ORD_ROW.TAX/100)</cfif>),0) AS PRICE,
                    <cfelse>
                        SUM(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>) AS PRICE,
                    </cfif>
                    SUM((((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>)/OM.RATE2) AS PRICE_DOVIZ,			
                </cfif>
            <cfelse>
                <cfif attributes.report_type eq 3>
                    SUM(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>) AS PRICE,
                <cfelse>
                    <cfif attributes.is_discount eq 1>
                        ISNULL(SUM((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE)-((ORD_ROW.QUANTITY*PU.MULTIPLIER*(ORD_ROW.PRICE-ORD_ROW.DISCOUNT_COST))*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5)*(100-ORD_ROW.DISCOUNT_6)*(100-ORD_ROW.DISCOUNT_7)*(100-ORD_ROW.DISCOUNT_8)*(100-ORD_ROW.DISCOUNT_9)*(100-ORD_ROW.DISCOUNT_10)/100000000000000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE)-(ORD_ROW.QUANTITY*PU.MULTIPLIER*(ORD_ROW.PRICE-ORD_ROW.DISCOUNT_COST)))*((100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5)*(100-ORD_ROW.DISCOUNT_6)*(100-ORD_ROW.DISCOUNT_7)*(100-ORD_ROW.DISCOUNT_8)*(100-ORD_ROW.DISCOUNT_9)*(100-ORD_ROW.DISCOUNT_10)/100000000000000000000)*ORD_ROW.TAX/100)</cfif>),0) AS PRICE,
                    <cfelse>
                        SUM(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>) AS PRICE,
                    </cfif>
                </cfif>
            </cfif>
            ORDERS.ORDER_ID,
            ORD_ROW.PRODUCT_ID,
            ORD_ROW.STOCK_ID,
            <cfif attributes.report_type eq 1>
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID,
                ORD_ROW.WRK_ROW_ID,
                SUM(ORD_ROW.QUANTITY*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) DELIVER_AMOUNT
                ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 2>
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID
                ,P.PRODUCT_ID
                ,P.PRODUCT_NAME
                ,P.BARCOD
                ,P.PRODUCT_CODE
                ,SUM(ORD_ROW.QUANTITY*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,PU.MAIN_UNIT AS BIRIM
                ,ORD_ROW.WRK_ROW_ID
                ,((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) DELIVER_AMOUNT
                ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 3>
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID
                ,P.PRODUCT_ID
                ,P.PRODUCT_NAME
                ,S.BARCOD
                ,S.STOCK_CODE
                ,S.PROPERTY
                ,ORD_ROW.STOCK_ID
                ,SUM(ORD_ROW.QUANTITY) AS PRODUCT_STOCK
                ,ORD_ROW.UNIT AS BIRIM
                ,((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) DELIVER_AMOUNT
            ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 4>
                1 MEMBER_TYPE,
                C.NICKNAME,
                C.COMPANY_ID
                ,SUM(ORD_ROW.QUANTITY*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) DELIVER_AMOUNT
                ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 5>
                ORD_ROW.PRICE BIRIM_FIYAT,
                ORD_ROW.PRICE_OTHER BIRIM_FIYAT_OTHER,
                ORD_ROW.OTHER_MONEY_VALUE,
                ORD_ROW.OTHER_MONEY,
                ORD_ROW.ORDER_ROW_CURRENCY,
                ORD_ROW.ROW_PROJECT_ID,
                ORD_ROW.NETTOTAL,
                ORD_ROW.PRODUCT_NAME2,
                ORD_ROW.QUANTITY,
                ORD_ROW.DISCOUNT_COST,
                ORDERS.ORDER_NUMBER,
                ORDERS.PROJECT_ID,
                C.NICKNAME AS MUSTERI,
                1 MEMBER_TYPE,
                C.COMPANY_ID,
                ORDERS.ORDER_DATE,
                ISNULL(ORD_ROW.DELIVER_DATE,ORDERS.DELIVERDATE) DELIVERDATE,
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID,
                P.PRODUCT_NAME,
                S.PROPERTY,
                S.STOCK_CODE,
                P.MANUFACT_CODE,
                SUM(ORD_ROW.QUANTITY*PU.MULTIPLIER) AS PRODUCT_STOCK,
                ORD_ROW.UNIT AS BIRIM,
                ORDERS.ORDER_STAGE,
                ORDERS.ORDER_HEAD,
                CAST(ORDERS.ORDER_DETAIL AS VARCHAR(200)) AS ORDER_DETAIL,
                ORDERS.PAYMETHOD,
                ORDERS.CARD_PAYMETHOD_ID,
                DELIVER_DEPT_ID,
                LOCATION_ID,
                ORD_ROW.WRK_ROW_ID,
                ORD_ROW.SPECT_VAR_NAME,
                (SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = ORD_ROW.SPECT_VAR_ID) AS SPECT_MAIN_ID,
                ((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM ####TMP_DLVR_AMNT_#session.ep.userid# SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM ####TMP_DLVR_AMNT_1_#session.ep.userid# SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) AS DELIVER_AMOUNT
                ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM ####TMP_DLVR_AMNT_#session.ep.userid# SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM ####TMP_DLVR_AMNT_1_#session.ep.userid# SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            </cfif>
        FROM
            ORDERS <cfif len(attributes.department_id)> JOIN ####parodept_gtp2_#session.ep.userid# AS DEPT ON DEPT.DEPT_ID = ORDERS.DELIVER_DEPT_ID AND DEPT.LOC_ID = ORDERS.LOCATION_ID</cfif>,
            ORDER_ROW ORD_ROW	
            ,STOCKS S,
            PRODUCT_CAT PC,
            PRODUCT P,
            PRODUCT_UNIT PU
            <cfif attributes.report_type eq 4 or attributes.report_type eq 5>
                ,#dsn_alias#.COMPANY C
            </cfif>			
            <cfif attributes.is_money2 eq 1>
                ,ORDER_MONEY OM
            </cfif>

        WHERE
            <cfif len(attributes.project_id) and len(attributes.project_head)>
                ORDERS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
            </cfif>
            <cfif attributes.is_money2 eq 1>
                OM.ACTION_ID = ORDERS.ORDER_ID AND 
                OM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND 
            </cfif>
            <cfif isDefined("attributes.status") and len(attributes.status)>
                ORDERS.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#"> AND
            </cfif>
            ORDERS.PURCHASE_SALES = 0 AND
            ORDERS.ORDER_ZONE = 0 AND 	
            PC.PRODUCT_CATID = P.PRODUCT_CATID AND	
            S.PRODUCT_ID = P.PRODUCT_ID AND	
            ORD_ROW.STOCK_ID = S.STOCK_ID AND	
            ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND	
            ORDERS.ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
            <cfif len(attributes.termin_date1)>ORDERS.DELIVERDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.termin_date1#"> AND</cfif>
            <cfif len(attributes.termin_date2)>ORDERS.DELIVERDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.termin_date2#"> AND</cfif>
            PU.PRODUCT_ID = P.PRODUCT_ID AND	
            S.PRODUCT_ID = ORD_ROW.PRODUCT_ID AND 
            PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID		
            <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
            <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
            <cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
            <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
            <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
            <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND P.BRAND_ID IN (#attributes.brand_id#)</cfif>
            <cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND P.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
            <cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
                AND ORDERS.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
            </cfif>
            <cfif len(trim(attributes.order_employee)) and len(attributes.order_employee_id)>AND ORDERS.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_employee_id#"></cfif>
            <cfif len(attributes.order_stage)>
                AND ORD_ROW.ORDER_ROW_CURRENCY IN (#attributes.order_stage#)
            </cfif>
            <cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
                AND ORDERS.PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
            <cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
                AND ORDERS.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
            </cfif>
            <!---
            <cfif len(attributes.department_id)>
                AND(
                <!--- queryparam eklemeyiniz. Loop query'den çok fazla kayit geldiginde CF max queryparam sayisi 2100'u asabiliyor. Hata veriyordu. EY 20140810 --->
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                    (ORDERS.DELIVER_DEPT_ID = #listfirst(dept_i,'-')# AND ORDERS.LOCATION_ID = #listlast(dept_i,'-')#)
                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
                    )
            </cfif>	
            --->
            <cfif attributes.report_type eq 4 or attributes.report_type eq 5>
                AND ORDERS.COMPANY_ID = C.COMPANY_ID
            </cfif>
            <cfif len(attributes.order_process_cat)>
                AND ORDERS.ORDER_STAGE IN (#attributes.order_process_cat#)
            </cfif>
            <cfif isDefined('attributes.extra_info_type') And len(attributes.extra_info_type)>
                AND ORD_ROW.SELECT_INFO_EXTRA = #attributes.extra_info_type#
            </cfif>
        GROUP  BY
            ORDERS.ORDER_ID,
            ORD_ROW.PRODUCT_ID,
            ORD_ROW.STOCK_ID,
            <cfif attributes.report_type eq 1>
                PC.PRODUCT_CAT,
                PC.PRODUCT_CATID,			
                PC.HIERARCHY
                ,ORD_ROW.WRK_ROW_ID
            <cfelseif attributes.report_type eq 2>
                PC.PRODUCT_CAT,
                PC.PRODUCT_CATID,			
                PC.HIERARCHY
                ,P.PRODUCT_ID
                ,P.BARCOD
                ,P.PRODUCT_NAME
                ,P.PRODUCT_CODE
                ,ORD_ROW.PRODUCT_ID
                ,PU.MAIN_UNIT
                ,ORD_ROW.WRK_ROW_ID
            <cfelseif attributes.report_type eq 3>
                PC.PRODUCT_CAT,
                PC.PRODUCT_CATID,			
                PC.HIERARCHY
                ,ORD_ROW.UNIT 
                ,ORD_ROW.STOCK_ID
                ,P.PRODUCT_NAME
                ,S.STOCK_CODE
                ,P.PRODUCT_ID
                ,S.PROPERTY
                ,S.BARCOD
                ,ORD_ROW.WRK_ROW_ID
            <cfelseif attributes.report_type eq 4>
                C.NICKNAME,
                C.COMPANY_ID
                ,ORD_ROW.WRK_ROW_ID
            <cfelseif attributes.report_type eq 5>
                ORD_ROW.PRICE,
                ORD_ROW.PRICE_OTHER,
                ORD_ROW.OTHER_MONEY_VALUE,
                ORD_ROW.OTHER_MONEY,
                ORD_ROW.ORDER_ROW_CURRENCY,
                ORD_ROW.ROW_PROJECT_ID,
                ORD_ROW.NETTOTAL,
                ORD_ROW.PRODUCT_NAME2,
                ORD_ROW.QUANTITY,
                ORD_ROW.DISCOUNT_COST,
                ORDERS.ORDER_NUMBER,
                ORDERS.PROJECT_ID,
                C.NICKNAME,
                C.COMPANY_ID,
                ORDERS.ORDER_DATE,
                ISNULL(ORD_ROW.DELIVER_DATE,ORDERS.DELIVERDATE),
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID,
                P.PRODUCT_NAME,
                S.PROPERTY,
                S.STOCK_CODE,
                P.MANUFACT_CODE,
                ORD_ROW.UNIT,
                ORDERS.ORDER_STAGE,
                ORDERS.ORDER_HEAD,
                CAST(ORDERS.ORDER_DETAIL AS VARCHAR(200)),
                ORDERS.PAYMETHOD,
                ORDERS.CARD_PAYMETHOD_ID,
                DELIVER_DEPT_ID,
                LOCATION_ID,
                ORD_ROW.SPECT_VAR_NAME,
                ORD_ROW.SPECT_VAR_ID,
                ORD_ROW.WRK_ROW_ID
            </cfif>
        UNION <!--- ALL --->
            SELECT DISTINCT
            <cfif attributes.is_money2 eq 1>
                <cfif attributes.report_type eq 3>
                    SUM(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>) AS PRICE,
                    SUM((((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>)/OM.RATE2) AS PRICE_DOVIZ,
                <cfelse>
                    <cfif attributes.is_discount eq 1>
                        ISNULL(SUM((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE)-((ORD_ROW.QUANTITY*PU.MULTIPLIER*(ORD_ROW.PRICE-ORD_ROW.DISCOUNT_COST))*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5)*(100-ORD_ROW.DISCOUNT_6)*(100-ORD_ROW.DISCOUNT_7)*(100-ORD_ROW.DISCOUNT_8)*(100-ORD_ROW.DISCOUNT_9)*(100-ORD_ROW.DISCOUNT_10)/100000000000000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE)-(ORD_ROW.QUANTITY*PU.MULTIPLIER*(ORD_ROW.PRICE-ORD_ROW.DISCOUNT_COST)))*((100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5)*(100-ORD_ROW.DISCOUNT_6)*(100-ORD_ROW.DISCOUNT_7)*(100-ORD_ROW.DISCOUNT_8)*(100-ORD_ROW.DISCOUNT_9)*(100-ORD_ROW.DISCOUNT_10)/100000000000000000000)*ORD_ROW.TAX/100)</cfif>),0) AS PRICE,
                    <cfelse>
                        SUM(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>) AS PRICE,
                    </cfif>
                    SUM((((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>)/OM.RATE2) AS PRICE_DOVIZ,			
                </cfif>
            <cfelse>
                <cfif attributes.report_type eq 3>
                    SUM(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>) AS PRICE,
                <cfelse>
                    <cfif attributes.is_discount eq 1>
                        ISNULL(SUM((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE)-((ORD_ROW.QUANTITY*PU.MULTIPLIER*(ORD_ROW.PRICE-ORD_ROW.DISCOUNT_COST))*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5)*(100-ORD_ROW.DISCOUNT_6)*(100-ORD_ROW.DISCOUNT_7)*(100-ORD_ROW.DISCOUNT_8)*(100-ORD_ROW.DISCOUNT_9)*(100-ORD_ROW.DISCOUNT_10)/100000000000000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE)-(ORD_ROW.QUANTITY*PU.MULTIPLIER*(ORD_ROW.PRICE-ORD_ROW.DISCOUNT_COST)))*((100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5)*(100-ORD_ROW.DISCOUNT_6)*(100-ORD_ROW.DISCOUNT_7)*(100-ORD_ROW.DISCOUNT_8)*(100-ORD_ROW.DISCOUNT_9)*(100-ORD_ROW.DISCOUNT_10)/100000000000000000000)*ORD_ROW.TAX/100)</cfif>),0) AS PRICE,
                    <cfelse>
                        SUM(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((ORD_ROW.QUANTITY*PU.MULTIPLIER*ORD_ROW.PRICE*(100-ORD_ROW.DISCOUNT_1)*(100-ORD_ROW.DISCOUNT_2)*(100-ORD_ROW.DISCOUNT_3)*(100-ORD_ROW.DISCOUNT_4)*(100-ORD_ROW.DISCOUNT_5))/10000000000)*ORD_ROW.TAX/100)</cfif>) AS PRICE,
                    </cfif>            
                </cfif>
            </cfif>
            ORDERS.ORDER_ID,
            ORD_ROW.PRODUCT_ID,
            ORD_ROW.STOCK_ID,
            <cfif attributes.report_type eq 1>
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID,
                ORD_ROW.WRK_ROW_ID,
                SUM(ORD_ROW.QUANTITY*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) DELIVER_AMOUNT
                ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 2>
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID
                ,P.PRODUCT_ID
                ,P.PRODUCT_NAME
                ,P.BARCOD
                ,P.PRODUCT_CODE
                ,SUM(ORD_ROW.QUANTITY*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,PU.MAIN_UNIT AS BIRIM,
                ORD_ROW.WRK_ROW_ID
                ,((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) DELIVER_AMOUNT
                ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 3>
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID
                ,P.PRODUCT_ID
                ,P.PRODUCT_NAME
                ,S.BARCOD
                ,S.STOCK_CODE
                ,S.PROPERTY
                ,ORD_ROW.STOCK_ID
                ,SUM(ORD_ROW.QUANTITY) AS PRODUCT_STOCK
                ,ORD_ROW.UNIT AS BIRIM
                ,((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) DELIVER_AMOUNT
                ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 4>
                2 MEMBER_TYPE,
                C.CONSUMER_NAME +' '+ C.CONSUMER_SURNAME AS NICKNAME,
                C.CONSUMER_ID COMPANY_ID
                ,SUM(ORD_ROW.QUANTITY*PU.MULTIPLIER) AS PRODUCT_STOCK	
                ,((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) DELIVER_AMOUNT
                ,((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 5>
                ORD_ROW.PRICE BIRIM_FIYAT,
                ORD_ROW.PRICE_OTHER BIRIM_FIYAT_OTHER,
                ORD_ROW.OTHER_MONEY_VALUE,
                ORD_ROW.OTHER_MONEY,
                ORD_ROW.ORDER_ROW_CURRENCY,
                ORD_ROW.ROW_PROJECT_ID,
                ORD_ROW.NETTOTAL,
                ORD_ROW.PRODUCT_NAME2,
                ORD_ROW.QUANTITY,
                ORD_ROW.DISCOUNT_COST,
                ORDERS.ORDER_NUMBER,
                ORDERS.PROJECT_ID,
                C.CONSUMER_NAME +' '+ C.CONSUMER_SURNAME AS MUSTERI,
                2 MEMBER_TYPE,
                C.CONSUMER_ID COMPANY_ID,
                ORDERS.ORDER_DATE,
                ISNULL(ORD_ROW.DELIVER_DATE,ORDERS.DELIVERDATE) DELIVERDATE,
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID,
                P.PRODUCT_NAME,
                S.PROPERTY,
                S.STOCK_CODE,
                P.MANUFACT_CODE,
                SUM(ORD_ROW.QUANTITY*PU.MULTIPLIER) AS PRODUCT_STOCK,
                ORD_ROW.UNIT AS BIRIM,
                ORDERS.ORDER_STAGE,
                ORDERS.ORDER_HEAD,
                CAST(ORDERS.ORDER_DETAIL AS VARCHAR(200)) AS ORDER_DETAIL,
                ORDERS.PAYMETHOD,
                ORDERS.CARD_PAYMETHOD_ID,
                DELIVER_DEPT_ID,
                LOCATION_ID,
                ORD_ROW.WRK_ROW_ID,
                ORD_ROW.SPECT_VAR_NAME,
                (SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = ORD_ROW.SPECT_VAR_ID) AS SPECT_MAIN_ID,
                ((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM ####TMP_DLVR_AMNT_#session.ep.userid# SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM ####TMP_DLVR_AMNT_1_#session.ep.userid# SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) AS DELIVER_AMOUNT,
                ((SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM ####TMP_DLVR_AMNT_#session.ep.userid# SR LEFT JOIN #dsn3_alias#.GET_ALL_SHIP_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR2.AMOUNT),0) FROM ####TMP_DLVR_AMNT_1_#session.ep.userid# SR LEFT JOIN #dsn3_alias#.GET_ALL_INVOICE_ROW SR2 ON SR2.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)) RETURN_DELIVER_AMOUNT
            </cfif>
        FROM
            ORDERS <cfif len(attributes.department_id)> JOIN ####parodept_gtp2_#session.ep.userid# AS DEPT ON DEPT.DEPT_ID = ORDERS.DELIVER_DEPT_ID AND DEPT.LOC_ID = ORDERS.LOCATION_ID</cfif>,
            ORDER_ROW ORD_ROW,		
            STOCKS S,
            PRODUCT_CAT PC,
            PRODUCT P,
            PRODUCT_UNIT PU
            <cfif attributes.report_type eq 4 or attributes.report_type eq 5>
                ,#dsn_alias#.CONSUMER C
            </cfif>			
            <cfif attributes.is_money2 eq 1>
                ,ORDER_MONEY OM
            </cfif>
        WHERE
            <cfif len(attributes.project_id) and len(attributes.project_head)>
                ORDERS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
            </cfif>
            <cfif attributes.is_money2 eq 1>
                OM.ACTION_ID = ORDERS.ORDER_ID AND 
                OM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND 
            </cfif>
            <cfif isDefined("attributes.status") and len(attributes.status)>
                ORDERS.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#"> AND
            </cfif>
            ORDERS.PURCHASE_SALES = 0 AND
            ORDERS.ORDER_ZONE = 0 AND 	
            PC.PRODUCT_CATID = P.PRODUCT_CATID AND	
            S.PRODUCT_ID = P.PRODUCT_ID AND	
            ORD_ROW.STOCK_ID = S.STOCK_ID AND	
            ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND	
            ORDERS.ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
            <cfif len(attributes.termin_date1)>ORDERS.DELIVERDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.termin_date1#"> AND</cfif>
            <cfif len(attributes.termin_date2)>ORDERS.DELIVERDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.termin_date2#"> AND</cfif>
            PU.PRODUCT_ID = P.PRODUCT_ID AND	
            S.PRODUCT_ID = ORD_ROW.PRODUCT_ID AND 
            PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID		
            <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
            <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
            <cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
            <cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
            <cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
            <cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND P.BRAND_ID IN (#attributes.brand_id#)</cfif>
            <cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND P.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
            <cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
                AND ORDERS.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
            </cfif>
            <cfif len(trim(attributes.order_employee)) and len(attributes.order_employee_id)>AND ORDERS.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_employee_id#"></cfif>
            <cfif len(attributes.order_stage)>
                AND ORD_ROW.ORDER_ROW_CURRENCY IN (#attributes.order_stage#)
            </cfif>
            <cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
                AND ORDERS.PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
            <cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
                AND ORDERS.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
            </cfif>
            <!---
            <cfif len(attributes.department_id)>
                AND(
                <!--- queryparam eklemeyiniz. Loop query'den çok fazla kayit geldiginde CF max queryparam sayisi 2100'u asabiliyor. Hata veriyordu. EY 20140810 --->
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                    (ORDERS.DELIVER_DEPT_ID = #listfirst(dept_i,'-')# AND ORDERS.LOCATION_ID = #listlast(dept_i,'-')#)
                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
                    )
            </cfif>	
            --->
            <cfif attributes.report_type eq 4 or attributes.report_type eq 5>
                AND ORDERS.CONSUMER_ID = C.CONSUMER_ID
            </cfif>
            <cfif len(attributes.order_process_cat)>
                AND ORDERS.ORDER_STAGE IN (#attributes.order_process_cat#)
            </cfif>	
        GROUP  BY
            ORDERS.ORDER_ID,
            ORD_ROW.PRODUCT_ID,
            ORD_ROW.STOCK_ID,
            <cfif attributes.report_type eq 1>
                PC.PRODUCT_CAT,
                PC.PRODUCT_CATID,			
                PC.HIERARCHY
                ,ORD_ROW.WRK_ROW_ID
        <cfelseif attributes.report_type eq 2>
                PC.PRODUCT_CAT,
                PC.PRODUCT_CATID,			
                PC.HIERARCHY
                ,P.PRODUCT_ID
                ,P.BARCOD
                ,P.PRODUCT_NAME
                ,P.PRODUCT_CODE
                ,ORD_ROW.PRODUCT_ID
                ,PU.MAIN_UNIT
                ,ORD_ROW.WRK_ROW_ID
            <cfelseif attributes.report_type eq 3>
                PC.PRODUCT_CAT,
                PC.PRODUCT_CATID,			
                PC.HIERARCHY
                ,ORD_ROW.UNIT 
                ,ORD_ROW.STOCK_ID
                ,P.PRODUCT_NAME
                ,S.STOCK_CODE
                ,P.PRODUCT_ID
                ,S.PROPERTY
                ,S.BARCOD
                ,ORD_ROW.WRK_ROW_ID
            <cfelseif attributes.report_type eq 4>
                C.CONSUMER_NAME,C.CONSUMER_SURNAME,
                C.CONSUMER_ID
                ,ORD_ROW.WRK_ROW_ID
            <cfelseif attributes.report_type eq 5>
                ORD_ROW.PRICE,
                ORD_ROW.PRICE_OTHER,
                ORD_ROW.OTHER_MONEY_VALUE,
                ORD_ROW.OTHER_MONEY,
                ORD_ROW.ORDER_ROW_CURRENCY,
                ORD_ROW.ROW_PROJECT_ID,
                ORD_ROW.NETTOTAL,
                ORD_ROW.PRODUCT_NAME2,
                ORD_ROW.QUANTITY,
                ORD_ROW.DISCOUNT_COST,
                ORDERS.ORDER_NUMBER,
                ORDERS.PROJECT_ID,
                C.CONSUMER_NAME,C.CONSUMER_SURNAME,
                C.CONSUMER_ID,
                ORDERS.ORDER_DATE,
                ISNULL(ORD_ROW.DELIVER_DATE,ORDERS.DELIVERDATE),
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PC.PRODUCT_CATID,
                P.PRODUCT_NAME,
                S.PROPERTY,
                S.STOCK_CODE,
                P.MANUFACT_CODE,
                ORD_ROW.UNIT,
                ORDERS.ORDER_STAGE,
                ORDERS.ORDER_HEAD,
                CAST(ORDERS.ORDER_DETAIL AS VARCHAR(200)),
                ORDERS.PAYMETHOD,
                ORDERS.CARD_PAYMETHOD_ID,
                DELIVER_DEPT_ID,
                LOCATION_ID,
                ORD_ROW.SPECT_VAR_NAME,
                ORD_ROW.SPECT_VAR_ID,
                ORD_ROW.WRK_ROW_ID
            </cfif>
    </cfquery>
    <cfquery name="get_total_purchase" dbtype="query">
        SELECT
            <cfif attributes.is_money2 eq 1>
                SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
            </cfif>
            SUM(PRICE) AS PRICE
            <cfif attributes.report_type eq 1>
            ,PRODUCT_CAT,PRODUCT_CATID,HIERARCHY,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(DELIVER_AMOUNT) AS DELIVER_AMOUNT, SUM(RETURN_DELIVER_AMOUNT) AS RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 2>
            ,PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,BARCOD,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(DELIVER_AMOUNT) AS DELIVER_AMOUNT, SUM(RETURN_DELIVER_AMOUNT) AS RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 3>
            ,PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,BARCOD
            ,PROPERTY,STOCK_ID,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(DELIVER_AMOUNT) AS DELIVER_AMOUNT, SUM(RETURN_DELIVER_AMOUNT) AS RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 4>
            ,MEMBER_TYPE
            ,NICKNAME,COMPANY_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(DELIVER_AMOUNT) AS DELIVER_AMOUNT, SUM(RETURN_DELIVER_AMOUNT) AS RETURN_DELIVER_AMOUNT
            <cfelseif attributes.report_type eq 5>
            ,MEMBER_TYPE
            ,BIRIM_FIYAT,BIRIM_FIYAT_OTHER,OTHER_MONEY_VALUE,OTHER_MONEY,ORDER_ROW_CURRENCY,ORDER_ID,ORDER_NUMBER,MUSTERI,COMPANY_ID,ORDER_DATE,DELIVERDATE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,PRODUCT_NAME,PROPERTY,STOCK_CODE,MANUFACT_CODE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,BIRIM,ORDER_STAGE,ORDER_HEAD,ORDER_DETAIL,PAYMETHOD,CARD_PAYMETHOD_ID,DELIVER_DEPT_ID,LOCATION_ID,WRK_ROW_ID,DELIVER_AMOUNT,PROJECT_ID,ROW_PROJECT_ID,NETTOTAL,PRODUCT_NAME2,QUANTITY,SPECT_VAR_NAME,SPECT_MAIN_ID
            ,SUM(DELIVER_AMOUNT) AS DELIVER_AMOUNT
            ,SUM(RETURN_DELIVER_AMOUNT) AS RETURN_DELIVER_AMOUNT
            </cfif>	
        FROM 
            get_total_purchase_2
        GROUP BY 
            <cfif attributes.report_type eq 1>
                PRODUCT_CAT,HIERARCHY,PRODUCT_CATID
            <cfelseif attributes.report_type eq 2>
                PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,BIRIM,BARCOD
            <cfelseif attributes.report_type eq 3>
                PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,PROPERTY,STOCK_ID,BIRIM,BARCOD
            <cfelseif attributes.report_type eq 4>
                MEMBER_TYPE,
                NICKNAME,COMPANY_ID
            <cfelseif attributes.report_type eq 5>
                BIRIM_FIYAT,
                BIRIM_FIYAT_OTHER,
                OTHER_MONEY_VALUE,
                OTHER_MONEY,
                ORDER_ROW_CURRENCY,
                ORDER_NUMBER,
                ORDER_ID,
                MUSTERI,
                MEMBER_TYPE,
                COMPANY_ID,
                ORDER_DATE,
                DELIVERDATE,
                PRODUCT_CAT,
                HIERARCHY,
                PRODUCT_CATID,
                PRODUCT_ID,
                STOCK_ID,
                PRODUCT_NAME,
                PROPERTY,
                STOCK_CODE,
                MANUFACT_CODE,
                BIRIM,
                ORDER_STAGE,
                ORDER_HEAD,
                ORDER_DETAIL,
                PAYMETHOD,
                CARD_PAYMETHOD_ID,
                DELIVER_DEPT_ID,
                LOCATION_ID,
                WRK_ROW_ID,
                DELIVER_AMOUNT,
                PROJECT_ID,
                ROW_PROJECT_ID,
                NETTOTAL,
                PRODUCT_NAME2,
                QUANTITY,
                SPECT_VAR_NAME,
                SPECT_MAIN_ID
            </cfif>	
        ORDER  BY 
        <cfif attributes.kontrol_type eq 1>
            ORDER_NUMBER
        <cfelseif attributes.report_sort eq 1>
            PRICE DESC
        <cfelse>
            <cfif attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 4>
                PRODUCT_STOCK DESC
            <cfelseif attributes.report_type eq 3 or attributes.report_type eq 5>
                STOCK_CODE DESC
            <cfelse>
                PRODUCT_CAT, PRICE DESC
            </cfif>				
        </cfif>
    </cfquery>

    <!--- ön tarafta order_id ler kullanılıyo --->
    <cfquery name="get_total_purchase_3" dbtype="query">
        SELECT
            ORDER_ID,
            PRODUCT_ID,
            STOCK_ID
        FROM
            get_total_purchase_2
        GROUP BY
            ORDER_ID,
            PRODUCT_ID,
            STOCK_ID
    </cfquery>
    <cfquery name="get_all_total" dbtype="query">
        SELECT SUM(PRICE) AS PRICE FROM get_total_purchase
    </cfquery>
    <cfif len(get_all_total.PRICE)>
        <cfset butun_toplam=get_all_total.PRICE>
    <cfelse>
        <cfset butun_toplam=1>
    </cfif>	
</cfif>
<cfset toplam_satis=0>
<cfset toplam_net_fiyat=0>
<cfset toplam_kalan_tutar=0>
<cfset toplam_isk_tutar=0>
<cfset toplam_doviz=0>
<cfset toplam_miktar=0>
<cfset toplam_gelen_miktar=0>
<cfset toplam_kalan_miktar=0>
<cfoutput query="get_money">
	<cfset "toplam_#money#" = 0>
</cfoutput>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='39073.Alış Analiz Sipariş'></cfsavecontent>
<cf_report_list_search id="analyse_report_orders_" title="#title#">
	<cf_report_list_search_area>
        <cfform name="rapor" method="post" action="#request.self#?fuseaction=report.purchase_analyse_report_orders">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <div class="row">
        		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            		<div class="row formContent">
                		<div class="row" type="row">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="input-group">
										<cf_wrk_product_cat form_name='rapor' hierarchy_code='search_product_catid' product_cat_name='product_cat'>
                                        <input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.search_product_catid#</cfoutput></cfif>">
                                        <input type="text" name="product_cat" id="product_cat" style="width:160px;" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onkeyup="get_product_cat();">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.search_product_catid&field_name=rapor.product_cat</cfoutput>');"></span>
									</div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.product_employee_id#</cfoutput></cfif>">
                                        <input type="text" name="employee_name" id="employee_name" style="width:160px;" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.product_employee_id&field_name=rapor.employee_name&select_list=1,9','list')"></span>
									</div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58796.Sipariş Veren'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="order_employee_id" id="order_employee_id" value="<cfoutput>#attributes.order_employee_id#</cfoutput>">
                                        <input type="text" name="order_employee" id="order_employee" value="<cfoutput>#attributes.order_employee#</cfoutput>" style="width:160px;" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','135')">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.order_employee_id&field_name=rapor.order_employee&select_list=1&branch_related','list','popup_list_positions')"></span>
									</div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfoutput>#attributes.card_paymethod_id#</cfoutput>">
                                        <input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfoutput>#attributes.payment_type_id#</cfoutput>">
                                        <input type="text" name="payment_type" id="payment_type" value="<cfoutput>#attributes.payment_type#</cfoutput>" style="width:160px;" onfocus="AutoComplete_Create('payment_type','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMETHOD_ID,PAYMENT_TYPE_ID','payment_type_id,card_paymethod_id','','3','200');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=rapor.payment_type_id&field_name=rapor.payment_type&field_card_payment_id=rapor.card_paymethod_id&field_card_payment_name=rapor.payment_type','medium');"></span>
									</div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                        <input type="text" name="project_head" id="project_head" style="width:160px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"></span>
									</div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='51153.Ek Tanım'> 2</label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									 <select name="extra_info_type" id="extra_info_type" style="width:180px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_extra_info_type">
                                        <option value="#BASKET_INFO_TYPE_ID#" <cfif attributes.extra_info_type eq BASKET_INFO_TYPE_ID>selected</cfif>>#BASKET_INFO_TYPE#</option>
                                        </cfoutput>
                                    </select>
									</div>
								</div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <cf_wrk_list_items  table_name ='PRODUCT_BRANDS' wrk_list_object_id='BRAND_ID' wrk_list_object_name='BRAND_NAME' sub_header_name="#getLang('main',1435)#" header_name="#getLang('report',1818)#" width='160' datasource ="#dsn1#">
                                    </div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
                                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <cf_wrk_list_items table_name ='PRODUCT_BRANDS_MODEL' wrk_list_object_id='MODEL_ID' wrk_list_object_name='MODEL_NAME' sub_header_name="#getLang('main',813)#" header_name="#getLang('report',1354)#" width='160' datasource ="#dsn1#">
                                    </div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                                        <input type="text" name="product_name" id="product_name" style="width:160px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off"value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="set_the_report();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name','list');"></span>
									</div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
                                        <input type="hidden" name="company_id" id="company_id"<cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                        <input type="text" name="company" id="company" style="width:160px;" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company</cfoutput>&keyword='+encodeURIComponent(document.rapor.company.value),'list')"></span>
									</div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
                                        <input type="text" name="ship_method_name" id="ship_method_name" style="width:160px;" value="<cfif isdefined("attributes.ship_method_name") and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=rapor.ship_method_name&field_id=rapor.ship_method_id','list');"></span>
									</div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									 <select name="report_type" id="report_type" style="width:180px;" onchange="kontrol();">
                                        <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39052.Kategori Bazında'></option>
                                        <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='39053.Ürün Bazında'></option>
                                        <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39054.Stok Bazında'></option>
                                        <option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id='39075.Cari Bazında'></option>
                                        <option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id='39685.Belge ve Stok Bazında'></option>
                                    </select>
									</div>
								</div>  
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'>*</label>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'><cf_get_lang dictionary_id='61824.Giriniz'></cfsavecontent>
                                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfinput validate="#validate_style#" message="#message#" type="text" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" required="yes" readonly>  
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span> 
                                            </div>           
                                        </div>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfinput validate="#validate_style#" message="#message#" type="text" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" required="yes" readonly>
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>  
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'>*</label>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57645.Teslim Tarihi'><cf_get_lang dictionary_id='61824.Giriniz'></cfsavecontent>
                                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                            <cfinput validate="#validate_style#" message="#message#" type="text" name="termin_date1" value="#dateformat(attributes.termin_date1,dateformat_style)#" required="yes" readonly>  
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="termin_date1"></span>            
                                            </div>
                                        </div>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfinput validate="#validate_style#" message="#message#" type="text" name="termin_date2" value="#dateformat(attributes.termin_date2,dateformat_style)#" required="yes" readonly>
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="termin_date2"></span>  
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='39675.Sipariş Aşaması'>*</label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									 <select name="order_stage" id="order_stage" style="width:175px;height:75px;" multiple>
                                        <option value="-10" <cfif listfind(attributes.order_stage,-10,',')>selected</cfif>><cf_get_lang dictionary_id='58623.Kapatıldı (Manuel)'></option>
                                        <option value="-9" <cfif listfind(attributes.order_stage,-9,',')>selected</cfif>><cf_get_lang dictionary_id='58506.İptal'></option>
                                        <option value="-7" <cfif listfind(attributes.order_stage,-7,',')>selected</cfif>><cf_get_lang dictionary_id='29748.Eksik Teslimat'></option>
                                        <option value="-8" <cfif listfind(attributes.order_stage,-8,',')>selected</cfif>><cf_get_lang dictionary_id='29749.Fazla Teslimat'></option>
                                        <option value="-6" <cfif listfind(attributes.order_stage,-6,',')>selected</cfif>><cf_get_lang dictionary_id='58761.Sevk'></option>
                                        <option value="-5" <cfif listfind(attributes.order_stage,-5,',')>selected</cfif>><cf_get_lang dictionary_id='57456.Üretim'></option>
                                        <option value="-4" <cfif listfind(attributes.order_stage,-4,',')>selected</cfif>><cf_get_lang dictionary_id='29747.Kısmi Üretim'></option>
                                        <option value="-3" <cfif listfind(attributes.order_stage,-3,',')>selected</cfif>><cf_get_lang dictionary_id='29746.Kapatıldı'></option>
                                        <option value="-2" <cfif listfind(attributes.order_stage,-2,',')>selected</cfif>><cf_get_lang dictionary_id='29745.Tedarik'></option>
                                        <option value="-1" <cfif listfind(attributes.order_stage,-1,',')>selected</cfif>><cf_get_lang dictionary_id='58717.Açık'></option>
                                    </select>		
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									 <cfquery name="get_department" datasource="#dsn#">
                                        SELECT 
                                            DEPARTMENT_ID,DEPARTMENT_HEAD
                                        FROM
                                            BRANCH B,DEPARTMENT D
                                        WHERE
                                            B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                                            B.BRANCH_ID = D.BRANCH_ID AND
                                            D.IS_STORE <>2
                                            <cfif x_show_pasive_departments eq 0>
                                                AND D.DEPARTMENT_STATUS = 1 
                                            </cfif>
                                    </cfquery>
                                    <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
                                        SELECT * FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
                                    </cfquery>						
                                    <select name="department_id" multiple style="width:175px;height:75px;">
                                    <cfoutput query="get_department">
                                        <optgroup label="#department_head#">
                                            <cfquery name="GET_LOCATION" dbtype="query">
                                                SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department.department_id[currentrow]#">
                                            </cfquery>
                                            <cfif get_location.recordcount>
                                                <cfloop from="1" to="#get_location.recordcount#" index="s">
                                                <option value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
                                                </cfloop>
                                            </cfif>
                                        </optgroup>
                                    </cfoutput>
                                    </select>		
									</div>
								</div>
                               
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='39695.Sipariş Süreci'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									 <select name="order_process_cat" id="order_process_cat" style="width:175px;height:65px;" multiple>
                                        <cfoutput query="get_process_type">
                                            <option value="#process_row_id#"<cfif listfind(attributes.order_process_cat,process_row_id)>selected</cfif>>#stage#</option>
                                        </cfoutput>
                                    </select>			
									</div>
								</div>
                                <div class="form-group">
                                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <select name="status" id="status" style="width:60px;">
                                            <option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
                                            <option value="0"<cfif attributes.status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                            <option value="1"<cfif attributes.status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='39055.Rapor Sıra'></label>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
									    <input type="hidden" name="kontrol_type" id="kontrol_type" value="0">
                                        <label><cf_get_lang dictionary_id='30010.Ciro'><input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1 and attributes.kontrol_type eq 0>checked</cfif>></label>
                                        <label><cf_get_lang dictionary_id='57635.Miktar'><input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2 and attributes.kontrol_type eq 0>checked</cfif>></label>
									</div>
								</div>
                                
                                <div class="form-group">
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<label><cf_get_lang dictionary_id='39059.Kdv Dahil'><input type="checkbox" name="kdv_dahil" id="kdv_dahil" value="1" <cfif isdefined("attributes.kdv_dahil") and (attributes.kdv_dahil eq 1)>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='58596.Göster'><input name="is_money2" id="is_money2" value="1" type="checkbox" <cfif attributes.is_money2 eq 1 >checked</cfif>><cfoutput> #session.ep.money2# </cfoutput></label>
										<label id="money_info_2"><cf_get_lang dictionary_id='39647.Döviz Göster'><input type="checkbox" name="is_money_info" id="is_money_info" value="1" <cfif isdefined("attributes.is_money_info")>checked</cfif>></label>
										<label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="is_spect_info"><cf_get_lang dictionary_id='40610.Spec Göster'><input type="checkbox" name="is_spect_info" id="is_spect_info" value="1" <cfif attributes.is_spect_info eq 1 >checked</cfif>></label>
                                        <label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="is_project"><cf_get_lang dictionary_id='58596.Göster'><input name="is_project" id="is_project" value="1" type="checkbox" <cfif attributes.is_project eq 1 >checked</cfif>><cf_get_lang dictionary_id='57416.Proje'></label>
                                        <label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="is_discount"><cf_get_lang dictionary_id='39368.İskonto Göster'><input name="is_discount" id="is_discount" value="1" type="checkbox" <cfif attributes.is_discount eq 1 >checked</cfif>></label>
                                        <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                                    </div>
								</div>
                                
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                		<div class="ReportContentFooter">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="max_rows" value="#attributes.max_rows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                            <cf_wrk_report_search_button insert_info='#message#' insert_alert='' button_type='1' search_function='alan_control()'>
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
</cfif>	

<cfif isdefined("attributes.form_submitted") and not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='39675.Sipariş Aşaması'> 
    </cfsavecontent>
   
    </cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
		<cfset type_ = 1>
		<cfset attributes.startrow=1>
		<cfset attributes.max_rows = get_total_purchase.recordcount>		
	<cfelse>
		<cfset type_ = 0>	
	</cfif>
    <div class="col col-12">
    <cf_box title="#getlang('','Sipariş Aşaması','39675')#" pure="1">
        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58960.Rapor Tipi'></th>
                        <th> <cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                        <th><cf_get_lang dictionary_id='57416.Proje'></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></th>
                        <th><cf_get_lang dictionary_id='58847.Marka'></th>
                        <th><cf_get_lang dictionary_id='58225.Model'></th>
                        <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                        <th><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
                        <th><cf_get_lang dictionary_id='58796.Sipariş Veren'></th>
                        <th><cf_get_lang dictionary_id='39055.Rapor Sıra'></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <cfoutput>
                        <td>
                            
                            <cfif attributes.report_type eq 1><cf_get_lang dictionary_id='39052.Kategori Bazında'>
                            <cfelseif attributes.report_type eq 2><cf_get_lang dictionary_id='39053.Ürün Bazında'>
                            <cfelseif attributes.report_type eq 3><cf_get_lang dictionary_id='39054.Stok Bazında'>
                            <cfelseif attributes.report_type eq 4><cf_get_lang dictionary_id='39075.Cari Bazında'>
                            <cfelseif attributes.report_type eq 5><cf_get_lang dictionary_id='39685.Belge ve Stok Bazında'>
                            </cfif>
                        </td>
                        <td>#attributes.product_cat#</td>
                        <td>#dateformat(attributes.date1,dateformat_style)#-#dateformat(attributes.date2,dateformat_style)#</td>
                        <td>#dateformat(attributes.termin_date1,dateformat_style)#-#dateformat(attributes.termin_date2,dateformat_style)#</td>
                        <td>#attributes.company#</td>
                        <td>#attributes.project_head#</td>
                        <td>#attributes.product_name#</td>
                        <td>#attributes.employee_name#</td>
                        <td>#BRAND_NAME#</td>
                        <td>#model_NAME#</td>
                        <td>#attributes.payment_type#</td>
                        <td>#attributes.ship_method_name#</td>
                        <td>#attributes.order_employee#</td>
                        <td><cfif attributes.report_sort eq 1><cf_get_lang dictionary_id='30010.Ciro'><cfelseif attributes.report_sort eq 2><cf_get_lang dictionary_id='57635.Miktar'></cfif></td>
                        </cfoutput>
                    </tr>
                </tbody>
            </cf_grid_list>
        </cfif>
    </cf_box>
</div>
    <cf_report_list>
          
            <cfparam name="attributes.page" default=1>
            <cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
            <cfset attributes.startrow=((attributes.page-1)*attributes.max_rows)+1>
            <cfif get_total_purchase.recordcount>
                <cfif attributes.page neq 1>
                    <cfoutput query="get_total_purchase" startrow="1" maxrows="#attributes.startrow-1#">
                        <cfif len(PRICE)>
                            <cfset toplam_satis=PRICE+toplam_satis>
                        </cfif>  
                        <cfif isdefined("PRODUCT_STOCK") and len(PRODUCT_STOCK)>
                            <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
                        </cfif>
                        <cfif attributes.is_money2 eq 1 and len(PRICE_DOVIZ)>
                            <cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz>
                        </cfif>
                    </cfoutput>
                </cfif>	
                <cfif listfind('1,2,3,4,5',attributes.report_type)>
                    <cfset pay_id_list = ''>
                    <cfset credit_pay_id_list = ''>
                    <cfset stock_id_list = ''>
                    <cfif attributes.report_type eq 5>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
                            <cfif isdefined("stock_id") and len(stock_id) and not listfind(stock_id_list,stock_id)>
                                <cfset stock_id_list=listappend(stock_id_list,stock_id)>
                            </cfif> 
                            <cfif len(paymethod) and not listfind(pay_id_list,paymethod)>
                                <cfset pay_id_list=listappend(pay_id_list,paymethod)>
                            </cfif>
                            <cfif len(card_paymethod_id) and not listfind(credit_pay_id_list,card_paymethod_id)>
                                <cfset credit_pay_id_list=listappend(credit_pay_id_list,card_paymethod_id)>
                            </cfif>  
                        </cfoutput>
                    </cfif>
                    <cfif len(stock_id_list)>
                        <cfquery name="get_dept_stock" datasource="#dsn2#">
                            SELECT 
                                SUM(SR.STOCK_IN-SR.STOCK_OUT) TOPLAM, 
                                SR.STOCK_ID,
                                SR.STORE,
                                SR.STORE_LOCATION
                            FROM
                                STOCKS_ROW AS SR
                            WHERE
                                SR.PROCESS_TYPE IS NOT NULL 
                                AND STOCK_ID IN (#stock_id_list#)
                                AND SR.STORE IS NOT NULL
                                AND SR.STORE_LOCATION IS NOT NULL
                            GROUP BY 
                                SR.PRODUCT_ID,
                                SR.STOCK_ID,
                                SR.STORE,
                                SR.STORE_LOCATION
                        </cfquery>
                        <cfscript>
                            for(gpi_ind=1;gpi_ind lte get_dept_stock.recordcount;gpi_ind=gpi_ind+1)
                                'total_stock_#get_dept_stock.stock_id[gpi_ind]#_#get_dept_stock.store[gpi_ind]#_#get_dept_stock.store_location[gpi_ind]#' = get_dept_stock.TOPLAM[gpi_ind];
                        </cfscript>
                    </cfif>
                    <cfif len(pay_id_list)>
                        <cfset pay_id_list=listsort(pay_id_list,"numeric","ASC",",")>
                        <cfquery name="get_pay_name" datasource="#dsn#">
                            SELECT PAYMETHOD,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#pay_id_list#) ORDER BY PAYMETHOD_ID
                        </cfquery>
                        <cfset pay_id_list = listsort(listdeleteduplicates(valuelist(get_pay_name.PAYMETHOD_ID,',')),'numeric','ASC',',')>
                    </cfif> 
                    <cfif len(credit_pay_id_list)>
                        <cfset credit_pay_id_list=listsort(credit_pay_id_list,"numeric","ASC",",")>
                        <cfquery name="get_credit_pay_name" datasource="#dsn3#">
                            SELECT CARD_NO,PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID IN (#credit_pay_id_list#) ORDER BY PAYMENT_TYPE_ID
                        </cfquery>
                        <cfset credit_pay_id_list = listsort(listdeleteduplicates(valuelist(get_credit_pay_name.PAYMENT_TYPE_ID,',')),'numeric','ASC',',')>
                    </cfif>
                </cfif>	
                <cfif attributes.report_type eq 1>

                        <thead>
                            <tr>
                                <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id='39378.Kategori kodu'></th>
                                <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                                <th width="100" align="right"><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th width="120" align="right"><cf_get_lang dictionary_id='57673.Tutar'></th>
                                <th align="right"><cf_get_lang dictionary_id ='40210.Teslim Alınan'></th>
                                <th align="right"><cf_get_lang dictionary_id='58444.Kalan'></th>
                                <th width="30" align="left"><cf_get_lang dictionary_id='58474.Birim'></th>
                                <cfif attributes.is_money2 eq 1>
                                    <th width="100" align="right"><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
                                    <th align="center"><cf_get_lang dictionary_id='58474.Birim'></th>
                                </cfif>
                                <th width="35" align="right">%</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
                                <tr>
                                    <td>#currentrow#</td>
                                    <td width="100">#HIERARCHY#</td>
                                    <td>#PRODUCT_CAT#</td>
                                    <td align="right" format="numeric">#TLFormat(PRODUCT_STOCK,amount_round)#<cfif len(PRODUCT_STOCK)>
                                        <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>
                                    </td>
                                    <td align="right" format="numeric">#TLFormat(PRICE,price_round_number)#</td>
                                    <td align="right" format="numeric">

                                        #TLFormat( (DELIVER_AMOUNT-RETURN_DELIVER_AMOUNT),amount_round)#
                                    </td>
                                    <td align="right" format="numeric">#TLFormat(product_stock-(DELIVER_AMOUNT-RETURN_DELIVER_AMOUNT),amount_round)#</td>
                                    <cfset toplam_gelen_miktar = toplam_gelen_miktar + DELIVER_AMOUNT-RETURN_DELIVER_AMOUNT>
                                    <cfset toplam_kalan_miktar = toplam_kalan_miktar + (product_stock - (DELIVER_AMOUNT-RETURN_DELIVER_AMOUNT))>
                                    <td align="left">#SESSION.EP.MONEY#</td>
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                    <cfif attributes.is_money2 eq 1>
                                        <td align="right" format="numeric">#TLFormat(PRICE_DOVIZ,price_round_number)#</td>
                                        <td align="center">#SESSION.EP.MONEY2#</td>
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif>
                                    </cfif>
                                    <td align="right" format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                                </tr>
                        </cfoutput>
                        </tbody>
                        <tfoot>
                            <cfoutput>
                                <tr>
                                    <td colspan="3" align="right" class="formbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_miktar,amount_round)#</td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_satis,price_round_number)#</td>
                                    <td class="formbold" align="right" format="numeric">#TLFormat(toplam_gelen_miktar,amount_round)#</td> 
                                    <td class="formbold" align="right" format="numeric">#TLFormat(toplam_kalan_miktar,amount_round)#</td>
                                    <td align="left" class="formbold">#SESSION.EP.MONEY# </td>
                                    <cfif attributes.is_money2 eq 1>
                                        <td align="right" class="formbold" format="numeric">#TLFormat(toplam_doviz,price_round_number)#</td>
                                        <td align="center" class="formbold"> #SESSION.EP.MONEY2#</td>
                                    </cfif>
                                    <td></td>
                                </tr>
                            </cfoutput>	
                        </tfoot> 
                <cfelseif attributes.report_type eq 4>
                        <thead>
                            <tr align="right">
                                <th style="width:30px;"><cf_get_lang dictionary_id='57487.No'></th>
                                <th><cf_get_lang dictionary_id='58607.Firma'></th>
                                <th width="130" align="right"><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th width="130" align="right"><cf_get_lang dictionary_id='57673.Tutar'></th>
                                <th align="right"><cf_get_lang dictionary_id ='40210.Teslim Alınan'></th>
                                <th align="right"><cf_get_lang dictionary_id='58444.Kalan'></th>
                                <th style="width:50px;"><cf_get_lang dictionary_id='58474.Birim'></th>
                                <cfif attributes.is_money2 eq 1><th align="right"><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
                                    <th style="width:30px;"><cf_get_lang dictionary_id='58474.Birim'></th>
                                </cfif>
                                <th style="width:30px;">%</th>
                            </tr>
                        </thead>
                        <cfif attributes.page neq 1>
                            <cfoutput query="get_total_purchase" startrow="1" maxrows="#attributes.startrow-1#">
                                <cfif len(PRICE)>
                                    <cfset toplam_satis=PRICE+toplam_satis>
                                </cfif> 
                                    <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
                            </cfoutput>
                        </cfif>
                        <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
                            <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
                                <td>#currentrow#</td>
                                <td>
                                    <cfif type_ eq 1>
                                        #NICKNAME#
                                    <cfelse>
                                        <cfif MEMBER_TYPE eq 1>
                                            <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','list')">#NICKNAME#</a>
                                        <cfelse>
                                            <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#company_id#','list')">#NICKNAME#</a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td align="right" format="numeric">#TLFormat(PRODUCT_STOCK,amount_round)#</td>
                                <td align="right" format="numeric">#TLFormat(PRICE,price_round_number)#
                                    <cfif len(PRICE)>
                                        <cfset toplam_satis=PRICE+toplam_satis>
                                    </cfif>
                                    <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
                                </td>
                                <td align="right" format="numeric">#TLFormat((deliver_amount-return_deliver_amount),amount_round)#
                                </td>
                                <td align="right" format="numeric">#TLFormat(product_stock-(DELIVER_AMOUNT-return_deliver_amount),amount_round)#</td>
                                <cfset toplam_gelen_miktar = toplam_gelen_miktar + (DELIVER_AMOUNT-return_deliver_amount)>
                                <cfset toplam_kalan_miktar = toplam_kalan_miktar + (product_stock - (DELIVER_AMOUNT-return_deliver_amount))>
                                <td align="left">#SESSION.EP.MONEY#</td>
                                    <cfif attributes.is_money2 eq 1>
                                        <td align="right" format="numeric">#TLFormat(PRICE_DOVIZ,price_round_number)# 
                                            <cfif len(PRICE_DOVIZ)>
                                                <cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz>
                                            </cfif>
                                        </td>
                                        <td align="left">#SESSION.EP.MONEY2#</td>
                                    </cfif>
                                <td align="right" format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                            </tr>
                        </cfoutput>
                        </tbody> 
                        <cfoutput>
                            <tfoot> 
                                <tr>
                                    <td class="formbold" colspan="2" align="right"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td class="formbold" align="right" format="numeric">#TLFormat(toplam_miktar,amount_round)#</td> 
                                    <td class="formbold" align="right" format="numeric">#TLFormat(toplam_satis,price_round_number)#</td>
                                    <td class="formbold" align="right" format="numeric">#TLFormat(toplam_gelen_miktar,amount_round)#</td> 
                                    <td class="formbold" align="right" format="numeric">#TLFormat(toplam_kalan_miktar,amount_round)#</td>
                                    <td class="formbold" align="left">#SESSION.EP.MONEY#</td>
                                    <cfif attributes.is_money2 eq 1><td align="right" class="formbold" format="numeric">#TLFormat(toplam_doviz,price_round_number)#</td>
                                        <td class="formbold" align="left">#SESSION.EP.MONEY2#</td>
                                    </cfif>
                                    <td></td>
                                </tr>
                            </tfoot> 
                        </cfoutput>	  
              	  <cfelseif get_total_purchase.recordcount and attributes.report_type eq 5>
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='57487.No'></th>
                                <th nowrap="nowrap" width="60"><cf_get_lang dictionary_id='58211.Sipariş No'></th>
                                <th><cf_get_lang dictionary_id='57480.Konu'></th>
                                <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                                <th width="70"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></th>
                                <th width="70"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                                <th width="70"><cf_get_lang dictionary_id='57482.Aşama'></th>
                                <th width="70"><cf_get_lang dictionary_id='57457.Müşteri'></th>
                                <cfif attributes.is_project eq 1>
                                    <th width="70"><cf_get_lang dictionary_id ='57416.Proje'></th>
                                </cfif>
                                <cfif x_show_detail eq 1><th width="70"><cf_get_lang dictionary_id='57629.Açıklama'></th></cfif>
                                <th nowrap="nowrap"  width="70"><cf_get_lang dictionary_id='57629.Açıklama'> 2</th>
                                <cfif x_show_paymethod eq 1><th width="70"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th></cfif>
                                <th width="100"><cf_get_lang dictionary_id='58800.Ürün Kod'></th>
                                <th width="100"><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
                                <th width="95"><cf_get_lang dictionary_id='57657.Ürün'> </th>
                                <cfif attributes.is_spect_info eq 1>
                                    <th><cf_get_lang dictionary_id='57647.Spec'></th>
                                    <th><cf_get_lang dictionary_id='54850.Spec Id'></th>
                                </cfif>
                                <th width="80" align="right"><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th width="30" align="center"><cf_get_lang dictionary_id='57636.Birim'></th>
                                <th align="center" width="80" nowrap>TL <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
                                <th align="center" nowrap><cf_get_lang dictionary_id='38843.Net Fiyat'></th> 
                                <th align="center"><cf_get_lang dictionary_id='57677.Döviz'> <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
                                <cfif isdefined("attributes.is_money_info")>
                                    <th><cf_get_lang dictionary_id='39411.Döviz Net Fiyat'></th>
                                    <th><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
                                </cfif>
                                <th align="right"><cf_get_lang dictionary_id ='40210.Teslim Alınan'></th>
                                <th align="right"><cf_get_lang dictionary_id='58444.Kalan'></th>
                                <cfif x_show_dept_amount eq 1>					
                                    <th align="right"><cf_get_lang dictionary_id='39425.Depo Miktarı'></th>
                                </cfif>
                                <th align="right"><cf_get_lang dictionary_id='57673.Tutar'></th>
                                <th align="center"><cf_get_lang dictionary_id='40687.Kalan Tutar'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th align="right"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
                                </cfif>
                                <th align="left"><cf_get_lang dictionary_id='58474.Birim'></th>
                                <cfif attributes.is_money2 eq 1>
                                    <th align="right"><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
                                    <th align="left"><cf_get_lang dictionary_id='58474.Birim'></th>
                                </cfif>
                                <th align="right">%</th>
                            </tr>
                        </thead>    
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
                            <tbody>    
                                <tr>
                                    <td>#currentrow#</td>
                                    <td><cfif type_ eq 1>
                                            #order_number#
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#','wide');" class="tableyazi">#order_number#</a>
                                        </cfif>
                                    </td>
                                    <td>#ORDER_HEAD#</td>
                                    <td><cfif isdefined('stage_list_name_id') and listlen(stage_list_name_id,',') gte listfind(stage_list_name_id,ORDER_STAGE,',')+1 and listfind(stage_list_name_id,ORDER_STAGE,',') gt 0>
                                            #listgetat(stage_list_name_id,listfind(stage_list_name_id,ORDER_STAGE,',')+1,',')#
                                        </cfif>
                                    </td>
                                    <td>#dateformat(ORDER_DATE,dateformat_style)#</td>
                                    <td>#dateformat(DELIVERDATE,dateformat_style)#</td>
                                    <td><cfif order_row_currency eq -8><cf_get_lang dictionary_id='29749.Fazla Teslimat'>
                                        <cfelseif order_row_currency eq -7><cf_get_lang dictionary_id='29748.Eksik Teslimat'>
                                        <cfelseif order_row_currency eq -6><cf_get_lang dictionary_id='58761.Sevk'>
                                        <cfelseif order_row_currency eq -5><cf_get_lang dictionary_id='57456.Üretim'>
                                        <cfelseif order_row_currency eq -4><cf_get_lang dictionary_id='29747.Kısmi Üretim'>
                                        <cfelseif order_row_currency eq -3><cf_get_lang dictionary_id='29746.Kapatıldı'>
                                        <cfelseif order_row_currency eq -2><cf_get_lang dictionary_id='29745.Tedarik'>
                                        <cfelseif order_row_currency eq -1><cf_get_lang dictionary_id='58717.Açık'>
                                        <cfelseif order_row_currency eq -9><cf_get_lang dictionary_id='58506.İptal'>
                                        <cfelseif order_row_currency eq -10><cf_get_lang dictionary_id='58623.Kapatıldı (Manuel)'>
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                            #MUSTERI#
                                        <cfelse>
                                            <cfif MEMBER_TYPE eq 1>
                                                <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','list')">#MUSTERI#</a>
                                            <cfelse>
                                                <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#company_id#','list')">#MUSTERI#</a>
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <cfif attributes.is_project eq 1>
                                        <td>
                                            <cfif len(get_total_purchase.row_project_id) and listfind(project_id_list,get_total_purchase.row_project_id,',')>
                                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                                    #get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]#
                                                <cfelse>
                                                    <a href="#request.self#?fuseaction=project.projects&event=det&id=#row_project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]#</a>
                                                </cfif>
                                            <cfelseif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
                                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                                    #get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#
                                                <cfelse>
                                                    <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#</a>
                                                </cfif>
                                            </cfif> 
                                        </td>
                                    </cfif>
                                    <cfif x_show_detail eq 1><td>#ORDER_DETAIL#</td></cfif>
                                    <td>#PRODUCT_NAME2#</td>
                                    <cfif x_show_paymethod eq 1>
                                        <td><cfif len(paymethod) and len(pay_id_list)>
                                                #get_pay_name.paymethod[listfind(pay_id_list,paymethod,',')]#
                                            <cfelseif len(card_paymethod_id) and len(credit_pay_id_list)>
                                                #get_credit_pay_name.card_no[listfind(credit_pay_id_list,card_paymethod_id,',')]#
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <td>#STOCK_CODE#</td>
                                    <td>#MANUFACT_CODE#</td>
                                    <td><cfif type_ eq 1>
                                            #PRODUCT_NAME# #PROPERTY#
                                        <cfelse>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">#PRODUCT_NAME# #PROPERTY#</a>
                                        </cfif>
                                    </td>
                                    <cfif attributes.is_spect_info eq 1>
                                        <td>#spect_var_name#</td>
                                        <td>#spect_main_id#</td>
                                    </cfif>
                                    <td align="right" format="numeric">
                                        #TLFormat(PRODUCT_STOCK,amount_round)#
                                        <cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>
                                    </td>
                                    <td align="center">#birim#</td> 
                                    <td align="right" format="numeric">#TLFormat(BIRIM_FIYAT,price_round_number)#</td>
                                    <td align="right" format="numeric">#TLFormat(NETTOTAL/QUANTITY,price_round_number)#</td><!---  --->
                                    <td align="right" format="numeric">#TLFormat(BIRIM_FIYAT_OTHER,price_round_number)#</td>
                                    <cfif isdefined("attributes.is_money_info")>
                                        <cfset "toplam_#other_money#" = evaluate("toplam_#other_money#") + other_money_value>
                                        <td align="right" format="numeric">#tlformat(other_money_value,price_round_number)#</td>
                                        <td>#other_money#</td>
                                    </cfif>
                                    <td align="right" format="numeric">#TLFormat((deliver_amount-return_deliver_amount),amount_round)#
                                    </td>
                                    <td align="right" format="numeric">#TLFormat(product_stock-(deliver_amount-return_deliver_amount),amount_round)#</td>
                                    <cfset toplam_gelen_miktar = toplam_gelen_miktar + (deliver_amount-return_deliver_amount)>
                                    <cfset toplam_kalan_miktar = toplam_kalan_miktar + (product_stock - (deliver_amount-return_deliver_amount))>
                                    <cfif x_show_dept_amount eq 1>
                                        <td align="right" format="numeric">
                                            <cfif len(DELIVER_DEPT_ID)>
                                                <cfif isdefined("total_stock_#stock_id#_#deliver_dept_id#_#location_id#")>
                                                    #tlformat(evaluate("total_stock_#stock_id#_#deliver_dept_id#_#location_id#"),amount_round)#
                                                <cfelse>
                                                    -
                                                </cfif>
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <td align="right" format="numeric">#TLFormat(PRICE,price_round_number)#</td>
                                    <td align="center" format="numeric"><cfset remain=product_stock-deliver_amount>
                                        #TLFormat(remain*nettotal/PRODUCT_STOCK,price_round_number)#
                                        <cfset toplam_kalan_tutar=toplam_kalan_tutar+(remain*nettotal/PRODUCT_STOCK)>
                                    </td>
                                    <cfif attributes.is_discount eq 1><!---#TLFormat((PRODUCT_STOCK*PRICE)-PRICE,price_round_number)#--->
                                        <td align="right" format="numeric">#TLFormat(PRICE,price_round_number)#</td>
                                        <cfset toplam_isk_tutar = toplam_isk_tutar+(PRICE)>
                                    </cfif>
                                    <td align="left">#SESSION.EP.MONEY#</td>
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                    <cfif attributes.is_money2 eq 1>
                                        <td align="right" format="numeric">
                                            #TLFormat(PRICE_DOVIZ,price_round_number)# 
                                            <cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif>
                                        </td>
                                        <td align="left">#SESSION.EP.MONEY2#</td>
                                    </cfif>
                                    <td align="right" format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                                </tr>
                            </tbody>
                        </cfoutput>
                        <cfoutput>
                            <tfoot>
                                <tr>
                                    <cfset colspan_info = 12>
                                    <cfif x_show_detail eq 1><cfset colspan_info = colspan_info + 1></cfif>
                                    <cfif x_show_paymethod eq 1><cfset colspan_info = colspan_info + 1></cfif>
                                    <cfif attributes.is_project eq 1><cfset colspan_info = colspan_info + 1></cfif>
                                    <cfif attributes.is_spect_info eq 1><cfset colspan_info = colspan_info + 2></cfif>
                                    <td colspan="#colspan_info#" align="right" class="formbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_miktar,amount_round)#</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <cfif isdefined("attributes.is_money_info")>
                                        <td align="right" class="formbold" format="numeric">
                                            <cfloop query="get_money">
                                                <cfif evaluate("toplam_#money#") gt 0>
                                                    #TLFormat(evaluate("toplam_#money#"),price_round_number)#<br/>
                                                </cfif>
                                            </cfloop>
                                        </td>
                                        <td class="formbold">
                                            <cfloop query="get_money">
                                                <cfif evaluate("toplam_#money#") gt 0>
                                                    #money#<br/>
                                                </cfif>
                                            </cfloop>
                                        </td>
                                    </cfif>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_gelen_miktar,amount_round)#</td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_kalan_miktar,amount_round)#</td>
                                    <cfif x_show_dept_amount eq 1><td></td></cfif>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_satis,price_round_number)#</td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_kalan_tutar,price_round_number)#</td>
                                    <cfif attributes.is_discount eq 1><td align="right" class="formbold" format="numeric">#TLFormat(toplam_isk_tutar,price_round_number)#</td></cfif>
                                    <td align="left" class="formbold">#SESSION.EP.MONEY#</td>
                                    <cfif attributes.is_money2 eq 1>
                                        <td align="right" class="formbold" format="numeric">#TLFormat(toplam_doviz,price_round_number)# </td>
                                        <td align="left" class="formbold">#SESSION.EP.MONEY2#</td>
                                    </cfif>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </cfoutput>
                <cfelse>
                        <thead>
                            <tr>
                                <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
                                <th height="22"><cf_get_lang dictionary_id='57486.Kategori'></th>
                                <th width="80"><cf_get_lang dictionary_id='57633.Barkod'></th>
                                <th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                                <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                                <th width="100" align="right"><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th width="30"><cf_get_lang dictionary_id='57636.Birim'></th>
                                <th width="80" align="right"><cf_get_lang dictionary_id ='40210.Teslim Alınan'></th>
                                <th width="100" align="right"><cf_get_lang dictionary_id='58444.Kalan'></th>
                                <th width="120" align="right"><cf_get_lang dictionary_id='57673.Tutar'></th>
                                <th width="30"><cf_get_lang dictionary_id='58474.Birim'></th>
                                <cfif attributes.is_money2 eq 1>
                                    <th width="200" align="right"><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
                                    <th width="30"><cf_get_lang dictionary_id='58474.Birim'></th>
                                </cfif>
                                <th width="35" align="right">%</th>
                            </tr>
                        </thead>
                        <cfif attributes.page neq 1>
                            <cfoutput query="get_total_purchase" startrow="1" maxrows="#attributes.startrow-1#">
                                <cfif len(PRICE)>
                                    <cfset toplam_satis=PRICE+toplam_satis>
                                </cfif>  
                                    <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
                            </cfoutput>				  
                        </cfif>				  
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
                            <tbody>
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#PRODUCT_CAT#</td>
                                    <cfif attributes.report_type eq 2>
                                        <td>#BARCOD#</td>
                                        <td>#PRODUCT_CODE#</td>
                                        <td><cfif type_ eq 1>
                                                #PRODUCT_NAME#
                                            <cfelse>
                                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">
                                                    #PRODUCT_NAME#
                                                </a>
                                            </cfif>
                                        </td>
                                    <cfelseif attributes.report_type eq 3>
                                        <td>#BARCOD#</td>
                                        <td>#STOCK_CODE#</td>
                                        <td><cfif type_ eq 1>
                                                #PRODUCT_NAME# #PROPERTY#
                                            <cfelse>
                                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">
                                                    #PRODUCT_NAME# #PROPERTY#
                                                </a>
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <td align="right" format="numeric">#TLFormat(PRODUCT_STOCK,amount_round)# </td>
                                    <td align="left">#BIRIM#</td>
                                    <td align="right" format="numeric">#TLFormat((deliver_amount-return_deliver_amount),amount_round)#</td>
                                    <td align="right" format="numeric">#TLFormat(product_stock-(deliver_amount-return_deliver_amount),amount_round)#</td>
                                    <cfset toplam_gelen_miktar = toplam_gelen_miktar + (deliver_amount-return_deliver_amount)>
                                    <cfset toplam_kalan_miktar = toplam_kalan_miktar + (product_stock - (deliver_amount-return_deliver_amount))>
                                    <td align="right" format="numeric">
                                        #TLFormat(PRICE,price_round_number)#
                                        <cfif len(PRICE)>
                                            <cfset toplam_satis=PRICE+toplam_satis>
                                        </cfif>
                                    </td>
                                    <td align="left">#SESSION.EP.MONEY#</td>
                                    <cfif attributes.is_money2 eq 1>
                                        <td align="right" format="numeric">
                                            #TLFormat(PRICE_DOVIZ,price_round_number)#
                                            <cfif len(PRICE_DOVIZ)>
                                                <cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz>
                                            </cfif>
                                        </td>
                                        <td align="left">#SESSION.EP.MONEY2#</td>
                                    </cfif>						
                                    <td align="right" format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                                </tr>
                            </tbody>
                        </cfoutput>
                        <cfoutput>
                            <tfoot>
                                <tr>
                                    <td colspan="5" align="right" class="formbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_gelen_miktar+toplam_kalan_miktar,amount_round)#</td>
                                    <td></td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_gelen_miktar,amount_round)#</td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_kalan_miktar,amount_round)#</td>
                                    <td align="right" class="formbold" format="numeric">#TLFormat(toplam_satis,price_round_number)#</td>
                                    <td align="left" class="formbold">#SESSION.EP.MONEY#</td>
                                    <cfif attributes.is_money2 eq 1><td align="right" class="formbold" format="numeric">#TLFormat(toplam_doviz,price_round_number)# </td>
                                    <td align="left" class="formbold">#SESSION.EP.MONEY2#</td>
                                    </cfif>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </cfoutput>  
                </cfif>
            </cfif>

    </cf_report_list>
	<cfif  isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.max_rows>
		
			<cfscript>
				str_link = "form_submitted=1";
				str_link = "#str_link#&max_rows=#attributes.max_rows#&report_sort=#attributes.report_sort#&product_employee_id=#attributes.product_employee_id#";
				str_link = "#str_link#&product_name=#attributes.product_name#&product_id=#attributes.product_id#&total_event=#attributes.total_event#&employee_name=#attributes.employee_name#";
				str_link = "#str_link#&keyword=#attributes.keyword#&product_id=#attributes.product_id#";
				str_link = "#str_link#&department_id=#attributes.department_id#&department_name=#attributes.department_name#&consumer_id=#attributes.consumer_id#";
				str_link = "#str_link#&company=#attributes.company#&company_id=#attributes.company_id#&product_cat=#attributes.product_cat#&search_product_catid=#attributes.search_product_catid#&hierarcy=#attributes.hierarcy#";
				str_link = "#str_link#&kdv_dahil=#attributes.kdv_dahil#&is_stock_active=#attributes.is_stock_active#&stock_status_level=#attributes.stock_status_level#&date1=#dateformat(attributes.date1,dateformat_style)#";
				str_link = "#str_link#&date2=#dateformat(attributes.date2,dateformat_style)#&report_type=#attributes.report_type#";
				str_link = "#str_link#&termin_date1=#dateformat(attributes.termin_date1,dateformat_style)#&termin_date2=#dateformat(attributes.termin_date2,dateformat_style)#";
				str_link = "#str_link#&project_id=#attributes.project_id#";
				str_link = "#str_link#&project_head=#attributes.project_head#";
				str_link = "#str_link#&kontrol_type=#attributes.kontrol_type#";
				str_link = "#str_link#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#";
				str_link = "#str_link#&model_id=#attributes.model_id#&model_name=#attributes.model_name#";
				str_link = "#str_link#&ship_method_id=#attributes.ship_method_id#&ship_method_name=#attributes.ship_method_name#";
				str_link = "#str_link#&payment_type_id=#attributes.payment_type_id#";
				str_link = "#str_link#&card_paymethod_id=#attributes.card_paymethod_id#";
				str_link = "#str_link#&payment_type=#attributes.payment_type#";
				str_link = "#str_link#&order_employee=#attributes.order_employee#";
				str_link = "#str_link#&order_employee_id=#attributes.order_employee_id#";
				str_link = "#str_link#&is_discount=#attributes.is_discount#";
				str_link = "#str_link#&order_stage=#attributes.order_stage#";
				str_link = "#str_link#&is_money2=#attributes.is_money2#";
				str_link = "#str_link#&order_process_cat=#attributes.order_process_cat#";
				str_link = "#str_link#&status=#attributes.status#";
				if(isdefined("attributes.is_money_info"))
					str_link = "#str_link#&is_money_info=#attributes.is_money_info#";
				if(isdefined("attributes.is_project"))
					str_link = "#str_link#&is_project=#attributes.is_project#";
				if(isdefined("attributes.is_spect_info"))	
					str_link = "#str_link#&is_spect_info=#attributes.is_spect_info#";
			</cfscript>
            <cf_paging page="#attributes.page#" 
					maxrows="#attributes.max_rows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="report.purchase_analyse_report_orders&#str_link#"> 
		
		
	</cfif>	
</cfif>  			  
<br/>
<script type="text/javascript">
	function set_the_report()
	{
		rapor.report_type.checked = false;
	}
	function alan_control()
	{
		if(document.getElementById('order_stage').value=='')
		{
			alert('<cf_get_lang dictionary_id="58194.zorunlu alan"> : <cf_get_lang dictionary_id="39675.sipariş aşaması">');
			return false;	
		}
        else
        {
            if(document.rapor.is_excel.checked==false)
			{
				document.rapor.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.purchase_analyse_report_orders</cfoutput>"
				return true;
			}
			else
				document.rapor.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_purchase_analyse_report_orders</cfoutput>"
        }
	}
	
	function kontrol()
	{
		if (rapor.report_type.value == 5)
			rapor.kontrol_type.value = 1;
		else
			rapor.kontrol_type.value = 0;
		if(rapor.report_type.value != 5)	
		{
			if(money_info_2 != undefined)
				document.getElementById('money_info_2').style.display = 'none';
			if(is_project != undefined)
				document.getElementById('is_project').style.display = 'none';
			if(is_discount != undefined)
				document.getElementById('is_discount').style.display = 'none';
			if(is_spect_info != undefined)
				document.getElementById('is_spect_info').style.display = 'none';	
		}
		else
		{
			if(money_info_2 != undefined)
				document.getElementById('money_info_2').style.display = '';
			if(is_project != undefined)
				document.getElementById('is_project').style.display = '';
			if(is_discount != undefined)
				document.getElementById('is_discount').style.display = '';
			if(is_spect_info != undefined)
				document.getElementById('is_spect_info').style.display = '';
		}
	}
	kontrol();
</script>