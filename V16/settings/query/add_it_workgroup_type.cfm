<cfquery name="add_it_workgroup_type" datasource="#dsn#">
	INSERT INTO 
	SETUP_IT_WORKGROUP_TYPE
	(
		WORKGROUP_TYPE_NAME,
		INTERNAL_GROUP,
		EXTERNAL_GROUP,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.workgroup_type_name#">,
		<cfif isDefined('attributes.internal_group')>1<cfelse>0</cfif>,
		<cfif isDefined('attributes.external_group')>1<cfelse>0</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.reöte._addr#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_it_workgroup_type" addtoken="no">
