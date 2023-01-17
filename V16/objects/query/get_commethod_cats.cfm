<cfquery name="GET_COMMETHOD_CATS" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_COMMETHOD
	ORDER BY
		COMMETHOD
</cfquery>
