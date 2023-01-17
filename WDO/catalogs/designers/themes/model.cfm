<cffunction name="list_theme">
    <cfargument name="keyword" default="">
    <cfquery name="query_list_theme" datasource="#dsn#">
        SELECT * FROM WRK_THEME 
        <cfif len(arguments.keyword)>
        WHERE THEME_NAME LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.keyword#%'>
        </cfif>
    </cfquery>

    <cfreturn query_list_theme>
</cffunction>

<cffunction name="get_theme">
    <cfargument name="id" type="numeric">

    <cfquery name="query_get_theme" datasource="#dsn#">
        SELECT * FROM WRK_THEME WHERE THEME_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
    </cfquery>

    <cfreturn query_get_theme>
</cffunction>

<cffunction name="insert_theme">
    <cfargument name="theme_name" type="string">
    <cfargument name="detail" type="any">
    <cfargument name="author" type="string">
    <cfargument name="authorid" type="numeric">
    <cfargument name="product_id" type="numeric">
    <cfargument name="file_path" type="string">
    <cfargument name="license" type="numeric">
    <cfargument name="is_active" type="boolean">
    <cfargument name="process_stage" type="numeric" default="0">
    <cfargument name="sector_cats" type="string">
    <cfargument name="workcube_product_code" type="string">
    <cfargument name="preview_path" type="string">
    <cfargument name="publish_date" type="string">

    <cfquery name="query_insert_theme" result="qresult_insert_theme" datasource="#dsn#">
        INSERT INTO WRK_THEME ( 
            THEME_NAME, 
            THEME_DETAIL, 
            THEME_AUTHOR, 
            THEME_AUTHORID,
            THEME_PRODUCT_ID,
            THEME_FILE_PATH,
            THEME_LICENSE,
            THEME_IS_ACTIVE,
            THEME_STAGE,
            THEME_SECTORS,
            THEME_PRODUCT_CODE,
            THEME_PUBLISH_DATE,
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP 
        )
        VALUES (
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.theme_name#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detail#' null="#iif(isDefined("arguments.detail"), de("no"), de("yes"))#">,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>,
            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.authorid#'>,
            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'>,
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#' null="#iif(len(arguments.file_path), de("no"), de("yes"))#">, 
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>, 
            <cfqueryparam cfsqltype='CF_SQL_BIT' value='#arguments.is_active#'>, 
            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_stage#' null="#iif(arguments.process_stage neq 0, de("no"), de("yes"))#">, 
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.sector_cats#'>, 
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.workcube_product_code#'>, 
            <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.publish_date#'>, 
            #session.ep.userid#, 
            #now()#, 
            '#cgi.REMOTE_ADDR#'
        )
    </cfquery>

    <cfreturn qresult_insert_theme.GENERATEDKEY>
</cffunction>

<cffunction name="update_theme">
    <cfargument name="id" type="numeric">
    <cfargument name="name" type="string">
    <cfargument name="detail" type="any">
    <cfargument name="author" type="string">
    <cfargument name="authorid" type="numeric">
    <cfargument name="product_id" type="numeric">
    <cfargument name="file_path" type="string">
    <cfargument name="license" type="numeric">
    <cfargument name="is_active" type="boolean">
    <cfargument name="process_stage" type="numeric" default="0">
    <cfargument name="sector_cats" type="string">
    <cfargument name="workcube_product_code" type="string">
    <cfargument name="publish_date" type="string">
    <cfquery name="query_update_theme" datasource="#dsn#">
        UPDATE WRK_THEME SET 
        THEME_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.theme_name#'>
        <cfif isDefined("arguments.detail")> , THEME_DETAIL = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detail#'></cfif>
        , THEME_AUTHOR = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
        , THEME_AUTHORID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.authorid#'>
        , THEME_PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'>
        , THEME_FILE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#' null="#iif(len(arguments.file_path), de("no"), de("yes"))#">
        , THEME_LICENSE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
        , THEME_IS_ACTIVE = <cfqueryparam cfsqltype='CF_SQL_BIT' value='#arguments.is_active#'>
        <cfif arguments.process_stage neq 0> , THEME_STAGE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_stage#'></cfif>
        , THEME_SECTORS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.sector_cats#'>
        , THEME_PRODUCT_CODE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.workcube_product_code#'>
        , THEME_PUBLISH_DATE = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.publish_date#'>
        , UPDATE_EMP = #session.ep.userid#
        , UPDATE_DATE = #now()#
        , UPDATE_IP = '#cgi.REMOTE_ADDR#'
        WHERE THEME_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
    </cfquery>

</cffunction>

<cffunction name="update_theme_file_path">
    <cfargument name="id" type="numeric">
    <cfargument name="file_path" type="string">
    <cfquery name="query_update_theme_file_path" datasource="#dsn#">
        UPDATE WRK_THEME SET THEME_FILE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
        WHERE THEME_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
    </cfquery>
</cffunction>