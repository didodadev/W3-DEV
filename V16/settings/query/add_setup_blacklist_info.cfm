<cfquery name="ADD_SETUP_BLACKLIST_INFO" datasource="#DSN#">
	INSERT
	INTO
		SETUP_BLACKLIST_INFO
		(
			BLACKLIST_INFO_NAME,
			BLACKLIST_INFO_DETAIL,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
	VALUES
		(
			'#attributes.BLACKLIST_INFO_NAME#',
			<cfif len(attributes.BLACKLIST_INFO_DETAIL)>'#attributes.BLACKLIST_INFO_DETAIL#',<cfelse>NULL,</cfif>
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_setup_blacklist_info" addtoken="no">
