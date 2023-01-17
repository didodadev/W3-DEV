<cf_xml_page_edit fuseact="member.detail_partner">
    <cfinclude template="../../config.cfm">
    <cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
    <cfif not isdefined('attributes.compid') and isdefined('session.pp')>
        <cfset attributes.compid = session.pp.company_id>
    </cfif>
    
    <cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.companies.member") />
    <cfset getCompany = cmp.getCompany(company_id:attributes.compid) />
    <!---<cfset getMobilcat = cmp.getMobilcat() />--->
    <cfset getCountry = cmp.getCountry() />
    <cfset getPartnerPositions = cmp.getPartnerPositions() />
    <cfset getPartnerDepartments = cmp.getPartnerDepartments() />
    <cfset getLanguage = cmp.getLanguage() />
    <cfset getCompanyBranch = cmp.getCompanyBranch(company_id:attributes.compid) />
    
    <cfset pageHead="Partner Ekle: #getCompany.fullname#">
    <cf_catalystHeader>
    <div class="row">
        <div class="col col-12 uniqueRow" id="content">
            <cfform name="add_partner" enctype="multipart/form-data" method="post">
                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.compid#</cfoutput>">
                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cf_get_lang no="4.Kullanıcı Bilgileri"></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                        <div class="form-group" id="item-nameless">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='219.Ad'>*</label>
                                            <div class="col col-8 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'></cfsavecontent>
                                                <cfinput type="text" name="nameless" id="nameless" required="yes" message="#message#" maxlength="20" style="width:150px;">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-sex">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='352.Cinsiyet'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="sex" id="sex" style="width:155px;">
                                                    <option value="1"><cf_get_lang_main no='1547.Erkek'>
                                                    <option value="2"><cf_get_lang_main no='1546.Kadın'>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-username">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='139.Kullanıcı Ad'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="username" id="username" maxlength="50" style="width:150px;">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                        <div class="form-group" id="item-soyad">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1314.Soyad'>*</label>
                                            <div class="col col-8 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad'></cfsavecontent>
                                                <cfinput type="text" name="soyad" id="soyad" required="yes" message="#message#" maxlength="20" style="width:150px;">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-title">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='159.Ünvan'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="title" id="title" maxlength="50" style="width:150px;">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-password">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='140.Şifre'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="Password" name="password" id="password" style="width:150px;" maxlength="16">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                        <div class="form-group" id="item-tc_identity">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='613.TC Kimlik No'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="0" width_info='150' is_verify='0' consumer_name='name' consumer_surname='soyad' birth_date='birthdate'>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-mission">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='161.Görev'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="mission" id="mission" style="width:155px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="getPartnerPositions">
                                                        <option value="#partner_position_id#">#partner_position#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-language_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1584.Dil'>*</label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="language_id" id="language_id" style="width:155px;">
                                                <cfoutput query="getLanguage">
                                                    <option value="#language_short#">#language_set#</option>
                                                </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                        <div class="form-group" id="item-birthdate">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1315.Doğum Tarihi'></label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfinput type="text" name="birthdate" id="birthdate" maxlength="10" validate="eurodate" style="width:65px;" tabindex="5">
                                                    <div class="input-group-addon">
                                                        <cf_wrk_date_image date_field="birthdate">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-department">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="department" id="department" style="width:155px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="getPartnerDepartments">
                                                        <option value="#partner_department_id#">#partner_department#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-photo">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no='125.Fotoğraf Ekle'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="file" name="photo" id="photo" style="width:155px;">
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
                        <span><cf_get_lang_main no='731.İletişim'></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                            <div class="form-group" id="item-compbranch_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="compbranch_id" id="compbranch_id" style="width:155px;" onChange="kontrol_et(this.value);">
                                        <option value="0"><cf_get_lang no='181.Merkez Ofis'> 
                                        <cfoutput query="getCompanyBranch">
                                            <option value="#compbranch_id#">#compbranch__name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-mobiltel">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='116.Kod /Mobil Tel'></label>
                                <div class="col col-3">
                                    <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:55px;">
                                </div>
                                <div class="col col-5">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='116.gsm No !'></cfsavecontent>
                                    <cfinput type="text" name="mobiltel" id="mobiltel" value="" validate="integer" message="#message#" maxlength="10" style="width:86px;">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
                            <div class="form-group" id="item-email">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='16.e-mail'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="mesaj"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
                                    <cfinput type="text" name="email" id="email" maxlength="100" validate="email" message="#mesaj#" style="width:150px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-fax">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Fax'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='107.Fax No !'></cfsavecontent>
                                    <cfinput type="text" name="fax" id="fax" value="#getCompany.company_fax#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="7" sort="true">
                            <div class="form-group" id="item-tel">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='36. Kod/ Telefon'></label>
                                <div class="col col-3">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='36.Kod/Telefon!'></cfsavecontent>
                                    <cfinput type="text" name="telcod" id="telcod" value="#getCompany.company_telcode#" validate="integer" message="#message#" maxlength="6" style="width:55px;">
                                </div>
                                <div class="col col-5">
                                    <cfinput type="text" name="tel" id="tel" value="#getCompany.company_tel1#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-homepage">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='41.İnternet'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="homepage" id="homepage" value="<cfoutput>#getCompany.homepage#</cfoutput>" maxlength="50" style="width:150px;">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="8" sort="true">
                            <div class="form-group" id="item-tel_local">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='121.Dahili'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='121.dahili !'></cfsavecontent>
                                    <cfinput type="text" name="tel_local" id="tel_local" validate="integer" message="#message#" maxlength="5" style="width:86px;">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cf_get_lang_main no='1311.Adres'></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="9" sort="true">
                                        <div class="form-group" id="item-country">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='807.Ülke'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="country" id="country" style="width:155px;" onChange="LoadCity(this.value,'city_id','county_id',0)">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="getCountry">
                                                        <option value="#country_id#" <cfif getCompany.country eq country_id>selected</cfif>>#country_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-postcod">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="postcod" id="postcod" style="width:150px;" maxlength="15" value="<cfoutput>#getCompany.company_postcode#</cfoutput>">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="10" sort="true">
                                        <div class="form-group" id="item-city_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="city_id" id="city_id" style="width:155px;" onChange="LoadCounty(this.value,'county_id','telcod')">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfquery name="GET_CITY" datasource="#DSN#">
                                                        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(getCompany.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCompany.country#"></cfif>
                                                    </cfquery>
                                                    <cfoutput query="GET_CITY">
                                                        <option value="#city_id#" <cfif getCompany.city eq city_id>selected</cfif>>#city_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="11" sort="true">
                                        <div class="form-group" id="item-county_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1226.Ilce'></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="county_id" id="county_id" style="width:155px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfquery name="GET_COUNTY" datasource="#DSN#">
                                                        SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(getCompany.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCompany.city#"></cfif>
                                                    </cfquery>
                                                    <cfoutput query="get_county">
                                                        <option value="#county_id#" <cfif getCompany.county eq county_id>selected</cfif>>#county_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="12" sort="true">
                                        <div class="form-group" id="item-semt">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='720.Semt'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="semt" id="semt" value="<cfoutput>#getCompany.semt#</cfoutput>" maxlength="45" style="width:150px;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="13" sort="true">
                                        <div class="form-group" id="item-adres">
                                            <label class="col col-2 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
                                            <div class="col col-10 col-xs-12">
                                                <textarea name="adres" id="adres" style="width:150px; height:65px;" ><cfoutput>#getCompany.company_address#</cfoutput></textarea>
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
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfform>
        </div>
    </div>
    
    <script type="text/javascript">
    var is_tc_number = 1;
    function remove_adress(parametre)
    {
        if(parametre==1)
        {
            document.getElementById('city_id').value = '';
            document.getElementById('county_id').value = '';
            document.getElementById('telcod').value = '';
        }
        else
        {
            document.getElementById('county_id').value = '';
        }	
    }
    
    function kontrol_et(compbranch_id)
    {
        if(compbranch_id == 0)
        {
            get_comp_branch = wrk_safe_query("mr_get_comp_branch","dsn",0,document.getElementById('company_id').value);
            if(get_comp_branch.COUNTRY != '')
            {
                document.getElementById('country').value = get_comp_branch.COUNTRY;
                LoadCity(get_comp_branch.COUNTRY,'city_id','county_id',0);
            }
            else
                document.getElementById('country').value = '';
            if(get_comp_branch.CITY != '')
            {
                document.getElementById('city_id').value = get_comp_branch.CITY;
                LoadCounty(get_comp_branch.CITY,'county_id');
            }
            else
                document.getElementById('city_id').value = '';
            if(get_comp_branch.COUNTY != '')
                document.getElementById('county_id').value = get_comp_branch.COUNTY;
            else
                document.getElementById('county_id').value = '';	
            if(get_comp_branch.COMPANY_ADDRESS != '')
                document.getElementById('adres').value = get_comp_branch.COMPANY_ADDRESS;
            else
                document.getElementById('adres').value = '';
            if(get_comp_branch.COMPANY_POSTCODE != '')
                document.getElementById('postcod').value = get_comp_branch.COMPANY_POSTCODE;
            else
                document.getElementById('postcod').value = '';
            if(get_comp_branch.SEMT != '')
                document.getElementById('semt').value = get_comp_branch.SEMT;
            else
                document.getElementById('semt').value = '';
            if(get_comp_branch.COMPANY_TELCODE != '')
                document.getElementById('telcod').value = get_comp_branch.COMPANY_TELCODE;
            else
                document.getElementById('telcod').value = '';
            if(get_comp_branch.COMPANY_TEL1 != '')
                document.getElementById('tel').value = get_comp_branch.COMPANY_TEL1;
            else
                document.getElementById('tel').value = '';
            if(get_comp_branch.COMPANY_FAX != '')
                document.getElementById('fax').value = get_comp_branch.COMPANY_FAX;
            else
                document.getElementById('fax').value = '';
        }
        else
        {
            getCompany_branch = wrk_safe_query("mr_get_company_branch","dsn",0,compbranch_id);
            if(getCompany_branch.COUNTRY_ID != '')
            {
                document.getElementById('country').value = getCompany_branch.COUNTRY_ID;
                LoadCity(getCompany_branch.COUNTRY_ID,'city_id','county_id',0);
            }
            else
                document.getElementById('country').value = '';
            if(getCompany_branch.CITY_ID != '')
            {
                document.getElementById('city_id').value = getCompany_branch.CITY_ID;
                LoadCounty(getCompany_branch.CITY_ID,'county_id',0);
            }
            else
                document.getElementById('city_id').value = '';
            if(getCompany_branch.COUNTY_ID != '')
                document.getElementById('county_id').value = getCompany_branch.COUNTY_ID;
            else
                document.getElementById('county_id').value = '';	
            if(getCompany_branch.COMPBRANCH_ADDRESS != '')
                document.getElementById('adres').value = getCompany_branch.COMPBRANCH_ADDRESS;
            else
                document.getElementById('adres').value = '';
            if(getCompany_branch.COMPBRANCH_POSTCODE != '')
                document.getElementById('postcod').value = getCompany_branch.COMPBRANCH_POSTCODE;
            else
                document.getElementById('postcod').value = '';
            if(getCompany_branch.SEMT != '')
                document.getElementById('semt').value = getCompany_branch.SEMT;
            else
                document.getElementById('semt').value = getCompany_branch.SEMT;
            if(getCompany_branch.COMPBRANCH_TELCODE != '')
                document.getElementById('telcod').value = getCompany_branch.COMPBRANCH_TELCODE;
            else
                document.getElementById('telcod').value = '';
            if(getCompany_branch.COMPBRANCH_TEL1 != '')
                document.getElementById('tel').value = getCompany_branch.COMPBRANCH_TEL1;
            else
                document.getElementById('tel').value = '';
            if(getCompany_branch.COMPBRANCH_FAX != '')
                document.getElementById('fax').value = getCompany_branch.COMPBRANCH_FAX;
            else
                document.getElementById('fax').value = '';
        }
    }	
    
    function kontrol ()
    {	
        if(document.getElementById('tc_identity').value != "")
        {
            if(!isTCNUMBER(document.getElementById('tc_identity'))) return false;
            if(document.getElementById('tc_identity').value.length != 11)
                {
                    alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='436.TC Kimlik Numarası - 11 Hane'> !");
                    return false;
                }
        }
        x = document.getElementById('language_id').selectedIndex;
        if (document.add_partner.language_id[x].value == "")
        { 
            alert ("<cf_get_lang no='195.Kullanıcı İçin Dil Seçmediniz !'>");
            return false;
        }
    
        x = (100 - document.getElementById('adres').value.length);
        if ( x < 0)
        { 
            alert ("<cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
            return false;
        }
        
        y = (document.getElementById('password').value.length);
        if ((document.getElementById('password').value != '')  && ( y < 4 ))
        { 
            alert ("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='196.Şifre-En Az Dört Karakter'>");
            return false;
        }
        
        var obj =  document.getElementById('photo').value;
        if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4) == 'gif').toLowerCase() || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
        {
            alert("<cf_get_lang no='197.Lütfen bir resim dosyası(gif,jpg veya png) giriniz!!'>");        
            return false;
        }	
        
        if (confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz, Lütfen yeni kullanıcı kaydını onaylayın!'>")) return true; else return false;
    }
    document.getElementById('name').focus();
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    