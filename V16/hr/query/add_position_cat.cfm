<cfquery name="INSPOSITION" datasource="#dsn#">
	INSERT INTO SETUP_POSITION_CAT
		(
			POSITION_CAT,
			POSITION_CAT_DETAIL,
			HIERARCHY,
			POSITION_CAT_TYPE,
			POSITION_CAT_UPPER_TYPE,
			POSITION_CAT_STATUS,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
	        TITLE_ID,
	        ORGANIZATION_STEP_ID,
	        FUNC_ID,
	        COLLAR_TYPE,
	        BUSINESS_CODE_ID
		) 
	VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.position_cat#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.position_detail#">,
			<cfif len(attributes.hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.position_cat_type")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.position_cat_upper_type")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.position_cat_status")>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
	        <cfif len(attributes.title_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#"><cfelse>NULL</cfif>,
	        <cfif len(attributes.organization_step_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_step_id#"><cfelse>NULL</cfif>,
	        <cfif len(attributes.func_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#"><cfelse>NULL</cfif>,
	        <cfif len(attributes.collar_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"><cfelse>NULL</cfif>,
	        <cfif len(attributes.business_code_id) and len(attributes.business_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.business_code_id#"><cfelse>NULL</cfif>
		)
</cfquery>


<script type="text/javascript">
	<cfif isdefined("attributes.callAjax") and attributes.callAjax eq 1><!--- Organizasyon Planlama sayfasından ajax ile çağırıldıysa 20190912ERU --->
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.list_position_cats&event=add&comp_id=#attributes.comp_id#&branch_id=#attributes.branch_id#&department_id=#attributes.department_id#&department=#attributes.department#&branch=#attributes.branch#</cfoutput>','ajax_right');
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.organization_management&event=ajaxSub&type=4&comp_id=#attributes.comp_id#&branch_id=#attributes.branch_id#&department_id=#attributes.department_id#&department=#attributes.department#&branch=#attributes.branch#</cfoutput>','BranchesDepartmentDiv<cfoutput>#attributes.department_id#</cfoutput>');
        $('#BranchesDepartment<cfoutput>#attributes.department_id#</cfoutput>').show();
	<cfelse>
		window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_position_cats&event=add</cfoutput>";
	</cfif>
</script>


