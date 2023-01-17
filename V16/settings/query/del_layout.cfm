<cfquery name="DEL_LAYOUT" datasource="#dsn#">
	DELETE FROM
		MAIN_MENU_LAYOUTS
	WHERE 
		LAYOUT_ID = #attributes.layout_id#
</cfquery>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
