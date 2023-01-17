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
		if(listfind('1,2,18,19',trim(oku(satir,139,2)),','))
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
		get_stock = f_get_stock(STOCK_ID:0,BARCODE:barcode,TERMINAL_TYPE:-8);
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

<cfscript>
	start_time = now();
	CRLF = Chr(13)&Chr(10); // satır atlama karakteri
</cfscript>

<cfset dosya2 = ''>
<cf_get_server_file output_file="store#dir_seperator##get_import.file_name_2#" output_server="#get_import.file_server_id#" output_type="3" read_name="dosya2">
<cfset new_basket = StructNew()>
<cfset fis_satir = 0>
<cfscript>
dosya2 = ListToArray(dosya2,CRLF);
line_count = ArrayLen(dosya2);
for (i=1; i lte line_count;i++)
{
	temp_satir = dosya2[i];
	satir_tipi = val(trim(mid(temp_satir,265,2)));
	if(satir_tipi eq 18 or satir_tipi eq 19)
	{
		fis_satir = fis_satir + 1;
		new_basket[fis_satir] = StructNew();
		
		yil_ = val(trim(mid(temp_satir,6,4)));
		ay_ = val(trim(mid(temp_satir,10,2)));
		gun_ = val(trim(mid(temp_satir,12,2)));
		tarih_ = createodbcdatetime(createdate(yil_,ay_,gun_));
		view_tarih_ = dateformat(tarih_,'dd/mm/yyyy');
		belge_no_ = val(trim(mid(temp_satir,21,8)));
		belge_sira_no_ = val(trim(mid(temp_satir,14,6)));
		musteri_no_ = trim(mid(temp_satir,31,16));
		
		musteri_ = trim(mid(temp_satir,278,20));
		adres_ = trim(mid(temp_satir,537,20));
		il_ = trim(mid(temp_satir,497,20));
		ilce_ = trim(mid(temp_satir,517,20));
		musteri_email_ = trim(mid(temp_satir,557,30));
		
		fis_toplam_ = 0;
		fis_toplam_kdv_ = 0;
		
		new_basket[fis_satir].fis_toplam = fis_toplam_;
		new_basket[fis_satir].fis_toplam_kdv = fis_toplam_kdv_;
		new_basket[fis_satir].belge_turu = satir_tipi;
		new_basket[fis_satir].view_tarih = view_tarih_;
		new_basket[fis_satir].tarih = tarih_;
		new_basket[fis_satir].belge_no = belge_no_;
		new_basket[fis_satir].belge_sira_no = belge_sira_no_;
		new_basket[fis_satir].musteri_no = musteri_no_;
		
		new_basket[fis_satir].member_name = musteri_;
		new_basket[fis_satir].member_email = musteri_email_;
		new_basket[fis_satir].member_il = il_;
		new_basket[fis_satir].member_ilce = ilce_;
		new_basket[fis_satir].member_adres = adres_;
	}
}
</cfscript>
<cfset comp_id_list = "">
<cfset fatura_sayisi = StructCount(new_basket)>
<cfif fatura_sayisi gt 0>
	<cfloop from="1" to="#fatura_sayisi#" index="fatura_satir">
		
		<cfset attributes.basket_id = 18>
		<cfset tarih_ = new_basket[fatura_satir].tarih>
		<cfset control_tarih_ = tarih_>		
		<cf_date tarih="control_tarih_">	
		
		<cfquery name="get_rows" datasource="#dsn2#">
			SELECT * FROM INVOICE_ROW_POS WHERE INVOICE_ID = #attributes.invoice_id# AND BRANCH_FIS_NO = '#new_basket[fatura_satir].belge_sira_no#'
		</cfquery>
		<cfif get_rows.recordcount>
			<cfset urun_sayisi = 0>
			<cfset new_basket[fatura_satir].fatura_satirlar = StructNew()>
			
			<cfset fatura_toplam = 0>
			<cfset fatura_kdv_toplam = 0>
			<cfoutput query="get_rows">
				<cfset urun_sayisi = urun_sayisi + 1>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi] = StructNew()>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].tax = TAX>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].amount = AMOUNT>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].product_id = product_id>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].stock_id = stock_id>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].price = price>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].grosstotal = grosstotal>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].nettotal = nettotal>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].taxtotal = taxtotal>
				<cfset new_basket[fatura_satir].fis_satirlar[urun_sayisi].unit = unit>
				
				<cfset fatura_toplam = fatura_toplam + grosstotal>
				<cfset fatura_kdv_toplam = fatura_kdv_toplam + taxtotal>
			</cfoutput>
			<cfset new_basket[fatura_satir].fis_toplam = fatura_toplam>
			<cfset new_basket[fatura_satir].fis_toplam_kdv = fatura_kdv_toplam>
		</cfif>
	</cfloop>
	
	<cfquery name="get_perakende_type" datasource="#dsn3#">
		SELECT TOP 1 PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 52 AND ISNULL(IS_STOCK_ACTION,0) = 0 ORDER BY RECORD_DATE DESC
	</cfquery>
	
	<cfset kredi_kartli_faturali_satis_toplam = 0>
    <cfset kredi_kartli_faturali_satis_toplam_kdvsiz = 0>
        <cfquery name="get_cash" datasource="#dsn2#">
            SELECT
                *
            FROM
                CASH
            WHERE
                BRANCH_ID = #GET_IMPORT.BRANCH_ID#
        </cfquery>
        <cfset form.period_id = session.ep.period_id>
        <cfset form.active_period = session.ep.period_id>
        <cfset form.BASKET_RATE1 = 1>
        <cfset form.BASKET_RATE2 = 1>
        <cfset attributes.BASKET_DUE_VALUE_DATE_ = tarih_>
        <cfset form.note = "Wincor Otomatik Fatura">
        <cfset form.ACTION_DETAIL = "Wincor Otomatik Fatura">
        <cfset form.project_id = "">
        <cfset form.project_name = "">
		
        <cfset form.invoice_date = tarih_>
		<cfset form.invoice_date_h = 8>
		<cfset form.invoice_date_m = 8>
        <cfset form.invoice_cat = 52>
        <cfset form.process_cat = get_perakende_type.PROCESS_CAT_ID>
            
        <cfset form.stopaj = 0>
        <cfset form.stopaj_oran = 0>
        <cfset form.stopaj_yuzde = 0>
        <cfset form.CURRENCY_MULTIPLIER = 1>
        <cfset 'form.str_kasa_parasi#get_cash.cash_id#' = "TL"/>
        <cfset form.inventory_product_exists = 1>
        
        
        <cfset form.CASH_ACTION_TO_CONSUMER_ID = "">
        <cfset form.CASH_ACTION_FROM_CASH_ID = get_cash.cash_id>
        <cfset form.ACTION_DATE = tarih_>
        <cfset form.MONEY_TYPE = 'TL'/>
        <cfset form.PAYER_ID = session.ep.userid>
        <cfset form.ship_date = tarih_>
        
		<cfset form.department_id = GET_IMPORT.DEPARTMENT_ID>
		<cfset form.location_id = 1>
		<cfset form.branch_id = GET_IMPORT.branch_id>
        <cfset xml_import = 2>
        
        <cfquery name="get_money" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
        </cfquery>
        
        <cfloop query="get_money">
            <cfset "form.hidden_rd_money_#get_money.currentrow#" = "#GET_MONEY.MONEY#">
            <cfset "form.txt_rate1_#get_money.currentrow#" = "#GET_MONEY.RATE1#">
            <cfset "form.txt_rate2_#get_money.currentrow#" = "#GET_MONEY.RATE2#">
        </cfloop>
        <cfset form.kur_say = get_money.recordcount>
        
        <cfloop from="1" to="#fatura_sayisi#" index="fatura_satir">
			<cfset FIS_NUMARASI = new_basket[fatura_satir].belge_no>
			<cfset fis_sira_numarasi = new_basket[fatura_satir].belge_sira_no>
			<cfset musteri_no = new_basket[fatura_satir].musteri_no>
			<cfset fis_toplam = new_basket[fatura_satir].fis_toplam>
			<cfset fis_toplam_kdv = new_basket[fatura_satir].fis_toplam_kdv>
			
			<cfset form.cash = 1>
			<cfset form.cash_amount1 = tlformat(fis_toplam)>
			<cfset form.kasa1 = get_cash.cash_id>
			<cfset form.total_cash_amount = fis_toplam>
			<cfset form.diff_amount = 0>
			<cfset form.currency_type1 = 'TL'>
			<cfset form.system_cash_amount1 = fis_toplam>
			<cfset form.company_id = "">
			
			<cfquery name="get_member" datasource="#dsn#">
				SELECT TOP 1 
					COMPANY_ID,
					FULLNAME,
					MEMBER_CODE					
				FROM 
					COMPANY 
				WHERE 
					TAXNO = '#musteri_no#' AND 
					COMPANY_STATUS = 1 AND
					COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_PERIOD WHERE PERIOD_ID = #session.ep.period_id#)
			</cfquery>
			<cfif get_member.recordcount>
				<cfset form.company_id = get_member.COMPANY_ID>
				<cfset form.consumer_id = "">
				<cfset form.comp_name = "#get_member.FULLNAME#">
				<cfset form.company_name = "#get_member.FULLNAME#">
				<cfset form.MEMBER_NAME = "#get_member.FULLNAME#">
				<cfset form.MEMBER_SURNAME = "">
				<cfset form.MEMBER_CODE = get_member.MEMBER_CODE>
				<cfset form.partner_id = "">
				<cfset form.ADDRESS = "#new_basket[fatura_satir].member_adres# #new_basket[fatura_satir].member_ilce# #new_basket[fatura_satir].member_il#">
			<cfelse>
				<cfset form.member_type = 1>
				
				<cfset form.comp_member_cat = 7>
				<cfset form.company_stage = 11>
				
				<cfset uye_ = new_basket[fatura_satir].member_name>
				
				<cfif len(uye_)>
					<cfset form.comp_name = uye_>
					<cfset form.company_name = uye_>
					<cfset form.MEMBER_NAME = uye_>
					<cfset form.MEMBER_SURNAME = "">
				<cfelse>
					<cfset form.comp_name = musteri_no>
					<cfset form.company_name = musteri_no>
					<cfset form.MEMBER_NAME = musteri_no>
					<cfset form.MEMBER_SURNAME = "">
				</cfif>
				<cfset form.email  = new_basket[fatura_satir].member_email>
				<cfset form.TAX_OFFICE  = "">
				<cfset form.TAX_NUM = musteri_no>
				<cfset form.TEL_CODE = "">
				<cfset form.TEL_NUMBER = "">
				<cfset form.ADDRESS = "#new_basket[fatura_satir].member_adres# #new_basket[fatura_satir].member_ilce# #new_basket[fatura_satir].member_il#">
				<cfset form.MOBIL_CODE = "">
				<cfset form.MOBIL_TEL = "">
				<cfif len(musteri_no) eq 11>
					<cfset form.tc_num = musteri_no>
				<cfelse>
					<cfset form.tc_num = "">
				</cfif>
				<cfset form.county_id = "">
				<cfset form.city = "">
				<cfset form.MEMBER_CODE = "">
			</cfif>			
			
            <cfset form.sale_product = 1>
            
            <cfset attributes.department_id = GET_IMPORT.DEPARTMENT_ID>
            <cfset attributes.location_id = GET_IMPORT.DEPARTMENT_LOCATION>
            <cfset form.invoice_number = '#FIS_NUMARASI#'>
            <cfset form.serial_no = '#FIS_NUMARASI#'>
			<cfset form.serial_number = ''>
            
            <cfset form.basket_net_total = fis_toplam>
            <cfset form.basket_gross_total = fis_toplam - fis_toplam_kdv>
            <cfset form.basket_tax_total = fis_toplam_kdv>
            <cfset form.BASKET_DISCOUNT_TOTAL = 0>
            <cfset form.basket_otv_total = 0>
            <cfset form.yuvarlama = 0>
            <cfset form.genel_indirim = 0>
            <cfset form.DELIVER_GET_ID = session.ep.userid>
            <cfset form.DELIVER_GET = session.ep.userid>
            <cfset form.basket_money = 'TL'>
            <cfset form.basket_discount_total = 0>
            <cfset inventory_product_exists = 1>
            
              
			<cfset satirlar_ = StructCount(new_basket[fatura_satir].fis_satirlar)>
            <cfset gercek_sayi_ = 0>
            <cfloop from="1" to="#satirlar_#" index="fatura_alt_satirlar">
            	<cfset birim_adi = new_basket[fatura_satir].fis_satirlar[fatura_alt_satirlar].unit>
				<cfset stock_id = new_basket[fatura_satir].fis_satirlar[fatura_alt_satirlar].stock_id>
				<cfset miktar = new_basket[fatura_satir].fis_satirlar[fatura_alt_satirlar].amount>
				<cfset SATIR_NET_TOPLAM = new_basket[fatura_satir].fis_satirlar[fatura_alt_satirlar].nettotal>
				<cfset satir_kdv_tutar = new_basket[fatura_satir].fis_satirlar[fatura_alt_satirlar].taxtotal>
				<cfset SATIR_SON_TOPLAM = new_basket[fatura_satir].fis_satirlar[fatura_alt_satirlar].grosstotal>
				<cfset satir_kdv = new_basket[fatura_satir].fis_satirlar[fatura_alt_satirlar].tax>
				
				<cfif birim_adi is 'Metre'>
					<cfset birim_adi_ = "M">
                <cfelse>
                    <cfset birim_adi_ = birim_adi>
                </cfif>
            
                <cfset gercek_sayi_ = gercek_sayi_ + 1>
                    
				<cfquery name="get_prod" datasource="#dsn1#">
					SELECT 
						*, 
						P.PRODUCT_NAME+' '+S.PROPERTY NAME_PRODUCT,
						(SELECT UNIT_ID FROM PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = P.PRODUCT_ID AND ADD_UNIT = '#birim_adi_#') UNIT_ID
					FROM 
						PRODUCT P INNER JOIN 
						STOCKS S ON S.PRODUCT_ID = P.PRODUCT_ID 
					WHERE 
						S.STOCK_ID = #stock_id#
				</cfquery>
	
				<cfset "form.product_name#gercek_sayi_#" = "#get_prod.NAME_PRODUCT#" />
				<cfset "form.product_id#gercek_sayi_#" = "#get_prod.product_id#" />
				<cfset "form.stock_id#gercek_sayi_#" = "#get_prod.stock_id#" />
				
				<cfset "form.amount#gercek_sayi_#" = "#miktar#" />
				
				<cfset "form.unit#gercek_sayi_#" = "#birim_adi_#" />
				<cfset "form.unit_id#gercek_sayi_#" = "#get_prod.UNIT_ID#" />
				
				<cfset "form.price#gercek_sayi_#" = "#SATIR_NET_TOPLAM / MIKTAR#"/>
				
				<cfset "form.row_lasttotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM#" />
				<cfset "form.row_total#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#" />
				<cfset "form.row_otvtotal#gercek_sayi_#" = "0" />
				<cfset "form.row_nettotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#" />
				<cfset "form.row_taxtotal#gercek_sayi_#" = "#satir_kdv_tutar#" />
				<cfset "form.tax#gercek_sayi_#" = "#satir_kdv#" />
				<cfset "form.deliver_date#gercek_sayi_#" = "#tarih_#"/>
				<cfset "form.deliver_dept#gercek_sayi_#" = "#GET_IMPORT.DEPARTMENT_ID#"/>
				<cfset "form.deliver_loc#gercek_sayi_#" = "1"/>
				<cfset "form.other_money#gercek_sayi_#" = "TL"/>
				<cfset "form.other_money_#gercek_sayi_#" = "TL"/>
				<cfset "form.other_money_value_#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#"/>
				<cfset "form.price_other#gercek_sayi_#" = "#SATIR_NET_TOPLAM / MIKTAR#" />
				<cfset "form.other_money_grosstotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM#"/>
				<cfset "form.otv_oran#gercek_sayi_#" = ""/>
				<cfset "form.is_inventory#gercek_sayi_#" = "1"/>
				<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
				<cfset "form.wrk_row_id#gercek_sayi_#" = "#wrk_id#"/>
				<cfset "form.spect_id#gercek_sayi_#" = ""/>
				<cfset "form.spect_name#gercek_sayi_#" = ""/>
            </cfloop>
            <cfset attributes.rows_ = gercek_sayi_>
            <cfscript>StructAppend(attributes,form);</cfscript>
            <cfquery name="cont_" datasource="#dsn2#">
                SELECT * FROM INVOICE WHERE INVOICE_NUMBER = '#form.invoice_number#' AND INVOICE_CAT = 52 AND INVOICE_DATE = #control_tarih_#
            </cfquery>
            <cfif not cont_.recordcount>
                <cfinclude template="/V16/invoice/query/add_invoice_retail.cfm">
				
				<cfif isdefined("get_max.max_company")>
					<cfset comp_id_list = listappend(comp_id_list,get_max.max_company)>
				</cfif>
			</cfif>
        </cfloop>
    <!--- fatura --->
</cfif>