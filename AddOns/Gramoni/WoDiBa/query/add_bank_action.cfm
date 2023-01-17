<!---
	File: add_bank_action.cfm
	Author: Gramoni-Cagla <cagla.kara@gramoni.com>
	Date: 29.12.2019
	Controller: WodibaBankActionsController.cfm
	Description:
	form\add_bank_action.cfm sayfasından gönderilen değerler ile banka işlemi ekler.
	
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
--->

<cfscript>
	include "../cfc/Functions.cfc";
	include "../cfc/W3Actions.cfc";

	wdb_settings    = GetSettings(our_company_id: session.ep.company_id);
	wdb_bank_action     = GetBankActionWithId(ActionId=attributes.form_id);
	in_out              = iIf(wdb_bank_action.MIKTAR Gt 0,de('IN'),de('OUT'));
	get_process_type    = GetProcessType(BankCode=wdb_bank_action.bankakodu, TransactionCode=wdb_bank_action.islemkodu, InOut=in_out);

	period_id               = wdb_bank_action.period_id;
	account_id              = wdb_bank_action.account_id;
	amount                  = wdb_bank_action.miktar;
	date                    = CreateDateTime(year(wdb_bank_action.tarih), month(wdb_bank_action.tarih), day(wdb_bank_action.tarih), hour(wdb_bank_action.tarih), minute(wdb_bank_action.tarih), second(wdb_bank_action.tarih));
	detail                  = attributes.description;
	paper_no                = wdb_bank_action.dekontno;
	record_emp              = session.ep.userid;
	acc_type_id             = 0;
	is_success              = 0;

	if(attributes.expense_center_id==""){expense_center_id=0;}else{expense_center_id=attributes.expense_center_id;}
	if(attributes.expense_item_id==""){expense_item_id=0;}else{expense_item_id=attributes.expense_item_id;}
	if(attributes.project_id==""){project_id=0;}else{project_id=attributes.project_id;}
	if(attributes.ch_company_id==""){company_id=0;}else{company_id=attributes.ch_company_id;}
	if(attributes.ch_consumer_id==""){consumer_id=0;}else{consumer_id=attributes.ch_consumer_id;}
	if(attributes.ch_employee_id==""){employee_id=0;}else{employee_id=attributes.ch_employee_id;}
	if(attributes.paymethod_id==""){payment_type_id=0;}else{payment_type_id=attributes.paymethod_id;}
	if(attributes.special_definition_id==""){special_definition_id=0;}else{special_definition_id=attributes.special_definition_id;}
	if(attributes.asset_id==""){asset_id=0;}else{asset_id=attributes.asset_id;}
	branch_id               = attributes.branch_id;
	branch_id_alacak        = 0;
    branch_id_borc          = 0;
	department_id           = attributes.department;
	process_type            = get_process_type.process_type;
	process_cat_id          = attributes.process_cat_id;
	bank_action             = structNew();

	wdb_hareket  = GetBankAccount(BankaKodu=wdb_bank_action.bankakodu, SubeKodu=wdb_bank_action.subekodu, HesapNo=wdb_bank_action.hesapno, ActionIdNull=1);
	/* wodiba_dsn2 = '#dsn#_#Year(wdb_bank_action.TARIH)#_#wdb_hareket.OUR_COMPANY_ID#';
	wodiba_dsn3 = '#dsn#_#wdb_hareket.OUR_COMPANY_ID#'; */
	account_info    = GetAccountInfo(AccountId=account_id);
   
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

	amounts         = structNew('ordered');
	action_rate     = 1;
	action_rate_2   = 1;

	for(mon=1; mon Lte moneyResult.recordcount; mon++){
		if(moneyResult.MONEY[mon] eq account_info.ACCOUNT_CURRENCY_ID){
			action_rate     = moneyResult.RATE2[mon];
		}
		if(moneyResult.MONEY[mon] eq periodResult.OTHER_MONEY){
			action_rate_2   = moneyResult.RATE2[mon];
		}
	}

	amounts.action_value            = replace(amount, '-', '');
	amounts.action_currency_id      = account_info.ACCOUNT_CURRENCY_ID;
	amounts.system_action_value     = amounts.action_value * action_rate;
	amounts.system_currency_id      = periodResult.STANDART_PROCESS_MONEY;
	amounts.system_action_value_2   = amounts.action_value * action_rate / action_rate_2;
	amounts.system_currency_id_2    = periodResult.OTHER_MONEY;
	amounts.action_rate             = action_rate;
	amounts.action_rate_2           = action_rate_2;


	switch(process_type){

		case '21'://Para yatırma işlemi
			addInvestMoney();
		break;

		case '22'://Para çekme işlemi
			addGetMoney();
		break;

		case '23'://Döviz Alış Satış Virman İşlemi
			other_transaction=GetBankActionWithId(ActionId=attributes.other_action_id);
			if(other_transaction.miktar Lt 0){from_=other_transaction;to_=wdb_bank_action;}else{from_=wdb_bank_action;to_=other_transaction;}
			arguments_str                   = StructNew();
			arguments_str.process_cat       = process_cat_id;
			arguments_str.period_id         = period_id;
			arguments_str.acc_type_id       = acc_type_id;
			arguments_str.date              = CreateDateTime(year(from_.TARIH), month(from_.TARIH), day(from_.TARIH), hour(from_.TARIH), minute(from_.TARIH), second(from_.TARIH));
			arguments_str.from_action_id    = from_.WDB_ACTION_ID;

			from_account_info     = GetAccountInfo(AccountId=from_.ACCOUNT_ID);

			amounts         = structNew('ordered');
			action_rate     = 1;
			action_rate_2   = 1;

			for(mon=1; mon Lte moneyResult.recordcount; mon++){
				if(moneyResult.MONEY[mon] eq from_account_info.ACCOUNT_CURRENCY_ID){
					action_rate     = moneyResult.RATE2[mon];
				}
				if(moneyResult.MONEY[mon] eq periodResult.OTHER_MONEY){
					action_rate_2   = moneyResult.RATE2[mon];
				}
			}

			amounts.action_value            = replace(from_.miktar, '-', '');
			amounts.action_currency_id      = from_account_info.ACCOUNT_CURRENCY_ID;
			amounts.system_action_value     = amounts.action_value * action_rate;
			amounts.system_currency_id      = periodResult.STANDART_PROCESS_MONEY;
			amounts.system_action_value_2   = amounts.action_value * action_rate / action_rate_2;
			amounts.system_currency_id_2    = periodResult.OTHER_MONEY;
			amounts.action_rate             = action_rate;
			amounts.action_rate_2           = action_rate_2;
			
			arguments_str.from_amount       = amounts;
			arguments_str.from_account_id   = from_.ACCOUNT_ID;
			arguments_str.from_detail       = detail;
			arguments_str.from_paper_no     = paper_no;
			arguments_str.from_date         = date;
			arguments_str.record_emp        = record_emp;
			arguments_str.expense_center_id = expense_center_id;
			arguments_str.expense_item_id   = expense_item_id;
			arguments_str.project_id        = project_id;
			arguments_str.special_definition_id = special_definition_id;
			arguments_str.branch_id         = branch_id;
			arguments_str.branch_id_alacak  = branch_id_alacak;
            arguments_str.branch_id_borc    = branch_id_borc;
			arguments_str.department_id     = department_id;

			to_action   = GetBankActionWithId(ActionId=to_.WDB_ACTION_ID);
			if (to_action.RecordCount) {
				to_account_info     = GetAccountInfo(AccountId=to_action.ACCOUNT_ID);
				to_amounts          = structNew('ordered');
				to_action_rate      = 1;
				to_action_rate_2    = 1;

				for(mon=1; mon Lte moneyResult.recordcount; mon++){
					if(moneyResult.MONEY[mon] eq to_account_info.ACCOUNT_CURRENCY_ID){
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
				is_success  = 1;
			}
			else {
				writeOutput("<script>alert('Virman karşı işlem tanımlanamadığı için kayıt edilemedi.");
				WodibaLogger(
					message="Wodiba Başarısız Kayıt. İşlem Tipi: Virman, Banka Kodu: #wdb_bank_action.BANKAKODU#, İşlem Kodu: #wdb_bank_action.ISLEMKODU#",
					extraInfo="Virman karşı işlem tanımlanamadığı için kayıt edilemedi.<br />Dekont No: #wdb_bank_action.DEKONTNO#<br />İşlem ID: #wdb_bank_action.WDB_ACTION_ID#<br />Şirket ID: #wdb_bank_action.OUR_COMPANY_ID#<br />Banka Kodu: #wdb_bank_action.BANKAKODU#<br />İşlem Kodu: #wdb_bank_action.ISLEMKODU#<br />İşlem Yönü: #target#");
			}
			structClear(arguments_str);
		break;

		case '24':// Gelen havale
			//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
			get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
			if(get_bank_action.RecordCount){
				bank_action.bank_action_id  = get_bank_action.ACTION_ID;
				bank_action.document_id     = get_bank_action.ACTION_ID;
				is_success      = 1;
			}
			else if(company_id Neq 0 Or consumer_id Neq 0 Or employee_id Neq 0){
				bank_action = addIncomingTransfer(
					process_cat : process_cat_id,
					period_id : period_id,
					acc_type_id : (employee_id Neq 0 ? listLast(employee_id,'_') : acc_type_id),
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
					employee_id : (employee_id Neq 0 ? listFirst(employee_id,'_') : employee_id),
					payment_type_id: payment_type_id,
					special_definition_id: special_definition_id,
					asset_id : asset_id,
					branch_id: branch_id,
					department_id: department_id
				);
				is_success = 1;
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
			else if(company_id Neq 0 Or consumer_id Neq 0 Or employee_id Neq 0){
				bank_action = addOutgoingTransfer(
					process_cat : process_cat_id,
					period_id : period_id,
					acc_type_id : (employee_id Neq 0 ? listLast(employee_id,'_') : acc_type_id),
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
					employee_id : (employee_id Neq 0 ? listFirst(employee_id,'_') : employee_id),
					payment_type_id: payment_type_id,
					special_definition_id: special_definition_id,
					asset_id : asset_id,
					branch_id: branch_id,
					department_id: department_id
				);
				is_success = 1;
			}
		break;

		case '120':// Masraf fişi
			//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
			get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
			if(get_bank_action.RecordCount){
				bank_action.bank_action_id  = get_bank_action.ACTION_ID;
				bank_action.document_id     = 0;
				is_success                  = 1;
			}
			else if (expense_center_id Neq 0 And expense_item_id Neq 0){
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
				is_success = 1;
			}
			else {
				WodibaLogger(
						message="Wodiba Başarısız Kayıt. İşlem Tipi: Harcama Fişi, Banka Kodu: #wdb_bank_action.BANKAKODU#, İşlem Kodu: #wdb_bank_action.ISLEMKODU#",
						extraInfo="Masraf merkezi ve bütçe kalemi tanımlanamadığı için belge kayıt edilemedi.<br />Dekont No: #wdb_bank_action.DEKONTNO#<br />İşlem ID: #wdb_bank_action.WDB_ACTION_ID#<br />Şirket ID: #wdb_hareket.OUR_COMPANY_ID#<br />Banka Kodu: #wdb_bank_action.BANKAKODU#<br />İşlem Kodu: #wdb_bank_action.ISLEMKODU#<br />İşlem Yönü: #target#");
			}
		break;

		case '121'://Gelir fişi
			//Sistemde bu dekont ile kayıt var ise tekrar kayıt etmiyoruz, kaydı ilişkilendiriyoruz
			get_bank_action = GetRecordedBankAction(dsn2=dsn2, ProcessType=process_type, PaperNumber=paper_no, AccountId=account_id);
			if(get_bank_action.RecordCount){
				bank_action.bank_action_id  = get_bank_action.ACTION_ID;
				bank_action.document_id     = 0;
				is_success                  = 1;
			}
			else if (expense_center_id Neq 0 And expense_item_id Neq 0){
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
				is_success = 1;
			}
			else {
				WodibaLogger(
						message="Wodiba Başarısız Kayıt. İşlem Tipi: Harcama Fişi, Banka Kodu: #wdb_hareket.BANKAKODU#, İşlem Kodu: #wdb_hareket.ISLEMKODU#",
						extraInfo="Masraf merkezi ve bütçe kalemi tanımlanamadığı için belge kayıt edilemedi.<br />Dekont No: #wdb_hareket.DEKONTNO#<br />İşlem ID: #wdb_hareket.WDB_ACTION_ID#<br />Şirket ID: #wdb_hesap.OUR_COMPANY_ID#<br />Banka Kodu: #wdb_hareket.BANKAKODU#<br />İşlem Kodu: #wdb_hareket.ISLEMKODU#<br />İşlem Yönü: #target#");
			}
		break;

		case '243'://Kredi Kartı Hesaba Geçiş
			addPaymentCreditCard();
		break;
		
		case '244'://Kredi Kartı Borcu Ödeme
			addDebitCreditCard();
		break;
		
		case '247'://Kredi Kartı Hesaba Geçiş İptal
			addPaymentCreditCard();
		break;
		
		case '248'://Kredi Kartı Borcu Ödeme İptal
			addDebitCreditCard();
		break;
		
		case '291'://Kredi Ödemesi
			addPaymentCreditContract();
		break;
		
		case '292'://Kredi Tahsilatı
			addRevenueCreditContract();
		break;
		
		case '1043'://Çek İşlemi Tahsil Bankaya
			addRevenueCheque();
		break;
		
		case '1044'://Çek İşlemi Ödeme Bankadan
			addPaymentCheque();
		break;
		
		case '1051'://Senet İşlemi Ödeme Bankadan
			addPaymentVoucher();
		break;
		
		case '1053'://Senet İşlemi Tahsil Bankaya
			addRevenueVoucher();
		break;
		
		case '2501'://Çek/Senet Banka Ödeme
			
		break;
	}
	if(is_success){//işlem başarılı ise wodiba banka işlemi ile sistem banka işlemini eşleştiriyoruz
		if (isDefined('bank_action.bank_action_id') And isDefined('bank_action.document_id')) {
			UpdateBankAction(ActionId=wdb_bank_action.WDB_ACTION_ID, BankActionId=bank_action.bank_action_id, DocumentId=bank_action.document_id);
			writeOutput("<script>alert('Kayıt başarılı');</script>");
		}
		else {
			writeOutput("<script>alert('#bank_action.ERROR_MESSAGE#');window.close();</script>");
		}
	}
	is_success              = 0;
	expense_center_id       = 0;
	expense_item_id         = 0;
	project_id              = 0;
	company_id              = 0;
	consumer_id             = 0;
	employee_id             = 0;
	payment_type_id         = 0;
	special_definition_id   = 0;
	asset_id                = 0;
	branch_id               = 0;
	department_id           = 0;
	process_type            = '';
	process_cat_id          = '';

	structClear(bank_action);
</cfscript>
<script type="text/javascript">	
	location.href = document.referrer;
</script>