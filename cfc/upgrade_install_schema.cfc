<!---

    Author : Uğur Hamurpet
    Create Date : 26/02/2020
    Methods : {
        createMainProductSchema,
        createCompanySchema,
        createPeriodSchema
    }

--->

<cfcomponent extends ="V16.settings.cfc.params_settings">

    <cfset params = this.getDeserializedParams() /><!--- Json paramdan gelir --->
    <cfset get_params = application.systemParam.systemParam() /><!--- SystemParamdan gelir --->
    <cfset upload_folder = '#get_params.index_folder#admin_tools#get_params.dir_seperator#' />
    <cfset dsn = params.dsn />

    <cffunction name="removeDBSchema" access="public">
        <cfargument name="cf_admin_password" type="string" required="yes" />

        <cfset SchemaComparison = createObject("component", "Utility.schemaComparison") />
        <cfset getDatasources = SchemaComparison.getDatasources( cfpass : arguments.cf_admin_password ) />

        <cfloop list="#getDatasources#" index="dataSourceName">

            <cfif findNoCase( "#dsn#_compare", dataSourceName )>
                
                <!--- remove table - view schema --->
                <cfquery name="getSchemaTables" datasource="_#dsn#">
                    SELECT  'DROP TABLE #dataSourceName#.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13) AS DEL_TABLE
                    FROM INFORMATION_SCHEMA.TABLES
                    WHERE TABLE_SCHEMA = '#dataSourceName#'
                        AND TABLE_TYPE = 'BASE TABLE'
                </cfquery>
                
                <cfif getSchemaTables.recordcount>
                    <cfquery name="delSchemaTables" datasource="_#dsn#">
                        <cfloop query="getSchemaTables">
                            #DEL_TABLE#
                        </cfloop>
                    </cfquery>
                </cfif>

                <cfquery name="getSchemaViews" datasource="_#dsn#">
                    SELECT  'DROP VIEW #dataSourceName#.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13) AS DEL_TABLE
                    FROM INFORMATION_SCHEMA.TABLES
                    WHERE TABLE_SCHEMA = '#dataSourceName#'
                        AND TABLE_TYPE = 'VIEW'
                </cfquery>
                
                <cfif getSchemaViews.recordcount>
                    <cfquery name="delSchemaViews" datasource="_#dsn#">
                        <cfloop query="getSchemaViews">
                            #DEL_TABLE#
                        </cfloop>
                    </cfquery>
                </cfif>
                <!--- remove table - view schema --->
                
                <!--- remove procedures - functions --->
                <cfquery name="getSchemaProcedures" datasource="_#dsn#">
                    SELECT  'DROP PROCEDURE #dataSourceName#.' + QUOTENAME(ROUTINE_NAME) + ';' + CHAR(13) AS DEL_TABLE
                    FROM INFORMATION_SCHEMA.ROUTINES
                    WHERE ROUTINE_SCHEMA = '#dataSourceName#'
                        AND ROUTINE_TYPE = 'PROCEDURE'
                </cfquery>
                
                <cfif getSchemaProcedures.recordcount>
                    <cfquery name="delSchemaProcedures" datasource="_#dsn#">
                        <cfloop query="getSchemaProcedures">
                            #DEL_TABLE#
                        </cfloop>
                    </cfquery>
                </cfif>
        
                <cfquery name="getSchemaFunctions" datasource="_#dsn#">
                    SELECT  'DROP FUNCTION #dataSourceName#.' + QUOTENAME(ROUTINE_NAME) + ';' + CHAR(13) AS DEL_TABLE
                    FROM INFORMATION_SCHEMA.ROUTINES
                    WHERE ROUTINE_SCHEMA = '#dataSourceName#'
                        AND ROUTINE_TYPE = 'FUNCTION'
                </cfquery>
                
                <cfif getSchemaFunctions.recordcount>
                    <cfquery name="delSchemaFunctions" datasource="_#dsn#">
                        <cfloop query="getSchemaFunctions">
                            #DEL_TABLE#
                        </cfloop>
                    </cfquery>
                </cfif>
                <!--- remove procedures - functions --->

                <!--- remove schema --->
                <cfquery name="getSchema" datasource="_#dsn#">
                    SELECT * FROM sys.schemas WHERE name = '#dataSourceName#'
                </cfquery>
                <cfif getSchema.recordcount>
                    <cfquery name="delSchema" datasource="_#dsn#">
                        DROP SCHEMA #dataSourceName#
                    </cfquery>
                </cfif>
                <!--- remove schema --->

            </cfif>

        </cfloop>

    </cffunction>

    <cffunction name="removeDBUser" access="public">
        <cfargument name="cf_admin_password" type="string" required="yes" />

        <cfset SchemaComparison = createObject("component", "Utility.schemaComparison") />
        <cfset getDatasources = SchemaComparison.getDatasources( cfpass : arguments.cf_admin_password ) />
        
        <cfloop list="#getDatasources#" index="dataSourceName">

            <cfif findNoCase( "#dsn#_compare", dataSourceName )>

                <!--- remove active login --->
                <cfquery name="getActiveLogin" datasource="_#dsn#">
                    SELECT spid FROM sys.sysprocesses where loginame = '#dataSourceName#'
                </cfquery>

                <cfif getActiveLogin.recordcount>
                    <cfquery name="killActiveLogin" datasource="_#dsn#">
                    kill #getActiveLogin.spid#
                    </cfquery>
                </cfif>
                <!--- remove active login --->

                <!--- remove login --->
                <cfquery name="getLoginName" datasource="_#dsn#">
                    SELECT sid FROM sys.syslogins where loginname = '#dataSourceName#'
                </cfquery>
                
                <cfif getLoginName.recordcount>
                    <cfquery name="delUser" datasource="_#dsn#">
                        DROP USER #dataSourceName#
                    </cfquery>
    
                    <cfquery name="delLogin" datasource="_#dsn#">
                        DROP LOGIN #dataSourceName#
                    </cfquery>
                </cfif>
                <!--- remove login --->

            </cfif>
            
        </cfloop>
        
    </cffunction>

    <cffunction name = "createMainProductSchema" returnType = "any" returnformat="JSON" access = "remote" hint = "Create Main Schema">
        <cfargument name="datasource" type="string" required="yes" />
        <cfargument name="db_username" type="string" required="yes" />
        <cfargument name="db_password" type="string" required="yes" />
        <cfargument name="cf_admin_password" type="string" required="yes" />

        <cfscript>
            response = structNew();
            try {

                this.removeDBSchema( cf_admin_password : arguments.cf_admin_password ); ///remove compare db schemas
                this.removeDBUser( cf_admin_password : arguments.cf_admin_password ); ///remove compare db users

                try {
                    index_folder_ilk_ = '#get_params.download_folder#workcloud/' ;///SystemParamdan gelir
                    attributes.datasource = arguments.datasource;
                    attributes.db_username = arguments.db_username;
                    attributes.db_password = arguments.db_password;
                    attributes.cf_admin_password = arguments.cf_admin_password;
                    attributes.db_host = params.database_host;///Json paramdan gelir
                    attributes.db_port = params.database_port;///Json paramdan gelir
                    //Create Main Schema
                    include '../workcloud/DB/create_main_db.cfm';
                    include '../workcloud/DB/create_main_db_2.cfm';
                    //Create Main Schema
                    response.status = true;
                } catch (any ex) {
                    this.removeDBSchema( cf_admin_password : arguments.cf_admin_password ); ///remove compare db schemas
                    this.removeDBUser( cf_admin_password : arguments.cf_admin_password ); ///remove compare db users
                    response.status = false;
                    response.errorMessage = ex;
                }

            } catch (any exp) {
                response.status = false;
                response.errorMessage = exp;
            }
        </cfscript>

        <cfreturn Replace( SerializeJson(response), "//", "" ) />

    </cffunction>

    <cffunction name = "createCompanySchema" returnType = "any" returnformat="JSON" access = "remote" hint = "Create Company Schema">
        <cfargument name="datasource" type="string" required="yes" />
        <cfargument name="db_username" type="string" required="yes" />
        <cfargument name="db_password" type="string" required="yes" />
        <cfargument name="cf_admin_password" type="string" required="yes" />

        <cfset response = structNew() />     
        <cftry>
            <cfset dir_seperator = get_params.dir_seperator />
            <cf_add_company_db username="#arguments.db_username#" password="#arguments.db_password#" company_id="1" dsn="#arguments.datasource#" main_dsn="#dsn#" host="#params.database_host#" upload_folder="#upload_folder#">
            <cfset response.status = true />
            <cfcatch>
                <cfset this.removeDBSchema( cf_admin_password : arguments.cf_admin_password ) />
                <cfset this.removeDBUser( cf_admin_password : arguments.cf_admin_password ) />
                <cfset response.status = false />
                <cfset response.errorMessage = cfcatch />
            </cfcatch>
        </cftry>

        <cfreturn Replace( SerializeJson(response), "//", "" ) />

    </cffunction>

    <cffunction name = "createPeriodSchema" returnType = "any" returnformat="JSON" access = "remote" hint = "Create Period Schema">
        <cfargument name="datasource" type="string" required="yes" />
        <cfargument name="db_username" type="string" required="yes" />
        <cfargument name="db_password" type="string" required="yes" />
        <cfargument name="cf_admin_password" type="string" required="yes" />

        <cfset response = structNew() />
        <cftry>
            <cfset dir_seperator = get_params.dir_seperator />
            <cf_add_period_db username="#arguments.db_username#" is_old_account="0" password="#arguments.db_password#" period_id="1" dsn="#arguments.datasource#" main_dsn="#dsn#" host="#params.database_host#" upload_folder="#upload_folder#">
            <cfset response.status = true />
            <cfcatch>
                <cfset this.removeDBSchema( cf_admin_password : arguments.cf_admin_password ) />
                <cfset this.removeDBUser( cf_admin_password : arguments.cf_admin_password ) />
                <cfset response.status = false />
                <cfset response.errorMessage = cfcatch />
            </cfcatch>
        </cftry>

        <cfreturn Replace( SerializeJson(response), "//", "" ) />

    </cffunction>

</cfcomponent>