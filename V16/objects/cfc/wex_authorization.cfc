<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name = "insert" access = "public" hint = "INSERT AUTHORIZATION">
        <cfargument name="wex_id" default="">
        <cfargument name="subscription_id" default="">
        <cfargument name="counter_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="domain" default="">
        <cfargument name="ipNo" default="">
        <cfargument name="password" default="">
        <cfargument name="is_sms" default="">
        <cfset response = StructNew()>
        <cftry>
            <cfquery name = "ADD_WEX_AUTHORIZATION" datasource = "#dsn#" result="MAX_ID">
                INSERT INTO WRK_WEX_AUTHORIZATION
                (
                    WEX_ID,
                    SUBSCRIPTION_ID,
                    COUNTER_ID,
                    COMPANY_ID,
                    DOMAIN,
                    IP,
                    PASSWORD,
                    IS_SMS,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    <cfif len(arguments.wex_id)><cfqueryparam value = "#arguments.wex_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    <cfif len(arguments.subscription_id)><cfqueryparam value = "#arguments.subscription_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    <cfif len(arguments.counter_id)><cfqueryparam value = "#arguments.counter_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    <cfif len(arguments.company_id)><cfqueryparam value = "#arguments.company_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    <cfif len(arguments.domain)><cfqueryparam value = "#arguments.domain#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    <cfif len(arguments.ipNo)><cfqueryparam value = "#arguments.ipNo#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    <cfif len(arguments.password)><cfqueryparam value = "#arguments.password#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    <cfif len(arguments.is_sms)><cfqueryparam value = "#arguments.is_sms#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    #session.ep.userid#,
                    #now()#,
                    '#cgi.remote_addr#'
                )
            </cfquery>
            <cfset response.status = true>
            <cfset response.message = "Kayıt işlemi başarıyla gerçekleşti!">
            <cfset response.result = MAX_ID>
            <cfcatch type = "any">
                <cfset response.status = false>
                <cfset response.message = "Kayıt işlemi sırasında bir hata oluştu!">
            </cfcatch>
        </cftry>
        <cfreturn response> 
    </cffunction>

    <cffunction name = "select" returnType = "any">
        <cfargument name="wex_id" default="0">
        <cfargument name="auth_id" default="0">

        <cfquery name = "GET_WRK_WEX_AUTHORITIY" datasource = "#DSN#">
            SELECT
                WWAU.AUTH_ID,
                WWAU.WEX_ID,
                WWAU.DOMAIN,
                WWAU.IP,
                WWAU.PASSWORD,
                WWAU.IS_SMS,
                WWAU.RECORD_EMP,
                WWAU.RECORD_DATE,
                WWAU.RECORD_IP,
                WWAU.UPDATE_EMP,
                WWAU.UPDATE_DATE,
                WWAU.UPDATE_IP,
                SCT.SUBSCRIPTION_ID,
                SCT.SUBSCRIPTION_NO,
                SCT.SUBSCRIPTION_HEAD,
                SCT.COMPANY_ID,
                SCT.PARTNER_ID,
                SC.COUNTER_ID,
                SC.COUNTER_NO,
                WWAU.COMPANY_ID,
                CMP.FULLNAME
            FROM
                WRK_WEX_AUTHORIZATION AS WWAU
                JOIN WRK_WEX AS WX ON WWAU.WEX_ID = WX.WEX_ID
                LEFT JOIN COMPANY AS CMP ON CMP.COMPANY_ID = WWAU.COMPANY_ID
                JOIN SETUP_LANGUAGE_TR AS S1 ON WX.DICTIONARY_ID = S1.DICTIONARY_ID
                LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT AS SCT ON WWAU.SUBSCRIPTION_ID = SCT.SUBSCRIPTION_ID
                LEFT JOIN #dsn3#.SUBSCRIPTION_COUNTER AS SC ON WWAU.COUNTER_ID = SC.COUNTER_ID
            WHERE
                1 = 1
                <cfif arguments.wex_id neq 0>
                AND WX.WEX_ID = <cfqueryparam value = "#arguments.wex_id#" CFSQLType = "cf_sql_integer">
                </cfif>
                <cfif arguments.auth_id neq 0>
                AND WWAU.AUTH_ID = <cfqueryparam value = "#arguments.auth_id#" CFSQLType = "cf_sql_integer">
                </cfif>
        </cfquery>
        <cfreturn GET_WRK_WEX_AUTHORITIY>

    </cffunction>

    <cffunction name = "update" access = "public" hint = "UPDATE AUTHORIZATION">
        <cfargument name="auth_id" default="">
        <cfargument name="subscription_id" default="">
        <cfargument name="counter_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="domain" default="">
        <cfargument name="ipNo" default="">
        <cfargument name="password" default="">
        <cfargument name="is_sms" default="">
        <cfset response = StructNew()>
        <cftry>
            <cfquery name = "UPD_WEX_AUTHORIZATION" datasource = "#dsn#">
                UPDATE 
                    WRK_WEX_AUTHORIZATION
                SET
                    SUBSCRIPTION_ID = <cfif len(arguments.subscription_id)><cfqueryparam value = "#arguments.subscription_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    COUNTER_ID = <cfif len(arguments.counter_id)><cfqueryparam value = "#arguments.counter_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    COMPANY_ID = <cfif len(arguments.company_id)><cfqueryparam value = "#arguments.company_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    DOMAIN = <cfif len(arguments.domain)><cfqueryparam value = "#arguments.domain#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    IP = <cfif len(arguments.ipNo)><cfqueryparam value = "#arguments.ipNo#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    PASSWORD = <cfif len(arguments.password)><cfqueryparam value = "#arguments.password#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    IS_SMS = <cfif len(arguments.is_sms)><cfqueryparam value = "#arguments.is_sms#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    RECORD_EMP = #session.ep.userid#,
                    RECORD_DATE = #now()#,
                    RECORD_IP ='#cgi.remote_addr#'
                WHERE 
                    AUTH_ID = <cfqueryparam value = "#arguments.auth_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfset response.status = true>
            <cfset response.message = "Güncelleme işlemi başarıyla gerçekleşti!">
            <cfcatch type = "any">
                <cfset response.status = false>
                <cfset response.message = "Güncelleme işlemi sırasında bir hata oluştu!">
            </cfcatch>
        </cftry>
        <cfreturn response> 
    </cffunction>

    <cffunction name = "delete" access = "public" hint = "DELETE AUTHORIZATION">
        <cftry>
            <cfquery name = "DELETE_WEX_AUTHORIZATION" datasource = "#dsn#">
                DELETE FROM WRK_WEX_AUTHORIZATION WHERE AUTH_ID = <cfqueryparam value = "#arguments.auth_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfset response.status = true>
            <cfset response.message = "Silme işlemi başarıyla gerçekleşti!">
            <cfcatch type = "any">
                <cfset response.status = false>
                <cfset response.message = "Silme işlemi sırasında bir hata oluştu!">
            </cfcatch>
        </cftry>
        <cfreturn response> 
    </cffunction>

</cfcomponent>