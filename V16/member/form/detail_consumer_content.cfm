<cfform name="upd_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_consumer&#xml_str#">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.cid#</cfoutput>">
    <input type="hidden" name="cid" id="cid" value="<cfoutput>#attributes.cid#</cfoutput>">
    <input type="hidden" name="old_cat_id" id="old_cat_id" value="<cfoutput>#get_consumer.consumer_cat_id#</cfoutput>">
    <input type="hidden" name="is_upper_ref" id="is_upper_ref" value="0">
    <input type="hidden" name="x_name_surname_write_standart" id="x_name_surname_write_standart" value="<cfoutput>#x_name_surname_write_standart#</cfoutput>" />
	<!--- Uye modulu power user kontrolu icin eklendi. BK 20140821 --->
	<input type="hidden" name="x_power_user" id="x_power_user" value="<cfoutput>#get_module_power_user(4)#</cfoutput>" />
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="47163.Bireysel Hesaplar"> <cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
	<cf_box id="consumer_content" title="#message#">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-consumer_status" extra_checkbox="ispotantial,is_related_consumer" height="20">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<input type="checkbox" name="consumer_status" id="consumer_status" <cfif get_consumer.consumer_status is 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
					</label>
				</div>
				<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12">
					<cfif is_dsp_potantial_check eq 1>
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="ispotantial" id="ispotantial" <cfif get_consumer.ispotantial is 1>checked="checked"</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'>
						</label>
					</cfif>
				</div>
				<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12">
					<cfif is_dsp_related_consumer_check eq 1>
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_related_consumer" id="is_related_consumer" <cfif get_consumer.is_related_consumer is 1> checked="checked"</cfif>><cf_get_lang dictionary_id='30559.Bağlı Üye'>
						</label>
					</cfif>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-xs-12" type="column" index="2" sort="true">
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57558.Üye No'></cfsavecontent>
				<div class="form-group" id="item-customer_number">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57558.Üye No'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="customer_number" id="customer_number" value="<cfoutput>#get_consumer.member_code#</cfoutput>" maxlength="50"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57631.Ad'></cfsavecontent>
				<div class="form-group" id="item-consumer_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
					<div class="col col-8 col-xs-12"><cfinput type="text" name="consumer_name" id="consumer_name" value="#Left(get_consumer.consumer_name,50)#" required="yes"  maxlength="50"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
				<div class="form-group" id="item-consumer_surname">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
					<div class="col col-8 col-xs-12"><cfinput type="text" name="consumer_surname" id="consumer_surname" value="#Left(get_consumer.consumer_surname,50)#" required="yes" maxlength="50"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></cfsavecontent>
				<div class="form-group" id="item-consumer_username">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
					<div class="col col-8 col-xs-12"><cfinput type="text" name="consumer_username" id="consumer_username" value="#get_consumer.consumer_username#" maxlength="50"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57552.Şifre'></cfsavecontent>
				<div class="form-group" id="item-consumer_password">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif xml_hidden_password eq 1>
								<cfif xml_enter_manual_password eq 1>
									<cfinput type="text" class="input-type-password"  name="consumer_password" id="consumer_password" value="" maxlength="10" oncopy="return false" onpaste="return false">
								<cfelse>
									<cfinput type="text" class="input-type-password" name="consumer_password" id="consumer_password" value="" maxlength="10" readonly="yes" oncopy="return false" onpaste="return false">
								</cfif>
							<cfelse>
								<cfinput type="text" class="input-type-password" name="consumer_password" id="consumer_password" value="" maxlength="10" oncopy="return false" onpaste="return false">
							</cfif>
							<span class="input-group-addon showPassword" onclick="showPasswordClass('consumer_password')"><i class="fa fa-eye"></i></span>
							<cfif isdefined("is_add_password") and is_add_password eq 1>
								<span class="input-group-addon bold btnPointer" onclick="sayfa_getir();">?</span>
								<div id="SHOW_PASSWORD"></div>
							</cfif>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30448.Uyelik Baslama Tarihi'></cfsavecontent>
				<div class="form-group" id="item-startdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30448.Uyelik Baslama Tarihi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id ='30448.Üyelik Başlama Tarihi'></cfsavecontent>
							<cfinput type="text" name="startdate" id="startdate" maxlength="10" value="#dateformat(get_consumer.start_date,dateformat_style)#" validate="#validate_style#" message="#alert#" style="width:130px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58636.Referans Üye'></cfsavecontent>
				<div class="form-group" id="item-ref_pos_code_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58636.Referans Üye'><cfif is_req_reference_member eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="ref_pos_code" id="ref_pos_code" <cfif len(get_consumer.ref_pos_code)> value="<cfoutput>#get_consumer.ref_pos_code#</cfoutput>"</cfif>>
							<input type="text" name="ref_pos_code_name" id="ref_pos_code_name" value="<cfif len(get_consumer.ref_pos_code)><cfoutput>#get_cons_info(get_consumer.ref_pos_code,0,0)#</cfoutput></cfif>">
							<!--- xml deki parametreye bagli olarak sadece ilgili calisanlar guncellesin --->
							<cfif not len(get_consumer.ref_pos_code) or not len(is_reference_member_upd_code) or (len(is_reference_member_upd_code) and listfind(is_reference_member_upd_code,session.ep.position_code))>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=upd_consumer.ref_pos_code&field_consumer=upd_consumer.dsp_reference_code&field_name=upd_consumer.ref_pos_code_name&field_cons_ref_code=upd_consumer.reference_code&call_function=kontrol_ref_member(0)&kontrol_conscat_id=#get_consumer.consumer_cat_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>)"></span>
							</cfif>
							<div style="position:absolute;" id="open_process"></div>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30593.Referans Kod'></cfsavecontent>
				<div class="form-group" id="item-dsp_reference_code">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30593.Referans Kod'></label>
					<div class="col col-8 col-xs-12">
						<input type="hidden" name="hidden_reference_code" id="hidden_reference_code" value="<cfoutput>#get_consumer.consumer_reference_code#</cfoutput>">
						<input type="hidden" name="reference_code" id="reference_code" value="<cfoutput>#get_consumer.consumer_reference_code#</cfoutput>">
						<input type="hidden" name="hidden_ref_pos_code" id="hidden_ref_pos_code" value="<cfoutput>#get_consumer.ref_pos_code#</cfoutput>">
						<input type="text" name="dsp_reference_code" id="dsp_reference_code" value="<cfoutput>#get_consumer.ref_pos_code#</cfoutput>" maxlength="250">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30720.Öneren Üye'></cfsavecontent>
				<div class="form-group" id="item-proposer_cons_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30720.Öneren Üye'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
						<input type="hidden" name="proposer_cons_id" id="proposer_cons_id" <cfif len(get_consumer.proposer_cons_id)> value="<cfoutput>#get_consumer.proposer_cons_id#</cfoutput>"</cfif>>
						<input type="text" name="proposer_cons_name" id="proposer_cons_name" onfocus="AutoComplete_Create('proposer_cons_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','2,0,0,0','CONSUMER_ID','proposer_cons_id','upd_consumer','3','250');" value="<cfif len(get_consumer.proposer_cons_id) ><cfoutput>#get_cons_info(get_consumer.proposer_cons_id,0,0)#</cfoutput></cfif>" autocomplete="off">
						<span class="input-group-addon icon-pluss btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=upd_consumer.proposer_cons_id&field_name=upd_consumer.proposer_cons_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>)"></span>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57789.Ozel Kod'></cfsavecontent>
				<div class="form-group" id="item-ozel_kod">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Ozel Kod'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="ozel_kod" id="ozel_kod" value="<cfoutput>#get_consumer.ozel_kod#</cfoutput>" maxlength="50"></div>
				</div>
				<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_add_info info_type_id="-2" info_id="#attributes.cid#" upd_page = "1" colspan="9"> 
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-xs-12" type="column" index="3" sort="true">
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57493.Aktif'>-<cf_get_lang dictionary_id='57577.Potansiyel'>-<cf_get_lang dictionary_id='30559.Bağlı Üye'></cfsavecontent>
				<cfif session.ep.our_company_info.is_earchive and get_consumer.use_efatura neq 1>
				<div class="form-group" id="item-use_earchive">
					<input type="hidden" name="use_earchive" value="<cfoutput>#get_consumer.use_earchive#</cfoutput>">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59328.E-Arşiv'> <cf_get_lang dictionary_id='57441.Fatura'></label>
					<div class="col col-8 col-xs-12">
						<select name="earchive_sending_type" id="earchive_sending_type" style="width:100px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="0" <cfif get_consumer.earchive_sending_type eq 0>selected</cfif>><cf_get_lang dictionary_id='41981.KAĞIT'></option>
							<option value="1" <cfif get_consumer.earchive_sending_type eq 1>selected</cfif>><cf_get_lang dictionary_id='59873.ELEKTRONİK'></option>
						</select>
					</div>
				</div>
				</cfif>
				<cfif session.ep.our_company_info.is_efatura >
					<cfif get_consumer.use_efatura is 1><span style="color:##000;font-weight:bold">&nbsp;&nbsp;<cfoutput><cf_get_lang dictionary_id='59034.e-Fatura Mukellefi'> - #dateformat(get_consumer.efatura_date,dateformat_style)#</cfoutput></span></cfif>
				</cfif>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id="58859.Süreç"></cfsavecontent>
				<div class="form-group" id="item-process_stage">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
					<div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' select_value = '#get_consumer.consumer_stage#' process_cat_width='150' is_detail='1'></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></cfsavecontent>
				<div class="form-group" id="item-consumer_cat_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'>*</label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_MemberCat
							name="consumer_cat_id"
							is_active="1"
							comp_cons="0"
							value="#get_consumer.consumer_cat_id#">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58830.İlişki Şekli'></cfsavecontent>
				<div class="form-group" id="item-resource">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'> <cfif isdefined("is_resource_info") and is_resource_info eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_combo 
							name="resource"
							query_name="GET_PARTNER_RESOURCE"
							value="#get_consumer.resource_id#"
							option_name="resource"
							option_value="resource_id"
							width="150">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></cfsavecontent>
				<div class="form-group" id="item-customer_value">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
					<div class="col col-8 col-xs-12">
						<select name="customer_value" id="customer_value">
							<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
							<cfoutput query="get_customer_value">
								<option value="#customer_value_id#" <cfif get_consumer.customer_value_id eq customer_value_id>selected="selected"</cfif>>#customer_value#</option>
							</cfoutput>
						</select>	
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30200.Üye Özel Tanımı'></cfsavecontent>
				<div class="form-group" id="item-member_add_option_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30200.Üye Özel Tanımı'></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_combo 
							name="member_add_option_id"
							query_name="GET_MEMBER_ADD_OPTIONS"
							value="#get_consumer.member_add_option_id#"
							option_name="member_add_option_name"
							option_value="member_add_option_id"
							width="150">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57428.E-mail'></cfsavecontent>
				<div class="form-group" id="item-consumer_email">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57428.E-mail'>!</cfsavecontent>
						<cfinput type="text" name="consumer_email" id="consumer_email" value="#get_consumer.consumer_email#" validate="email" maxlength="100" message="#message#">
					</div>
				</div>
				<div class="form-group" id="item-consumer_email">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="consumer_kep_address" id="consumer_kep_address" value="#get_consumer.consumer_kep_address#" validate="email" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-mobilcat_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'> <cfif xml_mobile_tel_required eq 1> * </cfif></label>
						<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30254.Kod / Mobil'></cfsavecontent>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='30223.Kod/ Mobil Girmelisiniz'>!</cfsavecontent>
						<div class="col col-2 col-xs-2">
							<cfinput type="text" name="mobilcat_id" id="mobilcat_id" value="#get_consumer.mobil_code#" validate="integer" maxlength="7" message="#message#" style="width:47px;">
						</div>
						<cfif xml_mobile_tel_required eq 1>
							<div class="col col-6 col-xs-10">
								<cfinput type="text" name="mobiltel" id="mobiltel" value="#get_consumer.mobiltel#" required="yes" maxlength="10" onKeyUp="isNumber(this);" style="width:100px;" message="#message#">
							</div>
						<cfelse>
							<div class="col col-6 col-xs-10">
							<cfinput type="text" name="mobiltel" id="mobiltel" value="#get_consumer.mobiltel#" maxlength="10" onKeyUp="isNumber(this);" style="width:100px;" message="#message#">
							</div>
						</cfif>
						<cfif len(get_consumer.mobiltel) and session.ep.our_company_info.sms eq 1 ><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_send_sms&member_type=consumer&member_id=#get_consumer.consumer_id#&sms_action=#fuseaction#</cfoutput>','small','popup_form_send_sms');"><img src="/images/mobil.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id ='58590.SMS Gönder'>"></a></cfif>
						<cfif len(get_consumer.mobiltel) and len(get_consumer.consumer_password) and xml_send_password_by_sms eq 1 and not listfindnocase(denied_pages,'member.emptypopup_send_password_sms')>
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_send_password_sms&member_type=consumer&member_id=#get_consumer.consumer_id#&sms_action=#fuseaction#</cfoutput>','small','emptypopup_send_password_sms');"><img src="/images/mobil2.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id ='29480.Şifre SMS Gönder'>"></a>
						</cfif>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30254.Kod / Mobil'> 2</cfsavecontent>
				<div class="form-group" id="item-mobilcat_id_2">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'> 2</label>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='30223.Kod/ Mobil Girmelisiniz'>!</cfsavecontent>
					<div class="col col-2 col-xs-2">
						<cfinput type="text" name="mobilcat_id_2" id="mobilcat_id_2" value="#get_consumer.mobil_code_2#" validate="integer" maxlength="7" message="#message#" style="width:47px;">
					</div>
					<div class="col col-6 col-xs-10">
						<cfinput type="text" name="mobiltel_2" id="mobiltel_2" maxlength="10" validate="integer" message="#message#" style="width:100px;" onKeyUp="isNumber(this);" value="#get_consumer.mobiltel_2#">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30179.İnternet'></cfsavecontent>
				<div class="form-group" id="item-homepage">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30179.İnternet'></label>
					<div class="col col-8 col-xs-12"><input  type="text" name="homepage" id="homepage" value="<cfoutput>#get_consumer.homepage#</cfoutput>" maxlength="50"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30380.im cat / im'></cfsavecontent>
				<div class="form-group" id="item-imcat_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30380.im cat / im'></label>
					<div class="col col-4 col-xs-12">
						<select name="imcat_id" id="imcat_id" style="width:60px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_im">
								<option value="#imcat_id#" <cfif imcat_id eq get_consumer.imcat_id>selected</cfif>>#imcat#</option>
							</cfoutput>
						</select>
					</div>
					<div class="col col-4 col-xs-12">
						<input type="text" name="im" id="im" value="<cfoutput>#get_consumer.im#</cfoutput>" style="width:87px;">
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="30236.Kişisel Bilgiler"></cfsavecontent>
		<cf_seperator name="#message#" id="kisisel_bilgiler" title="#message#">
		<cf_box_elements id="kisisel_bilgiler">
			<div class="col col-6 col-md-6 col-xs-12" type="column" index="4" sort="true">						
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30237.Eğitim Durumu'></cfsavecontent>
				<div class="form-group col col-12" id="item-education_level">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30237.Eğitim Durumu'></label>
					<div class="col col-8 col-xs-12">
						<select name="education_level" id="education_level" tabindex="3">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_edu_level">
								<option value="#edu_level_id#" <cfif get_consumer.education_id eq edu_level_id> selected</cfif>>#education_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30239.Kimlik Kart / No'></cfsavecontent>
				<div class="form-group col col-12" id="item-identycard_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30239.Kimlik Kart / No'></label>
					<div class="col col-4 col-xs-12">
						<cf_wrk_combo 
							query_name="GET_IDENTYCARD" 
							name="identycard_cat" 
							value="#get_consumer.identycard_cat#"
							option_value="identycat_id" 
							option_name="identycat"
							width=90>
					</div>
					<div class="col col-4 col-xs-12">
						<input type="text" name="identycard_no" id="identycard_no" value="<cfoutput>#get_consumer.identycard_no#</cfoutput>" maxlength="40" style="width:56px;">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57764.Cinsiyet'></cfsavecontent>
				<div class="form-group col col-12" id="item-sex">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
					<div class="col col-8 col-xs-12">
						<select name="sex" id="sex" tabindex="3">
							<option value="1"<cfif get_consumer.sex eq 1> selected</cfif>><cf_get_lang dictionary_id='58959.Erkek'>
							<option value="0"<cfif get_consumer.sex eq 0> selected</cfif>><cf_get_lang dictionary_id='58958.Kadın'>
						</select>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57790.Doğum Yeri'></cfsavecontent>
				<div class="form-group col col-12" id="item-birthplace">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="birthplace" id="birthplace" value="<cfoutput>#get_consumer.birthplace#</cfoutput>" maxlength="30"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></cfsavecontent>
				<div class="form-group col col-12" id="item-birthdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'><cfif is_birthday eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi!'></cfsavecontent>
							<cfinput validate="#validate_style#" message="#message#" maxlength="10" type="text" id="birthdate" name="birthdate" value="#dateformat(get_consumer.birthdate,dateformat_style)#" style="width:130px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="birthdate"></span>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30513.Medeni Durumu'></cfsavecontent>
				<div class="form-group col col-12" id="item-married">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30513.Medeni Durumu'></label>
					<div class="col col-2 col-xs-12">
						<input type="checkbox" name="married" id="married" tabindex="3" value="1" <cfif get_consumer.married eq 1>checked</cfif>><span><cf_get_lang dictionary_id='30501.Evli'></span>
					</div>
					<div class="col col-6 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='29911.Evlilik Tarihi'>!</cfsavecontent>
							<cfinput type="text" name="married_date" id="married_date" value="#DateFormat(get_consumer.married_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:83px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="married_date"></span>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30502.Uyruğu'></cfsavecontent>
				<div class="form-group col col-12" id="item-nationality">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30502.Uyruğu'></label>
					<div class="col col-8 col-xs-12">
						<select name="nationality" id="nationality" tabindex="3">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#country_id#" <cfif get_country.country_id eq get_consumer.nationality>selected</cfif>>#country_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30391.Çocuk Sayısı'></cfsavecontent>
				<div class="form-group col col-12" id="item-child">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30391.Çocuk Sayısı'></label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30391.Çocuk Sayısı !'></cfsavecontent>
						<cfinput type="text" name="child" id="child" value="#get_consumer.child#" validate="integer" message="#message#" maxlength="2" onKeyUp="isNumber(this);">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30243.Fotoğraf'></cfsavecontent>
				<div class="form-group col col-12" id="item-picture">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30243.Fotoğraf'></label>
					<div class="col col-8 col-xs-12"><input type="file" name="picture" id="picture"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30274.Fotoğrafı Sil'></cfsavecontent>
				<div class="form-group col col-12" id="item-del_photo">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30274.Fotoğrafı Sil'></label>
					<div class="col col-8 col-xs-12"><input type="checkbox" name="del_photo" id="del_photo" value="1"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58025.TC Kimlik No'></cfsavecontent>
				<div class="form-group col col-12" id="item-tc_identity_no">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'><cfif is_tc_number eq 1> *</cfif></label>
					<div class="col col-8 col-xs-12">
						<cfif is_tc_number eq 1>
							<cfset temp_is_tc_number = 1>
						<cfelse>
							<cfset temp_is_tc_number = 0>											
						</cfif>
						<cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_number="#get_consumer.tc_identy_no#" tc_identity_required="#temp_is_tc_number#" width_info='150' is_verify='1' consumer_name='consumer_name' consumer_surname='consumer_surname' birth_date='birthdate' use_gib="1" gdpr="2">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='58033.Baba Adı'></cfsavecontent>
				<div class="form-group col col-12" id="item-father">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58033.Baba Adı'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="father" id="father" value="<cfoutput>#get_consumer.father#</cfoutput>"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='58440.Ana Adı'></cfsavecontent>
				<div class="form-group col col-12" id="item-mother">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58440.Ana Adı'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="mother" id="mother" value="<cfoutput>#get_consumer.mother#</cfoutput>"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='58441.Kan Grubu'></cfsavecontent>
				<div class="form-group col col-12" id="item-BLOOD_TYPE">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
					<div class="col col-8 col-xs-12">
						<select name="blood_type" id="blood_type">
							<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
							<option value="0" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 0)> selected</cfif>>0 Rh+</option>
							<option value="1" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 1)> selected</cfif>>0 Rh-</option>
							<option value="2" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 2)> selected</cfif>>A Rh+</option>
							<option value="3" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 3)> selected</cfif>>A Rh-</option>
							<option value="4" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 4)> selected</cfif>>B Rh+</option>
							<option value="5" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 5)> selected</cfif>>B Rh-</option>
							<option value="6" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 6)> selected</cfif>>AB Rh+</option>
							<option value="7" <cfif len(get_consumer.blood_type) and (get_consumer.blood_type eq 7)> selected</cfif>>AB Rh-</option>
						</select>  
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-xs-12" type="column" index="5" sort="true">
				<cfif Len(get_consumer.home_country_id)>
					<cfquery name="GET_HOME_PHONE" dbtype="query">
						SELECT COUNTRY_PHONE_CODE FROM GET_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_country_id#">
					</cfquery>
				</cfif>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57499.Telefon'></cfsavecontent>
				<div class="form-group col col-12" id="item-home_telcode">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'><cfif is_home_telephone eq 1>*</cfif> <span id="load_phone_home"><cfif Len(get_consumer.home_country_id) and len(get_home_phone.country_phone_code)>(<cfoutput>#get_home_phone.country_phone_code#</cfoutput>)</cfif></span></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30174.Kod/Telefon!'></cfsavecontent>
					<div class="col col-2 col-xs-2">	
						<cfinput type="text" name="home_telcode" id="home_telcode" tabindex="4" value="#get_consumer.consumer_hometelcode#" maxlength="3" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:60px;">
					</div>
					<div class="col col-6 col-xs-12">	
						<cfinput type="text" name="home_tel" id="home_tel" tabindex="4" value="#get_consumer.consumer_hometel#" maxlength="7" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:87px;">
					</div>
				</div>
				<cfif len(get_consumer.home_district_id)>
					<cfquery name="GET_HOME_DIST" datasource="#DSN#">
						SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_district_id#">
					</cfquery>
					<cfset home_dis = '#get_home_dist.district_name#'>
				<cfelse>
					<cfset home_dis = ''>
				</cfif>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57472.Posta Kodu'></cfsavecontent>
				<div class="form-group col col-12" id="item-home_postcode">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="home_postcode" id="home_postcode" maxlength="15" value="<cfoutput>#get_consumer.homepostcode#</cfoutput>" onkeyup="isNumber(this);"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58219.Ülke'></cfsavecontent>
				<div class="form-group col col-12" id="item-home_country">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
					<div class="col col-8 col-xs-12">
						<select name="home_country" id="home_country" tabindex="4" onchange="LoadCity(this.value,'home_city_id','home_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>);LoadPhone(this.value,'home');">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#country_id#" <cfif get_consumer.home_country_id eq country_id> selected</cfif>>#country_name#</option>
							</cfoutput>
						</select>	
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57971.Şehir'></cfsavecontent>
				<div class="form-group col col-12" id="item-home_city_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
					<div class="col col-8 col-xs-12">
						<select name="home_city_id" id="home_city_id"  onchange="LoadCounty(this.value,'home_county_id','home_telcode','0'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'home_district_id'</cfif>);">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
					</div>
				</div>   
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58638.İlçe'></cfsavecontent>
				<div class="form-group col col-12" id="item-home_county_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
					<div class="col col-8 col-xs-12">
						<cfinput type="hidden" name="old_home_county_id" id="old_home_county_id" value="#get_consumer.home_county_id#">
						<select name="home_county_id" id="home_county_id" <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'home_district_id');"</cfif>>
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
					</div>
				</div>
				<cfif isdefined("is_adres_detail") and is_adres_detail eq 1>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58132.Semt'></cfsavecontent>
					<div class="form-group col col-12" id="item-home_semt">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
						<div class="col col-8 col-xs-12"><input type="text" name="home_semt" id="home_semt" value="<cfoutput>#get_consumer.homesemt#</cfoutput>" maxlength="30"></div>
					</div>
					<!--- Burası incelenecek --->
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58735.Mahalle'></cfsavecontent>
					<div class="form-group col col-12" id="item-home_district">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
						<div class="col col-8 col-xs-12">
							<cfif is_residence_select eq 0>
								<input type="text" name="home_district" id="home_district" value="<cfif len(get_consumer.home_district)><cfoutput>#get_consumer.home_district#</cfoutput><cfelse><cfoutput>#home_dis#</cfoutput></cfif>">
							<cfelse>
								<select name="home_district_id" id="home_district_id" onchange="get_ims_code(1);">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
						</div>
					</div>
					<!--- Burası incelenecek --->
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30629.Cadde'></cfsavecontent>
					<div class="form-group col col-12" id="item-home_main_street">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30629.Cadde'></label>
						<div class="col col-8 col-xs-12"><input type="text" name="home_main_street" id="home_main_street" value="<cfoutput>#get_consumer.home_main_street#</cfoutput>"></div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30630.Sokak'></cfsavecontent>
					<div class="form-group col col-12" id="item-home_street">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30630.Sokak'></label>
						<div class="col col-8 col-xs-12"><input type="text" name="home_street" id="home_street" value="<cfoutput>#get_consumer.home_street#</cfoutput>"></div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30215.Adres Detay'></cfsavecontent>
					<div class="form-group col col-12" id="item-home_door_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30215.Adres Detay'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
							<textarea name="home_door_no" id="home_door_no" message="<cfoutput>#message#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);" value=""><cfoutput>#get_consumer.home_door_no#</cfoutput></textarea>
						</div>
					</div>
					<input type="hidden" name="home_address" id="home_address" value="<cfoutput>#get_consumer.homeaddress#</cfoutput>">
				<cfelse>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58723.Adres'></cfsavecontent>
					<div class="form-group col col-12" id="item-home_address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
						<div class="col col-8 col-xs-12"><textarea name="home_address" id="home_address" style="width:150px;height:60px;"><cfoutput>#get_consumer.homeaddress#</cfoutput></textarea></div>
					</div>
				</cfif>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30740.Fatura Adresini Güncelle'></cfsavecontent>
				<div class="form-group col col-12" id="item-is_tax_address">
					<label class="col col-4 col-xs-12"></label>
					<div class="col col-8 col-xs-12"><label><input type="checkbox" name="is_tax_address" id="is_tax_address" value="1" <cfif get_consumer.tax_address_type eq 1>checked</cfif>><cf_get_lang dictionary_id='30740.Fatura Adresini Güncelle'></label></div>
				</div>                   
			</div>
		</cf_box_elements>

		<cfsavecontent variable="message"><cf_get_lang dictionary_id="30244.İş Bilgileri"></cfsavecontent>
		<cf_seperator name="#message#" id="is_bilgileri" title="#message#">
		<cf_box_elements id="is_bilgileri">
			<div class="col col-6 col-md-6 col-xs-12" type="column" index="6" sort="true">
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57574.Şirket'></cfsavecontent>
				<div class="form-group col col-12" id="item-company">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="company" id="company" value="<cfoutput>#get_consumer.company#</cfoutput>" maxlength="100"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57571.Ünvan'></cfsavecontent>
				<div class="form-group col col-12" id="item-title">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
					<div class="col col-8 col-xs-12"><input  type="text" name="title" id="title" maxlength="50"value="<cfoutput>#get_consumer.title#</cfoutput>"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57573.Görev'></cfsavecontent>
				<div class="form-group col col-12" id="item-mission">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57573.Görev'></label>
					<div class="col col-8 col-xs-12">
						<select name="mission" id="mission">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_positions">
								<option value="#partner_position_id#" <cfif get_consumer.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57572.Departman'></cfsavecontent>
				<div class="form-group col col-12" id="item-department">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
					<div class="col col-8 col-xs-12">
						<select name="department" id="department">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_departments">
								<option value="#partner_department_id#" <cfif get_consumer.department eq partner_department_id>selected</cfif>>#partner_department#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57579.Sektör'></cfsavecontent>
				<div class="form-group col col-12" id="item-sector_cat_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_selectlang
							name="sector_cat_id"
							value="#get_consumer.sector_cat_id#"
							width="150"
							table_name="SETUP_SECTOR_CATS"
							option_name="sector_cat"
							tabindex="5"
							option_value="sector_cat_id"
							sort_type="SECTOR_CAT">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30503.Gelir Düzeyi'></cfsavecontent>
				<div class="form-group col col-12" id="item-income_level">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30503.Gelir Düzeyi'></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_combo 
							name="income_level"
							query_name="GET_INCOME_LEVEL"
							value="#get_consumer.income_level_id#"
							option_name="income_level"
							option_value="income_level_id"
							width="150">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30170.Şirket Büyüklüğü'></cfsavecontent>
				<div class="form-group col col-12" id="item-company_size_cat_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30170.Şirket Büyüklüğü'></label>
					<div class="col col-8 col-xs-12">
						<select name="company_size_cat_id" id="company_size_cat_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_company_size">
								<option value="#company_size_cat_id#"<cfif company_size_cat_id eq get_consumer.company_size_cat_id>selected</cfif>>#company_size_cat#</option>
							</cfoutput>
						</select>	
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30489.Sosyal Güvenlik Kurumu'></cfsavecontent>
				<div class="form-group col col-12" id="item-social_society_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30489.Sosyal Güvenlik Kurumu'></label>
					<div class="col col-8 col-xs-12">
						<select name="social_society_id" id="social_society_id">
							<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
							<cfoutput query="get_societies">
								<option value="#society_id#" <cfif get_consumer.social_society_id eq society_id> selected</cfif>>#society#</option>
							</cfoutput>
						</select>	
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30307.Sosyal Güvenlik No'></cfsavecontent>
				<div class="form-group col col-12" id="item-social_security_no">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30307.Sosyal Güvenlik No'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="social_security_no" id="social_security_no" value="<cfoutput>#get_consumer.social_security_no#</cfoutput>" maxlength="50" onkeyup="isNumber(this);"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30500.meslek Tipi'></cfsavecontent>
				<div class="form-group col col-12" id="item-vocation_type">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30500.meslek Tipi'></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_combo 
							name="vocation_type"
							query_name="GET_VOCATION_TYPE"
							value="#get_consumer.vocation_type_id#"
							option_name="vocation_type"
							option_value="vocation_type_id"
							width="150">
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-xs-12" type="column" index="7" sort="true">
				<cfif Len(get_consumer.work_country_id)>
					<cfquery name="GET_HOME_PHONE" dbtype="query">
						SELECT COUNTRY_PHONE_CODE FROM GET_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
					</cfquery>
				</cfif>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57499.Telefon'></cfsavecontent>
				<div class="form-group col col-12" id="item-work_telcode">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> <span id="load_phone_work"><cfif Len(get_consumer.work_country_id) and len(get_home_phone.country_phone_code)>(<cfoutput>#get_home_phone.country_phone_code#</cfoutput>)</cfif></span></label>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30174.Kod/Telefon!'></cfsavecontent>
					<div class="col col-2 col-xs-2">
						<cfinput type="text" name="work_telcode" id="work_telcode" value="#get_consumer.consumer_worktelcode#" maxlength="3" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:60px;">
					</div>
					<div class="col col-6 col-xs-10">
						<cfinput type="text" name="work_tel" id="work_tel" value="#get_consumer.consumer_worktel#" maxlength="7" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:87px;">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30259.Dahili'></cfsavecontent>
				<div class="form-group col col-12" id="item-work_tel_ext">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30259.Dahili'></label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30259.dahili !'></cfsavecontent>
						<cfinput type="text" name="work_tel_ext" id="work_tel_ext" value="#get_consumer.consumer_tel_ext#" validate="integer" message="#message#" maxlength="6" onKeyUp="isNumber(this);">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30245.Fax Kod / Fax'></cfsavecontent>
				<div class="form-group col col-12" id="item-work_faxcode">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30245.Fax Kod / Fax'></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30245.Fax Kod/Fax!'></cfsavecontent>
					<div class="col col-2 col-xs-2">
						<cfinput type="text" name="work_faxcode" id="work_faxcode" value="#get_consumer.consumer_faxcode#" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this);" style="width:60px;">
					</div>
					<div class="col col-6 col-xs-10">	
						<cfinput type="text" name="work_fax" id="work_fax" value="#get_consumer.consumer_fax#" validate="integer" message="#message#" maxlength="7" onKeyUp="isNumber(this);" style="width:87px;">
					</div>
				</div>
				<cfif len(get_consumer.work_district_id)>
					<cfquery name="GET_WORK_DIST" datasource="#DSN#">
						SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_district_id#">
					</cfquery>
					<cfset work_dis = '#get_work_dist.district_name# '>
				<cfelse>
					<cfset work_dis = ''>
				</cfif>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58445.İş'> <cf_get_lang dictionary_id='57472.Posta Kodu'></cfsavecontent>
				<div class="form-group col col-12" id="item-work_postcode">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
					<div class="col col-8 col-xs-12"><input type="text" name="work_postcode" id="work_postcode" value="<cfoutput>#get_consumer.workpostcode#</cfoutput>" maxlength="15" onkeyup="isNumber(this);"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58219.Ülke'></cfsavecontent>
				<div class="form-group col col-12" id="item-work_country">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
					<div class="col col-8 col-xs-12">
						<select name="work_country" id="work_country" onchange="LoadCity(this.value,'work_city_id','work_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'work_district_id'</cfif>);LoadPhone(this.value,'work');">
							<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#country_id#" <cfif get_consumer.work_country_id eq country_id>selected</cfif>>#country_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57971.Şehir'></cfsavecontent>
				<div class="form-group col col-12" id="item-work_city_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
					<div class="col col-8 col-xs-12">
						<select name="work_city_id" id="work_city_id" onchange="LoadCounty(this.value,'work_county_id','work_telcode','0'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'work_district_id'</cfif>);">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58638.İlçe'></cfsavecontent>
				<div class="form-group col col-12" id="item-work_county_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
					<div class="col col-8 col-xs-12">
						<cfinput type="hidden" name="old_work_county_id" id="old_work_county_id" value="#get_consumer.work_county_id#">
						<select name="work_county_id" id="work_county_id" <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'work_district_id');"</cfif>>
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
					</div>
				</div>
				<cfif isdefined("is_adres_detail") and is_adres_detail eq 1>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58132.Semt'></cfsavecontent>
					<div class="form-group col col-12" id="item-work_semt">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
						<div class="col col-8 col-xs-12"><input type="text" name="work_semt" id="work_semt" value="<cfoutput>#get_consumer.worksemt#</cfoutput>" maxlength="30"></div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58735.Mahalle'></cfsavecontent>
					<div class="form-group col col-12" id="item-work_district">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
						<div class="col col-8 col-xs-12">
							<cfif is_residence_select eq 0>
								<input type="text" name="work_district" id="work_district" value="<cfif len(get_consumer.work_district)><cfoutput>#get_consumer.work_district#</cfoutput><cfelse><cfoutput>#work_dis#</cfoutput></cfif>">
							<cfelse>
								<select name="work_district_id" id="work_district_id" onchange="get_ims_code(2);">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
						</div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30629.Cadde'></cfsavecontent>
					<div class="form-group col col-12" id="item-work_main_street">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30629.Cadde'></label>
						<div class="col col-8 col-xs-12"><input type="text" name="work_main_street" id="work_main_street" value="<cfoutput>#get_consumer.work_main_street#</cfoutput>"></div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30630.Sokak'></cfsavecontent>
					<div class="form-group col col-12" id="item-work_street">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30630.Sokak'></label>
						<div class="col col-8 col-xs-12"><input type="text" name="work_street" id="work_street" value="<cfoutput>#get_consumer.work_street#</cfoutput>"></div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30215.Adres Detay'></cfsavecontent>
					<div class="form-group col col-12" id="item-work_door_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30215.Adres Detay'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
							<textarea name="work_door_no" id="work_door_no" style="width:150px;" maxlength="250" message="<cfoutput>#message#</cfoutput>" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_consumer.work_door_no#</cfoutput></textarea>
						</div>
					</div>
					<input type="hidden" name="work_address" id="work_address" value="<cfoutput>#get_consumer.workaddress#</cfoutput>">
				<cfelse>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58445.İş'> <cf_get_lang dictionary_id='58723.Adres'></cfsavecontent>
					<div class="form-group col col-12" id="item-work_address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
						<div class="col col-8 col-xs-12"><textarea name="work_address" id="work_address" style="width:150px;height:65px;"><cfoutput>#work_dis##get_consumer.workaddress#</cfoutput></textarea></div>
					</div> 	
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30740.Fatura Adresini Güncelle'></cfsavecontent>
				</cfif>
				<div class="form-group col col-12" id="item-is_tax_address_2">
					<label class="col col-4 col-xs-12"></label>
					<div class="col col-8 col-xs-12"><label><input type="checkbox" name="is_tax_address_2" id="is_tax_address_2" value="1" <cfif get_consumer.tax_address_type eq 2>checked</cfif>><cf_get_lang dictionary_id='30740.Fatura Adresini Güncelle'></label></div>
				</div>
			</div>
		</cf_box_elements>
		
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="30248.Satış Bilgileri"></cfsavecontent>
		<cf_seperator name="#message#" id="satis_bilgileri" title="#message#">
		<cf_box_elements id="satis_bilgileri">
			<div class="col col-6 col-md-6 col-xs-12 ui-form-list" type="column" index="11" sort="true">
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57519.Cari Hesap'></cfsavecontent>
				<div class="form-group col col-12" id="item-is_cari">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
					<div class="col col-8 col-xs-12">
						<label>
							<input type="checkbox" tabindex="7" name="is_cari" id="is_cari" <cfif get_consumer.is_cari eq 1>checked</cfif>><cf_get_lang dictionary_id='30392.Çalışabilir'>
						</label>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30655.Vergi Mükellefi'></cfsavecontent>
				<div class="form-group col col-12" id="item-is_taxpayer">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30655.Vergi Mükellefi'></label>
					<div class="col col-8 col-xs-12">
						<label><input type="checkbox" name="is_taxpayer" id="is_taxpayer" value="1" <cfif get_consumer.is_taxpayer eq 1>checked</cfif>></label>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></cfsavecontent>
				<div class="form-group col col-12" id="item-sales_county">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'><cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_saleszone
						name="sales_county"
						width="150"
						tabindex="7"
						value="#get_consumer.sales_county#">
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57908.Temsilci'></cfsavecontent>
				<div class="form-group col col-12" id="item-pos_code_text">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57908.Temsilci'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="old_pos_code" id="old_pos_code" value="<cfoutput>#get_work_pos.position_code#</cfoutput>">
							<cfif len(get_work_pos.position_code)>
								<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#get_work_pos.position_code#</cfoutput>">
								<input type="text" name="pos_code_text" id="pos_code_text" value="<cfoutput>#get_emp_info(get_work_pos.position_code,1,0)#</cfoutput>" readonly>
							<cfelse>
								<input type="hidden" name="pos_code" id="pos_code" value="">
								<input type="text" name="pos_code_text" id="pos_code_text" value="" readonly>
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_consumer.pos_code&field_name=upd_consumer.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1');return false" tabindex="7"></span>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30171.Üst Şirket'></cfsavecontent>
				<div class="form-group col col-12" id="item-hierarchy_company">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30171.Üst Şirket'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif len(get_consumer.hierarchy_id)>
								<cfquery name="GET_UPPER_COMPANY" datasource="#DSN#">
									SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.hierarchy_id#">
								</cfquery>
								<input type="hidden" name="hierarchy_id" id="hierarchy_id" value="<cfoutput>#get_consumer.hierarchy_id#</cfoutput>">
								<input type="text" name="hierarchy_company" id="hierarchy_company"  readonly value="<cfoutput>#get_upper_company.fullname#</cfoutput>">
							<cfelse>
								<input type="hidden" name="hierarchy_id" id="hierarchy_id" value="">
								<input type="text" name="hierarchy_company" id="hierarchy_company" readonly>
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_consumer.hierarchy_id&field_comp_name=upd_consumer.hierarchy_company<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2');return false" tabindex="7"></span>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58134.Micro Bölge Kodu'></cfsavecontent>
				<div class="form-group col col-12" id="item-ims_code_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58134.Micro Bölge Kodu'><cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif len(get_consumer.ims_code_id)>
								<cfquery name="GET_IMS" datasource="#DSN#">
									SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.ims_code_id#">
								</cfquery>
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#get_consumer.ims_code_id#</cfoutput>">
								<cfinput type="text" name="ims_code_name" id="ims_code_name" value="#get_ims.ims_code# #get_ims.ims_code_name#" readonly>
							<cfelse>
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="">
								<cfinput type="text" name="ims_code_name" id="ims_code_name" value="">
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=upd_consumer.ims_code_name&field_id=upd_consumer.ims_code_id','','ui-draggable-box-small');" tabindex="7"></span>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57446.Kampanya'></cfsavecontent>
				<div class="form-group col col-12" id="item-camp_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif len(get_consumer.campaign_id)>
								<cfquery name="get_camp_info" datasource="#dsn3#">
									SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = #get_consumer.campaign_id#
								</cfquery>
							<cfelse>
								<cfset get_camp_info.camp_head = ''>
							</cfif>
							<cfoutput>
							<input type="hidden" name="camp_id" id="camp_id" value="#get_consumer.campaign_id#">
							<input type="text" name="camp_name" id="camp_name" value="#get_camp_info.camp_head#">
							<span class="input-group-addon icon-pluss btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=upd_consumer.camp_id&field_name=upd_consumer.camp_name');"></span>
							</cfoutput>
						</div>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30573.Timeout Süresi (dk)'></cfsavecontent>
				<div class="form-group col col-12" id="item-timeout_limit">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30573.Timeout Süresi (dk)'></label>
					<div class="col col-8 col-xs-12">
						<select name="timeout_limit" id="timeout_limit">
							<option value="15" <cfif get_consumer.timeout_limit is '15'>selected</cfif>>15 <cf_get_lang dictionary_id='58827.Dk'>.</option>
							<option value="30" <cfif get_consumer.timeout_limit is '30'>selected</cfif>>30 <cf_get_lang dictionary_id='58827.Dk'>.</option>
							<option value="45" <cfif get_consumer.timeout_limit is '45'>selected</cfif>>45 <cf_get_lang dictionary_id='58827.Dk'>.</option>
							<option value="60" <cfif get_consumer.timeout_limit is '60'>selected</cfif>>60 <cf_get_lang dictionary_id='58827.Dk'>.</option>
						</select>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30742.Mail Almak İstemiyorum'></cfsavecontent>
				<div class="form-group col col-12" id="item-not_want_email">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30742.Mail Almak İstemiyorum'></label>
					<div class="col col-8 col-xs-12"><label><input type="checkbox" name="not_want_email" id="not_want_email" value="0"<cfif get_consumer.want_email eq 0>checked</cfif>></label></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30741.SMS Almak İstemiyorum'></cfsavecontent>
				<div class="form-group col col-12" id="item-not_want_sms">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30741.SMS Almak İstemiyorum'></label>
					<div class="col col-8 col-xs-12"><label><input type="checkbox" name="not_want_sms" id="not_want_sms" value="0"<cfif get_consumer.want_sms eq 0>checked</cfif>></label></div>
				</div> 
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30742.Mail Almak İstemiyorum'></cfsavecontent>
				<div class="form-group col col-12" id="item-not_want_email">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64230.Sesli Arama Almak İstemiyorum'></label>
					<div class="col col-8 col-xs-12"><label><input type="checkbox" name="not_want_call" id="not_want_call" value="0"<cfif get_consumer.want_call eq 0>checked</cfif>></label></div>
				</div>       
			</div>
			<div class="col col-6 col-md-6 col-xs-12 ui-form-list" type="column" index="12" sort="true">
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></cfsavecontent>
				<div class="form-group col col-12" id="item-tax_office">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'><cfif is_invoice_info_detail eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12"><input type="text" tabindex="8" name="tax_office" id="tax_office" value="<cfoutput>#get_consumer.tax_office#</cfoutput>" maxlength="50"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57752.Vergi No'></cfsavecontent>
				<div class="form-group col col-12" id="item-tax_no">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'><cfif is_invoice_info_detail eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57752.Vergi No!'></cfsavecontent>
						<cfinput type="text" tabindex="8" name="tax_no" id="tax_no" value="#get_consumer.tax_no#" validate="integer" message="#message#" maxlength="10" onKeyUp="isNumber(this);">
					</div>
				</div>
				<cfif len(get_consumer.tax_district_id)>
					<cfquery name="GET_TAX_DIST" datasource="#DSN#">
						SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_district_id#">
					</cfquery>
					<cfset tax_dis = '#get_tax_dist.district_name# '>
				<cfelse>
					<cfset tax_dis = ''>
				</cfif>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57472.Posta Kodu'></cfsavecontent>
				<div class="form-group col col-12" id="item-tax_postcode">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'><cfif is_invoice_info_detail eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12"><input type="text" tabindex="8" name="tax_postcode" id="tax_postcode" maxlength="15" value="<cfoutput>#get_consumer.tax_postcode#</cfoutput>" onkeyup="isNumber(this);"></div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58219.Ülke'></cfsavecontent>
				<div class="form-group col col-12" id="item-tax_country">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'><cfif is_invoice_info_detail eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<select name="tax_country" id="tax_country" onchange="LoadCity(this.value,'tax_city_id','tax_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'tax_district_id'</cfif>);">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif get_consumer.tax_country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57971.Şehir'></cfsavecontent>
				<div class="form-group col col-12" id="item-tax_city_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'><cfif is_invoice_info_detail eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<select name="tax_city_id" id="tax_city_id"  onchange="LoadCounty(this.value,'tax_county_id','','0'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'tax_district_id'</cfif>);">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
					</div>
				</div>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58638.Ilçe'></cfsavecontent>
				<div class="form-group col col-12" id="item-tax_county_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'><cfif is_invoice_info_detail eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<select name="tax_county_id" id="tax_county_id" <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'tax_district_id');"</cfif>>
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
					</div>
				</div>
				<cfif isdefined("is_adres_detail") and is_adres_detail eq 1>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58132.Semt'></cfsavecontent>
					<div class="form-group col col-12" id="item-tax_semt">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'><cfif is_invoice_info_detail eq 1>*</cfif></label>
						<div class="col col-8 col-xs-12"><cfinput type="text" name="tax_semt" id="tax_semt" value="#get_consumer.tax_semt#" maxlength="30"></div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58735.Mahalle'></cfsavecontent>
					<div class="form-group col col-12" id="item-tax_district">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'><cfif is_invoice_info_detail eq 1>*</cfif></label>
						<div class="col col-8 col-xs-12">
							<cfif is_residence_select eq 0>
								<input type="text" name="tax_district" id="tax_district" value="<cfif len(get_consumer.tax_district)><cfoutput>#get_consumer.tax_district#</cfoutput><cfelse><cfoutput>#tax_dis#</cfoutput></cfif>">
							<cfelse>
								<select name="tax_district_id" id="tax_district_id" onchange="get_ims_code(3);">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
						</div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30629.Cadde'></cfsavecontent>
					<div class="form-group col col-12" id="item-tax_main_street">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30629.Cadde'><cfif is_invoice_info_detail eq 1>*</cfif></label>
						<div class="col col-8 col-xs-12"><input type="text" name="tax_main_street" id="tax_main_street" value="<cfoutput>#get_consumer.tax_main_street#</cfoutput>"></div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30630.Sokak'></cfsavecontent>
					<div class="form-group col col-12" id="item-tax_street">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30630.Sokak'><cfif is_invoice_info_detail eq 1>*</cfif></label>
						<div class="col col-8 col-xs-12"><input type="text" name="tax_street" id="tax_street" value="<cfoutput>#get_consumer.tax_street#</cfoutput>"></div>
					</div>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30215.Adres Detay'></cfsavecontent>
					<div class="form-group col col-12" id="item-tax_door_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30215.Adres Detay'><cfif is_invoice_info_detail eq 1>*</cfif></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
							<textarea name="tax_door_no" id="tax_door_no" style="width:150px;" message="<cfoutput>#message#</cfoutput>" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_consumer.tax_door_no#</cfoutput></textarea>
						</div>
					</div>
				<cfelse>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='30261.Fatura Adresi'></cfsavecontent>
					<div class="form-group col col-12" id="item-tax_address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30261.Fatura Adresi'><cfif is_invoice_info_detail eq 1>*</cfif></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
							<textarea name="tax_address" id="tax_address" tabindex="8" style="width:150px;height:60px;" message="<cfoutput>#message#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#tax_dis# #get_consumer.tax_adress#</cfoutput></textarea>
						</div>
					</div>
				</cfif>
				<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58549.Koordinatlar'></cfsavecontent>
				<div class="form-group col col-12" id="item-coordinate_1">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58549.Koordinatlar'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='59875.Lütfen enlem değerini -90 ile 90 arasında giriniz'></cfsavecontent>
						<span class="input-group-addon bold"><cf_get_lang dictionary_id='58553.E'></span><cfinput type="text" maxlength="10" range="-90,90" message="#message#" value="#get_consumer.coordinate_1#" name="coordinate_1" id="coordinate_1" style="width:65px;"> 
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='59894.Lütfen boylam değerini -180 ile 180 arasında giriniz'></cfsavecontent>
						<span class="input-group-addon bold"><cf_get_lang dictionary_id='58591.B'></span><cfinput type="text" maxlength="10" range="-180,180" message="#message#" value="#get_consumer.coordinate_2#" name="coordinate_2" id="coordinate_2" style="width:64px;">
						<cfif len(get_consumer.coordinate_1) and len(get_consumer.coordinate_2)>
							<cfoutput><span class="input-group-addon icon-ellipis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#get_consumer.coordinate_1#&coordinate_2=#get_consumer.coordinate_2#&title=#get_consumer.consumer_name#&nbsp;#get_consumer.consumer_surname#','list','popup_view_map')"></span></cfoutput>
						</cfif>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>		
		<cf_box_footer>
			<div class="col col-6 col-xs-12 text-left">
				<cf_record_info query_name="get_consumer" is_consumer="1" record_emp="record_member">
				<cfif get_consumer.ispotantial eq 1>
					<cfset url_str = "&pot=1">
				<cfelse>
					<cfset url_str = "">
				</cfif>
			</div>
			<div class="col col-6 col-xs-12 text-right">
				<cfif session.ep.admin eq 1>
					<cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=member.emptypopup_del_consumer&consumer_id=#attributes.cid#' add_function='kontrol()'>
				<cfelse>
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
				</cfif>
			</div>
	</cf_box_footer>
	</cf_box>
</cfform>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30507.Diğer Adresler'></cfsavecontent>
<cf_box closable="0" style="width:100%;" unload_body="1" id="list_consumer_contact" title="#message#" box_page="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_ajax_list_consumer_contact&cid=#attributes.cid#"></cf_box>
<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30272.Bireysel Üye İlişkisi'></cfsavecontent>
<cf_box id="list_member_rel" scroll="1" style="width:100%;" title="#message#" closable="0" unload_body="1" box_page="#request.self#?fuseaction=objects.emptypopup_ajax_member_relations&relation_info_id=#attributes.cid#&action_type_info=2"></cf_box>
