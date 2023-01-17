<cfset attributes.employee_id = emp_id>
<cfinclude template="../query/get_im_cats.cfm">
<cfinclude template="../query/get_languages.cfm">
<cfinclude template="../query/get_hr_settings.cfm">
<cfinclude template="../query/get_in_out_other.cfm">
<cfset password_style = createObject('component','V16.hr.cfc.add_rapid_emp')><!--- Şifre standartları çekiliyor. --->
<cfset get_password_style = password_style.pass_control()>
<cfquery name="last_login" datasource="#DSN#" maxrows="1">
	SELECT IN_OUT_TIME,LOGIN_IP FROM WRK_LOGIN WHERE EMPLOYEE_ID = #attributes.employee_id# AND IN_OUT = 1 ORDER BY IN_OUT_TIME DESC
</cfquery>

<script type="text/javascript">
	function control()
	{	
		if ((document.getElementById('is_ip_control').checked == true) && (document.getElementById('is_address').value == ''))
		{
			alert("<cf_get_lang dictionary_id='56076.IP Adresi Girmelisiniz'>!");
			return false;
		}
		
		if ((document.getElementById('is_ip_control').checked == true) && (document.getElementById('computer_name').value == ''))
		{
			alert("<cf_get_lang dictionary_id='56077.Bilgisayar Adı Girmelisiniz'>!");
			return false;
		}
       
        var photo = document.getElementById('photo');
        if(photo.files.length > 0) var photoSize = photo.files[0].size;
        if(photoSize > 510200){
            alert("<cf_get_lang dictionary_id='48411.Fotoğrafınız maksimum 50KB boyutunda olmalıdır'>");
            return false;
        }
		var obj =  photo.value.toUpperCase();
		var obj_ = list_len(obj,'.');
		var uzanti_ = list_getat(obj,list_len(obj,'.'),'.');
		if(obj!='' && uzanti_!='GIF' && uzanti_!='PNG' && uzanti_!='JPG' && uzanti_!='JPEG') 
		{
			alert("<cf_get_lang dictionary_id='56078.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz'>!");        
			return false;
		}
		return true;
	}
</script>
<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_emp_std" enctype="multipart/form-data">
    <cfif isdefined("attributes.isAjax") and len(attributes.isAjax)>
        <input type="hidden" name="callAjax" id="callAjax" value="1">
    </cfif>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="49836.Çalışan Detay"></cfsavecontent>
    <cf_box title="#message#" closable="0">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-sex">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label>
                                <input type="radio" name="sex" id="sex" value="1" <cfif get_hr.sex eq 1 or not len(get_hr.sex)> checked</cfif>><cf_get_lang dictionary_id='58959.Erkek'>
                            </label>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label>
                                <input type="radio" name="sex" id="sex" value="0" <cfif get_hr.sex eq 0> checked</cfif>><cf_get_lang dictionary_id='58958.Kadın'>
                            </label>
                        </div>
                    </div>
                    <div class="form-group" id="item-tc_identy_no">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif isdefined('xml_tc_identy_no')><cfset maxlength_ = xml_tc_identy_no><cfelse><cfset maxlength_ = 11></cfif>
                            <cfinput type="text" name="tc_identy_no" id="tc_identy_no" maxlength="#maxlength_#" onKeyup="isNumber(this);" value="#get_hr.tc_identy_no#">
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'> *</label>
                        <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad '></cfsavecontent>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="employee_name" id="employee_name" maxlength="50" required="yes" onkeyup="isCharacter(this,1,45);" message="#message#" value="#get_hr.employee_name#">
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_surname">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
                        <cfsavecontent variable="message_"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput name="employee_surname" id="employee_surname" value="#get_hr.employee_surname#" type="text" maxlength="50" required="yes" onkeyup="isCharacter(this,0,45);" message="#message_#">
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_username">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="hidden" name="old_employee_username" value="<cfoutput>#get_hr.employee_username#</cfoutput>">
                            <cfif use_active_directory neq 0><div class="input-group"></cfif>
                            <cfif isdefined("use_active_directory") and use_active_directory neq 3>
                                <cfif session.ep.admin neq 1 and get_hr.employee_username contains 'admin'>
                                    <cfinput value="#get_hr.employee_username#" type="text" name="employee_username" id="employee_username" maxlength="20" readonly="yes">
                                <cfelse>
                                    <cfinput value="#get_hr.employee_username#" type="text" name="employee_username" id="employee_username" maxlength="20">
                                </cfif>
                            <cfelse>
                                <cfinput value="#get_hr.employee_username#" type="text" name="employee_username" id="employee_username" maxlength="20" readonly="yes">
                            </cfif>
                            <cfif use_active_directory neq 0>
                                <span class="input-group-addon"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_active_directory_names','list');"><i class="icon-ellipsis"></i></a></span></div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_password">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55439.Şifre (karakter duyarlı)	'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="hidden" name="old_employee_password" value="<cfoutput>#get_hr.employee_password#</cfoutput>">
                            <div class="input-group">
                            <cfif isdefined("use_active_directory") and use_active_directory neq 3>
                                <cfif session.ep.admin neq 1 and get_hr.employee_username contains 'admin'>
                                    <cfinput class="input-type-password"  value="" type="text" name="employee_password" id="employee_password" maxlength="16" readonly="yes" oncopy="return false" onpaste="return false" placeholder="#iIf(len(get_hr.employee_password),DE('&bull;&bull;&bull;&bull;'),DE(''))#">
                                <cfelse>
                                    <cfinput class="input-type-password"  value="" type="text" name="employee_password" id="employee_password" maxlength="16" oncopy="return false" onpaste="return false" placeholder="#iIf(len(get_hr.employee_password),DE('&bull;&bull;&bull;&bull;'),DE(''))#">
                                </cfif>
                            <cfelse>
                                <cfinput class="input-type-password" value="" type="text" name="employee_password" id="employee_password" maxlength="16" readonly="yes" oncopy="return false" onpaste="return false" placeholder="#iIf(len(get_hr.employee_password),DE('&bull;&bull;&bull;&bull;'),DE(''))#">
                            </cfif>
                            <span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password')"><i class="fa fa-eye"></i></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-reason_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id = '55550.Gerekçe'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_wrk_combo 
                                query_name="GET_FIRE_REASONS" 
                                name="reason_id" 
                                value="#get_hr.in_company_reason_id#"
                                option_value="reason_id" 
                                option_name="reason"
                                where="IS_ACTIVE=1">
                        </div>
                    </div>
                    <div class="form-group" id="item-HIERARCHY">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'> (<cf_get_lang dictionary_id='57761.Hiyerarşi'>)</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="HIERARCHY" id="HIERARCHY" maxlength="50" value="<cfoutput>#get_hr.hierarchy#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-ozel_kod_ilk">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'> 1</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="ozel_kod" id="ozel_kod" maxlength="50" value="<cfoutput>#get_hr.ozel_kod#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-ozel_kod">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'> 2</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="ozel_kod2" id="ozel_kod2" maxlength="50" value="<cfoutput>#get_hr.ozel_kod2#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-computer_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55112.Bilgisayar Adı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="computer_name" id="computer_name" value="#get_hr.computer_name#" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-ip_address">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55111.IP Kontrol'> / <cf_get_lang dictionary_id='55440.IP Adresi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="ip_address" id="ip_address" value="#get_hr.ip_address#" maxlength="25">
                                <span class="input-group-addon"><input type="checkbox" name="is_ip_control" id="is_ip_control" value="1" <cfif get_hr.is_ip_control eq 1> checked</cfif>></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-time_zone">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58880.Time Zone'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_wrkTimeZone selected="#get_hr.time_zone#">
                        </div>
                    </div>
                    <cfif fusebox.dynamic_hierarchy>
                        <div class="form-group" id="item-dynamic_hierarchy">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56318.Dinamik Hierarşi'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="text" name="dynamic_hierarchy" id="dynamic_hierarchy" value="<cfoutput>#get_hr.dynamic_hierarchy#</cfoutput>" readonly>
                            </div>
                            <div class="col col-4 col-sm-5">
                                <input type="text" name="dynamic_hierarchy_add" id="dynamic_hierarchy_add" value="<cfoutput>#get_hr.dynamic_hierarchy_add#</cfoutput>" readonly>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-photo">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55110.Fotoğraf'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="photo" id="photo">
                            <cfif isdefined("attributes.employee_id") and len(get_hr.photo)>
                                <label><input type="checkbox" name="del_photo" id="del_photo" value="1" onChange="photo.disabled = !(photo.disabled);">&nbsp;<cf_get_lang dictionary_id='55660.Fotoğrafı Sil'></label>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-add_info">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_wrk_add_info info_type_id="-4" info_id="#attributes.employee_id#" upd_page = "1" colspan="9">
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-employee_status">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'> / <cf_get_lang dictionary_id ='56335.Kritik Çalışan'></label>
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="checkbox" name="employee_status" id="employee_status" value="1" <cfif get_hr.employee_status eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                        </label>
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="checkbox" name="is_critical" id="is_critical" value="1" <cfif get_hr.is_critical eq 1>checked</cfif>> <cf_get_lang dictionary_id ='56335.Kritik Çalışan'>
                        </label>
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_hr.employee_stage#' is_detail='1'>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_no">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58487.Çalışan No'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="employee_no" id="employee_no" value="#get_hr.employee_no#" maxlength="50">
                        </div>
                    </div>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58484.Lütfen geçerli bir e-mail adresi giriniz"></cfsavecontent>
                    <div class="form-group" id="item-employee_email">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="employee_email" id="employee_email" maxlength="50" value="#get_hr.employee_email#" validate="email" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_email_spc">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'> (<cf_get_lang dictionary_id='29688.Kişisel'>)</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="employee_email_spc" id="employee_email_spc" maxlength="50" value="#get_hr.email_spc#" validate="email" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_kep_adress">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="employee_kep_adress" id="employee_kep_adress" maxlength="50" value="#get_hr.employee_kep_adress#" validate="email" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-tel_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63740.Dahili Telefon Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="tel_type" id="tel_type">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif get_hr.tel_type eq 1>selected</cfif>>Dec</option>
                                <option value="2" <cfif get_hr.tel_type eq 2>selected</cfif>>Web Phone</option>
                                <option value="3" <cfif get_hr.tel_type eq 3>selected</cfif>>Mobile</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-direct_tel">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55445.Direkt Tel'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55443.Direkt Tel girmelisiniz'></cfsavecontent>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfinput type="text" name="direct_telcode" id="direct_telcode" value="#get_hr.direct_telcode#" maxlength="5" validate="integer" message="#message#">
                        </div>
                        <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                            <cfinput type="text" name="direct_tel" id="direct_tel" value="#get_hr.direct_tel#" maxlength="9" validate="integer" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-dahili_tel">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55446.Dahili Tel'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55453.Dahili Tel girmelisiniz'></cfsavecontent>
                       <!---  <div class="col col-3 col-md-3 col-sm-3 col-xs-12"></div> --->
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput value="#get_hr.extension#" type="text" name="extension" id="extension" maxlength="5" validate="integer" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-corbus_tel">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55446.Dahili Tel'>2</label>
                      <!---   <div class="col col-3 col-md-3 col-sm-3 col-xs-12"></div> --->
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="corbus_tel" id="corbus_tel" maxlength="4" value="<cfoutput>#get_hr.corbus_tel#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-mobiltel">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'>1</label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Tel girmelisiniz'></cfsavecontent>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfinput value="#get_hr.mobilcode#" type="text" name="mobilcode" id="mobilcode" message="#message#" maxlength="7" validate="integer">
                        </div>
                        <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                            <cfinput value="#get_hr.mobiltel#" type="text" name="mobiltel" maxlength="10" validate="integer" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-mobiltel_spc">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'>2 (<cf_get_lang dictionary_id='29688.Kişisel'>)</label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58813.Cep Telefonu'>(<cf_get_lang dictionary_id='29688.Kişisel'>)</cfsavecontent>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfinput value="#get_hr.mobilcode_spc#" type="text" name="mobilcode_spc" id="mobilcode_spc" message="#message#" maxlength="7" validate="integer">
                        </div>
                        <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                            <cfinput value="#get_hr.mobiltel_spc#" type="text" name="mobiltel_spc" id="mobiltel_spc" maxlength="10" validate="integer" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-expiry_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55493.Sisteme Son Giriş'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="expiry_date" id="expiry_date" value="#dateformat(get_hr.expiry_date,dateformat_style)#" validate="#validate_style#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="expiry_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-group_start">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55738.Gruba Giriş'></label>
                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56699.Gruba giriş tarihi girmelisiniz'></cfsavecontent>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="group_start" id="group_start" value="#dateformat(get_hr.group_startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="group_start"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-kidem_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56336.Kıdem / İzin Baz Tarihi'></label>
                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56699.Gruba giriş tarihi girmelisiniz'></cfsavecontent>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="kidem_date" value="#dateformat(get_hr.kidem_date,dateformat_style)#" validate="#validate_style#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="kidem_date"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="izin_date" value="#dateformat(get_hr.izin_date,dateformat_style)#" validate="#validate_style#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="izin_date"></span>
                            </div>
                        </div>
                    </div>
                    <cfif xml_old_sgk_days eq 1>
                        <div class="form-group" id="item-old_sgk_days">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='54358.Old SGK Days'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="old_sgk_days" value="<cfoutput>#get_hr.old_sgk_days#</cfoutput>">
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-position">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div id="control_id">
                                <cfif get_position.recordcount>
                                    <cfoutput query="get_position">
                                        <a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#"><cfif xml_position_name eq 1>#position_name_#<cfelse>#position_name#</cfif></a>
                                    </cfoutput>
                                <cfelse>
                                    <cfoutput><a href="#request.self#?fuseaction=hr.list_positions&event=add&employee_id=#attributes.employee_id#"><cf_get_lang dictionary_id='55163.Pozisyon Ekle'><img src="/images/plus_square.gif" border="0" alt="Pozisyon Ekle"></a></cfoutput>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfoutput query="get_position">#department_head#</cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-upper_department">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='42335.Üst Departman'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfoutput query="get_position">#UPPER_DEPARTMENT_HEAD#</cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfoutput query="get_position">#branch_name#</cfoutput>
                        </div>
                    </div>
                    <cfif isdefined("xml_upper_code") and xml_upper_code eq 1>
                        <div class="form-group" id="item-branch">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='56110.birinci amir'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>#get_emp_info(get_position.upper_position_code,1,1)#</cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='38936.ikinci amir'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>#get_emp_info(get_position.upper_position_code2,1,1)#</cfoutput>
                            </div>
                        </div>
                    </cfif>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn">	
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_record_info query_name="get_hr"></div> 
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()&&kontrol()'></div> 
            </div>
    </cf_box>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
        <cfif isdefined('xml_is_tc_number') and xml_is_tc_number eq 1>
            var tc = $("#tc_identy_no").val();
            if(tc = "" || tc.length < 11){
                alert("<cf_get_lang dictionary_id='52469.TC Kimlik Numarası 11 Hane Olmalıdır'>");
                return false;
            }
        </cfif>
		control_ifade_ = $('#employee_password').val();
		var emp_no_ = document.getElementById('employee_no').value;
		var listParam = emp_no_ + "*" + "<cfoutput>#attributes.employee_id#</cfoutput>";
		var get_employee_no_query = wrk_safe_query("hr_get_employee_no_query",'dsn',0,listParam);
		if(get_employee_no_query.recordcount)
		{
			alert('<cf_get_lang dictionary_id="56835.Aynı Çalışan No İle Kayıt Var!"> <cf_get_lang dictionary_id="55971.Yeni Numara Atanacaktır!">');
			var run_query = wrk_safe_query('hr_emp_no','dsn');
			var run_query2 = wrk_safe_query('hr_emp_detail','dsn',0,run_query.EMPLOYEE_NO );
			var emp_num = parseFloat(run_query2.BIGGEST_NUMBER)+ 1;
			var emp_num_join = run_query.EMPLOYEE_NO + '-' +emp_num;
            $('#employee_no').val(emp_num_join);
		}
		if ($('#employee_password').val().indexOf(" ") != -1)
		{
			alert("<cf_get_lang dictionary_id='38682.Şifre boşluk karakterini içeremez.'>");
			$('#employee_password').focus();
			return false;
		}
		if(($('#employee_username').val() != "") && ($('#employee_password').val() != "") && ($('#employee_username').val() == $('#employee_password').val()))
		{
			alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz !'>");
			$('#employee_password').focus();
			return false;
		}
		if ($('#employee_password').val() != "")
		{
			<cfif get_password_style.recordcount>
				var number="0123456789";
				var lowercase = "abcdefghijklmnopqrstuvwxyz";
				var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
				
				var containsNumberCase = contains(control_ifade_,number);
				var containsLowerCase = contains(control_ifade_,lowercase);
				var containsUpperCase = contains(control_ifade_,uppercase);
				var ozl = contains(control_ifade_,ozel);
				
				<cfoutput>
					if(control_ifade_.length < #get_password_style.password_length#)
					{
						alert("<cf_get_lang dictionary_id='30949.Şifre Karakter Sayısı Az'>! <cf_get_lang dictionary_id='30951.Şifrede Olması Gereken Karakter Sayısı'> :#get_password_style.password_length#");
						document.getElementById('employee_password').focus();				
						return false;
					}
					
					if(#get_password_style.password_number_length# > containsNumberCase)
					{
						alert("<cf_get_lang dictionary_id = '30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
						document.getElementById('employee_password').focus();
						return false;
					}
					
					if(#get_password_style.password_lowercase_length# > containsLowerCase)
					{
						alert("<cf_get_lang dictionary_id = '30947.Şifrede Olması Gereken Küçük Harf Sayısı'> : #get_password_style.password_lowercase_length#");
						document.getElementById('employee_password').focus();				
						return false;
					}
					
					if(#get_password_style.password_uppercase_length# > containsUpperCase)
					{
						alert("<cf_get_lang dictionary_id = '30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
						document.getElementById('employee_password').focus();
						return false;
					}
					
					if(#get_password_style.password_special_length# > ozl)
					{
						alert("<cf_get_lang dictionary_id = '30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
						document.getElementById('employee_password').focus();
						return false;
					}
				</cfoutput>
			</cfif>
		}
		/*var imcat = document.getElementById('imcat_id').selectedIndex;
		if(document.employe_detail.imcat_id[imcat].value != "")
		{
			if(document.employe_detail.im.value.length == 0)
				{
					alert("<cf_get_lang_main no='13.uyarı'>: IMessege 1 Kategorisi seçilmiş fakat Instant Mesaj 1 adresi girilmemiş !");
					document.employe_detail.im.focus();
					return false;
				}
		}
		var imcat2 = document.employe_detail.imcat2_id.selectedIndex;
		if(document.employe_detail.imcat2_id[imcat2].value != "")
		{
			if(document.employe_detail.im2.value.length == 0)
				{
					alert("<cf_get_lang_main no='13.uyarı'>: IMessege 2 Kategorisi seçilmiş fakat Instant Mesaj 2 adresi girilmemiş !");
					document.employe_detail.im2.focus();
					return false;
				}
		}*/
		return process_cat_control();
	}
	employe_detail.employee_name.focus();
	
	function contains(deger,validChars)						
	{
		var sayac=0;				             
		for (i = 0; i < deger.length; i++)
		{
			var char = deger.charAt(i);
			if (validChars.indexOf(char) > -1)    
				sayac++;
		}
		return(sayac);				
    }
    function find_employee_f()
	{
		if($("#find_employee_number").val().length)
		{
			var get_employee = wrk_safe_query('sls_get_employee','dsn',0,$("#find_employee_number").val());
			if(get_employee.recordcount)
				window.location.href = '<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=</cfoutput>'+get_employee.EMPLOYEE_ID[0];
			else
			{
				alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!");
				return false;
			}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='41019.Employee No Eksik'>!");
			return false;
		}
	}
</script>