<cfcomponent>
<cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="savetoevent" access="public" returntype="any">
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
                                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#event#'>
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
                </cfloop>
            </cftransaction>
            <cfreturn 1>
            <cfcatch>
                <cfreturn 0>
            </cfcatch>
        </cftry>
    </cffunction>
    <cffunction  name="upttoevent" access="remote" returntype="any">
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
        <cfargument name="original_fuseaction" type="string">
        <cftry>
            <cftransaction>
                <cfloop list="#arguments.events#" index="event">
                    <cfquery name="query_update_event" datasource="#dsn#">
                        UPDATE WRK_EVENTS SET
                        EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                        ,EVENT_SOLUTIONID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
                        ,EVENT_SOLUTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.solution#'>
                        ,EVENT_FAMILYID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
                        ,EVENT_FAMILY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.family#'>
                        ,EVENT_MODULEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleid#'>
                        ,EVENT_MODULE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.module#'>
                        ,EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#event#'>
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
                        WHERE 
                        EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.original_fuseaction#'>
                        AND EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#event#'>                       
                     </cfquery>
                </cfloop>
            </cftransaction>
        <cfcatch>
            <cfreturn 0>
        </cfcatch>
        </cftry>
        <cfreturn 1>
    </cffunction>
    <cffunction  name="deletetoevent" access="remote" returntype="any">
        <cfargument name="events" type="string">
        <cfargument name="original_fuseaction" type="string">
        <cftry>
            <cftransaction>
                <cfloop list="#arguments.events#" index="event">
                    <cfquery name="query_delete_event" datasource="#dsn#">
                        DELETE FROM WRK_EVENTS 
                        WHERE 
                        EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.original_fuseaction#'>
                        AND EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#event#'>
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