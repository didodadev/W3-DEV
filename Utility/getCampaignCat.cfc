<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility kampanya kategorilerini getirir applicationStart methodunda create edilir.
	
Patameters :
		camp_type :Kampanya tipi bu değere göre kategoriler gelir.

Used : getCampaignCat.get(camp_type:23);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="camp_type" type="numeric" default="0" required="yes" hint="Kampanya tipi bu değere göre kategoriler gelir">
        
		<cfquery name="get" datasource="#DSN3#">
            SELECT 
            	CAMP_CAT_ID,
                CAMP_CAT_NAME 
            FROM 
            	CAMPAIGN_CATS 
            WHERE 
            	CAMP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_type#"> 
            ORDER BY 
            	CAMP_CAT_NAME
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>