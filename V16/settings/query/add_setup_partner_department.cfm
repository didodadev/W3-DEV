<cfquery name="ADD_PARTNER_TITLE" datasource="#DSN#">
	INSERT
	INTO
		SETUP_PARTNER_DEPARTMENT
		(
			PARTNER_DEPARTMENT,
			DETAIL,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
	VALUES
		(
			'#attributes.partner_department#',
			<cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_setup_partner_department" addtoken="no">
