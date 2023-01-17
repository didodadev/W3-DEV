<cfinclude template="../../config.cfm">
<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
    <cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.companies.member") />
    <cfset getCompany = cmp.getCompany(company_id:attributes.cpid) />
    <cfset getBranch = cmp.getCompanyBranch(company_id:attributes.cpid,branch_id:attributes.brid) />
    <cfset getPartner = cmp.getPartner(company_id:attributes.cpid) />
    <!---<cfset getMobilcat = cmp.getMobilcat() />--->
    <cfset getCountry = cmp.getCountry() />
    
    <cfsavecontent variable="pageHead">
        <cf_get_lang_main no='41.Şube'><cfoutput>:#getBranch.compbranch__name#</cfoutput>
    </cfsavecontent>
    <cf_catalystHeader>
        
    <cfform name="upd_company_branch" method="post">
        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getCompany.company_id#</cfoutput>">
        <input type="hidden" name="COMPBRANCH_ID" id="COMPBRANCH_ID" value="<cfoutput>#url.brid#</cfoutput>">
    
        <div class="row">
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                    <div class="row" type="row">
                        <!--- col 1 --->
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-compbranch_status">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='81.Aktif'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="checkbox" name="compbranch_status" id="compbranch_status" <cfif getBranch.compbranch_status eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group" id="item-compbranch_tel2">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 2</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="compbranch_tel2" id="compbranch_tel2" value="<cfoutput>#getBranch.compbranch_tel2#</cfoutput>" maxlength="10" style="width:97px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-country">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='807.Ülke'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="country" id="country" style="width:165px;" onBlur="LoadCity(this.value,'city_id','county_id')">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="getCountry">
                                            <option value="#getCountry.country_id#" <cfif getBranch.country_id eq getCountry.country_id>selected</cfif>>#getCountry.country_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-compbranch_postcode">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="compbranch_postcode" id="compbranch_postcode" value="<cfoutput>#getBranch.compbranch_postcode#</cfoutput>" maxlength="5" style="width:160px;">
                                </div>
                            </div>
                        </div>
                        <!--- col 2 --->
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-compbranch__name">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1735.Şube Adı'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1735.Şube adı !'></cfsavecontent>
                                    <cfinput type="text" name="compbranch__name" id="compbranch__name" value="#getBranch.compbranch__name#" maxlength="50" required="yes" message="#message#" style="width:430px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-compbranch_tel3">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 3</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="compbranch_tel3" id="compbranch_tel3" value="<cfoutput>#getBranch.compbranch_tel3#</cfoutput>" maxlength="10" style="width:97px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-city_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif len(getBranch.city_id)>
                                        <cfquery name="GET_CITY" datasource="#DSN#">
                                            SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
                                        </cfquery>
                                        <select name="city_id" id="city_id" style="width:165px;" onChange="LoadCounty(this.value,'county_id','compbranch_telcode')">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="GET_CITY">
                                                <option value="#city_id#" <cfif city_id eq getBranch.city_id>selected</cfif>>#city_name#</option>
                                            </cfoutput>
                                        </select>
                                    <cfelse>
                                        <select name="city_id" id="city_id" style="width:165px;" onChange="LoadCounty(this.value,'county_id','compbranch_telcode')">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        </select>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-compbranch_email">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='16.E-mail'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="mesaj"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
                                    <cfinput type="text" name="compbranch_email" id="compbranch_email" validate="email" message="#mesaj#" value="#getBranch.compbranch_email#" maxlength="100" style="width:160px;">
                                </div>
                            </div>
                        </div>
                        <!--- col 3 --->
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-compbranch_telcode">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='36.Kod/ Telefon'> *</label>
                                <div class="col col-3 col-xs-5">
                                    <cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
                                    <cfinput type="text" name="compbranch_telcode" id="compbranch_telcode" value="#getBranch.compbranch_telcode#" required="yes" maxlength="5" message="#message#" style="width:55px;">
                                </div>
                                <div class="col col-5 col-xs-7">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='87.Telefon '></cfsavecontent> 
                                    <cfinput type="text" name="compbranch_tel1" id="compbranch_tel1" value="#getBranch.compbranch_tel1#" maxlength="10" required="yes" message="#message#" style="width:90px;"> 
                                </div>
                            </div>
                            <div class="form-group" id="item-compbranch_fax">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Fax'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="compbranch_fax" id="compbranch_fax" value="<cfoutput>#getBranch.compbranch_fax#</cfoutput>" maxlength="10" style="width:97px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-county_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1226.ilçe'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="county_id" id="county_id" style="width:165px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>	
                                        <cfif len(getBranch.county_id)>
                                            <cfquery name="GET_COUNTY" datasource="#DSN#">
                                                SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY
                                            </cfquery>
                                            <cfoutput query="get_county">
                                            <option value="#county_id#" <cfif getBranch.county_id eq county_id>selected</cfif>>#county_name#</option>
                                            </cfoutput>
                                        </cfif>					
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-homepage">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='41.İnternet'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="homepage" id="homepage" value="<cfoutput>#getBranch.homepage#</cfoutput>" maxlength="50" style="width:160px;">
                                </div>
                            </div>
                        </div>
                        <!--- col 4 --->
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                            <div class="form-group" id="item-manager">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1714.Yönetici'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="manager" id="manager" style="width:165px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                          <cfoutput query="getPartner"> 
                                            <option value="#partner_id#" <cfif partner_id eq getBranch.manager_partner_id>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
                                          </cfoutput> 
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-mobiltel">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='116.Kod / Mobil'></label>
                                <div class="col col-3 col-xs-5">
                                    <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getBranch.compbranch_mobil_code#</cfoutput>" style="width:60px;">
                                </div>
                                <div class="col col-5 col-xs-7">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='116.Kod/ Mobil tel'></cfsavecontent>
                                    <cfinput type="text" name="mobiltel" id="mobiltel" value="#getBranch.compbranch_mobiltel#" maxlength="10" validate="integer" message="#message#" tabindex="2" style="width:97px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-semt">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='720.Semt'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="semt" id="semt" value="<cfoutput>#getBranch.semt#</cfoutput>" maxlength="50" style="width:160px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-coordinate_1">
                                <label class="col col-4 col-xs-12">
                                    <cf_get_lang_main no='1137.Koordinatlar'>
                                    <cfif len(getBranch.coordinate_1) and len(getBranch.coordinate_2)>
                                        <cfoutput><a href="javascript://" ><img src="/images/branch.gif" border="0" title="Haritada Göster" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#getBranch.coordinate_1#&coordinate_2=#getBranch.coordinate_2#&title=#getBranch.compbranch__name#</cfoutput>','list','popup_view_map')" align="absmiddle"></a></cfoutput> 				
                                    </cfif>
                                </label>
                                <div class="col col-4">
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <cf_get_lang_main no='1141.E'>
                                        </div>
                                        <cfinput type="text" maxlength="10" name="coordinate_1" id="coordinate_1" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="#getBranch.coordinate_1#" style="width:59px;"> 
                                    </div>
                                </div>
                                <div class="col col-4">
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <cf_get_lang_main no='1179.B'>
                                        </div>
                                        <cfinput type="text" maxlength="10" name="coordinate_2" id="coordinate_2" range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#getBranch.coordinate_2#" style="width:59px;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" type="row">
                        <div class="col col-6 col-xs-12" type="column" index="5" sort="true">
                            <div class="form-group" id="item-compbranch__nickname">
                                <label class="col col-2 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                                <div class="col col-10 col-xs-12">
                                    <textarea name="compbranch__nickname" id="compbranch__nickname" style="width:160px;height:70px;"><cfoutput>#getBranch.compbranch__nickname#</cfoutput></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12" type="column" index="6" sort="true">
                            <div class="form-group" id="item-compbranch_address">
                                <label class="col col-2 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
                                <div class="col col-10 col-xs-12">
                                    <textarea name="compbranch_address" id="compbranch_address" style="width:160px;height:70px;"><cfoutput>#getBranch.compbranch_address#</cfoutput></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row formContentFooter" type="row">
                        <div class="col col-6" type="column" index="7" sort="true">
                            <div class="form-group">
                                <div class="col col-12">
                                    <cfoutput>
                                        <cf_get_lang_main no='71.Kayıt'> :
                                        <cfif len(getBranch.record_member)>#get_emp_info(getBranch.record_member,0,0)# - </cfif>
                                        <cfif len(getBranch.record_par)> #get_par_info(getBranch.record_par,0,-1,0)# - </cfif>
                                        #dateformat(getBranch.record_date,"dd/mm/yyyy")#
                                        <cfif len(getBranch.update_member) or len(getBranch.update_par)>
                                        <br/><cf_get_lang_main no='291.Son Güncelleme'> :
                                            <cfif len(getBranch.update_member)> #get_emp_info(getBranch.update_member,0,0)# - </cfif>
                                            <cfif len(getBranch.update_par)> #get_par_info(getBranch.update_par,0,-1,0)# - </cfif>
                                            #dateformat(getBranch.update_date,'dd/mm/yyyy')#
                                        </cfif>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6" type="column" index="8" sort="true">
                            <div class="form-group">
                                <div class="col col-12">
                                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    
    </cfform>
    <script type="text/javascript">
    var country_= document.getElementById('country').value;
    <cfif not len(getBranch.city_id)>
        if(country_.length)
            LoadCity(country_,'city_id','county_id');
    </cfif>
    
    var city_= document.getElementById('city_id').value;
    <cfif not len(getBranch.county_id)>
        if(city_.length)
            LoadCounty(city_,'county_id');
    </cfif>
    
    function remove_adress(parametre)
    {
        if(parametre==1)
        {
            document.getElementById('city_id').value = '';
            document.getElementById('city').value = '';
            document.getElementById('county_id').value = '';
            document.getElementById('county').value = '';
            document.getElementById('compbranch_telcode').value = '';
        }
        else
        {
            document.getElementById('county_id').value = '';
            document.getElementById('county').value = '';
        }	
    }
    
    function kontrol()
    {
        x = (100 - document.getElementById('compbranch_address').value.length);
        if ( x < 0 )
        { 
            alert ("<cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
            return false;
        }
        
        y = (50 - document.getElementById('compbranch__nickname').value.length);
        if ( y < 0 )
        { 
            alert ("<cf_get_lang_main no ='217.Açıklama'>"+ ((-1) * y) +" <cf_get_lang_main no='1741.Karakter Uzun '>!");
            return false;
        }
        if((document.getElementById('coordinate_1').value.length != "" && document.getElementById('coordinate_2').value.length == "") || (document.getElementById('coordinate_1').value.length == "" && document.getElementById('coordinate_2').value.length != ""))
        {
            alert ("Lütfen koordinat değerlerini eksiksiz giriniz!");
            return false;
        }
        return true;
        
    }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->﻿
    