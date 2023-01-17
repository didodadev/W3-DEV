<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan	
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Şirketleri getirir.
	
Patameters :


----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="company_id" type="numeric" default="0" required="yes">
        
		<cfquery name="get" datasource="#dsn#">
            SELECT MEMBER_CODE, FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>