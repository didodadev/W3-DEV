<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GetMetaLang" access="public" returntype="query">
        <cfargument name="action_id" default="">
        <cfargument name="action_type" default="">
        <cfargument name="language_id" default="">
        <cfargument name="meta_desc_id" default="">
        <cfquery name="get_meta_lang" datasource="#dsn#">
            SELECT
                LANGUAGE_SHORT
            FROM 
                META_DESCRIPTIONS 
            WHERE 
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#"> AND
                LANGUAGE_SHORT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">AND
                META_DESC_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.meta_desc_id#">
        </cfquery>
        <cfreturn get_meta_lang>
    </cffunction> 
      <cffunction name="GetAddMetaLang" access="public" returntype="query">
        <cfargument name="action_id" default="">
        <cfargument name="action_type" default="">
        <cfargument name="language_id" default="">
        <cfquery name="GetAddMetaLang" datasource="#dsn#">
            SELECT 
               LANGUAGE_SHORT
            FROM
               META_DESCRIPTIONS
            WHERE 
               ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
               ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#"> AND
               LANGUAGE_SHORT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">
        </cfquery>
        <cfreturn GetAddMetaLang>
    </cffunction> 
    <cffunction name="GetAddMetaDescriptions" access="public">
        <cfargument name="action_type" default="">
        <cfargument name="action_id" default="">
        <cfargument name="meta_title" default="">
        <cfargument name="meta_desc" default="">
        <cfargument name="meta_keywords" default="">
        <cfargument name="language_id" default="">
        <cfargument name="faction_type" default="">
        <cfquery name="get_add_meta_descriptions" datasource="#DSN#">
            INSERT INTO
                META_DESCRIPTIONS
            (
                ACTION_TYPE,
                ACTION_ID,
                META_TITLE,
                META_DESC_HEAD,
                META_KEYWORDS,
                LANGUAGE_SHORT,
                <!---PERIOD_ID,--->
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP,
                FUSEACTION
            )	
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(arguments.action_type)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta_title#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta_desc#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta_keywords#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">,
                <!---#session.ep.period_id#,--->        
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.faction_type#">
            )
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="GetUpdMetaDescriptions" access="public">
        <cfargument name="meta_title" default="">
        <cfargument name="meta_desc" default="">
        <cfargument name="meta_keywords" default="">
        <cfargument name="language_id" default="">
        <cfargument name="meta_desc_id" default="">
        <cfquery name="get_upd_meta_descriptions" datasource="#DSN#">
            UPDATE 
                META_DESCRIPTIONS
            SET
                META_TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta_title#">,
                META_DESC_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta_desc#">,
                META_KEYWORDS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta_keywords#">,
                LANGUAGE_SHORT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                UPDATE_EMP = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE
                META_DESC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.meta_desc_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="GetContent" access="public" returntype="query">
        <cfargument name="action_id" default="">
        <cfquery name="get_content" datasource="#DSN#">
            SELECT
                CONTENT_ID
            FROM
                CONTENT
            WHERE 
                STAGE_ID = -2 AND
                CONTENT_STATUS = 1 AND
                CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> 
        </cfquery>
        <cfreturn  get_content>
    </cffunction> 
    <cffunction name="GetDelContents" access="public">
        <cfargument name="action_id" default="">
        <cfquery name="get_del_contents" datasource="#DSN#">
            DELETE FROM 
                CONTENT_KEYWORDS 
            WHERE 
                CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> 
        </cfquery>
        <cfreturn>
    </cffunction>
   <cffunction name="AddKeyword" access="public">
        <cfargument name="action_id" default="">
        <cfargument name="meta_keywords" default="">
        <cfquery name="add_keyword" datasource="#DSN#">
            INSERT INTO
                CONTENT_KEYWORDS
                (
                    CONTENT_ID,
                    KEYWORD
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#EncodeForHTML(arguments.meta_keywords)#">
                )
        </cfquery>
        <cfreturn>
    </cffunction>

    <!--- upd_meta_desc --->
    <cffunction name="GetMetaDesc" access="public" returntype="query">
        <cfargument name="meta_desc_id" default="">
        <cfquery name="get_meta_desc" datasource="#DSN#">
            SELECT
                ACTION_TYPE, 
                ACTION_ID, 
                LANGUAGE_SHORT, 
                FUSEACTION, 
                META_TITLE, 
                META_DESC_HEAD, 
                META_KEYWORDS, 
                RECORD_EMP, 
                RECORD_DATE, 
                UPDATE_EMP, 
                UPDATE_DATE 
            FROM  
                META_DESCRIPTIONS 
            WHERE
                META_DESC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.meta_desc_id#">
        </cfquery>
        <cfreturn get_meta_desc>
    </cffunction>
     <!--- upd_meta_desc --->
    <cffunction name="Get_Language" access="public" returntype="query">
        <cfquery name="get_language" datasource="#DSN#">
            SELECT 
                LANGUAGE_ID, 
                LANGUAGE_SHORT, 
                LANGUAGE_SET 
            FROM 
                SETUP_LANGUAGE
        </cfquery>  
        <cfreturn get_language>
    </cffunction>
    <cffunction name="GetMetaDescList" access="public" returntype="query">
        <cfargument name="action_id" default="">
        <cfargument name="action_type" default="">
        <cfquery name="get_meta_desc_list" datasource="#DSN#">
            SELECT 
                MD.META_DESC_ID,
                MD.RECORD_DATE,
                MD.META_TITLE,
                SL.LANGUAGE_SET
            FROM 
                META_DESCRIPTIONS MD,
                SETUP_LANGUAGE SL
            WHERE 
                MD.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                <cfif isdefined('arguments.action_type') and len(arguments.action_type)>
                    AND MD.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.action_type)#">
                </cfif>
                AND MD.LANGUAGE_SHORT = SL.LANGUAGE_SHORT
        </cfquery>
        <cfreturn get_meta_desc_list>
    </cffunction>
</cfcomponent>
