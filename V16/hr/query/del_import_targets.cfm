<cfquery name="GET_IMPORT" datasource="#dsn#">
	SELECT 
    	ISLEM_ID, 
        PROCESS_TYPE, 
        FILE_NAME, 
        FILE_SERVER_ID,
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
	    EMPLOYEES_PERFORMANCE_FILES 
    WHERE 
    	ISLEM_ID = #attributes.action_id#
</cfquery>
<cflock timeout="60">
	<cftransaction>
		<cfif GET_IMPORT.RECORDCOUNT>
			<cf_del_server_file output_file="hr/eislem/#GET_IMPORT.file_name#" output_server="#GET_IMPORT.file_server_id#">
			<cfquery name="DEL_IMPORTS" datasource="#dsn#"><!---hedef kayıtları --->
				DELETE FROM TARGET WHERE FILE_NAME = '#GET_IMPORT.file_name#'
			</cfquery>
		<cfelse>
			<script type="text/javascript">
				alert("Eski Dosya Bulunamadı ama Veritabanından Silindi !");
			</script>
		</cfif>
		<cfquery name="DEL_IMPORT" datasource="#dsn#">
			DELETE FROM EMPLOYEES_PERFORMANCE_FILES WHERE ISLEM_ID = #attributes.action_id#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.action_id# " action_name="İmport Sil : #GET_IMPORT.file_name#" process_type="#get_import.process_type#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
