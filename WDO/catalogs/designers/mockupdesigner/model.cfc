<cfcomponent>
    
    <cfproperty  name="mockup_info" type="struct">

    <cfset dsn = application.systemParam.systemParam().dsn />
    <cfset download_folder = application.systemParam.systemParam().download_folder />
    <cfset upload_folder = application.systemParam.systemParam().upload_folder />
    <cfset fileSystem = createObject("component","V16/asset/cfc/file_system") />

    <cffunction name="get" access="public">
        <cfargument name="keyword" default="">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrow" default="20">
        
        <cfquery name="query_get" datasource="#dsn#">
            
            WITH CTE1 AS(
                SELECT 
                    WM.*, 
                    EMP.EMPLOYEE_NAME,
                    EMP.EMPLOYEE_SURNAME,
                    PW.WORK_HEAD
                FROM WRK_MOCKUP AS WM
                LEFT JOIN EMPLOYEES AS EMP ON WM.MOCKUP_AUTHOR_ID = EMP.EMPLOYEE_ID
                LEFT JOIN PRO_WORKS AS PW ON WM.WORK_ID = PW.WORK_ID
                <cfif len(arguments.keyword)>
                WHERE MOCKUP_NAME LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.keyword#%'>
                </cfif>
            ),
            CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (	ORDER BY MOCKUP_ID DESC ) AS RowNum,
                    (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrow#-1)
        </cfquery>

        <cfreturn query_get>
    </cffunction>

    <cffunction name="getById" access="public">
        <cfargument name="id" type="numeric">

        <cfquery name="query_get" datasource="#dsn#">
            SELECT
                WM.*, 
                EMP.EMPLOYEE_NAME,
                EMP.EMPLOYEE_SURNAME,
                CASE
                    WHEN EMP.EMPLOYEE_NAME IS NOT NULL AND EMP.EMPLOYEE_SURNAME IS NOT NULL THEN CONCAT( EMP.EMPLOYEE_NAME, ' ', EMP.EMPLOYEE_SURNAME )
                    ELSE ''
                END EMPLOYEE_FULL_NAME,
                PW.WORK_HEAD
            FROM WRK_MOCKUP AS WM
            LEFT JOIN EMPLOYEES AS EMP ON WM.MOCKUP_AUTHOR_ID = EMP.EMPLOYEE_ID
            LEFT JOIN PRO_WORKS AS PW ON WM.WORK_ID = PW.WORK_ID 
            WHERE WM.MOCKUP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
        </cfquery>

        <cfreturn query_get>
    </cffunction>

    <cffunction name="getByWorkId" access="public">
        <cfargument name="work_id" type="numeric">

        <cfquery name="query_get" datasource="#dsn#">
            SELECT
                WM.*, 
                EMP.EMPLOYEE_NAME,
                EMP.EMPLOYEE_SURNAME,
                CASE
                    WHEN EMP.EMPLOYEE_NAME IS NOT NULL AND EMP.EMPLOYEE_SURNAME IS NOT NULL THEN CONCAT( EMP.EMPLOYEE_NAME, ' ', EMP.EMPLOYEE_SURNAME )
                    ELSE ''
                END EMPLOYEE_FULL_NAME,
                PW.WORK_HEAD
            FROM WRK_MOCKUP_WORK AS WMW
            JOIN WRK_MOCKUP AS WM ON WMW.MOCKUP_ID = WM.MOCKUP_ID
            JOIN PRO_WORKS AS PW ON WMW.WORK_ID = PW.WORK_ID
            LEFT JOIN EMPLOYEES AS EMP ON WM.MOCKUP_AUTHOR_ID = EMP.EMPLOYEE_ID
            WHERE WMW.WORK_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.work_id#'>
            ORDER BY MOCKUP_WORK_ID DESC
        </cfquery>

        <cfreturn query_get>
    </cffunction>

    <cffunction name="getByEvent" access="public">
        <cfargument name="id" type="numeric">
        <cfargument name="event" type="string">

        <cfquery name="query_get" datasource="#dsn#">
            SELECT MOCKUP_DESIGN, MOCKUP_MODEL FROM WRK_MOCKUP_ROW WHERE MOCKUP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'> AND MOCKUP_EVENT = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.event#'>
        </cfquery>

        <cfif query_get.recordcount>
            <cfif len(query_get.MOCKUP_DESIGN) and len(query_get.MOCKUP_MODEL)>
                <cfreturn { design: query_get.MOCKUP_DESIGN, model: query_get.MOCKUP_MODEL }>
            <cfelse>
                <cfreturn { design: "null", model: "null" }>
            </cfif>
        <cfelse>
            <cfreturn { design: "null", model: "null" }>
        </cfif>

    </cffunction>

    <cffunction name="save" access="remote" returntype="any" returnFormat="JSON">
        <cfargument name="mockup_id" type="any" default="">
        <cfargument name="mockup_name" type="string">
        <cfargument name="mockup_design" type="string">
        <cfargument name="mockup_author_id" type="any">
        <cfargument name="mockup_author_name" type="any">
        <cfargument name="work_id" type="any">
        <cfargument name="qpic_rs_id" type="any">

        <cfset response = structNew() />

        <cftransaction>
            
            <cftry>
                
                <cfif not len(arguments.mockup_id)>

                    <cfset unique_folder_name = createUUID() />
                    <cfset fileSystem.newFolder( "#upload_folder#", "mockup_designer" ) />
                    <cfset fileSystem.newFolder( "#upload_folder#/mockup_designer", "#unique_folder_name#" ) />

                    <cfquery name = "save_mockup" datasource = "#dsn#" result = "result">
                        INSERT INTO WRK_MOCKUP
                        (
                            MOCKUP_NAME
                            ,MOCKUP_FOLDER_NAME
                            ,MOCKUP_AUTHOR_ID
                            ,WORK_ID
                            ,QPIC_RS_ID
                            ,RECORD_EMP
                            ,RECORD_IP
                            ,RECORD_DATE
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.mockup_name#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#unique_folder_name#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mockup_author_id#' null='#not len(arguments.mockup_author_id) ? "yes" : "no"#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.work_id#' null='#not len(arguments.work_id) ? "yes" : "no"#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.qpic_rs_id#' null='#not len(arguments.qpic_rs_id) ? "yes" : "no"#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                            ,#now()#
                        )
                    </cfquery>

                    <cfif IsDefined("arguments.work_id") and len( arguments.work_id )>
                        <cfquery name = "save_mockup_work" datasource = "#dsn#">
                            INSERT INTO WRK_MOCKUP_WORK
                            (
                                MOCKUP_ID
                                ,WORK_ID
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#result.identitycol#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.work_id#'>
                            )
                        </cfquery>
                    </cfif>

                <cfelse>

                    <cfset get_mockup = this.getById( arguments.mockup_id ) />
                    <cfif get_mockup.recordcount>

                        <cfquery name = "update_mockup" datasource = "#dsn#">
                            UPDATE WRK_MOCKUP
                            SET
                                MOCKUP_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.mockup_name#'>,
                                MOCKUP_AUTHOR_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mockup_author_id#' null='#(not len(arguments.mockup_author_id) or not len(arguments.mockup_author_name)) ? "yes" : "no"#'>,
                                WORK_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.work_id#' null='#not len(arguments.work_id) ? "yes" : "no"#'>,
                                QPIC_RS_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.qpic_rs_id#' null='#not len(arguments.qpic_rs_id) ? "yes" : "no"#'>,
                                UPDATE_EMP = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>,
                                UPDATE_IP = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>,
                                UPDATE_DATE = #now()#
                            WHERE MOCKUP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mockup_id#'>
                        </cfquery>

                        <cfquery name = "delete_mockup_row" datasource = "#dsn#">
                            DELETE FROM WRK_MOCKUP_ROW WHERE MOCKUP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mockup_id#'>
                        </cfquery>

                        <cfset unique_folder_name = get_mockup.MOCKUP_FOLDER_NAME />
                        <cfset result = structNew() />
                        <cfset result.identitycol = arguments.mockup_id />

                    </cfif>

                </cfif>

                <cfscript>
                    modelStruct = deserializeJSON(arguments.mockup_design);
                    designbuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designbuilder").init(modelStruct);
                    designCode = designbuilder.generate();
                    /* writeDump(designCode)(designCode.dashLayout);
                    abort; */
                    saveandgeneratetodb( "add", replace(serializeJSON(modelStruct.layout.addLayout), "//", ""), replace(serializeJSON(modelStruct.domain), '//', ''), designCode.addLayout, iif( isDefined( "designDepends.addDependencies" ), 'replace(serializeJSON(designDepends.addDependencies), "//", "")', de("") ), unique_folder_name, result );
                    saveandgeneratetodb( "upd", replace(serializeJSON(modelStruct.layout.updLayout), "//", ""), replace(serializeJSON(modelStruct.domain), '//', ''), designCode.updateLayout, iif( isDefined( "designDepends.updDependencies" ), 'replace(serializeJSON(designDepends.updDependencies), "//", "")', de("") ), unique_folder_name, result );
                    saveandgeneratetodb( "det", replace(serializeJSON(modelStruct.layout.infoLayout), "//", ""), replace(serializeJSON(modelStruct.domain), '//', ''), designCode.infoLayout, iif( isDefined( "designDepends.updDependencies" ), 'replace(serializeJSON(designDepends.updDependencies), "//", "")', de("") ), unique_folder_name, result );
                    saveandgeneratetodb( "list", replace(serializeJSON(modelStruct.layout.listLayout), "//", ""), replace(serializeJSON(modelStruct.domain), '//', ''), designCode.tableLayout, iif( isDefined( "designDepends.listdependencies" ), 'replace(serializeJSON(designDepends.listDependencies), "//", "")', de("") ), unique_folder_name, result );
                    saveandgeneratetodb( "dashboard", replace(serializeJSON(modelStruct.layout.dashLayout), "//", ""), replace(serializeJSON(modelStruct.domain), '//', ''), designCode.dashLayout, iif( isDefined( "designDepends.dashdependencies" ), 'replace(serializeJSON(designDepends.dashDependencies), "//", "")', de("") ), unique_folder_name, result );
                    domain = modelStruct.domain;
                    toolboxIdx = arrayFind(domain, function(elm) { return elm.name eq "Toolbox"; });
                    arrayDeleteAt(domain, toolboxIdx);
                </cfscript>

                <cfset response = { status: true, message: (not len(arguments.mockup_id) ? "Mockup successfully created." : "Mockup successfully updated."), result: result } />

            <cfcatch type="any">
                <cfset response = { status: false, message: (not len(arguments.mockup_id) ? "An error occorred while creating mockup!" : "An error occorred while updating mockup!"), result: result } />
            </cfcatch>
            </cftry>

            <cfreturn LCase( Replace( serializeJSON( response ), "//", "" ) ) />

        </cftransaction>

    </cffunction>

    <!--- Save design model to db helper --->
    <cffunction name="saveandgeneratetodb" access="private" returntype="any">
        <cfargument name="mockup_event" type="string">
        <cfargument name="mockup_design" type="string">
        <cfargument name="mockup_model" type="string">
        <cfargument name="mockup_code" type="string">
        <cfargument name="mockup_dependencies" type="string">
        <cfargument name="mockup_folder_name" type="string">
        <cfargument name="result" type="struct">

        <!--- Önceden oluşturulan mockup dosyasını siler --->
        <cfset fileSystem.delete( "mockup_designer/#arguments.mockup_folder_name#/#arguments.mockup_event#.cfm" ) />

        <cfquery name = "save_mockup_row" datasource = "#dsn#">
            INSERT INTO WRK_MOCKUP_ROW
            (
                MOCKUP_ID
                ,MOCKUP_EVENT
                ,MOCKUP_DESIGN
                ,MOCKUP_MODEL
                ,MOCKUP_CODE
                ,MOCKUP_DEPENDENCIES
                ,RECORD_EMP
                ,RECORD_IP
                ,RECORD_DATE
            )
            VALUES
            (
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#result.identitycol#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.mockup_event#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.mockup_design#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.mockup_model#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.mockup_code#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.mockup_dependencies#' null='#not len(arguments.mockup_dependencies) ? "yes" : "no"#'>
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                ,#now()#
            )
        </cfquery>

        <!--- Yeni mockup dosyası oluşturur --->
        <cfset fileSystem.write( "#upload_folder#mockup_designer/#arguments.mockup_folder_name#/#arguments.mockup_event#.cfm", arguments.mockup_code, "utf-16" ) />

    </cffunction>

    <cffunction name="delete" access="remote" returntype="any" returnFormat="JSON">
        <cfargument name="mockup_id" type="numeric" required="true">

        <cfset response = structNew() />

        <cfset get_mockup = this.getById( arguments.mockup_id ) />
        <cfif get_mockup.recordcount>

            <cfquery name = "delete_mockup" datasource = "#dsn#">
                DELETE FROM WRK_MOCKUP WHERE MOCKUP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mockup_id#'>
                DELETE FROM WRK_MOCKUP_ROW WHERE MOCKUP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mockup_id#'>
            </cfquery>

            <!--- Mockup dosyalarını siler --->
            <cfset events = ["add","upd","det","list","dashboard"] />
            <cfloop array="#events#" item="item">
                <cfset fileSystem.delete( "mockup_designer/#get_mockup.MOCKUP_FOLDER_NAME#/#item#.cfm" ) />
            </cfloop>
            <cfset fileSystem.deleteFolder( "mockup_designer/#get_mockup.MOCKUP_FOLDER_NAME#" ) />

            <cfset response = { status: true, message: "Mockup successfully deleted." } />
        <cfelse>
            <cfset response = { status: false, message: "Mockup didn't find!" } />
        </cfif>

        <cfreturn LCase( Replace( serializeJSON( response ), "//", "" ) ) />

    </cffunction>

</cfcomponent>