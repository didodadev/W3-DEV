<cfquery name="ADD_COMPANY_SIZE_CAT" datasource="#DSN#">
	INSERT INTO 
		SETUP_COMPANY_SIZE_CATS
	(
		COMPANY_SIZE_CAT,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPANY_SIZE_CAT#">,
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_company_size_cat" addtoken="no">
