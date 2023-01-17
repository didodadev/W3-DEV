<cfcomponent extends="WMO.functions">
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cfset dsn1 = dsn_product = dsn1_alias = '#dsn#_product' />
    <cfset dsn2 = dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session.ep.company_id#' />
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cffunction name="get_recycle_group" returntype="query">
        <cfargument name="keyword" default="">
        <cfquery name="get_recycle_group" datasource="#dsn#">
            SELECT 
            RSG.RECYCLE_SUB_GROUP_ID AS SUB_GROUP_ID
            ,RG.RECYCLE_GROUP_ID AS MAIN_GROUP_ID
            ,RG.RECYCLE_GROUP AS MAIN_GROUP
            ,*
            FROM RECYCLE_SUB_GROUP RSG
              LEFT JOIN RECYCLE_GROUP RG ON RG.RECYCLE_GROUP_ID = RSG.RECYCLE_GROUP_ID
            WHERE
            1=1
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
              AND  RSG.RECYCLE_SUB_GROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
            </cfif>
        </cfquery>
        <cfreturn get_recycle_group>
    </cffunction>
</cfcomponent>