<cfif not isDefined("FORM.DEPARTMENT_STATUS")>
	<cfset FORM.DEPARTMENT_STATUS = 0>
</cfif>
<cfif isdefined('attributes.UP_DEPARTMENT_ID') and len(attributes.UP_DEPARTMENT_ID) and isdefined('attributes.level_no') and len(attributes.level_no)>
	<cfquery name="get_up_dep_level_no" datasource="#DSN#">
		SELECT LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID=#attributes.UP_DEPARTMENT_ID#
	</cfquery>
    <cfif get_up_dep_level_no.LEVEL_NO gte attributes.level_no>
    	<script type="text/javascript">
			alert("Üst departmanın kademe numarası daha küçük olmalıdır!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="ADD_DEPARTMENT" datasource="#DSN#" result="MAX_ID">
	INSERT  INTO
		DEPARTMENT
	(
		<!--- DEPARTMENT_NAME_ID, departman adları kaldırıldı silinebilir 20121006--->
		IS_ORGANIZATION,
		DEPARTMENT_HEAD,
		DEPARTMENT_DETAIL,
		DEPARTMENT_STATUS,
		IS_STORE,
		IS_PRODUCTION,
		ADMIN1_POSITION_CODE,
		ADMIN2_POSITION_CODE,	
		HIERARCHY,
		BRANCH_ID,
        DEPARTMENT_EMAIL,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
        LEVEL_NO,
		DEPT_STAGE,
		SPECIAL_CODE,
		SPECIAL_CODE2,
		DEPARTMENT_CAT,
		DEPARTMENT_TYPE
	)
		VALUES
	(
		<!--- <cfif isdefined('attributes.DEPARTMENT_NAME_ID') and len(attributes.DEPARTMENT_NAME_ID)>#attributes.DEPARTMENT_NAME_ID#,<cfelse>NULL,</cfif> --->
		<cfif isdefined("attributes.IS_ORGANIZATION")>1,<cfelse>0,</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DEPARTMENT_HEAD#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DEPARTMENT_DETAIL#">,
		<cfif isdefined("attributes.DEPARTMENT_STATUS")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.IS_STORE") and len(attributes.IS_STORE)>#attributes.IS_STORE#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.is_production')>1<cfelse>0</cfif>,
		<cfif isdefined('attributes.ADMIN1_POSITION_CODE') and isdefined('attributes.admin1_position') and len(attributes.ADMIN1_POSITION_CODE) and len(attributes.admin1_position)>#attributes.ADMIN1_POSITION_CODE#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.ADMIN2_POSITION_CODE') and isdefined('attributes.admin2_position') and len(attributes.ADMIN2_POSITION_CODE) and len(attributes.admin2_position)>#attributes.ADMIN2_POSITION_CODE#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.hierarchy') and len(attributes.hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#"><cfelse>NULL</cfif>,
		<cfif len(attributes.BRANCH_ID)>#attributes.BRANCH_ID#<cfelse>NULL</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#">,
		#NOW()#,
		#SESSION.EP.USERID#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
        <cfif isdefined('attributes.level_no') and len(attributes.level_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.level_no#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		<cfif  isdefined('attributes.SPECIAL_CODE') and len(attributes.SPECIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SPECIAL_CODE#"><cfelse>NULL</cfif>,
		<cfif  isdefined('attributes.SPECIAL_CODE_2') and len(attributes.SPECIAL_CODE_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SPECIAL_CODE_2#"><cfelse>NULL</cfif>,
		<cfif  isdefined('attributes.depatment_cat') and len(attributes.depatment_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.depatment_cat#"><cfelse>NULL</cfif>,
		<cfif  isdefined('attributes.depatment_type') and len(attributes.depatment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.depatment_type#"><cfelse>NULL</cfif>
	)
</cfquery>
<cfif isdefined('attributes.UP_DEPARTMENT_ID') and isdefined('attributes.UP_DEPARTMENT') and len(attributes.UP_DEPARTMENT_ID) and len(attributes.UP_DEPARTMENT)>
	<cfquery name="get_hier" datasource="#DSN#">
		SELECT
			HIERARCHY_DEP_ID
		FROM
			DEPARTMENT
		WHERE
			DEPARTMENT_ID=#attributes.UP_DEPARTMENT_ID#
	</cfquery>
	<cfif len(get_hier.HIERARCHY_DEP_ID)>
		<cfset hier=get_hier.HIERARCHY_DEP_ID & "." & MAX_ID.IDENTITYCOL>
	<cfelse>
		<cfset hier=attributes.UP_DEPARTMENT_ID & "." & MAX_ID.IDENTITYCOL>	
	</cfif>
<cfelse>
	<cfset hier = MAX_ID.IDENTITYCOL>
</cfif>
<cfquery name="get_max" datasource="#DSN#">
	UPDATE
		DEPARTMENT
	SET
		HIERARCHY_DEP_ID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#hier#">
	WHERE
		DEPARTMENT_ID=#MAX_ID.IDENTITYCOL#
</cfquery>
<!--- history icin --->
<cfquery name="add_dept_history" datasource="#dsn#">
	INSERT INTO DEPARTMENT_HISTORY (DEPARTMENT_STATUS,IS_PRODUCTION,IS_STORE,BRANCH_ID,DEPARTMENT_ID,DEPARTMENT_HEAD,DEPARTMENT_DETAIL,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,HIERARCHY_DEP_ID,HIERARCHY,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_ORGANIZATION,HEADQUARTERS_ID,OUR_COMPANY_ID,ZONE_ID,LEVEL_NO) 
	SELECT DEPARTMENT_STATUS,IS_PRODUCTION,IS_STORE,BRANCH_ID,DEPARTMENT_ID,DEPARTMENT_HEAD,DEPARTMENT_DETAIL,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,HIERARCHY_DEP_ID,HIERARCHY,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_ORGANIZATION,HEADQUARTERS_ID,OUR_COMPANY_ID,ZONE_ID,LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = #MAX_ID.IDENTITYCOL#
</cfquery>
<!--- history icin --->
<cfif attributes.x_show_process eq 1>
	<cfsavecontent variable="dept_"><cf_get_lang_main no='160.Departman'></cfsavecontent>
	<cf_workcube_process 
				is_upd='1' 
				data_source='#dsn#' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#'
				action_table='DEPARTMENT'
				action_column='DEPT_STAGE'
				action_id='#MAX_ID.IDENTITYCOL#'
				action_page='#request.self#?fuseaction=#attributes.fuseaction#&event=upd&id=#MAX_ID.IDENTITYCOL#' 
				warning_description='#dept_#: #MAX_ID.IDENTITYCOL#'>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.callAjaxBranch") and attributes.callAjaxBranch eq 1><!--- Organizasyon Yönetimi sayfasıdan ajax ile çağırıldıysa 20190912ERU --->
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.list_depts&event=upd&id=#MAX_ID.IDENTITYCOL#&comp_id=#attributes.comp_id#&branch_id=#attributes.branch_id#&branch=#attributes.branch#</cfoutput>','ajax_right');
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.organization_management&event=ajaxSub&type=3&comp_id=#attributes.comp_id#&branch_id=#attributes.branch_id#&branch=#attributes.branch#</cfoutput>','CompanyBranchesDiv<cfoutput>#attributes.branch_id#</cfoutput>');
        $('#CompanyBranches<cfoutput>#attributes.branch_id#</cfoutput>').show();
	<cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
	</cfif>
</script>