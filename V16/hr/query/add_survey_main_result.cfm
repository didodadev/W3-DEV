<cfquery name="get_type" datasource="#dsn#">
	SELECT TYPE FROM SURVEY_MAIN WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_main_id#">
</cfquery>
<!--- calisan icin doldurulacak form iliskilendiriliyor--->
<cfquery name="add_relation" datasource="#dsn#">
	INSERT INTO
		CONTENT_RELATION
	(
		SURVEY_MAIN_ID,
		RELATION_CAT,
		RELATION_TYPE,
		RELATED_ALL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_main_id#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">,
		8,<!--- performans tipinde form--->
		0,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=hr.list_performance_forms" addtoken="no">
