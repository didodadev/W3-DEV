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
			AND	( ANALYSIS_HEAD LIKE #sql_unicode()#'%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR ANALYSIS_OBJECTIVE LIKE  #sql_unicode()#'%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI )
		</cfif>
		<cfif isDefined("attributes.search_status") and len(attributes.search_status)>
			AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.search_status#">
		</cfif>
		<cfif isDefined("attributes.search_type") and len(attributes.search_type)>
			AND IS_PUBLISHED = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.search_type#">
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif len(attributes.start_dates)>AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_dates#"></cfif>
		<cfif len(attributes.finish_dates)>AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_dates#"></cfif>
</cfquery>
