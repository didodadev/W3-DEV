<cf_xml_page_edit fuseact="process.process_rows">
<cfquery name="GET_ALL_PROCESS_ROWS" datasource="#DSN#">
	SELECT 
		PROCESS_ROW_ID,
		STAGE
	FROM PROCESS_TYPE_ROWS
	WHERE 
		PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
		AND PROCESS_ROW_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
	ORDER BY 
		LINE_NUMBER ASC
</cfquery>
<cfif fusebox.use_period eq true>
    <cfset dsn_spf = DSN3>
<cfelse>
    <cfset dsn_spf = dsn>
</cfif>
<cfquery name="GET_ALL_PRINT" datasource="#dsn_spf#">
	SELECT FORM_ID, NAME FROM SETUP_PRINT_FILES WHERE ACTIVE = 1 AND NAME IS NOT NULL AND NAME !='' ORDER BY NAME ASC
</cfquery>
<cfquery name="GET_PROCESS_ROWS" datasource="#DSN#">
	SELECT 
		#dsn#.Get_Dynamic_Language(PROCESS_TYPE_ROWS.PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,PROCESS_TYPE_ROWS.STAGE) AS STAGE,
		#dsn#.Get_Dynamic_Language(PROCESS_TYPE_ROWS.PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','DETAIL',NULL,NULL,PROCESS_TYPE_ROWS.DETAIL) AS DETAIL,
		PROCESS_TYPE_ROWS.*,
		PROCESS_TYPE.IS_STAGE_BACK,
		#dsn#.Get_Dynamic_Language(PROCESS_TYPE.PROCESS_ID,'#session.ep.language#','PROCESS_TYPE','PROCESS_NAME',NULL,NULL,PROCESS_TYPE.PROCESS_NAME) AS PROCESS_NAME
	FROM
		PROCESS_TYPE_ROWS,
		PROCESS_TYPE
	WHERE
		PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
</cfquery>
<cfparam name="attributes.process_name" default="#GET_PROCESS_ROWS.PROCESS_NAME#">
<cfparam name="attributes.process_id" default="">
<cfquery name="get_max_line_number" datasource="#dsn#">
	SELECT MAX(LINE_NUMBER) AS MAX_LINE_NUMBER FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = #attributes.process_id#
</cfquery>
<cfset max_line_number_ = get_max_line_number.max_line_number + 1>
<cfsavecontent variable="right_images_">
	<cfif not listfindnocase(denied_pages,'process.emtypopup_dsp_process_file_history')><cfoutput>#request.self#?fuseaction=process.emtypopup_dsp_process_file_history&process_row_id=#attributes.process_row_id#</cfoutput>
    </cfif>
</cfsavecontent>
<cf_catalystHeader>
<div style="display:none;z-index:999;" id="process_templates"></div>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='38261.Aşama Güncelle'></cfsavecontent>
<div style="display:none;z-index:999;" id="history"></div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#get_process_rows.process_name# : #get_process_rows.stage#">
		<cfform name="upd_process_row" id="upd_process_row" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=process.emptypopup_upd_process_rows">
				<input type="hidden" name="process_row_id" id="process_row_id" value="<cfoutput>#attributes.process_row_id#</cfoutput>">
				<cf_box_elements class="row" type="row">
					<div class="col col-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-line_replace_">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36250.Sıra No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="line_replace_" id="line_replace_" value="<cfoutput>#get_process_rows.line_number#</cfoutput>"onKeyup="isNumber(this);">
							</div>
						</div>
						<cfif xml_show_stage_code>
							<div class="form-group" id="item-stage_code">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'> <cf_get_lang dictionary_id='32646.Kodu'></label>
								<div class="col col-8 col-xs-12">
									<cfinput type="text" name="stage_code" id="stage_code" value="#get_process_rows.stage_code#" maxlength="15">
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-stage">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'>*</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="stage" id="stage" value="#get_process_rows.stage#" required="yes" message="Aşama Girmelisiniz !" >
									<span class="input-group-addon">
										<cf_language_info 
											table_name="PROCESS_TYPE_ROWS" 
											column_name="STAGE" 
											column_id_value="#attributes.process_row_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="PROCESS_ROW_ID" 
											control_type="0">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36213.Geri Bildirim Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<label class="col col-2 col-xs-2"><cf_get_lang dictionary_id='57491.Saat'></label>
								<div class="col col-4 col-xs-4">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='36216.Lütfen Sayısal Bir Değer Giriniz'> !</cfsavecontent>
									<cfinput type="text" name="last_answer_hour" id="last_answer_hour" value="#get_process_rows.answer_hour#" validate="integer" message="#message#" >
								</div>
								<label class="col col-2 col-xs-2"><cf_get_lang dictionary_id='58127.Dakika'></label>
								<div class="col col-4 col-xs-4">    
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='36216.Lütfen Sayısal Bir Değer Giriniz'> !</cfsavecontent>
									<cfinput type="text" name="last_answer_minute" id="last_answer_minute" value="#get_process_rows.answer_minute#" validate="integer" message="" >
								</div>   
							</div> 
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<textarea name="detail" id="detail"><cfoutput>#get_process_rows.detail#</cfoutput></textarea>
									<span class="input-group-addon">
										<cf_language_info 
										table_name="PROCESS_TYPE_ROWS" 
										column_name="DETAIL" 
										column_id_value="#attributes.process_row_id#" 
										maxlength="500" 
										datasource="#dsn#" 
										column_id="PROCESS_ROW_ID" 
										control_type="0">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-display_file_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59000.Display File'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(get_process_rows.display_file_name)>
										<input type="hidden" name="is_display_file_name" id="is_display_file_name" value="<cfoutput>#get_process_rows.is_display_file_name#</cfoutput>"> 
										
										<input type="file" name="display_file_name" id="display_file_name" style="display:none;">
										<input type="text" name="display_file_name_rex" id="display_file_name_rex" readonly=""  value="<cfoutput>#get_process_rows.display_file_name#</cfoutput>">
									
										<span class="input-group-addon" id="value11" href="javascript://" style="display:none;" onClick="open_history('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&is_submitted=1&field_name=upd_process_row.display_file_name_rex&field_id=upd_process_row.display_file_name&is_file=upd_process_row.is_display_file_name&type=1&process_type=1','process_templates');"><i class="fa fa-plus"></i></span>
										<span class="input-group-addon" href="javascript://" id="value12" onClick="temizle();"><i class="fa fa-minus"></i></span>
									
									<cfelse>
										<input type="hidden" name="is_display_file_name" id="is_display_file_name" value="">

										<input type="file" name="display_file_name" id="display_file_name" >
										<input type="text" name="display_file_name_rex" id="display_file_name_rex" style="display:none;width:250px;">
								
										<span class="input-group-addon" id="value11" href="javascript://" onClick="open_history('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&is_submitted=1&field_name=upd_process_row.display_file_name_rex&field_id=upd_process_row.display_file_name&is_file=upd_process_row.is_display_file_name&type=1&process_type=1','process_templates');"><i class="fa fa-plus"></i></span>
										<span class="input-group-addon" href="javascript://" id="value12" style="display:none;" onClick="temizle();"><i class="fa fa-minus"></i></span>
										
									</cfif>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-file_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59001.Action File'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(get_process_rows.file_name)>
										<input type="hidden" name="is_file_name" id="is_file_name" value="<cfoutput>#get_process_rows.is_file_name#</cfoutput>">
										<input type="file" name="file_name" id="file_name" style="display:none;">
										<input type="text" name="file_name_rex" id="file_name_rex" value="<cfoutput>#get_process_rows.file_name#</cfoutput>" readonly="">
									
										<a id="value21" href="javascript://" style="display:none;" onClick="open_history('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&is_submitted=1&field_name=upd_process_row.file_name_rex&field_id=upd_process_row.file_name&is_file=upd_process_row.is_file_name&type=2&process_type=1','process_templates');"><i class="fa fa-plus"></i></a>
										<span class="input-group-addon" href="javascript://" id="value22" onClick="temizle_action();"><i class="fa fa-minus"></i></span>
									<cfelse>
										<input type="hidden" name="is_file_name" id="is_file_name" value="">
										<input type="file" name="file_name" id="file_name" ><input type="text" name="file_name_rex" id="file_name_rex" style="display:none;">
										<span class="input-group-addon" id="value21" href="javascript://" onClick="open_history('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&is_submitted=1&field_name=upd_process_row.file_name_rex&field_id=upd_process_row.file_name&is_file=upd_process_row.is_file_name&type=2&process_type=1','process_templates');"><i class="fa fa-plus"></i></span>
										<span class="input-group-addon" href="javascript://" id="value22" style="display:none;" onClick="temizle_action();"><i class="fa fa-minus"></i></span>
									</cfif>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_stage_action">
							<label class="col col-4 col-xs-12" for="is_stage_action"><cf_get_lang dictionary_id='62181.Aşama Action File Include'></label>
							<div class="col col-8 col-xs-12"> 
								<label>
									<input type="checkbox" name="is_stage_action" id="is_stage_action" value="1" <cfif get_process_rows.is_stage_action eq 1>checked</cfif>><cf_get_lang dictionary_id='62183.Aşama değişmese de Action File Çalışır'>
								</label>
							</div>	
						</div>
						<div class="form-group" id="item-is_display">
							<label class="col col-4 col-xs-12" for="is_display"><cf_get_lang dictionary_id='58206.Main'><cf_get_lang dictionary_id='59000.Display File'><cf_get_lang dictionary_id='36230.Include Et'></label>
							<div class="col col-8 col-xs-12"> 
								<label>
									<input type="checkbox" name="is_display" id="is_display" value="1" <cfif get_process_rows.is_display eq 1>checked</cfif>><cf_get_lang dictionary_id="60691.Seçildiğinde Aşama Display File Çalışmaz.">
								</label>
							</div>
						</div>
						<div class="form-group" id="item-is_action">
							<label class="col col-4 col-xs-12" for="is_action"><cf_get_lang dictionary_id='58206.Main'><cf_get_lang dictionary_id='59001.Action File'><cf_get_lang dictionary_id='36230.Include Et'></label>
							<div class="col col-8 col-xs-12"> 
								<label>
									<input type="checkbox" name="is_action" id="is_action" value="1" <cfif get_process_rows.is_action eq 1>checked</cfif>><cf_get_lang dictionary_id="60692.Seçildiğinde Aşama Action File Çalışmaz.">
								</label>
							</div>
						</div>
						<div class="form-group" id="item-template_print">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60375.Template Print'></label>
							<div class="col col-8 col-xs-12">
								<select name="template_print_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfif GET_ALL_PRINT.recordCount>
										<cfoutput query="GET_ALL_PRINT">
											<option value="#FORM_ID#" #iif( FORM_ID eq get_process_rows.TEMPLATE_PRINT_ID, DE('selected'), DE('') )#>#NAME#</option>
										</cfoutput>
									</cfif>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-destination_fuseaction">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60376.Destination WO'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="destination_wo" id="destination_wo"><cfoutput>#get_process_rows.DESTINATION_WO#</cfoutput></textarea>
							</div>
						</div>
						<div class="form-group" id="item-destination_event">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60377.Destination Event'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="destination_event" id="destination_event" value="<cfoutput>#get_process_rows.DESTINATION_EVENT#</cfoutput>">
							</div>
						</div>
					</div>
					<div class="col col-6 col-sm-6 col-xs-12">
						<cfif xml_show_confirm_selection>
							<cf_seperator title="Checker" id="checker" is_closed="1" class="mb-4 mt-1 padding-right-0 col-md-12 col-sm-12 col-xs-12">
							<div id="checker">
								<div class="form-group" id="item-comment_request">
									<label class="col col-12 col-xs-12" for="comment_request"><input type="checkbox" name="comment_request" id="comment_request" value="1" <cfif get_process_rows.comment_request eq 1>checked</cfif>><cf_get_lang dictionary_id='61054.Yorum Al'></label>
								</div>
								<div class="form-group" id="item-confirm_request">
									<label class="col col-12 col-xs-12" for="confirm_request"><input type="checkbox" name="confirm_request" id="confirm_request" value="1" <cfif get_process_rows.confirm_request eq 1>checked</cfif> onclick="confirmRequest()"><cf_get_lang dictionary_id='30389.Onay İste'></label>
								</div>
								<div class="checkerSettings" <cfif not len(get_process_rows.confirm_request) or get_process_rows.confirm_request eq 0>style="display:none;"</cfif>>
									<div id="confirmList">
										<hr class="mt-3">
										<div class="form-group mt-3 mb-3"><label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60359.Aksiyon sonrasında süreç aşamasını değiştirmek için aşağıdaki açılır listeden seçim yapabilirsiniz'>!</label></div>
										<div class="form-group" id="item-is_confirm">
											<label class="col col-3 col-xs-6" for="is_confirm"><input type="checkbox" name="is_confirm" id="is_confirm" value="1" <cfif get_process_rows.is_confirm eq 1>checked</cfif>><cf_get_lang dictionary_id='57500.Onay'></label>
											<label class="col col-4 col-xs-6" for="is_confirm_comment"><input type="checkbox" name="is_confirm_comment" id="is_confirm_comment" value="1" <cfif get_process_rows.is_confirm_comment_required eq 1>checked</cfif>><cf_get_lang dictionary_id='61091.Yorum zorunlu olsun'></label>
											<div class="col col-5 col-xs-12">
												<select name="is_confirm_stage" id="is_confirm_stage" <cfif get_process_rows.is_confirm neq 1>disabled</cfif>>
													<option value=""><cf_get_lang dictionary_id='54530.Aşama Seçiniz'></option>
													<cfoutput query="GET_ALL_PROCESS_ROWS">
														<option value="#PROCESS_ROW_ID#" #iif(get_process_rows.IS_CONFIRM_STAGE_ID eq PROCESS_ROW_ID, DE('selected'), DE('') )#>#STAGE#</option>
													</cfoutput>
												</select>
											</div>
										</div> 
										<div class="form-group" id="item-is_refuse">
											<label class="col col-3 col-xs-6" for="is_refuse"><input type="checkbox" name="is_refuse" id="is_refuse" value="1" <cfif get_process_rows.is_refuse eq 1>checked</cfif>><cf_get_lang dictionary_id='29537.Red'></label>
											<label class="col col-4 col-xs-6" for="is_refuse_comment"><input type="checkbox" name="is_refuse_comment" id="is_refuse_comment" value="1" <cfif get_process_rows.is_refuse_comment_required eq 1>checked</cfif>><cf_get_lang dictionary_id='61091.Yorum zorunlu olsun'></label>
											<div class="col col-5 col-xs-12">
												<select name="is_refuse_stage" id="is_refuse_stage" <cfif get_process_rows.is_refuse neq 1>disabled</cfif>>
													<option value=""><cf_get_lang dictionary_id='54530.Aşama Seçiniz'></option>
													<cfoutput query="GET_ALL_PROCESS_ROWS">
														<option value="#PROCESS_ROW_ID#" #iif(get_process_rows.IS_REFUSE_STAGE_ID eq PROCESS_ROW_ID, DE('selected'), DE('') )#>#STAGE#</option>
													</cfoutput>
												</select>
											</div>
										</div>
										<div class="form-group" id="item-is_again">
											<label class="col col-3 col-xs-6" for="is_again"><input type="checkbox" name="is_again" id="is_again" value="1" <cfif get_process_rows.is_again eq 1>checked</cfif>><cf_get_lang dictionary_id='57214.Tekrar Yap'></label>
											<label class="col col-4 col-xs-6" for="is_again_comment"><input type="checkbox" name="is_again_comment" id="is_again_comment" value="1" <cfif get_process_rows.is_again_comment_required eq 1>checked</cfif>><cf_get_lang dictionary_id='61091.Yorum zorunlu olsun'></label>
											<div class="col col-5 col-xs-12">
												<select name="is_again_stage" id="is_again_stage" <cfif get_process_rows.is_again neq 1>disabled</cfif>>
													<option value=""><cf_get_lang dictionary_id='54530.Aşama Seçiniz'></option>
													<cfoutput query="GET_ALL_PROCESS_ROWS">
														<option value="#PROCESS_ROW_ID#" #iif(get_process_rows.IS_AGAIN_STAGE_ID eq PROCESS_ROW_ID, DE('selected'), DE('') )#>#STAGE#</option>
													</cfoutput>
												</select>
											</div>
										</div>
										<div class="form-group" id="item-is_support">
											<label class="col col-3 col-xs-6" for="is_support"><input type="checkbox" name="is_support" id="is_support" value="1" <cfif get_process_rows.is_support eq 1>checked</cfif>><cf_get_lang dictionary_id='57218.Başkasına Gönder'></label>
											<label class="col col-4 col-xs-6" for="is_support_comment"><input type="checkbox" name="is_support_comment" id="is_support_comment" value="1" <cfif get_process_rows.is_support_comment_required eq 1>checked</cfif>><cf_get_lang dictionary_id='61091.Yorum zorunlu olsun'></label>
											<div class="col col-5 col-xs-12">
												<select name="is_support_stage" id="is_support_stage" <cfif get_process_rows.is_support neq 1>disabled</cfif>>
													<option value=""><cf_get_lang dictionary_id='54530.Aşama Seçiniz'></option>
													<cfoutput query="GET_ALL_PROCESS_ROWS">
														<option value="#PROCESS_ROW_ID#" #iif(get_process_rows.IS_SUPPORT_STAGE_ID eq PROCESS_ROW_ID, DE('selected'), DE('') )#>#STAGE#</option>
													</cfoutput>
												</select>
											</div>
										</div>
										<div class="form-group" id="item-is_cancel">
											<label class="col col-3 col-xs-6" for="is_cancel"><input type="checkbox" name="is_cancel" id="is_cancel" value="1" <cfif get_process_rows.is_cancel eq 1>checked</cfif>><cf_get_lang dictionary_id='58506.İptal'></label>
											<label class="col col-4 col-xs-6" for="is_cancel_comment"><input type="checkbox" name="is_cancel_comment" id="is_cancel_comment" value="1" <cfif get_process_rows.is_cancel_comment_required eq 1>checked</cfif>><cf_get_lang dictionary_id='61091.Yorum zorunlu olsun'></label>
											<div class="col col-5 col-xs-12">
												<select name="is_cancel_stage" id="is_cancel_stage" <cfif get_process_rows.is_cancel neq 1>disabled</cfif>>
													<option value=""><cf_get_lang dictionary_id='54530.Aşama Seçiniz'></option>
													<cfoutput query="GET_ALL_PROCESS_ROWS">
														<option value="#PROCESS_ROW_ID#" #iif(get_process_rows.IS_CANCEL_STAGE_ID eq PROCESS_ROW_ID, DE('selected'), DE('') )#>#STAGE#</option>
													</cfoutput>
												</select>
											</div>
										</div>
									</div>
									<hr class="mt-2">
									<div class="form-group mt-3 mb-3"><label class="col col-12 col-xs-12"><b><cf_get_lang dictionary_id='65155.Süreci İşleten Rol-Poziyon'></b></label></div>
									
									<div class="form-group mt-3 mb-3"><label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='65157.İlk Kayıt Yapan Rol-Pozisyon'></label></div>
									<div class="form-group" id="item-is_confirm_first_chief_recording">
										<label class="col col-12 col-xs-12" for="is_confirm_first_chief_recording"><input type="checkbox" name="is_confirm_first_chief_recording" id="is_confirm_first_chief_recording" value="1" <cfif get_process_rows.is_confirm_first_chief_recording eq 1>checked</cfif>><cf_get_lang dictionary_id='33648.1.Amirden onay al'></label>
									</div>
									<div class="form-group" id="item-is_confirm_second_chief_recording">
										<label class="col col-12 col-xs-12" for="is_confirm_second_chief_recording"><input type="checkbox" name="is_confirm_second_chief_recording" id="is_confirm_second_chief_recording" value="1" <cfif get_process_rows.is_confirm_second_chief_recording eq 1>checked</cfif>><cf_get_lang dictionary_id='33647.2.Amirden onay al'></label>
									</div>

									<div class="form-group mt-3 mb-3"><label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='65156.İşlem Yapan - İşlem Yapılan Rol Pozisyon'></label></div>
									<div class="form-group" id="item-is_confirm_first_chief">
										<label class="col col-12 col-xs-12" for="is_confirm_first_chief"><input type="checkbox" name="is_confirm_first_chief" id="is_confirm_first_chief" value="1" <cfif get_process_rows.is_confirm_first_chief eq 1>checked</cfif>><cf_get_lang dictionary_id='33648.1.Amirden onay al'></label>
									</div>
									<div class="form-group" id="item-is_confirm_second_chief">
										<label class="col col-12 col-xs-12" for="is_confirm_second_chief"><input type="checkbox" name="is_confirm_second_chief" id="is_confirm_second_chief" value="1" <cfif get_process_rows.is_confirm_second_chief eq 1>checked</cfif>><cf_get_lang dictionary_id='33647.2.Amirden onay al'></label>
									</div>
									<div class="form-group" id="item-is_position_code_argument_name">
										<label class="col col-7 col-xs-7" for="is_position_code_argument_name"><input type="checkbox" name="is_position_code_argument_name" id="is_position_code_argument_name" value="1" <cfif len(get_process_rows.position_code_argument_name)>checked</cfif>><cf_get_lang dictionary_id='58586.İşlem Yapan'></label>
										<div class="col col-5 col-xs-7">
											<div class = "input-group">
												<div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='65158.Kişinin pozisyon_code bilgisini içeren form elemanının name değerini giriniz'>.<br><cf_get_lang dictionary_id='65159.Süreç kaydı, girdiğiniz form elemanının değerindeki position_code bilgisiyle atılacaktır'>!</div>
												<input type="text" name="position_code_argument_name" id="position_code_argument_name" <cfif not len(get_process_rows.position_code_argument_name)>disabled</cfif> value="<cfoutput>#get_process_rows.position_code_argument_name#</cfoutput>" placeholder="<cf_get_lang dictionary_id='65160.Form elemanının name değeri'>">
												<span class="input-group-addon icon-question input-group-tooltip"></span>
											</div>
										</div>
									</div>

									<hr class="mt-3">
									<div class="form-group" id="item-is_continue" style="display:none;">
										<!--- Surecdeki Asamalar Geriye Dönebilir checkboxu secili degil ise--->
										<label class="col col-12 col-xs-12">
											<cfif get_process_rows.is_stage_back eq 0>
												<input type="checkbox" name="is_continue" id="is_continue" value="1" <cfif get_process_rows.is_continue eq 1>checked</cfif>>
											<cfelse>
												<input type="checkbox" name="is_continue" id="is_continue" value="1" disabled>
											</cfif>
											<cf_get_lang dictionary_id='33646.Onaydan sonra sonraki aşamaya geç'>
										</label>										
									</div>
									<div class="form-group" id="item-checker_number">
										<label class="col col-7 col-xs-7" for="is_checker_number"><input type="checkbox" name="is_checker_number" id="is_checker_number" value="1" <cfif len(get_process_rows.checker_number)>checked</cfif>><cf_get_lang dictionary_id='61055.Checkerlardan onay al'></label>
										<div class="col col-5 col-xs-7">
											<input type="text" name="checker_number" id="checker_number" <cfif not len(get_process_rows.checker_number)>disabled</cfif> value="<cfoutput>#get_process_rows.checker_number#</cfoutput>" placeholder="<cf_get_lang dictionary_id = '31701.Sayı giriniz'>">
										</div>
									</div>
									<div class="form-group" id="item-is_send_notification_maker">
										<label class="col col-12 col-xs-12" for="is_send_notification_maker"><input type="checkbox" name="is_send_notification_maker" id="is_send_notification_maker" value="1" <cfif get_process_rows.is_send_notification_maker eq 1>checked</cfif>><cf_get_lang dictionary_id='60446.	İlk kayıt yapana bildirim yap'></label>
									</div>
								</div>
								<hr class="mt-3">
								<div class="form-group" id="item-is_checker_update_authority">
									<label class="col col-12 col-xs-12" for="is_checker_update_authority"><input type="checkbox" name="is_checker_update_authority" id="is_checker_update_authority" value="1" <cfif get_process_rows.is_checker_update_authority eq 1>checked</cfif>><cf_get_lang dictionary_id='61056.Checkera güncelleme yetkisi ver'></label>
								</div>
								<div class="form-group" id="item-is_add_access_code">
									<label class="col col-12 col-xs-12" for="is_add_access_code"><input type="checkbox" name="is_add_access_code" id="is_add_access_code" value="1" <cfif get_process_rows.is_add_access_code eq 1>checked</cfif>><cf_get_lang dictionary_id='61057.Bağlantıya erişim kodu ekle'></label>
								</div>
								<div class="form-group" id="item-is_create_password" <cfif get_process_rows.is_add_access_code neq 1>style="display:none;"</cfif>>
									<label class="col col-12 col-xs-12" for="is_create_password"><input type="checkbox" name="is_create_password" id="is_create_password" value="1" <cfif get_process_rows.is_create_password eq 1>checked</cfif>><cf_get_lang dictionary_id='61058.Erişim yapan için şifre üret'></label>
								</div>
								<hr class="mt-3">
								<div class="form-group" id="item-is_employee">
									<label class="col col-12 col-xs-12" for="is_employee"><input type="checkbox" name="is_employee" id="is_employee" value="1" <cfif get_process_rows.is_employee eq 1>checked</cfif>><cf_get_lang dictionary_id='36218.Tüm Çalışanlar'></label>
								</div>	
								<div class="form-group" id="item-is_partner">
									<label class="col col-12 col-xs-12" for="is_partner"><input type="checkbox" name="is_partner" id="is_partner" value="1" <cfif get_process_rows.is_partner eq 1>checked</cfif>><cf_get_lang dictionary_id='36219.Tüm Kurumsal Üyeler'>									
								</div>
								<div class="form-group" id="item-is_consumer">
									<label class="col col-12 col-xs-12" for="is_consumer"><input type="checkbox" name="is_consumer" id="is_consumer" value="1" <cfif get_process_rows.is_consumer eq 1>checked</cfif>><cf_get_lang dictionary_id='36215.Tüm Bireysel Üyeler'>
								</div>
							</div>
						</cfif>
						<cfsavecontent variable="title"><cf_get_lang dictionary_id="58143.İletişim"></cfsavecontent>
						<cf_seperator title="#title#" id="contact" is_closed="1" class="mb-4 mt-4 padding-right-0 col-md-12 col-sm-12 col-xs-12">
						<div id="contact">
							<div class="form-group" id="item-is_online">
								<label class="col col-12 col-xs-12" for="is_online"><input type="checkbox" name="is_online" id="is_online" value="1" <cfif get_process_rows.is_online eq 1>checked</cfif>>Chatflow (<cf_get_lang dictionary_id='57427.Online Mesaj'>)</label>
							</div>
							<div class="form-group" id="item-is_warning">
								<label class="col col-12 col-xs-12" for="is_warning"><input type="checkbox" name="is_warning" id="is_warning" value="1" <cfif get_process_rows.is_warning eq 1>checked</cfif> onclick="workflowChange()">Workflow (<cf_get_lang dictionary_id="47578.Uyarı ve Onaylar">)</label>
							</div>
							<div class="workflow_choose" <cfif get_process_rows.is_warning eq 0>style="display:none;"</cfif>>
								<hr class="mt-3">
								<div class="form-group" id="item-is_required_preview">
									<label class="col col-12 col-xs-12" for="is_required_preview"><input type="checkbox" name="is_required_preview" id="is_required_preview" value="1" <cfif get_process_rows.is_required_preview eq 1>checked</cfif>><cf_get_lang dictionary_id='59767.Önizleme zorunlu olsun'></label>
								</div>
								<div class="form-group" id="item-is_required_action_link"> 
									<label class="col col-12 col-xs-12" for="is_required_action_link"><input type="checkbox" name="is_required_action_link" id="is_required_action_link" value="1" <cfif get_process_rows.is_required_action_link eq 1>checked</cfif>><cf_get_lang dictionary_id='59768.Belge detayını görmek zorunlu olsun'></label>
								</div>
								<hr class="mb-3">
							</div>
							<div class="form-group" id="item-is_email">
								<label class="col col-12 col-xs-12" for="is_email"><input type="checkbox" name="is_email" id="is_email" value="1" <cfif get_process_rows.is_email eq 1>checked</cfif>><cf_get_lang dictionary_id='36212.Email'></label>
							</div>
							<div class="form-group" id="item-is_sms">
								<label class="col col-12 col-xs-12" for="is_sms"><input type="checkbox" name="is_sms" id="is_sms" value="1" <cfif get_process_rows.is_sms eq 1>checked</cfif>><cf_get_lang dictionary_id='36211.SMS'></label>
							</div>
							<div class="form-group" id="item-is_kep">
								<label class="col col-12 col-xs-12" for="is_kep"><input type="checkbox" name="is_kep" id="is_kep" value="1" <cfif get_process_rows.is_kep eq 1>checked</cfif>><cf_get_lang dictionary_id='63591.KEP Adresine Gönder'></label>
							</div>
						</div>						
					</div>
				</cf_box_elements>
				<cf_seperator title="Stage Display - Action File" id="df_af_file">
				<cf_flat_list id="df_af_file">
					<cfif len(get_process_rows.display_file_name) or len(get_process_rows.file_name)>
						<cfoutput>
							<cfif len(get_process_rows.display_file_name)>
								<tr><td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=process.popup_main_display_action_file&is_main_action_file=#get_process_rows.is_display_file_name#&main_action_file=#get_process_rows.display_file_name#&process_id=#attributes.process_id#&process_row_id=#attributes.process_row_id#&display_file=1');">Display File</a></td></tr>
							</cfif>
							<cfif len(get_process_rows.file_name)>
								<tr><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=process.popup_main_display_action_file&is_main_file=#get_process_rows.is_file_name#&main_file=#get_process_rows.file_name#&process_id=#attributes.process_id#&process_row_id=#attributes.process_row_id#&action_file=1');">Action File</a></td></tr>
							</cfif>
						</cfoutput>
					<cfelse>
						<tr><td><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
					</cfif>
				</cf_flat_list>
				<!--- 
				<cf_seperator title="Dynamic Actions" id="dynamic_actions" is_closed="0" class="mb-4 mt-4 padding-right-0 col-md-12 col-sm-12 col-xs-12">
				<div id="dynamic_actions" style="width: 100%; margin-bottom: 16px;">
					<input type="hidden" id="da_rowcount" name="da_rowcount" value="0">
					<table class="ajax_list">
						<thead>
							<tr>
							<th>Schema</th>
							<th>Table</th>
							<th>Key Column</th>
							<th>Key Variable</th>
							<th>Column</th>
							<th>Column Value</th>
							<th><a href="javascript:void(0);" onclick="add_darow()"><i class="fa fa-plus"></a></th>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>
				</div>
				<hr>
				--->
				<!--- <cfif get_process_rows.is_confirm_first_chief neq 1 and get_process_rows.is_confirm_second_chief neq 1>
					<cfinclude template="list_process_workgroup.cfm">
				<cfelse>
					<table><tr><td><cf_get_lang dictionary_id="33659.Bu aşamada amir onayları istendiğinden aşama yetkileri tanımlanamaz">.</td></tr></table>
				</cfif> --->
				<cfinclude template="list_process_workgroup.cfm">
				<div class="ui-form-list-btn">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_record_info query_name="get_process_rows">
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
					</div>
				</div>
				<!--- Bu kısım display ve action file'leri elle değiştirmek için kullanılıyor. --->
		</cfform>	
	</cf_box>
</div>
<script type="text/javascript">
function confirmRequest(){
	if($("input[name = confirm_request]").is(":checked")) $("div.checkerSettings").show();
	else $("div.checkerSettings").hide();
}
function workflowChange(){
	if($("input[name = is_warning]").is(":checked")) $("div.workflow_choose").show();
	else $("div.workflow_choose").hide();
}
$("div#confirmList input[type=checkbox]").click(function(){
	var chekcBoxid = $(this).attr("id");
	var stageSelect = $("div#confirmList select#"+chekcBoxid+"_stage");
	if($(this).is(":checked")) stageSelect.prop("disabled",false);
	else stageSelect.prop("disabled",true);
});
$("input[name=is_checker_number]").click(function(){
	if($(this).is(":checked")) $("input[name = checker_number]").prop("disabled",false);
	else $("input[name = checker_number]").prop("disabled",true);
});
$("input[name=is_position_code_argument_name]").click(function(){
	if($(this).is(":checked")) $("input[name = position_code_argument_name]").prop("disabled",false);
	else $("input[name = position_code_argument_name]").prop("disabled",true);
});
$("input[name=is_confirm_first_chief], input[name=is_confirm_second_chief]").click(function(){
	if($(this).is(":checked")){
		$("input[name = is_confirm_first_chief_recording]").prop("checked",false);
		$("input[name = is_confirm_second_chief_recording]").prop("checked",false);
	}
});
$("input[name=is_confirm_first_chief_recording], input[name=is_confirm_second_chief_recording]").click(function(){
	if($(this).is(":checked")){
		$("input[name = is_confirm_first_chief]").prop("checked",false);
		$("input[name = is_confirm_second_chief]").prop("checked",false);
	}
});
$("#is_add_access_code").click(function(){
	if($(this).is(":checked")) $("#item-is_create_password").show();
	else{
		$("#item-is_create_password").hide();
		$("#is_create_password").prop("checked",false);
	}
});
function kontrol()
{
	var obj =  document.getElementById("file_name").value;
	extention = list_getat(obj,list_len(obj,'.'),'.');
	if(obj != '' && extention != 'cfm') 
	{
		alert("<cf_get_lang dictionary_id ='36242.Lütfen Action File İçin cfm Dosyası Seçiniz '>!");
		return false;
	}
	var obj2 =  document.getElementById("display_file_name").value;
	var extention2 = list_getat(obj2,list_len(obj2,'.'),'.');
	if(obj2 != '' && extention2 != 'cfm') 
	{
		alert("<cf_get_lang dictionary_id ='36243.Lütfen Display File İçin cfm Dosyası Seçiniz'> !");
		return false;
	}
	if(document.getElementById("line_replace_").value == '') 
	{
		alert("<cf_get_lang dictionary_id ='36255.Lütfen Sıra No Giriniz'> !");
		return false;
	}
	if(document.getElementById("line_replace_").value == 0 || document.getElementById("line_replace_").value >= <cfoutput>#max_line_number_#</cfoutput>) 
	{
		alert("<cf_get_lang dictionary_id='36256.Lütfen Sıra No yu Kontrol Ediniz'>");
		return false;
	}
	if(document.getElementById("confirm_request").checked){
		var acc = 0;
		$("div#confirmList input[type=checkbox]:checked").each(function(){
			acc++;
		});
		if(acc == 0){
			alert("<cf_get_lang dictionary_id='60378.En az bir adet onay isteği seçmeniz gerekmektedir'>!");
			return false;
		}
	}
/* 	if (!document.getElementById("upd_process_row").checkValidity()) {
		alert("Lütfen alanları doldurun!");
		document.getElementById("upd_process_row").reportValidity();
		return false;
	} */
	return true;
}

function temizle()
{
	document.getElementById("is_display_file_name").value="";
	document.getElementById("display_file_name").style.display='';
	document.getElementById("display_file_name_rex").style.display='none';
	document.getElementById("value11").style.display='';
	document.getElementById("value12").style.display='none';
	document.getElementById("display_file_name_rex").value='';
}

function temizle_action()
{
	document.getElementById("is_file_name").value="";
	document.getElementById("file_name").style.display='';
	document.getElementById("file_name_rex").style.display='none';
	document.getElementById("value21").style.display='';
	document.getElementById("value22").style.display='none';
	document.getElementById("file_name_rex").value='';
}
<!---
window.da_rowcount = 0;
function add_darow(rowdata) {
	window.da_rowcount++;
	if (rowdata !== undefined && rowdata !== null) {
		rowdata.da_rowcount = window.da_rowcount;
	}
	$("#dynamic_actions table tbody").append( nano(`<tr data-rowid="row{rownum}">
						<td>
							<select name="da_schema{rownum}">
								<option value="main" {mainselected}>Main</option>
								<option value="company" {companyselected}>Company</option>
								<option value="period" {periodselected}>Period</option>
								<option value="product" {productselected}>Product</option>
							</select>
						</td>
						<td>
							<input type="text" name="da_table{rownum}" value="{da_table}" required>
						</td>
						<td>
							<input type="text" name="da_keycolumn{rownum}" value="{da_keycolumn}" required>
						</td>
						<td>
							<input type="text" name="da_keyvariable{rownum}" value="{da_keyvariable}" required>
						</td>
						<td>
							<input type="text" name="da_column{rownum}" value="{da_column}" required>
						</td>
						<td>
							<input type="text" name="da_columnvalue{rownum}" value="{da_columnvalue}" required>
						</td>
						<td><a href="javascript:void(0);" onclick="$(this).closest('tr').remove()"><i class="fa fa-minus"></td>
					</tr>`, rowdata?rowdata:{ rownum: window.da_rowcount }) );
	$("#da_rowcount").val(window.da_rowcount);
}
<cfquery name="QUERY_DYNAMIC_ACTIONS" datasource="#dsn#">
	SELECT * FROM PROCESS_TYPE_ROWS_DYNACT WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.process_row_id#'>
</cfquery>
<cfoutput query="QUERY_DYNAMIC_ACTIONS">
	add_darow( { #da_schema#selected: "selected", da_table: "#da_table#", da_keycolumn: "#da_keycolumn#", da_keyvariable: "#da_keyvariable#", da_column: "#da_column#", da_columnvalue: "#da_columnvalue#" } );
</cfoutput>
--->
	function open_history(url,id) {
		document.getElementById(id).style.display ='';	
		document.getElementById(id).style.width ='500px';	
		$("#"+id).css('margin-left',$("#tabMenu").position().left-500);
		$("#"+id).css('margin-top',$("#tabMenu").position().top);
		$("#"+id).css('position','absolute');	
		
		AjaxPageLoad(url,id,1);
		return false;
	}
</script>
