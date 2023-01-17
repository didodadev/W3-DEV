<!---is istasyonu iliskili fiziki varlık silme --->
<cfquery name="DEL_PHYSICAL_RELATION" datasource="#dsn#">
	DELETE FROM RELATION_PHYSICAL_ASSET_STATION WHERE STATION_ID =  #attributes.station_id# AND PHYSICAL_ASSET_ID = #asset_id#
</cfquery>
<cfif not isdefined('attributes.is_ajax_del')>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>

