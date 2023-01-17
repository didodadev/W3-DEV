<!--- Bireysel Uye Hizli Ekleme Ekranı FBS 20081103 --->
<cfform name="add_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_consumer">
<cfif isdefined('xml_consumer_contract_id') and len(xml_consumer_contract_id)>
	<input type="hidden" name="xml_consumer_contract_id" id="xml_consumer_contract_id"  value="<cfoutput>#xml_consumer_contract_id#</cfoutput>">
</cfif>   
<div class="row">
	<div class="col col-12 uniqueRow">
		<div class="row formContent">
			<div class="row" type="row">
				<div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
                    <!--- Genel Bilgiler --->
                    <div class="form-group" id="form-process_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'> 
                        </div>
                    </div>
                    <div class="form-group" id="form-consumer_cat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_membercat
                                name="consumer_cat_id"
                                is_active="1"
                                comp_cons="0">
                        </div>
                    </div>
                    <div class="form-group" id="form-ref_pos_code_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58636.Referans Üye'>*</label><cfif is_req_reference_member eq 1></cfif>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="ref_pos_code" id="ref_pos_code" value="" />
                                <input type="text" name="ref_pos_code_name" id="ref_pos_code_name" value="" style="width:150px;" autocomplete="off" readonly />
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=add_consumer.ref_pos_code&field_consumer=add_consumer.dsp_reference_code&field_name=add_consumer.ref_pos_code_name&field_cons_ref_code=add_consumer.reference_code&kontrol_conscat_id=1<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>,'list','popup_list_cons')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form-dsp_reference_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30593.Referans Kod'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="reference_code" id="reference_code" value="" />
                            <input type="text" name="dsp_reference_code" id="dsp_reference_code" value="" maxlength="50" style="width:150px;" />
                        </div>
                    </div>
                    <div class="form-group" id="form-proposer_cons_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30720.Öneren Üye'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <input type="hidden" name="proposer_cons_id" id="proposer_cons_id" value="" />
                            <input type="text" name="proposer_cons_name" id="proposer_cons_name" style="width:150px;" onfocus="AutoComplete_Create('proposer_cons_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','2,0,0,0','CONSUMER_ID','proposer_cons_id','add_consumer','3','250');" value="" autocomplete="off" />
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=add_consumer.proposer_cons_id&field_name=add_consumer.proposer_cons_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>,'list','popup_list_cons')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form-consumer_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='57631.Ad'></cfsavecontent>
                            <cfif isdefined("attributes.consumer_name")>
                                <cfinput type="text" name="consumer_name" id="consumer_name" required="yes" message="#message#" maxlength="30" style="width:150px;" value="#attributes.consumer_name#">
                            <cfelse>
                                <cfinput type="text" name="consumer_name" id="consumer_name" required="yes" message="#message#" maxlength="30" style="width:150px;" value="">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="form-consumer_surname">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> :<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                            <cfif isdefined("attributes.consumer_surname")>
                                <cfinput type="text" name="consumer_surname"  id="consumer_surname" required="yes" message="#message#" maxlength="30" style="width:150px;" value="#attributes.consumer_surname#">
                            <cfelse>
                                <cfinput type="text" name="consumer_surname"  id="consumer_surname" required="yes" message="#message#" maxlength="30" style="width:150px;" value="">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="form-birthdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label><cfif is_birthday eq 1 or is_tc_number eq 1>*</cfif>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi!'></cfsavecontent>
                                <cfinput type="text" name="birthdate" id="birthdate" maxlength="10" validate="#validate_style#" message="#message#" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="birthdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form-tc_identity_no" >
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label><cfif is_tc_number eq 1>*</cfif>
                        <div class="col col-8 col-xs-12">
                            <cfif is_tc_number eq 1>
                                <cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_required="#is_tc_number#" width_info='150' is_verify='1' consumer_name='consumer_name' consumer_surname='consumer_surname' birth_date='birthdate' >
                            <cfelse>					
                                <cf_wrktcnumber fieldid="tc_identity_no" tc_identity_required="#is_tc_number#" width_info='150'>
                            </cfif>
                        </div>
                    </div>				
                    <div class="form-group" id="form-sex">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="sex" id="sex" style="width:150px;">
                                <option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
                                <option value="0"><cf_get_lang dictionary_id='58958.Kadın'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="form-mobilcat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'></label>
                        <div class="col col-2 col-xs-12">
                        <cfinput type="text" name="mobilcat_id" id="mobilcat_id" maxlength="5"  tabindex="2" onKeyUp="isNumber(this);" style="width:47px;" required="yes" value="">
                        </div>
                        <div class="col col-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='30223.Kod/ Mobil Girmelisiniz'> !</cfsavecontent>
                            <cfif isdefined("attributes.mobiltel")>
                                <cfinput type="text" name="mobiltel" id="mobiltel" maxlength="7" validate="integer" onKeyUp="isNumber(this)" message="#message#"  value="#attributes.mobiltel#">
                            <cfelse>
                                <cfinput type="text" name="mobiltel" id="mobiltel" maxlength="7" validate="integer" onKeyUp="isNumber(this)" message="#message#" value="">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="form-mobilcat_id_2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'>2</label>
                        <div class="col col-2 col-xs-12">
                        <cfinput type="text" name="mobilcat_id_2" id="mobilcat_id_2" maxlength="5"  tabindex="2" onKeyUp="isNumber(this);" required="yes" value="">
                            <cfoutput query="get_mobilcat">
                            </cfoutput>
                        </div>
                        <div class="col col-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='30223.Kod/ Mobil Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="mobiltel_2" id="mobiltel_2" maxlength="7" onKeyUp="isNumber(this)" validate="integer" message="#message#" style="width:87px;" value="">
                        </div>
                    </div>
                    <div class="form-group" id="form-home_telcode">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30384.Kod/Ev Telefonu'></label><cfif is_home_telephone eq 1>*</cfif>
                        <div class="col col-2 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='30316.Telefon Kodu Giriniz'>!</cfsavecontent>
                            <cfif isdefined("attributes.home_telcode")>
                                <cfinput text="text" name="home_telcode" id="home_telcode" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3"  value="#attributes.home_telcode#">
                            <cfelse>
                                <cfinput text="text" name="home_telcode" id="home_telcode" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3"  value="">
                            </cfif>
                            </div>
                            <div class="col col-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'> : <cf_get_lang dictionary_id='57499.telefon'> !</cfsavecontent>
                            <cfif isdefined("attributes.home_tel")>
                                <cfinput type="text" name="home_tel" id="home_tel" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="7"  value="#attributes.home_tel#">
                            <cfelse>
                                <cfinput type="text" name="home_tel" id="home_tel" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="7"  value="">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="form-consumer_email">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
                        <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'> : <cf_get_lang dictionary_id='57428.E-mail'> !</cfsavecontent>
                                <cfinput type="text" name="consumer_email" id="consumer_email" maxlength="100" validate="email" message="#message#"  value="">
                        </div>
                    </div>
                    <div class="form-group" id="form-resource">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label><cfif isdefined("is_resource_info") and is_resource_info eq 1> *</cfif>
                        <div class="col col-8 col-xs-12">
                        <cf_wrk_combo 
                            name="resource"
                            query_name="GET_PARTNER_RESOURCE"
                            option_name="resource"
                            option_value="resource_id"
                            width="150">
                        </div>
                    </div>
                    <cfif isdefined('is_fast_add_member_option') and (is_fast_add_member_option eq 1 or is_fast_add_member_option eq 2)>
                    <div class="form-group" id="form-member_add_option_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30200.Üye Özel Tanımı'></label><cfif isdefined('is_fast_add_member_option') and is_fast_add_member_option eq 2>*</cfif></td>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_combo 
                            name="member_add_option_id"
                            query_name="GET_MEMBER_ADD_OPTIONS"
                            value=""
                            option_name="member_add_option_name"
                            option_value="member_add_option_id"
                            width="150">
                        </div>
                    </div>
                    </cfif>
                </div>
            </div>
            <div class="row" type="row" slidebox="true">
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="3" sort="true">
                        <!--- Ev Adres Bilgileri --->
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="30258.Ev Adres Bilgileri"></cfsavecontent>
                    <cf_seperator id="ev_adres_bilgileri_" header="#message#" is_closed="1">
                    <div id="ev_adres_bilgileri_" style="display:none;">
                        <cfif is_adres_detail eq 0>
                            <div class="form-group" id="item-home_address" >
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                                    <div class="col col-8 col-xs-12">
                                    <cfif isdefined("attributes.home_address")>
                                        <cfset home_address_ = attributes.home_address>
                                    <cfelse>
                                        <cfset home_address_ = "">
                                    </cfif>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısıss'></cfsavecontent>
                                    <textarea name="home_address" id="home_address" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" maxlength="750" tabindex="6"><cfoutput>#home_address_#</cfoutput></textarea>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-home_postcode">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="home_postcode" id="home_postcode" maxlength="15" />
                            </div>
                        </div>
                        <div class="form-group" id="item-home_country">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="home_country" id="home_country"  onblur="LoadCity(this.value,'home_city_id','home_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'home_district_id'</cfif>)">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_country">
                                        <option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-home_city_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="home_city_id" id="home_city_id" onchange="LoadCounty(this.value,'home_county_id','home_telcode'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'home_district_id'</cfif>)" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-home_county_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="home_county_id" id="home_county_id"  <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'home_district_id');"</cfif> >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-home_semt">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
                                <div class="col col-8 col-xs-12">
                                <input type="text" name="home_semt" id="home_semt" value="" maxlength="30"  />
                            </div>
                        </div>
                        <cfif is_adres_detail eq 1>
                        <div class="form-group" id="item-home_district">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif is_residence_select eq 0>
                                    <input type="text" name="home_district" id="home_district" style="width:150px;" value="" />
                                <cfelse>
                                    <select name="home_district_id" id="home_district_id" style="width:150px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    </select>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-home_main_street">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30629.Cadde'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="home_main_street" id="home_main_street" style="width:150px;" maxlength="50" />
                            </div>
                        </div>
                        <div class="form-group" id="item-home_street">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30630.Sokak'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="home_street" id="home_street" style="width:150px;" maxlength="50" />-
                            </div>
                        </div>
                        <div class="form-group" id="item-home_door_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30215.Adres Detay'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
                                <textarea name="home_door_no" id="home_door_no" style="width:150px;" maxlength="250" message="<cfoutput>#message#</cfoutput>" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"></textarea>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-is_tax_address">
                            <input type="checkbox" name="is_tax_address" id="is_tax_address" value="1" /><label class=><cf_get_lang dictionary_id='59904.Teslimat Adresi Olarak Kaydet'></label>
                        </div>
                    </div>
                </div>
            </div> 
            <div class="row" type="row" slidebox="true">
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="5" sort="true">
                    <!--- Is Adres Bilgileri --->
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="30381.İş Adres Bilgileri"></cfsavecontent>
                    <cf_seperator id="is_adres_bilgileri" header="#message#" is_closed="1">
                    <div id="is_adres_bilgileri" style="display:none;">
                        <div class="form-group" id="item-work_telcode">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30382.Kod/İş Telefonu'></label>
                            <div class="col col-2 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'> : <cf_get_lang dictionary_id='30382.Kod/İş Telefonu !'></cfsavecontent>
                                <cfinput type="text" name="work_telcode" id="work_telcode" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" >
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'> : <cf_get_lang dictionary_id='87.telefon'></cfsavecontent>
                                <cfinput type="text" name="work_tel" id="work_tel" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="7" >
                            </div>
                        </div>
                        <div class="form-group" id="item-work_tel_ext">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30259.Dahili'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'> : <cf_get_lang dictionary_id='30259.dahili !'></cfsavecontent>
                                <cfinput type="text" name="work_tel_ext" id="work_tel_ext" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="5" >
                            </div>
                        </div>
                        <div class="form-group" id="item-work_faxcode">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30245.Fax Kod / Fax'></label>
                            <div class="col col-4 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'> : <cf_get_lang dictionary_id='30245.Fax/Fax kodu!'></cfsavecontent>
                                <cfif isdefined("attributes.work_faxcode")>
                                    <cfinput type="text" name="work_faxcode" id="work_faxcode" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3"  value="#attributes.work_faxcode#">
                                <cfelse>
                                    <cfinput type="text" name="work_faxcode" id="work_faxcode" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3"  value="">
                                </cfif>
                            </div>
                            <div class="col col-4 col-xs-12">
                                <cfif isdefined("attributes.work_fax")>
                                    <cfinput type="text" name="work_fax" id="work_fax" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="7"  value="#attributes.work_fax#">
                                <cfelse>
                                    <cfinput type="text" name="work_fax" id="work_fax" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="7"  value="">
                                </cfif>
                            </div>
                        </div>
                        <cfif is_adres_detail eq 0>
                        <div class="form-group" id="item-work_address">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısıss'></cfsavecontent>
                                <textarea name="work_address" id="work_address" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" maxlength="750" ></textarea>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-work_postcode">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="work_postcode" id="work_postcode" maxlength="5"  />
                            </div>
                        </div>
                        <div class="form-group" id="item-work_country">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="work_country" id="work_country"  onchange="LoadCity(this.value,'work_city_id','work_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'work_district_id'</cfif>)">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_country">
                                    <cfset is_load_country = 1>
                                        <option value="#country_id#" <cfif is_default eq 1>selected</cfif>>#country_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-work_city_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="work_city_id" id="work_city_id"  onchange="LoadCounty(this.value,'work_county_id','work_telcode'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'work_district_id'</cfif>)" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-work_city_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="work_county_id" id="work_county_id"  <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'work_district_id');"</cfif> >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-work_semt">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="work_semt" id="work_semt" value="" maxlength="30"  />
                            </div>
                        </div>
                        <cfif is_adres_detail eq 1>
                        <div class="form-group" id="item-work_district">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif is_residence_select eq 0>
                                    <input type="text" name="work_district" id="work_district" value="" />
                                <cfelse>
                                    <select name="work_district_id" id="work_district_id" >
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    </select>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-work_main_street">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30629.Cadde'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="work_main_street" id="work_main_street"  maxlength="50" />
                            </div>
                        </div>
                        <div class="form-group" id="item-work_street">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30630.Sokak'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="work_street" id="work_street"  maxlength="50" />
                            </div>
                        </div>
                        <div class="form-group" id="item-work_door_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30215.Adres Detay'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'></cfsavecontent>
                                <textarea name="work_door_no" id="work_door_no" maxlength="250" message="<cfoutput>#message#</cfoutput>" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"></textarea>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-is_tax_address_2">
                            <input type="checkbox" name="is_tax_address_2" id="is_tax_address_2" value="1" /><label class=><cf_get_lang dictionary_id='59904.Teslimat Adresi Olarak Kaydet'></label>
                        </div>
                    </div>
                </div>
            </div>      
            <div class="row" type="row" slidebox="true">
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="7" sort="true">
                    <!--- Is Bilgileri --->
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="30244.İş Bilgileri"></cfsavecontent>
                    <cf_seperator id="is_bilgileri_" header="#message#" is_closed="1">
                    <div id="is_bilgileri_" style="display:none;">  
                            <div class="form-group" id="item-company">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="company" id="company" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" maxlength="40"  />
                                </div>
                            </div>
                            <div class="form-group" id="item-title">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                <div class="col col-8 col-xs-12">
                                    <input  type="text" name="title" id="title" maxlength="50"  />
                                </div>
                            </div>
                            <div class="form-group" id="item-mission">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57573.Görev'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="mission" id="mission" >
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_partner_positions">
                                            <option value="#partner_position_id#">#partner_position#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-department">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="department" id="department"  >
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_partner_departments">
                                            <option value="#partner_department_id#">#partner_department#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-sector_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
                                <div class="col col-8 col-xs-12">
                                <cf_wrk_selectlang
                                    name="sector_cat_id"
                                    width="150"                                   
                                    option_name="sector_cat"
                                    option_value="sector_cat_id"
                                    table_name="SETUP_SECTOR_CATS"
                                    sort_type="sector_cat">
                                </div>
                            </div>
                            <div class="form-group" id="item-income_level">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30503.Gelir Düzeyi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_combo 
                                        name="income_level"
                                        query_name="GET_INCOME_LEVEL"
                                        option_name="income_level"
                                        option_value="income_level_id"
                                        width="150">
                                 </div>
                            </div>
                            <div class="form-group" id="item-company_size_cat_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30170.Şirket Büyüklüğü'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="company_size_cat_id" id="company_size_cat_id" >
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_company_size_cats">
                                            <option value="#company_size_cat_id#">#company_size_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-social_society_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30489.Sosyal Güvenlik Kurumu'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="social_society_id" id="social_society_id" >
                                        <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                                        <cfoutput query="get_societies">
                                            <option value="#society_id#">#society#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-social_security_no">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30307.Sosyal Güvenlik No'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="social_security_no" id="social_security_no" maxlength="50" />
                                </div>
                            </div>
                            <div class="form-group" id="item-vocation_type">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30500.meslek Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_combo 
                                        name="vocation_type"
                                        query_name="GET_VOCATION_TYPE"
                                        option_name="vocation_type"
                                        option_value="vocation_type_id"
                                        width="150">
                                </div>
                            </div>
                    </div>
                </div>
            </div>
            <div class="row" type="row" slidebox="true">
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="9" sort="true">
                    <!--- Kisisel Bilgiler --->
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="30236.Kişisel Bilgiler"></cfsavecontent>
                    <cf_seperator id="kisisel_bilgiler_" header="#message#" is_closed="1">
                    <div id="kisisel_bilgiler_" style="display:none;"> 
                        <div class="form-group" id="item-education_level">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30237.Eğitim Durumu'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="education_level" id="education_level" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_edu_level">
                                        <option value="#edu_level_id#">#education_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-identycard_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30239.Kimlik Kart / No'></label>
                            <div class="col col-4 col-xs-12">
                                <select name="identycard_cat" id="identycard_cat"> 
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_identycard_cat">
                                        <option value="#identycat_id#">#identycat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-4 col-xs-12">    
                                <input type="text" name="identycard_no" id="identycard_no" maxlength="40" style="width:48px;"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-birthplace">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="birthplace" id="birthplace" maxlength="30" />
                            </div>
                        </div>
                        <div class="form-group" id="item-married">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30513.Medeni Durumu'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="married" id="married" value="1" onclick="medeni_durum_kontrol();" /><cf_get_lang dictionary_id='30501.Evli'>
                            </div>
                        </div>
                        <div class="form-group" id="item-married_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29911.Evlilik Tarihi"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'> : <cf_get_lang dictionary_id='29911.Evlilik Tarihi'>! </cfsavecontent>
                                    <cfinput type="text" name="married_date" id="married_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="married_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-nationality">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30502.Uyruğu'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="nationality" id="nationality" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_country">
                                        <option value="#country_id#" <cfif country_id eq 1>selected</cfif>>#country_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-child">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30391.Çocuk Sayısı'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='30391.Çocuk Sayısı !'></cfsavecontent>
                                <cfinput type="text" name="child" id="child" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="2" >
                            </div>
                        </div>
                        <cfif is_dsp_photo eq 1>
                        <div class="form-group" id="item-picture">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30243.Fotoğraf'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="file" name="picture" id="picture" />
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-father">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58033.Baba Adı'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="father" id="father" maxlength="50" />
                            </div>
                        </div>
                        <div class="form-group" id="item-mother">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58440.Ana Adı'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="mother" id="mother" maxlength="50" />
                            </div>
                        </div>
                        <div class="form-group" id="item-blood_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
                                <div class="col col-8 col-xs-12">
                                <select name="blood_type" id="blood_type" >
                                    <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                                    <option value="0">0 Rh+</option>
                                    <option value="1">0 Rh-</option>
                                    <option value="2">A Rh+</option>
                                    <option value="3">A Rh-</option>
                                    <option value="4">B Rh+</option>
                                    <option value="5">B Rh-</option>
                                    <option value="6">AB Rh+</option>
                                    <option value="7">AB Rh-</option>
                                </select>
                            </div>
                        </div>
                        <cfif isdefined('xml_consumer_contract_id') and len(xml_consumer_contract_id)>
                            <cfquery name="GET_CONTENT_ORDER" datasource="#DSN#">
                            SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#xml_consumer_contract_id#">
                            </cfquery>
                            <div class="form-group">
                                <a href="javascript://" class="tableyazi" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_content_notice&content_id=#xml_consumer_contract_id#</cfoutput>','list');"><cfoutput>#get_content_order.cont_head#</cfoutput></a><br/>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-contract_rules">
                            <input type="checkbox" name="contract_rules" id="contract_rules" class="radio_frame" value="1" /><label class=><cf_get_lang dictionary_id='30184.Temsilci Sözleşmesini Kabul Ediyorum.'>*</label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12 text-right"><cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol()"></div>
            </div>
        </div>
    </div>
</div>
</cfform>
<script type="text/javascript">
	function medeni_durum_kontrol()
	{
		if(document.getElementById('married').checked == true)
			document.getElementById('medeni_durum').style.display = '';
		else
			document.getElementById('medeni_durum').style.display = 'none';
	}
</script>
