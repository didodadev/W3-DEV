<cf_xml_page_edit fuseact="objects.popup_form_export_stock">
<cfsetting requesttimeout="3600">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_all" default="0">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

<cfif not len(attributes.department_id)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='30126.Şube Seçiniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_dept" datasource="#dsn#">
	SELECT 
    	D.DEPARTMENT_HEAD,
        BEF.LOCAL_FOLDER
    FROM 
    	DEPARTMENT D,
        #dsn_dev_alias#.BRANCH_EXTRA_INFO BEF
    WHERE 
    	D.BRANCH_ID = BEF.BRANCH_ID AND
        D.DEPARTMENT_ID = #attributes.department_id#
</cfquery>

<cfif not DirectoryExists("#upload_folder#store#dir_seperator##attributes.department_id#")>
	<cfdirectory action="create" directory="#upload_folder#store#dir_seperator##attributes.department_id#">
</cfif>

<cfif isdate(attributes.product_startdate)><cf_date tarih='attributes.product_startdate'></cfif>
<cfif isdate(attributes.product_finishdate)><cf_date tarih='attributes.product_finishdate'></cfif>


<cfset upload_folder = "#upload_folder#store#dir_seperator##attributes.department_id##dir_seperator#">

<cfif FileExists("#upload_folder#GNCPLUF.GTF")>
	<cffile action="delete" file="#upload_folder#GNCPLUF.GTF">
</cfif>
<cfif FileExists("#upload_folder#GNDPROMO.GTF")>
	<cffile action="delete" file="#upload_folder#GNDPROMO.GTF">
</cfif>
<cfif FileExists("#upload_folder#GNDREY.GTF")>
	<cftry><cffile action="delete" file="#upload_folder#GNDREY.GTF"><cfcatch type="any"></cfcatch></cftry>
</cfif>
<cfif FileExists("#upload_folder#GNSTAFF.GTF")>
	<cffile action="delete" file="#upload_folder#GNSTAFF.GTF">
</cfif>
<cfif FileExists("#upload_folder#sube_terazi_dosyasi.GTF")>
	<cffile action="delete" file="#upload_folder#sube_terazi_dosyasi.GTF">
</cfif>

<cfif FileExists("#upload_folder#output.txt")>
	<cftry><cffile action="delete" file="#upload_folder#output.txt"><cfcatch type="any"></cfcatch></cftry>
</cfif>
<cfif FileExists("#upload_folder#output_sil.txt")>
	<cftry><cffile action="delete" file="#upload_folder#output_sil.txt"><cfcatch type="any"></cfcatch></cftry>
</cfif>

<cfset CRLF=chr(13)&chr(10)>




<!--- Urunler Alinir --->
<cfinclude template="get_stocks2.cfm">


<!--- marketlere ozel tum dosyalar bir arada oluşturulmalı --->
<cfinclude template="export_genius_pay_methods.cfm">
<cfinclude template="export_genius_reyon.cfm">
<cfinclude template="export_promotion.cfm">
<cfinclude template="export_pos_users.cfm">
<cfinclude template="popup_export_terazi.cfm">
<!--- marketlere ozel tum dosyalar bir arada oluşturulmalı --->


<cfif not get_stocks.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='34053.Girdiğiniz Koşullara Uygun Kayıt Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfset my_date = date_add('h',session.ep.time_zone,now())>
	<cfset my_date = CreateODBCDateTime(CreateDate(year(my_date),month(my_date),day(my_date)))>
	<cfset real_finish_date = dateadd("d",-1,my_date)>
	<cfset simdi_tarih = date_add('h',session.ep.time_zone,my_date)>
	<cfif attributes.target_pos is "-1"><!--- 20050527 sadece genius promosyonlarını aliyoruz simdilik --->
		<cfquery name="GET_ALL_PROMS" datasource="#DSN3#">
			SELECT 
				DISCOUNT,
				AMOUNT_DISCOUNT,
				BRAND_ID,
				STOCK_ID,
				PRICE_CATID,
				PRODUCT_CATID,			
				RECORD_DATE
			FROM
				PROMOTIONS 
			WHERE
				STARTDATE <= #DATEADD('h',session.ep.time_zone,my_date)# AND
				FINISHDATE >= #DATEADD('h',session.ep.time_zone,DATEADD('d',1,my_date))#
		</cfquery>
	</cfif>
    
    <cfquery name="get_all_prices" datasource="#dsn_dev#">
    	SELECT 
        	*
        FROM 
        	PRICE_TABLE 
        WHERE 
        	STARTDATE <= #my_date# AND 
            FINISHDATE >= #my_date# AND 
            IS_ACTIVE_S = 1 
    </cfquery>
	<cfscript>	
	file_name = "GNCPLUF.GTF";

	// satır atlama karakteri
	CRLF=chr(13)&chr(10);

	file_content = ArrayNew(1);
	file_content_file2 = ArrayNew(1); 	// barcode.idx icin olusturuldu.yo27052005
	file_content_file3 = ArrayNew(1); 	// pluno.idx icin olusturuldu.yo27052005

	file_content2 = ArrayNew(1);
	index_array2 = 1;

	aktif_satir = 1; 					//pluno.idx ve barcode.idx de aktif satiri dosyaya yazabilmek icin eklendi.yo27052005
	index_array_pluno = 1; 				//pluno.idx dosyasinda stock_id tekrarini onlemek amacli eklendi.yo27052005
	
	index_array = 1;
	urun_say = 0;
	last_stock_id = ""; 					//pluno.idx dosyasinda stock_id tekrarini onlemek amacli eklendi.yo27052005
	last_product_id=""; 					// workcube dosya formatında bir ust satirdaki urunle aynimi yani cesitmi kontrolu icin
	</cfscript>

	<!--- ilk once dosya eklenir sonra asagida ici doldurulur --->
	<cffile action="write" output="<SIGNATURE=GNDPLU.GDF><VERSION=0222000>" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
	
	
	<!--- Loop ile file oluşturulur --->
	<cfset group_id="STOCK_ID">
    
	<cfif attributes.target_pos is "-4">
    	<cfinclude template="workcube_export_stock.cfm">
	<cfelse>
		<cfoutput query="get_stocks" group="#group_id#">	
            <cfif attributes.target_pos is "-1"><!--- Genius --->
                <cfif isdefined("attributes.is_pricecat_control") and (attributes.is_pricecat_control eq 1)>
                    <cfquery name="GET_PROM" dbtype="query" maxrows="1">
                        SELECT
                            DISCOUNT,
                            AMOUNT_DISCOUNT,
                            RECORD_DATE
                        FROM
                            GET_ALL_PROMS
                        WHERE
                        <cfif (attributes.price_catid gt 0) and len(get_stocks.price_catid)>
                            (STOCK_ID = #get_stocks.stock_id# AND PRICE_CATID = #get_stocks.price_catid#)
                        <cfelse>
                            (STOCK_ID = #get_stocks.stock_id# AND PRICE_CATID = -2)
                        </cfif>
                        <cfif len(get_stocks.brand_id)>
                            OR BRAND_ID = #get_stocks.brand_id#
                        </cfif>
                        <cfif len(get_stocks.product_catid)>
                            OR PRODUCT_CATID = #get_stocks.product_catid#
                        </cfif>
                        ORDER BY
                            RECORD_DATE DESC
                    </cfquery>
                <cfelse>
                    <cfset get_prom.recordcount = 0>
                </cfif>
                <cfscript>
				// xml_stock_detail2 Stok Karti Aciklamasi degeri ürün detayındaki Açıklama2 değerini kullanılsın mı?
				if(xml_stock_detail2 eq 0)
				{
					if(len(property))
						product_name_ = "#product_name#";
					else
						product_name_ = product_name;
				}
				else
					product_name_ = product_detail2;
				
					
                
                // 1. SATIR (Stok Bilgileri)
                prom_yuzde = "";
                prom_tutar_ind = "";
                fiyat_istenen_fiyat = 0; 				// istenen fiyat listesinde yoksa ürünü alma
                temp_stock_unit_id = product_unit_id;	// asagida barkod output icin gerekli
                
				if(attributes.price_catid eq -3)
				{
					dbtype_ = 'query';
					datasource_ = '#dsn_dev#';
					//main_sql_text = 'SELECT NEW_PRICE_KDV FROM get_all_prices WHERE STOCK_ID = #get_stocks.stock_id# ORDER BY STARTDATE DESC';
					main_sql_text = 'SELECT
										NEW_PRICE_KDV
									FROM
										get_all_prices
									WHERE
										PRODUCT_ID = 0 AND
										(STARTDATE <= #my_date# AND FINISHDATE > #my_date#) AND
										IS_ACTIVE_S = 1 AND										
										PRODUCT_ID = #product_id#
									ORDER BY
                						STARTDATE';
					price_query = cfquery(SQLString:main_sql_text,dbtype:dbtype_,datasource:datasource_,is_select:1);
					
					//abort(price_query.NEW_PRICE_KDV[1] & ' ---- ' & main_sql_text);	
				}
				
				if (attributes.price_catid eq -3 and price_query.recordcount)		// fiyat listesi isteniyor
                {
				    fiyat_istenen_fiyat = 1;
                    stock_unit = add_unit;
					
					std_satis = price_query.NEW_PRICE_KDV[1];
                }
                else
                {
					// standart satis isteniyor
                    fiyat_istenen_fiyat = 1;
                    stock_unit = add_unit;
                    //if(is_kdv)
                    if(PRICE_KDV_DEPT neq -1)
						std_satis = wrk_round(PRICE_KDV_DEPT,2);
					else
						std_satis = price_kdv;
                    //else
                        //std_satis = wrk_round((price*(100+tax)) / 100);
                }
                if(fiyat_istenen_fiyat and listlen(product_code,'.') gt 3) //listlen(product_code,'.') gt 3
                {
					// Promosyondan gelen yüzde veya tutar indirimi (Fiyattan gelse bile üzerine yazar)
                    if (get_prom.recordcount and len(get_prom.discount))
                    {
                        prom_yuzde = get_prom.discount;
                        prom_tutar_ind = '';
                    }
                    else if(get_prom.recordcount and len(get_prom.amount_discount) and (get_prom.amount_discount lte std_satis))
                        prom_tutar_ind = wrk_round(get_prom.amount_discount);
 
                   	satir1 = "01" & repeatString(" ",846);	
                	satir2 = "02" & repeatString(" ",200);
					
					satir1 = yerles(satir1,0,5,1,""); //islem turu yeni kayit
                    //satir1 = yerles(satir1, left("#product_id#.#stock_id#", 24), 6, 24, " ");	// stok kodu
                    //satir1 = yerles(satir1, left("#product_id#.#stock_id#", 24), 30, 24, " ");	// eski stok kodu
					satir1 = yerles(satir1, left("#stock_id#", 24), 6, 24, " ");	// stok kodu
                   satir1 = yerles(satir1, left("#stock_id#", 24), 30, 24, " ");	// eski stok kodu 
					
					if(len(BRAND_NAME)) 
						ozel_ad_ = replace(property,BRAND_NAME,'','all');
					else
						ozel_ad_ = property;
						
					if(len(trim(ozel_ad_)) eq 0)
					{
						if(len(BRAND_NAME)) 
							ozel_ad_ = replace(product_name,BRAND_NAME,'','all');
						else
							ozel_ad_ = product_name;	
					}
						
				  ozel_ad_ = ReplaceList(ozel_ad_, "Ü,Ğ,İ,Ş,Ç,Ö,ü,ğ,ı,ş,ç,ö", "U,G,I,S,C,O,u,g,i,s,c,o"); 
					ozel_ad_ = replace(ozel_ad_,'@','','all');
					ozel_ad_ = replace(ozel_ad_,"*","","all");
					ozel_ad_ = replace(ozel_ad_,"##","","all");
					ozel_ad_ = replace(ozel_ad_,'"','',"all");
					ozel_ad_ = replace(ozel_ad_,'$','',"all");
					ozel_ad_ = replace(ozel_ad_,'£','',"all");
					ozel_ad_ = replace(ozel_ad_,'_','',"all");
					ozel_ad_ = replace(ozel_ad_,"'","","all"); 
				
					ozel_ad_ = trim(ozel_ad_);
						
					sayi_ = 39 - len(BRAND_NAME);
					if(sayi_ gt 0)
						ozel_ad_uzun_ = trim(left(ozel_ad_,sayi_));
					ozel_ad_uzun_ = BRAND_NAME & ' ' & ozel_ad_uzun_;
					
					sayi_ = 19 - len(BRAND_NAME);
					if(sayi_ gt 0)
						ozel_ad_kisa_ = trim(left(ozel_ad_,sayi_));
					ozel_ad_kisa_ = BRAND_NAME & ' ' & ozel_ad_kisa_;

					ozel_ad_kisa_ = BRAND_NAME & ' ' & ozel_ad_kisa_;
					
					ozel_ad_kisa_ = trim(ozel_ad_kisa_);
					ozel_ad_uzun_ = trim(ozel_ad_uzun_);
					
					
					satir1 = yerles(satir1, left(ozel_ad_uzun_, 40), 54, 40, " ");				// stok karti aciklamasi
                    satir1 = yerles(satir1, left(ozel_ad_uzun_, 40), 94, 40, " ");				// ekstra stok karti aciklamasi
					
					satir1 = yerles(satir1, left(ozel_ad_kisa_, 20), 134, 20, " ");				// pos ekranı aciklamasi
                    satir1 = yerles(satir1, left(ozel_ad_kisa_, 20), 154, 20, " ");				// raf etiketi aciklamasi
                    satir1 = yerles(satir1, left(ozel_ad_kisa_, 16), 174, 16, " ");				// terazi etiketi aciklamasi
					
					/*
					if (Listlen(product_code,".") gte 2) 
						satir1 = yerles(satir1, ListGetAt(product_code,1,"."), 190, 8, " ");	// Departman ERSAN icin urun kategorisinin ilk noktadan onceki bolumu  
					else																		// Or:001.002.003 kodlu kategori icin 001 
						satir1 = yerles(satir1,0, 190, 8, " ");
					*/
					satir1 = yerles(satir1,"1", 190,8," ");
													
					reyon1 = ListGetAt(product_code,1,".");
					reyon2 = ListGetAt(product_code,2,".");
					reyon3 = ListGetAt(product_code,3,".");
					satir1 = yerles(satir1,left(reyon1,8),198,8," ");			// Reyon
						
					if(len(P_PRODUCT_TYPE_DEPT) and P_PRODUCT_TYPE_DEPT eq 1)
						satir1 = yerles(satir1,P_PRODUCT_TYPE_DEPT,206,8," ");		// Urun Tipi
					else if(len(P_PRODUCT_TYPE_DEPT) and P_PRODUCT_TYPE_DEPT eq 0)
						satir1 = yerles(satir1,'55',206,8," ");
					else if(len(P_PRODUCT_TYPE) and P_PRODUCT_TYPE eq 1)
						satir1 = yerles(satir1,P_PRODUCT_TYPE,206,8," ");			// Urun Tipi
					else if(len(P_PRODUCT_TYPE) and P_PRODUCT_TYPE eq 0)
						satir1 = yerles(satir1,'55',206,8," ");
					else if(len(G_PRODUCT_TYPE) and isnumeric(G_PRODUCT_TYPE))
						satir1 = yerles(satir1,G_PRODUCT_TYPE,206,8," ");			// Urun Tipi
					else
						satir1 = yerles(satir1,1,206,8," ");						// Urun Tipi
					
					 
                    if(len(prom_yuzde))
                    {
                        satir1 = yerles(satir1, attributes.indirim_grubu, 214, 8, " ");			// indirim grubu
                        satir1 = yerles(satir1,0, 222, 1, " ");								// indirip tipi (grup)
                        satir1 = yerles(satir1, prom_yuzde, 223, 15, " ");						// indirim yuzdesi
                    }
                    else if(len(prom_tutar_ind))
                    {
                        satir1 = yerles(satir1, attributes.indirim_grubu, 214, 8, " ");								// indirim grubu
						satir1 = yerles(satir1,0,222,1," ");													// indirim tipi - indirim yok(promosyon modülü-Kiler kart için doğru)
                        if(not isdefined("std2_satis"))
							satir1 = yerles(satir1, replace(left(prom_tutar_ind ,15),".",","), 238, 15, " ");			// tutar indirimi
						else
							satir1 = yerles(satir1, replace(left(0 ,15),".",","), 238, 15, " ");			// tutar indirimi
                    }
					else
					{
						satir1 = yerles(satir1," ", 214, 8, " ");			// indirim grubu
                        satir1 = yerles(satir1,0, 222, 1, " ");								// indirip tipi (grup)
                        satir1 = yerles(satir1,0, 223, 15, " ");						// indirim yuzdesi
						satir1 = yerles(satir1,0, 238, 15, " ");	
					}
					
					satir1 = yerles(satir1," ", 253, 6, " ");
					satir1 = yerles(satir1," ", 259,24, " ");
					
					if(stock_unit is 'M')
						stock_unit = 'metre';
					
					unit_id_ = listfindnocase("Adet,kg,metre,litre",stock_unit);
                    unit_id_ = iif(unit_id_ gt 0, unit_id_-1, 6);
                    
                    satir1 = yerles(satir1,unit_id_, 283, 1, " ");						// birim id {Genius Karşılığı}

					//Birimdeki paket carpan sayisi icin eklendi. sadece Paket,koli,kutu icin kasaya adet gibi gidecek BK 20090403
					if(x_genius_box_price eq 1 and listfindnocase("Paket,Koli,Kutu", stock_unit))
						unit_id_ = 0;
					
					if (unit_id_ eq 1)
                        satir1 = yerles(satir1, "1000", 284, 15, " ");				// kg ise bölen 1000 olacak 
					else if (unit_id_ eq 2)
                        satir1 = yerles(satir1, "1000", 284, 15, " ");				// m ise bölen 1000 olacak k
					else if (unit_id_ eq 3)
                        satir1 = yerles(satir1, "1000", 284, 15, " ");				// lt ise bölen 1000 olacak k
                    else
                        satir1 = yerles(satir1, 1, 284, 15, " ");					// birim boleni  {simdilik 1}
						
					if(x_genius_box_price eq 0 and not listfindnocase("Paket,Koli,Kutu", stock_unit))				
						satir1 = yerles(satir1, multiplier, 299, 15, " ");			// birim carpani birimdeki carpan ifadesi 
					else
						satir1 = yerles(satir1, '1', 299, 15, " ");					// birim carpani default 1 verilir
						
					satir1 = yerles(satir1, ' ', 314,8, " ");
					satir1 = yerles(satir1, ' ', 322,8, " ");
					
					satir1 = yerles(satir1,0, 330,12, " ");
					satir1 = yerles(satir1,0, 342,12, " ");
					
					satir1 = yerles(satir1, '0', 354,1,"");
					satir1 = yerles(satir1, '0', 355,1,"");
					
					if(x_genius_box_price eq 0 and not listfindnocase("Paket,Koli,Kutu", stock_unit))
	                    satir1 = yerles_saga(satir1, replace(left(std_satis ,15),".",","), 356, 15, " ");					// satis fiyatı adet ve kg birimleri icin yukardaki fiyat alinir
					else
					{
						temp_std_satis = std_satis / multiplier;
						satir1 = yerles_saga(satir1, replace(left(temp_std_satis ,15),".",","), 356, 15, " ");               // satis fiyatı paket,koli,kutu birimleri icin carpan degeri kullanilarak bulunan fiyat alinir BK 20080415
					}
					
					/*
					if(len(prom_tutar_ind))
						std2_satis = std_satis - prom_tutar_ind;
					else
						std2_satis = std_satis;
						satir1 = yerles(satir1, replace(left(std2_satis ,15),".",","), 371, 15, " ");					//Satis fiyati2 alani, indirimli tutari gosterir
					*/
					satir1 = yerles_saga(satir1,tlformat(0), 371, 15, " ");
					satir1 = yerles_saga(satir1,tlformat(0), 386, 15, " ");
					satir1 = yerles_saga(satir1,tlformat(0), 401, 15, " ");
					
					satir1 = yerles(satir1,0, 416, 15, " ");
					satir1 = yerles(satir1,0, 431, 15, " ");
					satir1 = yerles(satir1,0, 446, 15, " ");
					satir1 = yerles(satir1,0, 461, 15, " ");
					satir1 = yerles(satir1,0, 476, 15, " ");
					satir1 = yerles(satir1,0, 491, 15, " ");
					
					satir1 = yerles(satir1,0, 506,2, " ");
					satir1 = yerles(satir1,0, 508,2, " ");
					satir1 = yerles(satir1,0, 510,2, " ");
					satir1 = yerles(satir1,0, 512,2, " ");
					satir1 = yerles(satir1,0, 514,2, " ");
					satir1 = yerles(satir1,0, 516,2, " ");
					satir1 = yerles(satir1,0, 518,2, " ");
					satir1 = yerles(satir1,0, 520,2, " ");
					satir1 = yerles(satir1,0, 522,2, " ");
					satir1 = yerles(satir1,0, 524,2, " ");
					
					satir1 = yerles(satir1,"1023", 526,6, " ");
                    
                    // KDV ler
                    if(tax eq 0)
						kdv_ = 0;
					if(tax eq 1)
						kdv_ = 1;
					if(tax eq 8)
						kdv_ = 2;
					if(tax eq 18)
						kdv_ = 3;
					
					
					satir1 = yerles(satir1,kdv_, 532, 3, " ");					// satis kdv grubu
                    
					
					satir1 = yerles(satir1,"3", 535, 3, " ");						// alis kdv grubu default 0
                    satir1 = yerles(satir1, 0, 538, 1, " ");						// Kdv grubu {simdilik 0-kendi kdv si}
                    // digerleri
                    satir1 = yerles(satir1, 0, 539, 15, " ");						// izin verilen minimum satis {simdilik 0-kontrol etme}
                    satir1 = yerles(satir1, 0, 554, 15, " ");						// izin verilen maximum satis {simdilik 0-kontrol etme}
					
					satir1 = yerles(satir1, 0, 569, 3, " ");
					satir1 = yerles(satir1, 0, 572, 15, " ");
					
					
					if(IS_SALES eq 1 and STOCK_IS_SALES eq 1)
                    	satir1 = yerles(satir1, 0, 587, 1, " ");						// satıs durumu {0:satilabilir}
					else
						satir1 = yerles(satir1, 1, 587, 1, " ");						// satıs durumu {1:satilamaz}
						
					satir1 = yerles(satir1, 0, 588, 1, " ");
					satir1 = yerles(satir1, 0, 589, 1, " ");
					satir1 = yerles(satir1, 0, 590, 1, " ");
					satir1 = yerles(satir1, 0, 591, 1, " ");
					satir1 = yerles(satir1, 0, 592, 1, " ");
                    satir1 = yerles(satir1, 2, 593, 1, " ");						// indirim durumu {2:yapilabilir}
					satir1 = yerles(satir1, 1, 594, 1, " ");
					satir1 = yerles(satir1," ", 595,20, " ");
					
					satir1 = yerles(satir1, 0, 615, 6, " ");
					satir1 = yerles(satir1, 0, 621, 15, " ");
					satir1 = yerles(satir1, 0, 636, 6, " ");
					satir1 = yerles(satir1, 0, 642, 15, " ");
					satir1 = yerles(satir1, 0, 657, 15, " ");
					satir1 = yerles(satir1, 0, 672, 15, " ");
					
					
                    satir1 = yerles(satir1, iif(is_terazi, 1, 0), 687, 1, " "); 	// teraziye gider ?

					// SC083 Promosyonda kullanilacak Katsayı 1 alanı Burda ve Ersan icin urundeki ozel kod var sa 1 yoksa 0 yazıldı 
					/*
					if (len(product_code_2) and isnumeric(product_code_2))
						if(xml_coefficient eq 0)
							satir1 = yerles(satir1,1, 688, 15, " ");					
						else
							satir1 = yerles(satir1,product_code_2, 688, 15, " ");					
					else
						satir1 = yerles(satir1,0, 688, 15, " ");
					*/
					
					if(URETICI_SUB_TYPE neq 0)
						satir1 = yerles(satir1,tlformat(URETICI_SUB_TYPE/100), 688, 15, " ");//uretici
					else
						satir1 = yerles(satir1,URETICI_SUB_TYPE, 688, 15, " ");//uretici
                    
					if(AMBALAJ_SUB_TYPE neq 0)
						satir1 = yerles(satir1,tlformat(AMBALAJ_SUB_TYPE/100), 703, 15, " ");//ambalaj
					else
						satir1 = yerles(satir1,AMBALAJ_SUB_TYPE, 703, 15, " ");//ambalaj
						
					if(MARKA_SUB_TYPE neq 0)
						satir1 = yerles(satir1,tlformat(MARKA_SUB_TYPE/100), 718, 15, " ");//marka
					else
						satir1 = yerles(satir1,MARKA_SUB_TYPE, 718, 15, " ");//marka
						
					if(MARKET_PROMOSYON_SUB_TYPE neq 0)
						satir1 = yerles(satir1,tlformat(MARKET_PROMOSYON_SUB_TYPE/100), 733, 15, " ");//market promosyon
					else
						satir1 = yerles(satir1,MARKET_PROMOSYON_SUB_TYPE, 733, 15, " ");//market promosyon
					
					if(PROMOSYON_SUB_TYPE neq 0)
						satir1 = yerles(satir1,tlformat(PROMOSYON_SUB_TYPE/100), 748, 15, " ");//promosyon
					else
						satir1 = yerles(satir1,PROMOSYON_SUB_TYPE, 748, 15, " ");//promosyon
                    
					if(MUADIL_SUB_TYPE neq 0)
						satir1 = yerles(satir1,tlformat(MUADIL_SUB_TYPE/100), 763, 15, " ");//muadil
					else
						satir1 = yerles(satir1,MUADIL_SUB_TYPE, 763, 15, " ");//muadil
						
					if(SEKTOR_SUB_TYPE neq 0)
						satir1 = yerles(satir1,tlformat(SEKTOR_SUB_TYPE/100), 778, 15, " ");//sektor
					else
						satir1 = yerles(satir1,SEKTOR_SUB_TYPE, 778, 15, " ");//sektor
						
					if(BUYUKLUK_SUB_TYPE neq 0)
						satir1 = yerles(satir1,tlformat(BUYUKLUK_SUB_TYPE/100), 793, 15, " ");//buyukluk
					else
						satir1 = yerles(satir1,BUYUKLUK_SUB_TYPE, 793, 15, " ");//buyukluk
					
					satir1 = yerles(satir1,0, 808, 15, " ");
					
					t=0;															// uretim bilgisi
                    if (isdefined("get_stocks.is_worker") and get_stocks.is_worker eq 1) t=4;								// calısan icin 4
                    if (isdefined("get_stocks.is_retired") and get_stocks.is_retired eq 1) t=t+2;							// emekli icin 2
                    satir1 = yerles(satir1,t, 823,6, " ");			// emekli ve calısanin toplami

					satir1 = yerles(satir1," ",829,15, " ");
                    
					satir1 = yerles(satir1," ",844,5, " ");															// kdv dahil her zaman erk 20040410
                    // fiyatlar yerleşir bitti
                    
                    row_count = 0;
                    if (unit_id_ neq 6) //(unit_id_ neq 6) BU KOŞUL NİYE YAZILMIŞ BİLMİYORUM
                    {
						urun_say = urun_say + 1;
                        file_content[index_array] = "#satir1#";
                        index_array = index_array+1;
                    }
                    else
                    {
                        file_content2[index_array2] = "#left(satir1,50)# (Genius Birim Sorunu)";
                        index_array2 = index_array2+1;
                    }
                }
                temp_barkod = '';
                </cfscript>
                <cfif (fiyat_istenen_fiyat and listlen(product_code,'.') gt 3)>
                    <cfoutput>
                    <cfscript>
	                // 2. SATIR (Barkod Bilgileri)
                    // yukarıda ürün gelir burada çalıştırılacak fonk ile de
                    // bizim her stock_id miz icin genius ta 99 barkod olabilir 20050305
                    is_barkod_price_flag = true;
                    
					/*
					if(temp_stock_unit_id neq product_unit_id and attributes.price_catid eq -3)
					{
						main_table_datasource = '#dsn_dev#';
						main_sql_text = 'SELECT TOP 1 NEW_PRICE_KDV FROM PRICE_TABLE WHERE STARTDATE <= #NOW()# AND FINISHDATE >= #NOW()# AND STOCK_ID = #get_stocks.stock_id# AND IS_ACTIVE_S = 1 ORDER BY NEW_PRICE_KDV ASC';
						price_query = cfquery(SQLString:main_sql_text,Datasource:main_table_datasource,is_select:1);	
					}
					*/
					
					//std_satis = price_query.NEW_PRICE_KDV;
					
					
                    if(is_barkod_price_flag and row_count lte 98)
                    {
                        row_count = row_count + 1;
                        satir2 = yerles(satir2, 0, 5, 1, " ");										// islem turu default 0
                        //satir2 = yerles(satir2, left("#product_id#.#stock_id#",24), 6, 24, " ");	// iliskili stok kodr
						satir2 = yerles(satir2, left("#stock_id#",24), 6, 24, " ");	// iliskili stok kodr
                        satir2 = yerles(satir2, barcod, 30, 24, " ");								// b
                        satir2 = yerles(satir2, barcod, 54, 24, " ");								// eski barkodarkod

                        // BK 20090415 eski hali satir2 = yerles(satir2, 1, 78, 24, " ");			// birim miktar simdilik 1

						//Birimdeki paket carpan sayisi icin eklendi. sadece Paket,koli,kutu icin BK 20090403
						if(x_genius_box_price eq 0 and not listfindnocase("Paket,koli,kutu", stock_unit))
							satir2 = yerles(satir2, 1, 78, 24, " ");								// Birim miktar simdilik 1
						else
							satir2 = yerles(satir2, multiplier, 78, 24, " ");						// Birim miktar carpan olarak geliyor

                        satir2 = yerles(satir2, 0, 84, 1, " ");										// default 0 bilinmiyor
                        satir2 = yerles(satir2, 0, 85, 1, " ");										// fiyat bilgilerinden hangisi ise default 0
                        satir2 = yerles(satir2, row_count-1, 86, 2, " ");								// sira numarasi
                        //satir2 = yerles(satir2, replace(left(std_satis ,15),".",","), 88, 15, " ");	// barkod fiyatı
						satir2 = yerles(satir2," ", 88, 15, " ");	// barkod fiyatı
                        if (unit_id_ neq 6)
                        {
                            file_content[index_array] = "#satir2#";
                            index_array = index_array+1;
                            //detayli bakmak icin acınız performans adına kapatıldı BK 20080724 writeoutput("<font size=2>#get_stocks.currentrow#:#product_name_#,#BARCOD#</font><br/>");
                        }
                        else
						{
							file_content2[index_array2] = "#left(satir2,50)# (Genius Birim Sorunu)";
							index_array2 = index_array2+1;
						}
                    }
                    else
                    {
                        file_content2[index_array2] = "#product_name_# (#product_id#.#stock_id#) icin fazla barkod veya barkoda ait birime uygun fiyat bulunamadi. Alınamayan barkod:#barcod#";
                        index_array2 = index_array2+1;
                    }
                    </cfscript>
                    </cfoutput>
                </cfif>
            </cfif>
            <cfif (get_stocks.currentrow mod 1000) eq 0>
                <!--- daha once yukarida eklenmis dosyanin icerigi doluyor --->
                <cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#upload_folder##file_name#" charset="ISO-8859-9">
                <cfset file_content = ArrayNew(1)>
                <cfset index_array = 1>
                <cfset index_array_pluno = 1>
            </cfif>
        </cfoutput>
    
        <cfif (get_stocks.recordcount mod 1000) eq 0>
            <cfset yeni_satir = 0>
        <cfelse>
            <cfset yeni_satir = 1>
        </cfif>
    	
        <cffile action="append" output="#ArraytoList(file_content,CRLF)#" addnewline="#yeni_satir#" file="#upload_folder##file_name#" charset="ISO-8859-9"><!--- FBS ISO-8859-9 --->
        <cfset file_content = ''>
        <hr>
		<!--- eger hatali urun kodu ve birimi varsa --->
		<cfif ArrayLen(file_content2) neq 0>
			<cfif attributes.target_pos is "-1">
			  <!--- Genius icin --->
				<strong>Genius Uyumsuz Kayıtlar : </strong><br/>
			</cfif>
			<font size=2 color=red>
			<cfoutput>#ArraytoList(file_content2, "<br/>")#</cfoutput> 
			</font>
			<hr>
		</cfif>
		
		<div id="urun_sonuc" style="display:none;"><cfoutput>&nbsp; <br/>#urun_say# Adet Ürün Dosyaya Eklendi.<br/></cfoutput></div>
    </cfif>
	
	<!--- Dosya Loglanır --->
	<cfquery name="ADD_FILE" datasource="#DSN2#">
		INSERT INTO
			FILE_EXPORTS
		(
			TARGET_SYSTEM,
			PROCESS_TYPE,
			PRODUCT_COUNT,
			FILE_NAME,
			FILE_SERVER_ID,
			DEPARTMENT_ID,
			PRODUCT_RECORD_DATE,
			PRICE_RECORD_DATE,
			IS_PHL,
			<!---FILE_STAGE,--->
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
		<cfif attributes.target_pos eq -4 and len(attributes.destination_company_id) and len(attributes.destination_company_name)>
			,DESTINATION_COMPANY_ID
		</cfif>
		)
		VALUES
		(
			#target_pos#,
			-1,
			#urun_say#, <!--- #get_stocks.recordcount#, --->
			'#FILE_NAME#',
			#fusebox.server_machine#,
		<cfif len(attributes.department_id)>#listfirst(attributes.department_id,"-")#<cfelse>NULL</cfif>,
		<cfif isdate(attributes.product_startdate)>#attributes.product_startdate#<cfelse>NULL</cfif>,
		<cfif isdate(attributes.product_finishdate)>#attributes.product_finishdate#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_phl")>1<cfelse>0</cfif>,
			<!---#attributes.process_stage#,--->
			#now()#,
			'#cgi.remote_addr#',
			#session.ep.userid#
		<cfif attributes.target_pos eq -4 and len(attributes.destination_company_id) and len(attributes.destination_company_name)>
			,#attributes.destination_company_id#
		</cfif>
		)
	</cfquery>
	<cfquery name="GET_MAX_FILE_EXPORT" datasource="#DSN2#">
		SELECT MAX(E_ID) AS E_ID FROM #dsn2_alias#.FILE_EXPORTS
	</cfquery>
	
	<!---<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#'
		action_table='FILE_EXPORTS'
		action_column='E_ID'
		action_id='#get_max_file_export.e_id#'
		action_page='#request.self#?fuseaction=pos.list_stock_export'
		warning_description = 'File Export Süreci'> --->
 
 
<cfset icerik_ = "copy #upload_folder#GNCPLUF.GTF #get_dept.LOCAL_FOLDER##CRLF#">

<cfif get_reyons.recordcount>
	<cfset icerik_ = "#icerik_#copy #upload_folder#GNDREY.GTF #get_dept.LOCAL_FOLDER##CRLF#">
</cfif>
<cfif get_pos_users.recordcount>
	<cfset icerik_ = "#icerik_#copy #upload_folder#GNSTAFF.GTF #get_dept.LOCAL_FOLDER##CRLF#">
</cfif>
<cfif get_products.recordcount>
	<cfset icerik_ = "#icerik_#copy #upload_folder#sube_terazi_dosyasi.dat #get_dept.LOCAL_FOLDER##CRLF#">
</cfif>
<cfset icerik_ = "#icerik_#copy #upload_folder#GNDPROMO.GTF #get_dept.LOCAL_FOLDER##CRLF#">
<cfif get_types.recordcount>
	<cfset icerik_ = "#icerik_#copy #upload_folder#GNDPAYMENT.GTF #get_dept.LOCAL_FOLDER##CRLF#">
</cfif>
<cffile action="write" output="#icerik_#" addnewline="yes" file="#upload_folder#copy_command.cmd" charset="utf-8">       
	
<cfexecute 
	name="#upload_folder#copy_command.cmd"
    outputFile="#upload_folder#output.txt">
</cfexecute>

<br /><br />
<hr />
<div id="action_buttons" style="display:none;">
	<input type="button" value="Kapat" onclick="<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>"/>
</div>
   
	<script type="text/javascript">
	function duzenle()
	{
		document.getElementById('working_div_main').style.display='none';
		document.getElementById('urun_sonuc').style.display='';
		document.getElementById('action_buttons').style.display='';
	}
	function check_file()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.popup_control_file&department_id=#attributes.department_id#</cfoutput>','action_div',1);
	}
	
		document.getElementById('fountainG').innerHTML='<h1><img src="/images/loading_fountainG.gif" />Dosyalar Kopyalanıyor!</h1>';
		document.getElementById('working_div_main').style.display='';
		check_file();
	</script>
<div id="action_div"></div>
</cfif>
<cfscript>
	get_stocks = '';
	GET_PRICES = '';
	GET_PRICE_END = '';
</cfscript>

<cflocation url="#request.self#?fuseaction=retail.list_stock_export" addtoken="no">