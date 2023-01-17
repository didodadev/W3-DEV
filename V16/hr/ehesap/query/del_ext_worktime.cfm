<cfinclude template="get_ext_worktime.cfm">
<cfset process_component = createObject("component","V16.objects.cfc.process_is_active")>
<cfset passive_process = process_component.PROCESS_IS_ACTIVE(action_table : 'EMPLOYEES_EXT_WORKTIMES', action_id : ewt_id, is_active : 0)>
<cfquery name="del_worktime" datasource="#dsn#">
	DELETE FROM
		EMPLOYEES_EXT_WORKTIMES
	WHERE
		EWT_ID = #EWT_ID#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.ewt_id#" action_name="Fazla Mesai Kaydı Silindi.#get_ext_worktime.employee_name# #get_ext_worktime.employee_surname# #get_ext_worktime.start_time# #get_ext_worktime.end_time#">
<cfif not isdefined("attributes.ajax")>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_ext_worktimes</cfoutput>";
	</script>
<cfelse>
	<script type="text/javascript">
		document.getElementById('fm_row_td_<cfoutput>#attributes.ewt_id#</cfoutput>').innerHTML = '<font color="red">Silindi!</font>';
	</script>
</cfif>
