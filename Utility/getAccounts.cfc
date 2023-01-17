<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
    
	<cffunction name="get" access="public" returntype="any"> 
		<cfargument name="system_money_info" type="string" required="no" default="" hint="Toplu İşlem ID">
        <cfargument name="account_status" type="numeric" required="no" default="0" hint="İşlem ID">
        <cfargument name="branch_id" type="numeric" required="no" default="0" hint="Talimat ID">
        <cfargument name="keyword" type="string" required="no" default="" hint="Talimat ID">
        <cfargument name="acc_type" type="string" required="no" default="" hint="Datasource Name">
        <cfargument name="money_info" type="string" required="no" default="" hint="Talimat ID">
        <cfargument name="account_id_" type="string" required="no" default="" hint="Talimat ID">
        
        <cfquery name="get" datasource="#dsn3#">
            SELECT
                ACCOUNTS.ACCOUNT_NAME,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID,
            </cfif>
                ACCOUNTS.ACCOUNT_ID,
                BANK_BRANCH.BANK_NAME
            FROM
                ACCOUNTS
                LEFT JOIN BANK_BRANCH ON  ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
            WHERE
                1=1
            <cfif session.ep.period_year lt 2009>
                AND (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')  
                <cfif len(arguments.system_money_info)>AND ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL'</cfif><!--- sadece sistem para birimi olanlarda --->
            <cfelse>
                AND ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2#.SETUP_MONEY) 
                <cfif len(arguments.system_money_info)>AND ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"></cfif><!--- sadece sistem para birimi olanlarda --->
            </cfif>
            <cfif arguments.account_status neq 0>
                AND ACCOUNT_STATUS = 1
            </cfif>	
            <cfif arguments.branch_id neq 0>
                AND ACCOUNTS.ACCOUNT_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
            </cfif>
            <cfif len(arguments.keyword)>
                AND ACCOUNTS.ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
            </cfif>
            <cfif  len(arguments.acc_type)>
                AND ACCOUNTS.ACCOUNT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_type#">
            </cfif>
            <cfif  len(arguments.money_info)>
                AND ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money_info#">
            </cfif>
            <cfif len(arguments.account_id_)>
                AND ACCOUNTS.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_id_#">
            </cfif>
            <cfif session.ep.isBranchAuthorization >
                AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#">) 
            </cfif>
            ORDER BY
                BANK_BRANCH.BANK_NAME,
                ACCOUNTS.ACCOUNT_NAME
        </cfquery>

        
		<cfreturn get>
	</cffunction>
</cfcomponent>