<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3="#dsn#_#session.ep.company_id#">
    <cfset dsn_alias=dsn>
    <cfset dsn3_alias=dsn3>
    <cffunction name="get_contact_detail" access="remote">
        <cfargument name="contract_id" default="">
        <cfquery name="get_contact_detail" datasource="#DSN3#">
            SELECT 
                CONTRACT_ID, 
                TERM, 
                FOLDER,
                CONTRACT_CAT_ID, 
                STARTDATE, 
                FINISHDATE, 
                CONTRACT_HEAD, 
                CONTRACT_BODY, 
                COMPANY, 
                COMPANY_PARTNER, 
                EMPLOYEE, 
                CONSUMERS, 
                STATUS, 
                STAGE_ID, 
                PROCESS_CAT,
                OUR_COMPANY_ID, 
                COMPANY_ID, 
                CONSUMER_ID, 
                CONTRACT_NO, 
                PAYMENT_TYPE_ID, 
                CONTRACT_AMOUNT, 
                CONTRACT_TAX, 
                CONTRACT_TAX_AMOUNT, 
                CONTRACT_UNIT_PRICE, 
                CONTRACT_MONEY, 
                GUARANTEE_AMOUNT, 
                GUARANTEE_RATE, 
                ADVANCE_AMOUNT, 
                TEVKIFAT_RATE_ID, 
                TEVKIFAT_RATE, 
                STOPPAGE_RATE_ID,
                STOPPAGE_RATE,
                ADVANCE_RATE, 
                CONTRACT_TYPE, 
                CONTRACT_CALCULATION, 
                DISCOUNT_RATE,
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP,
                STAMP_TAX,
                STAMP_TAX_RATE,
                COPY_NUMBER,
                UPDATE_DATE, 
                UPDATE_EMP,
                UPDATE_IP, 
                PROJECT_ID ,
                PAYMETHOD_ID,
                CARD_PAYMETHOD_ID,
                DELIVER_DEPT_ID,
                LOCATION_ID,
                SHIP_METHOD_ID,
                (SELECT SHIP_METHOD FROM #dsn_alias#.SHIP_METHOD WHERE SHIP_METHOD_ID =RELATED_CONTRACT.SHIP_METHOD_ID ) AS SHIP_METHOD,
                ORDER_ID
            FROM 
                RELATED_CONTRACT 
            WHERE 
                CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#"> 
        </cfquery>
        <cfreturn get_contact_detail>
    </cffunction>
     <!--- alış satış koşulları --->
    <cffunction name="getPurchaseDiscount" access="remote">
        <cfargument name="contract_id" default="">   
        <cfquery name="getPurchaseDiscount" datasource="#dsn3#">
            SELECT 
                CPPD.CONTRACT_ID,
                CPPD.PRODUCT_ID,
                CPPD.DISCOUNT1,
                CPPD.DISCOUNT2,
                CPPD.DISCOUNT3,
                CPPD.DISCOUNT4,
                CPPD.DISCOUNT5,
                CPPD.PAYMETHOD_ID,
                CPPD.COMPANY_ID,
                CPPD.START_DATE,
                CPPD.FINISH_DATE,
                P.PRODUCT_NAME
            FROM CONTRACT_PURCHASE_PROD_DISCOUNT AS CPPD 
            LEFT JOIN PRODUCT AS P ON CPPD.PRODUCT_ID = P.PRODUCT_ID
            WHERE RELATED_CONTRACTS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#"> 
        </cfquery>
         <cfreturn getPurchaseDiscount>
    </cffunction>
    <cffunction name="getSaleDiscount" access="remote">
        <cfargument name="contract_id" default="">   
        <cfquery name="getSaleDiscount" datasource="#dsn3#">
            SELECT 
                CSPD.CONTRACT_ID,
                CSPD.PRODUCT_ID,
                CSPD.DISCOUNT1,
                CSPD.DISCOUNT2,
                CSPD.DISCOUNT3,
                CSPD.DISCOUNT4,
                CSPD.DISCOUNT5,
                CSPD.PAYMETHOD_ID,
                CSPD.COMPANY_ID,
                CSPD.START_DATE,
                CSPD.FINISH_DATE,
                P.PRODUCT_NAME
            FROM CONTRACT_SALES_PROD_DISCOUNT AS CSPD 
            LEFT JOIN PRODUCT AS P ON CSPD.PRODUCT_ID = P.PRODUCT_ID 
            WHERE RELATED_CONTRACTS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#"> 
        </cfquery>
         <cfreturn getSaleDiscount>
    </cffunction>
    <cffunction name="GET_KDV" access="remote">
        <cfquery name="GET_KDV" datasource="#DSN2#">
            SELECT TAX_ID, TAX FROM SETUP_TAX ORDER BY TAX
        </cfquery>
         <cfreturn GET_KDV>
    </cffunction>  
    <cffunction name="GET_PRICE_CATS" access="remote">
        <cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
            SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
        </cfquery>
         <cfreturn GET_PRICE_CATS>
    </cffunction> 
    <cffunction name="get_price_cat_exceptions" access="remote">
        <cfargument name="contract_id" default=""> 
        <cfquery name="get_price_cat_exceptions" datasource="#DSN3#">
            SELECT
                *
            FROM 
                PRICE_CAT_EXCEPTIONS
            WHERE 
                CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#"> AND ISNULL(ACT_TYPE,1) IN(1,3)
        </cfquery>
         <cfreturn get_price_cat_exceptions>
    </cffunction>
    <cffunction name="getContractWorks" access="remote">
        <cfargument name="contract_id" default=""> 
      <!--- ilisklili isler --->
        <cfquery name="getContractWorks" datasource="#dsn#">
            SELECT 
                WORK_ID
            FROM 
                PRO_WORKS,
                #dsn3_alias#.RELATED_CONTRACT RC,
                OUR_COMPANY OC
            WHERE 
                OC.COMP_ID = RC.OUR_COMPANY_ID AND
                OC.COMP_ID = PRO_WORKS.OUR_COMPANY_ID AND
                (
                    (RC.CONTRACT_TYPE = 1 AND RC.CONTRACT_ID = PRO_WORKS.PURCHASE_CONTRACT_ID) OR
                    (RC.CONTRACT_TYPE = 2 AND RC.CONTRACT_ID = PRO_WORKS.SALE_CONTRACT_ID)
                ) AND
                RC.CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">
        </cfquery>
         <cfreturn getContractWorks>
    </cffunction>
    <cffunction name="getProgress" access="remote">
        <cfargument name="contract_id" default=""> 
    <!--- iliskili hakedisler --->
        <cfquery name="getProgress" datasource="#dsn3#">
            SELECT CONTRACT_ID,PROGRESS_VALUE FROM PROGRESS_PAYMENT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">
        </cfquery>
         <cfreturn getProgress>
    </cffunction> 
    <cffunction name="get_process_type" access="remote">
        <cfargument name="process_cat" default="">
        <cfquery name="get_process_type" datasource="#DSN3#">
            SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">
        </cfquery>
         <cfreturn get_process_type>
    </cffunction>   
    <cffunction name="get_stamp_tax" access="remote">
        <cfargument name="sal_mon" default="">
        <cfargument name="sal_year" default="">
        <cfargument name="account_process" default="">
        <cfquery name="get_stamp_tax" datasource="#dsn3#">
            SELECT
                COMPANY_ID,
                CONSUMER_ID,
                COMPANY,
                CONSUMERS,
                EMPLOYEE,
                STARTDATE,
                FINISHDATE,
                PROJECT_ID,
                CONTRACT_ID,
                CONTRACT_HEAD,
                CONTRACT_NO,
                STAMP_TAX,
                COPY_NUMBER,
                CONTRACT_MONEY,
                CONTRACT_AMOUNT,
                ORDER_ID,
                SP.PROCESS_CAT,
                SP.IS_ACCOUNT,
                CC.CONTRACT_CAT
            FROM 
                RELATED_CONTRACT
                LEFT JOIN SETUP_PROCESS_CAT SP ON RELATED_CONTRACT.PROCESS_CAT = SP.PROCESS_CAT_ID
                LEFT JOIN CONTRACT_CAT CC ON CC.CONTRACT_CAT_ID = RELATED_CONTRACT.CONTRACT_CAT_ID
            WHERE 
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                <cfif isdefined('arguments.sal_mon') and len(arguments.sal_mon)>
                    AND ( DATEPART(MONTH, STARTDATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                 </cfif>
                 <cfif isdefined('arguments.sal_year') and len(arguments.sal_year)>
                    AND ( DATEPART(YEAR, STARTDATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                </cfif>
                <cfif isdefined('arguments.account_process') and len(arguments.account_process) and arguments.account_process eq 1>
                    AND SP.IS_ACCOUNT = 1
                </cfif>
             ORDER BY
                 CONTRACT_ID DESC
        </cfquery>
         <cfreturn get_stamp_tax>
    </cffunction>      
    <cffunction name="get_tax_type" access="remote">
        <cfquery name="get_tax_type" datasource="#dsn3#">
            SELECT  TAX_TYPE_ID
                    ,TAX_TYPE
                    ,TAX_DETAIL
                    ,CALCULATION_TYPE
                    ,TAX_FORMULA
            FROM TAX_TYPE
            ORDER BY TAX_TYPE
        </cfquery>
         <cfreturn get_tax_type>
    </cffunction>

    <!--- Ödeme planı  --->
    <cffunction name="GET_PAYMENT" returntype="query">
        <cfargument name="contract_id" default="">
        <cfquery name="GET_PAYMENT" datasource="#dsn3#">
            SELECT 
                SUBSCRIPTION_PAYMENT_PLAN_ID, 
                CONTRACT_ID, 
                PRODUCT_ID, 
                STOCK_ID, 
                UNIT, 
                QUANTITY, 
                AMOUNT, 
                MONEY_TYPE, 
                PERIOT, 
                START_DATE, 
                UNIT_ID, 
                PAYMETHOD_ID, 
                CARD_PAYMETHOD_ID, 
                PROCESS_STAGE, 
                RECORD_EMP, 
                RECORD_IP, 
                RECORD_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                UPDATE_DATE 
            FROM 
                SUBSCRIPTION_PAYMENT_PLAN 
            WHERE 
                CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">
        </cfquery>
        <cfreturn GET_PAYMENT>
    </cffunction>

    <!--- Ödeme planı satırları --->
    <cffunction name="GET_PAYMENT_ROWS" returntype="query">
        <cfargument name="contract_id" displayname="" default="">
        <cfquery name="GET_PAYMENT_ROWS" datasource="#DSN3#">
            SELECT 
                SUBSCRIPTION_PAYMENT_ROW_ID,
                CONTRACT_ID,
                STOCK_ID,
                PRODUCT_ID,
                (SELECT ISNULL(TAX,0) FROM PRODUCT WHERE PRODUCT_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.PRODUCT_ID) TAX,
                (SELECT ISNULL(OTV,0) FROM PRODUCT WHERE PRODUCT_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.PRODUCT_ID) OTV,
                PAYMENT_DATE,
                DETAIL,
                UNIT,
                QUANTITY,
                AMOUNT,
                MONEY_TYPE,
                ROW_TOTAL,
                DISCOUNT,
                ROW_NET_TOTAL,
                IS_COLLECTED_INVOICE,
                IS_BILLED,
                IS_PAID,
                IS_COLLECTED_PROVISION,
                INVOICE_ID,
                PERIOD_ID,
                (SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.PERIOD_ID) AS PERIOD_YEAR,
                    (SELECT EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.RECORD_EMP) RECORD_EMP_NAME,
                    (SELECT EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.UPDATE_EMP) UPDATE_EMP_NAME,
                RECORD_IP,
                RECORD_DATE,
                UPDATE_IP,
                UPDATE_DATE,
                UNIT_ID,
                PAYMETHOD_ID,
                (SELECT SETUP_PAYMETHOD.PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE SETUP_PAYMETHOD.PAYMETHOD_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.PAYMETHOD_ID) PAYMETHOD,
                CARD_PAYMETHOD_ID,
                (SELECT CREDITCARD_PAYMENT_TYPE.CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.CARD_PAYMETHOD_ID) CARD_NO,
                    SUBS_REFERENCE_ID,
                    (SELECT SUBSCRIPTION_CONTRACT.SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.SUBS_REFERENCE_ID) SUBSCRIPTION_NO,
                IS_GROUP_INVOICE,
                IS_INVOICE_IPTAL,
                DUE_DIFF_ID,
                    SERVICE_ID,
                    (SELECT SERVICE.SERVICE_NO FROM SERVICE WHERE SERVICE.SERVICE_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.SERVICE_ID) SERVICE_NO,
                    CALL_ID,
                    (SELECT G_SERVICE.SERVICE_NO FROM #dsn_alias#.G_SERVICE WHERE G_SERVICE.SERVICE_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.CALL_ID) G_SERVICE_NO,
                IS_ACTIVE,
                    CAMPAIGN_ID,
                    (SELECT CAMPAIGNS.CAMP_HEAD FROM CAMPAIGNS WHERE CAMPAIGNS.CAMP_ID = SUBSCRIPTION_PAYMENT_PLAN_ROW.CAMPAIGN_ID) CAMP_HEAD,
                CARI_ACTION_ID,
                CARI_PERIOD_ID,
                CAMP_ID,
                CARI_ACT_TYPE,
                CARI_ACT_TABLE,
                CARI_ACT_ID,
                DISCOUNT_AMOUNT,
                PAYMENT_FINISH_DATE,
                RATE,
                ISNULL(BSMV_RATE,0) AS BSMV_RATE,
                ISNULL(BSMV_AMOUNT,0) AS BSMV_AMOUNT,
                ISNULL(OIV_RATE,0) AS OIV_RATE,
                ISNULL(OIV_AMOUNT,0) AS OIV_AMOUNT,
                ISNULL(TEVKIFAT_RATE,0) AS TEVKIFAT_RATE,
                ISNULL(TEVKIFAT_AMOUNT,0) AS TEVKIFAT_AMOUNT,
                REASON_CODE
            FROM 
                SUBSCRIPTION_PAYMENT_PLAN_ROW                 
            WHERE 
            CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">
            ORDER BY 
                PAYMENT_DATE
        </cfquery>
        <cfreturn GET_PAYMENT_ROWS>
    </cffunction>
    <cffunction name="GET_CAMPAIGN" returntype="query">
        <cfargument name="subscription_id" default="">
        <cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
            SELECT C.CAMP_ID,C.CAMP_HEAD FROM CAMPAIGN_RELATION CR,CAMPAIGNS C WHERE C.CAMP_ID = CR.CAMP_ID AND CR.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
        </cfquery>
        <cfreturn GET_CAMPAIGN>
    </cffunction>
    <cffunction name="ADD_PAYMENT_PLAN" returntype="any">
        <cfargument name="contract_id"  required="yes" default="">
        <cfargument name="product_id" required="yes" default="">
        <cfargument name="stock_id" required="yes"  default="">
        <cfargument name="unit" default="">
        <cfargument name="unit_id" required="yes" default="">
        <cfargument name="quantity" default="">
        <cfargument name="amount" required="yes" default="">
        <cfargument name="money_type" required="yes" default="">
        <cfargument name="period" required="yes" default="">
        <cfargument name="start_date" default="">
        <cfargument name="paymethod_id" default="">
        <cfargument name="card_paymethod_id" default="">
        <cfargument name="RECORD_DATE" default="#now()#">
        <cfargument name="process_stage" required="yes" default="">
        <cfquery name="ADD_PAYMENT_PLAN" datasource="#dsn3#">
            INSERT INTO
                SUBSCRIPTION_PAYMENT_PLAN
                (
                    CONTRACT_ID,
                    PRODUCT_ID,
                    STOCK_ID,
                    UNIT,
                    UNIT_ID,
                    QUANTITY,
                    AMOUNT,
                    MONEY_TYPE,
                    PERIOT,
                    START_DATE,
                    PAYMETHOD_ID,
                    CARD_PAYMETHOD_ID,
                    PROCESS_STAGE,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">,
                    <cfif isDefined("arguments.product_id") and len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.stock_id") and len(arguments.stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.unit") and len(arguments.unit)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.unit#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.unit_id") and len(arguments.unit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_id#">,<cfelse>NULL,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.quantity#">,
                    <cfif isDefined("arguments.amount") and len(arguments.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount#">,<cfelse>0,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money_type#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">,
                <cfif isDefined("arguments.paymethod_id") and len(arguments.paymethod_id)>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paymethod_id#">,
                <cfelse>
                    NULL,
                </cfif>
                <cfif isDefined("arguments.card_paymethod_id") and len(arguments.card_paymethod_id)>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_paymethod_id#">,
                <cfelse>
                    NULL,
                </cfif>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfif isDefined("cgi.remote_addr")>
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                <cfelse>
                    NULL,
                </cfif>    
                <cfif isDefined('session.pp.userid')>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">   
                <cfelseif isDefined('session.ep.userid')> 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  
                <cfelseif isDefined('session.ww.userid')> 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> 
                <cfelse>
                    NULL
                </cfif>    
                )
        </cfquery>
    </cffunction> 
    <cffunction name="UPD_PAYMENT_PLAN" returntype="any">  
        <cfargument name="contract_id" required="yes" default="">
       
        <cfquery name="UPD_PAYMENT_PLAN" datasource="#dsn3#">
            UPDATE 
                SUBSCRIPTION_PAYMENT_PLAN 
            SET
            UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            <cfif isDefined("arguments.product_id")>
                ,PRODUCT_ID = <cfif isDefined("arguments.product_id") and len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.stock_id")>
                ,STOCK_ID = <cfif isDefined("arguments.stock_id") and len(arguments.stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"><cfelse>NULL</cfif>
            </cfif>    
            <cfif isDefined("arguments.unit")>
                ,UNIT = <cfif isDefined("arguments.unit") and len(arguments.unit)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.unit#"><cfelse>NULL</cfif>
            </cfif>  
            <cfif isDefined("arguments.unit_id")>  
                ,UNIT_ID = <cfif isDefined("arguments.unit_id") and len(arguments.unit_id)> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_id#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.quantity")>
                ,QUANTITY = <cfif len(arguments.quantity)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.quantity#"><cfelse>NULL</cfif>
            </cfif>    
            <cfif isDefined("arguments.amount")>
                ,AMOUNT = <cfif isDefined("arguments.amount") and len(arguments.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount#"><cfelse>0</cfif>
            </cfif> 
            <cfif isDefined("arguments.money_type")>   
                ,MONEY_TYPE =<cfif len(arguments.money_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money_type#"><cfelse>NULL</cfif>
            </cfif>    
            <cfif isDefined("arguments.period")>
                ,PERIOT =<cfif len(arguments.period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#"><cfelse>NULL</cfif>
            </cfif>  
            <cfif isDefined("arguments.start_date")>  
                ,START_DATE = <cfif len(arguments.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"><cfelse>NULL</cfif>
            </cfif>    
            <cfif isDefined("arguments.process_stage")>
                ,PROCESS_STAGE = <cfif len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>
            </cfif>    
            <cfif isDefined("arguments.paymethod_id") and len(arguments.paymethod_id)><!--- aslında bos olmamsı lazım ama eski kayıtlarda proble olabilir diye AE--->
                ,PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paymethod_id#">
            <cfelse>
                ,PAYMETHOD_ID = NULL
            </cfif>
            <cfif isDefined("arguments.card_paymethod_id") and len(arguments.card_paymethod_id)>
                ,CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_paymethod_id#">
            <cfelse>
                ,CARD_PAYMETHOD_ID = NULL
            </cfif>
            <cfif isDefined("cgi.remote_addr")>
                ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
            <cfelse>
                ,UPDATE_IP = NULL
            </cfif>  
            <cfif isDefined('session.pp.userid')>
                ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">   
            <cfelseif isDefined('session.ep.userid')> 
                ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  
            <cfelseif isDefined('session.ww.userid')> 
                ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            <cfelse>
                ,UPDATE_EMP = NULL
            </cfif>
            WHERE 
                CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">
        </cfquery> 
    </cffunction>
    <cffunction name="UPD_PAYMENT_PLAN_ROW" returntype="any">
        <cfargument name="product_id" required="yes" default="">
        <cfargument name="stock_id" required="yes" default="">
        <cfargument name="payment_date" required="yes" default="">
        <cfargument name="unit" required="yes" default="">
        <cfargument name="unit_id" required="yes" default="">
        <cfargument name="quantity" required="yes" default="">
        <cfargument name="amount" required="yes" default="">
        <cfargument name="paymethod_id" required="yes" default="">
        <cfargument name="is_active" default="">
        <cfargument name="row_rate" default="">
        <cfargument name="UPDATE_DATE" default="#now()#">
        <cfargument name="payment_row_id" required="yes" default="">
        <cfargument name="row_reason_code" default="">
        <cfargument name="row_bsmv_rate" default="">
        <cfargument name="row_bsmv_amount" default="">
        <cfargument name="row_oiv_rate" default="">
        <cfargument name="row_oiv_amount" default="">
        <cfargument name="row_tevkifat_rate" default="">
        <cfargument name="row_tevkifat_amount" default="">
        <cfargument name="contract_id" required="yes" default="">
        <cfargument name="HISTORY_ACTION_TYPE" default="2">
        <cfargument name="xml_payment_finish_date" default="">
      
        <cfquery name="UPD_PAYMENT_PLAN_ROW" datasource="#dsn3#">
            UPDATE 
                SUBSCRIPTION_PAYMENT_PLAN_ROW 
            SET
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">,
                STOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">,   
                PAYMENT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.payment_date#">,
                IS_ACTIVE = <cfif isDefined("arguments.is_active") and arguments.is_active eq 1>1<cfelse>0</cfif>, 
                DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#">, 
                UNIT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.unit#">,
                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_id#">,
                QUANTITY = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.quantity#">,    
                CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">,
                AMOUNT = <cfif len(arguments.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount#"><cfelse>0</cfif>,
                RATE = <cfif isDefined("arguments.row_rate") and len(arguments.row_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_rate#"><cfelse>NULL</cfif>,
                REASON_CODE = <cfif isDefined("arguments.row_reason_code") and len(arguments.row_reason_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.row_reason_code#"><cfelse>NULL</cfif>
                <cfif isdefined("arguments.bill_info") and len(arguments.bill_info)>
                    ,IS_INVOICE_IPTAL = NULL
                </cfif>
                <cfif isdefined("arguments.payment_finish_date") and len(arguments.payment_finish_date) and isdefined("arguments.xml_payment_finish_date")>  
                    ,PAYMENT_FINISH_DATE = <cfif len(arguments.payment_finish_date) and arguments.xml_payment_finish_date eq 1><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.payment_finish_date#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.money_type_row")>   
                    ,MONEY_TYPE = <cfif len(arguments.money_type_row)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money_type_row#"><cfelse>NULL</cfif>
                </cfif>   
                <cfif isdefined("arguments.row_total")>  
                    ,ROW_TOTAL = <cfif len(arguments.row_total)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_total#"><cfelse>0</cfif>
                </cfif>   
                <cfif isdefined("arguments.discount")> 
                    ,DISCOUNT = <cfif len(arguments.discount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount#"><cfelse>0</cfif>
                </cfif>  
                <cfif isdefined("arguments.discount_amount")>   
                    ,DISCOUNT_AMOUNT = <cfif len(arguments.discount_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount_amount#"><cfelse>0</cfif>
                </cfif>
                <cfif isdefined("arguments.row_net_total")>      
                    ,ROW_NET_TOTAL = <cfif len(arguments.row_net_total)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_net_total#"><cfelse>0</cfif>
                </cfif>   
                <cfif isdefined("arguments.is_collected_inv")> 
                    ,IS_COLLECTED_INVOICE = <cfif isDefined("arguments.is_collected_inv") and arguments.is_collected_inv eq 1>1<cfelse>0</cfif>
                </cfif>  
                <cfif isdefined("arguments.is_group_inv")>  
                    ,IS_GROUP_INVOICE = <cfif isDefined("arguments.is_group_inv") and arguments.is_group_inv eq 1>1<cfelse>0</cfif>
                </cfif>   
                <cfif isdefined("arguments.is_billed") and len(arguments.is_billed)> 
                    ,IS_BILLED = <cfif isDefined("arguments.is_billed") and arguments.is_billed eq 1>1<cfelse>0</cfif>
                </cfif>  
                <cfif isdefined("arguments.is_collected_prov") and len(arguments.is_collected_prov)>   
                    ,IS_COLLECTED_PROVISION = <cfif isDefined("arguments.is_collected_prov") and arguments.is_collected_prov eq 1>1<cfelse>0</cfif>
                </cfif>
                <cfif isdefined("arguments.is_paid") and len(arguments.is_paid)>
                    ,IS_PAID = <cfif isDefined("arguments.is_paid") and arguments.is_paid eq 1>1<cfelse>0</cfif>
                </cfif> 
                <cfif isdefined("arguments.invoice_id")>   
                    ,INVOICE_ID = <cfif isdefined("arguments.invoice_id") and len(arguments.invoice_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.period_id")>
                    ,PERIOD_ID = <cfif isdefined("arguments.period_id") and len(arguments.period_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.paymethod_id") and len(arguments.paymethod_id)>    
                    ,PAYMETHOD_ID = <cfif isDefined("arguments.paymethod_id") and len(arguments.paymethod_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paymethod_id#"><cfelse>NULL</cfif>
                </cfif>  
                <cfif isDefined("arguments.card_paymethod_id")> 
                    ,CARD_PAYMETHOD_ID = <cfif isDefined("arguments.card_paymethod_id") and len(arguments.card_paymethod_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_paymethod_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.subs_ref_id")>
                    ,SUBS_REFERENCE_ID = <cfif isdefined("arguments.subs_ref_id") and len(arguments.subs_ref_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subs_ref_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.service_id")>
                    ,SERVICE_ID = <cfif isdefined("arguments.service_id") and len(arguments.service_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.call_id")>
                    ,CALL_ID = <cfif isdefined("arguments.call_id") and len(arguments.call_id) and isdefined("arguments.call_no") and len(arguments.call_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.call_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined('arguments.camp_id')>
                    ,CAMPAIGN_ID = <cfif isdefined('arguments.camp_id') and len(arguments.camp_id) and isdefined("arguments.camp_name") and len(arguments.camp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.cari_action_id")>
                    ,CARI_ACTION_ID = <cfif isDefined("arguments.is_paid") and isdefined("arguments.cari_action_id") and len(arguments.cari_action_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cari_action_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.cari_period_id")>
                    ,CARI_PERIOD_ID = <cfif isDefined("arguments.is_paid") and isdefined("arguments.cari_period_id") and len(arguments.cari_period_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cari_period_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.cari_act_type")>
                    ,CARI_ACT_TYPE = <cfif isDefined("arguments.is_paid") and isdefined("arguments.cari_act_type") and len(arguments.cari_act_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cari_act_type#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.cari_act_id")>    
                    ,CARI_ACT_ID = <cfif isDefined("arguments.is_paid") and isdefined("arguments.cari_act_id") and len(arguments.cari_act_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cari_act_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.cari_act_table")>
                    ,CARI_ACT_TABLE = <cfif isDefined("arguments.is_paid") and isdefined("arguments.cari_act_table") and len(arguments.cari_act_table)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.cari_act_table#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("cgi.remote_addr")>    
                    ,UPDATE_IP =<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                <cfelse>
                    ,UPDATE_IP = NULL
                </cfif>
                <cfif isDefined('session.pp.userid')>
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">   
                <cfelseif isDefined('session.ep.userid')> 
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  
                <cfelseif isDefined('session.ww.userid')> 
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                <cfelse>
                    ,UPDATE_EMP = NULL
                </cfif>    
                <cfif isdefined('arguments.row_bsmv_rate') and len(arguments.row_bsmv_rate)>, BSMV_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_bsmv_rate#"></cfif>
                <cfif isdefined('arguments.row_bsmv_amount') and len(arguments.row_bsmv_amount)>, BSMV_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_bsmv_amount#"></cfif>
                <cfif isdefined('arguments.row_oiv_rate') and len(arguments.row_oiv_rate)>, OIV_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_oiv_rate#"></cfif>
                <cfif isdefined('arguments.row_oiv_amount') and len(arguments.row_oiv_amount)>, OIV_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_oiv_amount#"></cfif>
                <cfif isdefined('arguments.row_tevkifat_rate') and len(arguments.row_tevkifat_rate)>, TEVKIFAT_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_tevkifat_rate#"></cfif>
                <cfif isdefined('arguments.row_tevkifat_amount') and len(arguments.row_tevkifat_amount)>, TEVKIFAT_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_tevkifat_amount#"></cfif>
            WHERE
                SUBSCRIPTION_PAYMENT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payment_row_id#">
        </cfquery>
    </cffunction> 
    <cffunction name="IS_PAID" returntype="any">
        <cfargument name="is_collected_prov" default="">
        <cfargument name="is_paid" default="">
        <cfargument name="UPDATE_DATE" default="#now()#">
        <cfargument name="payment_row_id" required="yes" default="">
        <cfquery name="IS_PAID" datasource="#dsn3#">
            UPDATE
                SUBSCRIPTION_PAYMENT_PLAN_ROW 
            SET
                IS_COLLECTED_PROVISION = <cfif isDefined("arguments.is_collected_prov") and arguments.is_collected_prov eq 1>1,<cfelse>0,</cfif>
                IS_PAID = <cfif isDefined("arguments.is_paid") and arguments.is_paid eq 1>1,<cfelse>0,</cfif>
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                <cfif isDefined('session.pp.userid')>
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">   
                <cfelseif isDefined('session.ep.userid')> 
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  
                <cfelseif isDefined('session.ww.userid')> 
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                </cfif>
            WHERE
                SUBSCRIPTION_PAYMENT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payment_row_id#">
        </cfquery>
    </cffunction>
    <cffunction name="ADD_PAYMENT_PLAN_ROW" returntype="any">
        <cfargument name="bill_info" default="">
        <cfargument name="row_bsmv_rate" default="">
        <cfargument name="row_bsmv_amount" default="">
        <cfargument name="row_oiv_rate" default="">
        <cfargument name="row_oiv_amount" default="">
        <cfargument name="row_tevkifat_rate" default="">
        <cfargument name="row_tevkifat_amount" default="">
        <cfargument name="contract_id" required="yes" default="">
        <cfargument name="product_id" required="yes" default="">
        <cfargument name="stock_id" required="yes" default="">
        <cfargument name="payment_date" required="yes" default="">
        <cfargument name="unit" required="yes" default="">
        <cfargument name="unit_id" required="yes" default="">
        <cfargument name="quantity" required="yes" default="">
        <cfargument name="amount" required="yes" default="">
        <cfargument name="money_type_row" default="">
        <cfargument name="paymethod_id" required="yes" default="">
        <cfargument name="row_reason_code" default="">  
        <cfargument name="UPDATE_DATE" default="#now()#">
        <cfargument name="HISTORY_ACTION_TYPE" default="1">
            <cfquery name="ADD_PAYMENT_PLAN_ROW" datasource="#dsn3#" RESULT="MAX">
                INSERT INTO
                    SUBSCRIPTION_PAYMENT_PLAN_ROW
                    (
                        CONTRACT_ID,
                        RECORD_DATE,
                        PRODUCT_ID,
                        STOCK_ID,
                        PAYMENT_DATE,
                        UNIT,  
                        MONEY_TYPE,  
                        QUANTITY,
                        AMOUNT,  
                        UNIT_ID,   
                        PAYMETHOD_ID,
                        REASON_CODE
                    <cfif isdefined("arguments.bill_info") and len(arguments.bill_info)>,IS_INVOICE_IPTAL</cfif> 
                    <cfif isdefined("arguments.payment_finish_date")>
                        ,PAYMENT_FINISH_DATE
                    </cfif>
                    <cfif isdefined("arguments.detail")>
                        ,DETAIL
                    </cfif>
                    <cfif isdefined("arguments.row_total")>  
                        ,ROW_TOTAL
                    </cfif> 
                    <cfif isdefined("arguments.discount")>     
                        ,DISCOUNT
                    </cfif>
                    <cfif isdefined("arguments.discount_amount")>     
                        ,DISCOUNT_AMOUNT
                    </cfif> 
                    <cfif isdefined("arguments.row_net_total")>   
                        ,ROW_NET_TOTAL
                    </cfif> 
                    <cfif isdefined("arguments.is_collected_inv")>   
                        ,IS_COLLECTED_INVOICE
                    </cfif>    
                    <cfif isdefined("arguments.is_group_inv")>
                        ,IS_GROUP_INVOICE
                    </cfif>    
                    <cfif isDefined("arguments.is_billed") and isdefined("arguments.invoice_id")> 
                        ,IS_BILLED
                    </cfif>
                    <cfif isDefined("arguments.is_collected_prov")>
                        ,IS_COLLECTED_PROVISION
                    </cfif> 
                    <cfif isDefined("arguments.is_paid")>   
                        ,IS_PAID
                    </cfif>  
                    <cfif isdefined("arguments.invoice_id")>   
                        ,INVOICE_ID
                    </cfif>    
                    <cfif isdefined("arguments.period_id")>   
                        ,PERIOD_ID
                    </cfif>    
                    <cfif isDefined("arguments.card_paymethod_id")>   
                        ,CARD_PAYMETHOD_ID
                    </cfif>    
                    <cfif isdefined('arguments.subs_ref_id') and isdefined('arguments.subs_ref_name')>
                        ,SUBS_REFERENCE_ID
                    </cfif>   
                    <cfif isdefined('arguments.service_id') and isdefined('arguments.service_no')> 
                        ,SERVICE_ID
                    </cfif>    
                    <cfif isdefined('arguments.camp_id') and isdefined('arguments.camp_name')>
                        ,CAMPAIGN_ID
                    </cfif>
                    <cfif isdefined('arguments.call_id') and isdefined('arguments.call_no')>    
                        ,CALL_ID
                    </cfif>  
                    <cfif isdefined('arguments.cari_action_id')>  
                        ,CARI_ACTION_ID
                    </cfif>   
                    <cfif isdefined('arguments.cari_period_id')> 
                        ,CARI_PERIOD_ID
                    </cfif>  
                    <cfif isdefined('arguments.cari_act_type')>  
                        ,CARI_ACT_TYPE
                    </cfif>   
                    <cfif isdefined('arguments.cari_act_id')> 
                        ,CARI_ACT_ID
                    </cfif>   
                    <cfif isdefined('arguments.cari_act_table')> 
                        ,CARI_ACT_TABLE
                    </cfif> 
                    <cfif isDefined("arguments.is_active")>   
                        ,IS_ACTIVE
                    </cfif> 
                    <cfif isDefined("arguments.row_rate")>   
                        ,RATE
                    </cfif>  
                        ,RECORD_IP
                        ,RECORD_EMP
                        <cfif isdefined('arguments.row_bsmv_rate') and len(arguments.row_bsmv_rate)>,BSMV_RATE</cfif>
                        <cfif isdefined('arguments.row_bsmv_amount') and len(arguments.row_bsmv_amount)>,BSMV_AMOUNT</cfif>
                        <cfif isdefined('arguments.row_oiv_rate') and len(arguments.row_oiv_rate)>,OIV_RATE</cfif>
                        <cfif isdefined('arguments.row_oiv_amount') and len(arguments.row_oiv_amount)>,OIV_AMOUNT</cfif>
                        <cfif isdefined('arguments.row_tevkifat_rate') and len(arguments.row_tevkifat_rate)>,TEVKIFAT_RATE</cfif>
                        <cfif isdefined('arguments.row_tevkifat_amount') and len(arguments.row_tevkifat_amount)>,TEVKIFAT_AMOUNT</cfif> 
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.payment_date#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.unit#">, 
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money_type_row#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.quantity#">
                        <cfif len(arguments.amount)>,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount#"><cfelse>,0</cfif>
                        <cfif isdefined("arguments.UNIT_ID") and len(arguments.UNIT_ID)>,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_id#"><cfelse>,0</cfif>    
                        <cfif isDefined("arguments.paymethod_id") and len(arguments.paymethod_id)>,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paymethod_id#"><cfelse>,NULL</cfif>
                        <cfif isDefined("arguments.row_reason_code") and len(arguments.row_reason_code)>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.row_reason_code#"><cfelse>,NULL</cfif>
                        <cfif isdefined("arguments.bill_info") and len(arguments.bill_info)>,NULL</cfif> 
                        <cfif isdefined("arguments.payment_finish_date")>
                            ,<cfif len(arguments.payment_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.payment_finish_date#"><cfelse>NULL</cfif>
                        </cfif>    
                        <cfif isdefined("arguments.detail")>
                            ,<cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>
                        </cfif>  
                        <cfif isdefined("arguments.row_total")> 
                            ,<cfif len(arguments.row_total)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_total#"><cfelse>0</cfif>
                        </cfif>
                        <cfif isdefined("arguments.discount")>    
                            ,<cfif len(arguments.discount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount#"><cfelse>0</cfif>
                        </cfif> 
                        <cfif isdefined("arguments.discount_amount")>   
                            ,<cfif len(arguments.discount_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount_amount#"><cfelse>0</cfif>
                        </cfif>  
                        <cfif isdefined("arguments.row_net_total")>  
                            ,<cfif len(arguments.row_net_total)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_net_total#"><cfelse>0</cfif>
                        </cfif>    
                        <cfif isdefined("arguments.is_collected_inv")>
                            ,<cfif isDefined("arguments.is_collected_inv") and arguments.is_collected_inv eq 1>1<cfelse>0</cfif>
                        </cfif>    
                        <cfif isdefined("arguments.is_group_inv")>
                            ,<cfif isDefined("arguments.is_group_inv") and arguments.is_group_inv eq 1>1<cfelse>0</cfif>
                        </cfif>  
                        <cfif isDefined("arguments.is_billed")>  
                            ,<cfif (isDefined("arguments.is_billed") or isdefined("arguments.invoice_id")) and  arguments.is_billed eq 1>1<cfelse>0</cfif>
                        </cfif>
                        <cfif isDefined("arguments.is_collected_prov")>
                            ,<cfif isDefined("arguments.is_collected_prov") and arguments.is_collected_prov eq 1>1<cfelse>0</cfif>
                        </cfif>  
                        <cfif isDefined("arguments.is_paid")>    
                            ,<cfif isDefined("arguments.is_paid")  and arguments.is_paid eq 1>1<cfelse>0</cfif>
                        </cfif> 
                        <cfif isdefined("arguments.invoice_id")>   
                            ,<cfif isdefined("arguments.invoice_id") and len(arguments.invoice_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"><cfelse>NULL</cfif>
                        </cfif>   
                        <cfif isdefined("arguments.period_id")>
                            ,<cfif isdefined("arguments.period_id") and len(arguments.period_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"><cfelse>NULL</cfif>
                        </cfif>    
                        <cfif isDefined("arguments.card_paymethod_id")>
                            ,<cfif isDefined("arguments.card_paymethod_id") and len(arguments.card_paymethod_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_paymethod_id#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isdefined('arguments.subs_ref_id') and isdefined('arguments.subs_ref_name')>
                            ,<cfif isdefined('arguments.subs_ref_id') and len(arguments.subs_ref_id) and isdefined('arguments.subs_ref_name') and len(arguments.subs_ref_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subs_ref_id#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isdefined('arguments.service_id') and isdefined('arguments.service_no')>
                            ,<cfif isdefined('arguments.service_id') and len(arguments.service_id) and isdefined('arguments.service_no') and len(arguments.service_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isdefined('arguments.camp_id') and isdefined('arguments.camp_name')>
                            ,<cfif isdefined('arguments.camp_id') and len(arguments.camp_id) and isdefined('arguments.camp_name') and len(arguments.camp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isdefined('arguments.call_id') and  isdefined('arguments.call_no')>
                            ,<cfif isdefined('arguments.call_id') and len(arguments.call_id) and isdefined('arguments.call_no') and len(arguments.call_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.call_id#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isdefined('arguments.cari_action_id')>
                            ,<cfif isdefined('arguments.cari_action_id') and len(arguments.cari_action_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cari_action_id#"><cfelse>NULL</cfif>
                        </cfif>   
                        <cfif isdefined('arguments.cari_period_id')> 
                            ,<cfif isdefined('arguments.cari_period_id') and len(arguments.cari_period_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cari_period_id#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isdefined('arguments.cari_act_type')>
                            ,<cfif isdefined('arguments.cari_act_type') and len(arguments.cari_act_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cari_act_type#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isdefined('arguments.cari_act_id')>
                           ,<cfif isdefined('arguments.cari_act_id') and len(arguments.cari_act_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cari_act_id#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isdefined('arguments.cari_act_table')>
                            ,<cfif isdefined('arguments.cari_act_table') and len(arguments.cari_act_table)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.cari_act_table#"><cfelse>NULL</cfif>
                        </cfif>
                        <cfif isDefined("arguments.is_active")>
                            ,<cfif isDefined("arguments.is_active")>1<cfelse>0</cfif>
                        </cfif>  
                        <cfif isDefined("arguments.row_rate")>    
                            ,<cfif isDefined("arguments.row_rate") and len(arguments.row_rate)>#arguments.row_rate#<cfelse>NULL</cfif>
                        </cfif> 
                        <cfif isDefined("cgi.remote_addr")>
                            ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                        <cfelse>
                            ,NULL
                        </cfif>
                        <cfif isDefined('session.pp.userid')>
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">   
                        <cfelseif isDefined('session.ep.userid')> 
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  
                        <cfelseif isDefined('session.ww.userid')> 
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> 
                        <cfelse>
                            ,NULL
                        </cfif> 
                        <cfif isdefined('arguments.row_bsmv_rate') and len(arguments.row_bsmv_rate)>,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_bsmv_rate#"></cfif>
                        <cfif isdefined('arguments.row_bsmv_amount') and len(arguments.row_bsmv_amount)>,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_bsmv_amount#"></cfif>
                        <cfif isdefined('arguments.row_oiv_rate') and len(arguments.row_oiv_rate)>,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_oiv_rate#"></cfif>
                        <cfif isdefined('arguments.row_oiv_amount') and len(arguments.row_oiv_amount)>,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_oiv_amount#"></cfif>
                        <cfif isdefined('arguments.row_tevkifat_rate') and len(arguments.row_tevkifat_rate)>,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_tevkifat_rate#"></cfif>
                        <cfif isdefined('arguments.row_tevkifat_amount') and len(arguments.row_tevkifat_amount)>,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.row_tevkifat_amount#"></cfif> 
                    )
            </cfquery>     
    </cffunction>
      <!--- ödeme planı silme sayfası--->
      <cffunction name="DEL_PAY_PLAN_ROW" returntype="any">
        <cfargument name="start_date" default="">
        <cfargument name="contract_id" default="">  
        <cfquery name="DEL_PAY_PLAN_ROW" datasource="#dsn3#">
            DELETE FROM
                SUBSCRIPTION_PAYMENT_PLAN_ROW
            WHERE
                IS_PAID = 0 AND
                IS_COLLECTED_PROVISION = 0 AND
                IS_BILLED = 0 AND
                PAYMENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contract_id#">
        </cfquery>
    </cffunction>
    <cffunction name="DEL_PAY_PLAN_ROW2" returntype="any">
        <cfargument name="payment_row_id" default="">
        <cfquery name="DEL_PAY_PLAN_ROW" datasource="#dsn3#">
            DELETE FROM 
                SUBSCRIPTION_PAYMENT_PLAN_ROW
            WHERE 
                SUBSCRIPTION_PAYMENT_ROW_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payment_row_id#" list="yes">)
        </cfquery>
    </cffunction>
</cfcomponent>
