<cfsetting showdebugoutput="no">
<cfquery name="UPD_FUSEACTION_RELATION" datasource="#dsn#">
	UPDATE 
		WRK_OBJECTS
	SET
		RELATED_MODUL_SHORT_NAME = NULL,
		RELATED_FUSEACTION = NULL
	WHERE
		WRK_OBJECTS_ID = #attributes.wrk_obj_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload(); 
	window.close();
</script>
