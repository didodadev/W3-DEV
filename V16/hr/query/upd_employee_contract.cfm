<cfif len(attributes.contract_date)>
	<CF_DATE tarih="attributes.contract_date">
</cfif>
<cfif len(attributes.contract_finishdate)>
	<CF_DATE tarih="attributes.contract_finishdate">
</cfif>
<cfquery name="ADD_CONTRACT" datasource="#dsn#">
	UPDATE
		EMPLOYEES_CONTRACT SET
		CONTRACT_HEAD = '#attributes.contract_head#',
		CONTRACT_DETAIL = '#attributes.contract_detail#',
		CONTRACT_DATE = #attributes.contract_date#,
		CONTRACT_FINISHDATE = #attributes.contract_finishdate#,
		EMPLOYEE_ID = #attributes.employee_id#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_EMP = #session.ep.userid#,
		CONTRACT_JOB=<cfif len(attributes.contract_job_id)>#attributes.contract_job_id#,<cfelse>NULL,</cfif>
		CONTRACT_NO='#attributes.contract_no#'
	WHERE 
		CONTRACT_ID = #attributes.cont_id#
</cfquery>
<cfif isdefined("attributes.callAjax") and len(attributes.callAjax)>
	<script>
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.popup_upd_employee_contract&cont_id=#attributes.cont_id#</cfoutput>','ajax_right');
	</script>
<cfelse>
	<cfif not isdefined("attributes.draggable")>
		<cflocation url="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.employee_id#" addtoken="no">
	<cfelseif isdefined("attributes.draggable")>
		<script>
			closeBoxDraggable( 'upd_contract_box' );
			closeBoxDraggable( 'contract_box' );
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_employee_contract&employee_id=#attributes.employee_id#</cfoutput>','contract_box');
		</script>
	</cfif>
</cfif>