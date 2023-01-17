<cf_xml_page_edit>
<cf_get_lang_set module_name="hr"><!--- sayfanin alt kisminda kapanisi var --->
<cfinclude template="../query/get_edu_level.cfm">
<cfinclude template="../query/get_driverlicence.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_languages.cfm">
<cfinclude template="../query/get_know_levels.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('myhome',581,'Personel Taleplerim')#">
        <cfform name="add_form" id="add_form" method="post" action="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.emptypopup_add_personel_requirement" enctype="multipart/form-data">
            <input type="hidden" id="circuitDet" value="<cfoutput>#ListFirst(attributes.fuseaction,'.')#</cfoutput>" name="circuitDet">
            <input name="record_num" id="record_num" type="hidden" value="0">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-xs-12">
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="1">
                        <div class="form-group" id="item-Talep">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
                        </div>
                        <div class="form-group" id="item-req_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Baslik'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfif isDefined("x_display_change_head") and x_display_change_head eq 1><cfset readonly_ = ""><cfelse><cfset readonly_ = "yes"></cfif>
                                <cfsavecontent variable="head_message"><cf_get_lang dictionary_id='56873.Personel Talebi'></cfsavecontent>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Baslik'>!</cfsavecontent>
                                <cfinput type="text" name="req_head" id="req_head" value="#head_message#" readonly="#readonly_#" required="yes" message="#message#" maxlength="100" style="width:456px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-our_company">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Sirket'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="our_company_id" id="our_company_id" value="" readonly>
                                <cfinput type="text" name="our_company" id="our_company" value="" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="item-our_branch">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Sube'>/ <cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-4 col-xs-12">
                                <input type="hidden" name="branch_id" id="branch_id" value="">
                                <input type="text" name="branch" id="branch" value="" readonly>
                            </div>
                            <div class="col col-4 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="department_id" id="department_id" value="">
                                    <input type="text" name="department" id="department" value="" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_list_departments&field_id=add_form.department_id&field_name=add_form.department&field_branch_name=add_form.branch&field_branch_id=add_form.branch_id&field_our_company=add_form.our_company&field_our_company_id=add_form.our_company_id</cfoutput>','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_staff">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="55441.Kadro"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-4 col-xs-6"><label><input type="checkbox" name="is_staff" value="1"> <cf_get_lang dictionary_id="38671.Kadrolu"></label></div>
                                <div class="col col-4 col-xs-6"><label><input type="checkbox" name="is_outsource" value="1"><cf_get_lang dictionary_id="30439.Dış Kaynak"></label></div>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_fulltime">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53415.Çalışma Saatleri"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-4 col-xs-4"><label><input type="checkbox" name="is_fulltime" value="1"><cf_get_lang dictionary_id="38669.Tam zamanlı"></label></div>
                                <div class="col col-4 col-xs-4"><label><input type="checkbox" name="is_halftime" value="1"><cf_get_lang dictionary_id="38668.Yarı Zamanlı"></label></div>
                                <div class="col col-4 col-xs-4"><label><input type="checkbox" name="is_shift" value="1"><cf_get_lang dictionary_id="58545.Vardiyalı"></label></div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="2">
                        <div class="form-group" id="item-position_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> </label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="position_cat_id" id="position_cat_id" value="">
                                    <cfinput type="text" name="position_cat" id="position_cat" style="width:150px;" value="" message="">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats&field_cat_id=add_form.position_cat_id&field_cat=add_form.position_cat','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-position_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="demand_position_id" id="demand_position_id" value="">
                                    <input type="text" name="demand_position_name" id="demand_position_name" value="" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=add_form.demand_position_id&field_pos_name=add_form.demand_position_name&show_empty_pos=1','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-personel_count">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55283.Talep Edilen Kisi Sayisi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='56221.Kadro Sayisini Rakam Olarak Giriniz'>!</cfsavecontent>
                                <cfinput type="text" name="personel_count" id="personel_count" value="1" style="width:150px;" validate="integer" required="yes" range="1,99" message="#message#" maxlength="2" onKeyUp="ısNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-requirement_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31023.Talep Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="31023.Talep Tarihi">!</cfsavecontent>
                                    <cfinput type="text" name="requirement_date" id="requirement_date" style="width:65px;" validate="#validate_style#" message="#message#" value="#dateformat(now(),dateformat_style)#" required="yes">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="requirement_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-requirement_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56219.Istekte Bulunan'></label>
                            <div class="col col-8 col-xs-12">
                                    <input type="hidden" name="requirement_pos_code" id="requirement_pos_code" value="<cfoutput>#session.ep.position_code#</cfoutput>">
                                    <input type="hidden" name="requirement_member_id" id="requirement_member_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                    <input type="hidden" name="requirement_partner_id" id="requirement_partner_id" value="">
                                    <input type="hidden" name="requirement_consumer_id" id="requirement_consumer_id" value="">
                                    <input type="hidden" name="requirement_member_type" id="requirement_member_type" value="employee">
                                <cfif fusebox.circuit neq 'myhome'>
                                    <div class="input-group">
                                        <cfinput type="text" name="requirement_name" id="requirement_name" value="#get_emp_info(session.ep.userid,0,0)#" readonly>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1,2,3&field_code=add_form.requirement_pos_code&field_name=add_form.requirement_name&field_type=add_form.requirement_member_type&field_emp_id=add_form.requirement_member_id&field_partner=add_form.requirement_partner_id&field_consumer=add_form.requirement_consumer_id','list');"></span>
                                    </div>
                                <cfelse>
                                    <cfinput type="text" name="requirement_name" id="requirement_name" value="#get_emp_info(session.ep.userid,0,0)#" readonly>
                                </cfif>
                            </div>
                        </div>
                        <cfif x_related_forms eq 1>
                            <div class="form-group" id="item-related_forms">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55119.Ölçme Degerlendirme Formu'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfquery name="get_emp_quizes" datasource="#dsn#">
                                        SELECT QUIZ_ID,QUIZ_HEAD FROM EMPLOYEE_QUIZ WHERE IS_SHOW = 1
                                    </cfquery>
                                    <select name="related_forms" id="related_forms" multiple>
                                        <cfoutput query="get_emp_quizes">
                                            <option value="#quiz_id#">#QUIZ_HEAD#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </cfif>
                    </div>
                </div>

            <div class="col col-12 col-md-12 col-xs-12">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="55297.Talep Edilen Kişi Özellikleri"></cfsavecontent>
                <cf_seperator id="talep_edilen_kisi_ozellikleri" title="#message#">
                <div id="talep_edilen_kisi_ozellikleri">
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="3">
                        <cfif x_show_sex_info eq 1>
                            <div class="form-group" id="item-sex">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-6 col-xs-6">
                                        <label><input type="radio" name="sex" id="sex" value="0" checked="checked" /><cf_get_lang dictionary_id='58958.Kadin'></label>
                                    </div>
                                    <div class="col col-6 col-xs-6">
                                        <label><input type="radio" name="sex" id="sex" value="1" /><cf_get_lang dictionary_id='58959.Erkek'></label>
                                    </div>
                
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-training_level">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55495.Egitim Durumu'></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput query="GET_EDU_LEVEL">
                                    <div class="col col-6 col-xs-6"><label><input type="radio" name="training_level" id="training_level" value="#GET_EDU_LEVEL.EDU_LEVEL_ID#" <cfif currentrow eq 1>checked</cfif>> #GET_EDU_LEVEL.EDUCATION_NAME#</label></div>
                                </cfoutput>
                            </div>
                        </div>
                        <cfif x_show_language_info eq 1>
                            <div class="form-group" id="item-language">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55218.Yabanci Dil Bilgisi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-6 col-xs-6">
                                        <label><input type="radio" name="language" id="language" value="1" onclick="lang_info();"><cf_get_lang dictionary_id='58564.Var'></label>
                                    </div>
                                    <div class="col col-6 col-xs-6">
                                        <label><input type="radio" name="language" id="language" value="0" onclick="lang_info();" checked><cf_get_lang dictionary_id='58546.Yok'></label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="language_info" style="display:none;">
                                <div class="col col-4 col-xs-12"><label class="hide"><cf_get_lang dictionary_id='55218.Yabanci Dil Bilgisi'><cf_get_lang dictionary_id="38752.Tablo"></label></div>
                                <div class="col col-8 col-xs-12">
                                    <table id="table_lang" class="workDevList" name="table_lang" cellpadding="1" cellspacing="0">
                                        <tr>
                                            <td><i><cf_get_lang dictionary_id='55216.Yabanci Dil'></i></td>
                                            <td><i><cf_get_lang dictionary_id='56192.Seviye'></i></td>
                                            <td>
                                                <a href="javascript://" onClick="add_row();"><i class="fa fa-plus" title="Ekle"></i></a>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-personal_age">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55308.Yas Araligi'></label>
                            <div class="col col-3 col-xs-4">
                                <select	name="personal_age_min" id="personal_age_min">
                                    <option value=""></option>
                                    <cfloop from="16" to="60" index="x">
                                        <cfoutput>
                                        <option value="#x#">#x#</option>
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                            <label><cf_get_lang dictionary_id ="30022.ile"></label>
                            <div class="col col-3 col-xs-4">
                                <select	name="personal_age_max" id="personal_age_max">
                                    <option value=""></option>
                                    <cfloop from="16" to="60" index="y">
                                        <cfoutput>
                                        <option value="#y#">#y#</option>
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                            <label><cf_get_lang dictionary_id='55215.Arasinda'></label>
                        </div>
                        <div class="form-group" id="item-personel_exp">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55309.Bu Alandaki Is Tecrübesi (Yil)'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="personel_exp" id="personel_exp" maxlength="200"  onKeyUp="isNumber(this)">
                            </div>
                        </div>
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55154.Ise Baslama Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58499.Göreve Baslama Tarihi Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="text" name="startdate" id="startdate" style="width:65px;" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="4">
                        <div class="form-group" id="item-driverlicence">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55334.Ehliyet'></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput query="get_driverlicence">
                                    <div class="col col-3 col-xs-4"><label><input type="checkbox" name="driver_licence_type" id="driver_licence_type" value="#LICENCECAT_ID#">#LICENCECAT#</label></div>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-vehicle_req">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55335.Araç Talebi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-6 col-xs-6"><label><input type="radio" value="1" name="vehicle_req" id="vehicle_req" onclick="arac_talebi();"><cf_get_lang_main no='1152.Var'> </label></div>
                                    <div class="col col-6 col-xs-6"><label><input type="radio" value="0" name="vehicle_req" id="vehicle_req" checked="checked" onclick="arac_talebi();"><cf_get_lang_main no='1134.Yok'></label></div>
                            </div>
                        </div>
                        <div class="form-group" id="arac_modeli" style="display:none;">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33567.Araç Modeli'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="vehicle_req_model" id="vehicle_req_model" maxlength="100">
                            </div>
                        </div>
                        <div class="form-group" id="item-personel_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55344.Diger Nitelikler'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla satir sayisi'></cfsavecontent>
                                <textarea name="personel_detail" id="personel_detail" message="<cfoutput>#message#</cfoutput>" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col col-12 col-md-12 col-xs-12">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="55370.İhtiyaç Gerekçeleri"></cfsavecontent>
                <cf_seperator id="ihtiyac_gercekleri" title="#message#">
                <div id="ihtiyac_gercekleri">
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="5">
                        <div class="form-group" id="item-form_type">
                            <div class="col col-12">
                                <label><input type="radio" name="form_type" id="form_type" value="2" onclick="gizleme_islemi();" checked><cf_get_lang dictionary_id='55436.Ek Kadro Süresiz'></label>
                                <label><input type="radio" name="form_type" id="form_type" value="6" onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55449.Ek Kadro Süreli'></label>
                                <label><input type="radio" name="form_type" id="form_type" value="1" onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55433.Ayrilan Kisinin Yerine'></label>
                                <label><input type="radio" name="form_type" id="form_type" value="4" onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55481.Nakil Olan Personelin Yerine'></label>
                                <label><input type="radio" name="form_type" id="form_type" value="3" onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55451.Pozisyon Degisikligi Yapan Personelin Yerine'></label>
                                <label><input type="radio" name="form_type" id="form_type" value="5" onclick="gizleme_islemi();"><cf_get_lang dictionary_id='55488.Emeklilik Nedeniyle Çikis / Giris Yapan Personelin Yerine'></label>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="6">
                        <div class="form-group" id="belirsiz_header">
                            <label  class="bold col col-4 col-xs-12"><cf_get_lang dictionary_id='55536.Belirli Süreli Çalisan ise'></label>
                        </div>
                        <div class="form-group" id="belirsiz_1">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55538.Çalisma Baslangiç'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55554.Çalisma Baslangiç Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="work_start" id="work_start" style="width:65px;" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="work_start"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="belirsiz_2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55555.Çalisma Bitis'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55567.Çalisma Bitis Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="work_finish" id="work_finish" style="width:65px;" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="work_finish"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="ek_kadro" >
                            <div class="col col-8 col-xs-12">
                                <div class="col col-6 col-xs-6">
                                    <label><input type="checkbox" name="is_organization_change" value="1"/> <cf_get_lang dictionary_id="38665.Organizasyon Değişikliği"> </label>
                                </div>
                                <div class="col col-6 col-xs-6">
                                    <label><input type="checkbox" name="is_new_project" value="1"/> <cf_get_lang dictionary_id="38660.Yeni Projeler"></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-volume_of_business">
                            <label class="col col-4 col-xs-12"><input type="checkbox" name="is_volume_of_business" value="1"/><cf_get_lang dictionary_id="38661.İş hacmi artışı">%</label>
                            <div class="col col-4 col-sm-6 col-xs-12">
                                <input type="text" name="volume_business_min" value="" placeholder="<cf_get_lang dictionary_id='64228.den'>">
                            </div>
                            <div class="col col-4 col-sm-6 col-xs-12">
                                <input type="text" name="volume_business_max" value="" placeholder="<cf_get_lang dictionary_id='64229.e'>">
                            </div>
                        </div>
                        <div class="form-group" id="item-number_of_transactions">
                            <label class="col col-4 col-xs-12"><input type="checkbox" name="is_number_of_transactions" value="1"/> <cf_get_lang dictionary_id="38659.İşlem adedi artışı"> </label>
                            <div class="col col-4 col-sm-6 col-xs-12">
                                <input type="text" name="transaction_number_min" value="" placeholder="<cf_get_lang dictionary_id="38657.adetten">">
                            </div>
                            <div class="col col-4 col-sm-6 col-xs-12">
                                <input type="text" name="transaction_number_max" value="" placeholder="<cf_get_lang dictionary_id="38653.adete">">
                            </div>
                        </div>
                        <div class="form-group" id="item-additional_staff_detail">
                            <label class="col col-4 col-xs-12">
                                <cf_get_lang dictionary_id="36199.Açıklama">
                            </label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="additional_staff_detail" id="additional_staff_detail"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col col-12 col-md-12 col-xs-12">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="55489.İlgili Pozisyondaki Çalışan Bilgileri"></cfsavecontent>
                <cf_seperator id="ilgili_header_" title="#message#">
                <div id="ilgili_header_">
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="7">
                        <div class="form-group" id="item-old_personel_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55522.Ad Soyad / Görev'></label>
                            <div class="col col-4 col-xs-4">
                                <input type="text" name="old_personel_name" id="old_personel_name" maxlength="200" readonly>
                            </div>
                            <div class="col col-4 col-xs-4">
                                <div class="input-group">
                                    <input type="hidden" name="position_id" id="position_id" value="">
                                    <input type="hidden" name="personel_employee_id" id="personel_employee_id" value="">
                                    <input type="text" name="old_personel_position" id="old_personel_position" maxlength="200" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=add_form.old_personel_name&field_emp_id=add_form.personel_employee_id&field_code=add_form.position_id&field_pos_name=add_form.old_personel_position&show_empty_pos=1','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="ilgili_2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55332.Ayrilma Nedeni'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-4 col-xs-12"><label><input type="radio" value="Istifa" name="old_personel_detail" id="old_personel_detail" checked="checked" onclick="if(this.checked){gizle(personel_detail_other_info);}"><cf_get_lang dictionary_id='55508.Istifa'></label></div>
                                <div class="col col-4 col-xs-12"><label><input type="radio" value="Fesih" name="old_personel_detail" id="old_personel_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}"><cf_get_lang dictionary_id='55509.Fesih'></label></div>
                                <div class="col col-4 col-xs-12"><label><input type="radio" value="Nakil" name="old_personel_detail" id="old_personel_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}"><cf_get_lang dictionary_id='55510.Nakil'></label></div>
                                <div class="col col-4 col-xs-12"><label><input type="radio" value="Emeklilik" name="old_personel_detail" id="old_personel_detail" onclick="if(this.checked){gizle(personel_detail_other_info);}"><cf_get_lang dictionary_id='58541.Emeklilik'></label></div>
                                <div class="col col-4 col-xs-12"><label><input type="radio" value="Diger" name="old_personel_detail" id="old_personel_detail" onclick="if(this.checked){goster(personel_detail_other_info);}"><cf_get_lang dictionary_id='58156.Diger'></label></div>
                            </div>
                        </div>
                        <div class="form-group" id="personel_detail_other_info" style="display:none;">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55513.Diger ise Nedeni'></label>
                            <div class="col col-8 col-xs-12"><input type="text" name="old_personel_detail" id="old_personel_detail" value="" maxlength="75"></div>
                        </div>
                        <div class="form-group" id="ilgili_3">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55517.Isten Ayrilma Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55517.Isten Ayrilma Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="old_personel_finishdate" id="old_personel_finishdate" style="width:65px;" validate="#validate_style#" message="#message#" value="">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="old_personel_finishdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="nakil_header">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='55524.Nakil Olan Personelin'></label>
                        </div>
                        <div class="form-group" id="nakil_1">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55522.Ad Soyad / Görev'></label>
                                <div class="col col-4 col-xs-4">
                                    <input type="hidden" name="transfer_position_id" id="transfer_position_id" value="">
                                    <input type="text" name="transfer_personel_name" id="transfer_personel_name" maxlength="200" readonly>
                                </div>
                                <div class="col col-4 col-xs-4">
                                    <div class="input-group">
                                        <input type="text" name="transfer_personel_position" id="transfer_personel_position" maxlength="200" readonly>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=add_form.transfer_personel_name&field_code=add_form.transfer_position_id&field_pos_name=add_form.transfer_personel_position&show_empty_pos=1','list');"></span>
                                    </div>
                                </div>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="8">
                        <div class="form-group" id="nakil_2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55525.Yeni Subesi / Pozisyonu'></label>
                                <div class="col col-4 col-xs-4">
                                    <input type="hidden" name="transfer_personel_branch_new_id" id="transfer_personel_branch_new_id" value="">
                                    <input type="text" name="transfer_personel_branch_new" id="transfer_personel_branch_new" maxlength="200" readonly>
                                </div>
                                <div class="col col-4 col-xs-4">
                                    <div class="input-group">
                                        <input type="hidden" name="transfer_personel_position_new_id" id="transfer_personel_position_new_id" value="">
                                        <input type="text" name="transfer_personel_position_new"  id="transfer_personel_position_new" maxlength="200" readonly>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_form.transfer_personel_position_new_id&field_pos_name=add_form.transfer_personel_position_new&field_branch_name=add_form.transfer_personel_branch_new&field_branch_id=add_form.transfer_personel_branch_new_id&show_empty_pos=1','list');"></span>
                                    </div>
                                </div>
                        </div>
                        <div class="form-group" id="nakil_3">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55526.Nakil Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='441.Nakil Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="transfer_personel_startdate" id="transfer_personel_startdate" style="width:65px;" validate="#validate_style#" message="#message#" value="">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="transfer_personel_startdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="position_header">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='55519.Pozisyon Degisikligi Yapan Personelin'></label>
                        </div>
                        <div class="form-group" id="position_1">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55522.Ad Soyad / Görev'></label>
                            <div class="col col-4 col-xs-4">
                                <input type="text" name="change_personel_name" id="change_personel_name" maxlength="200" readonly>
                            </div>
                            <div class="col col-4 col-xs-4">
                                <div class="input-group">
                                    <input type="hidden" name="change_position_id" id="change_position_id" value="">
                                    <input type="text" name="change_personel_position" id="change_personel_position"  maxlength="200" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=add_form.change_personel_name&field_code=add_form.change_position_id&field_pos_name=add_form.change_personel_position&show_empty_pos=1','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="position_2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55523.Yeni Pozisyonu'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="change_personel_position_new_id" id="change_personel_position_new_id" value="">
                                    <input type="text" name="change_personel_position_new" id="change_personel_position_new" axlength="200" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats&field_cat_id=add_form.change_personel_position_new_id&field_cat=add_form.change_personel_position_new','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="position_3">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55839.Onay Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55839.Onay Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="change_personel_finishdate" id="change_personel_finishdate" style="width:65px;" validate="#validate_style#" message="#message#" value="">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="change_personel_finishdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-xs-12">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="55572.Diğer Bilgiler"></cfsavecontent>
                <cf_seperator id="diger_bilgiler" title="#message#">
                <div id="diger_bilgiler">
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="10">
                        <div class="form-group" id="item-is_foreign_lang_exam">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="38652.Yabancı Dil Sınavı"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-6 col-xs-6"><label><input type="radio" name="is_foreign_lang_exam" id="is_foreign_lang_exam" value="1"> <cf_get_lang dictionary_id="38651.Uygulansın"></label></div>
                                <div class="col col-6 col-xs-6"><label><input type="radio" name="is_foreign_lang_exam" id="is_foreign_lang_exam" value="0"> <cf_get_lang dictionary_id="38650.Uygulanmasın"></label></div>
                            </div>
                        </div>
                        <div class="form-group" id="item-min_salary">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56230.Vereilebilecek Min Brüt Ücret'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput name="min_salary" id="min_salary" validate="float" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                    <span class="input-group-addon width">
                                        <select	name="min_salary_money" id="min_salary_money">
                                            <cfoutput query="get_moneys">
                                                <option <cfif session.ep.money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
                                            </cfoutput>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-max_salary">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56231.Verilebilecek Max Brüt Ücret'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput name="max_salary" id="max_salary" validate="float" value="" style="width:150px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                    <span class="input-group-addon width">
                                        <select	name="max_salary_money"	id="max_salary_money">
                                            <cfoutput query="get_moneys">
                                                <option <cfif session.ep.money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
                                            </cfoutput>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <cfif x_show_language_info eq 0>
                            <div class="form-group" id="item-personel_lang">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56228.Lisan Bilgisi'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="personel_lang" id="personel_lang" style="width:456px;height:50px;" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="11">
                        <div class="form-group" id="item-requirement_reason">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayisi'></cfsavecontent>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56225.Kadro Talebinin Gerekçesi'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="requirement_reason" id="requirement_reason" style="width:456px;height:50px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-personel_ability">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56227.Özel Yetenekler'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="personel_ability" id="personel_ability" style="width:456px;height:50px;" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-personel_properties">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56229.Sosyal Fiziki Psikolojik Özellikler'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="personel_properties" id="personel_properties" style="width:456px;height:50px;" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-xs-12">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="55571.Görüş Ve Onay"></cfsavecontent>
                <cf_seperator id="gorus_ve_onaylar" title="#message#">
                <div id="gorus_ve_onaylar">
                    <div class="col col-6 col-xs-12" type="column" sort="true" index="9">
                        <div class="form-group" id="item-Gorus">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56016.Görüs'>*</label>
                            <div class="col col-8 col-xs-12"><textarea name="personel_other" id="personel_other" onKeyUp="CheckLen(this,500);"></textarea></div>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function CheckLen(Target,limit) 
{
    StrLen = Target.value.length;
    if (StrLen == 1 && Target.value.substring(0,1) == " ") 
        {
        Target.value = "";
        StrLen = 0;
        }
    if (StrLen > limit ) 
        {
        Target.value = Target.value.substring(0,limit);
        CharsLeft = 0;
        alert("<cf_get_lang dictionary_id ='58774.Maksimum açiklama uzunlugu'>" + ":" + limit);
        }
    else 
        {
        CharsLeft = StrLen;
        }
}

row_count=0;
function add_row()
{
    row_count++;
    var newRow;
    var newCell;

    newRow = document.getElementById('table_lang').insertRow();
    newRow.setAttribute("name","frm_row" + row_count);
    newRow.setAttribute("id","frm_row" + row_count);
    
    document.getElementById('record_num').value=row_count;
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><select name="language_id'+row_count+'" id="language_id'+row_count+'" style="width:150px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select>';
    
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<select name="knowlevel_id'+row_count+'" id="knowlevel_id'+row_count+'"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
    
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><i class="fa fa-minus" align="absmiddle" border="0" alt="Sil"></i></a>';							
}
function sil(sy)
{
    var my_element=eval("add_form.row_kontrol"+sy);
    my_element.value=0;
    var my_element=eval("frm_row"+sy);
    my_element.style.display="none";
}

function lang_info()
{
    if(document.add_form.language[0].checked)
        goster(language_info);
    else
        gizle(language_info);
}

function kontrol()
{
    if(!(document.add_form.form_type[0].checked == true || document.add_form.form_type[1].checked) == true)
    {
        document.add_form.is_organization_change.checked = false;
        document.add_form.is_volume_of_business.checked = false;
        document.add_form.volume_business_min.value = "";
        document.add_form.volume_business_max.value = "";
        document.add_form.is_new_project.checked = false;
        document.add_form.is_number_of_transactions.checked = false;
        document.add_form.transaction_number_min.value = "";
        document.add_form.transaction_number_max.value = "";
        document.add_form.additional_staff_detail.value = "";
    }			
    if(document.getElementById('personel_other').value=='')
    {
        alert("<cf_get_lang dictionary_id='55590.Görüş Girmelisiniz'>!");
        return false;
    }
    /*	Eski-Yeni	0-2		1-0		2-1		3-4		4-3		5-5		*/
    if(document.add_form.vehicle_req[0].checked && document.add_form.vehicle_req_model.value=='')
    {
        alert("<cf_get_lang dictionary_id='55581.Araç Modeli Girmelisiniz'>!");
        return false;
    }		
    if(document.add_form.form_type[2].checked || document.add_form.form_type[5].checked)
    {
        if(document.getElementById('old_personel_name').value=='')
            {
            alert("<cf_get_lang dictionary_id='55591.İlgili Pozisyon Çalışanını Giriniz'>!");
            return false;
        }
        if(document.getElementById('old_personel_position').value=='')
            {
            alert("<cf_get_lang dictionary_id='55592.İlgili Pozisyon Giriniz'>!");
            return false;
        }

        if(document.getElementById('old_personel_finishdate').value=='')
            {
            alert("<cf_get_lang dictionary_id='38649.İlgili Pozisyon Çıkış Tarihi Giriniz'>!");
            return false;
        }
    }
    if(document.add_form.form_type[4].checked)
    {
        if(document.getElementById('change_personel_name').value=='')
            {
            alert("<cf_get_lang dictionary_id='55591.İlgili Pozisyon Çalışanını Giriniz'>!");
            return false;
        }
        if(document.getElementById('change_personel_position').value=='')
            {
            alert("<cf_get_lang dictionary_id='55592.İlgili Pozisyon Giriniz'>!");
            return false;
        }
        if(document.getElementById('change_personel_finishdate').value=='')
            {
            alert("<cf_get_lang dictionary_id='38649.İlgili Pozisyon Çıkış Tarihi Giriniz'>!");
            return false;
        }
    }
    if(document.add_form.form_type[3].checked)
    {
        if(document.getElementById('transfer_personel_name').value=='')
            {
            alert("<cf_get_lang dictionary_id='55591.İlgili Pozisyon Çalışanını Giriniz'>!");
            return false;
        }
        if(document.getElementById('transfer_personel_position').value=='')
            {
            alert("<cf_get_lang dictionary_id='55592.İlgili Pozisyon Giriniz'>!");
            return false;
        }
        if(document.getElementById('transfer_personel_startdate').value=='')
            {
            alert("<cf_get_lang dictionary_id='38649.İlgili Pozisyon Çıkış Tarihi Giriniz'>!");
            return false;
        }
    }
    if(document.getElementById('personal_age_max').value != '' || document.getElementById('personal_age_min').value != ''){
        if(document.getElementById('personal_age_max').value <= document.getElementById('personal_age_min').value)
        {
            alert("<cf_get_lang dictionary_id='55118.Yas araligi düzgün girilmedi'>!");
            return false;
        }
    }
    if(process_cat_control())
    {
        if(add_form.min_salary != undefined) add_form.min_salary.value = filterNum(add_form.min_salary.value);
        if(add_form.max_salary != undefined) add_form.max_salary.value = filterNum(add_form.max_salary.value);
        return true;
    }
    else
        return false;
}

function arac_talebi()
{
    gizle(arac_modeli);
    if(document.add_form.vehicle_req[0].checked)
        goster(arac_modeli);
    else
        gizle(arac_modeli);
}

function gizleme_islemi()
{
    gizle(ilgili_header_);
    gizle(ilgili_2);
    gizle(ilgili_3);
    gizle(belirsiz_header);
    gizle(belirsiz_1);
    gizle(belirsiz_2);
    gizle(position_header);
    gizle(position_1);
    gizle(position_2);
    gizle(position_3);
    gizle(nakil_header);
    gizle(nakil_1);
    gizle(nakil_2);
    gizle(nakil_3);
    gizle(personel_detail_other_info);
    gizle(ek_kadro);
    goster(document.getElementById('item-old_personel_name'));
    /*
        form_type;
        1: Ayrilan Kisinin Yerine
        2: Ek Kadro Süresiz (Default)
        3: Pozisyon Degisikligi Yapan Personelin Yerine
        4: Nakil Olan Personelin Yerine
        5: Emeklilik Nedeniyle Çikis / Giris Yapan Personelin Yerine
        6: Ek Kadro Süreli
    */
    
    if(document.add_form.form_type[2].checked || document.add_form.form_type[5].checked) 
    {
        goster(ilgili_2);
        goster(ilgili_3);
        goster(nakil_3);
        if(document.add_form.old_personel_detail[4].checked)
            goster(personel_detail_other_info);
    }
    if(document.add_form.form_type[1].checked)
    {
        goster(belirsiz_header);
        goster(belirsiz_1);
        goster(belirsiz_2);
    }
    if(document.add_form.form_type[4].checked)
    {
        goster(position_header);
        goster(position_1);
        goster(position_2);
        goster(position_3);
        gizle(document.getElementById('item-old_personel_name'));
    }
    if(document.add_form.form_type[3].checked)
    {
        goster(nakil_header);
        goster(nakil_1);
        goster(nakil_2);
        goster(nakil_3);
        gizle(document.getElementById('item-old_personel_name'));
    }
    if(document.add_form.form_type[0].checked || document.add_form.form_type[1].checked)
    {
        goster(ek_kadro);
    }
}
gizleme_islemi();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin ust kisminda acilisi var --->
