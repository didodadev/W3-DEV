<cfquery name="add_school_part" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_HIGH_SCHOOL_PART
	(
		HIGH_PART_NAME,
		HIGH_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		'#TITLE#',
		'#TITLE_DETAIL#',
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_highadd_school_part" addtoken="no">
