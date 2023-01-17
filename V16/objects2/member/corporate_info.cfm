<cfparam name="our_company_id" default="#(isdefined('attributes.default_our_company_id') and len(attributes.default_our_company_id)) ? attributes.default_our_company_id : (session_base.our_company_id?:'')#">
<cfparam name="period_id" default="#(isdefined('attributes.default_period_id') and len(attributes.default_period_id)) ? attributes.default_period_id : (session_base.period_id?:'')#">

<cfset member_company = createObject("component","V16.member.cfc.member_company")>
<cfset get_country = member_company.GET_COUNTRY() />
<cfset get_company_size = member_company.GET_COMPANY_SIZE() />
<cfset get_partner_positions = member_company.GET_PARTNER_POSITIONS() />
<cfset get_company_stage = member_company.GET_COMPANY_STAGE(company_id:our_company_id) />
<cfset get_company_cat = member_company.GET_COMPANYCAT(company_id:our_company_id) />
<cfset get_company_sector_upper = member_company.GET_COMPANY_SECTOR_UPPER() />
<cfset get_company_sector = member_company.GET_COMPANY_SECTOR() />

<cfform name="add_member" id="add_member" action="" method="post">
    <cfoutput>
        <input type="hidden" name="company_status" id="company_status" value="1">
        <input type="hidden" name="company_partner_status" id="company_partner_status" value="1">
        <input type="hidden" name="our_company_id" id="our_company_id" value="#our_company_id#">
        <input type="hidden" name="period_id" id="period_id" value="#period_id#">
        <input type="hidden" name="process_stage" id="process_stage" value="#(isdefined('attributes.default_process_stage') and len(attributes.default_process_stage)) ? attributes.default_process_stage : (get_company_stage.recordcount ? get_company_stage.PROCESS_ROW_ID[1] : '')#">

        <div class="row mx-auto mt-3">
            <div class="col-md-12">
                <div class="col-lg-6 col-md-6 col-xs-12">
                    <div class="form-row">
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label for="fullname" class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'> - <cf_get_lang dictionary_id='57574.Şirket'>*</label>
                            <input type="text" name="fullname" id="fullname" class="form-control" placeholder="<cf_get_lang dictionary_id='61823.Tam Ünvanı Giriniz'>" required>
                        </div>
                    </div>
                    <div class="form-row">                      
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label for="companycat_id" class="font-weight-bold"><cf_get_lang dictionary_id='30269.Şirket Kategorisi'>*</label>
                            <select name="companycat_id" id="companycat_id" class="form-control" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_company_cat.recordcount>
                                    <cfloop query="get_company_cat">
                                        <option value="#COMPANYCAT_ID#">#COMPANYCAT#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>    
                    </div>
                    <!--- <div class="form-row">                      
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label for="upper_sector_cat" class="font-weight-bold"><cf_get_lang dictionary_id='43647.Üst Sektör'>*</label>
                            <select name="upper_sector_cat" id="upper_sector_cat" class="form-control" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_company_sector_upper.recordcount>
                                    <cfloop query="get_company_sector_upper">
                                        <option value="#SECTOR_UPPER_ID#">#SECTOR_CAT#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>    
                    </div> --->
                    <div class="form-row">                      
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label for="company_sector" class="font-weight-bold"><cf_get_lang dictionary_id='57579.Sektör'>*</label>
                            <select name="company_sector" id="company_sector" class="form-control" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_company_sector.recordcount>
                                    <cfloop query="get_company_sector">
                                        <option value="#SECTOR_CAT_ID#">#SECTOR_CAT#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>    
                    </div>
                    <div class="form-row">                           
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label for="company_size_cat_id" class="font-weight-bold"><cf_get_lang dictionary_id='61818.Organizasyon Büyüklüğü'>*</label>
                            <select name="company_size_cat_id" id="company_size_cat_id" class="form-control" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_company_size.recordcount>
                                    <cfloop query="get_company_size">
                                        <option value="#COMPANY_SIZE_CAT_ID#">#COMPANY_SIZE_CAT#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>    
                    </div>
                    <div class="form-row">
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label for="homepage" class="font-weight-bold"><cf_get_lang dictionary_id='51251.Web Adresi'></label>
                            <input type="text" name="homepage" id="homepage" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>">
                        </div>
                    </div>                      
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label for="email" class="font-weight-bold"><cf_get_lang dictionary_id='32494.E- Mail'>*</label>
                            <input type="email" name="email" id="email" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" required>
                        </div>
                        <div class="form-group col-lg-2 col-md-2 col-xs-4">
                            <label for="telcod" class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'></label>
                            <input type="number" maxlength="5" name="telcod" id="telcod" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>">
                        </div>
                        <div class="form-group col-lg-4 col-md-4 col-xs-8">
                            <label for="tel1" class="font-weight-bold"><cf_get_lang dictionary_id='57499.Telefon'></label>
                            <input type="number" maxlength="7" name="tel1" id="tel1" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>">
                        </div>
                    </div>
                    <h6 class="mt-3 mb-3 header-color"><cf_get_lang dictionary_id='61820.Yetkili Bilgileri'></h6>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label for="name" class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                            <input type="text" name="name" id="name" class="form-control" placeholder="<cf_get_lang dictionary_id='57631.Ad'>" required>
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label for="soyad" class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
                            <input type="text" name="soyad" id="soyad" class="form-control" placeholder="<cf_get_lang dictionary_id='58726.Soyad'>" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="title" class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'>*</label>
                            <input type="text" name="title" id="title" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label for="mission" class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
                            <select name="mission" id="mission" class="form-control" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_partner_positions.recordcount>
                                    <cfloop query="get_partner_positions">
                                        <option value="#PARTNER_POSITION_ID#">#PARTNER_POSITION#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label for="company_partner_email" class="font-weight-bold"><cf_get_lang dictionary_id='39186.E-Mail'>*</label>
                            <input type="email" name="company_partner_email" id="company_partner_email" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" required>
                        </div>
                        <div class="form-group col-lg-2 col-md-2 col-xs-4">
                            <label for="mobilcat_id_partner" class="font-weight-bold"><cf_get_lang dictionary_id='29983.Mobil Kod'>*</label>
                            <input type="number" maxlength="3" name="mobilcat_id_partner" id="mobilcat_id_partner" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" required>
                        </div>
                        <div class="form-group col-lg-4 col-md-4 col-xs-8">
                            <label for="mobiltel_partner" class="font-weight-bold"><cf_get_lang dictionary_id='30181.Mobil Telefon'>*</label>
                            <input type="number" maxlength="7" name="mobiltel_partner" id="mobiltel_partner" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6 col-lg-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57552.Şifre'>*</label>
                            <input type="password" name="partner_password" id="partner_password" class="form-control" placeholder="En az 8 karakter" required>
                        </div>
                        <div class="form-group col-md-6 col-lg-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='59013.Şifre Tekrar'>*</label>
                            <input type="password" name="partner_password_confirm" id="partner_password_confirm" class="form-control" placeholder="En az 8 karakter" required>
                        </div>
                    </div>
                    <h6 class="mt-3 mb-3 header-color"><cf_get_lang dictionary_id='30324.Address Information'></h6>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="country" class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'>*</label>
                            <select name="country" id="country" class="form-control" required onchange="LoadCity(this.value,'city_id','county_id',0);">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_country.recordcount>
                                    <cfloop query="get_country">
                                        <option value="#COUNTRY_ID#">#COUNTRY_NAME#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="city_id" class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'>*</label>
                            <select name="city_id" id="city_id" class="form-control" required onchange="LoadCounty(this.value,'county_id')">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="county_id" class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'>*</label>
                            <select name="county_id" id="county_id" class="form-control" onchange="LoadDistrict(this.value,'district_id');" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="district_id" class="font-weight-bold"><cf_get_lang dictionary_id='58735.Mahalle'>*</label>
                            <select name="district_id" id="district_id" class="form-control" required onchange="LoadPostCode(this.value,'postcod','semt')">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="postcod" class="font-weight-bold"><cf_get_lang dictionary_id='57472.Posta Kodu'>*</label>
                            <input type="text" name="postcod" id="postcod" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="semt" class="font-weight-bold"><cf_get_lang dictionary_id='58132.Semt'>*</label>
                            <input type="text" name="semt" id="semt" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" required>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="adres" class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'>*</label>
                            <input type="text" name="adres" id="adres" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" required>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="form-group">
                    <cf_workcube_buttons is_insert="1" add_function="control()" data_action="/V16/objects2/member/cfc/corporate_info:add_corporate_info" next_page="/subscriber" >
                </div>
            </div>
        </div>
    </cfoutput>
</cfform>

<script>

    function control() {
        if( document.add_subscription.partner_password.value != document.add_subscription.partner_password_confirm.value ){
            alert('Şifre ve Şifre tekrar alanları aynı olmalı!');
            return false;
        }
    }

</script>