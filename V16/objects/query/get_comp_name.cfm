<cfquery name="GET_COMP_NAME" datasource="#dsn#">
	SELECT
		NICKNAME,
		FULLNAME
	FROM
		COMPANY
	WHERE
		COMPANY_ID = #attributes.COMPANY_ID#
</cfquery>
