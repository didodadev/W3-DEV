<cfquery name="GET_ANALYSIS" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		MEMBER_ANALYSIS
	WHERE
		ANALYSIS_ID = #attributes.analysis_id#
</cfquery>
