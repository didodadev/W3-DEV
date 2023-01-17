<cfquery name="add_stock_action" datasource="#dsn3#">
	INSERT INTO SETUP_SALEABLE_STOCK_ACTION
	(
		STOCK_ACTION_NAME,
		STOCK_ACTION_TYPE,
		STOCK_ACTION_MESSAGE,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_char" value="#attributes.stock_action_name#">,
		<cfif len(attributes.stock_action_type)>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_action_type#">,
		<cfelse>
			NULL,
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_char" value="#attributes.stock_action_message#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#		
	)
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
