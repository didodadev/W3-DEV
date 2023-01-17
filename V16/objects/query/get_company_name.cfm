<cfquery name="get_company_name" datasource="#DSN#">
	SELECT
		NICK_NAME
	FROM
		OUR_COMPANY
	WHERE
		COMP_ID=#attributes.COMP_ID#
</cfquery>
