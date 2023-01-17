<cfquery datasource="#dsn#" name="del_relationship">
	DELETE FROM WRK_TABLE_RELATION_SHIP WHERE RELATIONSHIP_ID=#attributes.relation_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>	
