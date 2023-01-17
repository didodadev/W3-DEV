<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		*
	FROM
		COMPANY
	WHERE 
		COMPANY_ID = #attributes.company_id#
</cfquery>
