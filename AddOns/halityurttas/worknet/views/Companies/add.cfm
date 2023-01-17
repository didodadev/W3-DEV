<cfinclude template="../../config.cfm">
<cf_xml_page_edit fuseact="member.form_add_company" is_multi_page="1">
    <cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
    <cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.Companies.member") />
    <!---<cfset getMobilcat = cmp.getMobilcat() />--->
    <cfset getCountry = cmp.getCountry() />
    <cfset getPartnerPositions = cmp.getPartnerPositions() />
    <cfset getPartnerDepartments = cmp.getPartnerDepartments() />
    
    <cfset pageHead="Kurumsal Üye Ekle">
    <cf_catalystHeader>
    
    <div class="row">
        <div class="col col-12 uniqueRow" id="content">
    
            <cfform name="form_add_company" method="post" enctype="multipart/form-data">
    
                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cf_get_lang_main no='162.Şirket'></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="1" sort="true">
                                        <div class="form-group" id="item-is_status">
                                            <label>
                                                <input type="checkbox" name="is_status" id="is_status" value="1"><cf_get_lang_main no='81.Aktif'>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="2" sort="true">
                                        <div class="form-group" id="item-is_potential">
                                            <label>
                                                <input type="checkbox" name="is_potential" id="is_potential" value="1"><cf_get_lang_main no='165.Potansiyel'>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="3" sort="true">
                                        <div class="form-group" id="item-is_related_company">
                                            <input type="checkbox" name="is_related_company" id="is_related_company" value="1"><cf_get_lang no='421.Bağlı Üye'>
                                        </div>
                                    </div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="4" sort="true">
                                        <div class="form-group" id="item-is_homepage">
                                            <input type="checkbox" name="is_homepage" id="is_homepage" value="1"><cf_get_lang no="182.Anasayfa">	
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-12 uniqueRow">
                                        <div class="row formContent">
                                            <div class="row" type="row">
                                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                                                    <div class="form-group" id="item-fullname">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='159.Unvan'>*</label>
                                                        <div class="col col-8 col-xs-12">
                                                            <input type="text" name="fullname" id="fullname" value="" maxlength="250" style="width:455px;">
                                                        </div>
                                                    </div>
                                                    <div class="form-group" id="item-process_cat">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç">*</label>
                                                        <div class="col col-8 col-xs-12">
                                                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                                                        </div>
                                                    </div>
                                                    <div class="form-group" id="item-sector_cat">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='167.Sektör'></label>
                                                        <div class="col col-8 col-xs-12">
                                                            <cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
                                                                <cf_wrk_selectlang 
                                                                    name="company_sector"
                                                                    option_name="sector_cat"
                                                                    option_value="sector_cat_id"
                                                                    width="150"
                                                                    table_name="SETUP_SECTOR_CATS"
                                                                    option_text="#text#">
                                                        </div>
                                                    </div>
                                                    
                                                </div>
                                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
                                                    <div class="form-group" id="item-nickname">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='339.Kisa Ad'>*</label>
                                                        <div class="col col-8 col-xs-12">
                                                            <input type="text" name="nickname" id="nickname" value="" maxlength="150" style="width:150px;">
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="form-group" id="item-firm_type">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang no="8.Firma Tipi"></label>
                                                        <div class="col col-8 col-xs-12">
                                                            <cf_multiselect_check 
                                                                table_name="SETUP_FIRM_TYPE"  
                                                                name="firm_type"
                                                                width="150" 
                                                                option_name="firm_type" 
                                                                option_value="firm_type_id">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="7" sort="true">
                                                    <div class="form-group" id="item-companycat_id">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='74.Kategori'>*</label>
                                                        <div class="col col-8 col-xs-12">
                                                            <cfsavecontent variable="text"><cf_get_lang_main no='322.Seciniz'></cfsavecontent>
                                                                <cf_wrk_MemberCat
                                                                    name="companycat_id"
                                                                    option_text="#text#"
                                                                    comp_cons=1>
                                                        </div>
                                                    </div>
                                                    <div class="form-group" id="item-taxoffice">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1350.Vergi Dairesi'></label>
                                                        <div class="col col-8 col-xs-12">
                                                            <input type="text" name="taxoffice" id="taxoffice" maxlength="30" value="" style="width:150px;">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="8" sort="true">
                                                    <div class="form-group" id="item-sort">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no="1512.Sıralama"></label>
                                                        <div class="col col-8 col-xs-12">
                                                            <input type="text" name="sort" id="sort" value="" style="width:30px;" maxlength="2" onKeyup="isNumber(this);" onblur="isNumber(this);"/>
                                                        </div>
                                                    </div>
                                                    <div class="form-group" id="item-taxno">
                                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='340.Vergi No'></label>
                                                        <div class="col col-8 col-xs-12">
                                                            <input type="text" name="taxno" id="taxno" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="" maxlength="12" style="width:150px;">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" type="row">
                                                <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="9" sort="true">
                                                    <div class="form-group" id="item-product_category">
                                                        <label class="col col-2 col-xs-12"><cf_get_lang_main no='155.Ürün Kategorileri'></label>
                                                        <div class="col col-10 col-xs-12">
                                                            <select name="product_category" id="product_category" style="width:430px; height:80px;" multiple></select>
                                                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.form_upd_company.product_category','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
                                                            <a href="javascript://" onClick="remove_field('product_category');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Sil'>"></a>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="10" sort="true">							
                                                    <div class="form-group">
                                                        <label class="col col-2 col-xs-12">Ek Bilgi</label>
                                                        <div class="col col-10 col-xs-12">
                                                            <cf_wrk_add_info info_type_id="-1" upd_page = "0" colspan="9">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cf_get_lang no='265.Adres ve Iletisim'></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="11" sort="true">
                                        <div class="form-group" id="item-country">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='807.Ulke'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="country" id="country" style="width:155px;" onChange="LoadCity(this.value,'city_id','county_id',0);">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="getCountry">
                                                        <option value="#country_id#">#country_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-company_postcode">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="company_postcode" id="company_postcode" style="width:150px;" maxlength="10" value="">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-company_tel1">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no='36.Kod/Telefon'>*</label>
                                            <div class="col col-3">
                                                <input maxlength="5" type="text" name="company_telcode" id="company_telcode" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="" style="width:50px;">
                                            </div>
                                            <div class="col col-5">
                                                <input maxlength="10" type="text" name="company_tel1" id="company_tel1" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="" style="width:85px;">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-ASSET2">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no='428.Kroki'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="FILE" style="width:150px;" name="ASSET2" id="ASSET2">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="12" sort="true">
                                        <div class="form-group" id="item-city_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='559.Sehir'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="city_id" id="city_id" style="width:155px;" onChange="LoadCounty(this.value,'county_id','company_telcode')">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-email">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='16.e-mail'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
                                                    <cfinput type="text" name="email" id="email" validate="email" message="#message#" maxlength="100" style="width:150px;" value="">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-company_tel2">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 2</label>
                                            <div class="col col-8 col-xs-12">
                                                <input validate="integer" maxlength="10" type="text" name="company_tel2" id="company_tel2" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="" style="width:90px;">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-coordinate_1">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1137.Koordinatlar'></label>
                                            <div class="col col-4">
                                                <div class="input-group">
                                                    <div class="input-group-addon">
                                                        <cf_get_lang_main no='1141.E'>
                                                    </div>
                                                    <cfinput type="text" maxlength="10" range="-90,90" tabindex="35" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="" name="coordinate_1" id="coordinate_1" style="width:56px;"> 
                                                </div>
                                            </div>
                                            <div class="col col-4">
                                                <div class="input-group">
                                                    <div class="input-group-addon">
                                                        <cf_get_lang_main no='1179.B'>
                                                    </div>
                                                    <cfinput type="text" maxlength="10" range="-180,180" tabindex="36" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="" name="coordinate_2" id="coordinate_2" style="width:56px;">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="12" sort="true">
                                        <div class="form-group" id="item-county_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1226.Ilce'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="county_id" id="county_id" style="width:155px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-homepage">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no='41.Internet'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="homepage" id="homepage" style="width:150px;" maxlength="50" value="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'>3</label>
                                            <div class="col col-8 col-xs-12">
                                                <input maxlength="10" type="text" name="company_tel3" id="company_tel3" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="" style="width:90px;">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="13" sort="true">
                                        <div class="form-group" id="item-semt">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='720.Semt'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="semt" id="semt" value="" maxlength="30" style="width:150px;">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-mobiltel">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no='116.Kod / Mobil'></label>
                                            <div class="col col-3">
                                                <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:50px;">
                                            </div>
                                            <div class="col col-5">
                                                <cfinput type="text" name="mobiltel" id="mobiltel" maxlength="10" onKeyup="isNumber(this);" onblur="isNumber(this);" style="width:85px;" value="">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-company_fax">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Fax'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="company_fax" id="company_fax" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" maxlength="10" style="width:90px;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-6 col-xs-12" type="column" index="14" sort="true">
                                        <div class="form-group">
                                            <label class="col col-2 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
                                            <div class="col col-10 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang no ='611.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
                                                <textarea name="company_address" id="company_address" style="width:150px; height:65px;" message="<cfoutput>#message#</cfoutput>" maxlength="200" onKeyUp="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cf_get_lang_main no='166.Yetkili'></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="15" sort="true">
                                        <div class="form-group" id="item-name">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='219.Ad'>*</label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="name" id="name" value="<cfif isdefined("attributes.name")><cfoutput>#attributes.name#</cfoutput></cfif>" maxlength="50" style="width:150px;"><input type="hidden">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-company_partner_email">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='16.e-mail'> *</label>
                                            <div class="col col-8 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
                                                <cfinput type="text" name="company_partner_email" id="company_partner_email" validate="email" message="#message#" maxlength="100" style="width:150px;">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-mobiltel_partner">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no='116.Kod /Mobil Tel'></label>
                                            <div class="col col-3">
                                                <input maxlength="5" type="text" name="mobilcat_id_partner" id="mobilcat_id_partner" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:55px;">									
                                            </div>
                                            <div class="col col-5">
                                                <input maxlength="10" type="text" name="mobiltel_partner" id="mobiltel_partner" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.mobiltel")><cfoutput>#attributes.mobiltel#</cfoutput></cfif>" style="width:85px;">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="16" sort="true">
                                        <div class="form-group" id="item-soyad">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1314.Soyad'>*</label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="soyad" id="soyad" value="<cfif isdefined("attributes.soyad")><cfoutput>#attributes.soyad#</cfoutput></cfif>" maxlength="50" style="width:150px;">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-password">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='140.Şifre'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="Password" name="password" id="password" style="width:145px;" maxlength="16">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-tel_local">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no='121.Dahili'><cf_get_lang_main no='87.Tel'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" onKeyup="isNumber(this);" onblur="isNumber(this);" name="tel_local" id="tel_local" maxlength="5" style="width:86px;">
                                            </div>
                                        </div>
                                        
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="17" sort="true">
                                        <div class="form-group" id="item-tc_identity">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='613.TC Kimlik No'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="0" width_info='145' is_verify='0' consumer_name='name' consumer_surname='soyad' birth_date='birthdate'>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-department">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="department" id="department" style="width:150px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="getPartnerDepartments">
                                                        <option value="#partner_department_id#">#partner_department#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='352.Cinsiyet'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="sex" id="sex" style="width:150px;">
                                                    <option value="1"><cf_get_lang_main no='1547.Erkek'></option>
                                                    <option value="2"><cf_get_lang_main no='1546.Kadin'></option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="18" sort="true">
                                        <div class="form-group" id="item-title">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='159.Unvan'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input  type="text" name="title" id="title" style="width:150px;" maxlength="50">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-mission">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='161.Gorev'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="mission" id="mission" style="width:150px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="getPartnerPositions">
                                                        <option value="#partner_position_id#">#partner_position#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cf_get_lang no="11.Profil Bilgileri"></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="19" sort="true">
                                        <div class="form-group" id="item-organization_start_date">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no='119.Kuruluş Tarihi'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='119.Kuruluş Tarihi'>!</cfsavecontent>
                                                <div class="input-group">
                                                    <cfinput type="text" name="organization_start_date" id="organization_start_date" value="" validate="eurodate" message="#message#" style="width:65px;">
                                                    <div class="input-group-addon"><cf_wrk_date_image date_field="organization_start_date"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="21" sort="true">
                                        <div class="form-group" id="item-ASSET1">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1225.Logo'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="file" name="ASSET1" id="ASSET1" style="width:150px;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="22" sort="true">
                                        <div class="form-group">
                                            <div class="col col-12 col-xs-12">
                                                <img src="../documents/templates/worknet/tasarim/dil_icon_3.png" width="18" height="14" alt="TR" align="top" >
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="23" sort="true">
                                        <div class="form-group">
                                            <div class="col col-12 col-xs-12">
                                                <img src="../documents/templates/worknet/tasarim/dil_icon_1.png" width="18" height="14" alt="ENG" align="top" onclick="gizle_goster_detail('profile_eng')" >
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="24" sort="true">
                                        <div class="form-group">
                                            <div class="col col-12 col-xs-12">
                                                <img src="../documents/templates/worknet/tasarim/dil_icon_2.png" width="18" height="14" alt="SPA" align="top" onclick="gizle_goster_detail('profile_spa')" >
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="25" sort="true">
                                        <div class="form-group" id="item-company_detail">
                                            <label class="col col-2 col-xs-12"><cf_get_lang_main no="1708.Şirket Profili"></label>
                                            <div class="col col-10 col-xs-12">
                                                <textarea 
                                                    name="company_detail" id="company_detail" 
                                                    style="width:500px; height:120px;" maxlenght="1500"
                                                    onChange="counter(this.id,'detailLen');return ismaxlength(this);"
                                                    onkeydown="counter(this.id,'detailLen');return ismaxlength(this);" 
                                                    onkeyup="counter(this.id,'detailLen');return ismaxlength(this);" 
                                                    onBlur="return ismaxlength(this);"	
                                                    ></textarea>
                                                <input type="text" name="detailLen"  id="detailLen" size="1"  style="width:40px !important;" value="1500" readonly />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row" id="profile_eng" style="display: none;">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="26" sort="true">
                                        <div class="form-group" id="item-company_detail_eng">
                                            <label class="col col-2 col-xs-12"><cf_get_lang_main no="1708.Şirket Profili"> <img src="../documents/templates/worknet/tasarim/dil_icon_1.png" width="18" height="14" alt="ENG" align="top" ></label>
                                            <div class="col col-10 col-xs-12">
                                                <textarea 
                                                    name="company_detail_eng" id="company_detail_eng" 
                                                    style="width:500px; height:120px;" maxlenght="1500"
                                                    onChange="counter(this.id,'detailLen_eng');return ismaxlength(this);"
                                                    onkeydown="counter(this.id,'detailLen_eng');return ismaxlength(this);" 
                                                    onkeyup="counter(this.id,'detailLen_eng');return ismaxlength(this);" 
                                                    onBlur="return ismaxlength(this);"	
                                                    ></textarea>
                                                <input type="text" name="detailLen_eng"  id="detailLen_eng" size="1"  style="width:40px !important;" value="1500" readonly />
                                            </div>
                                        </div>
                                    </div>						
                                </div>
                                <div class="row" type="row" id="profile_spa" style="display: none;">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="27" sort="true">
                                        <div class="form-group">
                                            <label class="col col-2 col-xs-12"><cf_get_lang_main no="1708.Şirket Profili"><img src="../documents/templates/worknet/tasarim/dil_icon_2.png" width="18" height="14" alt="SPA" align="top" ></label>
                                            <div class="col col-10 col-xs-12">
                                                <textarea 
                                                    name="company_detail_spa" id="company_detail_spa" 
                                                    style="width:500px; height:120px;" maxlenght="1500"
                                                    onChange="counter(this.id,'detailLen_spa');return ismaxlength(this);"
                                                    onkeydown="counter(this.id,'detailLen_spa');return ismaxlength(this);" 
                                                    onkeyup="counter(this.id,'detailLen_spa');return ismaxlength(this);" 
                                                    onBlur="return ismaxlength(this);"	
                                                    ></textarea>
                                                <input type="text" name="detailLen_spa"  id="detailLen_spa" size="1"  style="width:40px !important;" value="1500" readonly />
                                            </div>
                                        </div>
                                    </div>						
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col col-12 uniqueRow">
                        <div class="row formContent">
                            <div class="row" type="row">
                                <div class="col col-12" type="column" index="28" sort="false">
                                    <div class="form-group">
                                        <div class="col col-12">
                                            <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfform>
    
        </div>
    </div>
    
    
    <script type="text/javascript">
        var country_ = document.form_add_company.country.value;
        if(country_.length)
            LoadCity(country_,'city_id','county_id',0);
    
    function remove_field(field_option_name)
    {
        field_option_name_value = document.getElementById(field_option_name);
        for (i=field_option_name_value.options.length-1;i>-1;i--)
        {
            if (field_option_name_value.options[i].selected==true)
            {
                field_option_name_value.options.remove(i);
            }	
        }
    }
    function select_all(selected_field)
    {
        var m = eval("document.form_add_company." + selected_field + ".length");
        for(i=0;i<m;i++)
        {
            eval("document.form_add_company."+selected_field+"["+i+"].selected=true");
        }
    }
    function kontrol()
    {
        select_all('product_category');
        if(document.getElementById('fullname').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='159.Ünvan'>!");
            document.getElementById('fullname').focus();
            return false;
        }
        
        if(document.getElementById('nickname').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='339.kisa Ad'>!");
            document.getElementById('nickname').focus();
            return false;
        }
        
        x = document.getElementById('companycat_id').selectedIndex;
        if (document.form_add_company.companycat_id[x].value == "")
        { 
            alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='131.Sirket Kategorisi '>!");
            document.getElementById('companycat_id').focus();
            return false;
        }		
        /*if (document.getElementById('firm_type').value == "")
        { 
            alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:Firma Tipi!");
            return false;
        }
        if(document.getElementById('product_category').value == '' )
        {
            alert("Ürün Kategorisi Seçmelisiniz !");
            document.getElementById('product_category').focus();
            return false;
        }*/
        if(document.getElementById('name').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='485.adı '>!");
            document.getElementById('name').focus();
            return false;
        }
        
        if(document.getElementById('soyad').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='1138.soyadı '>!");
            document.getElementById('soyad').focus();
            return false;
        }
        
        if(document.getElementById('tc_identity').value != "")
        {
            if(!isTCNUMBER(document.getElementById('tc_identity'))) return false;
            if(document.getElementById('tc_identity').value.length != 11)
                {
                    alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='436.TC Kimlik Numarası - 11 Hane'> !");
                    document.getElementById('tc_identity').focus();
                    return false;
                }
        }
        
        if(document.getElementById('company_partner_email').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='16.email '>!");
            document.getElementById('company_partner_email').focus();
            return false;
        }
        
        
        if(document.getElementById('company_partner_email').value != '')
        {
            getMemberEmailCheck = wrk_query("SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = '" + document.getElementById('company_partner_email').value +"'" ,"dsn");
            if(getMemberEmailCheck.COMPANY_PARTNER_EMAIL != undefined)
            {
                alert("Bu E-Posta ile bir kayıt bulunmaktadır. Lütfen yeni bir mail adresi giriniz !");
                document.getElementById('company_partner_email').focus();
                return false;
            }
        }
        
        if(document.getElementById('company_telcode').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='178.Telefon Kodu'> !");
            document.getElementById('company_telcode').focus();
            return false;
        }
        
        if(document.getElementById('company_tel1').value == "")
        {
            alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='87.Telefon'> !");
            document.getElementById('company_tel1').focus();
            return false;
        }
        
        if(document.form_add_company.process_stage.value == "")
        {
            alert("<cf_get_lang no='393.Lütfen Süreçlerinizi Tanımlayınız Yada Süreçler Üzerinde Yetkiniz Yok'>!");
            return false;
        }
        if(process_cat_control())
            if(confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!"));
        else
            return false;
    
        return true;
    }
    
    function gizle_goster_detail(id)
        {
            if(document.getElementById(id).style.display == '' || document.getElementById(id).style.display == 'block' )
            {
                document.getElementById(id).style.display = 'none';
            } else {
                document.getElementById(id).style.display ='';
            }
        }
    
    function counter(id1,id2)
         { 
            if (document.getElementById(id1).value.length > 1500) 
              {
                    document.getElementById(id1).value = document.getElementById(id1).value.substring(0, 1500);
                    alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 1500");  
               }
            else 
                document.getElementById(id2).value = 1500 - (document.getElementById(id1).value.length); 
         }
    
    
    document.getElementById('fullname').focus();
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    