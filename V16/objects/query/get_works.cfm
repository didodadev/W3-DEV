<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfquery name="GET_WORKS" datasource="#dsn#">
	SELECT
		PRO_WORKS.PROJECT_ID,
		PRO_WORKS.WORK_ID,
		PRO_WORKS.WORK_HEAD,
		PRO_WORKS.COMPANY_ID,
		PRO_WORKS.WORK_CURRENCY_ID,
		PRO_WORKS.PROJECT_EMP_ID,
		PRO_WORKS.TARGET_START,
		PRO_WORKS.TARGET_FINISH,
		PRO_WORKS.PROJECT_ID,
        PRO_WORKS.WORK_NO
		<cfif isdefined('attributes.expense_code') and len(attributes.expense_code) and len(attributes.expense_code_name)>
			,EXPENSE_CENTER.EXPENSE_CODE 
		</cfif>
	FROM
		PRO_WORKS
		<cfif isdefined('attributes.expense_code') and len(attributes.expense_code) and len(attributes.expense_code_name)> 
			,EXPENSE_CENTER 
		</cfif>
	WHERE
		PRO_WORKS.WORK_ID IS NOT NULL
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND (PRO_WORKS.WORK_HEAD LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%' OR
			PRO_WORKS.WORK_NO LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%')
	</cfif>
	<cfif isdefined("attributes.status") and len(attributes.status)>
		AND PRO_WORKS.WORK_STATUS = #attributes.status#
	</cfif>
	<cfif isdefined("attributes.currency") and len(attributes.currency)>
		AND	PRO_WORKS.WORK_CURRENCY_ID = #attributes.currency#	
	</cfif>
	<cfif len(attributes.workgroup_id)>
		AND PRO_WORKS.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
	</cfif>
	<cfif len(attributes.work_cat)>
		AND PRO_WORKS.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_cat# ">
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND	PROJECT_EMP_ID = #attributes.employee_id#
	</cfif>
    <cfif isdefined('attributes.expense_code') and len(attributes.expense_code) and len(attributes.expense_code_name)>
		AND EXPENSE_CENTER.EXPENSE_CODE LIKE '#attributes.expense_code#'
	</cfif>
	<cfif len(attributes.date1)>
		<cf_date tarih='attributes.date1'>
		AND TARGET_START >= #DATEADD('h',-1*(session.ep.time_zone),DATE1)#		
	</cfif>
	<cfif len(attributes.date2)>
		<cf_date tarih='attributes.date2'>
		AND TARGET_START <= #DATEADD('h',-1*(session.ep.time_zone),DATE2)#
	</cfif>
	<cfif len(attributes.modal_project_head) and len(attributes.modal_project_id)>
		AND PRO_WORKS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.modal_project_id#">
    <cfelseif isdefined("attributes.sarf_project_id") and len(attributes.sarf_project_id)>
    	AND PRO_WORKS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_project_id#">
	</cfif>
	<cfif isdefined("attributes.rel_workid")>
	    AND PRO_WORKS.WORK_ID <> #listfirst(attributes.rel_workid)#
    </cfif>
	ORDER BY 
		RECORD_DATE DESC
</cfquery>
