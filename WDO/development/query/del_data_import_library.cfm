<cfset cmpLibrary = createObject("component","WDO.development.cfc.data_import_library") />

<cftry>

	<cfset cmpLibrary.delData(
		data_import_id : attributes.data_import_id
	) />

	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cfoutput>#getLang('dictionary_id','Silme işlemi yapılırken hata oluştu!',60841)#</cfoutput>!");
			window.location.replace(document.referrer);
		</script>
		<cfabort>
	</cfcatch>

</cftry>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=dev.data_import_library</cfoutput>';
</script>