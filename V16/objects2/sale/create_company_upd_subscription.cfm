<cfif isDefined("session.storage")>
    <cfset ccus = createObject("component", "V16.objects2.sale.cfc.create_company_upd_subscription") />
    <cfset get_company_sector = ccus.GET_COMPANY_SECTOR() />
    <cfset get_company_size = ccus.GET_COMPANY_SIZE() />
    <cfset get_partner_positions = ccus.GET_PARTNER_POSITIONS() />
    <cfset get_country = ccus.GET_COUNTRY_() />

    <cfform name="add_company" id="add_company" action="" method="post">
        <cfoutput>
            <input type="hidden" name="member_type" id="member_type" value="partner">
            <input type="hidden" name="company_status" id="company_status" value="1">
            <input type="hidden" name="start_date" id="start_date" value="#now()#">
            <input type="hidden" name="process_stage" id="process_stage" value="#attributes.default_company_process_stage#"><!--- xml --->
            <input type="hidden" name="companycat_id" id="companycat_id" value="#attributes.default_company_cat_id#"><!--- xml --->
            <input type="hidden" name="period_id" id="period_id" value="#session.qq.period_id#">
            <input type="hidden" name="ispotantial" id="ispotantial" value="1">

            <div class="row mx-auto">
                <div class="col-lg-8 col-md-8 col-sm-12">
                    <h6 class="mb-3"><cf_get_lang dictionary_id='65278.Size daha iyi ürünler ve hizmetler sunmak için birkaç bilgiye ihtiyacımız var'></h6>
                    <div class="form-row">
                        <div class="form-group col-md-12 col-sm-12">
                            <label for="fullname" class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'>- <cf_get_lang dictionary_id='57574.Şirket'>*</label>
                            <input type="text" name="fullname" id="fullname" class="form-control" placeholder="#getLang('','Tam Ünvanı Giriniz',61823)#" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="sector_cat_id" class="font-weight-bold"><cf_get_lang dictionary_id='57579.Sektör'>*</label>
                            <select name="sector_cat_id" id="sector_cat_id" class="form-control select2" multiple required>
                                <cfif get_company_sector.recordcount>
                                    <cfloop query = "#get_company_sector#">
                                        <option value="#SECTOR_CAT_ID#">#SECTOR_CAT#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="company_size_cat_id" class="font-weight-bold"><cf_get_lang dictionary_id='61818.Organizasyon Büyüklüğü'>*</label>
                            <select name="company_size_cat_id" id="company_size_cat_id" class="form-control select2" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_company_size.recordcount>
                                    <cfloop query="get_company_size">
                                        <option value="#company_size_cat_id#">#company_size_cat#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-12 col-sm-12">
                            <label for="homepage" class="font-weight-bold"><cf_get_lang dictionary_id='51251.Web Adresi'></label>
                            <input type="text" name="homepage" id="homepage" class="form-control">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="email" class="font-weight-bold"><cf_get_lang dictionary_id='55484.E-Mail'>*</label>
                            <input type="text" name="email" id="email" class="form-control" required>
                        </div>
                        <div class="form-group col-lg-6 col-md-2 col-sm-4">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='61819.Sabit Telefon'></label>
                            <input type="text" name="phone_number" id="phone_number" class="form-control" data-number_format="phone">
                            <!--- <div class="col-lg-4 col-md-2 col-sm-4 float-left p-0">
                                <input type="number" maxlength="3" name="telcod" id="telcod" class="form-control">
                            </div>
                            <div class="col-lg-8 col-md-10 col-sm-8 float-left pr-lg-0 pr-md-0">
                                <input type="number" maxlength="7" name="tel1" id="tel1" class="form-control">
                            </div> --->
                        </div>
                    </div>
                    <h5 class="mt-3 mb-3 text-warning"><cf_get_lang dictionary_id='61820.Yetkili Bilgileri'></h5>
                    <p><cf_get_lang dictionary_id='61937.Abone işlemlerini yapmak ve bilgi paylaşmak için üst yetkiliyi belirtin.'></p>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="name" class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                            <input type="text" name="name" id="name" class="form-control" required>
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="soyad" class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
                            <input type="text" name="soyad" id="soyad" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-12 col-sm-12">
                            <label for="mission" class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
                            <select name="mission" id="mission" class="form-control select2" required>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_partner_positions.recordcount>
                                    <cfloop query = "#get_partner_positions#">
                                        <option value="#PARTNER_POSITION_ID#">#PARTNER_POSITION#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>    
                    </div> 
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="company_partner_email" class="font-weight-bold"><cf_get_lang dictionary_id='39186.E-Mail'>*</label>
                            <input type="email" name="company_partner_email" id="company_partner_email" class="form-control" required>
                        </div>
                        <div class="form-group col-lg-6 col-md-2 col-sm-4">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='30181.Mobil Telefon'>*</label>
                            <input type="text" name="partner_mobile_phone" id="partner_mobile_phone" class="form-control" required data-number_format="phone">
                            <!--- <div class="col-lg-4 col-md-2 col-sm-4 float-left p-0">
                                <input type="number" maxlength="3" name="partner_mobile_code" id="partner_mobile_code" class="form-control" required>
                            </div>
                            <div class="col-lg-8 col-md-10 col-sm-8 float-left pr-lg-0 pr-md-0">
                                <input type="number" maxlength="7" name="partner_mobile_tel" id="partner_mobile_tel" class="form-control" required>
                            </div> --->
                        </div>
                    </div>
                    <h5 class="mt-3 mb-3 text-warning"><cf_get_lang dictionary_id='34532.Adres Bilgileri'></h5>
                    <div class="form-row">
                        <div class="form-group col-md-12 col-sm-12">
                            <label for="country" class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'>*</label>
                            <select name="country" id="country" class="form-control select2" onchange="LoadCity(this.value,'city_id','county_id',0);" required>
                                <option value=""><cf_get_lang dictionary_id='58219.Ülke'></option>
                                <cfif get_country.recordcount>
                                    <cfloop query = "#get_country#">
                                        <option value="#COUNTRY_ID#">#COUNTRY_NAME#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="city_id" class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'>*</label>
                            <select name="city_id" id="city_id" class="form-control select2" onchange="LoadCounty(this.value,'county_id')" required>
                                <option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
                            </select>
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="county_id" class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'>*</label>
                            <select name="county_id" id="county_id" class="form-control select2" onchange="LoadDistrict(this.value,'district_id');" required>
                                <option value=""><cf_get_lang dictionary_id='58638.İlçe'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="district_id" class="font-weight-bold"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                            <select name="district_id" id="district_id" class="form-control select2" onchange="LoadPostCode(this.value,'postcod')">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="postcod" class="font-weight-bold"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                            <input type="number" name="postcod" id="postcod" class="form-control">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-12 col-sm-12">
                            <label for="adres" class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'>*</label>
                            <input type="text" name="adres" id="adres" class="form-control" required>
                        </div>
                    </div>
                    <h5 class="mt-3 mb-3 text-warning"><cf_get_lang dictionary_id='61846.Fatura Bilgisi'></h5>
                    <p><cf_get_lang dictionary_id='61938.Abone hizmetlerinin fatura edileceği kurumun vergi bilgilerini giriniz.'></p>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="taxoffice" class="font-weight-bold"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                            <input type="text" name="taxoffice" id="taxoffice" class="form-control">
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-sm-12">
                            <label for="taxno" class="font-weight-bold"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                            <input type="text" name="taxno" id="taxno" class="form-control">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <label class="checkbox-container font-weight-bold mb-0"><cf_get_lang dictionary_id='61939.Fatura adresi şirket adresi ile aynı.'>
                                <input type="checkbox" name="is_same_with_company" id="is_same_with_company">
                                <span class="checkmark"></span>
                            </label>
                        </div>
                    </div>
                    <div class="mt-3 mb-5" id="invoice_panel">
                        <div class="form-row">
                            <div class="form-group col-md-12">
                                <label for="invoice_country_id" class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'></label>
                                <select name="invoice_country_id" id="invoice_country_id" class="form-control select2" onchange="LoadCity(this.value,'invoice_city_id','invoice_county_id',0);">
                                    <option value=""><cf_get_lang dictionary_id='58219.Ülke'></option>
                                    <cfif get_country.recordcount>
                                        <cfloop query = "#get_country#">
                                            <option value="#COUNTRY_ID#">#COUNTRY_NAME#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="invoice_city_id" class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'></label>
                                <select name="invoice_city_id" id="invoice_city_id" class="form-control select2" onchange="LoadCounty(this.value,'invoice_county_id')">
                                    <option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="invoice_county_id" class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                <select name="invoice_county_id" id="invoice_county_id" class="form-control select2" onchange="LoadDistrict(this.value,'invoice_district_id');">
                                    <option value=""><cf_get_lang dictionary_id='58638.İlçe'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="invoice_district_id" class="font-weight-bold"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                                <select name="invoice_district_id" id="invoice_district_id" class="form-control select2" onchange="LoadPostCode(this.value,'invoice_postcode')">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="invoice_postcode" class="font-weight-bold"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                                <input type="number" name="invoice_postcode" id="invoice_postcode" class="form-control">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-12">
                                <label for="invoice_address" class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
                                <input type="text" name="invoice_address" id="invoice_address" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8 col-md-8 col-sm-12 mt-3">
                    <div class="form-group" style="float: left;">
                        <cf_workcube_buttons is_insert="1" insert_info="İlerle" win_alert="0" data_action="/V16/objects2/sale/cfc/create_company_upd_subscription:create_company_partner" next_page="/siparis-odeme" class="btn-success">
                    </div>
                </div>
            </div>
        </cfoutput>
    </cfform>

    <script>
        $("#is_same_with_company").click(function() {
            $("#invoice_panel").toggle();
        });
    </script>
<cfelse>
    <script>
        alert("Bir hata oluştu!\nLütfen önce sepete ürün ekleyiniz!");
        history.back();
    </script>
</cfif>