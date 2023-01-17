<cfquery name="GET_PROJECTS" datasource="#dsn#">
	SELECT 
		PROJECT_ID,
		PROJECT_HEAD
	FROM 
		PRO_PROJECTS
	<cfif isDefined("attributes.keyword") and (len(attributes.keyword) eq 1)>
	WHERE		
		PROJECT_HEAD LIKE '#attributes.keyword#%'
	</cfif>		
	ORDER BY
		RECORD_DATE
</cfquery>
