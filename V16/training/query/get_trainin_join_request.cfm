<cfquery name="get_trainin_join_request" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_REQUEST_ROWS
	WHERE
		REQUEST_ROW_ID = #attributes.REQUEST_ID#
</cfquery>
