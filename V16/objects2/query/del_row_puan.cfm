<cfquery name="del_rows" datasource="#dsn3#">
	DELETE 
		FROM
			ORDER_PRE_ROWS_SPECIAL
	WHERE
		ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_row_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>
