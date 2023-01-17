<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'> 
    <cffunction name="ADD_ASSETCARE" access="remote" returntype="any" hint="Akaryakıt Şifreleri Kayıt">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cf_get_lang_set module_name="assetcare">
       <cftry>     
            <cfquery name="ADD_ASSETCARE" datasource="#dsn#"  result="my_result">
                INSERT INTO
                    ASSET_P_FUEL_PASSWORD
                    (
                        BRANCH_ID,
                        COMPANY_ID,
                        STATUS,
                        USER_CODE,
                        PASSWORD1,
                        PASSWORD2,
                        START_DATE,
                        FINISH_DATE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP,
                        CARD_NO
                    )
                    VALUES
                    (
                        <cfif isdefined("arguments.branch_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.status")>1<cfelse>0</cfif>,
                        <cfif isdefined("arguments.user_code") and len(arguments.user_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user_code#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.password1") and  len(arguments.password1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password1#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.password2") and len(arguments.password2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password2#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.start_date2") and len(arguments.start_date2)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date2#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.finish_date2") and len(arguments.finish_date2)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date2#"><cfelse>NULL</cfif>,
                        #now()#,
                        #session.ep.userid#,
                        '#cgi.remote_addr#',
                        <cfif isdefined("arguments.card_no") and len(arguments.card_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_no#"><cfelse>NULL</cfif>
                    )
            </cfquery>
            <cfquery name="GET_MAXID" datasource="#dsn#" maxrows="1">
                SELECT * FROM ASSET_P_FUEL_PASSWORD ORDER BY PASSWORD_ID DESC
            </cfquery>        
            <cfset attributes.is_upd = 0>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = GET_MAXID.PASSWORD_ID>
            <cfcatch>          
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>   
    </cffunction>
    <cffunction  name="UPD_FUEL_PASSWORD"  access="remote" returntype="any" hint="Akaryakıt Şifreleri Güncelleme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="UPD_FUEL_PASSWORD" datasource="#dsn#">
                UPDATE
                    ASSET_P_FUEL_PASSWORD
                SET
                    BRANCH_ID = <cfif len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                    STATUS = <cfif isdefined("arguments.status")>1<cfelse>0</cfif>,
                    USER_CODE = <cfif isdefined("arguments.user_code") and len(arguments.user_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user_code#"><cfelse>NULL</cfif>,
                    PASSWORD1 = <cfif isdefined("arguments.password1") and  len(arguments.password1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password1#"><cfelse>NULL</cfif>,
                    PASSWORD2 = <cfif isdefined("arguments.password2") and len(arguments.password2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password2#"><cfelse>NULL</cfif>,
                    START_DATE = <cfif isdefined("arguments.start_date2") and len(arguments.start_date2)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date2#"><cfelse>NULL</cfif>,
                    FINISH_DATE = <cfif isdefined("arguments.finish_date2") and len(arguments.finish_date2)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date2#"><cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_IP = '#cgi.remote_addr#',
                    CARD_NO = <cfif isdefined("arguments.card_no") and len(arguments.card_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_no#"><cfelse>NULL</cfif>
                WHERE
                    PASSWORD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.password_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = #arguments.password_id#>
            <cfcatch>          
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch> 
        </cftry> 
        <cfreturn responseStruct>             
    </cffunction>
    <cffunction  name="select"  access = "public">
        <cfargument name="password_id" default="">
        <cfquery name="GET_FUEL_PASSWORD" datasource="#DSN#">
            SELECT
                ASSET_P_FUEL_PASSWORD.PASSWORD_ID,
                ASSET_P_FUEL_PASSWORD.BRANCH_ID,
                ASSET_P_FUEL_PASSWORD.COMPANY_ID,   
                ASSET_P_FUEL_PASSWORD.STATUS,
                ASSET_P_FUEL_PASSWORD.USER_CODE,
                ASSET_P_FUEL_PASSWORD.PASSWORD1, 
                ASSET_P_FUEL_PASSWORD.PASSWORD2, 
                ASSET_P_FUEL_PASSWORD.START_DATE,  
                ASSET_P_FUEL_PASSWORD.FINISH_DATE,  
                ASSET_P_FUEL_PASSWORD.AUTHOR_NAME, 
                ASSET_P_FUEL_PASSWORD.AUTHOR_SURNAME,
                ASSET_P_FUEL_PASSWORD.MAIL,
                ASSET_P_FUEL_PASSWORD.TELCODE,
                ASSET_P_FUEL_PASSWORD.TEL,
                ASSET_P_FUEL_PASSWORD.FAX,
                ASSET_P_FUEL_PASSWORD.RECORD_DATE,
                ASSET_P_FUEL_PASSWORD.RECORD_EMP, 
                ASSET_P_FUEL_PASSWORD.RECORD_IP,
                ASSET_P_FUEL_PASSWORD.UPDATE_DATE,
                ASSET_P_FUEL_PASSWORD.UPDATE_EMP, 
                ASSET_P_FUEL_PASSWORD.UPDATE_IP,
                ASSET_P_FUEL_PASSWORD.CARD_NO,
                COMPANY.FULLNAME,
                BRANCH.BRANCH_NAME
            FROM
                ASSET_P_FUEL_PASSWORD,
                COMPANY,		
                BRANCH
            WHERE
                PASSWORD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.password_id#"> AND
                BRANCH.BRANCH_ID = ASSET_P_FUEL_PASSWORD.BRANCH_ID AND		
                COMPANY.COMPANY_ID = ASSET_P_FUEL_PASSWORD.COMPANY_ID
        </cfquery>               
        <cfreturn GET_FUEL_PASSWORD>
    </cffunction>
    <cffunction  name="get" access="public" returntype="any">
        <cfargument  name="password_id" default="">
         <cfreturn select(password_id=arguments.password_id)> 
    </cffunction>
</cfcomponent>
