<cfif isdefined("get_company.manager_partner_id") and len(get_company.manager_partner_id)>
    <cfset get_tc = company_cmp.get_tc(manager_partner_id:get_company.manager_partner_id)>
</cfif>
<cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
<cfset get_api_key = googleapi.get_api_key()>
<!--- Kurumsal Üye Detayı ch--->
<cf_box id="detail_accounts" title="#getLang('','Üye Detay',41230)#">
    <cfoutput>
    	<div id="unique_companyMain" itemTitle="<cfoutput>#getLang('','Kurumsal Hesaplar',47167)#</cfoutput>">
            <cfform name="form_upd_company" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_company" enctype="multipart/form-data">
                <input type="hidden" name="page_warning_value" id="page_warning_value" value="0">
                <input type="hidden" name="is_auto_fill" id="is_auto_fill" value="<cfif isdefined('x_is_auto_fill_user_friendly') and x_is_auto_fill_user_friendly eq 1>1<cfelse>0</cfif>">
                <input type="hidden" name="xml_upd_par_address" id="xml_upd_par_address" value="#xml_upd_par_address#">
                <input type="hidden" name="x_is_off_same_records" id="x_is_off_same_records" value="#x_is_off_same_records#" />
                <input type="hidden" name="company_id" id="company_id" value="#attributes.cpid#" />
                <cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true"> 
                        <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-company_status">  
                            <label class="col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="company_status" id="company_status" value="1" tabindex="4" <cfif get_company.company_status is 1>checked</cfif>></label>
                        </div>  
                        <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_buyer">     
                            <label class="col-xs-12"><cf_get_lang dictionary_id='58733.Alıcı'><input type="checkbox" name="is_buyer" id="is_buyer" value="1" tabindex="2" <cfif len(get_company.is_buyer) and get_company.is_buyer> checked</cfif>></label>
                        </div>                               
                        <div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="item-is_seller">  
                            <label class="col-xs-12"><cf_get_lang dictionary_id='58873.Satıcı'><input type="checkbox" name="is_seller" id="is_seller" value="1" tabindex="3" <cfif len(get_company.is_seller) and get_company.is_seller> checked</cfif>></label>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-ispotantial">      
                            <label class="col-xs-12"><cf_get_lang dictionary_id='57577.Potansiyel'><input type="checkbox" name="ispotantial" id="ispotantial" value="1" tabindex="5" <cfif get_company.ispotantial is 1>checked</cfif>></label>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_person">    
                            <label class="col-xs-12"><cf_get_lang dictionary_id='30354.Şahıs'><input type="checkbox" name="is_person" id="is_person" value="1" tabindex="2" <cfif len(get_company.is_person) and get_company.is_person> checked</cfif>></label>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_related_company">    
                            <label class="col-xs-12"><cf_get_lang dictionary_id='30559.Bağlı Üye'><input type="checkbox" name="is_related_company" id="is_related_company" value="1" tabindex="6" <cfif get_company.is_related_company is 1>checked</cfif>></label>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_civil_company">
                            <label class="col-xs-12"><cf_get_lang dictionary_id='41536.Kamu'> <input type="checkbox" name="is_civil" id="is_civil" value="1" tabindex="7" <cfif get_company.is_civil_company is 1>checked</cfif>></label>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-member_code">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57487.No'></label>
                            <div class="col col-8 col-sm-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57487.No'></cfsavecontent>
                                <input type="text" name="member_code" id="member_code" value="#get_company.member_code#" required="yes" message="#message#" maxlength="50" tabindex="1">
                            </div>                
                        </div>
                        <div class="form-group" id="item-fullname">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57571.Ünvan'>*</label>
                            <div class="col col-8 col-sm-12">
                                <input type="hidden" name="old_fullname" id="old_fullname" value="#get_company.fullname#">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30314.Şirket Ünvanı'></cfsavecontent>
                                <input type="text" name="fullname" value="#get_company.fullname#"required="yes" message="#message#" maxlength="250">
                            </div>                
                        </div>
                        <div class="form-group" id="item-nickname">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57751.Kısa Ad'></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="nickname" value="#get_company.nickname#" maxlength="60">
                            </div>                
                        </div>	
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                            <div class="col col-8 col-sm-12">
                                <cf_workcube_process is_upd='0' select_value = '#get_company.company_state#' process_cat_width='150' is_detail='1'>
                            </div>                
                        </div>
                        <div class="form-group" id="item-companycat_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                            <div class="col col-8 col-sm-12">
                                <cf_wrk_membercat
                                    name="companycat_id"
                                    value="#get_company.companycat_id#"
                                    comp_cons=1>
                            </div>                
                        </div>
                        <cfif x_is_upper_sector eq 0>
                            <cfset get_sector_id = company_cmp.get_sector_id(cpid:attributes.cpid)>
                            <div class="form-group" id="item-sector_cat_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_multiselect_check
                                            name="sector_cat_id"
                                            table_name="SETUP_SECTOR_CATS"
                                            option_name="SECTOR_CAT"
                                            option_value="SECTOR_CAT_ID"
                                            value="#valuelist(get_sector_id.sector_id)#"
                                            sort_type="SECTOR_CAT">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-manager_partner_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30367.Yönetici'></label>
                            <div class="col col-8 col-sm-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57751.Kisa Ad'></cfsavecontent>
                                <select name="manager_partner_id" id="manager_partner_id" tabindex="12" onchange="getTc();">
                                    <cfloop query="get_partner_">
                                        <option value="#get_partner_.partner_id#" <cfif get_partner_.partner_id is get_company.manager_partner_id>selected</cfif>>#get_partner_.company_partner_name# #get_partner_.company_partner_surname#</option>
                                    </cfloop>
                                </select>
                            </div>                
                        </div>
                        <div class="form-group" id="item-tckimlikno">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
                            <div class="col col-8 col-sm-12">
                                <cfif isdefined('get_tc.tc_identity') and len(get_tc.tc_identity)>
                                    <cfset tckimlikno_= get_tc.tc_identity>
                                <cfelse>
                                    <cfset tckimlikno_= ''>
                                </cfif>
                                <cf_duxi type="text" name="tckimlikno" id="tckimlikno" value="#tckimlikno_#" hint="TC Kimlik No" gdpr="2"  maxlength="50" data_control="isnumber">
                            </div>                
                        </div>
                        <cfif isdefined("attributes.type")>            
                            <div class="form-group" id="item-type">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30723.Hedef Kodu'></label>
                                <div class="col col-8 col-sm-12">
                                    <input type="hidden" name="type" id="type" value="#attributes.type#">
                                    #get_company.company_id#
                                </div>                
                            </div>
                            <div class="form-group" id="item-glncode">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30725.GLN Kodu'></label>
                                <div class="col col-8 col-sm-12">
                                    <input type="text" name="glncode" id="glncode" value="#get_company.glncode#" maxlength="13" onkeyup="isNumber(this);">
                                </div>                
                            </div>               
                        </cfif>

                        <cfif x_is_related_brands eq 1>
                            <div class="form-group" id="item-related_brand_id">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30182.İlişkili Markalar'> *</label>
                                <div class="col col-8 col-sm-12">
                                    <div class="input-group">
                                        <select name="related_brand_id" id="related_brand_id">
                                            <cfif getRelatedBrands.recordcount>
                                            <cfloop query="getRelatedBrands">
                                                <cfset getBrandName = company_cmp.getBrandName(related_brand_id:getRelatedBrands.related_brand_id, dsn1:dsn1)>
                                                <option value="#getRelatedBrands.related_brand_id#">#getBrandName.brand_name#</option>
                                            </cfloop>
                                        </cfif>
                                        </select>  
                                        <span class="input-group-addon">                       
                                            <i class="icon-pluss btnPointer show" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_brands&brand_name=form_upd_company.related_brand_id','medium');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                            <i class="icon-minus btnPointer show" onclick="remove_field('related_brand_id');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                        </span>
                                    </div>
                                </div>                
                            </div>
                        </cfif>

                        
                        <div id="display_div"></div>

                        <div class="form-group" id="item-company_address">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                            <div class="col col-8 col-sm-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='30749.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
                                <textarea name="company_address" id="company_address" message="#message#" maxlength="200" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);">#get_company.company_address#</textarea>
                            </div>                
                        </div>
                        <div class="form-group" id="item-homepage">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30179.İnternet'></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="homepage" id="homepage" maxlength="50" value="#get_company.homepage#">
                            </div>                
                        </div>
                        <div class="form-group" id="item-company_email">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57428.e-mail'></label>
                            <div class="col col-8 col-sm-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57428.E-mail'>!</cfsavecontent>
                                <input type="text" name="company_email" id="company_email" maxlength="100" value="#get_company.company_email#" validate="email" message="#message#">
                            </div>                
                        </div>
                        <div class="form-group" id="item-kep_address">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="company_kep_address" id="company_kep_address" maxlength="100" value="#get_company.company_kep_address#" validate="email" message="#message#">
                            </div>                
                        </div>
                        
                        <cfif len(get_company.country)>
                            <cfset get_country_phone = company_cmp.get_country_phone(country:get_company.country)>
                        </cfif>
                        <div class="form-group" id="item-company_telcode">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57499.Telefon'><label id="load_phone"><cfif Len(get_company.country) and Len(get_country_phone.country_phone_code)>(#get_country_phone.country_phone_code#)</cfif></label></label>
                            <div class="col col-4 col-sm-12">
                                <input type="text" name="company_telcode" onKeyUp="isNumber(this);" onBlur="isNumber(this);" value="#get_company.company_telcode#" maxlength="5">
                            </div>
                            <div class="col col-4 col-sm-12">
                                <input type="text" name="company_tel1" onKeyUp="isNumber(this);" onBlur="isNumber(this);" value="#get_company.company_tel1#" maxlength="10">
                            </div>                
                        </div>
                        <div class="form-group" id="item-company_tel2">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57499.Telefon'>2</label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="company_tel2" onKeyUp="isNumber(this);" onBlur="isNumber(this);" value="#get_company.company_tel2#" maxlength="10">
                            </div>                
                        </div>
                        <div class="form-group" id="item-company_tel3">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57499.Telefon'>3</label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="company_tel3" onKeyUp="isNumber(this);" onBlur="isNumber(this);" value="#get_company.company_tel3#" maxlength="10">
                            </div>                
                        </div>
                        <div class="form-group" id="item-company_fax">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57488.Fax'></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="company_fax" id="company_fax" onKeyUp="isNumber(this);" onBlur="isNumber(this);" value="#get_company.company_fax#" maxlength="10">
                            </div>                
                        </div>
                        <div class="form-group" id="item-mobilcat_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'></label>
                            <div class="col col-4 col-sm-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30254.Kod/ Mobil tel'></cfsavecontent>
                                <input type="text" name="mobilcat_id" id="mobilcat_id" value="#get_company.mobil_code#" maxlength="7" validate="integer" message="#message#">
                            </div>
                            <div class="col col-4 col-sm-12">                        
                                <input type="text" name="mobiltel" id="mobiltel" value="#get_company.mobiltel#" maxlength="10" validate="integer" message="#message#" tabindex="29">
                            </div>                
                        </div>
                        <cfif xml_upd_par_address eq 1>
                            <div class="form-group" id="item-upd_par_address">
                                <label class="col col-4 col-sm-12"></label>
                                <div class="col col-8 col-sm-12">
                                    <input type="checkbox" name="upd_par_address" id="upd_par_address" value="1"><cf_get_lang dictionary_id='30251.Tüm Çalışan Adresleri Güncellensin'>
                                </div>                
                            </div>
                        </cfif>

                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30448.Üyelik Başlama Tarihi'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30448.Üyelik Başlama Tarihi'> !</cfsavecontent>
                                    <input validate="#validate_style#" message="#message#" type="text" name="startdate" id="startdate" value="#dateformat(get_company.start_date,dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-organization_start_date">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30257.Kuruluş Tarihi'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30257.Kuruluş Tarihi'>!</cfsavecontent>
                                    <input type="text" name="organization_start_date" id="organization_start_date" value="#dateformat(get_company.org_start_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="organization_start_date"></span>
                                </div>
                            </div>     
                        </div>
                        <div class="form-group" id="item-hierarchy_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30171.Üst Şirket'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <cfif len(get_company.hierarchy_id)>
                                        <cfset GET_UPPER_COMPANY = company_cmp.GET_UPPER_COMPANY(hierarchy_id:get_company.hierarchy_id)>
                                    </cfif>
                                    <input type="hidden" name="hierarchy_id" id="hierarchy_id" value="#get_company.hierarchy_id#" />	
                                    <input type="text" name="hierarchy_company" id="hierarchy_company" onfocus="AutoComplete_Create('hierarchy_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,1,0','COMPANY_ID','hierarchy_id','','3','140');" value="<cfif isDefined("get_upper_company.fullname")>#get_upper_company.fullname#</cfif>"  maxlength="250" />
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&is_form_submitted=1&field_comp_id=form_upd_company.hierarchy_id&field_comp_name=form_upd_company.hierarchy_company<cfif fusebox.circuit is "store">&is_store_module=1</cfif>');return false"></span>
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-our_company_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30487.Grup Şirketi'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <input type="hidden" name="our_company_id" id="our_company_id" value="#get_company.our_company_id#">
                                    <cfif len(get_company.our_company_id)>
                                        <cfset attributes.comp_id = get_company.our_company_id>
                                        <cfset GET_OUR_COMPANY_NAME = company_cmp.GET_OUR_COMPANY_NAME(comp_id:attributes.comp_id)>
                                        <input type="text" name="our_company_name" id="our_company_name" value="#get_our_company_name.company_name#">
                                    <cfelse>
                                        <input type="text" name="our_company_name" id="our_company_name" tabindex="50">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_our_companies&field_id=form_upd_company.our_company_id&field_name=form_upd_company.our_company_name');return false"></span>                        
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-period_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30172.Muhasebe Dönemi'></label>
                            <div class="col col-8 col-sm-12">
                                <cfset periods = company_cmp.periods_company(cpid:attributes.cpid)>
                                <select name="period_id" id="" tabindex="52">
                                    <cfloop query="periods">
                                        <option value="#period_id#" <cfif len(get_company.period_id) and (get_company.period_id eq period_id)> selected</cfif>>#period#</option>
                                    </cfloop>
                                </select>
                            </div>                
                        </div>
                        <div class="form-group" id="item-resource">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
                            <div class="col col-8 col-sm-12">
                                <cf_wrk_combo 
                                    name="resource"
                                    query_name="GET_PARTNER_RESOURCE"
                                    value="#get_company.resource_id#"
                                    option_name="resource"
                                    option_value="resource_id"
                                    width="150">
                            </div>                
                        </div>
                        <cfif isdefined('x_is_off_same_records') and x_is_off_same_records eq 0>
                            <div class="form-group" id="item-user_friendly_url">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30253.Kullancı Dostu URL'></label>
                                <div class="col col-8 col-sm-12">
                                    <input type="text" name="user_friendly_url" id="user_friendly_url" value="<cfif get_user_url.recordcount>#get_user_url.user_friendly_url#</cfif>">
                                </div>                
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-12" type="column" index="3" sort="true">  
                        <!---<div class="form-group" id="item-use_earchive">
                            <cfif session.ep.our_company_info.is_earchive>                             
                                    <label>E-Arşiv<input type="checkbox" name="use_earchive" id="use_earchive" value="1" tabindex="2" <cfif get_company.use_earchive is 1>checked</cfif>></label>
                            </cfif>
                        </div>--->
                        <div class="form-group" id="item-earchive_sending_type">                                	
                            <cfif session.ep.our_company_info.is_earchive and get_company.use_efatura neq 1>
                                <input type="hidden" name="use_earchive" value="#get_company.use_earchive#">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='59328.E-Arşiv'> <cf_get_lang dictionary_id='57441.Fatura'></label>
                                <div class="col col-4 col-sm-12">
                                    <select name="earchive_sending_type" id="earchive_sending_type" style="width:100px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="0" <cfif get_company.earchive_sending_type eq 0>selected</cfif>><cf_get_lang dictionary_id='41981.KAĞIT'></option>
                                        <option value="1" <cfif get_company.earchive_sending_type eq 1>selected</cfif>><cf_get_lang dictionary_id='59873.ELEKTRONİK'></option>
                                    </select>
                                </div>
                            </cfif>
                            <cfif session.ep.our_company_info.is_efatura>
                                <div class="col col-4 col-sm-12"><cfif get_company.use_efatura is 1><span><cf_get_lang dictionary_id='59034.e-Fatura Mukellefi'> - #dateformat(get_company.efatura_date,dateformat_style)#</span></cfif></div>
                            </cfif>
                        </div>
                        <div class="form-group" id="item-taxoffice">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="taxoffice" id="taxoffice" value="#get_company.taxoffice#" maxlength="30">
                            </div>                
                        </div>
                        <div class="form-group" id="item-taxno">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <input type="text" name="taxno" id="taxno" onkeyup="country_vno(this);" onblur="country_vno(this);" value="#get_company.taxno#"/>
                                    <cfinclude template="/WEX/gib/internalapi.cfm">
                                    <cfif is_gib_activate()>
                                        <span class="input-group-addon">
                                            <i class="icon-search btnPointer show" onclick="mukellefSorgula()"></i>
                                        </span>
                                    </cfif>
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-ozel_kod">
                            <label class="col col-4 col-sm-12"><cfif isdefined("attributes.type")><cf_get_lang dictionary_id='30155.Cari Hesap Kodu'>*<cfelse><cf_get_lang dictionary_id='30337.Özel Kod 1'></cfif></label>
                            <div class="col col-8 col-sm-12">
                                <input type="hidden" name="old_ozel_kod" id="old_ozel_kod" value="#get_company.ozel_kod#">
                                <input type="text" name="ozel_kod" id="ozel_kod" value="#get_company.ozel_kod#" <cfif isdefined("attributes.type")>maxlength="10" onKeyup="isNumber(this);" <cfif isdefined("get_process_stage.process_row_id") and get_company.company_state eq get_process_stage.process_row_id> readonly</cfif><cfelse>maxlength="75"</cfif>>
                            </div>                
                        </div>
                        
                        <div class="form-group" id="item-ozel_kod_1" <cfif fusebox.circuit eq 'crm'>style="display:none;"</cfif>>
                            <label class="col col-4 col-sm-12"><cfif isdefined("attributes.type")><cf_get_lang dictionary_id='30155.Cari Hesap Kodu'>*<cfelse><cf_get_lang dictionary_id='30338.Ozel Kod 2'></cfif></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="ozel_kod_1" id="ozel_kod_1" value="#get_company.ozel_kod_1#" <cfif isdefined("attributes.type")> maxlength="10" onKeyup="isNumber(this);" <cfif isdefined("get_process_stage.process_row_id") and get_company.company_state eq get_process_stage.process_row_id> readonly</cfif><cfelse>maxlength="75"</cfif>>
                            </div>                
                        </div>
                        <div class="form-group" id="item-ozel_kod_2" <cfif fusebox.circuit eq 'crm'>style="display:none;"</cfif>>
                            <label class="col col-4 col-sm-12"><cfif isdefined("attributes.type")><cf_get_lang dictionary_id='30155.Cari Hesap Kodu'>*<cfelse><cf_get_lang dictionary_id='30343.Ozel Kod 3'></cfif></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="ozel_kod_2" id="ozel_kod_2" value="#get_company.ozel_kod_2#" maxlength="75">
                            </div>                
                        </div>
                        <cfif session.ep.our_company_info.is_efatura eq 1>
                            <div class="form-group" id="item-profile_id">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='49118.Senaryo'></label>
                                <div class="col col-8 col-sm-12">
                                    <select name="profile_id" id="profile_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="TEMELFATURA" <cfif get_company.profile_id is 'TEMELFATURA'>selected</cfif>><cf_get_lang dictionary_id='57067.Temel Fatura'></option>
                                        <option value="TICARIFATURA" <cfif get_company.profile_id is 'TICARIFATURA'>selected</cfif>><cf_get_lang dictionary_id='59874.Ticari Fatura'></option>
                                    </select>
                                </div>                
                            </div>
                        </cfif>
                        <div class="form-group" id="item-firm_type">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='49350.Firma Tipi'></label>
                            <div class="col col-8 col-sm-12">
                                <cf_multiselect_check 
                                    table_name="SETUP_FIRM_TYPE"  
                                    name="firm_type"
                                    option_name="firm_type" 
                                    option_value="firm_type_id" 
                                    value="#get_company.firm_type#">
                            </div>                
                        </div>
                        <cfif x_is_upper_sector eq 1>
                            <div class="form-group" id="item-upper_sector_cat">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57579.Sektor'></label>
                                <div class="col col-8 col-sm-12">
                                    <cfset get_sector_name = company_cmp.get_sector_name(cpid:attributes.cpid)>
                                    <div class="input-group">
                                        <select name="upper_sector_cat" id="upper_sector_cat">
                                            <cfif get_sector_name.recordcount>
                                                <cfloop query="get_sector_name">
                                                    <option value="#sector_cat_id#">#upper_sector_cat_code# #IIf(len(upper_sector_cat_code) and len(sector_cat_code), DE("-"), DE(""))# #sector_cat_code# #sector_cat#</option>
                                                </cfloop>
                                            </cfif>
                                        </select> 
                                        <span class="input-group-addon">
                                            <i class="icon-pluss btnPointer show" onclick="windowopen('#request.self#?fuseaction=member.popup_list_sectors&field_name=upper_sector_cat','medium');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                            <i class="icon-minus btnPointer show" onclick="remove_field('upper_sector_cat');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                        </span>
                                    </div>
                                </div>                
                            </div>
                        </cfif>
                        <cfif x_is_product_category eq 1>
                            <div class="form-group" id="item-product_category">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'> *</label>
                                <div class="col col-8 col-sm-12">
                                    <div class="input-group">
                                        <select name="product_category" id="product_category" style="width:485px; height:80px;">
                                            <cfif getProductCat.recordcount>
                                                <cfloop query="getProductCat">
                                                    <cfset hierarchy_ = "">
                                                    <cfset new_name = "">
                                                    <cfloop list="#HIERARCHY#" delimiters="." index="hi">
                                                        <cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
                                                        <cfset getCat = company_cmp.getCat(hierarchy:hierarchy_, dsn1:dsn1)>
                                                        <cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
                                                    </cfloop>
                                                    <option value="#product_catid#">#new_name#</option>
                                                </cfloop>
                                            </cfif>
                                        </select>
                                        <span class="input-group-addon">                       
                                            <i class="icon-pluss btnPointer show" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.popup_list_product_categories&field_name=document.form_add_company.product_category','medium');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                                            <i class="icon-minus btnPointer show" onclick="remove_field('product_category');" title="<cf_get_lang dictionary_id='57463.Sil'>"></i>
                                        </span>
                                    </div>
                                </div>                
                            </div>
                        </cfif>
                        <div class="form-group" id="item-country">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                            <div class="col col-8 col-sm-12">
                                <select name="country" id="country" onchange="LoadCity(this.value,'city_id','county_id',0);LoadPhone(this.value);">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_country">
                                        <option value="#country_id#" <cfif get_company.country eq country_id>selected</cfif>>#country_name#</option>
                                    </cfloop>
                                </select>
                            </div>                
                        </div>
                        <div class="form-group" id="item-city_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57971.Şehir'><cfif get_einvoice.recordcount> *</cfif></label>
                            <div class="col col-8 col-sm-12">
                                <cfset get_city = company_cmp.GET_CITY(
                                    event:"upd",
                                    country_id:'#iIf(len(get_company.country),"get_company.country",DE(""))#'
                                )>
                                <select name="city_id" id="city_id" onchange="LoadCounty(this.value,'county_id','company_telcode')">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_city">
                                        <option value="#city_id#" <cfif get_company.city eq city_id>selected</cfif>>#city_name#</option>
                                    </cfloop>
                                </select>
                            </div>                
                        </div>
                        <div class="form-group" id="item-county_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58638.Ilce'><cfif get_einvoice.recordcount> *</cfif></label>
                            <div class="col col-8 col-sm-12">
                                <select name="county_id" id="county_id" <cfif x_district_address_info eq 1>onChange="LoadDistrict(this.value,'district_id');"</cfif>>
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfif len(get_company.city)>
                                        <cfset GET_COUNTY = company_cmp.GET_COUNTY(city_id:get_company.city)>
                                        <cfloop query="get_county">
                                            <option value="#county_id#" <cfif get_company.county eq county_id>selected</cfif>>#county_name#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>                
                        </div>
                        <div class="form-group" id="item-semt">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58132.Semt'></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="semt" id="semt" value="#get_company.semt#" maxlength="30">
                            </div>                
                        </div>
                        <cfif x_district_address_info eq 1>
                            <div class="form-group" id="item-district_id">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                                <div class="col col-8 col-sm-12">
                                    <select name="district_id" id="district_id" onchange="get_ims_code();" tabindex="23">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfif len(get_company.county)>
                                            <cfset get_district_name = company_cmp.get_district_name(county_id:get_company.county)>
                                            <cfloop query="get_district_name">
                                                <option value="#district_id#" <cfif get_company.district_id eq district_id>selected</cfif>>#district_name#</option>
                                            </cfloop>
                                        </cfif>
                                    </select>
                                </div>                
                            </div>
                        </cfif>
                        <div class="form-group" id="item-company_postcode">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                            <div class="col col-8 col-sm-12">
                                <input type="text" name="company_postcode" id="company_postcode" maxlength="10" value="#get_company.company_postcode#">
                            </div>                
                        </div>
                        <div class="form-group" id="item-coordinate_1">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58549.Koordinatlar'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="col col-6 col-sm-12">
                                    <div class="input-group">
                                        <div class="input-group-addon bold"><cf_get_lang dictionary_id='58553.Enlem'></div>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='59875.Lütfen enlem değerini -90 ile 90 arasında giriniz'></cfsavecontent>
                                        <input type="text" maxlength="10" range="-90,90" message="<cfoutput>#message#</cfoutput>" value="#get_company.coordinate_1#" name="coordinate_1" id="coordinate_1">
                                    </div>
                                </div>
                                <div class="col col-6 col-sm-12">
                                    <div class="input-group">
                                        <div class="input-group-addon bold"><cf_get_lang dictionary_id='58591.Boylam'></div>
                                        <input type="text" maxlength="10" range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#get_company.coordinate_2#" name="coordinate_2" id="coordinate_2">
                                        <cfif len(get_api_key.GOOGLE_API_KEY) gt 10>
                                            <cfif len(get_company.coordinate_1) and len(get_company.coordinate_2)>
                                                <div class="input-group-addon bold"><a href="javascript://" title="<cf_get_lang dictionary_id='58849.Haritada Göster'>" onclick="windowopen('#request.self#?fuseaction=member.form_list_company&event=openMap&type=det&lat=#get_company.coordinate_1#&lng=#get_company.coordinate_2#&title=#get_company.fullname#','list','popup_view_map')"><i class="fa fa-map-marker"></i></a></div>
                                            </cfif>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-asset2">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58637.logo'></label>
                            <div class="col col-3 col-sm-12">
                                <input type="FILE" name="ASSET2" id="ASSET2">
                            </div>    
                            <cfif len(get_company.asset_file_name2)>
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30161.Logo sil'> <input type="checkbox" id="del_asset2" name="del_asset2" value="1"></label>
                                <div class="col col-2 col-xs-12" style="text-align:center;">
                                    <cf_get_server_file title="#getLang('','Logo',58637)#" output_file="member/#get_company.asset_file_name2#" output_server="#get_company.asset_file_name2_server_id#" output_type="2" small_image="/images/branch_plus.gif" image_link="1">
                                </div>     
                            </cfif>                                        
                        </div>
                        <div class="form-group" id="item-asset1">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30570.Dış Görünüş'></label>
                            <div class="col col-3 col-sm-12">
                                <input type="FILE" name="ASSET1" id="ASSET1">
                            </div>
                            <cfif len(get_company.asset_file_name1)> 
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30570.Dış Görünüş'><cf_get_lang dictionary_id='57463.Sil'><input type="checkbox" name="del_asset1" id="del_asset1" value="1"></label>
                                <div class="col col-2 col-xs-12" style="text-align:center;">
                                    <cf_get_server_file title="#getLang('','Dış Görünüş',30570)#" output_file="member/#get_company.asset_file_name1#" output_server="#get_company.asset_file_name1_server_id#" output_type="2" small_image="/images/branch_plus.gif" image_link="1">
                                </div> 
                            </cfif>
                        </div>
                        <div class="form-group" id="item-member_add_option_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='30200.Üye Özel Tanımı'></label>
                            <div class="col col-8 col-sm-12">
                                <cf_wrk_selectlang 
                                        name="member_add_option_id"
                                        table_name="SETUP_MEMBER_ADD_OPTIONS"
                                        option_name="MEMBER_ADD_OPTION_NAME"
                                        option_value="MEMBER_ADD_OPTION_ID"
                                        value="#get_company.member_add_option_id#"
                                        sort_type="MEMBER_ADD_OPTION_NAME">
                            </div>                
                        </div>
                        <div class="form-group" id="item-sales_county">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'><cfif session.ep.our_company_info.sales_zone_followup eq 1>*</cfif></label>
                            <div class="col col-8 col-sm-12">
                                <input type="hidden" name="old_sales_county" id="old_sales_county" value="#get_company.sales_county#">
                                <cf_wrk_saleszone
                                        name="sales_county"
                                        width="150"
                                        is_active="1"
                                        value="#get_company.sales_county#">
                            </div>                
                        </div>
                        <div class="form-group" id="item-company_size_cat_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30170.Şirket Büyüklüğü'></label>
                            <div class="col col-8 col-sm-12">
                                <select name="company_size_cat_id" id="company_size_cat_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_company_size">
                                        <option value="#company_size_cat_id#" <cfif company_size_cat_id eq get_company.company_size_cat_id>selected</cfif>>#company_size_cat#</option>
                                    </cfloop>
                                </select>
                            </div>                
                        </div>
                        <cfif GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1>
                            <div class="form-group" id="item-watalogy_code">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='63801.Watalogy'></label>
                                <div class="col col-8 col-sm-12">
                                    <input type="text" id="watalogy_code" name="watalogy_code" value="#get_company.WATALOGY_MEMBER_CODE#">
                                </div>                
                            </div>
                        </cfif>
                        <div class="form-group" id="item-old_ims_code_name">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'><cfif session.ep.our_company_info.sales_zone_followup eq 1>*</cfif></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <cfif len(get_company.ims_code_id)>
                                        <cfset GET_IMS = company_cmp.GET_IMS(ims_code_id:get_company.ims_code_id)>
                                        <input type="hidden" name="old_ims_code_name" id="old_ims_code_name" value="#get_ims.ims_code# #get_ims.ims_code_name#">
                                        <input type="hidden" name="old_ims_code_id" id="old_ims_code_id" value="#get_company.ims_code_id#">
                                        <input type="hidden" name="ims_code_id" id="ims_code_id" value="#get_company.ims_code_id#">
                                        <input type="text" name="ims_code_name" id="ims_code_name"  passthrough="readonly=yes;" value="#get_ims.ims_code# #get_ims.ims_code_name#" tabindex="43">
                                    <cfelse>
                                        <input type="hidden" name="old_ims_code_name" id="old_ims_code_name" value="">
                                        <input type="hidden" name="old_ims_code_id" id="old_ims_code_id" value="">
                                        <input type="hidden" name="ims_code_id" id="ims_code_id">
                                        <input type="text" name="ims_code_name" id="ims_code_name" value="" passthrough="readonly=yes;">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&is_form_submitted=1&field_name=form_upd_company.ims_code_name&field_id=form_upd_company.ims_code_id');"></span>                        
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-customer_value">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
                            <div class="col col-8 col-sm-12">
                                <select name="customer_value" id="customer_value">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_customer_value">
                                        <option value="#customer_value_id#" <cfif customer_value_id eq get_company.company_value_id>selected</cfif>>#customer_value#</option>
                                    </cfloop>
                                </select>
                            </div>                
                        </div>
                        <div class="form-group" id="item-old_pos_code">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57908.Temsilci'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <cfif len(get_work_pos.position_code)>
                                        <input type="hidden" name="old_pos_code" id="old_pos_code" value="#get_work_pos.position_code#">
                                        <input type="hidden" name="old_pos_code_text" id="old_pos_code_text" value="#get_emp_info(get_work_pos.position_code,1,0)#">
                                        <input type="hidden" name="pos_code" id="pos_code" value="#get_work_pos.position_code#">
                                        <input type="text" name="pos_code_text" id="pos_code_text" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" autocomplete="off" value="#get_emp_info(get_work_pos.position_code,1,0)#">
                                    <cfelse>
                                        <input type="hidden" name="old_pos_code" id="old_pos_code" value="">
                                        <input type="hidden" name="old_pos_code_text" id="old_pos_code_text" value="">
                                        <input type="hidden" name="pos_code" id="pos_code" value="">
                                        <input type="text" name="pos_code_text" id="pos_code_text" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" value="">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&is_form_submitted=1&field_code=form_upd_company.pos_code&field_name=form_upd_company.pos_code_text<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1','list');return false"></span>                        
                                </div>
                            </div>                
                        </div>
                        <div class="form-group" id="item-is_export">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30348.İhracat Yapıyor'></label>
                            <div class="col col-8 col-sm-12">
                                <input type="checkbox" name="is_export" id="is_export" value="1" <cfif get_company.is_export eq 1>checked</cfif> onclick="gizle_goster(form_ul_is_ihracat_country);" />
                            </div>                
                        </div>
                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='30351.İhracat Yapılan Ülkeler'></cfsavecontent>
                        <cfif get_company.is_export eq 1>
                            <cfset style_display = ''>
                            <cfset getExportCountries = company_cmp.getExportCountries(company_id:get_company.company_id)>
                            <cfset eport_country_ids = valuelist(getExportCountries.country_id,',')>
                        <cfelse>
                            <cfset style_display = 'none'>
                            <cfset eport_country_ids = ''>
                        </cfif>
                        <div class="form-group" style="display:#style_display#;" id="form_ul_is_ihracat_country">
                            <label class="col col-4 col-sm-12"><cfoutput>#header_#</cfoutput></label>
                            <div class="col col-8 col-sm-12">
                                <cf_multiselect_check 
                                    table_name="SETUP_COUNTRY"  
                                    name="export_countries"
                                    option_name="COUNTRY_NAME" 
                                    option_value="COUNTRY_ID"
                                    value="#eport_country_ids#">
                            </div>
                        </div>
                    </div>   
                    <div class="col col-12 col-md-12 col-sm-12" type="column" index="4" sort="true">
                        <div class="form-group" id="deneme">
                            <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                            <div class="col col-10 col-sm-12">
                                <cf_wrk_add_info info_type_id="-1" info_id="#attributes.cpid#" upd_page = "1" colspan="9">
                            </div>
                        </div> 
                    </div>
                    
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="get_company" is_partner='1'>
                    </div>
                    <div class="col col-6">
                       <cf_workcube_buttons is_upd='1' is_delete= '0' type_format="1" add_function='kontrol()'>
                    </div>            
                </cf_box_footer>
        	</cfform>
        </div>
    </cfoutput>
</cf_box>
    <div class="row">
        <!--- Partnerler ch--->
        <cfif isdefined('xml_company_partner') and xml_company_partner eq 1>
            <cf_box
                id="list_company_partner"
                unload_body="1"
                closable="0"
                title="#getLang('','Kontak Kişiler',31385)#"
                box_page="#request.self#?fuseaction=#iif(fusebox.circuit is 'crm',DE('member'),'fusebox.circuit')#.popupajax_my_company_partners&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#&is_active=#is_only_active_partners#"
                add_href="#request.self#?fuseaction=member.list_contact&event=add&compid=#attributes.cpid#&comp_cat=#iif(len(get_company.companycat_id),'#get_company.companycat_id#',DE(""))#">
            </cf_box>
        </cfif>
        
        <!--- Adresler Şubeler --->
        <cfif isdefined('xml_address_branch') and xml_address_branch eq 1>
            <cf_box
                id="detail_company_address_branch"
                unload_body="1"
                closable="0"
                title="#getLang('','Adresler/Şubeler',30192)#"
                box_page="#request.self#?fuseaction=#iif(fusebox.circuit is 'crm',DE('member'),'fusebox.circuit')#.popupajax_detail_company_address_branch&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#">
            </cf_box>
        </cfif>
        <cfif  GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1>
            <!--- Pazaryerleri --->
            <cf_box
                id="list_worknet_relation"
                unload_body="1"
                closable="0"
                add_href="openBoxDraggable('#request.self#?fuseaction=worknet.form_list_company&event=popup_addWorknetRelation&cpid=#attributes.cpid#&draggable=1&form_submitted=1')"
                title="#getLang('','Pazaryeri','63775')#"
                widget_load="companyMarketplaces&cpid=#attributes.cpid#">
            </cf_box>
        </cfif>
        <!--- Sözleşmeler ch--->
        <cfif isdefined('xml_subscription') and xml_subscription eq 1>
            <cf_box
                id="LIST_MY_COMPANY_SYSTEMS"
                title="#getLang('','Sözleşmeler',30262)#"
                unload_body="1"
                box_page="#request.self#?fuseaction=member.popupajax_my_company_systems&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#"
                closable="0"
                add_href="#request.self#?fuseaction=sales.list_subscription_contract&event=add&company_id=#attributes.cpid#&partner_id=#get_partner_.partner_id#&member_type=partner">
            </cf_box>
        </cfif>
        
        <!--- Kurumsal Üye İlişkisi --->
        <cfif isdefined('xml_company_member_related') and xml_company_member_related eq 1>
            <cf_box
                id="list_member_rel"
                scroll="1"
                unload_body="1"
                closable="0"
                title="#getLang('','Kurumsal Üye İlişkisi',30175)#"
                box_page="#request.self#?fuseaction=objects.emptypopup_ajax_member_relations&relation_info_id=#attributes.cpid#&action_type_info=1">
            </cf_box>
        </cfif>
    </div>
<script type="text/javascript">
	$(function() {		
		$(".uniqueRow").sortable({
			connectWith		: '.uniqueRow',
			items			: 'div.uniqueBox',
			handle			: '[id*="handle_"]',
			cursor			: 'move',
			opacity			: '0.6',
			placeholder		: 'elementSortArea',
			tolerance		: 'pointer',
			revert			: 300,
			start: function(e, ui ){
				ui.placeholder.height(ui.helper.outerHeight());	
			},
			stop: function(e, ui ) {					
				console.log('kaydedilecek');
				element = ui.item[0];
			}//stop
		});	
	});//ready
	function country_vno(e){
	if ($('#country').val()==1)isNumber(e);
	}
</script>