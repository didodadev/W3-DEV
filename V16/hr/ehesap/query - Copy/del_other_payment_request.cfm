<cfquery  name="del_rec" datasource="#DSN#">
	DELETE
	FROM
		SALARYPARAM_GET_REQUESTS
	WHERE
		SPGR_ID=#attributes.id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
