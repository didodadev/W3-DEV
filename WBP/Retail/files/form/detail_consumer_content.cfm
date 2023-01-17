<cf_form_box width="100%"> 
<cfform name="upd_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_consumer&#xml_str#">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#url.cid#</cfoutput>">
    <input type="hidden" name="old_cat_id" id="old_cat_id" value="<cfoutput>#get_consumer.consumer_cat_id#</cfoutput>">
    <input type="hidden" name="is_upper_ref" id="is_upper_ref" value="0">
    <input type="hidden" name="x_name_surname_write_standart" id="x_name_surname_write_standart" value="<cfoutput>#x_name_surname_write_standart#</cfoutput>" />
    <cf_object_main_table>
        <cf_object_table column_width_list="140,200">
            <cfsavecontent variable="header_"><cf_get_lang_main no='146.Üye No'></cfsavecontent>
            <cf_object_tr id="form_ul_customer_number" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='146.Üye No'></cf_object_td>
                <cf_object_td><input type="text" name="customer_number" id="customer_number" value="<cfoutput>#get_consumer.member_code#</cfoutput>" style="width:150px;" maxlength="50"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='219.Ad'></cfsavecontent>
            <cf_object_tr id="form_ul_consumer_name" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='219.Ad'>*</cf_object_td>
                <cf_object_td><cfinput type="text" name="consumer_name" id="consumer_name" value="#Left(get_consumer.consumer_name,50)#" required="yes"  maxlength="50" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1314.Soyad'></cfsavecontent>
            <cf_object_tr id="form_ul_consumer_surname" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1314.Soyad'>*</cf_object_td>
                <cf_object_td><cfinput type="text" name="consumer_surname" id="consumer_surname" value="#Left(get_consumer.consumer_surname,50)#" required="yes" maxlength="50" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='139.Kullanıcı Adı'></cfsavecontent>
            <cf_object_tr id="form_ul_consumer_username" Title="#header_#" style="display:none;">
                <cf_object_td type="text"><cf_get_lang_main no='139.Kullanıcı Adı'></cf_object_td>
                <cf_object_td><cfinput type="text" name="consumer_username" id="consumer_username" value="#get_consumer.consumer_username#" maxlength="50" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='140.Şifre'></cfsavecontent>
            <cf_object_tr id="form_ul_consumer_password" Title="#header_#" style="display:none;">
                <cf_object_td type="text"><cf_get_lang_main no='140.Şifre'></cf_object_td>
                <cf_object_td>
                    <cfif xml_hidden_password eq 1>
                        <cfif xml_enter_manual_password eq 1>
                            <cfinput type="password" name="consumer_password" id="consumer_password" value="" maxlength="10" style="width:150px;" oncopy="return false" onpaste="return false">
                        <cfelse>
                            <cfinput type="password" name="consumer_password" id="consumer_password" value="" maxlength="10" style="width:150px;" readonly="yes" oncopy="return false" onpaste="return false">
                        </cfif>
                    <cfelse>
                        <cfinput type="text" name="consumer_password" id="consumer_password" value="" maxlength="10" style="width:150px;" oncopy="return false" onpaste="return false">
                    </cfif>
                    <cfif isdefined("is_add_password") and is_add_password eq 1>
                        <a href="javascript://" onclick="sayfa_getir();"> <img src="/images/plus_ques.gif" align="absmiddle" border="0" title="Şifre Oluştur" id="member_password"></a>
                        <div id="SHOW_PASSWORD" style="display:none"></div>
                    </cfif>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='310.Uyelik Baslama Tarihi'></cfsavecontent>
            <cf_object_tr id="form_ul_startdate" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='310.Uyelik Baslama Tarihi'></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="alert"><cf_get_lang_main no='69.eksik veri'>:<cf_get_lang no ='310.Üyelik Başlama Tarihi'></cfsavecontent>
                    <cfinput type="text" name="startdate" id="startdate" maxlength="10" value="#dateformat(get_consumer.start_date,'dd/mm/yyyy')#" validate="eurodate" message="#alert#" style="width:130px;">
                    <cf_wrk_date_image date_field="startdate">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1224.Referans Üye'></cfsavecontent>
            <cf_object_tr id="form_ul_ref_pos_code_name" Title="#header_#" style="display:none;">
                <cf_object_td type="text"><cf_get_lang_main no='1224.Referans Üye'><cfif is_req_reference_member eq 1>*</cfif></cf_object_td>
                <cf_object_td>
                    <input type="hidden" name="ref_pos_code" id="ref_pos_code" <cfif len(get_consumer.ref_pos_code)> value="<cfoutput>#get_consumer.ref_pos_code#</cfoutput>"</cfif>>
                    <input type="text" name="ref_pos_code_name" id="ref_pos_code_name" style="width:150px;" value="<cfif len(get_consumer.ref_pos_code)><cfoutput>#get_cons_info(get_consumer.ref_pos_code,0,0)#</cfoutput></cfif>">
                    <!--- xml deki parametreye bagli olarak sadece ilgili calisanlar guncellesin --->
                    <cfif not len(get_consumer.ref_pos_code) or not len(is_reference_member_upd_code) or (len(is_reference_member_upd_code) and listfind(is_reference_member_upd_code,session.ep.position_code))>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=upd_consumer.ref_pos_code&field_consumer=upd_consumer.dsp_reference_code&field_name=upd_consumer.ref_pos_code_name&field_cons_ref_code=upd_consumer.reference_code&call_function=kontrol_ref_member(0)&kontrol_conscat_id=#get_consumer.consumer_cat_id#<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=3'</cfoutput>,'list','popup_list_cons')"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='322.seçiniz'>" border="0" align="absmiddle" id="ref_pos_code_img"></a>
                    </cfif>
                    <div style="position:absolute;" id="open_process"></div>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no ='455.Referans Kod'></cfsavecontent>
            <cf_object_tr id="form_ul_dsp_reference_code" Title="#header_#" style="display:none;">
                <cf_object_td type="text"><cf_get_lang no ='455.Referans Kod'></cf_object_td>
                <cf_object_td>
                    <input type="hidden" name="hidden_reference_code" id="hidden_reference_code" value="<cfoutput>#get_consumer.consumer_reference_code#</cfoutput>">
                    <input type="hidden" name="reference_code" id="reference_code" value="<cfoutput>#get_consumer.consumer_reference_code#</cfoutput>">
                    <input type="hidden" name="hidden_ref_pos_code" id="hidden_ref_pos_code" value="<cfoutput>#get_consumer.ref_pos_code#</cfoutput>">
                    <input type="text" name="dsp_reference_code" id="dsp_reference_code" value="<cfoutput>#get_consumer.ref_pos_code#</cfoutput>" maxlength="250" style="width:150px;">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='582.Öneren Üye'></cfsavecontent>
            <cf_object_tr id="form_ul_proposer_cons_name" Title="#header_#" style="display:none;">
                <cf_object_td type="text"><cf_get_lang no='582.Öneren Üye'></cf_object_td>
                <cf_object_td>
                    <input type="hidden" name="proposer_cons_id" id="proposer_cons_id" <cfif len(get_consumer.proposer_cons_id)> value="<cfoutput>#get_consumer.proposer_cons_id#</cfoutput>"</cfif>>
                    <input type="text" name="proposer_cons_name" id="proposer_cons_name" style="width:150px;" onfocus="AutoComplete_Create('proposer_cons_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','2,0,0,0','CONSUMER_ID','proposer_cons_id','upd_consumer','3','250');" value="<cfif len(get_consumer.proposer_cons_id) ><cfoutput>#get_cons_info(get_consumer.proposer_cons_id,0,0)#</cfoutput></cfif>" autocomplete="off">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=upd_consumer.proposer_cons_id&field_name=upd_consumer.proposer_cons_name<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=3'</cfoutput>,'list','popup_list_cons')"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='322.seçiniz'>" border="0" align="absmiddle"></a>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='377.Ozel Kod'></cfsavecontent>
            <cf_object_tr id="form_ul_ozel_kod" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='377.Ozel Kod'></cf_object_td>
                <cf_object_td><input type="text" name="ozel_kod" id="ozel_kod" value="<cfoutput>#get_consumer.ozel_kod#</cfoutput>" maxlength="50" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cf_object_tr id="form_ul_ozel_kod2" Title="Genius">
                <cf_object_td type="text">Genius ID</cf_object_td>
                <cf_object_td><cfoutput>#get_consumer.genius_id#</cfoutput></cf_object_td>
            </cf_object_tr>
            <cf_object_tr>
                <cf_object_td>
                    <cf_wrk_add_info info_type_id="-2" info_id="#attributes.cid#" upd_page = "1" colspan="9">
                </cf_object_td>
            </cf_object_tr>
        </cf_object_table>
        <cf_object_table column_width_list="100,200">
            <cfsavecontent variable="header_"><cf_get_lang_main no='81.Aktif'>-<cf_get_lang_main no='165.Potansiyel'>-<cf_get_lang no='421.Bağlı Üye'></cfsavecontent>
            <cf_object_tr id="form_ul_consumer_status" extra_checkbox="ispotantial,is_related_consumer" Title="#header_#" height="20">
                <cf_object_td type="text"><cf_get_lang_main no='81.Aktif'><input type="checkbox" name="consumer_status" id="consumer_status" <cfif get_consumer.consumer_status is 1>checked</cfif>></cf_object_td>
                <cf_object_td>
                    <div style="display:none;">
					<cfif is_dsp_potantial_check eq 1>
                        <cf_get_lang_main no='165.Potansiyel'><input type="checkbox" name="ispotantial" id="ispotantial" <cfif get_consumer.ispotantial is 1>checked="checked"</cfif>>&nbsp;&nbsp;
                    </cfif>
                    <cfif is_dsp_related_consumer_check eq 1>
                        <cf_get_lang no='421.Bağlı Üye'> <input type="checkbox" name="is_related_consumer" id="is_related_consumer" <cfif get_consumer.is_related_consumer is 1> checked="checked"</cfif>>
                    </cfif>
                    </div>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_">E-Fatura Kullanıyor</cfsavecontent>
            <cf_object_tr id="form_ul_process_stage" Title="#header_#">
                <cf_object_td type="text">E-Fatura *</cf_object_td>
                <cf_object_td>
                    <input type="checkbox" name="use_efatura" id="use_efatura" <cfif len(get_consumer.use_efatura) and get_consumer.use_efatura>checked="checked"</cfif> <cfif xml_use_efatura>disabled="disabled"</cfif>/>
                    <cfif xml_use_efatura>
		                <cfinput type="text" name="efatura_date" value="#dateformat(get_consumer.efatura_date,'dd/mm/yyyy')#" readonly="readonly" validate="eurodate" maxlength="10" style="width:114px;">
                    <cfelse>
		                <cfinput type="text" name="efatura_date" value="#dateformat(get_consumer.efatura_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:114px;">                    
	                    <cf_wrk_date_image date_field="efatura_date">
                    </cfif>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no="1447.Süreç"></cfsavecontent>
            <cf_object_tr id="form_ul_process_stage" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no="1447.Süreç">*</cf_object_td>
                <cf_object_td><cf_workcube_process is_upd='0' select_value = '#get_consumer.consumer_stage#' process_cat_width='150' is_detail='1'></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1197.Üye Kategorisi'></cfsavecontent>
            <cf_object_tr id="form_ul_consumer_cat_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1197.Üye Kategorisi'>*</cf_object_td>
                <cf_object_td>
                    <cf_wrk_MemberCat
                        name="consumer_cat_id"
                        is_active="1"
                        comp_cons="0"
                        value="#get_consumer.consumer_cat_id#">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1418.İlişki Şekli'></cfsavecontent>
            <cf_object_tr id="form_ul_resource" Title="#header_#" style="display:none;">
                <cf_object_td type="text"><cf_get_lang_main no='1418.İlişki Şekli'> <cfif isdefined("is_resource_info") and is_resource_info eq 1>*</cfif></cf_object_td>
                <cf_object_td>
                    <cf_wrk_combo 
                        name="resource"
                        query_name="GET_PARTNER_RESOURCE"
                        value="#get_consumer.resource_id#"
                        option_name="resource"
                        option_value="resource_id"
                        width="150">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1140.Müşteri Değeri'></cfsavecontent>
            <cf_object_tr id="form_ul_customer_value" Title="#header_#" style="display:none;">
                <cf_object_td type="text"><cf_get_lang_main no='1140.Müşteri Değeri'></cf_object_td>
                <cf_object_td>
                    <select name="customer_value" id="customer_value" style="width:150px;">
                        <option value=""><cf_get_lang_main no='322.seçiniz'></option>
                        <cfoutput query="get_customer_value">
                            <option value="#customer_value_id#" <cfif get_consumer.customer_value_id eq customer_value_id>selected="selected"</cfif>>#customer_value#</option>
                        </cfoutput>
                    </select>	
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no ='62.Üye Özel Tanımı'></cfsavecontent>
            <cf_object_tr id="form_ul_member_add_option_id" Title="#header_#" style="display:none;">
                <cf_object_td type="text"><cf_get_lang no ='62.Üye Özel Tanımı'></cf_object_td>
                <cf_object_td>
                    <cf_wrk_combo 
                        name="member_add_option_id"
                        query_name="GET_MEMBER_ADD_OPTIONS"
                        value="#get_consumer.member_add_option_id#"
                        option_name="member_add_option_name"
                        option_value="member_add_option_id"
                        width="150">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='16.E-mail'></cfsavecontent>
            <cf_object_tr id="form_ul_consumer_email" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='16.E-mail'></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'>!</cfsavecontent>
                    <cfinput type="text" name="consumer_email" id="consumer_email" value="#get_consumer.consumer_email#" validate="email" maxlength="100" message="#message#" style="width:150px;">
                </cf_object_td>
            </cf_object_tr>
            <cf_object_tr id="form_ul_mobilcat_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='116.Kod / Mobil'> <cfif xml_mobile_tel_required eq 1> * </cfif></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="header_"><cf_get_lang no='116.Kod / Mobil'></cfsavecontent>
                    <cfsavecontent variable="message"><cf_get_lang no='85.Kod/ Mobil Girmelisiniz'>!</cfsavecontent>
                    <cfinput type="text" name="mobilcat_id" id="mobilcat_id" value="#get_consumer.mobil_code#" validate="integer" maxlength="7" message="#message#" style="width:47px;">
		            <cfif xml_mobile_tel_required eq 1>
                        <cfinput type="text" name="mobiltel" id="mobiltel" value="#get_consumer.mobiltel#" required="yes" maxlength="10" onKeyUp="isNumber(this);" style="width:100px;" message="#message#">
                    <cfelse>
                        <cfinput type="text" name="mobiltel" id="mobiltel" value="#get_consumer.mobiltel#" maxlength="10" onKeyUp="isNumber(this);" style="width:100px;" message="#message#">
                    </cfif>
                    <cfif len(get_consumer.mobiltel) and session.ep.our_company_info.sms eq 1 ><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_send_sms&member_type=consumer&member_id=#get_consumer.consumer_id#&sms_action=#fuseaction#</cfoutput>','small','popup_form_send_sms');"><img src="/images/mobil.gif" border="0" align="absmiddle" title="<cf_get_lang_main no ='1178 .SMS Gönder'>"></a></cfif>
                    <cfif len(get_consumer.mobiltel) and len(get_consumer.consumer_password) and xml_send_password_by_sms eq 1 and not listfindnocase(denied_pages,'member.emptypopup_send_password_sms')>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_send_password_sms&member_type=consumer&member_id=#get_consumer.consumer_id#&sms_action=#fuseaction#</cfoutput>','small','emptypopup_send_password_sms');"><img src="/images/mobil2.gif" border="0" align="absmiddle" title="<cf_get_lang_main no ='1683.Şifre SMS Gönder'>"></a>
                    </cfif>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='116.Kod / Mobil'> 2</cfsavecontent>
            <cf_object_tr id="form_ul_mobilcat_id_2" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='116.Kod / Mobil'> 2</cf_object_td>
                <cf_object_td>
                <cfsavecontent variable="message"><cf_get_lang no='85.Kod/ Mobil Girmelisiniz'>!</cfsavecontent>
                <cfinput type="text" name="mobilcat_id_2" id="mobilcat_id_2" value="#get_consumer.mobil_code_2#" validate="integer" maxlength="7" message="#message#" style="width:47px;">
                <cfinput type="text" name="mobiltel_2" id="mobiltel_2" maxlength="10" validate="integer" message="#message#" style="width:100px;" onKeyUp="isNumber(this);" value="#get_consumer.mobiltel_2#">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='41.İnternet'></cfsavecontent>
            <cf_object_tr id="form_ul_homepage" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='41.İnternet'></cf_object_td>
                <cf_object_td><input  type="text" name="homepage" id="homepage" value="<cfoutput>#get_consumer.homepage#</cfoutput>" maxlength="50" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='242.im cat / im'></cfsavecontent>
            <cf_object_tr id="form_ul_imcat_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='242.im cat / im'></cf_object_td>
                <cf_object_td>
                    <select name="imcat_id" id="imcat_id" style="width:60px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_im">
                            <option value="#imcat_id#" <cfif imcat_id eq get_consumer.imcat_id>selected</cfif>>#imcat#</option>
                        </cfoutput>
                    </select>
                    <input type="text" name="im" id="im" value="<cfoutput>#get_consumer.im#</cfoutput>" style="width:87px;">
                </cf_object_td>
            </cf_object_tr>
        </cf_object_table>
    </cf_object_main_table>
    <cf_seperator id="kisisel_bilgiler_" header="#lang_array.item[98]#">
    <cf_object_main_table  id="kisisel_bilgiler_">
        <cf_object_table column_width_list="140,200">
            <cfsavecontent variable="header_"><cf_get_lang no='98.Kişisel Bilgiler'></cfsavecontent>
            <cf_object_tr Title="#header_#">
                <cf_object_td type="formbold"><cf_get_lang no='98.Kişisel Bilgiler'></cf_object_td>
                <cf_object_td></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='99.Eğitim Durumu'></cfsavecontent>
            <cf_object_tr id="form_ul_education_level" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='99.Eğitim Durumu'></cf_object_td>
                <cf_object_td>
                    <select name="education_level" id="education_level" style="width:150px;" tabindex="3">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_edu_level">
                            <option value="#edu_level_id#" <cfif get_consumer.education_id eq edu_level_id> selected</cfif>>#education_name#</option>
                        </cfoutput>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='101.Kimlik Kart / No'></cfsavecontent>
            <cf_object_tr id="form_ul_identycard_cat" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='101.Kimlik Kart / No'></cf_object_td>
                <cf_object_td>
                    <cf_wrk_combo 
                        query_name="GET_IDENTYCARD" 
                        name="identycard_cat" 
                        value="#get_consumer.identycard_cat#"
                        option_value="identycat_id" 
                        option_name="identycat"
                        width=90>
                    <input type="text" name="identycard_no" id="identycard_no" value="<cfoutput>#get_consumer.identycard_no#</cfoutput>" maxlength="40" style="width:56px;">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='352.Cinsiyet'></cfsavecontent>
            <cf_object_tr id="form_ul_sex" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='352.Cinsiyet'></cf_object_td>
                <cf_object_td>
                    <select name="sex" id="sex" style="width:150px;" tabindex="3">
                        <option value="1"<cfif get_consumer.sex eq 1> selected</cfif>><cf_get_lang_main no='1547.Erkek'>
                        <option value="0"<cfif get_consumer.sex eq 0> selected</cfif>><cf_get_lang_main no='1546.Kadın'>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='378.Doğum Yeri'></cfsavecontent>
            <cf_object_tr id="form_ul_birthplace" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='378.Doğum Yeri'></cf_object_td>
                <cf_object_td><input type="text" name="birthplace" id="birthplace" style="width:150px;" value="<cfoutput>#get_consumer.birthplace#</cfoutput>" maxlength="30"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1315.Doğum Tarihi'></cfsavecontent>
            <cf_object_tr id="form_ul_birthdate" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1315.Doğum Tarihi'><cfif is_birthday eq 1>*</cfif></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='1315.Doğum Tarihi!'></cfsavecontent>
                    <cfinput validate="eurodate" message="#message#" maxlength="10" type="text" id="birthdate" name="birthdate" value="#dateformat(get_consumer.birthdate,'dd/mm/yyyy')#" style="width:130px;">
                    <cf_wrk_date_image date_field="birthdate">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='375.Medeni Durumu'></cfsavecontent>
            <cf_object_tr id="form_ul_married" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='375.Medeni Durumu'></cf_object_td>
                <cf_object_td>
                    <input type="checkbox" name="married" id="married" tabindex="3" value="1" <cfif get_consumer.married eq 1>checked</cfif>><cf_get_lang no='363.Evli'>&nbsp;
                    <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='2114.Evlilik Tarihi'>!</cfsavecontent>
                    <cfinput type="text" name="married_date" id="married_date" value="#DateFormat(get_consumer.married_date,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" message="#message#" style="width:83px;">
                    <cf_wrk_date_image date_field="married_date">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='364.Uyruğu'></cfsavecontent>
            <cf_object_tr id="form_ul_nationality" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='364.Uyruğu'></cf_object_td>
                <cf_object_td>
                    <select name="nationality" id="nationality" style="width:150px;" tabindex="3">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_country">
                            <option value="#country_id#" <cfif get_country.country_id eq get_consumer.nationality>selected</cfif>>#country_name#</option>
                        </cfoutput>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='253.Çocuk Sayısı'></cfsavecontent>
            <cf_object_tr id="form_ul_child" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='253.Çocuk Sayısı'></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='253.Çocuk Sayısı !'></cfsavecontent>
                    <cfinput type="text" name="child" id="child" value="#get_consumer.child#" validate="integer" message="#message#" maxlength="2" onKeyUp="isNumber(this);" style="width:150px;">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='105.Fotoğraf'></cfsavecontent>
            <cf_object_tr id="form_ul_picture" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='105.Fotoğraf'></cf_object_td>
                <cf_object_td><input type="file" name="picture" id="picture" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='136.Fotoğrafı Sil'></cfsavecontent>
            <cf_object_tr id="form_ul_del_photo" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='136.Fotoğrafı Sil'></cf_object_td>
                <cf_object_td><input type="checkbox" name="del_photo" id="del_photo" value="1"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='613.TC Kimlik No'></cfsavecontent>
            <cf_object_tr id="form_ul_tc_identity_no" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='613.TC Kimlik No'><cfif is_tc_number eq 1> *</cfif></cf_object_td>
                <cf_object_td>
                    <cfif is_tc_number eq 1>
                        <cfset temp_is_tc_number = 1>
                    <cfelse>
                        <cfset temp_is_tc_number = 0>											
                    </cfif>
                    <cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_number="#get_consumer.tc_identy_no#" tc_identity_required="#temp_is_tc_number#" width_info='150' is_verify='1' consumer_name='consumer_name' consumer_surname='consumer_surname' birth_date='birthdate'>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no ='621.Baba Adı'></cfsavecontent>
            <cf_object_tr id="form_ul_father" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no ='621.Baba Adı'></cf_object_td>
                <cf_object_td><input name="father" id="father" value="<cfoutput>#get_consumer.father#</cfoutput>"style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no ='1028.Ana Adı'></cfsavecontent>
            <cf_object_tr id="form_ul_mother" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no ='1028.Ana Adı'></cf_object_td>
                <cf_object_td><input name="mother" id="mother" value="<cfoutput>#get_consumer.mother#</cfoutput>"style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no ='1029.Kan Grubu'></cfsavecontent>
            <cf_object_tr id="form_ul_BLOOD_TYPE" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no ='1029.Kan Grubu'></cf_object_td>
                <cf_object_td>
                    <select name="blood_type" id="blood_type" style="width:150px;">
                        <option value=""><cf_get_lang_main no='322.seçiniz'></option>
                        <option value="0" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 0)> selected</cfif>>0 Rh+</option>
                        <option value="1" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 1)> selected</cfif>>0 Rh-</option>
                        <option value="2" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 2)> selected</cfif>>A Rh+</option>
                        <option value="3" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 3)> selected</cfif>>A Rh-</option>
                        <option value="4" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 4)> selected</cfif>>B Rh+</option>
                        <option value="5" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 5)> selected</cfif>>B Rh-</option>
                        <option value="6" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 6)> selected</cfif>>AB Rh+</option>
                        <option value="7" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 7)> selected</cfif>>AB Rh-</option>
                    </select>  
                </cf_object_td>
            </cf_object_tr>
        </cf_object_table>
        <cf_object_table column_width_list="100,200">
            <cfsavecontent variable="header_"><cf_get_lang no='120.Ev Adres Bilgileri'></cfsavecontent>
            <cf_object_tr Title="#header_#">
                <cf_object_td type="formbold"><cf_get_lang no='120.Ev Adres Bilgileri'></cf_object_td>
                <cf_object_td></cf_object_td>
            </cf_object_tr>
            <cfif Len(get_consumer.home_country_id)>
                <cfquery name="GET_HOME_PHONE" dbtype="query">
                    SELECT COUNTRY_PHONE_CODE FROM GET_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_country_id#">
                </cfquery>
            </cfif>
            <cfsavecontent variable="header_"><cf_get_lang_main no='87.Telefon'></cfsavecontent>
            <cf_object_tr id="form_ul_home_telcode" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='87.Telefon'><cfif is_home_telephone eq 1>*</cfif> <label id="load_phone_home"><cfif Len(get_consumer.home_country_id) and len(get_home_phone.country_phone_code)>(<cfoutput>#get_home_phone.country_phone_code#</cfoutput>)</cfif></label></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='36.Kod/Telefon!'></cfsavecontent>
                    <cfinput type="text" name="home_telcode" id="home_telcode" tabindex="4" value="#get_consumer.consumer_hometelcode#" maxlength="3" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:60px;">
                    <cfinput type="text" name="home_tel" id="home_tel" tabindex="4" value="#get_consumer.consumer_hometel#" maxlength="7" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:87px;">
                </cf_object_td>
            </cf_object_tr>
            <cfif len(get_consumer.home_district_id)>
                <cfquery name="GET_HOME_DIST" datasource="#DSN#">
                    SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_district_id#">
                </cfquery>
                <cfset home_dis = '#get_home_dist.district_name#'>
            <cfelse>
                <cfset home_dis = ''>
            </cfif>
            <cfsavecontent variable="header_"><cf_get_lang_main no='60.Posta Kodu'></cfsavecontent>
            <cf_object_tr id="form_ul_home_postcode" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='60.Posta Kodu'></cf_object_td>
                <cf_object_td><input type="text" name="home_postcode" id="home_postcode" maxlength="15" value="<cfoutput>#get_consumer.homepostcode#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='807.Ülke'></cfsavecontent>
            <cf_object_tr id="form_ul_home_country" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='807.Ülke'></cf_object_td>
                <cf_object_td>
                    <select name="home_country" id="home_country" style="width:150px;" tabindex="4" onchange="LoadCity(this.value,'home_city_id','home_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>);LoadPhone(this.value,'home');">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_country">
                            <option value="#country_id#" <cfif get_consumer.home_country_id eq country_id> selected</cfif>>#country_name#</option>
                        </cfoutput>
                    </select>	
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='559.Şehir'></cfsavecontent>
            <cf_object_tr id="form_ul_home_city_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='559.Şehir'></cf_object_td>
                <cf_object_td>
                    <select name="home_city_id" id="home_city_id"  onchange="LoadCounty(this.value,'home_county_id','home_telcode','0'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'home_district_id'</cfif>);" style="width:150px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfif len(get_consumer.home_country_id) and len(get_consumer.home_city_id)>
                        <cfquery name="GET_CITY_HOME" datasource="#DSN#">
                            SELECT
                                CITY_ID,
                                CITY_NAME 
                            FROM 
                                SETUP_CITY 
                            WHERE 
                                COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_country_id#">
								<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1 and kontrol_zone neq 0>
                                    AND CITY_ID IN(#kontrol_zone#)
                                </cfif>
                        </cfquery>
                        <cfoutput query="get_city_home">
                            <option value="#city_id#" <cfif get_consumer.home_city_id eq city_id>selected</cfif>>#city_name#</option>	
                        </cfoutput>
                        </cfif>
                    </select>
                </cf_object_td>
            </cf_object_tr>   
            <cfsavecontent variable="header_"><cf_get_lang_main no='1226.İlçe'></cfsavecontent>
            <cf_object_tr id="form_ul_home_county_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1226.İlçe'></cf_object_td>
                <cf_object_td>
                    <cfinput type="hidden" name="old_home_county_id" id="old_home_county_id" value="#get_consumer.home_county_id#">
                    <select name="home_county_id" id="home_county_id" style="width:150px;" <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'home_district_id');"</cfif>>
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfif len(get_consumer.home_city_id) and len(get_consumer.home_county_id)>
                            <cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
                                SELECT 
                                    COUNTY_ID,
                                    COUNTY_NAME
                                FROM 
                                    SETUP_COUNTY 
                                WHERE 
                                    CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_city_id#">
									<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1 and kontrol_zone neq 0>
                                        AND CITY IN(#kontrol_zone#)
                                    </cfif>
                            </cfquery>										
                            <cfoutput query="get_county_home">
                                <option value="#county_id#" <cfif get_consumer.home_county_id eq county_id>selected="selected"</cfif>>#county_name#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfif isdefined("is_adres_detail") and is_adres_detail eq 1>
                <cfsavecontent variable="header_"><cf_get_lang_main no='720.Semt'></cfsavecontent>
                <cf_object_tr id="form_ul_home_semt" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='720.Semt'></cf_object_td>
                    <cf_object_td><input type="text" name="home_semt" id="home_semt" value="<cfoutput>#get_consumer.homesemt#</cfoutput>" maxlength="30" style="width:150px;"></cf_object_td>
                </cf_object_tr>
                <!--- Burası incelenecek --->
                <cfsavecontent variable="header_"><cf_get_lang_main no='1323.Mahalle'></cfsavecontent>
                <cf_object_tr id="form_ul_home_district" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='1323.Mahalle'></cf_object_td>
                    <cf_object_td>
                         <cfif is_residence_select eq 0>
                            <input type="text" name="home_district" id="home_district" style="width:150px;" value="<cfif len(get_consumer.home_district)><cfoutput>#get_consumer.home_district#</cfoutput><cfelse><cfoutput>#home_dis#</cfoutput></cfif>">
                         <cfelse>
                             <select name="home_district_id" id="home_district_id" style="width:150px;" onchange="get_ims_code(1);">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_consumer.home_county_id) and len(get_consumer.home_district_id)>
                                    <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                        SELECT * FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_county_id#"> ORDER BY DISTRICT_NAME 
                                    </cfquery>		
                                    <cfoutput query="get_district_name">
                                        <option value="#district_id#" <cfif get_consumer.home_district_id eq district_id>selected</cfif>>#district_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                         </cfif>
                    </cf_object_td>
                </cf_object_tr>
                <!--- Burası incelenecek --->
                <cfsavecontent variable="header_"><cf_get_lang no ='491.Cadde'></cfsavecontent>
                <cf_object_tr id="form_ul_home_main_street" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='491.Cadde'></cf_object_td>
                    <cf_object_td><input type="text" name="home_main_street" id="home_main_street" style="width:150px;" value="<cfoutput>#get_consumer.home_main_street#</cfoutput>"></cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang no ='492.Sokak'></cfsavecontent>
                <cf_object_tr id="form_ul_home_street" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='492.Sokak'></cf_object_td>
                    <cf_object_td><input type="text" name="home_street" id="home_street" style="width:150px;" value="<cfoutput>#get_consumer.home_street#</cfoutput>"></cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang no ='77.Adres Detay'></cfsavecontent>
                <cf_object_tr id="form_ul_home_door_no" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='77.Adres Detay'></cf_object_td>
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
                        <textarea name="home_door_no" id="home_door_no" message="<cfoutput>#message#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);" style="width:150px;" value=""><cfoutput>#get_consumer.home_door_no#</cfoutput></textarea>
                    </cf_object_td>
                </cf_object_tr>
                <input type="hidden" name="home_address" id="home_address" value="<cfoutput>#get_consumer.homeaddress#</cfoutput>">
            <cfelse>
                <cfsavecontent variable="header_"><cf_get_lang_main no='1311.Adres'></cfsavecontent>
                <cf_object_tr id="form_ul_home_address" Title="#header_#">
                    <cf_object_td type="text_top"><cf_get_lang_main no='1311.Adres'></cf_object_td>
                    <cf_object_td><textarea name="home_address" id="home_address" style="width:150px;height:60px;"><cfoutput>#get_consumer.homeaddress#</cfoutput></textarea></cf_object_td>
                </cf_object_tr>
            </cfif>
            <cfsavecontent variable="header_"><cf_get_lang no='602.Fatura Adresini Güncelle'></cfsavecontent>
            <cf_object_tr id="form_ul_is_tax_address" Title="#header_#">
                <cf_object_td type="text"></cf_object_td>
                <cf_object_td><input type="checkbox" name="is_tax_address" id="is_tax_address" value="1" <cfif get_consumer.tax_address_type eq 1>checked</cfif>><cf_get_lang no='602.Fatura Adresini Güncelle'></cf_object_td>
            </cf_object_tr>                                    
        </cf_object_table>
    </cf_object_main_table>
    <cf_seperator id="is_bilgileri_" header="#lang_array.item[106]#" is_closed="1">
    <cf_object_main_table id="is_bilgileri_" hide="1">
        <cf_object_table column_width_list="140,200">
            <cfsavecontent variable="header_"><cf_get_lang no='106.İş Bilgileri'></cfsavecontent>
            <cf_object_tr Title="#header_#">
                <cf_object_td type="formbold"><cf_get_lang no='106.İş Bilgileri'></cf_object_td>
                <cf_object_td></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='162.Şirket'></cfsavecontent>
            <cf_object_tr id="form_ul_company" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='162.Şirket'></cf_object_td>
                <cf_object_td><input type="text" name="company" id="company" value="<cfoutput>#get_consumer.company#</cfoutput>" maxlength="100" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='159.Ünvan'></cfsavecontent>
            <cf_object_tr id="form_ul_title" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='159.Ünvan'></cf_object_td>
                <cf_object_td><input  type="text" name="title" id="title" maxlength="50"value="<cfoutput>#get_consumer.title#</cfoutput>" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='161.Görev'></cfsavecontent>
            <cf_object_tr id="form_ul_mission" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='161.Görev'></cf_object_td>
                <cf_object_td>
                    <select name="mission" id="mission" style="width:150px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_partner_positions">
                            <option value="#partner_position_id#" <cfif get_consumer.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
                        </cfoutput>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='160.Departman'></cfsavecontent>
            <cf_object_tr id="form_ul_department" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='160.Departman'></cf_object_td>
                <cf_object_td>
                    <select name="department" id="department" style="width:150px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_partner_departments">
                            <option value="#partner_department_id#" <cfif get_consumer.department eq partner_department_id>selected</cfif>>#partner_department#</option>
                        </cfoutput>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='167.Sektör'></cfsavecontent>
            <cf_object_tr id="form_ul_sector_cat_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='167.Sektör'></cf_object_td>
                <cf_object_td>
                    <cf_wrk_selectlang
                         name="sector_cat_id"
                         value="#get_consumer.sector_cat_id#"
                         width="150"
                         table_name="SETUP_SECTOR_CATS"
                         option_name="sector_cat"
                         tabindex="5"
                         option_value="sector_cat_id"
                         sort_type="SECTOR_CAT">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='365.Gelir Düzeyi'></cfsavecontent>
            <cf_object_tr id="form_ul_income_level" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='365.Gelir Düzeyi'></cf_object_td>
                <cf_object_td>
                    <cf_wrk_combo 
                        name="income_level"
                        query_name="GET_INCOME_LEVEL"
                        value="#get_consumer.income_level_id#"
                        option_name="income_level"
                        option_value="income_level_id"
                        width="150">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='32.Şirket Büyüklüğü'></cfsavecontent>
            <cf_object_tr id="form_ul_company_size_cat_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='32.Şirket Büyüklüğü'></cf_object_td>
                <cf_object_td>
                    <select name="company_size_cat_id" id="company_size_cat_id" style="width:150px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_company_size">
                            <option value="#company_size_cat_id#"<cfif company_size_cat_id eq get_consumer.company_size_cat_id>selected</cfif>>#company_size_cat#</option>
                        </cfoutput>
                    </select>	
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='351.Sosyal Güvenlik Kurumu'></cfsavecontent>
            <cf_object_tr id="form_ul_social_society_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='351.Sosyal Güvenlik Kurumu'></cf_object_td>
                <cf_object_td>
                    <select name="social_society_id" id="social_society_id" style="width:150px;">
                        <option value=""><cf_get_lang_main no='322.seçiniz'></option>
                        <cfoutput query="get_societies">
                            <option value="#society_id#" <cfif get_consumer.social_society_id eq society_id> selected</cfif>>#society#</option>
                        </cfoutput>
                    </select>	
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='169.Sosyal Güvenlik No'></cfsavecontent>
            <cf_object_tr id="form_ul_social_security_no" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='169.Sosyal Güvenlik No'></cf_object_td>
                <cf_object_td><input type="text" name="social_security_no" id="social_security_no" value="<cfoutput>#get_consumer.social_security_no#</cfoutput>" maxlength="50" onkeyup="isNumber(this);" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='362.meslek Tipi'></cfsavecontent>
            <cf_object_tr id="form_ul_vocation_type" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='362.meslek Tipi'></cf_object_td>
                <cf_object_td>
                    <cf_wrk_combo 
                        name="vocation_type"
                        query_name="GET_VOCATION_TYPE"
                        value="#get_consumer.vocation_type_id#"
                        option_name="vocation_type"
                        option_value="vocation_type_id"
                        width="150">
                </cf_object_td>
            </cf_object_tr>
        </cf_object_table>
        <cf_object_table column_width_list="100,200">
            <cfsavecontent variable="header_"><cf_get_lang no='243.İş Adres Bilgileri'></cfsavecontent>
            <cf_object_tr Title="#header_#">
                <cf_object_td type="formbold"><cf_get_lang no='243.İş Adres Bilgileri'></cf_object_td>
                <cf_object_td></cf_object_td>
            </cf_object_tr>
            <cfif Len(get_consumer.work_country_id)>
                <cfquery name="GET_HOME_PHONE" dbtype="query">
                    SELECT COUNTRY_PHONE_CODE FROM GET_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
                </cfquery>
            </cfif>
            <cfsavecontent variable="header_"><cf_get_lang_main no='87.Telefon'></cfsavecontent>
            <cf_object_tr id="form_ul_work_telcode" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='87.Telefon'> <label id="load_phone_work"><cfif Len(get_consumer.work_country_id) and len(get_home_phone.country_phone_code)>(<cfoutput>#get_home_phone.country_phone_code#</cfoutput>)</cfif></label></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='36.Kod/Telefon!'></cfsavecontent>
                    <cfinput type="text" name="work_telcode" id="work_telcode" value="#get_consumer.consumer_worktelcode#" maxlength="3" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:60px;">
                    <cfinput type="text" name="work_tel" id="work_tel" value="#get_consumer.consumer_worktel#" maxlength="7" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:87px;">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='121.Dahili'></cfsavecontent>
            <cf_object_tr id="form_ul_work_tel_ext" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='121.Dahili'></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='121.dahili !'></cfsavecontent>
                    <cfinput type="text" name="work_tel_ext" id="work_tel_ext" value="#get_consumer.consumer_tel_ext#" validate="integer" message="#message#" maxlength="6" onKeyUp="isNumber(this);" style="width:150px;">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='107.Fax Kod / Fax'></cfsavecontent>
            <cf_object_tr id="form_ul_work_faxcode" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='107.Fax Kod / Fax'></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='107.Fax Kod/Fax!'></cfsavecontent>
                    <cfinput type="text" name="work_faxcode" id="work_faxcode" value="#get_consumer.consumer_faxcode#" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this);" style="width:60px;">
                    <cfinput type="text" name="work_fax" id="work_fax" value="#get_consumer.consumer_fax#" validate="integer" message="#message#" maxlength="7" onKeyUp="isNumber(this);" style="width:87px;">
                </cf_object_td>
            </cf_object_tr>
            <cfif len(get_consumer.work_district_id)>
                <cfquery name="GET_WORK_DIST" datasource="#DSN#">
                    SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_district_id#">
                </cfquery>
                <cfset work_dis = '#get_work_dist.district_name# '>
            <cfelse>
                <cfset work_dis = ''>
            </cfif>
            <cfsavecontent variable="header_">İş <cf_get_lang_main no='60.Posta Kodu'></cfsavecontent>
            <cf_object_tr id="form_ul_work_postcode" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='60.Posta Kodu'></cf_object_td>
                <cf_object_td><input type="text" name="work_postcode" id="work_postcode" value="<cfoutput>#get_consumer.workpostcode#</cfoutput>" maxlength="15" onkeyup="isNumber(this);" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='807.Ülke'></cfsavecontent>
            <cf_object_tr id="form_ul_work_country" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='807.Ülke'></cf_object_td>
                <cf_object_td>
                    <select name="work_country" id="work_country" style="width:150px;" onchange="LoadCity(this.value,'work_city_id','work_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'work_district_id'</cfif>);LoadPhone(this.value,'work');">
                        <option value=""><cf_get_lang_main no='322.seçiniz'></option>
                        <cfoutput query="get_country">
                            <option value="#country_id#" <cfif get_consumer.work_country_id eq country_id>selected</cfif>>#country_name#</option>
                        </cfoutput>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='559.Şehir'></cfsavecontent>
            <cf_object_tr id="form_ul_work_city_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='559.Şehir'></cf_object_td>
                <cf_object_td>
                    <select style="width:150px;" name="work_city_id" id="work_city_id" onchange="LoadCounty(this.value,'work_county_id','work_telcode','0'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'work_district_id'</cfif>);">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfif len(get_consumer.work_country_id) and len(get_consumer.work_city_id)>
                            <cfquery name="GET_CITY_WORK" datasource="#DSN#">
                                SELECT 
                                    CITY_ID, CITY_NAME 
                                FROM 
                                    SETUP_CITY 
                                WHERE 
                                    COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
                                    <cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1 and kontrol_zone neq 0>
                                        AND CITY_ID IN(#kontrol_zone#)
                                    </cfif>
                            </cfquery>
                            <cfoutput query="get_city_work">
                                <option value="#city_id#"<cfif get_consumer.work_city_id eq city_id>selected</cfif>>#city_name#</option>	
                            </cfoutput>
                        </cfif>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1226.İlçe'></cfsavecontent>
            <cf_object_tr id="form_ul_work_county_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1226.İlçe'></cf_object_td>
                <cf_object_td>
                    <cfinput type="hidden" name="old_work_county_id" id="old_work_county_id" value="#get_consumer.work_county_id#">
                    <select style="width:150px;" name="work_county_id" id="work_county_id" <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'work_district_id');"</cfif>>
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfif len(get_consumer.work_city_id) and len(get_consumer.work_county_id)>
                            <cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
                                SELECT 
                                    COUNTY_ID,
                                    COUNTY_NAME
                                FROM 
                                    SETUP_COUNTY 
                                WHERE 
                                    CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">
                                <cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1 and kontrol_zone neq 0>
                                    AND CITY IN(#kontrol_zone#)
                                </cfif>
                            </cfquery>		
                            <cfoutput query="get_county_work">
                                <option value="#county_id#" <cfif get_consumer.work_county_id eq county_id>selected</cfif>>#county_name#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfif isdefined("is_adres_detail") and is_adres_detail eq 1>
                <cfsavecontent variable="header_"><cf_get_lang_main no='720.Semt'></cfsavecontent>
                <cf_object_tr id="form_ul_work_semt" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='720.Semt'></cf_object_td>
                    <cf_object_td><input type="text" name="work_semt" id="work_semt" value="<cfoutput>#get_consumer.worksemt#</cfoutput>" maxlength="30" style="width:150px;"></cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang_main no='1323.Mahalle'></cfsavecontent>
                <cf_object_tr id="form_ul_work_district" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='1323.Mahalle'></cf_object_td>
                    <cf_object_td>
                        <cfif is_residence_select eq 0>
                            <input type="text" name="work_district" id="work_district" style="width:150px;" value="<cfif len(get_consumer.work_district)><cfoutput>#get_consumer.work_district#</cfoutput><cfelse><cfoutput>#work_dis#</cfoutput></cfif>">
                        <cfelse>
                             <select style="width:150px;" name="work_district_id" id="work_district_id" onchange="get_ims_code(2);">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_consumer.work_county_id) and len(get_consumer.work_district_id)>
                                    <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                        SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#"> ORDER BY DISTRICT_NAME
                                    </cfquery>										
                                    <cfoutput query="get_district_name">
                                        <option value="#district_id#" <cfif get_consumer.work_district_id eq district_id>selected</cfif>>#district_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </cfif>
                    </cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang no ='491.Cadde'></cfsavecontent>
                <cf_object_tr id="form_ul_work_main_street" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='491.Cadde'></cf_object_td>
                    <cf_object_td><input type="text" name="work_main_street" id="work_main_street" style="width:150px;" value="<cfoutput>#get_consumer.work_main_street#</cfoutput>"></cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang no ='492.Sokak'></cfsavecontent>
                <cf_object_tr id="form_ul_work_street" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='492.Sokak'></cf_object_td>
                    <cf_object_td><input type="text" name="work_street" id="work_street" style="width:150px;" value="<cfoutput>#get_consumer.work_street#</cfoutput>"></cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang no ='77.Adres Detay'></cfsavecontent>
                <cf_object_tr id="form_ul_work_door_no" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='77.Adres Detay'></cf_object_td>
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
                        <textarea name="work_door_no" id="work_door_no" style="width:150px;" maxlength="250" message="<cfoutput>#message#</cfoutput>" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_consumer.work_door_no#</cfoutput></textarea>
                    </cf_object_td>
                </cf_object_tr>
                <input type="hidden" name="work_address" id="work_address" value="<cfoutput>#get_consumer.workaddress#</cfoutput>">
            <cfelse>
				<cfsavecontent variable="header_">İş <cf_get_lang_main no='1311.Adres'></cfsavecontent>
                <cf_object_tr id="form_ul_work_address" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='1311.Adres'></cf_object_td>
                    <cf_object_td><textarea name="work_address" id="work_address" style="width:150px;height:65px;"><cfoutput>#work_dis##get_consumer.workaddress#</cfoutput></textarea></cf_object_td>
                </cf_object_tr> 	
               	<cfsavecontent variable="header_"><cf_get_lang no='602.Fatura Adresini Güncelle'></cfsavecontent>
            </cfif>
            <cf_object_tr id="form_ul_is_tax_address_2" Title="#header_#">
                <cf_object_td type="text"></cf_object_td>
                <cf_object_td><input type="checkbox" name="is_tax_address_2" id="is_tax_address_2" value="1" <cfif get_consumer.tax_address_type eq 2>checked</cfif>><cf_get_lang no='602.Fatura Adresini Güncelle'></cf_object_td>
            </cf_object_tr>
        </cf_object_table>
    </cf_object_main_table>
    <cf_seperator id="satis_bilgileri_" header="#lang_array.item[110]#" is_closed="1">
    <cf_object_main_table id="satis_bilgileri_" hide="1">
        <cf_object_table column_width_list="140,200">
            <cfsavecontent variable="header_"><cf_get_lang no='110.Satış Bilgileri'></cfsavecontent>
            <cf_object_tr Title="#header_#">
                <cf_object_td type="formbold"><cf_get_lang no='110.Satış Bilgileri'></cf_object_td>
                <cf_object_td></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='107.Cari Hesap'></cfsavecontent>
            <cf_object_tr id="form_ul_is_cari" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='107.Cari Hesap'></cf_object_td>
                <cf_object_td><input type="checkbox" tabindex="7" name="is_cari" id="is_cari" <cfif get_consumer.is_cari eq 1>checked</cfif>><cf_get_lang no='254.Çalışabilir'></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='517.Vergi Mükellefi'></cfsavecontent>
            <cf_object_tr id="form_ul_is_taxpayer" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='517.Vergi Mükellefi'></cf_object_td>
                <cf_object_td><input type="checkbox" name="is_taxpayer" id="is_taxpayer" value="1" <cfif get_consumer.is_taxpayer eq 1>checked</cfif>></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='247.Satış Bölgesi'></cfsavecontent>
            <cf_object_tr id="form_ul_sales_county" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='247.Satış Bölgesi'><cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></cf_object_td>
                <cf_object_td>
                    <cf_wrk_saleszone
                     name="sales_county"
                     width="150"
                     tabindex="7"
                     value="#get_consumer.sales_county#">
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='496.Temsilci'></cfsavecontent>
            <cf_object_tr id="form_ul_pos_code_text" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='496.Temsilci'></cf_object_td>
                <cf_object_td>
                    <input type="hidden" name="old_pos_code" id="old_pos_code" value="<cfoutput>#get_work_pos.position_code#</cfoutput>">
                    <cfif len(get_work_pos.position_code)>
                        <input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#get_work_pos.position_code#</cfoutput>">
                        <input type="text" name="pos_code_text" id="pos_code_text" value="<cfoutput>#get_emp_info(get_work_pos.position_code,1,0)#</cfoutput>" readonly style="width:150px;">
                    <cfelse>
                        <input type="hidden" name="pos_code" id="pos_code" value="">
                        <input type="text" name="pos_code_text" id="pos_code_text" value="" readonly style="width:150px;">
                    </cfif>
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_consumer.pos_code&field_name=upd_consumer.pos_code_text<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1','list','popup_list_positions');return false" tabindex="7"><img src="/images/plus_thin.gif" border="0" align="absmiddle" id="pos_code_1"></a>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='33.Üst Şirket'></cfsavecontent>
            <cf_object_tr id="form_ul_hierarchy_company" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='33.Üst Şirket'></cf_object_td>
                <cf_object_td>
                    <cfif len(get_consumer.hierarchy_id)>
                        <cfquery name="GET_UPPER_COMPANY" datasource="#DSN#">
                            SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.hierarchy_id#">
                        </cfquery>
                        <input type="hidden" name="hierarchy_id" id="hierarchy_id" value="<cfoutput>#get_consumer.hierarchy_id#</cfoutput>">
                        <input type="text" name="hierarchy_company" id="hierarchy_company" style="width:150px;"  readonly value="<cfoutput>#get_upper_company.fullname#</cfoutput>">
                    <cfelse>
                        <input type="hidden" name="hierarchy_id" id="hierarchy_id" value="">
                        <input type="text" name="hierarchy_company" id="hierarchy_company" readonly style="width:150px;">
                    </cfif>
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_consumer.hierarchy_id&field_comp_name=upd_consumer.hierarchy_company<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=2','list','popup_list_pars');return false" tabindex="7"><img src="/images/plus_thin.gif" border="0" align="absmiddle" id="pos_code_2"></a>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='722.Micro Bölge Kodu'></cfsavecontent>
            <cf_object_tr id="form_ul_ims_code_name" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='722.Micro Bölge Kodu'><cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></cf_object_td>
                <cf_object_td>
                    <cfif len(get_consumer.ims_code_id)>
                        <cfquery name="GET_IMS" datasource="#DSN#">
                            SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.ims_code_id#">
                        </cfquery>
                        <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#get_consumer.ims_code_id#</cfoutput>">
                        <cfinput type="text" name="ims_code_name" id="ims_code_name" value="#get_ims.ims_code# #get_ims.ims_code_name#" style="width:150px;" readonly>
                    <cfelse>
                        <input type="hidden" name="ims_code_id" id="ims_code_id" value="">
                        <cfinput type="text" name="ims_code_name" id="ims_code_name" value="" style="width:150px;">
                    </cfif>
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=upd_consumer.ims_code_name&field_id=upd_consumer.ims_code_id','list','popup_list_ims_code');" tabindex="7"><img src="/images/plus_thin.gif" border="0" align="absmiddle" id="pos_code_3"></a>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='34.Kampanya'></cfsavecontent>
            <cf_object_tr id="form_ul_camp_name" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='34.Kampanya'></cf_object_td>
                <cf_object_td>
                    <cfif len(get_consumer.campaign_id)>
                        <cfquery name="get_camp_info" datasource="#dsn3#">
                            SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = #get_consumer.campaign_id#
                        </cfquery>
                    <cfelse>
                        <cfset get_camp_info.camp_head = ''>
                    </cfif>
                    <cfoutput>
                    <input type="hidden" name="camp_id" id="camp_id" value="#get_consumer.campaign_id#">
                    <input type="text" name="camp_name" id="camp_name" value="#get_camp_info.camp_head#" style="width:150px;">
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=upd_consumer.camp_id&field_name=upd_consumer.camp_name','list','popup_list_campaigns');"><img border="0" src="/images/plus_list.gif" align="absmiddle"></a>
                    </cfoutput>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no ='435.Timeout Süresi (dk)'></cfsavecontent>
            <cf_object_tr id="form_ul_timeout_limit" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no ='435.Timeout Süresi (dk)'></cf_object_td>
                <cf_object_td>
                    <select name="timeout_limit" id="timeout_limit" style="width:150px;">
                        <option value="15" <cfif get_consumer.timeout_limit is '15'>selected</cfif>>15 dk.</option>
                        <option value="30" <cfif get_consumer.timeout_limit is '30'>selected</cfif>>30 dk.</option>
                        <option value="45" <cfif get_consumer.timeout_limit is '45'>selected</cfif>>45 dk.</option>
                        <option value="60" <cfif get_consumer.timeout_limit is '60'>selected</cfif>>60 dk.</option>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='604.Mail Almak İstemiyorum'></cfsavecontent>
            <cf_object_tr id="form_ul_not_want_email" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='604.Mail Almak İstemiyorum'></cf_object_td>
                <cf_object_td><input type="checkbox" name="not_want_email" id="not_want_email" value="0"<cfif get_consumer.want_email eq 0>checked</cfif>></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang no='603.SMS Almak İstemiyorum'></cfsavecontent>
            <cf_object_tr id="form_ul_not_want_sms" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang no='603.SMS Almak İstemiyorum'></cf_object_td>
                <cf_object_td><input type="checkbox" name="not_want_sms" id="not_want_sms" value="0"<cfif get_consumer.want_sms eq 0>checked</cfif>></cf_object_td>
            </cf_object_tr>                                    
        </cf_object_table>
        <cf_object_table column_width_list="100,160">
            <cfsavecontent variable="header_"><cf_get_lang_main no='1337.Fatura Bilgileri'></cfsavecontent>
            <cf_object_tr Title="#header_#">
                <cf_object_td type="formbold"><cf_get_lang_main no='1337.Fatura Bilgileri'></cf_object_td>
                <cf_object_td></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1350.Vergi Dairesi'></cfsavecontent>
            <cf_object_tr id="form_ul_tax_office" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1350.Vergi Dairesi'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                <cf_object_td><input type="text" tabindex="8" name="tax_office" id="tax_office" value="<cfoutput>#get_consumer.tax_office#</cfoutput>" maxlength="50" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='340.Vergi No'></cfsavecontent>
            <cf_object_tr id="form_ul_tax_no" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='340.Vergi No'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                <cf_object_td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='340.Vergi No!'></cfsavecontent>
                    <cfinput type="text" tabindex="8" name="tax_no" id="tax_no" value="#get_consumer.tax_no#" validate="integer" message="#message#" maxlength="11" onKeyUp="isNumber(this);" style="width:150px;">
                </cf_object_td>
            </cf_object_tr>
            <cfif len(get_consumer.tax_district_id)>
                <cfquery name="GET_TAX_DIST" datasource="#DSN#">
                    SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_district_id#">
                </cfquery>
                <cfset tax_dis = '#get_tax_dist.district_name# '>
            <cfelse>
                <cfset tax_dis = ''>
            </cfif>
            <cfsavecontent variable="header_"><cf_get_lang_main no='60.Posta Kodu'></cfsavecontent>
            <cf_object_tr id="form_ul_tax_postcode" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='60.Posta Kodu'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                <cf_object_td><input type="text" tabindex="8" name="tax_postcode" id="tax_postcode" maxlength="15" value="<cfoutput>#get_consumer.tax_postcode#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;"></cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='807.Ülke'></cfsavecontent>
            <cf_object_tr id="form_ul_tax_country" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='807.Ülke'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                <cf_object_td>
                    <select name="tax_country" id="tax_country" style="width:150px;" onchange="LoadCity(this.value,'tax_city_id','tax_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'tax_district_id'</cfif>);">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_country">
                            <option value="#get_country.country_id#" <cfif get_consumer.tax_country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
                        </cfoutput>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='559.Şehir'></cfsavecontent>
            <cf_object_tr id="form_ul_tax_city_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='559.Şehir'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                <cf_object_td>
                    <select style="width:150px;" name="tax_city_id" id="tax_city_id"  onchange="LoadCounty(this.value,'tax_county_id','','0'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'tax_district_id'</cfif>);">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfif len(get_consumer.tax_country_id) and len(get_consumer.tax_city_id)>
                            <cfquery name="GET_CITY_TAX" datasource="#DSN#">
                                SELECT 
                                    CITY_ID, CITY_NAME 
                                FROM 
                                    SETUP_CITY 
                                WHERE 
                                    COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_country_id#">
                                    <cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1 and kontrol_zone neq 0>
                                        AND CITY_ID IN(#kontrol_zone#)
                                    </cfif>
                            </cfquery>				  
                            <cfoutput query="get_city_tax">
                                <option value="#get_city_tax.city_id#"<cfif get_consumer.tax_city_id eq get_city_tax.city_id>selected</cfif>>#GET_CITY_TAX.CITY_NAME#</option>	
                            </cfoutput>
                        </cfif>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1226.Ilçe'></cfsavecontent>
            <cf_object_tr id="form_ul_tax_county_id" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1226.İlçe'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                <cf_object_td>
                    <select style="width:150px;" name="tax_county_id" id="tax_county_id" <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'tax_district_id');"</cfif>>
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfif len(get_consumer.tax_city_id) and len(get_consumer.tax_county_id)>
                            <cfquery name="GET_COUNTY_TAX" datasource="#DSN#">
                                SELECT 
                                    COUNTY_ID,
                                    COUNTY_NAME
                                FROM 
                                    SETUP_COUNTY 
                                WHERE 
                                    CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_city_id#">
                                    <cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1 and kontrol_zone neq 0>
                                        AND CITY IN(#kontrol_zone#)
                                    </cfif>
                            </cfquery>		
                            <cfoutput query="get_county_tax">
                                <option value="#county_id#" <cfif get_consumer.tax_county_id eq county_id>selected</cfif>>#county_name#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </cf_object_td>
            </cf_object_tr>
            <cfif isdefined("is_adres_detail") and is_adres_detail eq 1>
                <cfsavecontent variable="header_"><cf_get_lang_main no='720.Semt'></cfsavecontent>
                <cf_object_tr id="form_ul_tax_semt" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='720.Semt'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                    <cf_object_td><cfinput type="text" name="tax_semt" id="tax_semt" value="#get_consumer.tax_semt#" maxlength="30" style="width:150px;"></cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang_main no='1323.Mahalle'></cfsavecontent>
                <cf_object_tr id="form_ul_tax_district" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='1323.Mahalle'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                    <cf_object_td>
                        <cfif is_residence_select eq 0>
                            <input type="text" name="tax_district" id="tax_district" style="width:150px;" value="<cfif len(get_consumer.tax_district)><cfoutput>#get_consumer.tax_district#</cfoutput><cfelse><cfoutput>#tax_dis#</cfoutput></cfif>">
                        <cfelse>
                             <select style="width:150px;" name="tax_district_id" id="tax_district_id" onchange="get_ims_code(3);">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_consumer.tax_county_id) and len(get_consumer.tax_district_id)>
                                    <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                        SELECT DISTRICT_ID,DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_county_id#"> ORDER BY DISTRICT_NAME
                                    </cfquery>										
                                    <cfoutput query="get_district_name">
                                        <option value="#district_id#" <cfif get_consumer.tax_district_id eq district_id>selected</cfif>>#district_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </cfif>
                    </cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang no ='491.Cadde'></cfsavecontent>
                <cf_object_tr id="form_ul_tax_main_street" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='491.Cadde'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                    <cf_object_td><input type="text" name="tax_main_street" id="tax_main_street" style="width:150px;" value="<cfoutput>#get_consumer.tax_main_street#</cfoutput>"></cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang no ='492.Sokak'></cfsavecontent>
                <cf_object_tr id="form_ul_tax_street" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='492.Sokak'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                    <cf_object_td><input type="text" name="tax_street" id="tax_street" style="width:150px;" value="<cfoutput>#get_consumer.tax_street#</cfoutput>"></cf_object_td>
                </cf_object_tr>
                <cfsavecontent variable="header_"><cf_get_lang no ='77.Adres Detay'></cfsavecontent>
                <cf_object_tr id="form_ul_tax_door_no" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang no ='77.Adres Detay'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
                        <textarea name="tax_door_no" id="tax_door_no" style="width:150px;" maxlength="5" message="<cfoutput>#message#</cfoutput>" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_consumer.tax_door_no#</cfoutput></textarea>
                    </cf_object_td>
                </cf_object_tr>
            <cfelse>
          		<cfsavecontent variable="header_"><cf_get_lang no='123.Fatura Adresi'></cfsavecontent>
                <cf_object_tr id="form_ul_tax_address" Title="#header_#">
                    <cf_object_td type="text_top"><cf_get_lang no='123.Fatura Adresi'><cfif is_invoice_info_detail eq 1>*</cfif></cf_object_td>
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
                        <textarea name="tax_address" id="tax_address" tabindex="8" style="width:150px;height:60px;" message="<cfoutput>#message#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#tax_dis# #get_consumer.tax_adress#</cfoutput></textarea>
                    </cf_object_td>
                </cf_object_tr>
            </cfif>
            <cfsavecontent variable="header_"><cf_get_lang_main no='1137.Koordinatlar'></cfsavecontent>
            <cf_object_tr id="form_ul_coordinate_1" Title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1137.Koordinatlar'></cf_object_td>
                <cf_object_td>
                    <cf_get_lang_main no='1141.E'><cfinput type="text" maxlength="10" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="#get_consumer.coordinate_1#" name="coordinate_1" id="coordinate_1" style="width:65px;"> 
                    <cf_get_lang_main no='1179.B'><cfinput type="text" maxlength="10" range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#get_consumer.coordinate_2#" name="coordinate_2" id="coordinate_2" style="width:64px;">
                    <cfif len(get_consumer.coordinate_1) and len(get_consumer.coordinate_2)>
                        <cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#get_consumer.coordinate_1#&coordinate_2=#get_consumer.coordinate_2#&title=#get_consumer.consumer_name#&nbsp;#get_consumer.consumer_surname#','list','popup_view_map')"><img src="/images/branch.gif" border="0" title="Haritada Göster" align="absmiddle"></a></cfoutput>
                    </cfif>
                </cf_object_td>
            </cf_object_tr>
        </cf_object_table>
    </cf_object_main_table>
	<cf_form_box_footer>   
		<cf_record_info query_name="get_consumer" is_consumer="1" record_emp="record_member">
		<cfif get_consumer.ispotantial eq 1>
			<cfset url_str = "&pot=1">
		<cfelse>
			<cfset url_str = "">
		</cfif>
		<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
	</cf_form_box_footer>
    </cfform>
</cf_form_box>
<br />
<cfsavecontent variable="message"><cf_get_lang no='369.Diğer Adresler'></cfsavecontent>
<cf_box closable="0" style="width:100%;" unload_body="1" id="list_consumer_contact" title="#message#" box_page="#request.self#?fuseaction=member.emptypopup_ajax_list_consumer_contact&cid=#attributes.cid#"></cf_box>
<cfsavecontent variable="message"><cf_get_lang no ='134.Bireysel Üye İlişkisi'></cfsavecontent>
<cf_box id="list_member_rel"  style="width:100%;" title="#message#" closable="0" unload_body="1" box_page="#request.self#?fuseaction=objects.emptypopup_ajax_member_relations&relation_info_id=#attributes.cid#&action_type_info=2"></cf_box>