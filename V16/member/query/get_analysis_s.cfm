<cfquery name="GET_MEMBER_ANALYSIS" datasource="#DSN#">
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
	<cfif len(attributes.keyword)>
		AND	( ANALYSIS_HEAD LIKE '%#attributes.keyword#%' OR ANALYSIS_OBJECTIVE LIKE '%#attributes.keyword#%' )
	</cfif>
	<cfif isDefined("attributes.search_status") and len(attributes.search_status)>
		AND IS_ACTIVE = #attributes.search_status#
	</cfif>
	<cfif isDefined("attributes.search_type") and len(attributes.search_type)>
		AND IS_PUBLISHED = #attributes.search_type#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND RECORD_EMP = #attributes.employee_id#
	</cfif>
	<cfif len(attributes.start_dates)>AND RECORD_DATE >= #attributes.start_dates#</cfif>
	<cfif len(attributes.finish_dates)>AND RECORD_DATE <= #attributes.finish_dates#</cfif>
</cfquery>
