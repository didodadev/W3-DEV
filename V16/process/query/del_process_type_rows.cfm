<cfquery name="GET_PLUS" datasource="#dsn#">
	SELECT
		P.PROCESS_ID,
		P.PROCESS_NAME,
		PR.PROCESS_ROW_ID,
		PR.LINE_NUMBER,
		PR.STAGE,
		PR.DISPLAY_FILE_NAME,
		PR.FILE_NAME,
		PR.DISPLAY_FILE_SERVER_ID
	FROM
		PROCESS_TYPE P,
		PROCESS_TYPE_ROWS PR
	WHERE
		P.PROCESS_ID = PR.PROCESS_ID AND
		PR.PROCESS_ID = #attributes.process_id#
	ORDER BY 
		PR.PROCESS_ROW_ID
</cfquery>
<cfset Log_Action_Name = "">
<cfoutput query="get_plus">
	<cfif get_plus.line_number gt attributes.line_number>
		<cfquery name="UPD_PLUS" datasource="#dsn#">
			UPDATE
				PROCESS_TYPE_ROWS
			SET
				LINE_NUMBER = #get_plus.line_number-1#
			WHERE
				PROCESS_ID = #attributes.process_id# AND
				PROCESS_ROW_ID = #get_plus.process_row_id#
		</cfquery>
	</cfif>
	<cfif get_plus.process_row_id eq attributes.process_row_id>
		<cfset Log_Action_Name = "#GET_PLUS.process_name#- #GET_PLUS.Stage#">
	</cfif>
</cfoutput>
<cfquery name="DEL_PROCESS_FILE_HISTORY" datasource="#dsn#"><!--- Ilgili asamanin historysini siler --->
	DELETE FROM PROCESS_FILE_HISTORY WHERE PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>
<cfquery name="get_plus_" dbtype="query"><!--- Ilgili asamanin dosyalarini siler --->
	SELECT DISPLAY_FILE_NAME,FILE_NAME,DISPLAY_FILE_SERVER_ID FROM GET_PLUS WHERE PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.process_row_id#" action_name="#Log_Action_Name#" period_id="#session.ep.period_id#">
<cf_del_server_file output_file="settings/#get_plus_.display_file_name#" output_server="#get_plus_.display_file_server_id#">
<cf_del_server_file output_file="settings/#get_plus_.file_name#" output_server="#get_plus_.display_file_server_id#">

<cfquery name="DEL_PROCESS_TYPE_ROWS" datasource="#dsn#">
	DELETE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>
<cfquery name="DEL_PROCESS_TYPE_ROWS_POSID" datasource="#dsn#"><!--- Ilgili asamanin yetkili pozisyonlarını siler --->
	DELETE FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>
<cfquery name="DEL_PROCESS_TYPE_ROWS_CAUID" datasource="#dsn#"><!--- Ilgili asamanin onay ve uyaricilarını siler --->
	DELETE FROM PROCESS_TYPE_ROWS_CAUID WHERE PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>
<cfquery name="DEL_PROCESS_TYPE_ROWS_INFID" datasource="#dsn#"><!--- Ilgili asamanin bilgi verileceklerini siler --->
	DELETE FROM PROCESS_TYPE_ROWS_INFID WHERE PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>
<cfquery name="DEL_PROCESS_TYPE_ROWS_WORKGRUOP" datasource="#dsn#"><!--- Ilgili asamanin surec grubunu siler --->
	DELETE FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
