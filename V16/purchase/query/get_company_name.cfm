<cfquery name="GET_COMPANY_NAME" datasource="#dsn#">
	SELECT 
		COMPANY_ID,
		FULLNAME,
		NICKNAME
	FROM 
		COMPANY
	WHERE
		COMPANY_ID = #attributes.COMPANY_ID#
</cfquery>
