<cfquery name="GET_EXPORT" datasource="#dsn#">
	SELECT FILE_NAME,FILE_SERVER_ID FROM EMPLOYEES_SSK_EXPORTS WHERE ESE_ID = #ATTRIBUTES.ESE_ID#
</cfquery>

<cfif GET_EXPORT.RECORDCOUNT>
	<cf_del_server_file output_file="hr/ebildirge/#GET_EXPORT.file_name#" output_server="#GET_EXPORT.file_server_id#">
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='867.Eski Dosya Bulunamadı ama Veritabanından Silindi'> !");
	</script>
</cfif>

<cfquery name="DEL_EXPORT" datasource="#dsn#">
	DELETE FROM EMPLOYEES_SSK_EXPORTS WHERE ESE_ID = #ATTRIBUTES.ESE_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
