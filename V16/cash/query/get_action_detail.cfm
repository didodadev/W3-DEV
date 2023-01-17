<cfif not isdefined("db_adres")><cfset db_adres = "#dsn2#"></cfif>
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT
		*
	FROM
		#attributes.table_name#
	WHERE
		ACTION_ID = #attributes.id#
	<cfif session.ep.isBranchAuthorization>
		AND
		(
				(CASH_ACTION_FROM_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)) OR
				CASH_ACTION_TO_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)))
		)
	</cfif>		
</cfquery>
