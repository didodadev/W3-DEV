<cfquery name="GET_STOCK_IMPORT" datasource="#DSN2#">
	SELECT 
		FILE_NAME,
		FILE_SERVER_ID,
		IMPORTED
	FROM 
		FILE_IMPORTS
	WHERE
		I_ID = #attributes.import_id#
</cfquery>
<cfif (GET_STOCK_IMPORT.IMPORTED eq 1)>
	<script type="text/javascript">
		alert('Bu belge için birleştirilmiş sayım kaydı bulunmaktadır!');
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif FileExists("#upload_folder#store#dir_seperator##GET_STOCK_IMPORT.FILE_NAME#")>
    <cf_del_server_file output_file="store/#GET_STOCK_IMPORT.FILE_NAME#" output_server="#GET_STOCK_IMPORT.FILE_SERVER_ID#">
</cfif>

<cfquery name="DEL_STOCK_IMPORT" datasource="#DSN2#">
	DELETE FROM
		FILE_IMPORTS_ROW
	WHERE
		FILE_IMPORT_ID = #attributes.import_id#
</cfquery>
<cfquery name="DEL_STOCK_IMPORT" datasource="#DSN2#">
	DELETE FROM
		FILE_IMPORTS
	WHERE
		I_ID = #attributes.import_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
