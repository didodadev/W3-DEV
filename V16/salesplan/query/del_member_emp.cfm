<cfquery name="del_group_emp" datasource="#DSN#">
	DELETE FROM 
		SALES_ZONE_GROUP
	WHERE
		POSITION_CODE = #URL.position_code#  	 
	AND
		SZ_ID = #URL.SZ_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
