<cfinclude template="upd_date_values.cfm">
<cfinclude template="get_check.cfm">
<cfif not check.recordcount>
<cfquery name="UPD_ASSETP_RESERVE" datasource="#DSN#">
	UPDATE 
		ASSET_P_RESERVE
	SET
		STARTDATE = #FORM.STARTDATE#,
		FINISHDATE = #FORM.FINISHDATE#,
        EMPLOYEE_ID = #attributes.employee_id#,
        STAGE_ID = #attributes.process_stage#,        
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		ASSETP_RESID = #attributes.ASSETP_RESID#
</cfquery>
	<cf_workcube_process
		is_upd='1' 
		data_source='#dsn#'
		old_process_line='0'
		process_stage='#attributes.process_stage#'
		record_member='#session.ep.userid#'
		record_date='#now()#'
		action_table='ASSET_P_RESERVE'
		action_column='ASSETP_RESID'
		action_id='#attributes.ASSETP_RESID#'
		action_page=''
		warning_description=''>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='16.Bu aralıkta kaynak rezervasyon çakışması var !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
