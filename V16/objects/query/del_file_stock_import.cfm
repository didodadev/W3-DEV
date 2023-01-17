<cfif isdefined("attributes.I_ID")>
	<cfquery name="GET_FILE" datasource="#dsn2#">
		SELECT
			INVOICE_ID,
			FILE_NAME,
			FILE_SERVER_ID,
			IS_MUHASEBE
		FROM
			FILE_IMPORTS
		WHERE
			I_ID = #attributes.I_ID#			
	</cfquery>
	<cfif get_file.recordcount>
		<cfset attributes.upload_folder = "#upload_folder#store#dir_seperator#">
		<cftry>
			<!--- <cffile action="delete" file="#attributes.upload_folder##get_file.file_name#"> --->
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
	
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="del_invoice_import" datasource="#dsn2#">
				DELETE FROM
					FILE_IMPORTS
				WHERE
					<cfif isdefined("attributes.I_ID") and len(attributes.I_ID)>
					I_ID = #attributes.I_ID#
					</cfif>
			</cfquery>
		</cftransaction>
	</cflock>
</cfif>
<script type="text/javascript">
		wrk_opener_reload();
		window.close();
</script>
