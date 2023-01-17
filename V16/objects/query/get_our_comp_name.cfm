<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
	SELECT
		NICK_NAME
	FROM
		OUR_COMPANY
	WHERE
		COMP_ID = #attributes.comp_id#
</cfquery>
