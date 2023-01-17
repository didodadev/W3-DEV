<cfset cmpDsn = createObject("component","V16.settings.cfc.data_source") />

<cftry>

	<cf_add_data_sources mod="del" dsn="#attributes.old_data_source_name#" admin_password="#attributes.cf_password#">

	<cfset cmpDsn.delDataSource(
		data_source_id : attributes.data_source_id
	) />

	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cfoutput>#getLang('dictionary_id','Data source oluşturulamadı!',62700)#</cfoutput>");
			window.location.replace(document.referrer);
		</script>
		<cfabort>
	</cfcatch>

</cftry>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=settings.data_source</cfoutput>';
</script>