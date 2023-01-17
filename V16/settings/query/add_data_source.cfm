<cfset cmpDsn = createObject("component","V16.settings.cfc.data_source") />

<cfif len(attributes.password)>
	<cf_cryptedpassword password="#attributes.password#" output="cryptoPass" mod="1">
</cfif>
<cfif len(attributes.cf_password)>
	<cf_cryptedpassword password="#attributes.cf_password#" output="cryptocfPass" mod="1">
</cfif>
<cftry>

	<cf_add_data_sources mod="add" dsn="#attributes.data_source_name#" db="#attributes.data_source_name#" host="#attributes.host_ip#" driver="#attributes.driver#" username="#attributes.username#" password="#attributes.password#" admin_password="#attributes.cf_password#">

	<cfset result = cmpDsn.addDataSource(
		data_source_name : attributes.data_source_name,
		type : attributes.type,
		driver : attributes.driver,
		host_ip : attributes.host_ip,
		port : attributes.port,
		username : attributes.username,
		password : cryptoPass,
		cf_password : cryptocfPass,
		details : len(attributes.details) ? attributes.details : ''
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
	window.location.href = '<cfoutput>#request.self#?fuseaction=settings.data_source&event=upd&data_source_id=#result.IdentityCol#</cfoutput>';
</script>