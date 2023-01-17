<!--- toplu pos dönüş belgeleri silme sayfasıdır --->
<cfquery name="GET_FILE" datasource="#dsn2#">
	SELECT FILE_NAME, FILE_SERVER_ID FROM FILE_IMPORTS WHERE I_ID = #attributes.I_ID# AND IMPORTED = 0			
</cfquery>
<cfif GET_FILE.recordcount>
	<cfset attributes.upload_folder = "#upload_folder#finance#dir_seperator#">
	<cftry>
		<cf_del_server_file output_file="finance/#get_file.file_name#" output_server="#get_file.file_server_id#">
		<cfcatch type="any">
			<script type="text/javascript">
				alert("<cf_get_lang no ='412.Dosya Bulunamadı Ama Veritabanından Silindi'>!");
			</script>
		</cfcatch>
	</cftry>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="DEL_IMPORT" datasource="#dsn2#">
				DELETE FROM FILE_IMPORTS WHERE I_ID = #attributes.I_ID#
			</cfquery>
		</cftransaction>
	</cflock>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
