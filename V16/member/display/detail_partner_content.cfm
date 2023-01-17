<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfform name="upd_partner" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_partner&cpid=#get_partner.company_id#&partner_id=#attributes.pid#">
    <cfset GET_CITY = company_cmp.detail_partner_city(country:'#iIf(isdefined("get_partner.country") and len(get_partner.country),"get_partner.country",DE(""))#')>
    <cfset GET_COUNTY = company_cmp.detail_partner_county(city:'#iIf(isdefined("get_partner.city") and len(get_partner.city),"get_partner.city",DE(""))#')> 
    <cfset get_pdks_types = company_cmp.get_pdks_types()>
    <cfset get_district_name = company_cmp.detail_partner_district(county:get_partner.county)> 
    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_partner.company_id#</cfoutput>">
    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_partner.partner_id#</cfoutput>">
    <cf_box_elements>
        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group" id="item-partner_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30162.Online'></label>
                <div class="col col-8 col-xs-12">
                    <cf_online id="#get_partner.partner_id#" zone="pp">
                </div>
            </div>
            <div class="form-group" id="item-company_partner_name">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'> *</label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="company_partner_name" id="company_partner_name" value="#get_partner.company_partner_name#" maxlength="20" required="yes" style="width:150px;">
                </div>
            </div>
            <div class="form-group" id="item-company_partner_surname">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="company_partner_surname" id="company_partner_surname" value="#get_partner.company_partner_surname#" required="yes" maxlength="20" style="width:150px;">
                </div>
            </div>
            <div class="form-group" id="item-company_partner_username">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="company_partner_username" id="company_partner_username" value="#get_partner.company_partner_username#" maxlength="50" style="width:150px;">
                    <cfif Len(get_partner.country)>
                        <cfquery name="get_country_phone" dbtype="query">
                            SELECT COUNTRY_PHONE_CODE FROM GET_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner.country#">
                        </cfquery>  
                    </cfif>
                </div>
            </div>
            <div class="form-group" id="item-company_partner_password">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" name="company_partner_password" id="company_partner_password" autocomplete="new-password" class="input-type-password" value="" maxlength="16" onpaste="return false" oncopy="return false" placeholder="#iIf(len(get_partner.company_partner_password),DE('&bull;&bull;&bull;&bull;'),DE(''))#">
                        <span class="input-group-addon showPassword" onclick="showPasswordClass('company_partner_password')"><i class="fa fa-eye"></i></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-birthdate">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" name="birthdate" id="birthdate" maxlength="10" validate="#validate_style#" style="width:150px;" value="#DateFormat(get_partner.birthdate,dateformat_style)#" tabindex="5">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="birthdate"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-tc_identity">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'><cfif isDefined('is_tc_number') and is_tc_number eq 1> *</cfif></label>
                <div class="col col-8 col-xs-12">
                    <cfif isDefined('is_tc_number')>
                        <cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="#is_tc_number#" width_info='150' is_verify='1' consumer_name='company_partner_name' consumer_surname='company_partner_surname' birth_date='birthdate' tc_identity_number='#get_partner.TC_IDENTITY#'>
                    </cfif>
                </div>
            </div>
            <div class="form-group" id="item-title">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                <div class="col col-8 col-xs-12">
                    <input type="text" name="title" id="title" value="<cfoutput>#get_partner.title#</cfoutput>" maxlength="50" style="width:150px;">
                </div>
            </div>
            <div class="form-group" id="item-mission">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57573.Görev'>* <cfif isDefined('is_mission_required') and is_mission_required eq 1> *</cfif></label>
                <div class="col col-8 col-xs-12">
                    <select name="mission" id="mission" style="width:150px;">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_partner_positions">
                        <option value="#partner_position_id#" <cfif get_partner.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
                    </cfoutput>
                </select>
                </div>
            </div>
            <div class="form-group" id="item-department">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                <div class="col col-8 col-xs-12">
                    <select name="department" id="department" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_partner_departments">
                            <option value="#partner_department_id#" <cfif get_partner.department eq partner_department_id>selected</cfif>>#partner_department#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-compbranch_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                <div class="col col-8 col-xs-12">
                    <select name="compbranch_id" id="compbranch_id" style="width:150px;" onchange="kontrol_et(this.value);" >
                        <option value="0"><cf_get_lang dictionary_id='30319.Merkez Ofis'> 
                        <cfoutput query="get_branch">
                            <option value="#compbranch_id#"<cfif get_partner.compbranch_id eq compbranch_id> selected</cfif>>#compbranch__name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-language_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'> *</label>
                <div class="col col-8 col-xs-12">
                    <select name="language_id" id="language_id" style="width:150px;">
                        <cfoutput query="get_language">
                            <option value="#language_short#" <cfif get_partner.language_id eq language_short> selected</cfif>>#language_set#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-TimeZone">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30572.Saat Ayarı'></label>
                <div class="col col-8 col-xs-12">
                    <cf_wrkTimeZone width="150">
                </div>
            </div>
            <div class="form-group" id="item-photo">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30243.Fotoğraf'></label>
                <div class="col col-8 col-xs-12">
                    <input type="file" name="photo" id="photo">
                </div>
            </div>
            <div class="form-group" id="item-del_photo">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30274.Fotoğrafı Sil'></label>
                <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="del_photo" id="del_photo" value="1"><cf_get_lang dictionary_id='57495.Evet'>
                </div>
            </div>
            <div class="form-group" id="item-status_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                <div class="col col-8 col-xs-12">
                    <select name="status_id" id="status_id" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="GET_STATUS">
                            <option value="#cps_id#" <cfif get_partner.cp_status_id eq cps_id>selected</cfif>>#status_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-sex">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                <div class="col col-8 col-xs-12">
                    <select name="sex" id="sex" style="width:150px;">
                        <option value="1" <cfif get_partner.sex eq 1> selected</cfif>><cf_get_lang dictionary_id='58959.Erkek'>
                        <option value="2" <cfif get_partner.sex eq 2> selected</cfif>><cf_get_lang dictionary_id='58958.Kadın'>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-timeout_limit">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30573.Timeout Süresi'></label>
                <div class="col col-8 col-xs-12">
                    <select name="timeout_limit" id="timeout_limit" style="width:150px;">
                        <option value="15" <cfif get_partner_settings.timeout_limit is '15'> selected</cfif>>15 <cf_get_lang dictionary_id='58827.dk'>.</option>
                        <option value="30" <cfif get_partner_settings.timeout_limit is '30'> selected</cfif>>30 <cf_get_lang dictionary_id='58827.dk'>.</option>
                        <option value="45" <cfif get_partner_settings.timeout_limit is '45'> selected</cfif>>45 <cf_get_lang dictionary_id='58827.dk'>.</option>
                        <option value="60" <cfif get_partner_settings.timeout_limit is '60'> selected</cfif>>60 <cf_get_lang dictionary_id='58827.dk'>.</option>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-hier_partner_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30732.Bağlı Çalışan'></label>
                <div class="col col-8 col-xs-12">
                    <select name="hier_partner_id" id="hier_partner_id" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_hier_partner">
                            <option value="#partner_id#"<cfif get_partner.hierarchy_partner_id eq partner_id>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
                        </cfoutput>
                        <cfset get_control = company_cmp.get_control(
                            country:'#iIf(isdefined("get_partner.country") and len(get_partner.country),"get_partner.country",DE(""))#',     
                            pid:'#iIf(isdefined("url.pid") and len(url.pid),"url.pid",DE(""))#'
                            )>
                        <cfset hier_partner_id_list = ValueList(get_control.partner_id,',')>
                        <cfinput name="hierarchy_part_id" id="hierarchy_part_id" type="hidden" value="#hier_partner_id_list#">
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-pdks_type_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29489.Pdks tipi'></label>
                <div class="col col-8 col-xs-12">
                    <select name="pdks_type_id" id="pdks_type_id" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_pdks_types">
                            <option value="#PDKS_TYPE_ID#" <cfif get_partner.PDKS_TYPE_ID eq PDKS_TYPE_ID>selected</cfif>>#PDKS_TYPE#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-pdks_number">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29488.Pdks numarası'></label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="pdks_number" id="pdks_number" maxlength="8" value="#get_partner.pdks_number#" style="width:150px;" />
                </div>
            </div>
            <div class="form-group" id="item-extra_note">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                <div class="col col-8 col-xs-12">
                    <cf_wrk_add_info info_type_id="-3" info_id="#attributes.pid#" upd_page = "1" colspan="9">
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-company_partner_status">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="company_partner_status" id="company_partner_status" <cfif get_partner.company_partner_status eq 1>checked</cfif> style="margin-left:-4px;">
                </div>
            </div>
            <div class="form-group" id="item-imcat_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30340.Instant Message'></label>
                <div class="col col-4 col-xs-12">
                    <select name="imcat_id" id="imcat_id" style="width:55px;">
                        <option value=''><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_im">
                            <option value="#imcat_id#" <cfif imcat_id is get_partner.imcat_id>selected</cfif>>#imcat#</option> 
                        </cfoutput>
                    </select>
                </div>
                <div class="col col-4 col-xs-12">
                    <input type="text" name="im" id="im" value="<cfoutput>#get_partner.im#</cfoutput>" maxlength="50" style="width:92px;">
                </div>
            </div>
            <div class="form-group" id="item-imcat2_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30340.Instant Mesaj'> 2</label>
                <div class="col col-4 col-xs-12">
                    <select name="imcat2_id" id="imcat2_id" style="width:55px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="GET_IM">
                            <option value="#imcat_id#" <cfif get_partner.imcat2_id eq imcat_id>selected</cfif>>#imcat#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="col col-4 col-xs-12">
                    <cfinput type="text" name="im2" id="im2" maxlength="50" value="#get_partner.im2#" style="width:92px;">
                </div>
            </div>
            <div class="form-group" id="item-company_partner_telcode">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> <label id="load_phone"><cfif Len(get_partner.country) and len(get_country_phone.country_phone_code)>(<cfoutput>#get_country_phone.country_phone_code#</cfoutput>)</cfif></label></label>
                <div class="col col-4 col-xs-12">
                    <cfinput type="text" name="company_partner_telcode" id="company_partner_telcode" value="#get_partner.company_partner_telcode#" onkeyup="isNumber(this)"  maxlength="5" >
                </div>
                <div class="col col-4 col-xs-12">
                    <cfinput type="text" name="company_partner_tel" id="company_partner_tel" value="#get_partner.company_partner_tel#" onkeyup="isNumber(this)"  maxlength="10" >
                </div>
            </div>
            <div class="form-group" id="item-company_partner_tel_ext">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30259.Dahili'><cf_get_lang dictionary_id='57499.Telefon'></label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="company_partner_tel_ext" id="company_partner_tel_ext" value="#get_partner.company_partner_tel_ext#" onkeyup="isNumber(this)" maxlength="5">
                </div>
            </div>
            <div class="form-group" id="item-company_partner_fax">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="company_partner_fax" id="company_partner_fax" value="#get_partner.company_partner_fax#" onkeyup="isNumber(this)" maxlength="10">
                </div>
            </div>
            <div class="form-group" id="item-mobilcat_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30151.Mobil Kod'></label>
                <div class="col col-4 col-xs-12">
                    <cfinput type="text" name="mobilcat_id" id="mobilcat_id" value="#get_partner.mobil_code#" onkeyup="isNumber(this)" validate="integer" maxlength="7">
                </div>
                <div class="col col-4 col-xs-12">
                    <cfinput type="text" name="mobiltel" id="mobiltel" value="#get_partner.mobiltel#" onkeyup="isNumber(this)" validate="integer" maxlength="10">
                </div>
            </div>
            <div class="form-group" id="item-company_partner_email">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.e-mail'></label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="company_partner_email" id="company_partner_email" value="#get_partner.company_partner_email#" maxlength="100" validate="email">
                </div>
            </div>
            <div class="form-group" id="item-kep_adress">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59876.kep adresi'></label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="partner_kep_adress" id="partner_kep_adress" maxlength="100" value="#get_partner.PARTNER_KEP_ADRESS#" validate="email"> 
                </div>
            </div>
            <div class="form-group" id="item-homepage">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30179.İnternet'></label>
                <div class="col col-8 col-xs-12">
                    <input type="text" maxlength="50" name="homepage" id="homepage" value="<cfoutput>#get_partner.homepage#</cfoutput>" style="width:150px;">
                </div>
            </div>
            <div class="form-group" id="item-company_partner_address">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                <div class="col col-8 col-xs-12">
                    <input type="hidden" name="counter" id="counter">
                    <textarea name="company_partner_address" id="company_partner_address" style="width:150px;"><cfoutput>#get_partner.company_partner_address#</cfoutput></textarea>
                </div>
            </div>
            <div class="form-group" id="item-country">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                <div class="col col-8 col-xs-12">
                    <select name="country" id="country" style="width:150px;" onchange="LoadCity(this.value,'city_id','county_id',0);LoadPhone(this.value);">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_country">
                        <option value="#country_id#" <cfif get_partner.country eq country_id>selected</cfif>>#country_name#</option>
                    </cfoutput>
                </select>
                </div>
            </div>
            <div class="form-group" id="item-city_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                <div class="col col-8 col-xs-12">
                    <select name="city_id" id="city_id" style="width:150px;" onchange="LoadCounty(this.value,'county_id','company_partner_telcode')">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="GET_CITY">
                            <option value="#city_id#" <cfif get_partner.city eq city_id>selected</cfif>>#city_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
           <div class="form-group" id="item-county_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.ilçe'></label>
                <div class="col col-8 col-xs-12">
                    <select name="county_id" id="county_id" style="width:150px;" onChange="LoadDistrict(this.value,'district_id');">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <!--- Onchange fonksiyonu ile yüklendiği ve hataya düşürdüğü için kapatıldı. --->
                        <!--- <cfoutput query="get_county">
                            <option value="#county_id#" <cfif get_partner.county eq county_id>selected</cfif>>#county_name#</option>
                        </cfoutput> --->
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-district_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                <div class="col col-8 col-xs-12">
                    <select name="district_id" id="district_id" style="width:150px;" onchange="get_ims_code();">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfif len(get_partner.county)>									
                            <cfloop query="get_district_name">
                                <cfoutput><option value="#district_id#" <cfif get_partner.district_id eq district_id>selected</cfif>>#district_name#</option></cfoutput>
                            </cfloop>
                        </cfif>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-semt">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="semt" id="semt" value="#get_partner.semt#" maxlength="45" style="width:150px;">
                </div>
            </div>
            <div class="form-group" id="item-company_partner_postcode">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                <div class="col col-8 col-xs-12">
                    <input type="text" name="company_partner_postcode" id="company_partner_postcode" value="<cfoutput>#get_partner.company_partner_postcode#</cfoutput>" maxlength="15" style="width:150px;">
                </div>
            </div>
            <div class="form-group" id="item-start_date">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" name="start_date" id="start_date" style="width:65px;" value="#dateformat(get_partner.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-finish_date">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" name="finish_date" id="finish_date" style="width:65px;" value="#dateformat(get_partner.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
            </div>
			<div class="form-group" id="item-resource">
				<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
				<div class="col col-8 col-sm-12">
					<cf_wrk_combo 
						name="resource"
						query_name="GET_PARTNER_RESOURCE"
						value="#get_partner.resource_id#"
						option_name="resource"
						option_value="resource_id"
						width="150">
				</div>                
			</div>
            <div class="form-group" id="item-not_want_email">
                <label class="col col-4 col-xs-12" for="not_want_email"><cf_get_lang dictionary_id='30742.Mail Almak İstemiyorum'></label>
                <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="not_want_email" id="not_want_email" value="0" <cfif get_partner.want_email eq 0> checked</cfif>>
                </div>
            </div>
            <div class="form-group" id="item-not_want_sms">
                <label class="col col-4 col-xs-12" for="not_want_sms"><cf_get_lang dictionary_id='30741.SMS Almak İstemiyorum'></label>
                <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="not_want_sms" id="not_want_sms" value="0" <cfif get_partner.want_sms eq 0> checked</cfif>>
                </div>
            </div>
			<div class="form-group" id="item-not_want_call">
                <label class="col col-4 col-xs-12" for="not_want_call">Sesli Arama Almak İstemiyorum</label>
                <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="not_want_call" id="not_want_call" value="0" <cfif get_partner.want_call eq 0> checked</cfif>>
                </div>
            </div>
            <cfif isDefined('is_finance_mail') and is_finance_mail eq 1>
            <div class="form-group" id="item-send_finance_mail">
                <label class="col col-4 col-xs-12" for="send_finance_mail"><cf_get_lang dictionary_id='30734.Finans Mailleri Gönderilsin'></label>
                <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="send_finance_mail" id="send_finance_mail" value="1" <cfif get_partner.is_send_finance_mail eq 1>checked</cfif>>
                </div>
            </div>
            </cfif>
            <div class="form-group" id="item-send_earchive_mail">
                <label class="col col-4 col-xs-12" for="send_earchive_mail"><cf_get_lang dictionary_id='60086.E-Arşiv Mailleri Gönderilsin'></label>
                <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="send_earchive_mail" id="send_earchive_mail" value="1" <cfif get_partner.IS_SEND_EARCHIVE_MAIL eq 1>checked</cfif>>
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <div class="col col-6 col-xs-12">
            <cf_record_info query_name="get_partner" record_emp="record_member" update_emp="update_member" is_partner='1'>
        </div>
        <div class="col col-6 col-xs-12">
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
        </div>
    </cf_box_footer>
</cfform>