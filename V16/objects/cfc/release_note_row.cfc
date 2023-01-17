<!--- 
    Author : Uğur Hamurpet
    Date : 31/08/2020
    Desc : Add new or update release note row cfc
--->

<cfcomponent>

    <cfset dsn = application.SystemParam.SystemParam().dsn />

    <cffunction name = "select" returnType = "query" access = "public">
        <cfargument name="note_row_id" type="numeric" default="0">
        <cfargument name="task_id" type="numeric" default="0">
        <cfargument name="release_no" type="string" default="">
        
        <cfquery name = "select_upgrade_notes_row" datasource = "#dsn#">
            SELECT 
                WUNR.NOTE_ROW_ID
                ,WUNR.TASK_ID
                ,WUNR.HOOKID
                ,WUNR.RELEASE_NO
                ,WUNR.PATCH_NO
                ,WUNR.NOTE_ROW_TYPE
                ,WUNR.NOTE_ROW_TITLE
                ,WUNR.NOTE_ROW_DETAIL
                ,WUNR.NOTE_ROW_STATUS
                ,WUNR.RECORD_EMP
                ,WUNR.RECORD_IP
                ,WUNR.RECORD_DATE
                ,WUNR.UPDATE_EMP
                ,WUNR.UPDATE_IP
                ,WUNR.UPDATE_DATE
                ,BH.BBID
                ,BH.SOURCE_BRANCH
                ,BH.DESTINATION_BRANCH
            FROM WRK_UPGRADE_NOTES_ROW AS WUNR
            LEFT JOIN BITBUCKET_HOOKS AS BH ON WUNR.HOOKID = BH.HOOKID
            WHERE 1 = 1
            <cfif arguments.note_row_id neq 0>
                AND WUNR.NOTE_ROW_ID = <cfqueryparam value = "#arguments.note_row_id#" CFSQLType = "cf_sql_integer">
            </cfif>
            <cfif arguments.task_id neq 0>
                AND WUNR.TASK_ID = <cfqueryparam value = "#arguments.task_id#" CFSQLType = "cf_sql_integer">
            </cfif>
            <cfif len(arguments.release_no)>
                AND WUNR.RELEASE_NO = <cfqueryparam value = "#arguments.release_no#" CFSQLType = "cf_sql_nvarchar">
            </cfif>
            ORDER BY WUNR.NOTE_ROW_ID DESC
        </cfquery>
        <cfreturn select_upgrade_notes_row />
    </cffunction>

    <cffunction name = "insert" returnType = "struct" access = "public">
        <cfargument name="task_id" type="numeric" default="0">
        <cfargument name="hook_id" type="numeric" default="0">
        <cfargument name="release_no" type="string" required="true">
        <cfargument name="patch_no" type="string" default="">
        <cfargument name="note_row_type" type="string" required="true">
        <cfargument name="note_row_title" type="string" default="">
        <cfargument name="note_row_detail" type="string" required="true">
        <cfargument name="note_row_status" type="boolean" default="1">

        <cftry>
            <cfquery name = "insert_upgrade_notes_row" datasource = "#dsn#" result="result">
                INSERT INTO WRK_UPGRADE_NOTES_ROW(
                    TASK_ID
                    ,HOOKID
                    ,RELEASE_NO
                    ,PATCH_NO
                    ,NOTE_ROW_TYPE
                    ,NOTE_ROW_TITLE
                    ,NOTE_ROW_DETAIL
                    ,NOTE_ROW_STATUS
                    ,RECORD_EMP
                    ,RECORD_IP
                    ,RECORD_DATE
                )
                VALUES
                (
                    <cfqueryparam value = "#arguments.task_id#" CFSQLType = "cf_sql_integer" null = "#arguments.task_id eq 0 ? 'yes' : 'no'#">
                    ,<cfqueryparam value = "#arguments.hook_id#" CFSQLType = "cf_sql_integer" null = "#arguments.hook_id eq 0 ? 'yes' : 'no'#">
                    ,<cfqueryparam value = "#arguments.release_no#" CFSQLType = "cf_sql_nvarchar">
                    ,<cfqueryparam value = "#arguments.patch_no#" CFSQLType = "cf_sql_nvarchar" null = "#not len('arguments.patch_no') ? 'yes' : 'no'#">
                    ,<cfqueryparam value = "#arguments.note_row_type#" CFSQLType = "cf_sql_nvarchar">
                    ,<cfqueryparam value = "#arguments.note_row_title#" CFSQLType = "cf_sql_nvarchar" null = "#not len('arguments.note_row_title') ? 'yes' : 'no'#">
                    ,<cfqueryparam value = "#arguments.note_row_detail#" CFSQLType = "cf_sql_nvarchar">
                    ,<cfqueryparam value = "#arguments.note_row_status#" CFSQLType = "cf_sql_bit">
                    ,#session.ep.userid#
                    ,'#CGI.REMOTE_ADDR#'
                    ,#now()#
                )
            </cfquery>
            <cfreturn  { status : true, result : result }>
            <cfcatch type = "any">
                <cfreturn  { status : false }>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "update" returnType = "struct" access = "public">
        <cfargument name="note_row_id" type="numeric">
        <cfargument name="task_id" type="numeric" default="0">
        <cfargument name="hook_id" type="numeric" default="0">
        <cfargument name="release_no" type="string" required="true">
        <cfargument name="patch_no" type="string" default="">
        <cfargument name="note_row_type" type="string" required="true">
        <cfargument name="note_row_title" type="string" default="">
        <cfargument name="note_row_detail" type="string" required="true">
        <cfargument name="note_row_status" type="boolean" default="1">

        <cftry>
            <cfquery name = "update_upgrade_notes_row" datasource = "#dsn#">
                UPDATE WRK_UPGRADE_NOTES_ROW SET
                    TASK_ID = <cfqueryparam value = "#arguments.task_id#" CFSQLType = "cf_sql_integer" null = "#arguments.task_id eq 0 ? 'yes' : 'no'#">
                    ,HOOKID = <cfqueryparam value = "#arguments.hook_id#" CFSQLType = "cf_sql_integer" null = "#arguments.hook_id eq 0 ? 'yes' : 'no'#">
                    ,RELEASE_NO = <cfqueryparam value = "#arguments.release_no#" CFSQLType = "cf_sql_nvarchar">
                    ,PATCH_NO = <cfqueryparam value = "#arguments.patch_no#" CFSQLType = "cf_sql_nvarchar" null = "#not len('arguments.patch_no') ? 'yes' : 'no'#">
                    ,NOTE_ROW_TYPE = <cfqueryparam value = "#arguments.note_row_type#" CFSQLType = "cf_sql_nvarchar">
                    ,NOTE_ROW_TITLE = <cfqueryparam value = "#arguments.note_row_title#" CFSQLType = "cf_sql_nvarchar" null = "#not len('arguments.note_row_title') ? 'yes' : 'no'#">
                    ,NOTE_ROW_DETAIL = <cfqueryparam value = "#arguments.note_row_detail#" CFSQLType = "cf_sql_nvarchar">
                    ,NOTE_ROW_STATUS = <cfqueryparam value = "#arguments.note_row_status#" CFSQLType = "cf_sql_bit">
                    ,UPDATE_EMP = #session.ep.userid#
                    ,RECORD_IP = '#CGI.REMOTE_ADDR#'
                    ,RECORD_DATE = #now()#
                WHERE NOTE_ROW_ID = <cfqueryparam value = "#arguments.note_row_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfreturn  { status : true }>
            <cfcatch type = "any">
                <cfreturn  { status : false }>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "delete" returnType = "struct" access = "public">
        <cfargument name="note_row_id" type="numeric">

        <cftry>
            <cfquery name = "delete_upgrade_notes_row" datasource = "#dsn#">
                DELETE FROM WRK_UPGRADE_NOTES_ROW WHERE NOTE_ROW_ID = <cfqueryparam value = "#arguments.note_row_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfreturn  { status : true }>
            <cfcatch type = "any">
                <cfreturn  { status : false }>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>