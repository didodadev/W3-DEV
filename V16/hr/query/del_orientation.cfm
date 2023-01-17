
<cfquery name="DEL_ORIENTATION" datasource="#DSN#">
  DELETE FROM TRAINING_ORIENTATION WHERE ORIENTATION_ID = #attributes.ORIENTATION_ID#
</cfquery>

<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
