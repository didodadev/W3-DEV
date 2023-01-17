<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn />

    <cffunction name = "get_license_information" returnType = "any" access = "public" hint = "SELECT WRK LICENSE INFORMATION">
        <cfargument  name="get_all" type="boolean" default="false">

        <cfquery name = "get_license_information" datasource = "#dsn#">
            SELECT 
            <cfif not arguments.get_all>TOP 1</cfif>
                LICENSE_ID
                ,WORKCUBE_ID
                ,OWNER_COMPANY_ID
                ,IMPLEMENTATION_PROJECT_ID
                ,IMPLEMENTATION_PROJECT_DOMAIN
                ,SUPPORT_PROJECT_DOMAIN
                ,PROJECT_ID AS SUPPORT_PROJECT_ID
                ,TECHNICAL_PERSON_ID
                ,TECHNICAL_PERSON_EMPLOYEE_ID
                ,IMPLEMENTATION_POWER_USER_ID
                ,IMPLEMENTATION_POWER_USER_EMPLOYEE_ID
                ,IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE
                ,WORKCUBE_PARTNER_COMPANY_ID
                ,WORKCUBE_PARTNER_COMPANY_TEAM_ID
                ,WORKCUBE_SUPPORT_TEAM_ID
                ,COMPANY_PARTNER AS WORKCUBE_PARTNER_COMPANY_TITLE
                ,WORKCUBE_PARTNER_COMPANY_TEAM
                ,TECHNICAL_PERSON_EMPLOYEE_TITLE
                ,COMPANY AS OWNER_COMPANY_TITLE
                ,EMAIL AS OWNER_COMPANY_EMAIL
                ,TEL AS OWNER_COMPANY_PHONE
                ,LICENSE_TYPE
                ,RELEASE_NO
                ,RELEASE_DATE
                ,PATCH_NO
                ,PATCH_DATE
                ,GIT_URL
                ,GIT_DIR
                ,GIT_BRANCH
                ,PARAMS
                ,MONO
                ,PROD
                ,IS_APPROVE
                ,APPROVED_DATE
                ,APPROVED_NAME_SURNAME
                ,RECORD_EMP
                ,RECORD_DATE
                ,RECORD_IP
                ,UPDATE_EMP
                ,UPDATE_DATE
                ,UPDATE_IP
            FROM WRK_LICENSE
            ORDER BY LICENSE_ID DESC
        </cfquery>

        <cfreturn get_license_information>

    </cffunction>

    <cffunction name = "save_license_information" returnType = "any" access = "public" hint = "UPDATE WRK LICENSE INFORMATION">
        <cfargument name="license_id" type="numeric" default="0">

        <cftry>
            
            <cfif arguments.license_id neq 0>
                <cfquery name = "update_license_information" datasource = "#dsn#" result="result">
                    UPDATE WRK_LICENSE SET
                    WORKCUBE_ID = <cfif len( arguments.workcube_id )><cfqueryparam value = "#arguments.workcube_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    OWNER_COMPANY_ID = <cfif len( arguments.owner_company_id )><cfqueryparam value = "#arguments.owner_company_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    IMPLEMENTATION_PROJECT_ID = <cfif len( arguments.implementetion_project_id )><cfqueryparam value = "#arguments.implementetion_project_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    IMPLEMENTATION_PROJECT_DOMAIN = <cfif len( arguments.implementetion_project_domain )><cfqueryparam value = "#arguments.implementetion_project_domain#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    PROJECT_ID = <cfif len( arguments.support_project_id )><cfqueryparam value = "#arguments.support_project_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    SUPPORT_PROJECT_DOMAIN = <cfif len( arguments.support_project_domain )><cfqueryparam value = "#arguments.support_project_domain#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    TECHNICAL_PERSON_ID = <cfif len( arguments.technical_persons_id )><cfqueryparam value = "#arguments.technical_persons_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    TECHNICAL_PERSON_EMPLOYEE_ID = <cfif len( arguments.technical_person_employee_id )><cfqueryparam value = "#arguments.technical_person_employee_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    TECHNICAL_PERSON_EMPLOYEE_TITLE = <cfif len( arguments.technical_person_employee_title )><cfqueryparam value = "#arguments.technical_person_employee_title#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    IMPLEMENTATION_POWER_USER_ID = <cfif len( arguments.implementation_power_user_id )><cfqueryparam value = "#arguments.implementation_power_user_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    IMPLEMENTATION_POWER_USER_EMPLOYEE_ID = <cfif len( arguments.implementation_power_user_employee_id )><cfqueryparam value = "#arguments.implementation_power_user_employee_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE = <cfif len( arguments.implementation_power_user_employee_title )><cfqueryparam value = "#arguments.implementation_power_user_employee_title#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    WORKCUBE_PARTNER_COMPANY_ID = <cfif len( arguments.workcube_partner_company_id )><cfqueryparam value = "#arguments.workcube_partner_company_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    WORKCUBE_PARTNER_COMPANY_TEAM_ID = <cfif len( arguments.workcube_partner_company_team_id )><cfqueryparam value = "#arguments.workcube_partner_company_team_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    WORKCUBE_PARTNER_COMPANY_TEAM = <cfif len( arguments.workcube_partner_company_team )><cfqueryparam value = "#arguments.workcube_partner_company_team#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    WORKCUBE_SUPPORT_TEAM_ID = <cfif len( arguments.workcube_support_team_id )><cfqueryparam value = "#arguments.workcube_support_team_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    COMPANY_PARTNER = <cfif len( arguments.workcube_partner_company_title )><cfqueryparam value = "#arguments.workcube_partner_company_title#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    COMPANY = <cfif len( arguments.owner_company_title )><cfqueryparam value = "#arguments.owner_company_title#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    EMAIL = <cfif len( arguments.owner_company_email )><cfqueryparam value = "#arguments.owner_company_email#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    TEL = <cfif len( arguments.owner_company_phone )><cfqueryparam value = "#arguments.owner_company_phone#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    LICENSE_TYPE = <cfif len( arguments.license_type )><cfqueryparam value = "#arguments.license_type#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #session.ep.userid#
                    WHERE LICENSE_ID = <cfqueryparam value = "#arguments.license_id#" CFSQLType = "cf_sql_integer">
                </cfquery>
            <cfelse>
                <cfquery name = "insert_license_information" datasource = "#dsn#" result="result">
                    INSERT INTO WRK_LICENSE(
                        WORKCUBE_ID,
                        OWNER_COMPANY_ID,
                        IMPLEMENTATION_PROJECT_ID,
                        IMPLEMENTATION_PROJECT_DOMAIN,
                        PROJECT_ID,
                        SUPPORT_PROJECT_DOMAIN,
                        TECHNICAL_PERSON_ID,
                        TECHNICAL_PERSON_EMPLOYEE_ID,
                        TECHNICAL_PERSON_EMPLOYEE_TITLE,
                        IMPLEMENTATION_POWER_USER_ID,
                        IMPLEMENTATION_POWER_USER_EMPLOYEE_ID,
                        IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE,
                        WORKCUBE_PARTNER_COMPANY_ID,
                        WORKCUBE_PARTNER_COMPANY_TEAM_ID,
                        WORKCUBE_PARTNER_COMPANY_TEAM,
                        WORKCUBE_SUPPORT_TEAM_ID,
                        COMPANY_PARTNER,
                        COMPANY,
                        EMAIL,
                        TEL,
                        LICENSE_TYPE,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                        
                    ) VALUES(
                        <cfif len( arguments.workcube_id )><cfqueryparam value = "#arguments.workcube_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.owner_company_id )><cfqueryparam value = "#arguments.owner_company_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif len( arguments.implementetion_project_id )><cfqueryparam value = "#arguments.implementetion_project_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                        <cfif len( arguments.implementetion_project_domain )><cfqueryparam value = "#arguments.implementetion_project_domain#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.support_project_id )><cfqueryparam value = "#arguments.support_project_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.support_project_domain )><cfqueryparam value = "#arguments.support_project_domain#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.technical_persons_id )><cfqueryparam value = "#arguments.technical_persons_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.technical_person_employee_id )><cfqueryparam value = "#arguments.technical_person_employee_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.technical_person_employee_title )><cfqueryparam value = "#arguments.technical_person_employee_title#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.implementation_power_user_id )><cfqueryparam value = "#arguments.implementation_power_user_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.implementation_power_user_employee_id )><cfqueryparam value = "#arguments.implementation_power_user_employee_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.implementation_power_user_employee_title )><cfqueryparam value = "#arguments.implementation_power_user_employee_title#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.workcube_partner_company_id )><cfqueryparam value = "#arguments.workcube_partner_company_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.workcube_partner_company_team_id )><cfqueryparam value = "#arguments.workcube_partner_company_team_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.workcube_partner_company_team )><cfqueryparam value = "#arguments.workcube_partner_company_team#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.workcube_support_team_id )><cfqueryparam value = "#arguments.workcube_support_team_id#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.workcube_partner_company_title )><cfqueryparam value = "#arguments.workcube_partner_company_title#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.owner_company_title )><cfqueryparam value = "#arguments.owner_company_title#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.owner_company_email )><cfqueryparam value = "#arguments.owner_company_email#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.owner_company_phone )><cfqueryparam value = "#arguments.owner_company_phone#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len( arguments.license_type )><cfqueryparam value = "#arguments.license_type#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                        #session.ep.userid#,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
                </cfquery>
            </cfif>

            <cfreturn { status : true, result : result } />

            <cfcatch type = "any">
                <cfreturn { status : false } />
            </cfcatch>

        </cftry>
    
    </cffunction>

    <cffunction name = "set_license_prod" returnType = "any" access = "public" hint = "UPDATE WRK LICENSE PROD">
        <cfargument name="license_id" type="numeric" required="true">
        <cfargument name="prod" type="string" required="true">

        <cftry>

            <cfquery name = "update_license_information" datasource = "#dsn#" result="result">
                UPDATE WRK_LICENSE SET PROD = <cfqueryparam value = "#arguments.prod#" CFSQLType = "cf_sql_nvarchar">
                WHERE LICENSE_ID = <cfqueryparam value = "#arguments.license_id#" CFSQLType = "cf_sql_integer">
            </cfquery>

            <cfreturn { status : true, result : result } />
        
            <cfcatch type = "any">
                <cfreturn { status : false } />
            </cfcatch>

        </cftry>

    </cffunction>

    <cffunction name = "save_approve_info" returnType = "any" access = "public" hint = "UPDATE WRK LICENSE APPROVE">

        <cftry>

            <cfquery name = "update_license_information" datasource = "#dsn#" result="result">
                UPDATE WRK_LICENSE SET 
                IS_APPROVE = 1,
                APPROVED_DATE = #now()#,
                APPROVED_NAME_SURNAME = '#session.ep.name# #session.ep.surname#'
            </cfquery>

            <cfreturn { status : true, result : result } />
        
            <cfcatch type = "any">
                <cfreturn { status : false } />
            </cfcatch>

        </cftry>

    </cffunction>

</cfcomponent>