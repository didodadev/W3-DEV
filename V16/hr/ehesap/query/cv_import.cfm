<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='44501.Display Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfquery name="GET_DRIVER_LICENCECAT" datasource="#DSN#">
	SELECT
		 LICENCECAT_ID,
		 LICENCECAT
	FROM 
		SETUP_DRIVERLICENCE 
	ORDER BY 
		LICENCECAT_ID
</cfquery>

<cfset licencecat_list = valuelist(get_driver_licencecat.licencecat)>
<cfset licencecat_id_list = valuelist(get_driver_licencecat.licencecat_id)>

<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("Dosya Okunamadı ! Karakter Seti Yanlış Seçilmiş Olabilir.");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	satir_no =0;
</cfscript>
<cfset error_flag = 0>
<cflock name="#CREATEUUID()#" timeout="500">
	<cftransaction>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset j= 1>
		<script type="text/javascript">
			degisken=0;
		</script>
			<cftry>
				<cfscript>
					//Employees App tablosuna yazılacaklar
					ad = Listgetat(dosya[i],j,";");
					ad = trim(ad);
					j=j+1;
			
					soyad = Listgetat(dosya[i],j,";");
					soyad = trim(soyad);
					j=j+1;
						
					//Employees Identy Ve Employees App Tablosuna yazılacak
					tc_kimlik = Listgetat(dosya[i],j,";");
					tc_kimlik = trim(tc_kimlik);
					j=j+1;
					
					//Employees Identy 
					medeni_durum = Listgetat(dosya[i],j,";");
					medeni_durum = trim(medeni_durum);
					j=j+1;
					
					cinsiyet = Listgetat(dosya[i],j,";");
					cinsiyet = trim(cinsiyet);
					j=j+1;
					
					//Employees Identy 
					dogum_tarihi = Listgetat(dosya[i],j,";");
					j=j+1;
					
					//Employees Identy 
					dogum_yeri = Listgetat(dosya[i],j,";");
					dogum_yeri = trim(dogum_yeri);
					j=j+1;
					
					email = Listgetat(dosya[i],j,";");
					email = trim(email);
					j=j+1;
					
					ev_adresi = Listgetat(dosya[i],j,";");
					ev_adresi = trim(ev_adresi);
					j=j+1;
					
					ilce = Listgetat(dosya[i],j,";");
					ilce = trim(ilce);
					j=j+1;
					
					sehir = Listgetat(dosya[i],j,";");
					sehir = trim(sehir);
					j=j+1;
					
					ev_tel_kod = Listgetat(dosya[i],j,";");
					ev_tel_kod = trim(ev_tel_kod);
					j=j+1;
					
					ev_tel = Listgetat(dosya[i],j,";");
					ev_tel = trim(ev_tel);
					j=j+1;
						
					cep_tel_kod = Listgetat(dosya[i],j,";");
					cep_tel_kod = trim(cep_tel_kod);
					j=j+1;
					
					cep_tel = Listgetat(dosya[i],j,";");
					cep_tel = trim(cep_tel);
					j=j+1;
						
					egitim_seviyesi = Listgetat(dosya[i],j,";");
					egitim_seviyesi = trim(egitim_seviyesi);
					j=j+1;
					
					for (n=1; n lte 7; n=n+1)
					{
						'okul_turu_#n#' = Listgetat(dosya[i],j,";");
						'okul_turu_#n#' = trim(evaluate('okul_turu_#n#'));
						j=j+1;
						'okul_adi_#n#' = Listgetat(dosya[i],j,";");
						'okul_adi_#n#' = trim(evaluate('okul_adi_#n#'));
						j=j+1;
						'giris_#n#' = Listgetat(dosya[i],j,";");
						'giris_#n#' = trim(evaluate('giris_#n#'));
						j=j+1;
						'cikis_#n#' = Listgetat(dosya[i],j,";");
						'cikis_#n#' = trim(evaluate('cikis_#n#'));
						j=j+1;
						'ortalama_#n#' = Listgetat(dosya[i],j,";");
						'ortalama_#n#' = trim(evaluate('ortalama_#n#'));
						j=j+1;
						'bolum_#n#' = Listgetat(dosya[i],j,";");
						'bolum_#n#' = trim(evaluate('bolum_#n#'));
						j=j+1;
					}
					/*ilkokul_adi = Listgetat(dosya[i],j,";");
					ilkokul_adi = trim(ilkokul_adi);
					j=j+1;
					
					ilk_giris_yil = Listgetat(dosya[i],j,";");
					ilk_giris_yil = trim(ilk_giris_yil);
					j=j+1;
					
					ilk_cikis_yil = Listgetat(dosya[i],j,";");
					ilk_cikis_yil = trim(ilk_cikis_yil);
					j=j+1;
			
					ilk_not_ort = Listgetat(dosya[i],j,";");
					ilk_not_ort = trim(ilk_not_ort);
					j=j+1;
					
					ortaokul_adi = Listgetat(dosya[i],j,";");
					ortaokul_adi = trim(ortaokul_adi);
					j=j+1;
					
					orta_giris_yil = Listgetat(dosya[i],j,";");
					orta_giris_yil = trim(orta_giris_yil);
					j=j+1;
					
					orta_cikis_yil = Listgetat(dosya[i],j,";");
					orta_cikis_yil = trim(orta_cikis_yil);
					j=j+1;
			
					orta_not_ort = Listgetat(dosya[i],j,";");
					orta_not_ort = trim(orta_not_ort);
					j=j+1;
					
					lise_adi = Listgetat(dosya[i],j,";");
					lise_adi = trim(lise_adi);
					j=j+1;
					
					lise_giris_yil = Listgetat(dosya[i],j,";");
					lise_giris_yil = trim(lise_giris_yil);
					j=j+1;
					
					lise_cikis_yil = Listgetat(dosya[i],j,";");
					lise_cikis_yil = trim(lise_cikis_yil);
					j=j+1;
			
					lise_not_ort = Listgetat(dosya[i],j,";");
					lise_not_ort = trim(lise_not_ort);
					j=j+1;
					
					lise_bolum = Listgetat(dosya[i],j,";");
					lise_bolum = trim(lise_bolum);
					j=j+1;
					
					univ1_adi = Listgetat(dosya[i],j,";");
					univ1_adi = trim(univ1_adi);
					j=j+1;
					
					univ1_giris_yil = Listgetat(dosya[i],j,";");
					univ1_giris_yil = trim(univ1_giris_yil);
					j=j+1;
					
					univ1_cikis_yil = Listgetat(dosya[i],j,";");
					univ1_cikis_yil = trim(univ1_cikis_yil);
					j=j+1;
			
					univ1_not_ort = Listgetat(dosya[i],j,";");
					univ1_not_ort = trim(univ1_not_ort);
					j=j+1;
					
					univ1_bolum = Listgetat(dosya[i],j,";");
					univ1_bolum = trim(univ1_bolum);
					j=j+1;
					
					//üniv2
					univ2_adi = Listgetat(dosya[i],j,";");
					univ2_adi = trim(univ2_adi);
					j=j+1;
					
					univ2_giris_yil = Listgetat(dosya[i],j,";");
					univ2_giris_yil = trim(univ2_giris_yil);
					j=j+1;
					
					univ2_cikis_yil = Listgetat(dosya[i],j,";");
					univ2_cikis_yil = trim(univ2_cikis_yil);
					j=j+1;
			
					univ2_not_ort = Listgetat(dosya[i],j,";");
					univ2_not_ort = trim(univ2_not_ort);
					j=j+1;
					
					univ2_bolum = Listgetat(dosya[i],j,";");
					univ2_bolum = trim(univ2_bolum);
					j=j+1;
					
					//yüksek linsans
					yksklsns_adi = Listgetat(dosya[i],j,";");
					yksklsns_adi = trim(yksklsns_adi);
					j=j+1;
					
					yksklsns_giris_yil = Listgetat(dosya[i],j,";");
					yksklsns_giris_yil = trim(yksklsns_giris_yil);
					j=j+1;
					
					yksklsns_cikis_yil = Listgetat(dosya[i],j,";");
					yksklsns_cikis_yil = trim(yksklsns_cikis_yil);
					j=j+1;
			
					yksklsns_not_ort = Listgetat(dosya[i],j,";");
					yksklsns_not_ort = trim(yksklsns_not_ort);
					j=j+1;
					
					yksklsns_bolum = Listgetat(dosya[i],j,";");
					yksklsns_bolum = trim(yksklsns_bolum);
					j=j+1;
					
					//doktora
					doktora_adi = Listgetat(dosya[i],j,";");
					doktora_adi = trim(doktora_adi);
					j=j+1;
					
					doktora_giris_yil = Listgetat(dosya[i],j,";");
					doktora_giris_yil = trim(doktora_giris_yil);
					j=j+1;
					
					doktora_cikis_yil = Listgetat(dosya[i],j,";");
					doktora_cikis_yil = trim(doktora_cikis_yil);
					j=j+1;
					
					doktora_bolum = Listgetat(dosya[i],j,";");
					doktora_bolum = trim(doktora_bolum);
					j=j+1;
					*/
					//yabancı dil1
					dil1 = Listgetat(dosya[i],j,";");
					dil1 = trim(dil1);
					j=j+1;
					
					dil1_konusma = Listgetat(dosya[i],j,";");
					dil1_konusma = trim(dil1_konusma);
					j=j+1;
					
					dil1_anlama = Listgetat(dosya[i],j,";");
					dil1_anlama = trim(dil1_anlama);
					j=j+1;
					
					dil1_yazma = Listgetat(dosya[i],j,";");
					dil1_yazma = trim(dil1_yazma);
					j=j+1;
					
					dil1_yer = Listgetat(dosya[i],j,";");
					dil1_yer = trim(dil1_yer);
					j=j+1;
					
					//yabancı dil2
					dil2 = Listgetat(dosya[i],j,";");
					dil2 = trim(dil2);
					j=j+1;
					
					dil2_konusma = Listgetat(dosya[i],j,";");
					dil2_konusma = trim(dil2_konusma);
					j=j+1;
					
					dil2_anlama = Listgetat(dosya[i],j,";");
					dil2_anlama = trim(dil2_anlama);
					j=j+1;
					
					dil2_yazma = Listgetat(dosya[i],j,";");
					dil2_yazma = trim(dil2_yazma);
					j=j+1;
					
					dil2_yer = Listgetat(dosya[i],j,";");
					dil2_yer = trim(dil2_yer);
					j=j+1;
					
					//yabancı dil3
					dil3 = Listgetat(dosya[i],j,";");
					dil3 = trim(dil3);
					j=j+1;
					
					dil3_konusma = Listgetat(dosya[i],j,";");
					dil3_konusma = trim(dil3_konusma);
					j=j+1;
					
					dil3_anlama = Listgetat(dosya[i],j,";");
					dil3_anlama = trim(dil3_anlama);
					j=j+1;
					
					dil3_yazma = Listgetat(dosya[i],j,";");
					dil3_yazma = trim(dil3_yazma);
					j=j+1;
					
					dil3_yer = Listgetat(dosya[i],j,";");
					dil3_yer = trim(dil3_yer);
					j=j+1;
					
					//EMPLOYEES_APP_WORK_INFO
					//iş tecrübesi 1 
					is_tcr1_sirket = Listgetat(dosya[i],j,";");
					is_tcr1_sirket = trim(is_tcr1_sirket);
					j=j+1;
					
					is_tcr1_pozisyon = Listgetat(dosya[i],j,";");
					is_tcr1_pozisyon = trim(is_tcr1_pozisyon);
					j=j+1;
					
					is_tcr1_basl_trh = Listgetat(dosya[i],j,";");
					j=j+1;
					
					is_tcr1_bitis_trh = Listgetat(dosya[i],j,";");
					j=j+1;
					
					is_tcr1_gorev = Listgetat(dosya[i],j,";");
					is_tcr1_gorev = trim(is_tcr1_gorev);
					j=j+1;
					
					is_tcr1_ayrlma_nedeni = Listgetat(dosya[i],j,";");
					is_tcr1_ayrlma_nedeni = trim(is_tcr1_ayrlma_nedeni);
					j=j+1;
					
					// iş tecrübesi 2
					is_tcr2_sirket = Listgetat(dosya[i],j,";");
					is_tcr2_sirket = trim(is_tcr2_sirket);
					j=j+1;
					
					is_tcr2_pozisyon = Listgetat(dosya[i],j,";");
					is_tcr2_pozisyon = trim(is_tcr2_pozisyon);
					j=j+1;
					
					is_tcr2_basl_trh = Listgetat(dosya[i],j,";");
					j=j+1;
					
					is_tcr2_bitis_trh = Listgetat(dosya[i],j,";");
					j=j+1;
					
					is_tcr2_gorev = Listgetat(dosya[i],j,";");
					is_tcr2_gorev = trim(is_tcr2_gorev);
					j=j+1;
					
					is_tcr2_ayrlma_nedeni = Listgetat(dosya[i],j,";");
					is_tcr2_ayrlma_nedeni = trim(is_tcr2_ayrlma_nedeni);
					j=j+1;
					
					// iş tecrübesi 3
					is_tcr3_sirket = Listgetat(dosya[i],j,";");
					is_tcr3_sirket = trim(is_tcr3_sirket);
					j=j+1;
					
					is_tcr3_pozisyon = Listgetat(dosya[i],j,";");
					is_tcr3_pozisyon = trim(is_tcr3_pozisyon);
					j=j+1;
					
					is_tcr3_basl_trh = Listgetat(dosya[i],j,";");
					j=j+1;
					
					is_tcr3_bitis_trh = Listgetat(dosya[i],j,";");
					j=j+1;
					
					is_tcr3_gorev = Listgetat(dosya[i],j,";");
					is_tcr3_gorev = trim(is_tcr3_gorev);
					j=j+1;
					
					is_tcr3_ayrlma_nedeni = Listgetat(dosya[i],j,";");
					is_tcr3_ayrlma_nedeni = trim(is_tcr3_ayrlma_nedeni);
					j=j+1;
					
					// iş tecrübesi 4
					is_tcr4_sirket = Listgetat(dosya[i],j,";");
					is_tcr4_sirket = trim(is_tcr4_sirket);
					j=j+1;
					
					is_tcr4_pozisyon = Listgetat(dosya[i],j,";");
					is_tcr4_pozisyon = trim(is_tcr4_pozisyon);
					j=j+1;
					
					is_tcr4_basl_trh = Listgetat(dosya[i],j,";");
					j=j+1;
					
					is_tcr4_bitis_trh = Listgetat(dosya[i],j,";");
					j=j+1;
					
					is_tcr4_gorev = Listgetat(dosya[i],j,";");
					is_tcr4_gorev = trim(is_tcr4_gorev);
					j=j+1;
					
					is_tcr4_ayrlma_nedeni = Listgetat(dosya[i],j,";");
					is_tcr4_ayrlma_nedeni = trim(is_tcr4_ayrlma_nedeni);
					j=j+1;
			
					//kurs1
					kurs1 = Listgetat(dosya[i],j,";");
					kurs1 = trim(kurs1);
					j=j+1;
			
					kurs1_yil = Listgetat(dosya[i],j,";");
					kurs1_yil = trim(kurs1_yil);
					j=j+1;
			
					kurs1_yer = Listgetat(dosya[i],j,";");
					kurs1_yer = trim(kurs1_yer);
					j=j+1;
			
					kurs1_gun = Listgetat(dosya[i],j,";");
					kurs1_gun = trim(kurs1_gun);
					j=j+1;
					
					//kurs2
					kurs2 = Listgetat(dosya[i],j,";");
					kurs2 = trim(kurs2);
					j=j+1;
			
					kurs2_yil = Listgetat(dosya[i],j,";");
					kurs2_yil = trim(kurs2_yil);
					j=j+1;
			
					kurs2_yer = Listgetat(dosya[i],j,";");
					kurs2_yer = trim(kurs2_yer);
					j=j+1;
			
					kurs2_gun = Listgetat(dosya[i],j,";");
					kurs2_gun = trim(kurs2_gun);
					j=j+1;
					
					//kurs3
					kurs3 = Listgetat(dosya[i],j,";");
					kurs3 = trim(kurs3);
					j=j+1;
			
					kurs3_yil = Listgetat(dosya[i],j,";");
					kurs3_yil = trim(kurs3_yil);
					j=j+1;
			
					kurs3_yer = Listgetat(dosya[i],j,";");
					kurs3_yer = trim(kurs3_yer);
					j=j+1;
			
					kurs3_gun = Listgetat(dosya[i],j,";");
					kurs3_gun = trim(kurs3_gun);
					j=j+1;
			
					askerlik = Listgetat(dosya[i],j,";");
					askerlik = trim(askerlik);
					j=j+1;
					
					terhis_tarihi = Listgetat(dosya[i],j,";");
					j=j+1;
			
					hastalik = Listgetat(dosya[i],j,";");
					hastalik = trim(hastalik);
					j=j+1;
					
					sigara = Listgetat(dosya[i],j,";");
					sigara = trim(sigara);
					j=j+1;
			
					ozur_durumu = Listgetat(dosya[i],j,";");
					ozur_durumu = trim(ozur_durumu);
					j=j+1;
					
					mahkumiyet = Listgetat(dosya[i],j,";");
					mahkumiyet = trim(mahkumiyet);
					j=j+1;
					
					kovusturma = Listgetat(dosya[i],j,";");
					kovusturma = trim(kovusturma);
					j=j+1;

					ehliyet_yil = Listgetat(dosya[i],j,";");
					ehliyet_yil = trim(ehliyet_yil);
					j=j+1;
					
					ehliyet_tip = Listgetat(dosya[i],j,";");
					ehliyet_tip = trim(ehliyet_tip);
					j=j+1;

					seyahat_engeli = Listgetat(dosya[i],j,";");
					seyahat_engeli = trim(seyahat_engeli);
					j=j+1;
					
					//Referans Bilgileri 1
					ref1_ad_soyad = Listgetat(dosya[i],j,";");
					ref1_ad_soyad = trim(ref1_ad_soyad);
					j=j+1;
					
					ref1_sirket = Listgetat(dosya[i],j,";");
					ref1_sirket = trim(ref1_sirket);
					j=j+1;
					
					ref1_pozisyon = Listgetat(dosya[i],j,";");
					ref1_pozisyon = trim(ref1_pozisyon);
					j=j+1;
					
					ref1_tel_kod = Listgetat(dosya[i],j,";");
					ref1_tel_kod = trim(ref1_tel_kod);
					j=j+1;
					
					ref1_tel = Listgetat(dosya[i],j,";");
					ref1_tel = trim(ref1_tel);
					j=j+1;
					
					ref1_email = Listgetat(dosya[i],j,";");
					ref1_email = trim(ref1_email);
					j=j+1;
					
					//Referans Bilgileri 2
					ref2_ad_soyad = Listgetat(dosya[i],j,";");
					ref2_ad_soyad = trim(ref2_ad_soyad);
					j=j+1;
					
					ref2_sirket = Listgetat(dosya[i],j,";");
					ref2_sirket = trim(ref2_sirket);
					j=j+1;
					
					ref2_pozisyon = Listgetat(dosya[i],j,";");
					ref2_pozisyon = trim(ref2_pozisyon);
					j=j+1;
					
					ref2_tel_kod = Listgetat(dosya[i],j,";");
					ref2_tel_kod = trim(ref2_tel_kod);
					j=j+1;
						
					ref2_tel = Listgetat(dosya[i],j,";");
					ref2_tel = trim(ref2_tel);
					j=j+1;
					
					ref2_email = Listgetat(dosya[i],j,";");
					ref2_email = trim(ref2_email);
					j=j+1;
					
					istenen_ucret = Listgetat(dosya[i],j,";");
					istenen_ucret = trim(istenen_ucret);
					j=j+1;
					
					if(listlen(dosya[i],';') gte j)
					{
						ek_bilgi = Listgetat(dosya[i],j,";");
					}else
						ek_bilgi ='';
					j=j+1;
					//alanlar bitti
					//Ad soyad büyük harf yapılıyor
					list="',""";
					list2=" , ";
					e_name=replacelist(trim(ad),list,list2);
					e_surname=replacelist(trim(soyad),list,list2);
					a = "";
					b = e_name;
					a = '#a# #b#';	
					e_name = trim(a);
					a = "";
					b = e_surname;
					a = '#a# #b#';
					e_surname = trim(a);
				</cfscript>
			<cfcatch type="Any"> 
					<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
					<cfset error_flag = 1>
					<script>window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.cv_import"</script>
			</cfcatch>
			</cftry>

			<cfif error_flag neq 1>
				<cftry>
					<cfif not len(email) or not len(e_name) or not len(e_surname)>
						<cfoutput>
							<script type="text/javascript">
								alert("#i#. <cf_get_lang dictionary_id='44510.satırdaki Cv nin Zorunlu Alanlarından Biri boş Bırakılmış'>!");
								history.back();
							</script>
						</cfoutput>
						<cfabort>
					</cfif>
					<cfquery name="get_select_cv" datasource="#dsn#">
						SELECT 
							* 
						FROM 
							EMPLOYEES_APP
						WHERE
							NAME = '#e_name#' AND
							SURNAME = '#e_surname#' AND
							EMAIL = '#email#'
					</cfquery>
					<cfif get_select_cv.recordcount>
						<cfoutput>
							<script type="text/javascript">
								alert<cf_get_lang dictionary_id='44542.Bu kişinin Cv Kaydı bulunuyor tekrar Kayıt Edemezsiniz'>.<cf_get_lang dictionary_id='44543.Kayıtlı kişi'> : #e_name# #e_surname#!");
								history.back();
							</script>
						</cfoutput>
						<cfabort>
					</cfif>
					<cfquery name="get_select_cv_2" datasource="#dsn#">
						SELECT 
							* 
						FROM 
							EMPLOYEES_APP
						WHERE
							EMAIL = '#email#'
					</cfquery>
					<cfif get_select_cv_2.recordcount>
						<cfoutput>
							<script type="text/javascript">
								alert("<cf_get_lang dictionary_id='44544.Bu e-mail adresine ait Cv Kaydı bulunuyor tekrar Kayıt Edemezsiniz'>.E-mail #email#  !");
								history.back();
							</script>
						</cfoutput>
						<cfabort>
					</cfif>

					<cfif len(ehliyet_tip) and listfindnocase(licencecat_list,ehliyet_tip) gt 0 > 
						<cfset ehliyet_tip_ = listgetat(licencecat_id_list,listfindnocase(licencecat_list,ehliyet_tip))>
					<cfelse>
						<cfset ehliyet_tip_ = ''>
					</cfif>
					<cfset county_id = "">
					<cfif len(ilce)>
						<cfquery name="get_county" datasource="#dsn#">
							SELECT COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_NAME = '#ilce#'
						</cfquery>
						<cfif get_county.recordcount>
							<cfset county_id = get_county.county_id>
						</cfif>
					</cfif>
					<cfquery name="add_1" datasource="#dsn#" result="MAX_ID">
						INSERT INTO 
							EMPLOYEES_APP
						(
							STEP_NO,
							APP_STATUS,
							NAME,
							SURNAME,
							TC_IDENTY_NO,
							SEX,
							EMAIL,
							HOMEADDRESS,
							HOMECOUNTY,
							HOMECITY,
							HOMETELCODE,
							HOMETEL,
							MOBILCODE,
							MOBIL,
							TRAINING_LEVEL,
							KURS1,
							KURS1_YIL,
							KURS1_YER,
							KURS1_GUN,
							KURS2,
							KURS2_YIL,
							KURS2_YER,
							KURS2_GUN,
							KURS3,
							KURS3_YIL,
							KURS3_YER,
							KURS3_GUN,
							MILITARY_STATUS,
							MILITARY_FINISHDATE,
							ILLNESS_PROBABILITY,
							USE_CIGARETTE,
							DEFECTED,
							SENTENCED,
							INVESTIGATION,
							IS_TRIP,
							EXPECTED_PRICE,
							APPLICANT_NOTES,
							LICENCE_START_DATE,
							LICENCECAT_ID,
							WORK_STARTED,
							WORK_FINISHED,
							CV_STAGE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							-1,
							1,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#e_name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#e_surname#">,
							<cfif len(tc_kimlik)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tc_kimlik#"><cfelse>NULL</cfif>,
							<cfif len(cinsiyet)>#cinsiyet#<cfelse>NULL</cfif>,
							<cfif len(email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#email#"><cfelse>NULL</cfif>,
							<cfif len(ev_adresi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ev_adresi#"><cfelse>NULL</cfif>,
							<cfif len(county_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#county_id#"><cfelse>NULL</cfif>,
							<cfif len(sehir)>#sehir#<cfelse>NULL</cfif>,
							<cfif len(ev_tel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ev_tel_kod#"><cfelse>NULL</cfif>,
							<cfif len(ev_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ev_tel#"><cfelse>NULL</cfif>,
							<cfif len(cep_tel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#cep_tel_kod#"><cfelse>NULL</cfif>,
							<cfif len(cep_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#cep_tel#"><cfelse>NULL</cfif>,
							<cfif len(egitim_seviyesi)>#egitim_seviyesi#<cfelse>NULL</cfif>,
							<cfif len(kurs1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs1#"><cfelse>NULL</cfif>,
							<cfif len(kurs1_yil)>{TS '#kurs1_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
							<cfif len(kurs1_yer)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs1_yer#"><cfelse>NULL</cfif>,
							<cfif len(kurs1_gun)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs1_gun#"><cfelse>NULL</cfif>,
							<cfif len(kurs2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs2#"><cfelse>NULL</cfif>,
							<cfif len(kurs2_yil)>{TS '#kurs2_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
							<cfif len(kurs2_yer)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs2_yer#"><cfelse>NULL</cfif>,
							<cfif len(kurs2_gun)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs2_gun#"><cfelse>NULL</cfif>,
							<cfif len(kurs3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs3#"><cfelse>NULL</cfif>,
							<cfif len(kurs3_yil)>{TS '#kurs3_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
							<cfif len(kurs3_yer)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs3_yer#"><cfelse>NULL</cfif>,
							<cfif len(kurs3_gun)><cfqueryparam cfsqltype="cf_sql_varchar" value="#kurs3_gun#"><cfelse>NULL</cfif>,
							<cfif len(askerlik)>#askerlik#<cfelse>NULL</cfif>,
							<cfif len(terhis_tarihi) and (terhis_tarihi neq 0) and isdate(terhis_tarihi)>#CreateDate(listgetat(terhis_tarihi,3,'.'),listgetat(terhis_tarihi,2,'.'),listgetat(terhis_tarihi,1,'.'))#<cfelse>NULL</cfif>,
							<cfif len(hastalik)>#hastalik#<cfelse>NULL</cfif>,
							<cfif len(sigara)>#sigara#<cfelse>NULL</cfif>,
							<cfif len(ozur_durumu)>#ozur_durumu#<cfelse>NULL</cfif>,
							<cfif len(mahkumiyet)>#mahkumiyet#<cfelse>NULL</cfif>,
							<cfif len(kovusturma)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(kovusturma,50)#"><cfelse>NULL</cfif>,
							<cfif len(seyahat_engeli)>#seyahat_engeli#<cfelse>NULL</cfif>,
							<cfif len(istenen_ucret)>#istenen_ucret#<cfelse>NULL</cfif>,
							<cfif len(ek_bilgi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ek_bilgi#"><cfelse>NULL</cfif>,
							<cfif len(ehliyet_yil)and isdate(ehliyet_yil)>#CreateDate(listgetat(ehliyet_yil,3,'.'),listgetat(ehliyet_yil,2,'.'),listgetat(ehliyet_yil,1,'.'))#<cfelse>NULL</cfif>,
							<cfif len(ehliyet_tip_)>#ehliyet_tip_#<cfelse>NULL</cfif>,
							0,
							0,
							<cfif isdefined('attributes.process_stage')>#attributes.process_stage#<cfelse>NULL</cfif>,
							#now()#,
							#SESSION.EP.USERID#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
						)		
					</cfquery>
					<!---dil bilgileri --->
					<cfloop from="1" to="3" index="x">
						<cfif len(evaluate('dil#x#'))>
							<cfquery name="add_lang" datasource="#dsn#">
								INSERT INTO
									EMPLOYEES_APP_LANGUAGE
									(
										EMPAPP_ID,
										LANG_ID,
										LANG_SPEAK,
										LANG_MEAN,
										LANG_WRITE,
										LANG_WHERE,
										RECORD_EMP,
										RECORD_DATE,
										RECORD_IP	
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										#evaluate('dil#x#')#,
										<cfif len(evaluate('dil#x#_konusma'))>#evaluate('dil#x#_konusma')#<cfelse>NULL</cfif>,
										<cfif len(evaluate('dil#x#_anlama'))>#evaluate('dil#x#_anlama')#<cfelse>NULL</cfif>,
										<cfif len(evaluate('dil#x#_yazma'))>#evaluate('dil#x#_yazma')#<cfelse>NULL</cfif>,
										<cfif len(evaluate('dil#x#_yer'))>'#evaluate('dil#x#_yer')#'<cfelse>NULL</cfif>,		
										#session.ep.userid#,
										#now()#,
										'#cgi.REMOTE_ADDR#'					
									)
							</cfquery>
						</cfif>
					</cfloop>
					<!--- //dil bilgileri---->
					<!--- referans bilgileri--->
					<cfloop from="1" to="2" index="y">
						<cfif len(evaluate('ref#y#_ad_soyad'))>
							<cfquery name="add_ref" datasource="#dsn#">
								INSERT INTO
									EMPLOYEES_REFERENCE
									(
										EMPAPP_ID,
										REFERENCE_NAME,
										REFERENCE_COMPANY,
										REFERENCE_POSITION,
										REFERENCE_TELCODE,
										REFERENCE_TEL,
										REFERENCE_EMAIL,
										RECORD_EMP,
										RECORD_DATE,
										RECORD_IP									
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										'#evaluate('ref#y#_ad_soyad')#',
										<cfif len(evaluate('ref#y#_sirket'))>'#evaluate('ref#y#_sirket')#'<cfelse>NULL</cfif>,
										<cfif len(evaluate('ref#y#_pozisyon'))>'#evaluate('ref#y#_pozisyon')#'<cfelse>NULL</cfif>,
										<cfif len(evaluate('ref#y#_tel_kod'))>'#evaluate('ref#y#_tel_kod')#'<cfelse>NULL</cfif>,
										<cfif len(evaluate('ref#y#_tel'))>'#evaluate('ref#y#_tel')#'<cfelse>NULL</cfif>,
										<cfif len(evaluate('ref#y#_email'))>'#evaluate('ref#y#_email')#'<cfelse>NULL</cfif>,
										#session.ep.userid#,
										#now()#,
										'#cgi.REMOTE_ADDR#'
									)
							</cfquery>
						</cfif>
					</cfloop>
					<!--- //referans bilgileri--->
					<cfquery name="add_2" datasource="#dsn#">
						INSERT INTO 
							EMPLOYEES_IDENTY
						(
								EMPAPP_ID,
								TC_IDENTY_NO,
								<cfif len(medeni_durum)>MARRIED,</cfif>
								BIRTH_DATE,
								BIRTH_PLACE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
						)
						VALUES
						(
								#MAX_ID.IDENTITYCOL#,
								<cfif len(tc_kimlik)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tc_kimlik#"><cfelse>NULL</cfif>,
								<cfif len(medeni_durum)>#medeni_durum#,</cfif>
								<cfif len(dogum_tarihi) and (dogum_tarihi neq 0) and isdate(dogum_tarihi)>#CreateDate(listgetat(dogum_tarihi,3,'.'),listgetat(dogum_tarihi,2,'.'),listgetat(dogum_tarihi,1,'.'))#<cfelse>NULL</cfif>,
								<cfif len(dogum_yeri)><cfqueryparam cfsqltype="cf_sql_varchar" value="#dogum_yeri#"><cfelse>NULL</cfif>,
								#now()#,
								#SESSION.EP.USERID#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
						)		
					</cfquery>
					<cfloop from="1" to="4" index="k">
						<cfif len(evaluate('is_tcr#k#_sirket'))>
							<cfquery name="add_3" datasource="#dsn#">
								INSERT INTO 
								EMPLOYEES_APP_WORK_INFO
									(
										EMPAPP_ID,
										EXP,
										EXP_POSITION,
										EXP_START,
										EXP_FINISH,
										EXP_EXTRA,
										EXP_REASON
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										<cfif len(evaluate('is_tcr#k#_sirket'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('is_tcr#k#_sirket')#"><cfelse>NULL</cfif>,
										<cfif len(evaluate('is_tcr#k#_pozisyon'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('is_tcr#k#_pozisyon')#"><cfelse>NULL</cfif>,
										<cfif len(evaluate('is_tcr#k#_basl_trh')) and (evaluate('is_tcr#k#_basl_trh') neq 0) and isdate(evaluate('is_tcr#k#_basl_trh'))>#CreateDate(listgetat(evaluate('is_tcr#k#_basl_trh'),3,'.'),listgetat(evaluate('is_tcr#k#_basl_trh'),2,'.'),listgetat(evaluate('is_tcr#k#_basl_trh'),1,'.'))#<cfelse>NULL</cfif>,
										<cfif len(evaluate('is_tcr#k#_bitis_trh')) and (evaluate('is_tcr#k#_bitis_trh') neq 0) and isdate(evaluate('is_tcr#k#_bitis_trh'))>#CreateDate(listgetat(evaluate('is_tcr#k#_bitis_trh'),3,'.'),listgetat(evaluate('is_tcr#k#_bitis_trh'),2,'.'),listgetat(evaluate('is_tcr#k#_bitis_trh'),1,'.'))#<cfelse>NULL</cfif>,
										<cfif len(evaluate('is_tcr#k#_gorev'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('is_tcr#k#_gorev')#"><cfelse>NULL</cfif>,
										<cfif len(evaluate('is_tcr#k#_ayrlma_nedeni'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('is_tcr#k#_ayrlma_nedeni')#"><cfelse>NULL</cfif>
									)		
							</cfquery>
						</cfif>
					</cfloop>
					<!---egitim bilgileri --->
					<cfloop from="1" to="7" index="n">
						<cfif len(evaluate('okul_turu_#n#')) and len(evaluate('okul_adi_#n#'))>
							<cfquery name="get_type" datasource="#dsn#">
								SELECT EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = #evaluate('okul_turu_#n#')#
							</cfquery>
							<cfset bolum_adi = "">
							<cfif get_type.edu_type eq 1>
								<cfif len(evaluate('bolum_#n#'))>
									<cfquery name="get_high_part_name" datasource="#dsn#">
										SELECT HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID=#evaluate('bolum_#n#')#
									</cfquery>
									<cfif get_high_part_name.recordcount>
										<cfset bolum_adi = get_high_part_name.HIGH_PART_NAME>
									</cfif>
								</cfif>
							</cfif>
							<cfset univ_adi = "">
							<cfif get_type.edu_type eq 2>
								<cfquery name="get_univ1_adi" datasource="#dsn#">
									SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #evaluate('okul_adi_#n#')#
								</cfquery>
								<cfif get_univ1_adi.recordcount>
									<cfset univ_adi = get_univ1_adi.school_name>
								</cfif>
								<cfif len(evaluate('bolum_#n#'))>
									<cfquery name="get_univ1_bolum_adi" datasource="#dsn#">
										SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #evaluate('bolum_#n#')#
									</cfquery>
									<cfif get_univ1_bolum_adi.recordcount>
										<cfset bolum_adi = get_univ1_bolum_adi.part_name>
									</cfif>
								</cfif>
							</cfif>
							<cfquery name="add_edu_info" datasource="#dsn#">
								INSERT INTO
									EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EDU_TYPE,
										EDU_START,
										EDU_FINISH,
										<cfif get_type.edu_type eq 2><!--- üniversite--->
										EDU_ID,
										</cfif>
										EDU_NAME,
										<cfif get_type.edu_type eq 1 or get_type.edu_type eq 2>
										EDU_PART_ID,
										EDU_PART_NAME,
										</cfif>
										EDU_RANK
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										#evaluate('okul_turu_#n#')#,
										<cfif len(evaluate('giris_#n#'))>#evaluate('giris_#n#')#<cfelse>NULL</cfif>,
										<cfif len(evaluate('cikis_#n#'))>#evaluate('cikis_#n#')#<cfelse>NULL</cfif>,
										<cfif get_type.edu_type eq 2><!--- üniversite--->
											#evaluate('okul_adi_#n#')#,
										</cfif>
										<cfif get_type.edu_type eq 2>
											<cfif len(univ_adi)>'#univ_adi#'<cfelse>NUL</cfif>,
										<cfelse>
											'#evaluate('okul_adi_#n#')#',
										</cfif>
										<cfif get_type.edu_type eq 1 or get_type.edu_type eq 2>
											#evaluate('bolum_#n#')#,
											<cfif len(bolum_adi)>'#bolum_adi#'<cfelse>NULL</cfif>,
										</cfif>
										<cfif len(evaluate('ortalama_#n#'))>#evaluate('ortalama_#n#')#<cfelse>NULL</cfif>
									)
								
							</cfquery>
						</cfif>
					</cfloop>

					<!---<cfif len(ilkokul_adi)>
						<cfquery name="add_edu_ilk" datasource="#dsn#">
							INSERT INTO 
							EMPLOYEES_APP_EDU_INFO
								(
									EMPAPP_ID,
									EDU_TYPE,
									EDU_NAME,
									EDU_START,
									EDU_FINISH,
									EDU_RANK
								)
							VALUES
								(
									#MAX_ID.IDENTITYCOL#,
									1,
									<cfif len(ilkokul_adi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ilkokul_adi#"><cfelse>NULL</cfif>,
									<cfif len(ilk_giris_yil)>#ilk_giris_yil#<cfelse>NULL</cfif>,
									<cfif len(ilk_cikis_yil)>#ilk_cikis_yil#<cfelse>NULL</cfif>,
									<cfif len(ilk_not_ort)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ilk_not_ort#"><cfelse>NULL</cfif>
								)		
						</cfquery>
					</cfif>
					<cfif len(ortaokul_adi)>
						<cfquery name="add_edu_orta" datasource="#dsn#">
							INSERT INTO 
								EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EDU_TYPE,
										EDU_NAME,
										EDU_START,
										EDU_FINISH,
										EDU_RANK
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										2,
										<cfif len(ortaokul_adi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ortaokul_adi#"><cfelse>NULL</cfif>,
										<cfif len(orta_giris_yil)>#orta_giris_yil#<cfelse>NULL</cfif>,
										<cfif len(orta_cikis_yil)>#orta_cikis_yil#<cfelse>NULL</cfif>,
										<cfif len(orta_not_ort)><cfqueryparam cfsqltype="cf_sql_varchar" value="#orta_not_ort#"><cfelse>NULL</cfif>
									)		
							</cfquery>
					</cfif>
					<cfif len(lise_adi)>
						<cfset lise_bolum_adi = "">
						<cfif len(lise_bolum)>
							<cfquery name="get_high_part_name" datasource="#dsn#">
								SELECT HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID=#lise_bolum#
							</cfquery>
							<cfif get_high_part_name.recordcount>
								<cfset lise_bolum_adi = get_high_part_name.HIGH_PART_NAME>
							</cfif>
						</cfif>
						<cfquery name="add_edu_lise" datasource="#dsn#">
							INSERT INTO 
								EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EDU_TYPE,
										EDU_NAME,
										EDU_START,
										EDU_FINISH,
										EDU_RANK,
										EDU_PART_ID,
										EDU_PART_NAME
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										3,
										<cfif len(lise_adi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#lise_adi#"><cfelse>NULL</cfif>,
										<cfif len(lise_giris_yil)>#lise_giris_yil#<cfelse>NULL</cfif>,
										<cfif len(lise_cikis_yil)>#lise_cikis_yil#<cfelse>NULL</cfif>,
										<cfif len(lise_not_ort)><cfqueryparam cfsqltype="cf_sql_varchar" value="#lise_not_ort#"><cfelse>NULL</cfif>,
										<cfif len(lise_bolum)>#lise_bolum#<cfelse>NULL</cfif>,
										<cfif len(lise_bolum_adi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#lise_bolum_adi#"><cfelse>NULL</cfif>
									)		
						</cfquery>
					</cfif>
					<cfif len(univ1_adi)>
						<cfset univ1_adi_ = "">
						<cfset univ1_bolum_adi_ = "">
						<cfquery name="get_univ1_adi" datasource="#dsn#">
							SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #univ1_adi#
						</cfquery>
						<cfif get_univ1_adi.recordcount>
							<cfset univ1_adi_ = get_univ1_adi.school_name>
						</cfif>
						<cfif len(univ1_bolum)>
							<cfquery name="get_univ1_bolum_adi" datasource="#dsn#">
								SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #univ1_bolum#
							</cfquery>
							<cfif get_univ1_bolum_adi.recordcount>
								<cfset univ1_bolum_adi_ = get_univ1_bolum_adi.part_name>
							</cfif>
						</cfif>
						<cfquery name="add_edu_univ1" datasource="#dsn#">
							INSERT INTO 
								EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EDU_TYPE,
										EDU_ID,
										EDU_NAME,
										EDU_START,
										EDU_FINISH,
										EDU_RANK,
										EDU_PART_ID,
										EDU_PART_NAME
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										4,
										<cfif len(univ1_adi)>#univ1_adi#<cfelse>NULL</cfif>,
										<cfif len(univ1_adi_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#univ1_adi_#"><cfelse>NULL</cfif>,
										<cfif len(univ1_giris_yil)>#univ1_giris_yil#<cfelse>NULL</cfif>,
										<cfif len(univ1_cikis_yil)>#univ1_cikis_yil#<cfelse>NULL</cfif>,
										<cfif len(univ1_not_ort)><cfqueryparam cfsqltype="cf_sql_varchar" value="#univ1_not_ort#"><cfelse>NULL</cfif>,
										<cfif len(univ1_bolum)>#univ1_bolum#<cfelse>NULL</cfif>,
										<cfif len(univ1_bolum_adi_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#univ1_bolum_adi_#"><cfelse>NULL,</cfif>
									)		
							</cfquery>
					</cfif>
					<cfif len(univ2_adi)>
						<cfset univ2_adi_ = "">
						<cfset univ2_bolum_adi_ = "">
						<cfquery name="get_univ2_adi" datasource="#dsn#">
							SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #univ2_adi#
						</cfquery>
						<cfif get_univ2_adi.recordcount>
							<cfset univ2_adi_ = get_univ2_adi.school_name>
						</cfif>
						<cfif len(univ2_bolum)>
							<cfquery name="get_univ2_bolum_adi" datasource="#dsn#">
								SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #univ2_bolum#
							</cfquery>
							<cfif get_univ2_bolum_adi.recordcount>
								<cfset univ2_bolum_adi_ = get_univ2_bolum_adi.part_name>
							</cfif>
						</cfif>
						<cfquery name="add_edu_univ2" datasource="#dsn#">
							INSERT INTO 
								EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EDU_TYPE,
										EDU_ID,
										EDU_NAME,
										EDU_START,
										EDU_FINISH,
										EDU_RANK,
										EDU_PART_ID,
										EDU_PART_NAME
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										4,
										<cfif len(univ2_adi)>#univ2_adi#<cfelse>NULL</cfif>,
										<cfif len(univ2_adi_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#univ2_adi_#"><cfelse>NULL</cfif>,
										<cfif len(univ2_giris_yil)>#univ2_giris_yil#<cfelse>NULL</cfif>,
										<cfif len(univ2_cikis_yil)>#univ2_cikis_yil#<cfelse>NULL</cfif>,
										<cfif len(univ2_not_ort)><cfqueryparam cfsqltype="cf_sql_varchar" value="#univ2_not_ort#"><cfelse>NULL</cfif>,
										<cfif len(univ2_bolum)>#univ2_bolum#<cfelse>NULL</cfif>,
										<cfif len(univ2_bolum_adi_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#univ2_bolum_adi_#"><cfelse>NULL</cfif>
									)		
							</cfquery>
					</cfif>
					<cfif len(yksklsns_adi)>
						<cfquery name="add_edu_yksklsns" datasource="#dsn#">
							INSERT INTO 
								EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EDU_TYPE,
										EDU_NAME,
										EDU_START,
										EDU_FINISH,
										EDU_RANK,
										EDU_PART_NAME
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										5,
										<cfif len(yksklsns_adi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#yksklsns_adi#"><cfelse>NULL</cfif>,
										<cfif len(yksklsns_giris_yil)>#yksklsns_giris_yil#<cfelse>NULL</cfif>,
										<cfif len(yksklsns_cikis_yil)>#yksklsns_cikis_yil#<cfelse>NULL</cfif>,
										<cfif len(yksklsns_not_ort)><cfqueryparam cfsqltype="cf_sql_varchar" value="#yksklsns_not_ort#"><cfelse>NULL</cfif>,
										<cfif len(yksklsns_bolum)><cfqueryparam cfsqltype="cf_sql_varchar" value="#yksklsns_bolum#"><cfelse>NULL</cfif>
									)		
						</cfquery>
					</cfif>
					<cfif len(doktora_adi)>
						<cfquery name="add_edu_doktora" datasource="#dsn#">
							INSERT INTO 
								EMPLOYEES_APP_EDU_INFO
									(
										EMPAPP_ID,
										EDU_TYPE,
										EDU_NAME,
										EDU_START,
										EDU_FINISH,
										EDU_PART_NAME
									)
								VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										6,
										<cfif len(doktora_adi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#doktora_adi#"><cfelse>NULL</cfif>,
										<cfif len(doktora_giris_yil)>#doktora_giris_yil#<cfelse>NULL</cfif>,
										<cfif len(doktora_cikis_yil)>#doktora_cikis_yil#<cfelse>NULL</cfif>,
										<cfif len(doktora_bolum)><cfqueryparam cfsqltype="cf_sql_varchar" value="#doktora_bolum#"><cfelse>NULL</cfif>
									)		
						</cfquery>
					</cfif>--->
					<cfset satir_no = satir_no + 1>
					<cfcatch type="Any"> 
						<cfoutput>
							<script type="text/javascript">
								degisken=1;
								if(degisken==1)
								{
									alert("#i#. <cf_get_lang dictionary_id='44511.satırda hata oluştu dosyanızı kontrol ediniz'>");
									history.back();
								}
							</script>
							<cfabort>
						</cfoutput>
					</cfcatch> 
				</cftry>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.cv_import</cfoutput>";
</script>

