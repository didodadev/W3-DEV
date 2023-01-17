<cfif listfind('hr,service',listgetat(attributes.fuseaction,1,'.'))>
	<cfset list="',""">
	<cfset list2=" , ">
	<cfset attributes.workgroup_name=replacelist(attributes.workgroup_name,list,list2)>
	
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
			HIERARCHY = '#my_hierarchy_code#' AND 
			WORKGROUP_ID <> #attributes.WORKGROUP_ID#
	</cfquery>
	
	<cfif check.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1743.Bu Hierarşi Kullanılmaktadır Lütfen Kodu Değiştiriniz'>!");
		</script>
		<cfabort>
	</cfif>
</cfif>

<cftransaction>
	<cflock timeout="20" name="#CreateUUID()#">
		<cfif listfind('hr,service',listgetat(attributes.fuseaction,1,'.'))>
			<cfquery name="UPD_WORK_GROUP" datasource="#DSN#">  
				UPDATE
					WORK_GROUP
				SET
					MANAGER_EMP_ID = <cfif len(attributes.manager_emp_id) and len(attributes.manager_position)>#attributes.manager_emp_id#<cfelse>NULL</cfif>,
					MANAGER_POSITION_CODE = <cfif len(attributes.manager_pos_code) and len(attributes.manager_position)>#attributes.manager_pos_code#<cfelse>NULL</cfif>,
					SPONSOR_EMP_ID = <cfif len(attributes.sponsor_emp_id) and len(attributes.sponsor_position)>#attributes.sponsor_emp_id#<cfelse>NULL</cfif>,
					WORKGROUP_NAME = '#attributes.workgroup_name#',
					MANAGER_ROLE_HEAD = '#attributes.manager_role_head#',
					GOAL = '#attributes.goal#',
					HIERARCHY = '#my_hierarchy_code#',
					DEPARTMENT_ID = <cfif len(attributes.department_id) and len(attributes.branch_id) and len(attributes.department)>#attributes.department_id#<cfelse>NULL</cfif>,
					BRANCH_ID = <cfif len(attributes.department_id) and len(attributes.branch_id) and len(attributes.department)>#attributes.branch_id#<cfelse>NULL</cfif>,
					OUR_COMPANY_ID = <cfif len(attributes.our_company_id) and len(attributes.our_company)>#attributes.our_company_id#<cfelse>NULL</cfif>,
					HEADQUARTERS_ID = <cfif len(attributes.headquarters_id) and len(attributes.headquarters_name)>#attributes.headquarters_id#<cfelse>NULL</cfif>,
					ONLINE_HELP = <cfif isDefined("attributes.online_help")>1<cfelse><cfif listgetat(attributes.fuseaction,1,'.') is 'service'>1<cfelse>0</cfif></cfif>,
					ONLINE_SALES = <cfif isDefined("attributes.online_sales")>1<cfelse>0</cfif>,
					WORKGROUP_TYPE_ID = <cfif isDefined("attributes.workgroup_type_id") and len(attributes.workgroup_type_id)>#workgroup_type_id#<cfelse>NULL</cfif>,
					STATUS = <cfif isDefined("attributes.status")>1<cfelse>0</cfif>,
					IS_ORG_VIEW = <cfif isdefined("attributes.is_org_view")>1<cfelse>0</cfif>,
					PROJECT_ID= <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					IS_BUDGET = <cfif isdefined("attributes.is_budget")>1<cfelse>0</cfif>,
					UPDATE_DATE = #now()#,
					UPDATE_IP = '#cgi.remote_addr#',
					UPDATE_EMP = #session.ep.userid#
				WHERE
					WORKGROUP_ID = #attributes.workgroup_id#
			 </cfquery>
		<cfelseif listgetat(attributes.fuseaction,1,'.') is 'objects'>
			<cfquery name="del_work_emp_par" datasource="#dsn#">
				DELETE FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = #attributes.workgroup_id#
			</cfquery>
			<cfloop from="1" to="#attributes.record#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfquery name="add_workgroup_emp_par" datasource="#DSN#">
						INSERT INTO 
							WORKGROUP_EMP_PAR
						(
							WORKGROUP_ID,
							EMPLOYEE_ID,
							IS_REAL,
							IS_CRITICAL,
							HIERARCHY,
							ROLE_HEAD,
							ROLE_ID,
							IS_ORG_VIEW,
							CONSUMER_ID,
							COMPANY_ID,
							PARTNER_ID,
							PRODUCT_ID,
							PRODUCT_UNIT_PRICE,
							PRODUCT_MONEY,
							PRODUCT_UNIT,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
							VALUES
						(
							#attributes.workgroup_id#,
							<cfif isdefined("attributes.employee_id#i#") and len(evaluate("attributes.employee_id#i#"))>#evaluate("attributes.employee_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.is_real#i#")>1<cfelse>0</cfif>,
							<cfif isdefined("attributes.is_critical#i#")>1<cfelse>0</cfif>,
							<cfif isdefined("attributes.code#i#") and len(evaluate("attributes.code#i#"))>'#wrk_eval("attributes.code#i#")#'<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.role_head#i#") and len(evaluate("attributes.role_head#i#"))>'#wrk_eval("attributes.role_head#i#")#'<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.role_id#i#") and len(evaluate("attributes.role_id#i#"))>#evaluate("attributes.role_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.is_org_view#i#")>1<cfelse>0</cfif>,
							<cfif isdefined('attributes.consumer_id#i#') and len(evaluate("attributes.consumer_id#i#"))>#evaluate("attributes.consumer_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.company_id#i#') and len(evaluate("attributes.company_id#i#"))>#evaluate("attributes.company_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.partner_id#i#') and len(evaluate("attributes.partner_id#i#"))>#evaluate("attributes.partner_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.product_id#i#') and len(evaluate("attributes.product_id#i#"))>#evaluate("attributes.product_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.price#i#') and len(evaluate("attributes.price#i#"))>#FilterNum(evaluate("attributes.price#i#"))#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.money_type#i#') and len(evaluate("attributes.money_type#i#"))>'#wrk_eval("attributes.money_type#i#")#'<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.unit_name#i#') and len(evaluate("attributes.unit_name#i#"))>'#wrk_eval("attributes.unit_name#i#")#'<cfelse>NULL</cfif>,
							#session.ep.userid#,
							'#cgi.remote_addr#',
							#now()#
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cflock>
</cftransaction>
<cfset attributes.actionId = attributes.WORKGROUP_ID>

<cfif listgetat(attributes.fuseaction,1,'.') is 'objects'>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=#attributes.WORKGROUP_ID#</cfoutput>";
	</script>
</cfif>
