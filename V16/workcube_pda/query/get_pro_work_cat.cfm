<cfif isDefined("control_project_id") and len(control_project_id)>
	<cfquery name="GET_PRO_CAT" datasource="#DSN#">
        SELECT PROCESS_CAT FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_project_id#">
    </cfquery>
</cfif>

<cfquery name="GET_WORK_CAT" datasource="#DSN#">
	SELECT 
		WORK_CAT_ID,
		WORK_CAT,
		TEMPLATE_ID 
	FROM 
		PRO_WORK_CAT
	WHERE
    	<cfif isDefined('session.ep.userid')>
			','+OUR_COMPANY_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
		<cfelseif isDefined('session.pp.userid')>
			','+OUR_COMPANY_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.our_company_id#,%">
		<cfelseif isDefined('session.pda.userid')>
			','+OUR_COMPANY_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.our_company_id#,%">
		</cfif>		
		<cfif isDefined("attributes.work_cat_id") and len(attributes.work_cat_id)>
			AND WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_cat_id#">
		</cfif>
		<cfif isdefined("xml_is_project_cat") and xml_is_project_cat eq 1 and isDefined("control_project_id") and len(control_project_id)>
			AND MAIN_PROCESS_ID IS NOT NULL AND ','+MAIN_PROCESS_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_pro_cat.process_cat#,%">
		<cfelseif isdefined("xml_is_project_cat") and xml_is_project_cat eq 1>
			AND MAIN_PROCESS_ID IS NULL
		</cfif>
	ORDER BY 
		WORK_CAT
</cfquery>
