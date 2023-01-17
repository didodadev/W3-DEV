<cfquery name="add_cv_unit" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_CV_UNIT
	(
		IS_VIEW,
		IS_ACTIVE,
		UNIT_NAME,
		UNIT_DETAIL,
		HIERARCHY,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		<cfif isdefined("attributes.is_view") and len(attributes.is_view)>#attributes.is_view#<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_active") and len(attributes.is_active)>#attributes.is_active#<cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.title_#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.title_detail#">,
		<cfif len(attributes.hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#"><cfelse>NULL</cfif>,
		#SESSION.EP.USERID#,
		#NOW()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_cv_unit" addtoken="no">
