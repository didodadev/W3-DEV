<cfquery name="GET_CONSUMER_ANALYSIS_RESULT" datasource="#dsn#">
	SELECT
		RESULT_ID, CONSUMER_ID
	FROM	
		MEMBER_ANALYSIS_RESULTS
	WHERE
		ANALYSIS_ID = #ANALYSIS_ID#
	AND
		CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.CID#)
</cfquery>

