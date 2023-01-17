
<cfquery name="DEL_POS_REQ" datasource="#DSN#">
  DELETE FROM POSITION_REQUIREMENTS WHERE REQ_ID = #URL.REQ_ID#
</cfquery>

<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
