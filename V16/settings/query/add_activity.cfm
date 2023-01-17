<cfquery name="ADD_ACTIVITY" datasource="#DSN#"> 
	INSERT INTO 
		SETUP_ACTIVITY
	(
		ACTIVITY_NAME,
		ACTIVITY_STATUS,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.activity_name#">,
		<cfif isdefined("attributes.activity_status")>1<cfelse>0</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_activity" addtoken="no">
