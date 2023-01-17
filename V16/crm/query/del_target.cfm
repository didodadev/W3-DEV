<!--- del_target.cfm --->
<cfquery name="DEL_TARGET" datasource="#dsn#">
	DELETE 
		TARGET
	WHERE 
		TARGET_ID= #URL.TARGET_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
