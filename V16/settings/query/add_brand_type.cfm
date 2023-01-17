<cfquery name="ADD_BRAND_TYPE" datasource="#dsn#"  result="MAX_ID">
	INSERT INTO 
	SETUP_BRAND_TYPE
	(
		BRAND_TYPE_NAME,
		BRAND_ID,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_type_name#">,
		#attributes.brand_id#,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.upd_brand_type&brand_type_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
