<cfif len(attributes.contract_date)>
	<CF_DATE tarih="attributes.contract_date">
</cfif>
<cfif len(attributes.contract_finishdate)>
	<CF_DATE tarih="attributes.contract_finishdate">
</cfif>

<cfquery name="ADD_CONTRACT" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_CONTRACT
		(
			CONTRACT_HEAD,
			CONTRACT_DETAIL, 
			CONTRACT_DATE,
			CONTRACT_FINISHDATE,
			EMPLOYEE_ID,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP ,
			CONTRACT_JOB,
			CONTRACT_NO
		)
	VALUES
		(
			'#attributes.contract_head#', 
			<cfif len(attributes.contract_detail)>'#attributes.contract_detail#'<cfelse>NULL</cfif>,
			#attributes.contract_date#,
			#attributes.contract_finishdate#,
			#attributes.employee_id#,
			#now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#,
			<cfif len(attributes.contract_job_id)>#attributes.contract_job_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.contract_no)>'#attributes.contract_no#'<cfelse>NULL</cfif>
		)
</cfquery>
<script>
	<cfif not isdefined("attributes.draggable")>
        location.href=document.referrer;
    <cfelseif isdefined("attributes.draggable")>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        closeBoxDraggable( 'contract_box' );
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_employee_contract&employee_id=#attributes.employee_id#</cfoutput>','contract_box','ui-draggable-box-large');
	</cfif>
</script>
<!--- <cflocation url="#request.self#?fuseaction=hr.popup_list_employee_contract&employee_id=#attributes.employee_id#" addtoken="no"> --->