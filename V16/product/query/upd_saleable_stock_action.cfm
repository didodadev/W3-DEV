<cfquery name="upd_stock_action" datasource="#dsn3#">
	UPDATE
		SETUP_SALEABLE_STOCK_ACTION
	SET
		STOCK_ACTION_NAME=<cfqueryparam cfsqltype="cf_sql_char" value="#attributes.stock_action_name#">,
		STOCK_ACTION_TYPE=<cfif len(attributes.stock_action_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_action_type#"><cfelse>NULL</cfif>,
		STOCK_ACTION_MESSAGE=<cfif len(attributes.stock_action_message)><cfqueryparam cfsqltype="cf_sql_char" value="#attributes.stock_action_message#"><cfelse>NULL</cfif>,
		UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE=#now()#	
	WHERE
		STOCK_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_char" value="#attributes.stock_action_id#">
</cfquery>
<script type="text/javascript">
	location.href=document.referrer;
</script>
