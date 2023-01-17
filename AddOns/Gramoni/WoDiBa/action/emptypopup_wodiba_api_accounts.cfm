<!---
    File: emptypopup_wodiba_api_accounts.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 10.12.2018
    Controller:
    Description:
		Gateway sistemine bağlanarak banka hesap bilgilerini çeken job action
--->

<cfscript>
    include "../cfc/WebService.cfc";
    include "../cfc/Functions.cfc";

    get_company  = queryExecute("SELECT OUR_COMPANY_ID FROM WODIBA_API_DEFINITIONS ORDER BY OUR_COMPANY_ID",{},{datasource='#dsn#'});

    for (company_ in get_company) {
		init(our_company_id: company_.OUR_COMPANY_ID);

		wdb_hesaplar[company_.OUR_COMPANY_ID] =   Hesaplar();

        if(arrayLen(wdb_hesaplar[company_.OUR_COMPANY_ID])){
			for(e=1; e <= ArrayLen(wdb_hesaplar[company_.OUR_COMPANY_ID]); e++){
				wdb_hesap[company_.OUR_COMPANY_ID][e] = GetBankAccount(
					BankaKodu   = wdb_hesaplar[company_.OUR_COMPANY_ID][e].bankaKodu,
					SubeKodu    = wdb_hesaplar[company_.OUR_COMPANY_ID][e].subeKodu,
					HesapNo     = wdb_hesaplar[company_.OUR_COMPANY_ID][e].hesapNo
				);
				
				if(wdb_hesap[company_.OUR_COMPANY_ID][e].RecordCount){
					UpdateBankAccount(
						wdb_account_id      = wdb_hesap[company_.OUR_COMPANY_ID][e].WDB_ACCOUNT_ID,
						Bakiye              = wdb_hesaplar[company_.OUR_COMPANY_ID][e].bakiye,
						UpdateUser          = 0,
						UpdateIp            = '127.0.0.1'
					);
				}
			}
		}
    }
</cfscript>