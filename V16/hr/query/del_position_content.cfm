
<cfquery name="del_pos_" datasource="#DSN#">
  DELETE FROM EMPLOYEE_AUTHORITY  WHERE AUTHORITY_ID = #URL.AUTHORITY_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
