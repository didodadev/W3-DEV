<cfquery name="GET_EMP_POS" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset position_list = valuelist(get_emp_pos.POSITION_CODE,',')>
<cfquery name="GET_FORM" datasource="#dsn#">
	SELECT * FROM TRAINING_REQUEST WHERE TRAIN_REQUEST_ID = #attributes.form_id#
</cfquery>
<cfif not get_form.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='194.Kayıt silinmiş veya Yetkiniz Bulunmamaktadır'>");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_ROW" datasource="#dsn#">
	SELECT
		TRR.*,
		TC.CLASS_NAME AS NAME
	FROM 
		TRAINING_REQUEST_ROWS TRR,
		TRAINING_CLASS TC
	WHERE 
		TRR.TRAIN_REQUEST_ID = #attributes.form_id# AND
		TC.CLASS_ID = TRR.CLASS_ID AND
		TRR.CLASS_ID IS NOT NULL
	UNION ALL
	SELECT
		TRR.*,
		'' AS NAME
	FROM 
		TRAINING_REQUEST_ROWS TRR
	WHERE 
		TRR.TRAIN_REQUEST_ID = #attributes.form_id# AND
		TRR.CLASS_ID IS NULL AND 
		TRR.TRAINING_ID IS NULL
	UNION ALL
	SELECT
		TRR.*,
		T.TRAIN_HEAD AS NAME
	FROM 
		TRAINING_REQUEST_ROWS TRR,
		TRAINING T
	WHERE 
		TRR.TRAIN_REQUEST_ID = #attributes.form_id# AND
		T.TRAIN_ID = TRR.TRAINING_ID AND
		TRR.TRAINING_ID IS NOT NULL
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">      
        <table width="98%" height="35" align="center"  cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td class="headbold"><cf_get_lang no ='195.Yıllık Eğitim Talebi Onay'></td>
          </tr>
        </table>
                    <table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">
                      <tr>
                        <td class="color-row" valign="top">
                          <table>
							<tr class="color-list">
								<td class="txtbold" colspan="2"><cf_get_lang no ='196.Değerlendirilen'></td>
							</tr>
							<cfform name="add_perf_emp_info" method="post" action="#request.self#?fuseaction=training.emptypopup_add_training_request_valid" enctype="multipart/form-data">
							<input type="hidden" name="form_id" id="form_id" value="<cfoutput>#attributes.form_id#</cfoutput>">
                            <tr>
								<td width="100"><cf_get_lang_main no ='164.Çalışan'> *</td>
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#GET_FORM.EMPLOYEE_ID#</cfoutput>">
								<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#GET_FORM.POSITION_CODE#</cfoutput>">
								<cfif session.ep.ehesap>
									<td>
										<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='164.Çalışan'> !</cfsavecontent>
										<cfinput type="text" name="emp_name" value="#get_emp_info(GET_FORM.EMPLOYEE_ID,0,0)#" required="yes" message="#message#" style="width:180px;">
										<cfif session.ep.ehesap and get_form.first_boss_valid neq 1>
											<!--- <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_under_position_list&field_emp_id=add_perf_emp_info.employee_id&field_pos_code=add_perf_emp_info.position_code&field_name=add_perf_emp_info.emp_name&up_emp_id='+</cfoutput>amir_id_1.value,'list')"><img src="/images/plus_thin.gif" border="0"></a> --->
										</cfif>	
									</td>
								<cfelse>
									<td width="180"><cfoutput>#get_emp_info(GET_FORM.EMPLOYEE_ID,0,0)#</cfoutput></td>
								</cfif>
                            </tr>
							<cfoutput query="get_row">
							<tr class="color-list">
								<td class="txtbold" colspan="2">#name#</td>
							</tr>
                            <tr>
								<td><cf_get_lang no ='198.İlk Amir'> 1</td>
								<td>
									<input type="hidden" name="amir_id_1_old" id="amir_id_1_old" value="#get_form.first_boss_id#">
									<input type="hidden" name="amir_id_1" id="amir_id_1" value="#get_form.first_boss_id#">
									<input type="hidden" name="amir_code_1" id="amir_code_1" value="#get_form.first_boss_code#">
									<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1869.Amir'> !</cfsavecontent>
									<cfif get_form.first_boss_valid eq 1>
										<cfset amir_1_name = get_emp_info(get_form.first_boss_id,0,0)>
									<cfelse>
										<cfset amin_1_name = get_emp_info(get_form.first_boss_code,1,0)>
									</cfif>
									<cfif listfind(position_list,get_form.first_boss_code,',') or session.ep.ehesap>
										<cfinput type="text" name="amir_name_1" value="#amir_1_name#" style="width:180px;">
									<cfelse>
										<cfinput type="text" name="amir_name_1" value="#amir_1_name#" style="width:180px;" readonly="true">
									</cfif>
									<cfif listfind(position_list,get_form.first_boss_code,',') and get_row.first_boss_valid_row neq 1>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_1&field_name=add_perf_emp_info.amir_name_1&field_code=add_perf_emp_info.amir_code_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
										</cfif>
										<input type="hidden" name="amir_valid_1" id="amir_valid_1" value="<cfoutput>#get_form.first_boss_valid#</cfoutput>">
										<cfsavecontent variable="ony_message"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='784.Onaylamak İstediğnizden Emin misiniz ?'></cfsavecontent>
										<input type="Image" src="/images/valid.gif" alt="<cf_get_lang_main no ='1063.Onayla'>" onClick="if (confirm('<cfoutput>#ony_message#</cfoutput>')) {document.add_perf_emp_info.amir_valid_1.value='1'} else {return false}" border="0">
									<cfelseif get_form.first_boss_valid eq 1>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_1&field_name=add_perf_emp_info.amir_name_1&field_code=add_perf_emp_info.amir_code_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
										</cfif>
										<cfif listfind(position_list,get_form.first_boss_code,',') and get_form.FORM_VALID neq 1>
											<cfsavecontent variable="message"><cf_get_lang no ='.'></cfsavecontent>
											<input type="Image" src="/images/refusal.gif" alt="Süreci İptal Et" onClick="if (confirm('Süreci başa almak üzeresiniz tüm süreç baştan işleyecektir. Süreci iptal etmek istediğinizden emin misiniz ?')) {document.add_perf_emp_info.amir_valid_1.value='-1'} else {return false}" border="0">
										</cfif>
										<input type="hidden" name="amir_valid_1" id="amir_valid_1" value="2">
										<cf_get_lang no ='200.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.first_boss_valid_date,dateformat_style)#</cfoutput>
									<cfelse>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_1&field_name=add_perf_emp_info.amir_name_1&field_code=add_perf_emp_info.amir_code_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
										</cfif>
										<cfif len(get_form.first_boss_id)>
											<cf_get_lang_main no ='203.Onay Bekliyor'>
										</cfif>
									</cfif>
								</td>
                            </tr>
                            <tr>
								<td><cf_get_lang no ='201.Üst Amir'> 2</td>
								<td>
									<input type="hidden" name="amir_id_2_old" id="amir_id_2_old" value="<cfoutput>#get_form.second_boss_id#</cfoutput>">
									<input type="hidden" name="amir_id_2" id="amir_id_2" value="<cfoutput>#get_form.second_boss_id#</cfoutput>">
									<input type="hidden" name="amir_code_2" id="amir_code_2" value="<cfoutput>#get_form.second_boss_code#</cfoutput>">
									<cfif get_form.second_boss_valid eq 1><cfset AMIR_2_NAME=get_emp_info(get_form.second_boss_id,0,0)><cfelse><cfset AMIR_2_NAME=get_emp_info(get_form.second_boss_code,1,0)></cfif>
									<cfif listfind(position_list,get_form.first_boss_code,',') or session.ep.ehesap>
										<cfinput type="text" name="amir_name_2" value="#amir_2_name#" style="width:180px;">
									<cfelse>
										<cfinput type="text" name="amir_name_2" value="#amir_2_name#" style="width:180px;" readonly="true">
									</cfif>
									<cfif listfind(position_list,get_form.second_boss_code,',') and get_form.second_boss_valid neq 1 and get_form.first_boss_valid eq 1>
										<input type="hidden" name="amir_valid_2" id="amir_valid_2" value="<cfoutput>#get_form.second_boss_valid#</cfoutput>">
										<cfsavecontent variable="ony_message"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='784.Onaylamak İstediğnizden Emin misiniz ?'></cfsavecontent>
										<input type="Image" src="/images/valid.gif" alt="<cf_get_lang_main no ='1063.Onayla'>" onClick="if (confirm('<cfoutput>#ony_message#</cfoutput>')) {document.add_perf_emp_info.amir_valid_2.value='1'} else {return false}" border="0">
									<cfelseif get_form.second_boss_valid eq 1>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_2&field_name=add_perf_emp_info.amir_name_2&field_code=add_perf_emp_info.amir_code_2&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>										
										</cfif>
										<input type="hidden" name="amir_valid_2" id="amir_valid_2" value="2">
										<cf_get_lang no ='200.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.second_boss_valid_date,dateformat_style)#</cfoutput>
									<cfelse>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_2&field_name=add_perf_emp_info.amir_name_2&field_code=add_perf_emp_info.amir_code_2&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
										</cfif>
										<cfif len(get_form.second_boss_id)>
											<cf_get_lang_main no ='203.Onay Bekliyor'>
										</cfif>
									</cfif>
								</td>
                            </tr>
                            <tr>
								<td><cf_get_lang no ='201.Üst Amir'> 3</td>								
								<td>
									<input type="hidden" name="amir_id_3_old" id="amir_id_3_old" value="<cfoutput>#get_form.third_boss_id#</cfoutput>">
									<input type="hidden" name="amir_id_3" id="amir_id_3" value="<cfoutput>#get_form.third_boss_id#</cfoutput>">
									<input type="hidden" name="amir_code_3" id="amir_code_3" value="<cfoutput>#get_form.third_boss_code#</cfoutput>">
									<cfif get_form.third_boss_valid eq 1><cfset AMIR_3_NAME=get_emp_info(get_form.third_boss_id,0,0)><cfelse><cfset AMIR_3_NAME=get_emp_info(get_form.third_boss_code,1,0)></cfif>
									<cfif listfind(position_list,get_form.first_boss_code,',') or session.ep.ehesap>
										<cfinput type="text" name="amir_name_3" value="#amir_3_name#" style="width:180px;">
									<cfelse>
										<cfinput type="text" name="amir_name_3" value="#amir_3_name#" style="width:180px;" readonly="true">
									</cfif>
									<cfif listfind(position_list,get_form.third_boss_code,',') and get_form.third_boss_valid neq 1 and get_form.second_boss_valid eq 1>
										<input type="hidden" name="amir_valid_3" id="amir_valid_3" value="<cfoutput>#get_form.third_boss_valid#</cfoutput>">
										<cfsavecontent variable="ony_message"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='784.Onaylamak İstediğnizden Emin misiniz ?'></cfsavecontent>
										<input type="Image" src="/images/valid.gif" alt="<cf_get_lang_main no ='1063.Onayla'>" onClick="if (confirm('<cfoutput>#ony_message#</cfoutput>')) {document.add_perf_emp_info.amir_valid_3.value='1'} else {return false}" border="0">
									<cfelseif get_form.third_boss_valid eq 1>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_3&field_name=add_perf_emp_info.amir_name_3&field_code=add_perf_emp_info.amir_code_3&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>										
										</cfif>
										<input type="hidden" name="amir_valid_3" id="amir_valid_3" value="2">
										<cf_get_lang no ='200.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.third_boss_valid_date,dateformat_style)#</cfoutput>
									<cfelse>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_3&field_name=add_perf_emp_info.amir_name_3&field_code=add_perf_emp_info.amir_code_3&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
										</cfif>
										<cfif len(get_form.third_boss_id)>
											<cf_get_lang_main no ='203.Onay Bekliyor'>
										</cfif>
									</cfif>
								</td>
                            </tr>
 							<tr>
								<td><cf_get_lang no ='201.Üst Amir'> 4</td>								
								<td>
									<input type="hidden" name="amir_id_4_old" id="amir_id_4_old" value="<cfoutput>#get_form.fourth_boss_id#</cfoutput>">
									<input type="hidden" name="amir_id_4" id="amir_id_4" value="<cfoutput>#get_form.fourth_boss_id#</cfoutput>">
									<input type="hidden" name="amir_code_4" id="amir_code_4" value="<cfoutput>#get_form.fourth_boss_code#</cfoutput>">
									<cfif get_form.fourth_boss_valid eq 1><cfset AMIR_4_NAME=get_emp_info(get_form.fourth_boss_id,0,0)><cfelse><cfset AMIR_4_NAME=get_emp_info(get_form.fourth_boss_code,1,0)></cfif>
									<cfif listfind(position_list,get_form.first_boss_code,',') or session.ep.ehesap>
										<cfinput type="text" name="amir_name_4" value="#amir_4_name#" style="width:180px;">
									<cfelse>
										<cfinput type="text" name="amir_name_4" value="#amir_4_name#" style="width:180px;" readonly="true">
									</cfif>
									<cfif listfind(position_list,get_form.fourth_boss_code,',') and get_form.fourth_boss_valid neq 1 and get_form.third_boss_valid eq 1>
										<!--- <cfif session.ep.ehesap><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_4&field_name=add_perf_emp_info.amir_name_4&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a></cfif> --->
										<input type="hidden" name="amir_valid_4" id="amir_valid_4" value="<cfoutput>#get_form.fourth_boss_valid#</cfoutput>">
										<cfsavecontent variable="ony_message"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='784.Onaylamak İstediğnizden Emin misiniz ?'></cfsavecontent>
										<input type="Image" src="/images/valid.gif" alt="<cf_get_lang_main no ='1063.Onayla'>" onClick="if (confirm('<cfoutput>#ony_message#</cfoutput>')) {document.add_perf_emp_info.amir_valid_4.value='1'} else {return false}" border="0">
									<cfelseif get_form.fourth_boss_valid eq 1>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_4&field_name=add_perf_emp_info.amir_name_4&field_code=add_perf_emp_info.amir_code_4&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>										
										</cfif>
										<input type="hidden" name="amir_valid_4" id="amir_valid_4" value="2">
										<cf_get_lang no ='200.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.fourth_boss_valid_date,dateformat_style)#</cfoutput>
									<cfelse>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_4&field_name=add_perf_emp_info.amir_name_4&field_code=add_perf_emp_info.amir_code_4&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
										</cfif>
										<cfif len(get_form.fourth_boss_id)>
											<cf_get_lang_main no ='203.Onay Bekliyor'>
										</cfif>
									</cfif>
								</td>
                            </tr>
							<tr>
								<td><cf_get_lang no ='201.Üst Amir'>5</td>								
								<td>
									<input type="hidden" name="amir_id_5_old" id="amir_id_5_old" value="<cfoutput>#get_form.fifth_boss_id#</cfoutput>">
									<input type="hidden" name="amir_id_5" id="amir_id_5" value="<cfoutput>#get_form.fifth_boss_id#</cfoutput>">
									<input type="hidden" name="amir_code_5" id="amir_code_5" value="<cfoutput>#get_form.fifth_boss_code#</cfoutput>">
									<cfif get_form.fifth_boss_valid eq 1><cfset AMIR_5_NAME=get_emp_info(get_form.fifth_boss_id,0,0)><cfelse><cfset AMIR_5_NAME=get_emp_info(get_form.fifth_boss_code,1,0)></cfif>
									<cfif listfind(position_list,get_form.first_boss_code,',') or session.ep.ehesap>
										<cfinput type="text" name="amir_name_5" value="#amir_5_name#" style="width:180px;">
									<cfelse>
										<cfinput type="text" name="amir_name_5" value="#amir_5_name#" style="width:180px;"  readonly="true">
									</cfif>
									<cfif listfind(position_list,get_form.fifth_boss_code,',') and get_form.fifth_boss_valid neq 1 and get_form.fourth_boss_valid eq 1>
										<input type="hidden" name="amir_valid_5" id="amir_valid_5" value="<cfoutput>#get_form.fifth_boss_valid#</cfoutput>">
										<cfsavecontent variable="ony_message"><cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='784.Onaylamak İstediğnizden Emin misiniz ?'></cfsavecontent>
										<input type="Image" src="/images/valid.gif" alt="<cf_get_lang_main no ='1063.Onayla'>" onClick="if (confirm('<cfoutput>#ony_message#</cfoutput>')) {document.add_perf_emp_info.amir_valid_5.value='1'} else {return false}" border="0">
									<cfelseif get_form.fifth_boss_valid eq 1>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_5&field_name=add_perf_emp_info.amir_name_5&field_code=add_perf_emp_info.amir_code_5&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
										</cfif>
										<input type="hidden" name="amir_valid_5" id="amir_valid_5" value="2">
										<cf_get_lang no ='200.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.fifth_boss_valid_date,dateformat_style)#</cfoutput>
									<cfelse>
										<cfif session.ep.ehesap>
											<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_5&field_name=add_perf_emp_info.amir_name_5&field_code=add_perf_emp_info.amir_code_5&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
										</cfif>
										<cfif len(get_form.fifth_boss_id)>
											<cf_get_lang_main no ='203.Onay Bekliyor'>
										</cfif>
									</cfif>
								</td>
                            </tr>
							</cfoutput>
							</cfform>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
<script type="text/javascript">
function kontrol()
{
	return true;
}
</script>
