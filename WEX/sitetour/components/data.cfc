<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="insert" access="public">
        <cfargument name="help_fuseaction">
        <cfargument name="help_head" default="">
        <cfargument name="help_topic" default="">
        <cfargument name="recorder_name" default="">
        <cfargument name="recorder_domain" default="">
        <cfargument name="recorder_email" default="">
        <cfargument name="is_news" default="">
        <cfquery name="query_insert_tour" datasource="#dsn#">
            INSERT INTO HELP_DESK
           (HELP_HEAD
           ,HELP_TOPIC
           ,HELP_CIRCUIT
           ,HELP_FUSEACTION
           ,RECORD_DATE
           ,RECORD_MEMBER
           ,RECORD_ID
           ,RECORD_IP
           ,UPDATE_DATE
           ,UPDATE_MEMBER
           ,UPDATE_ID
           ,UPDATE_IP
           ,IS_STANDARD
           ,RECORDER_NAME
           ,HELP_LANGUAGE
           ,HELP_OLD_ID
           ,IS_INTERNET
           ,IS_FAQ
           ,RELATION_HELP_ID
           ,HELP_LIKE_COUNT
           ,RECORDER_DOMAIN
           ,RECORDER_EMAIL
           ,NEWS)
     VALUES
           (<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.help_head#' null="#len(arguments.help_head)?'no':'yes'#">
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.help_topic#' null="#len(arguments.help_topic)?'no':'yes'#">
           ,NULL
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.help_fuseaction#'>
           ,#now()#
           ,NULL
           ,NULL
           ,'#cgi.REMOTE_ADDR#'
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.recorder_name#' null="#len(arguments.recorder_name)?'no':'yes'#">
           ,'TR'
           ,NULL
           ,0
           ,0
           ,NULL
           ,0
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.recorder_domain#' null="#len(arguments.recorder_domain)?'no':'yes'#">
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.recorder_email#' null="#len(arguments.recorder_email)?'no':'yes'#">
           ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.is_news#'>
           )
        </cfquery>
    </cffunction>

    <cffunction name="update" access="public">
        <cfargument name="help_fuseaction" default="">
        <cfargument name="help_id">
        <cfargument name="help_head" default="">
        <cfargument name="help_topic" default="">
        <cfargument name="is_new" default="">
        <cfquery name="query_update_tour" datasource="#dsn#">
            UPDATE 
                HELP_DESK 
            SET 
                HELP_HEAD = <cfqueryparam cfsqltype='CF_SQL_VARCHAR' value='#arguments.help_head#' null="#len(arguments.help_head)?'no':'yes'#">,
                HELP_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.help_fuseaction#'null="#len(arguments.help_fuseaction)?'no':'yes'#">,
                HELP_TOPIC = <cfqueryparam cfsqltype='CF_SQL_VARCHAR' value='#arguments.help_topic#' null="#len(arguments.help_topic)?'no':'yes'#">,               
                UPDATE_DATE =<cfqueryparam cfsqltype='CF_SQL_DATE' value='#now()#'>,
                UPDATE_IP = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cgi.REMOTE_ADDR#">,
                UPDATE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                <cfif len(arguments.is_new)>,NEWS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.is_new#'></cfif>
            WHERE 
                HELP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.help_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="delete" access="public">
        <cfargument name="help_id">

        <cfquery name="query_delete_tour" datasource="#dsn#">
            DELETE FROM HELP_DESK WHERE HELP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.help_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="getlist" access="public">
        <cfargument name="help_fuseaction">

        <cfquery name="query_list" datasource="#dsn#">
            SELECT * FROM HELP_DESK WHERE HELP_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.help_fuseaction#'>
            
        </cfquery>
        

        <cfreturn query_list>
    </cffunction>
    <cffunction name="getlists" access="public">
        <cfargument name="help_fuseaction">
        <cfargument name="keyword">
        <cfargument name="news" default="">

        <cfquery name="query_list" datasource="#dsn#">
            WITH CTE1 AS(
                SELECT 
                    *
                FROM 
                    HELP_DESK 
                WHERE 
                    1=1 
                    <cfif len(arguments.help_fuseaction)>
                        AND HELP_FUSEACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.help_fuseaction#%'>
                    </cfif>
                    <cfif len(arguments.keyword)>
                        AND HELP_HEAD LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.keyword#%'> OR HELP_TOPIC LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.keyword#%'> OR HELP_FUSEACTION LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.keyword#%'>
                    </cfif>
                    <cfif arguments.news eq 1>
                        AND NEWS =1
                    </cfif>
            ),
            CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (ORDER BY RECORD_DATE DESC) AS RowNum
                FROM
                    CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
          
        </cfquery>

        <cfreturn query_list>
        
    </cffunction>

    <cffunction name="getitem" access="public">
        <cfargument name="help_id">

        <cfquery name="query_item" datasource="#dsn#">
            SELECT HELP_ID, HELP_FUSEACTION, HELP_LIKE_COUNT, HELP_TOPIC, HELP_HEAD, RECORDER_DOMAIN, RECORDER_EMAIL, RECORDER_NAME, NEWS
            FROM HELP_DESK WHERE HELP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.help_id#'>
        </cfquery>
        <cfreturn query_item>
    </cffunction>

</cfcomponent>