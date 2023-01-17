<!--- ürün kayıt tipi 0 olacaksa mutlaka dosyadaki ondan önceki kayıt tipi 1 olan ürünün onun üst ürünü olmalıdır--->
<cfsetting showdebugoutput="no">
<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cfset hata_file_name = "#CreateUUID()#.xml">
<cffile action="write" output="" addnewline="no" file="#upload_folder##hata_file_name#" charset="utf-8">
<cfquery name="GET_FILE" datasource="#dsn2#">
	SELECT
		INVOICE_ID,
		FILE_NAME,
		PRICE_CATID
	FROM
		FILE_IMPORTS
	WHERE
		I_ID = #attributes.I_ID#
</cfquery>
<cfscript>
	GET_UNIT=cfquery(SQLString:"SELECT UNIT_ID, UNIT FROM SETUP_UNIT",is_select:1,Datasource:dsn);
	if(GET_UNIT.recordcount)
	{
		unit_list=ValueList(GET_UNIT.UNIT_ID,',');
		unit_list_name=ValueList(GET_UNIT.UNIT,',');
	}
	else
	{
		unit_list='';
		unit_list_name='';
	}
	GET_BRAND=cfquery(SQLString:"SELECT BRAND_ID, BRAND_NAME FROM PRODUCT_BRANDS",is_select:1,Datasource:dsn1);
	if(GET_UNIT.recordcount)
	{
		brand_list=ValueList(GET_BRAND.BRAND_ID,',');
		brand_list_name=ValueList(GET_BRAND.BRAND_NAME,',');
	}
	else
	{
		brand_list='';
		brand_list_name='';
	}
	GET_PROD_CAT=cfquery(SQLString:"SELECT PRODUCT_CATID, HIERARCHY FROM PRODUCT_CAT",is_select:1,Datasource:dsn1);
	if(GET_PROD_CAT.recordcount)
	{
		prod_cat_list=ValueList(GET_PROD_CAT.PRODUCT_CATID,',');
		prod_cat_list_name=ValueList(GET_PROD_CAT.HIERARCHY,',');
	}
	else
	{
		prod_cat_list='';
		prod_cat_list_name='';
	}
</cfscript>

<cffile action="read" file="#upload_folder##GET_FILE.FILE_NAME#" variable="dosya" charset="utf-8"><!---charset="#attributes.file_format#"  --->
<cfscript>
	counter = 0;
	problem_counter = 0;
	pre_rec_flag = 0;//onceki satirin kayit edilip edilmedigini tutuyor cunku cesitse ana urun kayit yapilmadi ise cesitte kaydedilmemeli

	//islem uzun surmesi halinde session kaybedebillir diye bir degiskene aldik
	session_comp_id=SESSION.EP.COMPANY_ID;
	session_user_id=SESSION.EP.USERID;
	session_userkey=SESSION.EP.USERKEY;
	session_money=SESSION.EP.MONEY;
	attributes.price_catid=GET_FILE.PRICE_CATID;
	//urun no bulunuyor kayit yoksa 10000den baslatiliyor
	get_product_no=cfquery(SQLString:"SELECT MAX(PRODUCT_NO) AS URUN_NO FROM PRODUCT_NO",is_select:1,Datasource:dsn1);
	if(get_product_no.recordcount)
		attributes.URUN_NO=get_product_no.URUN_NO;
	else
		attributes.URUN_NO="10000";

	dosyam = XmlParse(dosya);
	xml_dizi = dosyam.PRODUCTS.XmlChildren;
	d_boyut = ArrayLen(xml_dizi);
	
	//LİSANS VE DOSYA BİLGİLERİ
	server_date = trim(dosyam.PRODUCTS.PRODUCT_DESCRIPTION[1].CREATION_SERVER_DATE.XmlText);
	server_id = trim(dosyam.PRODUCTS.PRODUCT_DESCRIPTION[1].WORKCUBE_ID.XmlText);
	server_company = trim(dosyam.PRODUCTS.PRODUCT_DESCRIPTION[1].SERVER_COMPANY.XmlText);
	destination_company = trim(dosyam.PRODUCTS.PRODUCT_DESCRIPTION[1].DESTINATION_COMPANY.XmlText);
	destination_company_id = trim(dosyam.PRODUCTS.PRODUCT_DESCRIPTION[1].DESTINATION_COMPANY_ID.XmlText);
	
	//hatalı satırları yazmak için yeni xml dosyası
	hata_index = 1;
	my_doc = XmlNew();
	my_doc.xmlRoot = XmlElemNew(my_doc,"PRODUCTS");
	my_doc.xmlRoot.XmlChildren[hata_index] = XmlElemNew(my_doc,"PRODUCT_DESCRIPTION");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[1] = XmlElemNew(my_doc,"CREATION_SERVER_DATE");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[1].XmlText = "#dateformat(NOW(),dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,NOW()),timeformat_style)#";
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[2] = XmlElemNew(my_doc,"WORKCUBE_ID");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[2].XmlText = server_id;
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[3] = XmlElemNew(my_doc,"SERVER_COMPANY");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[3].XmlText = server_company;
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[4] = XmlElemNew(my_doc,"DESTINATION_COMPANY");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[4].XmlText = destination_company;
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[5] = XmlElemNew(my_doc,"DESTINATION_COMPANY_ID");
	my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[5].XmlText = destination_company_id;
	hata_index = hata_index+1;
</cfscript>
<!--- belge formati kontorlu icin  --->
<cfif not len(server_date) eq 16 and not isdate(server_date)>
	<script type="text/javascript">
		alert('Dosya Formatı hatalı. Dosyanın doğru olduğundan emin olun');
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cfset server_date=CreateODBCDateTime(server_date)>
</cfif>
<table>
	<tr><td colspan="3" align="center">Import Sonuç</td></tr>
	<tr><td width="15">Satır</td><td width="75">Barcode</td><td>Hata</td></tr>
<cfloop index="i" from="1" to="#d_boyut-1#">
	<cftry>
		<cfscript>
            error_flag = 0;
            barcode_no_list="";
			counter = counter + 1;
			
		 	record_type = dosyam.PRODUCTS.STOCK[i].RECORD_TYPE.XmlText;
			if(not len(record_type)) record_type=1;
			product_type = dosyam.PRODUCTS.STOCK[i].PRODUCT_TYPE.XmlText;
			if(not len(product_type)) product_type=1;
			
			if(product_type eq 1) pre_rec_flag=0;//urun cesit degilse onceki urun kayit edilip edilmedigi degeri 0 laniyor
			if(pre_rec_flag eq 0)//ana urunu kaydedilmis ise diger islemleri yapsin
			{
				barcode = trim(dosyam.PRODUCTS.STOCK[i].BARCODE.XmlText);
				barcode2 = trim(dosyam.PRODUCTS.STOCK[i].BARCODE2.XmlText);
				barcode_no_list = ListAppend(barcode_no_list,barcode,',');
				barcode_no_list = ListAppend(barcode_no_list,barcode2,',');
				product_name = trim(dosyam.PRODUCTS.STOCK[i].PRODUCT_NAME.XmlText);
				product_property = trim(dosyam.PRODUCTS.STOCK[i].PRODUCT_PROPERTY.XmlText);
				sales_tax = dosyam.PRODUCTS.STOCK[i].SALES_TAX.XmlText;
				std_stock_unit = dosyam.PRODUCTS.STOCK[i].STD_STOCK_UNIT.XmlText;
				std_sales_price_kdv = dosyam.PRODUCTS.STOCK[i].STD_SALES_PRICE_KDV.XmlText;
				std_sales_price = dosyam.PRODUCTS.STOCK[i].STD_SALES_PRICE.XmlText;
				std_sales_price_money = dosyam.PRODUCTS.STOCK[i].STD_SALES_PRICE_MONEY.XmlText;
				add_unit = dosyam.PRODUCTS.STOCK[i].ADD_UNIT.XmlText;
				sales_price_kdv = dosyam.PRODUCTS.STOCK[i].SALES_PRICE_KDV.XmlText;
				sales_price = dosyam.PRODUCTS.STOCK[i].SALES_PRICE.XmlText;
				sales_price_money = dosyam.PRODUCTS.STOCK[i].SALES_PRICE_MONEY.XmlText;
				product_cat = dosyam.PRODUCTS.STOCK[i].PRODUCT_CAT.XmlText;
				prod_competitive = dosyam.PRODUCTS.STOCK[i].PROD_COMPETITIVE.XmlText;
				product_stage = dosyam.PRODUCTS.STOCK[i].PRODUCT_STAGE.XmlText;
				product_code_2 = dosyam.PRODUCTS.STOCK[i].PRODUCT_CODE_2.XmlText;
				brand_name = trim(dosyam.PRODUCTS.STOCK[i].BRAND_NAME.XmlText);
				product_detail = left(dosyam.PRODUCTS.STOCK[i].PRODUCT_DETAIL.XmlText,255);
				
				is_inventory = dosyam.PRODUCTS.STOCK[i].IS_INVENTORY.XmlText;
				inventory_calc_type = dosyam.PRODUCTS.STOCK[i].INVENTORY_CALC_TYPE.XmlText;
				is_production = dosyam.PRODUCTS.STOCK[i].IS_PRODUCTION.XmlText;
				is_sales = dosyam.PRODUCTS.STOCK[i].IS_SALES.XmlText;
				is_purchase = dosyam.PRODUCTS.STOCK[i].IS_PURCHASE.XmlText;
				is_prototype = dosyam.PRODUCTS.STOCK[i].IS_PROTOTYPE.XmlText;
				is_internet = dosyam.PRODUCTS.STOCK[i].IS_INTERNET.XmlText;
				is_extranet = dosyam.PRODUCTS.STOCK[i].IS_EXTRANET.XmlText;
				is_terazi = dosyam.PRODUCTS.STOCK[i].IS_BALANCE.XmlText;
				is_serial_no = dosyam.PRODUCTS.STOCK[i].IS_SERIAL_NO.XmlText;
				is_zero_stock = dosyam.PRODUCTS.STOCK[i].IS_ZERO_STOCK.XmlText;
				is_karma = dosyam.PRODUCTS.STOCK[i].IS_KARMA.XmlText;			
				is_cost = dosyam.PRODUCTS.STOCK[i].IS_COST.XmlText;
			}else{
				error_flag=1;
				problem_counter =problem_counter+ 1;
			}
        </cfscript>
         <cfcatch type="Any">
			<tr><cfoutput><td>#i#</td><td><!--- #barcode# ---></td></cfoutput><td>okuma sırasında hata oldu</td></tr>
			<cfset error_flag = 1>
			<cfset problem_counter =problem_counter+ 1>
			<cfset pre_rec_flag = 1>
		</cfcatch>
	</cftry>
    <cfif error_flag neq 1>
		<cfif len(product_name) and (product_type eq 1 or (product_type eq 0 and pre_rec_flag eq 0))><!--- urun ana urunse ismide varsa kayit atilir ancak cesit se ve ana urunu kaydedilmedi ise cesit de kaydedilmez --->
            <cfscript>
            error_flag=0;
            if(record_type eq 1)
            {
                //barkod no_1 varmı
                if(len(barcode) gt 0)
                {
                    check_same=cfquery(SQLString:"SELECT BARCODE FROM STOCKS_BARCODES WHERE BARCODE = '#barcode#'",is_select:1,Datasource:dsn1);
                    if(check_same.recordcount)
                    {
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>1. barcod var </td><tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                    }
                }	
                //barkod no_2 varmı
                if(error_flag eq 0 and len(barcode2) gt 0 and listlen(barcode_no_list,',') eq 2)
                {
                    check_same2=cfquery(SQLString:"SELECT BARCODE FROM STOCKS_BARCODES WHERE BARCODE = '#barcode2#'",is_select:1,Datasource:dsn1);
                    if(check_same2.recordcount)
                    {
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode2&'</td><td>2. barcod var </td><tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                    }
                }
                //urun adi kontrolu
                if(error_flag eq 0 and len(product_name) and product_type is 1)
                {
                    check_same3=cfquery(SQLString:"SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = '#product_name#'",is_select:1,Datasource:dsn1);
                    if(check_same3.recordcount)
                    {
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>Ürün Adı var </td><tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                    }
                }
            }else
            {	//GUNCELLEME YAPILACAKSA
                //barkod no_1 varmı
                if(len(barcode) gt 0)
                {
                    check_same=cfquery(SQLString:"SELECT STOCK_ID,BARCODE,UNIT_ID FROM STOCKS_BARCODES WHERE BARCODE = '#barcode#'",is_select:1,Datasource:dsn1);
                    if(check_same.recordcount eq 0)
                    {
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>ürün bulunamadı </td></tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                    }else
                    {
                        upd_stock_id=check_same.STOCK_ID;
                    }
                }
                //barkod no_2 başka bir üründe varmı eşitti stock id farklı yaptım düşünülecek neden öyleymiş----------------
                if(error_flag eq 0 and len(barcode2) gt 0 and listlen(barcode_no_list,',') eq 2)
                {
                    check_same2=cfquery(SQLString:"SELECT STOCK_ID,BARCODE,UNIT_ID FROM STOCKS_BARCODES WHERE BARCODE = '#barcode#' AND STOCK_ID<>#upd_stock_id#",is_select:1,Datasource:dsn1);
                    if(check_same2.recordcount)
                    {
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>2. barcod başka bir üründe kullanılmış </td><tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                    }
                }
                
            }
            //std_birim adi kontrolu
            if(error_flag eq 0)
            {
                if(len(std_stock_unit))
                {
                    yer=ListFindNoCase(unit_list_name,std_stock_unit,',');
                    if(yer gt 0)
                    {
                        std_unit_name=listgetat(unit_list_name,yer,',');
                        std_unit_id=listgetat(unit_list,yer,',');
                    }else
                    {
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> birim kaydı yok </td><tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                    }
                }else{
                    writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> ürün birimi yok </td><tr>');
                    error_flag = 1;
                    pre_rec_flag = 1;
                    problem_counter =problem_counter + 1;
                }
            }
            //2. birim adi kontrolu
            if(error_flag eq 0)
            {
                if(len(add_unit))
                {
                    if(std_stock_unit neq add_unit)
                    {
                        yer=ListFindNoCase(unit_list_name,add_unit,',');
                        if(yer gt 0)
                        {
                            unit_name=listgetat(unit_list_name,yer,',');
                            unit_id=listgetat(unit_list,yer,',');
                        }else
                        {
                            writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> ürünün fiyat birim kaydı yok </td><tr>');
                            error_flag = 1;
                            pre_rec_flag = 1;
                            problem_counter =problem_counter + 1;
                        }
                    }else{
                        unit_name=std_unit_name;
                        unit_id=std_unit_id;
                    }
                }else{
                    writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>  ürünün fiyat birimi yok </td><tr>');
                    error_flag = 1;
                    pre_rec_flag = 1;
                    problem_counter =problem_counter + 1;
                }
            }
                    
            //marka adi kontrolu
            if(error_flag eq 0)
            {
                if(len(brand_name))
                {
                    yer=ListFindNoCase(brand_list_name,brand_name,',');
                    if(yer gt 0)
                    {
                        brand_name=listgetat(brand_list_name,yer,',');
                        brand_id=listgetat(brand_list,yer,',');
                    }else
                    {
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>  marka kaydı yok </td><tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                    }
                }else{
                    brand_name='';
                    brand_id='';
                }
            }
            //kategori kontrolu
            if(error_flag eq 0)
            {
                if(len(product_cat))
                {
                    yer=ListFindNoCase(prod_cat_list_name,product_cat,',');
                    if(yer gt 0)
                    {
                        kategori_hier=listgetat(prod_cat_list_name,yer,',');
                        kategori_id=listgetat(prod_cat_list,yer,',');
                    }else
                    {
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> kategori kaydı yok </td><tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                    }
                }else{
                        writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> kategorisi yok </td><tr>');
                        error_flag = 1;
                        pre_rec_flag = 1;
                        problem_counter =problem_counter + 1;
                }
            }
            </cfscript>
            
			<cfif error_flag neq 1>
                <cftry>
                <!---kayıt tipine göre kayıt işleimi çalışıyor---->
                    <cfif len(std_stock_unit) and len(product_name)>
                        <cfif product_type is 1><!--- ana urun kaydi ise --->
                            <cfset bugun_00 = DateFormat(now(),dateformat_style)>
                            <cf_date tarih='bugun_00'>			
    
                            <cfset attributes.URUN_NO=attributes.URUN_NO+1>					
                            <!--- urun kodu olusturuluyor --->
                            <cfset attributes.PRODUCT_CODE=kategori_hier&"."&attributes.URUN_NO>
                            <cfif record_type eq 1><!--- insert islemi ise kayit islemi yapiliyor --->
                                <cfquery name="add_product" datasource="#dsn1#">
                                    INSERT INTO
                                        PRODUCT
                                    (
                                        PRODUCT_STATUS,
                                        PRODUCT_CATID,
                                        PRODUCT_CODE,
                                        BARCOD,
                                        PRODUCT_NAME,
                                        PRODUCT_DETAIL,
                                        TAX,
                                        TAX_PURCHASE,
                                        PRODUCT_STAGE,
                                        IS_INVENTORY,
                                        IS_PRODUCTION,
                                        IS_SALES,
                                        IS_PURCHASE,
                                        IS_PROTOTYPE,
                                        IS_INTERNET,
                                        IS_EXTRANET,
                                        IS_TERAZI,
                                        IS_SERIAL_NO,
                                        IS_ZERO_STOCK,
                                        IS_KARMA,		
                                        IS_COST,
                                        RECORD_DATE,
                                        RECORD_MEMBER,
                                        MEMBER_TYPE,
                                        PROD_COMPETITIVE,
                                        MANUFACT_CODE,
                                        BRAND_ID,
                                        PRODUCT_CODE_2
                                    )
                                    VALUES
                                    (
                                        1,
                                        #kategori_id#,
                                        '#attributes.PRODUCT_CODE#',
                                        '#barcode#',
                                        '#product_name#',
                                        '#product_detail#',
                                        #sales_tax#,
                                        0,
										<cfif len(product_stage)>#product_stage#<cfelse>1</cfif>,
										<cfif len(is_inventory)>#is_inventory#<cfelse>0</cfif>,
										<cfif len(is_production)>#is_production#<cfelse>0</cfif>,
                                        <cfif len(is_sales)>#is_sales#<cfelse>0</cfif>,
                                        <cfif len(is_purchase)>#is_purchase#<cfelse>0</cfif>,
                                        <cfif len(is_prototype)>#is_prototype#<cfelse>0</cfif>,
                                        <cfif len(is_internet)>#is_internet#<cfelse>0</cfif>,
                                        <cfif len(is_extranet)>#is_extranet#<cfelse>0</cfif>,
                                        <cfif len(is_terazi)>#is_terazi#<cfelse>0</cfif>,
                                        <cfif len(is_serial_no)>#is_serial_no#<cfelse>0</cfif>,
                                        <cfif len(is_zero_stock)>#is_zero_stock#<cfelse>0</cfif>,
                                        <cfif len(is_karma)>#is_karma#<cfelse>0</cfif>,
                                        <cfif len(is_cost)>#is_cost#<cfelse>0</cfif>,
                                        #NOW()#,
                                        #session_user_id#,
                                        '#session_userkey#',
                                        <cfif len(prod_competitive)>#prod_competitive#<cfelse>1</cfif>,
                                        NULL,
                                        <cfif len(brand_id)>#brand_id#<cfelse>NULL</cfif>,
                                        <cfif len(product_code_2)>'#product_code_2#'<cfelse>NULL</cfif>
                                    )
                                </cfquery>
                                <cfquery name="GET_PID" datasource="#dsn1#">
                                    SELECT MAX(PRODUCT_ID) AS PRODUCT_ID FROM PRODUCT
                                </cfquery>
                            <cfelse><!--- kayit tipi 0 ise guncelleme --->
                                <cfquery name="GET_PID" datasource="#dsn1#" maxrows="1">
                                    SELECT PRODUCT_ID,STOCKS.STOCK_ID FROM STOCKS,STOCKS_BARCODES WHERE STOCKS.STOCK_ID=STOCKS_BARCODES.STOCK_ID AND BARCODE='#barcode#'
                                </cfquery>
                                <cfquery name="add_product" datasource="#dsn1#">
                                    UPDATE PRODUCT SET
                                        PRODUCT_CATID=#kategori_id#,
                                        PRODUCT_CODE='#attributes.PRODUCT_CODE#',
                                        BARCOD='#barcode#',
                                        PRODUCT_NAME='#product_name#',
                                        PRODUCT_DETAIL='#product_detail#',
                                        TAX=#sales_tax#,
                                        TAX_PURCHASE=0,
                                        IS_INVENTORY=<cfif len(barcode)>1<cfelse>0</cfif>,
                                        IS_PRODUCTION=0,
                                        IS_SALES=1,
                                        IS_PURCHASE=1,
                                        IS_PROTOTYPE=0,
                                        IS_INTERNET=0,
                                        PRODUCT_STAGE=<cfif len(product_stage)>#product_stage#<cfelse>1</cfif>,
                                        IS_TERAZI=<cfif std_stock_unit is "KG">1,<cfelse>0,</cfif>
                                        IS_SERIAL_NO=0,
                                        IS_ZERO_STOCK=1,
                                        IS_KARMA=0,
                                        UPDATE_DATE=#NOW()#,
                                        UPDATE_IP='#cgi.REMOTE_ADDR#',
                                        UPDATE_EMP=#session_user_id#,
                                        PROD_COMPETITIVE=<cfif len(prod_competitive)>#prod_competitive#<cfelse>1</cfif>,
                                        BRAND_ID=<cfif len(brand_id)>#brand_id#<cfelse>NULL</cfif>,
                                        PRODUCT_CODE_2=<cfif len(product_code_2)>'#product_code_2#'<cfelse>NULL</cfif>
                                    WHERE
                                        PRODUCT_ID=#GET_PID.PRODUCT_ID#
                                </cfquery>
                            </cfif>
    
                            <!--- ürünün unit kaydı--->
                            <cfif record_type eq 1>
                                <cfquery name="ADD_MAIN_UNIT" datasource="#dsn1#">
                                    INSERT INTO
                                        PRODUCT_UNIT 
                                        (
                                            PRODUCT_ID, 
                                            PRODUCT_UNIT_STATUS, 
                                            MAIN_UNIT_ID, 
                                            MAIN_UNIT, 
                                            UNIT_ID,
                                            ADD_UNIT,
                                            DIMENTION,
                                            WEIGHT,
                                            IS_MAIN,
                                            RECORD_EMP,
                                            RECORD_DATE
                                        )
                                    VALUES 
                                        (
                                            #GET_PID.PRODUCT_ID#,
                                            1,
                                            #std_unit_id#,
                                            '#std_unit_name#',
                                            #std_unit_id#,
                                            '#std_unit_name#',
                                            '',
                                            '',
                                            1,
                  							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                  							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                        )
                             	</cfquery>
                                <cfquery name="GET_MAX_UNIT" datasource="#dsn1#">
                                    SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM PRODUCT_UNIT
                                </cfquery>
                            <cfelse>
                                <cfquery name="GET_MAX_UNIT" datasource="#dsn1#">
                                    SELECT PRODUCT_UNIT_ID MAX_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID=#GET_PID.PRODUCT_ID# AND IS_MAIN=1
                                </cfquery>
								<cfquery name="add_product" datasource="#dsn1#">
                                    UPDATE 
                                        PRODUCT_UNIT 
                                    SET
                                        PRODUCT_UNIT_STATUS=1, 
                                        MAIN_UNIT_ID=#std_unit_id#,
                                        MAIN_UNIT='#std_unit_name#',
                                        UNIT_ID=#std_unit_id#,
                                        ADD_UNIT='#std_unit_name#',
                                        DIMENTION='',
                                        WEIGHT='',
                    					UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    					UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                    WHERE
                                        PRODUCT_UNIT_ID=#GET_MAX_UNIT.MAX_UNIT#
                               </cfquery>
                            </cfif>
                            <!--- ürünün unit kaydı--->	
                            
                            <!---alış fiyatı--->
                            <cfset purchase_price = sales_price><!--- secilen fiyat listedindeki fiyat hedef server daki alis fiyattir --->
                            <cfset purchase_price_kdv = sales_price_kdv>
                            <cfset purchase_price_money = sales_price_money>
                            <cfset is_kdv=1>
                            <cfif record_type eq 0><!--- kayit guncelleme ise o gun eklenen baska fiyat varsa silinir sonrada actif olan satir pasif yapilir --->
                                <cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#dsn1#">
                                    DELETE FROM
                                        PRICE_STANDART
                                    WHERE
                                        PRODUCT_ID = #GET_PID.PRODUCT_ID# AND
                                        <!--- PURCHASESALES = 1 AND --->
                                        UNIT_ID = #GET_MAX_UNIT.MAX_UNIT# AND
                                        START_DATE = #bugun_00#		
                                </cfquery>
                                <cfquery name="STD_PRICE_PAS" datasource="#dsn1#">
                                    UPDATE 
                                        PRICE_STANDART
                                    SET 
                                        PRICESTANDART_STATUS = 0,
                                        RECORD_EMP=#SESSION.EP.USERID#
                                    WHERE 
                                        PRODUCT_ID = #GET_PID.PRODUCT_ID# AND 
                                        <!--- PURCHASESALES = 1 AND --->
                                        UNIT_ID = #GET_MAX_UNIT.MAX_UNIT# AND
                                        PRICESTANDART_STATUS = 1
								</cfquery>
                            </cfif>
                            <cfquery name="ADD_STD_PRICE" datasource="#dsn1#">
                                INSERT INTO PRICE_STANDART
                                (
                                    PRODUCT_ID, 
                                    PURCHASESALES, 
                                    PRICE, 
                                    PRICE_KDV,
                                    IS_KDV,
                                    ROUNDING,
                                    MONEY,
                                    START_DATE,
                                    RECORD_DATE,
                                    PRICESTANDART_STATUS,
                                    UNIT_ID,
                                    RECORD_EMP
                                )
                                VALUES
                                (
                                    #GET_PID.PRODUCT_ID#,
                                    0,
                                    <cfif not IsNumeric(purchase_price)>0<cfelse>#purchase_price#</cfif>,
                                    <cfif not isnumeric(purchase_price_kdv)>0<cfelse>#purchase_price_kdv#</cfif>,
                                    #is_kdv#,
                                    0,
                                    <cfif len(purchase_price_money)>'#purchase_price_money#'<cfelse>'#session_money#'</cfif>,
                                    #bugun_00#,
                                    #NOW()#,
                                    1,
                                    #GET_MAX_UNIT.MAX_UNIT#,
                                    #session_user_id#
                                )
                            </cfquery>
                            <!---satış fiyatı--->
                            <cfquery name="ADD_STD_PRICE" datasource="#dsn1#">
                                INSERT INTO PRICE_STANDART
                                (
                                    PRODUCT_ID, 
                                    PURCHASESALES, 
                                    PRICE,
                                    PRICE_KDV,
                                    IS_KDV,
                                    ROUNDING,
                                    MONEY,
                                    START_DATE,
                                    RECORD_DATE,
                                    PRICESTANDART_STATUS,
                                    UNIT_ID,
                                    RECORD_EMP
                                )
                                VALUES
                                (
                                    #GET_PID.PRODUCT_ID#,
                                    1,
                                    <cfif not IsNumeric(std_sales_price)>0<cfelse>#std_sales_price#</cfif>,
                                    <cfif not isnumeric(std_sales_price_kdv)>0<cfelse>#std_sales_price_kdv#</cfif>,
                                    1,
                                    0,
                                    <cfif len(std_sales_price_money)>'#std_sales_price_money#'<cfelse>'#session_money#'</cfif>,
                                    #bugun_00#,
                                    #NOW()#,
                                    1,
                                    #GET_MAX_UNIT.MAX_UNIT#,
                                    #session_user_id#
                                )
                            </cfquery>
                            <!---satış fiyatı--->
                            <cfif attributes.price_catid neq -2>
                                <!--- ürünün unit kaydı--->
                                <cfif record_type eq 1>
                                    <cfquery name="ADD_MAIN_UNIT" datasource="#dsn1#">
                                        INSERT INTO
                                            PRODUCT_UNIT 
                                            (
                                                PRODUCT_ID, 
                                                PRODUCT_UNIT_STATUS, 
                                                MAIN_UNIT_ID, 
                                                MAIN_UNIT, 
                                                UNIT_ID,
                                                ADD_UNIT,
                                                DIMENTION,
                                                WEIGHT,
                                                IS_MAIN,
                                                RECORD_EMP,
                                                RECORD_DATE
                                            )
                                        VALUES 
                                            (
                                                #GET_PID.PRODUCT_ID#,
                                                1,
                                                #std_unit_id#,
                                                '#std_unit_name#',
                                                #unit_id#,
                                                '#unit_name#',
                                                '',
                                                '',
                                                0,
                 								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                  								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                            )
                                      </cfquery>
                                    <cfquery name="GET_MAX_UNIT_2" datasource="#dsn1#">
                                        SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM PRODUCT_UNIT
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="GET_MAX_UNIT_2" datasource="#dsn1#">
                                        SELECT PRODUCT_UNIT_ID MAX_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID=#GET_PID.PRODUCT_ID# AND MAIN_UNIT='#std_unit_name#' AND UNIT_ID=#unit_id#
                                    </cfquery>
                                    <cfif GET_MAX_UNIT_2.recordcount>
                                        <cfquery name="add_product" datasource="#dsn1#">
                                            UPDATE 
                                                PRODUCT_UNIT 
                                            SET
                                                PRODUCT_UNIT_STATUS=1, 
                                                MAIN_UNIT_ID=#std_unit_id#,
                                                MAIN_UNIT='#std_unit_name#',
                                                UNIT_ID=#unit_id#,
                                                ADD_UNIT='#unit_name#',
                   								UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    							UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                            WHERE
                                                PRODUCT_UNIT_ID=#GET_MAX_UNIT_2.MAX_UNIT#
                                       </cfquery>
                                    <cfelse>
										<cfquery name="ADD_MAIN_UNIT" datasource="#dsn1#">
                                            INSERT INTO
                                                PRODUCT_UNIT 
                                                (
                                                    PRODUCT_ID, 
                                                    PRODUCT_UNIT_STATUS, 
                                                    MAIN_UNIT_ID, 
                                                    MAIN_UNIT, 
                                                    UNIT_ID,
                                                    ADD_UNIT,
                                                    DIMENTION,
                                                    WEIGHT,
                                                    IS_MAIN,
                  									RECORD_EMP,
                  									RECORD_DATE
                                                )
                                            VALUES
                                                (
                                                    #GET_PID.PRODUCT_ID#,
                                                    1,
                                                    #std_unit_id#,
                                                    '#std_unit_name#',
                                                    #unit_id#,
                                                    '#unit_name#',
                                                    '',
                                                    '',
                                                    0,
                  									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                  									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                                )
                                        </cfquery>
                                        <cfquery name="GET_MAX_UNIT_2" datasource="#dsn1#">
                                            SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM PRODUCT_UNIT
                                        </cfquery>
                                    </cfif>
                                </cfif>
                                <!--- ürünün unit kaydı--->
                                <!--- importa secilen  fiyat listesine std fiyat atiliyor cunku satis fiyat olarak o var--->
                                <cfquery datasource="#dsn3#" name="new_price_add_method" timeout="300">
                                    exec add_price
                                        #GET_PID.PRODUCT_ID#,
                                        #GET_MAX_UNIT_2.MAX_UNIT#,
                                        #attributes.price_catid#,
                                        #bugun_00#,
                                        #std_sales_price#,<!--- #satis_fiyat_kdvsiz#, --->
                                        <cfif len(std_sales_price_money)>'#std_sales_price_money#'<cfelse>'#session_money#'</cfif>,
                                        1,
                                        #std_sales_price_kdv#,<!--- #satis_fiyat_kdvli#, --->
                                        -1,
                                        #session_user_id#,
                                        '#cgi.remote_addr#',
                                        0,
										0,
										0										
								</cfquery>
                            </cfif>
                            
                            <!--- stok --->
                            <cfif record_type eq 1>
                                <cfquery name="ADD_STOCKS" datasource="#dsn1#">
                                    INSERT INTO STOCKS
                                    (
                                        STOCK_CODE,
                                        PRODUCT_ID,
                                        PROPERTY,
                                        BARCOD,					
                                        PRODUCT_UNIT_ID,
                                        STOCK_STATUS,
                                        MANUFACT_CODE,
                                        RECORD_EMP, RECORD_IP, RECORD_DATE
                                    )
                                    VALUES
                                    (
                                        '#attributes.PRODUCT_CODE#',
                                        #GET_PID.PRODUCT_ID#,
                                        '#product_property#',
                                        '#barcode#',
                                        #GET_MAX_UNIT.MAX_UNIT#,
                                        1,
                                        '',
                                        #session_user_id#, '#REMOTE_ADDR#', #now()#
                                    )
                                </cfquery>
                                <!---stok kaydı id si--->
                                <cfquery name="GET_MAX_STCK" datasource="#dsn1#">
                                    SELECT MAX(STOCK_ID) AS MAX_STCK FROM STOCKS
                                </cfquery>
                                <!---stok kaydı id si--->
                            <cfelse>
                                <cfquery name="ADD_STOCKS" datasource="#dsn1#">
                                    UPDATE STOCKS SET
                                        STOCK_CODE='#attributes.PRODUCT_CODE#',
                                        PRODUCT_ID=#GET_PID.PRODUCT_ID#,
                                        PROPERTY='#product_property#',
                                        BARCOD='#barcode#',					
                                        PRODUCT_UNIT_ID=#GET_MAX_UNIT.MAX_UNIT#,
                                        STOCK_STATUS=1,
                                        MANUFACT_CODE='',
                                        UPDATE_EMP=#session_user_id#,
                                        UPDATE_IP='#REMOTE_ADDR#',
                                        UPDATE_DATE=#now()#
                                    WHERE
                                        STOCK_ID=#GET_PID.STOCK_ID#
                                </cfquery>
                                <cfset GET_MAX_STCK.MAX_STCK=GET_PID.STOCK_ID>
                            </cfif>
                            <!--- stok --->
                            
                            <cfif record_type eq 1>
                                <cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#dsn1#">
                                    INSERT INTO PRODUCT_OUR_COMPANY
                                    (
                                        PRODUCT_ID,
                                        OUR_COMPANY_ID
                                    )
                                    VALUES
                                    (
                                        #GET_PID.PRODUCT_ID#,
                                        #session_comp_id#
                                    )
                                </cfquery>
                            </cfif>
                            <cfif record_type eq 1>
                                <!---stok row--->
                                <cfquery name="get_my_periods" datasource="#dsn#">
                                    SELECT
                                        *
                                    FROM
                                        SETUP_PERIOD
                                    WHERE
                                        OUR_COMPANY_ID = #session_comp_id#
                                </cfquery>
                                <cfloop query="get_my_periods">
                                    <cfif database_type is "MSSQL">
                                        <cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#session_comp_id#">
                                    <cfelseif database_type is "DB2">
                                        <cfset temp_dsn = "#dsn#_#session_comp_id#_#right(period_year,2)#">
                                    </cfif>
                                
									<cfquery name="INSRT_STK_ROW" datasource="#temp_dsn#">
                                        INSERT INTO 
                                            STOCKS_ROW 
                                            (
                                                STOCK_ID,
                                                PRODUCT_ID
                                            )
                                        VALUES 
                                            (
                                                #GET_MAX_STCK.MAX_STCK#,
                                                #GET_PID.PRODUCT_ID#
                                            )
                                    </cfquery>
                                </cfloop>  
                                <!---stok row--->
                            </cfif>
    
                            <cfquery name="GET_STOCK_BARCODE" datasource="#dsn1#">
                                SELECT BARCODE FROM STOCKS_BARCODES WHERE BARCODE = '#barcode#'
                            </cfquery>
                            <cfif GET_STOCK_BARCODE.recordcount eq 0><!--- urunun boyle bir barcod yoksa kaydet --->
                                <cfquery name="ADD_STOCK_CODE" datasource="#dsn1#">
                                    INSERT INTO 
                                        STOCKS_BARCODES
                                        (
                                            STOCK_ID,
                                            BARCODE,
                                            UNIT_ID
                                        )
                                    VALUES 
                                        (
                                            #GET_MAX_STCK.MAX_STCK#,
                                            '#barcode#',
                                            #GET_MAX_UNIT.MAX_UNIT#
                                        )
                                </cfquery>
                            </cfif>
                            <cfset attributes.pid = GET_PID.PRODUCT_ID>
                            <cfset attributes.pcode = attributes.PRODUCT_CODE>
                        
                        <cfelseif product_type is 0 and isdefined("attributes.pid") and len(attributes.pid)><!--- cesit ise ve onceki ana urun kaydi yapilmis ve attributes.pid degeri gelmis ise--->
                        
                            <cfquery name="stock_count" datasource="#dsn1#">
                                SELECT STOCK_ID	FROM STOCKS WHERE PRODUCT_ID = #ATTRIBUTES.PID#
                            </cfquery>
                            <cfset new_stock_code = '#attributes.pcode#.#stock_count.recordcount+1#'>
                            
                            <cfquery name="GET_UNIT" datasource="#dsn1#">
                                SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE ADD_UNIT = '#add_unit#' AND PRODUCT_ID = #attributes.pid# 
                            </cfquery>
                            
                            <cfif GET_UNIT.RecordCount>
                                <cfif record_type eq 1><!--- insert ise --->
                                    <cfquery name="ADD_STOCK_CODE" datasource="#dsn1#">
                                        INSERT INTO 
                                            STOCKS 
                                            (
                                                STOCK_CODE,
                                                PRODUCT_ID,
                                                PROPERTY,
                                                BARCOD,
                                                PRODUCT_UNIT_ID,
                                                MANUFACT_CODE,
                                                STOCK_STATUS,
                                                RECORD_EMP, RECORD_IP, RECORD_DATE
                                            )
                                        VALUES 
                                            (
                                                '#trim(new_stock_code)#',
                                                #attributes.pid#,
                                                '#product_property#',
                                                '#barcode#',
                                                #GET_UNIT.PRODUCT_UNIT_ID#,
                                                '',
                                                1,
                                                #session_user_id#, '#REMOTE_ADDR#', #now()#
                                            )
                                    </cfquery>
                                    
                                    <cfquery name="GET_MAX_STOCK" datasource="#dsn1#">
                                        SELECT MAX(STOCK_ID) AS MAX_STOCK FROM STOCKS
                                    </cfquery>
                                
                                    <cfquery name="get_my_periods" datasource="#dsn#">
                                        SELECT
                                            *
                                        FROM
                                            SETUP_PERIOD
                                        WHERE
                                            OUR_COMPANY_ID IN (SELECT OUR_COMPANY_ID FROM #dsn1_alias#.PRODUCT_OUR_COMPANY WHERE PRODUCT_ID = #attributes.pid#)
                                    </cfquery>
                                    <cfloop query="get_my_periods">
                                        <cfif database_type is "MSSQL">
                                            <cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#OUR_COMPANY_ID#">
                                        <cfelseif database_type is "DB2">
                                            <cfset temp_dsn = "#dsn#_#OUR_COMPANY_ID#_#right(period_year,2)#">
                                        </cfif>
                                
                                        <cfquery name="INSRT_STK_ROW" datasource="#temp_dsn#">
                                            INSERT INTO STOCKS_ROW 
                                                (
                                                STOCK_ID, 
                                                PRODUCT_ID
                                                )
                                            VALUES 
                                                (
                                                #GET_MAX_STOCK.MAX_STOCK#, 
                                                #attributes.pid#
                                                )
                                       </cfquery>
                                    </cfloop>
                                <cfelse><!--- update ise --->
                                
                                    <cfquery name="ADD_STOCKS" datasource="#dsn1#">
                                        UPDATE STOCKS SET
                                            STOCK_CODE='#attributes.PRODUCT_CODE#',
                                            PRODUCT_ID=#GET_PID.PRODUCT_ID#,
                                            PROPERTY='#product_property#',
                                            BARCOD='#barcode#',					
                                            PRODUCT_UNIT_ID=#GET_MAX_UNIT.MAX_UNIT#,
                                            STOCK_STATUS=1,
                                            MANUFACT_CODE='',
                                            UPDATE_EMP=#session_user_id#,
                                            UPDATE_IP='#REMOTE_ADDR#',
                                            UPDATE_DATE=#now()#
                                        WHERE
                                            STOCK_ID=#upd_stock_id#<!--- barcode ile bulunan stok id --->
                                    </cfquery>
                                    <cfset GET_MAX_STCK.MAX_STCK=upd_stock_id>
                                    
                                </cfif>
                            <cfelse>
                                **************************SORUNLU KAYIT !!!<br/>
                                
                            </cfif>
    
                        </cfif>
                        <cfif barcode2 gt 0><!---2. barcod kayıt ediliyor--->
    
                            <cfset attributes.BARCODE=TRIM(barcode2)>
                            <cfquery name="GET_STOCK_BARCODE_2" datasource="#dsn1#">
                                SELECT BARCODE FROM STOCKS_BARCODES WHERE BARCODE = '#attributes.BARCODE#'
                            </cfquery>
                            <cfif GET_STOCK_BARCODE_2.recordcount eq 0><!--- urunun boyle bir barcod yoksa kaydet --->
                                <cfquery name="ADD_STOCK_CODE" datasource="#dsn1#">
                                    INSERT INTO 
                                        STOCKS_BARCODES
                                        (
                                            STOCK_ID,
                                            BARCODE,
                                            UNIT_ID
                                        )
                                    VALUES 
                                        (
                                            #GET_MAX_STCK.MAX_STCK#,
                                            '#attributes.BARCODE#',
                                            #GET_MAX_UNIT.MAX_UNIT#
                                        )
                                </cfquery>
                            </cfif>
    
                        </cfif>
                    </cfif>
            
                     <cfcatch type="Any">
                        <tr><cfoutput><td>#i#</td><td>#barcode#</td></cfoutput><td>satırda kayıt sırasında hata oldu</td></tr>
                        <cfset problem_counter =problem_counter + 1>
                        <cfset error_flag = 1>
                    </cfcatch>
                </cftry>
            </cfif>
    
        <cfelse>
            <cfif product_type eq 0 and pre_rec_flag eq 1>
                <tr><cfoutput><td>#i#</td><td>#barcode#</td></cfoutput><td>ürünün ana ürün kaydı yapılmadı veya ürün adı yok</td></tr>
            <cfelse>
                <tr><cfoutput><td>#i#</td><td>#barcode#</td></cfoutput><td>ürün adı yok</td></tr>
            </cfif>
            <cfset problem_counter =problem_counter + 1>
            <cfset error_flag = 1>
        </cfif>
	</cfif>
    <cfif error_flag eq 1>
		<cfscript>
			my_doc.xmlRoot.XmlChildren[hata_index] = XmlElemNew(my_doc,"STOCK");
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[1] = XmlElemNew(my_doc,"RECORD_TYPE");//eger 1 ise kayit edilcek urun anlamında 0 sa guncelleme
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[1].XmlText = record_type;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[2] = XmlElemNew(my_doc,"PRODUCT_TYPE");// 1 ise ürün kaydedilecek 0 ise sadece stocks tablosuna ürün kaydı yapılacak(boş olabilir). urun tipi 0 olan ürün kendinden onceki 1 olan ürünün cesidi olarak kayıt edilir
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[2].XmlText = product_type;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[3] = XmlElemNew(my_doc,"BARCODE");//barcode
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[3].XmlText = barcode;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[4] = XmlElemNew(my_doc,"BARCODE2");//barcode2
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[4].XmlText = barcode2;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[5] = XmlElemNew(my_doc,"PRODUCT_NAME");//ürün adı
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[5].XmlText = product_name;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[6] = XmlElemNew(my_doc,"PRODUCT_PROPERTY");//cesit adı
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[6].XmlText = product_property;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[7] = XmlElemNew(my_doc,"SALES_TAX");//satis kdv
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[7].XmlText = sales_tax;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[8] = XmlElemNew(my_doc,"STD_STOCK_UNIT");//stnd birim
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[8].XmlText = std_stock_unit;	
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[9] = XmlElemNew(my_doc,"STD_SALES_PRICE_KDV");//standart satis fiyat (kdvli)***
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[9].XmlText = std_sales_price_kdv;	
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[10] = XmlElemNew(my_doc,"STD_SALES_PRICE");//standart satis (kdvsiz)***
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[10].XmlText = std_sales_price;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[11] = XmlElemNew(my_doc,"STD_SALES_PRICE_MONEY");//standart satis Money***
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[11].XmlText = std_sales_price_money;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[12] = XmlElemNew(my_doc,"ADD_UNIT");//Ürün Birimi
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[12].XmlText = add_unit;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[13] = XmlElemNew(my_doc,"SALES_PRICE_KDV");//satış fiyatı (kdvli fiyat)
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[13].XmlText = sales_price_kdv;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[14] = XmlElemNew(my_doc,"SALES_PRICE");//satış fiyatı (kdvsiz fiyat)
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[14].XmlText = sales_price;	
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[15] = XmlElemNew(my_doc,"SALES_PRICE_MONEY");//Satış Money
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[15].XmlText = sales_price_money;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[16] = XmlElemNew(my_doc,"PRODUCT_CAT");//Kategori --PRODUCT_CATID
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[16].XmlText = product_cat;	
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[17] = XmlElemNew(my_doc,"PROD_COMPETITIVE");//Fiyat Yetkisi
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[17].XmlText = prod_competitive;	
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[18] = XmlElemNew(my_doc,"PRODUCT_STAGE");//Aşama
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[18].XmlText = product_stage;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[19] = XmlElemNew(my_doc,"PRODUCT_CODE_2");//ozel Kod
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[19].XmlText = product_code_2;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[20] = XmlElemNew(my_doc,"BRAND_NAME");//Marka ismi cunku aktarilan yerde isimle karsilastiralacak
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[20].XmlText = brand_name;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[21] = XmlElemNew(my_doc,"PRODUCT_DETAIL");//Aciklama
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[21].XmlText = product_detail;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[22] = XmlElemNew(my_doc,"IS_INVENTORY");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[22].XmlText = is_inventory;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[23] = XmlElemNew(my_doc,"INVENTORY_CALC_TYPE");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[23].XmlText = inventory_calc_type;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[24] = XmlElemNew(my_doc,"IS_PRODUCTION");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[24].XmlText = is_production;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[25] = XmlElemNew(my_doc,"IS_SALES");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[25].XmlText = is_sales;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[26] = XmlElemNew(my_doc,"IS_PURCHASE");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[26].XmlText = is_purchase;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[27] = XmlElemNew(my_doc,"IS_PROTOTYPE");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[27].XmlText = is_prototype;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[28] = XmlElemNew(my_doc,"IS_INTERNET");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[28].XmlText = is_internet;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[29] = XmlElemNew(my_doc,"IS_EXTRANET");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[29].XmlText = is_extranet;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[30] = XmlElemNew(my_doc,"IS_BALANCE");//TERAZİ
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[30].XmlText = is_terazi;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[31] = XmlElemNew(my_doc,"IS_SERIAL_NO");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[31].XmlText = is_serial_no;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[32] = XmlElemNew(my_doc,"IS_ZERO_STOCK");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[32].XmlText = is_zero_stock;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[33] = XmlElemNew(my_doc,"IS_KARMA");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[33].XmlText = is_karma;
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[34] = XmlElemNew(my_doc,"IS_COST");//
			my_doc.xmlRoot.XmlChildren[hata_index].XmlChildren[34].XmlText = is_cost;
			hata_index = hata_index+1;
		</cfscript>
	</cfif>
</cfloop>
<cfif problem_counter gt 0>
	<cffile action="append" file="#upload_folder##hata_file_name#" output="#toString(my_doc)#" charset="utf-8">
<cfelse>
	<!--- hatalı satır yok hata dosyasını silelim --->
    <cf_del_server_file output_file="#upload_folder##hata_file_name#" output_server="#session.ep.SERVER_MACHINE#">
</cfif>


<!---product_no tablosunu update--->
<cfquery name="get_product_no" datasource="#dsn1#">
	UPDATE PRODUCT_NO SET PRODUCT_NO=#attributes.URUN_NO#
</cfquery>
<!---product_no tablosunu update--->

<!--- meta bolumundeki bilgiler kayit ediliyor --->
<cfquery name="UPD_FILE" datasource="#dsn2#">
	UPDATE 
		FILE_IMPORTS 
	SET   
		SERVER_DATE=#server_date#,
		SERVER_ID='#server_id#',
		SERVER_COMPANY='#server_company#',
		DESTINATION_COMPANY='#LEFT(destination_company,150)#',
		IMPORTED=1,
		PROBLEMS_COUNT=#problem_counter#,
		PROBLEMS_FILE_NAME=<cfif problem_counter gt 0>'#hata_file_name#'<cfelse>NULL</cfif>
	WHERE
		I_ID = #attributes.I_ID#
</cfquery>
	<tr><td colspan="3"><hr></td></tr>
	<tr><td colspan="3">Toplam Satır:<cfoutput>#counter#</cfoutput></td></tr>
	<tr><td colspan="3">Hatalı Satır:<cfoutput>#problem_counter#</cfoutput></td></tr>
</table>
<br/><br/>işlem tamamlandı
