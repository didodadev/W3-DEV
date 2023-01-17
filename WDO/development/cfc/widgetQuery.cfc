<cfcomponent>
<cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="savetowidget" access="remote" returntype="any">  
        <cfargument name="fuseaction" type="string" default="">
        <cfargument name="title" type="string">
        <cfargument name="version" type="string">
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
        <cfargument name="widget_type" type="integer">
        
        <cftry>
            <cftransaction>
                <cfloop list="#arguments.events#" index="event">
                    
                        <cfquery datasource="#dsn#">
                            INSERT INTO WRK_WIDGET (
                                WIDGET_FUSEACTION,
                                WIDGET_TITLE,
                                WIDGET_EVENT_TYPE,
                                WIDGET_VERSION,
                                WIDGET_STATUS,
                                WIDGET_STAGE,
                                WIDGET_TOOL,
                                WIDGET_FILE_PATH,
                                WIDGETSOLUTIONID,
                                WIDGETSOLUTION,
                                WIDGETFAMILYID,
                                WIDGETFAMILY,
                                WIDGETMODULEID,
                                WIDGETMODULE,
                                WIDGET_LICENSE,
                                WIDGET_AUTHOR,
                                WIDGET_DESCRIPTION,
                                RECORD_IP,
                                RECORD_EMP,
                                RECORD_DATE,
                                WIDGET_TYPE
                            ) VALUES (
                                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#event#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.version#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.status#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stage#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.tool#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.solution#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.family#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleid#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.module#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.description#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                                ,#now()# 
                                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.widget_type#'>
                            )
                        </cfquery>
                    
                </cfloop>
            </cftransaction>
            <cfreturn 1>
            <cfcatch>
                <cfreturn 0>
            </cfcatch>
        </cftry>
    </cffunction>
    <cffunction  name="upttowidget" access="remote" returntype="any">
        <cfargument name="fuseaction" type="string">
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
        <cfargument name="widget_type" type="integer">
        <cfargument name="original_fuseaction" type="string">
        <cftry>
            <cftransaction>
                <cfloop list="#arguments.events#" index="event">
                    <cfquery name="query_update" datasource="#dsn#">
                        UPDATE WRK_WIDGET SET
                        WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                        ,WIDGET_TITLE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                        ,WIDGET_STATUS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.status#'>
                        ,WIDGET_STAGE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stage#'>
                        <cfif isDefined("arguments.file_path") and len(arguments.file_path)>
                        ,WIDGET_FILE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
                        </cfif>
                        ,WIDGETSOLUTIONID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
                        ,WIDGETSOLUTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.solution#'>
                        ,WIDGETFAMILYID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
                        ,WIDGETFAMILY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.family#'>
                        ,WIDGETMODULEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleid#'>
                        ,WIDGETMODULE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.module#'>
                        ,WIDGET_LICENSE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
                        ,WIDGET_AUTHOR = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
                        ,WIDGET_DESCRIPTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.description#'>
                        ,UPDATE_IP = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                        ,UPDATE_EMP = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                        ,UPDATE_DATE = #now()#
                        ,WIDGET_TYPE=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.widget_type#'>
                        WHERE 
                        WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.original_fuseaction#'>
                        AND WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#event#'>
                    </cfquery>
                </cfloop>
            </cftransaction>
        <cfcatch>
            <cfreturn 0>
        </cfcatch>
        </cftry>
        <cfreturn 1>
    </cffunction>
    <cffunction  name="deletetowidget" access="remote" returntype="any">
        <cfargument name="events" type="string">
        <cfargument name="original_fuseaction" type="string">
        <cftry>
            <cftransaction>
                <cfloop list="#arguments.events#" index="event">
                    <cfquery name="query_delete" datasource="#dsn#">
                        DELETE FROM WRK_WIDGET 
                        WHERE 
                        WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.original_fuseaction#'>
                        AND WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#event#'>
                        AND 1 = 2
                    </cfquery>
                </cfloop>
            </cftransaction>
        <cfcatch>
         <cfdump  var="#cfcatch#">
            <cfreturn 0>
        </cfcatch>
        </cftry>
        <cfreturn 1>
    </cffunction>
</cfcomponent>