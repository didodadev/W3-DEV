<cfquery name="get_companies" datasource="#DSN#">
	SELECT
		NICK_NAME,
		COMPANY_NAME,
		COMP_ID
	FROM
		OUR_COMPANY
</cfquery>
