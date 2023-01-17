<cfquery name="del_accidents" datasource="#dsn#">
	DELETE FROM ASSET_P_ACCIDENT WHERE ACCIDENT_ID = #attributes.accident_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>
