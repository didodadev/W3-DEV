<cfif isDefined("attributes.is_default_type")>
	<cfquery name="Upd_Other_Type" datasource="#dsn3#">
		UPDATE
			QUALITY_SUCCESS
		SET
			IS_DEFAULT_TYPE = NULL
		WHERE
			IS_SUCCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_success_type#"> AND
			IS_DEFAULT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_default_type#">
	</cfquery>
</cfif>
<cfquery name="ADD_QUALITY_SUCCESS" datasource="#DSN3#">
	INSERT INTO
		QUALITY_SUCCESS
	(
		IS_SUCCESS_TYPE,
		IS_DEFAULT_TYPE,
		SUCCESS,
		DETAIL,
		QUALITY_COLOR,
		CODE,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(
		<cfif isDefined("attributes.is_success_type")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_success_type#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.is_default_type")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_default_type#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.qua_success#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.quality_color#">,
		<cfif len(attributes.code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.code#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cfquery name="get_max" datasource="#dsn3#">
	SELECT MAX(SUCCESS_ID) SUCCESS_ID FROM QUALITY_SUCCESS
</cfquery>

<cfset attributes.action=get_max.success_id>
<script type="text/javascript">
window.location.href="<cfoutput>#request.self#?fuseaction=settings.add_production_quality_success</cfoutput>";
</script>

