<!--- get event list --->
<cffunction name="get_events" returntype="any">
    <cfargument name="fuseaction" type="string">
    <cfargument name="solutionid" type="numeric">
    <cfargument name="familyid" type="numeric">
    <cfargument name="moduleid" type="numeric">
    <cfargument name="type" type="string">
    <cfargument name="title" type="string">
    <cfargument name="licence" type="string">
    <cfquery name="query_events" datasource="#dsn#">
        SELECT * FROM WRK_EVENTS
        WHERE 1 = 1
        <cfif isDefined("arguments.solutionid")>
            AND EVENT_SOLUTIONID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
        </cfif>
        <cfif isDefined("arguments.familyid")>
            AND EVENT_FAMILYID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
        </cfif>
        <cfif isDefined("arguments.moduleid")>
            AND EVENT_MODULEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleid#'>
        </cfif>
        <cfif isDefined("arguments.fuseaction")>
            AND EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
        </cfif>
        <cfif isDefined("arguments.type")>
            AND EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.type#'>
        </cfif>
        <cfif isDefined("arguments.title")>
            AND EVENT_TITLE LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.title#%'>
        </cfif>
        <cfif isDefined("arguments.licence")>
            AND EVENT_LICENCE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.licence#'>
        </cfif>
    </cfquery>
    <cfreturn query_events>
</cffunction>

<!--- get event detail --->
<cffunction name="get_event_detail" returntype="any">
    <cfargument name="id" type="numeric">
    <cfquery name="query_event_detail" datasource="#dsn#">
        SELECT TEVENTS.EVENT_TITLE, TEVENTS.EVENT_FUSEACTION, TEVENTS.EVENT_SOLUTIONID, TEVENTS.EVENT_SOLUTION, TEVENTS.EVENT_FAMILYID, TEVENTS.EVENT_FAMILY, TEVENTS.EVENT_MODULEID, TEVENTS.EVENT_MODULE, TEVENTS.EVENT_TOOL, TEVENTS.EVENT_DESCRIPTION, TEVENTS.EVENT_LICENSE, TEVENTS.EVENT_AUTHOR, TEVENTS.EVENT_STATUS, TEVENTS.EVENT_STAGE, TEVENTS.EVENT_VERSION, ISNULL(( SELECT TOP 1 EVENT_FILE_PATH FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'add') ), 0) AS ADD_PATH, ISNULL(( SELECT TOP 1 EVENT_FILE_PATH FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'upd') ), 0) AS UPDATE_PATH, ISNULL(( SELECT TOP 1 EVENT_FILE_PATH FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'list') ), 0) AS LIST_PATH, ISNULL(( SELECT TOP 1 1 FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'dashboard') ), 0) AS DASHBOARD_PATH, ISNULL(( SELECT TOP 1 EVENT_FILE_PATH FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'info') ), 0) AS INFO_PATH, ISNULL(( SELECT TOP 1 EVENTID FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'add') ), 0) AS ADD_ID, ISNULL(( SELECT TOP 1 EVENTID FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'upd') ), 0) AS UPDATE_ID, ISNULL(( SELECT TOP 1 EVENTID FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'list') ), 0) AS LIST_ID, ISNULL(( SELECT TOP 1 EVENTID FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'dashboard') ), 0) AS DASHBOARD_ID, ISNULL(( SELECT TOP 1 EVENTID FROM WRK_EVENTS WHERE ((EVENT_FUSEACTION IS NULL AND TEVENTS.EVENT_FUSEACTION IS NULL) OR EVENT_FUSEACTION = TEVENTS.EVENT_FUSEACTION) AND (EVENT_SOLUTIONID = TEVENTS.EVENT_SOLUTIONID) AND (EVENT_FAMILYID = TEVENTS.EVENT_FAMILYID) AND (EVENT_MODULEID = TEVENTS.EVENT_MODULEID) AND (EVENT_VERSION = TEVENTS.EVENT_VERSION) AND (EVENT_TOOL = TEVENTS.EVENT_TOOL) AND (EVENT_TYPE = 'info') ), 0) AS INFO_ID FROM WRK_EVENTS TEVENTS INNER JOIN WRK_EVENTS OEVENTS ON TEVENTS.EVENT_FUSEACTION = OEVENTS.EVENT_FUSEACTION AND TEVENTS.EVENT_SOLUTIONID = OEVENTS.EVENT_SOLUTIONID AND TEVENTS.EVENT_FAMILYID = OEVENTS.EVENT_FAMILYID AND TEVENTS.EVENT_MODULEID = OEVENTS.EVENT_MODULEID AND TEVENTS.EVENT_TOOL = OEVENTS.EVENT_TOOL AND TEVENTS.EVENT_VERSION = OEVENTS.EVENT_VERSION AND <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'> = OEVENTS.EVENTID GROUP BY TEVENTS.EVENT_TITLE, TEVENTS.EVENT_FUSEACTION, TEVENTS.EVENT_SOLUTIONID, TEVENTS.EVENT_SOLUTION, TEVENTS.EVENT_FAMILYID, TEVENTS.EVENT_FAMILY, TEVENTS.EVENT_MODULEID, TEVENTS.EVENT_MODULE, TEVENTS.EVENT_TOOL, TEVENTS.EVENT_DESCRIPTION, TEVENTS.EVENT_LICENSE, TEVENTS.EVENT_AUTHOR, TEVENTS.EVENT_STATUS, TEVENTS.EVENT_STAGE, TEVENTS.EVENT_VERSION
    </cfquery>
    <cfreturn query_event_detail>
</cffunction>

<!--- Save form to db --->
<cffunction name="formtodb" access="public" returntype="any">
    <cfargument name="fuseaction" type="string" default="">
    <cfargument name="title" type="string">
    <cfargument name="version" type="string">
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
    <cfargument name="moduleid" type="integer">
    <cfargument name="module" type="string">
    <cfargument name="license" type="string">
    <cfargument name="author" type="string">
    <cfargument name="description" type="string">
    <cfargument name="events" type="string">

    <cftry>
        <cftransaction>
            <cfloop list="#arguments.events#" index="event">
                <cfset eventname= listFirst(event, ":")>
                <cfset eventid = listLast(event, ":")>
                <cfquery name="query_ids_count" datasource="#dsn#">
                    SELECT TOP 1 1 FROM WRK_EVENTS WHERE EVENTID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#eventid#'>
                </cfquery>
                <cfif query_ids_count.recordCount eq 0>
                    <cfquery datasource="#dsn#">
                        INSERT INTO WRK_EVENTS (
                            [EVENT_TITLE]
                            ,[EVENT_FUSEACTION]
                            ,[EVENT_SOLUTIONID]
                            ,[EVENT_SOLUTION]
                            ,[EVENT_FAMILYID]
                            ,[EVENT_FAMILY]
                            ,[EVENT_MODULEID]
                            ,[EVENT_MODULE]
                            ,[EVENT_TYPE]
                            <cfif isDefined("arguments.file_path")>
                            ,[EVENT_FILE_PATH]
                            </cfif>
                            ,[EVENT_TOOL]
                            ,[EVENT_DESCRIPTION]
                            ,[EVENT_LICENSE]
                            ,[EVENT_AUTHOR]
                            ,[EVENT_STATUS]
                            ,[EVENT_STAGE]
                            ,[EVENT_VERSION]
                            ,[RECORD_IP]
                            ,[RECORD_EMP]
                            ,[RECORD_DATE]
                        ) VALUES (
                            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.solution#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.family#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.module#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#eventname#'>
                            <cfif isDefined("arguments.file_path")>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
                            </cfif>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.tool#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.description#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.status#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stage#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.version#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                            ,#now()#
                        )
                    </cfquery>
                <cfelse>
                    <cfquery datasource="#dsn#">
                    UPDATE WRK_EVENTS SET
                    EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                    ,EVENT_SOLUTIONID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
                    ,EVENT_SOLUTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.solution#'>
                    ,EVENT_FAMILYID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
                    ,EVENT_FAMILY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.family#'>
                    ,EVENT_MODULEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleid#'>
                    ,EVENT_MODULE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.module#'>
                    ,EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#eventname#'>
                    <cfif isDefined("arguments.file_path")>
                    ,EVENT_FILE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
                    </cfif>
                    ,EVENT_TOOL = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.tool#'>
                    ,EVENT_DESCRIPTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.description#'>
                    ,EVENT_LICENSE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
                    ,EVENT_AUTHOR = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
                    ,EVENT_STATUS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.status#'>
                    ,EVENT_STAGE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stage#'>
                    ,EVENT_VERSION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.version#'>
                    ,UPDATE_IP = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                    ,UPDATE_EMP = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                    ,UPDATE_DATE = #now()#
                    WHERE EVENTID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#eventid#'>
                    </cfquery>
                </cfif>
            </cfloop>
        </cftransaction>
        <cfreturn 1>
        <cfcatch>
            <cfdump var="#cfcatch#" abort>
            <cfreturn 0>
        </cfcatch>
    </cftry>
</cffunction>

<!--- Save layout to db --->
<cffunction name="layouttodb" access="public" returntype="any">
    <cfargument name="id" type="numeric">
    <cfargument name="structure" type="string">
    <cfset response = structNew() />
    <cftry>
        <cfquery name="query_update_layout" datasource="#dsn#">
            UPDATE WRK_EVENTS SET EVENT_STRUCTURE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.structure#'>
            WHERE EVENTID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
        </cfquery>
        <cfset response = { status: true, message: 'Event successfully updated.' } />
    <cfcatch type="any">
        <cfset response = { status: false, message: 'An error occorred while updating event!' } />
    </cfcatch>
    </cftry>
    <cfreturn response>
</cffunction>

<!--- Get layout --->
<cffunction name="get_layout" access="public" returntype="any">
    <cfargument name="id" type="numeric">
    <cfquery name="query_get_layout" datasource="#dsn#">
        SELECT EVENT_STRUCTURE FROM WRK_EVENTS WHERE EVENTID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
    </cfquery>
    <cfif query_get_layout.recordCount>
        <cfreturn query_get_layout.EVENT_STRUCTURE>
    <cfelse>
        <cfreturn '[]'>
    </cfif>
</cffunction>

<cffunction name="get_widgets" returntype="any">
    <cfargument name="fuseaction">
    <cfargument name="event">
    <cfargument name="version" default="default">
    <cfquery name="query_widget" datasource="#dsn#">
        SELECT 
            W.WIDGETID,
            W.WIDGET_TITLE,
            W.WIDGET_VERSION,
            W.WIDGET_EVENT_TYPE,
            W.WIDGET_STRUCTURE,
            W.WIDGETMODULEID MODULE_NO,
            W.WIDGET_TOOL,
            W.WIDGET_FUSEACTION,
            WM.MODELJSON,
            WO.WRK_OBJECTS_ID AS WOID
        FROM WRK_WIDGET W
        INNER JOIN WRK_MODEL WM ON W.WIDGET_FUSEACTION = WM.MODEL_FUSEACTION
        INNER JOIN WRK_OBJECTS WO ON W.WIDGET_FUSEACTION = WO.FULL_FUSEACTION
        WHERE 1 = 1
        AND W.WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
        AND W.WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.event#'>
        <cfif arguments.version neq "">
            AND W.WIDGET_VERSION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.version#'>
        </cfif>
    </cfquery>
    <cfset arr_widgets = []>
    <cfloop query="query_widget">
        <cfscript>
            the_model = deserializeJSON( MODELJSON );
            lofProperties = [];
            for (strct in the_model) {
                for (prp in strct.listOfProperties) {
                    prp.struct = strct.name;
                    arrayAppend( lofProperties, prp, 1 );
                }
            }
        </cfscript>
        <cfset arrayAppend( arr_widgets, { title: WIDGET_TITLE, version: WIDGET_VERSION, id: WIDGETID, event: WIDGET_EVENT_TYPE, tool: WIDGET_TOOL, fuseaction: WIDGET_FUSEACTION, woid: WOID, data: deserializeJSON( len( WIDGET_STRUCTURE ) ? WIDGET_STRUCTURE : "[]" ), props: lofProperties } )>
    </cfloop>
    <cfreturn arr_widgets>
</cffunction>

<cffunction name="get_all_widgets" returntype="any">
    <cfargument name="event">

    <cfquery name="query_widget" datasource="#dsn#">
        SELECT 
            W.WIDGETID,
            W.WIDGET_TITLE,
            W.WIDGET_VERSION,
            W.WIDGET_EVENT_TYPE,
            W.WIDGET_STRUCTURE,
            W.WIDGETMODULEID MODULE_NO,
            W.WIDGET_TOOL,
            W.WIDGET_FUSEACTION,
            WM.MODELJSON,
            M.MODULE_DICTIONARY_ID,
            ISNULL(DC.ITEM_#session.ep.LANGUAGE#, M.MODULE) AS MODULE_TITLE,
            ISNULL(M.ICON,'ctl-045-warehouse') ICON,
            WO.WRK_OBJECTS_ID AS WOID
        FROM 
            WRK_WIDGET W
            LEFT JOIN WRK_MODEL WM ON W.WIDGET_FUSEACTION = WM.MODEL_FUSEACTION
            LEFT JOIN WRK_MODULE M ON M.MODULE_ID = W.WIDGETMODULEID
            LEFT JOIN WRK_OBJECTS WO ON W.WIDGET_FUSEACTION = WO.FULL_FUSEACTION
            LEFT JOIN SETUP_LANGUAGE_TR DC ON DC.DICTIONARY_ID = M.MODULE_DICTIONARY_ID
        WHERE
            W.WIDGET_STATUS = 'Deployment'
            AND W.WIDGETMODULEID IS NOT NULL
            AND W.WIDGET_TITLE IS NOT NULL
        ORDER BY W.WIDGETMODULEID ASC
    </cfquery>
    <cfset arr_wo = {}>
    <cfloop query="query_widget">
        <cfscript>
            the_model = len( MODELJSON ) ? deserializeJSON( MODELJSON ) : [];
            lofProperties = [];
            if ( WIDGET_TOOL eq "nocode" ) {
                the_struct = len( WIDGET_STRUCTURE ) ? WIDGET_STRUCTURE : '{ "layout": [ { "listOfCols": [ { "colsize": 12 } ] } ], "box":{"closable":false,"dragdrop":false,"left_side":false,"uniquebox_height":"","refresh":false,"collapsable":false,"title_style":"","box_type":"","style":"","body_style":"","class":"","header_style":"","unload_body":false,"scroll":false,"body_height":"","title":"","iswidget":false,"design_type":false} }';
                if( ArrayLen( the_model ) ){
                    for (strct in the_model) {
                        for (prp in strct.listOfProperties) {
                            prp.struct = strct.name;
                            arrayAppend( lofProperties, prp, 1 );
                        }
                    }
                }
            } else {
                the_struct = '{ "layout": [ { "listOfCols": [ { "colsize": 12 } ] } ], "box":{"closable":false,"dragdrop":false,"left_side":false,"uniquebox_height":"","refresh":false,"collapsable":false,"title_style":"","box_type":"","style":"","body_style":"","class":"","header_style":"","unload_body":false,"scroll":false,"body_height":"","title":"","iswidget":false,"design_type":false} }';
                if( ArrayLen( the_model ) ){
                    for (strct in the_model) {
                        for (prp in strct.listOfProperties) {
                            arrayAppend( lofProperties, prp, 1 );
                        }
                    }
                }
            }
        </cfscript>
        <cfif not structKeyExists( arr_wo, MODULE_NO )> 
            <cfset arr_wo[MODULE_NO] = structNew() /> 
            <cfset arr_wo[MODULE_NO] = { module: { id: MODULE_NO, title: MODULE_TITLE, icon: ICON }, widget: [] } />
        </cfif>
        <cfset arrayAppend( arr_wo[MODULE_NO]["widget"], { title: WIDGET_TITLE, version: WIDGET_VERSION, id: WIDGETID, event: WIDGET_EVENT_TYPE, tool: WIDGET_TOOL, fuseaction: WIDGET_FUSEACTION, woid: WOID, data: deserializeJSON( the_struct ), props: lofProperties } )>
    </cfloop>

    <cfset response = [] />
    <cfloop collection="#arr_wo#" item="item"><cfset arrayAppend(response, { module: arr_wo[item].module, widget: arr_wo[item].widget }) /></cfloop>

    <cfreturn response>
</cffunction>

<cffunction name = "get_ready_objects" returnType = "any">
    <cffile action="read" file="#replace(download_folder,'\','/','all')#WDO/catalogs/readyObjects.json" variable="readyObjects" charset="utf-8">
    
    <cfset arr_objects = [] />
    <cfif len( readyObjects )>
        <cfloop array="#deserializeJson(readyObjects)#" item="item">
            <cfset the_struct = '{ "layout": [ { "listOfCols": [ { "colsize": 12 } ] } ], "box":{"closable":false,"dragdrop":false,"left_side":false,"uniquebox_height":"","refresh":false,"collapsable":false,"title_style":"","box_type":"","style":"","body_style":"","class":"","header_style":"","unload_body":false,"scroll":false,"body_height":"","title":"","iswidget":false,"design_type":false} }' />
            <cfset arrayAppend( arr_objects, { title: item.WIDGET_TITLE, version: item.WIDGET_VERSION, id: 0, event: "", tool: "readyObject", fuseaction: "", woid: "", data: deserializeJSON( the_struct ), props: [] } )>
        </cfloop>
    </cfif>

    <cfreturn arr_objects>
</cffunction>