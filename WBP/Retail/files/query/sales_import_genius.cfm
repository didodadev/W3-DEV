<!--- 
	Promosyon urunlerin stoktan dusulmesi islemi icin yapılan eklemeler BK 20070412
	- 	05 18 ile baslayan satirlar isleme alinmakta. (Pick & Mix Hediyeleri) 
	-	Urunun barcod bilgisinden ilgili diger alanlar f_get_stock fonksiyonundan alinacaktir 
	-	Iade belgelerinde bu islem gozardı edilebilir.
 --->
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

	for (i=1; i lt line_count;)
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
			if (listfind('0,1,2', oku(satir,12,1)))
			{
				satir_count3 = satir_count3 + 1;
				if ((oku(satir, 12, 1) eq 0) and (oku(satir, 13, 1) eq 1) and len(oku(satir, 44, 24)))
				{
					creditcard_no = oku(satir,44,24);
					credit_card_payment_total = credit_card_payment_total + replace(oku(satir, 14, 15),",",".","all");
				}
			}
			i = i + 1;
			satir = dosya[i];
		}
		
		// Bu eklenti satir1,satir2 degerinden sonra satir3 blogunun bulanamadığı icin yapıldı.		
		if(satir_count3 eq 0)
		{
			writeoutput("<br/> Satır 3 Bulunamadı Dosyanızı Kontrol (#i#)! <br/>");
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
			if ( (oku(satir, 4, 1) eq 1) and (oku(satir, 5, 1) eq 8)) //05 18 ifedesini yakalamak adina eklendi
			{
				satir_count5 = satir_count5 + 1;
				"satir_5_#satir_count5#" = satir;
			}
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

		if (oku(satir_1,63,1) eq 0) // belge geçerli
		{
			if (oku(satir_1,62,1) eq 2) // belge tipi iade fisi
			{
				for (j=1; j lte satir_count2; j=j+1)
				{
					tempo = evaluate("satir_2_#j#");
					// detayli bakmak icin acınız performans adına kapatıldı BK 20080724
					//if (fusebox.circuit neq 'schedules')
						//writeoutput("#i# S:#oku(tempo,10,24)# B:#oku(tempo,183,24)# IADE <br/>");						
					add_unit = ListGetAt(birim_list, oku(tempo, 61, 1)+1);

					//Bos hareket satirlarini kontrol etmek amaciyla alt kısma alindi 6 aya siline BK 20080824
					//product_id = ListFirst(oku(tempo, 10, 24), ".");
					//stock_id = ListGetAt(oku(tempo, 10, 24), 2, ".");						

					if (add_unit is "Kilogram")
						amount = replace(oku(tempo,46,15),",",".","all")/1000;//#(oku(arguments.tempo,46,15)/1000)*(-1)#,
					else
						amount = replace(oku(tempo,46,15),",",".","all");//#oku(arguments.tempo,46,15)*(-1)#,
					price = replace(oku(tempo,62,15),",",".","all");//Birim fiyatı
					discounttotal = replace(oku(tempo,107,15),",",".","all");//Toplam indirim
					grosstotal = replace(oku(tempo,77,15),",",".","all");//Toplam fiyat
					taxtotal = replace(oku(tempo,92,15),",",".","all");//Toplam KDV
					tax = oku(tempo,43,3);//KDV Oranı
					customer_no = oku(satir_1,212,24);//Musteri No
					invoice_date = invoice_date_general;					
					row_type = 0; //Iade
					if(oku(tempo,34,1)) row_type = 'NULL';// iade fisinde iptal satırı normal satis gibi alınır.
				
					if(len(oku(tempo, 10, 24))) //and (ListLen(oku(tempo, 10, 24), ".") eq 2))//product id.stock_id ifadesinin uzunlugu ve noktali mi kontrolu
					{
						if ((ListLen(oku(tempo, 10, 24), ".") eq 2))
						{
							product_id = ListFirst(oku(tempo, 10, 24), ".");
							stock_id = ListGetAt(oku(tempo, 10, 24), 2, ".");						
						}
						else
						{
							stock_id = oku(tempo, 10, 24);	
							get_product = cfquery(datasource : "#dsn#", sqlstring :"SELECT TOP 1 PRODUCT_ID FROM #dsn1#.STOCKS WHERE STOCK_ID = #stock_id#");
							product_id = get_product.product_id;
						}
						get_stock_id_sql = cfquery(datasource : "#dsn#", sqlstring : "SELECT 
													S.PRODUCT_ID,
													S.STOCK_ID
												FROM
													#dsn1#.PRODUCT P INNER JOIN
													#dsn3#.RELATED_PRODUCT RP ON RP.PRODUCT_ID = P.PRODUCT_ID INNER JOIN
													#dsn1#.STOCKS S ON S.PRODUCT_ID = RP.RELATED_PRODUCT_ID
												WHERE
													P.PRODUCT_CATID = 1
													AND P.PRODUCT_ID = #product_id#
													");
						if(get_stock_id_sql.recordcount)
						{
							virman_count = virman_count+1;
							'product_id_#virman_count#'=product_id;
							'stock_id_#virman_count#'=stock_id;
							'product_id_in_#virman_count#'=get_stock_id_sql.PRODUCT_ID;
							'stock_id_in_#virman_count#'=get_stock_id_sql.STOCK_ID;
							'unit_#virman_count#'= add_unit;
							'amount_#virman_count#' = amount;
						}
						
						get_stock = f_get_stock(STOCK_ID : stock_id,TERMINAL_TYPE : get_import.source_system);
						if(get_stock.recordcount) // stok kaydı bizde var ise
						{
							TOTAL_PRODUCTS = TOTAL_PRODUCTS + 1;
							if (len(oku(satir_1,36,12)))
							{
								invoice_date = date_add("h",oku(satir_1,36,2),invoice_date);
								invoice_date = date_add("n",oku(satir_1,38,2),invoice_date);
								invoice_date = date_add("s",oku(satir_1,40,2),invoice_date);
							}
							// kredi kartı ile ödeme varsa azalta azalta gidilir
							if (credit_card_payment_total gt 0)
								credit_card_payment_total = credit_card_payment_total - replace(oku(tempo,77,15),",",".","all");
							else
								creditcard_no = "";
				
							if(len(get_stock.multiplier))
								multiplier_ = get_stock.multiplier;
							else
								multiplier_ = 1;
				
							//writeoutput('<font color="red">TOTAL_PRODUCTS:#TOTAL_PRODUCTS#  stock_id:#stock_id# row_type:#row_type# net #grosstotal-taxtotal-discounttotal# tax:#taxtotal# discounttotal:#discounttotal#<br></font>');
							//invoice_row_pos a eklenir
							sonuc = f_add_invoice_row(
								DB_SOURCE : dsn2,
								ROW_BLOCK : row_block,
								STOCK_ID : stock_id,
								PRODUCT_ID : product_id,
								BARCODE : oku(tempo,183,24),
								ADD_UNIT : add_unit,//ListGetAt(birim_list, oku(tempo, 61, 1)+1)
								MULTIPLIER : multiplier_,
								ROW_TYPE : row_type,							
								INVOICE_ID : attributes.invoice_id,
								INVOICE_DATE : invoice_date,//temp_invoice_date
								BILL_NO : temp_fis_no,
								AMOUNT : amount, //Miktar
								PRICE : price,
								DISCOUNTTOTAL : discounttotal,
								GROSSTOTAL : grosstotal,
								TAXTOTAL : taxtotal,
								NETTOTAL : (grosstotal-taxtotal-discounttotal),								
								TAX : tax,
								CUSTOMER_NO : customer_no,
								CREDITCARD_NO : creditcard_no,
								TERMINAL_TYPE : get_import.source_system,
								IS_KARMA : get_stock.is_karma,
								IS_PROM : 0
								);
						}
						else
						{
							PROBLEMS_COUNT = PROBLEMS_COUNT + 1;
							// kredi kartı ile ödeme varsa azalta azalta gidilir
							if (credit_card_payment_total gt 0)
								credit_card_payment_total = credit_card_payment_total - replace(oku(tempo,77,15),",",".","all");
							else
								creditcard_no = "";
				
							// invoice_row_pos_problem eklenir
							sonuc = f_add_invoice_row_problem(
								STOCK_CODE : stock_id,
								BARCODE : oku(tempo,183,24),
								INVOICE_ID : attributes.invoice_id,
								INVOICE_DATE : invoice_date,
								BILL_NO : temp_fis_no,
								AMOUNT : amount,
								PRICE : price,
								DISCOUNTTOTAL : discounttotal,
								GROSSTOTAL : grosstotal,
								TAXTOTAL : taxtotal,
								NETTOTAL : (grosstotal-taxtotal-discounttotal),
								TAX : tax,
								CUSTOMER_NO : customer_no,
								CREDITCARD_NO : creditcard_no,
								ROW_TYPE : row_type,
								IS_PROM : 0
								);
							if (fusebox.circuit neq 'schedules')
								writeoutput("Bu Ürün için Stok Kaydı YOK !!! Fiş:#i#-#j# (product_id.stock_id):#oku(tempo,10,24)# B:#oku(tempo,183,24)#<br/><hr>");
						}
					}
					else
					{
						PROBLEMS_COUNT = PROBLEMS_COUNT + 1;
						// kredi kartı ile ödeme varsa azalta azalta gidilir
						if (credit_card_payment_total gt 0)
							credit_card_payment_total = credit_card_payment_total - replace(oku(tempo,77,15),",",".","all");
						else
							creditcard_no = "";
			
						// invoice_row_pos_problem eklenir
						sonuc = f_add_invoice_row_problem(
							STOCK_CODE : 'NULL',
							BARCODE : oku(tempo,183,24),
							INVOICE_ID : attributes.invoice_id,
							INVOICE_DATE : invoice_date,
							BILL_NO : temp_fis_no,
							AMOUNT : amount,
							PRICE : price,
							DISCOUNTTOTAL : discounttotal,
							GROSSTOTAL : grosstotal,
							TAXTOTAL : taxtotal,
							NETTOTAL : (grosstotal-taxtotal-discounttotal),
							TAX : tax,
							CUSTOMER_NO : customer_no,
							CREDITCARD_NO : creditcard_no,
							ROW_TYPE : row_type,
							IS_PROM : 0
							);
						if (fusebox.circuit neq 'schedules')
							writeoutput("<hr>İlgili Fişin Haraket Satırında Ürün Kodu Yok. Dosyanızı Kontrol Ediniz !!! Fiş:#i#-#j# (product_id.stock_id):#oku(tempo,10,24)# B:#oku(tempo,183,24)#<br/><hr>");
					
					}
				}

				// satır_1 toplamlarından son toplamdan düşülür because iade
				GROSS_TOTAL = GROSS_TOTAL - replace(oku(satir_1,92,15),",",".","all");
				NET_TOTAL = NET_TOTAL - (replace(oku(satir_1,92,15),",",".","all")-replace(oku(satir_1,107,15),",",".","all"));
				TAX_TOTAL = TAX_TOTAL - replace(oku(satir_1,107,15),",",".","all");
				
				TAX_TOTAL2 = TAX_TOTAL2 + taxtotal;
				writeoutput('<font color="red">GROSS_TOTAL:#GROSS_TOTAL# NET_TOTAL:#NET_TOTAL# TAX_TOTAL:#TAX_TOTAL# </font><hr>');
				
			}
			else // iade fişi değil ise
			{
				writeoutput('<b>#satir_count2#</b><br> ');
				for (j=1; j lte satir_count2; j=j+1)
				{
					tempo = evaluate("satir_2_#j#");
					/*detayli bakmak icin acınız performans adına kapatıldı BK 20080724
					if (fusebox.circuit neq 'schedules')
						writeoutput("#i# S:#oku(tempo,10,24)# B:#oku(tempo,183,24)#<br/>");*/

					add_unit = ListGetAt(birim_list, oku(tempo, 61, 1)+1);//Birim
					
					//Bos hareket satirlarini kontrol etmek amaciyla alt kısma alindi 6 aya siline BK 20080824
					//product_id = ListFirst(oku(tempo, 10, 24), ".");
					//stock_id = ListGetAt(oku(tempo, 10, 24), 2, ".");	
					
					if (add_unit is "Kilogram")
						amount = (replace(oku(tempo,46,15),",",".","all")/1000);//#(oku(arguments.tempo,46,15)/1000)*(-1)#,
					else
						amount =replace(oku(tempo,46,15),",",".","all");//#oku(arguments.tempo,46,15)*(-1)#,
					price = replace(oku(tempo,62,15),",",".","all");//Birim fiyatı
					discounttotal = replace(oku(tempo,107,15),",",".","all");//Toplam indirim
					grosstotal = replace(oku(tempo,77,15),",",".","all");//Toplam fiyat
					taxtotal = replace(oku(tempo,92,15),",",".","all");//Toplam KDV
					tax = oku(tempo,43,3);//KDV Oranı
					customer_no = oku(satir_1,212,24);//Musteri No
					invoice_date = invoice_date_general;						
					row_type = 'NULL'; //satis
					if (oku(tempo,34,1)) row_type = 1; // İade fisi olmayan belgedeki iptal satırı
					
					if(len(oku(tempo, 10, 24))) //and (ListLen(oku(tempo, 10, 24), ".") eq 2))//product id.stock_id ifadesinin uzunlugu ve noktali mi kontrolu
					{
						if ((ListLen(oku(tempo, 10, 24), ".") eq 2))
						{
							product_id = ListFirst(oku(tempo, 10, 24), ".");
							stock_id = ListGetAt(oku(tempo, 10, 24), 2, ".");						
						}
						else
						{
							stock_id = oku(tempo, 10, 24);	
							get_product = cfquery(datasource : "#dsn#", sqlstring :"SELECT TOP 1 PRODUCT_ID FROM #dsn1#.STOCKS WHERE STOCK_ID = #stock_id#");
							product_id = get_product.product_id;
						}
						get_stock_id_sql = cfquery(datasource : "#dsn#", sqlstring : "SELECT 
													S.PRODUCT_ID,
													S.STOCK_ID
												FROM
													#dsn1#.PRODUCT P INNER JOIN
													#dsn3#.RELATED_PRODUCT RP ON RP.PRODUCT_ID = P.PRODUCT_ID INNER JOIN
													#dsn1#.STOCKS S ON S.PRODUCT_ID = RP.RELATED_PRODUCT_ID
												WHERE
													P.PRODUCT_CATID = 1
													AND P.PRODUCT_ID = #product_id#
													");
						if(get_stock_id_sql.recordcount)
						{
							virman_count = virman_count+1;
							'product_id_#virman_count#'=product_id;
							'stock_id_#virman_count#'=stock_id;
							'product_id_in_#virman_count#'=get_stock_id_sql.PRODUCT_ID;
							'stock_id_in_#virman_count#'=get_stock_id_sql.STOCK_ID;
							'unit_#virman_count#'= add_unit;
							'amount_#virman_count#' = amount;
						}

						get_stock = f_get_stock(STOCK_ID : stock_id,TERMINAL_TYPE : get_import.source_system);
				
						if (get_stock.recordcount) // stok kaydı bizde var ise
						{
							TOTAL_PRODUCTS = TOTAL_PRODUCTS + 1;
							if (len(oku(satir_1,36,12)))
							{
								invoice_date = date_add("h",oku(satir_1,36,2),invoice_date);
								invoice_date = date_add("n",oku(satir_1,38,2),invoice_date);
								invoice_date = date_add("s",oku(satir_1,40,2),invoice_date);
							}
							// kredi kartı ile ödeme varsa azalta azalta gidilir
							if (credit_card_payment_total gt 0)
								credit_card_payment_total = credit_card_payment_total - replace(oku(tempo,77,15),",",".","all");
							else
								creditcard_no = "";
				
							//row_type = 'NULL'; //satis
							//if (oku(tempo,34,1)) row_type = 1; // İade fisi olmayan belgedeki iptal satırı // Daha sonra silinebilir ust bloga alındı
							
							//Iade ve iptal olayı netlestikten sonra kaldır BK 20050801
							//is_iade = false;
							//if (oku(tempo,34,1)) is_iade = true;  // iptal satırı iade gibi işlem görür
				
							if(len(get_stock.multiplier))
								multiplier_ = get_stock.multiplier;
							else
								multiplier_ = 1;
							
							
							//writeoutput('TOTAL_PRODUCTS:#TOTAL_PRODUCTS# stock_id:#stock_id#  row_type:#row_type# net #grosstotal-taxtotal-discounttotal# tax:#taxtotal# discounttotal:#discounttotal#<br>');
							//invoice_row_pos a eklenir
							sonuc = f_add_invoice_row(
								DB_SOURCE : dsn2,
								ROW_BLOCK : row_block,
								STOCK_ID : stock_id,
								PRODUCT_ID : product_id,
								BARCODE : oku(tempo,183,24),
								ADD_UNIT : add_unit,
								MULTIPLIER : multiplier_,
								ROW_TYPE : row_type,
								INVOICE_ID : attributes.invoice_id,
								INVOICE_DATE : invoice_date,
								BILL_NO : temp_fis_no,
								AMOUNT : amount,
								PRICE : price,
								DISCOUNTTOTAL : discounttotal,
								GROSSTOTAL : grosstotal,
								TAXTOTAL : taxtotal,
								NETTOTAL : (grosstotal-taxtotal-discounttotal),
								TAX : tax,
								CUSTOMER_NO : customer_no,
								CREDITCARD_NO : creditcard_no,
								TERMINAL_TYPE : get_import.source_system,
								IS_KARMA : get_stock.is_karma,
								IS_PROM : 0
								);
						}
						else
						{
							PROBLEMS_COUNT = PROBLEMS_COUNT + 1;
							// kredi kartı ile ödeme varsa azalta azalta gidilir
							if (credit_card_payment_total gt 0)
								credit_card_payment_total = credit_card_payment_total - replace(oku(tempo,77,15),",",".","all");
							else
								creditcard_no = "";
								
							// invoice_row_pos_problem eklenir
							sonuc = f_add_invoice_row_problem(
								STOCK_CODE : stock_id,
								BARCODE : oku(tempo,183,24),
								INVOICE_ID : attributes.invoice_id,
								INVOICE_DATE : invoice_date,
								BILL_NO : temp_fis_no,													
								AMOUNT : amount, 
								PRICE : price,
								DISCOUNTTOTAL : discounttotal,
								GROSSTOTAL : grosstotal,
								TAXTOTAL : taxtotal,
								NETTOTAL : (grosstotal-taxtotal-discounttotal),
								TAX : tax,
								CUSTOMER_NO : customer_no,
								CREDITCARD_NO : creditcard_no,
								ROW_TYPE : row_type,
								IS_PROM : 0
								);
							if (fusebox.circuit neq 'schedules')
								writeoutput("Bu Ürün için Stok Kaydı YOK !!! Fiş:#i#-#j#(product_id.stock_id):#oku(tempo,10,24)# B:#oku(tempo,183,24)#<br/><hr>");
						}
					}
					else
					{
						PROBLEMS_COUNT = PROBLEMS_COUNT + 1;
						// kredi kartı ile ödeme varsa azalta azalta gidilir
						if (credit_card_payment_total gt 0)
							credit_card_payment_total = credit_card_payment_total - replace(oku(tempo,77,15),",",".","all");
						else
							creditcard_no = "";
							
						// invoice_row_pos_problem eklenir
						sonuc = f_add_invoice_row_problem(
							STOCK_CODE : 'NULL',
							BARCODE : oku(tempo,183,24),
							INVOICE_ID : attributes.invoice_id,
							INVOICE_DATE : invoice_date,
							BILL_NO : temp_fis_no,													
							AMOUNT : amount, 
							PRICE : price,
							DISCOUNTTOTAL : discounttotal,
							GROSSTOTAL : grosstotal,
							TAXTOTAL : taxtotal,
							NETTOTAL : (grosstotal-taxtotal-discounttotal),
							TAX : tax,
							CUSTOMER_NO : customer_no,
							CREDITCARD_NO : creditcard_no,
							ROW_TYPE : row_type,
							IS_PROM : 0
							);
						if (fusebox.circuit neq 'schedules')
							writeoutput("<hr>İlgili Fişin Haraket Satırında Ürün Kodu Yok. Dosyanızı Kontrol Ediniz !!! Fiş:#i#-#j#(product_id.stock_id):#oku(tempo,10,24)# B:#oku(tempo,183,24)#<br/><hr>");
					}	
				}
				// satır_1 toplamlarından son toplama eklenir
				GROSS_TOTAL = GROSS_TOTAL + replace(oku(satir_1,92,15),",",".","all");
				NET_TOTAL = NET_TOTAL + (replace(oku(satir_1,92,15),",",".","all")-replace(oku(satir_1,107,15),",",".","all"));
				TAX_TOTAL = TAX_TOTAL + replace(oku(satir_1,107,15),",",".","all");
				TAX_TOTAL2 = TAX_TOTAL2 + taxtotal;
				
				//writeoutput('GROSS_TOTAL:#GROSS_TOTAL# NET_TOTAL:#NET_TOTAL# TAX_TOTAL:#TAX_TOTAL# TAX_TOTAL2:#TAX_TOTAL2# #grosstotal#<hr>');
				
				//satir 5 islenmesi Hediye Urun
				for (k=1; k lte satir_count5; k=k+1)
				{
					tempo = evaluate("satir_5_#k#");
					amount = replace(oku(tempo,11,15),",",".","all");
					customer_no = oku(satir_1,212,24); //Musteri No
					invoice_date = invoice_date_general;
					row_type = 'NULL'; //satis					
					barcode = oku(tempo,50,24);
					
					//if (fusebox.circuit neq 'schedules')
						//writeoutput("#k# B:#barcode#<br/>");				
					//Burada ozellikle TERMINAL_TYPE : get_import.source_system gonderilmedi. Ilk defa Genius belgede barcode bagli olarak urun cekildi.
					get_stock = f_get_stock(BARCODE : barcode, TERMINAL_TYPE : -3);
					if (get_stock.recordcount) // stok kaydı bizde var ise
					{
						TOTAL_PRODUCTS = TOTAL_PRODUCTS + 1;
						if (len(oku(satir_1,36,12)))
						{
							invoice_date = date_add("h",oku(satir_1,36,2),invoice_date);
							invoice_date = date_add("n",oku(satir_1,38,2),invoice_date);
							invoice_date = date_add("s",oku(satir_1,40,2),invoice_date);
						}
				
						//if (fusebox.circuit neq 'schedules')
							//writeoutput(" #i#__S_ID : #stock_id# BRKD : #barcode#  MIK : #amount# KDV : 0 GROSSTOTAL : 0 N_TOTAL : 0 <br/>");
	
						//invoice_row_pos a eklenir
						if(len(get_stock.multiplier))
							multiplier_ = get_stock.multiplier;
						else
							multiplier_ = 1;
						
						sonuc = f_add_invoice_row(
							DB_SOURCE : dsn2,
							ROW_BLOCK : row_block,
							STOCK_ID : get_stock.stock_id,
							PRODUCT_ID : get_stock.product_id,
							BARCODE : barcode,
							ADD_UNIT : get_stock.add_unit,
							MULTIPLIER : multiplier_,
							ROW_TYPE : row_type,							
							INVOICE_ID : attributes.invoice_id,
							INVOICE_DATE : invoice_date,
							BILL_NO : temp_fis_no,
							AMOUNT : amount, //Miktar
							PRICE : 0,
							DISCOUNTTOTAL : 0,
							GROSSTOTAL : 0,
							TAXTOTAL : 0,
							NETTOTAL : 0,								
							TAX : get_stock.tax,
							CUSTOMER_NO : customer_no,
							CREDITCARD_NO : creditcard_no,
							TERMINAL_TYPE : get_import.source_system,
							IS_KARMA : get_stock.is_karma,
							IS_PROM : 1
							);
					}		
					else
					{
						PROBLEMS_COUNT = PROBLEMS_COUNT + 1;
						// invoice_row_pos_problem eklenir
						sonuc = f_add_invoice_row_problem(
							STOCK_CODE : '',
							BARCODE : barcode,
							INVOICE_ID : attributes.invoice_id,
							INVOICE_DATE : invoice_date,
							BILL_NO : temp_fis_no,													
							AMOUNT : amount, 
							PRICE : 0,
							DISCOUNTTOTAL : 0,
							GROSSTOTAL : 0,
							TAXTOTAL : 0,
							NETTOTAL : 0,
							TAX : 0,
							CUSTOMER_NO : customer_no,
							CREDITCARD_NO : creditcard_no,
							ROW_TYPE : row_type,
							IS_PROM : 1
							);
						if (fusebox.circuit neq 'schedules')
							writeoutput("Bu Hediye Ürün için Stok Kaydı YOK !!! Fiş:#oku(satir_1,24,12)# Barkod:#barcode#<br/><hr>");
					}
				}				
			}
		}
		
		else // belge geçerli değil ise ekrana yazılır
		{
			if (fusebox.circuit neq 'schedules')
			{
				writeoutput("Fiş Okunamadı ! Satır : #i#<br/>");
				switch (oku(satir_1,63,1))
				{
					case "1" : writeoutput("Kullanıcı Tarafından İptal !<hr>"); break;
					case "2" : writeoutput("Uygulama Tarafından İptal !<hr>"); break;
					case "3" : writeoutput("Askıya Alındığından Dolayı İptal !<hr>"); break;
					case "4" : writeoutput("Program Açılırken Yarım Kalan Belgeden Dolayı İptal !<hr>"); break;
					default  : writeoutput("! Bilinmiyor !<hr>");
				}
			}
		}
	}
	if(database_type is 'MSSQL') /* sadece MSSQL icin array olusup block olarak satir yazildigi icin*/
	{
		add_block_row(db_source:dsn2,row_array:add_inv_row);
		add_inv_row = ArrayNew(1);
	}
</cfscript>


<!---
<!---belirli stoklarda virman--->
<cfinclude template="/objects/functions/get_cost.cfm">
<cfinclude template="/objects/functions/cost_action.cfm">

<cfif virman_count gt 0>

	<cfoutput> 
        <cfquery name="GET_GEN_PAPER" datasource="#DSN2#">
				SELECT * FROM #DSN3#.GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
			</cfquery>
        <cfset paper_code = get_gen_paper.stock_fis_no>
        <cfset paper_no = get_gen_paper.stock_fis_number +1>
		<cfset attributes.process_date = get_import.startdate>
        <cfset attributes.process_type = 116>
        <cfset form.process_cat = 66>
        <cfset attributes.process_cat = 66>
        <cfset attributes.stock_record_num = virman_count>
       
       		<cfset attributes.active_period = session.ep.period_id>
		   <cfset attributes.exchange_no= '#paper_code#-#paper_no#'>
		
        <cfset attributes.department_id = get_import.DEPARTMENT_ID>
        <cfset attributes.location_id = 1>
        <cfset attributes.exit_department_id = get_import.DEPARTMENT_ID>
        <cfset attributes.exit_location_id = 1>
	<cfloop from="1" to="#virman_count#" index="i">
 		<cfset 'attributes.stock_id#i#' = evaluate('stock_id_#i#')>
		<cfset 'attributes.spec_main_name#i#' = ''>
		<cfset 'attributes.spec_main_id#i#' = ''>
		<cfset 'attributes.exit_spec_main_name#i#' = ''>
		<cfset 'attributes.exit_spec_main_id#i#' = ''>
        <cfset 'attributes.row_kontrol#i#' = 1>
        <cfset 'attributes.product_id#i#' = evaluate('product_id_#i#')>
        <cfset 'attributes.exit_product_id#i#' = evaluate('product_id_in_#i#')>
		<cfset 'attributes.unit#i#' = evaluate('unit_#i#')>
        <cfset 'attributes.unit_id#i#' = ''>
		<cfset 'attributes.unit2_#i#' = evaluate('unit_#i#')>
        <cfset 'attributes.unit_id2_#i#' = ''>
        <cfquery name="GET_UNIT" datasource="#DSN2#">
            SELECT 
                P.PRODUCT_ID,
                P.STOCK_ID,
                PU.MAIN_UNIT_ID,
                PU.MAIN_UNIT
            from 
                #dsn1#.PRODUCT_UNIT PU INNER JOIN
                #dsn1#.STOCKS P ON P.PRODUCT_ID = PU.PRODUCT_ID
            WHERE
            	P.PRODUCT_ID = #evaluate('attributes.product_id#i#')#
        </cfquery>
        <cfset 'attributes.exit_stock_id#i#' = evaluate('stock_id_in_#i#')>
 		<cfset 'attributes.exit_unit#i#' = GET_UNIT.MAIN_UNIT>
        <cfset 'attributes.exit_unit_id#i#' = GET_UNIT.MAIN_UNIT_ID>
 		<cfset 'attributes.exit_unit2_#i#' = ''>
        <cfset 'attributes.exit_unit_id2_#i#' = ''>
        <cfset 'attributes.amount#i#' = evaluate('amount_#i#')>
        <cfset 'attributes.exit_amount#i#' = evaluate('amount_#i#')>
     </cfloop>

	</cfoutput>
    <cfinclude template="/add_options/query/add_stock_exchange.cfm">
</cfif>
--->