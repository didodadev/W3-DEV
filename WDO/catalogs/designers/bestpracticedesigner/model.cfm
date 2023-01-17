<cffunction name="list_bp">
    <cfargument name="keyword" default="">
    <cfquery name="query_list_bp" datasource="#dsn#">
        SELECT * FROM WRK_BESTPRACTICE 
        <cfif len(arguments.keyword)>
        WHERE BESTPRACTICE_NAME LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.keyword#%'>
        </cfif>
    </cfquery>

    <cfreturn query_list_bp>
</cffunction>

<cffunction name="get_bp">
    <cfargument name="id" type="numeric">

    <cfquery name="query_get_bp" datasource="#dsn#">
        SELECT * FROM WRK_BESTPRACTICE WHERE BESTPRACTICE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
    </cfquery>

    <cfreturn query_get_bp>
</cffunction>

<cffunction name="insert_bp">
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
    <cfargument name="icon_path" type="string">
    <cfargument name="publish_date" type="string">

    <cfquery name="query_insert_bp" result="qresult_insert_bp" datasource="#dsn#">
        INSERT INTO WRK_BESTPRACTICE ( 
            BESTPRACTICE_NAME, 
            BESTPRACTICE_DETAIL, 
            BESTPRACTICE_AUTHOR, 
            BESTPRACTICE_AUTHORID,
            BESTPRACTICE_PRODUCT_ID,
            BESTPRACTICE_FILE_PATH,
            BESTPRACTICE_LICENSE,
            BESTPRACTICE_IS_ACTIVE,
            BESTPRACTICE_STAGE,
            BESTPRACTICE_SECTORS,
            BESTPRACTICE_PRODUCT_CODE, 
            BESTPRACTICE_ICON_PATH,
            BESTPRACTICE_PUBLISH_DATE,
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP 
        )
        VALUES (
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.name#'>,
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
            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.icon_path#'>, 
            <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.publish_date#'>, 
            #session.ep.userid#, 
            #now()#, 
            '#cgi.REMOTE_ADDR#' 
        )
    </cfquery>

    <cfreturn qresult_insert_bp.GENERATEDKEY>
</cffunction>

<cffunction name="update_bp">
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
    <cfargument name="icon_path" type="string">
    <cfargument name="publish_date" type="string">

    <cfquery name="query_update_bp" datasource="#dsn#">
        UPDATE WRK_BESTPRACTICE SET 
        BESTPRACTICE_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.name#'>
        <cfif isDefined("arguments.detail")> , BESTPRACTICE_DETAIL = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detail#'></cfif>
        , BESTPRACTICE_AUTHOR = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
        , BESTPRACTICE_AUTHORID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.authorid#'>
        , BESTPRACTICE_PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'>
        , BESTPRACTICE_FILE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#' null="#iif(len(arguments.file_path), de("no"), de("yes"))#">
        , BESTPRACTICE_LICENSE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
        , BESTPRACTICE_IS_ACTIVE = <cfqueryparam cfsqltype='CF_SQL_BIT' value='#arguments.is_active#'>
        <cfif arguments.process_stage neq 0> , BESTPRACTICE_STAGE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_stage#'></cfif>
        , BESTPRACTICE_SECTORS = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.sector_cats#'>
        , BESTPRACTICE_PRODUCT_CODE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.workcube_product_code#'>
        , BESTPRACTICE_ICON_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.icon_path#'>
        , BESTPRACTICE_PUBLISH_DATE = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.publish_date#'>
        , UPDATE_EMP = #session.ep.userid#
        , UPDATE_DATE = #now()#
        , UPDATE_IP = '#cgi.REMOTE_ADDR#'
        WHERE BESTPRACTICE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
    </cfquery>

</cffunction>

<cffunction name="update_bp_file_path">
    <cfargument name="id" type="numeric">
    <cfargument name="file_path" type="string">
    <cfquery name="query_update_bp_file_path" datasource="#dsn#">
        UPDATE WRK_BESTPRACTICE SET BESTPRACTICE_FILE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
        WHERE BESTPRACTICE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
    </cfquery>
</cffunction>