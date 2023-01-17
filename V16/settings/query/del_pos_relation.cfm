<cfquery name="DEL_RELATION" datasource="#dsn#">
	DELETE FROM OUR_COMPANY_POS_RELATION WHERE POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_id#">
</cfquery>
<script type="text/javascript">
	history.back();
	wrk_opener_reload();
</script>
