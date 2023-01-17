<!--- DIKKAT: Display file dosyamiz DISPLAY_FILE_NAME alaninda, Action file dosyamiz FILE_NAME alanina kayit atmaktadir. 
	Upload edilen dosyalar documents\settings klasorune kaydedilir. BK 20061001--->
<cfquery name="Get_File_Control" datasource="#dsn#">
	SELECT IS_DISPLAY_FILE_NAME, DISPLAY_FILE_NAME, DISPLAY_FILE_SERVER_ID, IS_FILE_NAME,FILE_NAME, FILE_SERVER_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #attributes.process_row_id#
</cfquery>
<cflock name="#createUUID()#" timeout="60">
<cftransaction>
	<!--- Display File Upload --->
	<cfif (not Len(attributes.display_file_name) and not Len(attributes.display_file_name_rex)) or (Len(attributes.display_file_name_rex) and attributes.is_display_file_name eq 1)>
		<!--- Display file tamamen silindiğinde --->
		<cfif Len(Get_File_Control.display_file_name) and Get_File_Control.is_display_file_name neq 1>
			<cf_del_server_file output_file="settings/#Get_File_Control.display_file_name#" output_server="#Get_File_Control.display_file_server_id#">
		</cfif>
	</cfif>
	<cfif Len(attributes.display_file_name) and not Len(attributes.display_file_name_rex)>
		<!--- Yeni Bir Display File Eklendiginde --->
		<cftry>
			<cffile action = "upload" fileField = "display_file_name" destination = "#upload_folder#settings#dir_seperator#" nameConflict = "MakeUnique" mode="777">
			<cfset display_file_name = createUUID() & '.' & cffile.serverfileext>
			<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##display_file_name#">
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang no ='102.Display Dosyanız Upload Edilemedi! Dosyanızı Kontrol Ediniz'>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		<!--- Güncelleme yapıldığında eski dosya silinir --->
		<cfif Len(Get_File_Control.display_file_name)>
			<cf_del_server_file output_file="settings/#Get_File_Control.display_file_name#" output_server="#Get_File_Control.display_file_server_id#">
		</cfif>  
	</cfif>
	<!--- //Display File Upload --->
	
	<!--- Action File Upload --->
	<cfif (not Len(attributes.file_name) and not Len(attributes.file_name_rex)) or (Len(attributes.file_name_rex) and attributes.is_file_name eq 1)>
		<!--- Action file tamamen silindiğinde --->
		<cfif Len(Get_File_Control.file_name) and Get_File_Control.is_file_name neq 1>
			<cf_del_server_file output_file="settings/#Get_File_Control.file_name#" output_server="#Get_File_Control.file_server_id#">
		</cfif>
	</cfif>
	<cfif Len(attributes.file_name) and not Len(attributes.file_name_rex)>
		<!--- Yeni Bir Action File Eklendiginde --->
		<cftry>
			<cffile action = "upload" fileField = "file_name" destination = "#upload_folder#settings#dir_seperator#" nameConflict = "MakeUnique" mode="777">
			<cfset file_name = createUUID() & '.' & cffile.serverfileext>
			<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##file_name#">
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang no ='103.Action Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		<!--- Güncelleme yapıldığında eski dosya silinir --->
		<cfif Len(Get_File_Control.file_name)>
			<cf_del_server_file output_file="settings/#Get_File_Control.file_name#" output_server="#Get_File_Control.file_server_id#">
		</cfif>
	</cfif>
	<!--- //Action File Upload --->
	
   <cfquery name="UPD_PROCESS_TYPE_ROWS" datasource="#DSN#">
		UPDATE
			PROCESS_TYPE_ROWS
		SET
			IS_WARNING = <cfif isdefined("attributes.is_warning")>1<cfelse>0</cfif>,
			IS_SMS = <cfif isdefined("attributes.is_sms")>1<cfelse>0</cfif>,
			IS_EMAIL = <cfif isdefined("attributes.is_email")>1<cfelse>0</cfif>,
			IS_KEP = <cfif isdefined("attributes.is_kep")>1<cfelse>0</cfif>,
			IS_ONLINE = <cfif isdefined("attributes.is_online")>1<cfelse>0</cfif>,
			IS_STAGE_ACTION = <cfif isdefined("attributes.is_stage_action")>1<cfelse>0</cfif>,
			IS_ACTION = <cfif isdefined("attributes.is_action")>1<cfelse>0</cfif>,
			IS_DISPLAY = <cfif isdefined("attributes.is_display")>1<cfelse>0</cfif>,
			IS_CONTINUE = <cfif isdefined("attributes.is_continue")>1<cfelse>0</cfif>,
			IS_EMPLOYEE = <cfif isdefined("attributes.is_employee")>1<cfelse>0</cfif>,
			IS_PARTNER = <cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
			IS_CONSUMER = <cfif isdefined("attributes.is_consumer")>1<cfelse>0</cfif>,
			STAGE_CODE = <cfif isDefined("attributes.stage_code") and Len(attributes.stage_code)>'#attributes.stage_code#'<cfelse>NULL</cfif>,
			STAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.stage#">,
			DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
			ANSWER_HOUR = <cfif len(attributes.last_answer_hour)>#attributes.last_answer_hour#<cfelse>0</cfif>,
			ANSWER_MINUTE = <cfif len(attributes.last_answer_minute)>#attributes.last_answer_minute#<cfelse>0</cfif>,
			<cfif Len(attributes.file_name) and not Len(attributes.file_name_rex)>
				FILE_NAME = '#file_name#',
				FILE_SERVER_ID = #fusebox.server_machine#,
			<cfelseif Len(attributes.file_name_rex)>
				FILE_NAME = '#attributes.file_name_rex#',
				FILE_SERVER_ID = #fusebox.server_machine#,
			<cfelse>
				FILE_NAME = NULL,
				FILE_SERVER_ID = NULL,
			</cfif>
			IS_FILE_NAME = <cfif isDefined("attributes.is_file_name") and Len(attributes.is_file_name)>1<cfelse>NULL</cfif>,
			<cfif Len(attributes.display_file_name) and not Len(attributes.display_file_name_rex)>
				DISPLAY_FILE_NAME = '#display_file_name#',
				DISPLAY_FILE_SERVER_ID = #fusebox.server_machine#,
			<cfelseif Len(attributes.display_file_name_rex)>
				DISPLAY_FILE_NAME = '#attributes.display_file_name_rex#',
				DISPLAY_FILE_SERVER_ID = #fusebox.server_machine#,
			<cfelse>
				DISPLAY_FILE_NAME = NULL,
				DISPLAY_FILE_SERVER_ID = NULL,
			</cfif>
			IS_DISPLAY_FILE_NAME = <cfif isDefined("attributes.is_display_file_name") and Len(attributes.is_display_file_name)>1<cfelse>NULL</cfif>,
			CONFIRM_REQUEST = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request)>1<cfelse>0</cfif>,
			COMMENT_REQUEST = <cfif isdefined("attributes.comment_request") and len(attributes.comment_request)>1<cfelse>0</cfif>,
			IS_CONFIRM = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_confirm") and len(attributes.is_confirm)>1<cfelse>0</cfif>,
			IS_REFUSE = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_refuse") and len(attributes.is_refuse)>1<cfelse>0</cfif>,
			IS_AGAIN = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_again") and Len(attributes.is_again)>1<cfelse>0</cfif>,
			IS_SUPPORT = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_support") and Len(attributes.is_support)>1<cfelse>0</cfif>,
			IS_CANCEL = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_cancel") and Len(attributes.is_cancel)>1<cfelse>0</cfif>,
			IS_CONFIRM_COMMENT_REQUIRED = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_confirm_comment") and len(attributes.is_confirm_comment)>1<cfelse>0</cfif>,
			IS_REFUSE_COMMENT_REQUIRED = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_refuse_comment") and len(attributes.is_refuse_comment)>1<cfelse>0</cfif>,
			IS_AGAIN_COMMENT_REQUIRED = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_again_comment") and len(attributes.is_again_comment)>1<cfelse>0</cfif>,
			IS_SUPPORT_COMMENT_REQUIRED = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_support_comment") and len(attributes.is_support_comment)>1<cfelse>0</cfif>,
			IS_CANCEL_COMMENT_REQUIRED = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_cancel_comment") and len(attributes.is_cancel_comment)>1<cfelse>0</cfif>,
			IS_APPROVE_ALL_CHECKERS = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_approve_all_checkers") and Len(attributes.is_approve_all_checkers)>1<cfelse>0</cfif>,
			CHECKER_NUMBER = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_checker_number") and Len(attributes.is_checker_number) and isDefined("attributes.checker_number") and Len(attributes.checker_number)><cfqueryparam value = "#attributes.checker_number#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			IS_CONFIRM_FIRST_CHIEF = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_confirm_first_chief") and Len(attributes.is_confirm_first_chief)>1<cfelse>0</cfif>,
			IS_CONFIRM_SECOND_CHIEF = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_confirm_second_chief") and Len(attributes.is_confirm_second_chief)>1<cfelse>0</cfif>,
			IS_CONFIRM_FIRST_CHIEF_RECORDING = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_confirm_first_chief_recording") and Len(attributes.is_confirm_first_chief_recording)>1<cfelse>0</cfif>,
			IS_CONFIRM_SECOND_CHIEF_RECORDING = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_confirm_second_chief_recording") and Len(attributes.is_confirm_second_chief_recording)>1<cfelse>0</cfif>,
			POSITION_CODE_ARGUMENT_NAME = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_position_code_argument_name") and Len(attributes.is_position_code_argument_name) and isDefined("attributes.position_code_argument_name") and Len(attributes.position_code_argument_name)><cfqueryparam value = "#attributes.position_code_argument_name#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
			IS_CONFIRM_STAGE_ID = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_confirm") and len(attributes.is_confirm) and isdefined("attributes.is_confirm_stage") and len(attributes.is_confirm_stage)>#attributes.is_confirm_stage#<cfelse>NULL</cfif>,
			IS_REFUSE_STAGE_ID = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_refuse") and len(attributes.is_refuse) and isdefined("attributes.is_refuse_stage") and len(attributes.is_refuse_stage)>#attributes.is_refuse_stage#<cfelse>NULL</cfif>,
			IS_AGAIN_STAGE_ID = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_again") and len(attributes.is_again) and isdefined("attributes.is_again_stage") and len(attributes.is_again_stage)>#attributes.is_again_stage#<cfelse>NULL</cfif>,
			IS_SUPPORT_STAGE_ID = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_support") and len(attributes.is_support) and isdefined("attributes.is_support_stage") and len(attributes.is_support_stage)>#attributes.is_support_stage#<cfelse>NULL</cfif>,
			IS_CANCEL_STAGE_ID = <cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_cancel") and len(attributes.is_cancel) and isdefined("attributes.is_cancel_stage") and len(attributes.is_cancel_stage)>#attributes.is_cancel_stage#<cfelse>NULL</cfif>,
			IS_REQUIRED_PREVIEW = <cfif isdefined("attributes.is_required_preview") and len(attributes.is_required_preview)>1<cfelse>0</cfif>,
			IS_REQUIRED_ACTION_LINK = <cfif isdefined("attributes.is_required_action_link") and len(attributes.is_required_action_link)>1<cfelse>0</cfif>,
			DESTINATION_WO = <cfif isdefined("attributes.destination_wo") and len(attributes.destination_wo)><cfqueryparam value = "#attributes.destination_wo#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
			DESTINATION_EVENT = <cfif isdefined("attributes.destination_event") and len(attributes.destination_event)><cfqueryparam value = "#attributes.destination_event#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
			TEMPLATE_PRINT_ID = <cfif isdefined("attributes.template_print_id") and len(attributes.template_print_id)>#attributes.template_print_id#<cfelse>NULL</cfif>,
			IS_SEND_NOTIFICATION_MAKER = <cfif isdefined("attributes.is_send_notification_maker") and len(attributes.is_send_notification_maker)>#attributes.is_send_notification_maker#<cfelse>NULL</cfif>,
			IS_CHECKER_UPDATE_AUTHORITY = <cfif isdefined("attributes.is_checker_update_authority") and len(attributes.is_checker_update_authority)>#attributes.is_checker_update_authority#<cfelse>NULL</cfif>,
			IS_ADD_ACCESS_CODE = <cfif isdefined("attributes.is_add_access_code") and len(attributes.is_add_access_code)>#attributes.is_add_access_code#<cfelse>NULL</cfif>,
			IS_CREATE_PASSWORD = <cfif isdefined("attributes.is_create_password") and len(attributes.is_create_password)>#attributes.is_create_password#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			PROCESS_ROW_ID = #attributes.process_row_id#
	</cfquery>
	
	<!--- Sira No Guncellemeleri --->
	<cfquery name="get_plus" datasource="#dsn#">
		SELECT LINE_NUMBER, PTR.PROCESS_ID, PROCESS_NAME FROM PROCESS_TYPE_ROWS PTR LEFT JOIN PROCESS_TYPE PT ON PTR.PROCESS_ID=PT.PROCESS_ID WHERE PTR.PROCESS_ROW_ID = #attributes.process_row_id# ORDER BY PROCESS_ROW_ID
	</cfquery>
	<cfif attributes.line_replace_ gt get_plus.line_number>
		<cfquery name="upd_minus" datasource="#dsn#">
			UPDATE PROCESS_TYPE_ROWS SET LINE_NUMBER =  LINE_NUMBER - 1 WHERE PROCESS_ID = #get_plus.process_id# AND LINE_NUMBER BETWEEN  #get_plus.line_number# AND #attributes.line_replace_#
		</cfquery>
		<cfquery name="upd_plus" datasource="#dsn#">
			UPDATE PROCESS_TYPE_ROWS SET LINE_NUMBER = #attributes.line_replace_# WHERE PROCESS_ROW_ID = #attributes.process_row_id#
		</cfquery>
	<cfelseif attributes.line_replace_ lt get_plus.line_number>
		<cfquery name="upd_minus1" datasource="#dsn#">
			UPDATE PROCESS_TYPE_ROWS SET LINE_NUMBER =  LINE_NUMBER + 1 WHERE PROCESS_ID = #get_plus.process_id# AND LINE_NUMBER BETWEEN  #attributes.line_replace_# AND #get_plus.line_number#
		</cfquery>
		<cfquery name="upd_plus1" datasource="#dsn#">
			UPDATE PROCESS_TYPE_ROWS SET LINE_NUMBER = #attributes.line_replace_# WHERE PROCESS_ROW_ID = #attributes.process_row_id#
		</cfquery>
	</cfif>
	<!--- //Sira No Guncellemeleri --->
	
	<!--- Calismayi engelledigi ve kaldirilmasi talep edildigi icin kaldirildi FBS 20111007
	<!--- Display File icin Wrk_Query( Kullanimi Engellenir --->
	<cfquery name="Get_File_Content_Control" datasource="#dsn#">
		SELECT DISPLAY_FILE_NAME,IS_DISPLAY_FILE_NAME FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #attributes.process_row_id#
	</cfquery>
	<cfif Len(Get_File_Content_Control.display_file_name) and Get_File_Content_Control.is_display_file_name neq 1>
		<cffile action="read" file="#upload_folder#settings#dir_seperator##Get_File_Content_Control.display_file_name#" variable="content_control">
		<cfif FindNoCase("wrk_query(",content_control)>
			<script type="text/javascript">
				alert("Dosya İçeriğinde Kullanılmaması Gereken Bir İfade Kullanılmıştır. (wrk_query)\nLütfen Kontrol Ediniz!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<!--- //Display File icin Wrk_Query( Kullnimi Engellenir --->
	 --->
	<!--- 
	<cfquery name="query_da_clear" datasource="#dsn#">
		DELETE FROM PROCESS_TYPE_ROWS_DYNACT WHERE PROCESS_ROW_ID = #attributes.process_row_id#
	</cfquery>
	<cfloop from="1" to="#attributes.da_rowcount#" index="dai">
		<cfif structKeyExists(attributes, "da_schema"&dai)>
			<cfquery name="query_da_add" datasource="#dsn#">
				INSERT INTO PROCESS_TYPE_ROWS_DYNACT( PROCESS_ROW_ID, DA_SCHEMA, DA_TABLE, DA_KEYCOLUMN, DA_KEYVARIABLE, DA_COLUMN, DA_COLUMNVALUE )
				VALUES (
					<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.process_row_id#'>
					,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes["da_schema"&dai]#'>
					,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes["da_table"&dai]#'>
					,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes["da_keycolumn"&dai]#'>
					,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes["da_keyvariable"&dai]#'>
					,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes["da_column"&dai]#'>
					,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes["da_columnvalue"&dai]#'>
				)
			</cfquery>
		</cfif>
	</cfloop>
	 --->
</cftransaction>
</cflock>
<script type="text/javascript">
	//history.back();
	//window.close();
	window.location.href ="<cfoutput>#request.self#?fuseaction=process.form_add_process_rows&event=upd&process_id=#get_plus.process_id#&process_row_id=#attributes.process_row_id#&process_name=#get_plus.process_name#</cfoutput>";
</script>
