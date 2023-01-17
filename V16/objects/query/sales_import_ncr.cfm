<cfscript>
	add_inv_row = ArrayNew(1);
	row_block = 200;
	dosya = ListToArray(dosya,CRLF);		
	line_count = ArrayLen(dosya);
	sube_satis_no = "#dateformat(get_import.startdate,'yyyymmdd')#_#get_import.department_id#_";
	invoice_date_general = createodbcdatetime(get_import.startdate);
	fis_no = 0;
	GROSS_TOTAL = 0;
	NET_TOTAL = 0;
	TAX_TOTAL = 0;
	TOTAL_PRODUCTS = 0;
	PROBLEMS_COUNT = 0;
	creditcard_no = '';
	
	satir_countHEADER = 0;
	satir_countSALES = 0;
	satir_countOTHER = 0;
	satir_countTENDER = 0;
	satir_countVAT = 0;
	satir_TENDER = '';
	
	//Aşama 1 : Ilk Islem Baslangicinin Bulunmasi
	for (i=1; i lte line_count;)
	{
		satir = dosya[i];
		record_type = mid(satir,33,1);
		if(record_type is 'H' and i lt line_count)
		{
			start_satir = i;				
			break;			
		}			
		i = i+1;
	}
	if (fusebox.circuit neq 'schedules')
		writeoutput("Kullanılan Kısaltmalar <br/>İlk XX__XX ifadesi Sepet Bitis Satırı ve Sepet Sıra No ifadesi olup Stock_ıd : S_ID _ Barcod : BRKD _ MIK : Miktar _ KDV : KDV _ Total : TOTAL _ NetTotal : N_TOTAL<br/>");

	//İlk Islem Baslangicindan Sonraki Satirlarin Dondurulmesi
	for(i=start_satir; i lt line_count;)
	{
		satir = dosya[i];
		satir_countSALES = 0;
		credit_card_total = 0;

		// Belge Baslangici
		if((mid(satir,33,1) is 'H') and (i lte line_count))
		{
			satir_HEADER = satir;
			satir_countHEADER = satir_countHEADER + 1;
			fis_date = "20"&oku(satir_HEADER,10,2)&"/"&oku(satir_HEADER,12,2)&"/"&oku(satir_HEADER,14,2);
			i = i+1;
			satir = dosya[i];
			//document_type = 1;
		}
		
		while(mid(satir,33,1) is 'S' and (i lte line_count))//S Satislar
		{
			satir_countSALES = satir_countSALES + 1;
			"satir_SALES_#satir_countSALES#" = satir;
			satir_SALES = dosya[i];
			i = i + 1;
			satir = dosya[i];
		}
		
		while(listfind('C,D,I,L,M,N,O,P,X',mid(satir,33,1),',') and (i lte line_count))//Diger islemler		
		{
			satir_countOTHER = satir_countOTHER + 1;
			"satir_OTHER_#satir_countOTHER#" = satir;
			satir_OTHER = dosya[i];
			i = i + 1;
			satir = dosya[i];
		}

		while(mid(satir,33,1) is 'T' and (i lte line_count)) //T Ara toplam 2 sıra olursa 1 satir verilen para 2 satir para ustu
		{
			satir_countTENDER = satir_countTENDER + 1;
			"satir_TENDER_#satir_countTENDER#" = satir;
			satir_TENDER = satir;
			//writeoutput(" #i# Satır_T : #satir_TENDER#<br/>");
			i = i + 1;
			satir = dosya[i];
		}

		while(mid(satir,33,1) is 'V' and (i lte line_count)) //V KDV degerleri İlki KDV Tutarı Ikincisi KDV'li toplam
		{
			satir_countVAT = satir_countVAT + 1;
			"satir_VAT_#satir_countVAT#" = satir;
			satir_VAT = dosya[i];
			i = i + 1;
			satir = dosya[i];
		}
		
		if((mid(satir,33,1) is 'F') and (i lte line_count))
		{
			satir_ENDOF = satir;				
			i = i+1;
			satir = dosya[i];
		}
		
		if((mid(satir,33,1) is ' ') and (i lte line_count))
		{
			satir_FIS = satir;				
			i = i+1;
			if(i lt line_count) satir = dosya[i];
		}

		///Satisların isletilmesi
		for (SALES_j=1; SALES_j lte satir_countSALES; SALES_j=SALES_j+1)
		{
			temp_satir = evaluate("satir_SALES_#SALES_j#");				
			invoice_date = date_add("h",oku(temp_satir,17,2),invoice_date_general);
			invoice_date = date_add("n",oku(temp_satir,19,2),invoice_date);
			invoice_date = date_add("s",oku(temp_satir,21,2),invoice_date);
			barcode = oku(temp_satir,44,16);
			get_stock = f_get_stock(BARCODE : barcode, TERMINAL_TYPE : get_import.source_system);
			if(not GET_STOCK.RECORDCOUNT and len(barcode) eq 7)
			{
				barcode = '#barcode#00000';
				barcode = barcode&WRK_UPCEANCheck(barcode);
				get_stock = f_get_stock(BARCODE : barcode, TERMINAL_TYPE : get_import.source_system);
			}
			else if (not GET_STOCK.RECORDCOUNT and len(barcode) eq 13)
			{				
				if (not val(mid(barcode,8,5)))
				{
					barcode = oku(barcode,1,7);
					get_stock = f_get_stock(BARCODE : barcode, TERMINAL_TYPE : get_import.source_system);
				}
			}

			if(mid(temp_satir,65,1) is '.')
				amount = oku(temp_satir,61,8);//Miktar
			else
				amount = oku(temp_satir,61,4);//iktar
										
			total = mid(temp_satir,70,9)/100;//satis tutari
			
			customer_no = oku(satir_HEADER,44,16);//Musteri No				
			creditcard_no = oku(satir_TENDER,44,16);//Kredi Kart No
			bill_no = sube_satis_no&mid(satir_HEADER,24,4);//Fis No
			if(oku(temp_satir,60,1) is '-')
				if(oku(temp_satir,36,1) eq 5) row_type = 0; //Iade
				else row_type = 1; //Iptal
			else
				row_type = 'NULL'; //Satis

			if (GET_STOCK.RECORDCOUNT) // stok kaydı bizde var ise
			{
				stock_id = get_stock.stock_id;
				product_id = get_stock.product_id;
				add_unit = get_stock.add_unit;
				tax = get_stock.tax;
				nettotal = total/((tax+100)/100);
				multiplier = get_stock.multiplier;
				//is_iade = false; 

				//if(oku(temp_satir,60,1) is '-')
					//if(oku(temp_satir,36,1) eq 5) row_type = 0; //Iade
					//else row_type = 1; //Iptal
				//else
					//row_type = 'NULL'; //Satis  // bu if blogu ustte alındı daha sonra silinebilir BK

				//if(oku(temp_satir,60,1) is '-') //Quantity ve amount - kontrolu Iade ve iptal olayı netlestikten sonra kaldır BK 20050801
					//is_iade = true;
				
				if (fusebox.circuit neq 'schedules')
					writeoutput(" #i#__#SALES_j# S_ID : #stock_id# BRKD : #barcode#  MIK : #amount# KDV : #tax# TOTAL : #total# N_TOTAL : #nettotal# <br/>");
				
				TOTAL_PRODUCTS = TOTAL_PRODUCTS + 1;

				sonuc = f_add_invoice_row(
					DB_SOURCE : dsn2,
					ROW_BLOCK : row_block,
					STOCK_ID : stock_id,
					PRODUCT_ID : product_id,
					BARCODE : barcode,
					ADD_UNIT : add_unit,
					MULTIPLIER : multiplier,	
			  		ROW_TYPE : row_type,
			  		INVOICE_ID : attributes.invoice_id,
					INVOICE_DATE : invoice_date,
					BILL_NO : bill_no,								
					AMOUNT : amount, 
					PRICE : (total/amount),
					DISCOUNTTOTAL : 0,
					GROSSTOTAL : total,
					TAXTOTAL : (total - nettotal),
					NETTOTAL : nettotal,
					TAX : tax,
					CUSTOMER_NO : customer_no,
					CREDITCARD_NO : creditcard_no,
					TERMINAL_TYPE : get_import.source_system,
					IS_KARMA : get_stock.is_karma,
					IS_PROM : 0
					);

				// Satıs toplamları son toplama eklenir.
				
				if(row_type neq 'NULL')//is_iade vardı daha sonra sil
				{
					GROSS_TOTAL = GROSS_TOTAL - total;
					NET_TOTAL = NET_TOTAL - nettotal;
					TAX_TOTAL = TAX_TOTAL - (total-nettotal);					
				}
				else
				{
					GROSS_TOTAL = GROSS_TOTAL + total;
					NET_TOTAL = NET_TOTAL + nettotal;
					TAX_TOTAL = TAX_TOTAL + (total-nettotal);
				}
			}
			else
			{
				PROBLEMS_COUNT = PROBLEMS_COUNT + 1;
				sonuc = f_add_invoice_row_problem(
					STOCK_CODE : '',						
					BARCODE : oku(temp_satir,44,16),
					INVOICE_ID : attributes.invoice_id,
					INVOICE_DATE : invoice_date,
					BILL_NO : bill_no,
					AMOUNT : amount,
					PRICE : (total/amount),
					DISCOUNTTOTAL : 0,
					GROSSTOTAL : total,
					TAXTOTAL : 0,//(total-nettotal),
					NETTOTAL : 0,//(total-taxtotal),
					TAX : 0,
					CUSTOMER_NO : customer_no,
					CREDITCARD_NO : creditcard_no,
					ROW_TYPE : row_type,
					IS_PROM : 0
				);
				if (fusebox.circuit neq 'schedules')
					writeoutput("Stok Kaydı YOK !!! #i#_#SALES_j# BRKD : #barcode#<br/><hr>");
			}
		///Satisların isletilmesi son
		}
	}
	if(database_type is 'MSSQL') /* sadece MSSQL icin array olusup block olarak satir yazildigi icin*/
	{
		add_block_row(db_source:dsn2,row_array:add_inv_row);
		add_inv_row = ArrayNew(1);
	}
</cfscript>
