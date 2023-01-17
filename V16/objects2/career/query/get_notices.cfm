<cfquery name="GET_NOTICES" datasource="#DSN#">
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
		STARTDATE,
		NOTICE_CITY
	FROM
		NOTICES
	WHERE
		STATUS=1 AND
		STARTDATE < =<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND 
        	OUR_COMPANY_ID IS NOT NULL AND
		<cfif isDefined('attributes.our_company_id') and len(attributes.our_company_id)>
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#"> AND
		</cfif>
		<cfif isDefined('attributes.city') and len(attributes.city)>
			NOTICE_CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.city#,%"> AND			
		</cfif>
		<cfif isDefined('attributes.position_id') and len(attributes.position_id)>
			POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#"> AND			
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			(	
				DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				WORK_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				NOTICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)AND
		</cfif> 
		STATUS_NOTICE = -2 
	ORDER BY
		RECORD_DATE DESC
</cfquery>
