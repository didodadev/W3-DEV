<cfquery name="INSPRIORITY" datasource="#DSN#">
	INSERT INTO 
		SETUP_PRIORITY
	(
		PRIORITY,
		COLOR,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#PRIORITY#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#COLOURP#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_priority" addtoken="no">
