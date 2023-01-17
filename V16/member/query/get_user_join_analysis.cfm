<cfquery name="GET_USER_JOIN_ANALYSIS" datasource="#dsn#">
	SELECT 
		RESULT_ID
	FROM 
		MEMBER_ANALYSIS_RESULTS
	WHERE
		<cfif isDefined("SESSION.memberid")>
		PARTNER_ID = #SESSION.memberid#
	AND
		</cfif> 
		ANALYSIS_ID = #attributes.ANALYSIS_ID#
</cfquery>
