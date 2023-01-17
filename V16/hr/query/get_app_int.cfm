
<cfquery name="GET_APP_INT" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_APP_INTERVIEWS
	WHERE
		INT_ID = #attributes.INT_ID#
</cfquery>
