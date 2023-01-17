<!---
File: fuseaction_properties.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: -
Description: Get Fuseaction Properties Function
Date: 23/10/2019
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_fuseaction_property" access="public" returntype="query">
        <cfargument name="company_id">
        <cfargument name="fuseaction_name">
        <cfargument name="property_name">
        <cfargument name="datasource_name" default="#dsn#">
        <cfquery name="get_fuseaction_property" datasource="#arguments.datasource_name#">
            SELECT 
                PROPERTY_VALUE,
                PROPERTY_NAME
            FROM
                #dsn#.FUSEACTION_PROPERTY
            WHERE
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuseaction_name#">  AND
                PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.property_name#"> 
        </cfquery>
        <cfreturn get_fuseaction_property>
    </cffunction>
	<cffunction name="get_project" access="public" returntype="query">
        <cfquery name="get_project" datasource="#dsn#">
            SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS
        </cfquery>
        <cfreturn get_project>
    </cffunction>
</cfcomponent>