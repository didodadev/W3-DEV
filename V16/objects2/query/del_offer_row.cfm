<cfquery name="DEL_OFFER_ROW" datasource="#DSN3#">
	DELETE FROM OFFER_ROW WHERE OFFER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_row_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
