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

<cfquery name="upd_pass" datasource="#DSN#">
	UPDATE
		PASSWORD_MAKER
	SET
		PASSWORD_MAKER_NO = '#attributes.PASSWORD_MAKER#',
		IS_ACTIVE = <cfif isdefined("attributes.active")>1<cfelse>0</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_USER#'
	WHERE
		PASSWORD_MAKER_ID = #attributes.pass_id#
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
