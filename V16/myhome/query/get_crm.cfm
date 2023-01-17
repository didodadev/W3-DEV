<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
	<cfset attributes.finish_date=date_add("h",23,attributes.finish_date)>
	<cfset attributes.finish_date=date_add("n",59,attributes.finish_date)>
	<cfset attributes.finish_date=date_add("s",59,attributes.finish_date)>
</cfif>
<cfquery name="GET_CRM" datasource="#dsn3#">
	SELECT
		SERVICE_ID,
		SERVICE_HEAD,
		SERVICE_COMPANY_ID,
		SERVICE_CONSUMER_ID,
		SERVICE_EMPLOYEE_ID,
		APPLICATOR_NAME,
		APPLY_DATE,
        PROJECT_ID
	FROM
		SERVICE
	WHERE
		1=1
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND SERVICE_HEAD LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%'
	</cfif>
	<cfif isdefined("attributes.made_application") and len(attributes.made_application)>
			AND
			(
				APPLICATOR_NAME LIKE '%#attributes.made_application#%'
				<cfif isdefined("attributes.EMPLOYEE_ID_") and len(attributes.EMPLOYEE_ID_)>
					OR SERVICE.SERVICE_EMPLOYEE_ID = #attributes.EMPLOYEE_ID_#
				</cfif>
				<cfif isdefined("attributes.PARTNER_ID_") and len(attributes.PARTNER_ID_)>
					OR SERVICE.SERVICE_PARTNER_ID = #attributes.PARTNER_ID_#
				</cfif>
				<cfif isdefined("attributes.COMPANY_ID_") and len(attributes.COMPANY_ID_)>
					OR SERVICE.SERVICE_COMPANY_ID = #attributes.COMPANY_ID_#
				</cfif>
				<cfif isdefined("attributes.consumer_id_") and len(attributes.consumer_id_)>
					OR SERVICE.SERVICE_CONSUMER_ID = #attributes.consumer_id_#
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
					OR SERVICE.PROJECT_ID = #attributes.project_id#
				</cfif>
			)
	</cfif>
	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
		AND SERVICE.APPLY_DATE >= #attributes.start_date#
	</cfif>
	<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
		AND SERVICE.APPLY_DATE < #attributes.finish_date#
	</cfif>
    <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
		AND SERVICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfif>
	ORDER BY 
		SERVICE_HEAD
</cfquery>
