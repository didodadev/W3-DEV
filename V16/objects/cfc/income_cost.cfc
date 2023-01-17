<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3="#dsn#_#session.ep.company_id#">
	<cfset dsn3_alias=dsn3>
	<cffunction name="GET_MONEY" access="public">
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
        </cfquery>
        <cfreturn GET_MONEY>
    </cffunction>
    <cffunction name="GET_EXPENSE_MONEY" access="public">
        <cfargument name="expense_id" default="">
        <cfquery name="GET_EXPENSE_MONEY" datasource="#DSN2#"><!--- expense money kayıtları --->
            SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
        </cfquery>
        <cfif not GET_EXPENSE_MONEY.recordcount>
            <cfquery name="GET_EXPENSE_MONEY" datasource="#DSN#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS=<cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
            </cfquery>
        </cfif>
        <cfreturn GET_EXPENSE_MONEY>
    </cffunction>
    <cffunction name="GET_EXPENSE" access="public">
        <cfargument name="expense_id" default="">
        <cfquery name="GET_EXPENSE" datasource="#DSN2#">
            SELECT 
                EIP.*,
                SPC.INVOICE_TYPE_CODE,
                 CASE WHEN BA.ACTION_ID IS NOT NULL THEN BA.ACTION_ID WHEN CA.ACTION_ID IS NOT NULL THEN CA.ACTION_ID WHEN CCBE.CREDITCARD_EXPENSE_ID IS NOT NULL THEN CCBE.CREDITCARD_EXPENSE_ID ELSE 0 END AS RELATED_ACTION_ID,
                CASE WHEN BA.ACTION_ID IS NOT NULL THEN 'BANK_ACTIONS' WHEN CA.ACTION_ID IS NOT NULL THEN 'CASH_ACTIONS' WHEN CCBE.CREDITCARD_EXPENSE_ID IS NOT NULL THEN 'CREDIT_ACTIONS' ELSE '' END AS RELATED_ACTION_TABLE
            FROM 
                EXPENSE_ITEM_PLANS EIP
                    LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON EIP.PROCESS_CAT = SPC.PROCESS_CAT_ID
                    LEFT JOIN CASH_ACTIONS CA ON CA.PAPER_NO = EIP.PAPER_NO AND EIP.EXPENSE_ID=CA.EXPENSE_ID
                    LEFT JOIN BANK_ACTIONS BA ON BA.PAPER_NO = EIP.PAPER_NO AND EIP.EXPENSE_ID=BA.EXPENSE_ID
                    LEFT JOIN #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CCBE ON CCBE.PAPER_NO = EIP.PAPER_NO AND EIP.EXPENSE_ID=CCBE.EXPENSE_ID
            WHERE
                EIP.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
        </cfquery>
        <cfreturn GET_EXPENSE>
    </cffunction>
    <cffunction name="CHK_SEND_INV" access="public">
        <cfargument name="expense_id" default="">
        <cfquery name="CHK_SEND_INV" datasource="#DSN2#">
            SELECT COUNT(*) COUNT FROM EINVOICE_SENDING_DETAIL WHERE  ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#"> AND ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1
        </cfquery> 
        <cfreturn CHK_SEND_INV>
    </cffunction>
    <cffunction name="CHK_SEND_ARC" access="public">
        <cfargument name="expense_id" default="">
        <cfquery name="CHK_SEND_ARC" datasource="#DSN2#">
            SELECT COUNT(*) COUNT FROM EARCHIVE_SENDING_DETAIL WHERE  ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#"> AND ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1
        </cfquery>
        <cfreturn CHK_SEND_ARC>
    </cffunction>
    <cffunction name="CONTROL_EINVOICE" access="public">
        <cfargument name="expense_id" default="">
        <cfquery name="CONTROL_EINVOICE" datasource="#DSN2#">
            SELECT ACTION_ID FROM EINVOICE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#"> AND ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
        </cfquery> 
        <cfreturn CONTROL_EINVOICE>
    </cffunction>
    <cffunction name="CONTROL_EARCHIVE" access="public">
        <cfargument name="expense_id" default="">
        <cfquery name="CONTROL_EARCHIVE" datasource="#DSN2#">
            SELECT ISNULL(IS_CANCEL,0) IS_CANCEL FROM EARCHIVE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#"> AND ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
        </cfquery>
        <cfreturn CONTROL_EARCHIVE>
    </cffunction>
    <cffunction name="get_expense_comp" access="public">
        <cfargument name="ch_company_id" default="">
        <cfquery name="get_expense_comp" datasource="#DSN#">
            SELECT 
                COMPANY_ID,
                COMPANYCAT_ID,
                TAXOFFICE,
                TAXNO,
                COMPANY_ADDRESS,
                COUNTY,
                CITY,
                COUNTRY,
                FULLNAME,
                COMPANY_TELCODE,
                COMPANY_TEL1,
                COMPANY_FAX,
                COMPANY_ADDRESS,
                COMPANY_EMAIL,
                MEMBER_CODE,
                IMS_CODE_ID,
                USE_EFATURA,
                EFATURA_DATE
            FROM
                COMPANY
            WHERE 
                COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ch_company_id#">
        </cfquery>
        <cfreturn get_expense_comp>
    </cffunction>
    <cffunction name="GET_CONS_NAME" access="public">
        <cfargument name="ch_consumer_id" default="">
        <cfquery name="GET_CONS_NAME" datasource="#DSN#">
            SELECT 
                CONSUMER_ID,
                CONSUMER_CAT_ID,
                COMPANY,
                MEMBER_CODE,
                TC_IDENTY_NO,
                CONSUMER_NAME,
                CONSUMER_SURNAME,
                CONSUMER_WORKTELCODE,
                CONSUMER_WORKTEL,
                CONSUMER_FAX,
                CONSUMER_EMAIL,
                MOBIL_CODE,
                MOBILTEL,
                TAX_ADRESS,
                TAX_CITY_ID,
                TAX_COUNTY_ID,
                TAX_COUNTRY_ID,
                TAX_NO,
                TAX_OFFICE,
                VOCATION_TYPE_ID,
                IMS_CODE_ID,
                USE_EFATURA,
                EFATURA_DATE
            FROM 
                CONSUMER
            WHERE 
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ch_consumer_id#">
        </cfquery>		
        <cfreturn GET_CONS_NAME>
    </cffunction>
    <cffunction name="GET_DOCUMENT_TYPE" access="public">
        <cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
            SELECT
                SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
                SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
            FROM
                SETUP_DOCUMENT_TYPE,
                SETUP_DOCUMENT_TYPE_ROW
            WHERE
                SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
                SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#fuseaction#%">
            ORDER BY
                DOCUMENT_TYPE_NAME
        </cfquery>
      <cfreturn GET_DOCUMENT_TYPE>
    </cffunction>
    <cffunction name = "getLawRequest" returnType = "any" access = "public"  hint = "icra dosya no yu getirir">
        <cfquery name = "getLawRequest" datasource = "#dsn#">
           SELECT 
                FILE_NUMBER,
                COMPANY_ID AS CH_COMPANY_ID,
                CONSUMER_ID AS CH_CONSUMER_ID,
                '' CH_EMPLOYEE_ID,
                '' CH_PARTNER_ID,
                '' ACC_TYPE_ID,
                '' PAPER_TYPE,
                '' DETAIL,
                '' SYSTEM_RELATION,
                '' DEPARTMENT_ID,
                '' LOCATION_ID,
                '' EXPENSE_CASH_ID,
                '' PAYMETHOD_ID,
                '' EXPENSE_DATE,
                '' EXPENSE_DATE_TIME,
                '' ACC_TYPE_ID_EXP,
                '' DUE_DATE,
                '' EMP_ID,
                '' IS_CASH,
                '' IS_BANK,
                '' TEVKIFAT,
                '' TEVKIFAT_ORAN,
                '' SHIP_ADDRESS_ID,
                '' SHIP_ADDRESS,
                '' TEVKIFAT_ID,
                '' BRANCH_ID,
                '' PROJECT_ID,
                '' ROUND_MONEY,
                '' STOPAJ,
                '0' STOPAJ_ORAN,
                '0' STOPAJ_RATE_ID,
                '0' OTV_TOTAL,
                '' IS_CREDITCARD,
                '' EXPENSE_ID,		
                '' ACC_DEPARTMENT_ID,
                '' TAX_CODE,
                '0' TOTAL_AMOUNT,
                '0' KDV_TOTAL,
                '0' TOTAL_AMOUNT_KDVLI,
                '' OTHER_MONEY_AMOUNT,
                '' OTHER_MONEY,
                '' OTHER_MONEY_KDV,
                '' OTHER_MONEY_OTV,
                '' OTHER_MONEY_NET_TOTAL,
                '' PROCESS_DATE,
                '' POSITION_CODE
            FROM 
                COMPANY_LAW_REQUEST
            WHERE 
                LAW_REQUEST_ID = <cfqueryparam value = "#arguments.law_id#" CFSQLType = "cf_sql_integer"> 
        </cfquery>
        <cfreturn getLawRequest>
    </cffunction>
    <cffunction name = "getCollectionExpenseLaw" returnType = "any" access = "public" hint = "icra-gelir fişi">
       <cfquery name="getCollectionExpenseLaw" datasource="#dsn#">
            SELECT 
                EIP.PAPER_NO,
                EIP.EXPENSE_ID,
                EIP.EXPENSE_DATE,
                CLP.TOTAL_REVENUE,
                CLP.TOTAL_AMOUNT AS TOTAL_CREDIT,
                EIP.TOTAL_AMOUNT ,
                CLP.KALAN_REVENUE,
                CLP.KALAN_REVENUE_MONEY_CURRENCY,
                SPC.PROCESS_CAT,
                EI.EXPENSE_ITEM_NAME,
                EC.EXPENSE,
                EI.EXPENSE_ITEM_ID,
                EIPR.EXPENSE_ACCOUNT_CODE AS ACCOUNT_CODE
            FROM
                COMPANY_LAW_REQUEST CLP
                LEFT JOIN #dsn2#.EXPENSE_ITEM_PLANS EIP ON CLP.LAW_REQUEST_ID = EIP.LAW_REQUEST_ID
                LEFT JOIN #dsn2#.EXPENSE_ITEMS_ROWS EIPR ON EIP.EXPENSE_ID = EIPR.EXPENSE_ID
                LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = EIPR.EXPENSE_ITEM_ID
                LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = EIPR.EXPENSE_CENTER_ID 
                LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON EIP.PROCESS_CAT = SPC.PROCESS_CAT_ID
            WHERE
                EIP.ACTION_TYPE = <cfqueryparam value = "#arguments.process_type#" CFSQLType = "cf_sql_integer">
                AND CLP.LAW_REQUEST_ID = <cfqueryparam value = "#arguments.lawRequestId#" CFSQLType = "cf_sql_integer">
       </cfquery> 
       <cfreturn getCollectionExpenseLaw>
    </cffunction>
</cfcomponent>