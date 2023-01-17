<cfquery name="UPD_PARTNER_TITLE" datasource="#DSN#">
	UPDATE
		SETUP_PARTNER_DEPARTMENT
		SET
			PARTNER_DEPARTMENT = '#attributes.partner_department#',
			DETAIL = '#attributes.detail#',
			UPDATE_EMP	=#SESSION.EP.USERID#,
			UPDATE_IP	='#CGI.REMOTE_ADDR#',
			UPDATE_DATE =#NOW()#
			
		WHERE
			PARTNER_DEPARTMENT_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_setup_partner_department" addtoken="no">
