<cflock name="#createUUID()#" timeout="20">
  <cftransaction>
	<cfif isdefined("attributes.is_standart")>
		<cfquery name="upd_page_type" datasource="#dsn3#">
			UPDATE CATALOG_PAGE_TYPES SET IS_DEFAULT= 0
		</cfquery>
	</cfif>
	<cfquery name="add_page_type" datasource="#dsn3#">
		INSERT INTO 
			CATALOG_PAGE_TYPES 
		(
			IS_DEFAULT,
			PAGE_TYPE,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		VALUES	
		(	
			<cfif isdefined("attributes.is_standart")>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.page_type#">,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#		
		)
	</cfquery>
  </cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
