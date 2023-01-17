<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 19/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility CASH_ACTION tablosunda kayıtlı banka işlemlerini getirir applicationStart methodunda create edilir.
	
Patameters :
		id :  default olarak 0 gelir ve CASH_ACTIONS tablosundaki kayıtları getirir . Değer girildiği zaman CASH_ACTION tablosunda kayıtlı banka işlemini getirir

Used : getCashAction.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
	<cffunction name="get" access="public" returntype="query">
    	<cfargument name="id"  type="numeric" default="0" required="yes">
        
		<cfquery name="get" datasource="#dsn2#">
            SELECT 
            	ACTION_ID 
            FROM 	
            	CASH_ACTIONS 
            WHERE 
            	1=1
                <cfif arguments.id neq 0>
            		AND BANK_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
                </cfif>
        </cfquery>
        
        <cfreturn get>
    </cffunction>
</cfcomponent>