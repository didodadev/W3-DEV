<cfset rm = '#chr(13)#'>
<cfset DETAIL = ReplaceList(DETAIL,rm,'')>
<cfset rm = '#chr(10)#'>
<cfset DETAIL = ReplaceList(DETAIL,rm,'')>
<cfquery name="INSCORRCAT" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_CORR
	(
		CORRCAT,
		DETAIL,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CORRCAT#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
		#SESSION.EP.USERID#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		#NOW()#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_corr_cat" addtoken="no">
