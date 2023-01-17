<cfcomponent>
		<cffunction name="butceci" returntype="boolean" output="false">
    <!---
    notes : Butçe fişi keser...
            !!! TRANSACTION icinde kullanilmalidir !!!, ancak bu durumda transaction icindeki diger queryler de
            bu fonksiyon gibi dsn2 den calismalidir. Fonksiyon dagilim yaptigi taktirde (true) degilse false dondurur.
            ****dongu icinde hersatirda sil calismamasi icin butceci icinde sil yok ayrı olarak cagrilmali 
    usage :
    butceci (
            action_id: invoice_id,
            muhasebe_db:dsn2,
            muhasebe_db_alias : muhasebe_db_alias argumanına deger gonderilmemelidir, muhasebe_db argumanı DSN2'den farklıysa muhasebe_db_alias set ediliyor...
            stock_id: stock_id,
            product_tax:attributes.tax,
            product_otv:attributes.otv,
            invoice_row_id: invoice_row_id,
            is_income_expense: 'false', <!---true:gelir , false:gider--->
            process_type:INVOICE_CAT, 
            nettotal: row_nettotal,
            other_money_gross_total:other_money_value, 
            action_currency:other_money,  islem para cinsi
            expense_date:attributes.INVOICE_DATE
            expense_member_type: , harcama veya satışı yapan tipi employee,partner,consumer
            expense_member_id :  harcama veya satışı yapanın idsi
            expense_date: islem tarihi,
            departmen_id: faturadaki department_id,
            project_id: projeye gore dagilim yapacaksa yollanmali
        );		
    : TolgaS20060206; TolgaS20060605; Aysenur20080325, TolgaS20190930
    --->
    <cfargument name="action_id" required="yes" type="numeric"><!---işlem idsi--->
    <cfargument name="muhasebe_db" type="string" default="#dsn2#">
    <cfargument name="muhasebe_db_alias" type="string" default="">
    <cfargument name="stock_id" type="numeric">
    <cfargument name="branch_id">
    <cfargument name="product_id" type="numeric">
    <cfargument name="product_tax" type="numeric" default="0"><!--- kdv orani --->
    <cfargument name="product_otv" type="numeric" default="0"><!--- ötv orani --->
    <cfargument name="product_bsmv" type="numeric" default="0"><!--- bsmv orani --->
    <cfargument name="product_oiv" type="numeric" default="0"><!--- oiv orani --->
    <cfargument name="tevkifat_rate" type="numeric" default="0"><!---  tevkifat orani --->
    <cfargument name="invoice_row_id" type="numeric"><!--- fatura satır idsi --->
    <cfargument name="is_income_expense" required="yes" type="boolean" default="false"><!---true:gelir , false:gider --->
    <cfargument name="process_type" required="yes" type="numeric"><!---INVOICE_CAT--->
    <cfargument name="process_cat" type="numeric"><!---işlem kategorisi py--->
    <cfargument name="nettotal" required="yes" type="numeric" default="0"><!--- kdvsiz tutar --->
    <cfargument name="discounttotal" type="numeric" default="0.0"><!--- indirim tutarı --->
    <cfargument name="other_money_value" type="numeric" default="0"><!--- kdvsiz satır dövizli toplam --->
    <cfargument name="discount_other_money_value" type="numeric" default="0.0"><!--- indirim tutarı dövizli toplam --->
    <cfargument name="action_currency" type="string" default=""><!--- işlme para birimi--->
    <cfargument name="action_currency_2" type="string" default="#session.ep.money2#"><!--- sistem 2. dövizi --->
    <cfargument name="expense_member_type" type="string" default=""><!--- harcama yapam --->
    <cfargument name="expense_member_id" type="numeric">
    <cfargument name="company_id" type="string" default="">
    <cfargument name="consumer_id" type="string" default="">
    <cfargument name="employee_id" type="string" default=""><!---20070219 TolgaS bu parametrelerin isini yapması için expense_member_id ve expense_member_type var ken niye eklenmis --->
    <cfargument name="expense_date" type="date" default="#now()#"><!--- işlem tarihi --->
    <cfargument name="department_id" type="numeric" default="0">
    <cfargument name="project_id" type="string" default="">
    <cfargument name="insert_type" type="string" default=""><!---banka vs den gelen işlemler için ayraç --->
    <cfargument name="expense_center_id" type="numeric"><!--- masraf/gelir merkezi --->
    <cfargument name="expense_item_id" type="numeric"><!--- bütçe kalemi --->
    <cfargument name="expense_account_code" type="string"><!--- muhasebe kodu --->
    <cfargument name="detail" type="string" default=""><!--- açıklama --->
    <cfargument name="currency_multiplier" type="string" default=""><!--- sistem 2.döviz kuru --->
    <cfargument name="paper_no" type="string" default="">
    <cfargument name="activity_type" type="string" default=""><!--- aktivite tipi --->
    <cfargument name="action_table" type="string" default="">
    <cfargument name="subscription_id">
    <cfargument name="period_id">
    <cfargument name="muhasebe_db_dsn3">
    <cfargument name="reserv_type" type="string" default=""> <!--- Rezerv_type gelirse expense_reserved_rows tablosuna kayıt atar --->
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.wp")>
        <cfset session_base = evaluate('session.wp')>
    <cfelse>
        <cfset session_base = evaluate('session.ww')>
    </cfif>
    <cfif not (isdefined("arguments.period_id") and len(arguments.period_id))>
        <cfset new_period_id = session_base.period_id>
    <cfelse>
        <cfset new_period_id = arguments.period_id>
    </cfif>
    <cfif not (isdefined("arguments.muhasebe_db_dsn3") and len(arguments.muhasebe_db_dsn3))>
        <cfset new_db_dsn3 = dsn3_alias>
    <cfelse>
        <cfset new_db_dsn3 = "#arguments.muhasebe_db_dsn3#">
    </cfif>
    <cfscript>//sistem 2.dövizine göre hesaplama yapılır
        if(arguments.muhasebe_db is not '#dsn2#')
        {
            if(arguments.muhasebe_db is '#dsn#' or arguments.muhasebe_db is '#dsn1#' or arguments.muhasebe_db is '#dsn3#')		
                arguments.muhasebe_db_alias = '#dsn2_alias#.';
            else 
                arguments.muhasebe_db_alias = '#muhasebe_db#.';
        }
        else
            arguments.muhasebe_db_alias = '';
        if(not len(arguments.currency_multiplier))
        {
            get_currency_rate = cfquery(datasource : "#arguments.muhasebe_db#", sqlstring : "SELECT (RATE2/RATE1) RATE FROM #arguments.muhasebe_db_alias#SETUP_MONEY WHERE MONEY ='#session_base.money2#'");
            if(get_currency_rate.recordcount) arguments.currency_multiplier = get_currency_rate.RATE;
        }
    </cfscript>
    <cfif len(insert_type)><!--- banka vs den gelen işlemler için --->
        <cfset kdv_toplam = (arguments.nettotal*arguments.product_tax)/100>
        <cfset tevkifat_toplam = kdv_toplam*arguments.tevkifat_rate>
        <cfset otv_toplam = (arguments.nettotal*arguments.product_otv)/100>
        <cfset bsmv_toplam = (arguments.nettotal*arguments.product_bsmv)/100>
        <cfset oiv_toplam = (arguments.nettotal*arguments.product_oiv)/100>
        <cfset kdvli_toplam = wrk_round(arguments.nettotal + (kdv_toplam - tevkifat_toplam) + otv_toplam + bsmv_toplam + oiv_toplam)>
        <cfset other_money_kdv = (arguments.other_money_value*arguments.product_tax)/100>
        <cfset other_money_kdv_tevkifat = other_money_kdv*arguments.tevkifat_rate>
        <cfset other_kdvli_toplam = wrk_round(arguments.other_money_value + ( other_money_kdv - other_money_kdv_tevkifat ) + ((arguments.other_money_value*arguments.product_otv)/100) + ((arguments.other_money_value*arguments.product_bsmv)/100) + ((arguments.other_money_value*arguments.product_oiv)/100)) >

        <cfif not len( arguments.activity_type )>
        <!--- 20190925 TolgaS bütçe işleminde aktivite tipi gelmedi ise masraf merkezinden alınacak --->
            <cfquery name = "getActivityType" datasource = "#arguments.muhasebe_db#">
                SELECT ACTIVITY_ID FROM #arguments.muhasebe_db_alias#EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam value = "#arguments.expense_center_id#" CFSQLType = "cf_sql_integer"> 
            </cfquery>
        <cfelse>
            <cfset getActivityType.recordcount = 0>
        </cfif>
        
        <cfquery name="ADD_EXPENSE" datasource="#arguments.muhasebe_db#">
            INSERT INTO
                <cfif not len(arguments.reserv_type)>
                    #arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS
                <cfelse>
                    #arguments.muhasebe_db_alias#EXPENSE_RESERVED_ROWS
                </cfif>
                    (
                        EXPENSE_ID,
                        EXPENSE_DATE,
                        EXPENSE_CENTER_ID,
                        EXPENSE_ITEM_ID,
                        EXPENSE_ACCOUNT_CODE,
                        EXPENSE_COST_TYPE,
                        DETAIL,
                        IS_INCOME,
                        ACTION_ID,
                        COMPANY_ID,
                        COMPANY_PARTNER_ID,
                        MEMBER_TYPE,
                        AMOUNT,<!--- kdvsiz tutar --->
                        KDV_RATE,<!--- kdv oranı --->
                        OTV_RATE,<!--- otv oranı --->
                        BSMV_RATE,<!--- bsmv oranı --->
                        OIV_RATE,<!--- ÖİV oranı --->
                        TEVKIFAT_RATE,<!--- tevkifat oranı --->
                        AMOUNT_KDV,<!--- kdv tutaı --->
                        AMOUNT_OTV,<!--- otv tutarı --->
                        AMOUNT_BSMV,<!--- bsmv tutarı --->
                        AMOUNT_OIV,<!--- OIV tutarı --->
                        AMOUNT_TEVKIFAT,<!--- tevkifat tutarı --->
                        TOTAL_AMOUNT,<!--- kdvlitoplam --->
                        OTHER_MONEY_VALUE,<!--- kdvsiz döviz toplam --->
                        OTHER_MONEY_GROSS_TOTAL,<!--- kdvli döviz toplam --->
                        OTHER_MONEY_VALUE_2,<!--- sistem 2. döviz kdvli toplam --->
                        MONEY_CURRENCY_ID,<!--- işlem dövizi - other_money --->
                        MONEY_CURRENCY_ID_2,<!--- sistem 2. dövizi --->
                        ROW_PAPER_NO,
                        QUANTITY,
                        PROJECT_ID,
                        RECORD_IP,
                        RECORD_EMP,
                        RECORD_CONS,
                        RECORD_DATE,
                        BRANCH_ID,
                        ACTIVITY_TYPE,
                        ACTION_TABLE
                    )
                VALUES
                    (
                        0,
                        #arguments.expense_date#,
                        #arguments.expense_center_id#,
                        #arguments.expense_item_id#,
                        <cfif isDefined("arguments.expense_account_code") and Len(arguments.expense_account_code)>'#arguments.expense_account_code#'<cfelse>NULL</cfif>,
                        #arguments.process_type#,
                        #sql_unicode()#'#arguments.detail#',
                        <cfif arguments.is_income_expense>1<cfelse>0</cfif>,
                        #arguments.action_id#,
                        <cfif len(arguments.company_id)>
                            #arguments.company_id#,
                            <cfif isDefined("arguments.expense_member_id") and len(arguments.expense_member_id) and arguments.expense_member_id neq 0>#arguments.expense_member_id#<cfelse>0</cfif>,
                            'partner',
                        <cfelseif len(arguments.consumer_id)>
                            0,
                            #arguments.consumer_id#,
                            'consumer',
                        <cfelseif len(arguments.employee_id)>
                            0,
                            #arguments.employee_id#,
                            'employee',
                        <cfelse>
                            <!---
                            FA neden calisana atiyoruz !!
                            NULL,
                            #session.ep.userid#,
                            'employee',--->
                            NULL,
                            NULL,
                            NULL,
                        </cfif>
                        #arguments.nettotal#,
                        #arguments.product_tax#,
                        #arguments.product_otv#,
                        #arguments.product_bsmv#,
                        #arguments.product_oiv#,
                        #arguments.tevkifat_rate#,
                        #kdv_toplam#,
                        #otv_toplam#,
                        #bsmv_toplam#,
                        #oiv_toplam#,
                        #tevkifat_toplam#,
                        #kdvli_toplam#,
                        #arguments.other_money_value#,
                        #other_kdvli_toplam#,
                        <cfif isDefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round(arguments.nettotal/arguments.currency_multiplier)#<cfelse>NULL</cfif>,
                        <cfif len(arguments.action_currency)>'#arguments.action_currency#'<cfelse>NULL</cfif>,
                        '#session_base.money2#',
                        <cfif isDefined("arguments.paper_no") and  len(arguments.paper_no)>'#arguments.paper_no#'<cfelse>NULL</cfif>,
                        1,
                        <cfif isDefined("arguments.project_id") and  len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
                        '#CGI.REMOTE_ADDR#',
                        <cfif isdefined("session.ep.userid")>#SESSION.EP.USERID#<cfelse>NULL</cfif>,
                        <cfif isdefined("session.ww.userid")>#SESSION.WW.USERID#<cfelse>NULL</cfif>,
                        #NOW()#,
                        <cfif len(arguments.branch_id)>#arguments.branch_id#<cfelse>NULL</cfif>,
                        <cfif len(arguments.activity_type)>#arguments.activity_type#<cfelseif getActivityType.recordcount and len( getActivityType.ACTIVITY_ID )>#getActivityType.ACTIVITY_ID#<cfelse>NULL</cfif>,
                        <cfif len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>
                    )
            </cfquery>
        <cfreturn true>
    <cfelse><!--- faturadan bütçeci --->
        <cfif len(project_id)>
            <cfquery name="GET_PROJECT_EXP_INFO" datasource="#arguments.muhasebe_db#"><!--- proje muhasebe kod ekranından sadece masraf merkzini alıp,kalemi üründen alsın diye yapıldı.. --->
                SELECT
                <cfif is_income_expense>
                    INCOME_ITEM_ID EXP_ITEM_INFO,
                    EXPENSE_CENTER_ID EXP_CENTER_INFO
                <cfelse>
                    EXPENSE_ITEM_ID EXP_ITEM_INFO,
                    COST_EXPENSE_CENTER_ID EXP_CENTER_INFO
                </cfif>
                FROM
                    #new_db_dsn3#.PROJECT_PERIOD PP
                WHERE
                    PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"> AND
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">
            </cfquery>
            <cfquery name="GET_EXPENSE_ROW" datasource="#arguments.muhasebe_db#">
                <cfif GET_PROJECT_EXP_INFO.recordcount and GET_PROJECT_EXP_INFO.EXP_ITEM_INFO eq '-1'><!--- Üründen İşlem Yapılsın parametresi --->
                    SELECT
                        #GET_PROJECT_EXP_INFO.EXP_CENTER_INFO# EXPENSE_CENTER_ID,
                        <cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> AS EXPENSE_ITEM_ID,
                        <cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> AS EXPENSE_TEMPLATE_ID,
                        <cfif is_income_expense>PP.INCOME_ACTIVITY_TYPE_ID<cfelse>PP.ACTIVITY_TYPE_ID</cfif> AS ACTIVITY_TYPE_ID,
                        100 AS RATE,
                        0 AS COMPANY_PARTNER_ID,
                        '' AS MEMBER_TYPE,
                        0 AS IS_DEPARTMENT,
                        0 AS TEMP_DEP_ID,
                        0 AS EXPENSE_COST_TYPE,
                        PP.DISCOUNT_EXPENSE_CENTER_ID,
                        PP.DISCOUNT_EXPENSE_ITEM_ID,
                        PP.DISCOUNT_ACTIVITY_TYPE_ID
                    FROM
                        #new_db_dsn3#.PRODUCT_PERIOD PP
                    WHERE
                        PP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND
                        PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
                        <cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> IS NULL AND
                        <cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> IS NOT NULL
                <cfelse>
                    SELECT
                        <cfif is_income_expense>EXPENSE_CENTER_ID<cfelse>PP.COST_EXPENSE_CENTER_ID</cfif> AS EXPENSE_CENTER_ID,<!--- PP.EXPENSE_CENTER_ID, --->
                        <cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> AS EXPENSE_ITEM_ID,
                        <cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> AS EXPENSE_TEMPLATE_ID,
                        <cfif is_income_expense>PP.INCOME_ACTIVITY_TYPE_ID<cfelse>PP.ACTIVITY_TYPE_ID</cfif> AS ACTIVITY_TYPE_ID,
                        100 AS RATE,<!--- masraf*gelir şablonu oran --->
                        0 AS COMPANY_PARTNER_ID,
                        '' AS MEMBER_TYPE,
                        0 AS IS_DEPARTMENT,
                        0 AS TEMP_DEP_ID,
                        0 AS EXPENSE_COST_TYPE,
                        NULL AS DISCOUNT_EXPENSE_CENTER_ID,
                        NULL AS DISCOUNT_EXPENSE_ITEM_ID,
                        NULL AS DISCOUNT_ACTIVITY_TYPE_ID
                    FROM
                        #new_db_dsn3#.PROJECT_PERIOD PP
                    WHERE
                        PP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"> AND
                        PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
                        <cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> IS NULL AND
                        <cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> IS NOT NULL
                        <cfif is_income_expense>AND PP.EXPENSE_CENTER_ID IS NOT NULL<cfelse>AND PP.COST_EXPENSE_CENTER_ID IS NOT NULL</cfif>
                </cfif>
            UNION
                SELECT
                    EPTR.EXPENSE_CENTER_ID,
                    EPTR.EXPENSE_ITEM_ID,
                    EPT.TEMPLATE_ID,
                    EPTR.PROMOTION_ID AS ACTIVITY_TYPE_ID,
                    EPTR.RATE,<!--- masraf*gelir şablonu oran --->
                    EPTR.COMPANY_PARTNER_ID,
                    EPTR.MEMBER_TYPE,
                    EPT.IS_DEPARTMENT,
                    EPTR.DEPARTMENT_ID AS TEMP_DEP_ID,
                    1 AS EXPENSE_COST_TYPE,
                    NULL AS DISCOUNT_EXPENSE_CENTER_ID,
                    NULL AS DISCOUNT_EXPENSE_ITEM_ID,
                    NULL AS DISCOUNT_ACTIVITY_TYPE_ID
                FROM
                    #new_db_dsn3#.PROJECT_PERIOD PP,
                    #arguments.muhasebe_db_alias#EXPENSE_PLANS_TEMPLATES EPT,
                    #arguments.muhasebe_db_alias#EXPENSE_PLANS_TEMPLATES_ROWS EPTR
                WHERE
                    PP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"> AND
                    PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
                    <cfif is_income_expense>PP.INCOME_TEMPLATE_ID=EPT.TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID=EPT.TEMPLATE_ID</cfif> AND
                    EPTR.TEMPLATE_ID=EPT.TEMPLATE_ID AND
                    PP.EXPENSE_TEMPLATE_ID IS NOT NULL
                    <cfif is_income_expense>AND EPT.IS_INCOME=1</cfif>
                    AND (EPT.IS_DEPARTMENT=0 OR (EPT.IS_DEPARTMENT=1 AND EPTR.DEPARTMENT_ID=#department_id#))
            </cfquery>
        </cfif>
        <cfif not len(project_id) or not GET_EXPENSE_ROW.RECORDCOUNT>
            <cfquery name="GET_EXPENSE_ROW" datasource="#arguments.muhasebe_db#">
                SELECT
                    PP.PRODUCT_ID,
                    <cfif is_income_expense>EXPENSE_CENTER_ID<cfelse>PP.COST_EXPENSE_CENTER_ID</cfif> AS EXPENSE_CENTER_ID,<!--- PP.EXPENSE_CENTER_ID, --->
                    <cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> AS EXPENSE_ITEM_ID,
                    <cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> AS EXPENSE_TEMPLATE_ID,
                    <cfif is_income_expense>PP.INCOME_ACTIVITY_TYPE_ID<cfelse>PP.ACTIVITY_TYPE_ID</cfif> AS ACTIVITY_TYPE_ID,
                    100 AS RATE,<!--- masraf*gelir şablonu oran --->
                    <!--- <cfif is_income_expense>S.TAX<cfelse>S.TAX_PURCHASE</cfif> AS TAX, --->
                    0 AS COMPANY_PARTNER_ID,
                    '' AS MEMBER_TYPE,
                    0 AS IS_DEPARTMENT,
                    0 AS TEMP_DEP_ID,
                    0 AS EXPENSE_COST_TYPE,
                    PP.DISCOUNT_EXPENSE_CENTER_ID,
                    PP.DISCOUNT_EXPENSE_ITEM_ID,
                    PP.DISCOUNT_ACTIVITY_TYPE_ID
                FROM
                    #new_db_dsn3#.PRODUCT_PERIOD PP
                    <!--- #dsn3_alias#.STOCKS S --->
                WHERE
                    <!--- S.PRODUCT_ID=PP.PRODUCT_ID AND
                    S.STOCK_ID = #arguments.stock_id# AND --->
                    PP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND
                    PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
                    <cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> IS NULL AND
                    <cfif is_income_expense>PP.INCOME_ITEM_ID<cfelse>PP.EXPENSE_ITEM_ID</cfif> IS NOT NULL
                    <cfif is_income_expense>AND PP.EXPENSE_CENTER_ID IS NOT NULL<cfelse>AND PP.COST_EXPENSE_CENTER_ID IS NOT NULL</cfif>
            UNION
                SELECT
                    PP.PRODUCT_ID,
                    EPTR.EXPENSE_CENTER_ID,
                    EPTR.EXPENSE_ITEM_ID,
                    EPT.TEMPLATE_ID,
                    EPTR.PROMOTION_ID AS ACTIVITY_TYPE_ID,
                    EPTR.RATE,<!--- masraf*gelir şablonu oran --->
                    <!--- <cfif is_income_expense>S.TAX<cfelse>S.TAX_PURCHASE</cfif> AS TAX, --->
                    EPTR.COMPANY_PARTNER_ID,
                    EPTR.MEMBER_TYPE,
                    EPT.IS_DEPARTMENT,
                    EPTR.DEPARTMENT_ID AS TEMP_DEP_ID,
                    1 AS EXPENSE_COST_TYPE,
                    PP.DISCOUNT_EXPENSE_CENTER_ID,
                    PP.DISCOUNT_EXPENSE_ITEM_ID,
                    PP.DISCOUNT_ACTIVITY_TYPE_ID
                FROM
                    #new_db_dsn3#.PRODUCT_PERIOD PP,
                <!--- 	#dsn3_alias#.STOCKS S, --->
                    #arguments.muhasebe_db_alias#EXPENSE_PLANS_TEMPLATES EPT,
                    #arguments.muhasebe_db_alias#EXPENSE_PLANS_TEMPLATES_ROWS EPTR
                WHERE
                    <!--- S.PRODUCT_ID=PP.PRODUCT_ID AND
                    S.STOCK_ID = #arguments.stock_id# AND --->
                    PP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND
                    PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
                    <cfif is_income_expense>PP.INCOME_TEMPLATE_ID=EPT.TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID=EPT.TEMPLATE_ID</cfif> AND
                    EPTR.TEMPLATE_ID=EPT.TEMPLATE_ID AND
                    <cfif is_income_expense>PP.INCOME_TEMPLATE_ID<cfelse>PP.EXPENSE_TEMPLATE_ID</cfif> IS NOT NULL
                    <cfif is_income_expense>AND EPT.IS_INCOME=1</cfif>
                    AND (EPT.IS_DEPARTMENT=0 OR (EPT.IS_DEPARTMENT=1 AND EPTR.DEPARTMENT_ID=#department_id#))
            </cfquery>
        </cfif>
        <cfif GET_EXPENSE_ROW.recordcount EQ 0>
            <!--- üründe masraf merkezi vs seçili değil şablonda yok ise fonksiyona gelen değerler ile işlem yapılacak --->
            <cfscript>
                if(isDefined("arguments.expense_center_id") and arguments.expense_center_id > 0 
                    && isDefined("arguments.expense_item_id") and arguments.expense_item_id > 0)
                {
                    newRow=StructNew();
                    newRow={
                            PRODUCT_ID=arguments.product_id,
                            EXPENSE_CENTER_ID=arguments.expense_center_id,
                            EXPENSE_ITEM_ID=arguments.expense_item_id,
                            ACTIVITY_TYPE_ID=arguments.activity_type,
                            RATE = 100,
                            COMPANY_PARTNER_ID=0,
                            MEMBER_TYPE = "",
                            IS_DEPARTMENT=0,
                            TEMP_DEP_ID=0,
                            EXPENSE_COST_TYPE = 0,
                            DISCOUNT_EXPENSE_CENTER_ID = "",
                            DISCOUNT_EXPENSE_ITEM_ID = "",
                            DISCOUNT_ACTIVITY_TYPE_ID = ""
                        };
                    QueryAddRow(GET_EXPENSE_ROW,newRow);
                    GET_EXPENSE_ROW.recordcount = 1;
                }
            </cfscript>
        </cfif>
        <cfif GET_EXPENSE_ROW.recordcount>
            <cfscript>	
                if (not isdefined("arguments.expense_member_id") or not isdefined("arguments.expense_member_type"))
                {
                    arguments.expense_member_id=session.ep.userid;
                    arguments.expense_member_type='employee';
                }
            </cfscript>
            <cfset IS_EXPENSING_OIV = 0>
            <cfset IS_EXPENSING_OTV = 0>
            <cfif isDefined("arguments.process_cat") and  len(arguments.process_cat)>
                <cfquery name="get_process_cat" datasource="#arguments.muhasebe_db#">
                    SELECT ISNULL(IS_EXPENSING_OIV,0) IS_EXPENSING_OIV,ISNULL(IS_EXPENSING_OTV,0) IS_EXPENSING_OTV  FROM #new_db_dsn3#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #arguments.process_cat#
                </cfquery>
                <cfset IS_EXPENSING_OIV = get_process_cat.IS_EXPENSING_OIV>
                <cfset IS_EXPENSING_OTV = get_process_cat.IS_EXPENSING_OTV>
             </cfif>
            <cfoutput query="GET_EXPENSE_ROW">
                <!--- satır oranlarına gore tutar hesabı --->
                <cfif not isdefined("total_rate") or total_rate eq 0>
                    <cfset total_rate=0>
                    <cfoutput><cfset total_rate=total_rate+rate></cfoutput><!--- oranları 100 e tamamlıyor,output lu kalıcakmışş --->
                </cfif>
                <cfscript>
                    ort_rate=(100*GET_EXPENSE_ROW.RATE);
                    if(total_rate neq 0) ort_rate=ort_rate/total_rate;
                    //satır dağılım oranına göre other_money_gross_total lar hesaplanıyor
                    expense_amount=(ort_rate*arguments.nettotal)/100;
                    expense_amount_kdv=(expense_amount*arguments.product_tax)/100;
                    expense_amount_tevkifat = expense_amount_kdv*arguments.tevkifat_rate;
                    expense_amount_otv=(expense_amount*arguments.product_otv)/100;
                    expense_amount_bsmv=(expense_amount*arguments.product_bsmv)/100;
                    expense_amount_oiv=(expense_amount*arguments.product_oiv)/100;
                   
                    if(IS_EXPENSING_OIV eq 1) // öiv giderleştirmede net rakama öiv ekliyoruz py
                        expense_amount= expense_amount + expense_amount_oiv;
                    if(IS_EXPENSING_OTV eq 1)
                        expense_amount= expense_amount + expense_amount_otv;
                    expense_amount_total=expense_amount+( expense_amount_kdv - expense_amount_tevkifat) + expense_amount_bsmv;
                    if(IS_EXPENSING_OIV eq 0)
                        expense_amount_total = expense_amount_total + expense_amount_oiv;
                    if(IS_EXPENSING_OTV eq 0)
                        expense_amount_total = expense_amount_total + expense_amount_otv;
                    expense_other_money_value=(ort_rate*arguments.other_money_value)/100;
                    expense_other_money_kdv = (expense_other_money_value*arguments.product_tax)/100;
                    expense_other_money_kdv_tevkifat = expense_other_money_kdv*arguments.tevkifat_rate;
                    if(IS_EXPENSING_OIV eq 1) // öiv giderleştirmede net rakama öiv ekliyoruz py
                        expense_other_money_value= expense_other_money_value + ((arguments.other_money_value*arguments.product_oiv)/100);      
                    if(IS_EXPENSING_OTV eq 1) // ötv giderleştirmede net rakama ötv ekliyoruz py
                        expense_other_money_value= expense_other_money_value + ((arguments.other_money_value*arguments.product_otv)/100);
                    expense_other_money_gross= wrk_round(expense_other_money_value + (expense_other_money_kdv - expense_other_money_kdv_tevkifat) + (arguments.other_money_value*arguments.product_bsmv)/100);
                    if(IS_EXPENSING_OIV eq 0)
                        expense_other_money_gross = expense_other_money_gross + ((arguments.other_money_value*arguments.product_oiv)/100);
                    if(IS_EXPENSING_OTV eq 0)
                        expense_other_money_gross = expense_other_money_gross + ((arguments.other_money_value*arguments.product_otv)/100);
                </cfscript>
                <cfif GET_EXPENSE_ROW.EXPENSE_COST_TYPE eq 1 and len(GET_EXPENSE_ROW.MEMBER_TYPE)>
                    <cfif len(GET_EXPENSE_ROW.COMPANY_PARTNER_ID) and GET_EXPENSE_ROW.MEMBER_TYPE eq 'employee'>
                        <!--- harcama yapan employee_id kaydedilecegi icin--->
                        <cfquery name="GET_EMPS" datasource="#muhasebe_db#">
                            SELECT EMPLOYEE_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_EXPENSE_ROW.COMPANY_PARTNER_ID#">
                        </cfquery>
                        <cfset arguments.expense_member_id=GET_EMPS.EMPLOYEE_ID>
                        <cfset arguments.expense_member_type='employee'>
                    <cfelseif len(GET_EXPENSE_ROW.COMPANY_PARTNER_ID) and len(GET_EXPENSE_ROW.MEMBER_TYPE)>
                        <cfset arguments.expense_member_id=GET_EXPENSE_ROW.COMPANY_PARTNER_ID>
                        <cfset arguments.expense_member_type=GET_EXPENSE_ROW.MEMBER_TYPE>
                    </cfif>
                </cfif>
                <!---20191020 TolgaS faturadan bütçe işlemi için masraf merkezi geldi ise üründe şablon varsa alınır
                    şablon yoksa fonksiyona gelen masraf merkezi üzerinden işlem yapar oda gelmedi ise üründeki kullanılır --->
                <cfif GET_EXPENSE_ROW.EXPENSE_COST_TYPE neq 1 >
                    <cfif isDefined("arguments.expense_center_id") and arguments.expense_center_id gt 0>
                        <cfif not len(project_id) >
                            <cfset GET_EXPENSE_ROW.EXPENSE_CENTER_ID = arguments.expense_center_id>
                        <cfelse>
                            <cfif GET_PROJECT_EXP_INFO.EXP_ITEM_INFO neq '-1'><!--- masraf merkezi projeden gelecek ise değiştirme --->
                                <cfset GET_EXPENSE_ROW.EXPENSE_CENTER_ID = arguments.expense_center_id>
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfif isDefined("arguments.expense_item_id") and arguments.expense_item_id gt 0>
                        <cfset GET_EXPENSE_ROW.EXPENSE_ITEM_ID = arguments.expense_item_id>
                    </cfif>
                    <cfif isDefined("arguments.activity_type") and arguments.activity_type gt 0>
                        <cfset GET_EXPENSE_ROW.ACTIVITY_TYPE_ID = arguments.activity_type>
                    </cfif>
                </cfif>
                <cfif len(GET_EXPENSE_ROW.EXPENSE_CENTER_ID) AND not len( GET_EXPENSE_ROW.ACTIVITY_TYPE_ID )>
                    <!--- 20100925 TolgaS bütçe işleminde aktivite tipi gelmedi ise masraf merkezinden alınacak --->
                    <cfquery name = "getActivityType" datasource = "#arguments.muhasebe_db#">
                        SELECT ACTIVITY_ID FROM #arguments.muhasebe_db_alias#EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam value = "#arguments.expense_center_id#" CFSQLType = "cf_sql_integer"> 
                    </cfquery>
                    <cfset GET_EXPENSE_ROW.ACTIVITY_TYPE_ID = getActivityType.ACTIVITY_ID>
                </cfif>
                
                <cfquery name="ADD_EXPENSE" datasource="#muhasebe_db#">
                    INSERT INTO
                        <cfif not len(arguments.reserv_type)>
                            #arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS
                        <cfelse>
                            #arguments.muhasebe_db_alias#EXPENSE_RESERVED_ROWS
                        </cfif>
                            (
                                EXPENSE_COST_TYPE,
                                ACTION_ID,
                                EXPENSE_CENTER_ID,
                                EXPENSE_ITEM_ID,
                                EXPENSE_ACCOUNT_CODE,
                                ACTIVITY_TYPE,
                                DETAIL,
                                STOCK_ID,
                                EXPENSE_DATE,
                                AMOUNT_KDV,<!--- kdv oran --->
                                AMOUNT_OTV,<!--- ötv oran --->
                                AMOUNT_BSMV,<!--- bsmv oran --->
                                AMOUNT_OIV,<!--- oiv oran --->
                                AMOUNT_TEVKIFAT,<!--- tevkifat oran --->
                                AMOUNT,<!--- kdvsiz toplam --->
                                TOTAL_AMOUNT,<!--- kdvli toplam --->
                                KDV_RATE,<!--- kdv toplam --->
                                OTV_RATE,<!--- otv toplam --->
                                BSMV_RATE,<!--- bsmv toplam --->
                                OIV_RATE,<!--- oiv toplam --->
                                TEVKIFAT_RATE,<!--- tevkifat toplam --->
                                EXPENSE_ID,
                                INVOICE_ID,
                                SALE_PURCHASE,
                                MEMBER_TYPE,
                                COMPANY_PARTNER_ID,
                                MONEY_CURRENCY_ID,<!--- işlem dövizi-other_money --->
                                OTHER_MONEY_VALUE,<!--- kdvsiz döviz toplam --->
                                OTHER_MONEY_GROSS_TOTAL,<!--- kdvli döviz toplam --->
                                OTHER_MONEY_VALUE_2,<!--- sistem 2. döviz tutar --->
                                MONEY_CURRENCY_ID_2,<!--- sistem 2. dövizi --->
                                IS_INCOME,
                                RATE,
                                IS_DETAILED,
                                PROJECT_ID,
                                QUANTITY,
                                RECORD_IP,
                                RECORD_EMP,
                                RECORD_CONS,
                                RECORD_DATE,
                                BRANCH_ID,
                                SUBSCRIPTION_ID,
                                PROCESS_CAT
                            )
                        VALUES
                            (
                                #arguments.process_type#,
                                <cfif len(arguments.invoice_row_id)>#arguments.invoice_row_id#<cfelse>NULL</cfif>,
                                <cfif len(GET_EXPENSE_ROW.EXPENSE_CENTER_ID)>#GET_EXPENSE_ROW.EXPENSE_CENTER_ID#,<cfelse>NULL,</cfif>
                                <cfif len(GET_EXPENSE_ROW.EXPENSE_ITEM_ID)>#GET_EXPENSE_ROW.EXPENSE_ITEM_ID#,<cfelse>NULL,</cfif>
                                <cfif isDefined("arguments.expense_account_code") and Len(arguments.expense_account_code)>'#arguments.expense_account_code#'<cfelse>NULL</cfif>,
                                <cfif len(GET_EXPENSE_ROW.ACTIVITY_TYPE_ID)>#GET_EXPENSE_ROW.ACTIVITY_TYPE_ID#,<cfelse>NULL,</cfif>
                                <cfif len(arguments.detail)>#sql_unicode()#'#arguments.detail#',<cfelse>NULL,</cfif>
                                #arguments.stock_id#,
                                #arguments.expense_date#,
                                #expense_amount_kdv#,
                                #expense_amount_otv#,
                                #expense_amount_bsmv#,
                                #expense_amount_oiv#,
                                #expense_amount_tevkifat#,
                                #expense_amount#,
                                #expense_amount_total#,
                                #arguments.product_tax#,
                                #arguments.product_otv#,
                                #arguments.product_bsmv#,
                                #arguments.product_oiv#,
                                #arguments.tevkifat_rate#,
                                0,
                                #arguments.action_id#,
                                1,<!--- neden hep 1 ??? --->
                                '#arguments.expense_member_type#',
                                #arguments.expense_member_id#,
                                <cfif len(arguments.action_currency)>'#arguments.action_currency#'<cfelse>NULL</cfif>,
                                #expense_other_money_value#,
                                #expense_other_money_gross#,
                                <cfif isDefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round(expense_amount_total/arguments.currency_multiplier)#<cfelse>NULL</cfif>,
                                '#session_base.money2#',
                                <cfif arguments.is_income_expense>1<cfelse>0</cfif>,
                                <cfif len(ort_rate)>#ort_rate#<cfelse>NULL</cfif>,
                                <cfif len(GET_EXPENSE_ROW.EXPENSE_COST_TYPE)>1<cfelse>0</cfif>,
                                <cfif len(project_id)>#project_id#<cfelse>NULL</cfif>,
                                1,
                                '#CGI.REMOTE_ADDR#',
                                <cfif isdefined("session.ep.userid")>#SESSION.EP.USERID#<cfelse>NULL</cfif>,
                                <cfif isdefined("session.ww.userid")>#SESSION.WW.USERID#<cfelse>NULL</cfif>,
                                #NOW()#,
                                <cfif len(arguments.branch_id)>#arguments.branch_id#<cfelse>NULL</cfif>,
                                <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)>#arguments.subscription_id#<cfelse>NULL</cfif>,
                                <cfif isdefined("arguments.PROCESS_CAT") and len(arguments.PROCESS_CAT)>#arguments.PROCESS_CAT#<cfelse>NULL</cfif>
                            )
                    </cfquery>
                </cfoutput>
                <cfset total_rate=0>
                <cfif arguments.is_income_expense and arguments.discounttotal gt 0 and len(GET_EXPENSE_ROW.DISCOUNT_EXPENSE_CENTER_ID) and len(GET_EXPENSE_ROW.DISCOUNT_EXPENSE_ITEM_ID)>
                    <!--- gelir işleminde iskonto tutarı geldi ise üründe seçili olan iskonto gider kalemine bütçe hareketi yapılır --->
                    <cfif not len( GET_EXPENSE_ROW.DISCOUNT_ACTIVITY_TYPE_ID )>
                        <!--- 20101024 TolgaS bütçe işleminde aktivite tipi gelmedi ise masraf merkezinden alınacak --->
                        <cfquery name = "getActivityType" datasource = "#arguments.muhasebe_db#">
                            SELECT ACTIVITY_ID FROM #arguments.muhasebe_db_alias#EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam value = "#GET_EXPENSE_ROW.DISCOUNT_EXPENSE_CENTER_ID#" CFSQLType = "cf_sql_integer"> 
                        </cfquery>
                        <cfset GET_EXPENSE_ROW.DISCOUNT_ACTIVITY_TYPE_ID = getActivityType.ACTIVITY_ID>
                    </cfif>
                    <cfif arguments.discount_other_money_value eq 0>
                        <!--- TolgaS fatura eklemede bütceciden sonra işlem kurlar ekleniyor. Bu nedenle kur tutarlardan oranlanarak bulundu --->
                            <cfif arguments.action_currency eq session.ep.MONEY>
                                <cfset cur_RATE = 1>
                            <cfelse>
                                <cfset cur_RATE = wrk_round(arguments.nettotal / arguments.other_money_value,session.ep.OUR_COMPANY_INFO.SALES_PRICE_ROUND_NUM)>
                            </cfif>        
                        <cfset expense_other_money_value = wrk_round(arguments.discounttotal / cur_RATE,session.ep.OUR_COMPANY_INFO.RATE_ROUND_NUM)>
                    <cfelse>
                        <cfset expense_other_money_value= arguments.discount_other_money_value>
                    </cfif>
                    <cfscript>
                        expense_amount=arguments.discounttotal;
                        expense_amount_kdv=(expense_amount*arguments.product_tax)/100;
                        expense_amount_tevkifat = expense_amount_kdv*arguments.tevkifat_rate;
                        expense_amount_otv=(expense_amount*arguments.product_otv)/100;
                        expense_amount_bsmv=(expense_amount*arguments.product_bsmv)/100;
                        expense_amount_oiv=(expense_amount*arguments.product_oiv)/100;
                        if(IS_EXPENSING_OIV eq 1) // öiv giderleştirmede net rakama öiv ekliyoruz py
                            expense_amount=expense_amount + expense_amount_oiv;
                        if(IS_EXPENSING_OTV eq 1)
                            expense_amount=expense_amount + expense_amount_otv;
                        expense_amount_total=expense_amount+( expense_amount_kdv - expense_amount_tevkifat)  + expense_amount_bsmv ;
                        if(IS_EXPENSING_OIV eq 0)
                            expense_amount_total = expense_amount_total + expense_amount_oiv;
                        if(IS_EXPENSING_OTV eq 0)
                            expense_amount_total = expense_amount_total + expense_amount_otv;
                        //expense_other_money_value=discount_other_money_value;
                        expense_other_money_kdv = (expense_other_money_value*arguments.product_tax)/100;
                        expense_other_money_kdv_tevkifat = expense_other_money_kdv*arguments.tevkifat_rate;
                        
                         if(IS_EXPENSING_OIV eq 1) // öiv giderleştirmede net rakama öiv ekliyoruz py
                            expense_other_money_value= expense_other_money_value + ((arguments.other_money_value*arguments.product_oiv)/100);
                        if(IS_EXPENSING_OTV eq 1) // ötv giderleştirmede net rakama ötv ekliyoruz py
                            expense_other_money_value= expense_other_money_value + ((arguments.other_money_value*arguments.product_otv)/100);
                        expense_other_money_gross= wrk_round(expense_other_money_value + (expense_other_money_kdv - expense_other_money_kdv_tevkifat) + (arguments.other_money_value*arguments.product_bsmv)/100);
                        if(IS_EXPENSING_OIV eq 0)
                            expense_other_money_gross = expense_other_money_gross + ((arguments.other_money_value*arguments.product_oiv)/100);
                        if(IS_EXPENSING_OTV eq 0)
                            expense_other_money_gross = expense_other_money_gross + ((arguments.other_money_value*arguments.product_otv)/100);
                        </cfscript>

                    <cfquery name="ADD_EXPENSE_DISCOUNT" datasource="#muhasebe_db#">
                        INSERT INTO
                            <cfif not len(arguments.reserv_type)>
                                #arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS
                            <cfelse>
                                #arguments.muhasebe_db_alias#EXPENSE_RESERVED_ROWS
                            </cfif>
                                (
                                    EXPENSE_COST_TYPE,
                                    ACTION_ID,
                                    EXPENSE_CENTER_ID,
                                    EXPENSE_ITEM_ID,
                                    EXPENSE_ACCOUNT_CODE,
                                    ACTIVITY_TYPE,
                                    DETAIL,
                                    STOCK_ID,
                                    EXPENSE_DATE,
                                    AMOUNT_KDV,<!--- kdv oran --->
                                    AMOUNT_OTV,<!--- ötv oran --->
                                    AMOUNT_BSMV,<!--- bsmv oran --->
                                    AMOUNT_OIV,<!--- oiv oran --->
                                    AMOUNT_TEVKIFAT,<!--- tevkifat oran --->
                                    AMOUNT,<!--- kdvsiz toplam --->
                                    TOTAL_AMOUNT,<!--- kdvli toplam --->
                                    KDV_RATE,<!--- kdv toplam --->
                                    OTV_RATE,<!--- otv toplam --->
                                    BSMV_RATE,<!--- bsmv toplam --->
                                    OIV_RATE,<!--- oiv toplam --->
                                    TEVKIFAT_RATE,<!--- tevkifat toplam --->
                                    EXPENSE_ID,
                                    INVOICE_ID,
                                    SALE_PURCHASE,
                                    MEMBER_TYPE,
                                    COMPANY_PARTNER_ID,
                                    MONEY_CURRENCY_ID,<!--- işlem dövizi-other_money --->
                                    OTHER_MONEY_VALUE,<!--- kdvsiz döviz toplam --->
                                    OTHER_MONEY_GROSS_TOTAL,<!--- kdvli döviz toplam --->
                                    OTHER_MONEY_VALUE_2,<!--- sistem 2. döviz tutar --->
                                    MONEY_CURRENCY_ID_2,<!--- sistem 2. dövizi --->
                                    IS_INCOME,
                                    RATE,
                                    IS_DETAILED,
                                    PROJECT_ID,
                                    QUANTITY,
                                    RECORD_IP,
                                    RECORD_EMP,
                                    RECORD_CONS,
                                    RECORD_DATE,
                                    BRANCH_ID,
                                    SUBSCRIPTION_ID,
                                    PROCESS_CAT
                                )
                            VALUES
                                (
                                    #arguments.process_type#,
                                    <cfif len(arguments.invoice_row_id)>#arguments.invoice_row_id#<cfelse>NULL</cfif>,
                                    <cfif len(GET_EXPENSE_ROW.DISCOUNT_EXPENSE_CENTER_ID)>#GET_EXPENSE_ROW.DISCOUNT_EXPENSE_CENTER_ID#<cfelse>NULL</cfif>,
                                    <cfif len(GET_EXPENSE_ROW.DISCOUNT_EXPENSE_ITEM_ID)>#GET_EXPENSE_ROW.DISCOUNT_EXPENSE_ITEM_ID#<cfelse>NULL</cfif>,
                                    <cfif isDefined("arguments.expense_account_code") and Len(arguments.expense_account_code)>'#arguments.expense_account_code#'<cfelse>NULL</cfif>,
                                    <cfif len(GET_EXPENSE_ROW.ACTIVITY_TYPE_ID)>#GET_EXPENSE_ROW.ACTIVITY_TYPE_ID#<cfelse>NULL</cfif>,
                                    <cfif len(arguments.detail)>#sql_unicode()#'#arguments.detail#',<cfelse>NULL,</cfif>
                                    #arguments.stock_id#,
                                    #arguments.expense_date#,
                                    #expense_amount_kdv#,
                                    #expense_amount_otv#,
                                    #expense_amount_bsmv#,
                                    #expense_amount_oiv#,
                                    #expense_amount_tevkifat#,
                                    #expense_amount#,
                                    #expense_amount_total#,
                                    #arguments.product_tax#,
                                    #arguments.product_otv#,
                                    #arguments.product_bsmv#,
                                    #arguments.product_oiv#,
                                    #arguments.tevkifat_rate#,
                                    0,
                                    #arguments.action_id#,
                                    1,<!--- neden hep 1 ??? --->
                                    '#arguments.expense_member_type#',
                                    #arguments.expense_member_id#,
                                    <cfif len(arguments.action_currency)>'#arguments.action_currency#'<cfelse>NULL</cfif>,
                                    #expense_other_money_value#,
                                    #expense_other_money_gross#,
                                    <cfif isDefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round(expense_amount_total/arguments.currency_multiplier)#<cfelse>NULL</cfif>,
                                    '#session_base.money2#',
                                    <cfif arguments.is_income_expense>0<cfelse>1</cfif>,<!--- iskonto olduğu için ters yazılıyor --->
                                    100,
                                    <cfif len(GET_EXPENSE_ROW.EXPENSE_COST_TYPE)>1<cfelse>0</cfif>,
                                    <cfif len(project_id)>#project_id#<cfelse>NULL</cfif>,
                                    1,
                                    '#CGI.REMOTE_ADDR#',
                                    <cfif isdefined("session.ep.userid")>#SESSION.EP.USERID#<cfelse>NULL</cfif>,
                                    <cfif isdefined("session.ww.userid")>#SESSION.WW.USERID#<cfelse>NULL</cfif>,
                                    #NOW()#,
                                    <cfif len(arguments.branch_id)>#arguments.branch_id#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)>#arguments.subscription_id#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.PROCESS_CAT") and len(arguments.PROCESS_CAT)>#arguments.PROCESS_CAT#<cfelse>NULL</cfif>
                                )
                        </cfquery>

                </cfif>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cfif><cfabort>
    </cffunction>
	<cffunction name="butce_sil" output="false">
        <!---
        by :  20060125
        notes : Butce fişi siler...
                !!! TRANSACTION icinde kullanılmalıdır !!!, ancak bu durumda transaction icindeki diger queryler de
                bu fonksiyon gibi dsn2 den calismalidir. Fonksiyon sorunsuz calistiginda true döndürür.
        usage :
            butce_sil (action_id:attributes.id,muhasebe_db:dsn2,process_type:process_type(fatura icin bos olmalı),is_stock_fis:1(stok fis ise true));
        revisions :TolgaS 20070211
        --->
        <cfargument name="action_id" required="yes" type="numeric">
        <cfargument name="process_type" type="string" default="">
        <cfargument name="muhasebe_db" type="string" default="#dsn2#">
        <cfargument name="muhasebe_db_alias" type="string" default="">
        <cfargument name="is_stock_fis" type="boolean" default="0">
        <cfargument name="reserv_type" type="string" default=""> <!--- Rezerv_type gelirse expense_reserved_rows tablosuna kayıt atar --->
            <cfif arguments.muhasebe_db is not '#dsn2#'>
                <cfset arguments.muhasebe_db_alias = '#dsn2_alias#'&'.'>
            <cfelse>
                <cfset arguments.muhasebe_db_alias =''>
            </cfif>
            <cfif len(arguments.process_type)><!--- banka vs tipi yerlerden gelen işlemler için --->
                <cfquery name="DEL_COST_FIS" datasource="#arguments.muhasebe_db#">
                    DELETE FROM <cfif not len(arguments.reserv_type)>#arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS <cfelse> #arguments.muhasebe_db_alias#EXPENSE_RESERVED_ROWS</cfif> WHERE ACTION_ID = #arguments.action_id# AND EXPENSE_COST_TYPE = #arguments.process_type# AND (ACTION_TABLE IS NULL OR ACTION_TABLE <> 'EMPLOYEES_PUANTAJ')
                </cfquery>
            <cfelse><!--- fatura dağılımları --->
                <cfif arguments.is_stock_fis eq 0>
                    <cfquery name="DEL_COST_FIS" datasource="#arguments.muhasebe_db#">
                        DELETE FROM <cfif not len(arguments.reserv_type)>#arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS <cfelse> #arguments.muhasebe_db_alias#EXPENSE_RESERVED_ROWS</cfif> WHERE INVOICE_ID = #arguments.action_id#
                    </cfquery>
                <cfelse>
                    <cfquery name="DEL_COST_FIS" datasource="#arguments.muhasebe_db#">
                        DELETE FROM <cfif not len(arguments.reserv_type)>#arguments.muhasebe_db_alias#EXPENSE_ITEMS_ROWS <cfelse> #arguments.muhasebe_db_alias#EXPENSE_RESERVED_ROWS</cfif> WHERE STOCK_FIS_ID = #arguments.action_id#
                    </cfquery>
                </cfif>
            </cfif>
        <cfreturn true>
    </cffunction>
    
    <!--- get_carici.cfm --->
    <cffunction name="carici" returntype="boolean" output="false">
		<!---
        by :   20031117
        notes : Cari İşlemi Ekler veya Günceller...Fonksiyon sorunsuz çalistiginda true döndürür.
    
        problem :	 20040113 banka acilisi gibi yerlerde update isleminde borc alacaga donerse onceki hesap carisini NULL yapmak gerekiyor
                    bu kodların DB2 da çalışması kontrol edilecek.
        usage :
        carici
            (action_id : GET_ACT_ID.MAX_ID,
            action_table : 'CASH_ACTIONS',
            workcube_process_type : 32,
            workcube_old_process_type : 32,
            account_card_type : 12,
            islem_tarihi : "#attributes.ACTION_DATE#",
            islem_tutari : CASH_ACTION_VALUE,
            islem_belge_no : PAPER_NUMBER,
            to_cmp_id : CASH_ACTION_TO_COMPANY_ID, Borçlu
            from_cmp_id : CASH_ACTION_FROM_COMPANY_ID, Alacaklı
            to_employee_id : EMPLOYEE_ID,
            from_cash_id : CASH_ACTION_FROM_CASH_ID,
            islem_detay : 'ÖDEME',
            cari_db : carici fonksiyonunu transaction içinde kullanılabilmesini saglar. transaction için dsn2'den farklı kullanılan datasource bu argumana gonderilmelidir.
            cari_db_alias : cari_db_alias argumanına deger gonderilmemelidir, cari_db argumanı DSN2'den farklıysa cari_db_alias set ediliyor...
            other_money_value : other_money_value,
            other_money : money_type,
            payer_id :PAYER_ID,
            action_currency_2:'USD', ikinci para birimini tutar
            action_value2 : sistem 2 para birimi cinsinden doviz tutarı... gonderilmediginde action_currency_2 parametresine gonderilen 
                            doviz turunun sistemdeki kur bilgisi bulunur ve action_value nun bu kura bolunmesiyle action_value2 nin degeri hesaplanır.
            action_currency : GET_CASH_CUR.CASH_CURRENCY_ID
            due_date : attributes.DUE_DATE ortalama vade ( ODBC Formatta !!!)
            action_detail : attributes.detail (işlemin geldiği yerdeki açıklama alanı)
            project_id : ilgili cari islemin baglı oldugu proje
            subscription_id : ilgili cari islemin baglı oldugu abone
            payment_value : fatura vb islem detaylarindaki odeme plani icin kullaniliyor, odeme plani 2 ondalik hane ile calirisken faturada 4 hane ile calisiliyorsa yuvarlamadan dolayi sorun oluyordu bu yuzden faturadaki hane kadar da tutabilmek icin boyle yaptik FBS 20110822
            );
        revisions : 20040227 , OZDEN20051101, 20060207, OZDEN20060228, OZDEN20060406, AE20070109 ,OZDEN20070111, OZDEN20070411
        --->
        <cfargument name="action_id" required="yes" type="numeric">
        <cfargument name="process_cat" required="yes" type="numeric">
        <cfargument name="action_table" type="string">
        <cfargument name="workcube_process_type" required="yes" type="numeric">
        <cfargument name="workcube_old_process_type" type="numeric">
        <cfargument name="action_currency" type="string" default="">
        <cfargument name="action_currency_2" type="string" default="">
        <cfargument name="currency_multiplier" type="string" default="">
        <cfargument name="other_money" type="string" default="">
        <cfargument name="other_money_value" type="string" default="">
        <cfargument name="account_card_type" type="numeric">
        <cfargument name="islem_tarihi" required="yes" type="date">
        <cfargument name="paper_act_date" type="date">
        <cfargument name="acc_type_id" default="">
        <cfargument name="due_date" type="string">
        <cfargument name="islem_tutari" required="yes" type="numeric">
        <cfargument name="action_value2">
        <cfargument name="islem_belge_no" type="string" default="">
        <cfargument name="islem_detay" type="string" default="">
        <cfargument name="period_is_integrated" type="any" default="">
        <cfargument name="cari_db" type="string" default="#dsn2#">
        <cfargument name="cari_db_alias" type="string">
        <cfargument name="expense_center_id">
        <cfargument name="expense_item_id">
        <cfargument name="payer_id">
        <cfargument name="revenue_collector_id">
        <cfargument name="to_cmp_id">
        <cfargument name="from_cmp_id">
        <cfargument name="to_account_id">
        <cfargument name="from_account_id">
        <cfargument name="to_cash_id">
        <cfargument name="from_cash_id">
        <cfargument name="to_employee_id">
        <cfargument name="from_employee_id">
        <cfargument name="to_consumer_id">
        <cfargument name="from_consumer_id">
        <cfargument name="is_processed" type="numeric" default="0">
        <cfargument name="action_detail" type="string" default="">
        <cfargument name="from_branch_id">
        <cfargument name="to_branch_id">
        <cfargument name="project_id">
        <cfargument name="payroll_id">
        <cfargument name="rate2">
        <cfargument name="subscription_id">
        <cfargument name="is_cancel">
        <cfargument name="is_cash_payment" default="0"><!---1 gönderildiğinde ödeme yöntemine göre parçalı ödemelerde peşinat satırını tutar  --->
        <cfargument name="is_upd_other_value" default="0"><!--- çek-senetler için extre değeri güncelledkten sonra değişmesin veya null olmasn diye ayrı bloklr içine almk için kullanıldı, if bloklarına eklenmedi çünkü else inde NULL set edilirdi ozaman.. --->
        <cfargument name="payment_value"><!--- Burasi fatura vb islem detaylarindaki odeme plani icin kullaniliyor, odeme plani 2 ondalik hane ile calirisken faturada 4 hane ile calisiliyorsa yuvarlamadan dolayi sorun oluyordu bu yuzden faturadaki hane kadar da tutabilmek icin boyle yaptik FBS 20110822 --->
        
        <cfif isdefined("session.pp")>
            <cfset session_base = evaluate('session.pp')>
        <cfelseif isdefined("session.ep")>
            <cfset session_base = evaluate('session.ep')>
        <cfelseif isdefined("session.ww")>
            <cfset session_base = evaluate('session.ww')>
        <cfelseif isdefined("session.wp")>
            <cfset session_base = evaluate('session.wp')>
        </cfif>

        <cfif not IsDefined("arguments.action_currency") or ( IsDefined("arguments.action_currency") && not len(arguments.action_currency) )>
            <cfset arguments.action_currency = session_base.money />
        </cfif>
        <cfif not IsDefined("arguments.action_currency_2") or ( IsDefined("arguments.action_currency_2") && not len(arguments.action_currency_2) )>
            <cfset arguments.action_currency_2 = session_base.money2 />
        </cfif>
        <cfif not IsDefined("arguments.period_is_integrated") or ( IsDefined("arguments.period_is_integrated") && not len(arguments.period_is_integrated) )>
            <cfset arguments.period_is_integrated = session_base.period_is_integrated />
        </cfif>
        
        <cfquery name="getProcessCat" datasource="#arguments.cari_db#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
            SELECT
                ACCOUNT_TYPE_ID
            FROM
                <cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT <!--- işlem kategorilerinin action fileların tanımlı olmama durumu için eklendi --->
            WHERE
                PROCESS_CAT_ID = #arguments.process_cat#
        </cfquery>
	    <cfif not len(arguments.acc_type_id)>
            <cfif (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)) or (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>
                <cfset arguments.acc_type_id = -1>
            <cfelse>
                <cfif len(getProcessCat.account_type_id) and getProcessCat.account_type_id neq 0>
                    <cfset arguments.acc_type_id = getProcessCat.account_type_id>
                <cfelse>
                    <cfset arguments.acc_type_id = ''>
                </cfif>	
            </cfif>
        </cfif>
        <cfscript>
            if(cari_db is not '#dsn2#') 
            { /*cari_db argumanına session da tutulan period dısında dsn2 gonderilmesi durumunda else bolumu calısıyor. orn. ayarlar - cari devir islemi
                bu sadece carici functionında boyle muhasebeciyle karıstırılmasın. muhasebeci sadece bulundugu perioddaki dsn2'den calısır...OZDEN20070111*/
                if(arguments.cari_db is '#dsn#' or arguments.cari_db is '#dsn1#' or arguments.cari_db is '#dsn3#')		
                    arguments.cari_db_alias = '#dsn2_alias#.';
                else 
                    arguments.cari_db_alias = '#cari_db#.';
            }
            else
                arguments.cari_db_alias = '';
            if(len(arguments.action_currency_2) and (not len(arguments.currency_multiplier)) and (not (isdefined('arguments.action_value2') and len(arguments.action_value2))) )
            {
                get_currency_rate = cfquery(datasource : "#arguments.cari_db#", sqlstring : "SELECT (RATE2/RATE1) RATE FROM #arguments.cari_db_alias#SETUP_MONEY WHERE MONEY ='#arguments.action_currency_2#'");
                if(get_currency_rate.recordcount) arguments.currency_multiplier = get_currency_rate.RATE;
            }
            if(ListFind("48,49",arguments.workcube_process_type))//kur farkı faturalarında döviz bakiyeleri sıfırlamak için.. Ayşenur20080111
                if(isDefined('arguments.other_money') and len(arguments.other_money) and arguments.other_money neq "session_base.money")
                {
                    arguments.other_money_value = 0;
                    arguments.action_value2 = 0;
                }
        </cfscript>
        <cfif isdefined("arguments.workcube_old_process_type") and len(arguments.workcube_old_process_type)>
            <cfquery name="carici_get_cari_islem" datasource="#arguments.cari_db#">
                SELECT 
                    ACTION_ID 
                FROM 
                    #arguments.cari_db_alias#CARI_ROWS 
                WHERE 
                    ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                    AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_old_process_type#">
                    AND ISNULL(IS_CANCEL,0)=0
                    <cfif isDefined('arguments.action_table') and len(arguments.action_table)> AND ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_table#"></cfif>
                    <cfif isDefined('arguments.payroll_id') and len(arguments.payroll_id)> AND PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payroll_id#"></cfif> 
            </cfquery>
        </cfif>
        <cfif isdefined("arguments.workcube_old_process_type") and len(arguments.workcube_old_process_type) and len(carici_get_cari_islem.action_id)>
            <cfquery name="UPD_CARI" datasource="#arguments.cari_db#">
                UPDATE
                    #arguments.cari_db_alias#CARI_ROWS
                SET
                    ACTION_DATE=#arguments.islem_tarihi#,
                    ACTION_TYPE_ID = #arguments.workcube_process_type#,
                    ACTION_VALUE= #wrk_round(arguments.islem_tutari,2)#,ACTION_CURRENCY_ID='#arguments.action_currency#',PROCESS_CAT=#arguments.process_cat#,
                    <cfif is_upd_other_value eq 0>
                        <cfif len(arguments.action_currency_2)>
                            ACTION_CURRENCY_2='#arguments.action_currency_2#', 
                            <cfif isdefined('arguments.action_value2') and len(arguments.action_value2)>
                                ACTION_VALUE_2= #wrk_round(arguments.action_value2,2)#,
                            <cfelse>
                                ACTION_VALUE_2= #wrk_round((arguments.islem_tutari/arguments.currency_multiplier),2)#,
                            </cfif>
                        <cfelse>
                            ACTION_CURRENCY_2 = NULL, ACTION_VALUE_2 = NULL,
                        </cfif>
                    </cfif>
                    PAYMENT_VALUE=<cfif isDefined('arguments.payment_value') and len(arguments.payment_value)>#arguments.payment_value#<cfelse>NULL</cfif>,
                    ACTION_TABLE=<cfif isDefined('arguments.action_table') and len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>,
                    DUE_DATE=<cfif isDefined('arguments.due_date') and isdate(arguments.due_date)>#arguments.due_date#<cfelse>#arguments.islem_tarihi#</cfif>,
                    PAPER_NO=<cfif isDefined('arguments.islem_belge_no') and len(arguments.islem_belge_no)>'#arguments.islem_belge_no#'<cfelse>NULL</cfif>,
                    ACTION_DETAIL=<cfif isDefined('arguments.action_detail') and len(arguments.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(arguments.action_detail,250)#"><cfelse>NULL</cfif>,
                    ACTION_NAME=<cfif isDefined('arguments.islem_detay') and len(arguments.islem_detay)>'#LEFT(arguments.islem_detay,100)#'<cfelse>NULL</cfif>,
                    EXPENSE_CENTER_ID=<cfif isDefined('arguments.expense_center_id') and isnumeric(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
                    EXPENSE_ITEM_ID=<cfif isDefined('arguments.expense_item_id') and isnumeric(arguments.expense_item_id)>#arguments.expense_item_id#<cfelse>NULL</cfif>,
                    PAYER_ID=<cfif isDefined('arguments.payer_id') and isnumeric(arguments.payer_id)>#arguments.payer_id#<cfelse>NULL</cfif>,
                    <cfif is_upd_other_value eq 0>
                        OTHER_CASH_ACT_VALUE=<cfif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value)>#wrk_round(arguments.other_money_value,2)#<cfelse>NULL</cfif>,
                        OTHER_MONEY=<cfif isDefined('arguments.other_money') and len(arguments.other_money)>'#arguments.other_money#'<cfelse>NULL</cfif>,
                        RATE2 = <cfif isdefined("arguments.rate2") and len(arguments.rate2) and arguments.rate2 neq 0>#arguments.rate2#<cfelseif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value) and arguments.other_money_value neq 0>#arguments.islem_tutari/arguments.other_money_value#<cfelse>NULL</cfif>,
                    </cfif>
                    TO_CMP_ID=<cfif isDefined('arguments.to_cmp_id') and isnumeric(arguments.to_cmp_id)>#arguments.to_cmp_id#<cfelse>NULL</cfif>,
                    FROM_CMP_ID=<cfif isDefined('arguments.from_cmp_id') and isnumeric(arguments.from_cmp_id)>#arguments.from_cmp_id#<cfelse>NULL</cfif>,
                    TO_ACCOUNT_ID=<cfif isDefined('arguments.to_account_id') and isnumeric(arguments.to_account_id)>#arguments.to_account_id#<cfelse>NULL</cfif>,
                    FROM_ACCOUNT_ID=<cfif isDefined('arguments.from_account_id') and isnumeric(arguments.from_account_id)>#arguments.from_account_id#<cfelse>NULL</cfif>,
                    TO_CASH_ID=<cfif isDefined('arguments.to_cash_id') and isnumeric(arguments.to_cash_id)>#arguments.to_cash_id#<cfelse>NULL</cfif>,
                    FROM_CASH_ID=<cfif isDefined('arguments.from_cash_id') and isnumeric(arguments.from_cash_id)>#arguments.from_cash_id#<cfelse>NULL</cfif>,
                    TO_EMPLOYEE_ID=<cfif isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)>#arguments.to_employee_id#<cfelse>NULL</cfif>,
                    FROM_EMPLOYEE_ID=<cfif isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id)>#arguments.from_employee_id#<cfelse>NULL</cfif>,
                    TO_CONSUMER_ID=<cfif isDefined('arguments.to_consumer_id') and isnumeric(arguments.to_consumer_id)>#arguments.to_consumer_id#<cfelse>NULL</cfif>,
                    FROM_CONSUMER_ID=<cfif isDefined('arguments.from_consumer_id') and isnumeric(arguments.from_consumer_id)>#arguments.from_consumer_id#<cfelse>NULL</cfif>,
                    REVENUE_COLLECTOR_ID=<cfif isDefined('arguments.revenue_collector_id') and isnumeric(arguments.revenue_collector_id)>#arguments.revenue_collector_id#<cfelse>NULL</cfif>,
                    IS_PROCESSED=<cfif isdefined('arguments.is_processed') and isnumeric(arguments.is_processed)>#arguments.is_processed#<cfelse>0</cfif>,
                    FROM_BRANCH_ID=<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>#arguments.from_branch_id#<cfelse>NULL</cfif>,
                    TO_BRANCH_ID=<cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>#arguments.to_branch_id#<cfelse>NULL</cfif>,
                    ASSETP_ID=<cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>#arguments.assetp_id#<cfelse>NULL</cfif>,
                    SPECIAL_DEFINITION_ID = <cfif isdefined('arguments.special_definition_id') and len(arguments.special_definition_id)>#arguments.special_definition_id#<cfelse>NULL</cfif>,
                    PROJECT_ID=<cfif isdefined('arguments.project_id') and len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
                    IS_CASH_PAYMENT=<cfif isdefined('arguments.is_cash_payment') and len(arguments.is_cash_payment)>#arguments.is_cash_payment#<cfelse>NULL</cfif>,
                    ACC_TYPE_ID=<cfif isdefined('arguments.acc_type_id') and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>#arguments.acc_type_id#<cfelseif (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)) or (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>-1<cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = <cfif isDefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
                    UPDATE_PAR = <cfif isDefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
                    UPDATE_CONS = <cfif isDefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                    UPDATE_IP = '#CGI.REMOTE_ADDR#',
                    <cfif arguments.period_is_integrated>IS_ACCOUNT=1,IS_ACCOUNT_TYPE=#arguments.account_card_type#<cfelse>IS_ACCOUNT=0,IS_ACCOUNT_TYPE=0</cfif>,
                    SUBSCRIPTION_ID = <cfif isDefined("arguments.subscription_id") and len(arguments.subscription_id)>#arguments.subscription_id#<cfelse>NULL</cfif>
                WHERE
                    ACTION_ID = #arguments.action_id#
                    AND ACTION_TYPE_ID = #arguments.workcube_old_process_type#
                    AND ISNULL(IS_CANCEL,0)=0
                    <cfif isDefined('arguments.action_table') and len(arguments.action_table)> AND ACTION_TABLE = '#arguments.action_table#'</cfif> 
                    <cfif isDefined('arguments.payroll_id') and len(arguments.payroll_id)> AND PAYROLL_ID = #arguments.payroll_id#</cfif> 
            </cfquery>
        <cfelse>
            <cfquery name="ADD_CARI" datasource="#arguments.cari_db#" result="GET_MAX_CARI">
                INSERT INTO
                    #arguments.cari_db_alias#CARI_ROWS
                    (
                        ACTION_ID,
                        ACTION_TYPE_ID,
                        ACTION_DATE,
                        PROCESS_CAT,
                        ACTION_VALUE,
                        ACTION_CURRENCY_ID,
                        <cfif len(arguments.action_currency_2)>
                        ACTION_VALUE_2,ACTION_CURRENCY_2,
                        </cfif>
                        PAYMENT_VALUE,
                        ACTION_TABLE,
                        PAPER_NO,
                        ACTION_DETAIL,
                        DUE_DATE,
                        ACTION_NAME,
                        EXPENSE_CENTER_ID,
                        EXPENSE_ITEM_ID,
                        SPECIAL_DEFINITION_ID,
                        PAYER_ID,
                        OTHER_CASH_ACT_VALUE,
                        OTHER_MONEY,
                        RATE2,
                        TO_CMP_ID,
                        FROM_CMP_ID,
                        TO_ACCOUNT_ID,
                        FROM_ACCOUNT_ID,
                        TO_CASH_ID,
                        FROM_CASH_ID,
                        TO_EMPLOYEE_ID,
                        FROM_EMPLOYEE_ID,
                        TO_CONSUMER_ID,
                        FROM_CONSUMER_ID,
                        REVENUE_COLLECTOR_ID,
                        IS_PROCESSED,
                        IS_CASH_PAYMENT,
                        ACC_TYPE_ID,
                        PAPER_ACT_DATE,
                        <cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>
                        FROM_BRANCH_ID,
                        </cfif>
                        <cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>
                        TO_BRANCH_ID,
                        </cfif>
                        <cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>
                        ASSETP_ID,
                        </cfif>
                        <cfif isdefined('arguments.project_id') and len(arguments.project_id)>
                        PROJECT_ID,
                        </cfif>
                        <cfif isdefined('arguments.payroll_id') and len(arguments.payroll_id)>
                        PAYROLL_ID,
                        </cfif>
                        <cfif arguments.period_is_integrated>IS_ACCOUNT,IS_ACCOUNT_TYPE<cfelse>IS_ACCOUNT,IS_ACCOUNT_TYPE</cfif>,
                        IS_CANCEL,
                        RECORD_DATE,
                        <cfif isDefined("session.ep.userid")>
                            RECORD_EMP,
                        <cfelseif isDefined("session.pp.userid")>
                            RECORD_PAR,
                        <cfelseif isDefined("session.ww.userid")>
                            RECORD_CONS,
                        </cfif>
                        RECORD_IP,
                        SUBSCRIPTION_ID
                    )
                VALUES
                    (
                        #arguments.action_id#,
                        #arguments.workcube_process_type#,
                        #arguments.islem_tarihi#,
                        #arguments.process_cat#,
                        #wrk_round(arguments.islem_tutari,2)#,
                        '#arguments.action_currency#',
                        <cfif len(arguments.action_currency_2)>
                            <cfif isdefined('arguments.action_value2') and len(arguments.action_value2)>#wrk_round(arguments.action_value2,2)#,<cfelseif isdefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round((arguments.islem_tutari/arguments.currency_multiplier),2)#,<cfelse>NULL,</cfif>
                            '#arguments.action_currency_2#',
                        </cfif>
                        <cfif isDefined('arguments.payment_value') and len(arguments.payment_value)>#arguments.payment_value#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.action_table') and len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.islem_belge_no') and len(arguments.islem_belge_no)>'#arguments.islem_belge_no#'<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.action_detail') and len(arguments.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(arguments.action_detail,250)#"><cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.due_date') and isdate(arguments.due_date)>#arguments.due_date#<cfelse>#arguments.islem_tarihi#</cfif>,
                        <cfif isDefined('arguments.islem_detay') and len(arguments.islem_detay)>'#LEFT(arguments.islem_detay,100)#'<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.expense_center_id') and isnumeric(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.expense_item_id') and isnumeric(arguments.expense_item_id)>#arguments.expense_item_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.special_definition_id') and isnumeric(arguments.special_definition_id)>#arguments.special_definition_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.payer_id') and isnumeric(arguments.payer_id)>#arguments.payer_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value)>#wrk_round(arguments.other_money_value,2)#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.other_money') and len(arguments.other_money)>'#arguments.other_money#'<cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.rate2") and len(arguments.rate2) and arguments.rate2 neq 0>#arguments.rate2#<cfelseif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value) and arguments.other_money_value neq 0>#arguments.islem_tutari/arguments.other_money_value#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_cmp_id') and isnumeric(arguments.to_cmp_id) and not (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id))>#arguments.to_cmp_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_cmp_id') and isnumeric(arguments.from_cmp_id) and not (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>#arguments.from_cmp_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_account_id') and isnumeric(arguments.to_account_id)>#arguments.to_account_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_account_id') and isnumeric(arguments.from_account_id)>#arguments.from_account_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_cash_id') and isnumeric(arguments.to_cash_id)>#arguments.to_cash_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_cash_id') and isnumeric(arguments.from_cash_id)>#arguments.from_cash_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)>#arguments.to_employee_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id)>#arguments.from_employee_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_consumer_id') and isnumeric(arguments.to_consumer_id)>#arguments.to_consumer_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_consumer_id') and isnumeric(arguments.from_consumer_id)>#arguments.from_consumer_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.revenue_collector_id') and isnumeric(arguments.revenue_collector_id)>#arguments.revenue_collector_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.is_processed') and isnumeric(arguments.is_processed)>#arguments.is_processed#<cfelse>0</cfif>,
                        <cfif isdefined('arguments.is_cash_payment') and len(arguments.is_cash_payment)>#arguments.is_cash_payment#<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.acc_type_id') and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
                            #arguments.acc_type_id#
                        <cfelseif (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)) or (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>
                            -1
                        <cfelse>
                            NULL
                        </cfif>,
                        <cfif isdefined('arguments.paper_act_date') and len(arguments.paper_act_date)>#arguments.paper_act_date#<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>#arguments.from_branch_id#,</cfif>
                        <cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>#arguments.to_branch_id#,</cfif>
                        <cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>#arguments.assetp_id#,</cfif>
                        <cfif isdefined('arguments.project_id') and len(arguments.project_id)>#arguments.project_id#,</cfif>
                        <cfif isdefined('arguments.payroll_id') and len(arguments.payroll_id)>#arguments.payroll_id#,</cfif>
                        <cfif arguments.period_is_integrated>1,#arguments.account_card_type#<cfelse>0,0</cfif>,
                        <cfif isdefined('arguments.is_cancel') and len(arguments.is_cancel)>#arguments.is_cancel#,<cfelse>0,</cfif>
                        #now()#,
                        <cfif isDefined("session.ep.userid")>
                            #SESSION.EP.USERID#,
                        <cfelseif isDefined("session.pp.userid")>
                            #SESSION.PP.USERID#,
                        <cfelseif isDefined("session.ww.userid")>
                            #SESSION.WW.USERID#,
                        </cfif>
                        '#CGI.REMOTE_ADDR#',
                        <cfif isDefined("arguments.subscription_id") and len(arguments.subscription_id)>#arguments.subscription_id#<cfelse>NULL</cfif>
                    )
            </cfquery>
            <cfset max_cari_action_id = GET_MAX_CARI.IDENTITYCOL>
        </cfif>
        <cfreturn 1>
    </cffunction>
    <cffunction name="cari_sil" returntype="boolean" output="false">
		<!---
        by :   20040227
        notes : Cari İşlemi Siler...Fonksiyon sorunsuz çalistiginda true döndürür.
        usage :
        cari_sil(action_id : some.action_id,workcube_old_process_type : 32);
        revisions : 
        --->
        <cfargument name="action_id" required="yes" type="numeric">
        <cfargument name="process_type" required="yes" type="numeric">
        <cfargument name="action_table" type="string">
        <cfargument name="payroll_id" type="string">
        <cfargument name="cari_db" type="string" default="#dsn2#">
        <cfargument name="cari_db_alias" type="string">
        <cfargument name="inv_related_info" type="string" default="0"><!--- fatura güncellemelerde,satır bazında vadeleşme yapılmışsa,kapamayı silmesn diye eklendi --->
        <cfargument name="is_delete_action" type="string" default="0"><!---  Ersan için tek satırlı faturaları n update işleminde talepler silinmiyor, fakat fatura silindiğinde de bu bloğa girmiyordu, o yüzden fatura silme işleminden bu parametreyi gönderiyoruz. --->
        <cfscript>
            if(arguments.cari_db is not '#dsn2#') 
            { /*cari_db argumanına session da tutulan period dısında dsn2 gonderilmesi durumunda else bolumu calısıyor. orn. ayarlar - cari devir islemi
                bu sadece carici functionında boyle muhasebeciyle karıstırılmasın. muhasebeci sadece bulundugu perioddaki dsn2'den calısır...OZDEN20070111*/
                if(arguments.cari_db is '#dsn#' or arguments.cari_db is '#dsn1#' or arguments.cari_db is '#dsn3#')		
                    arguments.cari_db_alias = '#dsn2_alias#.';
                else 
                    arguments.cari_db_alias = '#cari_db#.';
            }
            else
                arguments.cari_db_alias = '';
            if(arguments.inv_related_info neq 1)//manuel kapama işlemlernde cari bazlı çalıştıg için,cari_sil le birlikte kullanılacak, manuel kapamalarda,o kapamaya bağlı tüm hareketleri de siliniyor..Aysenur20081021
            {
                get_cari_row = cfquery(datasource:"#arguments.cari_db#",sqlstring:"SELECT ACTION_ID,CARI_ACTION_ID,ACTION_TABLE,DUE_DATE,ACTION_TYPE_ID FROM #arguments.cari_db_alias#CARI_ROWS WHERE ACTION_ID = #arguments.action_id# AND ACTION_TYPE_ID = #arguments.process_type#");
                if((get_cari_row.ACTION_TABLE eq 'INVOICE' and get_cari_row.recordcount gt 1) or get_cari_row.ACTION_TABLE neq 'INVOICE' or arguments.is_delete_action eq 1)
                {
                    //yazışmalardan gelen ödeme taleplerine bağlı olan closed ve closed_row kayıtları güncelleniyor, bu işlemlerin kapama satırı olmadığı için silme işlemi yapılmıyor
                    if (get_cari_row.recordcount)
                    {
                        get_closed_info = cfquery(datasource:"#arguments.cari_db#",sqlstring:"SELECT CLOSED_ID,CLOSED_ROW_ID,CARI_ACTION_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE RELATED_CARI_ACTION_ID = #get_cari_row.cari_action_id#");
                        if (get_closed_info.recordcount)
                        {
                            upd_cari_closed_main = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"UPDATE #arguments.cari_db_alias#CARI_CLOSED SET IS_CLOSED = NULL,DEBT_AMOUNT_VALUE = NULL,CLAIM_AMOUNT_VALUE = NULL,DIFFERENCE_AMOUNT_VALUE = NULL WHERE CLOSED_ID = #get_closed_info.closed_id[1]#");
                            for(kk=1;kk lte get_closed_info.recordcount;kk=kk+1)
                            {
                                upd_cari_closed = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"UPDATE #arguments.cari_db_alias#CARI_CLOSED_ROW SET RELATED_CLOSED_ROW_ID = NULL,RELATED_CARI_ACTION_ID=NULL,CLOSED_AMOUNT = NULL,OTHER_CLOSED_AMOUNT = NULL WHERE RELATED_CARI_ACTION_ID = #get_cari_row.cari_action_id#");
                            }
                        }
                    }
                    //normal kapama işlemlerinin silme işlemi, talep veya emir kapatan satırlar alınmasın diye related_closed_row_id ve related_cari_action_id kontrol ediliyor
                    get_closed_info = cfquery(datasource:"#arguments.cari_db#",sqlstring:"SELECT CLOSED_ID,CLOSED_ROW_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE ACTION_ID = #arguments.action_id# AND ACTION_TYPE_ID = #arguments.process_type# AND CLOSED_ROW_ID NOT IN(SELECT RELATED_CLOSED_ROW_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE RELATED_CLOSED_ROW_ID IS NOT NULL)");
                    if (get_closed_info.recordcount)
                    {
                        for(kk=1;kk lte get_closed_info.recordcount;kk=kk+1)
                        {
                            del_cari_closed = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"DELETE FROM #arguments.cari_db_alias#CARI_CLOSED WHERE CLOSED_ID = #get_closed_info.closed_id[kk]#");
                            del_cari_closed_row = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"DELETE FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE CLOSED_ID = #get_closed_info.closed_id[kk]#");
                        }
                    }
                    //cari_row a bağlı talep ve emirlerin kapama satırları siliniyor ve ilişkili işlemleri update ediliyor
                    get_closed_info = cfquery(datasource:"#arguments.cari_db#",sqlstring:"SELECT CLOSED_ID,CLOSED_ROW_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE ACTION_ID = #arguments.action_id# AND ACTION_TYPE_ID = #arguments.process_type# AND CLOSED_ROW_ID IN(SELECT RELATED_CLOSED_ROW_ID FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE RELATED_CLOSED_ROW_ID IS NOT NULL)");
                    if (get_closed_info.recordcount)
                    {
                        upd_cari_closed_main = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"UPDATE #arguments.cari_db_alias#CARI_CLOSED SET IS_CLOSED = NULL,DEBT_AMOUNT_VALUE = NULL,CLAIM_AMOUNT_VALUE = NULL,DIFFERENCE_AMOUNT_VALUE = NULL WHERE CLOSED_ID = #get_closed_info.closed_id[1]#");
                        for(kk=1;kk lte get_closed_info.recordcount;kk=kk+1)
                        {
                            upd_cari_closed = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"UPDATE #arguments.cari_db_alias#CARI_CLOSED_ROW SET RELATED_CLOSED_ROW_ID = NULL,CLOSED_AMOUNT = NULL,OTHER_CLOSED_AMOUNT = NULL WHERE RELATED_CLOSED_ROW_ID = #get_closed_info.closed_row_id[kk]#");
                            del_cari_closed_row = cfquery(datasource:"#arguments.cari_db#",is_select:false,sqlstring:"DELETE FROM #arguments.cari_db_alias#CARI_CLOSED_ROW WHERE CLOSED_ROW_ID = #get_closed_info.closed_row_id[kk]#");
                        }
                    }
                }
            }
        </cfscript>
        <cfquery name="DEL_CARI" datasource="#arguments.cari_db#">
            DELETE FROM #arguments.cari_db_alias#CARI_ROWS WHERE ACTION_ID = #arguments.action_id# AND ISNULL(IS_CANCEL,0)=0 AND ACTION_TYPE_ID = #arguments.process_type# <cfif isDefined('arguments.action_table') and len(arguments.action_table)> AND ACTION_TABLE = '#arguments.action_table#'</cfif>  <cfif isDefined('arguments.payroll_id') and len(arguments.payroll_id)> AND PAYROLL_ID = #arguments.payroll_id#</cfif>
        </cfquery>
        <cfreturn true>
    </cffunction>


    <cffunction name="get_cheque_no" returntype="any" output="false">
		<!---
        by :  20040109
        notes : sadece belge_tipi verirsek bize ilgili numarayı döndürür ama aynı anda belge_no da verirsek bu durumda
                güncelleme yapar ve true döndürür...Fonksiyon sorunsuz çalistiginda true veya belge no döndürür.
        önemli : bu fonksiyon mutlaka bir transaction arasındaki kodlar içine konmalı yada transaction yoksa yazılmalı. 
    
        usage :
        get_cheque_no
            (
            belge_tipi : payroll:çek bordro no,cheque: çek no,voucher_payroll:senet bodro no,voucher:senet no
            belge_no : bir numara alınmış ve arttırılmış ise artmış hali verilir, db güncellenir,
            );
        <cfset belge_no = get_cheque_no(belge_tipi:'payroll')>
        .....işlemler yaptim ve sonunda yine
        <cfset belge_no = get_cheque_no(belge_tipi:'payroll',belge_no:belge_no+1)> diyerek noyu kaldiğim yerde biraktim.
        revisions : 
        --->
        <cfargument name="belge_tipi" required="true" type="any">
        <cfargument name="belge_no" type="numeric">
        <cfif isDefined('arguments.belge_no') and len(arguments.belge_no)>
            <cfquery name="UPDATE_ACTION_NO_" datasource="#dsn2#">
                UPDATE #dsn3_alias#.PAPERS_NO_CHEQUE SET 
                    <cfif arguments.belge_tipi is 'payroll'>PAYROLL_NUMBER=#arguments.belge_no#</cfif>
                    <cfif arguments.belge_tipi is 'cheque'>CHEQUE_NUMBER=#arguments.belge_no#</cfif>
                    <cfif arguments.belge_tipi is 'voucher_payroll'>VOUCHER_PAYROLL_NUMBER=#arguments.belge_no#</cfif>
                    <cfif arguments.belge_tipi is 'voucher'>VOUCHER_NUMBER=#arguments.belge_no#</cfif>
            </cfquery>
            <cfreturn true>
        <cfelse>
            <cfquery name="GET_ACTION_NO_" datasource="#dsn2#">
                SELECT 
                    <cfif arguments.belge_tipi is 'payroll'>PAYROLL_NUMBER</cfif>
                    <cfif arguments.belge_tipi is 'cheque'>CHEQUE_NUMBER</cfif>
                    <cfif arguments.belge_tipi is 'voucher_payroll'>VOUCHER_PAYROLL_NUMBER</cfif>
                    <cfif arguments.belge_tipi is 'voucher'>VOUCHER_NUMBER</cfif>
                    AS BELGE_NUMBER
                FROM
                    #dsn3_alias#.PAPERS_NO_CHEQUE 
            </cfquery>
            <cfreturn GET_ACTION_NO_.BELGE_NUMBER>
        </cfif>	
    </cffunction>
    
    <!--- get_muhasebeci.cfm --->
    <cffunction name="muhasebeci" returntype="numeric" output="false">
        <!---
        by : Admin
        notes : Muhasebe fişi keser...(Tahsil-Tediye-Mahsup)
                !!! TRANSACTION icinde kullanılmalıdır !!!Fonksiyon sorunsuz çalistiginda muhasebe fişi ID sini (true) döndürür.
        usage :
        muhasebeci (
            action_id:attributes.id,
            workcube_process_type:90,
            workcube_old_process_type:90, güncellemelerde mecburi alan ; güncellemede işlemin eski proses tipi
            workcube_process_cat:,
            account_card_type:13, tahsil-tediye veya mahsup card_type_no buna göre alinir ve arttirilir.
            islem_tarihi:'#attributes.PAYROLL_REVENUE_DATE#',
            borc_hesaplar:'100,',
            borc_tutarlar:'123000,',
            other_amount_borc : '120,100' , borc tutarların doviz karsılıklarını tutar
            alacak_hesaplar:'#GET_COMPANY_PERIOD(COMPANY_ID)#,',
            alacak_tutarlar:'#toplam#,',
            other_amount_alacak : '100,120', alacak tutarların doviz karsılıklarını tutar
            other_currency_borc : '#diger_doviz#', other_amount_borc tutarlarının doviz birimini gosterir
            other_currency_alacak : '#diger_doviz2#', other_amount_alacak tutarlarının doviz birimini gosterir
            fis_detay:'#detail#',
            fis_satir_detay: fis satır acıklamalarını gosteriyor, arguman a string veya 2 boyutlu bir array gonderilebilir. 
                        string olarak gonderilisi: '12/12/2005 VADELİ ÇEK GİRİŞ İŞLEMİ',
                        array tipinde veri gonderildiginde; array[1][xxx] borc satırı açıklamalarını, array[2][xxx]  alacak satırı acıklamalarını tutar.
            belge_no : form.belge_no,
            is_account_group : is_account_group , islem kategorisinden gelir
            action_currency_2 : 'USD', ikinci para birimini tutar
            currency_multiplier : '#kur_bilgisi#', sistem ikinci para birimi icin kur bilgisini tutar
            is_other_currency : 0 , eger 1 ise muh fisinin dovizli olarak gosterilecegini (islem dovizlerini), 0 ise gosterilmeyecegini (kaydedilseler bile) set eder
            wrk_id : '' ilgili islem icin kullanilan unique deger varsa o da verilebilir
            muhasebe_db : muhasebeci fonksiyonunu transaction içinde kullanılabilmesini saglar. transaction için dsn2'den farklı kullanılan datasource bu argumana gonderilmelidir.
            muhasebe_db_alias : muhasebe_db_alias argumanına deger gonderilmemelidir, muhasebe_db argumanı DSN2'den farklıysa muhasebe_db_alias set ediliyor...
            company_id : 4 ,  Muhasebe hareketi yazılan işlemin kurumsal uye id si tutulur
            consumer_id : 15,  Muhasebe hareketi yazılan işlemin bireysel uye id si tutulur
            employee_id :  Muhasebe hareketi yazılan işlemin calisan id si tutulur
            alacak_miktarlar :'1,20,5' , satıs faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun miktarlarını gosterir
            borc_miktarlar : '1,20,5',  alış faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun miktarlarını gosterir
            alacak_birim_tutar : '15,25,45', satıs faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun fiyatını gosterir
            borc_birim_tutar : '15,25,45' alış faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun fiyatını gosterir
            is_abort : işlem kesilsinmi yoksa devam etsinmi
            );		
        revisions :20040227, 20051020, OZDEN20051101, OZDEN20051221 ,OZDEN20051230, 20060101, 20060125, OZDEN20060406, OZDEN20060421, OZDEN20060628, OZDEN20060907, OZDEN20060926, OZDEN20070411, OZDEN20070624
        UFRS_CODE eklendi OZDEN20071212
        is_abort  eklendi TolgaS 20080221
        yuvarlama bölümü eklendi OZDEN20080304
        --->
        <cfargument name="action_id" required="yes" type="numeric">
        <cfargument name="action_currency" type="string" default="">
        <cfargument name="action_currency_2" type="string" default="">
        <cfargument name="currency_multiplier" type="string" default="">
        <cfargument name="workcube_process_type" required="yes" type="numeric">
        <cfargument name="workcube_old_process_type" type="numeric">
        <cfargument name="account_card_type" required="yes" type="numeric">
        <cfargument name="account_card_catid" required="yes" type="numeric" default="0"> <!--- muhasebe fiş türünün process_cat_id si--->
        <cfargument name="islem_tarihi" required="yes" type="date">
        <cfargument name="borc_hesaplar" required="yes" type="string">
        <cfargument name="borc_tutarlar" required="yes" type="string">
        <cfargument name="alacak_hesaplar" required="yes" type="string">
        <cfargument name="alacak_tutarlar" required="yes" type="string">
        <cfargument name="other_amount_borc" type="string" default="">	
        <cfargument name="other_amount_alacak" type="string" default="">	
        <cfargument name="other_currency_borc" type="string" default="">
        <cfargument name="other_currency_alacak" type="string" default="">
        <cfargument name="belge_no" type="string" default="">
        <cfargument name="belge_no_satir" type="string" default="">
        <cfargument name="fis_detay" type="string">
        <cfargument name="fis_satir_detay" default="">
        <cfargument name="wrk_id" type="string" default="">
        <cfargument name="muhasebe_db" type="string" default="#dsn2#">
        <cfargument name="muhasebe_db_alias" type="string" default="">
        <cfargument name="company_id" default="">
        <cfargument name="consumer_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="alacak_miktarlar" default="">
        <cfargument name="borc_miktarlar" default="">
        <cfargument name="alacak_birim_tutar" default="">
        <cfargument name="borc_birim_tutar" default="">
        <cfargument name="is_account_group" type="numeric" default="0">
        <cfargument name="is_other_currency" type="numeric" default="0"><!--- 0: muhasebe fisi dovizli goruntulenMEsin, 1: goruntulensin --->
        <cfargument name="base_period_year_start" default="">
        <cfargument name="base_period_year_finish" default="">
        <cfargument name="action_table" type="string"> <!--- payrollda cek bazlı muhasebe islemi yapılabilmesi icin eklendi --->
        <cfargument name="from_branch_id">
        <cfargument name="to_branch_id">
        <cfargument name="acc_department_id">
        <cfargument name="acc_project_id">
        <cfargument name="acc_project_list_alacak" type="string" default="">
        <cfargument name="acc_project_list_borc" type="string" default="">
        <cfargument name="acc_branch_list_alacak" type="string" default="">
        <cfargument name="acc_branch_list_borc" type="string" default="">
        <cfargument name="is_abort" type="numeric" default="1">
        <cfargument name="dept_round_account" default=""> <!---muhasebe fisi borc-alacak toplamları arasındaki BORC FARKI icin kullanılacak yuvarlama hesabı --->
        <cfargument name="claim_round_account" default=""> <!---muhasebe fisi borc-alacak toplamları arasındaki ALACAK FARKI icin kullanılacak yuvarlama hesabı --->
        <cfargument name="max_round_amount" default="0"> <!---borc-alacak toplamları arasında yuvarlama yapılabilecek max. fark --->
        <cfargument name="round_row_detail" default=""><!--- yuvarlama satırı acıklama bilgisi, gönderilmezse yuvarlama satırına fis_detay bilgisi yazılır --->
        <cfargument name="workcube_process_cat" default=""> <!--- islem kategorisi process_cat_id --->
        <cfargument name="action_row_id" default="">
        <cfargument name="due_date" default="">
        <cfargument name="is_cancel">
        <cfargument name="document_type" default="">
        <cfargument name="payment_method" default="">
        <cfargument name="is_acc_type" default="0">

        <cfif isdefined("session.pp")>
            <cfset session_base = evaluate('session.pp')>
        <cfelseif isdefined("session.ep")>
            <cfset session_base = evaluate('session.ep')>
        <cfelseif isdefined("session.ww")>
            <cfset session_base = evaluate('session.ww')>
        <cfelseif isdefined("session.wp")>
            <cfset session_base = evaluate('session.wp')>
        </cfif>

        <cfif not IsDefined("arguments.action_currency") or ( IsDefined("arguments.action_currency") && not len(arguments.action_currency) )>
            <cfset arguments.action_currency = session_base.money />
        </cfif>
        <cfif not IsDefined("arguments.action_currency_2") or ( IsDefined("arguments.action_currency_2") && not len(arguments.action_currency_2) )>
            <cfset arguments.action_currency_2 = session_base.money2 />
        </cfif>
        
        <cfif isDefined('session.ep.userid')>
            <cfif not len(arguments.base_period_year_start)>
                <cfset arguments.base_period_year_start = year(session.ep.period_start_date)>
            </cfif>
            <cfif not len(arguments.base_period_year_finish)>
                <cfset arguments.base_period_year_finish = year(session.ep.period_finish_date)>
            </cfif>   
        </cfif>
        <cfscript>
            if(arguments.muhasebe_db_alias == '' and arguments.muhasebe_db is not '#dsn2#')
            {
                if(arguments.muhasebe_db is '#dsn#' or arguments.muhasebe_db is '#dsn1#' or arguments.muhasebe_db is '#dsn3#')		
                    arguments.muhasebe_db_alias = '#dsn2_alias#.';
                else 
                    arguments.muhasebe_db_alias = '#muhasebe_db#.';
            }
            else
            {
                arguments.muhasebe_db_alias = '#arguments.muhasebe_db_alias#.';
            }
        </cfscript>
        <cfif len(arguments.workcube_process_cat) and arguments.workcube_process_cat neq 0 and arguments.is_acc_type eq 0>
		
            <cfquery name="getProcessCat" datasource="#arguments.muhasebe_db#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
                SELECT
                    ACCOUNT_TYPE_ID
                FROM
                    #dsn3#.SETUP_PROCESS_CAT
                WHERE
                    PROCESS_CAT_ID = #arguments.workcube_process_cat#
            </cfquery>
			
            <cfif len(getProcessCat.account_type_id) and (len(arguments.company_id) or len(arguments.consumer_id))>
			
                <!--- üyenin muhasebe kodu tespit edilmeye çalışılıyor --->
                <cfif len(arguments.company_id)>
                    <cfset member_account_code = get_company_period(company_id : arguments.company_id, basket_money_db : arguments.muhasebe_db)>
                    <cfquery name = "getAccCode" datasource = "#arguments.muhasebe_db#">
                        SELECT * FROM #dsn_alias#.COMPANY_PERIOD WHERE COMPANY_ID = #arguments.company_id# AND PERIOD_ID = #session_base.period_id#
                    </cfquery>
                <cfelseif len(arguments.consumer_id)>
                    <cfset member_account_code = get_consumer_period(consumer_id : arguments.consumer_id, basket_money_db : arguments.muhasebe_db)>
                    <cfquery name = "getAccCode" datasource = "#arguments.muhasebe_db#">
                        SELECT * FROM #dsn_alias#.CONSUMER_PERIOD WHERE PERIOD_ID = #arguments.consumer_id# AND PERIOD_ID = #session_base.period_id#
                    </cfquery>
                </cfif>
                <cfswitch expression = "#getProcessCat.account_type_id#">
                    <cfcase value = "-1">
                        <cfset new_account_code = getAccCode.account_code>
                    </cfcase>
                    <cfcase value = "-2">
                        <cfset new_account_code = getAccCode.sales_account>
                    </cfcase>
                    <cfcase value = "-3">
                        <cfset new_account_code = getAccCode.purchase_account>
                    </cfcase>
                    <cfcase value = "-4">
                        <cfset new_account_code = getAccCode.received_advance_account>
                    </cfcase>
                    <cfcase value = "-5">
                        <cfset new_account_code = getAccCode.advance_payment_code>
                    </cfcase>
                    <cfcase value = "-6">
                        <cfset new_account_code = getAccCode.received_guarantee_account>
                    </cfcase>
                    <cfcase value = "-7">
                        <cfset new_account_code = getAccCode.given_guarantee_account>
                    </cfcase>
                    <cfcase value = "-8">
                        <cfset new_account_code = getAccCode.konsinye_code>
                    </cfcase>
                    <cfcase value = "-9">
                        <cfset new_account_code = getAccCode.EXPORT_REGISTERED_SALES_ACCOUNT>
                    </cfcase>
                    <cfcase value = "-10">
                        <cfset new_account_code = getAccCode.EXPORT_REGISTERED_BUY_ACCOUNT>
                    </cfcase>
                    <cfdefaultcase><cfset new_account_code = ""></cfdefaultcase>
                </cfswitch>
                <cfscript>
                    if(len(new_account_code)) {
                        // alacak hesaplarda carinin muhasebe kodu var mı?
                        alacakIndex = listFind(arguments.alacak_hesaplar,new_account_code);

                        // borc hesaplarda carinin muhasebe kodu var mı?
                        borcIndex = listFind(arguments.borc_hesaplar,new_account_code);

                        if(alacakIndex gt 0) {
                            arguments.alacak_hesaplar = listSetAt(arguments.alacak_hesaplar,alacakIndex,new_account_code);
                        }
                        if(borcIndex gt 0) {
                            arguments.borc_hesaplar = listSetAt(arguments.borc_hesaplar,borcIndex,new_account_code);
                        }
                    }
                </cfscript>
            </cfif>
        </cfif>
        <!--- e-defter islem kontrolu FA --->
        <cfif isDefined('session_base.our_company_info.is_edefter') and session_base.our_company_info.is_edefter eq 1>
            <cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>
                <cfquery name="GET_CARD_ID" datasource="#arguments.muhasebe_db#">
                     SELECT
                        ACTION_DATE
                     FROM
                        #arguments.muhasebe_db_alias#ACCOUNT_CARD
                     WHERE
                        ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                        AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_old_process_type#">
                        <cfif isDefined('arguments.action_table') and len(arguments.action_table)> 
                            AND ACTION_TABLE = '#arguments.action_table#'
                        </cfif>
                        <cfif len(arguments.action_row_id)> 
                            AND ACTION_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_row_id#">
                        </cfif>
                </cfquery>
                <cfif GET_CARD_ID.RECORDCOUNT>
                    <cfset netbook_date = GET_CARD_ID.ACTION_DATE>
                <cfelse>
                    <cfset netbook_date = ''>
                </cfif>
            <cfelse>
                <cfset netbook_date = ''>
            </cfif>
            <cfstoredproc procedure="GET_NETBOOK" datasource="#arguments.muhasebe_db#">
                <cfprocparam cfsqltype="cf_sql_timestamp" value="#netbook_date#" null="#not(len(netbook_date))#">
                <cfprocparam cfsqltype="cf_sql_timestamp" value="#arguments.islem_tarihi#">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.muhasebe_db_alias#">
                <cfprocresult name="getNetbook">
            </cfstoredproc>
            <cfif getNetbook.recordcount>
            	<script type="text/javascript">
					alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
				</script>
                <cfabort>
            </cfif>
        </cfif>
        <!--- e-defter islem kontrolu FA --->
        
        <cfif len(arguments.account_card_type) and arguments.account_card_catid eq 0 or not len(arguments.account_card_catid)>
            <cfquery name="CONTROL_ACC_CARD_PROCESS_" datasource="#arguments.muhasebe_db#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
                SELECT
                    PROCESS_CAT_ID,PROCESS_CAT,
                    PROCESS_TYPE,DISPLAY_FILE_NAME,
                    DISPLAY_FILE_FROM_TEMPLATE
                FROM
                    <cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT <!--- işlem kategorilerinin action fileların tanımlı olmama durumu için eklendi --->
                WHERE
                    PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_card_type#">
                    AND IS_DEFAULT=1		
            </cfquery>
            <cfif control_acc_card_process_.recordcount eq 0>
                <cfscript>
                    if(arguments.account_card_type eq 13)
                        alert_card_type_name='Mahsup';
                    else if(arguments.account_card_type eq 12)
                        alert_card_type_name='Tediye';
                    else if(arguments.account_card_type eq 11)
                        alert_card_type_name='Tahsil';
                </cfscript>
				<script type="text/javascript">
                    alert('Muhasebeci: Standart <cfoutput>#alert_card_type_name#</cfoutput> Fişi İşlem Kategorisi Tanımlı Değil! İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız!');
                </script>
                <cfabort>
            <cfelse>
                <cfset arguments.account_card_catid=control_acc_card_process_.process_cat_id>
            </cfif>
        </cfif>
        <cfif isdefined("session.pp")>
            <cfset session_base = evaluate('session.pp')>
        <cfelseif isdefined("session.ep")>
            <cfset session_base = evaluate('session.ep')>
        <cfelseif isdefined('session.ww')>
            <cfset session_base = evaluate('session.ww')>
        <cfelseif isdefined('session.wp')>
            <cfset session_base = evaluate('session.wp')>
        </cfif>
        <cfif ((isDefined('arguments.base_period_year_start') and year(arguments.islem_tarihi) lt arguments.base_period_year_start) or (isDefined('arguments.base_period_year_finish') and len(arguments.base_period_year_finish) and year(arguments.islem_tarihi) gt arguments.base_period_year_finish)) and workcube_process_type neq 130 and workcube_process_type neq 161>
			<script type="text/javascript">
                alert('Muhasebeci : İşlem Tarihi Döneme Uygun Değil.');
            </script>
            <cfabort>
        </cfif>
        <cfif len(arguments.other_amount_borc) and listlen(arguments.other_amount_borc,',') neq listlen(arguments.borc_tutarlar,',')>
			<script type="text/javascript">
                alert('Muhasebeci : Dövizli Borç Listesi Eksik.');
            </script>
            <cfabort>
        </cfif>
        <cfif len(arguments.other_amount_alacak) and listlen(arguments.other_amount_alacak,',') neq listlen(arguments.alacak_tutarlar,',')>
			<script type="text/javascript">
                alert('Muhasebeci : Dövizli Alacak Listesi Eksik.');
            </script>
            <cfabort>
        </cfif>
        <cfif len(arguments.action_currency_2) and (not len(arguments.currency_multiplier))>
			<cfscript>
                get_currency_rate = cfquery(datasource:"#arguments.muhasebe_db#", sqlstring:"SELECT (RATE2/RATE1) RATE FROM #arguments.muhasebe_db_alias#SETUP_MONEY WHERE MONEY ='#arguments.action_currency_2#'");
                if(get_currency_rate.recordcount) arguments.currency_multiplier = get_currency_rate.RATE;
			</cfscript>
        </cfif>
        <cfscript>
            muh_query = QueryNew("BA,ACCOUNT_CODE,AMOUNT,OTHER_AMOUNT,OTHER_CURRENCY,DETAIL,QUANTITY,PRICE,ACC_PROJECT_ID,ACC_BRANCH_ID","Bit,VarChar,Double,Double,Varchar,Varchar,Double,Double,Double,Double");
            muh_query_row = 0;
            borc_hesaplar_total = 0;
            alacak_hesaplar_total = 0;
            other_borc_hesaplar_total = 0;
            other_alacak_hesaplar_total = 0;
            for(i_index=1;i_index lte listlen(arguments.borc_hesaplar,',');i_index=i_index+1){
                if((wrk_round(listgetat(arguments.borc_tutarlar,i_index,','),4) gt 0 and len(listgetat(arguments.borc_hesaplar,i_index,',')) gt 0) or (listlen(arguments.other_amount_borc) and wrk_round(listgetat(arguments.other_amount_borc,i_index,','),4) gt 0 and len(listgetat(arguments.borc_hesaplar,i_index,',')) gt 0))
                    {
                    muh_query_row = muh_query_row + 1;
                    QueryAddRow(muh_query,1);
                    QuerySetCell(muh_query,"BA",0,muh_query_row);
                    QuerySetCell(muh_query,"ACCOUNT_CODE",listgetat(arguments.borc_hesaplar,i_index,','),muh_query_row);
                    {
                        QuerySetCell(muh_query,"AMOUNT",listgetat(arguments.borc_tutarlar,i_index,','),muh_query_row);
                        if(len(arguments.other_amount_borc)){
                            QuerySetCell(muh_query,"OTHER_AMOUNT",listgetat(arguments.other_amount_borc,i_index,','),muh_query_row);
                            QuerySetCell(muh_query,"OTHER_CURRENCY",listgetat(arguments.other_currency_borc,i_index,','),muh_query_row);
                            }
                    }
                    if(IsArray(arguments.fis_satir_detay) and Arraylen(arguments.fis_satir_detay[1]) gte i_index)
                    {
                         
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir))
                            arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],listgetat(arguments.belge_no_satir,i_index,','),'','all');
                        else if (len(arguments.belge_no))
                            arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],arguments.belge_no,'','all');
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir)){
                            if(len(listgetat(arguments.belge_no_satir,i_index,',')) and not findnocase(listgetat(arguments.belge_no_satir,i_index,','),arguments.fis_satir_detay[1][i_index]))
                            {
                                arguments.fis_satir_detay[1][i_index] =  listgetat(arguments.belge_no_satir,i_index,',')&"-"&arguments.fis_satir_detay[1][i_index] ;
                                arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'- -','-');
                                arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'--','-');
                            }
                        }
                        else if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay[1][i_index]))
                        {
                            arguments.fis_satir_detay[1][i_index] =  arguments.belge_no&"-"&arguments.fis_satir_detay[1][i_index] ;
                            arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'- -','-');
                            arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'--','-');
                        }
                        QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay[1][i_index],muh_query_row);
                    }
                    else if (not IsArray(arguments.fis_satir_detay))
                    {
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir))
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,"#arguments.belge_no_satir# - ",'','all');
                        else if(len(arguments.belge_no))
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,"#arguments.belge_no# - ",'','all');

                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir)){
                            if(len(arguments.belge_no_satir) and not findnocase(arguments.belge_no_satir,arguments.fis_satir_detay))
                            {
                                arguments.fis_satir_detay =  arguments.belge_no_satir&"-"&arguments.fis_satir_detay;
                                arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
                                arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'--','-');
                            }
                         }
                        else if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay))
                        {
                            arguments.fis_satir_detay =  arguments.belge_no&"-"&arguments.fis_satir_detay;
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'--','-');
                        }
                        QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay,muh_query_row);
                    }
                    if(IsArray(arguments.borc_miktarlar) and Arraylen(arguments.borc_miktarlar) gte i_index)
                        QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar[i_index],muh_query_row);
                    else if (not IsArray(arguments.borc_miktarlar))
                        QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar,muh_query_row);
                    if(IsArray(arguments.borc_birim_tutar) and Arraylen(arguments.borc_birim_tutar) gte i_index)
                        QuerySetCell(muh_query,"PRICE",arguments.borc_birim_tutar[i_index],muh_query_row);
                    else if (not IsArray(arguments.borc_birim_tutar))
                        QuerySetCell(muh_query,"PRICE",arguments.borc_birim_tutar,muh_query_row);
                    if(listlen(arguments.acc_project_list_borc))
                        QuerySetCell(muh_query,"ACC_PROJECT_ID",listgetat(arguments.acc_project_list_borc,i_index,','),muh_query_row);
                    else if (not listlen(arguments.acc_project_list_borc))
                        QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
                    if(len(arguments.acc_branch_list_borc))
                        QuerySetCell(muh_query,"ACC_BRANCH_ID",listgetat(arguments.acc_branch_list_borc,i_index,','),muh_query_row);
                    else
                        QuerySetCell(muh_query,"ACC_BRANCH_ID",0,muh_query_row);
                    }
            }
            for(i_index=1;i_index lte listlen(arguments.alacak_hesaplar,',');i_index=i_index+1){
                if((wrk_round(listgetat(arguments.alacak_tutarlar,i_index,','),4) gt 0 and len(listgetat(arguments.alacak_hesaplar,i_index,',')) gt 0) or (listlen(arguments.other_amount_alacak) and wrk_round(listgetat(arguments.other_amount_alacak,i_index,','),4) gt 0 and len(listgetat(arguments.alacak_hesaplar,i_index,',')) gt 0))
                    {
                    muh_query_row = muh_query_row + 1;
                    QueryAddRow(muh_query,1);
                    QuerySetCell(muh_query,"BA",1,muh_query_row);
                    QuerySetCell(muh_query,"ACCOUNT_CODE",listgetat(arguments.alacak_hesaplar,i_index,','),muh_query_row);
                    {
                        QuerySetCell(muh_query,"AMOUNT",listgetat(arguments.alacak_tutarlar,i_index,','),muh_query_row);
                        if(len(arguments.other_amount_alacak)){
                            QuerySetCell(muh_query,"OTHER_AMOUNT",listgetat(arguments.other_amount_alacak,i_index,','),muh_query_row);
                            QuerySetCell(muh_query,"OTHER_CURRENCY",listgetat(arguments.other_currency_alacak,i_index,','),muh_query_row);
                            }	
                    }
                    if(IsArray(arguments.fis_satir_detay) and Arraylen(arguments.fis_satir_detay[2]) gte i_index)
                    {
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir)){
                            if(len(listgetat(arguments.belge_no_satir,i_index,',')) and not findnocase(listgetat(arguments.belge_no_satir,i_index,','),arguments.fis_satir_detay[2][i_index]))
                            {
                                arguments.fis_satir_detay[2][i_index] =  listgetat(arguments.belge_no_satir,i_index,',')&"-"&arguments.fis_satir_detay[2][i_index] ;
                                arguments.fis_satir_detay[2][i_index] = replace(arguments.fis_satir_detay[2][i_index],'- -','-');
                            }
                         }
                        else if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay[2][i_index]))
                        {
                            arguments.fis_satir_detay[2][i_index] =  arguments.belge_no&"-"&arguments.fis_satir_detay[2][i_index] ;
                            arguments.fis_satir_detay[2][i_index] = replace(arguments.fis_satir_detay[2][i_index],'- -','-');
                        }
                        QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay[2][i_index],muh_query_row);
                    }
                    else if (not IsArray(arguments.fis_satir_detay))
                    {
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir)){
                            if(len(listgetat(arguments.belge_no_satir,i_index,',')) and not findnocase(listgetat(arguments.belge_no_satir,i_index,','),arguments.fis_satir_detay))
                            {
                                arguments.fis_satir_detay =  listgetat(arguments.belge_no_satir,i_index,',')&"-"&arguments.fis_satir_detay ;
                                arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
                            }
                        }
                        else if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay))
                        {
                            arguments.fis_satir_detay =  arguments.belge_no&"-"&arguments.fis_satir_detay ;
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
                        }
                        QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay,muh_query_row);
                    }
                    if(IsArray(arguments.alacak_miktarlar) and Arraylen(arguments.alacak_miktarlar) gte i_index)
                        QuerySetCell(muh_query,"QUANTITY",arguments.alacak_miktarlar[i_index],muh_query_row);
                    else if (not IsArray(arguments.alacak_miktarlar))
                        QuerySetCell(muh_query,"QUANTITY",arguments.alacak_miktarlar,muh_query_row);
                    if(IsArray(arguments.alacak_birim_tutar) and Arraylen(arguments.alacak_birim_tutar) gte i_index)
                        QuerySetCell(muh_query,"PRICE",arguments.alacak_birim_tutar[i_index],muh_query_row);
                    else if (not IsArray(arguments.alacak_birim_tutar))
                        QuerySetCell(muh_query,"PRICE",arguments.alacak_birim_tutar,muh_query_row);
                    if(listlen(arguments.acc_project_list_alacak))
                        QuerySetCell(muh_query,"ACC_PROJECT_ID",listgetat(arguments.acc_project_list_alacak,i_index,','),muh_query_row);
                    else if (not listlen(arguments.acc_project_list_alacak))
                        QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
                    if(len(arguments.acc_branch_list_alacak) and listlen(arguments.acc_branch_list_alacak,',') gte i_index)
                        QuerySetCell(muh_query,"ACC_BRANCH_ID",listgetat(arguments.acc_branch_list_alacak,i_index,','),muh_query_row);
                    else
                        QuerySetCell(muh_query,"ACC_BRANCH_ID",0,muh_query_row);
                    }
            }
            /*20040112 alttaki iki satirda fatura para biriminin kuruş durumuna göre round işlemi yapılmalı yoksa kuruş kaçar*/
            //alacak_hesaplar_total = wrk_round(alacak_hesaplar_total,2);
            //borc_hesaplar_total = wrk_round(borc_hesaplar_total,2);
            if( arguments.is_account_group )
            {
                if(not len(session_base.our_company_info.is_project_group) or session_base.our_company_info.is_project_group eq 1)//şirket akış parametrelerinde proje bazında grupla seçili ise
                    muh_query = cfquery(dbtype:'query',datasource:"",sqlstring:"SELECT SUM(OTHER_AMOUNT) OTHER_AMOUNT,SUM(AMOUNT) AMOUNT,ACC_PROJECT_ID, BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL,SUM(QUANTITY) QUANTITY, SUM(PRICE) PRICE FROM muh_query GROUP BY ACC_PROJECT_ID,BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL ORDER BY BA");
                else
                    muh_query = cfquery(dbtype:'query',datasource:"",sqlstring:"SELECT SUM(OTHER_AMOUNT) OTHER_AMOUNT,SUM(AMOUNT) AMOUNT,0 ACC_PROJECT_ID, BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL,SUM(QUANTITY) QUANTITY, SUM(PRICE) PRICE FROM muh_query GROUP BY BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL ORDER BY BA");
            }
            is_ifrs = 0;
            if(isDefined("session_base") and len(session_base.our_company_info.is_ifrs eq 1))
                is_ifrs = 1;
            else if(isDefined("session.pp.userid") and len(session.pp.our_company_info.is_ifrs eq 1))
                is_ifrs = 1;
            else if(isDefined("session.ww.userid") and len(session.ww.our_company_info.is_ifrs eq 1))
                is_ifrs = 1;
                
            if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_detay))
                arguments.fis_detay =  arguments.belge_no&" No'lu "&arguments.fis_detay ;
            for(cnt_i=1;cnt_i lte muh_query.recordcount;cnt_i=cnt_i+1) //borc alacak toplamı bulunup, fiste fark var mı bakılır
            {
                if(muh_query.BA[cnt_i] eq 1)
                {
                    alacak_hesaplar_total = alacak_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_i]);
                    if(len(muh_query.OTHER_AMOUNT[cnt_i]))
                        other_alacak_hesaplar_total = other_alacak_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_i]);
                }
                else if (muh_query.BA[cnt_i] eq 0)
                {
                    borc_hesaplar_total = borc_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_i]);
                    if(len(muh_query.OTHER_AMOUNT[cnt_i]))
                        other_borc_hesaplar_total = other_borc_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_i]);
                }
            }
            
            if(wrk_round(alacak_hesaplar_total) is not wrk_round(borc_hesaplar_total) or wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0) // borc-alacak tutmayan fisler icin yuvarlama yapılıyor
            {
                temp_fark = round((alacak_hesaplar_total-borc_hesaplar_total)*100);
                
                if(temp_fark gte (arguments.max_round_amount*-100) and temp_fark lt 0 and len(arguments.claim_round_account))
                {// fark alacaklilara eklenmeli, borc bakiye gelmis,muhasebeci querysine fark satırı ekleniyor
                    muh_query_row = muh_query.recordcount + 1;
                    QueryAddRow(muh_query,1);
                    QuerySetCell(muh_query,"BA",1,muh_query_row);
                    QuerySetCell(muh_query,"ACCOUNT_CODE",claim_round_account,muh_query_row);
                    QuerySetCell(muh_query,"AMOUNT",abs(temp_fark/100),muh_query_row);
                    QuerySetCell(muh_query,"OTHER_AMOUNT",abs(temp_fark/100),muh_query_row);
                    QuerySetCell(muh_query,"OTHER_CURRENCY",session_base.money,muh_query_row);
                    QuerySetCell(muh_query,"DETAIL",arguments.fis_detay,muh_query_row);
                    QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
                }
                else if(temp_fark lte (arguments.max_round_amount*100) and temp_fark gt 0 and len(arguments.dept_round_account))
                {//fark borclulara eklenmeli, alacak bakiye gelmis,muhasebeci querysine fark satırı ekleniyor 
                    muh_query_row = muh_query.recordcount + 1;
                    QueryAddRow(muh_query,1);
                    QuerySetCell(muh_query,"BA",0,muh_query_row);
                    QuerySetCell(muh_query,"ACCOUNT_CODE",dept_round_account,muh_query_row);
                    QuerySetCell(muh_query,"AMOUNT",abs(temp_fark/100),muh_query_row);
                    QuerySetCell(muh_query,"OTHER_AMOUNT",abs(temp_fark/100),muh_query_row);
                    QuerySetCell(muh_query,"OTHER_CURRENCY",session_base.money,muh_query_row);
                    QuerySetCell(muh_query,"DETAIL",arguments.fis_detay,muh_query_row);
                    QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
                }
                //yuvarlama satırı da eklenlendikten sonra fark olup olmadıgı yeniden kontrol ediliyor
                alacak_hesaplar_total =0;
                borc_hesaplar_total = 0;
                other_alacak_hesaplar_total =0;
                other_borc_hesaplar_total = 0;
                for(cnt_k=1;cnt_k lte muh_query.recordcount;cnt_k=cnt_k+1)
                {
                    if(muh_query.BA[cnt_k] eq 1)
                    {
                        alacak_hesaplar_total = alacak_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_k]);
                        if(len(muh_query.OTHER_AMOUNT[cnt_k]))
                            other_alacak_hesaplar_total = other_alacak_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_k]);
                    }
                    else if (muh_query.BA[cnt_k] eq 0)
                    {
                        borc_hesaplar_total = borc_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_k]);
                        if(len(muh_query.OTHER_AMOUNT[cnt_k]))
                        other_borc_hesaplar_total = other_borc_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_k]);
                    }
                }
            }
        </cfscript>
        <cfif (alacak_hesaplar_total eq 0) and (borc_hesaplar_total eq 0) and (other_borc_hesaplar_total eq 0) and (other_alacak_hesaplar_total eq 0)><!---Muhasebe Fisi Toplam Tutari Yoksa Hareket Yazmaz--->
            <cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>
                <cfscript>muhasebe_sil(action_id:arguments.action_id, process_type:arguments.workcube_old_process_type, muhasebe_db:arguments.muhasebe_db);</cfscript>
            </cfif>
            <cfreturn 0>
        </cfif>
        <cfif wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0 or (arguments.workcube_process_type eq 111 and (listlen(arguments.alacak_tutarlar) neq listlen(arguments.alacak_hesaplar) or listlen(arguments.borc_tutarlar) neq listlen(arguments.borc_hesaplar)))>
        <!--- yuvarlama hesabı henuz alerta dahil edilmedi --->
            <cfif workcube_mode>
				<script type="text/javascript">
                <cfoutput>
                    var alert_str="#getLang('','Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil','59057')#";
                    alert_str = alert_str + "\n#getLang('','Borç Hesaplar','64908')#\n";
                    <cfloop from="1" to="#listlen(arguments.borc_hesaplar,',')#" index="i">
                        alert_str = alert_str + '<cfoutput>#listgetat(arguments.borc_hesaplar,i,',')#=#TLFormat(listgetat(arguments.borc_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
                    </cfloop>
                    alert_str = alert_str + "#getLang('','Toplam','57492')# #getLang('','Borç Hesaplar','64908')# = #TLFormat(borc_hesaplar_total)#\n";
                    alert_str = alert_str + "\n#getLang('','Alacak Hesaplar','65108')#:\n";
                    <cfloop from="1" to="#listlen(arguments.alacak_hesaplar,',')#" index="i">
                        alert_str = alert_str + '<cfoutput>#listgetat(arguments.alacak_hesaplar,i,',')#=#TLFormat(listgetat(arguments.alacak_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
                    </cfloop>
                    alert_str = alert_str + "#getLang('','Toplam','57492')# #getLang('','Alacak Hesaplar','65108')# = #TLFormat(alacak_hesaplar_total)#\n\n";
                    alert_str = alert_str + "#getLang('','Fark','58583')#  = #TLFormat(borc_hesaplar_total-alacak_hesaplar_total)# <cfif borc_hesaplar_total gt alacak_hesaplar_total>(B)<cfelse>(A)</cfif>";
                </cfoutput>
                    alert(alert_str);
                </script>
                <cfabort>
            <cfelse>
                <cfif arguments.workcube_process_type eq 111 and (listlen(arguments.alacak_tutarlar) neq listlen(arguments.alacak_hesaplar) or listlen(arguments.borc_tutarlar) neq listlen(arguments.borc_hesaplar))>
                    
                    <script type="text/javascript">
                     <cfoutput> 
                        alert_str = 'Borç-Alacak Hesaplarında Eksik Tanımlamalar Mevcut!';
                    </cfoutput>
						alert(alert_str);
                    </script>
                    <cfabort>
                <cfelse>
                    <!--- baskette kur sorunlarına sebep oldugundan acıklama yukardaki gibi degistirildi, bu bölüm sadece development modda calısıyor --->
                   <script type="text/javascript">
                    <cfoutput>
                        var alert_str="#getLang('','Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil','59057')#";
                        alert_str = alert_str + "\n#getLang('','Borç Hesaplar','64908')#\n";
                        <cfloop from="1" to="#listlen(arguments.borc_hesaplar,',')#" index="i">
                            alert_str = alert_str + '<cfoutput>#listgetat(arguments.borc_hesaplar,i,',')#=#TLFormat(listgetat(arguments.borc_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
                        </cfloop>
                        alert_str = alert_str + "#getLang('','Toplam','57492')# #getLang('','Borç Hesaplar','64908')#  = #TLFormat(borc_hesaplar_total)#\n";
                        alert_str = alert_str + "\n#getLang('','Alacak Hesaplar','65108')#:\n";
                        <cfloop from="1" to="#listlen(arguments.alacak_hesaplar,',')#" index="i">
                            alert_str = alert_str + '<cfoutput>#listgetat(arguments.alacak_hesaplar,i,',')#=#TLFormat(listgetat(arguments.alacak_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
                        </cfloop>
                        alert_str = alert_str + "#getLang('','Toplam','57492')# #getLang('','Alacak Hesaplar','65108')# = #TLFormat(alacak_hesaplar_total)#\n\n";
                        alert_str = alert_str + "#getLang('','Fark','58583')# = #TLFormat(borc_hesaplar_total-alacak_hesaplar_total)# <cfif borc_hesaplar_total gt alacak_hesaplar_total>(B)<cfelse>(A)</cfif>";
                    </cfoutput>
                        alert(alert_str);
                        window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
                    </script>
                     <cfabort>
                </cfif>
            </cfif>
        </cfif>
        <cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>
            <cfquery name="GET_CARD_ID" datasource="#arguments.muhasebe_db#">
                 SELECT
                    *
                 FROM
                    #arguments.muhasebe_db_alias#ACCOUNT_CARD
                 WHERE
                    ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                    AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_old_process_type#">
                    AND ISNULL(IS_CANCEL,0)=0
                    <cfif isDefined('arguments.action_table') and len(arguments.action_table)> 
                        AND ACTION_TABLE = '#arguments.action_table#'
                    </cfif>
                    <cfif len(arguments.action_row_id)> 
                        AND ACTION_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_row_id#">
                    </cfif>
            </cfquery>
            <cfif GET_CARD_ID.RECORDCOUNT>
                <cfquery name="ADD_ACCOUNT_CARD_HISTORY" datasource="#arguments.muhasebe_db#">
                    INSERT INTO
                        #arguments.muhasebe_db_alias#ACCOUNT_CARD_HISTORY
                        (
                            CARD_ID,
                            WRK_ID,
                            ACTION_ID,
                            IS_ACCOUNT,
                            BILL_NO,
                            CARD_DETAIL,
                            CARD_TYPE,
                            CARD_CAT_ID,
                            CARD_TYPE_NO,
                            ACTION_TYPE,
                            ACTION_CAT_ID,
                            ACTION_DATE,
                            ACTION_TABLE,
                            PAPER_NO,
                            ACC_COMPANY_ID,
                            ACC_CONSUMER_ID,
                            ACC_EMPLOYEE_ID,
                            IS_OTHER_CURRENCY,
                            RECORD_EMP_OLD,
                            RECORD_PAR_OLD,
                            RECORD_CONS_OLD,
                            RECORD_IP_OLD,
                            RECORD_DATE_OLD,
                            <cfif isDefined("session.ep.userid")>
                                RECORD_EMP,
                            <cfelseif isDefined("session.pp.userid")>
                                RECORD_PAR,
                            <cfelseif isDefined("session.ww.userid")>
                                RECORD_CONS,
                            </cfif>
                            RECORD_IP,
                            RECORD_DATE,
                            ACTION_ROW_ID,
                            DUE_DATE,
                            CARD_DOCUMENT_TYPE,
                            CARD_PAYMENT_METHOD
                        )
                    VALUES
                        (
                            #GET_CARD_ID.CARD_ID#,
                            <cfif len(GET_CARD_ID.WRK_ID)>'#GET_CARD_ID.WRK_ID#'<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.ACTION_ID)>#GET_CARD_ID.ACTION_ID#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.IS_ACCOUNT)>#GET_CARD_ID.IS_ACCOUNT#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.BILL_NO)>#GET_CARD_ID.BILL_NO#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.CARD_DETAIL)>#sql_unicode()#'#GET_CARD_ID.CARD_DETAIL#'<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.CARD_TYPE)>#GET_CARD_ID.CARD_TYPE#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.CARD_CAT_ID)>#GET_CARD_ID.CARD_CAT_ID#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.CARD_TYPE_NO)>#GET_CARD_ID.CARD_TYPE_NO#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.ACTION_TYPE)>#GET_CARD_ID.ACTION_TYPE#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.ACTION_CAT_ID)>#GET_CARD_ID.ACTION_CAT_ID#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.ACTION_DATE)>#CreateODBCDateTime(GET_CARD_ID.ACTION_DATE)#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.ACTION_TABLE)>'#GET_CARD_ID.ACTION_TABLE#'<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.PAPER_NO)>'#GET_CARD_ID.PAPER_NO#'<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.ACC_COMPANY_ID)>#GET_CARD_ID.ACC_COMPANY_ID#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.ACC_CONSUMER_ID)>#GET_CARD_ID.ACC_CONSUMER_ID#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.ACC_EMPLOYEE_ID)>#GET_CARD_ID.ACC_EMPLOYEE_ID#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.IS_OTHER_CURRENCY)>#GET_CARD_ID.IS_OTHER_CURRENCY#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.RECORD_EMP)>#GET_CARD_ID.RECORD_EMP#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.RECORD_PAR)>#GET_CARD_ID.RECORD_PAR#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.RECORD_CONS)>#GET_CARD_ID.RECORD_CONS#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.RECORD_IP)>'#GET_CARD_ID.RECORD_IP#'<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.RECORD_DATE)>#CreateODBCDateTime(GET_CARD_ID.RECORD_DATE)#<cfelse>NULL</cfif>,
                            <cfif isDefined("session.ep.userid")>
                                #SESSION.EP.USERID#,
                            <cfelseif isDefined("session.pp.userid")>
                                #SESSION.PP.USERID#,
                            <cfelseif isDefined("session.ww.userid")>
                                #SESSION.WW.USERID#,
                            </cfif>
                            '#CGI.REMOTE_ADDR#',
                            #NOW()#,
                            <cfif len(GET_CARD_ID.ACTION_ROW_ID)>#GET_CARD_ID.ACTION_ROW_ID#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.DUE_DATE)>#CreateODBCDateTime(GET_CARD_ID.DUE_DATE)#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.CARD_DOCUMENT_TYPE)>#GET_CARD_ID.CARD_DOCUMENT_TYPE#<cfelse>NULL</cfif>,
                            <cfif len(GET_CARD_ID.CARD_PAYMENT_METHOD)>#GET_CARD_ID.CARD_PAYMENT_METHOD#<cfelse>NULL</cfif>
                        )
                </cfquery>
                <cfquery name="GET_MAX_ACC_HISTORY" datasource="#arguments.muhasebe_db#">
                    SELECT MAX(CARD_HISTORY_ID) AS MAX_HISTORY_ID FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD_HISTORY
                </cfquery>
                <cfquery name="GET_ACC_ROW_INFO" datasource="#arguments.muhasebe_db#">
                    SELECT * FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CARD_ID.CARD_ID#">
                </cfquery>
                <cfloop query="GET_ACC_ROW_INFO">
                    <cfquery name="ADD_ACC_ROW_HISTORY" datasource="#arguments.muhasebe_db#">
                        INSERT INTO
                            #arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS_HISTORY
                            (
                                CARD_HISTORY_ID,
                                CARD_ID,
                                CARD_ROW_ID,
                                ACCOUNT_ID,
                                IFRS_CODE,
                                ACCOUNT_CODE2,
                                DETAIL,
                                BA,
                                AMOUNT,
                                AMOUNT_CURRENCY,
                                AMOUNT_2,
                                AMOUNT_CURRENCY_2,
                                OTHER_CURRENCY,
                                OTHER_AMOUNT,
                                QUANTITY,
                                PRICE,
                                ACC_DEPARTMENT_ID,
                                ACC_BRANCH_ID,
                                ACC_PROJECT_ID,
                                BILL_CONTROL_NO
                            )
                        VALUES
                            (
                                #GET_MAX_ACC_HISTORY.MAX_HISTORY_ID#,
                                #GET_ACC_ROW_INFO.CARD_ID#,
                                #GET_ACC_ROW_INFO.CARD_ROW_ID#,
                                '#GET_ACC_ROW_INFO.ACCOUNT_ID#',
                                <cfif len(GET_ACC_ROW_INFO.IFRS_CODE)>'#GET_ACC_ROW_INFO.IFRS_CODE#',<cfelse>NULL,</cfif>
                                <cfif len(GET_ACC_ROW_INFO.ACCOUNT_CODE2)>'#GET_ACC_ROW_INFO.ACCOUNT_CODE2#',<cfelse>NULL,</cfif>
                                <cfif len(GET_ACC_ROW_INFO.DETAIL)>#sql_unicode()#'#GET_ACC_ROW_INFO.DETAIL#',<cfelse>NULL,</cfif>
                                #GET_ACC_ROW_INFO.BA#,
                                #GET_ACC_ROW_INFO.AMOUNT#,
                                '#GET_ACC_ROW_INFO.AMOUNT_CURRENCY#',
                                <cfif len(GET_ACC_ROW_INFO.AMOUNT_2)>#GET_ACC_ROW_INFO.AMOUNT_2#<cfelse>NULL</cfif>,
                                <cfif len(GET_ACC_ROW_INFO.AMOUNT_CURRENCY_2)>'#GET_ACC_ROW_INFO.AMOUNT_CURRENCY_2#'<cfelse>NULL</cfif>,
                                <cfif len(GET_ACC_ROW_INFO.OTHER_CURRENCY)>'#GET_ACC_ROW_INFO.OTHER_CURRENCY#'<cfelse>NULL</cfif>,

                                <cfif len(GET_ACC_ROW_INFO.OTHER_AMOUNT)>#GET_ACC_ROW_INFO.OTHER_AMOUNT#<cfelse>NULL</cfif>,
                                <cfif len(GET_ACC_ROW_INFO.QUANTITY)>#GET_ACC_ROW_INFO.QUANTITY#<cfelse>NULL</cfif>,
                                <cfif len(GET_ACC_ROW_INFO.PRICE)>#GET_ACC_ROW_INFO.PRICE#<cfelse>NULL</cfif>,
                                <cfif len(GET_ACC_ROW_INFO.ACC_DEPARTMENT_ID)>#GET_ACC_ROW_INFO.ACC_DEPARTMENT_ID#<cfelse>NULL</cfif>,
                                <cfif len(GET_ACC_ROW_INFO.ACC_BRANCH_ID)>#GET_ACC_ROW_INFO.ACC_BRANCH_ID#<cfelse>NULL</cfif>,
                                <cfif len(GET_ACC_ROW_INFO.ACC_PROJECT_ID)>#GET_ACC_ROW_INFO.ACC_PROJECT_ID#<cfelse>NULL</cfif>,
                                <cfif len(GET_ACC_ROW_INFO.BILL_CONTROL_NO)>#GET_ACC_ROW_INFO.BILL_CONTROL_NO#<cfelse>NULL</cfif>
                            )
                    </cfquery>
                </cfloop>
                <cfset bill_no=GET_CARD_ID.BILL_NO>
                <cfset card_type_no=GET_CARD_ID.CARD_TYPE_NO>

                <!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderiliyor İse Bu Blok Çalışır --->
                <cfset create_accounter_wex = createObject("component","WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
                <cfset comp_info = create_accounter_wex.COMP_INFO(datasource_db : arguments.muhasebe_db)>
                <cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
                    <cfset get_result = create_accounter_wex.WRK_TO_ACCOUNTER( card_id: GET_CARD_ID.CARD_ID, event: 'del' )>
                </cfif>
                <!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderiliyor İse Bu Blok Çalışır --->

                <cfquery name="DEL_ACCOUNT_CARD" datasource="#arguments.muhasebe_db#">
                    DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD WHERE CARD_ID IN (#valuelist(GET_CARD_ID.CARD_ID)#)
                </cfquery>
                <cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#arguments.muhasebe_db#">
                    DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS WHERE CARD_ID IN (#valuelist(GET_CARD_ID.CARD_ID)#)
                </cfquery>
            <cfelse>
                <cfquery name="get_bill_no" datasource="#arguments.muhasebe_db#">SELECT BILL_NO,MAHSUP_BILL_NO,TAHSIL_BILL_NO,TEDIYE_BILL_NO FROM #arguments.muhasebe_db_alias#BILLS</cfquery>
                <cfset bill_no=get_bill_no.BILL_NO>
                <cfif arguments.account_card_type is '11'>
                    <cfset card_type_no = get_bill_no.TAHSIL_BILL_NO>
                    <cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TAHSIL_BILL_NO=#card_type_no+1#</cfquery>
                <cfelseif arguments.account_card_type is '12'>
                    <cfset card_type_no = get_bill_no.TEDIYE_BILL_NO>
                    <cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TEDIYE_BILL_NO=#card_type_no+1#</cfquery>
                <cfelse>
                    <cfset card_type_no = get_bill_no.MAHSUP_BILL_NO>
                    <cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,MAHSUP_BILL_NO=#card_type_no+1#</cfquery>
                </cfif>
            </cfif>
        <cfelse>
            <cfquery name="get_bill_no" datasource="#arguments.muhasebe_db#">SELECT BILL_NO,MAHSUP_BILL_NO,TAHSIL_BILL_NO,TEDIYE_BILL_NO FROM #arguments.muhasebe_db_alias#BILLS</cfquery>
            <cfset bill_no=get_bill_no.BILL_NO>
            <cfif arguments.account_card_type is '11'>
                <cfset card_type_no = get_bill_no.TAHSIL_BILL_NO>
                <cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TAHSIL_BILL_NO=#card_type_no+1#</cfquery>
            <cfelseif arguments.account_card_type is '12'>
                <cfset card_type_no = get_bill_no.TEDIYE_BILL_NO>
                <cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TEDIYE_BILL_NO=#card_type_no+1#</cfquery>
            <cfelse>
                <cfset card_type_no = get_bill_no.MAHSUP_BILL_NO>
                <cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,MAHSUP_BILL_NO=#card_type_no+1#</cfquery>
            </cfif>
        </cfif>
        
        <!--- parametre olarak gönderilmişse --->
      <!---  <cfif not (len(arguments.document_type) OR len(arguments.payment_method))>--->
            <!--- edefter kapsaminda islem kategorisine bagli belge tipi ve odeme sekilleri cekiliyor. Masraf gelir fislerinde buradan degil belgeden gelene gore calismasi gerekiyor FA --->
            <cfif len(arguments.workcube_process_cat) and arguments.workcube_process_cat neq 0>
                <cfquery name="getProcessCatInfo" datasource="#arguments.muhasebe_db#">
                    SELECT
                        DOCUMENT_TYPE,
                        PAYMENT_TYPE,
						NEXT_PERIODS_ACCRUAL_ACTION
                    FROM
                        <cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT
                    WHERE
                        PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_cat#">	
                </cfquery>
            <cfelseif len(arguments.workcube_process_type)>
                <cfquery name="getProcessCatInfo" datasource="#arguments.muhasebe_db#">
                    SELECT TOP 1
                        DOCUMENT_TYPE,
                        PAYMENT_TYPE,
						NEXT_PERIODS_ACCRUAL_ACTION
                    FROM
                        <cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT
                    WHERE
                        PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_type#">
                </cfquery>
            </cfif>
      <!----  </cfif>--->
        
        <cfquery name="ADD_ACCOUNT_CARD" datasource="#arguments.muhasebe_db#">
            INSERT INTO
                #arguments.muhasebe_db_alias#ACCOUNT_CARD
                (
                <cfif len(arguments.wrk_id)>
                    WRK_ID,
                </cfif>
                    ACTION_ID,
                    IS_ACCOUNT,
                    BILL_NO,
                    CARD_DETAIL,
                    CARD_TYPE,
                    CARD_CAT_ID,
                    CARD_TYPE_NO,
                    ACTION_TYPE,
                    ACTION_CAT_ID,
                    ACTION_DATE,
                <cfif isdefined('arguments.action_table') and len(arguments.action_table)>
                    ACTION_TABLE,
                </cfif>
                <cfif len(arguments.belge_no)>
                    PAPER_NO,
                </cfif>
                <cfif len(arguments.company_id)>
                    ACC_COMPANY_ID,
                <cfelseif len(arguments.consumer_id)>
                    ACC_CONSUMER_ID,
                <cfelseif len(arguments.employee_id)>
                    ACC_EMPLOYEE_ID,
                </cfif>
                    IS_OTHER_CURRENCY,
                <cfif isDefined("session.ep.userid")>
                    RECORD_EMP,
                <cfelseif isDefined("session.pp.userid")>
                    RECORD_PAR,
                <cfelseif isDefined("session.ww.userid")>
                    RECORD_CONS,
                </cfif>
                    RECORD_IP,
                    RECORD_DATE,
                    IS_CANCEL,
                    ACTION_ROW_ID,
                    DUE_DATE,
                    CARD_DOCUMENT_TYPE,
                    CARD_PAYMENT_METHOD
                )
            VALUES
                (
                <cfif len(arguments.wrk_id)>
                    '#arguments.wrk_id#',
                </cfif>
                    #arguments.action_id#,
                    1,
                    #bill_no#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(arguments.fis_detay,150)#">,
                    #arguments.account_card_type#,
                    #account_card_catid#,
                    #card_type_no#,
                    #arguments.workcube_process_type#,
                <cfif len(arguments.workcube_process_cat)>#arguments.workcube_process_cat#<cfelse>NULL</cfif>,
                    #arguments.islem_tarihi#,
                <cfif isdefined('arguments.action_table') and len(arguments.action_table)>
                    '#arguments.action_table#',
                </cfif>
                <cfif len(arguments.belge_no)>
                    '#arguments.belge_no#',
                </cfif>
                <cfif len(arguments.company_id)>
                    #arguments.company_id#,
                <cfelseif len(arguments.consumer_id)>
                    #arguments.consumer_id#,
                <cfelseif len(arguments.employee_id)>
                    #arguments.employee_id#,
                </cfif>
                1,
                <cfif isDefined("session.ep.userid")>
                    #SESSION.EP.USERID#,
                <cfelseif isDefined("session.pp.userid")>
                    #SESSION.PP.USERID#,
                <cfelseif isDefined("session.ww.userid")>
                    #SESSION.WW.USERID#,
                </cfif>
                '#CGI.REMOTE_ADDR#',
                #now()#,
                <cfif isdefined('arguments.is_cancel') and len(arguments.is_cancel)>#arguments.is_cancel#,<cfelse>0,</cfif>
                <cfif len(arguments.action_row_id)>#arguments.action_row_id#<cfelse>NULL</cfif>,
                <cfif len(arguments.due_date)>#arguments.due_date#<cfelse>NULL</cfif>,
                <!--- belge tipi --->
                <cfif len(arguments.document_type) OR len(arguments.payment_method)>
                    <cfif len(arguments.document_type)>
                        #arguments.document_type#
                    <cfelse>
                        NULL
                    </cfif>
                <cfelseif isdefined('getProcessCatInfo.DOCUMENT_TYPE') and len(getProcessCatInfo.DOCUMENT_TYPE)>
                    #getProcessCatInfo.DOCUMENT_TYPE#
                <cfelse>
                    NULL
                </cfif>,
                <!--- odeme sekli --->
                <cfif len(arguments.document_type) OR len(arguments.payment_method)>
                    <cfif len(arguments.payment_method)>
                        #arguments.payment_method#
                    <cfelse>
                        NULL
                    </cfif>
                <cfelseif isdefined('getProcessCatInfo.PAYMENT_TYPE') and len(getProcessCatInfo.PAYMENT_TYPE)>
                    #getProcessCatInfo.PAYMENT_TYPE#
                <cfelse>
                    NULL
                </cfif>
                )
        </cfquery>
        <cfquery name="GET_MAX_ACCOUNT_CARD_ID" datasource="#arguments.muhasebe_db#">
            SELECT
                MAX(CARD_ID) AS MAX_ID 
            FROM
                #arguments.muhasebe_db_alias#ACCOUNT_CARD
            WHERE
                1=1
                <cfif len(arguments.wrk_id)>
                    AND WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wrk_id#">
                </cfif>
                <cfif len(arguments.action_id)>
                    AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                </cfif>
                <cfif len(arguments.workcube_process_type)>
                    AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_type#">
                </cfif>
        </cfquery>
        <cfif is_ifrs eq 1> <!--- sirket parametrelerinde ifrs_code kullan secilmisse hesapların urfs ve özel kodları alınıyor --->
            <cfset acc_list_for_ifrs = listsort(listdeleteduplicates(valuelist(muh_query.ACCOUNT_CODE)),'text','asc')>
            <cfif listlen(acc_list_for_ifrs)>
                <cfquery name="GET_IFRS_CODE" datasource="#arguments.muhasebe_db#">
                    SELECT ACCOUNT_CODE,IFRS_CODE,ACCOUNT_CODE2 FROM #arguments.muhasebe_db_alias#ACCOUNT_PLAN WHERE ACCOUNT_CODE IN (#listqualify(acc_list_for_ifrs,"'")#) ORDER BY ACCOUNT_CODE
                </cfquery>
             </cfif>
        </cfif>
        <cfloop query="muh_query">
            <cfif ListFind("48,49,45,46",arguments.workcube_process_type)><!--- kur farkı faturalarında döviz bakiyeleri sıfırlamak için.. Ayşenur20080111 --->
                <cfif isDefined('muh_query.OTHER_AMOUNT') and len(muh_query.OTHER_AMOUNT) and muh_query.OTHER_AMOUNT neq "session_base.money">
                    <cfset muh_query.OTHER_AMOUNT = 0>
                    <cfset action_value2 = 0>
                </cfif>
            <cfelseif len(arguments.currency_multiplier)>
                <cfset action_value2 = (wrk_round(muh_query.AMOUNT)/arguments.currency_multiplier)>
            </cfif>
            <cfif wrk_round(muh_query.AMOUNT,2) neq 0 or wrk_round(muh_query.OTHER_AMOUNT,2) neq 0>
                <cfquery name="ADD_FIS_ROW" datasource="#arguments.muhasebe_db#">
                    INSERT INTO
                        #arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS
                        (
                            CARD_ID,
                            ACCOUNT_ID,
                        <cfif is_ifrs eq 1>
                            IFRS_CODE,
                            ACCOUNT_CODE2,
                        </cfif>
                            DETAIL,
                            BA,
                            AMOUNT,
                            AMOUNT_CURRENCY,
                            AMOUNT_2,
                            AMOUNT_CURRENCY_2,
                            OTHER_CURRENCY,
                            OTHER_AMOUNT,
                            QUANTITY,
                            ACC_DEPARTMENT_ID,
                            PRICE,
                            ACC_BRANCH_ID,
                            ACC_PROJECT_ID
                        )
                    VALUES
                        (
                            #GET_MAX_ACCOUNT_CARD_ID.MAX_ID#,
                            '#muh_query.ACCOUNT_CODE#',
                        <cfif is_ifrs eq 1>
                            <cfif len(GET_IFRS_CODE.IFRS_CODE[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)])>'#GET_IFRS_CODE.IFRS_CODE[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)]#',<cfelse>NULL,</cfif>
                            <cfif len(GET_IFRS_CODE.ACCOUNT_CODE2[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)])>'#GET_IFRS_CODE.ACCOUNT_CODE2[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)]#',<cfelse>NULL,</cfif>
                        </cfif>
                            #sql_unicode()#'#left(muh_query.DETAIL,500)#',
                            #muh_query.BA#,
                            #wrk_round(muh_query.AMOUNT,2)#,
                            '#arguments.action_currency#'
                        <cfif len(arguments.currency_multiplier)>
                            ,#wrk_round(action_value2,2)#
                            ,'#arguments.action_currency_2#'
                        <cfelse>
                            ,NULL
                            ,NULL
                        </cfif>
                        <cfif len(muh_query.OTHER_CURRENCY) and len(muh_query.OTHER_AMOUNT)>
                            ,'#muh_query.OTHER_CURRENCY#'
                            ,#wrk_round(muh_query.OTHER_AMOUNT,2)#
                        <cfelse>
                            ,'#arguments.action_currency#'
                            ,#wrk_round(muh_query.AMOUNT,2)#
                        </cfif>
                        <cfif len(muh_query.QUANTITY)>,#muh_query.QUANTITY#<cfelse>,NULL</cfif>
                        <cfif isdefined('arguments.acc_department_id') and len(arguments.acc_department_id)>
                            ,#arguments.acc_department_id#
                        <cfelse>
                            ,NULL
                        </cfif>
                        <cfif len(muh_query.PRICE)>,#muh_query.PRICE#<cfelse>,NULL</cfif>
                        <cfif isdefined("muh_query.ACC_BRANCH_ID") and len(muh_query.ACC_BRANCH_ID) and muh_query.ACC_BRANCH_ID gt 0>
                            ,#muh_query.ACC_BRANCH_ID#
                        <cfelse>
                            <cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id) and not (isdefined('arguments.to_branch_id') and len(arguments.to_branch_id))>
                            <!--- sadece from_branch_id gönderildiyse --->
                                ,#arguments.from_branch_id#
                            <cfelseif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id) and not (isdefined('arguments.from_branch_id') and len(arguments.from_branch_id))>
                            <!--- sadece to_branch_id gönderildiyse --->
                                ,#arguments.to_branch_id#
                            <cfelse>
                                <cfif muh_query.BA eq 1>
                                    <cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>
                                        ,#arguments.from_branch_id#
                                    <cfelse>
                                        ,NULL
                                    </cfif>
                                <cfelse>
                                    <cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>
                                        ,#arguments.to_branch_id#
                                    <cfelse>
                                        ,NULL
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfif>
                        <cfif isdefined("muh_query.ACC_PROJECT_ID") and len(muh_query.ACC_PROJECT_ID) and muh_query.ACC_PROJECT_ID gt 0>
                            ,#muh_query.ACC_PROJECT_ID#
                        <cfelse>
                            <cfif isdefined('arguments.acc_project_id') and len(arguments.acc_project_id) and arguments.acc_project_id neq 0>
                                ,#arguments.acc_project_id#
                            <cfelse>
                                ,NULL
                            </cfif>
                        </cfif>
                        )
                </cfquery>
            </cfif>
        </cfloop>
		<cfscript>
            if(session_base.our_company_info.is_ifrs eq 1) {
                ifrs_result = muhasebeci_ifrs(card_id : GET_MAX_ACCOUNT_CARD_ID.MAX_ID, dsn_type : arguments.muhasebe_db);
            }
        </cfscript>		
        <cfquery name="ADD_LOG" datasource="#arguments.muhasebe_db#">
            INSERT INTO
                #dsn_alias#.WRK_LOG
            (
                PROCESS_TYPE,
                EMPLOYEE_ID,
                LOG_TYPE,
                LOG_DATE,
                <cfif len(arguments.belge_no)>
                PAPER_NO, 
                </cfif>
                FUSEACTION,
                ACTION_ID,
                ACTION_NAME,
                PERIOD_ID
            )
            VALUES
            (	
                #arguments.account_card_type#,
                #session_base.userid#,
                <cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>0<cfelse>1</cfif>,
                #now()#,
                <cfif len(arguments.belge_no)>
                        '#arguments.belge_no#', 
                </cfif>
                <cfif isdefined("fusebox.circuit") and isdefined("fusebox.fuseaction")>
                    '#fusebox.circuit#.#fusebox.fuseaction#',
                <cfelseif isdefined("caller.fusebox.circuit") and isdefined("caller.fusebox.fuseaction")>
                    '#caller.fusebox.circuit#.#caller.fusebox.fuseaction#',
                <cfelseif isdefined("caller.caller.fusebox.circuit") and isdefined("caller.caller.fusebox.fuseaction")>
                    '#caller.caller.fusebox.circuit#.#caller.caller.fusebox.fuseaction#',
                <cfelse>
                    '',
                </cfif>
                #GET_MAX_ACCOUNT_CARD_ID.MAX_ID#,
                '#left(bill_no,250)#',
                #session_base.period_id#
            )
        </cfquery>

        <!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderilecek İse Bu Blok Çalışır --->
            <cfset create_accounter_wex = createObject("component","workcube.WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
            <cfset comp_info = create_accounter_wex.COMP_INFO(datasource_db: arguments.muhasebe_db)>
            <cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
                <cfset get_result = create_accounter_wex.WRK_TO_ACCOUNTER( card_id: GET_MAX_ACCOUNT_CARD_ID.MAX_ID )>
            </cfif>
            <!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderilecek İse Bu Blok Çalışır --->

        <cfreturn GET_MAX_ACCOUNT_CARD_ID.MAX_ID>
    </cffunction>
    <cffunction name="muhasebe_sil" output="false">
        <!---
        by :  20040227
        notes : Muhasebe fişi siler...(Tahsil-Tediye-Mahsup)
                !!! TRANSACTION icinde kullanılmalıdır !!! Fonksiyon sorunsuz çalistiginda true döndürür.
        usage :
            muhasebe_sil (action_id:attributes.id,process_type:90);
        revisions :
        muhasebe sil fonksiyonuna history silme bölümü eklenmedi, boylece silinen kayıtların detaylı loglarını tutuyoruz
        --->
        <cfargument name="action_id" required="yes" type="numeric">
        <cfargument name="process_type" required="yes" type="numeric">
        <cfargument name="muhasebe_db" type="string" default="#dsn2#">	
        <cfargument name="muhasebe_db_alias" type="string" default="">
        <cfargument name="belge_no" type="string" default="">
        <cfargument name="action_table" type="string">
        
        <cfif isdefined("session.pp")>
            <cfset session_base = evaluate('session.pp')>
        <cfelseif isdefined("session.ep")>
            <cfset session_base = evaluate('session.ep')>
        <cfelseif isdefined("session.ww")>
            <cfset session_base = evaluate('session.ww')>
        <cfelseif isdefined("session.wp")>
            <cfset session_base = evaluate('session.wp')>
        </cfif>
        
        <cfif arguments.muhasebe_db is not '#dsn2#'>
            <cfset arguments.muhasebe_db_alias = '#dsn2_alias#'&'.'>
        <cfelse>
            <cfset arguments.muhasebe_db_alias =''>
        </cfif>
        <cfquery name="GET_CARD_ID" datasource="#arguments.muhasebe_db#">
            SELECT
                CARD_ID,
                ACTION_ID,
                BILL_NO,
                ACTION_DATE
            FROM
                #arguments.muhasebe_db_alias#ACCOUNT_CARD
            WHERE
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_type#">
                AND ISNULL(IS_CANCEL,0)=0
                <cfif isDefined('arguments.action_table') and len(arguments.action_table)> 
                    AND ACTION_TABLE = '#arguments.action_table#'
                </cfif>
        </cfquery>
        <cfif GET_CARD_ID.RECORDCOUNT>
            <!--- e-defter islem kontrolu FA --->
            <cfif session_base.our_company_info.is_edefter eq 1>
                <cfstoredproc procedure="GET_NETBOOK" datasource="#arguments.muhasebe_db#">
                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#GET_CARD_ID.ACTION_DATE#">
                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#GET_CARD_ID.ACTION_DATE#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.muhasebe_db_alias#">
                    <cfprocresult name="getNetbook">
                </cfstoredproc>
				<cfif getNetbook.recordcount>
                    <script type="text/javascript">
                        alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
                    </script>
                    <cfabort>
                </cfif>
            </cfif>
            <!--- e-defter islem kontrolu FA --->
            
            <!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderiliyor İse Bu Blok Çalışır --->
            <cfset create_accounter_wex = createObject("component","WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
            <cfset comp_info = create_accounter_wex.COMP_INFO(datasource_db: arguments.muhasebe_db)>
            <cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
                <cfset get_result = create_accounter_wex.WRK_TO_ACCOUNTER( card_id: GET_CARD_ID.card_id, event: 'del' )>
            </cfif>
            <!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderiliyor İse Bu Blok Çalışır --->

            <!--- FBS 20120606 Belgelerde Birden Fazla Fis Olustugunda, Belge Silindiginde Fislerin Tamaminin Silinmesi Icin CARD_ID IN ile Cekiliyor  --->
            <cfquery name="DEL_ACCOUNT_CARD" datasource="#arguments.muhasebe_db#">
                DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD WHERE CARD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(GET_CARD_ID.CARD_ID)#" list="yes">)
            </cfquery>
            <cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#arguments.muhasebe_db#">
                DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS WHERE CARD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(GET_CARD_ID.CARD_ID)#" list="yes">)
            </cfquery>
            <cfquery name="DEL_ACCOUNT_ROWS_IFRS" datasource="#arguments.muhasebe_db#">
                DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_ROWS_IFRS WHERE CARD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(GET_CARD_ID.CARD_ID)#" list="yes">)
            </cfquery>
            <cfquery name="ADD_LOG" datasource="#arguments.muhasebe_db#">
                INSERT INTO
                    #dsn_alias#.WRK_LOG
                (
                    PROCESS_TYPE,
                    EMPLOYEE_ID,
                    LOG_TYPE,
                    LOG_DATE,
                    <cfif len(arguments.belge_no)>
                     PAPER_NO, 
                    </cfif>
                    FUSEACTION,
                    ACTION_ID,
                    ACTION_NAME,
                    PERIOD_ID
                    
                )
                VALUES
                (	
                    #arguments.process_type#,
                    #session_base.userid#,
                    -1,
                    #now()#,
                    <cfif len(arguments.belge_no)>
                        '#arguments.belge_no#', 
                    </cfif>
                    <cfif isdefined("fusebox.circuit")>
                        '#fusebox.circuit#  #fusebox.fuseaction#',
                    <cfelse>
                        '#caller.fusebox.circuit#  #caller.fusebox.fuseaction#',
                    </cfif>
                    #arguments.action_id#,
                    '#left(GET_CARD_ID.BILL_NO,250)#',
                    #session_base.period_id#
                )
            </cfquery>
        </cfif>
        <cfreturn true>
    </cffunction>
    
    <cffunction name="get_cost_info" returntype="string" output="false">
    <!---
        by : TolgaS 20061110
        notes : 
            .....URUN, SPEC VEYA AGAC MALIYETINI LISTE SEKLINDE PURCHASE_NET_SYSTEM PARA TURUNDEN BULUR .....
        usage :
        sadece main_spec_id den degerler alinarak kaydedilecekse
            get_cost_info(
                    stock_id: ,
                    main_spec_id: ,
                    spec_id: ,
                    cost_date: ,
                    is_purchasesales:
                );
        --->
        <cfargument name="stock_id" type="numeric" required="yes"><!--- maliyeti bulunacak stock_id stock_id cunku stock_id bazında agac--->
        <cfargument name="main_spec_id" type="numeric" required="no"><!--- main_spec id icerigine gore maliyeti bulur bu deger varsa spec_id gerek yok --->
        <cfargument name="spec_id" type="numeric" required="no"><!--- spec_id bundan maın_spec_id bulunarak maliyeti hesaplanır --->
        <cfargument name="cost_date" type="date" required="no" default="#now()#"><!--- maliyet bulunacak tarih --->
        <cfargument name="dsn_type" type="string" required="no" default="#dsn3#"><!--- olurda cftransaction icinde olursa diye dsn yollansın --->
        <cfargument name="is_purchasesales" type="boolean" required="no" default="1"><!--- alis (0) veya satis(1) tipi. alis tipinde alis fiyatini getirir --->
    
        <cfif not len(arguments.cost_date) gt 9><cfset arguments.cost_date=now()></cfif>
        <cf_date tarih='cost_date'>
        <cfscript>
        maliyet_id=0;
        toplam_maliyet_sistem = 0;
        toplam_maliyet_extra_sistem = 0;
        GET_PROD=cfquery(SQLString:'SELECT IS_COST,PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
        if(len(GET_PROD.IS_COST) and GET_PROD.IS_COST eq 1)
        {
            if(is_purchasesales eq 1)
            {
                if(isdefined('arguments.spec_id') and len(arguments.spec_id))
                {
                    GET_MAIN_SPEC=cfquery(SQLString:'SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID=#arguments.spec_id#',Datasource:'#dsn_type#',is_select:1);
                    if(GET_MAIN_SPEC.RECORDCOUNT) arguments.main_spec_id=GET_MAIN_SPEC.SPECT_MAIN_ID;
                }
                if(isdefined('arguments.main_spec_id') and len(arguments.main_spec_id))
                {
                    GET_SPEC_ROW=cfquery(SQLString:'SELECT PRODUCT_ID, STOCK_ID, AMOUNT FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID=#arguments.main_spec_id# AND PRODUCT_ID IS NOT NULL AND IS_PROPERTY=0',Datasource:'#dsn_type#',is_select:1);//sadece sarfları aldık fireler maliyette etki etmeyecek diye düsünüldü ama degise bilir
                    cost_info_product_list=listsort(valuelist(GET_SPEC_ROW.PRODUCT_ID,','),'Numeric');
                    if(listlen(cost_info_product_list) eq 0)cost_info_product_list=0;
                    GET_COST_ALL=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID IN(#cost_info_product_list#)',Datasource:'#dsn_type#',is_select:1);
                    for(ww=1;ww lte GET_SPEC_ROW.RECORDCOUNT;ww=ww+1)
                    {
                        GET_TREE=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #evaluate('GET_SPEC_ROW.STOCK_ID[#ww#]')# AND PRODUCT_TREE.STOCK_ID=STOCKS.STOCK_ID AND STOCKS.IS_PRODUCTION=1",Datasource:"#dsn_type#",is_select:1);
                        if(GET_TREE.RECORDCOUNT)
                        {
                            for(ss=1;ss lte GET_TREE.RECORDCOUNT;ss=ss+1)
                            {
                                GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE.PRODUCT_ID[#ss#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'',dbtype='query',is_select:1);
                                if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_SPEC_ROW.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
                                if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_SPEC_ROW.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
                            }
                        }else
                        {
                            GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_SPEC_ROW.PRODUCT_ID[#ww#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'',dbtype='query',is_select:1);
                            if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM* evaluate('GET_SPEC_ROW.AMOUNT[#ww#]'));
                            if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM*evaluate('GET_SPEC_ROW.AMOUNT[#ww#]'));
                        }
                    }
                }
                else
                {
                    GET_TREE_PROD=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID STOCK_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #arguments.stock_id# AND PRODUCT_TREE.RELATED_ID=STOCKS.STOCK_ID",Datasource:"#dsn_type#",is_select:1);
                    if(GET_TREE_PROD.RECORDCOUNT)
                    {
                        cost_info_product_list=listsort(valuelist(GET_TREE_PROD.PRODUCT_ID,','),'Numeric');
                        GET_COST_ALL=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID IN(#cost_info_product_list#)',Datasource:'#dsn_type#',is_select:1);
                        for(ww=1;ww lte GET_TREE_PROD.RECORDCOUNT;ww=ww+1)
                        {
                            GET_TREE=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #evaluate('GET_TREE_PROD.STOCK_ID[#ww#]')# AND PRODUCT_TREE.STOCK_ID=STOCKS.STOCK_ID",Datasource:"#dsn_type#",is_select:1);
                            if(GET_TREE.RECORDCOUNT)
                            {
                                for(ss=1;ss lte GET_TREE.RECORDCOUNT;ss=ss+1)
                                {
                                    GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE.PRODUCT_ID[#ss#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',dbtype:'query',is_select:1);
                                    if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
                                    if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
                                }
                            }else
                            {
                                GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE_PROD.PRODUCT_ID[#ww#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',dbtype:'query',is_select:1);
                                if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]'));
                                if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]'));
                            }
                        }
                    
                    }else
                    {
                        //GET_PROD=cfquery(SQLString:'SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
                        if(GET_PROD.RECORDCOUNT)
                        {
                            GET_COST=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID = #GET_PROD.PRODUCT_ID# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',is_select:1);
                            if(len(GET_COST.RECORDCOUNT))maliyet_id=GET_COST.PRODUCT_COST_ID;
                            if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+GET_COST.PURCHASE_NET_SYSTEM;
                            if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+GET_COST.PURCHASE_EXTRA_COST_SYSTEM;
                        }
                    }
                }
            }else
            {//alis islemi ise standart alisi yollar maliyet olarak
                GET_PROD=cfquery(SQLString:'SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
                if(GET_PROD.RECORDCOUNT)
                {
                    GET_COST=cfquery(SQLString:'SELECT PRICE, MONEY FROM #dsn3_alias#.PRICE_STANDART PRICE_STANDART WHERE PRICE_STANDART.PURCHASESALES = 0 AND PRICE_STANDART.PRICESTANDART_STATUS = 1 AND PRICE_STANDART.PRODUCT_ID = #GET_PROD.PRODUCT_ID#',Datasource:'#dsn_type#',is_select:1);
                    if(GET_COST.MONEY eq session.ep.money)
                    {
                        if(len(GET_COST.PRICE))toplam_maliyet_sistem=toplam_maliyet_sistem+GET_COST.PRICE;
                    }else
                    {
                        GET_MONEY=cfquery(SQLString:"SELECT (RATE2/RATE1) RATE FROM #dsn_alias#.SETUP_MONEY PRICE_STANDART WHERE PERIOD_ID=#session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY='#GET_COST.MONEY#' AND COMPANY_ID=#session.ep.company_id#",Datasource:"#dsn_type#",is_select:1);
                        if(len(GET_COST.PRICE) and GET_MONEY.RECORDCOUNT) toplam_maliyet_sistem=GET_COST.PRICE*GET_MONEY.RATE;
                    }
                    toplam_maliyet_extra_sistem=0;
                }
            }
        }
        if(not len(maliyet_id)) maliyet_id=0;
        if(not len(toplam_maliyet_sistem)) toplam_maliyet_sistem=0;
        if(not len(toplam_maliyet_extra_sistem)) toplam_maliyet_extra_sistem=0;
        return '#maliyet_id#,#toplam_maliyet_sistem#,#toplam_maliyet_extra_sistem#';
        </cfscript>
    </cffunction>
	<cffunction name="muhasebeci_ifrs" returntype="any" output="true">
        <cfargument name = "card_id" type = "numeric" required = "true">
        <cfargument name = "dsn_type" type = "string" default = "#dsn2#">

        <cfquery name = "getCardRows" datasource = "#dsn_type#">
            DELETE FROM #dsn2#.ACCOUNT_ROWS_IFRS WHERE CARD_ID = #arguments.card_id#

            INSERT INTO
                #dsn2#.ACCOUNT_ROWS_IFRS
            SELECT
                ACR.[CARD_ID],
                ACR.[CARD_ROW_ID],
                ACR.[ACCOUNT_ID],
                ACR.[BA],
                ACR.[AMOUNT],
                ACR.[AMOUNT_CURRENCY],
                ACR.[DETAIL],
                ACR.[AMOUNT_2],
                ACR.[ROW_ACTION_ID],
                ACR.[ROW_ACTION_TYPE_ID],
                ACR.[ROW_PAPER_NO],
                ACR.[AMOUNT_CURRENCY_2],
                ACR.[OTHER_AMOUNT],
                ACR.[OTHER_CURRENCY],
                ACR.[QUANTITY],
                ACR.[PRICE],
                ACR.[BILL_CONTROL_NO],
                ACR.[IFRS_CODE],
                ACR.[ACCOUNT_CODE2],
                ACR.[IS_RATE_DIFF_ROW],
                ACR.[COST_PROFIT_CENTER],
                ACR.[ACC_DEPARTMENT_ID],
                ACR.[ACC_BRANCH_ID],
                ACR.[ACC_PROJECT_ID],
                ACR.[CARD_ROW_NO],
                ACR.[RECORD_EMP],
                ACR.[RECORD_IP],
                ACR.[RECORD_DATE],
                ACR.[UPDATE_EMP],
                ACR.[UPDATE_IP],
                ACR.[UPDATE_DATE]
            FROM
                #dsn2#.ACCOUNT_CARD AC
                    LEFT JOIN #dsn2#.ACCOUNT_CARD_ROWS ACR ON ACR.CARD_ID = AC.CARD_ID
            WHERE
                AC.CARD_ID = #arguments.card_id#
        </cfquery>
        <cfreturn 1>
    </cffunction>
</cfcomponent>
