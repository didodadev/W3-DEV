<cfquery name="GET_APP_INTS" datasource="#dsn#">
	SELECT
		INT_ID,
		RECORD_DATE
	FROM
		EMPLOYEES_APP_INTERVIEWS
	WHERE
		EMPAPP_ID = #attributes.EMPAPP_ID#
</cfquery>
