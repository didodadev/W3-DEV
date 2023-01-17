<cfquery name="GET_EXPORT" datasource="#dsn#">
	SELECT FILE_NAME,EXCEL_FILE_NAME,EXCEL_FILE_NAME_7103,FILE_NAME_7103, FILE_NAME_5746, TOTAL_FILE_NAME, EXCEL_XLS_FILE_NAME_7103, EXCEL_XLS_FILE_NAME  FROM EMPLOYEES_MUHTASAR_EXPORTS WHERE EME_ID = #ATTRIBUTES.EME_ID#
</cfquery>

<cfif GET_EXPORT.RECORDCOUNT>
	<cf_del_server_file output_file="hr/emuhtasar/#GET_EXPORT.file_name#" output_server="1">
	<cf_del_server_file output_file="hr/emuhtasar/#GET_EXPORT.file_name_7103#" output_server="1">
	<cf_del_server_file output_file="hr/emuhtasar/#GET_EXPORT.EXCEL_FILE_NAME#" output_server="1">
	<cf_del_server_file output_file="hr/emuhtasar/#GET_EXPORT.EXCEL_FILE_NAME_7103#" output_server="1">
	<cf_del_server_file output_file="hr/emuhtasar/#GET_EXPORT.FILE_NAME_5746#" output_server="1">
	<cf_del_server_file output_file="hr/emuhtasar/#GET_EXPORT.TOTAL_FILE_NAME#" output_server="1">
	<cf_del_server_file output_file="hr/emuhtasar/#GET_EXPORT.EXCEL_XLS_FILE_NAME_7103#" output_server="1">	
	<cf_del_server_file output_file="hr/emuhtasar/#GET_EXPORT.EXCEL_XLS_FILE_NAME#" output_server="1">	
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='867.Eski Dosya Bulunamadı ama Veritabanından Silindi'> !");
	</script>
</cfif>

<cfquery name="DEL_EXPORT" datasource="#dsn#">
	DELETE FROM EMPLOYEES_MUHTASAR_EXPORTS WHERE EME_ID = #ATTRIBUTES.EME_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>