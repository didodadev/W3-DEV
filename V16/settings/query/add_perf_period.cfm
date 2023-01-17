<cfquery name="ADD_PERF_PERIOD" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_PERF_PERIOD
	(
		PERF_PERIOD,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		#PERF_PERIOD#,
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_perf_period">
