<cf_workcube_process 
	is_upd='1' 
	old_process_line='0' 
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='EMPLOYEES_APP_SEL_LIST'
	action_column='LIST_ID'
	action_id='#attributes.list_id#'
	action_page='#request.self#?fuseaction=myhome.upd_emp_app_select_list&list_id=#attributes.list_id#' 
	warning_description = 'Seçim Listesi : #attributes.list_id#'>
<cfquery name="upd_list" datasource="#dsn#">
	UPDATE
		EMPLOYEES_APP_SEL_LIST
	SET
		SEL_LIST_STAGE=#attributes.process_stage#
	WHERE
		LIST_ID=#attributes.list_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
