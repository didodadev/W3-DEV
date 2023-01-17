<cfinclude template="../functions/get_basket_money_js.cfm">
<cfscript>
	wrk_xml_read(xml_file:'#upload_folder#pos#dir_seperator##IMPORT_FILE.FILE_NAME#',xml_charset:'ISO-8859-9');
	attributes.active_period=session.ep.period_id;
	form.active_period=session.ep.period_id;
	for(paper_count=1;paper_count lte 4;paper_count=paper_count+1)//xmlde hangi tagdan itibaren paper blokları basliyor
	{
		if(isdefined('paper_header_#paper_count#'))
			break;
	}
	GET_SETUP_MONEY=cfquery(SQLString:"SELECT MONEY_ID,RATE2,RATE1, MONEY MONEY_TYPE,PERIOD_ID FROM SETUP_MONEY",Datasource:dsn2,is_select:1);//kurlar alınıyor
	attributes.department_id = IMPORT_FILE.DEPARTMENT_ID;
	attributes.location_id = IMPORT_FILE.DEPARTMENT_LOCATION;
	
	//fatura işlemleri içinde kullanılan fonksiyonlar her belgede tekrar tekrar yükleniyordu bu neden ile bu yol izlendi bir kere başdan yüklüyor sonra belgeler işlenirken xml_import değişkeni ile kontrol ediliyor xmlden gelmiyorsa yükleniyor
	include('add_order_row_reserved_stock.cfm','\objects\functions');
	include('add_ship_row_relation.cfm','\objects\functions');
	include('del_serial_no.cfm','\objects\functions');
	include('add_relation_rows.cfm','\objects\functions');
	include('add_stock_rows.cfm','\objects\functions');
</cfscript>
<cfloop condition="isdefined('paper_header_#paper_count#')">
	<cftry>
		<cfscript>
			max_add_invoice_id='';
			not_find_invoice_xml=0;
			error_flag=0;
			row_ind=1;//hangi satırda oldugu
			xml_tax_count=1;//kdv sayısı
			xml_otv_count=1;//otv sayısı	
			xml_basket_net_total=0;
			xml_basket_gross_total=0;
			xml_basket_tax_total=0;
			xml_basket_otv_total=0;
			if(not isdefined("paper_header_#paper_count#_paper_no_#row_ind#")) 
				"paper_header_#paper_count#_paper_no_#row_ind#"='';
			if(isdefined('paper_header_#paper_count#_paper_type_#row_ind#') and listfind('sale,sales,satış,Satış,SATIŞ,Satis',evaluate('paper_header_'&paper_count&'_paper_type_'&row_ind),','))
			{
				form.sale_product=1;
				is_sales=1;
			}
			else
			{
				form.sale_product=0;
				is_sales=0;
			}
					
			//Cari Kurumsal- Bireysel Kontrolleri
			GET_MEMBER_ID.RECORDCOUNT = 0;
			if(not len(evaluate('paper_header_'&paper_count&'_member_type_'&row_ind)) or evaluate('paper_header_'&paper_count&'_member_type_'&row_ind) eq 'company')
			{
				member_sql_str='SELECT
									1 MEMBER_TYPE,
									C.COMPANY_ID MEMBER_ID,
									ISNULL(C.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = C.COMPANY_ID)) PARTNER_ID,
									CP.ACCOUNT_CODE ACCOUNT_CODE
								FROM 
									COMPANY C,
									COMPANY_PERIOD CP
								WHERE
									C.COMPANY_STATUS = 1 AND
									CP.COMPANY_ID = C.COMPANY_ID AND
									CP.PERIOD_ID = #session.ep.period_id#';
				if(isdefined("member_sql_str") and len(member_sql_str))
				{
					if(len(evaluate('paper_header_'&paper_count&'_member_code_'&row_ind)))
					{
						member_code=evaluate('paper_header_'&paper_count&'_member_code_'&row_ind);
						GET_MEMBER_ID=cfquery(SQLString:"#member_sql_str# AND C.MEMBER_CODE = '#member_code#'",Datasource:dsn,is_select:1);
					}
					else if(len(evaluate('paper_header_'&paper_count&'_member_special_code_'&row_ind)))
					{
						special_code=evaluate('paper_header_'&paper_count&'_member_special_code_'&row_ind);
						GET_MEMBER_ID=cfquery(SQLString:"#member_sql_str# AND C.OZEL_KOD = '#special_code#'",Datasource:dsn,is_select:1);
					}
					else if(len(evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind)))
					{
						member_account_code=evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind);
						GET_MEMBER_ID=cfquery(SQLString:"#member_sql_str# AND CP.ACCOUNT_CODE = '#member_account_code#'",Datasource:dsn,is_select:1);
					}
				}
			}
			if (GET_MEMBER_ID.RECORDCOUNT eq 0)
			{
				member_sql_str='SELECT
									2 MEMBER_TYPE,
									C.CONSUMER_ID MEMBER_ID,
									NULL PARTNER_ID,
									CP.ACCOUNT_CODE ACCOUNT_CODE
								FROM 
									CONSUMER C,
									CONSUMER_PERIOD CP
								WHERE 
									C.CONSUMER_STATUS = 1 AND
									CP.CONSUMER_ID = C.CONSUMER_ID AND
									CP.PERIOD_ID = #session.ep.period_id#';
				if(isdefined("member_sql_str") and len(member_sql_str))
				{
					if(len(evaluate('paper_header_'&paper_count&'_member_code_'&row_ind)))
					{
						member_code=evaluate('paper_header_'&paper_count&'_member_code_'&row_ind);
						GET_MEMBER_ID=cfquery(SQLString:"#member_sql_str# AND C.MEMBER_CODE = '#member_code#'",Datasource:dsn,is_select:1);
					}
					else if(len(evaluate('paper_header_'&paper_count&'_member_special_code_'&row_ind)))
					{
						special_code=evaluate('paper_header_'&paper_count&'_member_special_code_'&row_ind);
						GET_MEMBER_ID=cfquery(SQLString:"#member_sql_str# AND C.OZEL_KOD = '#special_code#'",Datasource:dsn,is_select:1);
					}
					else if(len(evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind)))
					{
						member_account_code=evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind);
						GET_MEMBER_ID=cfquery(SQLString:"#member_sql_str# AND CP.ACCOUNT_CODE = '#member_account_code#'",Datasource:dsn,is_select:1);
					}
				}
			}
			if(isdefined('GET_MEMBER_ID') and GET_MEMBER_ID.RECORDCOUNT eq 1)
			{
				if(GET_MEMBER_ID.MEMBER_TYPE eq 1)
				{
					attributes.company_id=GET_MEMBER_ID.MEMBER_ID;
					attributes.comp_name='a';
					attributes.partner_id=GET_MEMBER_ID.PARTNER_ID;
					attributes.partner_name='b';
					attributes.consumer_id='';
				}else
				{
					attributes.company_id='';
					attributes.comp_name='a';
					attributes.partner_id='';
					attributes.partner_name='b';
					attributes.consumer_id=GET_MEMBER_ID.MEMBER_ID;
				}
				
			}
			else
			{
				writeoutput('#evaluate("paper_header_#paper_count#_paper_no_#row_ind#")# #GET_MEMBER_ID.MEMBER_ID# Nolu Faturada Üye Bulunamadı veya Birden Fazla Üye ile Eşleşti!<br/>');
				error_flag=1;
			}
			
			attributes.invoice_number=evaluate('paper_header_'&paper_count&'_paper_no_'&row_ind);
			form.invoice_number=evaluate('paper_header_'&paper_count&'_paper_no_'&row_ind);//faturada formdan geliyormu diye kontrol
			papar_no_sql = "SELECT INVOICE_NUMBER, PURCHASE_SALES FROM INVOICE WHERE INVOICE_NUMBER = '#trim(attributes.invoice_number)#'";
			if(is_sales eq 0 and error_flag neq 1)
			{
				papar_no_sql = papar_no_sql & ' AND PURCHASE_SALES = 0';
				if(len(attributes.company_id))
					papar_no_sql = papar_no_sql & ' AND COMPANY_ID = #attributes.company_id#';
				else
					papar_no_sql = papar_no_sql & ' AND CONSUMER_ID = #attributes.consumer_id#'; 
			}
			GET_PAPER_NO = cfquery(SQLString:"#papar_no_sql#",Datasource:dsn2,is_select:1);
			if(GET_PAPER_NO.RECORDCOUNT gt 0)
			{
				writeoutput('#trim(attributes.invoice_number)# Belge Numarası Kullanılıyor!<br/>');
				error_flag = 1;
			}
			if(len(evaluate('paper_header_'&paper_count&'_action_date_'&row_ind)) and isdate(evaluate('paper_header_'&paper_count&'_action_date_'&row_ind)))
			{
				attributes.invoice_date=evaluate('paper_header_'&paper_count&'_action_date_'&row_ind);
			}
			else
			{
				writeoutput('#trim(attributes.invoice_number)# Nolu Belgede Tarih Hatalı!<br/>');
				error_flag = 1;
			}
			if(not isdefined('paper_rows_#paper_count#_stock_code_#row_ind#'))
			{
				writeoutput('#trim(attributes.invoice_number)# Nolu Belgede Ürün Bulunamadı!<br/>');
				error_flag = 1;
			}
			
			if(error_flag eq 0)
			{
				attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
				
				attributes.city_id=evaluate('paper_header_'&paper_count&'_city_'&row_ind);//xmldeki il ismi geliyor ve onun idsi bulunuyor
				if(len(attributes.city_id))
				{
					GET_CITY_ID=cfquery(SQLString:"SELECT CITY_ID FROM SETUP_CITY WHERE CITY_NAME LIKE '#attributes.city_id#%'",Datasource:dsn,is_select:1);
					if(GET_CITY_ID.RECORDCOUNT)
						attributes.city_id=GET_CITY_ID.CITY_ID;
					else
						attributes.city_id='';
				}
				attributes.county_id=evaluate('paper_header_'&paper_count&'_county_'&row_ind);//xmldeki ilçe ismi geliyor ve onun idsi bulunuyor
				if(len(attributes.county_id))
				{
					if(len(attributes.city_id))
						where_sql_txt=' AND CITY=#attributes.city_id#';
					else
						where_sql_txt='';
					GET_COUNTY_ID=cfquery(SQLString:"SELECT COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_NAME = '#attributes.county_id#' #where_sql_txt#",Datasource:dsn,is_select:1);
					if(GET_COUNTY_ID.RECORDCOUNT)
						attributes.city_id=GET_COUNTY_ID.COUNTY_ID;
					else
						attributes.city_id='';
				}
				attributes.adres=left(evaluate('paper_header_'&paper_count&'_adress_'&row_ind)&' '&evaluate('paper_header_'&paper_count&'_zip_code_'&row_ind)&' '&evaluate('paper_header_'&paper_count&'_county_'&row_ind)&' '&evaluate('paper_header_'&paper_count&'_city_'&row_ind),200);
			
				//kurlar ile ilgili değişkenler oluşuyor		
				for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
				{
					GET_MONEY_HISTORY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE >=#createodbcdatetime(attributes.invoice_date)# AND MONEY ='#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE ",Datasource:dsn,is_select:1);
					if(GET_MONEY_HISTORY.RECORDCOUNT)
						'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_MONEY_HISTORY.RATE1#;#GET_MONEY_HISTORY.RATE2#';
					else
						'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_SETUP_MONEY.RATE1[stp_mny]#;#GET_SETUP_MONEY.RATE2[stp_mny]#';
					'attributes.hidden_rd_money_#stp_mny#'=GET_SETUP_MONEY.MONEY_TYPE[stp_mny];
					'attributes.txt_rate1_#stp_mny#'=listfirst(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');				
					'attributes.txt_rate2_#stp_mny#'=listlast(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');
				}
				attributes.kur_say=GET_SETUP_MONEY.RECORDCOUNT;
				
				if(is_sales eq 1)//tipe göre yazılmalı
					attributes.basket_id=2;
				else
					attributes.basket_id=1;
				
				attributes.list_payment_row_id='';
				attributes.subscription_id='';
				attributes.invoice_counter_number='';
				attributes.commethod_id='';
				attributes.bool_from_control_bill='';
				attributes.invoice_control_id='';
				attributes.invoice_row_ids='';
				attributes.cost_ids='';
				attributes.ship_method='';
				attributes.ship_method_name='';
				attributes.ref_no='';
				attributes.card_paymethod_id='';
				attributes.commission_rate=0;
				attributes.paymethod_id='';
				attributes.paymethod='';
				attributes.project_id='';
				attributes.project_head='';
				attributes.irsaliye_id_listesi='';
				attributes.irsaliye='';
				attributes.EMPO_ID='';
				attributes.PARTO_ID='';
				attributes.PARTNER_NAMEO='';
				note='';
				
				attributes.deliver_get_id='';
				deliver_get_id='';//alışta attributes siz yazılmış
				attributes.deliver_get_id_consumer='';
				deliver_get='';

				inventory_product_exists = 0;
				
				if(is_sales eq 0) attributes.yuvarlama=0; else attributes.yuvarlama='';
				attributes.tevkifat_oran=0;
				attributes.is_general_prom=0;
				attributes.indirim_total='100000000000000000000,100000000000000000000';
				attributes.general_prom_limit='';
				attributes.general_prom_discount='';
				attributes.general_prom_amount=0;
				attributes.free_prom_limit='';
				attributes.flt_net_total_all=0;
				if(isdefined('session.ep.money2') and len(session.ep.money2))
				{
					form.basket_money=session.ep.money2;
					attributes.basket_money=session.ep.money2;
				}
				else
				{
					form.basket_money=session.ep.money;
					attributes.basket_money=session.ep.money;
				}
				form.basket_rate1=listfirst(evaluate('#form.basket_money#_rate'),';');
				form.basket_rate2=listlast(evaluate('#form.basket_money#_rate'),';');
				attributes.basket_rate1=listfirst(evaluate('#form.basket_money#_rate'),';');
				attributes.basket_rate2=listlast(evaluate('#form.basket_money#_rate'),';');
				attributes.currency_multiplier = '';
				attributes.basket_member_pricecat='';


				if(len(evaluate('paper_header_'&paper_count&'_due_date_'&row_ind)) and isdate(evaluate('paper_header_'&paper_count&'_due_date_'&row_ind)))
					attributes.basket_due_value=datediff('d',evaluate('paper_header_'&paper_count&'_due_date_'&row_ind),attributes.invoice_date);
				else
					attributes.basket_due_value='';
				if(isdate(evaluate('paper_header_'&paper_count&'_due_date_'&row_ind)))
					attributes.basket_due_value_date_=evaluate('paper_header_'&paper_count&'_due_date_'&row_ind);
				else
					attributes.basket_due_value_date_= attributes.invoice_date;
	
				//satırlar
				while(isdefined('paper_rows_#paper_count#_stock_code_#row_ind#'))
				{
					product_sql_str='SELECT
										S.BARCOD BARCODE,
										S.STOCK_ID,
										S.PRODUCT_ID,
										S.STOCK_CODE,
										S.PRODUCT_NAME,
										S.PROPERTY,
										S.IS_INVENTORY,
										S.MANUFACT_CODE,
										S.TAX,
										S.IS_PRODUCTION,
										PU.ADD_UNIT,
										PU.PRODUCT_UNIT_ID,
										PU.MULTIPLIER,
										PP.ACCOUNT_CODE,
										PP.ACCOUNT_CODE_PUR,
										PP.ACCOUNT_IADE
									FROM
										STOCKS AS S,
										PRODUCT_UNIT AS PU,
										PRODUCT_PERIOD PP
									WHERE
										S.PRODUCT_STATUS = 1 AND
										S.STOCK_STATUS = 1 AND
										S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
										S.PRODUCT_ID = PU.PRODUCT_ID AND
										PP.PRODUCT_ID=S.PRODUCT_ID AND
										PP.PERIOD_ID = #session.ep.period_id#
									';
					if(not len(trim(evaluate('paper_rows_'&paper_count&'_unit_'&row_ind))))
						stock_unit='Adet';
					else
						stock_unit=trim(evaluate('paper_rows_'&paper_count&'_unit_'&row_ind));
					if(len(evaluate('paper_rows_'&paper_count&'_stock_code_'&row_ind)))
					{
						stock_code=trim(evaluate('paper_rows_'&paper_count&'_stock_code_'&row_ind));
						GET_PRODUCT_ID=cfquery(SQLString:"#product_sql_str# AND S.STOCK_CODE = '#stock_code#' AND PU.ADD_UNIT='#stock_unit#'",Datasource:dsn3,is_select:1);
					}
					else if(len(evaluate('paper_rows_'&paper_count&'_stock_special_code_'&row_ind)))
					{
						stock_special_code=evaluate('paper_rows_'&paper_count&'_stock_special_code_'&row_ind);
						GET_PRODUCT_ID=cfquery(SQLString:"#product_sql_str# AND S.STOCK_CODE_2 = '#stock_special_code#' AND PU.ADD_UNIT='#stock_unit#'",Datasource:dsn3,is_select:1);
					}
					else if(len(evaluate('paper_rows_'&paper_count&'_account_code_'&row_ind)))
					{
						stock_account_code=evaluate('paper_rows_'&paper_count&'_account_code_'&row_ind);
						GET_PRODUCT_ID=cfquery(SQLString:"#product_sql_str# AND (PP.ACCOUNT_CODE = '#stock_account_code#' OR PP.ACCOUNT_CODE_PUR = '#stock_account_code#'  OR PP.ACCOUNT_IADE = '#stock_account_code#') AND PU.ADD_UNIT='#stock_unit#'",Datasource:dsn3,is_select:1);
					}else
					{
						GET_PRODUCT_ID.RECORDCOUNT=0;
					}
					
					if(GET_PRODUCT_ID.RECORDCOUNT eq 1)
					{
						if(not len(evaluate('paper_rows_#paper_count#_tax_rate_#row_ind#')))
							'paper_rows_#paper_count#_tax_rate_#row_ind#'=0;
						if(not len(evaluate('paper_rows_#paper_count#_special_tax_rate_#row_ind#')))
							'paper_rows_#paper_count#_special_tax_rate_#row_ind#'=0;
						if(not len(evaluate('paper_rows_#paper_count#_amount_#row_ind#')))
							'paper_rows_#paper_count#_amount_#row_ind#'=1;
						if(not len(evaluate('paper_rows_#paper_count#_discount_rate_#row_ind#')))
							'paper_rows_#paper_count#_discount_rate_#row_ind#'=0;
						if(not len(evaluate('paper_rows_#paper_count#_rebate_#row_ind#')))
							'paper_rows_#paper_count#_rebate_#row_ind#'=0;	
						if(not len(evaluate('paper_rows_#paper_count#_price_#row_ind#')))
							'paper_rows_#paper_count#_price_#row_ind#'=0;
						if(not len(evaluate('paper_rows_#paper_count#_price_money_#row_ind#')) or listfind('TL,tl,ytl',evaluate('paper_rows_#paper_count#_price_money_#row_ind#'),','))
							'paper_rows_#paper_count#_price_money_#row_ind#'='TL';

						xml_money_type = evaluate('paper_rows_#paper_count#_price_money_#row_ind#');
						if(xml_money_type is 'TL' and session.ep.period_year lt 2009) xml_money_type = 'YTL';
						if(xml_money_type is 'YTL' and session.ep.period_year gt 2008) xml_money_type = 'TL';
						if(evaluate('paper_rows_#paper_count#_price_#row_ind#') lte 0)
						{
							xml_row_net_total = 0;
							xml_row_tax_total = 0;
							xml_row_otv_total = 0;
							xml_row_price_sys = 0;
							xml_row_price_net_sys = 0;
							xml_row_tax_total_sys = 0;
							xml_row_otv_total_sys = 0;
							xml_basket_net_total = 0;
							xml_basket_gross_total = 0;
							xml_basket_tax_total = 0;
							xml_basket_otv_total = 0;
						}
						else
						{
							xml_row_net_total = wrk_round((evaluate('paper_rows_#paper_count#_price_#row_ind#')-evaluate('paper_rows_#paper_count#_rebate_#row_ind#'))*((100-evaluate('paper_rows_#paper_count#_discount_rate_#row_ind#'))/100),2);
							xml_row_tax_total = wrk_round((xml_row_net_total/100)*evaluate('paper_rows_#paper_count#_tax_rate_#row_ind#'),2);
							xml_row_otv_total = wrk_round((xml_row_net_total/100)*evaluate('paper_rows_#paper_count#_special_tax_rate_#row_ind#'),2);
							xml_row_price_sys = wrk_round(evaluate('paper_rows_#paper_count#_price_#row_ind#')*listlast(evaluate('#xml_money_type#_rate'),';')/listfirst(evaluate('#xml_money_type#_rate'),';'),2);
							xml_row_price_net_sys = wrk_round(xml_row_net_total*listlast(evaluate('#xml_money_type#_rate'),';')/listfirst(evaluate('#xml_money_type#_rate'),';'),2);
							xml_row_tax_total_sys = wrk_round((xml_row_price_sys/100)*evaluate('paper_rows_#paper_count#_tax_rate_#row_ind#'),2);
							xml_row_otv_total_sys = wrk_round((xml_row_price_sys/100)*evaluate('paper_rows_#paper_count#_special_tax_rate_#row_ind#'),2);
							xml_basket_net_total = wrk_round(xml_basket_net_total+xml_row_price_net_sys+xml_row_tax_total_sys+xml_row_otv_total_sys,2);
							xml_basket_gross_total = xml_basket_gross_total+xml_row_price_sys;
							xml_basket_tax_total = xml_basket_tax_total+xml_row_tax_total_sys;
							xml_basket_otv_total = xml_basket_otv_total+xml_row_otv_total_sys;
						}
						
						'attributes.amount#row_ind#'=evaluate('paper_rows_#paper_count#_amount_#row_ind#');
						'attributes.amount_other#row_ind#'='';
						'attributes.barcod#row_ind#'=GET_PRODUCT_ID.BARCODE;
						'attributes.dara#row_ind#'='';
						'attributes.darali#row_ind#'='';
						'attributes.deliver_date#row_ind#'='';
						'attributes.deliver_dept#row_ind#'='';
						'attributes.duedate#row_ind#'=attributes.basket_due_value;// header bloğundaki duedate alınacak
						'attributes.ek_tutar#row_ind#'=0;
						'attributes.ek_tutar_other_total#row_ind#'=0;
						'attributes.ek_tutar_total#row_ind#'=0;
						'attributes.extra_cost#row_ind#'=0;
						'attributes.indirim1#row_ind#'=evaluate('paper_rows_#paper_count#_discount_rate_#row_ind#');
						'attributes.indirim2#row_ind#'=0;
						'attributes.indirim3#row_ind#'=0;
						'attributes.indirim4#row_ind#'=0;
						'attributes.indirim5#row_ind#'=0;
						'attributes.indirim6#row_ind#'=0;
						'attributes.indirim7#row_ind#'=0;
						'attributes.indirim8#row_ind#'=0;
						'attributes.indirim9#row_ind#'=0;
						'attributes.indirim10#row_ind#'=0;
						'attributes.iskonto_tutar#row_ind#'=evaluate('paper_rows_#paper_count#_rebate_#row_ind#');
						'attributes.is_commission#row_ind#'=0;
						'attributes.is_inventory#row_ind#'=GET_PRODUCT_ID.IS_INVENTORY;
						if(GET_PRODUCT_ID.IS_INVENTORY)
							inventory_product_exists = 1;
						'attributes.is_production#row_ind#'=GET_PRODUCT_ID.IS_PRODUCTION;
	
						'attributes.is_promotion#row_ind#'=0;
						'attributes.karma_product_id#row_ind#'='';
						'attributes.list_price#row_ind#'=evaluate('paper_rows_#paper_count#_price_#row_ind#');
						'attributes.lot_no#row_ind#'='';
						'attributes.manufact_code#row_ind#'=GET_PRODUCT_ID.MANUFACT_CODE;
						'attributes.marj#row_ind#'='';
						'attributes.net_maliyet#row_ind#'=0;
						'attributes.number_of_installment#row_ind#'=0;
						'attributes.order_currency#row_ind#'=-1;
						'attributes.other_money_#row_ind#'=evaluate('paper_rows_#paper_count#_price_money_#row_ind#');
						'attributes.other_money_gross_total#row_ind#'=xml_row_net_total+xml_row_tax_total+xml_row_otv_total;
						'attributes.other_money_value_#row_ind#'=xml_row_net_total;
						'attributes.otv_oran#row_ind#'=evaluate('paper_rows_#paper_count#_special_tax_rate_#row_ind#');
						'attributes.price#row_ind#'=xml_row_price_sys;
						if(is_sales)
							'attributes.price_cat#row_ind#'=-1;
						else
							'attributes.price_cat#row_ind#'=-2;
						'attributes.price_net#row_ind#'=xml_row_price_net_sys;
						'attributes.price_net_doviz#row_ind#'=xml_row_net_total;
						'attributes.price_other#row_ind#'=evaluate('paper_rows_#paper_count#_price_#row_ind#');
						if(is_sales)
							'attributes.product_account_code#row_ind#'=GET_PRODUCT_ID.ACCOUNT_CODE;
						else
							'attributes.product_account_code#row_ind#'=GET_PRODUCT_ID.ACCOUNT_IADE;
						'attributes.product_id#row_ind#'=GET_PRODUCT_ID.PRODUCT_ID;
						'attributes.product_name#row_ind#'=GET_PRODUCT_ID.PRODUCT_NAME;
						'product_name#row_ind#'=GET_PRODUCT_ID.PRODUCT_NAME;
						'attributes.product_name_other#row_ind#'=left(evaluate('paper_rows_#paper_count#_description_#row_ind#'),100);
						'attributes.promosyon_maliyet#row_ind#'='';
						'attributes.promosyon_yuzde#row_ind#'='';
						'attributes.prom_relation_id#row_ind#'='';
						'attributes.prom_stock_id#row_ind#'='';
						'attributes.reserve_date#row_ind#'='';
						'attributes.reserve_type#row_ind#'='';
						'attributes.row_lasttotal#row_ind#'=(xml_row_price_net_sys+xml_row_tax_total_sys+xml_row_otv_total_sys)*evaluate('paper_rows_#paper_count#_amount_#row_ind#');
						'attributes.row_nettotal#row_ind#'=xml_row_price_net_sys*evaluate('paper_rows_#paper_count#_amount_#row_ind#');
						'attributes.row_otvtotal#row_ind#'=xml_row_otv_total_sys*evaluate('paper_rows_#paper_count#_amount_#row_ind#');
						'attributes.row_promotion_id#row_ind#'='';
						'attributes.row_service_id#row_ind#'='';
						'attributes.row_ship_id#row_ind#'=0;
						'attributes.row_taxtotal#row_ind#'=xml_row_tax_total_sys*evaluate('paper_rows_#paper_count#_amount_#row_ind#');
						'attributes.row_total#row_ind#'=(xml_row_price_net_sys*evaluate('paper_rows_#paper_count#_amount_#row_ind#'));
						'attributes.row_unique_relation_id#row_ind#'='';
						'attributes.shelf_number#row_ind#'='';
						'attributes.shelf_number_txt#row_ind#'='';
						'attributes.spect_id#row_ind#'='';
						'attributes.spect_name#row_ind#'='';
						'attributes.stock_code#row_ind#'=GET_PRODUCT_ID.STOCK_CODE;
						'attributes.stock_id#row_ind#'=GET_PRODUCT_ID.STOCK_ID;
						
						'attributes.tax#row_ind#'=evaluate('paper_rows_#paper_count#_tax_rate_#row_ind#');
						
						'attributes.tax_price#row_ind#'='';//yazmasakda olur
						'attributes.unit#row_ind#'=GET_PRODUCT_ID.ADD_UNIT;
						'attributes.unit_id#row_ind#'=GET_PRODUCT_ID.PRODUCT_UNIT_ID;
						'attributes.unit_other#row_ind#'='';
						'attributes.basket_employee#row_ind#'='';
						'attributes.basket_employee_id#row_ind#'='';
						'attributes.basket_extra_info#row_ind#'='';
						'attributes.select_info_extra#row_ind#'='';	
						'attributes.detail_info_extra#row_ind#'='';	
					}
					else
					{
						writeoutput('#trim(attributes.invoice_number)# Nolu Belgede Ürün Bulunamadı Veya Birden Fazla Ürün ile Eşleşti!<br/>');
						error_flag=1;
					}
					row_ind=row_ind+1;
				}
				
				//satır yoksa ve hata oluşmadı ise hata var demektir işlem dursun
				if(error_flag eq 0 and (row_ind-1) lt 1){writeoutput('#trim(attributes.invoice_number)# Nolu Belgede Ürün Satırı Bulunamadı!<br/>'); error_flag=1;}
				if(error_flag neq 1)
				{
					row_ind=row_ind-1;//sonda artırarak cıktığından bir azaltıroyoruz
					attributes.rows_ = row_ind;
					if(not len(evaluate('paper_header_'&paper_count&'_paper_discount_1')) or evaluate('paper_header_'&paper_count&'_paper_discount_1') lte 0)
						'paper_header_#paper_count#_paper_discount_1'=0;
					form.basket_discount_total = evaluate('paper_header_'&paper_count&'_paper_discount_1');
					attributes.basket_discount_total = evaluate('paper_header_'&paper_count&'_paper_discount_1');
					xml_basket_net_total_after_paper_discount = (xml_basket_net_total-xml_basket_tax_total) - evaluate('paper_header_'&paper_count&'_paper_discount_1');
					xml_basket_tax_total_after_paper_discount = 0;
					xml_basket_otv_total_after_paper_discount = 0;
					for(ind_inv_row=1;ind_inv_row lte attributes.rows_;ind_inv_row=ind_inv_row+1)
					{
						if(evaluate('attributes.price#ind_inv_row#') gt 0)
						{
							//fatura altı indirim varsa o da hesaplanarak satırlara yansıtılıyor
							row_price_=(1-evaluate('paper_header_'&paper_count&'_paper_discount_1')/(xml_basket_net_total-xml_basket_tax_total))*(evaluate('attributes.price#ind_inv_row#')*evaluate('attributes.amount#ind_inv_row#'));
							tmp_tax=0;
							for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
							{
								if(isdefined('form.basket_tax_#ind_tax_count#') and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_inv_row#'))
								{
									'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*evaluate('paper_rows_#paper_count#_tax_rate_#ind_inv_row#'),2);
									'attributes.basket_tax_value_#ind_tax_count#'=evaluate('form.basket_tax_value_#ind_tax_count#');
									xml_basket_tax_total_after_paper_discount = xml_basket_tax_total_after_paper_discount + wrk_round((row_price_/100)*evaluate('paper_rows_#paper_count#_tax_rate_#ind_inv_row#'),2);
									tmp_tax=1;
									break;
								}
							}
							if(tmp_tax eq 0)
							{
								
								'attributes.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
								'attributes.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*evaluate('paper_rows_#paper_count#_tax_rate_#ind_inv_row#'),2);
								
								'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
								'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*evaluate('paper_rows_#paper_count#_tax_rate_#ind_inv_row#'),2);
								xml_basket_tax_total_after_paper_discount = xml_basket_tax_total_after_paper_discount + evaluate('form.basket_tax_value_#xml_tax_count#');
								xml_tax_count=xml_tax_count+1;
							}
							tmp_otv=0;
							for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
							{
								if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_inv_row#'))
								{
									'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*evaluate('paper_rows_#paper_count#_special_tax_rate_#ind_inv_row#'),2);
									xml_basket_otv_total_after_paper_discount = xml_basket_otv_total_after_paper_discount + wrk_round((row_price_/100)*evaluate('paper_rows_#paper_count#_special_tax_rate_#ind_inv_row#'),2);
									tmp_otv=1;
									break;
								}
							}
							if(tmp_otv eq 0)	
							{
								'form.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_inv_row#');
								'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*evaluate('paper_rows_#paper_count#_special_tax_rate_#ind_inv_row#'),2);
								xml_basket_otv_total_after_paper_discount = xml_basket_otv_total_after_paper_discount + evaluate('form.basket_otv_value_#xml_otv_count#');
								xml_otv_count=xml_otv_count+1;
							}
						}
						else
						{
							xml_basket_tax_total_after_paper_discount = 0;
							xml_basket_otv_total_after_paper_discount = 0;
						}
					}
					
					attributes.basket_gross_total = xml_basket_gross_total;
					form.basket_gross_total = xml_basket_gross_total;
					form.basket_net_total = xml_basket_net_total_after_paper_discount+xml_basket_tax_total_after_paper_discount;//net ama kdv dahili tutuyormuş
					attributes.basket_net_total = xml_basket_net_total_after_paper_discount+xml_basket_tax_total_after_paper_discount;//net ama kdv dahili tutuyormuş
					form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
					attributes.basket_otv_count = xml_otv_count-1;//otv oran sayısı
					form.basket_otv_total = xml_basket_otv_total_after_paper_discount;
					form.basket_tax_total = xml_basket_tax_total_after_paper_discount;
					form.basket_tax_count = xml_tax_count-1;//kdv sayısı
					attributes.basket_tax_count = xml_tax_count-1;//kdv sayısı
					form.genel_indirim = evaluate('paper_header_'&paper_count&'_paper_discount_1');
					form.genel_indirim_ = TLFormat(evaluate('paper_header_'&paper_count&'_paper_discount_1'),2);
					attributes.genel_indirim = evaluate('paper_header_'&paper_count&'_paper_discount_1');
					attributes.genel_indirim_ = TLFormat(evaluate('paper_header_'&paper_count&'_paper_discount_1'),2);
				}
			}
			paper_count=paper_count+1;
		</cfscript>
		<cfcatch>
			<cfif isdefined('paper_header_#paper_count#_paper_no_1')>
				<cfoutput>#evaluate('paper_header_#paper_count#_paper_no_1')#</cfoutput> Nolu Faturada Okuma İşleminde Sorun Oluştu. Dosyayı Kontrol Ediniz!<br/><br/>
			<cfelse>
				Belge No Bilinmiyor, Okuma İşleminde Sorun Oluştu. Dosyayı Kontrol Ediniz!<br/><br/>
			</cfif>
			<cfset paper_count=paper_count+1><!--- okumada hata verdiğinden bir artırmayacak biz burda artırdık o nedenle--->
			<cfset error_flag = 1>
		</cfcatch>
	</cftry>
	<cfif error_flag eq 0>
		<cfset xml_import=1><!--- bu değşiken fatura ve diğer dosyaların takıldığında abort veya history back ile geri dönmelerini engellemektedir --->
		<cfif is_sales eq 1>
			<cfset process_id=53><!--- toptan satış faturası --->
		<cfelse>
			<cfset process_id=55><!--- toptan satış iade--->
		</cfif>
		<cfquery name="get_proc" datasource="#dsn2#">
			SELECT PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE=#process_id#
		</cfquery>
		<cfif get_proc.recordcount>
			<cfset form.process_cat = GET_PROC.PROCESS_CAT_ID><!--- işlem kategorisi --->
			<cfset attributes.process_cat = GET_PROC.PROCESS_CAT_ID><!--- işlem kategorisi alış sayfalarında attribtes ile bakıyor--->
			<cfset 'ct_process_type_#get_proc.PROCESS_CAT_ID#' = process_id>
			<cfset 'attributes.ct_process_type_#get_proc.PROCESS_CAT_ID#' = process_id>
		<cfelse>
			İşlem Kategorilerini Kontrol Ediniz!
			<cfset error_flag =1>
			<cfabort>
		</cfif>
		<cfoutput>#attributes.invoice_number#</cfoutput> Nolu Fatura Kayıt İşlemi;<br/>
		
		<cfif is_sales eq 1>
			<!--- Satis ---->
			<cftry>
				<cfinclude template="../../invoice/query/add_invoice_sale.cfm">
				<cfset max_add_invoice_id=get_invoice_id.max_id>
				<cfoutput>#attributes.invoice_number#</cfoutput> Nolu Fatura Kaydedildi!<br/><br/>
				<cfcatch>
					 <cfoutput>#attributes.invoice_number#</cfoutput> Nolu Fatura Kayıt İşleminde Hata Oluştu. Dosyayı Kontrol Ediniz!<br/><br/>
					 <cfset error_flag =1>
				</cfcatch>
			</cftry>
		<cfelse>
		<!--- Alis ---->
			<cftry>
				<cfinclude template="../../invoice/query/add_invoice_purchase.cfm">
				<cfset max_add_invoice_id=get_invoice_id.max_id>
				<cfoutput>#attributes.invoice_number#</cfoutput> Nolu Fatura Kaydedildi!<br/><br/>
				<cfcatch>
					 <cfoutput>#attributes.invoice_number#</cfoutput> Nolu Fatura Kayıt İşleminde Hata Oluştu. Dosyayı Kontrol Ediniz!<br/><br/>
					 <cfset error_flag =1>
				</cfcatch>
			</cftry>
		</cfif>
		<cfscript>
			//aynı degiskenler bir sonrakindede kullanıldıgından sorun oluyordu, degerler bosaltildi
			for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
			{
				'form.basket_tax_#ind_tax_count#' = '';
				'form.basket_tax_value_#ind_tax_count#' = '';
				'attributes.basket_tax_#ind_tax_count#' = '';
				'attributes.basket_tax_value_#ind_tax_count#' = '';
			}
			for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
			{
				'form.basket_otv_#ind_tax_count#' = '';
				'form.basket_otv_value_#ind_tax_count#' = '';
				'attributes.basket_otv_#ind_tax_count#' = '';
				'attributes.basket_otv_value_#ind_tax_count#' = '';
			}
		</cfscript>
	</cfif>
</cfloop>
