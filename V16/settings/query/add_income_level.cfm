<cfquery name="add_income_level" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_INCOME_LEVEL
	(
		INCOME_LEVEL,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		'#income_level#',
		<cfif isDefined("attributes.detail") and len(attributes.detail)>'#DETAIL#',<cfelse>NULL,</cfif>
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_income_level" addtoken="no">
