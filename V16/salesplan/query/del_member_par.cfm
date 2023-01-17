<cfquery name="del_group_par" datasource="#DSN#">
	DELETE FROM 
		SALES_ZONE_GROUP
	WHERE
		PARTNER_ID = #URL.partner_id#  	 
	AND
		SZ_ID = #URL.SZ_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
