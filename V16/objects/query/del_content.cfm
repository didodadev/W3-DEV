<cfquery name="DEL_CONTENT" datasource="#DSN#">
	DELETE FROM
		CONTENT
	WHERE
		CONTENT_ID = #attributes.content_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined('attributes.is_ajax_delete')><!--- İçeriklerin listelendiği yerde ajax ile silinme yapılıyor ise yani bu sayfa ajax ile geliyor ise ana sayfayı reload etmesin. --->
	wrk_opener_reload();
	window.close();
	</cfif>
</script>
