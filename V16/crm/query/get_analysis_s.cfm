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
		1=1
		<cfif isDefined("attributes.KEYWORD")>
	AND
		(
		ANALYSIS_HEAD LIKE '%#attributes.KEYWORD#%'
	OR
		ANALYSIS_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
		)
		</cfif>
		<cfif isDefined("attributes.SEARCH_STATUS") and len(attributes.SEARCH_STATUS)>
	AND
		IS_ACTIVE=#attributes.SEARCH_STATUS#
		</cfif>
		<cfif isDefined("attributes.SEARCH_TYPE") and len(attributes.SEARCH_TYPE)>
	AND
		IS_PUBLISHED=#attributes.SEARCH_TYPE#
		</cfif>
		
</cfquery>
