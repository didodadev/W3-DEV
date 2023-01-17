<cfquery name="get_trainin_join_request" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_JOIN_REQUESTS
	WHERE
		TRAINING_JOIN_REQUEST_ID=#attributes.REQUEST_ID#
</cfquery>
