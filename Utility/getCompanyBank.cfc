<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 20/05/2016			Dev Date	: 03/06/2016		
Description :
	Bu utility Şirket Bankalarına  ait bilgileri getirir applicationStart methodunda create edilir.
	

----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="company_id" type="numeric" default="0" required="yes" hint="Company ID>">
        <cfargument name="consumer_id" type="numeric" default="0" required="yes" hint="Consumer ID">
        <cfargument name="currency_id" type="string" default="0" required="yes" hint="Para Birimi">
		<cfquery name="get" datasource="#dsn2#">
            SELECT
                COMPANY_BANK_ID MEMBER_BANK_ID
             FROM
                #dsn#.COMPANY_BANK
            WHERE
            	<cfif arguments.consumer_id eq 0>
                	COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_id#">
                <cfelse>
                	CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.consumer_id#">
                </cfif>
                AND COMPANY_ACCOUNT_DEFAULT = 1
                AND COMPANY_BANK_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currency_id#">
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>