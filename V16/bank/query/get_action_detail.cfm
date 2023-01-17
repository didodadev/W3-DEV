<cfif not isdefined("db_adres")>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfif (session.ep.isBranchAuthorization)>
	<cfquery name="get_all_cash" datasource="#dsn2#">
		SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
	</cfquery>
	<cfset cash_list = valuelist(get_all_cash.cash_id)>
	<cfif not listlen(cash_list)><cfset cash_list = 0></cfif>
	<cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
</cfif>
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT
		*
	FROM
		#ATTRIBUTES.TABLE_NAME#
	WHERE
		ACTION_ID=#URL.ID#
	<cfif (session.ep.isBranchAuthorization)>
		AND	(TO_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR FROM_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
	</cfif>
</cfquery>

