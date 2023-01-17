<cfquery name="GET_SUPPORT_DETAIL" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_SUPPORT
	WHERE
		SUPPORT_ID = #URL.ID#
</cfquery>

