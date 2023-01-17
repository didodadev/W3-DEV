<cfquery name="INSTITLE" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_EMPLOYEE_FIRE_REASONS
	(
		REASON,
		REASON_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		'#ATTRIBUTES.REASON#',
		'#ATTRIBUTES.REASON_DETAIL#',
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#cgi.http_referer#" addtoken="no">
