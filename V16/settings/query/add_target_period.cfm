<cfquery name="ADD_TARGET_PERIOD" datasource="#DSN#">
	INSERT INTO
		SETUP_TARGET_PERIOD
	(
		TARGET_PERIOD,
		COEFFICIENT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.target_period#">,
		#attributes.coefficient#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_target_period" addtoken="no">
