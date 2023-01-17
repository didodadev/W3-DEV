<cfquery name="updtimecostcat" datasource="#dsn#">
	UPDATE 
		TIME_COST_CAT 
	SET 
		TIME_COST_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.time_cost_cat#">,
		COLOUR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.colour#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">	 
	WHERE 
		TIME_COST_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.time_cost_cat_id#">
</cfquery>
<script>
	location.href = document.referrer;
</script>
