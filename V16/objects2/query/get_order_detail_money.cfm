<cfquery name="GET_COMP_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND RATE1=1 AND RATE2=1
</cfquery>
<cfset str_money_bskt_func = get_comp_money.money>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY, RATE1, RATE2, RATEPP2, RATEWW2, DSP_RATE_SALE, COMPANY_ID FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
</cfquery>
<cfquery name="GET_STDMONEY" dbtype="query">
	SELECT MONEY FROM GET_MONEY WHERE RATE2 = RATE1
</cfquery>
<cfquery name="GET_MONEY_MONEY2" dbtype="query">
	SELECT 
		RATE1,
		<cfif isDefined("session.pp")>
			RATEPP2 RATE2
		<cfelseif isDefined("session.ww")>
			RATEWW2 RATE2
		<cfelse>
			RATE2
		</cfif>	
	FROM 
		GET_MONEY
	WHERE 
		MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money2#"> AND
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
</cfquery>
