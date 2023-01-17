<cfif not isdefined("attributes.just_actions")>
	<cfquery name="GET_FILE" datasource="#dsn#">
		SELECT
			I_ID,
			FILE_NAME,
			FILE_SERVER_ID
		FROM
			FILE_IMPORTS_MAIN
		WHERE
			I_ID = #attributes.I_ID#		
	</cfquery>
	<cfif get_file.recordcount>
		<cf_del_server_file output_file="hr/#get_file.file_name#" output_server="#get_file.file_server_id#">
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1745.Eski Dosya Bulunamadı ama Veritabanından Silindi'>!");
		</script>
	</cfif>
	<cfquery name="del_invoice_import" datasource="#dsn#"><!--- dosyadan eklenen satirlari sil --->
		DELETE FROM
			EMPLOYEE_DAILY_IN_OUT
		WHERE
			FILE_ID = #attributes.i_id#
	</cfquery>
	<cfquery name="del_" datasource="#dsn#"><!--- dosyadan guncellenen satirlarin guncellemelerini geri al --->
		UPDATE
			EMPLOYEE_DAILY_IN_OUT
		SET
			FINISH_DATE = NULL
		WHERE
			FILE2_ID = #attributes.i_id#
	</cfquery>
	<cfquery name="del_invoice_import" datasource="#dsn#"><!--- dosyadan eklenen fazla mesaileri sil --->
		DELETE FROM
			EMPLOYEES_EXT_WORKTIMES
		WHERE
			PDKS_FILE_ID = #attributes.i_id#
	</cfquery>
	<cfquery name="del_invoice_import" datasource="#dsn#">
		DELETE FROM
			FILE_IMPORTS_MAIN
		WHERE
			I_ID = #attributes.i_id#
	</cfquery>
	<cfquery name="del_invoice_import" datasource="#dsn#">
		DELETE FROM
			SALARYPARAM_GET
		WHERE
			FILE_NAME = '#attributes.i_id#'
	</cfquery>
	<cfquery name="del_offtime" datasource="#dsn#"><!--- Offtime sil --->
		DELETE FROM
			OFFTIME
		WHERE
			PDKS_FILE_ID = #attributes.i_id#
	</cfquery>
<cfelse>
	<cfquery name="del_invoice_import" datasource="#dsn#"><!--- dosyadan eklenen satirlari sil --->
		DELETE FROM
			EMPLOYEE_DAILY_IN_OUT
		WHERE
			FILE_ID = #attributes.i_id#				
	</cfquery>
	<cfquery name="del_" datasource="#dsn#"><!--- dosyadan guncellenen satirlarin guncellemelerini geri al --->
		UPDATE
			EMPLOYEE_DAILY_IN_OUT
		SET
			FINISH_DATE = NULL
		WHERE
			FILE2_ID = #attributes.i_id#
	</cfquery>
	<cfquery name="del_invoice_import" datasource="#dsn#"><!--- dosyadan eklenen fazla mesaileri sil --->
		DELETE FROM
			EMPLOYEES_EXT_WORKTIMES
		WHERE
			PDKS_FILE_ID = #attributes.i_id#
	</cfquery>
	<cfquery name="upd_file" datasource="#dsn#">
		UPDATE 
			FILE_IMPORTS_MAIN 
		SET
			IMPORTED=0,
			LINE_COUNT=0
		WHERE 
			I_ID = #attributes.i_id#
	</cfquery>
	<cfquery name="del_invoice_import" datasource="#dsn#">
		DELETE FROM
			SALARYPARAM_GET
		WHERE
			FILE_NAME = '#attributes.i_id#'
	</cfquery>
	<cfquery name="del_offtime" datasource="#dsn#"><!--- Offtime sil --->
		DELETE FROM
			OFFTIME
		WHERE
			PDKS_FILE_ID = #attributes.i_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
