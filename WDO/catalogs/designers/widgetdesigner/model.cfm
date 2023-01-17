<cfparam name="attributes.version" default="default">

<!--- Load domain model for designer --->
<cffunction name="loadModel" access="public" returntype="any">
    <cfquery name="modelquery" result="modelresult" datasource="#dsn#">
        SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.fuseact#">
    </cfquery>
    <cfif modelresult.recordcount>
        <cfif len(modelquery.MODELJSON)>
            <cfreturn modelquery.MODELJSON>
        <cfelse>
            <cfreturn '[]'>
        </cfif>
    <cfelse>
        <cfreturn '[]'>
    </cfif>
</cffunction>

<!--- Load widget design model --->
<cffunction name="loadDesign" access="public" returntype="any">
    <cfargument name="event" type="string">
    <cfquery name="modelquery" result="modelresult" datasource="#dsn#">
        SELECT WIDGET_STRUCTURE FROM WRK_WIDGET WHERE WIDGET_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.fuseact#"> AND [WIDGET_EVENT_TYPE] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.event#"> AND [WIDGET_VERSION] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.version#">
    </cfquery>
    <cfif modelresult.recordcount>
        <cfif len(modelquery.WIDGET_STRUCTURE)>
            <cfreturn modelquery.WIDGET_STRUCTURE>
        <cfelse>
            <cfreturn "null">
        </cfif>
    <cfelse>
        <cfreturn "null">
    </cfif>
</cffunction>

<!--- Check widget have event --->
<cffunction name="haveEvent" access="public">
    <cfargument name="event" type="string">
    <cfquery name="eventquery" datasource="#dsn#">
        SELECT count(*) as CNT FROM WRK_WIDGET WHERE WIDGET_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.fuseact#"> AND [WIDGET_EVENT_TYPE] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.event#"> AND [WIDGET_VERSION] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.version#">
    </cfquery>
    <cfreturn eventquery.CNT>
</cffunction>

<!--- Generate preview codes --->
<cffunction name="preview" access="public" returntype="any">
    <cfargument name="model" type="string">
    <cfscript>
        modelStruct = deserializeJSON(model);
        designbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designbuilder").init(modelStruct);
        code = designbuilder.generate();
        resultJson = replace( serializeJSON(code), "//", "" );
    </cfscript>
    <cfreturn resultJson>
</cffunction>

<cffunction name="save" access="public" returntype="any">
    <cfargument name="model" type="string">
    <cfargument name="event" type="string">
    
    <cfset response = structNew() />

    <cftransaction>
        <cftry>
            <cfscript>
                modelStruct = deserializeJSON(model);
                if( arguments.event eq 'add' ) savetodb("add", replace(serializeJSON(modelStruct.layout.addLayout), "//", ""));
                else if( arguments.event eq 'upd' ) savetodb("upd", replace(serializeJSON(modelStruct.layout.updLayout), "//", ""));
                else if( arguments.event eq 'list' ) savetodb("list", replace(serializeJSON(modelStruct.layout.listLayout), "//", ""));
                else if( arguments.event eq 'dashboard' ) savetodb("dashboard", replace(serializeJSON(modelStruct.layout.dashLayout), "//", ""));
                domain = modelStruct.domain;
                toolboxIdx = arrayFind(domain, function(elm) { return elm.name eq "Toolbox"; });
                arrayDeleteAt(domain, toolboxIdx);
                modeltodb(domain);
            </cfscript>
            <cfset response = { status: true, message: "Widget successfully created." } />
        <cfcatch type="any">
            <cfset response = { status: false, message: "An error occorred while creating widget!" } />
        </cfcatch>
        </cftry>
    </cftransaction>

    <cfreturn LCase( Replace( serializeJSON( response ), "//", "" ) ) />

</cffunction>

<cffunction name="savetodb" access="private" returntype="any">
    <cfargument name="event" type="string">
    <cfargument name="struct" type="string">

    <cfquery name="model_query" datasource="#dsn#">
        UPDATE [WRK_WIDGET]
        SET [WIDGET_STRUCTURE] = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.struct#'>
        WHERE
            WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.fuseact#'> 
            AND [WIDGET_EVENT_TYPE] = <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.event#"> 
            AND [WIDGET_VERSION] = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.version#'>
    </cfquery>
</cffunction>

<!--- Save design model --->
<cffunction name="saveandgenerate" access="public" returntype="any">
    <cfargument name="model" type="string">
    <cfargument name="event" type="string">
    
    <cfset response = structNew() />

    <cftransaction>
        <cftry>
            <cfscript>
                modelStruct = deserializeJSON(model);
                designbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designbuilder").init(modelStruct);
                designCode = designbuilder.generate();
                designDepends = designbuilder.dependencies;
                if( arguments.event eq 'add' ) saveandgeneratetodb("add", replace(serializeJSON(modelStruct.layout.addLayout), "//", ""), designCode.addLayout, iif( isDefined( "designDepends.addDependencies" ), 'replace(serializeJSON(designDepends.addDependencies), "//", "")', de("") ) );
                else if( arguments.event eq 'upd' ) saveandgeneratetodb("upd", replace(serializeJSON(modelStruct.layout.updLayout), "//", ""), designCode.updateLayout, iif( isDefined( "designDepends.updDependencies" ), 'replace(serializeJSON(designDepends.updDependencies), "//", "")', de("") ) );
                else if( arguments.event eq 'list' ) saveandgeneratetodb("list", replace(serializeJSON(modelStruct.layout.listLayout), "//", ""), designCode.tableLayout, iif( isDefined( "designDepends.listdependencies" ), 'replace(serializeJSON(designDepends.listDependencies), "//", "")', de("") ) );
                else if( arguments.event eq 'dashboard' ) saveandgeneratetodb("dashboard", replace(serializeJSON(modelStruct.layout.dashLayout), "//", ""), designCode.dashLayout, iif( isDefined( "designDepends.dashdependencies" ), 'replace(serializeJSON(designDepends.dashDependencies), "//", "")', de("") ));
                domain = modelStruct.domain;
                toolboxIdx = arrayFind(domain, function(elm) { return elm.name eq "Toolbox"; });
                arrayDeleteAt(domain, toolboxIdx);
                modeltodb(domain);
            </cfscript>
            <cfset response = { status: true, message: "Widget successfully generated." } />
        <cfcatch type="any">
            <cfset response = { status: false, message: "An error occorred while generating widget!" } />
        </cfcatch>
        </cftry>
    </cftransaction>

    <cfreturn LCase( Replace( serializeJSON( response ), "//", "" ) ) />
        
</cffunction>

<!--- Save design model to db helper --->
<cffunction name="saveandgeneratetodb" access="private" returntype="any">
    <cfargument name="event" type="string">
    <cfargument name="struct" type="string">
    <cfargument name="code" type="string">
    <cfargument name="depends" type="string">

    <cfquery name="wrkquery" datasource="#dsn#">
        UPDATE [WRK_WIDGET]
        SET  [WIDGET_STRUCTURE] = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.struct#'>
            ,[WIDGET_CODE] = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.code#'>
            ,[WIDGET_DEPENDS] = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.depends#'>
        WHERE 
            WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.fuseact#'> 
            AND [WIDGET_EVENT_TYPE] = <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.event#"> 
            AND [WIDGET_VERSION] = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.version#'>
    </cfquery>
</cffunction>

<!--- Save form to db --->
<cffunction name="formtodb" access="remote" returntype="any">
    <cfargument name="widgetid" default="">
    <cfargument name="fuseaction" type="string" default="">
    <cfargument name="title" type="string">
    <cfargument name="dictionary_id" type="string">
    <cfargument name="friendlyName" type="string">
    <cfargument name="version" type="string">
    <cfargument name="main_version" type="string">
    <cfargument name="structure" type="string" default="">
    <cfargument name="code" type="string" default="">
    <cfargument name="status" type="string">
    <cfargument name="stage" type="string" default="0">
    <cfargument name="tool" type="string">
    <cfargument name="file_path" type="string">
    <cfargument name="solutionid" type="integer">
    <cfargument name="solution" type="string">
    <cfargument name="familyid" type="integer">
    <cfargument name="family" type="string">
    <cfargument name="moduleno" type="integer">
    <cfargument name="module" type="string">
    <cfargument name="license" type="string">
    <cfargument name="author" type="string">
    <cfargument name="description" type="string">
    <cfargument name="widget_type" type="integer">
    <cfargument name="events" type="string">
    <cfargument name="is_public" type="any">
    <cfargument name="is_employee" type="any">
    <cfargument name="is_company" type="any">
    <cfargument name="is_consumer" type="any">
    <cfargument name="is_livestock" type="any">
    <cfargument name="is_machines" type="any">
    <cfargument name="is_employee_app" type="any">
    <cfargument name="is_template_widget" type="any">
    <cfargument name="xml_path" type="string">
    
    <cftry>
        <cftransaction>
                <cfif not len(arguments.widgetid)>
                    <cfquery datasource="#dsn#" result="result">
                        INSERT INTO WRK_WIDGET (
                            WIDGET_FUSEACTION,
                            WIDGET_TITLE,
                            WIDGET_TITLE_DICTIONARY_ID,
                            WIDGET_FRIENDLY_NAME,
                            WIDGET_EVENT_TYPE,
                            WIDGET_VERSION,
                            MAIN_VERSION,
                            WIDGET_STATUS,
                            WIDGET_STAGE,
                            WIDGET_TOOL,
                            <cfif isDefined("arguments.file_path")>
                            WIDGET_FILE_PATH,
                            </cfif>
                            WIDGETSOLUTIONID,
                            WIDGETSOLUTION,
                            WIDGETFAMILYID,
                            WIDGETFAMILY,
                            WIDGETMODULEID,
                            WIDGETMODULENO,
                            WIDGETMODULE,
                            WIDGET_LICENSE,
                            WIDGET_AUTHOR,
                            WIDGET_DESCRIPTION,
                            WIDGET_TYPE,
                            RECORD_IP,
                            RECORD_EMP,
                            RECORD_DATE,
                            IS_PUBLIC,
                            IS_EMPLOYEE,
                            IS_CONSUMER,
                            IS_COMPANY,
                            IS_EMPLOYEE_APP,
                            IS_LIVESTOCK,
                            IS_MACHINES,
                            IS_TEMPLATE_WIDGET,
                            XML_PATH
                        ) VALUES (
                            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.dictionary_id#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.friendlyName#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.events#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.version#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.main_version#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.status#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stage#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.tool#'>
                            <cfif isDefined("arguments.file_path")>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
                            </cfif>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.solution#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.family#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleno#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleno#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.module#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.description#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.widget_type#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                            ,#now()#
                            ,<cfif isdefined("arguments.is_public") and len(arguments.is_public)>1<cfelse>0</cfif>
                            ,<cfif isdefined("arguments.is_employee") and len(arguments.is_employee)>1<cfelse>0</cfif>
                            ,<cfif isdefined("arguments.is_consumer") and len(arguments.is_consumer)>1<cfelse>0</cfif>
                            ,<cfif isdefined("arguments.is_company") and len(arguments.is_company)>1<cfelse>0</cfif>
                            ,<cfif isdefined("arguments.is_employee_app") and len(arguments.is_employee_app)>1<cfelse>0</cfif>
                            ,<cfif isdefined("arguments.is_livestock") and len(arguments.is_livestock)>1<cfelse>0</cfif>
                            ,<cfif isdefined("arguments.is_machines") and len(arguments.is_machines)>1<cfelse>0</cfif>
                            ,<cfif isdefined("arguments.is_template_widget") and len(arguments.is_template_widget)>1<cfelse>0</cfif>
                            ,<cfif isdefined("arguments.xml_path") and len(arguments.xml_path)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.xml_path#'><cfelse>NULL</cfif>
                        )
                    </cfquery>
                    <cfset response = result.IDENTITYCOL>
                <cfelse>
                    <cfquery datasource="#dsn#">
                        UPDATE WRK_WIDGET SET
                        WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                        ,WIDGET_TITLE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                        ,WIDGET_TITLE_DICTIONARY_ID = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.dictionary_id#'>
                        ,WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.friendlyName#'>
                        ,WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.events#'>
                        ,WIDGET_VERSION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.version#'>
                        ,MAIN_VERSION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.main_version#'>
                        ,WIDGET_STATUS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.status#'>
                        ,WIDGET_STAGE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stage#'>
                        <cfif isDefined("arguments.file_path") and len(arguments.file_path)>
                        ,WIDGET_FILE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
                        </cfif>
                        ,WIDGETSOLUTIONID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
                        ,WIDGETSOLUTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.solution#'>
                        ,WIDGETFAMILYID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
                        ,WIDGETFAMILY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.family#'>
                        ,WIDGETMODULEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleno#'>
                        ,WIDGETMODULENO = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleno#'>
                        ,WIDGETMODULE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.module#'>
                        ,WIDGET_LICENSE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
                        ,WIDGET_AUTHOR = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
                        ,WIDGET_DESCRIPTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.description#'>
                        ,WIDGET_TYPE=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.widget_type#'>
                        ,UPDATE_IP = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                        ,UPDATE_EMP = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                        ,UPDATE_DATE = #now()#
                        ,IS_PUBLIC = <cfif isDefined("arguments.is_public") and Len(arguments.is_public)>1<cfelse>0</cfif>
                        ,IS_EMPLOYEE = <cfif isDefined("arguments.is_employee") and Len(arguments.is_employee)>1<cfelse>0</cfif>
                        ,IS_CONSUMER = <cfif isDefined("arguments.is_consumer") and Len(arguments.is_consumer)>1<cfelse>0</cfif>
                        ,IS_COMPANY = <cfif isDefined("arguments.is_company") and Len(arguments.is_company)>1<cfelse>0</cfif>
                        ,IS_LIVESTOCK = <cfif isDefined("arguments.is_livestock") and Len(arguments.is_livestock)>1<cfelse>0</cfif>
                        ,IS_MACHINES = <cfif isDefined("arguments.is_machines") and Len(arguments.is_machines)>1<cfelse>0</cfif>
                        ,IS_EMPLOYEE_APP = <cfif isDefined("arguments.is_employee_app") and Len(arguments.is_employee_app)>1<cfelse>0</cfif>
                        ,IS_TEMPLATE_WIDGET = <cfif isDefined("arguments.is_template_widget") and Len(arguments.is_template_widget)>1<cfelse>0</cfif>
                        ,XML_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.xml_path#'>
                    WHERE WIDGETID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.widgetid#'>
                    </cfquery>
                    <cfset response = arguments.widgetid>
                </cfif>
        </cftransaction>
        <cfcatch>
            <cfset response = -1>
        </cfcatch>
    </cftry>
    <cfreturn response>
</cffunction>
    
<!--- Get form from db --->
<cffunction name="loadform" access="public" returntype="query">
    <cfargument name="id" type="any">
    <cfquery name="form_query" datasource="#dsn#">
            <!---
                SELECT WIDGETS.[WIDGET_FUSEACTION], WIDGETS.[WIDGET_TITLE], WIDGETS.[WIDGET_VERSION], WIDGETS.[RECORD_DATE], WIDGETS.[RECORD_IP], WIDGETS.[RECORD_EMP], WIDGETS.[UPDATE_IP], WIDGETS.[UPDATE_DATE], WIDGETS.[UPDATE_EMP], WIDGETS.[WIDGET_STATUS], ISNULL(WIDGETS.[WIDGET_STAGE],0) AS WIDGET_STAGE, WIDGETS.[WIDGET_TOOL], WIDGETS.[WIDGETSOLUTIONID], WIDGETS.[WIDGETSOLUTION], WIDGETS.[WIDGETFAMILYID], WIDGETS.[WIDGETFAMILY], WIDGETS.[WIDGETMODULEID], WIDGETS.[WIDGETMODULE], WIDGETS.[WIDGET_DESCRIPTION], WIDGETS.[WIDGET_LICENSE], WIDGETS.[WIDGET_AUTHOR], ISNULL((SELECT TOP 1 WIDGETID FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'add' ), 0) AS ADD_ID, ISNULL((SELECT TOP 1 WIDGETID FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'upd' ), 0) AS UPDATE_ID, ISNULL((SELECT TOP 1 WIDGETID FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'list' ), 0) AS LIST_ID, ISNULL((SELECT TOP 1 WIDGETID FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'dashboard' ), 0) AS DASHBOARD_ID, ISNULL((SELECT TOP 1 WIDGETID FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'info' ), 0) AS INFO_ID, ISNULL(( SELECT TOP 1 WIDGET_FILE_PATH FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'add' ), '') AS ADD_PATH, ISNULL(( SELECT TOP 1 WIDGET_FILE_PATH FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'upd' ), '') AS UPDATE_PATH, ISNULL(( SELECT TOP 1 WIDGET_FILE_PATH FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'list' ), '') AS LIST_PATH, ISNULL(( SELECT TOP 1 WIDGET_FILE_PATH FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'dashboard' ), '') AS DASHBOARD_PATH, ISNULL(( SELECT TOP 1 WIDGET_FILE_PATH FROM [WRK_WIDGET] WHERE [WIDGET_FUSEACTION] = WIDGETS.WIDGET_FUSEACTION AND [WIDGET_VERSION] = WIDGETS.[WIDGET_VERSION] AND [WIDGET_TOOL] = WIDGETS.[WIDGET_TOOL] AND [WIDGETSOLUTIONID] = WIDGETS.[WIDGETSOLUTIONID] AND [WIDGETFAMILYID] = WIDGETS.[WIDGETFAMILYID] AND [WIDGETMODULEID] = WIDGETS.[WIDGETMODULEID] AND [WIDGET_LICENSE] = WIDGETS.[WIDGET_LICENSE] AND [WIDGET_TITLE] = WIDGETS.[WIDGET_TITLE] AND [WIDGET_EVENT_TYPE] = 'info' ), '') AS INFO_PATH FROM [WRK_WIDGET] WIDGETS INNER JOIN WRK_WIDGET TOUTER ON WIDGETS.WIDGET_FUSEACTION = TOUTER.WIDGET_FUSEACTION AND WIDGETS.WIDGET_VERSION = TOUTER.WIDGET_VERSION AND WIDGETS.WIDGET_TOOL = TOUTER.WIDGET_TOOL AND WIDGETS.WIDGETSOLUTIONID = TOUTER.WIDGETSOLUTIONID AND WIDGETS.WIDGETFAMILYID = TOUTER.WIDGETFAMILYID AND WIDGETS.WIDGETMODULEID = TOUTER.WIDGETMODULEID AND <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'> = TOUTER.WIDGETID GROUP BY WIDGETS.[WIDGET_FUSEACTION], WIDGETS.[WIDGET_TITLE], WIDGETS.[WIDGET_VERSION], WIDGETS.[WIDGET_STATUS], WIDGETS.[WIDGET_STAGE], WIDGETS.[WIDGET_TOOL], WIDGETS.[WIDGETSOLUTIONID], WIDGETS.[WIDGETSOLUTION], WIDGETS.[WIDGETFAMILYID], WIDGETS.[WIDGETFAMILY], WIDGETS.[WIDGETMODULEID], WIDGETS.[WIDGETMODULE], WIDGETS.[WIDGET_DESCRIPTION], WIDGETS.[WIDGET_LICENSE], WIDGETS.[RECORD_IP], WIDGETS.[RECORD_EMP], WIDGETS.[RECORD_DATE], WIDGETS.[UPDATE_IP], WIDGETS.[UPDATE_EMP], WIDGETS.[UPDATE_DATE], WIDGETS.[WIDGET_AUTHOR]
            --->
        SELECT * FROM WRK_WIDGET WHERE WIDGETID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfreturn form_query>
</cffunction>

<!--- Save domain model to db --->
<cffunction name="modeltodb" access="private" returntype="any">
    <cfargument name="model" type="any">
    <cfscript>
        textgenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.compositbuilders.textgenerator");
        code = textgenerator.createComponents(arguments.model, "");
        jmodel = replace(serializeJSON(arguments.model), '//', '');
    </cfscript>
    <cfquery name="existcheck_query" datasource="#dsn#">
        SELECT COUNT(*) AS CNT FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.fuseact#">
    </cfquery>
    <cfif existcheck_query.CNT eq 0>
        <cfquery name="wrkquery" result="wrkresult" datasource="#dsn#">
            SELECT wo.FULL_FUSEACTION, wo.HEAD, wo.DICTIONARY_ID, wf.WRK_FAMILY_ID, wf.FAMILY, ws.WRK_SOLUTION_ID, ws.SOLUTION 
            FROM WRK_OBJECTS wo
            INNER JOIN WRK_MODULE wm ON wo.MODULE_NO = wm.MODULE_NO
            INNER JOIN WRK_FAMILY wf ON wm.FAMILY_ID = wf.WRK_FAMILY_ID
            INNER JOIN WRK_SOLUTION ws ON wf.WRK_SOLUTION_ID = ws.WRK_SOLUTION_ID 
            WHERE FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.fuseact#">
        </cfquery>
        <cfquery name="modelinsertquery" datasource="#dsn#">
            INSERT INTO WRK_MODEL(MODEL_FUSEACTION, MODELNAME, MODELLANG, MODELJSON, MODELCOMPONENT, MODELFAMILYID, MODELFAMILY, MODELSOLUTIONID, MODELSOLUTION) VALUES(
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.FULL_FUSEACTION#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.HEAD#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrkquery.DICTIONARY_ID#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#jmodel#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#code#">,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#wrkquery.WRK_FAMILY_ID#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#wrkquery.FAMILY#'>,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#wrkquery.WRK_SOLUTION_ID#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#wrkquery.SOLUTION#'>
            )
        </cfquery>
    <cfelse>
        <cfquery name="modelupdatequery" datasource="#dsn#">
            UPDATE WRK_MODEL SET MODELJSON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#jmodel#">, MODELCOMPONENT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#code#"> WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.fuseact#">
        </cfquery>
    </cfif>
</cffunction>

<!--- get all widgets by fuseaction --->
<cffunction name="get_all_widgets" returntype="any">
    <cfargument name="fuseact">

    <cfquery name="query_widget" datasource="#dsn#">
        SELECT 
            WIDGETID,
            WIDGET_TITLE,
            WIDGET_VERSION,
            WIDGET_EVENT_TYPE,
            WIDGET_FUSEACTION
        FROM 
            WRK_WIDGET
        WHERE
            WIDGET_STATUS = 'Deployment'
            AND WIDGET_TITLE IS NOT NULL
            AND WIDGET_TOOL = 'nocode'
            AND  WIDGET_FUSEACTION = <cfqueryparam cfsqltype = "cf_sql_nvarchar" value="#arguments.fuseact#">
        ORDER BY WIDGET_TITLE ASC
    </cfquery>
    
    <cfreturn query_widget>
</cffunction>