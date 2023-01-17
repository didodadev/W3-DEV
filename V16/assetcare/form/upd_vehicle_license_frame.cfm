<cfsetting showdebugoutput="no">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="GET_ASSETP_INFOPLUS" datasource="#DSN#">
	SELECT 
		ASSET_P_INFO_PLUS.*,
		ASSET_P.ASSETP,
		ASSET_P.RECORD_DATE,
		ASSET_P.UPDATE_DATE,
		ASSET_P.UPDATE_EMP
	FROM 
		ASSET_P_INFO_PLUS,
		ASSET_P
	WHERE
		ASSET_P_INFO_PLUS.ASSETP_ID = ASSET_P.ASSETP_ID AND
		ASSET_P_INFO_PLUS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
</cfquery>
<cfquery name="GET_BRAND_INFO" datasource="#DSN#">
	SELECT
		ASSET_P.ASSETP,
		ASSET_P.MAKE_YEAR,
		ASSET_P.FUEL_TYPE,
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND.BRAND_NAME
	FROM
		ASSET_P,
		SETUP_BRAND_TYPE_CAT,
		SETUP_BRAND_TYPE,
		SETUP_BRAND
	WHERE
		ASSET_P.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"> AND
		ASSET_P.BRAND_TYPE_CAT_ID = SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID AND
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND		
		SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID
</cfquery>
<cfquery name="GET_FUEL_TYPE" datasource="#DSN#">
	SELECT FUEL_ID,FUEL_NAME FROM SETUP_FUEL_TYPE
</cfquery>
<cfquery name="GET_SETUP_UNIT" datasource="#DSN#">
	SELECT UNIT, UNIT_ID FROM SETUP_UNIT
</cfquery>
<cfset pageHead ="#getLang('assetcare',93)# : #getLang('main',1656)# : #get_assetp.assetp#">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="upd_license" method="post"action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_license&assetp_id=#assetp_id#">
            <cf_box_elements>
                <div class="col col-4 col-xs-12" type="column" index="1" sort="true">

                    <div class="form-group" id="item-il">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='272.Verildiği İl'>/<cf_get_lang_main no='1226.İlçe'></label>
                        <div class="col col-3 col-xs-6">
                            <cfinput type="text" name="il" value="#get_assetp_infoplus.il#">
                        </div>
                        <div class="col col-3 col-xs-6">
                            <cfinput type="text" name="ilce" value="#get_assetp_infoplus.ilce#">
                        </div>
                    </div>

                    <div class="form-group" id="item-tescil_plaka_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="tescil_plaka_no" value="#get_brand_info.assetp#" readonly>
                        </div>
                    </div>

                    <div class="form-group" id="item-trafik_cikis_tarih">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='254.Trafiğe Çıkış Tarihi'></label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='254.Trafiğe Çıkış Tarihi'> !</cfsavecontent>
                                <cfinput type="text" name="trafik_cikis_tarih" value="#dateformat(get_assetp_infoplus.trafik_cikis_tarih,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="trafik_cikis_tarih"></span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-identification_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1658.Sase No'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text"  name="identification_number" value="#get_assetp_infoplus.identification_number#">
                        </div>
                    </div>

                    <div class="form-group" id="item-marka">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1435.Marka'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text"  name="marka" value="#get_brand_info.brand_name#" readonly>
                        </div>
                    </div>

                    <div class="form-group" id="item-model">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='813.Model'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text"  name="model" value="#get_brand_info.make_year#" readonly>
                        </div>
                    </div>

                    <div class="form-group" id="item-cins">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='269.Cinsi'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="cins" value="#get_assetp_infoplus.cins#">
                        </div>
                    </div>

                    <div class="form-group" id="item-tip">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='256.Tipi'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="tip" value="#get_assetp_infoplus.tip#">
                        </div>
                    </div>

                    <div class="form-group" id="item-renk">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='257.Renk'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="renk" value="#get_assetp_infoplus.renk#">
                        </div>
                    </div>

                    <div class="form-group" id="item-net_agirlik">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='277.Net Ağırlık'></label>
                        <div class="col col-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='277.Net Ağırlık'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                            <cfinput type="text" name="net_agirlik" id="net_agirlik" value="#tlformat(get_assetp_infoplus.net_agirlik)#" message="" onKeyup="return(FormatCurrency(this,event,0));">
                        </div>
                    </div>

                    <div class="form-group" id="item-istihap_haddi_kg">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='263.İstihap Haddi'> / <cf_get_lang no='499.Kg'></label>
                        <div class="col col-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='263.İstihab Haddi'></cfsavecontent>
                            <cfinput type="text" name="istihap_haddi_kg" id="istihap_haddi_kg" value="#tlformat(get_assetp_infoplus.istihap_haddi_kg)#" onKeyup="return(FormatCurrency(this,event));" message="#message#" >
                        </div>
                    </div>


                    <div class="form-group" id="item-istihap_haddi_kisi">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='263.İstihap Haddi'> /<cf_get_lang_main no='2034.Kişi'></label>
                        <div class="col col-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='263.İstihab Haddi'></cfsavecontent>
                            <cfinput type="text" name="istihap_haddi_kisi" id="istihap_haddi_kisi" value="#tlformat(get_assetp_infoplus.istihap_haddi_kisi)#" onKeyup="return(FormatCurrency(this,event));" message="#message#">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-xs-12" type="column" index="2" sort="true">

                    <div class="form-group" id="item-ilk_muayene_tarihi">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='278.Ilk Muayene Gecerlilik Süresi'></label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_assetp_infoplus.ilk_muayene_tarihi)>
                                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='278.İlk Muayene Geçerlilik süresi'> !</cfsavecontent>
                                    <cfinput type="text" name="ilk_muayene_tarihi" value="#dateformat(get_assetp_infoplus.ilk_muayene_tarihi,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <cfelse>
                                    <cfinput type="text" name="ilk_muayene_tarihi" validate="#validate_style#" message="İlk Muayene Geçerlilik Tarihini Düzeltiniz !">
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ilk_muayene_tarihi"></span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-tescil_sira_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='276.Tescil Sıra No'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="tescil_sira_no" value="#get_assetp_infoplus.tescil_sira_no#">
                        </div>
                    </div>

                    <div class="form-group" id="item-tescil_tarihi">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='275.Tescil Tarihi'></label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='275.Tescil Tarihi '></cfsavecontent>
                                <cfinput type="text" name="tescil_tarihi" value="#dateformat(get_assetp_infoplus.tescil_tarihi,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="tescil_tarihi"></span>
                            </div>
                        </div>
                    </div>


                    <div class="form-group" id="item-engine_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1657.Motor No'></label>
                        <div class="col col-6 col-xs-12">
                        <cfinput type="text" name="engine_number" value="#get_assetp_infoplus.engine_number#">
                        </div>
                    </div>
                    

                    <div class="form-group" id="item-motor_gucu">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='260.Motor Gücü'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="motor_gucu" value="#get_assetp_infoplus.motor_gucu#">
                        </div>
                    </div>

                    <div class="form-group" id="item-motor">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='501.Silindir Hacmi'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="motor" value="#get_assetp_infoplus.motor#">
                        </div>
                    </div>

                    <div class="form-group" id="item-usage_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='502.Kullanım Tipi'></label>
                        <div class="col col-6 col-xs-12">
                            <select name="usage_type" id="usage_type">
                                <option value=""></option>
                                <option value="1" <cfif get_assetp_infoplus.usage_type eq 1>selected</cfif>><cf_get_lang no='771.Yolcu Nakli'></option>
                                <option value="2" <cfif get_assetp_infoplus.usage_type eq 2>selected</cfif>><cf_get_lang no='772.Yük Nakli'></option>					
                            </select>
                        </div>
                    </div>

                    <div class="form-group" id="item-transport_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='258.Taşıma Tipi'></label>
                        <div class="col col-6 col-xs-12">
                            <select name="transport_type" id="transport_type">
                                <option value=""></option>
                                <option value="1" <cfif get_assetp_infoplus.transport_type eq 1>selected</cfif>><cf_get_lang no='773.Resmi'></option>
                                <option value="2" <cfif get_assetp_infoplus.transport_type eq 2>selected</cfif>><cf_get_lang_main no='1649.Ticari'></option>	
                                <option value="3" <cfif get_assetp_infoplus.transport_type eq 3>selected</cfif>><cf_get_lang no='775.Hususi'></option>									
                            </select>
                        </div>
                    </div>

                    <div class="form-group" id="item-fuel_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='2316.Yakıt Tipi'></label>
                        <div class="col col-6 col-xs-12">
                            <cfif len(get_brand_info.fuel_type)>
                                <cfquery name="get_fuel_type_record" dbtype="query">
                                    SELECT * FROM GET_FUEL_TYPE WHERE FUEL_ID = #get_brand_info.fuel_type#
                                </cfquery>
                                <cfinput type="text" name="fuel_type" value="#get_fuel_type_record.fuel_name#" readonly>
                            <cfelse>
                                <cfinput type="text" name="fuel_type" value="" readonly>
                            </cfif>
                        </div>
                    </div>

                    <div class="form-group" id="item-arac_sahibi">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='271.Araç Sahibi'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="arac_sahibi" value="#get_assetp_infoplus.arac_sahibi#" maxlength="50">
                        </div>
                    </div>

                    <div class="form-group" id="item-ikametgah_adres">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='274.İkametgah Adresi'></label>
                        <div class="col col-6 col-xs-12">
                            <textarea name="ikametgah_adres" id="ikametgah_adres"><cfoutput>#get_assetp_infoplus.ikametgah_adres#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_elements>
                <div class="col col-12 col-xs-12">

                <cf_seperator id="ek_bilgiler" header="#getLang('assetcare',264)#" is_closed="1">
                <div id="ek_bilgiler">
                    <div class="col col-4 col-xs-12"  type="column" index="3" sort="true">
                        <div class="form-group" id="item-transport_capacity">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='266.Taşıma Kapasitesi'></label>
                            <div class="col col-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='266.taşıma kapasitesi'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                                <cfinput type="text" name="transport_capacity" id="transport_capacity" maxlength="100" message="#message#" value="#get_assetp_infoplus.transport_capacity#" onKeyup="return(FormatCurrency(this,event,0));">
                            </div>
                        </div>

                        <div class="form-group" id="item-km_yakit_gideri">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='265.Km Yakıt Gideri'></label>
                            <div class="col col-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='265.km yakıt gideri'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                                <cfinput type="text" name="km_yakit_gideri" id="km_yakit_gideri"  value="#tlformat(get_assetp_infoplus.km_yakit_gideri)#" onKeyup="return(FormatCurrency(this,event));" message="#message#">
                            </div>
                        </div>

                        <div class="form-group" id="item-baslangıc_km">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='231.Başlangıç KM'></label>
                            <div class="col col-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='231.başlangıç km'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                                <cfinput type="text" name="baslangıc_km" id="baslangıc_km" message="#message#" onKeyup="return(FormatCurrency(this,event,0));" value="#get_assetp_infoplus.baslangic_km#">
                            </div>
                        </div>

                        <div class="form-group" id="item-property2">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='95.özellik'></label>
                            <div class="col col-6 col-xs-12">
                                <cfinput type="text" value="#get_assetp_infoplus.property2#" name="property2" maxlength="100">
                            </div>
                        </div>

                        <div class="form-group" id="item-property4">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='97.özellik'></label>
                            <div class="col col-6 col-xs-12">
                                <cfinput type="text" value="#get_assetp_infoplus.property4#" name="property4" maxlength="100">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-xs-12"  type="column" index="4" sort="true">

                        <div class="form-group" id="item-unit_id">
                            <label class="col col-4 col-xs-12"></label>
                            <div class="col col-6 col-xs-12">
                                <select name="unit_id" id="unit_id">
                                    <cfoutput query="get_setup_unit">
                                    <option value="#unit_id#" <cfif get_assetp_infoplus.unit_id eq unit_id>selected</cfif>>#unit#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>

                        <div class="form-group" id="item-size">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='301.Boyut'></label>
                            <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='281.en'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                            <cfsavecontent variable="message2"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='282.boy'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                            <cfsavecontent variable="message3"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='284.yükseklik'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                            <div class="col col-2 col-xs-4">
                                <cfinput type="text" name="en" id="en" message="#message#" onKeyup="return(FormatCurrency(this,event,0));" value="#get_assetp_infoplus.en#" placeholder="#getLang('assetcare',281)#">
                            </div>
                            <div class="col col-2 col-xs-4">
                                <cfinput type="text" name="boy" id="boy" message="#message2#" onKeyup="return(FormatCurrency(this,event,0));" value="#get_assetp_infoplus.boy#" placeholder="#getLang('assetcare',282)#">   
                            </div>
                            <div class="col col-2 col-xs-4">
                                <cfinput type="text" name="yukseklik" id="yukseklik"  message="#message3#" onKeyup="return(FormatCurrency(this,event,0));" value="#get_assetp_infoplus.yukseklik#" placeholder="#getLang('main',284)#">
                            </div>
                        </div>

                        <div class="form-group" id="item-property1">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='94.Özellik 1'></label>
                            <div class="col col-6 col-xs-12">
                                <cfinput type="text" value="#get_assetp_infoplus.property1#" name="property1" maxlength="100">
                            </div>
                        </div>

                        <div class="form-group" id="item-property3">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='96.özellik'></label>
                            <div class="col col-6 col-xs-12">
                                <cfinput type="text" value="#get_assetp_infoplus.property3#" name="property3" maxlength="100">
                            </div>
                        </div>

                        <div class="form-group" id="item-property5">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='98.özellik'></label>
                            <div class="col col-6 col-xs-12">
                                <cfinput type="text"  value="#get_assetp_infoplus.property5#" name="property5" maxlength="100">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            </cf_box_elements>
                  
            <cf_box_footer>
                <cfif not get_assetp_infoplus.recordCount>
                    <cf_workcube_buttons is_upd='0' is_delete='0' is_cancel='0' is_reset='0' add_function='kontrol()'>
                <cfelse>
                    <cf_record_info query="get_assetp_infoplus">
                    <cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' is_reset='0' add_function='kontrol()'>
                </cfif>
            </cf_box_footer>
        </cfform>
    </cf_box> 
</div>
<script type="text/javascript">
	function kontrol()
	{
        unformat_fields();
		x = (150 - upd_license.ikametgah_adres.value.length);
		if ( x < 0 )
		{ 
			alert ("İkametgah Adresi "+ ((-1) * x) +" Karakter Uzun");
			return false;
		}
	}	
	function unformat_fields()
	{
        document.upd_license.net_agirlik.value = if (document.upd_license.net_agirlik.value != '') parseFloat(filterNum(document.upd_license.net_agirlik.value)) else 0;
		document.upd_license.istihap_haddi_kg.value = if (document.upd_license.istihap_haddi_kg.value != '') parseFloat(filterNum(document.upd_license.istihap_haddi_kg.value)) else 0;
		document.upd_license.istihap_haddi_kisi.value = if (document.upd_license.istihap_haddi_kisi.value != '') parseFloat(filterNum(document.upd_license.istihap_haddi_kisi.value)) else 0;
        document.upd_license.km_yakit_gideri.value = if (document.upd_license.km_yakit_gideri.value != '') parseFloat(filterNum(document.upd_license.km_yakit_gideri.value)) else 0;
	}
</script>
