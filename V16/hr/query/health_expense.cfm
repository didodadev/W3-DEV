<!---
File: health_expence.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 26.11.2019
Controller: -
Description: 
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="GET_HEALTH_EXPENSE_ITEM_PLANS" access="remote"  returntype="any">
        <cfargument name="expense_id" default=""> 
        <cfquery name="GET_HEALTH_EXPENSE_ITEM_PLANS" datasource="#dsn3#">
            SELECT
                *
            FROM   
                EXPENSE_ITEM_PLANS
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_ITEM_PLANS>
    </cffunction>
</cfcomponent>