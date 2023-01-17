<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="GET_BYID" access="public">
        <cfargument name="IMPORT_TYPE_ID" type="numeric" request="yes">
        <cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
        <cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
        <cfquery name="GET_IMPORT_TYPE" datasource="#dsn3#">
            SELECT
                IMPORT_TYPE_ID
                ,IMPORT_TYPE_NAME
                ,SUBSCRIPTION_TYPE_ID
                ,IMPORT_TYPE
                ,PAYMETHOD_ID
                ,IS_PAYMENT_DATE
                ,PRODUCT_ID
                ,STOCK_ID
                ,DETAIL
                ,USE_PRODUCT_PRICE
                ,USE_PRODUCT_REASON_CODE
                ,USE_PRODUCT_TAX
                ,USE_PRODUCT_PAYMETHOD
                ,IS_COLLECTED_INVOICE
                ,IS_GROUP_INVOICE
                ,IS_ROW_DESCRIPTION
                ,IS_ALLOW_ZERO_PRICE
                ,CFC_FILE
                ,TYPE_DESCRIPTION
                ,RECORD_EMP
                ,RECORD_IP
                ,RECORD_DATE
                ,UPDATE_EMP
                ,UPDATE_IP
                ,UPDATE_DATE
            FROM SETUP_PAYMENT_PLAN_IMPORT_TYPE
            WHERE
                IMPORT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IMPORT_TYPE_ID#">
                <cfif get_subscription_authority.IS_SUBSCRIPTION_AUTHORITY eq 1 and session.ep.ADMIN eq 0>
                    AND EXISTS 
                		(
                			SELECT
                			SPC.SUBSCRIPTION_TYPE_ID
                			FROM        
                			    #dsn#.EMPLOYEE_POSITIONS AS EP,
                			    SUBSCRIPTION_GROUP_PERM SPC
                			WHERE
                                EP.POSITION_CODE = #session.ep.position_code# AND
                                (
                                    SPC.POSITION_CODE = EP.POSITION_CODE OR
                                    SPC.POSITION_CAT = EP.POSITION_CAT_ID
                                )
                                AND SETUP_PAYMENT_PLAN_IMPORT_TYPE.SUBSCRIPTION_TYPE_ID = spc.SUBSCRIPTION_TYPE_ID
                		)
                </cfif>
        </cfquery>
        <cfreturn GET_IMPORT_TYPE>
    </cffunction>
    <cffunction name="GET_BYID_FOR_BACKEND" access="public" hint="transactionlarda problem olduğu için yetki kontrolü olmadan çağırıyor kullanırken dikkat">
        <cfargument name="IMPORT_TYPE_ID" type="numeric" request="yes">
        <cfquery name="GET_IMPORT_TYPE" datasource="#dsn3#">
            SELECT
                IMPORT_TYPE_ID
                ,IMPORT_TYPE_NAME
                ,SUBSCRIPTION_TYPE_ID
                ,IMPORT_TYPE
                ,PAYMETHOD_ID
                ,PRODUCT_ID
                ,STOCK_ID
                ,DETAIL
                ,IS_PAYMENT_DATE
                ,USE_PRODUCT_PRICE
                ,USE_PRODUCT_REASON_CODE
                ,USE_PRODUCT_TAX
                ,USE_PRODUCT_PAYMETHOD
                ,IS_COLLECTED_INVOICE
                ,IS_GROUP_INVOICE
                ,IS_ROW_DESCRIPTION
                ,IS_ALLOW_ZERO_PRICE
                ,CFC_FILE
                ,TYPE_DESCRIPTION
                ,RECORD_EMP
                ,RECORD_IP
                ,RECORD_DATE
                ,UPDATE_EMP
                ,UPDATE_IP
                ,UPDATE_DATE
            FROM SETUP_PAYMENT_PLAN_IMPORT_TYPE
            WHERE
                IMPORT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IMPORT_TYPE_ID#">
        </cfquery>
        <cfreturn GET_IMPORT_TYPE>
    </cffunction>
    <cffunction name="GET_IMPORT_TYPE" access="public">
        <cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
        <cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
        <cfquery name="GET_IMPORT_TYPE" datasource="#dsn3#">
            SELECT
                IMPORT_TYPE_ID
                ,IMPORT_TYPE_NAME
                ,SUBSCRIPTION_TYPE_ID
                ,IMPORT_TYPE
                ,PAYMETHOD_ID
                ,IS_PAYMENT_DATE
                ,PRODUCT_ID
                ,STOCK_ID
                ,DETAIL
                ,USE_PRODUCT_PRICE
                ,USE_PRODUCT_REASON_CODE
                ,USE_PRODUCT_TAX
                ,USE_PRODUCT_PAYMETHOD
                ,IS_COLLECTED_INVOICE
                ,IS_GROUP_INVOICE
                ,IS_ROW_DESCRIPTION
                ,IS_ALLOW_ZERO_PRICE
                ,CFC_FILE
                ,TYPE_DESCRIPTION
                ,RECORD_EMP
                ,RECORD_IP
                ,RECORD_DATE
                ,UPDATE_EMP
                ,UPDATE_IP
                ,UPDATE_DATE
            FROM 
                SETUP_PAYMENT_PLAN_IMPORT_TYPE
            WHERE
            1=1
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                    AND IMPORT_TYPE_NAME Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif get_subscription_authority.IS_SUBSCRIPTION_AUTHORITY eq 1 and session.ep.ADMIN eq 0>
                   AND EXISTS 
                		(
                			SELECT
                			SPC.SUBSCRIPTION_TYPE_ID
                			FROM        
                			    #dsn#.EMPLOYEE_POSITIONS AS EP,
                			    SUBSCRIPTION_GROUP_PERM SPC
                			WHERE
                                EP.POSITION_CODE = #session.ep.position_code# AND
                                (
                                    SPC.POSITION_CODE = EP.POSITION_CODE OR
                                    SPC.POSITION_CAT = EP.POSITION_CAT_ID
                                )
                                AND SETUP_PAYMENT_PLAN_IMPORT_TYPE.SUBSCRIPTION_TYPE_ID = spc.SUBSCRIPTION_TYPE_ID
                		)
                </cfif>
        </cfquery>
        <cfreturn GET_IMPORT_TYPE>
    </cffunction> 
    <cffunction name="ADD" access="public" returnType="any">
        <cfargument name="IMPORT_TYPE_NAME" type="string" required="yes">
        <cfargument name="SUBSCRIPTION_TYPE_ID">
        <cfargument name="IMPORT_TYPE" type="string" required="yes">
        <cfargument name="PAYMETHOD_ID" type="numeric" default="0">
        <cfargument name="IS_PAYMENT_DATE" type="boolean" default="false">
        <cfargument name="PRODUCT_ID" type="numeric" default="0">
        <cfargument name="STOCK_ID" type="numeric" default="0">
        <cfargument name="DETAIL" type="string" default="">
        <cfargument name="USE_PRODUCT_PRICE" type="boolean" default="false">
        <cfargument name="USE_PRODUCT_REASON_CODE" type="boolean" default="false">
        <cfargument name="USE_PRODUCT_PAYMETHOD" type="boolean" default="false">
        <cfargument name="USE_PRODUCT_TAX" type="boolean" default="false">
        <cfargument name="IS_COLLECTED_INVOICE" type="boolean" default="false">
        <cfargument name="IS_GROUP_INVOICE" type="boolean" default="false">
        <cfargument name="IS_ROW_DESCRIPTION" type="boolean" default="false">
        <cfargument name="IS_ALLOW_ZERO_PRICE" type="boolean" default="false">
        <cfargument name="CFC_FILE" type="string" default="">
        <cfargument name="TYPE_DESCRIPTION" type="string" default="">
        <cfquery name="ADD_IMPORT_TYPE" datasource="#DSN3#">
            INSERT INTO 
                SETUP_PAYMENT_PLAN_IMPORT_TYPE 
            (
                IMPORT_TYPE_NAME
                ,SUBSCRIPTION_TYPE_ID
                ,IMPORT_TYPE
                ,PAYMETHOD_ID
                ,IS_PAYMENT_DATE
                ,PRODUCT_ID
                ,STOCK_ID
                ,DETAIL
                ,USE_PRODUCT_PRICE
                ,USE_PRODUCT_REASON_CODE
                ,USE_PRODUCT_TAX
                ,USE_PRODUCT_PAYMETHOD
                ,IS_COLLECTED_INVOICE
                ,IS_GROUP_INVOICE
                ,IS_ROW_DESCRIPTION
                ,IS_ALLOW_ZERO_PRICE
                ,CFC_FILE
                ,TYPE_DESCRIPTION
                ,RECORD_EMP
                ,RECORD_IP
                ,RECORD_DATE
            ) 
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IMPORT_TYPE_NAME#">,
                <cfif isdefined("arguments.SUBSCRIPTION_TYPE_ID") and len(arguments.SUBSCRIPTION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SUBSCRIPTION_TYPE_ID#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IMPORT_TYPE#">,
                <cfif arguments.PAYMETHOD_ID gt 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PAYMETHOD_ID#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_PAYMENT_DATE#">,
                <cfif arguments.PRODUCT_ID gt 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"><cfelse>NULL</cfif>,
                <cfif arguments.STOCK_ID gt 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STOCK_ID#"><cfelse>NULL</cfif>,
                <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.USE_PRODUCT_PRICE#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.USE_PRODUCT_REASON_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.USE_PRODUCT_TAX#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.USE_PRODUCT_PAYMETHOD#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_COLLECTED_INVOICE#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_GROUP_INVOICE#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_ROW_DESCRIPTION#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_ALLOW_ZERO_PRICE#">,
                <cfif len(arguments.CFC_FILE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFC_FILE#"><cfelse>NULL</cfif>,
                <cfif len(arguments.TYPE_DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TYPE_DESCRIPTION#"><cfelse>NULL</cfif>,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #now()#
            )
        </cfquery>
        
		<cfreturn true>
    </cffunction>

    <cffunction name="get_maxId" access="public" returntype="numeric">
        <cfquery name="get_maxId" datasource="#dsn3#">
        SELECT 
           MAX(IMPORT_TYPE_ID) IMPORT_TYPE_ID
        FROM 
            SETUP_PAYMENT_PLAN_IMPORT_TYPE
        WHERE 
            RECORD_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_numeric">
       </cfquery>
        <cfreturn get_maxId.IMPORT_TYPE_ID />
    </cffunction>

    <cffunction name="UPDATE" access="public">
        <cfargument name="IMPORT_TYPE_ID" type="string" required="yes">
        <cfargument name="IMPORT_TYPE_NAME" type="string" required="yes">
        <cfargument name="SUBSCRIPTION_TYPE_ID">
        <cfargument name="IMPORT_TYPE" type="string" required="yes">
        <cfargument name="PAYMETHOD_ID" type="numeric" default="0">
        <cfargument name="IS_PAYMENT_DATE" type="boolean" default="false">
        <cfargument name="PRODUCT_ID" type="numeric" default="0">
        <cfargument name="STOCK_ID" type="numeric" default="0">
        <cfargument name="DETAIL" type="string" default="">
        <cfargument name="USE_PRODUCT_PRICE" type="boolean" default="false">
        <cfargument name="USE_PRODUCT_REASON_CODE" type="boolean" default="false">
        <cfargument name="USE_PRODUCT_TAX" type="boolean" default="false">
        <cfargument name="USE_PRODUCT_PAYMETHOD" type="boolean" default="false">
        <cfargument name="IS_COLLECTED_INVOICE" type="boolean" default="false">
        <cfargument name="IS_ROW_DESCRIPTION" type="boolean" default="false">
        <cfargument name="IS_GROUP_INVOICE" type="boolean" default="false">
        <cfargument name="IS_ALLOW_ZERO_PRICE" type="boolean" default="false">
        <cfargument name="CFC_FILE" type="string">
        <cfargument name="TYPE_DESCRIPTION" type="string" default="">
        <cfquery name="UPD_IMPORT_TYPE" datasource="#DSN3#">
            UPDATE 
                SETUP_PAYMENT_PLAN_IMPORT_TYPE
            SET 
                IMPORT_TYPE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IMPORT_TYPE_NAME#">,
                SUBSCRIPTION_TYPE_ID = <cfif isdefined("arguments.SUBSCRIPTION_TYPE_ID") and len(arguments.SUBSCRIPTION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SUBSCRIPTION_TYPE_ID#"><cfelse>NULL</cfif>,
                IMPORT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IMPORT_TYPE#">,
                PAYMETHOD_ID = <cfif arguments.PAYMETHOD_ID gt 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PAYMETHOD_ID#"><cfelse>NULL</cfif>,
                IS_PAYMENT_DATE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_PAYMENT_DATE#">,
                PRODUCT_ID = <cfif arguments.PRODUCT_ID gt 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"><cfelse>NULL</cfif>,
                STOCK_ID = <cfif arguments.STOCK_ID gt 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STOCK_ID#"><cfelse>NULL</cfif>,
                DETAIL=<cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                USE_PRODUCT_PRICE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.USE_PRODUCT_PRICE#">,
                USE_PRODUCT_REASON_CODE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.USE_PRODUCT_REASON_CODE#">,
                USE_PRODUCT_TAX = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.USE_PRODUCT_TAX#">,
                USE_PRODUCT_PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.USE_PRODUCT_PAYMETHOD#">,
                IS_COLLECTED_INVOICE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_COLLECTED_INVOICE#">,
                IS_GROUP_INVOICE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_GROUP_INVOICE#">,
                IS_ROW_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_ROW_DESCRIPTION#">,
                IS_ALLOW_ZERO_PRICE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_ALLOW_ZERO_PRICE#">,
                <cfif isdefined("arguments.CFC_FILE")>CFC_FILE = <cfif len(arguments.CFC_FILE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFC_FILE#"><cfelse>NULL</cfif>,</cfif>
                TYPE_DESCRIPTION = <cfif len(arguments.TYPE_DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TYPE_DESCRIPTION#"><cfelse>NULL</cfif>,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#
            WHERE
                IMPORT_TYPE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IMPORT_TYPE_ID#">
        </cfquery>
        <cfreturn true>
    </cffunction>
</cfcomponent>