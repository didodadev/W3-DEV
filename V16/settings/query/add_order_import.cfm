<cfsetting showdebugoutput="no">
<!---
<cfinclude template="../../objects/functions/get_basket_money_js.cfm">
<cfinclude template="../../objects/functions/add_relation_rows.cfm">
<cfinclude template="../../objects/functions/add_order_row_reserved_stock.cfm">
<cfinclude template="../../objects/functions/add_paper_relation.cfm">
<cfinclude template="../../objects/functions/add_company_related_action.cfm">
--->
<cfif not isdefined("is_from_webservice")><!--- web service den giriyorsa bu bloğa girmesine gerek yok , zaten dosya okunup geliyor --->
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				fileField = "uploaded_file" 
				destination = "#upload_folder#"
				nameConflict = "MakeUnique"  
				mode="777" charset="utf-8">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cftry>
		<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
		<cffile action="delete" file="#upload_folder##file_name#">
	<cfcatch>
		<script type="text/javascript">
			alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	count_order = 0;
	satir_say = 0;
	is_from_import = 1;
	basket_discount_total = 0;
	basket_gross_total = 0;
	basket_net_total = 0;
	basket_tax_total = 0;
</cfscript>
<font color="FF0000">Siparişler Kaydediliyor Lütfen Sayfayı Yenilemeyiniz !!</font><br/><br/>
<cfloop from="2" to="#line_count#" index="line_row_ii">
	<cfset import_row_ii= 1>
	<cfset error_flag = 0>
	<cftry>
		<cfscript>
			satir_say = satir_say + 1;
			
			act_type = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge mi satır mı 0 ise belge 0 dan büyükse satır olduğunu belirtir
			act_type = trim(act_type);
			import_row_ii=import_row_ii+1;
			
			import_col_1 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için alış satış siparişi mi olduğunu, satır için stok kodu
			import_col_1 = trim(import_col_1);
			import_row_ii=import_row_ii+1;
			
			import_col_2 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için sipariş başlığı , satır için spec kodu
			import_col_2 = trim(import_col_2);
			import_row_ii=import_row_ii+1;
			
			import_col_0 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için bireysel kurumsal tipi , satır için rezerve tipi
			import_col_0 = trim(import_col_0);
			import_row_ii=import_row_ii+1;
			
			import_col_3 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için cari kod , satır için miktar
			import_col_3 = trim(import_col_3);
			import_row_ii=import_row_ii+1;
			
			import_col_4 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için satış çalışanı, satır için birim
			import_col_4 = trim(import_col_4);
			import_row_ii=import_row_ii+1;
			
			import_col_5 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için sipariş tarihi, satır için brüt birim fiyat
			import_col_5 = trim(import_col_5);
			import_row_ii=import_row_ii+1;
			
			import_col_6 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için sevk tarihi, satır için para birimi
			import_col_6 = trim(import_col_6);
			import_row_ii=import_row_ii+1;
			
			import_col_7 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için teslim tarihi, satır için kdv oranı
			import_col_7 = trim(import_col_7);
			import_row_ii=import_row_ii+1;
			
			import_col_8 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için ödeme yöntemi, satır için iskonto 1
			import_col_8 = trim(import_col_8);
			import_row_ii=import_row_ii+1;
			
			import_col_9 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için vade tarihi, satır için iskonto 2
			import_col_9 = trim(import_col_9);
			import_row_ii=import_row_ii+1;
			
			import_col_10 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için teslim adresi, satır için iskonto 3
			import_col_10 = trim(import_col_10);
			import_row_ii=import_row_ii+1;
			
			import_col_11 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için süreç ID, satır için iskonto 4
			import_col_11 = trim(import_col_11);
			import_row_ii=import_row_ii+1;
			
			import_col_12 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için öncelik ID, satır için iskonto 5
			import_col_12 = trim(import_col_12);
			import_row_ii=import_row_ii+1;
			
			import_col_13 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için depo ID, satır için iskonto 6
			import_col_13 = trim(import_col_13);
			import_row_ii=import_row_ii+1;
			
			import_col_14 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için lokasyon ID, satır için aşama ID
			import_col_14 = trim(import_col_14);
			import_row_ii=import_row_ii+1;
			
			import_col_15 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge ve satır için açıklama
			import_col_15 = trim(import_col_15);
			import_row_ii=import_row_ii+1;
			
			import_col_16 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için proimport_row_iie ID, satır için açıklama2
			import_col_16 = trim(import_col_16);
			import_row_ii=import_row_ii+1;
			
			import_col_17 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için özel tanım ID, satır için teslim depo ID
			import_col_17 = trim(import_col_17);
			import_row_ii=import_row_ii+1;
			
			import_col_18 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için sevk yöntemi ID, satır için teslim lokasyon ID
			import_col_18 = trim(import_col_18);
			import_row_ii=import_row_ii+1;
			
			import_col_21 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge için İşlem Dövizi, Fiyat Listesi ID
			import_col_21 = trim(import_col_21);
			import_row_ii=import_row_ii+1;
			
			if(listlen(dosya[line_row_ii],';') gte import_row_ii)
			{
				import_col_22 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge ve satır için kur bilgisi
				import_col_22 = trim(import_col_22);
				import_col_22=Replace(import_col_22,',','.');
				import_row_ii=import_row_ii+1;
			}				
			else
			{
				import_col_22 = '';
				import_row_ii=import_row_ii+1;
			}
				
			if(listlen(dosya[line_row_ii],';') gte import_row_ii)
			{
				import_col_23 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge icin teslim adresi ilce ID si, satir icin bos
				import_col_23 = trim(import_col_23);
				import_row_ii=import_row_ii+1;
			}				
			else
			{
				import_col_23 = '';
				import_row_ii=import_row_ii+1;
			}
	
			if(listlen(dosya[line_row_ii],';') gte import_row_ii)
			{
				import_col_24 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge icin sistem no, satir icin 2.birim
				import_col_24 = trim(import_col_24);
				import_row_ii=import_row_ii+1;
			}				
			else
			{
				import_col_24 = '';
				import_row_ii=import_row_ii+1;
			}
	
			if(listlen(dosya[line_row_ii],';') gte import_row_ii)
			{
				import_col_25 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge icin Teslim Adresi ID, satir 2.miktar
				import_col_25 = trim(import_col_25);
				import_row_ii=import_row_ii+1;
			}				
			else
			{
				import_col_25 = '';
				import_row_ii=import_row_ii+1;
			}
	
			if(act_type eq 0)
			{
				if(listlen(dosya[line_row_ii],';') gte import_row_ii)
				{
					import_col_26 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge icin Şube ID, satir icin bos
					import_col_26 = trim(import_col_26);
					import_row_ii=import_row_ii+1;
				}				
				else
				{
					import_col_26 = '';
					import_row_ii=import_row_ii+1;
				}
				if(listlen(dosya[line_row_ii],';') gte import_row_ii)
				{
					import_col_27 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge icin Referans No, satir icin bos
					import_col_27 = trim(import_col_27);
					import_row_ii=import_row_ii+1;
				}				
				else
				{
					import_col_27 = '';
					import_row_ii=import_row_ii+1;
				}
				if(listlen(dosya[line_row_ii],';') gte import_row_ii)
				{
					import_col_28 = Listgetat(dosya[line_row_ii],import_row_ii,";");//belge icin Sipariş No, satir icin bos
					import_col_28 = trim(import_col_28);
					import_row_ii=import_row_ii+1;
				}				
				else
				{
					import_col_28 = '';
					import_row_ii=import_row_ii+1;
				}
			}
			error_txt_info = '';
				
			GET_SETUP_MONEY=cfquery(SQLString:"SELECT RATE2,RATE1, MONEY MONEY_TYPE,PERIOD_ID FROM SETUP_MONEY",Datasource:dsn2,is_select:1);
			if(act_type eq 0)//belge olan satır ise
			{					
				if(len(import_col_0) eq 0 or len(import_col_11) eq 0 or len(import_col_1) eq 0 or len(import_col_2) eq 0 or len(import_col_4) eq 0 or len(import_col_5) eq 0 or len(import_col_3) eq 0 or len(import_col_7) eq 0 or len(import_col_21) eq 0)
					error_txt_info = '#satir_say#. Satırda Zorunlu Alanlar Eksik !';	
 
				if(not len(error_txt_info))//hataya girmemisse
				{
					import_row_ind = 1;
					attributes.active_company=session.ep.company_id;
					
					if(import_col_0 eq 'K')
					{
						GET_MEMBER_INFO=cfquery(SQLString:"SELECT COMPANY_ID,MANAGER_PARTNER_ID FROM COMPANY WHERE MEMBER_CODE = '#import_col_3#'",Datasource:dsn,is_select:1);
						if(GET_MEMBER_INFO.recordcount)
						{
							attributes.company_id = GET_MEMBER_INFO.COMPANY_ID;
							attributes.partner_id = GET_MEMBER_INFO.MANAGER_PARTNER_ID;
							attributes.consumer_id = '';
						}
						else
							error_txt_info = '#satir_say#. Satır Girilen Üye Koduna Ait Kurumsal Üye Kaydı Bulunamadı !';
					}
					else
					{
						GET_MEMBER_INFO=cfquery(SQLString:"SELECT CONSUMER_ID FROM CONSUMER WHERE MEMBER_CODE = '#import_col_3#'",Datasource:dsn,is_select:1);
						if(GET_MEMBER_INFO.recordcount)
						{
							attributes.company_id = '';
							attributes.partner_id = '';
							attributes.consumer_id = GET_MEMBER_INFO.CONSUMER_ID;
						}
						else
							error_txt_info = '#satir_say#. Satır Girilen Üye Koduna Ait Bireysel Üye Kaydı Bulunamadı !';
					}
					attributes.deliverdate = import_col_7;
					attributes.ship_date = import_col_6;
					
					attributes.order_date = import_col_5;
					attributes.basket_due_value_date_ = import_col_9;
					
					//kurlar ile ilgili değişkenler oluşuyor		
					for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
					{
						GET_MONEY_HISTORY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE >=#createodbcdatetime(attributes.order_date)# AND MONEY ='#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE ",Datasource:dsn,is_select:1);
						if(GET_SETUP_MONEY.MONEY_TYPE[stp_mny] eq import_col_21 and len(import_col_22))		
							'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='1;#import_col_22#';
						else
						{
							if(GET_MONEY_HISTORY.RECORDCOUNT)
								'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_MONEY_HISTORY.RATE1#;#GET_MONEY_HISTORY.RATE2#';
							else
								'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_SETUP_MONEY.RATE1[stp_mny]#;#GET_SETUP_MONEY.RATE2[stp_mny]#';
						}					
						'attributes.hidden_rd_money_#stp_mny#'=GET_SETUP_MONEY.MONEY_TYPE[stp_mny];
						'attributes.txt_rate1_#stp_mny#'=listfirst(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');		
						if(GET_SETUP_MONEY.MONEY_TYPE[stp_mny] eq import_col_21 and len(import_col_22))		
							'attributes.txt_rate2_#stp_mny#' = import_col_22;
						else
							'attributes.txt_rate2_#stp_mny#' = listlast(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');
					}
					attributes.basket_money=import_col_21;
					attributes.basket_rate1=listfirst(evaluate('#attributes.basket_money#_rate'),';');
					attributes.basket_rate2=listlast(evaluate('#attributes.basket_money#_rate'),';');
					attributes.currency_multiplier = '';
					attributes.kur_say=GET_SETUP_MONEY.RECORDCOUNT;
					
					attributes.basket_id=4;
					
					attributes.subscription_id = "";
					attributes.deliver_dept_id = import_col_13;
					attributes.deliver_loc_id = import_col_14;
					attributes.deliver_dept_name = import_col_13;//len kontrolune takılmasn diye,zaten tutulmuyor
					deliver_dept_id.deliver_dept_id = import_col_13;
					deliver_dept_id.deliver_loc_id = import_col_14;
					deliver_dept_id.deliver_dept_name = import_col_13;//len kontrolune takılmasn diye,zaten tutulmuyor
					attributes.process_stage = import_col_11;				
						
					attributes.ref_company_id = "";
					attributes.ref_member_type = "";
					attributes.ref_member_id = "";
					attributes.ref_company = "";
					
					attributes.paymethod_id = import_col_8;
					attributes.paymethod = import_col_8;
					attributes.pay_method = import_col_8;//satinalmada bu sekilde kayitli
					attributes.order_employee_id = import_col_4;
					attributes.order_employee = import_col_4;
					attributes.detail = import_col_15;
					attributes.order_detail = import_col_15;
					attributes.reserved = 1;
					
					attributes.project_id = import_col_16;
					attributes.project_head = import_col_16;
					attributes.ref_no =import_col_27;
					attributes.sales_add_option = import_col_17;
					attributes.order_head = import_col_2;
					attributes.genel_indirim = 0;
					if (not len(attributes.genel_indirim)) attributes.genel_indirim=0;
					
					attributes.general_prom_limit=0;
					attributes.general_prom_discount=0;
					attributes.general_prom_amount=0;
					attributes.free_prom_limit=0;
					attributes.free_prom_amount=0;
					attributes.free_prom_cost=0;
					attributes.publishdate='';
					attributes.ship_method_id = import_col_18;
					
					sales_purchase_import = import_col_1;
					
					attributes.ship_address_city_id = '';
					attributes.ship_address_county_id = '';
					attributes.ship_address_id = import_col_25;			
					attributes.ship_address = import_col_10;			
					attributes.frm_branch_id = import_col_26;	
					attributes.order_number = import_col_28;	
					if (len(import_col_23))
					{
						GET_COUNTY_INFO=cfquery(SQLString:"SELECT COUNTY_ID,CITY FROM SETUP_COUNTY WHERE COUNTY_ID = '#import_col_23#'",Datasource:dsn,is_select:1);
						if(GET_COUNTY_INFO.recordcount)
						{
							attributes.ship_address_city_id = GET_COUNTY_INFO.CITY;
							attributes.ship_address_county_id = GET_COUNTY_INFO.COUNTY_ID;
						}
					}
					attributes.subscription_id = import_col_24;
					attributes.subscription_no = import_col_24;
				}
			}
			else//satır ise
			{
				if(not len(error_txt_info) and isdefined("import_row_ind"))//hataya girmemişse
				{		
					if(len(import_col_0) eq 0 or len(import_col_11) eq 0 or len(import_col_1) eq 0 or len(import_col_2) eq 0 or len(import_col_4) eq 0 or len(import_col_5) eq 0 or len(import_col_3) eq 0 or len(import_col_7) eq 0 or len(import_col_21) eq 0)
						error_txt_info = '#satir_say#. Satırda Zorunlu Alanlar Eksik!';

					if(not len(error_txt_info))//hataya girmemişse
					{
						if(not len(import_col_22))
						{
							GET_MONEY_HISTORY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE >=#createodbcdatetime(attributes.order_date)# AND MONEY ='#import_col_6#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE ",Datasource:dsn,is_select:1);
							
							if(GET_MONEY_HISTORY.RECORDCOUNT)
								row_rate_info=GET_MONEY_HISTORY.RATE2/GET_MONEY_HISTORY.RATE1;
							else
							{
								GET_S_MONEY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM SETUP_MONEY WHERE MONEY ='#import_col_6#'",Datasource:dsn2,is_select:1);
								row_rate_info=GET_S_MONEY.RATE2/GET_S_MONEY.RATE1;
							}
						}
						else
							row_rate_info=import_col_22;
						
						//Urun Kayit Tipi Stok kodu ise
						if(attributes.stock_record_type eq 1)
							where_sql = "S.STOCK_CODE = '#import_col_1#'";						
						else
							where_sql = "S.STOCK_CODE_2 = '#import_col_1#'";						
						product_sql_str="SELECT
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
											S.IS_PROTOTYPE,
											PU.ADD_UNIT,
											PU.PRODUCT_UNIT_ID,
											PU.MULTIPLIER
										FROM
											STOCKS AS S,
											PRODUCT_UNIT AS PU
										WHERE
											S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
											S.PRODUCT_ID = PU.PRODUCT_ID AND
											PU.MAIN_UNIT = PU.ADD_UNIT AND										
											#where_sql#
										";
						
						GET_PRODUCT_INFO=cfquery(SQLString:"#product_sql_str#",Datasource:dsn3,is_select:1);
	
						if(GET_PRODUCT_INFO.recordcount)
						{
	
							if( len(import_col_24) and len(import_col_25) and len(GET_PRODUCT_INFO.PRODUCT_ID) ){
								product_unit_2_sql_str="SELECT
															ADD_UNIT,
															PRODUCT_UNIT_ID,
															MULTIPLIER
														FROM
															PRODUCT_UNIT
														WHERE
															PRODUCT_ID = #GET_PRODUCT_INFO.PRODUCT_ID# AND
															ADD_UNIT = '#import_col_24#' AND
															MAIN_UNIT = '#GET_PRODUCT_INFO.ADD_UNIT#'
														";
	
								GET_PRODUCT_UNIT_2_INFO = cfquery(SQLString:"#product_unit_2_sql_str#",Datasource:dsn3,is_select:1);
							}
							else {
								GET_PRODUCT_UNIT_2_INFO.recordcount = 0;
							}
	
							if(len(import_col_8)) row_disc1=import_col_8; else row_disc1=0;
							if(len(import_col_9)) row_disc2=import_col_9; else row_disc2=0;
							if(len(import_col_10)) row_disc3=import_col_10; else row_disc3=0;
							if(len(import_col_11)) row_disc4=import_col_11; else row_disc4=0;
							if(len(import_col_12)) row_disc5=import_col_12; else row_disc5=0;
							if(len(import_col_13)) row_disc6=import_col_13; else row_disc6=0;
							row_disc7 = 0;
							row_disc8 = 0;
							row_disc9 = 0;
							row_disc10 = 0;
							order_disc_rate_ = 100000000000000000000 -((100-row_disc1) * (100-row_disc2) * (100-row_disc3) * (100-row_disc4) * (100-row_disc5) * (100-row_disc6) * (100-row_disc7) * (100-row_disc8) * (100-row_disc9) * (100-row_disc10));
							import_col_5 = Replace(Replace(import_col_5,'.','','all'),',','.','all');
							satir_toplam = import_col_5*import_col_3;
							nettotal = wrk_round((satir_toplam - (satir_toplam*order_disc_rate_/100000000000000000000)),4);
							other_money_info = wrk_round(nettotal/row_rate_info,4);
							if(len(import_col_2))
							{
								spect_sql_str="SELECT
											SP.SPECT_VAR_NAME,
											SP.SPECT_VAR_ID
										FROM
											SPECTS SP
										WHERE
											SP.SPECT_VAR_ID = '#import_col_2#'
										";
								GET_SPECT_INFO=cfquery(SQLString:"#spect_sql_str#",Datasource:dsn3,is_select:1);
								if(GET_SPECT_INFO.recordcount)
								{
									'attributes.spect_id#import_row_ind#'=GET_SPECT_INFO.SPECT_VAR_ID;
									'attributes.spect_name#import_row_ind#'=GET_SPECT_INFO.SPECT_VAR_NAME;
								}
								else
								{
									'attributes.spect_id#import_row_ind#'='';
									'attributes.spect_name#import_row_ind#'='';
								}
							}
							else
							{
								'attributes.spect_id#import_row_ind#'='';
								'attributes.spect_name#import_row_ind#'='';
							}
							'attributes.spec_info#import_row_ind#'='';
							'GET_TREE#import_row_ind#'='';
							if(len(import_col_21))
							{
								price_sql_str="SELECT
												P.PRICE_KDV
											FROM
												PRICE P
											WHERE
												P.PRICE_CATID = #import_col_21#
												AND (FINISHDATE IS NULL OR FINISHDATE > #now()#)
												AND PRODUCT_ID = #GET_PRODUCT_INFO.PRODUCT_ID#
										";
								GET_PRICE_INFO=cfquery(SQLString:"#price_sql_str#",Datasource:dsn3,is_select:1);
								if(GET_PRICE_INFO.recordcount)
								{
									'attributes.list_price#import_row_ind#'=GET_PRICE_INFO.PRICE_KDV;
									'attributes.price_cat#import_row_ind#'=import_col_21;
								}
								else
								{
									'attributes.list_price#import_row_ind#'='';
									'attributes.price_cat#import_row_ind#'='';
								}
							}
							else
							{
								'attributes.list_price#import_row_ind#'='';
								'attributes.price_cat#import_row_ind#'='';
							}
							'attributes.product_id#import_row_ind#'=GET_PRODUCT_INFO.PRODUCT_ID;
							'attributes.stock_id#import_row_ind#'=GET_PRODUCT_INFO.STOCK_ID;
							'attributes.amount#import_row_ind#'=import_col_3;
							'attributes.unit#import_row_ind#'=GET_PRODUCT_INFO.ADD_UNIT;
							'attributes.unit_id#import_row_ind#'=GET_PRODUCT_INFO.PRODUCT_UNIT_ID;
							'attributes.price#import_row_ind#'=import_col_5;
							'attributes.price_other#import_row_ind#'=wrk_round(import_col_5/row_rate_info,4);
							'attributes.tax#import_row_ind#'=import_col_7;					
							'attributes.row_nettotal#import_row_ind#'=nettotal;
							'attributes.product_name#import_row_ind#'=GET_PRODUCT_INFO.PRODUCT_NAME;
							'attributes.other_money_#import_row_ind#'=import_col_6;
							'attributes.other_money_gross_total#import_row_ind#'=other_money_info;
							'attributes.other_money_value_#import_row_ind#'=other_money_info;
							'attributes.order_currency#import_row_ind#'=import_col_14;
							'attributes.reserve_type#import_row_ind#'=import_col_0;
							'attributes.is_production#import_row_ind#'=GET_PRODUCT_INFO.IS_PRODUCTION;
							'attributes.is_inventory#import_row_ind#'=GET_PRODUCT_INFO.IS_INVENTORY;					
							'attributes.indirim1#import_row_ind#'= row_disc1;
							'attributes.indirim2#import_row_ind#'= row_disc2;
							'attributes.indirim3#import_row_ind#'=row_disc3;
							'attributes.indirim4#import_row_ind#'=row_disc4;
							'attributes.indirim5#import_row_ind#'=row_disc5;
							'attributes.indirim6#import_row_ind#'=row_disc6;
							'attributes.product_name_other#import_row_ind#'=import_col_16;
							'attributes.indirim7#import_row_ind#'=0;
							'attributes.indirim8#import_row_ind#'=0;
							'attributes.indirim9#import_row_ind#'=0;
							'attributes.indirim10#import_row_ind#'=0;
							'attributes.iskonto_tutar#import_row_ind#'=0;
							'attributes.ek_tutar_price#import_row_ind#'=0;
							'attributes.ek_tutar#import_row_ind#'=0;
							'attributes.ek_tutar_other_total#import_row_ind#'=0;
							'attributes.ek_tutar_total#import_row_ind#'=0;
							'attributes.extra_cost#import_row_ind#'=0;
							'attributes.otv_oran#import_row_ind#'=0;
							'attributes.row_otvtotal#import_row_ind#'=0;
							'attributes.description#import_row_ind#'=import_col_23;
							'attributes.wrk_row_id#import_row_ind#'="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#";
	
							if( len(import_col_24) and len(import_col_25) ) {
								'attributes.unit_other#import_row_ind#' = import_col_24;
								'attributes.amount_other#import_row_ind#' = import_col_25;
								if( GET_PRODUCT_UNIT_2_INFO.recordcount ) {
									if ( len(GET_PRODUCT_UNIT_2_INFO.MULTIPLIER) ) {
										'attributes.amount#import_row_ind#' = import_col_25 * GET_PRODUCT_UNIT_2_INFO.MULTIPLIER;
									}
								}
							}
							
							if(GET_PRODUCT_INFO.IS_PROTOTYPE eq 1)
								'attributes.spec_info#import_row_ind#' = 0;
							else
								'attributes.spec_info#import_row_ind#' = 1;
								
							'attributes.deliver_dept#import_row_ind#'="#import_col_17#-#import_col_18#";
							
							basket_discount_total = basket_discount_total + wrk_round((satir_toplam*order_disc_rate_/100000000000000000000),4);
							basket_gross_total = basket_gross_total + satir_toplam;
							basket_net_total = basket_net_total + (evaluate('attributes.row_nettotal#import_row_ind#') + (evaluate('attributes.row_nettotal#import_row_ind#')*evaluate('attributes.tax#import_row_ind#')/100));
							basket_tax_total = basket_tax_total + (evaluate('attributes.row_nettotal#import_row_ind#')*evaluate('attributes.tax#import_row_ind#')/100);					
							import_row_ind=import_row_ind+1;
						}
						else
							error_txt_info = '#satir_say#. Satır Girilen Stok Koduna Ait Ürün Kaydı Bulunamadı !';
					}
				}
			}
		</cfscript>	
		<cfcatch type="Any">
			<cfoutput>#line_row_ii#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
		</cfcatch>	
	</cftry>
	<cfif not len(error_txt_info) and isdefined("import_row_ind")>
		<cfif line_row_ii eq line_count or Listgetat(dosya[line_row_ii+1],1,";") eq 0><!--- Son satırsa veya bundan sonraki satır sipariş satırı ise ekleme sayfasına gidecek --->
			<cfscript>
				attributes.basket_discount_total = basket_discount_total;
				attributes.basket_gross_total = basket_gross_total;
				attributes.basket_net_total = basket_net_total;
				attributes.basket_tax_total = basket_tax_total;
				count_order = count_order + 1;
				import_row_ind=import_row_ind-1;
				basket_discount_total = 0;
				basket_gross_total = 0;
				basket_net_total = 0;
				basket_tax_total = 0;
				attributes.rows_ = import_row_ind;
				wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100);
				xml_import=1;
				attributes.order_status = 1;
			</cfscript>
			<cfif sales_purchase_import eq 1>
				<cfset add_order_error = 0>
				<cfinclude template="../../sales/query/add_order.cfm">
				<cfif add_order_error eq 0>
					<cfset error_txt_info = '#count_order#. Satırdaki Sipariş Kaydedildi. Sipariş No : #paper_full#'>
				<cfelse>
					<cfset error_txt_info = '#count_order#. Satırdaki Sipariş Kaydedilirken Sorun Oluştu !'>
				</cfif>
			<cfelse>
				<cfinclude template="../../purchase/query/add_order.cfm">
				<cfset error_txt_info = '#count_order#. Satırdaki Sipariş Kaydedildi. Sipariş No : #paper_full#'>
			</cfif>
		</cfif>
	</cfif>
	<cfif len(error_txt_info)><cfoutput>#error_txt_info#</cfoutput><br/></cfif>
</cfloop>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_order_import</cfoutput>";
</script>