<cfquery name="DEL_ROWS" datasource="#dsn#">
	DELETE FROM EMPLOYEES_INVENT_ZIMMET_ROWS WHERE ZIMMET_ID = #attributes.zimmet_id#
</cfquery> 
<cfquery name="DEL_EMPLOYEES_INVENT" datasource="#dsn#">
	DELETE FROM EMPLOYEES_INVENT_ZIMMET WHERE ZIMMET_ID = #attributes.zimmet_id#
</cfquery>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
