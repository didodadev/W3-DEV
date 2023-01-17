<cfquery name="del_stock_action" datasource="#dsn3#">
	DELETE FROM SETUP_SALEABLE_STOCK_ACTION WHERE STOCK_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_char" value="#attributes.stock_action_id#">
</cfquery>
<script type="text/javascript">
	location.href=document.referrer;
</script>

