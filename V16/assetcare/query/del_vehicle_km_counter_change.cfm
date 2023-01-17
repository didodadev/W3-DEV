<cfquery name="DEL_KM_CONTROL" datasource="#DSN#">
	DELETE FROM 
		ASSET_P_KM_CONTROL
	WHERE 
		KM_CONTROL_ID = #attributes.km_control_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
