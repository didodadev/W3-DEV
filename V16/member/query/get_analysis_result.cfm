<cfquery name="GET_ANALYSIS_RESULT" datasource="#dsn#">
	SELECT 
		*
	FROM 
		MEMBER_ANALYSIS_RESULTS
	WHERE
		ANALYSIS_ID = #attributes.ANALYSIS_ID#
</cfquery>
