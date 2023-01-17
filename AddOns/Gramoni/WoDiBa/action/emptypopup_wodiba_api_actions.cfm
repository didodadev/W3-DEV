<!---
    File: emptypopup_wodiba_api_actions.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 19.12.2018
    Controller:
    Description:
		Gateway sistemine bağlanarak banka hesap hareketlerini çeken job action
--->

<cfscript>
    include "../cfc/WebService.cfc";
    include "../cfc/Functions.cfc";

    get_company  = queryExecute("SELECT OUR_COMPANY_ID, WDB_START_DATE FROM WODIBA_API_DEFINITIONS ORDER BY OUR_COMPANY_ID",{},{datasource='#dsn#'});

    for (company_ in get_company) {
        init(our_company_id: company_.OUR_COMPANY_ID);

        if (dateDiff('m',get_company.WDB_START_DATE,Now())) {
            BaslangicTarihi = DateFormat(DateAdd("m","-1",Now()),"YYYY-mm-dd");
        }
        else {
            BaslangicTarihi = DateFormat(get_company.WDB_START_DATE,"YYYY-mm-dd");
        }

        wdb_hareketler[company_.OUR_COMPANY_ID] = HesapHareketleri(BaslangicTarihi: BaslangicTarihi);

        if(arrayLen(wdb_hareketler[company_.OUR_COMPANY_ID])){
            for(e=1; e <= ArrayLen(wdb_hareketler[company_.OUR_COMPANY_ID]); e++){
                BankaKodu[company_.OUR_COMPANY_ID][e]   = wdb_hareketler[company_.OUR_COMPANY_ID][e].bankaKodu;
                SubeKodu[company_.OUR_COMPANY_ID][e]    = wdb_hareketler[company_.OUR_COMPANY_ID][e].subeKodu;
                HesapNo[company_.OUR_COMPANY_ID][e]     = wdb_hareketler[company_.OUR_COMPANY_ID][e].hesapNo;
                DovizTuru[company_.OUR_COMPANY_ID][e]   = wdb_hareketler[company_.OUR_COMPANY_ID][e].dovizTuru;

                if(structKeyExists(wdb_hareketler[company_.OUR_COMPANY_ID][e], "hareketler")){
                    HAREKETLER[company_.OUR_COMPANY_ID][e] = wdb_hareketler[company_.OUR_COMPANY_ID][e].hareketler;

                    for(i=1; i <= ArrayLen(HAREKETLER[company_.OUR_COMPANY_ID][e]); i++){
                        bank_action[company_.OUR_COMPANY_ID] = GetBankAction(
                            BankaKodu   = BankaKodu[company_.OUR_COMPANY_ID][e],
                            SubeKodu    = SubeKodu[company_.OUR_COMPANY_ID][e],
                            HesapNo     = HesapNo[company_.OUR_COMPANY_ID][e],
                            DovizTuru   = DovizTuru[company_.OUR_COMPANY_ID][e],
                            islId       = HAREKETLER[company_.OUR_COMPANY_ID][e][i].islId
                        );

                        if(Not bank_action[company_.OUR_COMPANY_ID].RecordCount){
                            if(structKeyExists(HAREKETLER[company_.OUR_COMPANY_ID][e][i], "GuncellemeTarihi")){
                                GuncellemeTarihi[company_.OUR_COMPANY_ID][e][i]  = HAREKETLER[company_.OUR_COMPANY_ID][e][i].GuncellemeTarihi;
                            }
                            else{
                                GuncellemeTarihi[company_.OUR_COMPANY_ID][e][i]  = '1900-01-01';
                            }

                            account[company_.OUR_COMPANY_ID]= GetBankAccount(BankaKodu=HAREKETLER[company_.OUR_COMPANY_ID][e][i].BankaKodu, SubeKodu=HAREKETLER[company_.OUR_COMPANY_ID][e][i].SubeKodu, HesapNo=HAREKETLER[company_.OUR_COMPANY_ID][e][i].HesapNo);
                            period[company_.OUR_COMPANY_ID] = GetPeriodByDate(CompanyId=account[company_.OUR_COMPANY_ID].OUR_COMPANY_ID,Date=DateFormat(HAREKETLER[company_.OUR_COMPANY_ID][e][i].Tarih,'YYYY-mm-dd'));

                            AddBankAction(
                                AccountId           = account[company_.OUR_COMPANY_ID].ACCOUNT_ID,
                                PeriodId            = period[company_.OUR_COMPANY_ID].PERIOD_ID,
                                UId                 = HAREKETLER[company_.OUR_COMPANY_ID][e][i].UId,
                                BankaKodu           = HAREKETLER[company_.OUR_COMPANY_ID][e][i].BankaKodu,
                                HesapNo             = HAREKETLER[company_.OUR_COMPANY_ID][e][i].HesapNo,
                                MusteriNo           = HAREKETLER[company_.OUR_COMPANY_ID][e][i].MusteriNo,
                                SubeKodu            = HAREKETLER[company_.OUR_COMPANY_ID][e][i].SubeKodu,
                                Tarih               = HAREKETLER[company_.OUR_COMPANY_ID][e][i].Tarih,
                                Isl_Id              = HAREKETLER[company_.OUR_COMPANY_ID][e][i].islId,
                                DekontNo            = HAREKETLER[company_.OUR_COMPANY_ID][e][i].DekontNo,
                                Kaynak              = HAREKETLER[company_.OUR_COMPANY_ID][e][i].Kaynak,
                                Miktar              = HAREKETLER[company_.OUR_COMPANY_ID][e][i].Miktar,
                                Bakiye              = HAREKETLER[company_.OUR_COMPANY_ID][e][i].Bakiye,
                                DovizTuru           = HAREKETLER[company_.OUR_COMPANY_ID][e][i].DovizTuru,
                                Aciklama            = HAREKETLER[company_.OUR_COMPANY_ID][e][i].Aciklama,
                                KarsiVKN            = HAREKETLER[company_.OUR_COMPANY_ID][e][i].KarsiVKN,
                                KarsiIban           = HAREKETLER[company_.OUR_COMPANY_ID][e][i].KarsiIban,
                                IslemKodu           = HAREKETLER[company_.OUR_COMPANY_ID][e][i].IslemKodu,
                                GuncellemeTarihi    = GuncellemeTarihi[company_.OUR_COMPANY_ID][e][i],
                                Order               = HAREKETLER[company_.OUR_COMPANY_ID][e][i].Order
                            );
                        }
                    }
                }
            }
        }
    }
</cfscript>