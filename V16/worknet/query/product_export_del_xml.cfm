<cfset cmp = createObject("component","V16.worknet.cfc.watalogyProductExport")>
<cfset get_xml_files = cmp.get_xml_files_f(xml_id:attributes.xml_file_id)>
<cfset DEL_PRODUCT_XML = cmp.DEL_PRODUCT_XML_F(xml_id:attributes.xml_file_id)>
<cfif get_xml_files.recordcount>
	<cfset attributes.upload_folder = "#upload_folder#wex_files#dir_seperator#">
	<cftry>
		<cffile action="delete" file="#attributes.upload_folder##get_xml_files.wex_file_name#">
		<cfcatch type="any">
			<script type="text/javascript">
				alert("Eski Dosya Bulunamadı ama Veritabanından Silindi!");
			</script>
		</cfcatch>
	</cftry>
<cfelse>
	<script type="text/javascript">
		alert("Eski Dosya Bulunamadı ama Veritabanından Silindi!");
	</script>
</cfif>	
<script type="text/javascript">
	wrk_opener_reload(); 
	window.close();
</script>