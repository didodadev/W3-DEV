<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset company_partner = contract_cmp.GET_PARTNER(partner_list: session_base.userid?:(attributes.userid?:''), partner_email: attributes.email?:'') />

<cfset get_addres_company = contract_cmp.get_addres_company(company_id: session_base.company_id?:(attributes.company_id?:'')) />
<cfset get_country = contract_cmp.get_country_detail() />
<cfset get_city = contract_cmp.get_city_detail( COUNTRY_ID:get_addres_company.recordcount ? get_addres_company.COUNTRY : '' ) />
<cfset get_county = contract_cmp.get_county_detail( CITY:get_addres_company.recordcount ? get_addres_company.CITY : '' ) />

<cfform name="add_subscription" id="add_subscription" action="" method="post">
    <cfoutput>
        <input type="hidden" name="member_type" id="member_type" value="#session_base.member_type?:(attributes.member_type?:'')#">
        <input type="hidden" name="subscription_head" id="subscription_head" value="Master Ürün">
        <input type="hidden" name="is_active" id="is_active" value="1">
        <input type="hidden" name="start_date" id="start_date" value="#now()#">
        <input type="hidden" name="subscription_type" id="subscription_type" value="#attributes.default_subscription_type_id#"><!--- xml --->
        <input type="hidden" name="process_stage" id="process_stage" value="#attributes.default_process_stage#"><!--- xml --->
        <input type="hidden" name="create_subscription_no" id="create_subscription_no" value="#attributes.create_subscription_no#"><!--- xml --->
        <input type="hidden" name="create_subscription_key" id="create_subscription_key" value="#attributes.create_subscription_key#"><!--- xml --->
        
        <div class="row">
            <div class="col-md-12">
                <div class="col-lg-6 col-md-6 col-xs-12">
                    <div class="form-row">
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'>- <cf_get_lang dictionary_id='57574.Şirket'>*</label>
                            <input type="hidden" name="company_id" id="company_id" value="#session_base.company_id?:(attributes.company_id?:'')#">
                            <input type="text" name="company" id="company" class="form-control" placeholder="#getLang('','Tam Ünvanı Giriniz',61823)#" value="#session_base.company?:(attributes.company?:'')#" readonly required>
                        </div>
                    </div>
                    <a href="##" class="none-decoration"><p class="mb-4 header-color">> <cf_get_lang dictionary_id='61817.Kayıtlı bir şirketi aramak için tıklayarak kontrol edebilirsiniz.'></p></a>
                    <p><cf_get_lang dictionary_id='61931.Workcube tarafından verilen SSL sertifikalı ücretsiz sub-domain kullanabilirsiniz.'></p>                 
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='61932.Sub Domain'></label>
                            <input type="text" name="sub_domain" id="sub_domain" class="form-control" placeholder="Max 15 karakter" maxlength="15">
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57892.Domain'></label>
                            <select name="domain" id="domain" class="form-control">
                                <option>workcube.com</option>
                            </select>
                        </div>
                    </div>
                    <p><cf_get_lang dictionary_id='61933.Workcube''ü kurumunuza ait domain altında kullanmak istiyorsanız domain belirtiniz'></p>                  
                    <div class="form-row">
                        <div class="form-group col-lg-12 col-md-12 col-xs-12">
                            <label class="font-weight-bold">Kuruma Özel Domain</label>
                            <input type="text" name="company_domain" id="company_domain" class="form-control" placeholder="SSL - HHPS Girilmelidir">
                        </div>
                    </div>
                    <p><cf_get_lang dictionary_id='61934.Bulut kullanımı için Cloud müşteri sunucusuna kurmak için On-Prem seçilir.'></p>
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='61935.Kullanım Şekli'>*</label>
                            <select name="use_type" id="use_type" class="form-control" required>
                                <option value="Cloud">Cloud</option>
                                <option value="On-Prem">On-Prem</option>
                            </select>
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='59913.Kullanıcı Sayısı'>*</label>
                            <input type="number" name="user_count" id="user_count" class="form-control" required>
                        </div>
                    </div>
                    <h6 class="mt-3 mb-3 header-color"><cf_get_lang dictionary_id='61936.Abone Yetkilisi'></h6>
                    <p><cf_get_lang dictionary_id='61937.Abone işlemlerini yapmak ve bilgi paylaşmak için üst yetkiliyi belirtin.'></p>
                    <div class="form-row">
                        <input type="hidden" name="partner_id" id="partner_id" value="#company_partner.PARTNER_ID#">
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                            <input type="text" name="partner_name" id="partner_name" class="form-control" placeholder="#getLang('','Giriniz',61824)#" value="#company_partner.COMPANY_PARTNER_NAME#" readonly required>
                        </div>
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
                            <input type="text" name="partner_surname" id="partner_surname" class="form-control" placeholder="#getLang('','Giriniz',61824)#" value="#company_partner.COMPANY_PARTNER_SURNAME#" readonly required>
                        </div>
                    </div>    
                    <div class="form-row">
                        <div class="form-group col-lg-6 col-md-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='39186.E-Mail'>*</label>
                            <input type="email" name="partner_email" id="partner_email" class="form-control" placeholder="#getLang('','Giriniz',61824)#" value="#company_partner.COMPANY_PARTNER_EMAIL#" required>
                        </div>
                        <div class="form-group col-lg-2 col-md-2 col-xs-4">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='29983.Mobil Kod'>*</label>
                            <input type="number" maxlength="3" name="mobile_code" id="mobile_code" class="form-control" placeholder="#getLang('','Giriniz',61824)#" value="#company_partner.MOBIL_CODE#" required>
                        </div>
                        <div class="form-group col-lg-4 col-md-4 col-xs-8">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='30181.Mobil Telefon'>*</label>
                            <input type="number" maxlength="7" name="mobile_phone" id="mobile_phone" class="form-control" placeholder="#getLang('','Giriniz',61824)#" value="#company_partner.MOBILTEL#" required>
                        </div>
                    </div>
                    <h6 class="mt-3 mb-3 header-color"><cf_get_lang dictionary_id='61846.Fatura Bilgisi'></h6>
                    <p><cf_get_lang dictionary_id='61938.Abone hizmetlerinin fatura edileceği kurumun vergi bilgilerini giriniz.'></p>
                    <div class="form-row">
                        <div class="form-group col-md-6 col-lg-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                            <input type="text" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>">
                        </div>
                        <div class="form-group col-md-6 col-lg-6 col-xs-12">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                            <input type="text" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 col-xs-12">
                            <label class="checkbox-container font-weight-bold mb-0"><cf_get_lang dictionary_id='61939.Fatura adresi şirket adresi ile aynı.'>
                                <input type="checkbox" id="toggle_invoice_panel" checked>
                                <span class="checkmark"></span>
                            </label>
                        </div>
                    </div>
                    <div class="mt-3 mb-5" id="invoice_panel" style="display:none;">
                        <div class="form-row">
                            <div class="form-group col-md-12">
                                <label class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'></label>
                                <select name="invoice_country_id" id="invoice_country_id" class="form-control" required onchange="LoadCity(this.value,'invoice_city_id','invoice_county_id',0);">
                                    <option value=""><cf_get_lang dictionary_id='58219.Ülke'></option>
                                    <cfif get_country.recordcount>
                                        <cfloop query="get_country">
                                            <option value="#COUNTRY_ID#" <cfoutput>#get_addres_company.recordcount and get_addres_company.COUNTRY eq get_country.COUNTRY_ID ? 'selected' : ''#</cfoutput>>#COUNTRY_NAME#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'></label>
                                <select name="invoice_city_id" id="invoice_city_id" class="form-control" required onchange="LoadCounty(this.value,'invoice_county_id')">
                                    <option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
                                    <cfif get_addres_company.recordcount and get_city.recordcount>
                                        <cfloop query="get_city">
                                            <option value="#CITY_ID#" <cfoutput>#get_addres_company.CITY eq get_city.CITY_ID ? 'selected' : ''#</cfoutput>>#CITY_NAME#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                <select name="invoice_county_id" id="invoice_county_id" class="form-control" onchange="LoadDistrict(this.value,'district_id');" required>
                                    <option value=""><cf_get_lang dictionary_id='58638.İlçe'></option>
                                    <cfif get_addres_company.recordcount and get_county.recordcount>
                                        <cfloop query="get_county">
                                            <option value="#COUNTY_ID#" <cfoutput>#get_addres_company.COUNTY eq get_county.COUNTY_ID ? 'selected' : ''#</cfoutput>>#COUNTY_NAME#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="district_id" class="font-weight-bold"><cf_get_lang dictionary_id='58735.Mahalle'>*</label>
                                <select name="district_id" id="district_id" class="form-control" onchange="LoadPostCode(this.value,'invoice_postcode','invoice_semt')">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label class="font-weight-bold"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                                <input type="number" name="invoice_postcode" id="invoice_postcode" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" value="#get_addres_company.recordcount ? get_addres_company.POSTCODE : ''#">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="invoice_semt" class="font-weight-bold"><cf_get_lang dictionary_id='58132.Semt'>*</label>
                                <input type="text" name="invoice_semt" id="invoice_semt" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>">
                            </div>
                            <div class="form-group col-md-6">
                                <label class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
                                <input type="text" name="invoice_address" id="invoice_address" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.Giriniz'>" value="#get_addres_company.recordcount ? get_addres_company.ADDRESS : ''#">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="form-group">
                    <cf_workcube_buttons is_insert="1" add_function="control()" data_action="/V16/objects2/sale/cfc/subscribers:add_subscription_contract_all" next_page="/#url.return_url?:'subscribers'#" >
                </div>
            </div>
        </div>
    </cfoutput>
</cfform>

<script>

    function control() {
        if( document.add_subscription.sub_domain.value == '' && document.add_subscription.company_domain.value == '' ){
            alert('Sub Domain ya da Kuruma Özel Domain alanlarından birini doldurmalısınız!');
            return false;
        }
        return true;
    }

    $("#toggle_invoice_panel").click(function() {
        $("#invoice_panel").toggle();
        if( $('input#toggle_invoice_panel').is(':checked') ){
            $("select#district_id, input#invoice_postcode, input#invoice_semt, input#invoice_address").attr("required","true");
        }else{
            $("select#district_id, input#invoice_postcode, input#invoice_semt, input#invoice_address").removeAttr("required");
        }
    });

</script>