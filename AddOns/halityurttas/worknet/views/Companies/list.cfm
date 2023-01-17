<cfinclude template="../../config.cfm">
<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_potential" default="">
    <cfparam name="attributes.company_status" default="1">
    <cfparam name="attributes.company_stage" default="">
    <cfparam name="attributes.sector" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.companycat_id" default="">
    <cfparam name="attributes.firm_type" default="">
    <cfparam name="attributes.country" default="">
    <cfparam name="attributes.city" default="">
    <cfparam name="attributes.county" default="">
    <cfparam name="attributes.is_related_company" default="">
    <cfparam name="attributes.logo_status" default="">
    <cfparam name="attributes.search_type" default="1">
    <cfparam name="attributes.sortfield" default="FULLNAME">
    <cfparam name="attributes.sortdir" default="asc">
    
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.Companies.member") />
    <cfset getProcess = objectResolver.resolveByRequest("#addonNS#.components.Common.process").getProcess(fuseaction:attributes.fuseaction)/>
    <cfif isdefined('attributes.form_submitted') AND attributes.search_type eq 1><!--- sirket --->
        <cfset getCompany = cmp.getCompany(
                keyword:attributes.keyword,
                sector:attributes.sector,
                product_cat:attributes.product_cat,
                companycat_id:attributes.companycat_id,
                country:attributes.country,
                city:attributes.city,
                county:attributes.county,
                is_related_company:attributes.is_related_company,
                logo_status:attributes.logo_status,
                company_stage:attributes.company_stage,
                is_potential:attributes.is_potential,
                firm_type:attributes.firm_type,
                sortfield:attributes.sortfield,
                sortdir:attributes.sortdir,
                company_status:attributes.company_status
        ) />
            <cfset getCompanyMember.recordcount = 0>
    <cfelseif isdefined('attributes.form_submitted') AND attributes.search_type eq 0 ><!--- calisan --->
        <cfset getCompanyMember = cmp.getPartner(
                keyword:attributes.keyword,
                product_cat:attributes.product_cat,
                partner_country:attributes.country,
                partner_city:attributes.city,
                partner_county:attributes.county,
                sector:attributes.sector,
                companycat_id:attributes.companycat_id,
                logo_status:attributes.logo_status,
                company_stage:attributes.company_stage,
                is_potential:attributes.is_potential,
                is_related_company:attributes.is_related_company,
                firm_type:attributes.firm_type
        ) />
       <cfset getCompany.recordcount = 0>
    <cfelse>
        <cfset getCompany.recordcount = 0>
        <cfset getCompanyMember.recordcount = 0>
    </cfif>
    <cfif isdefined('attributes.form_submitted') AND attributes.search_type eq 1>
        <cfparam name="attributes.totalrecords" default="#getCompany.recordcount#">
     <cfelse>
        <cfparam name="attributes.totalrecords" default="#getCompanyMember.recordcount#">
    </cfif>
    <cfform name="search_member" action="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list']['fuseaction']#" method="post"> 
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
        <cf_big_list_search title="#getLang('main',5)#">
            <cf_big_list_search_area>
                <div class="row">
                    <div class="col col-12 form-inline">
                        <div class="form-group">
                            <div class="input-group x-10">
                                <cfsavecontent variable="form_filtre"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                                <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:117px;" placeholder="#form_filtre#">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group x-10">
                                <!--- Kategori --->
                                <cfsavecontent variable="text"><cf_get_lang_main no='74.Kategori'></cfsavecontent>
                                    <cfif len(attributes.companycat_id)><cfset attributes.companycat_id = attributes.companycat_id><cfelse><cfset attributes.companycat_id = ''></cfif>
                                    <cf_wrk_MemberCat
                                        name="companycat_id"
                                        option_text="#text#"
                                        comp_cons=1 value="#attributes.companycat_id#" width="110">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group x-10">
                                <!--- Asama --->
                                <select name="company_stage" id="company_stage" style="width:110px;">
                                    <option value=""><cf_get_lang_main no='70.Aşama'></option>
                                    <cfoutput query="getProcess">
                                        <option value="#process_row_id#" <cfif attributes.company_stage eq process_row_id>selected</cfif>>#stage#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group x-10">
                                <!--- Aktif/Pasif Durumu --->
                                <select name="company_status" id="company_status" style="width:110px;">
                                    <option value=""><cf_get_lang_main no ='344.Durum'></option>
                                    <option value="1" <cfif attributes.company_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
                                    <option value="0" <cfif attributes.company_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group x-10">
                                <!--- Sektor --->
                                <cfsavecontent variable="text"><cf_get_lang_main no='167.Sektör'></cfsavecontent>
                                <cfif len(attributes.sector)><cfset attributes.sector = attributes.sector><cfelse><cfset attributes.sector = ''></cfif>
                                <cf_wrk_selectlang 
                                    name="sector"
                                    option_name="sector_cat"
                                    option_value="sector_cat_id"
                                    width="120"
                                    table_name="SETUP_SECTOR_CATS"
                                    option_text="#text#" value="#attributes.sector#">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group x-10">
                                <!--- Potansiyel/Cari --->
                                <select name="is_potential" id="is_potential" style="width:66px">
                                    <option value=""><cf_get_lang_main no ='296.Tumu'></option>
                                    <option value="1" <cfif attributes.is_potential eq 1>selected</cfif>><cf_get_lang_main no='165.Potansiyel'></option>
                                    <option value="0" <cfif attributes.is_potential eq 0>selected</cfif>><cf_get_lang_main no ='649.Cari'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group x-10">
                                <span style="display:inline-block; padding-top:5px"><cf_get_lang no='421.Bağlı Üye'></span><input type="checkbox" name="is_related_company" id="is_related_company" value="1" <cfif isdefined('attributes.is_related_company') and attributes.is_related_company eq 1>checked</cfif>>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group x-10">
                                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px; text-align:center;">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <cf_wrk_search_button search_function='input_control()'>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_big_list_search_area>
            <cf_big_list_search_detail_area>
                <div id="detail_search_div" style="display: table-row;"></div>
                    <div class="row">
                        <div class="col col-12 uniqueRow">
                            <div class="row" type="row">
                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                    
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12">Ülke</label>
                                        <div class="col col-8 col-xs-12">
                                            <!--- Ulke--->
                                            <cfset getCountry = cmp.getCountry() />
                                            <select name="country" id="country" style="width:110px;" onChange="change_city();">
                                                <option value="">Seçiniz</option>
                                                <cfoutput query="getCountry">
                                                    <option value="#country_id#" <cfif attributes.country eq country_id>selected</cfif>>#country_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12">Şehir</label>
                                        <div class="col col-8 col-xs-12">
                                            <!--- Sehir --->
                                            <cfset getCity = cmp.getCity(country:attributes.country) />
                                            <select name="city" id="city" style="width:110px;" onChange="change_county();">
                                                <option value="">Seçiniz</option>
                                                <cfoutput query="getCity">
                                                    <option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12">İlçe</label>
                                        <div class="col col-8 col-xs-12">
                                            <!--- Ilce --->
                                            <cfset getCounty = cmp.getCounty(city:attributes.city) />
                                            <select name="county" id="county" style="width:110px;">
                                                <option value="">Seçiniz</option>
                                                <cfoutput query="getCounty">
                                                    <option value="#county_id#" <cfif attributes.county eq county_id>selected</cfif>>#county_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1195.Firma'></label>
                                        <div class="col col-8 col-xs-12">
                                            <!--- Firma Tipi --->
                                            <cfsavecontent variable="form_firm_type"><cf_get_lang_main no='1195.Firma'></cfsavecontent>
                                                <cfif len(attributes.firm_type)><cfset attributes.firm_type = attributes.firm_type><cfelse><cfset attributes.firm_type = ''></cfif>
                                                    <cf_multiselect_check 
                                                        table_name="SETUP_FIRM_TYPE"  
                                                        name="firm_type"
                                                        width="115" 
                                                        option_name="firm_type" 
                                                        option_value="firm_type_id" value="#attributes.firm_type#">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12">Logo</label>
                                        <div class="col col-8 col-xs-12">
                                            <!--- Logo Durum --->
                                            <select name="logo_status" id="logo_status" style="width:120px;">
                                                <option value=""><cf_get_lang_main no ='296.Tumu'></option>
                                                <option value="1" <cfif attributes.logo_status eq 1>selected</cfif>><cf_get_lang_main no ='1225.Logo'><cf_get_lang_main no ='1152.Var'></option>
                                                <option value="0" <cfif attributes.logo_status eq 0>selected</cfif>><cf_get_lang_main no ='1225.Logo'><cf_get_lang_main no ='1134.Yok'></option>
                                            </select>   
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12">Arama Tipi</label>
                                        <div class="col col-8 col-xs-12">
                                            <!--- Arama Tipi --->
                                            <select name="search_type" id="search_type"  style="width:66px;">
                                                <option value="1" <cfif attributes.search_type eq 1>selected</cfif>><cf_get_lang_main no ='162.Şirket'></option>
                                                <option value="0" <cfif attributes.search_type eq 0>selected</cfif>><cf_get_lang_main no ='164.Çalışan'></option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_big_list_search_detail_area>
        </cf_big_list_search>
    </cfform>
    
    <cf_big_list>
        <cfset add_fuseaction="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['add']['fuseaction']#">
        <cfset upd_fuseaction="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['det']['fuseaction']#">
        <cfif getCompany.recordcount>
            <thead>
                <tr>
                    <th><cf_get_lang_main no='75.No'></th>
                    <th><cf_get_lang_main no ='1225.Logo'></th>
                    <th><cf_get_lang_main no='162.Şirket'></th>
                    <th><cf_get_lang_main no='166.Yetkili'></th>
                    <th><cf_get_lang_main no='162.Şirket'><cf_get_lang_main no='168.Büyüklük'></th>
                    <th><cf_get_lang_main no='1896.Sertifikalar'></th>
                    <th><cf_get_lang_main no='1196.İl'></th>
                    <th><cf_get_lang_main no='1226.İlçe'></th>
                    <th><cf_get_lang_main no='731.İletişim'></th>
                    <th class="header_icn_none"><a href="<cfoutput>#add_fuseaction#</cfoutput>" title="<cf_get_lang_main no='170.Ekle'>"> <img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>"></a></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="getCompany" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td>#currentrow#</td>
                        <td style="text-align:center; width:50px; height:40px;">
                            <cfif len(ASSET_FILE_NAME1)>
                                <cf_get_server_file output_file="member/#ASSET_FILE_NAME1#" output_server="#ASSET_FILE_NAME1_SERVER_ID#" output_type="0" image_width="50">
                            <cfelse>
                                <img src="/images/no_photo.gif" width="50" height="50">
                            </cfif>
                        </td>
                        <td><a href="#upd_fuseaction##company_id#" class="tableyazi">#fullname#</a></td>
                        <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_partner&pid=#manager_partner_id#" class="tableyazi">#MANAGER_PARTNER#</a></td>
                        <td>#company_size_cat#</td>
                        <td><cfset getReqType = cmp.getReqType(company_id:company_id) />#getReqType.liste_name#</td>
                        <td>#CITY_NAME#</td>
                        <td>#COUNTY_NAME#</td>
                        <td>#homepage#</td>
                        <td width="15"><a href="#upd_fuseaction##company_id#" title="<cf_get_lang_main no='52.Güncelle'>"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>"></a></td>
                    </tr>
                </cfoutput>
            </tbody>
        <cfelseif getCompanyMember.recordcount>
            <thead>
                <tr>
                    <th><cf_get_lang_main no='75.No'></th>
                    <th><cf_get_lang_main no='164.Çalışan'></th>
                    <th><cf_get_lang_main no='162.Şirket'></th>
                    <th><cf_get_lang_main no='161.Görev'></th>
                    <th><cf_get_lang_main no='160.Departman'></th>
                    <th><cf_get_lang_main no='731.İletişim'></th>
                    <th class="header_icn_none"><a href="<cfoutput>#add_fuseaction#</cfoutput>" title="<cf_get_lang_main no='170.Ekle'>"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>"></a></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="getCompanyMember" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_partner&pid=#partner_id#" class="tableyazi" >#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a></td>
                        <td><a href="#upd_fuseaction##COMPANY_ID#" class="tableyazi" >#FULLNAME#</a></td>
                        <td>#PARTNER_POSITION#</td>
                        <td><cfif Len(department)>#PARTNER_DEPARTMENT#</cfif></td>
                        <td><cfif len(COMPANY_PARTNER_EMAIL)>
                                <a href="mailto:#COMPANY_PARTNER_EMAIL#"><img src="/images/mail.gif"  title="<cf_get_lang_main no='16.E-mail'>:#COMPANY_PARTNER_EMAIL#" border="0"></a>
                            </cfif>
                            <cfif len(COMPANY_PARTNER_TEL)>
                                &nbsp;<img src="/images/tel.gif" title="<cf_get_lang_main no='87.Telefon'>:#COMPANY_PARTNER_TELCODE# - #COMPANY_PARTNER_TEL# <cfif len(company_partner_tel_ext)>(#COMPANY_PARTNER_TEL_EXT#)</cfif>" border="0">
                            </cfif>
                            <cfif len(COMPANY_PARTNER_FAX)>
                                &nbsp;<img src="/images/fax.gif" title="<cf_get_lang_main no='76.Fax'>:#COMPANY_PARTNER_TELCODE# - #COMPANY_PARTNER_FAX#" border="0">
                            </cfif>
                            <cfif len(MOBILTEL)><img src="/images/mobil.gif"  title="<cf_get_lang no='116.Kod/Mobil Tel'>:#MOBIL_CODE# - #MOBILTEL#" border="0"></cfif>
                        </td>
                        <td width="15"><a href="#upd_fuseaction##company_id##partner_id#" title="<cf_get_lang_main no='52.Güncelle'>"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>"></a></td>
                    </tr>
                </cfoutput>
            </tbody>
        <cfelse>
            <thead>
                <tr>
                    <th><cf_get_lang_main no='75.No'></th>
                    <th><cf_get_lang_main no ='1225.Logo'></th>
                    <th><cf_get_lang_main no='162.Şirket'></th>
                    <th><cf_get_lang_main no='166.Yetkili'></th>
                    <th><cf_get_lang_main no='162.Şirket'><cf_get_lang_main no='168.Büyüklük'></th>
                    <th><cf_get_lang_main no='1896.Sertifikalar'></th>
                    <th><cf_get_lang_main no='1196.İl'></th>
                    <th><cf_get_lang_main no='1226.İlçe'></th>
                    <th><cf_get_lang_main no='731.İletişim'></th>
                    <th class="header_icn_none"><a href="<cfoutput>#add_fuseaction#</cfoutput>" title="<cf_get_lang_main no='170.Ekle'>"> <img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>"></a></th>
                </tr>
            </thead>
            <tbody>
                <tr class="worknet-row " height="25">
                    <td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
                </tr>
            </tbody>
        </cfif>
    </cf_big_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfset url_str = "">
        <cfif isDefined("attributes.form_submitted")>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.firm_type)>
            <cfset url_str = "#url_str#&firm_type=#attributes.firm_type#">
        </cfif>
        <cfif len(attributes.sector)>
            <cfset url_str = "#url_str#&sector=#attributes.sector#">
        </cfif>
        <cfif len(attributes.companycat_id)>
            <cfset url_str = "#url_str#&companycat_id=#attributes.companycat_id#">
        </cfif>
        <cfif len(attributes.company_status)>
            <cfset url_str = "#url_str#&company_status=#attributes.company_status#">
        </cfif>
        <cfif len(attributes.is_potential)>
            <cfset url_str = "#url_str#&is_potential=#attributes.is_potential#">
        </cfif>
        <cfif len(attributes.company_stage)>
            <cfset url_str = "#url_str#&company_stage=#attributes.company_stage#">
        </cfif>
        <cfif len(attributes.country)>
            <cfset url_str = "#url_str#&country=#attributes.country#">
        </cfif>
        <cfif len(attributes.city)>
            <cfset url_str = "#url_str#&city=#attributes.city#">
        </cfif>
        <cfif len(attributes.county)>
            <cfset url_str = "#url_str#&county=#attributes.county#">
        </cfif>
        <cfif len(attributes.is_related_company)>
            <cfset url_str = "#url_str#&is_related_company=#attributes.is_related_company#">
        </cfif>
        <cfif len(attributes.logo_status)>
            <cfset url_str = "#url_str#&logo_status=#attributes.logo_status#">
        </cfif>
        <cfif len(attributes.search_type eq 0)>
            <cfset url_str = "#url_str#&search_type=#attributes.search_type#">
        </cfif>
        <table cellpadding="0" cellspacing="0" width="98%" align="center" height="35">
            <tr>
                <td>
                  <cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#listgetat(attributes.fuseaction,1,'.')#.list_company#url_str#">
                <td style="text-align:right;"><cfoutput><cf_get_lang_main no ='128.Toplam Kayıt'>:<cfif attributes.search_type eq 1>#getCompany.recordcount#&nbsp;-&nbsp;<cfelse>#getCompanyMember.recordcount#&nbsp;-&nbsp;</cfif><cf_get_lang_main no ='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td>
            </tr>
        </table>
    </cfif>
    
    <script type="text/javascript">
        function input_control() {
            return true;
        }
        function change_city()
        {
            var country_ = document.getElementById("country").value;
            if(country_.length)
                LoadCity(country_,'city','county',0);
        }
        function change_county()
        {
            var city_ = document.getElementById("city").value;
            if(city_.length)
                LoadCounty(city_,'county');
        }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    