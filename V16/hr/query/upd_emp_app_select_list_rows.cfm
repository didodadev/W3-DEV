<!--- <cfdump  var="#attributes#" abort> --->
<cfif listFirst(attributes.responsible_employee_id, "_")>
	<cfset attributes.responsible_employee_id = listFirst(attributes.responsible_employee_id, "_")>
<cfelse>
	<cfset attributes.responsible_employee_id = attributes.responsible_employee_id>
</cfif>
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'hr.upd_emp_app_select_list')>
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
			action_table='EMPLOYEES_APP_SEL_LIST_ROWS'
			action_column='LIST_ROW_ID'
			action_page='#request.self#?fuseaction=hr.upd_emp_app_select_list&list_id=#attributes.list_id#'
			total_values = '#totalValues#'
		>
		<cfset attributes.approve_submit = 0>
	</cfif>
</cfif>
<cfif attributes.del eq 1>
	<cfset attributes.list_row_id = attributes._list_row_id_>
	<cfif len(attributes.list_row_id)>
		<cfloop list="#attributes.list_row_id#" index="ccc">
			<cfquery name="get_row" datasource="#dsn#">
				SELECT ROW_STATUS FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ROW_ID = #ccc#
			</cfquery>
			<cfif isdefined("get_row.ROW_STATUS") and get_row.ROW_STATUS eq 0>
				<cfquery name="del_empapp" datasource="#dsn#">
					DELETE FROM 
						EMPLOYEES_APP_SEL_LIST_ROWS
					WHERE
						LIST_ROW_ID = #ccc#
				</cfquery>
			<cfelse>
				<cfquery name="del_empapp" datasource="#dsn#">
					UPDATE
						EMPLOYEES_APP_SEL_LIST_ROWS
					SET
						ROW_STATUS=0,
						UPDATE_DATE=#now()#,
						UPDATE_EMP=#session.ep.userid#,
						UPDATE_IP='#cgi.REMOTE_ADDR#'
					WHERE
						LIST_ROW_ID = #ccc#
				</cfquery>
			</cfif>		
		</cfloop>
	</cfif>
    <cfset attributes.actionId = attributes.list_id>
    <script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=hr.emp_app_select_list&event=det&list_id=#attributes.list_id#</cfoutput>';
	</script>
<cfelse>
	<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
		<!--- list rowdaki kayıtlardan aktiflerin aşamasını değiştiriyor--->
		<cfquery name="upd_list_row" datasource="#dsn#">
		UPDATE
			EMPLOYEES_APP_SEL_LIST_ROWS
		SET
			STAGE=#attributes.process_stage#,
			UPDATE_DATE=#now()#,
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP='#cgi.REMOTE_ADDR#'
		WHERE
			LIST_ROW_ID IN (#attributes.list_row_id#)
		<!--- AND ROW_STATUS=1 --->
		</cfquery>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0' 
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='EMPLOYEES_APP_SEL_LIST'
			action_column='LIST_ID'
			action_id='#attributes.list_row_id#'
			action_page='#request.self#?fuseaction=hr.upd_emp_app_select_list&list_id=#attributes.list_id#' 
			warning_description = 'Seçim Listesi Satırları : Güncellendi'>
	</cfif>
</cfif>
<cfif not isdefined('is_popup')>
	<cfif fuseaction contains "hr">
		<cfset moduls="hr">
	<cfelse>
		<cfset moduls="myhome">
	</cfif>
    <script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=#moduls#.emp_app_select_list&event=det&list_id=#attributes.list_id#</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>