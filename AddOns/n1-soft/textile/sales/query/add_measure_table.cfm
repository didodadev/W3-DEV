

<cfset upload_folder_ = "#upload_folder#olcutablo#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			filefield = "olcu_tablo" 
			destination = "#upload_folder_#"
			nameconflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfobject name="request_" component="addons.n1-soft.textile.cfc.get_sample_request">
<cfset request_.dsn3 = dsn3>
<cfscript>
requestResult=request_.updRequest(req_id:attributes.req_id,measuretable_filename:file_name);
</cfscript>