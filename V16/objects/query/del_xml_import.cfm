<cfquery name="GET_FILE" datasource="#DSN2#">
	SELECT
		INVOICE_ID,
		FILE_NAME,
		FILE_SERVER_ID,
		IS_MUHASEBE
	FROM
		FILE_IMPORTS
	WHERE
		I_ID = #attributes.file_id#		
</cfquery>
<cfif get_file.recordcount>
	<cfset attributes.upload_folder = "#upload_folder#pos#dir_seperator#">
	<cftry>
		<cf_del_server_file output_file="#get_file.file_name#" output_server="#get_file.file_server_id#">
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
<cfquery name="DEL_FILE_IMPORTS" datasource="#DSN2#">
	DELETE FROM
		FILE_IMPORTS
	WHERE
		I_ID = #attributes.file_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
