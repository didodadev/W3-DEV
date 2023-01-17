<cfsetting showdebugoutput="no">
<cfparam name="attributes.record_type" default="0">
<cfset emp_pos_codes = "">
<cfset emp_emp_ids = "">
<cfif isdefined('attributes.auth_emps_pos_codes') and len(attributes.auth_emps_pos_codes) and isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
    <cfset emp_pos_codes = attributes.auth_emps_pos_codes>
    <cfset emp_emp_ids = attributes.auth_emps_id>
<cfelse>
    <cfset emp_pos_codes = listappend(emp_pos_codes,attributes.position_code,',')>
    <cfset emp_emp_ids = listAppend(emp_emp_ids,attributes.employee_id,',')>
</cfif>
<cfif attributes.record_type eq 0>
	<cfquery name="del_old" datasource="#DSN#">
		DELETE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_pos_codes#">) AND DEPARTMENT_ID IS NULL
	</cfquery>
	<cfif isdefined("attributes.branches")>
		<cfset my_branches = attributes.branches>
		<cfloop from="1" to="#listlen(my_branches,',')#" index="i">
			<cfset my_branch_id = ListGetAt(my_branches,i,",")>
			<cfquery name="add_employee_position_branches" datasource="#dsn#">
				<cfloop list="#emp_pos_codes#" index="pos_code">
					INSERT INTO
						EMPLOYEE_POSITION_BRANCHES
					(
						POSITION_CODE,
						BRANCH_ID,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#my_branch_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfloop>
			</cfquery>
		</cfloop>
	</cfif>
	<cfquery name="del_old_rows" datasource="#DSN#">
		<cfloop list="#emp_pos_codes#" index="pos_code">
			DELETE FROM 
				EMPLOYEE_POSITION_BRANCHES 
			WHERE 
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND 
				BRANCH_ID NOT IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND DEPARTMENT_ID IS NULL) AND
				DEPARTMENT_ID IS NOT NULL
		</cfloop>
	</cfquery>
	<cfquery name="del_wrk_app" datasource="#dsn#">
		DELETE FROM WRK_SESSION WHERE USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">) AND USER_TYPE = 0
	</cfquery>
	<cfif not isdefined("attributes.draggable")>
		<cfif not isdefined("attributes.page_type")><cfset attributes.page_type = 1></cfif>
		<cfif isdefined('attributes.from_sec') and len(attributes.from_sec)>
			<cflocation url="#request.self#?fuseaction=objects.popup_list_positions_poweruser&page_type=#attributes.page_type#&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#&from_sec=1" addtoken="no">
		<cfelse>
			<cflocation url="#request.self#?fuseaction=objects.popup_list_positions_poweruser&page_type=#attributes.page_type#&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#" addtoken="no">
		</cfif>
		<cfelse><script>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</script>
	</cfif>
<cfelse>
	<cfquery name="del_old" datasource="#DSN#">
		DELETE FROM 
			EMPLOYEE_POSITION_BRANCHES 
		WHERE 
			POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_pos_codes#">) AND 
			DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.active_branch_id#">)
	</cfquery>
	
	<cfif listlen(attributes.active_dept_loc_list,';')>
		<cfif right(attributes.active_dept_loc_list,1) is ';'>
			<cfset active_dept_loc_list_ = mid(attributes.active_dept_loc_list,1,len(attributes.active_dept_loc_list)-1)>
		<cfelse>
			<cfset active_dept_loc_list_ = attributes.active_dept_loc_list>
		</cfif>
	<cfelse>
		<cfset active_dept_loc_list_ = ''>
	</cfif>
	
	<cfif listlen(active_dept_loc_list_,';')>
		<cfloop list="#active_dept_loc_list_#" delimiters=";" index="ccc">
			<cfquery name="add_employee_position_branches" datasource="#dsn#">
				<cfloop list="#emp_pos_codes#" index="pos_code">
					INSERT INTO
						EMPLOYEE_POSITION_BRANCHES
					(
						POSITION_CODE,
						BRANCH_ID,
						DEPARTMENT_ID,
						LOCATION_ID,
						LOCATION_CODE,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.active_branch_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(ccc,'-')#">,
						<cfif listlen(ccc,'-') eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(ccc,'-')#">,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfloop>
			</cfquery>
		</cfloop>
	</cfif>
	<cfquery name="del_wrk_app" datasource="#dsn#">
		DELETE FROM WRK_SESSION WHERE USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">) AND USER_TYPE = 0
	</cfquery>
</cfif>
