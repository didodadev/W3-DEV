<cfquery name="DEL_RELATIVE" datasource="#DSN#">
  DELETE FROM
 	EMPLOYEES_RELATIVES
  WHERE
	RELATIVE_ID=#attributes.RELATIVE_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
