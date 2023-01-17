<cf_date tarih='attributes.trafik_cikis_tarih'>
<cf_date tarih='attributes.tescil_tarihi'>
<cf_date tarih='attributes.tarih'>
<cfquery name="ADD_SHIP_INFO" datasource="#DSN#">
	INSERT INTO
	ASSET_P_INFO_PLUS 
		(
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
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			KM_YAKIT_GIDERI,
			TESCIL_PLAKA_NO ,
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
			IL,
			ILCE,
			NET_AGIRLIK
			
		) 
	VALUES 
		(
			#attributes.assetp_id#,
			<cfif len(attributes.property1)>'#attributes.property1#'<cfelse>null</cfif>,
			<cfif len(attributes.property2)>'#attributes.property2#'<cfelse>null</cfif>,
			<cfif len(attributes.property3)>'#attributes.property3#'<cfelse>null</cfif>,
			<cfif len(attributes.property4)>'#attributes.property4#'<cfelse>null</cfif>,
			<cfif len(attributes.property5)>'#attributes.property5#'<cfelse>null</cfif>,
			<cfif len(attributes.transport_capacity)>#attributes.transport_capacity#<cfelse>null</cfif>,
			<cfif len(attributes.en)>#attributes.en#<cfelse>null</cfif>,
			<cfif len(attributes.boy)>#attributes.boy#<cfelse>null</cfif>,
			<cfif len(attributes.yukseklik)>#attributes.yukseklik#<cfelse>null</cfif>,
			<cfif len(attributes.baslangic_km)>#attributes.baslangic_km#<cfelse>null</cfif>,
			<cfif len(attributes.unit_id)>'#attributes.unit_id#'<cfelse>null</cfif>,
			#now()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			<cfif len(attributes.km_yakit_gideri)>#attributes.km_yakit_gideri#<cfelse>null</cfif>,
			<cfif len(attributes.tescil_plaka_no)>'#attributes.tescil_plaka_no#'<cfelse>null</cfif>,
			<cfif len(attributes.trafik_cikis_tarih)>#attributes.trafik_cikis_tarih#<cfelse>null</cfif>,
			<cfif len(attributes.cins)>'#attributes.cins#'<cfelse>null</cfif>,
			<cfif len(attributes.tip)>'#attributes.tip#'<cfelse>null</cfif>,
			<cfif len(attributes.renk)>'#attributes.renk#,<cfelse>null</cfif>,
			<cfif len(attributes.motor)>'#attributes.motor#'<cfelse>null</cfif>,
			<cfif len(attributes.tescil_sira_no)>'#attributes.tescil_sira_no#'<cfelse>null</cfif>,
			<cfif len(attributes.tescil_tarihi)>#attributes.tescil_tarihi#<cfelse>null</cfif>,
			<cfif len(attributes.motor_gucu)>'#attributes.motor_gucu#'<cfelse>nul,</cfif>,
			<cfif len(attributes.arac_sahibi)>'#attributes.arac_sahibi#'<cfelse>null</cfif>,
			<cfif len(attributes.ikametgah_adres)>'#attributes.ikametgah_adres#'<cfelse>null</cfif>,
			<cfif len(attributes.il)>'#attributes.il#'<cfelse>null</cfif>,
			<cfif len(attributes.ilce)>'#attributes.ilce#'<cfelse>null</cfif>,
			<cfif len(attributes.net_agirlik)>#attributes.net_agirlik#<cfelse>null</cfif>
		)
</cfquery>
<script type="text/javascript"> 
	 wrk_opener_reload();
	 window.close();
</script>
