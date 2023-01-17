<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
    <cffunction name="get_efatura_det" returntype="query">
        <cfargument name="receiving_detail_id" default="">
        <cfquery name="get_efatura_det" datasource="#dsn2#">
                SELECT 
                    ERD.RECEIVING_DETAIL_ID,
                    I.INVOICE_ID,
                    I.INVOICE_CAT,
                    EIP.EXPENSE_ID,
                    EIP.ACTION_TYPE               
                FROM 
                    EINVOICE_RECEIVING_DETAIL ERD
                    LEFT JOIN INVOICE I ON ERD.INVOICE_ID = I.INVOICE_ID
                    LEFT JOIN EXPENSE_ITEM_PLANS EIP ON ERD.EXPENSE_ID = EIP.EXPENSE_ID
                WHERE
                    RECEIVING_DETAIL_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.receiving_detail_id#">
        </cfquery>
      <cfreturn get_efatura_det>
    </cffunction>
    <cffunction name="get_member" returntype="query">
        <cfargument name="temp_VKN_" default="">
        <cfquery name="get_member" datasource="#DSN#">
            SELECT 
                1 AS TYPE,
                C.COMPANY_ID AS MEMBER_ID
            FROM 
                COMPANY C,
                COMPANY_PARTNER CP, 
                COMPANY_CAT CC, 
                COMPANY_CAT_OUR_COMPANY CCO 
            WHERE                                                               
                (C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.temp_VKN_#"> OR 
                CP.TC_IDENTITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.temp_VKN_#">) AND
                CCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                C.COMPANY_ID = CP.COMPANY_ID AND
                C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                CC.COMPANYCAT_ID = CCO.COMPANYCAT_ID
            UNION ALL
            SELECT 
                2 AS TYPE,
                C.CONSUMER_ID AS MEMBER_ID
            FROM 
                CONSUMER C, 
                CONSUMER_CAT CC, 
                CONSUMER_CAT_OUR_COMPANY CCO 
            WHERE                                                               
                C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.temp_VKN_#"> AND
                CCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
                CC.CONSCAT_ID = CCO.CONSCAT_ID
        </cfquery>
       
        <cfreturn get_member>
    </cffunction>
</cfcomponent>
    