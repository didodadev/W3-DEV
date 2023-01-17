<cfquery name="GET_ACC_BRANCH" datasource="#dsn3#">
	SELECT 
		BANK_NAME,
		BANK_BRANCH_NAME
	FROM
		BANK_BRANCH
	WHERE
		BANK_BRANCH_ID = #BRANCH_ID#
</cfquery>
