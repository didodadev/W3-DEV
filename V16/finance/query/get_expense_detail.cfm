<cfquery name="EXPENSE" datasource="#dsn2#">
	SELECT
		*
	FROM
		EXPENSE_CENTER
	WHERE
		EXPENSE_ID=#attributes.EXPENSE_ID#
</cfquery>
