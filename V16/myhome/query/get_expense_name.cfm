<cfquery name="GET_EXPENSE_NAME" datasource="#dsn2#">
	SELECT 
		EXPENSE,EXPENSE_ID
	FROM 
		EXPENSE_CENTER
	WHERE 
		EXPENSE_ID= #GET_TIME_COST.EXPENSE_ID#
</cfquery>
