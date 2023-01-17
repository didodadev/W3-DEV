<cfcomponent>
	<cffunction name="puantaj_account_name_list" returntype="String">
		<cfset puantaj_account_name_list_="
			TOTAL_SALARY;#getLang('','Toplam Kazanç','53244')#,
			NORMAL_KAZANC_;#getLang('','Ücret','55123')#,
			NORMAL_KAZANC_BRUT_KESINTI_DAHIL;#getLang('','Ücret-Brüt Kesinti Dahil','64777')#,
			NET_UCRET_;#getLang('','Net Ücret','53255')#,
			ICMAL_KESINTI_VE_AGI_ONCESI_NET;#getLang('','İcmal Kesinti ve AGİ Öncesi Net','64778')#,
			KESINTI_VE_AGI_ONCESI_NET;#getLang('','Kesinti ve AGİ Öncesi Net','54310')#,
			TOTAL_PAY_;#getLang('','Ek Ödenekler','53399')#,
			EXT_SALARY;#getLang('','Fazla Mesai Tutarı','53718')#,
			KIDEM_AMOUNT;#getLang('','Kıdem Tazminatı Tutarı','64779')#,
			IHBAR_AMOUNT;#getLang('','İhbar Tazmimatı Tutarı','64780')#,
			YILLIK_IZIN_AMOUNT;#getLang('','Yıllık İzin Ücreti','64781')#,
			VERGI_IADESI;#getLang('','Asgari Geçim İndirimi','53659')#,
			DAMGA_VERGISI;#getLang('','Damga Vergisi','53252')#,
			GELIR_VERGISI;#getLang('','Gelir Vergisi','53250')#,
			GELIR_VERGISI_HESAPLANAN;#getLang('','Gelir Vergisi Hesaplanan','53689')#,
			VERGI_INDIRIMI;#getLang('','Vergi İndirimleri','64782')#,
			VERGI_INDIRIMI_5084;#getLang('','Vergi İndirimi ','56368')# 5084,
			GELIR_VERGISI_INDIRIMI_5746;#getLang('','Vergi İndirimi ','56368')# 5746,
			SAKATLIK_INDIRIMI;#getLang('','Sakatlık İndirimi','54168')#,
			VERGI_ISTISNA_TUTAR_FARKLARI;#getLang('','Vergi İstisnası Tutar Farkları','64783')#,
			ISSIZLIK_ISVEREN_HISSESI;#getLang('','SGK İşsizlik İşveren Primi','64784')#,
			ISSIZLIK_ISCI_HISSESI;#getLang('','SGK İşsizlik İşçi Primi','64785')#,
			SSK_ISCI_HISSESI;#getLang('','SGK İşçi Primi','53719')#,
			SSK_ISVEREN_HISSESI_;#getLang('','SGK İşveren Primi','53256')#,
			SSK_ISVEREN_HISSESI_HESAPLANAN; #getLang('','SGK İşveren Primi','53256')# (#getLang('','SGK İşveren İndirimsiz','30887')#),
			SSDF_ISVEREN_HISSESI;#getLang('','SGDP İşveren Primi','54311')#,
			SSDF_ISCI_HISSESI;#getLang('','SGDP İşçi Primi','54308')#,
			TOTAL_SGK_ISCI_PRIM_;#getLang('','Toplam SGK İşçi Primi','64786')#,
			TOTAL_SGK_PRIM_;#getLang('','Toplam SGK İşveren Primi','64787')#,
			SSK_ISVEREN_HISSESI_GOV; #getLang('','SGK İşveren Primi 5763 İndirimi','64789')#,
			SSK_ISVEREN_HISSESI_5921;#getLang('','SGK İşveren Primi 5921 İndirimi','64790')#,
			SSK_ISVEREN_HISSESI_5510;#getLang('','SGK İşveren Primi 5510 İndirimi','64791')#,
			SSK_ISVEREN_HISSESI_5084;#getLang('','SGK İşveren Primi 5084 İndirimi','64792')#,
			SSK_ISVEREN_HISSESI_5746;#getLang('','SGK İşveren Primi 5746 İndirimi','64793')#,
			SSK_ISVEREN_HISSESI_6111;#getLang('','SGK İşveren Primi 6111 İndirimi','64794')#,
			SSK_ISVEREN_HISSESI_6486;#getLang('','SGK İşveren Primi 6486 İndirimi','64795')#,
			SSK_ISVEREN_HISSESI_6322;#getLang('','SGK İşveren Primi 6322 İndirimi','64796')#,
			SSK_ISVEREN_HISSESI_14857;#getLang('','SGK İşveren Primi 14857 İndirimi','64797')#,
			SSK_ISVEREN_HISSESI_6645;#getLang('','SGK İşveren Primi 6645 İndirimi','64798')#,
			VERGI_ISTISNA_VERGI;#getLang('','Vergi İstisnası Vergisi','64800')#,
			VERGI_ISTISNA_VERGI_NET;#getLang('','Vergi İstisnası Vergi Net','64801')#,
			VERGI_ISTISNA_DAMGA_NET;#getLang('','Vergi İstisna Net','64802')#,
			VERGI_ISTISNA_TOTAL;#getLang('','Toplam Vergi İstisnası','64803')#,
			SSK_ISCI_HISSESI_DUSULECEK_;#getLang('','SGK Devir İşçi Hissesi Fark','54300')#,
			ISSIZLIK_ISCI_HISSESI_DUSULECEK;#getLang('','SGK Devir İşsizlik Hissesi Fark','54301')#,
			SGDP_ISCI_PRIMI_FARK;#getLang('','SGDP İşçi Primi Fark','54302')#,
			SGK_PRIM_INDIRIMI_687;#getLang('','SGK Primi 687 İndirimi','64804')#,
			GELIR_VERGISI_INDIRIMI_687;#getLang('','Gelir Vergisi 687 İndirimi','64805')#,
			DAMGA_VERGISI_INDIRIMI_687;#getLang('','Damga Vergisi 687 İndirimi','64806')#,
			BES_ISCI_HISSESI;#getLang('','Otomatik BES Katılım Payı','59535')#,
			SGK_PRIM_INDIRIMI_7103;#getLang('','SGK Primi 7103 İndirimi','64807')#,
			SSK_ISVEREN_HISSESI_7103;#getLang('','SGK İşveren Primi 7103 İndirimi','64808')#,
			SSK_ISCI_HISSESI_7103;#getLang('','SGK İşçi Primi 7103 İndirimi','64809')#,
			ISSIZLIK_ISCI_HISSESI_7103;#getLang('','SGK İşçi İşsizlik Primi 7103 İndirimi','64810')#,
			ISSIZLIK_ISVEREN_HISSESI_7103;#getLang('','SGK İşveren İşsizlik Primi 7103 İndirimi','64811')#,
			GELIR_VERGISI_INDIRIMI_7103;#getLang('','Gelir Vergisi 7103 İndirimi','64812')#,
			DAMGA_VERGISI_INDIRIMI_7103;#getLang('','Damga Vergisi 7103 İndirimi','64813')#,
			SSK_ISVEREN_HISSESI_7252;#getLang('','SGK İşveren Primi 7252 İndirimi','64814')#,
			SSK_ISCI_HISSESI_7252;#getLang('','SGK İşçi Primi 7252 İndirimi','64815')#,
			ISSIZLIK_ISCI_HISSESI_7252;#getLang('','İşsizlik Sigortası 7252 İşçi','64816')#,
			ISSIZLIK_ISVEREN_HISSESI_7252;#getLang('','İşsizlik Sigortası 7252 İşveren','64817')#,
			DAMGA_VERGISI_INDIRIMI_5746;#getLang('','Damga Vergisi İndirimi','59370')# 5746,
			KESINTI_VE_AGI_ONCESI_NET_2;#getLang('','Kesinti AGİ Öncesi(Brüt Kes. hariç)','64818')# 2,
			OZEL_KESINTI_2_NET_FARK;#getLang('','Brüt Kesintinin SGK İşçi Primi','64819')# 2,
			OZEL_KESINTI_2;#getLang('','Brüt Kesinti','64820')#,
			SGK_PRIM_INDIRIMI_7252;#getLang('','SGK Primi 7252 İndirimi','64821')#,
			DAMGA_VERGISI_INDIRIMI_5746;#getLang('','Damga Vergisi İndirimi','59370')# 5746,
			SSK_ISVEREN_HISSESI_7256;#getLang('','SGK İşveren Primi 7256 İndirimi','64822')#,
			SSK_ISCI_HISSESI_7256;#getLang('','SGK İşçi Primi 7256 İndirimi','64823')#,
			ISSIZLIK_ISCI_HISSESI_7256;#getLang('','İşsizlik Sigortası 7256 İşçi','64824')#,
			ISSIZLIK_ISVEREN_HISSESI_7256;#getLang('','İşsizlik Sigortası 7256 İşveren','64825')#,
			SGK_PRIM_INDIRIMI_7256;#getLang('','SGK Primi 7256 İndirimi','64826')#,
            SSK_ISVEREN_HISSESI_3294;#getLang('','SGK İşveren Primi 3294 İndirimi','65391')#,
			SSK_ISCI_HISSESI_INDIRIMLI;#getLang('','SGK İşçi Hissesi İndirimli','64827')#,
			INCOME_TAX_TEMP;#getLang('','Asgari Ücret Faydalanılan','64746')# #getLang('','	Gelir Vergisi','53250')#,
			STAMP_TAX_TEMP;#getLang('','Asgari Ücret Faydalanılan Damga Vergisi','64769')#,
			HEALTH_INSURANCE_PREMIUM_WORKER;#getLang('','SGK','58714')# #getLang('','genel sağlık sigortası','53191')# #getLang('','İşçi','45049')#,
			DEATH_INSURANCE_PREMIUM_WORKER;#getLang('','SGK','58714')# #getLang('','Uzun Vadeli Sigorta Primi','65181')# #getLang('','İşçi','45049')#,
			HEALTH_INSURANCE_PREMIUM_EMPLOYER;#getLang('','SGK','58714')# #getLang('','genel sağlık sigortası','53191')# #getLang('','İşveren','56406')#,
			DEATH_INSURANCE_PREMIUM_EMPLOYER;#getLang('','SGK','58714')# #getLang('','Uzun Vadeli Sigorta Primi','65181')# #getLang('','İşveren','56406')#,
			SHORT_TERM_PREMIUM_EMPLOYER;#getLang('','SGK','58714')# #getLang('','Kısa Vadeli Sigorta Primi','65166')#,
			INDIRIMSIZ_DAMGA_VERGISI;#getLang('','İndirimsiz','30887')# #getLang('','Damga Vergisi','53252')#
			">
		<cfreturn puantaj_account_name_list_>
	</cffunction>
	
	<!--- Harcırah bordro kalemleri--->
	<cffunction name="puantaj_account_name_list2" returntype="String">
		<cfset puantaj_account_name_list2_="
			BRUT_AMOUNT;Harcırah Brüt,
			NET_AMOUNT;Harcırah Net,
			GELIR_VERGISI;Harcırah Gelir Vergisi,
			DAMGA_VERGISI;Harcırah Damga Vergisi
			">
		<cfreturn puantaj_account_name_list2_>
	</cffunction>

	<!--- Memur bordro kalemleri--->
	<cffunction name="officer_account_name_list" returntype="String">
		<cfset officer_account_name_list="
			ADDITIONAL_INDICATORS;#getLang('','Ek gösterge Aylığı','63674')#
			,SEVERANCE_PENSION;#getLang('','kıdem Aylığı','63278')#
			,BUSINESS_RISK;#getLang('','Yan Ödeme','63275')#
			,UNIVERSITY_ALLOWANCE;#getLang('','Üniversite Ödeneği','62884')#
			,PRIVATE_SERVICE_COMPENSATION;#getLang('','Özel Hizmet Tazminatı','63274')#
			,LANGUAGE_ALLOWANCE;#getLang('','Dil Tazminatı','62883')#
			,EXECUTIVE_INDICATOR_COMPENSATION;#getLang('','Makam Tazminatı','63280')#
			,ADMINISTRATIVE_COMPENSATION;#getLang('','Görev Tazminatı','63283')#
			,ADMINISTRATIVE_DUTY_ALLOWANCE;#getLang('','İdari Görev Tazminatı','63281')#
			,EDUCATION_ALLOWANCE;#getLang('','Eğitim Öğretim Ödeneği','63282')#
			,FAMILY_ASSISTANCE;#getLang('','Eş Yardımı','63664')#
			,CHILD_ASSISTANCE;#getLang('','Çocuk Yardımı','46080')#
			,BASE_SALARY;#getLang('','Taban Aylığı','63277')#
			,RETIREMENT_ALLOWANCE;#getLang('','Emekli Keseneği','63273')# #getLang('','Devlet','44806')#
			,RETIREMENT_ALLOWANCE_PERSONAL;#getLang('','Emekli Keseneği','63273')# #getLang('','Kişi','29831')#
			,RETIREMENT_ALLOWANCE_PERSONAL_INTERRUPTION;#getLang('','Emekli Keseneği','63273')# #getLang('','Kişi','29831')#(-)
			,GENERAL_HEALTH_INSURANCE;#getLang('','Genel Sağlık Sigortası','53191')#
			,SGK_BASE;#getLang('','SGK Matrahı','53245')#
			,COLLECTIVE_AGREEMENT_BONUS;#getLang('','Toplu Sözleşme İkramiyesi','63284')#
			,PLUS_RETIRED;#getLang('','Artış','48315')# %100
			,PLUS_RETIRED_PERSONAL;#getLang('','','63278')# #getLang('','Kişi','29831')# #getLang('','Devlet','44806')# %100
			,ADDITIONAL_INDICATOR_COMPENSATION;#getLang('','Ek Ödeme (666 KHK)','63949')#
			,RETIREMENT_ALLOWANCE_5510;#getLang('','Emekli Keseneği','63273')# / #getLang('','Malul Yaşlı','63844')# (#getLang('','Devlet','44806')#) 5510
			,RETIREMENT_ALLOWANCE_PERSONAL_5510;#getLang('','Emekli Keseneği','63273')# / #getLang('','Malul Yaşlı','63844')# (#getLang('','Kişi','29831')#) 5510
			,HEALTH_INSURANCE_PREMIUM_5510;#getLang('','Sağlık Sigortası Primi','63279')# #getLang('','Devlet','44806')#
			,HEALTH_INSURANCE_PREMIUM_PERSONAL_5510;#getLang('','Sağlık Sigortası Primi','63279')# (#getLang('','Kişi','29831')#) 5510
			,HIGH_EDUCATION_COMPENSATION_PAYROLL;#getLang('','Yüksek Öğretim Tazminatı','62937')#
			,PENANCE_DEDUCTION;#getLang('','Kefaret Kesintisi','64057')#
			,ACADEMIC_INCENTIVE_ALLOWANCE_AMOUNT;#getLang('','Akademik Teşvik Ödeneği','62936')#
			,AUDIT_COMPENSATION_AMOUNT;#getLang('','Denetim Tazminatı','64065')#
			,LAND_COMPENSATION_AMOUNT;#getLang('','Arazi Tazminatı','64569')#
			">
		<cfreturn officer_account_name_list>
	</cffunction>
	
	<cffunction name="reason_list" returntype="String">
		<cfset reason_list_ = "
					(15)#getLang('','Toplu İşçi Çıkarma',59635)#;
					(3)#getLang('','Belirsiz Süreli İş Sözleşmesinin İşçi Tarafından Feshi',59636)#;
					(9)#getLang('','Malülen Emeklilik Nedeniyle',64929)#;
					(8)#getLang('','Emeklilik (Yaşlılık veya Toptan Ödeme Nedeniyle)',64930)#;
					(10)#getLang('','Ölüm',40507)#;
					(12)#getLang('','Askerlik',55619)#;
					(13)#getLang('','Kadın İşçinin Evlenmesi',64931)#;
					(22)(4857 16)#getLang('','İşe Ara Verme',40510)#(#getLang('','Zorunlu Nedenler',40511)#);
					(28)#getLang('','İşveren Tarafından Sağlık Nedeni İle Fesih',59638)#;
					(25)#getLang('','İşçi Tarafından İşverenin Ahlak ve İyiniyet Kurallarına Aykırı Davranması Nedeni İle Fesih',64932)#;
					(26)#getLang('','Disiplin Kurulu Kararı İle Fesih',40513)#;
					(22)(4857 25-2)#getLang('','Devamsızlık',56893)#;
					(22)(4857 17)#getLang('','İşe Ara Verme',40510)#(#getLang('','Zorunlu Nedenler',40511)#);
					(24)#getLang('','İşçi Tarafından Sağlık Nedeniyle Fesih',59640)#;
					(29)#getLang('','İşveren Tarafından İşçinin Ahlak ve İyiniyet Kurallarına Aykırı Davranması Nedeni İle Fesih',64933)#;
					(22)#getLang('','Kaldırılan Çıkış Maddesi',59642)#;
					(18)#getLang('','İşin Sona Ermesi',40515)#;
					(16)#getLang('','Nakil',40516)#;
					(17)#getLang('','İşyerinin Kapanması',40517)#;
					(30)#getLang('','Vize Süre Bitimi / İş Akdinin Askıya Alınması Halinde',64934)#;
					(2)#getLang('','Deneme Süreli İş Sözleşmesinin İşçi Tarafından Feshi',59645)#;
					(19)#getLang('','Mevsim Bitimi',40519)#;
					(20)#getLang('','Kampanya Bitimi',40520)#;
					(21)#getLang('','Statü Değişikliği',40521)#;
					(1)#getLang('','Deneme Süreli İş Sözleşmesinin İşverence Feshi',59646)#;
					(4)#getLang('','Belirsiz Süreli İş Sözleşmesinin İşveren Tarafından Feshi',64938)#;
					(5)#getLang('','Belirli süreli iş sözleşmesinin sona ermesi',35077)#;
					(22)#getLang('','Diğer nedenler',35232)#;
					(14)#getLang('','Emeklilik İçin Yaş Dışında Diğer Şartların Tamamlanması',59648)#;
					(6)#getLang('','İş Sözleşmesinin Haklı Nedenlerle İşçi Tarafından Feshi',64939)#;
					(7)#getLang('','İş Sözleşmesinin Haklı Nedenlerle İşverence Feshi',64940)#;
					(11)#getLang('','İş Kazası Sonucu Ölüm',59649)#;
					(23)#getLang('','İşçi Tarafından Zorunlu Nedenle Fesih',59650)#;
					(27)#getLang('','İşveren Tarafından Zorunlu Nedenlerle ve Tutukluluk Nedeniyle Fesih',59651)#;
					(31)#getLang('','Borçlar Kanunu,Sendikalar Kanunu,Grev ve Lokavt Kanunu Kapsamında Kendi İstek ve Kusuru Dışında Fesih',59652)#;
					(32)#getLang('','4046 Sayılı Kanunun 21. Maddesine Göre Özelleştirme Nedeniyle Fesih',59653)#;
					(33)#getLang('','Gazeteci Tarafından Sözleşmenin Feshi',59654)#;
					(34)#getLang('','İşyerinin Devri, İşin veya İşyerinin Niteliğinin Değişmesi Nedeniyle Fesih',59655)#;
					(39)#getLang('','696 KHK ile Kamu İşçiliğine Geçiş',64942)#;
					(40)#getLang('','696 KHK ile Kamu İşçiliğine Geçilememesi Sebebi ile Çıkış	',64943)#;
					(38)#getLang('','Doğum Nedeniyle İşten Ayrılma',64944)#;
					(42)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-a(#getLang('','Gerekli vasıflar veya şartlar kendisinde bulunmadığı',64946)#);
                    (43)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-b(#getLang('','İşveren yahut bunların aile üyelerinden birinin şeref ve namusuna dokunacak sözler sarfetmesi',64947)#);
                    (44)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-c(#getLang('','İşçinin işverenin başka bir işçisine cinsel tacizde bulunması',64948)#.);
                    (45)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-d(#getLang('','Başka işçiye sataşması, işyerine sarhoş yahut uyuşturucu madde almış olarak gelmesi',64949)#);
                    (46)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-e(#getLang('','Hırsızlık yapmak, meslek sırlarını ortaya atmak gibi doğruluk ve bağlılığa uymayan davranış',64950)#);
                    (47)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-f(#getLang('','Yedi günden fazla hapisle cezalandırılan ve cezası ertelenmeyen bir suç işlemesi',64951)#.);
                    (48)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-g(#getLang('','Devamsızlık - Haklı bir sebebe dayanmaksızın işine devam etmemesi',64952)#.);
                    (49)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-h(#getLang('','Ödevli bulunduğu görevleri kendisine hatırlatıldığı halde yapmamakta ısrar etmesi',64954)#.);
                    (50)#getLang('','4857 sayılı Kanun Madde 25',64945)#-II-ı(#getLang('','İşin güvenliğini tehlikeye düşürmesi, makineleri, tesisatı veya başka eşya ve maddeleri hasara ve kayba uğratması',64955)#.)
					">
		<cfreturn reason_list_> 
	</cffunction>
	
	<cffunction name="law_list" returntype="String">
		<cfset law_list_ = "15,3,9,8,10,12,13,22,28,25,26,22,22,24,29,22,18,16,17,30,2,19,20,21,1,4,5,22,14,6,7,11,23,27,31,32,33,34,39,40,38,42,43,44,45,46,47,48,49,50">
		<cfreturn law_list_>
	</cffunction>
	
	<cffunction name="reason_order_list" returntype="String">
		<cfset reason_order_list_ = "25,21,2,26,27,30,31,4,3,5,32,6,7,29,1,18,19,17,22,23,24,28,33,14,10,11,34,9,15,20,35,36,37,38,8,12,13,16,39,40,41,42,43,44,45,46,47,48,49,50">
		<cfreturn reason_order_list_>
	</cffunction>
	
	<cffunction name="ay_list" returntype="String">
        <cfset ay_list_ = ''>
        <!--- 180 : Ocak, 191 : Aralık --->
        <cfloop index="ind" from="180" to="191">
        	<cfset ay_list_ = listAppend(ay_list_,getLang('main',ind))>
        </cfloop>
		<cfreturn ay_list_>
	</cffunction>
	
	<cffunction name="get_explanation_name" returntype="string" output="true">
		<cfargument name="exp_id" required="yes" type="string">
		<cfscript>
			if(arguments.exp_id eq -1)
				exp_name = "Giriş";
			else if(len(arguments.exp_id))
				exp_name = listgetat(reason_list(),arguments.exp_id,';');
			else
				exp_name = "";
		</cfscript>
		<cfreturn exp_name>
	</cffunction>
	
	<cffunction name="list_ucret" returntype="String">
		<cfset list_ucret_ = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,50,60,18,19,70,71,75,72,73,74,21,32,33">
		<cfreturn list_ucret_>
	</cffunction>
	
	<cffunction name="list_ucret_names" returntype="String"> 
		<cfset list_ucret_names_ = "#getLang('','Normal','59207')#*#getLang('','Emekli','58541')#*#getLang('','Stajyer Öğrenci','56408')#*#getLang('','Çırak','56409')#*#getLang('','Anlaşmaya Tabi Olmayan Yabancı','56410')#*#getLang('','Anlaşmalı Ülke Yabancı Uyruk','56411')#*#getLang('','Deniz','64577')#,#getLang('','Basım','64578')#,#getLang('','Azot','64579')#,#getLang('','Şeker','41853')#*04-Yeraltı Sürekli*#getLang('','Yeraltı Gruplu','56414')#*#getLang('','Yerüstü Gruplu','56415')#*#getLang('','YÖK Kısmi İstihdam Öğrenci','56416')#*#getLang('','Tüm Sigorta Kolları İşsizlik Hariç','64580')#*#getLang('','LIBYA','56417')#*
		#getLang('','2098 Sayılı Kanun İşsizlik Hariç','56418')#*#getLang('','2098 Görevli Malül. Aylığı Alanlar','56419')#*#getLang('','Görev Malüllük Aylığı Alanlar','56420')#*#getLang('','İş Kazası,Mes.Hast.,Analık ve Hast. Sig. Tabi','64581')#*#getLang('','Emekli Sandığı','56422')#*#getLang('','Banka ve Diğerleri','56423')#*48-Yeraltı Emekli*35-Tüm sigorta kollarına tabi çalışıp 90 gün fiili hizmet süresi zammına tabi çalışanlar*#getLang('','Bağ-kur','53956')#*#getLang('','Yabancı Uyruk Özel Anlaşma','54088')#*#getLang('','Mesleki Stajyer','54078')#*#getLang('','Nöbetçi Doktor','54089')#*#getLang('','Ders Saati Ücretliler','54090')#*#getLang('','Sabit Ücretliler','54091')#*#getLang('','Sözleşmesiz Ülkelere Götürülerek Çalıştırılanlar','54295')#*#getLang('','Tüm sigorta kollarına tabi çalışıp 90 gün fiili hizmet süresi zammına tabi çalışanlar','59474')#*#getLang('','5434 Sayılı Kanuna Tabi Çalışan','63737')#">
		<cfreturn list_ucret_names_>
	</cffunction>

</cfcomponent>
