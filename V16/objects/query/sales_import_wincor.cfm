<!--- 
	Wincor dosyalar icin yapilan satis isleme islemi BK 20130212
 --->
<cfscript>
	add_inv_row = ArrayNew(1);
	row_block = 200;
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	birim_list = "Adet,Kilogram,Metre,Litre";
	sube_satis_no = "#dateformat(get_import.startdate,'yyyymmdd')#_#get_import.department_id#_";
	invoice_date_general = createodbcdatetime(get_import.startdate);
	fis_no = 0;
	GROSS_TOTAL = 0;
	NET_TOTAL = 0;
	TAX_TOTAL = 0;
	TOTAL_PRODUCTS = 0;
	PROBLEMS_COUNT = 0;satir_count1 = 0;

	for (i=1; i lte line_count;i++)
	{
		satir = dosya[i];
		
		
		fis_no = fis_no + 1;


		// Belge Tipi 1 olanlar (fisli satis),Belge Tipi 2 olanlar (faturali satis) okunur
		if(listfind('1,2',trim(oku(satir,139,2)),','))
		{
			satir_count1 = satir_count1 + 1;
			"satir_1_#satir_count1#" = satir;
			//writeoutput("Fiş Tipi : #trim((oku(satir,139,2)))#<br>");
		}
		
		//satır 3,4,5,6,7,8,9,10,11,12 lar atlanir 
		else if(listfind('3,4,5,6,7,8,9,10,11,12',trim(oku(satir,139,2)),','))
		{
			//writeoutput("İşlenmeyen Fiş Tipi : #trim((oku(satir,139,2)))# Belge Satır No : #line_count# <br>");
		}

	
	}


	///Fisli satirlarin isletilmesi
	for (j=1; j lte satir_count1; j=j+1)
	{
		temp_satir = evaluate("satir_1_#j#");
		invoice_date = date_add("h",oku(temp_satir,14,2),invoice_date_general);
		invoice_date = date_add("n",oku(temp_satir,16,2),invoice_date);
		invoice_date = date_add("s",00,invoice_date);
		tax = oku(temp_satir,73,2);
		barcode = trim(oku(temp_satir,31,20));
		amount = mid(temp_satir,52,9);//Satis miktari 9 hane ondalık 3 hane
		total = mid(temp_satir,61,12)/100;//satis tutari 12 hane ondalık 2 hane
		get_stock = f_get_stock(BARCODE : barcode, TERMINAL_TYPE : get_import.source_system);
		customer_no = '';//Musteri No
		credit_card_no = '';//Kredi Kart No				
		bill_no = mid(temp_satir,18,6);

		/* Bilgi amacli istenilirse acilir BK 20080827
		if (fusebox.circuit neq 'schedules')
			writeoutput(" +++++ #i# Barkod:#barcode# KDV : #tax# Miktar :#amount# Tutar : #total#<br/>");*/
	
		if (get_stock.recordcount) // stok kaydı bizde var ise
		{

			stock_id = get_stock.stock_id;
			product_id = get_stock.product_id; 
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
				//IS_IADE : false, iade ve iptal olayı netlestikten sonra kaldır BK 20050801
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
				STOCK_CODE : '',
				BARCODE : barcode,
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
			//Bilgi amacli istenilirse acilir BK 20080827
			/*if (fusebox.circuit neq 'schedules')
				writeoutput("Bu Ürün için Stok Kaydı YOK !!!<br/>Fiş : #i#-#j# Stok Kodu : _#stock_id#_ Barkod : _???_<br/><hr>");*/
		}
	}

	
	if(database_type is 'MSSQL') /* sadece MSSQL icin array olusup block olarak satir yazildigi icin*/
	{
		add_block_row(db_source:dsn2,row_array:add_inv_row);
		add_inv_row = ArrayNew(1);
	}
</cfscript>
