<cfif isDefined("attributes.pswrd") and Len(attributes.pswrd)>
	<cfset pass = Encrypt(attributes.pswrd,attributes.employee_id)>
</cfif>
<cfset attributes.employee_id = listFirst(attributes.employee_id)>
<cfquery name="upd_emp_mail" datasource="#dsn#">  
	UPDATE
		CUBE_MAIL
	SET
		EMAIL = '#attributes.EMAIL#',
		ACCOUNT = '#attributes.ACC_NAME#',
		ISACTIVE = <cfif isDefined("attributes.ACTIVE")>1,<cfelse>0,</cfif>
		<cfif isDefined("attributes.pswrd") and len(attributes.pswrd)>PASSWORD = '#pass#',</cfif>
		POP = '#attributes.POP#',
		SMTP = '#attributes.SMTP#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		MAILBOX_ID = #attributes.MAILBOX_ID#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		closeBoxDraggable( 'mail_info_upd' );
		closeBoxDraggable( 'mail_accounts' );
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_mail_info&employee_id=#attributes.employee_id#</cfoutput>','mail_accounts');
	</cfif>
</script>
