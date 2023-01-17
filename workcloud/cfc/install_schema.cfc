<!---

    Author : Uğur Hamurpet
    Create Date : 14/03/2021
    Methods : {}

--->

<cfcomponent accessors="true" extends="parameter">

    <cfproperty  name="datasource" type="string">
    <cfproperty  name="schema_type" type="string">
    <cfproperty  name="object_type" type="string">

    <cfset mainPath = ReplaceNoCase('#Replace(GetDirectoryFromPath(GetBaseTemplatePath()),"\","/","ALL")#','workcloud/cfc/','','ALL') />
    <cfset wroPath = ReplaceNoCase('#Replace(GetDirectoryFromPath(GetBaseTemplatePath()),"\","/","ALL")#WRO','workcloud/cfc/','','ALL') />
    <cfset processPath = Replace(GetDirectoryFromPath(GetBaseTemplatePath()),"\","/","ALL") />

    <cffunction name="init" access="public">
        <cfargument  name="data" type="struct">

        <cfset setDatasource( this.getParameter().dsn ) />
        <cfset setSchema_type( arguments.data.schema_type ) />
        <cfset setObject_type( arguments.data.object_type ) />

        <cfreturn this>

    </cffunction>

    <cffunction name="removeDBSchema" access="public">
        <cfargument name="process_datasource" type="string" required="yes" />

        <cfset getParameter = this.getParameter() />

        <!--- remove table - view schema --->
        <cfquery name="getSchemaTables" datasource="_#getParameter.dsn#">
            SELECT  'DROP TABLE #arguments.process_datasource#.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13) AS DEL_TABLE
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = '#arguments.process_datasource#'
                AND TABLE_TYPE = 'BASE TABLE'
        </cfquery>
        
        <cfif getSchemaTables.recordcount>
            <cfquery name="delSchemaTables" datasource="_#getParameter.dsn#">
                <cfloop query="getSchemaTables">
                    #DEL_TABLE#
                </cfloop>
            </cfquery>
        </cfif>

        <cfquery name="getSchemaViews" datasource="_#getParameter.dsn#">
            SELECT  'DROP VIEW #arguments.process_datasource#.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13) AS DEL_TABLE
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = '#arguments.process_datasource#'
                AND TABLE_TYPE = 'VIEW'
        </cfquery>
        
        <cfif getSchemaViews.recordcount>
            <cfquery name="delSchemaViews" datasource="_#getParameter.dsn#">
                <cfloop query="getSchemaViews">
                    #DEL_TABLE#
                </cfloop>
            </cfquery>
        </cfif>
        <!--- remove table - view schema --->
        
        <!--- remove procedures - functions --->
        <cfquery name="getSchemaProcedures" datasource="_#getParameter.dsn#">
            SELECT  'DROP PROCEDURE #arguments.process_datasource#.' + QUOTENAME(ROUTINE_NAME) + ';' + CHAR(13) AS DEL_TABLE
            FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_SCHEMA = '#arguments.process_datasource#'
                AND ROUTINE_TYPE = 'PROCEDURE'
        </cfquery>
        
        <cfif getSchemaProcedures.recordcount>
            <cfquery name="delSchemaProcedures" datasource="_#getParameter.dsn#">
                <cfloop query="getSchemaProcedures">
                    #DEL_TABLE#
                </cfloop>
            </cfquery>
        </cfif>

        <cfquery name="getSchemaFunctions" datasource="_#getParameter.dsn#">
            SELECT  'DROP FUNCTION #arguments.process_datasource#.' + QUOTENAME(ROUTINE_NAME) + ';' + CHAR(13) AS DEL_TABLE
            FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_SCHEMA = '#arguments.process_datasource#'
                AND ROUTINE_TYPE = 'FUNCTION'
        </cfquery>
        
        <cfif getSchemaFunctions.recordcount>
            <cfquery name="delSchemaFunctions" datasource="_#getParameter.dsn#">
                <cfloop query="getSchemaFunctions">
                    #DEL_TABLE#
                </cfloop>
            </cfquery>
        </cfif>
        <!--- remove procedures - functions --->

        <!--- remove schema --->
        <cfquery name="getSchema" datasource="_#getParameter.dsn#">
            SELECT * FROM sys.schemas WHERE name = '#arguments.process_datasource#'
        </cfquery>
        <cfif getSchema.recordcount>
            <cfquery name="delSchema" datasource="_#getParameter.dsn#">
                DROP SCHEMA #arguments.process_datasource#
            </cfquery>
        </cfif>
        <!--- remove schema --->

    </cffunction>

    <cffunction name="removeDBUser" access="public">
        <cfargument name="process_datasource" type="string" required="yes" />

        <cfset getParameter = this.getParameter() />
        
        <!--- remove active login --->
        <cfquery name="getActiveLogin" datasource="_#getParameter.dsn#">
            SELECT spid FROM sys.sysprocesses where loginame = '#arguments.process_datasource#'
        </cfquery>

        <cfif getActiveLogin.recordcount>
            <cfquery name="killActiveLogin" datasource="_#getParameter.dsn#">
            kill #getActiveLogin.spid#
            </cfquery>
        </cfif>
        <!--- remove active login --->

        <!--- remove login --->
        <cfquery name="getLoginName" datasource="_#getParameter.dsn#">
            SELECT sid FROM sys.syslogins where loginname = '#arguments.process_datasource#'
        </cfquery>
        
        <cfif getLoginName.recordcount>
            <cfquery name="delUser" datasource="_#getParameter.dsn#">
                DROP USER #arguments.process_datasource#
            </cfquery>

            <cfquery name="delLogin" datasource="_#getParameter.dsn#">
                DROP LOGIN #arguments.process_datasource#
            </cfquery>
        </cfif>
        <!--- remove login --->

    </cffunction>

    <cffunction name="removeDB" access="public">
        
        <cfset getParameter = this.getParameter() />
        <cfscript>
            try {
                getDb = new Query(datasource = "master", sql = "SELECT name FROM master.dbo.sysdatabases WHERE ('[' + name + ']' = N'#getParameter.dsn#' OR name = N'#getParameter.dsn#')").execute().getResult();
                if( getDb.recordCount ){
                    new Query(datasource = "master", sql = "ALTER DATABASE #getParameter.dsn# SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE #getParameter.dsn#;").execute();    
                }
            }catch(any exp) {}
        </cfscript>
                
    </cffunction>

    <cffunction name = "controlSystem" returnType = "any" returnformat="JSON" access = "remote" hint = "Control System">
        <cfargument  name="db_type" type="string">
        <cfargument  name="server_detail" type="string">
        <cfargument  name="dsn" type="string">
        <cfargument  name="db_username" type="string">
        <cfargument  name="db_password" type="string">
        <cfargument  name="cf_admin_password" type="string">
        <cfargument  name="database_host" type="string">
        <cfargument  name="database_port" type="string">
        <cfargument  name="database_folder" type="string">
        <cfargument  name="database_log_folder" type="string">

        <cfset cf_admin_password = arguments.cf_admin_password />
        <cf_add_dsn_mssql dsn="master" db="master" host="#arguments.database_host#" port="#arguments.database_port#" username="#arguments.db_username#" password="#arguments.db_password#">        

        <cfscript>
        
            try {
                getDb = new Query(datasource = "master", sql = "SELECT name FROM master.dbo.sysdatabases WHERE ('[' + name + ']' = N'#arguments.dsn#' OR name = N'#arguments.dsn#')").execute().getResult();
                if( not getDb.recordCount ){
                    this.setParameter("db_type", arguments.db_type);
                    this.setParameter("server_detail", arguments.server_detail);
                    this.setParameter("dsn", arguments.dsn);
                    this.setParameter("db_username", arguments.db_username);
                    this.setParameter("db_password", arguments.db_password);
                    this.setParameter("cf_admin_password", arguments.cf_admin_password);
                    this.setParameter("database_host", arguments.database_host);
                    this.setParameter("database_port", arguments.database_port);
                    this.setParameter("database_folder", arguments.database_folder);
                    this.setParameter("database_log_folder", arguments.database_log_folder);
                    
                    fileWrite( "#mainPath#/dsn.txt", arguments.dsn );
                    
                    return this.returnResult( status: true );
                }else return this.returnResult( status: false, message: "There is already database with the same name on your server! Please remove database or change datasource name and try again!" );
            }
            catch(any exp) {
                return this.returnResult( status: false, errorMessage: exp );
            }
        
        </cfscript>

    </cffunction>

    <cffunction name = "createDatabase" returnType = "any" returnformat="JSON" access = "remote" hint = "Create Database">

        <cfset getParameter = this.getParameter() />

        <cfscript>
            response = structNew();

            try {
                attributes.datasource = getParameter.dsn;
                attributes.db_username = getParameter.db_username;
                attributes.db_password = getParameter.db_password;
                attributes.cf_admin_password = getParameter.cf_admin_password;
                attributes.db_host = getParameter.database_host;
                attributes.db_port = getParameter.database_port;
                attributes.db_folder = getParameter.database_folder;
                attributes.db_log_folder = getParameter.database_log_folder;
                cf_admin_password = getParameter.cf_admin_password;
                //Create Main DB
                include '../DB/create_main_db.cfm';
                //Create Main DB
                return this.returnResult( status: true );
            } catch (any exp) {
                this.removeDBSchema( process_datasource: getParameter.dsn ); ///remove db schemas
                this.removeDBUser( process_datasource: getParameter.dsn ); ///remove db users

                this.removeDBSchema( process_datasource: "#getParameter.dsn#_product" ); ///remove db schemas
                this.removeDBUser( process_datasource: "#getParameter.dsn#_product" ); ///remove db users
                this.removeDB(); ///remove db
                return this.returnResult( status: false, errorMessage: exp );
            }

        </cfscript>

    </cffunction>
    
    <cffunction name = "controlCompany" returnType = "any" returnformat="JSON" access = "remote" hint = "Control Company Schema and user">

        <cfset getParameter = this.getParameter() />

        <cftry>
            
            <cfquery name="addLogin" datasource="_#getParameter.dsn#">
                CREATE LOGIN  [#getParameter.dsn#_1] WITH PASSWORD = '#getParameter.db_password#' 
            </cfquery>

            <cfquery name="addSchema" datasource="#getParameter.dsn#">
                CREATE SCHEMA [#getParameter.dsn#_1]
            </cfquery>

            <cfquery name="addUser" datasource="#getParameter.dsn#">
                CREATE USER [#getParameter.dsn#_1] FOR LOGIN [#getParameter.dsn#_1] WITH DEFAULT_SCHEMA=[#getParameter.dsn#_1]
                ALTER ROLE [db_owner] ADD MEMBER [#getParameter.dsn#_1]
            </cfquery>

            <cfset cf_admin_password = getParameter.cf_admin_password />
            <cf_add_dsn_mssql dsn="#getParameter.dsn#_1" db="#getParameter.dsn#" host="#getParameter.database_host#" port="#getParameter.database_port#" username="#getParameter.dsn#_1" password="#getParameter.db_password#">   
            
            <cfreturn this.returnResult( status: true ) />
            <cfcatch type = "any">
                <cfset this.removeDBSchema( process_datasource: "#getParameter.dsn#_1" ) />
                <cfset this.removeDBUser( process_datasource: "#getParameter.dsn#_1" ) />
                <cfreturn this.returnResult( status: false, errorMessage: cfcatch ) />
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "controlPeriod" returnType = "any" returnformat="JSON" access = "remote" hint = "Control Period Schema and user">

        <cfset getParameter = this.getParameter() />

        <cftry>

            <cfset period_year = year(now()) />
            <cfset our_company_id = 1 />
            
            <cfquery name="addLogin" datasource="_#getParameter.dsn#">
                CREATE LOGIN [#getParameter.dsn#_#period_year#_#our_company_id#] WITH PASSWORD = '#getParameter.db_password#' 
            </cfquery>

            <cfquery name="addSchema" datasource="#getParameter.dsn#">
                CREATE SCHEMA [#getParameter.dsn#_#period_year#_#our_company_id#]
            </cfquery>

            <cfquery name="addUser" datasource="#getParameter.dsn#">
                CREATE USER [#getParameter.dsn#_#period_year#_#our_company_id#] FOR LOGIN [#getParameter.dsn#_#period_year#_#our_company_id#] WITH DEFAULT_SCHEMA=[#getParameter.dsn#_#period_year#_#our_company_id#]
                ALTER ROLE [db_owner] ADD MEMBER [#getParameter.dsn#_#period_year#_#our_company_id#]
            </cfquery>

            <cfset cf_admin_password = getParameter.cf_admin_password />
            <cf_add_dsn_mssql dsn="#getParameter.dsn#_#period_year#_#our_company_id#" db="#getParameter.dsn#" host="#getParameter.database_host#" port="#getParameter.database_port#" username="#getParameter.dsn#_#period_year#_#our_company_id#" password="#getParameter.db_password#">
            
            <cfreturn this.returnResult( status: true ) />
            <cfcatch type = "any">
                <cfset this.removeDBSchema( process_datasource: "#getParameter.dsn#_#period_year#_#our_company_id#" ) />
                <cfset this.removeDBUser( process_datasource: "#getParameter.dsn#_#period_year#_#our_company_id#" ) />
                <cfreturn this.returnResult( status: false, errorMessage: cfcatch ) />
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "createObject" returnType = "any" returnformat="JSON" access = "remote" hint = "Create Objects">
        
        <cfsetting requesttimeout="1000">
        <cfset this.init(arguments) />
        <cfreturn this.execute_script_buffer() />

    </cffunction>

    <cffunction name = "createLicense" returnType = "any" returnformat="JSON" access = "remote" hint="Create License">
        
        <cfset getParameter = this.getParameter() />

        <cftry>
            <cfquery name="ADD_LICENSE" datasource="#getParameter.dsn#">
                INSERT INTO 
                    WRK_LICENSE(
                        WORKCUBE_ID,
                        TEL,
                        EMAIL,
                        WORKCUBE_ID1,
                        LICENSE_TYPE,
                        RELEASE_NO,
                        RELEASE_DATE,
                        PATCH_NO,
                        PATCH_DATE,
                        PROJECT_ID,
                        GIT_URL,
                        GIT_DIR,
                        GIT_BRANCH,
                        COMPANY,
                        COMPANY_PARTNER,
                        GOOGLE_ANALYTICS_ID,
                        PARAMS
                    )
                    VALUES
                    (
                        <cfqueryparam value = "#getParameter.license_code?:''#" CFSQLType = "cf_sql_nvarchar">,
                        <cfqueryparam value = "+90 216 428 39 39" CFSQLType = "cf_sql_nvarchar">,
                        <cfqueryparam value = "info@workcube.com" CFSQLType = "cf_sql_nvarchar">,
                        <cfqueryparam value = "#getParameter.license_code?:''#" CFSQLType = "cf_sql_nvarchar">,
                        NULL,
                        <cfqueryparam value = "#getParameter.release_no?:''#" CFSQLType = "cf_sql_nvarchar">,
                        <cfqueryparam value = "#getParameter.release_date?:''#" CFSQLType = "cf_sql_timestamp">,
                        <cfqueryparam value = "#getParameter.patch_no?:''#" CFSQLType = "cf_sql_nvarchar" null="#len(getParameter.patch_no) ? 'no' : 'yes'#">,
                        <cfqueryparam value = "#getParameter.patch_date?:''#" CFSQLType = "cf_sql_timestamp" null="#len(getParameter.patch_date) ? 'no' : 'yes'#">,
                        <cfqueryparam value = "1" CFSQLType = "cf_sql_nvarchar">,
                        <cfqueryparam value = "#getParameter.git.git_url?:''#" CFSQLType = "cf_sql_nvarchar">,
                        <cfqueryparam value = "#getParameter.git.git_dir?:''#" CFSQLType = "cf_sql_nvarchar">,
                        <cfqueryparam value = "releases/#getParameter.release_no?:''#" CFSQLType = "cf_sql_nvarchar">,
                        NULL,
                        NULL,
                        NULL,
                        NULL
                    )
            </cfquery>
            <cfreturn this.returnResult( status: true ) />
            <cfcatch type = "any">
                <cfreturn this.returnResult( status: false, errorMessage: cfcatch ) />
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "updateParams" returnType = "any" returnformat="JSON" access = "remote" hint = "Update license params">
        <cfargument name="params" type="string"> 
        
        <cfset getParameter = this.getParameter() />
        
        <cftry>
            <cftransaction>
                <cfquery name="UPDATE_PARAMS" datasource="#getParameter.dsn#">
                    UPDATE WRK_LICENSE SET PARAMS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.params#">
                </cfquery>
                <cfquery name="UPDATE_PARAMS_COL" datasource="#getParameter.dsn#">
                    INSERT INTO WRK_SYSTEM_PARAMS(
                        WSP_DOMAIN,
                        RELEASE_NO, 
                        WSP_PARAM
                    )VALUES(
                        <cfqueryparam value="#cgi.server_name#">,
                        <cfqueryparam value="#getParameter.release_no#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.params#">
                    ) 
                </cfquery>
            </cftransaction>
            <cfreturn this.returnResult( status: true ) />
            <cfcatch type = "any">
                <cfreturn this.returnResult( status: false, errorMessage: cfcatch ) />
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "companyDefinitions" returnType = "any" returnformat="JSON" access = "remote" hint = "Create Company">
        <cfargument  name="nick_name" type="string">
        <cfargument  name="nick_name2" type="string">
        <cfargument  name="zone_name" type="string">
        <cfargument  name="branch_name" type="string">
        <cfargument  name="department_name" type="string">
        <cfargument  name="position_cat" type="string">
        <cfargument  name="title" type="string">

        <cfset attributes = arguments />
        <cfset getParameter = this.getParameter() />
        <cfset dsn = getParameter.dsn />

        <cftry>
            <cfinclude template = "../add_installation_5.cfm">
            <cfreturn this.returnResult( status: true ) />
            <cfcatch type = "any">
                <cfreturn this.returnResult( status: false, errorMessage: cfcatch ) />
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "periodDefinitions" returnType = "any" returnformat="JSON" access = "remote" hint = "Create Period">
        <cfset getParameter = this.getParameter() />
        <cfset dsn = getParameter.dsn />
        <cfset standart_process_other_money = getParameter.standart_process_other_money />
        <cfset standart_process_money = getParameter.standart_process_money />

        <cftry>
            <cfinclude template = "../add_installation_9.cfm">
            <cfreturn this.returnResult( status: true ) />
            <cfcatch type = "any">
                <cfreturn this.returnResult( status: false, errorMessage: cfcatch ) />
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "createPeriodExtraObject" returnType = "any" returnformat="JSON" access = "remote" hint = "Create Period Extra Object">
        <cfset getParameter = this.getParameter() />
        <cfset dsn = getParameter.dsn />
        <cfset company_dsn = "#getParameter.dsn#_1" />
        <cfset dsn_period = "#getParameter.dsn#_#Year(now())#_1" />
        <cfset period_year = Year(now()) />
        <cfset period_id = 1 />
        <cfset company_id = 1 />

        <cftry>
            <cfinclude template = "../add_installation_10.cfm">
            <cfreturn this.returnResult( status: true ) />
            <cfcatch type = "any">
                <cfreturn this.returnResult( status: false, errorMessage: cfcatch ) />
            </cfcatch>
        </cftry>

    </cffunction>

    <cfscript>
    
        public any function executeSql( queryContent, counter ) {
		
            try {
                
                if( LCase( schema_type ) eq 'main_product' ) dsn = getDatasource();
                else if( LCase( schema_type ) eq 'master' ) dsn = "master";
                else if( LCase( schema_type ) eq 'company' ) dsn = "#getDatasource()#_1";
                else if( LCase( schema_type ) eq 'period' ) dsn = "#getDatasource()#_#Year(now())#_1";

                queryContent = ReplaceNoCase( queryContent, "@_dsn_main_@", getDatasource(), "ALL" );
                queryContent = ReplaceNoCase( queryContent, "@_dsn_product_@","#getDatasource()#_product", "ALL" );
                queryContent = ReplaceNoCase( queryContent, "@_dsn_company_@","#getDatasource()#_1", "ALL" );
                queryContent = ReplaceNoCase( queryContent, "@_companyid_@","1", "ALL" );
                queryContent = ReplaceNoCase( queryContent, "@_dsn_period_@","#getDatasource()#_#Year(now())#_1", "ALL" );
                queryContent = ReplaceNoCase( queryContent, "@_periodid_@","1", "ALL" );

                openQueryTag = '<cfquery name="CREATE_MAIN_DB" datasource="#dsn#">';
                closeQueryTag = '</cfquery>';

                queryContent = replace(queryContent,'SET ANSI_NULLS ON GO SET QUOTED_IDENTIFIER ON GO','','all');
                queryContent = replace(queryContent,'ON [PRIMARY] GO','ON [PRIMARY]','all');
                queryContent = replace(queryContent,'CREATE TABLE','#closeQueryTag##openQueryTag# CREATE TABLE','all');
                queryContent = replace(queryContent,'CREATE TRIGGER','#closeQueryTag##openQueryTag# CREATE TRIGGER','all');
                queryContent = replace(queryContent,'CREATE PROCEDURE','#closeQueryTag##openQueryTag# CREATE PROCEDURE','all');
                queryContent = replace(queryContent,'CREATE VIEW','#closeQueryTag##openQueryTag# CREATE VIEW','all');
                queryContent = replace(queryContent,'CREATE FUNCTION','#closeQueryTag##openQueryTag# CREATE FUNCTION','all');
                queryContent = replace(queryContent,'BEGIN TRANSACTION','#closeQueryTag##openQueryTag# BEGIN TRANSACTION','all');
                queryContent = '#queryContent##closeQueryTag#';
                queryContent = '#replace(queryContent,'</cfquery>','','one')#';
                
                if(FileExists("#processPath#/queryText_#counter#.cfm")) FileDelete("#processPath#/queryText_#counter#.cfm");
                FileWrite("#processPath#/queryText_#counter#.cfm", queryContent, "utf-8");
                transaction{ include 'queryText_#counter#.cfm'; }
                FileDelete("#processPath#/queryText_#counter#.cfm");
                return { status: true, errorMessage: "" };
            }
            catch(any exp) {
                return { status: false, errorMessage: exp };
            }

        }

        public any function execute_script_buffer() returnformat="JSON" {
            
            dirPath = '#wroPath#/db_objects/#getSchema_type()#/#getObject_type()#';
            if( DirectoryExists( dirPath ) ){
                dirQuery = directoryList( dirPath, false, "query", "" );
                if( dirQuery.recordCount ){
                    for(i=1; i lte dirQuery.recordCount; i++){
                        if( len(dirQuery.size[i]) and dirQuery.size[i] gt 0 ){
                            queryContent = fileRead( '#dirPath#/#GetFileFromPath(dirQuery.Name[i])#', 'UTF-8' );
                            response = this.executeSql( queryContent, i ); 
                            if( !response.status ){
                                if(getSchema_type() eq "main_product") process_datasource = getDatasource();
                                else if( LCase( getSchema_type() ) eq 'company' ) process_datasource = "#getDatasource()#_1";
                                else if( LCase( getSchema_type() ) eq 'period' ) process_datasource = "#getDatasource()#_#Year(now())#_1";

                                if(isDefined("process_datasource")){
                                    this.removeDBSchema( process_datasource: process_datasource ); ///remove db schemas
                                    this.removeDBUser( process_datasource: process_datasource ); ///remove db users
                                    if(getSchema_type() eq "main_product"){
                                        this.removeDBSchema( process_datasource: "#getDatasource()#_product" ); ///remove db schemas
                                        this.removeDBUser( process_datasource: "#getDatasource()#_product" ); ///remove db users
                                        this.removeDB(); ///remove db
                                    }
                                }

                                return this.returnResult( status: response.status, errorMessage: response.errorMessage );
                            }
                        }
                    }
                }else return this.returnResult( status: true );
            }else return this.returnResult( status: false, message: "There is no object path!" );

            return this.returnResult( status: true );

        }

        public any function returnResult( boolean status, numeric fileid = 0, string fullFileName = "", string message = "", any errorMessage = "" ) returnformat = "JSON" {
            response = structNew();
            response = {
                status: status,
                fileid: fileid,
                fullFileName: fullFileName,
                fileName: GetFileFromPath(fullFileName),
                message: message,
                errorMessage: errorMessage
            };

            return Replace(SerializeJSON(response),"//","");
        }

    </cfscript>

</cfcomponent>