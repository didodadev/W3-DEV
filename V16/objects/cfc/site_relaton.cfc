<!---
    Semih Akartuna
    Create : 230721
    Desc : Datagate ile kullanuılıyor, kurumsal üye çalışanlarını site erişimlerini açar kaptır
--->

<cfcomponent>
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cffunction name="upd_site_relation" access="public" returntype="any" hint="kurmsal üye çalışan site erişim ayaarlarını günceller">
        <cfset attributes = arguments>
        <cfset form = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="GET_DOMAINS" datasource="#DSN#">
                DELETE FROM 
                    COMPANY_CONSUMER_DOMAINS 
                WHERE
                <cfif isdefined("arguments.COMPANY_ID")>
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#">  
                <cfelseif isdefined("arguments.CONSUMER_ID")>
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CONSUMER_ID#">  
                <cfelse>
                    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">  
                </cfif>                  
            </cfquery>

            <cfloop index="i" from="1" to="#arguments.domains#">
                <cfif isDefined("arguments.site_#i#")>
                    <cfset site = evaluate("arguments.site_#i#")>
                    <cfset site_domain = evaluate("arguments.site_domain_#i#")>

                    <cfquery name="control_protein" datasource="#DSN#">
                        SELECT SITE_ID FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#site#">
                    </cfquery>

                    <cfquery name="ADD_" datasource="#DSN#">
                        INSERT INTO
                            COMPANY_CONSUMER_DOMAINS
                            (
                                <cfif isdefined("arguments.COMPANY_ID")>
                                    COMPANY_ID,
                                <cfelseif isdefined("arguments.CONSUMER_ID")>
                                    CONSUMER_ID,
                                <cfelse>
                                    PARTNER_ID,
                                </cfif>
                                MENU_ID,
                                <cfif control_protein.recordcount eq 0>
                                    SITE_DOMAIN,
                                </cfif>
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            VALUES
                            (
                                <cfif isdefined("arguments.company_id")>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                                <cfelseif isdefined("arguments.consumer_id")>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">,
                                <cfelse>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">,
                                </cfif>
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#site#">,
                                <cfif control_protein.recordcount eq 0>
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#site_domain#">,
                                </cfif>
                                #now()#,
                                #session.ep.userid#,
                                '#cgi.remote_addr#'
                            )
                    </cfquery>
                </cfif>
            </cfloop>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
            <cfcatch type="database">
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>    
        <cfreturn responseStruct>
    </cffunction>
</cfcomponent>