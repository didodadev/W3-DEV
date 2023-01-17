<cfquery name="INSRESERVATION" datasource="#dsn#">
	INSERT INTO 
		SETUP_RESERVATION
	(
		RESERVATION,
		COLOR,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#RESERVATION#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#COLOURP#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_reservation" addtoken="no">
