<cfquery name="UPD_REQUEST" datasource="#DSN#">
	UPDATE
		SALARYPARAM_GET_REQUESTS
	SET
		AMOUNT_GET = #attributes.amount_get#,		
		TAKSIT_NUMBER = #attributes.taksit#,
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP =#SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
	WHERE
		SPGR_ID=#attributes.id#
</cfquery>
<cf_workcube_process
    is_upd='1'
    old_process_line='#attributes.old_process_line#'
    process_stage='#attributes.process_stage#'
    record_member='#session.ep.userid#'
    record_date='#now()#'
    action_table='SALARYPARAM_GET_REQUESTS'
    action_column='SPGR_ID'
    action_id='#attributes.id#'
    action_page="#request.self#?fuseaction=ehesap.list_other_payment_requests&event=upd&id=#attributes.id#"
    warning_description = 'Taksitli Avans Talebi : #attributes.id#'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
