<cfoutput>
#attributes.km_yakit_gideri#<br/>
#attributes.net_agirlik#<br/>
#attributes.istihap_haddi#<br/>
#attributes.transport_capacity#<br/>
#attributes.en#<br/>
#attributes.boy#<br/>
#attributes.yukseklik#<br/>
#attributes.baslangıc_km#<br/>
</cfoutput>

ssssss333
<cfabort>
<cf_date tarih='attributes.trafik_cikis_tarih'>
<cf_date tarih='attributes.tescil_tarihi'>
<cf_date tarih='attributes.tarih'>
<cfquery name="ADD_SHIP_INFO" datasource="#DSN#">
	UPDATE 
		ASSET_P_INFO_PLUS 
	SET
		ASSETP_ID = #ATTRIBUTES.ASSETP_ID#,
		TRANSPORT_CAPACITY = <cfif len(attributes.transport_capacity)>#attributes.transport_capacity#,<cfelse>null,</cfif>
		UNIT_ID = <cfif len(attributes.unit_id)>#attributes.unit_id#,<cfelse>null,</cfif>
		EN = <cfif len(attributes.en)>#attributes.en#,<cfelse>null,</cfif>
		BOY = <cfif len(attributes.boy)>#attributes.boy#,<cfelse>null,</cfif>
		YUKSEKLIK = <cfif len(attributes.yukseklik)>#attributes.yukseklik#,<cfelse>null,</cfif>
		BASLANGIC_KM = <cfif len(attributes.baslangic_km)>#attributes.baslangic_km#,<cfelse>null,</cfif>
		PROPERTY1 = <cfif len(attributes.property1)>'#attributes.property1#',<cfelse>null,</cfif>
		PROPERTY2 = <cfif len(attributes.property2)>'#attributes.property2#',<cfelse>null,</cfif>
		PROPERTY3 = <cfif len(attributes.property3)>'#attributes.property3#',<cfelse>null,</cfif>
		PROPERTY4 = <cfif len(attributes.property4)>'#attributes.property4#',<cfelse>null,</cfif>
		PROPERTY5 = <cfif len(attributes.property5)>'#attributes.property5#',<cfelse>null,</cfif>
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		KM_YAKIT_GIDERI = <cfif len(attributes.km_yakit_gideri)>#attributes.km_yakit_gideri#,<cfelse>null,</cfif>
		TESCIL_PLAKA_NO = <cfif len(attributes.tescil_plaka_no)>'#attributes.tescil_plaka_no#',<cfelse>null,</cfif>
		TRAFIK_CIKIS_TARIH  = <cfif len(attributes.trafik_cikis_tarih)>#attributes.trafik_cikis_tarih#,<cfelse>null,</cfif>
		CINS = <cfif len(attributes.cins)>'#attributes.cins#',<cfelse>null,</cfif>
		TIP = <cfif len(attributes.tip)>'#attributes.tip#',<cfelse>null,</cfif>
		RENK = <cfif len(attributes.renk)>'#attributes.renk#',<cfelse>null,</cfif>
		MOTOR = <cfif len(attributes.motor)>'#attributes.motor#',<cfelse>null,</cfif>
		<!--- SASI_NO = <cfif len(attributes.sasi_no)>'#attributes.sasi_no#',<cfelse>null,</cfif> 
		ISTIHAP_HADDI = <cfif len(attributes.istihap_haddi)>#attributes.istihap_haddi#,<cfelse>null,</cfif>
		ONAYLAYAN_SICIL = <cfif len(attributes.onaylayan_sicil)>'#attributes.onaylayan_sicil#',<cfelse>null,</cfif>
		ILK_MUAYENE_G_SURESI = <cfif len(attributes.ilk_muayene_g_suresi)>'#attributes.ilk_muayene_g_suresi#',<cfelse>null,</cfif>
		SERIAL_P_NO = <cfif len(attributes.serial_p_no)>'#attributes.serial_p_no#',<cfelse>null,</cfif>--->
		TESCIL_SIRA_NO = <cfif len(attributes.tescil_sira_no)>'#attributes.tescil_sira_no#',<cfelse>null,</cfif>
		TESCIL_TARIHI = <cfif len(attributes.tescil_tarihi)>#attributes.tescil_tarihi#,<cfelse>null,</cfif>
		MOTOR_GUCU = <cfif len(attributes.motor_gucu)>'#attributes.motor_gucu#',<cfelse>null,</cfif>
		<!--- TASIMA_TIPI = <cfif len(attributes.tasima_tipi)>'#attributes.tasima_tipi#',<cfelse>null,</cfif> 
		YAKIT_TIPI = <cfif len(attributes.yakit_tipi)>'#attributes.yakit_tipi#',<cfelse>null,</cfif>
		SERI_V_NO = <cfif len(attributes.seri_v_no)>'#attributes.seri_v_no#',<cfelse>null,</cfif>--->
		ARAC_SAHIBI = <cfif len(attributes.arac_sahibi)>'#attributes.arac_sahibi#',<cfelse>null,</cfif>
		IKAMETGAH_ADRES = <cfif len(attributes.ikametgah_adres)>'#attributes.ikametgah_adres#',<cfelse>null,</cfif>
		IL = <cfif len(attributes.il)>'#attributes.il#',<cfelse>null,</cfif>
		ILCE = <cfif len(attributes.ilce)>'#attributes.ilce#',<cfelse>null,</cfif>
		NET_AGIRLIK = <cfif len(attributes.net_agirlik)>#attributes.net_agirlik#<cfelse>null</cfif>
	WHERE
		ASSETP_ID = #attributes.assetp_id#
</cfquery>
<script type="text/javascript">
	 wrk_opener_reload();
	 window.close();
</script>
