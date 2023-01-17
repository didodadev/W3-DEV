<cfscript>
	my_doc = XmlNew();
	my_doc.xmlRoot = XmlElemNew(my_doc,"PRODUCTS");

	//lisans numarası alınıyor ve belgeye ekleniyor
	get_license=cfquery(SQLString:"SELECT WORKCUBE_ID,COMPANY FROM LICENSE",is_select:1,Datasource:DSN);
	get_company=cfquery(SQLString:"SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID=#session.ep.company_id#",is_select:1,Datasource:dsn);
	get_brand_all=cfquery(SQLString:"SELECT	BRAND_ID, BRAND_NAME FROM PRODUCT_BRANDS",is_select:1,Datasource:dsn1);			
	my_doc.xmlRoot.XmlChildren[index_array] = XmlElemNew(my_doc,"PRODUCT_DESCRIPTION");
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1] = XmlElemNew(my_doc,"CREATION_SERVER_DATE");
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1].XmlText = "#dateformat(NOW(),dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,NOW()),timeformat_style)#";
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2] = XmlElemNew(my_doc,"WORKCUBE_ID");
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2].XmlText = get_license.WORKCUBE_ID;
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3] = XmlElemNew(my_doc,"SERVER_COMPANY");
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3].XmlText = get_company.NICK_NAME;
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4] = XmlElemNew(my_doc,"DESTINATION_COMPANY");
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4].XmlText = attributes.destination_company_name;
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5] = XmlElemNew(my_doc,"DESTINATION_COMPANY_ID");
	my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5].XmlText = attributes.destination_company_id;
	index_array = index_array+1;
	
	for (qry_index = 1; qry_index lte get_stocks.recordcount; qry_index =qry_index + 1)
	{
		writeoutput(qry_index&'. Ürün'&GET_STOCKS.PRODUCT_NAME[qry_index]&'<br/>');
		is_insert=0;
		if(not len(attributes.product_recorddate))attributes.product_recorddate=my_today;//tarih girilmedi ise bugun esas alinir
		if(not len(GET_STOCKS.STOCK_UPDATE_DATE[qry_index]) or DateDiff('d',GET_STOCKS.STOCK_RECORD_DATE[qry_index],attributes.product_recorddate) lte 0)//urun stoklari belirtilen tarihten sonra girildi ise is_insert=1 yani ekleme degilse 0 yani guncelleme yapacagi belirtiliyor
			is_insert=1;
			
		if(GET_STOCKS.PRODUCT_ID[qry_index] eq last_product_id) urun_tipi=0; else urun_tipi=1;
		if (attributes.price_catid gt 0)
		{
			get_price_end = get_price(unit_id :GET_STOCKS.product_unit_id[qry_index], stock_id : GET_STOCKS.stock_id[qry_index], price_catid : attributes.price_catid); // şube fiyatlarını al
			if (get_price_end.recordcount)
			{
				stock_unit = get_price_end.add_unit;							
				sales_price=get_price_end.price;
				sales_price_kdv=get_price_end.price_kdv;
				sales_price_money=get_price_end.MONEY;
			}
			else
			{
				stock_unit = GET_STOCKS.ADD_UNIT[qry_index];
				sales_price = GET_STOCKS.PRICE[qry_index];
				sales_price_kdv = GET_STOCKS.PRICE_KDV[qry_index];
				sales_price_money = GET_STOCKS.MONEY[qry_index];
			}
		}
		else
		{
			stock_unit = GET_STOCKS.ADD_UNIT[qry_index];
			sales_price = GET_STOCKS.PRICE[qry_index];
			sales_price_kdv = GET_STOCKS.PRICE_KDV[qry_index];
			sales_price_money = GET_STOCKS.MONEY[qry_index];
		}
		std_stock_unit = GET_STOCKS.ADD_UNIT[qry_index];
		std_sales_price = GET_STOCKS.PRICE[qry_index];
		std_sales_price_kdv = GET_STOCKS.PRICE_KDV[qry_index];
		std_sales_price_money = GET_STOCKS.MONEY[qry_index];
	
		kategori_uzunluk=len(GET_STOCKS.PRODUCT_CODE[qry_index]);
		urun_no_uzunluk=len(listlast(GET_STOCKS.PRODUCT_CODE[qry_index],'.'))+1;
		product_cat=left(GET_STOCKS.PRODUCT_CODE[qry_index],kategori_uzunluk-urun_no_uzunluk);
		//2. barcode numarasını almak icin
		get_barcode=cfquery(SQLString:"SELECT BARCODE,STOCK_ID FROM get_all_barcode WHERE STOCK_ID=#evaluate("GET_STOCKS.STOCK_ID[#qry_index#]")# AND BARCODE<>'#evaluate("GET_STOCKS.BARCOD[#qry_index#]")#'",dbtype:1,is_select:1,Datasource:'');
		if(len(GET_STOCKS.BRAND_ID[qry_index]))
		{
			get_brand=cfquery(SQLString:"SELECT BRAND_NAME FROM get_brand_all WHERE BRAND_ID=#evaluate('GET_STOCKS.BRAND_ID[#qry_index#]')#",dbtype:1,is_select:1,Datasource:'');
			brand_names=get_brand.BRAND_NAME;
		}
		else
		{
			brand_names='';				
		}
			
		product_name_ = GET_STOCKS.PRODUCT_NAME[qry_index];
		property_ = GET_STOCKS.PROPERTY[qry_index];
		
		my_doc.xmlRoot.XmlChildren[index_array] = XmlElemNew(my_doc,"STOCK");
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1] = XmlElemNew(my_doc,"RECORD_TYPE");//eger 1 ise kayit edilcek urun anlamında 0 sa guncelleme
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1].XmlText = is_insert;
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2] = XmlElemNew(my_doc,"PRODUCT_TYPE");// 1 ise ürün kaydedilecek 0 ise sadece stocks tablosuna ürün kaydı yapılacak(boş olabilir). urun tipi 0 olan ürün kendinden onceki 1 olan ürünün cesidi olarak kayıt edilir
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2].XmlText = urun_tipi;
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3] = XmlElemNew(my_doc,"BARCODE");//barcode
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3].XmlText = GET_STOCKS.BARCOD[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4] = XmlElemNew(my_doc,"BARCODE2");//barcode2
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4].XmlText = get_barcode.BARCODE[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5] = XmlElemNew(my_doc,"PRODUCT_NAME");//ürün adı
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5].XmlText = '#product_name_#';
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[6] = XmlElemNew(my_doc,"PRODUCT_PROPERTY");//cesit adı
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[6].XmlText = '#property_#';
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[7] = XmlElemNew(my_doc,"SALES_TAX");//satis kdv
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[7].XmlText = GET_STOCKS.TAX[qry_index];		
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[8] = XmlElemNew(my_doc,"STD_STOCK_UNIT");//stnd birim
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[8].XmlText = std_stock_unit;	
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[9] = XmlElemNew(my_doc,"STD_SALES_PRICE_KDV");//standart satis fiyat (kdvli)***
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[9].XmlText = std_sales_price_kdv;	
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[10] = XmlElemNew(my_doc,"STD_SALES_PRICE");//standart satis (kdvsiz)***
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[10].XmlText = std_sales_price;
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[11] = XmlElemNew(my_doc,"STD_SALES_PRICE_MONEY");//standart satis Money***
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[11].XmlText = std_sales_price_money;
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[12] = XmlElemNew(my_doc,"ADD_UNIT");//Ürün Birimi
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[12].XmlText = stock_unit;
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[13] = XmlElemNew(my_doc,"SALES_PRICE_KDV");//satış fiyatı (kdvli fiyat)
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[13].XmlText = sales_price_kdv;
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[14] = XmlElemNew(my_doc,"SALES_PRICE");//satış fiyatı (kdvsiz fiyat)
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[14].XmlText = sales_price;	
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[15] = XmlElemNew(my_doc,"SALES_PRICE_MONEY");//Satış Money
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[15].XmlText = sales_price_money;
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[16] = XmlElemNew(my_doc,"PRODUCT_CAT");//Kategori --PRODUCT_CATID
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[16].XmlText = product_cat;	
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[17] = XmlElemNew(my_doc,"PROD_COMPETITIVE");//Fiyat Yetkisi
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[17].XmlText = GET_STOCKS.PROD_COMPETITIVE[qry_index];	
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[18] = XmlElemNew(my_doc,"PRODUCT_STAGE");//Aşama
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[18].XmlText = GET_STOCKS.PRODUCT_STAGE[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[19] = XmlElemNew(my_doc,"PRODUCT_CODE_2");//ozel Kod
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[19].XmlText = GET_STOCKS.PRODUCT_CODE_2[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[20] = XmlElemNew(my_doc,"BRAND_NAME");//Marka ismi cunku aktarilan yerde isimle karsilastiralacak
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[20].XmlText = brand_names;
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[21] = XmlElemNew(my_doc,"PRODUCT_DETAIL");//Aciklama
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[21].XmlText = GET_STOCKS.PRODUCT_DETAIL[qry_index];
		
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[22] = XmlElemNew(my_doc,"IS_INVENTORY");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[22].XmlText = GET_STOCKS.IS_INVENTORY[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[24] = XmlElemNew(my_doc,"IS_PRODUCTION");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[24].XmlText = GET_STOCKS.IS_PRODUCTION[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[25] = XmlElemNew(my_doc,"IS_SALES");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[25].XmlText = GET_STOCKS.IS_SALES[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[26] = XmlElemNew(my_doc,"IS_PURCHASE");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[26].XmlText = GET_STOCKS.IS_PURCHASE[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[27] = XmlElemNew(my_doc,"IS_PROTOTYPE");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[27].XmlText = GET_STOCKS.IS_PROTOTYPE[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[28] = XmlElemNew(my_doc,"IS_INTERNET");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[28].XmlText = GET_STOCKS.IS_INTERNET[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[29] = XmlElemNew(my_doc,"IS_EXTRANET");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[29].XmlText = GET_STOCKS.IS_EXTRANET[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[30] = XmlElemNew(my_doc,"IS_BALANCE");//TERAZİ
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[30].XmlText = GET_STOCKS.IS_TERAZI[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[31] = XmlElemNew(my_doc,"IS_SERIAL_NO");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[31].XmlText = GET_STOCKS.IS_SERIAL_NO[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[32] = XmlElemNew(my_doc,"IS_ZERO_STOCK");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[32].XmlText = GET_STOCKS.IS_ZERO_STOCK[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[33] = XmlElemNew(my_doc,"IS_KARMA");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[33].XmlText = GET_STOCKS.IS_KARMA[qry_index];
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[34] = XmlElemNew(my_doc,"IS_COST");//
		my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[34].XmlText = GET_STOCKS.IS_COST[qry_index];
		index_array = index_array+1;
		urun_say = urun_say + 1;
		last_stock_id = GET_STOCKS.STOCK_ID[qry_index];
		last_product_id = GET_STOCKS.PRODUCT_ID[qry_index];
	}
</cfscript>
<cffile action="append" file="#upload_folder##file_name#" output="#toString(my_doc)#" charset="utf-8">
<!--- <cfsetting enablecfoutputonly="no">
<cfheader name="Content-Disposition" value="attachment;filename=#index_folder#documents#dir_seperator#product#dir_seperator##file_name#">
<cfcontent file="#index_folder#documents#dir_seperator#product#dir_seperator##file_name#" type="application/octet-stream" deletefile="no"> --->
