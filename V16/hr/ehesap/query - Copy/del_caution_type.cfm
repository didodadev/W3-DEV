<cfquery name="del_caution_type" datasource="#dsn#">
 DELETE FROM SETUP_CAUTION_TYPE WHERE CAUTION_TYPE_ID = #attributes.caution_type_id#
</cfquery>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
