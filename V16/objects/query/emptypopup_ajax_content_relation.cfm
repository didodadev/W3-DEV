<cfquery name="add_content_relation" datasource="#dsn#">
	INSERT INTO
		CONTENT_RELATION
		(
		RELATION_TYPE,
		RELATION_CAT,
		SURVEY_MAIN_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
		)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relation_type#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relation_cat#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">		
	)
</cfquery>
<script type="text/javascript">
	<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
		location.href=document.referrer;
	<cfelse>
		opener.location.reload();
		window.close();
	</cfif>
</script>

