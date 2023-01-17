<cfquery name="GET_ANALYSIS_QUESTIONS" datasource="#DSN#">
	SELECT 
		QUESTION_ID,
		QUESTION,
		ANSWER_NUMBER,
		QUESTION_TYPE,
		ANALYSIS_ID,
		QUESTION_INFO,
		QUESTION_TYPE
	FROM 
		MEMBER_QUESTION 
	WHERE 
		ANALYSIS_ID IS NOT NULL
		<cfif isdefined("attributes.analysis_id") and len(attributes.analysis_id)>
			AND ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> 
		</cfif>
		<cfif isdefined("attributes.question_id") and len(attributes.question_id)>
			AND QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
		</cfif>
	ORDER BY 
		QUESTION_ID
</cfquery>

