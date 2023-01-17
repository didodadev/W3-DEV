<cfsetting showdebugoutput="no">
<cfquery name="CHECK_IMPORTED" datasource="#DSN2#">
    SELECT I_ID FROM FILE_IMPORTS WHERE IS_TRANSFER = 1 AND I_ID = #attributes.i_id#
</cfquery>
<cfif check_imported.recordcount>
    <script type="text/javascript">
        alert('Bu Dosya Dönüştürülmüş, Tekrar Dönüştürülemez!');
        wrk_opener_reload();
        window.close;
    </script>
    <cfabort>
</cfif>

<cfscript>
	start_time = now();
	CRLF = Chr(13)&Chr(10); // satır atlama karakteri
</cfscript>

<cfset islem_baslama = dateadd('h',2,now())>
<cfquery name="get_barcodes" datasource="#dsn1#">
    SELECT 
        SB.BARCODE,
        S.STOCK_ID ,
        S.PRODUCT_ID
    FROM 
        STOCKS_BARCODES SB,
        STOCKS S,
        PRODUCT P
    WHERE
        S.STOCK_ID = SB.STOCK_ID AND
        S.PRODUCT_ID = P.PRODUCT_ID AND
        S.STOCK_STATUS = 1 AND
        P.PRODUCT_STATUS = 1 AND
        SB.BARCODE <> '' AND
        SB.BARCODE IS NOT NULL
</cfquery>

<cfquery name="GET_IMPORT" datasource="#DSN2#">
	SELECT
		FI.SOURCE_SYSTEM,
		FI.STARTDATE,
		FI.DEPARTMENT_ID,
		FI.DEPARTMENT_LOCATION,
		FI.IMPORT_DETAIL,
		FI.FILE_NAME,
		FI.FILE_SERVER_ID,		
		D.BRANCH_ID,
        B.OZEL_KOD
	FROM
		FILE_IMPORTS FI,
		#dsn_alias#.DEPARTMENT D,
        #dsn_alias#.BRANCH B
	WHERE
		D.BRANCH_ID = B.BRANCH_ID AND
        FI.I_ID = #attributes.i_id# AND
		FI.DEPARTMENT_ID = D.DEPARTMENT_ID
</cfquery>

<cfset sube_kodu = GET_IMPORT.OZEL_KOD>
<cfloop from="1" to="#6-len(GET_IMPORT.OZEL_KOD)#" index="aaa">
	<cfset sube_kodu = '0#sube_kodu#'>
</cfloop>

<cfif not isDefined('GET_STOCK_ALL')>
    <cfquery name="GET_STOCK_ALL" datasource="#DSN1#">
        SELECT
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.BARCOD,
            PRODUCT.TAX,
            PRODUCT.IS_KARMA,
            PRODUCT_UNIT.MULTIPLIER,
            PRODUCT_UNIT.ADD_UNIT
        FROM
            STOCKS,
            PRODUCT_UNIT,
            PRODUCT
        WHERE
            PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
            PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
            PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID		
    </cfquery>
</cfif>
<!---
<cfinclude template="../../../../v16/objects/functions/sales_import_functions.cfm">
--->

<cf_get_server_file output_file="store#dir_seperator##get_import.file_name#" output_server="#get_import.file_server_id#" output_type="3" read_name="dosya">

<cfset new_basket = StructNew()>
<cfset fis_satir = 0>
        
	<cfscript>
	add_inv_row = ArrayNew(1);
	row_block = 200;
	dosya = ListToArray(dosya,CRLF);
	ArrayDeleteAt(dosya,1);
	line_count = ArrayLen(dosya);
	birim_list = "Adet,Kilogram,Metre,Litre";
	sube_satis_no = "#dateformat(get_import.startdate,'yyyymmdd')#_#get_import.DEPARTMENT_ID#_";
	invoice_date_general = createodbcdatetime(get_import.startdate);
	fis_no = 0;
	GROSS_TOTAL = 0;
	NET_TOTAL = 0;
	TAX_TOTAL = 0;
	TAX_TOTAL2 = 0;
	TOTAL_PRODUCTS = 0;
	PROBLEMS_COUNT = 0;
	virman_count = 0;
	
	for (i=1; i lte line_count;)
	{
		satir = dosya[i];
		i = i + 1;
		satir_count2 = 0;
		satir_count3 = 0;
		satir_count5 = 0;
		
		if ((left(satir, 3) eq 1) and (i lt line_count))
		{
			satir_1 = satir;
		}
		else
		{
			if (fusebox.circuit neq 'schedules')
				writeoutput("<br/> #oku(satir,1,3)# -------- 1.Satır Bulunamadı Sorunu Var --------<br/>");
			break;
		}

		satir = dosya[i];
		fis_no = fis_no + 1;
		if (len(trim(oku(satir_1,64,10))))
			temp_fis_no = oku(satir_1,64,10);
		else
			temp_fis_no = "#sube_satis_no##fis_no#";

		// Satır 02 ler okunur
		while ((left(satir, 3) eq 2) and (i lt line_count))
		{
			/*Bu kontrol ersandaki sorunlar yuzunden tekrar kapatıldı. bos satirlar Sorunlu kayitlara aktariliyor alt bolumde BK 20080724*/
			//if(len(oku(satir, 10, 24)) and (ListLen(oku(satir, 10, 24), ".") eq 2))//product id.stock_id ifadesinin uzunlugu ve noktali mi kontrolu
			//{
				satir_count2 = satir_count2 + 1;
				"satir_2_#satir_count2#" = satir;
			//}
			i = i + 1;
			satir = dosya[i];
		}
		
		temp_i = i;

		// Satır 03 ler okunur, Kredi karti-Nakit ödeme toplamlari bulunur
		credit_card_payment_total = 0;
		creditcard_no = "";
		while ((left(satir, 3) eq 3) and (i lt line_count))
		{
			if (listfind('0,1,2',oku(satir,12,1)))
			{
				satir_count3 = satir_count3 + 1;
				"satir_3_#satir_count3#" = satir;
			}
			i = i + 1;
			satir = dosya[i];
		}
		
		// Bu eklenti satir1,satir2 degerinden sonra satir3 blogunun bulanamadığı icin yapıldı.		
		if(satir_count3 eq 0)
		{
			//writeoutput("<br/> Satır 3 Bulunamadı Dosyanızı Kontrol (#i#)! <br/>");
			break;
		}
		
		// Satır 04 lar atlanir Not: 04 ve 06 satırları ozellikle tek bir ifadede birlesmedi.
		while( (left(satir, 3) eq 4) and (i lt line_count))
		{
			i = i + 1;
			satir = dosya[i];
		}
		
		// Satır 05 ler okunur Hediye urunler icin (Pick & Mix Hediyeleri)
		while ((left(satir, 3) eq 5) and (i lt line_count))
		{
			satir_count5 = satir_count5 + 1;
			"satir_5_#satir_count5#" = satir;
			
			i = i + 1;
			satir = dosya[i];		
		}

		// Satır 06 lar atlanir
		while( (left(satir, 3) eq 6) and (i lt line_count))
		{
			i = i + 1;
			satir = dosya[i];
		}
		
		/* satır 04,05,06 lar atlanir Önceki hali BK 20070412 180 gune kaldirilabilir
		while(listfind('04,05,06', oku(satir,1,3),',') and (i lt line_count))
		{
			i = i + 1;
			satir = dosya[i];
		}*/
		
		satir = dosya[temp_i];
		
		belge_turu = oku(satir_1,62,1);
		fis_iptal = oku(satir_1,63,1);
		kasiyer_no = oku(satir_1,54,8);
		fisno = oku(satir_1,24,12);
		fistarihi = oku(satir_1,10,14);
		fisbaslangic = oku(satir_1,36,6);
		fisbitis = oku(satir_1,36,6);
		fistoplam = oku(satir_1,92,15);
		fistoplamkdv = oku(satir_1,107,15);
		kasanumarasi = oku(satir_1,4,6);
		maliyeno = '';
		zno = '';
		musteri_no = oku(satir_1,212,24);
		fis_satir_alti_indirim = oku(satir_1,122,15);
		fis_promosyon_indirim = oku(satir_1,137,15);
		
		fis_satir = fis_satir + 1;
		new_basket[fis_satir] = StructNew();

		new_basket[fis_satir].fis_sira = fis_satir;
		new_basket[fis_satir].fis_toplam_kdv = filternum(fistoplamkdv);
		new_basket[fis_satir].fis_toplam = filternum(fistoplam);
		new_basket[fis_satir].fis_numarasi = fisno;
		new_basket[fis_satir].maliye_no = maliyeno;
		new_basket[fis_satir].kasa_numarasi = kasanumarasi;
		new_basket[fis_satir].sube_kodu = '#sube_kodu#';
		new_basket[fis_satir].fis_tarihi = '#replace(fistarihi,'/','','all')##fisbaslangic#';
		new_basket[fis_satir].fis_tarihi_bitis = '#replace(fistarihi,'/','','all')##fisbaslangic#';
		new_basket[fis_satir].belge_turu = val(belge_turu);
		new_basket[fis_satir].kasiyer_no = kasiyer_no;
		new_basket[fis_satir].musteri_no = musteri_no;
		new_basket[fis_satir].zno = zno;
		new_basket[fis_satir].fis_iptal = fis_iptal;
		new_basket[fis_satir].kdv0 = 0;
		new_basket[fis_satir].kdv1 = 0;
		new_basket[fis_satir].kdv8 = 0;
		new_basket[fis_satir].kdv18 = 0;
		new_basket[fis_satir].fis_satir_alti_indirim = filternum(fis_satir_alti_indirim);
		new_basket[fis_satir].fis_promosyon_indirim = filternum(fis_promosyon_indirim);
		new_basket[fis_satir].kazanilan_puan = 0;
		new_basket[fis_satir].kullanilan_puan = 0;
		new_basket[fis_satir].fis_satirlar = StructNew();
		new_basket[fis_satir].fis_odemeler = StructNew();
		
		//writeoutput('#htmlcodeformat(satir_1)# <br>');
		for (j=1; j lte satir_count2; j=j+1)
		{
			tempo = evaluate("satir_2_#j#");
			
			urun_sayisi = j;
			new_basket[fis_satir].fis_satirlar[urun_sayisi] = StructNew();
			
			new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_tipi = 'IS';
			new_basket[fis_satir].fis_satirlar[urun_sayisi].stock_id = oku(tempo,10,24);
			new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_iptalmi = oku(tempo,34,1);
			new_basket[fis_satir].fis_satirlar[urun_sayisi].barcode = oku(tempo,183,24);
			
			birim = filternum(oku(tempo,61,1));
			miktar = filternum(oku(tempo,46,15));
			
			if (birim eq 0)
				birim_adi = "Adet";
			else if (birim eq 1)
				birim_adi = "KG";
			else if (birim eq 2)
				birim_adi = "Metre";
			else if (birim eq 3)
				birim_adi = "Litre";

			if(birim neq 0)
				miktar = miktar / 1000;
			
			new_basket[fis_satir].fis_satirlar[urun_sayisi].miktar = miktar;
			new_basket[fis_satir].fis_satirlar[urun_sayisi].birim = birim;
			new_basket[fis_satir].fis_satirlar[urun_sayisi].birim_adi = birim_adi;

			new_basket[fis_satir].fis_satirlar[urun_sayisi].birim_fiyat = filternum(oku(tempo,62,15));
			new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_kdv = filternum(oku(tempo,43,2));
			new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_toplam = filternum(oku(tempo,77,15));
			new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_kdv_tutar = filternum(oku(tempo,92,15));
			new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_indirim = filternum(oku(tempo,137,15));
			new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_promosyon_indirim = filternum(oku(tempo,167,15));
		}
		
		for (m=1; m lte satir_count3; m=m+1)
		{
			tempo = evaluate("satir_3_#m#");
			odeme_sayisi = m;
			new_basket[fis_satir].fis_odemeler[odeme_sayisi] = StructNew();
			
			odeme_tipi = oku(tempo,12,1);
			odeme_turu = oku(tempo,10,2);
			odeme_iptalmi = oku(tempo,13,1);
			
			odeme_tutar = filterNum(oku(tempo,14,15));
			
			if(odeme_iptalmi eq 1)
				odeme_iptalmi = 0;
			else
				odeme_iptalmi = 1;
			
			new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tipi = odeme_tipi;
			new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_turu = odeme_turu;
            new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tutar = odeme_tutar;
            new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_iptalmi = odeme_iptalmi;
		}
		
		for (k=1; k lte satir_count5; k=k+1)
		{
			tempo = evaluate("satir_5_#k#");
			
			if(oku(tempo,4,1))//info
			{
				if(val(oku(tempo,5,4)) eq 2)//kazanilan puan
					new_basket[fis_satir].kazanilan_puan = new_basket[fis_satir].kazanilan_puan + filternum(oku(tempo,11,15));
				
				if(val(oku(tempo,5,4)) eq 4)//kullanilan puan
					new_basket[fis_satir].kullanilan_puan = new_basket[fis_satir].kullanilan_puan + filternum(oku(tempo,11,15));
			}
			else
			{
				
			}
		}				
	}
</cfscript>



<cftransaction>
<cfset fis_sayisi = StructCount(new_basket)>
<cfif fis_sayisi gt 0>
	<cfloop from="1" to="#fis_sayisi#" index="fis_satir">
		<cfset toplam_hareket = StructCount(new_basket[fis_satir].fis_satirlar)> 
		<cfset toplam_odeme_hareket = StructCount(new_basket[fis_satir].fis_odemeler)> 
		
		<cfif toplam_hareket gt 0>
			<cfset fis_tarih = new_basket[fis_satir].fis_tarihi>
			<cfset fis_tarih_bitis = new_basket[fis_satir].fis_tarihi_bitis>
			
			<cfset yil_ = mid(fis_tarih,5,4)>
			<cfset ay_ = mid(fis_tarih,3,2)>
			<cfset gun_ = mid(fis_tarih,1,2)>
			<cfset saat_ = mid(fis_tarih,9,2)>
			<cfset dakika_ = mid(fis_tarih,11,2)>
			<cfset saniye_ = mid(fis_tarih,13,2)>
			<cfset fis_tarih = createodbcdatetime(createdatetime(yil_,ay_,gun_,saat_,dakika_,saniye_))>
			
			<cfset yil_ = mid(fis_tarih_bitis,5,4)>
			<cfset ay_ = mid(fis_tarih_bitis,3,2)>
			<cfset gun_ = mid(fis_tarih_bitis,1,2)>
			<cfset saat_ = mid(fis_tarih_bitis,9,2)>
			<cfset dakika_ = mid(fis_tarih_bitis,11,2)>
			<cfset saniye_ = mid(fis_tarih_bitis,13,2)>
			<cfset fis_tarih_bitis = createodbcdatetime(createdatetime(yil_,ay_,gun_,saat_,dakika_,saniye_))>
			
			<cfquery name="get_cont_" datasource="#dsn_dev#">
				SELECT 
					ACTION_ID 
				FROM 
					GENIUS_ACTIONS 
				WHERE 
					FIS_TARIHI = #fis_tarih# AND 
					KASA_NUMARASI = #new_basket[fis_satir].kasa_numarasi# AND
					FIS_NUMARASI = #new_basket[fis_satir].fis_numarasi# AND
					BELGE_TURU = #new_basket[fis_satir].belge_turu#
			</cfquery>
            
			<cfif not get_cont_.recordcount>
				<cfquery name="add_fis" datasource="#dsn_dev#" result="add_fis_r">
					INSERT INTO
						GENIUS_ACTIONS
						(
						ACTION_DATE,
						RECORD_DATE,
						BELGE_TURU,
						FIS_IPTAL,
						FIS_NUMARASI,
						FIS_TARIHI,
						FIS_TARIHI_BITIS,
						FIS_TOPLAM,
						FIS_TOPLAM_KDV,
						KASA_NUMARASI,
						KASIYER_NO,
						KDV0,
						KDV1,
						KDV8,
						KDV18,
						MALIYE_NO,
						MUSTERI_NO,
						SUBE_KODU,
						FIS_PROMOSYON_INDIRIM,
						FIS_SATIR_ALTI_INDIRIM,
						KAZANILAN_PUAN,
						KULLANILAN_PUAN,
						HAREKET_SAYISI,
						ODEME_SAYISI,
						ZNO
						)
						VALUES
						(
						#islem_baslama#,
						#now()#,
						'#new_basket[fis_satir].belge_turu#',
						#new_basket[fis_satir].fis_iptal#,
						#new_basket[fis_satir].fis_numarasi#,
						#fis_tarih#,
						#fis_tarih_bitis#,
						#new_basket[fis_satir].fis_toplam#,
						#new_basket[fis_satir].fis_toplam_kdv#,
						#new_basket[fis_satir].kasa_numarasi#,
						#new_basket[fis_satir].kasiyer_no#,
						#new_basket[fis_satir].kdv0#,
						#new_basket[fis_satir].kdv1#,
						#new_basket[fis_satir].kdv8#,
						#new_basket[fis_satir].kdv18#,
						'#new_basket[fis_satir].maliye_no#',
						'#new_basket[fis_satir].musteri_no#',
						'#new_basket[fis_satir].sube_kodu#',
						#new_basket[fis_satir].fis_promosyon_indirim#,
						#new_basket[fis_satir].fis_satir_alti_indirim#,
						#new_basket[fis_satir].kazanilan_puan#,
						#new_basket[fis_satir].kullanilan_puan#,
						#toplam_hareket#,
						#toplam_odeme_hareket#,
						'#new_basket[fis_satir].zno#'
						)
				</cfquery>
				<cfset action_id = add_fis_r.IDENTITYCOL>
				
					<cfloop from="1" to="#toplam_hareket#" index="urun_sayisi">
						<cfset barcode_ = trim(new_basket[fis_satir].fis_satirlar[urun_sayisi].barcode)>
						<cfset stock_id_ = "">
						<cfset product_id_ = "">
						<cfquery name="get_barcode" dbtype="query">
							SELECT STOCK_ID,PRODUCT_ID FROM get_barcodes WHERE BARCODE = '#barcode_#'
						</cfquery>
						<cfif get_barcode.recordcount>
							<cfset stock_id_ = get_barcode.stock_id>
							<cfset product_id_ = get_barcode.PRODUCT_ID>
						</cfif>
						<cfquery name="add_fis_row" datasource="#dsn_dev#">
							INSERT INTO
								GENIUS_ACTIONS_ROWS
								(
								FIS_TARIHI,
								ACTION_ID,
								BARCODE,
								BIRIM,
								BIRIM_ADI,
								BIRIM_FIYAT,
								MIKTAR,
								SATIR_IPTALMI,
								SATIR_KDV,
								SATIR_KDV_TUTAR,
								SATIR_TIPI,
								SATIR_TOPLAM,
								SATIR_INDIRIM,
								STOCK_ID,
								SATIR_PROMOSYON_INDIRIM
								)
								VALUES
								(
								#fis_tarih#,
								#action_id#,
								'#barcode_#',
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].birim#,
								'#new_basket[fis_satir].fis_satirlar[urun_sayisi].birim_adi#',
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].birim_fiyat#,
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].miktar#,
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_IPTALMI#,
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_KDV#,
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_KDV_TUTAR#,
								'#new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_TIPI#',
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_TOPLAM#,
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_INDIRIM#,
								<cfif len(stock_id_)>#stock_id_#<cfelse>NULL</cfif>,
								#new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_PROMOSYON_INDIRIM#
								)
						</cfquery>
						
						<cfif new_basket[fis_satir].fis_iptal eq 0 and new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_IPTALMI eq 0 and len(stock_id_) and len(product_id_) and year(islem_baslama) eq year(fis_tarih) and month(islem_baslama) eq month(fis_tarih) and day(islem_baslama) eq day(fis_tarih)>
							<!--- stok hareketi yap --->
							<cfif new_basket[fis_satir].belge_turu eq 2>
								<cfset stock_in_ = new_basket[fis_satir].fis_satirlar[urun_sayisi].miktar>
                                <cfset stock_out_ = 0>
                                <cfset stock_islem_tipi_ = -1004>
                            <cfelse>
                                <cfset stock_in_ = 0>
                                <cfset stock_out_ = new_basket[fis_satir].fis_satirlar[urun_sayisi].miktar>
                                <cfset stock_islem_tipi_ = -1003>
                            </cfif>
							<cfquery name="add_" datasource="#dsn2#">
								INSERT INTO
									STOCKS_ROW
									(
										STOCK_ID,
										PRODUCT_ID,
										UPD_ID,
										PROCESS_TYPE,
										STOCK_IN,
										STOCK_OUT,
										STORE,
										STORE_LOCATION,
										PROCESS_DATE,
										DELIVER_DATE,
										WRK_ROW_ID
									)
									VALUES
									(
										#stock_id_#,
										#product_id_#,
										#action_id#,
										#stock_islem_tipi_#,
										#stock_in_#,
										#stock_out_#,
										#department_id_#,
										1,
										#fis_tarih#,
										#fis_tarih#,
										'#new_basket[fis_satir].sube_kodu#-#new_basket[fis_satir].kasa_numarasi#-#trim(new_basket[fis_satir].kasiyer_no)#-#action_id#-#new_basket[fis_satir].fis_numarasi#-#dateformat(fis_tarih,"ddmmyyyy")#'
									)   
							 </cfquery>
							 <!--- stok hareketi yap --->
						 </cfif>
					</cfloop>
					
					<cfloop from="1" to="#toplam_odeme_hareket#" index="odeme_sayisi">
						<cfquery name="add_row_payment" datasource="#dsn_dev#">
							INSERT INTO
								GENIUS_ACTIONS_PAYMENTS
								(
								ACTION_ID,
								ODEME_TURU,
								ODEME_TUTAR,
								ODEME_TIPI,
								ODEME_IPTALMI
								)
								VALUES
								(
								#action_id#,
								#new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_turu#,
								<cfif new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tipi eq 1 or new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_iptalmi eq 1>
									#-1 * new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tutar#,
								<cfelse>
									#new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tutar#,
								</cfif>
								#new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tipi#,
								#new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_iptalmi#
								)
						</cfquery>
					</cfloop>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
</cftransaction>

<cfquery name="upd_" datasource="#dsn2#">
    UPDATE 
        FILE_IMPORTS
    SET
        IS_TRANSFER = 1
    WHERE
        I_ID = #attributes.i_id#
</cfquery>
<script>
	alert('Aktarım Başarıyla Tamamlandı!');
	window.opener.location.reload();
	window.close();
</script>
<cfabort>