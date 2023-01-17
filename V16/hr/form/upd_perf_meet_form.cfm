<!--- sayfada alanları degistirme yetkisi ilk amirde. ehesap amirleri degistirme yetkisi var vede calisanda kendine ait olan aciklamayi degistirebiliyor--->
<!--- sayfayayi görüntülemek icin tum pozisyonlarından birinde yetkili olması yeterli--->
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfset position_list=valuelist(get_emp_pos.POSITION_CODE,',')>
<cfquery name="GET_FORM" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		PERF_MEET_FORM
	WHERE 
		FORM_ID = #attributes.form_id#
		<cfif not session.ep.ehesap>
			AND (
				 EMPLOYEE_ID = #session.ep.userid#
				 OR FIRST_BOSS_CODE IN (#position_list#)
				 OR SECOND_BOSS_CODE IN (#position_list#)
				 OR THIRD_BOSS_CODE IN (#position_list#)
				 OR FOURTH_BOSS_CODE IN (#position_list#)
				 OR FIFTH_BOSS_CODE IN (#position_list#)
				)
			<!--- AND #session.ep.userid# IN (EMPLOYEE_ID,FIRST_BOSS_ID,SECOND_BOSS_ID,THIRD_BOSS_ID,FOURTH_BOSS_ID,FIFTH_BOSS_ID) --->
		</cfif>
</cfquery>
<cfif not get_form.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='46194.Kayıt silinmiş veya Yetkiniz Bulunmamaktadır'>!");
		window.close();
	</script>
	<cfabort>
</cfif>

<!--- uyarı için eklenen form--->
<form name="add_warning" action="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_form_add_warning" method="post">
	<input type="hidden" name="act" id="act" value="<cfoutput>hr.popup_upd_perf_meet_form&form_id=#attributes.form_id#</cfoutput>">
</form>
<!---/// uyarı için eklenen form--->
<cfsavecontent variable="right_images_">
    <a href="javascript://" onClick="windowopen('','medium','add_warning_window');add_warning.target='add_warning_window';add_warning.submit();" class=""><img src="../images/bugpro.gif" title="<cf_get_lang_main no ='523.Uyarı Ekle'>" border="0"></a>
    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=#fuseaction#&action_name=form_id&action_id=#attributes.form_id#</cfoutput>','list');"> <img src="/images/uyar.gif" title="<cf_get_lang_main no='345.Uyarılar'>" border="0"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56571.Performans Görüşme Formu"></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right_images_#">
    <cfform name="add_perf_emp_info" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_perf_meet_form" enctype="multipart/form-data">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="56572.Değerlendirilen"></cfsavecontent>
		<cf_seperator id="degerlendirilen" title="#message#">
    	<table id="degerlendirilen">
            <tr>
                <input type="hidden" name="form_id" id="form_id" value="<cfoutput>#attributes.form_id#</cfoutput>">
                <td width="100"><cf_get_lang dictionary_id ='57576.Çalışan'>*</td>
                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#GET_FORM.EMPLOYEE_ID#</cfoutput>">
                <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#GET_FORM.EMP_POSITION_CODE#</cfoutput>">
                <cfif session.ep.ehesap>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29498.Çalışan Seçmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="emp_name" value="#get_emp_info(GET_FORM.EMPLOYEE_ID,0,0)#" required="yes" message="#message#" style="width:180px;">
                        <cfif session.ep.ehesap and get_form.first_boss_valid neq 1>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_under_position_list&field_emp_id=add_perf_emp_info.employee_id&field_pos_code=add_perf_emp_info.position_code&field_name=add_perf_emp_info.emp_name&up_emp_id=#get_form.first_boss_id#'</cfoutput>,'list')"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>	
                    </td>
                <cfelse>
                    <td width="180"><cfoutput>#get_emp_info(GET_FORM.EMPLOYEE_ID,1,0)#</cfoutput></td>
                </cfif>
            </tr>
        </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55316.Değerlendiren"></cfsavecontent>
        <cf_seperator id="degerlendiren" title="#message#">
		<table id="degerlendiren">
            <tr>
                <td width="100"><cf_get_lang dictionary_id ='56569.İlk Amir'>1</td>
                <td>
                    <input type="hidden" name="amir_id_1" id"amir_id_1" value="<cfoutput>#get_form.first_boss_id#</cfoutput>">
                    <input type="hidden" name="amir_code_1" id="amir_code_1" value="<cfoutput>#get_form.first_boss_code#</cfoutput>">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="56573.Amir Seçmelisiniz"> !</cfsavecontent>
                    <cfif get_form.first_boss_valid eq 1><cfset AMIR_1_NAME=get_emp_info(get_form.first_boss_id,0,0)><cfelse><cfset AMIR_1_NAME=get_emp_info(get_form.first_boss_code,1,0)></cfif>
                    <cfif listfind(position_list,get_form.first_boss_code,',') or session.ep.ehesap>
                        <cfinput type="text" name="amir_name_1" value="#amir_1_name#" style="width:180px;">
                    <cfelse>
                        <cfinput type="text" name="amir_name_1" value="#amir_1_name#" style="width:180px;" readonly="true">
                    </cfif>
                    <cfif listfind(position_list,get_form.first_boss_code,',') and get_form.first_boss_valid neq 1>
                        <cfif session.ep.ehesap><!--- İLK AMİR DEĞİŞTİRME YETKİSİ EHESAPTA--->
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_1&field_name=add_perf_emp_info.amir_name_1&field_code=add_perf_emp_info.amir_code_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                        <input type="hidden" name="amir_valid_1" id="amir_valid_1" value="<cfoutput>#get_form.first_boss_valid#</cfoutput>">
                        <input type="Image" src="/images/valid.gif" alt="Onayla" onClick="if (confirm('Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Onaylamak istediğinizden emin misiniz ?')) {document.add_perf_emp_info.amir_valid_1.value='1'} else {return false}" border="0">
                    <cfelseif get_form.first_boss_valid eq 1>
                        <cfif listfind(position_list,get_form.first_boss_code,',') and get_form.PERFORM_VALID neq 1>
                            <input type="Image" src="/images/refusal.gif" alt="Süreci İptal Et" onClick="if (confirm('Süreci başa almak üzeresiniz tüm süreç baştan işleyecektir. Süreci iptal etmek istediğinizden emin misiniz ?')) {document.add_perf_emp_info.amir_valid_1.value='-1'} else {return false}" border="0">
                        </cfif>
                        <input type="hidden" name="amir_valid_1" id="amir_valid_1" value="2">
                        <cf_get_lang dictionary_id ='56580	.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.first_boss_valid_date,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cfif session.ep.ehesap and get_form.first_boss_valid neq 1>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_1&field_name=add_perf_emp_info.amir_name_1&field_code=add_perf_emp_info.amir_code_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                        <cfif len(get_form.first_boss_id)>
                            <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                        </cfif>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>2</td>
                <td>
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
                        <input type="Image" src="/images/valid.gif" alt="Onayla" onClick="if (confirm('Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Onaylamak istediğinizden emin misiniz ?')) {document.add_perf_emp_info.amir_valid_2.value='1'} else {return false}" border="0">
                    <cfelseif get_form.second_boss_valid eq 1>
                        <input type="hidden" name="amir_valid_2" id="amir_valid_2" value="2">
                        <cf_get_lang dictionary_id ='56580.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.second_boss_valid_date,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cfif session.ep.ehesap and get_form.first_boss_valid neq 1>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_2&field_name=add_perf_emp_info.amir_name_2&field_code=add_perf_emp_info.amir_code_2&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                        <cfif len(get_form.second_boss_id)>
                            <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                        </cfif>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>3</td>								
                <td>
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
                        <input type="Image" src="/images/valid.gif" alt="Onayla" onClick="if (confirm('Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Onaylamak istediğinizden emin misiniz ?')) {document.add_perf_emp_info.amir_valid_3.value='1'} else {return false}" border="0">
                    <cfelseif get_form.third_boss_valid eq 1>
                        <input type="hidden" name="amir_valid_3" id="amir_valid_3" value="2">
                        <cf_get_lang dictionary_id ='56580.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.third_boss_valid_date,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cfif session.ep.ehesap and get_form.first_boss_valid neq 1>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_3&field_name=add_perf_emp_info.amir_name_3&field_code=add_perf_emp_info.amir_code_3&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                        <cfif len(get_form.third_boss_id)>
                            <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                        </cfif>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>4</td>								
                <td>
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
                        <input type="Image" src="/images/valid.gif" alt="Onayla" onClick="if (confirm('Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Onaylamak istediğinizden emin misiniz ?')) {document.add_perf_emp_info.amir_valid_4.value='1'} else {return false}" border="0">
                    <cfelseif get_form.fourth_boss_valid eq 1>
                        <input type="hidden" name="amir_valid_4" id="amir_valid_4" value="2">
                        <cf_get_lang dictionary_id ='56580.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.fourth_boss_valid_date,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cfif session.ep.ehesap and get_form.first_boss_valid neq 1>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_4&field_name=add_perf_emp_info.amir_name_4&field_code=add_perf_emp_info.amir_code_4&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                        <cfif len(get_form.fourth_boss_id)>
                            <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                        </cfif>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='56477.Üst Amir'>5</td>								
                <td>
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
                        <input type="Image" src="/images/valid.gif" alt="Onayla" onClick="if (confirm('Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Onaylamak istediğinizden emin misiniz ?')) {document.add_perf_emp_info.amir_valid_5.value='1'} else {return false}" border="0">
                    <cfelseif get_form.fifth_boss_valid eq 1>
                        <input type="hidden" name="amir_valid_5" id="amir_valid_5" value="2">
                        <cf_get_lang dictionary_id ='56580.Onaylanma Tarihi'>:<cfoutput>#dateformat(get_form.fifth_boss_valid_date,dateformat_style)#</cfoutput>
                    <cfelse>
                        <cfif session.ep.ehesap and get_form.first_boss_valid neq 1>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_5&field_name=add_perf_emp_info.amir_name_5&field_code=add_perf_emp_info.amir_code_5&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                        </cfif>
                        <cfif len(get_form.fifth_boss_id)>
                            <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                        </cfif>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58472.Dönem'> *</td>
                <cfif listfind(position_list,get_form.first_boss_code,',')>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="#dateformat(get_form.start_date,dateformat_style)#" style="width:80px;">
                        <cf_wrk_date_image date_field="start_date">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="#dateformat(get_form.finish_date,dateformat_style)#" style="width:77px;">
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
                <cfelse>
                    <td><cfoutput>#dateformat(get_form.start_date,dateformat_style)# - #dateformat(get_form.finish_date,dateformat_style)#</cfoutput></td>
                </cfif>
            </tr>
        </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="56574.Değerlendirmelere İlişkin Yorumlar"></cfsavecontent>
        <cf_seperator id="yorumlar" title="#message#">
        <table id="yorumlar">
            <tr>
                <td class="txtbold" valign="top" width="100"><cf_get_lang dictionary_id ='56575.Personelin'></td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                <cfif (session.ep.userid is get_form.employee_id) and (get_form.first_boss_valid neq 1)>
                    <td><textarea name="emp_comment" id="emp_comment" style="width:370px;height:60px" maxlength="2000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_form.employees_comment#</cfoutput></textarea></td>
                <cfelse>
                    <td style="width:370px;height:60px" valign="top"><cfoutput>#get_form.employees_comment#</cfoutput></td>
                </cfif>
            </tr>
            <tr>
                <td colspan="2" class="txtbold"><cf_get_lang dictionary_id ='56576.İlk Amirin'></td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang dictionary_id ='41525.Bilgi(Know-How)'></td>
                <cfif listfind(position_list,get_form.first_boss_code,',') and (get_form.first_boss_valid neq 1)>
                    <td><textarea name="boss_comment_1" id="boss_comment_1" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_form.first_boss_comment_1#</cfoutput></textarea></td>
                <cfelse>
                    <td style="width:370px;height:60px" valign="top"><cfoutput>#get_form.first_boss_comment_1#</cfoutput></td>
                </cfif>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang dictionary_id ='56577.İş Organizasyonu'></td>
                <cfif listfind(position_list,get_form.first_boss_code,',') and (get_form.first_boss_valid neq 1)>
                    <td><textarea name="boss_comment_2" id="boss_comment_2" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_form.first_boss_comment_2#</cfoutput></textarea></td>
                <cfelse>
                    <td style="width:370px;height:60px" valign="top"><cfoutput>#get_form.FIRST_BOSS_COMMENT_2#</cfoutput></td>
                </cfif>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang dictionary_id ='56578.Problem Çözme'></td>
                <cfif listfind(position_list,get_form.first_boss_code,',') and (get_form.first_boss_valid neq 1)>
                    <td><textarea name="boss_comment_3" id="boss_comment_3" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_form.first_boss_comment_3#</cfoutput></textarea></td>
                <cfelse>
                    <td style="width:370px;height:60px" valign="top"><cfoutput>#get_form.first_boss_comment_3#</cfoutput></td>
                </cfif>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang dictionary_id ='56579.İnsan İlişkileri'></td>
                <cfif listfind(position_list,get_form.first_boss_code,',') and (get_form.first_boss_valid neq 1)>
                    <td><textarea name="boss_comment_4" id="boss_comment_4" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_form.first_boss_comment_4#</cfoutput></textarea></td>
                <cfelse>
                    <td style="width:370px;height:60px" valign="top"><cfoutput>#get_form.first_boss_comment_4#</cfoutput></td>
                </cfif>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang dictionary_id ='58580.Başarı'></td>
                <cfif listfind(position_list,get_form.first_boss_code,',') and (get_form.first_boss_valid neq 1)>
                    <td><textarea name="boss_comment_5" id="boss_comment_5" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_form.first_boss_comment_5#</cfoutput></textarea></td>
                <cfelse>
                    <td style="width:370px;height:60px" valign="top"><cfoutput>#get_form.first_boss_comment_5#</cfoutput></td>
                </cfif>
            </tr>
            <cfif GET_FORM.PERFORM_VALID eq 1>
                <tr>
                    <td colspan="2">
                        <cf_get_lang dictionary_id ='41522.Son Onay'> : <cfoutput>#get_emp_info(GET_FORM.PERFORM_VALID_EMP,0,0)# (#dateformat(GET_FORM.PERFORM_VALID_DATE,dateformat_style)# #timeformat(GET_FORM.PERFORM_VALID_DATE,timeformat_style)#)</cfoutput>
                    </td>
                </tr>
            </cfif>
        </table>
        <cf_popup_box_footer>
        	<cf_record_info query_name="GET_FORM">
            <cfif get_form.first_boss_valid neq 1 and (session.ep.userid is get_form.employee_id or listfind(position_list,get_form.first_boss_code,',') or session.ep.ehesap)>
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
            </cfif>
        </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if(document.add_perf_emp_info.employee_id.value==document.add_perf_emp_info.amir_id_1.value || document.add_perf_emp_info.employee_id.value==document.add_perf_emp_info.amir_id_2.value || document.add_perf_emp_info.employee_id.value==document.add_perf_emp_info.amir_id_3.value || document.add_perf_emp_info.employee_id.value==document.add_perf_emp_info.amir_id_4.value || document.add_perf_emp_info.employee_id.value==document.add_perf_emp_info.amir_id_5.value)
	{
		alert("<cf_get_lang dictionary_id ='56582.Çalışan formda amir olarak seçilemez'>");
		return false;
	}
	
	return true;
}
</script>
