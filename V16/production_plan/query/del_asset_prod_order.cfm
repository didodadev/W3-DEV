<cfquery name="DEL_ASSET_PROD_ORDER" datasource="#dsn#">
	DELETE FROM
		ASSET_P_RESERVE 
	WHERE 
		PROD_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#"> AND 
		ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ASSETP_ID#"> AND
        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
