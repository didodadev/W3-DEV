<cfparam name="attributes.isAjax" default="0">
<cfparam name="attributes.style" default="1">

<cfif (cgi.referer contains 'workflowpages' or cgi.referer contains 'emptypopup_dsp_upd_warning') and attributes.isAjax eq 0 >
    <cfset attributes.warning_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.warning_id,accountKey:'wrk')>
    <cfset attributes.sub_warning_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.sub_warning_id,accountKey:'wrk')>
</cfif>
<cfif attributes.style eq 0>
	<cfif isdefined("attributes.warning_is_active")>
		<cfquery name="UPD_PAGE_WARNING" datasource="#dsn#">
			UPDATE PAGE_WARNINGS SET IS_ACTIVE = 0 
			WHERE 
				W_ID = #attributes.warning_id#
				<cfif isdefined("attributes.sub_warning_id") and len(attributes.sub_warning_id)>
					OR W_ID = #attributes.sub_warning_id#
				</cfif>
		</cfquery>
	</cfif>
	<cfquery name="GET_WARNINGS" datasource="#dsn#">
		SELECT
			W_ID,
			PARENT_ID,
			URL_LINK,
			WARNING_HEAD,
			WARNING_DESCRIPTION,
			WARNING_RESULT,
			RESPONSE,
			SETUP_WARNING_ID,
			LAST_RESPONSE_DATE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_PAR,
			RECORD_CON,
			POSITION_CODE,
			IS_AGENDA,
			IS_CONTENT
		FROM
			PAGE_WARNINGS
		WHERE
			W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.warning_id#">
	</cfquery>
	<cf_popup_box title="#getLang('myhome',169)#">
		<cfform action="#request.self#?fuseaction=myhome.emptypopup_dsp_upd_warning" name="form_warning_result" method="post">
			<cfoutput query="get_warnings">
				<input type="hidden" name="warning_mode" id="warning_mode" value="add_comment_from_popup">
				<input type="hidden" name="parent_id" id="parent_id" value="#w_id#">
				<input type="hidden" name="url_link" id="url_link" value="#url_link#">
				<input type="hidden" name="warning_head" id="warning_head" value="#warning_head#">
				<input type="hidden" name="setup_warning_id" id="setup_warning_id" value="#setup_warning_id#">
				<input type="hidden" name="warning_description" id="warning_description" value="#warning_description#">
				<input type="hidden" name="response_date" id="response_date" value="#last_response_date#">
				<input type="hidden" name="warning_id" id="warning_id" value="#attributes.warning_id#">
				<input type="hidden" name="sub_warning_id" id="sub_warning_id" value="#attributes.sub_warning_id#"> 
				<table width="99%" align="center">
					<tr>
						<td width="100" class="txtbold"><cf_get_lang_main no='468.Belge No'></td>
						<td>: #w_id#</td>
					</tr>
					<tr>
						<td width="100" class="txtbold"><cf_get_lang no='71.Talep'></td>
						<td>: #warning_head#</td>
					</tr>
						<tr>
						<td width="100" class="txtbold"><cf_get_lang no='72.Talep Eden'></td>
						<td>: <cfif len(record_emp)>#get_emp_info(record_emp,0,1)#<cfelseif len(record_par)>#get_par_info(record_par,0,0,1)#<cfelseif len(record_con)>#get_cons_info(record_con,1,1)#</cfif></td>
					</tr>
					<tr>
					<td width="100" class="txtbold"><cf_get_lang_main no='166.Yetkili'></td>
						<td>: #get_emp_info(position_code,1,1)#</td>
					</tr>	
						<tr>
						<td width="100" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
						<td>: #warning_description#</td>
					</tr>
					<tr>
						<td width="100" class="txtbold"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
						<td>: #dateformat(date_add('h',session.ep.time_zone,GET_WARNINGS.RECORD_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,GET_WARNINGS.RECORD_DATE),timeformat_style)#<br/>
						</td>
					</tr>
					<tr>
						<td width="100" class="txtbold"><cf_get_lang no='10.Son Cevap Tarihi'></td>
						<td>: #dateformat(date_add('h',session.ep.time_zone,GET_WARNINGS.LAST_RESPONSE_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,GET_WARNINGS.LAST_RESPONSE_DATE),timeformat_style)#<br/>
						</td>
					</tr>
						<cfif len(warning_result)>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang_main no='272.Sonuç'></td>
								<td>: #warning_result#</td>
							</tr>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang_main no='1242.Cevap'></td>
								<td>: #response#</td>
							</tr>
						</cfif>		
					<tr>
						<td colspan="2" height="15" valign="middle"><hr></td>
					</tr>
						<cfset attributes.warning_condition = 0>
						<cfset attributes.parent_id = attributes.warning_id>
						<cfinclude template="../query/get_warnings.cfm">
						<cfif not get_warnings.recordcount>
							<input type="hidden" name="last_warning_id" id="last_warning_id" value="#w_id#">		
						</cfif>
						<cfset max_record_id = get_warnings.recordcount>
						<cfset index = 0>
						<cfloop query="get_warnings">
							<cfset index = index + 1>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang_main no='468.Belge No'></td>
								<td>: #w_id#</td>
							</tr>		
								<tr>
								<td width="100" class="txtbold"><cf_get_lang no='71.Talep'></td>
								<td>: #warning_head#</td>
							</tr>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang no='72.Talep Eden'></td>
								<td>: <cfif len(record_emp)>#get_emp_info(record_emp,0,1)#<cfelseif len(record_par)>#get_par_info(record_par,0,0,1)#<cfelseif len(record_con)>#get_cons_info(record_con,1,1)#</cfif></td>
							</tr>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang_main no='166.Yetkili'></td>
								<td>: #get_emp_info(position_code,1,1)#</td>
							</tr>		
							<tr>
								<td width="100" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
								<td>: #warning_description#</td>
							</tr>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
								<td>: #dateformat(date_add('h',session.ep.time_zone,GET_WARNINGS.RECORD_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,GET_WARNINGS.RECORD_DATE),timeformat_style)#<br/>
								</td>
							</tr>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang no='10.Son Cevap Tarihi'></td>
								<td>: #dateformat(date_add('h',session.ep.time_zone,GET_WARNINGS.last_response_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,GET_WARNINGS.last_response_date),timeformat_style)#<br/>
								</td>
							</tr>
								<cfif Len(warning_result)>
									<tr>
										<td width="100" class="txtbold"><cf_get_lang_main no='272.Sonuç'></td>
										<td>: #warning_result#</td>
									</tr>
										<tr>
										<td width="100" class="txtbold"><cf_get_lang_main no='1242.Cevap'></td>
										<td>: #response#</td>
									</tr>
								</cfif>		
							<tr>
								<td colspan="2" height="15" valign="middle"><hr></td>
							</tr>
							<cfif max_record_id eq index>
								<input type="hidden" name="last_warning_id" id="last_warning_id" value="#w_id#">
							</cfif>		
						</cfloop>
						<cfif len(record_emp)>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang_main no='272.Sonuç'></td>
								<td><cfquery name="GET_SETUP_WARNING_RESULT" datasource="#dsn#">
									SELECT * FROM SETUP_WARNING_RESULT ORDER BY SETUP_WARNING_RESULT
									</cfquery>				  				  
										<select name="warning_result" id="warning_result" style="width:150px;">
											<cfloop query="get_setup_warning_result">
												<option value="#setup_warning_result#">#setup_warning_result#</option>
											</cfloop>
										</select>
								</td>
							</tr>
							<tr>
								<td width="100" class="txtbold"><cf_get_lang_main no='166.Yetkili'> *</td>
									<cfquery name="get_pos_code" datasource="#dsn#">
										SELECT
										POSITION_CODE
										FROM
										EMPLOYEE_POSITIONS
										WHERE
										EMPLOYEE_ID = #record_emp#
									</cfquery>
								<td><input type="hidden" name="position_code" id="position_code" value="#get_pos_code.position_code#">
									<cfsavecontent variable="yetkili"><cf_get_lang no='167.Yetkili girmelisiniz'>!</cfsavecontent>
									<cfinput type="text" name="employee" message="#yetkili#" required="yes" style="width:150px;" value="#get_emp_info(record_emp,0,0)#" readonly="yes">
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=form_warning_result.position_code&field_name=form_warning_result.employee','list');"><img src="/images/plus_thin.gif"></a>
										&nbsp;<input type="checkbox" name="is_agenda" id="is_agenda" value="1" <cfif is_agenda eq 1>checked</cfif>/>&nbsp;<cf_get_lang dictionary_id='32369.Ajandada Göster'>
								</td>
							</tr>
							<tr>
								<td width="100" class="txtbold" valign="top"><cf_get_lang_main no='1242.Cevap'></td>
								<td valign="top"><textarea name="warning_response" id="warning_response" maxlength="1000" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" style="width:300px;height:100px;"></textarea></td>
							</tr>
						</cfif>						
				</table>
				<cf_popup_box_footer>
					<cfif is_content eq 1><!--- eğer rule den geliyorsa silinmesin is_content add_optionstan gelecek --->
						<cf_workcube_buttons is_upd='1' is_delete='0' type_format="1" add_function='kontrol()'></td>
					<cfelse>
						<cf_workcube_buttons is_upd='1' type_format="1" delete_page_url='#request.self#?fuseaction=myhome.emptypopup_del_warning&w_id=#w_id#' add_function='kontrol()'></td>
					</cfif>
				</cf_popup_box_footer>
			</cfoutput>
		</cfform>
	</cf_popup_box>
<cfelse>
	
	<cfset get_messages = createObject("Component","V16.objects.cfc.messages") />
	<cfset getEmployeeInfo = createObject("Component","Utility.getEmployeeInfo") />

	<cfform action="#request.self#?fuseaction=myhome.emptypopup_dsp_upd_warning" name="form_warning_result" method="post">
		<cfinput type="hidden" name="url_link" id="url_link" value="#GET_WARNINGS.URL_LINK#">
		<cfinput type="hidden" name="warning_head" id="warning_head" value="#GET_WARNINGS.WARNING_HEAD#">
		<cfinput type="hidden" name="to_pos_codes" id="to_pos_codes" value="#(len(to_pos_code) ? to_pos_code : '' )#">
		<cfif GET_WARNINGS.IS_MANUEL_NOTIFICATION eq 1>
			<cfinput type="hidden" name="parent_id" id="parent_id" value="#GET_WARNINGS.PARENT_ID#">
		<cfelse>
			<cfinput type="hidden" name="action_id" id="action_id" value="#GET_WARNINGS.ACTION_ID#">
			<cfinput type="hidden" name="action_column" id="action_column" value="#GET_WARNINGS.ACTION_COLUMN#">
		</cfif>
		<cfset get_warning_messages = get_messages.get_warning_messages(
			action_id : len(GET_WARNINGS.ACTION_ID) ? GET_WARNINGS.ACTION_ID : 0,
			parent_id : GET_WARNINGS.IS_MANUEL_NOTIFICATION eq 1 ? GET_WARNINGS.PARENT_ID : 0,
			fuseaction : #attributes.action#
		)>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div id="all_messages" class="scrollbar scrltp all_messages" style="background: none !important">                   
				<cfif get_warning_messages.recordcount>
					<cfoutput query="get_warning_messages">
						<div class="message-info">
							<div class="message-user-info">
								<cfif len(SENDER_PHOTO) and FileExists("#upload_folder#hr\#SENDER_PHOTO#")>
									<img class="img-circle" width="30" height="30" src="../documents/hr/#SENDER_PHOTO#" data-toggle="tooltip" data-placement="top" title="#SENDER_NAME# #SENDER_SURNAME#"/>
								<cfelse>
									<span class="letter #getEngLetterColor(Left(SENDER_NAME, 1))#" style="height:30px;width:30px;">
										<small>
											#Left(SENDER_NAME, 1)##Left(SENDER_SURNAME, 1)#
										</small>
									</span>
								</cfif>
								<span class="userinfo">
									#SENDER_NAME# #SENDER_SURNAME#
								</span>
							</div>
							<div class="message-text">#MESSAGE#</div>
							<div class="message-date">#dateformat(send_date,dateformat_style)#-#timeformat(send_date,timeformat_style)#</div>
						</div>
					</cfoutput>
				</cfif>
				<div id="new_message"></div>                                     
			</div>
		</div>
		<div class="message_area content-item content-item-special">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<div id="messageArea" style="display:none;"></div>
				<textarea id="text_area" class="text_area" name="warning_response" rows="1" max-rows="4" class="embed-responsive-item" placeholder="<cf_get_lang dictionary_id='58654.Cevap'>" name="text"></textarea>
				<button class="pull-right send_btn" onclick="sendComment()" disabled><i class="fa fa-paper-plane"></i></button>
			</div>
		</div>
	</cfform>

</cfif>

<script type="text/javascript">
	$(function () {
		$('[data-toggle="tooltip"]').tooltip();
		$("div#workcube_button").css("margin", "0px");
	});

	var textControl = false;

	<cfif attributes.style eq 1>

	function sendComment() {
		
		<cfset userinfo = getEmployeeInfo.get()>
		<cfoutput>
		if(AjaxFormSubmit("form_warning_result","messageArea")){
			var lastMessage = $(".text_area").val();
			$(".text_area").val("");
			var newMessageHtml = $("##new_message").html();
			$("##new_message").html( newMessageHtml + '<div class="message-info"><div class="message-user-info"><cfif len(userinfo.PHOTO) and FileExists("#upload_folder#hr\#userinfo.PHOTO#")><img class="img-circle" width="30" height="30" src="../documents/hr/#userinfo.PHOTO#" data-toggle="tooltip" data-placement="top" title="#session.ep.name# #session.ep.surname#"/><cfelse><span class="letter #getEngLetterColor(Left(session.ep.name, 1))#" style="height:30px;width:30px;"><small>#Left(session.ep.name, 1)##Left(session.ep.surname, 1)#</small></span></cfif><span class="userinfo">#session.ep.name# #session.ep.surname#</span></div><div class="message-text">'+ convert(lastMessage) +'</div><div class="message-date"><cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput></div></div>' );
			$("form[name = form_warning_result] .send_btn").attr('disabled',true); 
			$("form[name = form_warning_result] .send_btn").css('background-color','##b3d0a6');
			textControl = false;
		}
		return false;
		</cfoutput>

	}

	$(".text_area").on("keyup keydown",function(event){
		sendButtonManagement();
	});

	</cfif>

	function sendButtonManagement(){

		var messageText = $.trim($(".text_area").val());
		if( messageText != ""){

			$("form[name = form_warning_result] .send_btn").attr('disabled',false);
			$("form[name = form_warning_result] .send_btn").css('background-color','#89ba73');
			textControl = true;

		}else{

			$("form[name = form_warning_result] .send_btn").attr('disabled',true); 
			$("form[name = form_warning_result] .send_btn").css('background-color','#b3d0a6');
			textControl = false;

		}

	}

	$(".text_area").keypress(function (e) {
		if(e.which == 13 && !e.shiftKey && textControl) {        
			sendComment();
			e.preventDefault();
			return false;
		}
	});

</script>