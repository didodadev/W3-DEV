<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_COMPONENTS" access="remote" returntype="query">
    	<cfargument name="userFriendly" required="no" hint="Related WO">
        <cfargument name="keyword" required="no" hint="Keyword">
        <cfargument name="other" required="no" default="0" hint="Other WO">
        <cfquery name="GET_COMPONENTS" datasource="#dsn#">
             SELECT
                COMPONENTNAME,
                COMPONENTUSERFRIENDLY,
                CASE WHEN LEN(ISNULL(COMPONENTJSON,0)) = 1 THEN 'Form' ELSE 'List' END AS TYPE,
                COMPONENTAUTHOR
            FROM
                COMPONENT
			WHERE
            	1 = 1
                <cfif len(arguments.userFriendly) and arguments.other eq 1>
                	AND COMPONENTUSERFRIENDLY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userFriendly#">
                <cfelseif len(arguments.userFriendly)>
                	AND COMPONENTUSERFRIENDLY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userFriendly#">
                </cfif>
                <cfif len(arguments.keyword)>
                	AND (COMPONENTUSERFRIENDLY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR COMPONENTNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
        </cfquery>
		<cfreturn GET_COMPONENTS>
    </cffunction>

    <cffunction name="GET_WIDGETS" access="remote" returntype="query">
    	<cfargument name="fuseaction" required="no" hint="Related WO">
        <cfargument name="keyword" required="no" default="" hint="Keyword">
        <cfargument name="other" required="no" default="0" hint="Other WO">
        <cfargument name="solution" required="no" default="">
        <cfargument name="family" required="no" default="">
        <cfargument name="module" required="no" default="">
        <cfargument name="licence" required="no" default="">
        <cfargument name="public_area" required="no" default="">
        <cfargument name="tool" required="no" default="">
        <cfargument name="friendly_name" required="no" default="">
        <cfargument name="widget_id" required="no" default="">
        <cfquery name="GET_WIDGETS" datasource="#dsn#">
            SELECT
                WRK_WIDGET.WIDGETID,
                WRK_WIDGET.WIDGET_FUSEACTION,
                WRK_WIDGET.WIDGET_TITLE,
                WRK_WIDGET.WIDGET_EVENT_TYPE,
                WRK_WIDGET.WIDGET_VERSION,
                WRK_WIDGET.WIDGET_STRUCTURE,
                WRK_WIDGET.WIDGET_CODE,
                WRK_WIDGET.WIDGET_STATUS,
                WRK_WIDGET.WIDGET_STAGE,
                WRK_WIDGET.WIDGET_TOOL,
                WRK_WIDGET.WIDGET_FILE_PATH,
                WRK_WIDGET.WIDGETSOLUTION,
                WRK_WIDGET.WIDGETFAMILY,
                WRK_WIDGET.WIDGETMODULE,
                WRK_WIDGET.WIDGET_TYPE,
                WRK_WIDGET.WIDGET_FRIENDLY_NAME,
                WRK_OBJECTS.WRK_OBJECTS_ID
            FROM
                WRK_WIDGET
                LEFT JOIN WRK_OBJECTS ON WRK_WIDGET.WIDGET_FUSEACTION = WRK_OBJECTS.FULL_FUSEACTION
			WHERE
            	1 = 1
                <cfif len(arguments.fuseaction) and arguments.other neq 1>
                	AND [WIDGET_FUSEACTION] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseaction#">
                </cfif>
                <cfif len(arguments.keyword)>
                	AND ([WIDGET_FUSEACTION] LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR [WIDGET_TITLE] LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
                <cfif len(arguments.solution)>
                    AND ([WIDGETSOLUTIONID]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.solution#">
                </cfif>
                <cfif len(arguments.family)>
                    AND ([WIDGETFAMILYID]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.family#">
                </cfif>
                <cfif len(arguments.widget_id)>
                    AND ([WIDGETID]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.widget_id#">
                </cfif>
                <cfif len(arguments.module)>
                    AND ([WIDGETMODULEID]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#">
                </cfif>
                <cfif isdefined("arguments.widget_type") and len(arguments.widget_type)>
                    AND ([WIDGET_TYPE]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.widget_type#">
                    </cfif>
                <cfif len(arguments.licence)>
                    AND ([WIDGET_LICENSE]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">
                </cfif>
                <cfif len(arguments.public_area) and  arguments.public_area eq  1>
                    AND ([IS_PUBLIC]) = 1
                </cfif>
                <cfif len(arguments.public_area) and  arguments.public_area eq  2>
                    AND ([IS_EMPLOYEE]) = 1
                </cfif>
                <cfif len(arguments.public_area) and  arguments.public_area eq  3>
                    AND ([IS_COMPANY]) = 1
                </cfif>
                <cfif len(arguments.public_area) and  arguments.public_area eq  4>
                    AND ([IS_CONSUMER]) = 1
                </cfif>
                <cfif len(arguments.public_area) and  arguments.public_area eq  5>
                    AND ([IS_EMPLOYEE_APP]) = 1
                </cfif>
                <cfif len(arguments.public_area) and  arguments.public_area eq  6>
                    AND ([IS_MACHINES]) = 1
                </cfif>
                <cfif len(arguments.public_area) and  arguments.public_area eq  7>
                    AND ([IS_LIVESTOCK]) = 1
                </cfif>
                <cfif len(arguments.tool)>
                    AND ([WIDGET_TOOL]) = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.tool#">
                </cfif>
                <cfif len(arguments.friendly_name)>
                    AND [WIDGET_FRIENDLY_NAME] LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.friendly_name#%">
                </cfif>
        </cfquery>
		<cfreturn GET_WIDGETS>
    </cffunction>

    <cffunction name="GET_EVENTS" access="remote" returntype="query">
    	<cfargument name="fuseaction" required="no" hint="Related Event">
        <cfargument name="keyword" required="no" default="" hint="Keyword">
        <cfargument name="other" required="no" default="0" hint="Other Event">
        <cfargument name="solution" required="no" default="">
        <cfargument name="family" required="no" default="">
        <cfargument name="module" required="no" default="">
        <cfargument name="licence" required="no" default="">
        <cfquery name="GET_EVENTS" datasource="#dsn#">
            SELECT
                [EVENTID],
                [EVENT_FUSEACTION],
                [EVENT_TITLE],
                [EVENT_TYPE],
                [EVENT_VERSION],
                [EVENT_STRUCTURE],
                [EVENT_CODE],
                [EVENT_STATUS],
                [EVENT_STAGE],
                [EVENT_TOOL],
                [EVENT_FILE_PATH],
                [EVENT_SOLUTION],
                [EVENT_FAMILY],
                [EVENT_MODULE]
            FROM
                [WRK_EVENTS]
			WHERE
            	1 = 1
                <cfif len(arguments.fuseaction) and arguments.other neq 1>
                	AND [EVENT_FUSEACTION] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseaction#">
                </cfif>
                <cfif len(arguments.keyword)>
                	AND ([EVENT_FUSEACTION] LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR [EVENT_TITLE] LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
                <cfif len(arguments.solution)>
                    AND ([EVENT_SOLUTIONID]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.solution#">
                </cfif>
                <cfif len(arguments.family)>
                    AND ([EVENT_FAMILYID]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.family#">
                </cfif>
                <cfif len(arguments.module)>
                    AND ([EVENT_MODULEID]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#">
                </cfif>
                <cfif len(arguments.licence)>
                    AND ([EVENT_LICENSE]) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">
                </cfif>
        </cfquery>
		<cfreturn GET_EVENTS>
    </cffunction>

    <cffunction name="GET_WRK_FUSEACTIONS" access="remote" returntype="query">
    	<cfargument name="userFriendly" required="no" hint="Related WO">
        <cfquery name="GET_WRK_FUSEACTIONS" datasource="#dsn#">
             SELECT
                EVENT_ADD,
                EVENT_UPD,
                EVENT_LIST,
                EVENT_DETAIL,
                EVENT_DASHBOARD
            FROM
                WRK_OBJECTS
            WHERE 
                FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userFriendly#">
                AND CONTROLLER_FILE_PATH IS NOT NULL
        </cfquery>
		<cfreturn GET_WRK_FUSEACTIONS>
    </cffunction>
    
    <cffunction name="GET_COMPONENTS_JSON" access="remote" returntype="string" returnFormat="json">
    	<cfargument name="userFriendly" required="no" hint="Related WO">
        <cfargument name="keyword" required="no" hint="Keyword">
        <cfargument name="other" required="no" default="0" hint="Other WO">
        <cfquery name="GET_COMPONENTS" datasource="#dsn#">
             SELECT
                COMPONENTNAME,
                COMPONENTUSERFRIENDLY,
                CASE WHEN LEN(ISNULL(COMPONENTJSON,0)) = 1 THEN 'Form' ELSE 'List' END AS TYPE,
                COMPONENTAUTHOR
            FROM
                COMPONENT
			WHERE
            	1 = 1
                <cfif len(arguments.userFriendly) and arguments.other eq 1>
                	AND COMPONENTUSERFRIENDLY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userFriendly#">
                <cfelseif len(arguments.userFriendly)>
                	AND COMPONENTUSERFRIENDLY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userFriendly#">
                </cfif>
                <cfif len(arguments.keyword)>
                	AND (COMPONENTUSERFRIENDLY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR COMPONENTNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
        </cfquery>
		<cfreturn Replace(serializeJSON(GET_COMPONENTS),'//','')>
    </cffunction>
	<cffunction name="GET_COMPONENT_OBJECT_JSON" access="remote" returntype="string" returnFormat="json">
        <cfargument name="keyword" required="no" hint="Keyword">
        <cfquery name="GET_COMPONENTS" datasource="#dsn#">
             SELECT
                HEAD,
                FUSEACTION,
                FILE_PATH
            FROM
                WRK_OBJECTS
			WHERE
            	1 = 1
                <cfif len(arguments.keyword)>
                	AND (HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
        </cfquery>
		<cfreturn Replace(serializeJSON(GET_COMPONENTS),'//','')>
    </cffunction>

	<cffunction name="GET_CONTROLLERNAME" access="remote" returntype="query">
        <cfargument name="userFriendly" required="no" hint="wo">
        <cfargument name="WoFuseaction" required="no" hint="wo">
        <cfquery name="GET_COMPONENTS" datasource="#dsn#">
             SELECT
                ADDOPTIONS_CONTROLLER_FILE_PATH,
                CONTROLLER_FILE_PATH,
                FRIENDLY_URL,
                DATA_CFC
            FROM
                WRK_OBJECTS
			WHERE
				FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userFriendly#">
                <cfif len(arguments.WoFuseaction)>
                	AND FULL_FUSEACTION = '#arguments.WoFuseaction#'
                </cfif>
        </cfquery>
        <cfreturn GET_COMPONENTS>
    </cffunction>
</cfcomponent>