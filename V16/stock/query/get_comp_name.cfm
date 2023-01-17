<cfquery name="get_comp_name" datasource="#DSN#">
	SELECT
		NICKNAME AS COMPANY_NAME
	FROM
		COMPANY
	WHERE
		COMPANY_ID=#COMP_ID#
</cfquery>

