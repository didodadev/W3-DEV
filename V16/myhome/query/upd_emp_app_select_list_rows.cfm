<cfif attributes.del eq 1>
	<cfif len(attributes.list_row_id)>
	<cfquery name="upd_status" datasource="#dsn#">
	UPDATE
		EMPLOYEES_APP_SEL_LIST_ROWS
	SET
		ROW_STATUS=0,
		UPDATE_DATE=#now()#,
		UPDATE_EMP=#session.ep.userid#,
		UPDATE_IP='#cgi.REMOTE_ADDR#'
	WHERE
		LIST_ROW_ID IN (#attributes.list_row_id#)
	</cfquery>
	</cfif>
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
		</cfquery>
		<cf_workcube_process 
			is_upd='1' 
			process_stage='#attributes.process_stage#' 
			old_process_line='0' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='EMPLOYEES_APP_SEL_LIST_ROWS'
			action_column='LIST_ROW_ID'
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
	<cflocation url="#request.self#?fuseaction=#moduls#.upd_emp_app_select_list&list_id=#attributes.list_id#" addtoken="No">
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>

