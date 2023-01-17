<cf_get_lang_set module_name="member">
<cfinclude template="../query/get_identycard_cat.cfm">
<cfinclude template="../query/get_edu_level.cfm">
<cfquery name="KNOW_LEVELS" datasource="#dsn#">
	SELECT * FROM SETUP_KNOWLEVEL
</cfquery>
<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
	SELECT 
		*
	FROM 
		COMPANY_PARTNER_DETAIL
	WHERE 
		PARTNER_ID=#ATTRIBUTES.PID# 
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Üye Kişisel Bilgileri',30460)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_upd_partner" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_partner_detail">
        <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#ATTRIBUTES.PID#</cfoutput>">
        <cf_seperator id="kisisel_bilgiler" header="#getLang('','Kişisel Bilgiler',30236)#">
        <cf_box_elements id="kisisel_bilgiler">
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30174.Kod- Telefon'></label>
                    <div class="col col-2 col-sm-12">
                        <cfinput maxlength="5" name="HOMETELCODE" value="#get_partner_detail.HOMETELCODE#">
                    </div>                
                    <div class="col col-6 col-sm-12">
                        <cfinput maxlength="9" type="text" name="HOMETEL" value="#get_partner_detail.HOMETEL#">
                    </div>
                </div> 
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30239.Kimlik Kart/No'></label>
                    <div class="col col-4 col-sm-12">
                        <select name="IDENTYCAT_ID" id="IDENTYCAT_ID">
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'> 
                            <cfoutput query="get_identycard_cat">
                                <cfif get_partner_detail.IDENTYCAT_ID is IDENTYCAT_ID>
                                <option value="#IDENTYCAT_ID#" selected>#identycat#
                                <cfelse>
                                <option value="#IDENTYCAT_ID#">#identycat#
                                </cfif>
                            </cfoutput>
                        </select> 
                    </div>                
                    <div class="col col-4 col-sm-12">
                        <cfinput type="text" name="IDENTYCARD_NO" value="#get_partner_detail.HOMETEL#" maxlength="50">
                    </div>
                </div> 
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="birthplace" id="birthplace" value="<cfoutput>#get_partner_detail.birthplace#</cfoutput>">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='30390.Doğum Tarihi Girmelisiniz !'></cfsavecontent>
                            <cfinput validate="#validate_style#" message="#message#" type="text" name="birthdate" value="#dateformat(get_partner_detail.birthdate,dateformat_style)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="birthdate"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30242.Evlilik Durumu'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="checkbox" name="married" id="married" value="checkbox" <cfif get_partner_detail.MARRIED is 1>checked</cfif>>
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30391.Çocuk Sayısı'></label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30391.Çocuk Sayısı !'></cfsavecontent>
                        <cfinput validate="integer" message="#message#" maxlength="2" type="text" name="child" value="#get_partner_detail.child#">
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="HOMEADDRESS" id="HOMEADDRESS" style="width:150px;height:50px;"><cfoutput>#get_partner_detail.HOMEADDRESS#</cfoutput></textarea>
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="HOMEPOSTCODE" id="HOMEPOSTCODE" maxlength="10"  value="<cfoutput>#get_partner_detail.HOMEPOSTCODE#</cfoutput>">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58638.ilçe'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="homecounty" id="homecounty" maxlength="30"  value="<cfoutput>#get_partner_detail.homecounty#</cfoutput>">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="homecity" id="homecity" maxlength="30"  value="<cfoutput>#get_partner_detail.homecity#</cfoutput>">
                    </div>
                </div>
            </div>
        </cf_box_elements>

        <cf_seperator id="egitim_bilgileri" header="#getLang('','Eğitim Bilgileri',30644)#">
        <cf_box_elements id="egitim_bilgileri">
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57419.Eğitim'></label>
                    <div class="col col-8 col-sm-12">
                        <select name="training_level" id="training_level">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfloop query="get_edu_level">
                            <option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif get_edu_level.edu_level_id eq get_partner_detail.training_level>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30478.İlkokul'></label>
                    <div class="col col-6 col-sm-12">
                        <cfinput name="edu1" type="text" value="#get_partner_detail.edu1#" maxlength="75">
                    </div>
                    <div class="col col-2 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30695.Mezuniyet Yılı'> !</cfsavecontent>
                        <cfinput type="text" name="edu1_finish" maxlength="4" value="#get_partner_detail.edu1_finish#" validate="integer" message="#message#" range="1900,2500">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30479.Ortaokul'></label>
                    <div class="col col-6 col-sm-12">
                        <cfinput name="edu2" type="text" value="#get_partner_detail.edu2#" maxlength="75">
                    </div>
                    <div class="col col-2 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30695.Mezuniyet Yılı'> !</cfsavecontent>
                        <cfinput type="text" name="edu2_finish" maxlength="4" value="#get_partner_detail.edu2_finish#" validate="integer" message="#message#" range="1900,2500">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30480.Lise'></label>
                    <div class="col col-6 col-sm-12">
                        <cfinput name="edu3" type="text" value="#get_partner_detail.edu3#" maxlength="75">
                    </div>
                    <div class="col col-2 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30695.Okul Mezuniyet Yılı'> !</cfsavecontent>
                        <cfinput type="text" name="edu3_finish" maxlength="4" value="#get_partner_detail.edu3_finish#" validate="integer" message="#message#" range="1900,2500">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29755.Üniversite'></label>
                    <div class="col col-6 col-sm-12">
                        <cfinput type="text" name="edu4" maxlength="75" value="#get_partner_detail.edu4#">
                    </div>
                    <div class="col col-2 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30695.Okul Mezuniyet Yılı'> !</cfsavecontent>
                        <cfinput type="text" name="edu4_finish" maxlength="4" value="#get_partner_detail.edu4_finish#" validate="integer" message="#message#" range="1900,2500">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30482.Fakülte'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="edu4_faculty" maxlength="75" value="#get_partner_detail.edu4_faculty#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang no='345.Üniversite'></label>
                    <div class="col col-6 col-sm-12">
                        <cfinput type="text" name="edu5" maxlength="75" value="#get_partner_detail.edu5#">
                    </div>
                    <div class="col col-2 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30695.Okul Mezuniyet Yılı'> !</cfsavecontent>
                        <cfinput type="text" name="edu5_finish" maxlength="4" value="#get_partner_detail.edu5_finish#" validate="integer" message="#message#"range="1900,2500">
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58996.Dil'> 1</label>
                    <div class="col col-4 col-sm-12">
                        <cfinput type="text" name="lang1" maxlength="15" value="#get_partner_detail.lang1#">
                    </div>
                    <div class="col col-4 col-sm-12">
                        <select name="lang1_level" id="lang1_level">
                            <cfoutput query="know_levels">
                            <option value="#knowlevel_id#" <cfif get_partner_detail.lang1_level EQ knowlevel_id>selected</cfif>>#knowlevel# </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58996.Dil'> 2</label>
                    <div class="col col-4 col-sm-12">
                        <cfinput type="text" name="lang2" maxlength="15"  value="#get_partner_detail.lang2#">
                    </div>
                    <div class="col col-4 col-sm-12">
                        <select name="lang2_level" id="lang2_level">
                            <cfoutput query="know_levels">
                            <option value="#knowlevel_id#" <cfif get_partner_detail.lang2_level EQ knowlevel_id>selected</cfif>>#knowlevel# </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="edu4_city" id="edu4_city" maxlength="50" value="<cfoutput>#get_partner_detail.edu4_city#</cfoutput>">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="edu4_part" maxlength="40" value="#get_partner_detail.edu4_part#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="edu5_part" maxlength="40" value="#get_partner_detail.edu5_part#">
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_upd_partner' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cfform>
</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
