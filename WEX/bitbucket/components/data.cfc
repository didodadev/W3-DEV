<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="insert" access="public">
        <cfargument name="title" required="true">
        <cfargument name="description" default="">
        <cfargument name="task_id" default="">
        <cfargument name="view_url" default="">
        <cfargument name="author" default="">
        <cfargument name="author_data" default="">
        <cfargument name="created" default="">
        <cfargument name="bbid" default="">
        <cfargument name="destination_branch" default="">
        <cfargument name="source_branch" default="">
        <cfargument name="state" default="">
        <cfargument name="participants" default="">

        <cfobject name="datetimehelper" type="component" component="WEX.bitbucket.helpers.datetime">

        <cfquery name="query_add_hooks" datasource="#dsn#">
            IF EXISTS (SELECT TOP 1 1 FROM BITBUCKET_HOOKS WHERE BBID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bbid#'>)
            BEGIN
                UPDATE BITBUCKET_HOOKS
                SET
                STATE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.state#' null="#len(arguments.state)?'no':'yes'#">
                ,PARTICIPANTS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.participants#' null="#len(arguments.participants)?'no':'yes'#">
                WHERE BBID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bbid#'>
            END
            ELSE
            BEGIN
                INSERT INTO BITBUCKET_HOOKS
                (PROC_TYPE
                ,TITLE
                ,DESCRIPTION
                ,VIEW_URL
                ,AUTHOR
                ,CREATED
                ,TASK_ID
                ,BBID
                ,DESTINATION_BRANCH
                ,SOURCE_BRANCH
                ,STATE
                ,PARTICIPANTS
                ,AUTHOR_DATA
                )
                    VALUES
                ('pullrequest'
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.description#' null="#len(arguments.description)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.view_url#' null="#len(arguments.view_url)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#' null="#len(arguments.author)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#len(arguments.created)?datetimehelper.webtime2date(arguments.created):""#' null="#len(arguments.created)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.task_id#' null="#(len(arguments.task_id) and arguments.task_id gt 0)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bbid#' null="#(len(arguments.bbid) and arguments.bbid gt 0)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.destination_branch#' null="#len(arguments.destination_branch)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.source_branch#' null="#len(arguments.source_branch)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.state#' null="#len(arguments.state)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.participants#' null="#len(arguments.participants)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author_data#' null="#len(arguments.author_data)?'no':'yes'#">
                )
            END
        </cfquery>
    </cffunction>

    <cffunction name="listbytask" access="public">
        <cfargument name="taskid">

        <cfquery name="query_get_hooks" datasource="#dsn#">
            SELECT BH.*, WUNR.NOTE_ROW_ID FROM BITBUCKET_HOOKS BH
            LEFT JOIN WRK_UPGRADE_NOTES_ROW WUNR ON BH.HOOKID = WUNR.HOOKID
            WHERE BH.TASK_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.taskid#'>
        </cfquery>

        <cfreturn query_get_hooks>
    </cffunction>

</cfcomponent>