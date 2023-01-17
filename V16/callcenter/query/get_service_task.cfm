<cfquery name="GET_SERVICE_TASK" datasource="#dsn#">
	SELECT 
		*
	FROM
		PRO_WORKS
	WHERE
		G_SERVICE_ID = #attributes.service_id#
</cfquery>
