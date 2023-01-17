<cfcomponent>
    <cfset dsn = application.SystemParam.SystemParam().dsn>
    
    <cfif isdefined("session.ep")>
        <cfset dsn3 = "#dsn#_#session.ep.company_id#">
        <cfset userid = "#session.ep.userid#">
    <cfelseif isdefined("session.pp")>
        <cfset dsn3 = "#dsn#_#session.pp.our_company_id#">
    <cfelseif isdefined("session.ww")>
        <cfset dsn3 = "#dsn#_#session.ww.our_company_id#">
    </cfif>
    
    <cffunction name = "get_counter_type" access = "public" returntype = "query" hint = "Select counter types">
        <cfargument  name="ct_id" type="any" required="false" default="">
        <cfargument  name="keyword" type="string" required="false" default="">
        
        <cfquery name = "q_get_counter_type" datasource = "#dsn3#">
            SELECT 
                SCT.COUNTER_TYPE_ID,
                SCT.COUNTER_TYPE,
                SCT.READING_TYPE_ID,
                SCT.READING_PERIOD,
                SCT.START_VALUE,
                SCT.TARIFF,
                SCT.INVOICE_PERIOD,
                SCT.FREE_PERIOD,
                SCT.WEX_CODE,
                SCT.RECORD_DATE,
                SCT.RECORD_EMP,
                SCT.RECORD_IP,
                SCT.UPDATE_DATE,
                SCT.UPDATE_EMP,
                SCT.UPDATE_IP,
                TARIFF.TARIFF_NAME,
                WX.HEAD
            FROM SETUP_COUNTER_TYPE AS SCT
            LEFT JOIN SUBSCRIPTION_TARIFF AS TARIFF ON SCT.TARIFF = TARIFF.TARIFF_ID
            LEFT JOIN #dsn#.WRK_WEX AS WX ON SCT.WEX_CODE = WX.WEX_ID
            WHERE 1 = 1
            <cfif isDefined("arguments.ct_id") and len(arguments.ct_id)>
                AND SCT.COUNTER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ct_id#">
            </cfif>
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND SCT.COUNTER_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="'#arguments.keyword#%'">
            </cfif>
            ORDER BY 
                SCT.COUNTER_TYPE DESC
        </cfquery>
        <cfreturn q_get_counter_type>
    </cffunction>

    <cffunction name = "add_counter_type" access = "public" returntype = "struct" hint = "Insert counter type">
        <cfargument name="counter_type" type="string" required="true" default="">
        <cfargument name="reading_type" type="numeric" required="true" default="">
        <cfargument name="reading_period" type="numeric" required="true" default="">
        <cfargument name="start_value" type="any" required="true" default="">
        <cfargument name="tariff_id" type="numeric" required="true" default="">
        <cfargument name="invoice_period" type="numeric" required="true" default="">
        <cfargument name="free_period" type="numeric" required="true" default="">
        <cfargument name="wex_code" type="string" required="true" default="">
        
        <cfset response = structNew()>
        <cftry>
            <cfquery name = "q_insert_counter_type" datasource = "#dsn3#" result="result">
                INSERT INTO 
                SETUP_COUNTER_TYPE(
                    COUNTER_TYPE,
                    READING_TYPE_ID,
                    READING_PERIOD,
                    START_VALUE,
                    TARIFF,
                    INVOICE_PERIOD,
                    FREE_PERIOD,
                    WEX_CODE,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES(
                    <cfqueryparam value = "#arguments.counter_type#" CFSQLType = "cf_sql_nvarchar">,
                    <cfqueryparam value = "#arguments.reading_type#" CFSQLType = "cf_sql_integer">,
                    <cfqueryparam value = "#arguments.reading_period#" CFSQLType = "cf_sql_integer">,
                    <cfqueryparam value = "#arguments.start_value#" CFSQLType = "cf_sql_float">,
                    <cfqueryparam value = "#arguments.tariff_id#" CFSQLType = "cf_sql_integer">,
                    <cfqueryparam value = "#arguments.invoice_period#" CFSQLType = "cf_sql_integer">,
                    <cfqueryparam value = "#arguments.free_period#" CFSQLType = "cf_sql_integer">,
                    <cfqueryparam value = "#arguments.wex_code#" CFSQLType = "cf_sql_nvarchar">,
                    <cfif len(userid)><cfqueryparam cfsqltype="cf_sql_integer" value="#userid#"><cfelse>NULL</cfif>,
                    #now()#,
                    <cfqueryparam value = "#CGI.REMOTE_ADDR#" CFSQLType = "cf_sql_nvarchar">
                )
            </cfquery>
            <cfset response.message = "İşlem Başarılı">
            <cfset response.status = true>
            <cfset response.error = {}>
            <cfset response.identity = result.identitycol>
        <cfcatch type="any">
            <cfset response.message = "İşlem Hatalı">
            <cfset response.status = false>
            <cfset response.error = cfcatch>
        </cfcatch>
        </cftry>    
        <cfreturn response>
    </cffunction>

    <cffunction name = "update_counter_type" access = "public" returntype = "struct" hint = "Update counter type">
        <cfargument name="counter_type" type="string" required="true" default="">
        <cfargument name="reading_type" type="numeric" required="true" default="">
        <cfargument name="reading_period" type="numeric" required="true" default="">
        <cfargument name="start_value" type="any" required="true" default="">
        <cfargument name="tariff_id" type="numeric" required="true" default="">
        <cfargument name="invoice_period" type="numeric" required="true" default="">
        <cfargument name="free_period" type="numeric" required="true" default="">
        <cfargument name="wex_code" type="string" required="true" default="">
        <cfargument name="ct_id" type="numeric" required="true" default="">
        
        <cfset response = structNew()>
        
        <cftry>
            <cfquery name = "q_update_counter_type" datasource = "#dsn3#">
                UPDATE  
                    SETUP_COUNTER_TYPE
                SET
                    COUNTER_TYPE = <cfqueryparam value = "#arguments.counter_type#" CFSQLType = "cf_sql_nvarchar">,
                    READING_TYPE_ID = <cfqueryparam value = "#arguments.reading_type#" CFSQLType = "cf_sql_integer">,
                    READING_PERIOD = <cfqueryparam value = "#arguments.reading_period#" CFSQLType = "cf_sql_integer">,
                    START_VALUE = <cfqueryparam value = "#arguments.start_value#" CFSQLType = "cf_sql_float">,
                    TARIFF = <cfqueryparam value = "#arguments.tariff_id#" CFSQLType = "cf_sql_integer">,
                    INVOICE_PERIOD = <cfqueryparam value = "#arguments.invoice_period#" CFSQLType = "cf_sql_integer">,
                    FREE_PERIOD = <cfqueryparam value = "#arguments.free_period#" CFSQLType = "cf_sql_integer">,
                    WEX_CODE = <cfqueryparam value = "#arguments.wex_code#" CFSQLType = "cf_sql_nvarchar">,
                    UPDATE_EMP = <cfif len(userid)><cfqueryparam cfsqltype="cf_sql_integer" value="#userid#"><cfelse>NULL</cfif>,
                    UPDATE_DATE = <cfqueryparam value = "#now()#" CFSQLType = "cf_sql_date">,
                    UPDATE_IP = <cfqueryparam value = "#CGI.REMOTE_ADDR#" CFSQLType = "cf_sql_nvarchar">
                WHERE COUNTER_TYPE_ID = <cfqueryparam value = "#arguments.ct_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfset response.message = "İşlem Başarılı">
            <cfset response.status = true>
            <cfset response.error = {}>
            <cfset response.identity = ''>
            <cfcatch type = "any">
                <cfset response.message = "İşlem Hatalı">
                <cfset response.status = false>
                <cfset response.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name = "delete_counter_type" access = "public" hint = "Delete counter type">
        <cfargument name="ct_id" type="numeric" required="true" default="">
        
        <cfset response = structNew()>
        <cftry>
            <cfquery name = "q_delete_counter_type" datasource = "#dsn3#">
                DELETE FROM SETUP_COUNTER_TYPE WHERE COUNTER_TYPE_ID = <cfqueryparam value = "#arguments.ct_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfset response.message = "İşlem Başarılı">
            <cfset response.status = true>
            <cfset response.error = {}>
            <cfcatch type="any">
                <cfset response.message = "İşlem Hatalı">
                <cfset response.status = false>
                <cfset response.error = cfcatch>
            </cfcatch>
        </cftry>    
        <cfreturn response>
    </cffunction>
</cfcomponent>