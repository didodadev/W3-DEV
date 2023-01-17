<cfif fusebox.use_period eq true>
    <cfset dsn_expense = dsn2>
<cfelse>
    <cfset dsn_expense = dsn>
</cfif>
<cfquery name="GET_EXPENSE" datasource="#dsn_expense#">
	SELECT
		*
	FROM
		EXPENSE_CENTER
		WHERE 
			EXPENSE_ID = #attributes.EXPENSE_ID#
</cfquery>
