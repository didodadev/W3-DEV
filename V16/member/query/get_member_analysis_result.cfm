<cfquery name="GET_MEMBER_ANALYSIS_RESULT" datasource="#DSN#">
	SELECT
		RESULT_ID,
		PARTNER_ID
	FROM	
		MEMBER_ANALYSIS_RESULTS
	WHERE
		ANALYSIS_ID = #analysis_id# AND
		PARTNER_ID = #attributes.pid#
</cfquery>
