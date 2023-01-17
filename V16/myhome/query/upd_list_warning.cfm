<cfparam name="attributes.reservedfuseaction" default="#attributes.fuseaction_#" />
<cfset getActionInfo = createObject("component","cfc.getActionInfo")>
<cfset getWorkcubeProcess = createObject("component","CustomTags.cfc.get_workcube_process")>
<cfif 
	(isDefined("attributes.valid_ids") and Len(attributes.valid_ids)) or 
	(isDefined("attributes.refusal_ids") and Len(attributes.refusal_ids)) or
	(isDefined("attributes.again_ids") and Len(attributes.again_ids)) or
	(isDefined("attributes.support_ids") and Len(attributes.support_ids)) or
	(isDefined("attributes.cancel_ids") and Len(attributes.cancel_ids)) or
	(isDefined("attributes.comment_ids") and Len(attributes.comment_ids))>
	<!--- Onaylanacaklar - Reddedilecekler - Tekrar Yap - Destek Al - İptal  --->
	<cfquery name="get_warnings" datasource="#dsn#">
		SELECT
			*
		FROM
			PAGE_WARNINGS AS PW
			LEFT JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
		WHERE
			PW.W_ID IN (
				<cfif isDefined("attributes.valid_ids") and Len(attributes.valid_ids)>#attributes.valid_ids#
				<cfelseif isDefined("attributes.refusal_ids") and Len(attributes.refusal_ids)>#attributes.refusal_ids#
				<cfelseif isDefined("attributes.again_ids") and Len(attributes.again_ids)>#attributes.again_ids#
				<cfelseif isDefined("attributes.support_ids") and Len(attributes.support_ids)>#attributes.support_ids#
				<cfelseif isDefined("attributes.cancel_ids") and Len(attributes.cancel_ids)>#attributes.cancel_ids#
				<cfelseif isDefined("attributes.comment_ids") and Len(attributes.comment_ids)>#attributes.comment_ids#
				</cfif>
				)
	</cfquery>
	<cfif get_warnings.recordcount>

		<cfoutput query = "get_warnings">

			<cfset actionNoteText = isdefined("attributes.actionNoteText") and len(attributes.actionNoteText) ? attributes.actionNoteText : get_warnings.warning_description />
			<cfif get_warnings.IS_MANUEL_NOTIFICATION neq 1>
				<cfset actionInfo = getActionInfo.get(action_table:get_warnings.action_table)>
			</cfif>

			<cfquery name="Add_Warning_Actions" datasource="#dsn#">
				INSERT INTO
				PAGE_WARNINGS_ACTIONS
				(
					WARNING_ID,
					URL_LINK,
					WARNING_DESCRIPTION,
					ACTION_DB,
					ACTION_STAGE_COLUMN,
					ACTION_TABLE,
					ACTION_COLUMN,
					ACTION_STAGE_ID,
					ACTION_ID,
					OUR_COMPANY_ID,
					PERIOD_ID,
					IS_CONFIRM,
					IS_REFUSE,
					IS_AGAIN,
					IS_SUPPORT,
					IS_CANCEL,
					CONFIRM_POSITION_CODE,
					CONFIRM_RESULT,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					<cfqueryparam value = "#get_warnings.w_id#" CFSQLType = "cf_sql_integer">,
					<cfqueryparam value = "#get_warnings.url_link#" CFSQLType = "cf_sql_nvarchar">,
					<cfqueryparam value = "#actionNoteText#" CFSQLType = "cf_sql_nvarchar">,
					<cfif get_warnings.IS_MANUEL_NOTIFICATION neq 1>
						<cfqueryparam value = "#actionInfo.action_db#" CFSQLType = "cf_sql_nvarchar">,
						<cfqueryparam value = "#actionInfo.action_stage_column#" CFSQLType = "cf_sql_nvarchar">,
						<cfqueryparam value = "#get_warnings.action_table#" CFSQLType = "cf_sql_nvarchar">,
						<cfqueryparam value = "#get_warnings.action_column#" CFSQLType = "cf_sql_nvarchar">,
						<cfqueryparam value = "#get_warnings.action_stage_id#" CFSQLType = "cf_sql_integer">,
						<cfqueryparam value = "#get_warnings.action_id#" CFSQLType = "cf_sql_integer">,
					<cfelse>
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
					</cfif>
					#session.ep.company_id#,
					#session.ep.period_id#,
					<cfif isDefined("attributes.valid_ids") and Len(attributes.valid_ids) and ListFind(attributes.valid_ids,get_warnings.w_id)>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.refusal_ids") and Len(attributes.refusal_ids) and ListFind(attributes.refusal_ids,get_warnings.w_id)>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.again_ids") and Len(attributes.again_ids) and ListFind(attributes.again_ids,get_warnings.w_id)>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.support_ids") and Len(attributes.support_ids) and ListFind(attributes.support_ids,get_warnings.w_id)>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.cancel_ids") and Len(attributes.cancel_ids) and ListFind(attributes.cancel_ids,get_warnings.w_id)>1<cfelse>0</cfif>,
					#session.ep.position_code#,
					<cfif Len(get_warnings.confirm_result)>#get_warnings.confirm_result#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>

			<cfif get_warnings.IS_MANUEL_NOTIFICATION neq 1>

				<cfset get_Process_Type_1 = getWorkcubeProcess.get_Process_Type_1(
					process_db		: "#dsn#.",
					process_stage	: get_warnings.ACTION_STAGE_ID,
					data_source		: dsn,
					lang			: "#session.ep.language#"
				)/>

				<cfset get_warnings.CHECKER_NUMBER = len( get_warnings.CHECKER_NUMBER ) ? get_warnings.CHECKER_NUMBER : 0 />

				<!--- Uyarının toplam onaylayan sayısını aşamada istenen cheker sayısıyla kıyaslar --->
				<cfif get_Process_Type_1.CHECKER_NUMBER eq 0 or (get_warnings.CHECKER_NUMBER + 1) gte get_Process_Type_1.CHECKER_NUMBER or (not (isDefined("attributes.valid_ids") and Len(attributes.valid_ids)))>

					<!--- 
						Süreç aşaması detayında, aksiyon sonrasında geçilecek aşama seçimine göre yeni aşamayı belirler. 
						Eğer geçilecek aşama tanımı yapılmamışsa, uyarısı yapılan kaydın aşamasını alır.
					--->

					<cfif isDefined("attributes.valid_ids") and len(attributes.valid_ids)>
						<cfset processStage = get_Process_Type_1.IS_CONFIRM_STAGE_ID>
					<cfelseif isDefined("attributes.refusal_ids") and len(attributes.refusal_ids)>
						<cfset processStage = get_Process_Type_1.IS_REFUSE_STAGE_ID>
					<cfelseif isDefined("attributes.again_ids") and len(attributes.again_ids)>
						<cfset processStage = get_Process_Type_1.IS_AGAIN_STAGE_ID>
					<cfelseif isDefined("attributes.support_ids") and len(attributes.support_ids)>
						<cfset processStage = get_Process_Type_1.IS_SUPPORT_STAGE_ID>
					<cfelseif isDefined("attributes.cancel_ids") and len(attributes.cancel_ids)>
						<cfset processStage = get_Process_Type_1.IS_CANCEL_STAGE_ID>
					</cfif>

					<cfif not IsDefined("processStage") or not len(processStage)><cfset processStage = get_warnings.ACTION_STAGE_ID></cfif>

					<cfif len( get_warnings.GENERAL_PAPER_ID )><!--- Uyarı GENERAL_PAPER ise --->
						
						<cfset totalValues = structNew()>
						<cfset totalValues = deserializeJSON( get_warnings.TOTAL_VALUES )>
						<cf_workcube_general_process
							mode = "query"
							general_paper_parent_id = "#(len( get_warnings.GENERAL_PAPER_PARENT_ID )) ? get_warnings.GENERAL_PAPER_PARENT_ID : get_warnings.GENERAL_PAPER_ID#"
							general_paper_no = "#get_warnings.GENERAL_PAPER_NO#"
							general_paper_date = "#get_warnings.GENERAL_PAPER_DATE#"
							fuseact = "#get_warnings.FUSEACTION#"
							action_list_id = "#get_warnings.ACTION_LIST_ID#"
							old_process_line = '#get_Process_Type_1.Line_Number#'
							old_process_stage = '#get_Process_Type_1.PROCESS_ROW_ID#'
							process_stage = "#processStage#"
							general_paper_notice = "#get_warnings.GENERAL_PAPER_NOTICE#"
							action_table = '#get_warnings.ACTION_TABLE#'
							action_column = '#get_warnings.ACTION_COLUMN#'
							action_page = '#get_warnings.URL_LINK#'
							mandate_position_code = '#(isDefined("attributes.mandate_position") and len(attributes.mandate_position)) ? attributes.mandate_position : 0#'
							total_values = '#totalValues#'
							warning_access_code='#get_warnings.ACCESS_CODE#'
							warning_password='#get_warnings.WARNING_PASSWORD#'>

					<cfelse>
						<!--- Belgenin aşamasını değiştirir ---->
						<cfset changeAction = getWorkcubeProcess.changeAction(
							process_db: "#actionInfo.action_db#.",
							data_source: dsn,
							actionTable: UCase(get_warnings.ACTION_TABLE),
							actionStageColumn: UCase(actionInfo.action_stage_column),
							actionIdColumn: UCase(get_warnings.ACTION_COLUMN),
							actionId: get_warnings.ACTION_ID,
							process_stage: processStage
						)/>

						<cfif changeAction>
							<cf_workcube_process
								is_upd='1'
								data_source='#dsn#'
								old_process_line='#get_Process_Type_1.Line_Number#'
								old_process_stage='#get_Process_Type_1.PROCESS_ROW_ID#'
								process_stage='#processStage#'
								record_member='#session.ep.userid#'
								record_date='#now()#'
								action_table='#get_warnings.ACTION_TABLE#'
								action_column='#get_warnings.ACTION_COLUMN#'
								action_id='#get_warnings.ACTION_ID#'
								action_page='#get_warnings.URL_LINK#'
								mandate_position_code='#(isDefined("attributes.mandate_position") and len(attributes.mandate_position)) ? attributes.mandate_position : 0#'
								warning_description='#get_warnings.WARNING_DESCRIPTION#'
								warning_access_code='#get_warnings.ACCESS_CODE#'
								warning_password='#get_warnings.WARNING_PASSWORD#'>
								
							<cfif get_Process_Type_1.IS_SEND_NOTIFICATION_MAKER><!--- Süreç aşamasında 'İlk kayıt yapana bildirim yap' seçilmişse --->

								<cfquery name="get_warnings_first_sender" datasource="#dsn#">
									SELECT TOP 1 SENDER_POSITION_CODE
									FROM PAGE_WARNINGS
									WHERE 
										ACTION_TABLE = '#get_warnings.ACTION_TABLE#' 
										AND ACTION_COLUMN = '#get_warnings.ACTION_COLUMN#' 
										AND ACTION_ID = '#get_warnings.ACTION_ID#'
										AND PERIOD_ID = #session.ep.period_id#
								</cfquery>
				
								<cf_workcube_process
										is_upd='1'
										data_source='#dsn#'
										old_process_line='#get_Process_Type_1.Line_Number#'
										old_process_stage='#get_Process_Type_1.PROCESS_ROW_ID#'
										process_stage='#processStage#'
										record_member='#session.ep.userid#'
										record_date='#now()#'
										action_table='#get_warnings.ACTION_TABLE#'
										action_column='#get_warnings.ACTION_COLUMN#'
										action_id='#get_warnings.ACTION_ID#'
										action_page='#get_warnings.URL_LINK#'
										position_code= '#get_warnings_first_sender.SENDER_POSITION_CODE#'
										mandate_position_code='#(isDefined("attributes.mandate_position") and len(attributes.mandate_position)) ? attributes.mandate_position : 0#'
										warning_description='#get_warnings.WARNING_DESCRIPTION#'
										warning_access_code='#get_warnings.ACCESS_CODE#'
										warning_password='#get_warnings.WARNING_PASSWORD#'
										is_notification="1"
										>
				
							</cfif>
						</cfif>
					</cfif>

				</cfif>

				<!--- Tüm ilişkili uyarıların onaylayan sayısını 1 artırır --->
				<cfif not len( get_warnings.GENERAL_PAPER_ID ) and (isDefined("attributes.valid_ids") and Len(attributes.valid_ids))>
					<cfset getWorkcubeProcess.upd_warnings_checker_number(
						process_db : '#dsn#.',
						data_source : dsn,
						action_table : '#get_warnings.ACTION_TABLE#',
						action_column : '#get_warnings.ACTION_COLUMN#',
						action_id : #get_warnings.ACTION_ID#,
						process_stage : #get_warnings.ACTION_STAGE_ID#
					) />
				</cfif>

			<cfelse>

				<!--- Bildirimi oluşturan kişiye geri bildirim gönderilir --->
				<cfset getWorkcubeProcess.add_Page_Warnings(
					process_db					:	dsn & ".",
					module_type					:	'e',
					data_source					:	dsn,
					action_page					: 	get_warnings.URL_LINK,
					warning_head 				:	get_warnings.WARNING_HEAD,
					process_row_id 				:	-1,
					warning_description			:	get_warnings.WARNING_DESCRIPTION,
					warning_date 				:	get_warnings.LAST_RESPONSE_DATE,
					record_date 				:	now(),
					record_member 				:	session.ep.userid,
					position_code 				:	get_warnings.SENDER_POSITION_CODE,
					sender_position_code 		:	session.ep.position_code,
					our_company_id 				:	session.ep.company_id,
					period_id 					:	session.ep.period_id,
					is_notification				:	1,
					is_manuel_notification		:	1,
					parent_id					:	get_warnings.W_ID,
					access_code					:	get_warnings.ACCESS_CODE,
					warning_password			:	get_warnings.WARNING_PASSWORD
				)/>

			</cfif>
			
		</cfoutput>

	</cfif>
<cfelseif IsDefined("attributes.mode") and attributes.mode eq 'changeprocessuser'>
	
	<cfif ListLen(attributes.warning_ids)>

		<cfquery name="get_warnings" datasource="#dsn#">
			SELECT
				*
			FROM
				PAGE_WARNINGS AS PW
				LEFT JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
			WHERE
				PW.W_ID IN (#attributes.warning_ids#)
		</cfquery>

		<cfif get_warnings.recordcount>

			<cfloop query = "get_warnings">
				
				<cfset actionInfo = getActionInfo.get(action_table : ACTION_TABLE)>
				<cf_workcube_process
					is_upd='1'
					data_source='#actionInfo.action_db#'
					old_process_line='0'
					process_stage='#ACTION_STAGE_ID#'
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='#ACTION_TABLE#'
					action_column='#ACTION_COLUMN#'
					action_id='#ACTION_ID#'
					action_page='#URL_LINK#'
					position_code= '#attributes.responsible_employee_pos#'
					mandate_position_code = '#(isDefined("attributes.mandate_position") and len(attributes.mandate_position)) ? attributes.mandate_position : 0#'
                	general_paper_id='#( len( GENERAL_PAPER_ID ) ) ? GENERAL_PAPER_ID : 0#'
					warning_description='#WARNING_DESCRIPTION# - #attributes.process_note#'
					warning_access_code='#ACCESS_CODE#'
					warning_password='#WARNING_PASSWORD#'
				>
				
				<cfquery name="upd_page_warnings" datasource="#dsn#">
					UPDATE PAGE_WARNINGS SET IS_ACTIVE = 0 WHERE W_ID = #W_ID#
				</cfquery>

			</cfloop>

		</cfif>

		<cfset attributes.reservedfuseaction = 'process.list_warnings' />

	</cfif>

<cfelse>
	<!--- Aktif Pasif --->
	<cfquery name="upd_page_warnings" datasource="#dsn#">
		UPDATE PAGE_WARNINGS SET IS_ACTIVE = 0 WHERE W_ID IN (#attributes.warning_ids#)
	</cfquery>
</cfif>
<script>
	<cfif IsDefined("reload_link")>
		window.location.reload();
	<cfelse>
		<cfif isdefined("attributes.fuseaction_reload") and len(attributes.fuseaction_reload)>
			window.location.href = '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction_reload#</cfoutput>';
		<cfelse>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.get_warnings_content&reservedfuseaction=#attributes.reservedfuseaction#</cfoutput>','warnings_div_');
		</cfif>
	</cfif>
</script>