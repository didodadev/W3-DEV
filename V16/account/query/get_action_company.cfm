<cfquery name="GET_ACTION_COMPANY" datasource="#dsn#">
	SELECT 
		FULLNAME
	FROM
		COMPANY
	WHERE
		COMPANY_ID=#COMPANY_ID#
</cfquery>

