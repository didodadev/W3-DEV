<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 20/05/2016			Dev Date	: 20/05/2016		
Description :
	Bu utility bireysel üyeye ait bilgileri getirir applicationStart methodunda create edilir.
	
Patameters :
		consumerId : Bireysel üye ıd.

Used : getConsumerInfo.get(consumerId:23);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="consumerId" type="numeric" default="0" required="yes" hint="Bireysel Üye ID">
        
		<cfquery name="get" datasource="#DSN#">
            SELECT 
                CONSUMER_ID,
                CONSUMER_NAME,
                CONSUMER_SURNAME,
                CONSUMER_EMAIL 
            FROM 
                CONSUMER 
            WHERE 
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumerId#">
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>