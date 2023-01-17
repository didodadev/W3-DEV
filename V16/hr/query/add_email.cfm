<cfif Len(attributes.PSWRD)>
	<cfset pass = Encrypt(attributes.PSWRD,attributes.employee_id)>
<cfelse>	
	<cfset pass = "">
</cfif>
	
<cfquery name="get_user_mail" datasource="#DSN#">
	SELECT * FROM CUBE_MAIL WHERE EMAIL = '#attributes.EMAIL#'
</cfquery>

<cfif get_user_mail.RecordCount>
	<script type="text/javascript">
		alert('Mail Adresi Kullanılıyor!');
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset mail_path = '#emp_mail_path##attributes.employee_id#'>

<cfquery name="ADD_EMP_MAIL" datasource="#DSN#">  
	INSERT INTO
	CUBE_MAIL
		(
		EMPLOYEE_ID,
		EMAIL,
		ACCOUNT,
		PASSWORD,
		POP,
		ISACTIVE,
		SMTP,
		MAIL_PATH,
        RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
		)
	VALUES
		(
		#attributes.employee_id#,
		'#attributes.EMAIL#',
		'#attributes.ACC_NAME#',
		'#pass#',
		'#attributes.POP#',
		<cfif isDefined("attributes.active")>1,<cfelse>0,</cfif>
		'#attributes.SMTP#',
		'#mail_path#',
        #NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>

<cfset folder_ = 0>
<cfif DirectoryExists("#emp_mail_path##attributes.employee_id#")>
	<cfset folder_ = 1>
</cfif>

<cfif folder_ eq 0>
	<cfdirectory action="create" name="as" directory="#emp_mail_path##attributes.employee_id#" recurse="yes">
	<cfdirectory action="create" name="as_in" directory="#emp_mail_path##attributes.employee_id#\inbox" recurse="yes">
	<cfdirectory action="create" name="as_out" directory="#emp_mail_path##attributes.employee_id#\sendbox" recurse="yes">
	<cfdirectory action="create" name="as_draft" directory="#emp_mail_path##attributes.employee_id#\draft" recurse="yes">
	<cfdirectory action="create" name="as_delete" directory="#emp_mail_path##attributes.employee_id#\deleted" recurse="yes">
	<cfdirectory action="create" name="as_ina" directory="#emp_mail_path##attributes.employee_id#\inbox\attachments" recurse="yes">
	<cfdirectory action="create" name="as_outa" directory="#emp_mail_path##attributes.employee_id#\sendbox\attachments" recurse="yes">
	<cfdirectory action="create" name="as_drafta" directory="#emp_mail_path##attributes.employee_id#\draft\attachments" recurse="yes">
	<cfdirectory action="create" name="as_deletea" directory="#emp_mail_path##attributes.employee_id#\deleted\attachments" recurse="yes">
</cfif>	

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();window.close();
	<cfelseif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		closeBoxDraggable( 'mail_accounts' );
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_mail_info&employee_id=#attributes.employee_id#</cfoutput>','mail_accounts');
	</cfif>
</script>