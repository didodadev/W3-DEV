<cfquery name="ADD_REC" datasource="#DSN#">
	INSERT INTO 
		SETUP_EDUCATION_LEVEL 
	(
		EDUCATION_NAME,
		IS_ACTIVE,
		EDU_TYPE,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP,
		DECLARATION_ID
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.edu_cat_name#">,
		<cfif isdefined("attributes.is_aktif")>1<cfelse>0</cfif>,
		<cfif len(attributes.edu_type)>#attributes.edu_type#<cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.declaration_id#">
	)
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_edu_level">
