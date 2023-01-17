<cf_get_lang_set module_name="hr">
<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.group_name=replacelist(attributes.group_name,list,list2)>

<cfif len(attributes.hierarchy1_code)>
	<cfset my_hierarchy_code = attributes.hierarchy1_code & '.' & attributes.hierarchy>
<cfelse>
	<cfset my_hierarchy_code = attributes.hierarchy>
</cfif>

<cfquery name="CHECK" datasource="#DSN#">
	SELECT
		HIERARCHY
	FROM
		WORK_GROUP
	WHERE
		HIERARCHY = '#my_hierarchy_code#'
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1743.Bu Hierarşi Kullanılmaktadır Lütfen Kodu Değiştiriniz'>!");
	</script>
	<cfabort>
</cfif>

<cflock name="#createUUID()#" timeout="20">
 	<cftransaction>
   		<cfquery name="ADD_WORK_GROUP" datasource="#DSN#" result="MAX_ID">
	  		INSERT INTO 
	   			WORK_GROUP 
			(
				MANAGER_EMP_ID,
				MANAGER_POSITION_CODE,
				MANAGER_ROLE_HEAD,
				SPONSOR_EMP_ID,
				WORKGROUP_NAME,
				DEPARTMENT_ID,
				BRANCH_ID,
				OUR_COMPANY_ID,
				HEADQUARTERS_ID,
				GOAL,
				ONLINE_HELP,
				ONLINE_SALES,
				STATUS,
				WORKGROUP_TYPE_ID,
				HIERARCHY,
				IS_BUDGET,
				IS_ORG_VIEW,
				PROJECT_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			) 
			VALUES 
			(
				<cfif len(attributes.manager_emp_id) and len(attributes.manager_position)>#attributes.manager_emp_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.manager_pos_code) and len(attributes.manager_position)>#attributes.manager_pos_code#<cfelse>NULL</cfif>,
				'#attributes.manager_role_head#',
				<cfif len(attributes.sponsor_emp_id) and len(attributes.sponsor_position)>#attributes.sponsor_emp_id#<cfelse>NULL</cfif>,
				'#attributes.group_name#',
				<cfif len(attributes.department_id) and len(attributes.branch_id) and len(attributes.department)>#attributes.department_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.department_id) and len(attributes.branch_id) and len(attributes.department)>#attributes.branch_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.our_company_id) and len(attributes.our_company)>#attributes.our_company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.headquarters_id) and len(attributes.headquarters_name)>#attributes.headquarters_id#<cfelse>NULL</cfif>,
				'#group_goal#',
				<cfif isdefined("attributes.online_help")>1<cfelse><cfif fusebox.circuit is 'service'>1<cfelse>0</cfif></cfif>,
				<cfif isdefined("attributes.online_sales")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.workgroup_type_id") and len(attributes.workgroup_type_id)>#workgroup_type_id#<cfelse>null</cfif>,
				'#my_hierarchy_code#',
				<cfif isdefined("attributes.is_budget")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_org_view")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				'#cgi.remote_addr#'
			)
    	</cfquery>
		<cfif len(upper_hierarchy)>
			<cfquery name="INS_UPP_GROUP" datasource="#DSN#">
				UPDATE WORK_GROUP SET SUB_WORKGROUP = 1 WHERE HIERARCHY = '#upper_hierarchy#'
			</cfquery>
		</cfif>
 	</cftransaction>
</cflock>
<cfset attributes.actionId = MAX_ID.identityCol>
<cfif listgetat(attributes.fuseaction,1,'.') is 'objects'>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=#MAX_ID.identityCol#</cfoutput>";
	</script>
</cfif>
