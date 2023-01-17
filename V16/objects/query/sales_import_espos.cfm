<cfquery name="GET_TAX" datasource="#DSN2#">
	SELECT TAX_ID,TAX FROM SETUP_TAX
</cfquery>
<!--- <cfset tax_id_list=''>
<cfset tax_list=''>
<cfoutput query="get_tax">
	<cfset tax_id_list = Listappend(tax_id_list,numberformat(tax_id,'00'))>
	<cfset tax_list = Listappend(tax_list,tax)>
</cfoutput> --->
<cfset tax_id_list='01,02,03,04'>
<cfset tax_list='0,1,8,18'>

<cfscript>
	add_inv_row = ArrayNew(1);
	row_block = 200;
	dosya = ListToArray(dosya,CRLF);		
	line_count = ArrayLen(dosya);
	sube_satis_no = "#dateformat(get_import.startdate,'yyyymmdd')#_#get_import.department_id#_#get_import.import_detail#_";
	invoice_date_general = createodbcdatetime(get_import.startdate);
	GROSS_TOTAL = 0;
	NET_TOTAL = 0;
	TAX_TOTAL = 0;
	TOTAL_PRODUCTS = 0;
	PROBLEMS_COUNT = 0;
	satir_count1 = 0;
	satir_count2 = 0;
	
	//Aşama 1 : İlk Birli Satırın Bulunması
	/* Bilgi amacli istenilirse acilir BK 20080827
	if (fusebox.circuit neq 'schedules')
		writeoutput("Satır Sayısı : #line_count# <br/>");*/
		
	for (i=1; i lte line_count;)
	{
		satir = dosya[i];
		record_type = mid(satir,9,2);
		if(record_type is '01' or record_type is '02' and i lt line_count)
		{
			start_satir = i;
			break;			
		}
		
		i = i+1;	
	}
	//İlk Birli Satırdan Sonraki Satırların Döndürülmesi
	for(i=start_satir; i lte line_count;)
	{			
		satir = dosya[i];
		satir_count04 = 0;
		satir_count05 = 0;
		credit_card_total = 0;		
		satir_11 =''; 

		// İslem No 01 Fis Baslangici
		if((mid(satir,9,2) is '01') and (i lte line_count))
		{				
			satir_01 = satir;
			satir_count1 = satir_count1 + 1;
			//writeoutput("#i#: 01 Bulduğu Yer ___ Satir degeri :#satir_01#<br/>");
			i = i+1;
			satir = dosya[i];
			document_type = 1;
		}
		// İslem No 02 Fatura Baslangici
		if((mid(satir,9,2) is '02') and  (i lte line_count))
		{				
			satir_02 = satir;
			satir_count2 = satir_count2 + 1;
			//writeoutput("#i#: 02 Bulduğu Yer ___ Satir degeri :#satir_02#<br/>");
			i = i+1;
			satir = dosya[i];
			document_type = 2;
		}			
		// İslem No 03 Belge tarihi ve saati
		if(mid(satir,9,2) is '03' and (i lte line_count))
		{				
			satir_03 = satir;
			//writeoutput("#i#: 03 Bulduğu Yer ___ Satir değeri :#satir_03#<br/>");
			i = i + 1;
			satir = dosya[i];
		}
		
		// İslem No 04 Satis İslemi
		while(listfind('04,05',mid(satir,9,2),',') and (i lte line_count))
		{
			if(mid(satir,9,2) is '04')
			{
				satir_count04 = satir_count04 + 1;
				"satir_04_#satir_count04#" = satir;
				satir_04 = dosya[i];
				//writeoutput("#i#: 04 Bulduğu Yer ___ Satir değeri :#satir_04#<br/>");
				i = i + 1;
				satir = dosya[i];
			}
			else
			{
				satir_count05 = satir_count05 + 1;
				"satir_05_#satir_count05#" = satir;
				satir_05 = dosya[i];
				//writeoutput("#i#: 05 Bulduğu Yer ___ Satir değeri :#satir_05# Count_05 #satir_count05#<br/>");
				i = i + 1;
				satir = dosya[i];				
			}
		}
		
		//İşlem No 06 - 09 arası
		while(listfind('06,07,08,09,10',mid(satir,9,2),',') and (i lte line_count))
		{
			//writeoutput(" #i#: 06,07,08,09 Bulduğu Yer <br/>");
			i = i + 1;
			satir = dosya[i];				
		}
		
		// İslem No 11 Belge Sonu
		if(mid(satir,9,2) is '11' and (i lte line_count))
		{				
			satir_11 = satir;				
			i = i + 1;
			if(i lt line_count) satir = dosya[i];
		}
		
		while(listfind('12,13,14,15,16,17,18,19,20,21,22,23',mid(satir,9,2),',') and (i lte line_count))
		{			
			//writeoutput("#i#: 12,13,14,15,16,17,18,19,20,21,22,23 Bulduğu Yer <br/>");
			i = i + 1;
			if(i lt line_count) satir = dosya[i];				
		}
		/* Bilgi amacli istenilirse acilir BK 20080827
		if (fusebox.circuit neq 'schedules')
			writeoutput("- - - - - - <br/>");*/
		
		///Satisların isletilmesi
		for (j=1; j lte satir_count04; j=j+1)
		{
			/* Bilgi amacli istenilirse acilir BK 20080827 
				writeoutput(evaluate("satir_04_#j#"));*/
			temp_satir = evaluate("satir_04_#j#");				
			invoice_date = date_add("h",oku(satir_03,29,2),invoice_date_general);
			invoice_date = date_add("n",oku(satir_03,32,2),invoice_date);
			invoice_date = date_add("s",oku(satir_03,35,2),invoice_date);
			stock_id = val(mid(temp_satir,22,6));
			tax = listgetat(tax_list,listfind(tax_id_list,mid(temp_satir,29,2),','),',');
			get_stock = f_get_stock(STOCK_ID : stock_id,TERMINAL_TYPE : get_import.source_system);
			amount = mid(temp_satir,16,6);//miktar
			total = (mid(temp_satir,31,10)/100);//satis tutari
			customer_no = mid(satir_11,16,12)&mid(satir_11,29,8);//Musteri No
			credit_card_no = '';//Kredi Kart No
			if(document_type eq 1)
				bill_no = sube_satis_no&mid(satir_01,29,6);
			else
				bill_no = sube_satis_no&mid(satir_02,29,6);
			/* Bilgi amacli istenilirse acilir BK 20080827
			if (fusebox.circuit neq 'schedules')
				writeoutput(" +++++ #i# Stock_id : #stock_id# Barkod:#oku(temp_satir,183,24)# KDV : #tax# Miktar :#amount# Tutar : #total#<br/>");*/
		
			if (GET_STOCK.RECORDCOUNT) // stok kaydı bizde var ise
			{
				product_id = get_stock.product_id;
				barcode = get_stock.barcod;
				add_unit = get_stock.add_unit;
				nettotal = total/((tax+100)/100);
				multiplier = get_stock.multiplier;
				TOTAL_PRODUCTS = TOTAL_PRODUCTS + 1;

				//invoice_row_pos a eklenir
				//writeoutput('02_Satir No: #i# stock_id : _#stock_id# İnvoive_id:_#attributes.invoice_id# MULTIPLIER :_#GET_STOCK.MULTIPLIER#<br/>');
				
				sonuc = f_add_invoice_row(
					DB_SOURCE : dsn2,
					ROW_BLOCK : row_block,
					STOCK_ID : stock_id,
					PRODUCT_ID : val(product_id),
					BARCODE : barcode,
					ADD_UNIT : add_unit,
					MULTIPLIER : multiplier,
					ROW_TYPE : 'NULL',
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
					CREDITCARD_NO : credit_card_no,
					TERMINAL_TYPE : get_import.source_system,
					IS_KARMA : get_stock.is_karma,
					IS_PROM : 0
				);
			// satır_1 toplamlarından son toplama eklenir
			GROSS_TOTAL = GROSS_TOTAL + total;
			NET_TOTAL = NET_TOTAL + nettotal;
			TAX_TOTAL = TAX_TOTAL + (total-nettotal);
			}
			else
			{
				nettotal = total/((tax+100)/100);
				PROBLEMS_COUNT = PROBLEMS_COUNT + 1;
				// invoice_row_pos_problem eklenir
				sonuc = f_add_invoice_row_problem(
					STOCK_CODE : stock_id,
					BARCODE : '',
					INVOICE_ID : attributes.invoice_id,
					INVOICE_DATE : invoice_date,
					AMOUNT : amount,
					PRICE : (total/amount),
					DISCOUNTTOTAL : 0,
					GROSSTOTAL : total,
					TAXTOTAL : (total - nettotal),
					NETTOTAL : nettotal,															
					TAX : tax,
					BILL_NO : bill_no,
					CUSTOMER_NO : customer_no,
					CREDITCARD_NO : credit_card_no,
					ROW_TYPE : 'NULL',
					IS_PROM : 0
				);
				/* Bilgi amacli istenilirse acilir BK 20080827
				if (fusebox.circuit neq 'schedules')
					writeoutput("Bu Ürün için Stok Kaydı YOK !!!<br/>Fiş : #i#-#j# Stok Kodu : _#stock_id#_ Barkod : _???_<br/><hr>");*/
			}
		}			
		///Satis islemleri son
		
		///İptallerin isletilmesi
		for (k=1; k lte satir_count05; k=k+1)
		{
			temp_iptal = evaluate("satir_05_#k#");
			if(mid(temp_iptal,9,2) is '25') row_type = 0;
			else row_type = 1;
			invoice_date = date_add("h",oku(satir_03,29,2),invoice_date_general);
			invoice_date = date_add("n",oku(satir_03,32,2),invoice_date);
			invoice_date = date_add("s",oku(satir_03,35,2),invoice_date);
			stock_id = val(mid(temp_iptal,22,6));
			tax = listgetat(tax_list,listfind(tax_id_list,mid(temp_iptal,29,2),','),',');				
			get_stock = f_get_stock(STOCK_ID : stock_id, TERMINAL_TYPE : get_import.source_system);
			amount = mid(temp_iptal,16,6);//miktar								
			total = (mid(temp_iptal,31,10)/100);//satis tutari
			customer_no = mid(satir_11,16,12)&mid(satir_11,29,8);//Musteri No
			credit_card_no = '';//Kredi Kart No
			if(document_type eq 1)
				bill_no = sube_satis_no&mid(satir_01,29,6);
			else
				bill_no = sube_satis_no&mid(satir_02,29,6);
			/* Bilgi amacli istenilirse acilir BK 20080827
			if (fusebox.circuit neq 'schedules')
				writeoutput(" ----- #i# Stock_id : #stock_id# Barkod:#oku(temp_satir,183,24)# KDV : #tax# Miktar :#amount# Tutar : #total#<br/>");*/
		
			if (GET_STOCK.RECORDCOUNT) // stok kaydı bizde var ise
			{
				product_id = get_stock.product_id;
				barcode = get_stock.barcod;
				add_unit = get_stock.add_unit;
				nettotal = total/((tax+100)/100);
				multiplier = get_stock.multiplier;
				TOTAL_PRODUCTS = TOTAL_PRODUCTS - 1;

				//invoice_row_pos a eklenir
				sonuc = f_add_invoice_row(
					DB_SOURCE : dsn2,
					ROW_BLOCK : row_block,
					STOCK_ID : stock_id,
					PRODUCT_ID : val(product_id),
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
					CREDITCARD_NO : credit_card_no,
					TERMINAL_TYPE : get_import.source_system,
					IS_KARMA : get_stock.is_karma,
					IS_PROM : 0
				);
			// satır_1 toplamlarından son toplama eklenir
			GROSS_TOTAL = GROSS_TOTAL - total;
			NET_TOTAL = NET_TOTAL - nettotal;
			TAX_TOTAL = TAX_TOTAL - (total-nettotal);
			}
			else
			{
				PROBLEMS_COUNT = PROBLEMS_COUNT + 1;

				// invoice_row_pos_problem eklenir
				sonuc = f_add_invoice_row_problem(
					STOCK_CODE : stock_id,
					BARCODE : '',			
					INVOICE_ID : attributes.invoice_id,
					INVOICE_DATE : invoice_date,
					AMOUNT : amount,
					TOTAL : total,
					PRICE : (total/amount),
					DISCOUNTTOTAL : 0,
					GROSSTOTAL : total,
					TAXTOTAL : (total - nettotal),
					NETTOTAL : nettotal,															
					TAX : tax,						
					BILL_NO : bill_no,
					CUSTOMER_NO : customer_no,
					CREDITCARD_NO : credit_card_no,
					ROW_TYPE : row_type,
					IS_PROM : 0
				);
				/* Bilgi amacli istenilirse acilir BK 20080827
				if (fusebox.circuit neq 'schedules')
					writeoutput("Bu Ürün için Stok Kaydı YOK !!!<br/>Fiş : #i#-#j# Stok Kodu : _#stock_id#_ Barkod : _???_<br/><hr>");*/
			}
		}
		//Iptal islemleri bitis
	}	
	if(database_type is 'MSSQL') /* sadece MSSQL icin array olusup block olarak satir yazildigi icin*/
	{
		add_block_row(db_source:dsn2,row_array:add_inv_row);
		add_inv_row = ArrayNew(1);
	}		
</cfscript>
