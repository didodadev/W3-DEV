<cfquery name="UPD_PERF_PERIOD" datasource="#dsn#">
	UPDATE 
		SETUP_PERF_PERIOD
	SET
		PERF_PERIOD = #PERF_PERIOD#,
		RECORD_EMP = #SESSION.EP.USERID#,
		RECORD_DATE = #NOW()#,
		RECORD_IP = '#CGI.REMOTE_ADDR#'
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_perf_period">
