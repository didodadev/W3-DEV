<cfscript>
	wrk_xml_read(xml_file:'#upload_folder#pos#dir_seperator##IMPORT_FILE.FILE_NAME#');
	attributes.active_period=session.ep.period_id;
	form.active_period=session.ep.period_id;
	for(paper_count=1;paper_count lte 4;paper_count=paper_count+1)//xmlde hangi tagdan itibaren paper blokları basliyor
	{
		if(isdefined('paper_header_#paper_count#'))
			break;
	}
	GET_SETUP_MONEY=cfquery(SQLString:"SELECT RATE2,RATE1, MONEY MONEY_TYPE,PERIOD_ID FROM SETUP_MONEY",Datasource:dsn2,is_select:1);//kurlar alınıyor
	attributes.department_id = IMPORT_FILE.DEPARTMENT_ID;
	attributes.location_id = IMPORT_FILE.DEPARTMENT_LOCATION;
	attributes.department_name = 'a';
	cross_account_code = '';
</cfscript>

<cfloop condition="isdefined('paper_header_#paper_count#')">
	<cftry>
		<cfscript>
			error_flag=0;
			row_ind=1;//hangi satırda oldugu
			if(isdefined('paper_header_#paper_count#_paper_type_#row_ind#') and ListFindNoCase('TA',evaluate('paper_header_'&paper_count&'_paper_type_'&row_ind),','))
			{
				if(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#') and ListFindNoCase('PE,Pe',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')))
					payment_type=1;// kasa tahsilat
				else if(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#') and ListFindNoCase('PO,Po,TK,Tk',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')))
					payment_type=3;//pos tahsilat = taksit kart
				else if(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#') and ListFindNoCase('BA,Ba',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')))
					payment_type=5;//gelen havale
				else if(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#') and ListFindNoCase('KK,Kk',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')))
					payment_type=7;//cari virman
				else
					error_flag=1;
			}
			else if(isdefined('paper_header_#paper_count#_paper_type_#row_ind#') and ListFindNoCase('TE',evaluate('paper_header_'&paper_count&'_paper_type_'&row_ind),','))
			{
				if(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#') and ListFindNoCase('PE,Pe',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')))
					payment_type=2;//kasa ödeme
				else if(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#') and ListFindNoCase('PO,Po,TK,Tk',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')))
					payment_type=4;//pos tahsilat iptal = taksit kart iptal
				else if(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#') and ListFindNoCase('BA,Ba',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')))
					payment_type=6;//giden havale
				else if(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#') and ListFindNoCase('KK,Kk',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')))
					payment_type=7;//cari virman
				else
					{
						writeoutput(trim(evaluate('paper_header_'&paper_count&'_paper_no_'&row_ind)) & ' Nolu Belge Tipinde Hata Var. Dosyayı Kotrol Ediniz!<br/>');
						error_flag=1;
					}
			}
			else
			{
				writeoutput(trim(evaluate('paper_header_'&paper_count&'_paper_no_'&row_ind)) & ' Nolu Belge Tipinde Hata Var. Dosyayı Kotrol Ediniz!<br/>');
				error_flag=1;
			}
			
			if(error_flag eq 0)
			{
				//Cari Kurumsal- Bireysel Kontrolleri
				GET_MEMBER_ID.RECORDCOUNT = 0;
				if(not len(evaluate('paper_header_'&paper_count&'_member_type_'&row_ind)) or evaluate('paper_header_'&paper_count&'_member_type_'&row_ind) eq 'company')
				{
					member_sql_str="SELECT
										1 MEMBER_TYPE,
										C.COMPANY_ID MEMBER_ID,
										ISNULL(C.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = C.COMPANY_ID)) PARTNER_ID,
										CP.ACCOUNT_CODE ACCOUNT_CODE
									FROM 
										COMPANY C,
										COMPANY_PERIOD CP
									WHERE 
										CP.COMPANY_ID = C.COMPANY_ID AND
										CP.PERIOD_ID = #session.ep.period_id#";
										
					if(isdefined("member_sql_str") and len(member_sql_str))
					{
						if(payment_type eq 7)//virman iptal isleminde bank ve member code degerlerinin yer degistirmesi istendi buna gore duzenlendi fbs20091114
						{
							if(ListFindNoCase('TE',evaluate('paper_header_'&paper_count&'_paper_type_'&row_ind),',') and len(evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind)))
								cross_account_code = evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind);
							else
								cross_account_code = evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind);
							
							GET_MEMBER_ID=cfquery(SQLString:"#member_sql_str# AND CP.ACCOUNT_CODE = '#cross_account_code#'",Datasource:dsn,is_select:1);
						}
						else
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
				}
				if(GET_MEMBER_ID.RECORDCOUNT eq 0)
				{
					member_sql_str="SELECT
										2 MEMBER_TYPE,
										C.CONSUMER_ID MEMBER_ID,
										'' PARTNER_ID,
										CP.ACCOUNT_CODE ACCOUNT_CODE
									FROM 
										CONSUMER C,
										CONSUMER_PERIOD CP
									WHERE 
										CP.CONSUMER_ID = C.CONSUMER_ID AND
										CP.PERIOD_ID = #session.ep.period_id#";
					
					if(isdefined("member_sql_str") and len(member_sql_str))
					{
						if(payment_type eq 7)//virman iptal isleminde bank ve member code degerlerinin yer degistirmesi istendi buna gore duzenlendi fbs20091114
						{
							if(ListFindNoCase('TE',evaluate('paper_header_'&paper_count&'_paper_type_'&row_ind),',') and len(evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind)))
								cross_account_code = evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind);
							else
								cross_account_code = evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind);
							
							GET_MEMBER_ID=cfquery(SQLString:"#member_sql_str# AND CP.ACCOUNT_CODE = '#cross_account_code#'",Datasource:dsn,is_select:1);
						}
						else
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
					
				}
	
				//Belge No Degerleri
				attributes.paper_code = 'XML'; //release sonrasi paper_code alanlari kalkabilir, kullanilmiyor
				form.paper_code = 'XML';
				attributes.paper_number = trim(evaluate('paper_header_'&paper_count&'_paper_no_'&row_ind));
				form.paper_number = trim(evaluate('paper_header_'&paper_count&'_paper_no_'&row_ind));
				
				if(payment_type eq 1)//kasa tahsilat
					GET_PAPER_NO = cfquery(SQLString:"SELECT PAPER_NO FROM CASH_ACTIONS WHERE PAPER_NO='#attributes.paper_number#'",Datasource:dsn2,is_select:1);
				else if(payment_type eq 2)//kasa ödeme
					GET_PAPER_NO = cfquery(SQLString:"SELECT PAPER_NO FROM CASH_ACTIONS WHERE PAPER_NO='#attributes.paper_number#'",Datasource:dsn2,is_select:1);
				else if(ListFind('3,4',payment_type,','))//pos tahsilat ve pos tahsilat iptal islemleri
					GET_PAPER_NO = cfquery(SQLString:"SELECT PAPER_NO FROM CREDIT_CARD_BANK_PAYMENTS WHERE PAPER_NO='#attributes.paper_number#'",Datasource:dsn3,is_select:1);
				else if(ListFind('5,6',payment_type,','))//gelen havale, giden havale
					GET_PAPER_NO = cfquery(SQLString:"SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO='#attributes.paper_number#'",Datasource:dsn2,is_select:1);
				else if(payment_type eq 7)//Cari Virman
					GET_PAPER_NO = cfquery(SQLString:"SELECT PAPER_NO FROM CARI_ACTIONS WHERE PAPER_NO='#attributes.paper_number#'",Datasource:dsn2,is_select:1);
				
				attributes.action_date = evaluate('paper_header_'&paper_count&'_action_date_'&row_ind);
				attributes.action_detail = evaluate('paper_header_'&paper_count&'_paper_discount_'&row_ind);
				action_detail = evaluate('paper_header_'&paper_count&'_paper_discount_'&row_ind);
				attributes.employee_id = '';
				employee_id = '';
				attributes.emp_name = '';
				emp_name = '';
				revenue_collector = 'a';
				revenue_collector_id = session.ep.userid;
				attributes.project_id = '';
				attributes.project_name = '';
				attributes.paper_printer_id = '';
				attributes.company_name='a';
				company_name='a';
				attributes.comp_name='b';
				comp_name='b';
				attributes.partner_id='';
				partner_id='';
	
	
				if(ListFind('1,2,3,4,5,6,7',payment_type,','))
				{
					// Belge Numaralarina bakiliyor
					if(GET_PAPER_NO.RECORDCOUNT gt 0)
					{
						writeoutput('#attributes.paper_number# Belge Numarası Kullanılıyor!<br/>');
						error_flag = 1;
					}
					
					// Kur Degerleri Aliniyor, Hepsinde ayni Degerler Oldugundan Tek Bir Yerde Cekiliyor
					for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
					{
						GET_MONEY_HISTORY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE >=#createodbcdatetime(attributes.action_date)# AND MONEY ='#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE ",Datasource:dsn,is_select:1);
						if(GET_MONEY_HISTORY.RECORDCOUNT)
							'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_MONEY_HISTORY.RATE1#;#GET_MONEY_HISTORY.RATE2#';
						else
							'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_SETUP_MONEY.RATE1[stp_mny]#;#GET_SETUP_MONEY.RATE2[stp_mny]#';
						'attributes.hidden_rd_money_#stp_mny#'=GET_SETUP_MONEY.MONEY_TYPE[stp_mny];
						'attributes.txt_rate1_#stp_mny#'=listfirst(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');				
						'attributes.txt_rate2_#stp_mny#'=listlast(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');
					}
					attributes.kur_say=GET_SETUP_MONEY.RECORDCOUNT;
				}
				
				if(payment_type eq 1)//kasa tahsilat
				{
					if(isdefined('GET_MEMBER_ID') and GET_MEMBER_ID.RECORDCOUNT eq 1)
					{
						
						if(GET_MEMBER_ID.MEMBER_TYPE eq 1)
						{
							attributes.cash_action_from_company_id=GET_MEMBER_ID.MEMBER_ID;
							cash_action_from_company_id=GET_MEMBER_ID.MEMBER_ID;
							attributes.partner_id=GET_MEMBER_ID.PARTNER_ID;
							partner_id=GET_MEMBER_ID.PARTNER_ID;
							attributes.cash_action_from_consumer_id='';
							cash_action_from_consumer_id='';
						}
						else
						{
							attributes.cash_action_from_company_id='';
							cash_action_from_company_id='';
							attributes.cash_action_from_consumer_id=GET_MEMBER_ID.MEMBER_ID;
							cash_action_from_consumer_id=GET_MEMBER_ID.MEMBER_ID;
						}
					}
					else
					{
						writeoutput('#attributes.paper_number# Nolu Belgede Üye Bulunamadı veya Birden Fazla Üye ile Eşleşti!<br/>');
						error_flag=1;
					}
							
					if(error_flag eq 0)
					{
						while(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#'))
						{
							if(len(evaluate('paper_payment_'&paper_count&'_cash_account_code_'&row_ind)))
							{
								cash_account_code=evaluate('paper_payment_'&paper_count&'_cash_account_code_'&row_ind);
								payment_sql_str="SELECT * FROM CASH WHERE CASH_ACC_CODE = '#cash_account_code#'";
								GET_PAYMENT=cfquery(SQLString:"#payment_sql_str#",Datasource:dsn2,is_select:1);
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgede Muhasebe Kodları Eksik!<br/>');
								error_flag=1;
							}
							
							if(GET_PAYMENT.RECORDCOUNT eq 1)
							{
								if(listfind('tl,TL',evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind),','))
									'paper_payment_#paper_count#_price_money_#row_ind#' = 'TL';
								cash_rate=1;
								attributes.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								form.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
	
								other_money_rate=1;
								for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
								{
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq GET_PAYMENT.CASH_CURRENCY_ID)
										cash_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind))
										other_money_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
								}
								attributes.cash_action_to_cash_id = '#GET_PAYMENT.CASH_ID#;#GET_PAYMENT.CASH_CURRENCY_ID#;#ListGetAt(session.ep.user_location,2,"-")#';
								attributes.cash_action_value = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind);
								attributes.system_amount = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind)*cash_rate;//kasanın para brimine göre bunu çarpmalıyız
								attributes.other_cash_act_value = attributes.system_amount/other_money_rate;//altta seçiliye göre
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgede İlgili Hesap Bulunamadı veya Birden Fazla Hesap ile Eşleşti!<br/>');
								error_flag=1;
							}
							row_ind=row_ind+1;
						}
						row_ind=row_ind-1;//sonda artırarak cıktığından bir azaltıroyoruz
					}
				}
				else if(payment_type eq 2)//kasa ödeme
				{
					if(isdefined('GET_MEMBER_ID') and GET_MEMBER_ID.RECORDCOUNT eq 1)
					{
						if(GET_MEMBER_ID.MEMBER_TYPE eq 1)
						{
							attributes.cash_action_to_company_id=GET_MEMBER_ID.MEMBER_ID;
							cash_action_to_company_id=GET_MEMBER_ID.MEMBER_ID;
							attributes.partner_id=GET_MEMBER_ID.PARTNER_ID;
							partner_id=GET_MEMBER_ID.PARTNER_ID;
							attributes.cash_action_to_consumer_id='';
							cash_action_to_consumer_id='';
						}
						else
						{
							attributes.cash_action_to_company_id='';
							cash_action_to_company_id='';
							attributes.cash_action_to_consumer_id=GET_MEMBER_ID.MEMBER_ID;
							cash_action_to_consumer_id=GET_MEMBER_ID.MEMBER_ID;
						}
					}
					else
					{
						writeoutput('#attributes.paper_number# Nolu Belgede Üye Bulunamadı veya Birden Fazla Üye ile Eşleşti!<br/>');
						error_flag=1;
					}
							
					attributes.expense_center = '';
					attributes.expense_center_id='';
					attributes.expense_item_id='';
					attributes.expense_item_name='';
					attributes.exp_emp_id='';
					attributes.exp_emp_name='';
					
					attributes.payer_name = 'a';
					payer_name = 'a';
					attributes.payer_id = session.ep.userid;
					payer_id =session.ep.userid;
					
					if(error_flag eq 0)
					{
						while(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#'))
						{
							if(len(evaluate('paper_payment_'&paper_count&'_cash_account_code_'&row_ind)))
							{
								cash_account_code=evaluate('paper_payment_'&paper_count&'_cash_account_code_'&row_ind);
								payment_sql_str="SELECT * FROM CASH WHERE CASH_ACC_CODE = '#cash_account_code#'";
								GET_PAYMENT=cfquery(SQLString:"#payment_sql_str#",Datasource:dsn2,is_select:1);
							}
							else
							{
								error_flag=1;
								writeoutput('#attributes.paper_number# Nolu Belgede Muhasebe Kodları Eksik!<br/>');
							}
			
							if(GET_PAYMENT.RECORDCOUNT eq 1)
							{
								if(listfind('tl,TL',evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind),','))
									'paper_payment_#paper_count#_price_money_#row_ind#'= 'TL';
								cash_rate=1;
								attributes.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								form.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								other_money_rate=1;
							
								for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
								{
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq GET_PAYMENT.CASH_CURRENCY_ID)
										cash_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind))
										other_money_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
								}
								attributes.cash_action_from_cash_id = '#GET_PAYMENT.CASH_ID#;#GET_PAYMENT.CASH_CURRENCY_ID#;#ListGetAt(session.ep.user_location,2,"-")#';
								attributes.cash_action_value = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind);
								attributes.system_amount = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind)*cash_rate;//kasanın para brimine göre bunu çarpmalıyız
								attributes.other_cash_act_value = attributes.system_amount/other_money_rate;//altta seçiliye göre
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgenin İşlem Yapılacak Kasa Hesabı Bulunamadı veya Birden Fazla Hesap ile Eşleşti!<br/>');
								error_flag=1;
							}
							row_ind=row_ind+1;
						}
						row_ind=row_ind-1;//sonda artırarak cıktığından bir azaltıroyoruz
					}
				}
				else if(ListFind('3,4',payment_type,','))//pos tahsilat ve iptal islemleri
				{
					if(isdefined('GET_MEMBER_ID') and GET_MEMBER_ID.RECORDCOUNT eq 1)
					{
						if(GET_MEMBER_ID.MEMBER_TYPE eq 1)
						{
							attributes.action_from_company_id=GET_MEMBER_ID.MEMBER_ID;
							action_from_company_id=GET_MEMBER_ID.MEMBER_ID;
							attributes.par_id=GET_MEMBER_ID.PARTNER_ID;
							par_id=GET_MEMBER_ID.PARTNER_ID;
							attributes.cons_id='';
							cons_id='';
						}
						else
						{
							attributes.action_from_company_id='';
							action_from_company_id='';
							attributes.par_id=GET_MEMBER_ID.PARTNER_ID;
							par_id=GET_MEMBER_ID.PARTNER_ID;
							attributes.cons_id=GET_MEMBER_ID.MEMBER_ID;
							cons_id=GET_MEMBER_ID.MEMBER_ID;
						}
					}
					else
					{
						writeoutput('#attributes.paper_number# Nolu Belgede Üye Bulunamadı veya Birden Fazla Üye ile Eşleşti!<br/>');
						error_flag=1;
					}
						
					attributes.card_no='';
					card_no='';
					attributes.card_owner='';
					card_owner='';
					
					if(error_flag eq 0)
					{
						while(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#'))
						{
							if(len(evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind)))
							{
								bank_account_code=evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind);
								payment_sql_str="SELECT 
													ACCOUNTS.ACCOUNT_ID,
													ACCOUNTS.ACCOUNT_CURRENCY_ID,
													ACCOUNTS.ACCOUNT_ACC_CODE,
													CPT.PAYMENT_RATE,
													CPT.PAYMENT_RATE_ACC,
													CPT.PAYMENT_TYPE_ID
												FROM 
													ACCOUNTS ACCOUNTS,
													CREDITCARD_PAYMENT_TYPE CPT
												WHERE 
													ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#' AND
													ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
													CPT.IS_ACTIVE = 1";
								
								
								if(ListFindNoCase('TK,Tk',evaluate('paper_payment_#paper_count#_payment_type_#row_ind#')) and payment_type eq 4) //Tk tiplerinde kredi karti tahsilat yontemlerindeki muhasebe kodu baz aliniyor
									GET_PAYMENT=cfquery(SQLString:"#payment_sql_str# AND ACCOUNTS.ACCOUNT_ACC_CODE = '#bank_account_code#'",Datasource:dsn3,is_select:1);
								else
									GET_PAYMENT=cfquery(SQLString:"#payment_sql_str# AND CPT.ACCOUNT_CODE = '#bank_account_code#'",Datasource:dsn3,is_select:1);
							}else
							{
								error_flag=1;
								writeoutput('#attributes.paper_number# Nolu Belgenin Hesap Muhasebe Kodları Eksik!<br/>');
							}
			
							if(isdefined('GET_PAYMENT') and GET_PAYMENT.RECORDCOUNT eq 1)
							{
								if(listfind('tl,TL',evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind),','))
									'paper_payment_#paper_count#_price_money_#row_ind#' = 'TL';
								cash_rate=1;
								attributes.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								form.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
		
								other_money_rate=1;
								for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
								{
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq GET_PAYMENT.ACCOUNT_CURRENCY_ID)
										cash_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind))
										other_money_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
								}
								if(not len(GET_PAYMENT.PAYMENT_RATE)) GET_PAYMENT.PAYMENT_RATE = 0;
								attributes.account_id = GET_PAYMENT.ACCOUNT_ID;
								attributes.currency_id = GET_PAYMENT.ACCOUNT_CURRENCY_ID;
								attributes.account_acc_code = GET_PAYMENT.ACCOUNT_ACC_CODE;
								attributes.payment_type_id = GET_PAYMENT.PAYMENT_TYPE_ID;
								attributes.payment_rate = GET_PAYMENT.PAYMENT_RATE;
								attributes.payment_rate_acc = GET_PAYMENT.PAYMENT_RATE_ACC;
								attributes.sales_credit_comm = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind);//komisyonsuz toplam
								attributes.sales_credit = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind)+(evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind) * (GET_PAYMENT.PAYMENT_RATE/100));//komisyonlu toplam
								attributes.system_amount = attributes.sales_credit*cash_rate;//kasanın para brimine göre bunu çarpmalıyız
								attributes.other_value_sales_credit = attributes.system_amount/other_money_rate;//altta seçiliye göre
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgenin İşlem Yapılacak Pos Hesabı Bulunamadı veya Birden Fazla Hesap ile Eşleşti!<br/>');
								error_flag=1;
							}
							row_ind=row_ind+1;
						}
						row_ind=row_ind-1;//sonda artırarak cıktığından bir azaltıroyoruz
					}
				}
				else if(payment_type eq 5)//gelen havale
				{
					if(isdefined('GET_MEMBER_ID') and GET_MEMBER_ID.RECORDCOUNT eq 1)
					{
						if(GET_MEMBER_ID.MEMBER_TYPE eq 1)
						{
							attributes.action_from_company_id=GET_MEMBER_ID.MEMBER_ID;
							action_from_company_id=GET_MEMBER_ID.MEMBER_ID;
							attributes.partner_id=GET_MEMBER_ID.PARTNER_ID;
							partner_id=GET_MEMBER_ID.PARTNER_ID;
							attributes.action_from_consumer_id='';
							action_from_consumer_id='';
						}
						else
						{
							attributes.action_from_company_id='';
							action_from_company_id='';
							attributes.action_from_consumer_id=GET_MEMBER_ID.MEMBER_ID;
							action_from_consumer_id=GET_MEMBER_ID.MEMBER_ID;
						}
					}
					else
					{
						writeoutput('#attributes.paper_number# Nolu Belgede Üye Bulunamadı veya Birden Fazla Üye ile Eşleşti!<br/>');
						error_flag=1;
					}
							
					form.bank_order_process_cat='';
					form.acc_order_code='';
					attributes.bank_order_id='';
					action_type='GELEN HAVALE';
					
					if(error_flag eq 0)
					{
						while(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#'))
						{
							if(len(evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind)))
							{
								bank_account_code=evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind);
								payment_sql_str="SELECT 
													ACCOUNTS.ACCOUNT_ID,
													ACCOUNTS.ACCOUNT_CURRENCY_ID,
													ACCOUNTS.ACCOUNT_ACC_CODE
												FROM
													BANK_BRANCH,
													ACCOUNTS
												WHERE
													ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND
													ACCOUNTS.ACCOUNT_ACC_CODE='#bank_account_code#'";
								GET_PAYMENT=cfquery(SQLString:"#payment_sql_str#",Datasource:dsn3,is_select:1);
							}
							else
							{
								error_flag=1;
								writeoutput('#attributes.paper_number# Nolu Belgenin Muhasebe Kodları Eksik!<br/>');
							}
			
							if(GET_PAYMENT.RECORDCOUNT eq 1)
							{
								if(listfind('tl,TL',evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind),','))
									'paper_payment_#paper_count#_price_money_#row_ind#' = 'TL';
								cash_rate=1;
								attributes.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								form.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								
								other_money_rate=1;
								for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
								{
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq GET_PAYMENT.ACCOUNT_CURRENCY_ID)
										cash_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind))
										other_money_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
								}
								attributes.account_id = GET_PAYMENT.ACCOUNT_ID;
								attributes.currency_id = GET_PAYMENT.ACCOUNT_CURRENCY_ID;
								attributes.account_acc_code = GET_PAYMENT.ACCOUNT_ACC_CODE;
								attributes.action_value = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind);
								attributes.system_amount = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind)*cash_rate;//kasanın para brimine göre bunu çarpmalıyız
								attributes.other_cash_act_value = attributes.system_amount/other_money_rate;//altta seçiliye göre
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgede Gelen Havale Hesabı Bulunamadı veya Birden Fazla Hesap ile Eşleşti!<br/>');
								error_flag=1;
							}
							row_ind=row_ind+1;
						}
						row_ind=row_ind-1;//sonda artırarak cıktığından bir azaltıroyoruz
					}
				}
				else if(payment_type eq 6)//giden havale
				{
					if(isdefined('GET_MEMBER_ID') and GET_MEMBER_ID.RECORDCOUNT eq 1)
					{
						if(GET_MEMBER_ID.MEMBER_TYPE eq 1)
						{
							attributes.action_to_company_id=GET_MEMBER_ID.MEMBER_ID;
							action_to_company_id=GET_MEMBER_ID.MEMBER_ID;
							form.action_to_company_id=GET_MEMBER_ID.MEMBER_ID;
							attributes.partner_id=GET_MEMBER_ID.PARTNER_ID;
							partner_id=GET_MEMBER_ID.PARTNER_ID;
							attributes.action_to_consumer_id='';
							action_to_consumer_id='';
						}
						else
						{
							attributes.action_to_company_id='';
							action_to_company_id='';
							form.action_to_company_id='';
							attributes.action_to_consumer_id=GET_MEMBER_ID.MEMBER_ID;
							action_to_consumer_id=GET_MEMBER_ID.MEMBER_ID;
							form.action_to_consumer_id=GET_MEMBER_ID.MEMBER_ID;
						}
					}
					else
					{
						writeoutput('#attributes.paper_number# Nolu Belgede Üye Bulunamadı veya Birden Fazla Üye ile Eşleşti!<br/>');
						error_flag=1;
					}
							
					form.bank_order_process_cat='';
					form.acc_order_code='';
					attributes.bank_order_id='';
					action_type='GİDEN HAVALE';
					
					attributes.expense_center='';
					attributes.expense_center_id='';
					attributes.expense_item_id='';
					attributes.expense_item_name='';
					attributes.masraf='';
					
					if(error_flag eq 0)
					{
						while(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#'))
						{
							if(len(evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind)))
							{
								bank_account_code=evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind);
								payment_sql_str="SELECT 
													ACCOUNTS.ACCOUNT_ID,
													ACCOUNTS.ACCOUNT_CURRENCY_ID,
													ACCOUNTS.ACCOUNT_ACC_CODE
												FROM
													BANK_BRANCH,
													ACCOUNTS
												WHERE
													ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND
													ACCOUNTS.ACCOUNT_ACC_CODE='#bank_account_code#'";
													
								GET_PAYMENT=cfquery(SQLString:"#payment_sql_str#",Datasource:dsn3,is_select:1);
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgenin Muhasebe Kodları Eksik!<br/>');
								error_flag=1;
							}
			
							if(GET_PAYMENT.RECORDCOUNT eq 1)
							{
								if(listfind('tl,TL',evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind),','))
									'paper_payment_#paper_count#_price_money_#row_ind#' = 'TL';
								cash_rate=1;
								attributes.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								form.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								
								other_money_rate=1;
								for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
								{
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq GET_PAYMENT.ACCOUNT_CURRENCY_ID)
										cash_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind))
										other_money_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
								}
								attributes.account_id = GET_PAYMENT.ACCOUNT_ID;
								attributes.currency_id = GET_PAYMENT.ACCOUNT_CURRENCY_ID;
								attributes.account_acc_code = GET_PAYMENT.ACCOUNT_ACC_CODE;
								attributes.action_value = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind);
								attributes.system_amount = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind)*cash_rate;//kasanın para brimine göre bunu çarpmalıyız
								attributes.other_cash_act_value = attributes.system_amount/other_money_rate;//altta seçiliye göre
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgenin Gelen Havale Hesabı Bulunamadı veya Birden Fazla Hesap ile Eşleşti!<br/>');
								error_flag=1;
							}
							row_ind=row_ind+1;
						}
						row_ind=row_ind-1;//sonda artırarak cıktığından bir azaltıyoruz
					}
				}
				else if(payment_type eq 7)//Cari Virman
				{
					if(isdefined('GET_MEMBER_ID') and GET_MEMBER_ID.RECORDCOUNT eq 1)
					{
						if(GET_MEMBER_ID.MEMBER_TYPE eq 1)
						{
							attributes.from_company_id = GET_MEMBER_ID.MEMBER_ID;
							attributes.from_company_name ='a' ;
							attributes.from_consumer_id = '';
							attributes.from_employee_id = '';
							attributes.from_member_type ='partner';
						}
						else
						{
							attributes.from_company_id = '';
							attributes.from_company_name = 'b';
							attributes.from_consumer_id = GET_MEMBER_ID.MEMBER_ID;
							attributes.from_employee_id = '';
							attributes.from_member_type ='consumer';
						}
					}
					else
					{
						//Virmanda Calisan Hesabi da Kontrol Ediliyor
						if(ListFindNoCase('TE',evaluate('paper_header_'&paper_count&'_paper_type_'&row_ind),',') and len(evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind)))
							cross_account_code = evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind);
						else
							cross_account_code = evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind);
	
						GET_MEMBER_ID_EMP=cfquery(SQLString:"SELECT EIO.EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIOP.ACCOUNT_CODE='#cross_account_code#' AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#",Datasource:dsn,is_select:1);
						if(GET_MEMBER_ID_EMP.RECORDCOUNT eq 1)
						{
							attributes.from_company_id = '';
							attributes.from_company_name = 'b';
							attributes.from_consumer_id = '';
							attributes.from_employee_id = GET_MEMBER_ID_EMP.EMPLOYEE_ID;
							attributes.from_member_type ='employee';
						}
						else
						{
							writeoutput('#attributes.paper_number# Nolu Belgede Üye Bulunamadı veya Birden Fazla Üye ile Eşleşti!<br/>');
							error_flag=1;
						}
					}
					
					attributes.action_currency_id = '0;#session.ep.money#';
					attributes.action_period = session.ep.period_id;
					attributes.due_date = '';
					attributes.project_id_2 = '';
					attributes.project_name_2 = '';
					other_account_code = '';
					
					if(error_flag eq 0)
					{
						while(isdefined('paper_payment_#paper_count#_payment_type_#row_ind#'))
						{
							if(ListFindNoCase('TE',evaluate('paper_header_'&paper_count&'_paper_type_'&row_ind),',') and len(evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind)))
								other_account_code = evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind);
							else 
								other_account_code = evaluate('paper_payment_'&paper_count&'_bank_account_code_'&row_ind);
	
							if(len(other_account_code))
							{
								//member_account_code=evaluate('paper_header_'&paper_count&'_member_account_code_'&row_ind);
								payment_sql_str="	SELECT
														1 MEMBER_TYPE,
														COMPANY.COMPANY_ID MEMBER_ID,
														ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
														COMPANY_PERIOD.ACCOUNT_CODE ACCOUNT_CODE,
														'' START_DATE
													FROM 
														COMPANY,
														COMPANY_PERIOD
													WHERE 
														COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
														COMPANY_PERIOD.PERIOD_ID = #session.ep.period_id# AND
														COMPANY_PERIOD.ACCOUNT_CODE = '#other_account_code#'
												UNION
													SELECT
														2 MEMBER_TYPE,
														CONSUMER.CONSUMER_ID MEMBER_ID,
														'' PARTNER_ID,
														CONSUMER_PERIOD.ACCOUNT_CODE ACCOUNT_CODE,
														'' START_DATE
													FROM 
														CONSUMER,
														CONSUMER_PERIOD
													WHERE 
														CONSUMER.CONSUMER_ID=CONSUMER_PERIOD.CONSUMER_ID AND
														CONSUMER_PERIOD.PERIOD_ID = #session.ep.period_id# AND
														CONSUMER_PERIOD.ACCOUNT_CODE = '#other_account_code#'
												UNION
													SELECT
														3 MEMBER_TYPE,
														EMPLOYEE_ID MEMBER_ID,
														'' PARTNER_ID,
														ACCOUNT_CODE,
														START_DATE
													FROM
														EMPLOYEES_IN_OUT
													WHERE
														ACCOUNT_CODE = '#other_account_code#'
												ORDER BY
													START_DATE DESC";
								GET_PAYMENT=cfquery(SQLString:"#payment_sql_str#",Datasource:dsn,is_select:1);
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgenin Muhasebe Kodları Eksik!<br/>');
								error_flag=1;
							}
			
							if(isdefined('GET_PAYMENT') and GET_PAYMENT.RECORDCOUNT eq 1)
							{
								attributes.to_company_id = '';
								attributes.to_consumer_id = '';
								attributes.to_employee_id = '';
								if(GET_PAYMENT.MEMBER_TYPE eq 1)
								{
									attributes.to_company_name ='a' ;
									attributes.to_company_id = GET_PAYMENT.MEMBER_ID;
									attributes.to_member_type ='partner';
								}
								else if(GET_PAYMENT.MEMBER_TYPE eq 2)
								{
									attributes.to_company_name = 'b';
									attributes.to_consumer_id = GET_PAYMENT.MEMBER_ID;
									attributes.to_member_type ='consumer';
								}
								else if(GET_PAYMENT.MEMBER_TYPE eq 3)
								{
									attributes.to_company_name = 'b';
									attributes.to_employee_id = GET_PAYMENT.EMPLOYEE_ID;
									attributes.to_member_type ='employee';
								}
								
								if(listfind('tl,TL',evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind),','))
									'paper_payment_#paper_count#_price_money_#row_ind#' = 'TL';
								cash_rate=1;
								attributes.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								form.money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								money_type=evaluate('paper_payment_#paper_count#_price_money_#row_ind#');
								
								other_money_rate=1;
								for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
								{
									
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq attributes.money_type)
										cash_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
									if(evaluate('attributes.hidden_rd_money_#stp_mny#') eq evaluate('paper_payment_'&paper_count&'_price_money_'&row_ind))
										other_money_rate=evaluate('attributes.txt_rate2_#stp_mny#')/evaluate('attributes.txt_rate1_#stp_mny#');
								}
								attributes.action_value = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind);
								attributes.system_amount = evaluate('paper_payment_'&paper_count&'_payment_price_'&row_ind)*cash_rate;//kasanın para brimine göre bunu çarpmalıyız
								attributes.other_cash_act_value = attributes.system_amount/other_money_rate;//altta seçiliye göre
							}
							else
							{
								writeoutput('#attributes.paper_number# Nolu Belgede Üye Bulunamadı veya Birden Fazla Üye ile Eşleşti!<br/>');
								error_flag=1;
							}
							row_ind=row_ind+1;
						}
						row_ind=row_ind-1;//sonda artırarak cıktığından bir azaltıyoruz
					}
				}
			}
			
			paper_count=paper_count+1;
			
			//satır yoksa ve hata oluşmadı ise hata var demektir işlem dursun
			if(error_flag eq 0 and row_ind lt 1)
			{
				writeoutput('#trim(attributes.paper_number)# Nolu Belgede Ürün Satırı Bulunamadı!<br/>');
				error_flag=1;
			}
		</cfscript>
	
		<cfcatch>
			<cfif isdefined('paper_header_#paper_count#_paper_no_1')>
				<cfoutput>#evaluate('paper_header_#paper_count#_paper_no_1')#</cfoutput> Nolu Belgede Okuma İşleminde Sorun Oluştu. Dosyayı Kontrol Ediniz!<br/><br/>
			<cfelse>
				Belge No Bilinmiyor, Okuma İşleminde Sorun Oluştu. Dosyayı Kontrol Ediniz!<br/><br/>
			</cfif>
			<cfset paper_count=paper_count+1><!--- okumada hata verdiğinden bir artırmayacak biz burda artırdık o nedenle--->
			<cfset error_flag = 1>
		</cfcatch>
	</cftry>
	<cfif error_flag eq 0>
		<cfif payment_type eq 1><!--- Kasa Tahsilat --->
			<cfset process_id=31>
		<cfelseif payment_type eq 2><!--- Kasa Odeme --->
			<cfset process_id=32>
		<cfelseif payment_type eq 3><!--- Kredi Karti Tahsilat --->
			<cfset process_id=241>
		<cfelseif payment_type eq 4><!--- Kredi Karti Tahsilat Iptal --->
			<cfset process_id=245>
		<cfelseif payment_type eq 5><!--- Gelen Havale --->
			<cfset process_id=24>
		<cfelseif payment_type eq 6><!--- Giden Havale --->
			<cfset process_id=25>
		<cfelseif payment_type eq 7><!--- Cari Virman --->
			<cfset process_id=43>
		</cfif>
		<cfquery name="get_proc" datasource="#dsn3#">
			SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = #process_id#
		</cfquery>
		<cfif get_proc.recordcount>
			<cfset form.process_cat = GET_PROC.PROCESS_CAT_ID><!--- işlem kategorisi --->
			<cfset attributes.process_cat = GET_PROC.PROCESS_CAT_ID><!--- işlem kategorisi alış sayfalarında attributes ile bakıyor--->
			<cfset 'ct_process_type_#get_proc.PROCESS_CAT_ID#' = process_id>
			<cfset 'attributes.ct_process_type_#get_proc.PROCESS_CAT_ID#' = process_id>
		<cfelse>
			<script type="text/javascript">
				alert('İşlem Kategorilerini Kontrol Ediniz!');
				window.close();
			</script>
			<cfabort>
		</cfif>
		
		<cfoutput>#attributes.paper_number#</cfoutput> Nolu Belge Kayıt İşlemi;<br/>
		<cfif ListFind('1,2,3,4,5,6,7',payment_type,',')>
			<cftry>
				<cfif payment_type eq 1><!--- Kasa Tahsilat --->
					<cfinclude template="../../cash/query/add_cash_revenue.cfm">
				<cfelseif payment_type eq 2><!--- Kasa Odeme --->
					<cfinclude template="../../cash/query/add_cash_payment.cfm">
				<cfelseif ListFind('3,4',payment_type,',')><!--- K.K. Tahsilat veya K.K. Tahsilat Iptal (Taksit Kart) --->
					<cfinclude template="../../bank/query/add_creditcard_revenue.cfm">
				<cfelseif payment_type eq 5><!--- Gelen Havale --->
					<cfinclude template="../../bank/query/add_gelenh.cfm">
				<cfelseif payment_type eq 6><!--- Giden Havale --->
					<cfinclude template="../../bank/query/add_gidenh.cfm">
				<cfelseif payment_type eq 7><!--- Cari Virman --->
					<cfinclude template="../../ch/query/add_cari_to_cari.cfm">
				</cfif>
				<cfoutput>#attributes.paper_number#</cfoutput> Nolu Belge Kaydedildi!<br/><br/>
				<cfcatch>
					 <cfoutput>#attributes.paper_number#</cfoutput> Nolu Kayıt İşleminde Hata Oluştu. Dosyayı Kontrol Ediniz!<br/><br/>
				</cfcatch>
			</cftry>
		<cfelse>
			Belge Tipi Bulunamadı!<br/><br/>
		</cfif>
	</cfif>
</cfloop>
