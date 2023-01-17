<cfquery name="GET_NOTICES" datasource="#dsn#">
  SELECT
		NOTICE_ID,
		NOTICE_NO,
		NOTICE_HEAD,
		POSITION_ID,
		POSITION_NAME,
		DEPARTMENT_ID,
		BRANCH_ID,
		OUR_COMPANY_ID,
		IS_VIEW_COMPANY_NAME,
		COMPANY_ID,
		NOTICE_CITY
	FROM
		NOTICES
	WHERE
		STATUS=1 AND
		PUBLISH LIKE '%2%' AND
		<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
			STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
		<cfelse>
			STARTDATE <=#now()# AND
		</cfif>
		<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
			FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
		<cfelse>
			FINISHDATE >= #now()# AND
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		(	DETAIL LIKE '%#attributes.keyword#%'
		 	OR
		 	WORK_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%">	
			OR
			NOTICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%">
		)AND
		</cfif>
		STATUS_NOTICE=-2
	ORDER BY 
		NOTICE_ID 
	DESC
</cfquery>
