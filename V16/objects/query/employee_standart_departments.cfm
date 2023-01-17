<cfif isDefined("attributes.position_code") and Len(attributes.position_code)>
	<cfset emp_pos_codes = "">
	<cfif isdefined('attributes.auth_emps_pos_codes') and len(attributes.auth_emps_pos_codes)>
    	<cfset emp_pos_codes = attributes.auth_emps_pos_codes>
	<cfelse>
    	<cfset emp_pos_codes = listappend(emp_pos_codes,attributes.position_code,',')>
	</cfif>
	<cfquery name="Get_Our_Company" datasource="#dsn#">
		SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_STATUS = 1 ORDER BY COMPANY_NAME
	</cfquery>
	<cfoutput query="Get_Our_Company">
		<cfloop list="#emp_pos_codes#" index="pos_code">
		<cfquery name="Old_Employee_Position_Departments_Control" datasource="#dsn#">
			SELECT OUR_COMPANY_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_our_company.comp_id#">
		</cfquery>
		<cfif Old_Employee_Position_Departments_Control.RecordCount>
			<cfif not (len(evaluate("attributes.branch_name_#comp_id#")) and len(evaluate("attributes.branch_id_#comp_id#"))) and not (len(evaluate("attributes.department_name_#comp_id#")) and len(evaluate("attributes.department_id_#comp_id#"))) and not (len(evaluate("attributes.location_name_#comp_id#")) and len(evaluate("attributes.location_id_#comp_id#")))>
				<cfquery name="del_employee_position_departments" datasource="#dsn#">
					DELETE FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_our_company.comp_id#">
				</cfquery>
			<cfelse>
				<cfquery name="Upd_Employee_Position_Departments" datasource="#dsn#">
					UPDATE
						EMPLOYEE_POSITION_DEPARTMENTS
					SET
						BRANCH_ID = <cfif Len(Evaluate("attributes.branch_name_#comp_id#")) and Len(Evaluate("attributes.branch_id_#comp_id#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.branch_id_#comp_id#')#"><cfelse>NULL</cfif>,
						DEPARTMENT_ID = <cfif Len(Evaluate("attributes.department_name_#comp_id#")) and Len(Evaluate("attributes.department_id_#comp_id#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.department_id_#comp_id#')#"><cfelse>NULL</cfif>,
						LOCATION_ID = <cfif Len(Evaluate("attributes.location_name_#comp_id#")) and Len(Evaluate("attributes.location_id_#comp_id#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.location_id_#comp_id#')#"><cfelse>NULL</cfif>,
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					WHERE
						POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_our_company.comp_id#">
				</cfquery>
			</cfif>
		<cfelse>
			<cfif Len(Evaluate("attributes.branch_name_#comp_id#")) and Len(Evaluate("attributes.branch_id_#comp_id#")) or
				Len(Evaluate("attributes.department_name_#comp_id#")) and Len(Evaluate("attributes.department_id_#comp_id#")) or
				Len(Evaluate("attributes.location_name_#comp_id#")) and Len(Evaluate("attributes.location_id_#comp_id#"))>
				<cfquery name="Add_Employee_Position_Departments" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_POSITION_DEPARTMENTS
					(
						POSITION_CODE,
						OUR_COMPANY_ID,
						BRANCH_ID,
						DEPARTMENT_ID,
						LOCATION_ID,
						UPDATE_EMP,
						UPDATE_DATE,
						UPDATE_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_our_company.comp_id#">,
						<cfif Len(Evaluate("attributes.branch_name_#comp_id#")) and Len(Evaluate("attributes.branch_id_#comp_id#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.branch_id_#comp_id#')#"><cfelse>NULL</cfif>,
						<cfif Len(Evaluate("attributes.department_name_#comp_id#")) and Len(Evaluate("attributes.department_id_#comp_id#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.department_id_#comp_id#')#"><cfelse>NULL</cfif>,
						<cfif Len(Evaluate("attributes.location_name_#comp_id#")) and Len(Evaluate("attributes.location_id_#comp_id#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.location_id_#comp_id#')#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
			</cfif>
		</cfif>
		</cfloop>
	</cfoutput>
	<cfquery name="Del_Session" datasource="#dsn#"><!--- ep ve pda portaldan atmali --->
		DELETE FROM WRK_SESSION WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_pos_codes#">) AND USER_TYPE IN (0,5)
	</cfquery>
</cfif>
<cfif not isdefined("attributes.draggable")>
	<cfif not isdefined("attributes.page_type")><cfset attributes.page_type = 1></cfif>
	<cflocation url="#request.self#?fuseaction=objects.popup_list_positions_poweruser&page_type=#attributes.page_type#&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#" addtoken="no">
<cfelse>
	<script>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</script>
</cfif>

