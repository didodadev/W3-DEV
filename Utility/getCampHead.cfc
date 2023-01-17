<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 20/05/2016			Dev Date	: 03/06/2016		
Description :
	Bu utility kampanyaya  ait başlık bilgisini getirir applicationStart methodunda create edilir.
	

----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Kampanya ID">
        
		<cfquery name="get" datasource="#dsn3#">
            SELECT CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>