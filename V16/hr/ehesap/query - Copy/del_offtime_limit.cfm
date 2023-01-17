<cfquery name="del_param" datasource="#dsn#">
	DELETE FROM SETUP_OFFTIME_LIMIT WHERE LIMIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.limit_id#">
</cfquery>

<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
