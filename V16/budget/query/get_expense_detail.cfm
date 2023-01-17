<cfquery name="EXPENSE" datasource="#dsn2#">
	SELECT
		EXPENSE_ID,
		#dsn#.Get_Dynamic_Language(EXPENSE_ID,'#session.ep.language#','EXPENSE_CENTER','EXPENSE',NULL,NULL,EXPENSE) AS EXPENSE,
		*
	FROM
		EXPENSE_CENTER
	WHERE
		EXPENSE_ID = #attributes.EXPENSE_ID#
</cfquery>
