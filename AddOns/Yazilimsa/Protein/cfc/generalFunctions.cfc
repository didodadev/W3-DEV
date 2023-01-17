<!---
    File :          AddOns\Yazilimsa\Protein\cfc\generalFunctions.cfc
    Author :        Emine Yılmaz
    Date :          28.06.2022
    Description :   Protein xml için queryler
--->
<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="our_company" access="remote" returntype="query">
        <cfquery name="our_company" datasource="#dsn#">
            SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY
        </cfquery>
        <cfreturn our_company>
    </cffunction>     
</cfcomponent>