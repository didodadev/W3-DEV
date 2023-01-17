<cflock name="#createUUID()#" timeout="20">
  <cftransaction>
	<cfif isdefined("attributes.is_standart")>
		<cfquery name="upd_page_type" datasource="#dsn3#">
			UPDATE CATALOG_PAGE_TYPES SET IS_DEFAULT= 0
		</cfquery>
	</cfif>
	<cfquery name="add_page_type" datasource="#dsn3#">
		UPDATE
			CATALOG_PAGE_TYPES 
		SET
			IS_DEFAULT = <cfif isdefined("attributes.is_standart")>1<cfelse>0</cfif>,
			PAGE_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.page_type#">,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE = #now()#	
		WHERE
			PAGE_TYPE_ID = #attributes.page_type_id#
	</cfquery>
  </cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
