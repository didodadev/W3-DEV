<cfif isdefined("attributes.active")>
	<cfquery name="upd_pass" datasource="#dsn#">
		UPDATE 
			PASSWORD_MAKER 
		SET 
			IS_ACTIVE = 0 
		WHERE 
			<cfif isdefined("attributes.employee_id")>
				EMPLOYEE_ID=#attributes.employee_id#
			<cfelse>
				PARTNER_ID=#attributes.partner_id#
			</cfif>
	</cfquery>
</cfif>

<cfquery name="add_password_maker" datasource="#DSN#">
	INSERT INTO
		PASSWORD_MAKER
	(
		PARTNER_ID,
		EMPLOYEE_ID,
		PASSWORD_MAKER_NO,
		IS_ACTIVE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP		
	)
	VALUES
	(
		<cfif isdefined("attributes.partner_id")>#attributes.partner_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.employee_id")>#attributes.EMPLOYEE_ID#<cfelse>NULL</cfif>,
		'#attributes.PASSWORD_MAKER#',
		<cfif isdefined("attributes.active")>1,<cfelse>0,</cfif>
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_password_maker');
		location.reload();
	</cfif>
</script>
