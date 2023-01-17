<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 20/05/2016			Dev Date	: 03/06/2016		
Description :
	Bu utility Account a ait bilgileri getirir applicationStart methodunda create edilir.
	

----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        
		<cfquery name="get" datasource="#dsn2#">
			SELECT ACCOUNT_ORDER_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.account_id#">
		</cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>