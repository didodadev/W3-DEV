<cfif not isdefined("attributes.kasa_numarasi") or not listlen(attributes.kasa_numarasi)>
	<script>
		alert('Kasa Seçmelisiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cf_date tarih='attributes.startdate'>
<cfset islem_yil_ = year(attributes.startdate)>
<cfset islem_ay_ = month(attributes.startdate)>
<cfset islem_gun_ = day(attributes.startdate)>


<cfsetting showdebugoutput="no">
<cfset bugun_yil = year(now())>
<cfset bugun_ay = month(now())>
<cfset bugun_gun = day(now())>


<!--- zvarmi --->
<cfquery name="get_cont" datasource="#dsn_Dev#">
    SELECT 
        KASA_NUMARASI 
    FROM 
        POS_CONS 
    WHERE 
        YEAR(CON_DATE) = #islem_yil_# AND
        MONTH(CON_DATE) = #islem_ay_# AND
        DAY(CON_DATE) = #islem_gun_# AND
        KASA_NUMARASI IN (#attributes.kasa_numarasi#)
</cfquery>

<cfif get_cont.recordcount>
	<script>
		alert('Seçili Kasalarda Z Raporu Bulunmaktadır! İşlem Yapamazsınız.\nKasa Numaraları : <cfoutput>#valuelist(get_cont.KASA_NUMARASI)#</cfoutput>');
		history.back();
	</script>
    <cfabort>
</cfif>
<!--- zvarmi --->

<!--- satisi var mi --->
<cfquery name="get_cont_" datasource="#dsn_dev#">
    SELECT DISTINCT
        KASA_NUMARASI 
    FROM 
        GENIUS_ACTIONS 
    WHERE 
        YEAR(FIS_TARIHI) = #islem_yil_# AND
        MONTH(FIS_TARIHI) = #islem_ay_# AND
        DAY(FIS_TARIHI) = #islem_gun_# AND
        KASA_NUMARASI IN (#attributes.kasa_numarasi#)
</cfquery>
<cfif get_cont_.recordcount>
	<script>
		alert('Seçili Kasalarda Hareket Bulunmaktadır! İşlem Yapamazsınız.\nKasa Numaraları : <cfoutput>#valuelist(get_cont_.KASA_NUMARASI)#</cfoutput>');
		history.back();
	</script>
    <cfabort>
</cfif>
<!--- satisi var mi --->

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
            --S.STOCK_STATUS = 1 AND
            --P.PRODUCT_STATUS = 1 AND
            SB.BARCODE <> '' AND
            SB.BARCODE IS NOT NULL
    </cfquery>
    
    <cfset application.transfer_message = 'Satışlar Alınıyor.'>
    
    <cfset application.sure1 = now()>
    <cfset application.sure2 = now()>
    
    <cfquery name="GET_POS_EQUIPMENT" datasource="#DSN3#">
        SELECT
            (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B.BRANCH_ID) AS DEPARTMENT_ID,
            POS_EQUIPMENT.*,
            B.BRANCH_NAME
        FROM
            POS_EQUIPMENT,
            #dsn_alias#.BRANCH B
        WHERE
            POS_EQUIPMENT.IS_STATUS = 1 AND
            POS_EQUIPMENT.EQUIPMENT_CODE IN (#attributes.kasa_numarasi#) AND
            POS_EQUIPMENT.BRANCH_ID = B.BRANCH_ID AND
            POS_EQUIPMENT.OFFLINE_PATH IS NOT NULL AND 
            POS_EQUIPMENT.OFFLINE_PATH <> '' AND
            POS_EQUIPMENT.FILENAME <> '' AND
            POS_EQUIPMENT.FILENAME IS NOT NULL
        ORDER BY
            POS_EQUIPMENT.EQUIPMENT_CODE
    </cfquery>
    
    <cfset last_branch_id = 0>
    <cfif GET_POS_EQUIPMENT.recordcount><!--- KASALAR DONER --->
    <cfoutput query="GET_POS_EQUIPMENT">
    <cfif FileExists("#OFFLINE_PATH#\#FILENAME#")><!--- dosya var mı --->
        <cffile action="read" file="#OFFLINE_PATH#\#FILENAME#" variable="dosya_read">
        <cfscript>
            start_time = now();
            CRLF = Chr(13)&Chr(10); // satır atlama karakteri
            dosya = ListToArray(dosya_read,CRLF);
            satir_sayisi = arraylen(dosya);
        </cfscript>
        
        <cfset department_id_ = DEPARTMENT_ID>
        <cfset branch_id_ = BRANCH_ID>
        
        <cfset rn_say = 0>
        <cfset new_basket = StructNew()>
        <cfset fis_satir = 0>
        <cfloop from="1" to="#satir_sayisi#" index="satirlar">
                <cfset satir = dosya[satirlar]>	
                <cfif len(satir) gte 40>
                    <cfset islem_tipi  = mid(satir,20,2)>
                    <cfif islem_tipi is 'RH'>
                        <cfset fis_satir = fis_satir + 1>
                        <cfset kasa_numarasi = mid(satir,11,3)>
                        <cfset sube_kodu = mid(satir,14,6)>
                        <cfset tarih = mid(satir,33,14)>
                        <cfset tarih2 = mid(satir,47,14)>
                        <cfset belge_turu = mid(satir,71,1)>  
                        <cfset kasiyer_no = mid(satir,25,8)>
                        <cfset musteri_no = mid(satir,106,24)>
                        <cfset fis_iptal = mid(satir,22,1)>
                        <cfset kdv_toplam  = val(mid(satir,91,15))>
                        <cfset fis_toplam  = val(mid(satir,76,15))>
                        <cfset zno = mid(satir,133,4)>                        
                        <cfset fis_numarasi = mid(satir,1,6)>
                        
        
                        <cfset new_basket[fis_satir] = StructNew()>
                        <cfset new_basket[fis_satir].fis_sira = fis_satir>
                        <cfset new_basket[fis_satir].fis_toplam_kdv = kdv_toplam>
                        <cfset new_basket[fis_satir].fis_toplam = fis_toplam>
                        <cfset new_basket[fis_satir].fis_numarasi = fis_numarasi>
                        <cfset new_basket[fis_satir].maliye_no = "">
                        <cfset new_basket[fis_satir].kasa_numarasi = kasa_numarasi>
                        <cfset new_basket[fis_satir].sube_kodu = sube_kodu>
                        <cfset new_basket[fis_satir].fis_tarihi = tarih>
                        <cfset new_basket[fis_satir].fis_tarihi_bitis = tarih2>
                        <cfset new_basket[fis_satir].belge_turu = belge_turu>
                        <cfset new_basket[fis_satir].kasiyer_no = kasiyer_no>
                        <cfset new_basket[fis_satir].musteri_no = musteri_no>
                        <cfset new_basket[fis_satir].zno = zno>
                        <cfset new_basket[fis_satir].fis_iptal = fis_iptal>
                        <cfset new_basket[fis_satir].kdv0 = 0>
                        <cfset new_basket[fis_satir].kdv1 = 0>
                        <cfset new_basket[fis_satir].kdv8 = 0>
                        <cfset new_basket[fis_satir].kdv18 = 0>
                        <cfset new_basket[fis_satir].fis_satir_alti_indirim = 0>
                        <cfset new_basket[fis_satir].fis_promosyon_indirim = 0>
                        <cfset new_basket[fis_satir].kazanilan_puan = 0>
                        <cfset new_basket[fis_satir].kullanilan_puan = 0>
                        <cfset new_basket[fis_satir].fis_satirlar = StructNew()>
                        <cfset new_basket[fis_satir].fis_odemeler = StructNew()>
                        <cfset urun_sayisi = 0>
                        <cfset odeme_sayisi = 0>
					<cfelseif islem_tipi is 'VF'>
                        <cfset kdv0 = val(mid(satir,26,15))>
                        <cfset kdv1 = val(mid(satir,41,15))>
                        <cfset kdv8 = val(mid(satir,56,15))>
                        <cfset kdv18 = val(mid(satir,71,15))> 
                        
                        <cfset new_basket[fis_satir].kdv0 = kdv0>
                        <cfset new_basket[fis_satir].kdv1 = kdv1>
                        <cfset new_basket[fis_satir].kdv8 = kdv8>
                        <cfset new_basket[fis_satir].kdv18 = kdv18>
                    <cfelseif islem_tipi is 'RN'>
                        <cfset rn_say = rn_say + 1>
                        <cfif mid(satir,30,2) is '12'>
							<cfset maliye_no  = mid(satir,99,10)>
                            <cfset new_basket[fis_satir].maliye_no = maliye_no>
                        </cfif>
                        <cfif rn_say eq 1>                            
                            <cfif val(mid(satir,25,1)) eq 0>
                                <cfset fis_satir_alti_indirim = val(mid(satir,32,15))>
                                <cfset new_basket[fis_satir].fis_satir_alti_indirim = new_basket[fis_satir].fis_satir_alti_indirim + fis_satir_alti_indirim>
                            </cfif>
                        </cfif>
                        <cfif val(mid(satir,27,5)) eq 2>
                            <cfset kazanilan_puan = val(mid(satir,32,15))>
                            <cfset new_basket[fis_satir].kazanilan_puan = kazanilan_puan>
                        </cfif>
                        <cfif val(mid(satir,27,5)) eq 4>
                            <cfset kullanilan_puan = val(mid(satir,32,15))>
                            <cfset new_basket[fis_satir].kullanilan_puan = kullanilan_puan>
                        </cfif>
                    <cfelseif islem_tipi is 'IN'>
                        <cfset fis_promosyon_indirim = val(mid(satir,32,15))>
                        <cfset new_basket[fis_satir].fis_promosyon_indirim = new_basket[fis_satir].fis_promosyon_indirim + fis_promosyon_indirim>
                    <cfelseif islem_tipi is 'IS'>
                        <cfset urun_sayisi = urun_sayisi + 1>
                        <cfset barcode = mid(satir,86,24)>
                        <cfset miktar = mid(satir,33,6)>
                        <cfset birim = mid(satir,39,1)>
                        <cfset kdv = mid(satir,31,2)>
                        
                        <cfif birim eq 0>
                            <cfset birim_adi = "Adet">
                        <cfelseif  birim eq 1>
                            <cfset birim_adi = "KG">
                        <cfelseif birim eq 2>
                            <cfset birim_adi = "Metre">
                        <cfelseif birim eq 3>
                            <cfset birim_adi = "Litre">
                        </cfif>
                        <cfif birim neq 0>
                            <cfset miktar = miktar / 1000>
                        </cfif>
                        
                        <cfset birim_fiyat = mid(satir,40,15)>
                        <cfset satir_toplam = mid(satir,55,15)>
                        <cfset satir_kdv_tutar = mid(satir,70,15)>
                        
                        <cfset satir_iptalmi = mid(satir,22,1)>
                        
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi] = StructNew()>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_tipi = '#islem_tipi#'>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_iptalmi = satir_iptalmi>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].barcode = barcode>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].miktar = val(miktar)>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].birim = birim>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].birim_adi = birim_adi>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].birim_fiyat = val(birim_fiyat)>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_kdv = val(kdv)>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_toplam = val(satir_toplam)>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_kdv_tutar = val(satir_kdv_tutar)>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_indirim = 0>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_promosyon_indirim = 0>
                        <cfset rn_say = 0>
                    <cfelseif islem_tipi is 'ID'>
                        <cfset satir_indirim = val(mid(satir,100,15))>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_indirim = satir_indirim>
                        
                        <cfset satir_promosyon_indirim = val(mid(satir,25,15))>
                        <cfset new_basket[fis_satir].fis_satirlar[urun_sayisi].satir_promosyon_indirim = satir_promosyon_indirim>
                    <cfelseif islem_tipi is 'PY'>
                        <cfset odeme_iptalmi = val(mid(satir,22,1))>
						<cfset odeme_turu = val(mid(satir,25,2))>
                        <cfset odeme_tutar = val(mid(satir,34,8))>
                        <cfset odeme_tutar_other = val(mid(satir,43,15))>
                        <cfset odeme_tipi = val(mid(satir,42,1))>
                        <cfset odeme_sayisi = odeme_sayisi + 1>
                        <cfset new_basket[fis_satir].fis_odemeler[odeme_sayisi] = StructNew()>
                        <cfset new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tipi = odeme_tipi>
						<cfset new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_turu = odeme_turu>
                        <cfset new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tutar = odeme_tutar>
                        <cfset new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tutar_other = odeme_tutar_other>
                        <cfset new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_iptalmi = odeme_iptalmi>
                    </cfif>
                </cfif>
        </cfloop>
       
        <cftry>
        <cfset fis_sayisi = StructCount(new_basket)>
        <cfif fis_sayisi gt 0>
            <cfloop from="1" to="#fis_sayisi#" index="fis_satir">
                <cfset toplam_hareket = StructCount(new_basket[fis_satir].fis_satirlar)> 
                <cfset toplam_odeme_hareket = StructCount(new_basket[fis_satir].fis_odemeler)> 
                
                <cfif toplam_hareket gt 0 or new_basket[fis_satir].belge_turu is 'P' or new_basket[fis_satir].belge_turu is 'L'>
                    <cfset fis_tarih = new_basket[fis_satir].fis_tarihi>
                    <cfset fis_tarih_bitis = new_basket[fis_satir].fis_tarihi_bitis>
                    
                    <cfset yil_ = mid(fis_tarih,1,4)>
                    <cfset ay_ = mid(fis_tarih,5,2)>
                    <cfset gun_ = mid(fis_tarih,7,2)>
                    <cfset saat_ = mid(fis_tarih,9,2)>
                    <cfset dakika_ = mid(fis_tarih,11,2)>
                    <cfset saniye_ = mid(fis_tarih,13,2)>
                    <cfset fis_tarih = createodbcdatetime(createdatetime(yil_,ay_,gun_,saat_,dakika_,saniye_))>
                    
                    <cfset yil_ = mid(fis_tarih_bitis,1,4)>
                    <cfset ay_ = mid(fis_tarih_bitis,5,2)>
                    <cfset gun_ = mid(fis_tarih_bitis,7,2)>
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
                            (
                            FIS_NUMARASI = #new_basket[fis_satir].fis_numarasi# 
                            OR
                            FIS_NUMARASI = '#trim(new_basket[fis_satir].fis_numarasi)#'
                            )
                            AND
                            BELGE_TURU = '#new_basket[fis_satir].belge_turu#'
                    </cfquery>
                    <cfif not get_cont_.recordcount and islem_gun_ eq gun_ and islem_ay_ eq ay_ and islem_yil_ eq yil_>
                        <cfquery name="add_fis" datasource="#dsn_dev#" result="add_fis_r">
                            INSERT INTO
                                GENIUS_ACTIONS
                                (
                                RECORD_EMP,
                                IS_OFFLINE,
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
                                ZNO,
                                BRANCH_ID,
                                DEPARTMENT_ID
                                )
                                VALUES
                                (
                                #session.ep.userid#,
                                1,
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
                                '#new_basket[fis_satir].zno#',
                                #branch_id_#,
                                #department_id_#
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
                                <cfquery name="add_fis_row" datasource="#dsn_dev#" result="add_fis_r_row">
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
                                <cfset action_row_id = add_fis_r_row.IDENTITYCOL>
                                
                                <cfif new_basket[fis_satir].fis_iptal eq 0 and len(stock_id_) and len(product_id_) and year(islem_baslama) eq year(fis_tarih) and month(islem_baslama) eq month(fis_tarih) and day(islem_baslama) eq day(fis_tarih)>
									<!--- stok hareketi yap --->
                                    <cfif new_basket[fis_satir].belge_turu eq 2>
                                        <cfset stock_in_ = new_basket[fis_satir].fis_satirlar[urun_sayisi].miktar>
                                        <cfset stock_out_ = 0>
                                        <cfset stock_islem_tipi_ = -1004>
                                        <cfif new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_IPTALMI eq 1>
                                        	<cfset stock_in_ = -1 * stock_in_>
                                        </cfif>
                                    <cfelse>
                                        <cfset stock_in_ = 0>
                                        <cfset stock_out_ = new_basket[fis_satir].fis_satirlar[urun_sayisi].miktar>
                                        <cfif new_basket[fis_satir].belge_turu eq 1>
											<cfset stock_islem_tipi_ = -1005>
                                        <cfelse>
                                        	<cfset stock_islem_tipi_ = -1003>
                                        </cfif>
                                        <cfif new_basket[fis_satir].fis_satirlar[urun_sayisi].SATIR_IPTALMI eq 1>
                                        	<cfset stock_out_ = -1 * stock_out_>
                                        </cfif>
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
                                                WRK_ROW_ID,
                                                RELATED_ROW_ID
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
                                                '#action_row_id#-#new_basket[fis_satir].sube_kodu#-#new_basket[fis_satir].kasa_numarasi#-#trim(new_basket[fis_satir].kasiyer_no)#-#action_id#-#new_basket[fis_satir].fis_numarasi#-#dateformat(fis_tarih,"ddmmyyyy")#',
                                                #action_row_id#
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
                                        ODEME_TUTAR_OTHER,
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
                                        <cfif new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tipi eq 1 or new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_iptalmi eq 1>
                                            #-1 * new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tutar_other#,
                                        <cfelse>
                                            #new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tutar_other#,
                                        </cfif>
                                        #new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_tipi#,
                                        #new_basket[fis_satir].fis_odemeler[odeme_sayisi].odeme_iptalmi#
                                        )
                                </cfquery>
                            </cfloop>
                            
                            <cfif new_basket[fis_satir].belge_turu is 'P' or new_basket[fis_satir].belge_turu is 'L'>
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
                                        26,
                                        #new_basket[fis_satir].fis_toplam#,
                                        0,
                                        0
                                        )
                                </cfquery>
                            </cfif>
                    </cfif>
                </cfif>
            </cfloop>
        </cfif>
        <cfcatch type="any">
                Kasa Numarası : <cfoutput>#EQUIPMENT_CODE#</cfoutput>
                Aşağıda Fiş Detay Verilen İşlem Hatalı!<br /><br />
                <script>
                    alert('<cfoutput> Aşağıda Fiş Detay Verilen İşlem Hatalı!\n #new_basket[fis_satir]# \n #cfcatch.message#</cfoutput>');
                </script>
                <cfdump var="#new_basket[fis_satir]#">
                <cfdump var="#cfcatch#">
                <HR />
        </cfcatch>
        </cftry>
    <cfelse>
            <script>
                alert('Dosya bulunamadı');
            </script>
            <table>
                <tr>
                    <td colspan="2" class="header">	
                    <br/>
                    Workcube Sistemi Kasa Aktarımı Yaparken Dosya Bulamadı.
                    </td>
                </tr><br/><br>
                <tr>
                    <td class="bold">Kasa : </td>
                    <td class="unbold">#EQUIPMENT#</td>
                </tr>
                <tr>
                    <td class="bold">Dosya : </td>
                    <td class="unbold">#OFFLINE_PATH#\#FILENAME#</td>
                </tr>
                <tr>
                    <td class="bold">İşlem Zamanı : </td>
                    <td class="unbold">#dateformat(islem_baslama,'dd/mm/yyyy')# (#timeformat(islem_baslama,'HH:MM')#)</td>
                </tr>
            </table>
    </cfif><!--- dosya var mı --->
    </cfoutput>
    </cfif><!--- KASALAR DONER --->
<HR /><br />
<script>
    alert('Aktarım İşlemi Tamamlandı!');
</script>
