<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 23/05/2016			Dev Date	: 23/05/2016		
Description :
	Bu utility banka hesapları selectboxı bulunan bazı sayfalarda kullanılır. applicationStart methodunda create edilir.
	
Patameters :
		moneyType					
		 değerlerini alır.

Used : bankAccounts = bankAccounts.get('TL');
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
    	<cfargument name="moneyType" type="string" default="" hint="Para Birimi">
		<cfquery name="bankAccounts" datasource="#dsn3#">
            SELECT 
                ACCOUNT_ID, 
                ACCOUNT_NAME,
                ACCOUNT_CURRENCY_ID
            FROM 
                ACCOUNTS
            WHERE
                ACCOUNT_STATUS = 1
                <cfif len(moneyType)>
	                AND ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moneyType#">
                </cfif>
                <cfif session.ep.isBranchAuthorization>
                    AND ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
                </cfif>
            ORDER BY 
                ACCOUNT_NAME
        </cfquery>
		<cfreturn bankAccounts>
	</cffunction>
</cfcomponent>