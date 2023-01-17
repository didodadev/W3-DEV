<cfquery name="GET_ASSETP_INFOPLUS" datasource="#DSN#">
	SELECT 
    	ASSET_SHIP_ID, 
        ASSETP_ID,
        PROPERTY1, 
        PROPERTY2, 
        PROPERTY3, 
        PROPERTY4, 
        PROPERTY5, 
        TRANSPORT_CAPACITY, 
        EN, 
        BOY, 
        YUKSEKLIK, 
        BASLANGIC_KM, 
        UNIT_ID, 
        KM_YAKIT_GIDERI, 
        TESCIL_PLAKA_NO, 
        TRAFIK_CIKIS_TARIH, 
        CINS, 
        TIP, 
        RENK,
        MOTOR, 
        TESCIL_SIRA_NO, 
        TESCIL_TARIHI, 
        MOTOR_GUCU, 
        ARAC_SAHIBI, 
        IKAMETGAH_ADRES, 
        TARIH, 
        IL, 
        ILCE, 
        NET_AGIRLIK, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        ENGINE_NUMBER, 
        IDENTIFICATION_NUMBER 
    FROM 
    	ASSET_P_INFO_PLUS 
    WHERE 
    	ASSETP_ID=#URL.ASSETP_ID#
</cfquery>
<cfquery name="GET_SETUP_UNIT" datasource="#DSN#">
	SELECT UNIT, UNIT_ID FROM SETUP_UNIT
</cfquery>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=assetcare.popup_add_ship_info&assetp_id=#assetp_id#</cfoutput>"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
<cfform action="#request.self#?fuseaction=assetcare.emptypopup_upd_ship_info&assetp_id=#assetp_id#" method="post" name="asset_care">
<cf_popup_box title="#getLang('assetcare',93)#" right_images="#img#">
    <input type="hidden" name="asset_ship_id" id="asset_ship_id" value="<cfoutput>#get_assetp_infoplus.asset_ship_id#</cfoutput>">
        <table>
            <tr>
                <td valign="top" width="30%">
                    <table>
                        <tr>
                            <td><cf_get_lang no='255.Tescil Araç No'></td>
                            <td><cfinput type="text" name="tescil_plaka_no" style="width:150" value="#get_assetp_infoplus.tescil_plaka_no#"></td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap"><cf_get_lang no='254.Trafiğe Çıkış Tarihi'>
                                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='254.Trafiğe Çıkış Tarihi'></cfsavecontent></td>
                            <td nowrap="nowrap"><cfinput type="text" name="trafik_cikis_tarih" style="width:150" validate="#validate_style#" value="#dateformat(get_assetp_infoplus.trafik_cikis_tarih,dateformat_style)#" message="#message#">
                                <cf_wrk_date_image date_field="trafik_cikis_tarih">
                           </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='269.Cinsi'></td>
                            <td><cfinput type="text" name="cins" style="width:150" value="#get_assetp_infoplus.cins#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='256.Tipi'></td>
                            <td><cfinput type="text" name="tip" style="width:150" value="#get_assetp_infoplus.tip#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='257.Renk'></td>
                            <td><cfinput type="text" name="renk" style="width:150" value="#get_assetp_infoplus.renk#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='259.Motor'></td>
                            <td><cfinput type="text" name="motor" style="width:150" value="#get_assetp_infoplus.motor#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='260.Motor Gücü'></td>
                            <td><cfinput type="text" name="motor_gucu" style="width:150" value="#get_assetp_infoplus.motor_gucu#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='261.Şasi No'></td>
                            <td><cfinput type="text" name="sasi_no" style="width:150" value=""></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='262.Seri P No'></td>
                            <td><cfinput type="text" name="serial_p_no" style="width:150" value=""> </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='279.Onaylayan Sicil'></td>
                            <td><cfinput type="text" name="onaylayan_sicil" style="width:150" value=""></td>
                        </tr>
                        <tr>
                            <td width="135"><cf_get_lang no='267.Yakıt Tipi'></td>
                            <td><cfinput type="text" name="yakit_tipi" style="width:150" value=""></td>
                        </tr>
                        <tr>
                            <td width="134"><cf_get_lang no='270.Seri V No'></td>
                            <td><cfinput type="text" name="seri_v_no" style="width:150" value=""> </td>
                        </tr>
                    </table>
                </td>
                <td valign="top" width="60%">   
                     <table>
                        <tr>
                            <td width="100"><cf_get_lang no='271.Araç Sahibi'></td>
                            <td width="368"><cfinput type="text" name="arac_sahibi" style="width:150" value="#get_assetp_infoplus.arac_sahibi#"> </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='272.Verildiği İl'>/<cf_get_lang_main no='1226.İlçe'></td>
                            <td><cfinput type="text" name="il" style="width:70" value="#get_assetp_infoplus.il#"><br />
                                <cfinput type="text" name="ilce" style="width:70"  value="#get_assetp_infoplus.ilce#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='274.İkametgah Adresi'></td>
                            <td><textarea name="ikametgah_adres" id="ikametgah_adres" style="width:122px;height:45px;"><cfoutput>#get_assetp_infoplus.ikametgah_adres#</cfoutput></textarea></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='258.Taşıma Tipi'></td>
                            <td><cfinput type="text" name="tasima_tipi" style="width:150" value=""></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='275.Tescil Tarihi'>
                                <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='275.Tescil Tarihi Girmelisiniz'></cfsavecontent></td>
                            <td><cfinput type="text" name="tescil_tarihi" style="width:150" value="#dateformat(get_assetp_infoplus.tescil_tarihi,dateformat_style)#" message="#message#">
                            <cf_wrk_date_image date_field="tescil_tarihi"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='276.Tescil Sıra No'></td>
                            <td><cfinput type="text" name="tescil_sira_no" style="width:150" value="#get_assetp_infoplus.tescil_sira_no#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='277.Net Ağırlık'></td>
                            <td><cfinput type="text" name="net_agirlik" style="width:150" value="" message="Net Ağırlık Sayısal Olmalıdır !" onKeyup="return(FormatCurrency(this,event,0));"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='263.İstihap Haddi'></td>
                                <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='263.İstihab Haddi'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
                            <td><cfinput type="text" name="istihap_haddi" style="width:150" value="" onKeyup="return(FormatCurrency(this,event,0));" message="#message#"></td>
                        </tr>
                        <tr>
                           
                            <td><cf_get_lang no='278.İlk Muayene G Süresi'></td>
                            <td><cfinput type="text" name="ilk_muayene_g_suresi" style="width:150" value="">
                            </td>
                        </tr>
                     </table>
                </td>
           </tr>
       </table>
    <table>
    <cf_seperator id="ek_bilgiler" header="#getLang('assetcare',264)#">
    <table id="ek_bilgiler">
        <tr>
            <td><cf_get_lang no='266.Taşıma Kapasitesi'></td>
            <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='266.taşıma kapasitesi'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
            <td><cfinput type="text" name="transport_capacity" maxlength="100" style="width:90" message="#message#" value="#tlformat(get_assetp_infoplus.transport_capacity)#" onKeyup="return(FormatCurrency(this,event,0));"></td>
			<td colspan="2">              
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
            <td><cfinput type="text" name="km_yakit_gideri" style="width:150" value="#tlformat(get_assetp_infoplus.km_yakit_gideri)#" onKeyup="return(FormatCurrency(this,event));" message="#message#"></td>
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
            <td><cfinput type="text" name="baslangıc_km" style="width:150" message="#message#" onKeyup="return(FormatCurrency(this,event,0));" value="#tlformat(get_assetp_infoplus.baslangic_km)#">
            </td>
            <td><cf_get_lang no='94.Özellik 1'> </td>
            <td><cfinput type="text" style="width:150" value="#get_assetp_infoplus.property1#" name="property1" maxlength="100"></td>
        </tr>
        <tr>
            <td><cf_get_lang no='95.özellik'></td>
            <td><cfinput type="text" style="width:150" value="#get_assetp_infoplus.property2#" name="property2" maxlength="100"></td>
            <td><cf_get_lang no='96.özellik'></td>
            <td><cfinput type="text" style="width:150" value="#get_assetp_infoplus.property3#" name="property3" maxlength="100"></td>
        </tr>
        <tr>
            <td><cf_get_lang no='97.özellik'> </td>
            <td><cfinput type="text" style="width:150" value="#get_assetp_infoplus.property4#" name="property4" maxlength="100">
            </td>
            <td><cf_get_lang no='98.özellik'></td>
            <td><cfinput type="text" style="width:150" value="#get_assetp_infoplus.property5#" name="property5" maxlength="100"></td>
        </tr>
    </table>
    <cf_popup_box_footer>
        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='clear_currency()' type_format='1'>
    </cf_popup_box_footer>
</cf_popup_box>
</cfform>
<script type="text/javascript">
	function clear_currency()
		{
			asset_care.km_yakit_gideri.value = filterNum(asset_care.km_yakit_gideri.value);
			asset_care.net_agirlik.value = filterNum(asset_care.net_agirlik.value);
			asset_care.istihap_haddi.value = filterNum(asset_care.istihap_haddi.value);
			asset_care.transport_capacity.value = filterNum(asset_care.transport_capacity.value);
			asset_care.en.value = filterNum(asset_care.en.value);
			asset_care.boy.value = filterNum(asset_care.boy.value);
			asset_care.yukseklik.value = filterNum(asset_care.yukseklik.value);
			asset_care.baslangıc_km.value = filterNum(asset_care.baslangıc_km.value);
		}
</script>

