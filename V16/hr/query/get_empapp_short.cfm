<cfquery name="get_empapp_short" datasource="#dsn#">
	SELECT
		NAME,
		SURNAME,
		APP_POSITION
	FROM
		EMPLOYEES_APP
	WHERE
		EMPAPP_ID = #attributes.EMPAPP_ID#
</cfquery>
