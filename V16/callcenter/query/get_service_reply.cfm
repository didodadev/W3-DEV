<cfquery name="GET_SERVICE_REPLY" datasource="#dsn#">
	SELECT 
		*
	FROM
		G_SERVICE_REPLY
	WHERE
		SERVICE_ID=#SERVICE_ID#
</cfquery>
