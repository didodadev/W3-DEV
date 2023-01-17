<cfquery name="add_period" datasource="#DSN#">
	INSERT INTO 
		SETUP_MEMBER_ANALYSIS_TERM
	(
		TERM,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#period#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_member_analysis_period" addtoken="no">
