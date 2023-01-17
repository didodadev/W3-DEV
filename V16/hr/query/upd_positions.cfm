<cf_box popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfif listFirst(attributes.responsible_employee_id, "_")>
		<cfset attributes.responsible_employee_id = listFirst(attributes.responsible_employee_id, "_")>
	<cfelse>
		<cfset attributes.responsible_employee_id = attributes.responsible_employee_id>
	</cfif>
	<cfset cmp_process = createObject('component','V16.workdata.get_process')>
	<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'hr.update_positions')>
	<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
		<cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>
			<cfset totalValues = structNew()>
			<cfset totalValues = {
					total_offtime : 0
				}>
			<cfset action_list_id = replace(attributes.action_list_id,";",",","all")>
			<cf_workcube_general_process
				mode = "query"
				general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
				general_paper_no = "#attributes.general_paper_no#"
				general_paper_date = "#attributes.general_paper_date#"
				action_list_id = "#action_list_id#"
				process_stage = "#attributes.process_stage#"
				general_paper_notice = "#attributes.general_paper_notice#"
				responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
				responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
				action_table = 'EMPLOYEE_POSITIONS'
				action_column = 'POSITION_ID'
				action_page = '#request.self#?fuseaction=hr.update_positions'
				total_values = '#totalValues#'
			>
			<cfset attributes.approve_submit = 0>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.record_num")>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol_#i#") eq 1 and len(evaluate("attributes.pos_id_#i#"))>
				<cfif isdefined('attributes.pos_in_out_date#i#') and len(evaluate("attributes.pos_in_out_date#i#"))>
					<cf_date tarih="attributes.pos_in_out_date#i#">
				</cfif>
				<cfset new_hie_ = ''>
				<cfif fusebox.dynamic_hierarchy and len(evaluate("attributes.emp_id#i#"))>
					<cfquery name="get_uppers" datasource="#DSN#">
						SELECT 
							O.HIERARCHY AS HIE1,
							Z.HIERARCHY AS HIE2,
							O.HIERARCHY2 AS HIE3,			
							B.HIERARCHY AS HIE4,
							D.HIERARCHY AS HIE5
						FROM
							DEPARTMENT D
							INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
							INNER JOIN OUR_COMPANY O ON B.COMPANY_ID = O.COMP_ID
							INNER JOIN ZONE Z ON B.ZONE_ID = Z.ZONE_ID
						WHERE
							D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_dep#i#')#">
					</cfquery>
					<cfquery name="get_position_cat" datasource="#DSN#">
						SELECT HIERARCHY FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_cat#i#')#">
					</cfquery>
					<cfquery name="get_title" datasource="#DSN#">
						SELECT HIERARCHY FROM SETUP_TITLE WHERE TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_title#i#')#">
					</cfquery>
					<cfif len(evaluate("attributes.pos_func#i#"))>
						<cfquery name="get_fonk" datasource="#DSN#">
							SELECT
							   HIERARCHY
							FROM
								SETUP_CV_UNIT
							WHERE
								UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_func#i#')#">
						</cfquery>
						<cfif get_fonk.recordcount and len(get_fonk.hierarchy)>
							<cfset fonk_add_ = '.#get_fonk.hierarchy#'>
						<cfelse>
							<cfset fonk_add_ = ''>
						</cfif>
					<cfelse>
						<cfset fonk_add_ = ''>
					</cfif>
					<cfif get_uppers.recordcount>
						<cfset new_hie_ = '#get_uppers.hie1#.' & '#get_uppers.hie2#.' & '#get_uppers.hie3#.' & '#get_uppers.hie4#.' & '#get_uppers.hie5#.' & '#get_title.hierarchy#.' & '#get_position_cat.hierarchy#' & '#fonk_add_#'>
					<cfelse>
						<cfset new_hie_ = ''>
					</cfif>
					<cfquery name="upd_2" datasource="#DSN#">
						UPDATE EMPLOYEES SET DYNAMIC_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">,DYNAMIC_HIERARCHY_ADD = NULL WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.emp_id#i#')#">
					</cfquery>
				</cfif>
				<cfquery name="upd_positions" datasource="#dsn#">
					UPDATE
						EMPLOYEE_POSITIONS
					SET
						POSITION_CAT_ID = <cfif len(evaluate("attributes.pos_cat#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_cat#i#')#"><cfelse>NULL</cfif>,
						DEPARTMENT_ID = <cfif len(evaluate("attributes.pos_dep#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_dep#i#')#"><cfelse>NULL</cfif>,
						TITLE_ID = <cfif len(evaluate("attributes.pos_title#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_title#i#')#"><cfelse>NULL</cfif>,
						FUNC_ID = <cfif len(evaluate("attributes.pos_func#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_func#i#')#"><cfelse>NULL</cfif>,
						ORGANIZATION_STEP_ID = <cfif len(evaluate("attributes.pos_org_step_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_org_step_id#i#')#"><cfelse>NULL</cfif>,
						COLLAR_TYPE = <cfif len(evaluate("attributes.pos_collar_type#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_collar_type#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.reason_id#i#")>IN_COMPANY_REASON_ID = <cfif len(evaluate("attributes.reason_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.reason_id#i#')#"><cfelse>NULL</cfif>,</cfif>
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						POSITION_NAME = <cfif isdefined("attributes.position_name#i#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.position_name#i#')#"><cfelse>NULL</cfif>
					WHERE
						POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_id_#i#')#">
				</cfquery>
				<!--- add position history --->
				<cfset url.id = evaluate('attributes.pos_id_#i#')>
				<cfinclude template="add_pos_his_info.cfm">
				<cfset history_position_id = url.id>
				<cfinclude template="add_position_history.cfm">
				<!---//add position history --->
				<!---gorev degisikligi kartina degisikligi at --->
				<cfif isdefined("attributes.pos_in_out_date#i#") and len(evaluate("attributes.pos_in_out_date#i#")) and isdefined("attributes.is_change_pos#i#") and evaluate("attributes.is_change_pos#i#") eq 1>
					<cfif (evaluate("attributes.old_dep#i#") neq evaluate("attributes.pos_dep#i#")) or (evaluate("attributes.old_title#i#") neq evaluate("attributes.pos_title#i#")) or (evaluate("attributes.old_func#i#") neq evaluate('attributes.pos_func#i#')) or (evaluate('attributes.old_pos_cat#i#') neq evaluate('attributes.pos_cat#i#'))>
						<cfquery name="get_content_history" datasource="#dsn#" maxrows="1">
							SELECT ID FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.emp_id#i#')#"> AND FINISH_DATE IS NULL AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_id_#i#')#"> ORDER BY START_DATE DESC
						</cfquery>
						<cfif len(evaluate("attributes.emp_id#i#"))>
							<cfset attributes.position_in_out_date_2 = dateadd('d',-1,evaluate("attributes.pos_in_out_date#i#"))>
						<cfelse>
							<cfset attributes.position_in_out_date_2 = evaluate("attributes.pos_in_out_date#i#")>
						</cfif>
						<cfif get_content_history.recordcount>
							<cfquery name="upd_conten_history" datasource="#dsn#">
								UPDATE EMPLOYEE_POSITIONS_CHANGE_HISTORY SET FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.position_in_out_date_2#"> WHERE ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_content_history.id#">
							</cfquery>
						</cfif>
					</cfif>
					<cfif len(evaluate("attributes.emp_id#i#")) and evaluate("attributes.emp_id#i#") neq 0>
						<cfquery name="add_change_history" datasource="#dsn#">
							INSERT INTO
								EMPLOYEE_POSITIONS_CHANGE_HISTORY
								(
									EMPLOYEE_ID,
									DEPARTMENT_ID,
									POSITION_ID,
									POSITION_NAME,
									POSITION_CAT_ID,
									TITLE_ID,
									FUNC_ID,
									ORGANIZATION_STEP_ID,
									COLLAR_TYPE,
									UPPER_POSITION_CODE,
									UPPER_POSITION_CODE2,
									START_DATE,
									RECORD_EMP,
									RECORD_DATE,
									RECORD_IP,
					                REASON_ID
								)
								SELECT
									EMPLOYEE_ID,
									DEPARTMENT_ID,
									POSITION_ID,
									POSITION_NAME,
									POSITION_CAT_ID,
									TITLE_ID,
									FUNC_ID,
									ORGANIZATION_STEP_ID,
									COLLAR_TYPE,
									UPPER_POSITION_CODE,
									UPPER_POSITION_CODE2,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate('attributes.pos_in_out_date#i#')#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					                <cfif len(evaluate("attributes.reason_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.reason_id#i#')#"><cfelse>NULL</cfif>
								FROM
									EMPLOYEE_POSITIONS 
								WHERE
									POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_id_#i#')#">
						</cfquery>
					</cfif>
				</cfif>
				<!---//gorev degisikligi kartina degisikligi at --->
				<!--- upd emp in out --->
				<cfif isdefined("attributes.x_upd_in_out") and attributes.x_upd_in_out eq 1>
					<cfif evaluate("attributes.pos_dep#i#") neq evaluate("attributes.old_dep#i#") and len(evaluate("attributes.emp_id#i#"))>
						<cfquery name="get_in_out" datasource="#dsn#" maxrows="1">
							SELECT IN_OUT_ID,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.emp_id#i#')#"> ORDER BY START_DATE DESC
						</cfquery>
						<cfif get_in_out.recordcount and evaluate("attributes.branch_id#i#") eq get_in_out.branch_id>
							<cfquery name="upd_in_out" datasource="#dsn#">
								UPDATE EMPLOYEES_IN_OUT	SET DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.pos_dep#i#')#"> WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_in_out.in_out_id#">	
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				<!---//upd emp in out --->
			</cfif>
		</cfloop>
	</cfif>
	<cflocation url="#request.self#?fuseaction=hr.update_positions" addToken="no">
</cf_box>