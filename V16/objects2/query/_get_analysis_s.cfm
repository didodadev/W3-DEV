<cfquery name="GET_ANALYSIS_S" datasource="#dsn#">
	SELECT 
		ANALYSIS_ID,
		ANALYSIS_HEAD,
		ANALYSIS_OBJECTIVE,
		IS_ACTIVE,
		IS_PUBLISHED,
		RECORD_EMP,
		RECORD_DATE
	FROM 
		MEMBER_ANALYSIS
	WHERE
		IS_ACTIVE = 1
		AND
		IS_PUBLISHED = 1
		<cfif isDefined("attributes.KEYWORD")>
			AND
			(
			ANALYSIS_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			OR
			ANALYSIS_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
</cfquery>
