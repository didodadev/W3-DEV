<!---
    File: emptypopup_wodiba_process_actions.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 09.02.2019
    Controller:
    Description:
        Gateway sisteminden alınan hareketleri sisteme işlem olarak kayıt eden job action

        21	İşlem (Para Yatırma)
        22	İşlem (Para Çekme)
        23	Virman
        24	Gelen Havale
        25	Giden Havale
        120	Harcama Fişi
        121	Gelir Fişi
        243	Kredi Kartı Hesaba Geçiş
        244	Kredi Kartı Borcu Ödeme
        247	Kredi Kartı Hesaba Geçiş İptal
        248	Kredi Kartı Borcu Ödeme İptal
        291	Kredi Ödemesi
        292	Kredi Tahsilatı
        1043	Çek İşlemi Tahsil Bankaya
        1044	Çek İşlemi Ödeme Bankadan
        1051	Senet İşlemi Ödeme Bankadan
        1053	Senet İşlemi Tahsil Bankaya
        2501	Çek/Senet Banka Ödeme

        Test adresi
        http://devcatalyst.wodiba/index.cfm?fuseaction=bank.emptypopup_wodiba_process_actions&dev_bank_code=62&dev_action_type=Y700&dev_action_id=28895
        http://wodiba/index.cfm?fuseaction=bank.emptypopup_wodiba_process_actions&dev_bank_code=64&dev_action_type=EFT&dev_action_id=13

    History:
        Banka Dekont no ile sistemde eşleşen bir kayıt mevcut ise wodiba kaydına tayin edilecek şekilde düzenleme yapıldı.
--->
<cftry>
<cfscript>
    include "../cfc/Functions.cfc";
    include "../cfc/W3Actions.cfc";
    
    param name='attributes.dev_bank_code' default='';
    param name='attributes.dev_action_type' default='';
    param name='attributes.dev_action_id' default=0;
    param name='attributes.with_debug' default=0;

    wdb_hesaplar    = GetBankAccounts(dsn=dsn);

    process_action_errors   = structNew();

    if(wdb_hesaplar.RecordCount){
        for(wdb_hesap in wdb_hesaplar){
            wdb_hareketler  = GetBankActions(BankaKodu=wdb_hesap.bankaKodu, SubeKodu=wdb_hesap.subeKodu, HesapNo=wdb_hesap.hesapNo, ActionIdNull=1,DevBankCode=attributes.dev_bank_code,DevActionType=attributes.dev_action_type,DevActionId=attributes.dev_action_id);
            for(wdb_hareket in wdb_hareketler){
                period_id               = wdb_hareket.period_id;
				our_company_id          = queryExecute("SELECT OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = '#period_id#'",{},{datasource='#dsn#'}).OUR_COMPANY_ID;
				our_company_vkn         = queryExecute("SELECT TAX_NO FROM OUR_COMPANY WHERE COMP_ID = '#our_company_id#'",{},{datasource='#dsn#'}).TAX_NO;
                account_id              = wdb_hareket.account_id;
                amount                  = wdb_hareket.miktar;
                date                    = CreateDateTime(year(wdb_hareket.tarih), month(wdb_hareket.tarih), day(wdb_hareket.tarih), hour(wdb_hareket.tarih), minute(wdb_hareket.tarih), second(wdb_hareket.tarih));
                detail                  = wdb_hareket.aciklama;
                paper_no                = wdb_hareket.dekontno;
                record_emp              = GetSettings(our_company_id: our_company_id).WDB_EMP_ID;
                acc_type_id             = 0;
                is_success              = 0;
                expense_center_id       = 0;
                expense_item_id         = 0;
                project_id              = 0;
                company_id              = 0;
                consumer_id             = 0;
                employee_id             = 0;
                to_account_id           = 0;
				//şirketin kendi hesaplarından gelen-giden bir işlem ise
				is_our_company          = 0;
                payment_type_id         = 0;
                special_definition_id   = 0;
                asset_id                = 0;
                branch_id               = 0;
                branch_id_alacak        = 0;
                branch_id_borc          = 0;
                department_id           = 0;
                process_type            = '';
                process_cat_id          = '';
                bank_action             = structNew();
                dsn2                    = '#dsn#_#Year(wdb_hareket.TARIH)#_#our_company_id#';
                dsn3                    = '#dsn#_#our_company_id#';
				to_action.recordcount	= 0;
				error_str				= structNew();
                LogType                 = 'other';
				rule_set_row			= 0;
				tax						= -1;
				tax_include				= 1;

				/*
					Cari hesabı karşı IBAN ya da karşı VKN'den bulmaya çalışacağız.
					Virman öncelikli işlem olduğu için OUR_COMPANY ve ACCOUNTS sorguları üstte olmalıdır.
				*/
				vknQuery = new Query();
				ibanQuery = new Query();
				vknQuery.recordcount = 0;
				ibanQuery.recordcount = 0;

                if(Len(wdb_hareket.karsivkn) Gt 3 Or Len(Trim(wdb_hareket.karsiiban)) Gt 3){
                    if(Len(wdb_hareket.karsivkn) Gt 3){
                        vknQuery.setDatasource("#dsn#");
                        vknQuery.setSQL("
							SELECT TOP 1 0 AS COMPANY_ID, 0 AS CONSUMER_ID, 0 AS EMPLOYEE_ID, COMP_ID AS IS_OUR_COMPANY FROM OUR_COMPANY OC WHERE OC.TAX_NO = '#Right(Trim(wdb_hareket.karsivkn),10)#' AND COMP_ID = #our_company_id#
                            UNION ALL
							SELECT TOP 1 C.COMPANY_ID, 0 AS CONSUMER_ID, 0 AS EMPLOYEE_ID, 0 AS IS_OUR_COMPANY FROM COMPANY C WHERE C.TAXNO = '#Right(Trim(wdb_hareket.karsivkn),10)#' AND COMPANY_STATUS = 1 AND ISPOTANTIAL = 0
                            UNION ALL
                            SELECT TOP 1 0 AS COMPANY_ID, C.CONSUMER_ID, 0 AS EMPLOYEE_ID, 0 AS IS_OUR_COMPANY FROM CONSUMER C WHERE C.TC_IDENTY_NO = '#Right(Trim(wdb_hareket.karsivkn),11)#' AND CONSUMER_STATUS = 1 AND ISPOTANTIAL = 0");
                        vknQuery = vknQuery.execute().getResult();
                    }
                    if (Len(Trim(wdb_hareket.karsiiban)) Gt 3) {
                        ibanQuery.setDatasource("#dsn#");
                        ibanQuery.setSQL("
							SELECT TOP 1 0 AS COMPANY_ID, 0 AS CONSUMER_ID, 0 AS EMPLOYEE_ID, ACCOUNT_ID FROM #dsn3#.ACCOUNTS WHERE ACCOUNT_OWNER_CUSTOMER_NO = '#Trim(wdb_hareket.karsiiban)#'
                            UNION ALL
							SELECT TOP 1
                                CB.COMPANY_ID,
                                0 AS CONSUMER_ID,
                                0 AS EMPLOYEE_ID,
                                0 AS ACCOUNT_ID
                            FROM
                                COMPANY_BANK AS CB
                                INNER JOIN COMPANY AS C
                                ON C.COMPANY_ID = CB.COMPANY_ID
                            WHERE
                                CB.COMPANY_IBAN_CODE = '#Trim(wdb_hareket.karsiiban)#'
                                AND C.COMPANY_STATUS = 1
                                AND C.ISPOTANTIAL = 0
                            UNION ALL
                            SELECT TOP 1
                                0 AS COMPANY_ID,
                                CB.CONSUMER_ID,
                                0 AS EMPLOYEE_ID,
                                0 AS ACCOUNT_ID
                            FROM
                                CONSUMER_BANK AS CB
                                INNER JOIN CONSUMER AS C
                                ON C.CONSUMER_ID = CB.CONSUMER_ID
                            WHERE
                                CONSUMER_IBAN_CODE = '#Trim(wdb_hareket.karsiiban)#'
                                AND C.CONSUMER_STATUS = 1
                                AND C.ISPOTANTIAL = 0
                            UNION ALL
                            SELECT TOP 1
                                0 AS COMPANY_ID,
                                0 AS CONSUMER_ID,
                                EBA.EMPLOYEE_ID,
                                0 AS ACCOUNT_ID
                            FROM
                                EMPLOYEES_BANK_ACCOUNTS AS EBA
                                INNER JOIN EMPLOYEES AS E
                                ON E.EMPLOYEE_ID = EBA.EMPLOYEE_ID
                            WHERE
                                EBA.IBAN_NO = '#Trim(wdb_hareket.karsiiban)#'
                                AND E.EMPLOYEE_STATUS = 1");
                        ibanQuery = ibanQuery.execute().getResult();
                    }

					/* 
						Birden fazla kayıt gelmesi ihtimaline karşın döngü halinde işlem yapılır.
						Virman önceliklidir, virman işlemli kayıt geldiğinde döngüden çıkılır.
					*/
                    if(vknQuery.recordcount){
                        for(i=1; i lte vknQuery.recordcount; i++){
							if (vknQuery.IS_OUR_COMPANY Gt 0) {
								is_our_company = vknQuery.IS_OUR_COMPANY;
								break;
							}
                            company_id  = vknQuery.COMPANY_ID;
                            consumer_id = vknQuery.CONSUMER_ID;
                            employee_id = vknQuery.EMPLOYEE_ID;
                        }
                    }
                    if(vknQuery.recordcount Eq 0 And ibanQuery.recordcount){
                        for(i=1; i lte ibanQuery.recordcount; i++){
							if (ibanQuery.ACCOUNT_ID Gt 0) {
								to_account_id = ibanQuery.ACCOUNT_ID;
								break;
							}
                            company_id  = ibanQuery.COMPANY_ID;
                            consumer_id = ibanQuery.CONSUMER_ID;
                            employee_id = ibanQuery.EMPLOYEE_ID;
                        }
                    }
                }
				vknQuery.clear();
				ibanQuery.clear();

                account_info    = GetAccountInfo(AccountId=account_id);

                if(account_info.RecordCount){//Hesap aktif olmayabilir
                    periodQuery = new Query();
                    periodQuery.setDatasource("#dsn#");
                    periodQuery.setSQL("SELECT STANDART_PROCESS_MONEY, OTHER_MONEY FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
                    periodResult = periodQuery.execute();
                    periodResult = periodResult.getResult();

                    moneyQuery = new Query();
                    moneyQuery.setDatasource("#dsn2#");
                    moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
                    moneyResult = moneyQuery.execute();
                    moneyResult = moneyResult.getResult();

                    amounts         = structNew();
                    action_rate     = 1;
                    action_rate_2   = 1;
					amounts.tax 	= 0;
					amounts.tax_value = 0;
					amounts.other_money_tax_value = 0;

                    for(mon=1; mon Lte moneyResult.recordcount; mon++){
                        if(moneyResult.MONEY[mon] eq account_info.ACCOUNT_CURRENCY_ID){
                            action_rate     = moneyResult.RATE2[mon];
                        }
                        if(moneyResult.MONEY[mon] eq periodResult.OTHER_MONEY){
                            action_rate_2   = moneyResult.RATE2[mon];
                        }
                    }

                    amounts.action_value            = replace(amount, '-', '');//işlem para birimi tutar
                    amounts.action_value_tax_free   = amounts.action_value;
                    amounts.action_currency_id      = account_info.ACCOUNT_CURRENCY_ID;//işlem para birimi
                    amounts.system_action_value     = amounts.action_value * action_rate;//sistem para birimi tutar
                    amounts.system_action_value_tax_free = amounts.system_action_value;
                    amounts.system_currency_id      = periodResult.STANDART_PROCESS_MONEY;//sistem para birimi
                    amounts.system_action_value_2   = amounts.action_value * action_rate / action_rate_2;//sistem 2. para birimi tutar
                    amounts.system_currency_id_2    = periodResult.OTHER_MONEY;//sistem 2. para birimi
                    amounts.action_rate             = action_rate;//kur bilgisi
                    amounts.action_rate_2           = action_rate_2;//kur bilgisi

                    if(amount > 0){
                        target = 'IN';
                    }
                    else{
                        target = 'OUT';
                    }

					//Karşı VKN ya da IBAN sistem şirketine ait olduğu durumlarda ve kural seti tanımlı olduğu durumda is_our_company değerini engellemek için eklendi.
					temp_rule_set = GetRuleSetRow(AccountId=account_id, TransactionCode=wdb_hareket.ISLEMKODU, Target=target, WithDescription=1, ProcessDate=wdb_hareket.TARIH);
					if (temp_rule_set.recordcount) {
						to_account_id	= 0;
						is_our_company	= 0;
					}

					//karşı IBAN mevcut banka hesaplarından birine ait ise veya karşı VKN şirketin kendisine ait ise process_type 23 Virman olarak set ediyoruz
                    if (to_account_id Gt 0 Or is_our_company Gt 0) {
						process_type    = 23;
						process_cat_id  = GetRuleSet(CompanyId=our_company_id, ProcessType=process_type, ProcessDate=wdb_hareket.TARIH).PROCESS_CAT_ID;
					}
                    else {
                        //Kural setleri
						rule_set_row = 0;
						//IBAN ile kural seti
						if(Len(wdb_hareket.KARSIIBAN) Gt 3){
							rule_set = GetRuleSetRow(AccountId=account_id, TransactionCode=wdb_hareket.ISLEMKODU, Target=target, IBAN=wdb_hareket.KARSIIBAN, ProcessDate=wdb_hareket.TARIH);
							if(rule_set.RecordCount){
								rule_set_row = 1;
							}
						}
						//VKN ile kural seti
						if (rule_set_row is 0 And Len(wdb_hareket.KARSIVKN) Gt 3){
							rule_set = GetRuleSetRow(AccountId=account_id, TransactionCode=wdb_hareket.ISLEMKODU, Target=target, VKN=wdb_hareket.KARSIVKN, ProcessDate=wdb_hareket.TARIH);
							if(rule_set.RecordCount){
								rule_set_row = 1;
							}
						}
						//Açıklama ile kural seti
						if (rule_set_row is 0 And Len(wdb_hareket.ACIKLAMA)) {
							rule_set = GetRuleSetRow(AccountId=account_id, TransactionCode=wdb_hareket.ISLEMKODU, Target=target, WithDescription=1, ProcessDate=wdb_hareket.TARIH);
							if(rule_set.RecordCount){
								/*
									Kural setinde tanımlı açıklama alanına göre bankadan gelen işlemi koşula dahil ediyoruz
									açıklama alanı virgül ile ayrılmış çoklu değer içerdiği durumda döngü halinde tüm değerleri sorguluyoruz
									account_id - işlem kodu - yön aynı olan birden fazla kural tanımlı olma ihtimaline karşı kural setleri için de döngüye giriyoruz
									örnek bir şubeye bağlı birden fazla taşıtın hgs ödemelerinin tek bir kural seti ile aynı masraf merkezi ve gider kalemine tayin edilmesi gibi.
									Mahmut-Fatih 03.04.2021
								*/
								for (rs in rule_set) {
									if(Len(rs.DESCRIPTION)){
										rule_set_row = 0;//açıklama alanı dolu olan bir kural geldiğinde sıfırlamak gerekiyor. KRİTİK
										for (i=1; i<=ListLen(rs.DESCRIPTION,';'); i++) {
											index_value = listGetAt(rs.DESCRIPTION,i,';');
											if (findNoCase(index_value,wdb_hareket.ACIKLAMA)) {
												rule_set_row = 1;
												rule_set = rs;
												break;
											}
										}
										if (rule_set_row) {
											break;
										}
									}
								}
							}
						}
						//Açıklama olmadan kural seti
                        //Devre dışı bırakıldı, kural setlerinin çalışabilmesi için IBAN, VKN ya da açıklama filtresinin mutlak girilmesi gerekir
						/* if (rule_set_row is 0) {
							rule_set = GetRuleSetRow(AccountId=account_id, TransactionCode=wdb_hareket.ISLEMKODU, Target=target, ProcessDate=wdb_hareket.TARIH);
							if(rule_set.RecordCount){
								rule_set_row = 1;
							}
						} */

						if(rule_set_row){
							// Düzenli ifade tanımlı ise
							if (Len(rule_set.REG_EX) And Len(rule_set.REG_EX_INPUT) And Len(rule_set.REG_EX_OUTPUT)) {
								regex_query = REFind(rule_set.REG_EX, wdb_hareket.ACIKLAMA,1,true,"all");
								if (isArray(regex_query) And arrayLen(regex_query[1].match) Gt 1) {
									regex_value = regex_query[1].match[2];
									switch (rule_set.REG_EX_INPUT) {
										case 'ASSETP':
											get_asset = queryExecute("SELECT ASSETP_ID FROM ASSET_P WHERE ASSETP = '#regex_value#'",{},{datasource='#dsn#'});
											if (get_asset.recordCount) {
												rule_set.ASSET_ID = get_asset.ASSETP_ID;
											}
										break;
										default:
									}
								}
							}
						}

						//Koşullar
						//Satış bölgesine göre kontrol aktif ise ve company_id dolu ise
						if(rule_set_row And rule_set.COND_IS_SALES_ZONE Eq 1 And Len(rule_set.COND_SALES_ZONE)) {
							company_sales_zone = queryExecute("SELECT SALES_COUNTY FROM COMPANY WHERE COMPANY_ID = #company_id#",{},{datasource='#dsn#'}).SALES_COUNTY;
							//Kurumsal üyenin satış bölgesi kural setindeki satış bölgelerinde tanımlı ise
							if(Len(company_sales_zone) And listFind(rule_set.COND_SALES_ZONE,company_sales_zone)) {
								rule_set_row = 1;
								//kural setinde Şube Tanımı Satış Bölgesinden Gelsin seçili ise
								if (rule_set.COND_IS_BRANCH_FROM_SALES_ZONE) {
									sales_zone_branch_id = queryExecute("SELECT RESPONSIBLE_BRANCH_ID FROM SALES_ZONES WHERE SZ_ID = #company_sales_zone#",{},{datasource='#dsn#'}).RESPONSIBLE_BRANCH_ID;
									if (Len(sales_zone_branch_id)) {
										rule_set.BRANCH_ID = sales_zone_branch_id;
									}
								}
							}
							else {
								rule_set_row = 0;
							}
						}

						if(rule_set_row){
							process_type    = rule_set.PROCESS_TYPE;
							process_cat_id  = rule_set.PROCESS_CAT_ID;
							if(Len(rule_set.EXPENSE_CENTER_ID) And rule_set.EXPENSE_CENTER_ID Neq 0){
								expense_center_id   = rule_set.EXPENSE_CENTER_ID;
							}
							if(Len(rule_set.EXPENSE_ITEM_ID) And rule_set.EXPENSE_ITEM_ID Neq 0){
								expense_item_id     = rule_set.EXPENSE_ITEM_ID;
							}
							if(Len(rule_set.PROJECT_ID) And rule_set.PROJECT_ID Neq 0){
								project_id          = rule_set.PROJECT_ID;
							}
							if(Len(rule_set.COMPANY_ID) And rule_set.COMPANY_ID Neq 0){
								company_id          = rule_set.COMPANY_ID;
							}
							if(Len(rule_set.CONSUMER_ID) And rule_set.CONSUMER_ID Neq 0){
								consumer_id         = rule_set.CONSUMER_ID;
							}
							if(Len(rule_set.EMPLOYEE_ID) And rule_set.EMPLOYEE_ID Neq 0){
								employee_id         = rule_set.EMPLOYEE_ID;
							}
							if(Len(rule_set.PAYMENT_TYPE_ID) And rule_set.PAYMENT_TYPE_ID Neq 0){
								payment_type_id     = rule_set.PAYMENT_TYPE_ID;
							}
							if(Len(rule_set.SPECIAL_DEFINITION_ID) And rule_set.SPECIAL_DEFINITION_ID Neq 0){
								special_definition_id   = rule_set.SPECIAL_DEFINITION_ID;
							}
							if(Len(rule_set.ASSET_ID) And rule_set.ASSET_ID Neq 0){
								asset_id            = rule_set.ASSET_ID;
							}
							if(Len(rule_set.BRANCH_ID) And rule_set.BRANCH_ID Neq 0){
								branch_id           = rule_set.BRANCH_ID;
							}
							if(Len(rule_set.DEPARTMENT_ID) And rule_set.DEPARTMENT_ID Neq 0){
								department_id       = rule_set.DEPARTMENT_ID;
							}
							if(Len(rule_set.TAX) And rule_set.DEPARTMENT_ID Neq -1){
								tax       			= rule_set.TAX;
							}
							if(Len(rule_set.TAX_INCLUDE)){
								tax_include			= rule_set.TAX_INCLUDE;
							}
                            //KDV
							if (tax Gt 0) {
								amounts.tax					    = tax;
								amounts.action_value_tax_free   = amounts.action_value / (1+(tax/100));
                                amounts.other_money_tax_value   = amounts.action_value - amounts.action_value_tax_free;
								amounts.tax_value			    = amounts.other_money_tax_value * action_rate;
                                amounts.system_action_value_tax_free = amounts.system_action_value - amounts.tax_value;
							}
						}
						else{
							process_type = GetTransactionType(BankCode=account_info.BANK_CODE, TransactionCode=wdb_hareket.ISLEMKODU, Target=target);

							if (Not Len(process_type)) {
								process_action_errors.message   = getLang(dictionary_id=62664) & getLang(dictionary_id=59006) & ' : ' & '#wdb_hareket.BANKAKODU#' & getLang(dictionary_id=48886) & ' : ' & '#wdb_hareket.ISLEMKODU#';
								process_action_errors.extraInfo = getLang(dictionary_id=59006) & '<br />' & getLang(dictionary_id=62592) ' : ' & '#wdb_hareket.DEKONTNO#' & '<br />' & getLang(dictionary_id=32509) & ' ID: ' & '#wdb_hareket.WDB_ACTION_ID#' & '<br />' & getLang(dictionary_id=41318) & ' ID: ' & '#our_company_id#' & '<br />' & getLang(dictionary_id=59006) & ' : ' & '#wdb_hareket.BANKAKODU#' '<br />' & getLang(dictionary_id=48886) & ' : ' & '#wdb_hareket.ISLEMKODU#' & '<br />' & getLang(dictionary_id=62593) & ' : ' & '#target#';
							}
							else {
								get_rule_set  = GetRuleSet(CompanyId=our_company_id, ProcessType=process_type, ProcessDate=wdb_hareket.TARIH);
								process_cat_id=get_rule_set.PROCESS_CAT_ID;
								if (Not Len(process_cat_id)) {
									process_action_errors.message   = getLang(dictionary_id=62666) & getLang(dictionary_id=59006) & ' : ' & '#wdb_hareket.BANKAKODU#' & getLang(dictionary_id=48886) & ' : ' & '#wdb_hareket.ISLEMKODU#';
									process_action_errors.extraInfo = getLang(dictionary_id=59006) & ' : ' & '<br />' & getLang(dictionary_id=62592) & ' : ' & '#wdb_hareket.DEKONTNO#' & '<br />' & getLang(dictionary_id=32509) & ' ID: ' & '#wdb_hareket.WDB_ACTION_ID#' & '<br />' & getLang(dictionary_id=41318) & ' ID: '& '#our_company_id#' & '<br />' & getLang(dictionary_id=59006) & ' : ' & '#wdb_hareket.BANKAKODU#' & '<br />' & getLang(dictionary_id=48886) & ' : ' & '#wdb_hareket.ISLEMKODU#' & '<br />' & getLang(dictionary_id=62593) & ' : ' & '#target#';
								}
							}
						}
                    }

                    // Açıklamadaki fatura numarasına göre cari eşleme
                    if (
                        isDefined('get_rule_set.MATCH_COMPANY_BY_INVOICE_NUMBER') And
                        get_rule_set.MATCH_COMPANY_BY_INVOICE_NUMBER Eq 1 And
                        company_id Eq 0 And
                        consumer_id Eq 0 And
                        employee_id Eq 0 And
                        Len(wdb_hareket.ACIKLAMA)) {
                        regExInvoiceNumber='';
                        regexQueryInvoiceNumber = REFind("(([a-zA-Z0-9]{3,3})-#Year(wdb_hareket.TARIH)#([\d\.]{5,9})+)", wdb_hareket.ACIKLAMA,1,true,"all");

                        if (isArray(regexQueryInvoiceNumber) And arrayLen(regexQueryInvoiceNumber[1].match) Gt 1){
                            regExInvoiceNumber = regexQueryInvoiceNumber[1].match[2];
                        }
                        else{
                            regexQueryInvoiceNumber = REFind("(([a-zA-Z0-9]{3,3})#Year(wdb_hareket.TARIH)#([\d\.]{5,9})+)", wdb_hareket.ACIKLAMA,1,true,"all");
                            if (isArray(regexQueryInvoiceNumber) And arrayLen(regexQueryInvoiceNumber[1].match) Gt 1){
                                regExInvoiceNumber = regexQueryInvoiceNumber[1].match[2];
                            }
                        }
                        if (Len(regExInvoiceNumber) Gt 0) {
                            purchase_sales=0;
                            expense_cost_type=0;

                            if(process_type Eq 24){
                                purchase_sales=1;
                                expense_cost_type=121;
                            }
                            else if(process_type Eq 25) {
                                purchase_sales=0;
                                expense_cost_type=120;
                            }

                            get_company = GetInvoice(dsn2=dsn2, invoiceNumber=regExInvoiceNumber, companyId=company_id, consumerId=consumer_id, purchaseSales=purchase_sales, expenseCostType=expense_cost_type);

                            if (get_company.recordcount And Len(get_company.COMPANY_ID)) {
                                company_id = get_company.COMPANY_ID;
                            }
                        }
                    }

					//employee_id dolu ise cari hesap tipini değiştiriyoruz.
                    if (employee_id gt 0) {
                        acc_type_id = (isDefined('rule_set.ACC_TYPE_ID') And Len(rule_set.ACC_TYPE_ID) ? rule_set.ACC_TYPE_ID : -1);
                    }

					//Debug
					if (attributes.with_debug Or Len(attributes.dev_action_type)) {
                        flush interval=100;
						writeOutput(
							"wdb_action_id: "& wdb_hareket.WDB_ACTION_ID
                            & "--- our_company: " & wdb_hesap.OUR_COMPANY_ID
							& "--- rule_set_row_id: " & (isDefined('rule_set.recordcount') ? rule_set.RULE_SET_ROW_ID : 0)
							& "--- account_id: " & account_id
							& "--- bank_code: " & account_info.BANK_CODE
							& "--- process_type: " & process_type
							& "--- process_cat_id: " & process_cat_id
							& "--- islemkodu: " & wdb_hareket.ISLEMKODU
							& "--- islem_yonu: " & target
							& "--- company_id: " & company_id
							& "--- consumer_id: " & consumer_id
							& "--- employee_id: " & employee_id
							& "--- acc_type_id: " & acc_type_id
							& "--- is_our_company: " & is_our_company
							& "--- to_account_id: " & to_account_id
							& "--- amount: " & amount
							& "<br />");
					}

                    if(structIsEmpty(process_action_errors)){
                        switch(process_type){
                            case '21'://Para yatırma işlemi
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addInvestMoney();
								}
                            break;

                            case '22'://Para çekme işlemi
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addGetMoney();
								}
                            break;

							case '23'://Döviz Alış Satış Virman İşlemi
                                //To Do: Virman için kayıtlı belge ilişkilendirme yapılmayacak, çift belge olduğu için farklı bir çözüm gerekiyor.
								if (process_cat_id Gt 0) {
									if(wdb_hareket.MIKTAR Lt 0){//Öncelikli olarak çıkış işlemi ile başlanır ve değişkenleri set edilir.
										arguments_str                   = StructNew();
										arguments_str.process_cat       = process_cat_id;
										arguments_str.period_id         = period_id;
										arguments_str.date              = date;
										arguments_str.from_action_id    = wdb_hareket.WDB_ACTION_ID;
										arguments_str.from_amount       = amounts;
										arguments_str.from_account_id   = account_id;
										arguments_str.from_detail       = wdb_hareket.ACIKLAMA;
										arguments_str.from_paper_no     = wdb_hareket.DEKONTNO;
										arguments_str.from_date         = wdb_hareket.TARIH;
										arguments_str.record_emp        = record_emp;
										arguments_str.expense_center_id = expense_center_id;
										arguments_str.expense_item_id   = expense_item_id;
										arguments_str.project_id        = project_id;
										arguments_str.special_definition_id = special_definition_id;
										arguments_str.branch_id         = branch_id;
										arguments_str.branch_id_alacak  = 0;
										arguments_str.branch_id_borc    = 0;
										arguments_str.department_id     = department_id;

										difference_branch_process_cat = queryExecute("SELECT DIFF_BRANCH_PROCESS_CAT_ID,PROCESS_DATE_RANGE FROM WODIBA_RULE_SETS WHERE PROCESS_TYPE = 23 AND COMPANY_ID = '#our_company_id#'",{},{datasource='#dsn#'}); 
										to_action   = GetTransferAction(
														ActionId: arguments_str.from_action_id,
														BankaKodu: wdb_hareket.BANKAKODU,
														AccountId: arguments_str.from_account_id,
														Tarih: arguments_str.from_date,
														IslemKodu: wdb_hareket.ISLEMKODU,
														PeriodId: period_id,
														Miktar: amounts.action_value,
                                                        DovizTuru: wdb_hareket.DovizTuru,
														KarsiVKN: our_company_vkn,
														Dsn3: dsn3,
														daterange: (Len(difference_branch_process_cat.PROCESS_DATE_RANGE) ? difference_branch_process_cat.PROCESS_DATE_RANGE : 0));

										if (to_action.RecordCount) {
                                            if (to_action.TYPE Eq 5 And isDefined('get_rule_set.RULE_ID')) {//Vadeli mevduat işlemi
                                                block_account = queryExecute("SELECT POS_ACCOUNT_ID FROM WODIBA_RULE_SET_DEFINITIONS WHERE RULE_SET_ID = #get_rule_set.RULE_ID# AND MAIN_ACCOUNT_ID = #arguments_str.from_account_id# AND MONEY_TYPE = '#account_info.ACCOUNT_CURRENCY_ID#'",{},{datasource='#dsn#'});
                                                if (block_account.recordCount) {
                                                    to_account_info     = GetAccountInfo(AccountId=block_account.POS_ACCOUNT_ID);
                                                    to_action.ACCOUNT_ID = block_account.POS_ACCOUNT_ID;
                                                }
                                                else {
													to_action					= structNew();
                                                    to_action.recordcount       = 0;
                                                    to_account_info.recordcount = 0;
                                                }
                                            }
                                            else if (listFind('1,2,3,4',to_action.TYPE)) {
                                                to_account_info     = GetAccountInfo(AccountId=to_action.ACCOUNT_ID);
                                            }
											else {
												to_action					= structNew();
												to_action.recordcount       = 0;
                                                to_account_info.recordcount = 0;
											}

											to_amounts          = structNew();
											to_action_rate      = 1;
											to_action_rate_2    = 1;

											if(to_action.recordcount And to_account_info.RecordCount){
												wdb_hareket_branch_id = GetBranchInfo(AccountId=arguments_str.from_account_id);
												wdb_opposite_hareket_branch_id = GetBranchInfo(AccountId=to_action.ACCOUNT_ID);
											}

											if (to_account_info.RecordCount And wdb_opposite_hareket_branch_id.RecordCount and wdb_hareket_branch_id.RecordCount and len(difference_branch_process_cat.DIFF_BRANCH_PROCESS_CAT_ID)) {
												branch_exist = 0;
												for (row_1 in wdb_opposite_hareket_branch_id) {
													for(row_2 in wdb_hareket_branch_id){
														if (row_1.BRANCH_ID eq row_2.BRANCH_ID) {
															branch_exist = 1 ;
															arguments_str.branch_id_alacak   = row_2.BRANCH_ID;
															arguments_str.branch_id_borc     = row_1.BRANCH_ID;
															break;
														}
													}
													if (branch_exist eq 1) {
														break;
													}
													else {
														arguments_str.process_cat = difference_branch_process_cat.DIFF_BRANCH_PROCESS_CAT_ID;
														arguments_str.branch_id_alacak   = wdb_hareket_branch_id.BRANCH_ID[1];
														arguments_str.branch_id_borc     = wdb_opposite_hareket_branch_id.BRANCH_ID[1];
													}
												}
											}

                                            if (to_action.recordcount And to_account_info.recordcount) {
                                                for(mon=1; mon Lte moneyResult.recordcount; mon++){
                                                    if(moneyResult.MONEY[mon] eq to_account_info.ACCOUNT_CURRENCY_ID And to_account_info.ACCOUNT_CURRENCY_ID Neq periodResult.standart_process_money){
                                                        to_action_rate     = to_action.MIKTAR / amounts.action_value;
                                                    }
                                                    if(moneyResult.MONEY[mon] eq periodResult.OTHER_MONEY){
                                                        to_action_rate_2   = to_action.MIKTAR / amounts.action_value;
                                                    }
                                                }
    
                                                to_amounts.action_value            = replace(to_action.MIKTAR, '-', '');
                                                to_amounts.action_currency_id      = to_account_info.ACCOUNT_CURRENCY_ID;
                                                to_amounts.system_action_value     = to_amounts.action_value * to_action_rate;
                                                to_amounts.system_currency_id      = periodResult.STANDART_PROCESS_MONEY;
                                                to_amounts.system_action_value_2   = to_amounts.action_value * to_action_rate / to_action_rate_2;
                                                to_amounts.system_currency_id_2    = periodResult.OTHER_MONEY;
                                                to_amounts.action_rate             = to_action_rate;
                                                to_amounts.action_rate_2           = to_action_rate_2;
    
                                                arguments_str.to_action_id      = to_action.WDB_ACTION_ID;
                                                arguments_str.to_amount         = to_amounts;
                                                arguments_str.to_account_id     = to_action.ACCOUNT_ID;
                                                arguments_str.to_detail         = to_action.ACIKLAMA;
                                                arguments_str.to_paper_no       = to_action.DEKONTNO;
    
                                                bank_action = addEFT(arguments_str=arguments_str);

												if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
													is_success = 1;

													if (to_action.TYPE Eq 5 And block_account.recordCount) {//Vadeli mevduat işlemi için 2. banka kaydını atıyoruz
														other_arguments_str					= arguments_str;
														other_arguments_str.from_account_id = block_account.POS_ACCOUNT_ID;
														other_arguments_str.to_account_id	= account_id;
														other_arguments_str.date			= CreateDateTime(year(to_action.TARIH), month(to_action.TARIH), day(to_action.TARIH), hour(to_action.TARIH), minute(to_action.TARIH), second(to_action.TARIH));
														other_arguments_str.from_paper_no	= to_action.DEKONTNO;
														other_arguments_str.to_paper_no		= wdb_hareket.DEKONTNO;
														other_arguments_str.from_detail		= to_action.ACIKLAMA;
														other_arguments_str.to_detail		= wdb_hareket.ACIKLAMA;
														other_bank_action 					= addEFT(arguments_str=other_arguments_str);
														UpdateBankAction(ActionId=to_action.WDB_ACTION_ID, BankActionId=other_bank_action.bank_action_id, DocumentId=other_bank_action.document_id);
													}
													else {
														UpdateBankAction(ActionId=arguments_str.to_action_id, BankActionId=bank_action.bank_action_id, DocumentId=bank_action.document_id);
													}
												}
												else {
													error_str = bank_action;
												}
                                            }
										}
										structClear(arguments_str);
									}
								}
                            break;

                            case '24':// Gelen havale
                                //Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success      = 1;
                                }
                                else if(company_id Neq 0 Or consumer_id Neq 0 Or employee_id Neq 0 And (is_our_company is 0 Or to_account_id is 0)){
                                    bank_action = addIncomingTransfer(
                                        process_cat : process_cat_id,
                                        period_id : period_id,
                                        acc_type_id : acc_type_id,
                                        account_id : account_id,
                                        amount : amounts,
                                        date : date,
                                        detail : detail,
                                        paper_no : paper_no,
                                        record_emp : record_emp,
                                        expense_center_id: expense_center_id,
                                        expense_item_id: expense_item_id,
                                        project_id : project_id,
                                        company_id : company_id,
                                        consumer_id : consumer_id,
                                        employee_id : employee_id,
                                        payment_type_id: payment_type_id,
                                        special_definition_id: special_definition_id,
                                        asset_id : asset_id,
                                        branch_id: branch_id,
                                        department_id: department_id
                                    );
                                    if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
                                        is_success = 1;
                                    }
                                    else {
                                        error_str = bank_action;
                                    }
                                }
                            break;

                            case '25':// Giden havale
                                //Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success                  = 1;
                                }
                                else if(company_id Neq 0 Or consumer_id Neq 0 Or employee_id Neq 0 And (is_our_company is 0 Or to_account_id is 0)){
                                    bank_action = addOutgoingTransfer(
                                        process_cat : process_cat_id,
                                        period_id : period_id,
                                        acc_type_id : acc_type_id,
                                        account_id : account_id,
                                        amount : amounts,
                                        date : date,
                                        detail : detail,
                                        paper_no : paper_no,
                                        record_emp : record_emp,
                                        expense_center_id: expense_center_id,
                                        expense_item_id: expense_item_id,
                                        project_id : project_id,
                                        company_id : company_id,
                                        consumer_id : consumer_id,
                                        employee_id : employee_id,
                                        payment_type_id: payment_type_id,
                                        special_definition_id: special_definition_id,
                                        asset_id : asset_id,
                                        branch_id: branch_id,
                                        department_id: department_id
                                    );
									if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
                                        is_success = 1;
                                    }
                                    else {
                                        error_str = bank_action;
                                    }
                                }
                            break;

                            case '120':// Masraf fişi
                                //Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.EXPENSE_ID;
                                    is_success                  = 1;
                                }
                                else if (expense_center_id Neq 0 And expense_item_id Neq 0){
                                    get_other_expense = GetRuleSetRowParam(rule_set.RULE_SET_ROW_ID,'other_expense_item_id');
								    get_other_expense_rate = GetRuleSetRowParam(rule_set.RULE_SET_ROW_ID,'other_expense_item_rate');

                                    bank_action = addCollactedExpenseCost(
                                        period_id : period_id,
                                        process_cat : process_cat_id,
                                        acc_type_id : acc_type_id,
                                        account_id : account_id,
                                        amount : amounts,
                                        date : date,
                                        detail : detail,
                                        paper_no : paper_no,
                                        record_emp : record_emp,
                                        expense_center_id: expense_center_id,
                                        expense_item_id: expense_item_id,
                                        other_expense_item_id: (Len(get_other_expense.param_value) ? get_other_expense.param_value: 0),
                                        other_expense_rate: (Len(get_other_expense_rate.param_value) ? get_other_expense_rate.param_value : 0),
                                        project_id : project_id,
                                        company_id : company_id,
                                        consumer_id : consumer_id,
                                        employee_id : employee_id,
                                        payment_type_id: payment_type_id,
                                        special_definition_id: special_definition_id,
                                        asset_id : asset_id,
                                        branch_id: branch_id,
                                        department_id: department_id
                                    );
                                    if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
                                        is_success = 1;
                                    }
                                    else {
                                        error_str = bank_action;
                                    }
                                }
                                else {
                                   }
                            break;

                            case '121'://Gelir fişi
                                //Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.EXPENSE_ID;
                                    is_success                  = 1;
                                }
                                else if (expense_center_id Neq 0 And expense_item_id Neq 0){
                                    get_other_expense = GetRuleSetRowParam(rule_set.RULE_SET_ROW_ID,'other_expense_item_id');
								    get_other_expense_rate = GetRuleSetRowParam(rule_set.RULE_SET_ROW_ID,'other_expense_item_rate');

                                    bank_action = addIncomingExpenseCost(
                                        period_id : period_id,
                                        process_cat : process_cat_id,
                                        acc_type_id : acc_type_id,
                                        account_id : account_id,
                                        amount : amounts,
                                        date : date,
                                        detail : detail,
                                        paper_no : paper_no,
                                        record_emp : record_emp,
                                        expense_center_id: expense_center_id,
                                        expense_item_id: expense_item_id,
                                        other_expense_item_id: (Len(get_other_expense.param_value) ? get_other_expense.param_value: 0),
                                        other_expense_rate: (Len(get_other_expense_rate.param_value) ? get_other_expense_rate.param_value : 0),
                                        project_id : project_id,
                                        company_id : company_id,
                                        consumer_id : consumer_id,
                                        employee_id : employee_id,
                                        payment_type_id: payment_type_id,
                                        special_definition_id: special_definition_id,
                                        asset_id : asset_id,
                                        branch_id: branch_id,
                                        department_id: department_id
                                    );
                                    if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
                                        is_success = 1;
                                    }
                                    else {
                                        error_str = bank_action;
                                    }
                                }
                                else {
                                   }
                            break;

                            case '243'://Kredi Kartı Hesaba Geçiş
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addPaymentCreditCard();
								}
                            break;

                            case '244'://Kredi Kartı Borcu Ödeme
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									if (Len(wdb_hareket.ACIKLAMA)) {
										regExCCNumber = '';

                                        if (wdb_hareket.bankaKodu Eq 64) {//İş Bankası CC no arama
											regexQueryCCNumber = REFind("[0-9]{4}\*\*\*\*[0-9]{4}", wdb_hareket.ACIKLAMA,1,true,"all");

											if (isArray(regexQueryCCNumber) And arrayLen(regexQueryCCNumber[1].match) Eq 1 And Len(regexQueryCCNumber[1].match[1])){
												regExCCNumber = regexQueryCCNumber[1].match[1];
											}
                                            else {
                                                regexQueryCCNumber = REFind("[0-9]{4}\*\*\*\*\*\*\*\*[0-9]{4}", wdb_hareket.ACIKLAMA,1,true,"all");

                                                if (isArray(regexQueryCCNumber) And arrayLen(regexQueryCCNumber[1].match) Eq 1 And Len(regexQueryCCNumber[1].match[1])){
                                                    regExCCNumber = regexQueryCCNumber[1].match[1];
                                                }
                                            }
										}
                                        else if (wdb_hareket.bankaKodu Eq 205) {//Kuveyttürk CC no arama
											regexQueryCCNumber = REFind("[0-9]{4}\*\*\*\*\*\*\*\*[0-9]{4}", wdb_hareket.ACIKLAMA,1,true,"all");

											if (isArray(regexQueryCCNumber) And arrayLen(regexQueryCCNumber[1].match) Eq 1 And Len(regexQueryCCNumber[1].match[1])){
												regExCCNumber = regexQueryCCNumber[1].match[1];
											}
										}

										if (Len(regExCCNumber)) {
											get_creditcards = queryExecute("SELECT CREDITCARD_ID, CREDITCARD_NUMBER FROM CREDIT_CARD WHERE ACCOUNT_ID = #account_id#",{},{datasource='#dsn3#'}); 

											if (get_creditcards.recordCount) {
												getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
												getCCNOKey.dsn = dsn;
												getCCNOKey1 = getCCNOKey.getCCNOKey1();
												getCCNOKey2 = getCCNOKey.getCCNOKey2();
												cc_number	= '';
												cc_id		= '';

												for (i=1; i<=get_creditcards.recordCount; i++) {
													if (getCCNOKey1.recordcount and getCCNOKey2.recordcount) {
														ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey);
														ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey);
														cc_number = contentEncryptingandDecodingAES(isEncode:0,content:get_creditcards.CREDITCARD_NUMBER[i],accountKey:our_company_id,key1:ccno_key1,key2:ccno_key2);
														cc_number = '#mid(cc_number,1,4)#********#mid(cc_number,Len(cc_number) - 3, Len(cc_number))#';
													}
													else {
														cc_number = '#mid(Decrypt(get_creditcards.CREDITCARD_NUMBER[i],our_company_id,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_creditcards.CREDITCARD_NUMBER[i],our_company_id,"CFMX_COMPAT","Hex"),Len(Decrypt(get_creditcards.CREDITCARD_NUMBER[i],our_company_id,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_creditcards.CREDITCARD_NUMBER[i],our_company_id,"CFMX_COMPAT","Hex")))#';
													}
													if (left(cc_number,4) Eq left(regExCCNumber,4) And right(cc_number,4) Eq right(regExCCNumber,4)) {
														cc_id = get_creditcards.CREDITCARD_ID[i];
													}
												}

												if (Len(cc_id)) {
													bank_action = addDebitCreditCard(
														process_cat : process_cat_id,
														period_id : period_id,
														account_id : account_id,
														amount : amounts,
														date : date,
														detail : detail,
														paper_no : paper_no,
														record_emp : record_emp,
														creditcard_id: cc_id
													);
													if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
														is_success = 1;
													}
													else {
														error_str = bank_action;
													}
												}
											}
										}
                                    }
								}
                            break;

                            case '247'://Kredi Kartı Hesaba Geçiş İptal
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addPaymentCreditCard();
								}
                            break;

                            case '248'://Kredi Kartı Borcu Ödeme İptal
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addDebitCreditCard();
								}
                            break;

                            case '291'://Kredi Ödemesi
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
                                    if (Len(wdb_hareket.ACIKLAMA)) {
										regExCreditNo = '';

                                        if (wdb_hareket.bankaKodu Eq 12) {//Halkbank Kredi no arama
											regexQueryreditNo = REFind("([a-zA-Z0-9]{8}) NO'LU KREDI HESABININ ANAPARA TAKSIT ÖDEMESI", wdb_hareket.ACIKLAMA,1,true,"all");
											if (isArray(regexQueryreditNo) And arrayLen(regexQueryreditNo[1].match) Gt 1){
												regExCreditNo = regexQueryreditNo[1].match[2];
											}
										}
                                        else if (wdb_hareket.bankaKodu Eq 64) {//İş Bankası Kredi no arama
											regexQueryreditNo = REFind("KREDİ NO: ([0-9]{11}) - ANAPARA TAHSİLAT", wdb_hareket.ACIKLAMA,1,true,"all");
											if (isArray(regexQueryreditNo) And arrayLen(regexQueryreditNo[1].match) Gt 1){
												regExCreditNo = regexQueryreditNo[1].match[2];
											}
										}
                                        else if (wdb_hareket.bankaKodu Eq 205) {//Kuveyttürk Kredi no arama
											regexQueryreditNo = REFind("Kredi No: ([0-9]{7})", wdb_hareket.ACIKLAMA,1,true,"all");
											if (isArray(regexQueryreditNo) And arrayLen(regexQueryreditNo[1].match) Gt 1){
												regExCreditNo = regexQueryreditNo[1].match[2];
											}
										}

										if (Len(regExCreditNo)) {
											get_credit = queryExecute("SELECT cc.CREDIT_CONTRACT_ID, cc.CREDIT_NO, cc.COMPANY_ID, cc.PROJECT_ID FROM CREDIT_CONTRACT AS cc WHERE cc.IS_ACTIVE = 1 AND cc.AGREEMENT_NO = '#regExCreditNo#'",{},{datasource='#dsn3#'});

											if (get_credit.recordCount) {
												get_interest_action = new query();
                                                get_tax_action      = new query();
                                                get_exchange_interest_action = new query();

												if (wdb_hareket.bankaKodu Eq 12) {
													get_interest_action = queryExecute("SELECT WDB_ACTION_ID, MIKTAR
                                                                                    FROM   WODIBA_BANK_ACTIONS
                                                                                    WHERE  ACCOUNT_ID = #account_id#
                                                                                            AND PERIOD_ID = #period_id#
                                                                                            AND ACIKLAMA LIKE '%#regExCreditNo# NO LU KREDI HESABININ FAIZ/KOMISYON%'
                                                                                            AND DOVIZTURU = '#wdb_hareket.DovizTuru#'
                                                                                            AND BANK_ACTION_ID IS NULL
                                                                                            AND DOCUMENT_ID IS NULL",{},{datasource='#dsn#'});
												}
                                                else if (wdb_hareket.bankaKodu Eq 64) {
													get_interest_action = queryExecute("SELECT WDB_ACTION_ID, MIKTAR
                                                                                    FROM   WODIBA_BANK_ACTIONS
                                                                                    WHERE  ACCOUNT_ID = #account_id#
                                                                                            AND PERIOD_ID = #period_id#
                                                                                            AND ACIKLAMA LIKE '%KREDİ NO: #regExCreditNo# - FAİZ%'
                                                                                            AND DOVIZTURU = '#wdb_hareket.DovizTuru#'
                                                                                            AND TARIH = '#wdb_hareket.TARIH#'
                                                                                            AND BANK_ACTION_ID IS NULL
                                                                                            AND DOCUMENT_ID IS NULL",{},{datasource='#dsn#'});
													get_tax_action = queryExecute("SELECT WDB_ACTION_ID, MIKTAR
																					FROM   WODIBA_BANK_ACTIONS
																					WHERE  ACCOUNT_ID = #account_id#
																							AND PERIOD_ID = #period_id#
																							AND ACIKLAMA LIKE '%KREDİ NO: #regExCreditNo# - BSMV%'
																							AND DOVIZTURU = '#wdb_hareket.DovizTuru#'
                                                                                            AND TARIH = '#wdb_hareket.TARIH#'
																							AND BANK_ACTION_ID IS NULL
																							AND DOCUMENT_ID IS NULL",{},{datasource='#dsn#'});

                                                    //Dövizli kredilerin TL ödenmesi durumunda kur farkı bedeli banka tarafından faiz olarak yansıtılır, ana para ödemesi ile aynı hesapta kayıt edilir.
                                                    get_exchange_interest_action = queryExecute("SELECT WDB_ACTION_ID, MIKTAR
                                                                                    FROM   WODIBA_BANK_ACTIONS
                                                                                    WHERE  ACCOUNT_ID = #account_id#
                                                                                            AND PERIOD_ID = #period_id#
                                                                                            AND ACIKLAMA LIKE '%KREDİ NO: #regExCreditNo# - KUR FARKI FAİZ%'
                                                                                            AND DOVIZTURU = '#wdb_hareket.DovizTuru#'
                                                                                            AND TARIH = '#wdb_hareket.TARIH#'
                                                                                            AND BANK_ACTION_ID IS NULL
                                                                                            AND DOCUMENT_ID IS NULL",{},{datasource='#dsn#'});

                                                    if (isDefined('get_exchange_interest_action.recordcount') And get_exchange_interest_action.recordcount) {
                                                        amounts.action_value                = amounts.action_value + replace(get_exchange_interest_action.MIKTAR, '-', '');//işlem para birimi tutar
                                                        amounts.action_value_tax_free       = amounts.action_value;
                                                        amounts.system_action_value         = amounts.action_value * action_rate;//sistem para birimi tutar
                                                        amounts.system_action_value_tax_free= amounts.system_action_value;
                                                        amounts.system_action_value_2       = amounts.action_value * action_rate / action_rate_2;//sistem 2. para birimi tutar
                                                    }
												}

                                                bank_action = addPaymentCreditContract(
                                                    process_cat : process_cat_id,
                                                    period_id : period_id,
                                                    account_id : account_id,
                                                    amount : amounts,
                                                    date : date,
                                                    detail : detail,
                                                    paper_no : paper_no,
                                                    record_emp : record_emp,
                                                    credit_id: get_credit.CREDIT_CONTRACT_ID,
													credit_no: get_credit.CREDIT_NO,
													company_id: get_credit.COMPANY_ID,
                                                    project_id: (Len(get_credit.PROJECT_ID) ? get_credit.PROJECT_ID: 0),
                                                    interest_action: get_interest_action,
                                                    tax_action: get_tax_action
                                                );
												if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
													is_success = 1;
                                                    if (isDefined('get_interest_action.recordcount') And get_interest_action.recordcount) {
                                                        UpdateBankAction(ActionId=get_interest_action.WDB_ACTION_ID, BankActionId=bank_action.bank_action_id, DocumentId=bank_action.document_id);
                                                    }
                                                    if (isDefined('get_tax_action.recordcount') And get_tax_action.recordcount) {
                                                        UpdateBankAction(ActionId=get_tax_action.WDB_ACTION_ID, BankActionId=bank_action.bank_action_id, DocumentId=bank_action.document_id);
                                                    }
                                                    if (isDefined('get_exchange_interest_action.recordcount') And get_exchange_interest_action.recordcount) {
                                                        UpdateBankAction(ActionId=get_exchange_interest_action.WDB_ACTION_ID, BankActionId=bank_action.bank_action_id, DocumentId=bank_action.document_id);
                                                    }
												}
												else {
													error_str = bank_action;
												}
											}
										}
                                    }
								}
                            break;

                            case '292'://Kredi Tahsilatı
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addRevenueCreditContract();
								}
                            break;

                            case '1043'://Çek İşlemi Tahsil Bankaya
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addRevenueCheque();
								}
                            break;

                            case '1044'://Çek İşlemi Ödeme Bankadan
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
                                    if (Len(wdb_hareket.ACIKLAMA)) {
										regExChequeNumber='';

                                        if (wdb_hareket.bankaKodu Eq 12) {//Halkbank için çek no arama
											regexQueryChequeNumber = REFind("[0-9]{10}", wdb_hareket.ACIKLAMA,1,true,"all");

											if (isArray(regexQueryChequeNumber) And arrayLen(regexQueryChequeNumber[1].match) Eq 1 And Len(regexQueryChequeNumber[1].match[1])){
												regExChequeNumber = regexQueryChequeNumber[1].match[1];
											}
											else{
												regexQueryChequeNumber = REFind("[0-9]{7}", wdb_hareket.ACIKLAMA,1,true,"all");
												if (isArray(regexQueryChequeNumber) And arrayLen(regexQueryChequeNumber[1].match) Eq 1){
													regExChequeNumber = regexQueryChequeNumber[1].match[1];
												}
											}
										}

										if (Len(regExChequeNumber)) {
											get_cheque = queryExecute("SELECT CHEQUE_ID, CHEQUE_PURSE_NO FROM CHEQUE WHERE CHEQUE_NO = '#Int(regExChequeNumber)#' AND CHEQUE_VALUE = #amounts.action_value# AND CHEQUE_STATUS_ID = 6",{},{datasource='#dsn2#'}); 
											if (get_cheque.recordCount) {
												bank_action = addPaymentCheque(
													process_cat : process_cat_id,
													period_id : period_id,
													account_id : account_id,
													amount : amounts,
													date : date,
													detail : detail,
													paper_no : paper_no,
													record_emp : record_emp,
													cheque_id: get_cheque.CHEQUE_ID,
													cheque_no: regExChequeNumber,
													cheque_purse_no: get_cheque.CHEQUE_PURSE_NO
												);
												if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
													is_success = 1;
												}
												else {
													error_str = bank_action;
												}
											}
										}
                                    }
								}
                            break;

                            case '1051'://Senet İşlemi Ödeme Bankadan
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addPaymentVoucher();
								}
                            break;

                            case '1053'://Senet İşlemi Tahsil Bankaya
								//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
								else {
									addRevenueVoucher();
								}
                            break;

                            case '2501'://Çek/Senet Banka Ödeme
                                //Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
                                get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
                                if(get_bank_action.RecordCount){
                                    bank_action.bank_action_id  = get_bank_action.ACTION_ID;
                                    bank_action.document_id     = get_bank_action.ACTION_ID;
                                    is_success = 1;
                                }
                            break;

                            default:
                        }

                        if(is_success){
							//işlem başarılı ise wodiba banka işlemi ile sistem banka işlemini eşleştiriyoruz
                            UpdateBankAction(ActionId=wdb_hareket.WDB_ACTION_ID, BankActionId=bank_action.bank_action_id, DocumentId=bank_action.document_id);
                            
							/**
							 ** Fatura Kapama İşlemleri
							* Author: Gramoni-Fatih <fatih.ekin@gramoni.com>
    						* Date: 20.04.2021
							* 
							*/
                            //if(wdb_hesap.HESAPNO eq wdb_hareket.HESAPNO)
                            //writeOutput("#get_rule_set.IS_PROCESS_INVOICE_CLOSING# - #process_type# - #wdb_hesap.HESAPNO#/#wdb_hareket.HESAPNO# - #wdb_hesap.ACCOUNT_ID#/#wdb_hareket.ACCOUNT_ID# <br/>");

                            if(process_type Eq 24 Or process_type Eq 25){ // And wdb_hesap.HESAPNO eq wdb_hareket.HESAPNO And wdb_hesap.ACCOUNT_ID eq wdb_hareket.ACCOUNT_ID
								if (isDefined('get_rule_set.IS_PROCESS_INVOICE_CLOSING') And get_rule_set.IS_PROCESS_INVOICE_CLOSING Eq 1 Or (rule_set_row And rule_set.IS_PROCESS_INVOICE_CLOSING Eq 1)) {
									regExInvoiceNumber='';
									regexQueryInvoiceNumber = REFind("(([a-zA-Z0-9]{3,3})-#Year(wdb_hareket.TARIH)#([\d\.]{5,9})+)", wdb_hareket.ACIKLAMA,1,true,"all");

									if (isArray(regexQueryInvoiceNumber) And arrayLen(regexQueryInvoiceNumber[1].match) Gt 1){
										regExInvoiceNumber = regexQueryInvoiceNumber[1].match[2];
									}
									else{
										regexQueryInvoiceNumber = REFind("(([a-zA-Z0-9]{3,3})#Year(wdb_hareket.TARIH)#([\d\.]{5,9})+)", wdb_hareket.ACIKLAMA,1,true,"all");
										if (isArray(regexQueryInvoiceNumber) And arrayLen(regexQueryInvoiceNumber[1].match) Gt 1){
											regExInvoiceNumber = regexQueryInvoiceNumber[1].match[2];
										}
									}
									if (Len(regExInvoiceNumber) Gt 0) {
										purchase_sales=0;
										expense_cost_type=0;

										if(process_type Eq 24){
											purchase_sales=1;
											expense_cost_type=121;
										}
										else if(process_type Eq 25) {
											purchase_sales=0;
											expense_cost_type=120;
										}

										get_invoice = GetInvoice(
                                                        dsn2=dsn2,
                                                        invoiceNumber=regExInvoiceNumber,
                                                        companyId=company_id,
                                                        consumerId=consumer_id,
                                                        purchaseSales=purchase_sales,
                                                        expenseCostType=expense_cost_type);

										if(get_invoice.recordcount){
											purchase_sales='';
											toleransControlAmount=0;

											if(process_type Eq 24){
												purchase_sales=1;
												toleransControlAmount=Abs(wdb_hareket.MIKTAR-get_invoice.NETTOTAL);
											}
											else if(process_type Eq 25) {
												purchase_sales=0;
												toleransControlAmount=Abs(get_invoice.NETTOTAL+wdb_hareket.MIKTAR);
											}

                                            //Kapatılan tutar belge tutarından küçük olmalı
                                            get_closed_amount = queryExecute("SELECT ISNULL(SUM(CLOSED_AMOUNT),0) AS CLOSED_AMOUNT FROM CARI_CLOSED_ROW WHERE ACTION_TYPE_ID = #get_invoice.INVOICE_CAT# AND ACTION_ID = #get_invoice.INVOICE_ID#",{},{datasource='#dsn2#'});

                                            close_amount = get_invoice.NETTOTAL - get_closed_amount.CLOSED_AMOUNT;
                                            diff_amount = amounts.action_value - close_amount;

                                            if (diff_amount Gte 0) {
                                                close_amount = amounts.action_value - diff_amount;
                                            }
                                            else {
                                                close_amount = amounts.action_value;
                                            }

                                            /* if((toleransControlAmount LTE get_rule_set.INVOICE_CLOSING_PAYMENT_TOLERANS_VALUE Or toleransControlAmount LTE rule_set.INVOICE_CLOSING_PAYMENT_TOLERANS_VALUE) And get_closed_amount.CLOSED_AMOUNT Lt get_invoice.NETTOTAL){ */
											if(get_closed_amount.CLOSED_AMOUNT Lt get_invoice.NETTOTAL){
												AddInvoiceClose(
													process_stage: 36, //müşteri bazlı değişiklik gösterebiliyor..
													company_id: company_id,
													consumer_id: consumer_id,
													other_money: get_invoice.OTHER_MONEY,
													difference_amount_value: toleransControlAmount,
													debt_action_type_id: get_invoice.INVOICE_CAT,
													debt_action_value: get_invoice.NETTOTAL,
													debt_action_id: get_invoice.INVOICE_ID,
													claim_action_type_id: process_type,
													claim_action_value: amounts.action_value,
													claim_action_id: bank_action.bank_action_id,
													closed_amount: close_amount,
													other_closed_amount: close_amount,
                                                    record_emp: record_emp);

													LogType     = 'invoice_close';
													is_success = 1;
											}
											else {
												// tolerans değerinden büyük bir değer, log....
											}
										}
										else {
											//log
										}
									}
								}
                            }
                        }
                    }
                }

                //WodibaLogger Handling Cases
                /*Sözlük Kod/Açıklama : 59006,'Banka Kodu',48886,'İşlem Kodu',62592,'Dekont No',32509,'İşlem',41318,'Üye/Şirket'62593,'İşlem Yönü'
                                        62581,'Virman Karşı İşlem Tanımlanamadı.',62582,'Virman Karşı İşlem Tanımlanamadığı İçin Kayıt Edilemedi.',
                                        62583,'İşlem Kategorisi Tanımlanamadı.',62584,'İşlem Kategorisi Tanımlanamadığı İçin Kayıt Edilemedi.','Masraf Merkezi Ve Bütçe Kalemi Tanımlanamadı.',62586,'Masraf Merkezi Ve Bütçe Kalemi Tanımlanamadığı İçin Kayıt Edilemedi.',62587,'Banka Hesabı Pasif Veya Tanımlı Değil.',62588,'Banka Hesabı Tanımlanamadığı İçin Kayıt Edilemedi.',62589,'Hata Tanımlanamadı. !'
                                        52153,'Sistem Yöneticinize Başvurun.'
                */

                if (is_success neq 1) {
                    message_log     = '<br />' & getLang(dictionary_id=59006) & ' : ' & '#wdb_hareket.BANKAKODU#' & '<br />' & getLang(dictionary_id=48886) & ' : ' & '#wdb_hareket.ISLEMKODU#' & ' ';
                    extraInfo_log   = '<br />' & getLang(dictionary_id=62592) & ' : ' & '#wdb_hareket.DEKONTNO#' & 
                                    '<br />' & getLang(dictionary_id=32509) & ' ID: ' & '#wdb_hareket.WDB_ACTION_ID#' & 
                                    '<br />' & getLang(dictionary_id=41318) & ' ID: ' & '#our_company_id#' & 
                                    '<br />' & getLang(dictionary_id=59006) & ' : ' & '#wdb_hareket.BANKAKODU#' & 
                                    '<br />' & getLang(dictionary_id=48886) & ' : ' & '#wdb_hareket.ISLEMKODU#' & 
                                    '<br />'getLang(dictionary_id=62593) & ' : ' & '#target#' & ' ';
					message		= '';
					extraInfo	= '';
					IsBugLog	= 0;
                    if (process_type eq 23 and wdb_hareket.MIKTAR Lt 0) {
                        if(to_action.recordcount eq 0){
                            message     = getLang(dictionary_id=62581) & message_log;                       
                            extraInfo   = getLang(dictionary_id=62582) & extraInfo_log;
                            LogType     = 'eft_other_action';
                            if(Not Len(process_cat_id)){
                                IsBugLog = 1;
                            }
                            else {
                                IsBugLog = 0;
                            }//Bankadan yeni bir işlem kodu geldiği aşamada veya müşteri sisteminde kayıtlı işlem tipi olmadığında bugloga gönder
					    }
                    }
                    else if (Not Len(process_type)) {
                        message     = getLang(dictionary_id=62583) & message_log;
                        extraInfo   = getLang(dictionary_id=62584) & extraInfo_log;
                        LogType     = 'process_type';
                        if(Not Len(process_cat_id)){IsBugLog = 1;}else {IsBugLog = 0;}
                    }
                    else if (Not Len(expense_center_id) and Not Len(expense_item_id)) {
                        message     = getLang(dictionary_id=62585) & message_log;
                        extraInfo   = getLang(dictionary_id=62586) & extraInfo_log;
                        LogType     = 'expense';
                        if(Not Len(process_cat_id)){IsBugLog = 1;}else {IsBugLog = 0;}
                    }
                    else if (Not len(account_info.RecordCount)) {
                        message     = getLang(dictionary_id=62587) & message_log;
                        extraInfo   = getLang(dictionary_id=62588) & extraInfo_log;
                        LogType     = 'account_disable';
                        if(Not Len(process_cat_id)){IsBugLog = 1;}else {IsBugLog = 0;}
                    }
					else if (Not structIsEmpty(error_str)) {
						message     = error_str.error_message & message_log;
                        extraInfo   = error_str.error_message & extraInfo_log;
                        LogType     = error_str.error_type;
					}
                    else {
                        message     = getLang(dictionary_id=52153) & message_log;
                        extraInfo   = getLang(dictionary_id=62589) & extraInfo_log;
                        LogType     = 'other';
                        if(Not Len(process_cat_id)){IsBugLog = 1;}else {IsBugLog = 0;}
                    }
                    is_log_saved = GetLoggerInfo(ActionId=wdb_hareket.WDB_ACTION_ID, LogType=LogType);
                    if (is_log_saved.recordcount eq 0) {
                        WodibaLogger(message=message, extraInfo=extraInfo, LogType=LogType, IsBugLog=IsBugLog, ActionId=wdb_hareket.WDB_ACTION_ID, rec_user=record_emp);
                    }
				}
                else {
                    message_log     = '<br />' & getLang(dictionary_id=59006) & ' : ' & '#wdb_hareket.BANKAKODU#' & '<br />' & getLang(dictionary_id=48886) & ' : ' & '#wdb_hareket.ISLEMKODU#' & ' ';
                                    
                    switch (LogType) {
                        case 'invoice_close':
                            message = getLang(dictionary_id=61210) & message_log;
                            extraInfo_log   = '<br />' & getLang(dictionary_id=58133) & ' : ' & '#regExInvoiceNumber#';

                            if (process_type eq 24) {
                                extraInfo   = getLang(dictionary_id=35583) & extraInfo_log;
                            }
                            if (process_type eq 25) {
                                extraInfo   = getLang(dictionary_id=35569) & extraInfo_log;
                            }
                            
                            if(Not Len(process_cat_id)){IsBugLog = 1;}else {IsBugLog = 0;}

                            WodibaLogger(message=message, extraInfo=extraInfo, LogType=LogType, IsBugLog=IsBugLog, ActionId=wdb_hareket.WDB_ACTION_ID, rec_user=record_emp);

                            break;
                        default:
                            
                    }
                }
                //WodibaLogger Handling Cases

				period_id               = 0;
				our_company_id          = 0;
				our_company_vkn         = '';
                account_id              = 0;
                amount                  = 0;
                date                    = 0;
                detail                  = '';
                paper_no                = '';
                record_emp              = 0;
                acc_type_id             = 0;
                is_success              = 0;
                expense_center_id       = 0;
                expense_item_id         = 0;
                project_id              = 0;
                company_id              = 0;
                consumer_id             = 0;
                employee_id             = 0;
                to_account_id           = 0;
				is_our_company          = 0;
                payment_type_id         = 0;
                special_definition_id   = 0;
                asset_id                = 0;
                branch_id               = 0;
                branch_id_alacak        = 0;
                branch_id_borc          = 0;
                department_id           = 0;
                process_type            = '';
                process_cat_id          = '';
                dsn2                    = '';
                dsn3                    = '';
				to_action.recordcount	= 0;
                LogType                 ='';
				rule_set_row 			= 0;
				tax						= -1;
				tax_include				= 1;

                structClear(process_action_errors);
                structClear(bank_action);
                structClear(wdb_hareket);
            }
		structClear(wdb_hesap);
        }
    }
</cfscript>
<cfcatch>
    <cfdump var="#cfcatch#" />
    <cfmail from="#listlast(server_detail)#<#listfirst(server_detail)#>" to="wodiba@gramoni.com" subject="Wodiba Error (#listlast(server_detail)#)" type="HTML">
        <cfdump var="#cfcatch#" />
    </cfmail>
</cfcatch>
</cftry>