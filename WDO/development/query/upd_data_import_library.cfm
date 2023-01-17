<cfset cmpLibrary = createObject("component","WDO.development.cfc.data_import_library") />

<cftry>

	<cfset cmpLibrary.updData(
		data_import_id : attributes.data_import_id,
		data_import_name : attributes.data_import_name,
		type : attributes.type,
		import_wo : attributes.import_wo,
		author : attributes.author,
		file_path : attributes.file_path,
		best_practice : attributes.best_practice,
		is_comp : iIf(isDefined('attributes.is_comp'),1,0),
		is_period : iIf(isDefined('attributes.is_period'),1,0)
	) />

	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cfoutput>#getLang('dictionary_id','Kayıt işlemi yapılırken hata oluştu!',59070)#</cfoutput>!");
			window.location.replace(document.referrer);
		</script>
		<cfabort>
	</cfcatch>

</cftry>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=dev.data_import_library&event=upd&data_import_id=#attributes.data_import_id#</cfoutput>';
</script>