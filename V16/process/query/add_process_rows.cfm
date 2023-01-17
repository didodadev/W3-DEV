<!--- DIKKAT: Display file dosyamiz DISPLAY_FILE_NAME alaninda, Action file dosyamiz FILE_NAME alanina kayit atmaktadir. Upload edilen dosyalar documents\settings klasorune kaydedilir. BK 20061001 --->
<!--- Display File Upload --->
<cfif Len(attributes.display_file_name) and not Len(attributes.display_file_name_rex)>
	<cftry>
		<cffile action = "upload" fileField = "display_file_name" destination = "#upload_folder#settings#dir_seperator#" nameConflict = "MakeUnique" mode="777">
		<cfset display_file_name = createUUID() & '.' & cffile.serverfileext>
		<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##display_file_name#">
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no ='102.Display Dosyanız Upload Edilemedi! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>
<!--- Action File Upload --->
<cfif Len(attributes.file_name) and not Len(attributes.file_name_rex)>
	<cftry>
		<cffile action = "upload" fileField = "file_name" destination = "#upload_folder#settings#dir_seperator#" nameConflict = "MakeUnique" mode="777">
		<cfset file_name = createUUID() & '.' & cffile.serverfileext>
		<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##file_name#">
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no ='103.Action Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
<cftransaction>
	<cfquery name="GET_LINE_NUMBER" datasource="#DSN#">
		SELECT MAX(LINE_NUMBER) AS LINE_NUMBER FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = #attributes.process_id#
	</cfquery>
	<cfif len(get_line_number.line_number)>
		<cfset line_number_plus = get_line_number.line_number + 1>
	<cfelse>
		<cfset line_number_plus = 1>
	</cfif>
	<cfquery name="ADD_PROCESS_TYPE_ROWS" datasource="#DSN#">
		INSERT INTO
			PROCESS_TYPE_ROWS
		(
			PROCESS_ID,
			IS_WARNING,
			IS_SMS,
			IS_EMAIL,
			IS_ONLINE,
			STAGE_CODE,
			STAGE,
			DETAIL,
			LINE_NUMBER,
			ANSWER_HOUR,
			ANSWER_MINUTE,
			FILE_NAME,
			FILE_SERVER_ID,
			IS_FILE_NAME,
			DISPLAY_FILE_NAME,
			DISPLAY_FILE_SERVER_ID,
			IS_DISPLAY_FILE_NAME,
			IS_STAGE_ACTION,
			IS_ACTION,
			IS_DISPLAY,
			IS_CONTINUE,
			IS_EMPLOYEE,
			IS_PARTNER,
			IS_CONSUMER,
			CONFIRM_REQUEST,
			COMMENT_REQUEST,
			IS_CONFIRM,
			IS_REFUSE,
			IS_AGAIN,
			IS_SUPPORT,
			IS_CANCEL,
			IS_CONFIRM_COMMENT_REQUIRED,
			IS_REFUSE_COMMENT_REQUIRED,
			IS_AGAIN_COMMENT_REQUIRED,	
			IS_SUPPORT_COMMENT_REQUIRED,
			IS_CANCEL_COMMENT_REQUIRED,
			IS_APPROVE_ALL_CHECKERS,
			CHECKER_NUMBER,
			IS_CONFIRM_FIRST_CHIEF,
			IS_CONFIRM_SECOND_CHIEF,
			IS_CONFIRM_FIRST_CHIEF_RECORDING,
			IS_CONFIRM_SECOND_CHIEF_RECORDING,
			POSITION_CODE_ARGUMENT_NAME,
			IS_CONFIRM_STAGE_ID,
			IS_REFUSE_STAGE_ID,
			IS_AGAIN_STAGE_ID,
			IS_SUPPORT_STAGE_ID,
			IS_CANCEL_STAGE_ID,
			IS_REQUIRED_PREVIEW,
			IS_REQUIRED_ACTION_LINK,
			DESTINATION_WO,
			DESTINATION_EVENT,
			TEMPLATE_PRINT_ID,
			IS_SEND_NOTIFICATION_MAKER,
			IS_CHECKER_UPDATE_AUTHORITY,
			IS_ADD_ACCESS_CODE,
			IS_CREATE_PASSWORD,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP			
		)
		VALUES
		(
			#attributes.process_id#,
			<cfif isdefined("attributes.is_warning")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_sms")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_email")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_online")>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.stage_code") and Len(attributes.stage_code)>'#attributes.stage_code#'<cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.stage#">,
			<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
			#line_number_plus#,
			<cfif len(attributes.last_answer_hour)>'#attributes.last_answer_hour#'<cfelse>0</cfif>,
			<cfif len(attributes.last_answer_minute)>'#attributes.last_answer_minute#'<cfelse>0</cfif>,
			<cfif len(attributes.file_name) and not Len(attributes.file_name_rex)>
				'#file_name#',
				#fusebox.server_machine#,
			<cfelseif len(attributes.file_name_rex)>
				'#attributes.file_name_rex#',
				#fusebox.server_machine#,
			<cfelse>
				NULL,
				NULL,
			</cfif>
			<cfif isDefined("attributes.is_file") and Len(attributes.is_file)>1<cfelse>NULL</cfif>,
			<cfif len(attributes.display_file_name) and not len(attributes.display_file_name_rex)>
				'#display_file_name#',
				#fusebox.server_machine#,
			<cfelseif len(attributes.display_file_name_rex)>
				'#attributes.display_file_name_rex#',
				#fusebox.server_machine#,
			<cfelse>
				NULL,
				NULL,
			</cfif>
			<cfif isDefined("attributes.is_display_file") and Len(attributes.is_display_file)>1<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_stage_action")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_action")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_display")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_continue")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_employee")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_consumer")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.comment_request") and len(attributes.comment_request)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_confirm") and len(attributes.is_confirm)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_refuse") and len(attributes.is_refuse)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_again") and len(attributes.is_again)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_support") and len(attributes.is_support)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_cancel") and len(attributes.is_cancel)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_confirm_comment") and len(attributes.is_confirm_comment)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_refuse_comment") and len(attributes.is_refuse_comment)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_again_comment") and len(attributes.is_again_comment)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_support_comment") and len(attributes.is_support_comment)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_cancel_comment") and len(attributes.is_cancel_comment)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_approve_all_checkers") and len(attributes.is_approve_all_checkers)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_checker_number") and len(attributes.is_checker_number) and isDefined("attributes.checker_number") and len(attributes.checker_number)><cfqueryparam value = "#attributes.checker_number#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_confirm_first_chief") and Len(attributes.is_confirm_first_chief)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_confirm_second_chief") and Len(attributes.is_confirm_second_chief)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_confirm_first_chief_recording") and Len(attributes.is_confirm_first_chief_recording)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_confirm_second_chief_recording") and Len(attributes.is_confirm_second_chief_recording)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isDefined("attributes.is_position_code_argument_name") and Len(attributes.is_position_code_argument_name) and isDefined("attributes.position_code_argument_name") and Len(attributes.position_code_argument_name)><cfqueryparam value = "#attributes.position_code_argument_name#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_confirm") and len(attributes.is_confirm) and isdefined("attributes.is_confirm_stage") and len(attributes.is_confirm_stage)>#attributes.is_confirm_stage#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_refuse") and len(attributes.is_refuse) and isdefined("attributes.is_refuse_stage") and len(attributes.is_refuse_stage)>#attributes.is_refuse_stage#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_again") and len(attributes.is_again) and isdefined("attributes.is_again_stage") and len(attributes.is_again_stage)>#attributes.is_again_stage#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_support") and len(attributes.is_support) and isdefined("attributes.is_support_stage") and len(attributes.is_support_stage)>#attributes.is_support_stage#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.confirm_request") and len(attributes.confirm_request) and isdefined("attributes.is_cancel") and len(attributes.is_cancel) and isdefined("attributes.is_cancel_stage") and len(attributes.is_cancel_stage)>#attributes.is_cancel_stage#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.is_required_preview") and Len(attributes.is_required_preview)>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.is_required_action_link") and Len(attributes.is_required_action_link)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.destination_wo") and len(attributes.destination_wo)><cfqueryparam value = "#attributes.destination_wo#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.destination_event") and len(attributes.destination_event)><cfqueryparam value = "#attributes.destination_event#" CFSQLType = "cf_sql_nvarchar"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.template_print_id") and len(attributes.template_print_id)>#attributes.template_print_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_send_notification_maker") and len(attributes.is_send_notification_maker)>#attributes.is_send_notification_maker#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_checker_update_authority") and len(attributes.is_checker_update_authority)>#attributes.is_checker_update_authority#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_add_access_code") and len(attributes.is_add_access_code)>#attributes.is_add_access_code#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_create_password") and len(attributes.is_create_password)>#attributes.is_create_password#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#'	
		)
	</cfquery>
	
	<cfif isdefined('attributes.line_replace_') and len(attributes.line_replace_)>
		<cfquery name="get_process_row_id" datasource="#dsn#">
			SELECT MAX(PROCESS_ROW_ID) AS PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = #attributes.process_id#
		</cfquery>
		<cfquery name="get_plus" datasource="#dsn#">
			SELECT LINE_NUMBER, PROCESS_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #get_process_row_id.process_row_id#
		</cfquery>
		<cfif attributes.line_replace_ gt get_plus.line_number>
			<cfquery name="upd_minus" datasource="#dsn#">
				UPDATE
					PROCESS_TYPE_ROWS
				SET
					LINE_NUMBER =  LINE_NUMBER - 1
				WHERE
					PROCESS_ID = #get_plus.process_id# AND
					LINE_NUMBER BETWEEN  #get_plus.line_number# AND #attributes.line_replace_#
			</cfquery>
			<cfquery name="upd_plus" datasource="#dsn#">
				UPDATE
					PROCESS_TYPE_ROWS
				SET
					LINE_NUMBER = #attributes.line_replace_#
				WHERE
					PROCESS_ROW_ID = #get_process_row_id.process_row_id#
			</cfquery>
		<cfelseif attributes.line_replace_ lt get_plus.line_number>
			<cfquery name="upd_minus1" datasource="#dsn#">
				UPDATE
					PROCESS_TYPE_ROWS
				SET
					LINE_NUMBER =  LINE_NUMBER + 1
				WHERE
					PROCESS_ID = #get_plus.process_id# AND
					LINE_NUMBER BETWEEN  #attributes.line_replace_# AND #get_plus.line_number#
			</cfquery>
			<cfquery name="upd_plus1" datasource="#dsn#">
				UPDATE
					PROCESS_TYPE_ROWS
				SET
					LINE_NUMBER = #attributes.line_replace_#
				WHERE
					PROCESS_ROW_ID = #get_process_row_id.process_row_id#
			</cfquery>
		</cfif>
	</cfif>
</cftransaction>
</cflock>

<script type="text/javascript">
	window.location.href ="<cfoutput>#request.self#?fuseaction=process.list_process&event=upd&process_id=#get_plus.process_id#</cfoutput>";
</script>
