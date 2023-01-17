<!--- dataservice product --->
<cfquery name="GET_WRKXML" datasource="#dsn#">
	SELECT 
		WORKXML_OUR_COMPANY,
		WORKXML_NAME,
		WORKXML_MEMBER_NO,
		WORKXML_USER,
		WORKXML_IP,
		WORKXML_ADRESS,
		WORKXML_PASSWORD,
		WORKXML_ID
	FROM 
		WORKXML_SERVICE
	WHERE 
		WORKXML_ID = #attributes.wrk_data_service#
</cfquery>
<cfparam name="product_match_type" default="1">
<cfset proc_date_1=attributes.processdate>
<cf_date tarih='proc_date_1'>
<cfset proc_date_2=date_add('d',1,proc_date_1)>

<cfscript>
	ws = CreateObject('webservice',GET_WRKXML.WORKXML_ADRESS);
	comp_id_ = ws.password_control(member_code:GET_WRKXML.WORKXML_MEMBER_NO,user_name:GET_WRKXML.WORKXML_USER,user_password:GET_WRKXML.WORKXML_PASSWORD);
	if(comp_id_)
	{
		query_text="
		SELECT
			P.PRODUCT_ID,S.STOCK_ID,
			1 RECORD_TYPE,
			CASE P.PRODUCT_CODE WHEN S.STOCK_CODE THEN 1 ELSE 0 END PRODUCT_TYPE,
			S.BARCOD BARCODE,
			(SELECT TOP 1 SBA.BARCODE FROM GET_STOCK_BARCODES_ALL SBA WHERE SBA.STOCK_ID=S.STOCK_ID AND SBA.BARCODE<>S.BARCOD) BARCODE2,
			P.PRODUCT_NAME,
			S.PROPERTY PRODUCT_PROPERTY,
			P.TAX SALES_TAX,
			(
				SELECT 
					PU2.ADD_UNIT
				FROM
					PRICE_STANDART PS,
					PRODUCT_UNIT AS PU2
				WHERE
					PS.PRODUCT_ID = P.PRODUCT_ID
					AND PU2.PRODUCT_UNIT_ID = PS.UNIT_ID
					AND PS.PURCHASESALES = 1
					AND PS.PRICESTANDART_STATUS = 1
					AND PU2.IS_MAIN = 1
			) AS STD_STOCK_UNIT,
			(
				SELECT 
					PS.PRICE_KDV
				FROM
					PRICE_STANDART PS,
					PRODUCT_UNIT AS PU2
				WHERE
					PS.PRODUCT_ID = P.PRODUCT_ID
					AND PU2.PRODUCT_UNIT_ID = PS.UNIT_ID
					AND PS.PURCHASESALES = 1
					AND PS.PRICESTANDART_STATUS = 1
					AND PU2.IS_MAIN = 1
			) AS STD_SALES_PRICE_KDV,
			(
				SELECT 
					PS.PRICE
				FROM
					PRICE_STANDART PS,
					PRODUCT_UNIT AS PU2
				WHERE
					PS.PRODUCT_ID = P.PRODUCT_ID
					AND PU2.PRODUCT_UNIT_ID = PS.UNIT_ID
					AND PS.PURCHASESALES = 1
					AND PS.PRICESTANDART_STATUS = 1
					AND PU2.IS_MAIN = 1
			) AS STD_SALES_PRICE,
			(
				SELECT 
					PS.MONEY
				FROM
					PRICE_STANDART PS,
					PRODUCT_UNIT AS PU2
				WHERE
					PS.PRODUCT_ID = P.PRODUCT_ID
					AND PU2.PRODUCT_UNIT_ID = PS.UNIT_ID
					AND PS.PURCHASESALES = 1
					AND PS.PRICESTANDART_STATUS = 1
					AND PU2.IS_MAIN = 1
			) AS STD_SALES_PRICE_MONEY,
			PU.ADD_UNIT AS ADD_UNIT,
			PR.PRICE_KDV AS SALES_PRICE_KDV,
			PR.PRICE AS SALES_PRICE,
			PR.MONEY AS SALES_PRICE_MONEY,
			LEFT(P.PRODUCT_CODE,LEN(P.PRODUCT_CODE)-CHARINDEX('.',REVERSE(P.PRODUCT_CODE))) PRODUCT_CAT,
			P.PROD_COMPETITIVE PROD_COMPETITIVE,
			P.PRODUCT_STAGE,
			P.PRODUCT_CODE_2,
			(SELECT PRODUCT_BRANDS.BRAND_NAME FROM ##dsn3_alias##.PRODUCT_BRANDS PRODUCT_BRANDS WHERE PRODUCT_BRANDS.BRAND_ID=P.BRAND_ID) BRAND_NAME,
			P.PRODUCT_DETAIL,
			P.IS_INVENTORY,
			P.IS_PRODUCTION,
			P.IS_SALES,
			P.IS_PURCHASE,
			P.IS_PROTOTYPE,
			P.IS_INTERNET,
			P.IS_EXTRANET,
			P.IS_TERAZI IS_BALANCE,
			P.IS_SERIAL_NO,
			P.IS_ZERO_STOCK,
			P.IS_KARMA,
			P.IS_COST
		FROM
			STOCKS AS S,
			PRODUCT AS P,
			PRODUCT_OUR_COMPANY AS POC,
			PRODUCT_UNIT AS PU,
			##dsn3_alias##.PRICE PR
		WHERE
			S.PRODUCT_ID = P.PRODUCT_ID AND
			POC.PRODUCT_ID = P.PRODUCT_ID AND
			PU.PRODUCT_ID = P.PRODUCT_ID AND
			PR.PRODUCT_ID = P.PRODUCT_ID AND
			PR.UNIT = PU.PRODUCT_UNIT_ID AND
			(
				(
					P.RECORD_DATE BETWEEN #proc_date_1# AND #proc_date_2# 
				)
			) AND
			PR.PRICE_CATID = ISNULL(
							(SELECT PRICE_CAT FROM ##dsn_alias##.COMPANY_CREDIT COMPANY_CREDIT WHERE COMPANY_ID = #comp_id_# AND OUR_COMPANY_ID = #GET_WRKXML.WORKXML_OUR_COMPANY#),
							(ISNULL((SELECT PRICE_CATID FROM ##dsn3_alias##.PRICE_CAT PRICE_CAT WHERE COMPANY_CAT LIKE '%,'+(SELECT cast(COMPANYCAT_ID as nvarchar) FROM ##dsn_alias##.COMPANY COMPANY WHERE COMPANY_ID = #comp_id_#)+',%'),0))
							) AND
			PR.STARTDATE <= #proc_date_1# AND
			(PR.FINISHDATE >= #proc_date_1# OR PR.FINISHDATE IS NULL) AND
			PU.IS_MAIN = 1 AND
			POC.OUR_COMPANY_ID = 1 AND
			P.PRODUCT_STATUS = 1 
	UNION
		SELECT
			P.PRODUCT_ID,S.STOCK_ID,
			0 RECORD_TYPE,
			CASE P.PRODUCT_CODE WHEN S.STOCK_CODE THEN 1 ELSE 0 END PRODUCT_TYPE,
			S.BARCOD BARCODE,
			(SELECT TOP 1 SBA.BARCODE FROM GET_STOCK_BARCODES_ALL SBA WHERE SBA.STOCK_ID=S.STOCK_ID AND SBA.BARCODE<>S.BARCOD) BARCODE2,
			P.PRODUCT_NAME,
			S.PROPERTY PRODUCT_PROPERTY,
			P.TAX SALES_TAX,
			(
				SELECT 
					PU2.ADD_UNIT
				FROM
					PRICE_STANDART PS,
					PRODUCT_UNIT AS PU2
				WHERE
					PS.PRODUCT_ID = P.PRODUCT_ID
					AND PU2.PRODUCT_UNIT_ID = PS.UNIT_ID
					AND PS.PURCHASESALES = 1
					AND PS.PRICESTANDART_STATUS = 1
					AND PU2.IS_MAIN = 1
			) AS STD_STOCK_UNIT,
			(
				SELECT 
					PS.PRICE_KDV
				FROM
					PRICE_STANDART PS,
					PRODUCT_UNIT AS PU2
				WHERE
					PS.PRODUCT_ID = P.PRODUCT_ID
					AND PU2.PRODUCT_UNIT_ID = PS.UNIT_ID
					AND PS.PURCHASESALES = 1
					AND PS.PRICESTANDART_STATUS = 1
					AND PU2.IS_MAIN = 1
			) AS STD_SALES_PRICE_KDV,
			(
				SELECT 
					PS.PRICE
				FROM
					PRICE_STANDART PS,
					PRODUCT_UNIT AS PU2
				WHERE
					PS.PRODUCT_ID = P.PRODUCT_ID
					AND PU2.PRODUCT_UNIT_ID = PS.UNIT_ID
					AND PS.PURCHASESALES = 1
					AND PS.PRICESTANDART_STATUS = 1
					AND PU2.IS_MAIN = 1
			) AS STD_SALES_PRICE,
			(
				SELECT 
					PS.MONEY
				FROM
					PRICE_STANDART PS,
					PRODUCT_UNIT AS PU2
				WHERE
					PS.PRODUCT_ID = P.PRODUCT_ID
					AND PU2.PRODUCT_UNIT_ID = PS.UNIT_ID
					AND PS.PURCHASESALES = 1
					AND PS.PRICESTANDART_STATUS = 1
					AND PU2.IS_MAIN = 1
			) AS STD_SALES_PRICE_MONEY,
			PU.ADD_UNIT AS ADD_UNIT,
			PR.PRICE_KDV AS SALES_PRICE_KDV,
			PR.PRICE AS SALES_PRICE,
			PR.MONEY AS SALES_PRICE_MONEY,
			LEFT(P.PRODUCT_CODE,LEN(P.PRODUCT_CODE)-CHARINDEX('.',REVERSE(P.PRODUCT_CODE))) PRODUCT_CAT,
			P.PROD_COMPETITIVE PROD_COMPETITIVE,
			P.PRODUCT_STAGE,
			P.PRODUCT_CODE_2,
			(SELECT PRODUCT_BRANDS.BRAND_NAME FROM ##dsn3_alias##.PRODUCT_BRANDS PRODUCT_BRANDS WHERE PRODUCT_BRANDS.BRAND_ID=P.BRAND_ID) BRAND_NAME,
			P.PRODUCT_DETAIL,
			P.IS_INVENTORY,
			P.IS_PRODUCTION,
			P.IS_SALES,
			P.IS_PURCHASE,
			P.IS_PROTOTYPE,
			P.IS_INTERNET,
			P.IS_EXTRANET,
			P.IS_TERAZI IS_BALANCE,
			P.IS_SERIAL_NO,
			P.IS_ZERO_STOCK,
			P.IS_KARMA,
			P.IS_COST
		FROM
			STOCKS AS S,
			PRODUCT AS P,
			PRODUCT_OUR_COMPANY AS POC,
			PRODUCT_UNIT AS PU,
			##dsn3_alias##.PRICE PR
		WHERE
			S.PRODUCT_ID = P.PRODUCT_ID AND
			POC.PRODUCT_ID = P.PRODUCT_ID AND
			PU.PRODUCT_ID = P.PRODUCT_ID AND
			PR.PRODUCT_ID = P.PRODUCT_ID AND
			PR.UNIT = PU.PRODUCT_UNIT_ID AND
			(
				(
					P.RECORD_DATE <= #proc_date_1# AND
					P.UPDATE_DATE BETWEEN #proc_date_1# AND #proc_date_2#
				)
				OR
				(
					PR.RECORD_DATE BETWEEN #proc_date_1# AND #proc_date_2#
				)
			) AND
			PR.PRICE_CATID = ISNULL(
							(SELECT PRICE_CAT FROM ##dsn_alias##.COMPANY_CREDIT COMPANY_CREDIT WHERE COMPANY_ID = #comp_id_# AND OUR_COMPANY_ID = #GET_WRKXML.WORKXML_OUR_COMPANY#),
							(ISNULL((SELECT PRICE_CATID FROM ##dsn3_alias##.PRICE_CAT PRICE_CAT WHERE COMPANY_CAT LIKE '%,'+(SELECT cast(COMPANYCAT_ID as nvarchar) FROM ##dsn_alias##.COMPANY COMPANY WHERE COMPANY_ID = #comp_id_#)+',%'),0))
							) AND
			PR.STARTDATE <= #proc_date_1# AND
			(PR.FINISHDATE >= #proc_date_1# OR PR.FINISHDATE IS NULL) AND
			PU.IS_MAIN = 1 AND
			POC.OUR_COMPANY_ID = 1 AND
			P.PRODUCT_STATUS = 1
		ORDER BY P.PRODUCT_ID,S.STOCK_ID 
		";
		call_function_string='wrk_xml(query_string:"#query_text#",query_string_datasource:"##DSN1##",query_string_xml_tag_name:"STOCK")';
		wrkxml_data=ws.wrk_call_function(comp_id:GET_WRKXML.WORKXML_OUR_COMPANY,process_date:"#attributes.processdate#",call_function:"#call_function_string#");
	}
	else
	{
		abort('Workcube Dataservisde tanımladığınız şifre veya kullanıcı adı hatalı!');
	}
</cfscript>
<!--- ürün kayıt tipi 0 olacaksa mutlaka dosyadaki ondan önceki kayıt tipi 1 olan ürünün onun üst ürünü olmalıdır--->
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

<cfscript>
	counter = 0;
	problem_counter = 0;
	pre_rec_flag = 0;//onceki satirin kayit edilip edilmedigini tutuyor cunku cesitse ana urun kayit yapilmadi ise cesitte kaydedilmemeli

	//islem uzun surmesi halinde session kaybedebillir diye bir degiskene aldik
	session_comp_id=SESSION.EP.COMPANY_ID;
	session_user_id=SESSION.EP.USERID;
	session_userkey=SESSION.EP.USERKEY;
	session_money=SESSION.EP.MONEY;

	//urun no bulunuyor kayit yoksa 10000den baslatiliyor
	get_product_no=cfquery(SQLString:"SELECT MAX(PRODUCT_NO) AS URUN_NO FROM PRODUCT_NO",is_select:1,Datasource:dsn1);
	if(get_product_no.recordcount)
		attributes.URUN_NO=get_product_no.URUN_NO;
	else
		attributes.URUN_NO="10000";

	dosyam = XmlParse(wrkxml_data);
	xml_dizi = dosyam.WORKCUBE_XML.XmlChildren;
	d_boyut = ArrayLen(xml_dizi);
</cfscript>

<!--- belge formati kontorlu icin  --->
<table>
	<tr><td colspan="3" align="center">Import Sonuç</td></tr>
	<tr><td width="15">Satır</td><td width="75">Barcode</td><td>Hata</td></tr>
<cfloop index="i" from="1" to="#d_boyut-1#"><!--- 2 den baslıyor cunku xmldeki 1 satır acıklama tagleri var--->
	<cftry>
		<cfscript>
			error_flag = 0;
			barcode_no_list="";
			counter = counter + 1;
			record_type = dosyam.WORKCUBE_XML.STOCK[i].RECORD_TYPE.XmlText;
			if(not len(record_type)) 
				record_type=1;
			product_type = dosyam.WORKCUBE_XML.STOCK[i].PRODUCT_TYPE.XmlText;
			if(not len(product_type))
				product_type=1;
			if(product_type eq 1)
				pre_rec_flag=0;//urun cesit degilse onceki urun kayit edilip edilmedigi degeri 0 laniyor
			if(pre_rec_flag eq 0)//ana urunu kaydedilmis ise diger islemleri yapsin
			{
				barcode = trim(dosyam.WORKCUBE_XML.STOCK[i].BARCODE.XmlText);
				barcode2 = trim(dosyam.WORKCUBE_XML.STOCK[i].BARCODE2.XmlText);
				barcode_no_list = ListAppend(barcode_no_list,barcode,',');
				barcode_no_list = ListAppend(barcode_no_list,barcode2,',');
				product_name = trim(dosyam.WORKCUBE_XML.STOCK[i].PRODUCT_NAME.XmlText);
				product_property = trim(dosyam.WORKCUBE_XML.STOCK[i].PRODUCT_PROPERTY.XmlText);
				sales_tax = dosyam.WORKCUBE_XML.STOCK[i].SALES_TAX.XmlText;
				std_stock_unit = dosyam.WORKCUBE_XML.STOCK[i].STD_STOCK_UNIT.XmlText;
				std_sales_price_kdv = dosyam.WORKCUBE_XML.STOCK[i].STD_SALES_PRICE_KDV.XmlText;
				std_sales_price = dosyam.WORKCUBE_XML.STOCK[i].STD_SALES_PRICE.XmlText;
				std_sales_price_money = dosyam.WORKCUBE_XML.STOCK[i].STD_SALES_PRICE_MONEY.XmlText;
				add_unit = dosyam.WORKCUBE_XML.STOCK[i].ADD_UNIT.XmlText;
				sales_price_kdv = dosyam.WORKCUBE_XML.STOCK[i].SALES_PRICE_KDV.XmlText;
				sales_price = dosyam.WORKCUBE_XML.STOCK[i].SALES_PRICE.XmlText;
				sales_price_money = dosyam.WORKCUBE_XML.STOCK[i].SALES_PRICE_MONEY.XmlText;
				product_cat = dosyam.WORKCUBE_XML.STOCK[i].PRODUCT_CAT.XmlText;
				prod_competitive = dosyam.WORKCUBE_XML.STOCK[i].PROD_COMPETITIVE.XmlText;
				product_stage = dosyam.WORKCUBE_XML.STOCK[i].PRODUCT_STAGE.XmlText;
				product_code_2 = dosyam.WORKCUBE_XML.STOCK[i].PRODUCT_CODE_2.XmlText;
				brand_name = trim(dosyam.WORKCUBE_XML.STOCK[i].BRAND_NAME.XmlText);
				product_detail = left(dosyam.WORKCUBE_XML.STOCK[i].PRODUCT_DETAIL.XmlText,255);
				is_inventory = dosyam.WORKCUBE_XML.STOCK[i].IS_INVENTORY.XmlText;
				is_production = dosyam.WORKCUBE_XML.STOCK[i].IS_PRODUCTION.XmlText;
				is_sales = dosyam.WORKCUBE_XML.STOCK[i].IS_SALES.XmlText;
				is_purchase = dosyam.WORKCUBE_XML.STOCK[i].IS_PURCHASE.XmlText;
				is_prototype = dosyam.WORKCUBE_XML.STOCK[i].IS_PROTOTYPE.XmlText;
				is_internet = dosyam.WORKCUBE_XML.STOCK[i].IS_INTERNET.XmlText;
				is_extranet = dosyam.WORKCUBE_XML.STOCK[i].IS_EXTRANET.XmlText;
				is_terazi = dosyam.WORKCUBE_XML.STOCK[i].IS_BALANCE.XmlText;
				is_serial_no = dosyam.WORKCUBE_XML.STOCK[i].IS_SERIAL_NO.XmlText;
				is_zero_stock = dosyam.WORKCUBE_XML.STOCK[i].IS_ZERO_STOCK.XmlText;
				is_karma = dosyam.WORKCUBE_XML.STOCK[i].IS_KARMA.XmlText;			
				is_cost = dosyam.WORKCUBE_XML.STOCK[i].IS_COST.XmlText;
			}else{
				error_flag=1;
				problem_counter =problem_counter+ 1;
			}
			if(not len(barcode))
			{
				error_flag=1;
				problem_counter =problem_counter+ 1;
				writeoutput('<tr><cfoutput><td>#i#. satır</td><td></td></cfoutput><td>barkod kaydı yok</td></tr>');
			}
		</cfscript>
		<cfcatch type="Any">
			<tr><cfoutput><td>#i#. satır</td><td></td></cfoutput><td>okuma sırasında hata oldu</td></tr>
			<cfset error_flag = 1>
			<cfset problem_counter =problem_counter+ 1>
			<cfset pre_rec_flag = 1>
		</cfcatch>
	</cftry>

	<cfif error_flag neq 1>
		<cfif len(product_name) and (product_type eq 1 or (product_type eq 0 and pre_rec_flag eq 0))>
			<!--- urun ana urunse ismide varsa kayit atilir ancak cesit se ve ana urunu kaydedilmedi ise cesit de kaydedilmez --->
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
						writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>1. barkod var </td><tr>');
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
						writeoutput('<tr><td>'&i&'</td><td>'&barcode2&'</td><td>2. barkod var </td><tr>');
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
						writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>(#product_name#) Ürün Adı var </td><tr>');
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
						writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>(#product_name#) ürün bulunamadı </td></tr>');
						error_flag = 1;
						pre_rec_flag = 1;
						problem_counter =problem_counter + 1;
					}else
					{
						upd_stock_id=check_same.STOCK_ID;
					}
				}
				//barkod no_2 başka bir üründe varmı 
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
						writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> (#std_stock_unit#) birim kaydı yok </td><tr>');
						error_flag = 1;
						pre_rec_flag = 1;
						problem_counter =problem_counter + 1;
					}
				}else{
					writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> (#product_name#) ürün birimi yok </td><tr>');
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
							writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td>(#add_unit#) ürünün fiyat birim kaydı yok </td><tr>');
							error_flag = 1;
							pre_rec_flag = 1;
							problem_counter =problem_counter + 1;
						}
					}else{
						unit_name=std_unit_name;
						unit_id=std_unit_id;
					}
				}else{
					writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> (#product_name#) ürünün fiyat birimi yok </td><tr>');
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
						writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> (#brand_name#)  marka kaydı yok </td><tr>');
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
						writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> (#product_cat#) kategori kaydı yok </td><tr>');
						error_flag = 1;
						pre_rec_flag = 1;
						problem_counter =problem_counter + 1;
					}
				}else{
						writeoutput('<tr><td>'&i&'</td><td>'&barcode&'</td><td> (#product_name#) kategorisi yok </td><tr>');
						error_flag = 1;
						pre_rec_flag = 1;
						problem_counter =problem_counter + 1;
				}
			}
			</cfscript>
			<cfif error_flag neq 1>
			   <cftry>
			   <cftransaction>
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
							<!--- ürün fiyatı başka bir fiyat listesine atılana kadar kapalı durmalı şimdilik standart satışa kaydedecek fiyatı
							<cfif attributes.price_catid neq -2>
								<!--- ürünün unit kaydı--->
								<cfif record_type eq 1>
									<!---<cfquery name="ADD_MAIN_UNIT" datasource="#dsn1#">--->
									<cfoutput>
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
												IS_MAIN
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
												0
											)
										</cfoutput><br />
									  <!---</cfquery>--->
									<cfquery name="GET_MAX_UNIT_2" datasource="#dsn1#">
										SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM PRODUCT_UNIT
									</cfquery>
								<cfelse>
									<cfquery name="GET_MAX_UNIT_2" datasource="#dsn1#">
										SELECT PRODUCT_UNIT_ID MAX_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID=#GET_PID.PRODUCT_ID# AND MAIN_UNIT='#std_unit_name#' AND UNIT_ID=#unit_id#
									</cfquery>
									<cfif GET_MAX_UNIT_2.recordcount>
										<!---<cfquery name="add_product" datasource="#dsn1#">--->
										<cfoutput>
											UPDATE 
												PRODUCT_UNIT 
											SET
												PRODUCT_UNIT_STATUS=1, 
												MAIN_UNIT_ID=#std_unit_id#,
												MAIN_UNIT='#std_unit_name#',
												UNIT_ID=#unit_id#,
												ADD_UNIT='#unit_name#'
											WHERE
												PRODUCT_UNIT_ID=#GET_MAX_UNIT_2.MAX_UNIT#
										</cfoutput><br />
									   <!---</cfquery>--->
									<cfelse>
										<!---<cfquery name="ADD_MAIN_UNIT" datasource="#dsn1#">--->
										<cfoutput>
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
													IS_MAIN
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
													0
												)
										</cfoutput><br />
										<!---</cfquery>--->
										<cfquery name="GET_MAX_UNIT_2" datasource="#dsn1#">
											SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM PRODUCT_UNIT
										</cfquery>
									</cfif>
								</cfif>
								<!--- ürünün unit kaydı--->
								<!--- importa secilen  fiyat listesine std fiyat atiliyor cunku satis fiyat olarak o var--->
							   <!--- <cfquery datasource="#dsn3#" name="new_price_add_method" timeout="300">--->
							   <cfoutput>
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
								</cfoutput><br />
								<!---</cfquery>--->
							</cfif>
							--->
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
								<cfquery name="get_my_periods" datasource="#dsn1#">
									SELECT
										*
									FROM
										#dsn_alias#.SETUP_PERIOD SETUP_PERIOD
									WHERE
										OUR_COMPANY_ID = #session_comp_id#
								</cfquery>
								<cfloop query="get_my_periods">
									<cfif database_type is "MSSQL">
										<cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#session_comp_id#">
									<cfelseif database_type is "DB2">
										<cfset temp_dsn = "#dsn#_#session_comp_id#_#right(period_year,2)#">
									</cfif>
								
									<cfquery name="INSRT_STK_ROW" datasource="#dsn1#">
										INSERT INTO 
											#temp_dsn#.STOCKS_ROW 
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
								
									<cfquery name="get_my_periods" datasource="#dsn1#">
										SELECT
											*
										FROM
											#dsn_alias#.SETUP_PERIOD SETUP_PERIOD
										WHERE
											OUR_COMPANY_ID IN (SELECT OUR_COMPANY_ID FROM #dsn1_alias#.PRODUCT_OUR_COMPANY WHERE PRODUCT_ID = #attributes.pid#)
									</cfquery>
									<cfloop query="get_my_periods">
										<cfif database_type is "MSSQL">
											<cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#OUR_COMPANY_ID#">
										<cfelseif database_type is "DB2">
											<cfset temp_dsn = "#dsn#_#OUR_COMPANY_ID#_#right(period_year,2)#">
										</cfif>
								
										<cfquery name="INSRT_STK_ROW" datasource="#dsn1#">
											INSERT INTO 
												#temp_dsn#.STOCKS_ROW 
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
				</cftransaction>
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
        </cfif><!---bitti <cfif len(product_name) and (product_type eq 1 or (product_type eq 0 and pre_rec_flag eq 0))>--->
	</cfif><!---bitimi <cfif error_flag neq 1> --->
</cfloop>

<cfabort>
<!---product_no tablosunu update--->
<cfquery name="get_product_no" datasource="#dsn1#">
	UPDATE PRODUCT_NO SET PRODUCT_NO=#attributes.URUN_NO#
</cfquery>
<!---//product_no tablosunu update--->

	<tr><td colspan="3"><hr></td></tr>
	<tr><td colspan="3">Toplam Satır:<cfoutput>#counter#</cfoutput></td></tr>
	<tr><td colspan="3">Hatalı Satır:<cfoutput>#problem_counter#</cfoutput></td></tr>
</table>
<br/><br/>işlem tamamlandı


