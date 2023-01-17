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

<cfform name="upd_license" method="post"action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_license&assetp_id=#assetp_id#" onsubmit="return(unformat_fields());">
<table width="100%" height="100%" >
    <tr valign="middle">
        <td class="headbold">
            <cf_medium_list_search title=" #getLang('assetcare',93)# #getLang('main',1656)# : #get_assetp.assetp# #images_#"></cf_medium_list_search>
        </td>
    </tr>
    <tr valign="top">
        <td>
        <table>
            <tr>
                <td width="25%" valign="top">
                <table width="312" border="0">
                    <tr>
                        <td width="112" valign="top"><cf_get_lang no='272.Verildiği İl'>/<cf_get_lang_main no='1226.İlçe'> </td>
                        <td width="190" valign="top">
                            <cfinput type="text" name="il" value="#get_assetp_infoplus.il#" style="width:73px">
                            <cfinput type="text" name="ilce" value="#get_assetp_infoplus.ilce#" style="width:74px">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='1656.Plaka'></td>
                        <td valign="top"><cfinput type="text" name="tescil_plaka_no" value="#get_brand_info.assetp#" readonly style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='254.Trafiğe Çıkış Tarihi'></td>
                        <td valign="top">
                            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='254.Trafiğe Çıkış Tarihi'> !</cfsavecontent>
                            <cfinput type="text" name="trafik_cikis_tarih" value="#dateformat(get_assetp_infoplus.trafik_cikis_tarih,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:150px">
                            <cf_wrk_date_image date_field="trafik_cikis_tarih">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='1658.Sase No'></td>
                        <td valign="top"><cfinput type="text"  name="identification_number" value="#get_assetp_infoplus.identification_number#" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='1435.Marka'> </td>
                        <td valign="top"><cfinput type="text"  name="marka" value="#get_brand_info.brand_name#" style="width:150px" readonly></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='813.Model'></td>
                        <td valign="top"><cfinput type="text"  name="model" value="#get_brand_info.make_year#" style="width:150px" readonly></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='269.Cinsi'></td>
                        <td valign="top"><cfinput type="text" name="cins" value="#get_assetp_infoplus.cins#" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='256.Tipi'></td>
                        <td valign="top"><cfinput type="text" name="tip" value="#get_assetp_infoplus.tip#" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td height="25" valign="top"><cf_get_lang no='257.Renk'></td>
                        <td valign="top"><cfinput type="text" name="renk" value="#get_assetp_infoplus.renk#" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='277.Net Ağırlık'></td>
                        <td valign="top">
                        <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='277.Net Ağırlık'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                        <cfinput type="text" name="net_agirlik" value="#tlformat(get_assetp_infoplus.net_agirlik,0)#" message="" onKeyup="return(FormatCurrency(this,event,0));" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='263.İstihap Haddi'> / <cf_get_lang no='499.Kg'></td>
                        <td valign="top">
                            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='263.İstihab Haddi'></cfsavecontent>
                            <cfinput type="text" name="istihap_haddi_kg" value="#tlformat(get_assetp_infoplus.istihap_haddi_kg,0)#" onKeyup="return(FormatCurrency(this,event,0));" message="#message#" style="width:150px">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='263.İstihap Haddi'> /<cf_get_lang_main no='2034.Kişi'></td>
                        <td valign="top">
                            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='263.İstihab Haddi'></cfsavecontent>
                            <cfinput type="text" name="istihap_haddi_kisi" style="width:150px" value="#tlformat(get_assetp_infoplus.istihap_haddi_kisi,0)#" onKeyup="return(FormatCurrency(this,event,0));" message="#message#">
                        </td> 
                    </tr>
                </table>
                </td>
                <td width="75%" valign="top">
                <table width="368">
                    <tr>
                        <td valign="top"><cf_get_lang no='278.Ilk Muayene Gecerlilik Süresi'></td>
                        <td valign="top">
                            <cfif len(get_assetp_infoplus.ilk_muayene_tarihi)>
                                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='278.İlk Muayene Geçerlilik süresi'> !</cfsavecontent>
                                <cfinput type="text" name="ilk_muayene_tarihi" value="#dateformat(get_assetp_infoplus.ilk_muayene_tarihi,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:150px">
                            <cfelse>
                                <cfinput type="text" name="ilk_muayene_tarihi" validate="#validate_style#" message="İlk Muayene Geçerlilik Tarihini Düzeltiniz !" style="width:150px">
                            </cfif>
                            <cf_wrk_date_image date_field="ilk_muayene_tarihi">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='276.Tescil Sıra No'></td>
                        <td valign="top"><cfinput type="text" name="tescil_sira_no" value="#get_assetp_infoplus.tescil_sira_no#" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='275.Tescil Tarihi'></td>
                        <td valign="top">
                            <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='275.Tescil Tarihi '></cfsavecontent>
                            <cfinput type="text" name="tescil_tarihi" value="#dateformat(get_assetp_infoplus.tescil_tarihi,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:150px">
                            <cf_wrk_date_image date_field="tescil_tarihi">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='1657.Motor No'></td>
                        <td valign="top"><cfinput type="text" name="engine_number" value="#get_assetp_infoplus.engine_number#" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='260.Motor Gücü'></td>
                        <td valign="top"><cfinput type="text" name="motor_gucu" value="#get_assetp_infoplus.motor_gucu#" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='501.Silindir Hacmi'></td>
                        <td valign="top"><cfinput type="text" name="motor" value="#get_assetp_infoplus.motor#" style="width:150px"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='502.Kullanım Tipi'></td>
                        <td valign="top">
                            <select name="usage_type" id="usage_type" style="width:150px;">
                                <option value=""></option>
                                <option value="1" <cfif get_assetp_infoplus.usage_type eq 1>selected</cfif>><cf_get_lang no='771.Yolcu Nakli'></option>
                                <option value="2" <cfif get_assetp_infoplus.usage_type eq 2>selected</cfif>><cf_get_lang no='772.Yük Nakli'></option>					
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='258.Taşıma Tipi'></td>
                        <td valign="top">
                            <select name="transport_type" id="transport_type" style="width:150px;">
                                <option value=""></option>
                                <option value="1" <cfif get_assetp_infoplus.transport_type eq 1>selected</cfif>><cf_get_lang no='773.Resmi'></option>
                                <option value="2" <cfif get_assetp_infoplus.transport_type eq 2>selected</cfif>><cf_get_lang_main no='1649.Ticari'></option>	
                                <option value="3" <cfif get_assetp_infoplus.transport_type eq 3>selected</cfif>><cf_get_lang no='775.Hususi'></option>									
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='2316.Yakıt Tipi'></td>
                        <td valign="top">
                            <cfif len(get_brand_info.fuel_type)>
                                <cfquery name="get_fuel_type_record" dbtype="query">
                                    SELECT * FROM GET_FUEL_TYPE WHERE FUEL_ID = #get_brand_info.fuel_type#
                                </cfquery>
                                <cfinput type="text" name="fuel_type" value="#get_fuel_type_record.fuel_name#" readonly style="width:150px">
                            <cfelse>
                                <cfinput type="text" name="fuel_type" value="" readonly style="width:150px">
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='271.Araç Sahibi'></td>
                        <td valign="top"><cfinput type="text" name="arac_sahibi" value="#get_assetp_infoplus.arac_sahibi#" style="width:150px" maxlength="50"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='274.İkametgah Adresi'></td>
                        <td valign="top"><textarea name="ikametgah_adres" id="ikametgah_adres" style="width:150px;height:50px;"><cfoutput>#get_assetp_infoplus.ikametgah_adres#</cfoutput></textarea></td>
                    </tr>
                </table>
                </td>
            </tr>
        </table>
        <cf_seperator id="ek_bilgiler" header="#getLang('assetcare',264)#" is_closed="1">
        <table id="ek_bilgiler">
            <tr>
                <td width="112"><cf_get_lang no='266.Taşıma Kapasitesi'></td>
                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='266.taşıma kapasitesi'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                <td width="200"><cfinput type="text" name="transport_capacity" maxlength="100" style="width:150px;" message="#message#" value="#tlformat(get_assetp_infoplus.transport_capacity)#" onKeyup="return(FormatCurrency(this,event,0));"></td>
                <td width="160"></td>
                <td>              
                    <select name="unit_id" id="unit_id" style="width:55">
                        <cfoutput query="get_setup_unit">
                          <option value="#unit_id#" <cfif get_assetp_infoplus.unit_id eq unit_id>selected</cfif>>#unit#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no='265.Km Yakıt Gideri'></td>
                  <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='265.km yakıt gideri'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                <td><cfinput type="text" name="km_yakit_gideri"  style="width:150px;" value="#tlformat(get_assetp_infoplus.km_yakit_gideri)#" onKeyup="return(FormatCurrency(this,event));" message="#message#"></td>
                <td><cf_get_lang_main no='301.Boyut'></td>
                <td width="380">
                  <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='281.en'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                  <cfsavecontent variable="message2"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='282.boy'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                  <cfsavecontent variable="message3"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='284.yükseklik'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                  <cfinput type="text" name="en" style="width:38px;" message="#message#" onKeyup="return(FormatCurrency(this,event,0));" value="#tlformat(get_assetp_infoplus.en)#">
                  <cfinput type="text" name="boy" style="width:38px;" message="#message2#" onKeyup="return(FormatCurrency(this,event,0));" value="#tlformat(get_assetp_infoplus.boy)#">
                  <cfinput type="text" name="yukseklik" style="width:38px;" message="#message3#" onKeyup="return(FormatCurrency(this,event,0));" value="#tlformat(get_assetp_infoplus.yukseklik)#">
                 ( <cf_get_lang no='281.en'> * <cf_get_lang no='282.boy'> *<cf_get_lang_main no='284. yükseklik'> <cf_get_lang_main no='1906.cm'>) </td>
            </tr>
            <tr>
                <td><cf_get_lang no='231.Başlangıç KM'></td>
                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='231.başlangıç km'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                <td><cfinput type="text" name="baslangıc_km" style="width:150px" message="#message#" onKeyup="return(FormatCurrency(this,event,0));" value="#tlformat(get_assetp_infoplus.baslangic_km)#">
                </td>
                <td><cf_get_lang no='94.Özellik 1'> </td>
                <td><cfinput type="text" style="width:150px" value="#get_assetp_infoplus.property1#" name="property1" maxlength="100"></td>
            </tr>
            <tr>
                <td><cf_get_lang no='95.özellik'></td>
                <td><cfinput type="text" style="width:150px" value="#get_assetp_infoplus.property2#" name="property2" maxlength="100"></td>
                <td><cf_get_lang no='96.özellik'></td>
                <td><cfinput type="text" style="width:150px" value="#get_assetp_infoplus.property3#" name="property3" maxlength="100"></td>
            </tr>
            <tr>
                <td><cf_get_lang no='97.özellik'> </td>
                <td><cfinput type="text" style="width:150px" value="#get_assetp_infoplus.property4#" name="property4" maxlength="100">
                </td>
                <td><cf_get_lang no='98.özellik'></td>
                <td><cfinput type="text" style="width:150px" value="#get_assetp_infoplus.property5#" name="property5" maxlength="100"></td>
            </tr>
        </table>   
        <table>
            <tr>
                <cfif len(get_assetp_infoplus.record_emp) and not len(get_assetp_infoplus.update_emp)>
                    <td colspan="2" valign="top" class="txtbold"><cf_get_lang_main no='71.Kayıt'> :<cfoutput>#get_emp_info(get_assetp_ınfoplus.record_emp,0,0)# - #dateformat(get_assetp_ınfoplus.record_date,dateformat_style)# #timeformat(get_assetp_ınfoplus.record_date,timeformat_style)#</cfoutput></td>
                </cfif>  
            </tr>
            <tr>
                <cfif len(get_assetp_infoplus.update_emp)> 
                    <td colspan="2" valign="top" class="txtbold"><cf_get_lang_main no='479.Güncelleyen'> :<cfoutput>#get_emp_info(get_assetp_ınfoplus.update_emp,0,0)# - #dateformat(get_assetp_ınfoplus.update_date,dateformat_style)# #timeformat(get_assetp_ınfoplus.update_date,timeformat_style)#</cfoutput></td>
                </cfif>
            </tr> 
     	</table>                     
        </td>
    </tr>
</table>
<cf_form_box_footer><cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' is_reset='0' add_function='kontrol()'></cf_form_box_footer>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		x = (150 - upd_license.ikametgah_adres.value.length);
		if ( x < 0 )
		{ 
			alert ("İkametgah Adresi "+ ((-1) * x) +" Karakter Uzun");
			return false;
		}
	}	
	function unformat_fields()
	{
		$('#net_agirlik').val() = filterNum($('#net_agirlik').val());
		$('#istihap_haddi_kg').val() = filterNum($('#istihap_haddi_kg').val());
		$('#istihap_haddi_kisi').val() = filterNum($('#istihap_haddi_kisi').val());
		$('#km_yakit_gideri').val()= filterNum($('#km_yakit_gideri').val());
		$('#transport_capacity').val() = filterNum($('#transport_capacity').val());
		$('#en').val()= filterNum($('#en').val());
		$('#boy').val() = filterNum($('#boy').val());
		$('#yukseklik').val() = filterNum($('#yukseklik').val());
		$('#baslangıc_km').val() = filterNum($('#baslangıc_km').val());	
	}
</script>
