<cfquery name="ADD_SECURE" datasource="#dsn#">
	INSERT
	INTO
		SETUP_SECUREFUND
	(
		SECUREFUND_CAT,
		SECUREFUND_CAT_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
		VALUES
	(
		'#attributes.SECUREFUND_CAT#',
		'#attributes.SECUREFUND_CAT_DETAIL#',
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_securefund" addtoken="no">
