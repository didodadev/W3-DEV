<cfquery name="DEL_RELATION" datasource="#dsn#">
	DELETE FROM OUR_COMPANY_BANK_RELATION WHERE RELATION_ID=#relation_id#
</cfquery>

<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
</script>

