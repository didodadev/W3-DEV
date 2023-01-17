<!---
    File :          V16\objects2\content\cfc\content.cfc
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          14.01.2022
    Description :   CONTENT ile ilgili servisler burdan gelir.
--->
<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset session_base.period_is_integrated = 0>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
    </cfif> 
    <cffunction name="SET_PRIVACY" access="remote" returntype="string" returnFormat="json">
        <cfargument name="IS_APPROVE_ALL" default="1">
        <cfargument name="IS_APPROVE_CUSTOM" default="1">
        <cftry>  
            <cfquery name="insert_wrk_cookie" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    WRK_COOKIE (                  
                        WRK_COOKIE,
                        IS_PERSONAL,
                        IS_ANALYTIC,
                        IS_MARKETING,
                        IS_APPROVE_ALL,
                        IS_APPROVE_CUSTOM,
                        COKIE_DATE,
                        TIME_STAMP,
                        DOMAIN,
                        CGI_STRUCT
                    )
                VALUES
                	(   
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.personisation_switch#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analytic_switch#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.marketing_switch#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IS_APPROVE_ALL#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IS_APPROVE_CUSTOM#">,
                        <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
                        CURRENT_TIMESTAMP,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#">,
                        '#replace(serializeJSON(CGI),"//","")#'
                    )
            </cfquery>
            <cfquery name="get_wrk_cookie" datasource="#dsn#">
                SELECT
                    WRK_COOKIE_ID,
                    WRK_COOKIE,
                    IS_PERSONAL,
                    IS_ANALYTIC,
                    IS_MARKETING,
                    IS_APPROVE_ALL,
                    IS_APPROVE_CUSTOM,
                    COKIE_DATE,
                    DOMAIN,
                    CGI_STRUCT
                FROM
                    WRK_COOKIE
                WHERE
                    WRK_COOKIE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#query_result.identitycol#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = query_result.identitycol>
            <cfset result.data = this.returnData(replace(serializeJSON(get_wrk_cookie),"//",""))>
            <cfset result.SUCCESS_MESSAGE = "#application.functions.getLang('','Cookie ayarlarınız başarıyla kaydedildi.',64989)#">
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch >
                <cfset result.DANGER_MESSAGE = "#application.functions.getLang('','Opps! bir hata meydana geldi, hemen ilgileniyoruz daha sonra tekrar deneyin..',33469)#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>