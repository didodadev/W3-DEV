<cfabort>
<cfquery name="GET_SETUP_UNIT" datasource="#DSN#">
SELECT UNIT, UNIT_ID FROM SETUP_UNIT
</cfquery>
<cf_popup_box title="#getLang('assetcare',93)#">
	<cfform name="asset_care" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_ship_info&assetp_id=#assetp_id#" >
		<table>
			<tr>
				<td width="125"><cf_get_lang no='255.Tescil Araç No'></td>
				<td width="210"><cfinput type="text" name="tescil_plaka_no" style="width:150px;"></td>
				<td width="125"><cf_get_lang no='267.Yakıt Tipi'></td>
				<td><cfinput type="text" name="yakit_tipi" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='254.Trafiğe Çıkış Tarihi'></td>
				<td><cfinput type="text" name="trafik_cikis_tarih" style="width:150px;"  validate="#validate_style#" message="Lütfen Trafiğe Çıkış Tarihi Giriniz !">
				<cf_wrk_date_image date_field="trafik_cikis_tarih"></td>
				<td width="134"><cf_get_lang no='270.Seri V No'></td>
				<td><cfinput type="text" name="seri_v_no" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='269.Cinsi'></td>
				<td ><cfinput type="text" name="cins" style="width:150px;">
				</td>
				<td><cf_get_lang no='271.Araç Sahibi'></td>
				<td><cfinput type="text" name="arac_sahibi" style="width:150px;"></td>
			</tr>
			<tr>
				<td ><cf_get_lang no='256.Tipi'></td>
				<td><cfinput type="text" name="tip" style="width:150px;">
				</td>
				<td><cf_get_lang no='272.Verildiği İl'>/<cf_get_lang_main no='1226.İlçe'></td>
				<td><cfinput type="text" name="il" style="width:75">
					<cfinput type="text" name="ilce" style="width:70">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='257.Renk'></td>
				<td><cfinput type="text" name="renk" style="width:150px;"></td>
				<td rowspan="3"><cf_get_lang no='274.İkametgah Adresi'></td>
				<td rowspan="3"><textarea name="ikametgah_adres" id="ikametgah_adres" style="width:150px;height:45px;"></textarea></td>
			</tr>
			<tr>
			</tr>
			<tr>
				<td><cf_get_lang no='258.Taşıma Tipi'></td>
				<td><cfinput type="text" name="tasima_tipi" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='259.Motor'></td>
				<td><cfinput type="text" name="motor" style="width:150px;"></td>
				<td><cf_get_lang no='275.Tescil Tarihi'></td>
				<td>
					<cfinput type="text" name="tescil_tarihi" style="width:150px;" validate="#validate_style#" message="Lütfen Tescil Tarihi Giriniz !">
					<cf_wrk_date_image date_field="tescil_tarihi">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='260.Motor Gücü'></td>
				<td><cfinput type="text" name="motor_gucu" style="width:150px;"></td>
				<td><cf_get_lang no='276.Tescil Sıra No'></td>
				<td><cfinput type="text" name="tescil_sira_no" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='261.Şasi No'></td>
				<td><cfinput type="text" name="sasi_no" style="width:150px;">
				</td>
				<td><cf_get_lang no='277.Net Ağırlık'></td>
				<td><cfinput type="text" name="net_agirlik" style="width:150px;" message="Lütfen Sayısal Değer Giriniz !" onKeyup="return(FormatCurrency(this,event,0));">
				</td>
			<tr>
				<td><cf_get_lang no='262.Seri P No'></td>
				<td><cfinput type="text" name="serial_p_no" style="width:150px;">
				</td>
				<td><cf_get_lang no='278.İlk Muayene G Süresi'></td>
				<td><cfinput type="text" name="ilk_muayene_g_suresi" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='263.İstihap Haddi'></td>
				<td><cfinput type="text" name="istihap_haddi" style="width:150px;" onKeyup="return(FormatCurrency(this,event,0));" message="İstihab Haddi Sayısal Olmalıdır !">
				</td>
				<td><cf_get_lang no='279.Onaylayan Sicil'></td>
				<td><cfinput type="text" name="onaylayan_sicil" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td colspan="4" class="txtbold"><cf_get_lang no='264.Ek Özellikler'></td>
			</tr>
			<tr>
				<td><cf_get_lang no='265.Km Yakıt Gideri'><br/>
				</td>
				<td><cfinput type="text" name="km_yakit_gideri" style="width:150px;" onKeyup="return(FormatCurrency(this,event));" message="Km Yakıt Gideri Sayısal Olmalıdır !">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='266.Taşıma Kapasitesi'></td>
				<td><cfinput type="text" name="transport_capacity" maxlength="100" style="width:80" message="Taşıma Kapasitesi Sayısal Olmalıdır !" onKeyup="return(FormatCurrency(this,event,0));">
					<select name="unit_id" id="unit_id"  style="width:35">
						<cfoutput query="get_setup_unit">
							<option value="#unit_id#">#unit#</option>
						</cfoutput>
					</select>
				</td>
				<td><cf_get_lang_main no='301.Boyut'><cf_get_lang_main no='1906.cm'></td>
				<td><cfinput type="text" name="en" style="width:25" message="En Sayısal Olmalıdır !" onKeyup="return(FormatCurrency(this,event,0));">
				<cfinput type="text" name="boy" style="width:25" message="Boy Sayısal Olmalıdır !" onKeyup="return(FormatCurrency(this,event,0));">
				<cfinput type="text" name="yukseklik" style="width:25" message="Yükseklik Sayısal Olmalıdır !" onKeyup="return(FormatCurrency(this,event,0));">
				( <cf_get_lang no='281.en'> * <cf_get_lang no='282.boy'> *<cf_get_lang_main no='284. yükseklik'>) </td>
			</tr>
			<tr>
				<td><cf_get_lang no='231.Başlangıç KM'></td>
				<td><cfinput type="text" name="baslangıc_km" style="width:150px;" message="Başlangıç KM Sayısal Olmalıdır !" onKeyup="return(FormatCurrency(this,event,0));">
				</td>
				<td><cf_get_lang no='94.Özellik 1'> </td>
				<td><cfinput type="text" style="width:150px;"  name="property1" maxlength="100">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='95.özellik'></td>
				<td><cfinput type="text" style="width:150px;"  name="property2" maxlength="100">
				</td>
				<td><cf_get_lang no='96.özellik'></td>
				<td><cfinput type="text" style="width:150px;"  name="property3" maxlength="100">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='97.özellik'> </td>
				<td><cfinput type="text" style="width:150px;"  name="property4" maxlength="100">
				</td>
				<td><cf_get_lang no='98.özellik'></td>
				<td><cfinput type="text" style="width:150px;"  name="property5" maxlength="100">
				</td>
			</tr>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function='clear_currency()'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
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

