<cfif not isdefined("temp_dsn")>
	<cfset temp_dsn = "#dsn2#">
</cfif>
<cfquery name="GET_EXPENSE_CENTER" datasource="#temp_dsn#">
	SELECT
		EXPENSE_ID,
		EXPENSE
	FROM
		EXPENSE_CENTER
	WHERE
		EXPENSE_ACTIVE = 1
	ORDER BY
		EXPENSE
</cfquery>
