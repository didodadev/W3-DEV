<cfquery name="GET_FILE" datasource="#dsn2#">
	SELECT FILE_NAME,FILE_SERVER_ID FROM FILE_EXPORTS WHERE E_ID = #attributes.e_id#
</cfquery>

<cfquery name="DEL_FILE" datasource="#dsn2#">
	DELETE FILE_EXPORTS WHERE E_ID = #attributes.e_id#
</cfquery>

<cfif FileExists("#upload_folder#store#dir_seperator##GET_FILE.FILE_NAME#")>
	<!--- <cffile action="delete" file="#upload_folder#store#dir_seperator##GET_FILE.FILE_NAME#"> --->
	<cf_del_server_file output_file="store/#GET_FILE.FILE_NAME#" output_server="#GET_FILE.FILE_SERVER_ID#">
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='36148.Dosya Bulunamadı! Dosya Yolu Kayıttan Silindi'>.");
	</script>	
</cfif>

<script type="text/javascript">
	
	window.location.href="<cfoutput>#request.self#?fuseaction=retail.list_stock_export</cfoutput>";

</script>
