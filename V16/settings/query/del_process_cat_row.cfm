<cfquery name="DEL_PROCESS_CAT_ROWS" datasource="#dsn3#">
	DELETE 
		SETUP_PROCESS_CAT_ROWS 
	WHERE 
		PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
	<cfif isdefined("attributes.position_code")>
		AND
		POSITION_CODE = #attributes.position_code#
	<cfelseif isdefined("attributes.position_cat_id")>
		AND
		POSITION_CAT_ID = #attributes.position_cat_id#
	</cfif>
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
