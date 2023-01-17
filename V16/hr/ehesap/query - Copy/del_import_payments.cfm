<cfquery name="GET_IMPORT" datasource="#dsn#">
	SELECT 
    	ISLEM_ID, 
        PROCESS_TYPE, 
        SAL_MON, 
        SAL_YEAR, 
        BRANCH_ID, 
        FILE_NAME, 
        FILE_SERVER_ID,
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
	    EMPLOYEES_PUANTAJ_FILES 
    WHERE 
    	ISLEM_ID = #attributes.action_id#
</cfquery>
<cflock timeout="60">
	<cftransaction>
		<cfif GET_IMPORT.RECORDCOUNT>
			<cf_del_server_file output_file="hr/eislem/#GET_IMPORT.file_name#" output_server="#GET_IMPORT.file_server_id#">
			<cfquery name="DEL_IMPORTS" datasource="#dsn#">
				DELETE FROM SALARYPARAM_PAY WHERE FILE_NAME = '#GET_IMPORT.file_name#'
			</cfquery>
			<cfquery name="DEL_IMPORTS" datasource="#dsn#">
				DELETE FROM SALARYPARAM_GET WHERE FILE_NAME = '#GET_IMPORT.file_name#'
			</cfquery>
            <cfquery name="DEL_IMPORTS" datasource="#dsn#">
				DELETE FROM SALARYPARAM_BES WHERE FILE_NAME = '#GET_IMPORT.file_name#'
			</cfquery>
			<cfquery name="DEL_IMPORTS" datasource="#dsn#">
				DELETE FROM SALARYPARAM_EXCEPT_TAX WHERE FILE_NAME = '#GET_IMPORT.file_name#'
			</cfquery>
			<cfquery name="DEL_IMPORTS" datasource="#dsn#">
				DELETE FROM EMPLOYEES_EXT_WORKTIMES WHERE FILE_NAME = '#GET_IMPORT.file_name#'
			</cfquery>
			<cfquery name="DEL_IMPORTS" datasource="#dsn#"><!---izin kayıtları --->
				DELETE FROM OFFTIME WHERE FILE_NAME = '#GET_IMPORT.file_name#'
			</cfquery>
		<cfelse>
			<script type="text/javascript">
				alert("Eski Dosya Bulunamadı ama Veritabanından Silindi !");
			</script>
		</cfif>
		<cfquery name="DEL_IMPORT" datasource="#dsn#">
			DELETE FROM EMPLOYEES_PUANTAJ_FILES WHERE ISLEM_ID = #attributes.action_id#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.action_id# " action_name="İmport Sil : #GET_IMPORT.file_name# (sube:#GET_IMPORT.BRANCH_ID#)" process_type="#get_import.process_type#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
				location.href = document.referrer;
		<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
