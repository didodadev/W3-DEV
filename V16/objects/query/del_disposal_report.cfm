<!--- İmha tutanağı Silme Sayfası --->
<cfquery name="DEL_REPORT" datasource="#DSN#">
	DELETE FROM WASTE_DISPOSAL_RESULT WHERE DISPOSAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.disposal_id#">
</cfquery>
<script type="text/javascript">
	window.close();
</script>

