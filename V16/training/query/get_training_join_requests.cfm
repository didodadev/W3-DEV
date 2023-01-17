<cfquery name="GET_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		TRAINING_JOIN_REQUESTS
	WHERE
		TRAINING_ID=#attributes.request_id#
</cfquery>

