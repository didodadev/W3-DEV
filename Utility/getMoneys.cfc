<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu
Analys Date : 19/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility ilgili periyottaki para birimlerini getirir
	
Patameters :
		periodId : Döenm ID'sini alır
								
		 değerlerini alır.

Used : getMoney.get(periodId:1);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="periodId" type="numeric" default="0" required="yes">
        
        <cfquery name="GET_MONEYS" datasource="#dsn#">
            SELECT 
            	MONEY_ID, 
                MONEY 
			FROM 
            	SETUP_MONEY 
			WHERE 
            	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodId#">
        </cfquery>
        
		<cfreturn GET_MONEYS>
	</cffunction>
</cfcomponent>