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

<cfquery name="UPD_QUALITY_SUCCESS" datasource="#dsn3#">
	UPDATE
		QUALITY_SUCCESS
	SET
		IS_SUCCESS_TYPE = <cfif isDefined("attributes.is_success_type")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_success_type#"><cfelse>NULL</cfif>,
		IS_DEFAULT_TYPE = <cfif isDefined("attributes.is_default_type")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_default_type#"><cfelse>NULL</cfif>,
		SUCCESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#QUA_SUC#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
		QUALITY_COLOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#QUALITY_COLOR#">,
		CODE=<cfif len(attributes.code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.code#"><cfelse>NULL</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		SUCCESS_ID = #attributes.id#
</cfquery>

<cfset attributes.action=attributes.id>
<script>
	location.href= document.referrer;
</script>
