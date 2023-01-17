<cfquery name="update_asset_p_demand" datasource="#dsn#">
	UPDATE
		ASSET_P_DEMAND
	SET
		VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE
		DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
