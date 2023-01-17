/* 
    File: Functions.cfc
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 03.11.2018
    Controller:
    Description:
		Wodiba için kullanılan fonksiyonlar sınıfı
*/
component{

    public string function GetSettingOld(required string SettingName){
        
        variables               = structNew();
        variables.apiURL        = '';
        variables.apiUser       = '';
        variables.apiPassword   = '';
        variables.apiServerIP   = '';

        if(structKeyExists(variables, arguments.SettingName)){
            return variables['#arguments.SettingName#'];
        }
        else{
            return '#arguments.SettingName# parametresi mevcut değil';
        }
    }

    public query function GetSettings(required numeric our_company_id){
        dsn     = application.systemParam.systemParam().dsn;

        queryObject = new Query();
        queryObject.setDatasource("#dsn#");
        queryObject.addParam(name="our_company_id",value="#arguments.our_company_id#",cfsqltype="NUMERIC");
        result = queryObject.execute(sql="SELECT * FROM WODIBA_API_DEFINITIONS WHERE OUR_COMPANY_ID = :our_company_id");
        result = result.getResult();
        return result;
    }

    public void function UpdateSettings(
		required numeric	our_company_id,
        required string     api_uri,
        required string     api_username,
        required string     api_password,
        required string     api_ip,
        required numeric    emp_id,
        required string     start_date){
        queryObject = new Query();
        queryObject.setDatasource("#dsn#");
		queryObject.addParam(name="our_company_id",value="#arguments.our_company_id#",cfsqltype="NUMERIC");
        queryObject.addParam(name="api_uri",value="#arguments.api_uri#",cfsqltype="VARCHAR");
        queryObject.addParam(name="api_username",value="#arguments.api_username#",cfsqltype="VARCHAR");
        queryObject.addParam(name="api_password",value="#arguments.api_password#",cfsqltype="VARCHAR");
        queryObject.addParam(name="api_ip",value="#arguments.api_ip#",cfsqltype="VARCHAR");
        queryObject.addParam(name="emp_id",value="#arguments.emp_id#",cfsqltype="NUMERIC");
        queryObject.addParam(name="start_date",value="#arguments.start_date#",cfsqltype="TIMESTAMP");

		get_def = queryExecute("SELECT DEF_ID FROM WODIBA_API_DEFINITIONS WHERE OUR_COMPANY_ID = #arguments.our_company_id#",{},{datasource='#dsn#'});

		if (get_def.recordcount) {
			queryObject.execute(sql="UPDATE WODIBA_API_DEFINITIONS SET WDB_API_URI = :api_uri, WDB_API_USERNAME = :api_username, WDB_API_PASSWORD = :api_password, WDB_API_SERVER_IP = :api_ip, WDB_EMP_ID = :emp_id, WDB_START_DATE = :start_date, UPD_USER = #session.ep.userid#, UPD_DATE = #Now()#, UPD_IP = '#CGI.REMOTE_ADDR#' WHERE OUR_COMPANY_ID = :our_company_id");
		}
		else {
			queryObject.execute(sql="INSERT INTO
				WODIBA_API_DEFINITIONS
				   (
						OUR_COMPANY_ID,
						WDB_API_URI,
						WDB_API_USERNAME,
						WDB_API_PASSWORD,
						WDB_API_SERVER_IP,
						WDB_EMP_ID,
						WDB_START_DATE,
						REC_USER,
						REC_DATE,
						REC_IP
				   )
			 			VALUES
				   (
						:our_company_id,
						:api_uri,
						:api_username,
						:api_password,
						:api_ip,
						:emp_id,
						:start_date,
						#session.ep.userid#,
						#Now()#,
						'#CGI.REMOTE_ADDR#'
				   )");
		}

        queryObject.clearParams();
    }

    public query function GetBankAccount(
        required numeric BankaKodu,
        required numeric SubeKodu,
        required string HesapNo){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="BankaKodu",value="#arguments.BankaKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="SubeKodu",value="#arguments.SubeKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="HesapNo",value="#arguments.HesapNo#",cfsqltype="VARCHAR");
        queryObj.setSQL("SELECT * FROM WODIBA_BANK_ACCOUNTS WHERE BANKAKODU = :BankaKodu AND SUBEKODU = :SubeKodu AND HESAPNO = :HesapNo");
        result = queryObj.execute();
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetBankAccountsWithBank(
        required numeric CompanyId,
        required numeric BankaKodu){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="CompanyId",value="#arguments.CompanyId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="BankaKodu",value="#arguments.BankaKodu#",cfsqltype="NUMERIC");
        queryObj.setSQL("SELECT * FROM WODIBA_BANK_ACCOUNTS WHERE OUR_COMPANY_ID = :CompanyId AND BANKAKODU = :BankaKodu");
        result = queryObj.execute();
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetBankAccountWithId(
        required numeric CompanyId,
        required numeric AccountId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="CompanyId",value="#arguments.CompanyId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        result = queryObj.execute(sql="SELECT * FROM WODIBA_BANK_ACCOUNTS WHERE OUR_COMPANY_ID = :CompanyId AND ACCOUNT_ID = :AccountId");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetBankAccountsWithCompany(required numeric CompanyId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="CompanyId",value="#arguments.CompanyId#",cfsqltype="NUMERIC");
        result = queryObj.execute(sql="SELECT * FROM WODIBA_BANK_ACCOUNTS WHERE OUR_COMPANY_ID = :CompanyId AND STATUS = 1");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetBankAccounts(required string dsn){
        queryObj = new Query();
        queryObj.setDatasource("#arguments.dsn#");
        result = queryObj.execute(sql="SELECT * FROM WODIBA_BANK_ACCOUNTS");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public void function AddBankAccount(
        required boolean    Status,
        required numeric    CompanyId,
        required numeric    AccountId,
        required string     BankaKodu,
        required string     SubeKodu,
        required string     HesapNo,
        required string     DovizTuru, 
        required string     ApiUser,
        required string     ApiPassword){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="Status",value="#arguments.Status#",cfsqltype="BIT");
        queryObj.addParam(name="CompanyId",value="#arguments.CompanyId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="BankaKodu",value="#arguments.BankaKodu#",cfsqltype="VARCHAR");
        queryObj.addParam(name="SubeKodu",value="#arguments.SubeKodu#",cfsqltype="VARCHAR");
        queryObj.addParam(name="HesapNo",value="#arguments.HesapNo#",cfsqltype="VARCHAR");
        queryObj.addParam(name="DovizTuru",value="#arguments.DovizTuru#",cfsqltype="VARCHAR");
        queryObj.addParam(name="ApiUser",value="#arguments.ApiUser#",cfsqltype="VARCHAR");
        queryObj.addParam(name="ApiPassword",value="#arguments.ApiPassword#",cfsqltype="VARCHAR");
        queryObj.addParam(name="RecordUser",value="#session.ep.userid#",cfsqltype="NUMERIC");
        queryObj.addParam(name="RecordDate",value="#Now()#",cfsqltype="TIMESTAMP");
        queryObj.addParam(name="RecordIp",value="#CGI.REMOTE_ADDR#",cfsqltype="VARCHAR");
        queryObj.execute(sql="INSERT INTO WODIBA_BANK_ACCOUNTS (STATUS,OUR_COMPANY_ID,ACCOUNT_ID,BANKAKODU,SUBEKODU,HESAPNO,DOVIZTURU,API_USER,API_PASSWORD,REC_USER,REC_DATE,REC_IP) VALUES (:Status,:CompanyId,:AccountId,:BankaKodu,:SubeKodu,:HesapNo,:DovizTuru,:ApiUser,:ApiPassword,:RecordUser,:RecordDate,:RecordIp)");
        queryObj.clearParams();
    }

    public void function UpdateBankAccount(
        required numeric    wdb_account_id,
        required string     Bakiye,
        required string     UpdateUser,
        required string     UpdateIp){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="wdb_account_id",value="#arguments.wdb_account_id#",cfsqltype="NUMERIC");
        queryObj.addParam(name="Bakiye",value="#arguments.Bakiye#",cfsqltype="VARCHAR");
        queryObj.addParam(name="UpdateUser",value="#arguments.UpdateUser#",cfsqltype="VARCHAR");
        queryObj.addParam(name="UpdateDate",value="#Now()#",cfsqltype="TIMESTAMP");
        queryObj.addParam(name="UpdateIp",value="#arguments.UpdateIp#",cfsqltype="VARCHAR");
        queryObj.execute(sql="UPDATE WODIBA_BANK_ACCOUNTS SET BAKIYE = :Bakiye, UPD_USER = :UpdateUser, UPD_DATE = :UpdateDate, UPD_IP = :UpdateIp WHERE WDB_ACCOUNT_ID = :wdb_account_id");
        queryObj.clearParams();
    }

    public void function UpdateBankAccountWithId(
        required boolean    Status,
        required numeric    CompanyId,
        required numeric    AccountId,
        required string     BankaKodu,
        required string     SubeKodu,
        required string     HesapNo,
        required string     ApiUser,
        required string     ApiPassword,
        boolean    IsDelete){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="Status",value="#arguments.Status#",cfsqltype="BIT");
        queryObj.addParam(name="CompanyId",value="#arguments.CompanyId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="BankaKodu",value="#arguments.BankaKodu#",cfsqltype="VARCHAR");
        queryObj.addParam(name="SubeKodu",value="#arguments.SubeKodu#",cfsqltype="VARCHAR");
        queryObj.addParam(name="HesapNo",value="#arguments.HesapNo#",cfsqltype="VARCHAR");
        queryObj.addParam(name="ApiUser",value="#arguments.ApiUser#",cfsqltype="VARCHAR");
        queryObj.addParam(name="ApiPassword",value="#arguments.ApiPassword#",cfsqltype="VARCHAR");
        queryObj.addParam(name="UpdateUser",value="#session.ep.userid#",cfsqltype="VARCHAR");
        queryObj.addParam(name="UpdateDate",value="#Now()#",cfsqltype="TIMESTAMP");
        queryObj.addParam(name="UpdateIp",value="#CGI.REMOTE_ADDR#",cfsqltype="VARCHAR");
        if (arguments.IsDelete Eq 1) {
            queryObj.execute(sql="DELETE WODIBA_BANK_ACCOUNTS WHERE ACCOUNT_ID = :AccountId");
        }
        else {
            queryObj.execute(sql="UPDATE WODIBA_BANK_ACCOUNTS SET STATUS = :Status, BANKAKODU = :BankaKodu, SUBEKODU = :SubeKodu, HESAPNO = :HesapNo, API_USER = :ApiUser, API_PASSWORD = :ApiPassword, UPD_USER = :UpdateUser, UPD_DATE = :UpdateDate, UPD_IP = :UpdateIp WHERE OUR_COMPANY_ID = :CompanyId AND ACCOUNT_ID = :AccountId");
        }
        queryObj.clearParams();
    }

    public query function GetBankAction(
        required numeric BankaKodu,
        required numeric SubeKodu,
        required string HesapNo,
        required string DovizTuru,
        required string islId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="BankaKodu",value="#arguments.BankaKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="SubeKodu",value="#arguments.SubeKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="HesapNo",value="#arguments.HesapNo#",cfsqltype="VARCHAR");
        queryObj.addParam(name="DovizTuru",value="#arguments.DovizTuru#",cfsqltype="VARCHAR");
        queryObj.addParam(name="islId",value="#arguments.islId#",cfsqltype="VARCHAR");
        result = queryObj.execute(sql="SELECT BANK_ACTION_ID FROM WODIBA_BANK_ACTIONS WHERE BANKAKODU = :BankaKodu AND SUBEKODU = :SubeKodu AND HESAPNO = :HesapNo AND DOVIZTURU = :DovizTuru AND ISL_ID = :islId");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetBankActionMoney( required numeric AccountId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        result = queryObj.execute(sql="SELECT 
            A.ACCOUNT_NAME,WDB.ISLEMKODU,WDB.DOCUMENT_ID,WDB.DEKONTNO,WDB.TARIH,WDB.ACIKLAMA,WDB.KARSIIBAN,WDB.KARSIVKN,WDB.MIKTAR,WDB.DOVIZTURU,WDB.BANK_ACTION_ID,WDB.WDB_ACTION_ID
            FROM WODIBA_BANK_ACTIONS WDB 
            INNER JOIN WODIBA_BANK_TRANSACTION_TYPES WBTT ON WBTT.TRANSACTION_CODE=WDB.ISLEMKODU
            LEFT OUTER JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_ID = WDB.ACCOUNT_ID
            WHERE 
            (WBTT.PROCESS_TYPE=120 OR WBTT.PROCESS_TYPE=121) AND wdb.ACCOUNT_ID=:AccountId AND WDB.BANK_ACTION_ID IS NULL AND WDB.PERIOD_ID = #session.ep.period_id#");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetBankActionOnly(
        required string money){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");

        if(arguments.money=="+")
        {
            result = queryObj.execute(sql="SELECT 
                A.ACCOUNT_NAME,WDB.ISLEMKODU,WDB.DOCUMENT_ID,WDB.DEKONTNO,WDB.TARIH,WDB.ACIKLAMA,WDB.KARSIIBAN,WDB.KARSIVKN,WDB.MIKTAR,WDB.DOVIZTURU,WDB.BANK_ACTION_ID,WDB.WDB_ACTION_ID
                FROM WODIBA_BANK_ACTIONS WDB 
                INNER JOIN WODIBA_BANK_TRANSACTION_TYPES WBTT ON WBTT.TRANSACTION_CODE=WDB.ISLEMKODU
                LEFT OUTER JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_ID = WDB.ACCOUNT_ID
                WHERE 
                WBTT.PROCESS_TYPE=23 AND WDB.BANK_ACTION_ID IS NULL AND WDB.PERIOD_ID = #session.ep.period_id# AND WDB.MIKTAR<0");
        }
        else
        {
            result = queryObj.execute(sql="SELECT 
                A.ACCOUNT_NAME,WDB.ISLEMKODU,WDB.DOCUMENT_ID,WDB.DEKONTNO,WDB.TARIH,WDB.ACIKLAMA,WDB.KARSIIBAN,WDB.KARSIVKN,WDB.MIKTAR,WDB.DOVIZTURU,WDB.BANK_ACTION_ID,WDB.WDB_ACTION_ID
                FROM WODIBA_BANK_ACTIONS WDB 
                INNER JOIN WODIBA_BANK_TRANSACTION_TYPES WBTT ON WBTT.TRANSACTION_CODE=WDB.ISLEMKODU
                LEFT OUTER JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_ID = WDB.ACCOUNT_ID
                WHERE 
                WBTT.PROCESS_TYPE=23 AND WDB.BANK_ACTION_ID IS NULL AND WDB.PERIOD_ID = #session.ep.period_id# AND WDB.MIKTAR>0");
        }
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetBankActionWithId(
        required numeric ActionId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="ActionId",value="#arguments.ActionId#",cfsqltype="NUMERIC");
        result = queryObj.execute(sql="SELECT * FROM WODIBA_BANK_ACTIONS WHERE WDB_ACTION_ID = :ActionId");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetBankActions(
        required numeric BankaKodu,
        required numeric SubeKodu,
        required string HesapNo,
        numeric ActionIdNull,
        string DevBankCode = '',
        string DevActionType = '',
        numeric DevActionId = 0){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="BankaKodu",value="#arguments.BankaKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="SubeKodu",value="#arguments.SubeKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="HesapNo",value="#arguments.HesapNo#",cfsqltype="VARCHAR");
        queryObj.addParam(name="ActionIdNull",value="#arguments.ActionIdNull#",cfsqltype="NUMERIC");
        queryObj.addParam(name="DevBankCode",value="#arguments.DevBankCode#",cfsqltype="VARCHAR");
        queryObj.addParam(name="DevActionType",value="#arguments.DevActionType#",cfsqltype="VARCHAR");
        queryObj.addParam(name="DevActionId",value="#arguments.DevActionId#",cfsqltype="NUMERIC");
        
        if (Len(arguments.DevBankCode) And Len(arguments.DevActionType) And arguments.DevActionId Neq 0) {
            sql = 'SELECT * FROM WODIBA_BANK_ACTIONS WHERE ACCOUNT_ID <> 0 AND MIKTAR <> 0 AND BANKAKODU = :DevBankCode AND HESAPNO = :HesapNo AND ISLEMKODU = :DevActionType AND WDB_ACTION_ID = :DevActionId';
		}
		else {
			sql = 'SELECT * FROM WODIBA_BANK_ACTIONS WHERE ACCOUNT_ID <> 0 AND MIKTAR <> 0 AND BANKAKODU = :BankaKodu AND SUBEKODU = :SubeKodu AND HESAPNO = :HesapNo';
		}

        if(arguments.ActionIdNull Eq 1){
            sql = sql & ' AND BANK_ACTION_ID IS NULL AND DOCUMENT_ID IS NULL';
        }

        sql = sql & ' ORDER BY WDB_ACTION_ID';
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();
        return result;
    }

    public query function GetNoneWodibaBankActions(
        required numeric AccountId){
        queryObj=new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="ACCOUNT_ID",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        sql= 'SELECT ACTION_TYPE,ACTION_VALUE,ACTION_CURRENCY_ID,PAPER_NO AS DEKONTNO,ACTION_DATE AS TARIH FROM #dsn2#.BANK_ACTIONS ba WHERE ISNULL(ba.ACTION_FROM_ACCOUNT_ID, ba.ACTION_TO_ACCOUNT_ID)= :ACCOUNT_ID  
        AND ACTION_ID NOT IN(SELECT wba.BANK_ACTION_ID FROM WODIBA_BANK_ACTIONS wba WHERE wba.ACCOUNT_ID= :ACCOUNT_ID  AND wba.PERIOD_ID=6 AND wba.BANK_ACTION_ID IS NOT NULL)';
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();
        return result;
    }
    
    public void function AddBankAction( 
        required numeric    AccountId,
        required numeric    PeriodId,
        required string     UId,
        required numeric    BankaKodu,
        required string     HesapNo,
        required string     MusteriNo,
        required numeric    SubeKodu,
        required date       Tarih,
        required string     Isl_Id,
        required string     DekontNo,
        required string     Kaynak,
        required string     Miktar,
        required string     Bakiye,
        required string     DovizTuru,
        required string     Aciklama,
        required string     KarsiVKN,
        required string     KarsiIban,
        required string     IslemKodu,
        required date       GuncellemeTarihi,
        required numeric    Order){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="ACCOUNT_ID",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="PERIOD_ID",value="#arguments.PeriodId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="UId",value="#arguments.UId#",cfsqltype="VARCHAR");
        queryObj.addParam(name="BankaKodu",value="#arguments.BankaKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="HesapNo",value="#arguments.HesapNo#",cfsqltype="VARCHAR");
        queryObj.addParam(name="MusteriNo",value="#arguments.MusteriNo#",cfsqltype="VARCHAR");
        queryObj.addParam(name="SubeKodu",value="#arguments.SubeKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="Tarih",value="#arguments.Tarih#",cfsqltype="TIMESTAMP");
        queryObj.addParam(name="Isl_Id",value="#arguments.Isl_Id#",cfsqltype="VARCHAR");
        queryObj.addParam(name="DekontNo",value="#arguments.DekontNo#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Kaynak",value="#arguments.Kaynak#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Miktar",value="#arguments.Miktar#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Bakiye",value="#arguments.Bakiye#",cfsqltype="VARCHAR");
        queryObj.addParam(name="DovizTuru",value="#arguments.DovizTuru#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Aciklama",value="#arguments.Aciklama#",cfsqltype="VARCHAR");
        queryObj.addParam(name="KarsiVKN",value="#arguments.KarsiVKN#",cfsqltype="VARCHAR");
        queryObj.addParam(name="KarsiIban",value="#arguments.KarsiIban#",cfsqltype="VARCHAR");
        queryObj.addParam(name="IslemKodu",value="#arguments.IslemKodu#",cfsqltype="VARCHAR");
        queryObj.addParam(name="GuncellemeTarihi",value="#arguments.GuncellemeTarihi#",cfsqltype="TIMESTAMP");
        queryObj.addParam(name="Order",value="#arguments.Order#",cfsqltype="NUMERIC");
        queryObj.addParam(name="WDB_REC_DATE",value="#Now()#",cfsqltype="TIMESTAMP");
        queryObj.execute(sql="INSERT INTO WODIBA_BANK_ACTIONS (ACCOUNT_ID,PERIOD_ID,UID,BANKAKODU,HESAPNO,MUSTERINO,SUBEKODU,TARIH,ISL_ID,DEKONTNO,KAYNAK,MIKTAR,BAKIYE,DOVIZTURU,ACIKLAMA,KARSIVKN,KARSIIBAN,ISLEMKODU,GUNCELLEMETARIHI,[ORDER],WDB_REC_DATE) VALUES (:ACCOUNT_ID,:PERIOD_ID,:UId,:BankaKodu,:HesapNo,:MusteriNo,:SubeKodu,:Tarih,:Isl_Id,:DekontNo,:Kaynak,:Miktar,:Bakiye,:DovizTuru,:Aciklama,:KarsiVKN,:KarsiIban,:IslemKodu,:GuncellemeTarihi,:Order,:WDB_REC_DATE)");
        queryObj.clearParams();
    }

    public query function GetBranchInfo(required numeric AccountId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn3#");
        queryObj.addParam(name="ACCOUNT_ID",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        result = queryObj.execute(sql="SELECT AB.BRANCH_ID FROM ACCOUNTS A INNER JOIN ACCOUNTS_BRANCH AB ON A.ACCOUNT_ID = AB.ACCOUNT_ID  WHERE A.ACCOUNT_ID = :ACCOUNT_ID AND A.ACCOUNT_STATUS = 1");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetAccountInfo(required numeric AccountId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn3#");
        queryObj.addParam(name="ACCOUNT_ID",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        result = queryObj.execute(sql="
                                    SELECT 
                                        A.ACCOUNT_NAME,
                                        A.ACCOUNT_BRANCH_ID,
                                        A.ACCOUNT_CURRENCY_ID,
                                        A.ACCOUNT_ACC_CODE,
                                        A.ACCOUNT_NO,
                                        A.BANK_CODE,
                                        A.BRANCH_CODE,
                                        BB.BANK_ID,
                                        BB.BANK_NAME
                                    FROM ACCOUNTS A 
                                    INNER JOIN BANK_BRANCH BB ON A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID 
                                        WHERE A.ACCOUNT_ID = :ACCOUNT_ID AND A.ACCOUNT_STATUS = 1");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetPeriodByDate(
        required numeric CompanyId,
        required date Date){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="OUR_COMPANY_ID",value="#arguments.CompanyId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="PERIOD_DATE",value="#arguments.Date#",cfsqltype="TIMESTAMP");
        result = queryObj.execute(sql="SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = :OUR_COMPANY_ID AND :PERIOD_DATE BETWEEN START_DATE AND FINISH_DATE");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public string function GetTransactionType(
        required string BankCode,
        required string TransactionCode,
        required string Target){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="BankCode",value="#arguments.BankCode#",cfsqltype="VARCHAR");
        queryObj.addParam(name="TransactionCode",value="#arguments.TransactionCode#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Target",value="#arguments.Target#",cfsqltype="VARCHAR");
        result = queryObj.execute(sql="SELECT TT.PROCESS_TYPE FROM WODIBA_BANK_TRANSACTION_TYPES TT WHERE TT.BANK_CODE = :BankCode AND (TT.TRANSACTION_CODE = :TransactionCode OR TT.TRANSACTION_CODE2 = :TransactionCode) AND IN_OUT = :Target");
        result = result.getResult();
        queryObj.clearParams();

        return result.PROCESS_TYPE;
    }

    public void function UpdateBankAction(
        required numeric    ActionId,
        required numeric    BankActionId,
        required numeric    DocumentId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="ActionId",value="#arguments.ActionId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="BankActionId",value="#arguments.BankActionId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="DocumentId",value="#arguments.DocumentId#",cfsqltype="NUMERIC");
        queryObj.execute(sql="UPDATE WODIBA_BANK_ACTIONS SET BANK_ACTION_ID = :BankActionId, DOCUMENT_ID = :DocumentId WHERE WDB_ACTION_ID = :ActionId");
        queryObj.clearParams();
    }

    public query function GetProcessType(
        required string BankCode,
        required string TransactionCode,
        required string InOut,
        numeric WDB_ACTION_ID = 0,
        string BANK_ACTION_ID = 0,
        string DOCUMENT_ID = 0){

        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        if ((len(arguments.BANK_ACTION_ID) and arguments.BANK_ACTION_ID neq 0) or (len(arguments.DOCUMENT_ID) and arguments.DOCUMENT_ID neq 0)) {
            queryObj.addParam(name="WDB_ACTION_ID",value="#arguments.WDB_ACTION_ID#",cfsqltype="NUMERIC");
            result = queryObj.execute(sql="SELECT SPC.PROCESS_TYPE, SPC.PROCESS_CAT, SPC.PROCESS_CAT_ID FROM WODIBA_BANK_ACTIONS AS WBA INNER JOIN #dsn2_alias#.BANK_ACTIONS AS BA ON WBA.BANK_ACTION_ID = BA.ACTION_ID INNER JOIN #dsn3_alias#.SETUP_PROCESS_CAT AS SPC ON SPC.PROCESS_CAT_ID = BA.PROCESS_CAT WHERE WBA.WDB_ACTION_ID = :WDB_ACTION_ID");
            result = result.getResult();
            queryObj.clearParams();
            return result;
        }
        else {
            queryObj.addParam(name="BankCode",value="#arguments.BankCode#",cfsqltype="NUMERIC");
            queryObj.addParam(name="TransactionCode",value="#arguments.TransactionCode#",cfsqltype="VARCHAR");
            queryObj.addParam(name="InOut",value="#arguments.InOut#",cfsqltype="VARCHAR");
            result = queryObj.execute(sql="SELECT wbtt.PROCESS_TYPE, SPC.PROCESS_CAT, SPC.PROCESS_CAT_ID FROM WODIBA_BANK_TRANSACTION_TYPES AS wbtt INNER JOIN #dsn3_alias#.SETUP_PROCESS_CAT AS spc ON  spc.PROCESS_TYPE = wbtt.PROCESS_TYPE WHERE wbtt.BANK_CODE = :BankCode AND (wbtt.TRANSACTION_CODE = :TransactionCode OR wbtt.TRANSACTION_CODE2 = :TransactionCode) AND wbtt.IN_OUT = :InOut");
            result = result.getResult();
            queryObj.clearParams();
            return result;    
        }
    }

    public query function GetRecordedBankAction(
        required string dsn2,
        required numeric ProcessType,
        required string PaperNumber,
        required numeric AccountId){
        queryObj = new Query();
        queryObj.setDatasource("#arguments.dsn2#");
        queryObj.addParam(name="ProcessType",value="#arguments.ProcessType#",cfsqltype="NUMERIC");
        queryObj.addParam(name="PaperNumber",value="#arguments.PaperNumber#",cfsqltype="VARCHAR");
        queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        result = queryObj.execute(sql="SELECT TOP 1 ACTION_ID, EXPENSE_ID FROM BANK_ACTIONS WHERE ACTION_TYPE_ID = :ProcessType AND PAPER_NO = :PaperNumber AND ISNULL(ACTION_FROM_ACCOUNT_ID,ACTION_TO_ACCOUNT_ID) = :AccountId ORDER BY RECORD_DATE DESC");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    remote string function GetTransactionTypesByAccountId(required numeric AccountId) returnformat="JSON" {

        dsn     = application.systemParam.systemParam().dsn;
        dsn3    = "#dsn#_#session.ep.company_id#";

        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        sql = "SELECT * FROM (SELECT
                    WBTT.TRANSACTION_CODE AS TRANSACTION_CODE
                FROM
                    #dsn#.WODIBA_BANK_TRANSACTION_TYPES AS WBTT
                    INNER JOIN SETUP_BANK_TYPES AS SBT ON SBT.BANK_CODE = WBTT.BANK_CODE
                    INNER JOIN #dsn3#.BANK_BRANCH AS BB ON BB.BANK_ID = SBT.BANK_ID
                    INNER JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
                WHERE
                    A.ACCOUNT_ID = :AccountId
                UNION ALL
                SELECT
                    WBTT.TRANSACTION_CODE2 AS TRANSACTION_CODE
                FROM
                    #dsn#.WODIBA_BANK_TRANSACTION_TYPES AS WBTT
                    INNER JOIN SETUP_BANK_TYPES AS SBT ON SBT.BANK_CODE = WBTT.BANK_CODE
                    INNER JOIN #dsn3#.BANK_BRANCH AS BB ON BB.BANK_ID = SBT.BANK_ID
                    INNER JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
                WHERE
                    A.ACCOUNT_ID = :AccountId
                    AND WBTT.TRANSACTION_CODE2 IS NOT NULL) SQL1
                GROUP BY
                    TRANSACTION_CODE
                ORDER BY
                    TRANSACTION_CODE";
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        codes   = arrayNew(1);
        for(code in result){
            transaction_code                   = structNew();
            transaction_code.TRANSACTIONCODE   = code.TRANSACTION_CODE;
            arrayAppend(codes,transaction_code);
        }

        transaction_codes = serializeJSON(codes);
        transaction_codes = reReplace(transaction_codes,"/","","ALL");
        writeOutput(transaction_codes);
    }

    public query function GetBankMoneyTypes() {

        dsn     = application.systemParam.systemParam().dsn;

        queryObj = new Query();
        queryObj.setDatasource("#dsn#");

        sql = "SELECT
            wba.DOVIZTURU
            FROM
                WODIBA_BANK_ACCOUNTS wba
            WHERE
                wba.OUR_COMPANY_ID = #session.ep.company_id# AND
                wba.BAKIYE IS NOT NULL AND
                wba.BAKIYE ! = 0
            GROUP BY wba.DOVIZTURU
            ORDER BY wba.DOVIZTURU";

        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    remote string function GetBankMoney() returnformat="JSON" {

        dsn     = application.systemParam.systemParam().dsn;
        dsn3    = "#dsn#_#session.ep.company_id#";

        queryObj = new Query();
        queryObj.setDatasource("#dsn#");

        sql = "SELECT wba.DOVIZTURU,wba.BAKIYE,a.ACCOUNT_NAME FROM  #dsn#.WODIBA_BANK_ACCOUNTS wba  
               LEFT JOIN #dsn3#.ACCOUNTS a ON a.ACCOUNT_ID=wba.ACCOUNT_ID WHERE wba.OUR_COMPANY_ID=#session.ep.company_id# AND wba.BAKIYE IS NOT NULL AND wba.BAKIYE !=0";

        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        moneys   = arrayNew(1);
        for(money in result){
            doviz_money             = structNew();
            doviz_money.DOVIZTURU   = money.DOVIZTURU;
            doviz_money.BAKIYE      = money.BAKIYE;
            doviz_money.ACCOUNT_NAME  = money.ACCOUNT_NAME;
            arrayAppend(moneys,doviz_money);
        }

        doviz_moneys = serializeJSON(moneys);
        doviz_moneys = reReplace(doviz_moneys,'/','','ALL');
        writeOutput(doviz_moneys);
    }

    remote string function GetWodibaBankActions() returnformat="JSON" {

        dsn     = application.systemParam.systemParam().dsn;
        dsn3    = '#dsn#_#session.ep.company_id#';

        queryObj = new Query();
        queryObj.setDatasource("#dsn#");

        sql = "SELECT TOP 10
            wba.ISLEMKODU,
            wba.BANKAKODU,
            wba.MIKTAR,
            wba.DOVIZTURU,
            CASE 
                WHEN wba.MIKTAR > 0 THEN 'IN'
                WHEN wba.MIKTAR < 0 THEN 'OUT'
            END AS IN_OUT,
            CASE wbtt.PROCESS_TYPE
            	WHEN 21 THEN 'Para Yatırma'
            	WHEN 22 THEN 'Para Çekme'
            	WHEN 23 THEN 'Virman'
            	WHEN 24 THEN 'Gelen Havale'
            	WHEN 25 THEN 'Giden Havale'
            	WHEN 120 THEN 'Harcama Fişi'
            	WHEN 121 THEN 'Gelir Fişi'
            	WHEN 243 THEN 'Kredi Kartı Hesaba Geçiş'
            	WHEN 244 THEN 'Kredi Kartı Borcu Ödeme'
            	WHEN 247 THEN 'Kredi Kartı Hesaba Geçiş İptal'
            	WHEN 248 THEN 'Kredi Kartı Borcu Ödeme İptal'
            	WHEN 291 THEN 'Kredi Ödemesi'
            	WHEN 292 THEN 'Kredi Tahsilatı'
            	WHEN 1043 THEN 'Çek Tahsilatı'
            	WHEN 1044 THEN 'Çek Ödeme'
            	WHEN 1051 THEN 'Senet Ödeme'
            	WHEN 1053 THEN 'Senet Tahsilatı'
            	WHEN 2501 THEN 'Çek/Senet Banka Ödeme'
            END AS PROCESS_TYPE
        FROM
            WODIBA_BANK_ACTIONS wba
            INNER JOIN WODIBA_BANK_TRANSACTION_TYPES AS wbtt ON  WBTT.BANK_CODE = wba.BANKAKODU AND
            wbtt.TRANSACTION_CODE = wba.ISLEMKODU AND
            wbtt.IN_OUT = CASE 
                            WHEN wba.MIKTAR > 0 THEN 'IN'
                            WHEN wba.MIKTAR < 0 THEN 'OUT'
                          END
        WHERE
            wba.PERIOD_ID = #session.ep.period_id#
        ORDER BY
            wba.TARIH DESC";

        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        operations   = arrayNew(1);
        for(operation in result){
            type             = structNew();
            type.ISLEMKODU   = operation.ISLEMKODU;
            type.BANKAKODU   = operation.BANKAKODU;
            type.MIKTAR      = operation.MIKTAR;
            type.DOVIZTURU   = operation.DOVIZTURU;
            type.IN_OUT      = operation.IN_OUT;
            type.PROCESS_TYPE= operation.PROCESS_TYPE;
            arrayAppend(operations,type);
        }

        type = serializeJSON(operations);
        type = reReplace(type,"/","","ALL");
        writeOutput(type);
    }

    remote string function GetInOut(required string InOut) returnformat="JSON" {

        dsn      = application.systemParam.systemParam().dsn;

        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        if(arguments.InOut eq "IN")
        {
            sql ="SELECT SUM(MIKTAR) AS MIKTAR,MONTH(TARIH) AS TARIH FROM #dsn#.WODIBA_BANK_ACTIONS WHERE MIKTAR > 0 AND PERIOD_ID=#session.ep.period_id# GROUP BY MONTH(TARIH) ORDER BY MONTH(TARIH) ASC ";
        }
        else if (arguments.InOut eq "OUT") {
            sql ="SELECT SUM(MIKTAR) AS MIKTAR,MONTH(TARIH) AS TARIH FROM #dsn#.WODIBA_BANK_ACTIONS WHERE MIKTAR < 0 AND PERIOD_ID=#session.ep.period_id# GROUP BY MONTH(TARIH) ORDER BY MONTH(TARIH) ASC";
        }

        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        giris   = arrayNew(1);
        for(girdiler in result){
            girdi             = structNew();
            girdi.MIKTAR   = girdiler.MIKTAR;
            girdi.TARIH   = girdiler.TARIH;
            arrayAppend(giris,girdi);
        }

        girdi = serializeJSON(giris);
        girdi = reReplace(girdi,'/','','ALL');
        writeOutput(girdi);

    }

    public query function GetWodibaBankTransactionDateType() {
        dsn     = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");

        result = queryObj.execute(
        sql="SELECT TOP 1 END_DATE FROM ( SELECT wbtt.REC_DATE AS END_DATE FROM #dsn#.WODIBA_BANK_TRANSACTION_TYPES AS wbtt
                                          UNION ALL
                                          SELECT wbtt.UPD_DATE AS END_DATE FROM #dsn#.WODIBA_BANK_TRANSACTION_TYPES AS wbtt
                                        ) 
            AS W1 WHERE END_DATE IS NOT NULL ORDER BY END_DATE DESC");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    remote string function GetWodibaBankTransactionTypeService(required date FromDate,required numeric GetAll) returnFormat="JSON" {

        dsn     = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");

        if(arguments.GetAll==1)
        {
            result = queryObj.execute(sql="SELECT * FROM WODIBA_BANK_TRANSACTION_TYPES AS wbtt");
        }
        else
        {
            result = queryObj.execute(sql="SELECT * FROM WODIBA_BANK_TRANSACTION_TYPES AS wbtt WHERE wbtt.REC_DATE >='#arguments.FromDate#' OR wbtt.UPD_DATE >='#arguments.FromDate#'");
        }
        result = result.getResult();
        queryObj.clearParams();

        banktransaction   = arrayNew(1);
        for(transactions in result){
            transaction             = structNew();
            transaction.TRANSACTION_UID   = transactions.TRANSACTION_UID;
            transaction.TRANSACTION_CODE   = transactions.TRANSACTION_CODE;
            transaction.TRANSACTION_CODE2   = transactions.TRANSACTION_CODE2;
            transaction.PROCESS_TYPE   = transactions.PROCESS_TYPE;
            transaction.DESCRIPTION_1   = transactions.DESCRIPTION_1;
            transaction.DESCRIPTION_2   = transactions.DESCRIPTION_2;
            transaction.IN_OUT   = transactions.IN_OUT;
            transaction.REC_USER   = transactions.REC_USER;
            transaction.REC_DATE   = transactions.REC_DATE;
            transaction.REC_IP   = transactions.REC_IP;
            transaction.UPD_USER   = transactions.UPD_USER;
            transaction.UPD_DATE   = transactions.UPD_DATE;
            transaction.UPD_IP   = transactions.UPD_IP;
            transaction.BANK_CODE   = transactions.BANK_CODE;
            arrayAppend(banktransaction,transaction);
        }

        banktransaction = serializeJSON(banktransaction);
        writeOutput(banktransaction);
    }

    public query function GetWodibaBankTransactionType(required integer Transaction_Uid) returnFormat="JSON" {

        dsn     = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="Transaction_Uid",value="#arguments.Transaction_Uid#",cfsqltype="INTEGER");
        
        result = queryObj.execute(sql="SELECT wbtt.TRANSACTION_UID FROM WODIBA_BANK_TRANSACTION_TYPES AS wbtt
        WHERE wbtt.TRANSACTION_UID = :Transaction_Uid");
        result = result.getResult();
        queryObj.clearParams();
         
        return result;
    }

    public void function AddWodibaBankTransaction(
        required numeric Transaction_Uid,
        required string Transaction_Code,
        required string Transaction_Code2,
        required numeric Process_Type,
        required string Description_1,
        required string Description_2,
        required string In_Out,
        required string Bank_Code
    ) returnFormat="JSON" {

        dsn     = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="Transaction_Uid",value="#arguments.Transaction_Uid#",cfsqltype="NUMERIC");
        queryObj.addParam(name="Transaction_Code",value="#arguments.Transaction_Code#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Transaction_Code2",value="#arguments.Transaction_Code2#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Process_Type",value="#arguments.Process_Type#",cfsqltype="NUMERIC");
        queryObj.addParam(name="Description_1",value="#arguments.Description_1#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Description_2",value="#arguments.Description_2#",cfsqltype="VARCHAR");
        queryObj.addParam(name="In_Out",value="#arguments.In_Out#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Bank_Code",value="#arguments.Bank_Code#",cfsqltype="VARCHAR");

        queryObj.execute(sql="INSERT INTO WODIBA_BANK_TRANSACTION_TYPES (TRANSACTION_UID,TRANSACTION_CODE,TRANSACTION_CODE2,PROCESS_TYPE,DESCRIPTION_1,DESCRIPTION_2,IN_OUT,REC_USER,REC_DATE,REC_IP,BANK_CODE)
        VALUES (:Transaction_Uid,:Transaction_Code,:Transaction_Code2,:Process_Type,:Description_1,:Description_2,:In_Out,1,#Now()#,'#CGI.REMOTE_ADDR#',:Bank_Code)");

        queryObj.clearParams();
    }

    public void function UpdateWodibaBankTransaction(
        required numeric Transaction_Uid,
        required numeric Process_Type,
        required string Description_1,
        required string Description_2,
        required string In_Out
    ) returnFormat="JSON" {

        dsn     = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="Transaction_Uid",value="#arguments.Transaction_Uid#",cfsqltype="NUMERIC");
        queryObj.addParam(name="Process_Type",value="#arguments.Process_Type#",cfsqltype="NUMERIC");
        queryObj.addParam(name="Description_1",value="#arguments.Description_1#",cfsqltype="VARCHAR");
        queryObj.addParam(name="Description_2",value="#arguments.Description_2#",cfsqltype="VARCHAR");
        queryObj.addParam(name="In_Out",value="#arguments.In_Out#",cfsqltype="VARCHAR");

        queryObj.execute(
            sql="UPDATE WODIBA_BANK_TRANSACTION_TYPES 
                 SET PROCESS_TYPE =:Process_Type,DESCRIPTION_1=:Description_1,
                 DESCRIPTION_2=:Description_2,IN_OUT=:In_Out,UPD_USER=1,UPD_DATE=#Now()#,UPD_IP='#CGI.REMOTE_ADDR#'
                 WHERE TRANSACTION_UID = :Transaction_Uid "
            );
        queryObj.clearParams();
    }

    public query function GetRuleSet(
        required numeric CompanyId,
        required numeric ProcessType,
        required date ProcessDate){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="CompanyId",value="#arguments.CompanyId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="ProcessType",value="#arguments.ProcessType#",cfsqltype="NUMERIC");
        queryObj.addParam(name="ProcessDate",value="#arguments.ProcessDate#",cfsqltype="TIMESTAMP");
        result = queryObj.execute(sql="SELECT * FROM WODIBA_RULE_SETS WHERE COMPANY_ID = :CompanyId AND PROCESS_TYPE = :ProcessType AND '#dateFormat(arguments.ProcessDate,'YYYY-mm-dd')#' >= PROCESS_START_DATE");
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetRuleSetRow(
        required numeric    AccountId,
        required string     TransactionCode,
        required date       ProcessDate,
        string  Target      = '',
        string  IBAN        = '',
        string  VKN         = '',
        numeric  WithDescription = 0){
        
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="TransactionCode",value="#arguments.TransactionCode#",cfsqltype="VARCHAR");
        queryObj.addParam(name="ProcessDate",value="#arguments.ProcessDate#",cfsqltype="TIMESTAMP");
        queryObj.addParam(name="Target",value="#arguments.Target#",cfsqltype="VARCHAR");
        queryObj.addParam(name="IBAN",value="#arguments.IBAN#",cfsqltype="VARCHAR");
        queryObj.addParam(name="VKN",value="#arguments.VKN#",cfsqltype="VARCHAR");

        sql="SELECT
                WR.*,
                W.IS_PROCESS_INVOICE_CLOSING,
                W.INVOICE_CLOSING_PAYMENT_TOLERANS_VALUE
            FROM
                WODIBA_RULE_SET_ROWS AS WR
                INNER JOIN WODIBA_RULE_SETS AS W ON WR.RULE_ID = W.RULE_ID
            WHERE
                TRY_PARSE('#dateFormat(arguments.ProcessDate,'YYYY-mm-dd')#' AS datetime) >= PROCESS_START_DATE AND
                ACCOUNT_ID = #arguments.AccountId# AND TRANSACTION_CODE = :TransactionCode AND
                STATUS = 1";

		if(arguments.WithDescription Eq 1){
			sql=sql & " AND LEN(WR.DESCRIPTION) > 0";
		}
		else {
			sql=sql & " AND LEN(WR.DESCRIPTION) = 0";
		}

        if(Len(arguments.Target)){
            sql=sql & " AND IN_OUT = :Target";
        }

        if(Len(arguments.IBAN)){
            sql=sql & " AND IBAN = :IBAN";
        }

        if(Len(arguments.VKN)){
            sql=sql & " AND VKN = :VKN";
        }

        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public numeric function AddRuleSetRow(
        required numeric    RuleId,
        required numeric    Status,
        required string     RuleName,
        required numeric    AccountId,
        required string     TransactionCode,
        required string     Target,
        required string     IBAN,
        required string     VKN,
        required string     Description,
        required string     RegEx,
        required string     RegExInput,
        required string     RegExOutput,
        required numeric    ProcessCat,
        required numeric    ExpenseCenter,
        required numeric    ExpenseItem,
        required numeric    Project,
        required numeric    ChCompanyId,
        required numeric    ChConsumerId,
        required numeric    ChEmployeeId,
        required numeric    AccTypeId,
        required numeric    PaymentType,
        required numeric    SpecialDefinition,
        required numeric    Asset,
        required numeric    Branch,
        required numeric    Department,
        required numeric    IsSalesZone,
        required string     SalesZone,
        required numeric    IsBranchFromSalesZone,
		required numeric    Tax,
        required numeric    TaxInclude){
        sql = "INSERT INTO
                    WODIBA_RULE_SET_ROWS
                (
                    RULE_ID,
                    STATUS,
                    RULE_SET_ROW_NAME,
                    ACCOUNT_ID,
                    TRANSACTION_CODE,
                    IN_OUT,
                    IBAN,
                    VKN,
                    DESCRIPTION,
                    REG_EX,
                    REG_EX_INPUT,
                    REG_EX_OUTPUT,
                    PROCESS_TYPE,
                    PROCESS_CAT_ID,
                    EXPENSE_CENTER_ID,
                    EXPENSE_ITEM_ID,
                    PROJECT_ID,
                    COMPANY_ID,
                    CONSUMER_ID,
                    EMPLOYEE_ID,
                    ACC_TYPE_ID,
                    PAYMENT_TYPE_ID,
                    SPECIAL_DEFINITION_ID,
                    ASSET_ID,
                    BRANCH_ID,
                    DEPARTMENT_ID,
                    COND_IS_SALES_ZONE,
                    COND_SALES_ZONE,
                    COND_IS_BRANCH_FROM_SALES_ZONE,
					TAX,
					TAX_INCLUDE,
                    REC_USER,
                    REC_DATE,
                    REC_IP
                )
                    VALUES
                (
                    #arguments.RuleId#,
                    #arguments.Status#,
                    N'#arguments.RuleName#',
                    #arguments.AccountId#,
                    N'#arguments.TransactionCode#',
                    N'#arguments.Target#',
                    N'#arguments.IBAN#',
                    N'#arguments.VKN#',
                    N'#arguments.Description#',
                    N'#arguments.RegEx#',
                    N'#arguments.RegExInput#',
                    N'#arguments.RegExOutput#',
                    #arguments.ProcessType#,
                    #arguments.ProcessCat#,
                    #arguments.ExpenseCenter#,
                    #arguments.ExpenseItem#,
                    #arguments.Project#,
                    #arguments.ChCompanyId#,
                    #arguments.ChConsumerId#,
                    #arguments.ChEmployeeId#,
                    #arguments.AccTypeId#,
                    #arguments.PaymentType#,
                    #arguments.SpecialDefinition#,
                    #arguments.Asset#,
                    #arguments.Branch#,
                    #arguments.Department#,
                    #arguments.IsSalesZone#,
                    '#arguments.SalesZone#',
                    #arguments.IsBranchFromSalesZone#,
                    #arguments.Tax#,
                    #arguments.TaxInclude#,
                    #session.ep.userid#,
                    #Now()#,
                    '#CGI.REMOTE_ADDR#'
                )";
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        result = queryObj.execute(sql=sql).getPrefix();
        queryObj.clearParams();

        return result.IDENTITYCOL;
    }

    public void function UpdateRuleSetRow(
        required numeric    RowId,
        required numeric    RuleId,
        required numeric    Status,
        required string     RuleName,
        required numeric    AccountId,
        required string     TransactionCode,
        required string     Target,
        required string     IBAN,
        required string     VKN,
        required string     Description,
        required string     RegEx,
        required string     RegExInput,
        required string     RegExOutput,
        required numeric    ProcessCat,
        required numeric    ExpenseCenter,
        required numeric    ExpenseItem,
        required numeric    Project,
        required numeric    ChCompanyId,
        required numeric    ChConsumerId,
        required numeric    ChEmployeeId,
        required numeric    AccTypeId,
        required numeric    PaymentType,
        required numeric    SpecialDefinition,
        required numeric    Asset,
        required numeric    Branch,
        required numeric    Department,
        required numeric    IsSalesZone,
        required string     SalesZone,
        required numeric    IsBranchFromSalesZone,
		required numeric    Tax,
        required numeric    TaxInclude){
        sql = "UPDATE
                    WODIBA_RULE_SET_ROWS
                SET
                    STATUS                  = #arguments.Status#,
                    RULE_SET_ROW_NAME       = N'#arguments.RuleName#',
                    ACCOUNT_ID              = #arguments.AccountId#,
                    TRANSACTION_CODE        = N'#arguments.TransactionCode#',
                    IN_OUT                  = N'#arguments.Target#',
                    IBAN                    = N'#arguments.IBAN#',
                    VKN                     = N'#arguments.VKN#',
                    DESCRIPTION             = N'#arguments.Description#',
                    REG_EX                  = N'#arguments.RegEx#',
                    REG_EX_INPUT            = N'#arguments.RegExInput#',
                    REG_EX_OUTPUT           = N'#arguments.RegExOutput#',
                    PROCESS_TYPE            = #arguments.ProcessType#,
                    PROCESS_CAT_ID          = #arguments.ProcessCat#,
                    EXPENSE_CENTER_ID       = #arguments.ExpenseCenter#,
                    EXPENSE_ITEM_ID         = #arguments.ExpenseItem#,
                    PROJECT_ID              = #arguments.Project#,
                    COMPANY_ID              = #arguments.ChCompanyId#,
                    CONSUMER_ID             = #arguments.ChConsumerId#,
                    EMPLOYEE_ID             = #arguments.ChEmployeeId#,
                    ACC_TYPE_ID             = #arguments.AccTypeId#,
                    PAYMENT_TYPE_ID         = #arguments.PaymentType#,
                    SPECIAL_DEFINITION_ID   = #arguments.SpecialDefinition#,
                    ASSET_ID                = #arguments.Asset#,
                    BRANCH_ID               = #arguments.Branch#,
                    DEPARTMENT_ID           = #arguments.Department#,
                    COND_IS_SALES_ZONE      = #arguments.IsSalesZone#,
                    COND_SALES_ZONE         = '#arguments.SalesZone#',
                    COND_IS_BRANCH_FROM_SALES_ZONE = #arguments.IsBranchFromSalesZone#,
                    TAX						= #arguments.Tax#,
                    TAX_INCLUDE				= #arguments.TaxInclude#,
                    UPD_USER                = #session.ep.userid#,
                    UPD_DATE                = #Now()#,
                    UPD_IP                  = '#CGI.REMOTE_ADDR#'
                WHERE
                    RULE_SET_ROW_ID = #arguments.RowId#";

        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.execute(sql=sql);
        queryObj.clearParams();
    }

    public void function DelRuleSetRow(
        required numeric RuleId,
        required numeric RowId){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="RuleId",value="#arguments.RuleId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="RowId",value="#arguments.RowId#",cfsqltype="NUMERIC");
        queryObj.execute(sql="DELETE FROM WODIBA_RULE_SET_ROWS WHERE RULE_ID = :RuleId AND RULE_SET_ROW_ID = :RowId");
        queryObj.clearParams();
    }

    public query function GetTransferAction(//Virman işleminin karşı işlemini tespit etmek için kullanılır
        required numeric ActionId,
        required numeric BankaKodu,
        required numeric AccountId,
        required string Tarih,
        required string IslemKodu,
        required numeric PeriodId,
        required numeric Miktar,
		required string DovizTuru,
        required string KarsiVKN,
        required string Dsn3,
        numeric daterange){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="ActionId",value="#arguments.ActionId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="BankaKodu",value="#arguments.BankaKodu#",cfsqltype="NUMERIC");
        queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="Tarih",value="#arguments.Tarih#",cfsqltype="VARCHAR");
        queryObj.addParam(name="IslemKodu",value="#arguments.IslemKodu#",cfsqltype="VARCHAR");
        queryObj.addParam(name="PeriodId",value="#arguments.PeriodId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="Miktar",value="#arguments.Miktar#",cfsqltype="DOUBLE");
        queryObj.addParam(name="DovizTuru",value="#arguments.DovizTuru#",cfsqltype="VARCHAR");
        queryObj.addParam(name="KarsiVKN",value="#arguments.KarsiVKN#",cfsqltype="VARCHAR");
        queryObj.addParam(name="daterange",value="#arguments.daterange#",cfsqltype="NUMERIC");
        sql="
            SELECT
                TYPE,
                WDB_ACTION_ID,
                ACCOUNT_ID,
                TARIH,
				DEKONTNO,
                MIKTAR,
				ACIKLAMA
            FROM
            (SELECT
                1 AS TYPE,-- Aynı bankadaki aynı para birimine sahip hesaplar arası yapılan virman işlemleri için
                WDB_ACTION_ID,
                ACCOUNT_ID,
                TARIH,
				DEKONTNO,
                MIKTAR,
				ACIKLAMA
            FROM
                WODIBA_BANK_ACTIONS
            WHERE
                WDB_ACTION_ID <> :ActionId AND
                BANKAKODU = :BankaKodu AND
                ACCOUNT_ID <> :AccountId AND
                TARIH = :Tarih AND
                ISLEMKODU = :IslemKodu AND
                PERIOD_ID= :PeriodId AND
				MIKTAR = :Miktar AND
				DOVIZTURU = :DovizTuru AND
                BANK_ACTION_ID IS NULL AND
                DOCUMENT_ID IS NULL
            UNION ALL
			SELECT
                2 AS TYPE,-- Aynı bankadaki hesaplar arası yapılan döviz alım satım işlemleri için
                WDB_ACTION_ID,
                ACCOUNT_ID,
                TARIH,
				DEKONTNO,
                MIKTAR,
				ACIKLAMA
            FROM
                WODIBA_BANK_ACTIONS
            WHERE
                WDB_ACTION_ID <> :ActionId AND
                BANKAKODU = :BankaKodu AND
                ACCOUNT_ID <> :AccountId AND
                TARIH = :Tarih AND
                ISLEMKODU = :IslemKodu AND
                PERIOD_ID= :PeriodId AND
				MIKTAR > 0 AND
				DOVIZTURU <> :DovizTuru AND
                BANK_ACTION_ID IS NULL AND
                DOCUMENT_ID IS NULL
            UNION ALL
			SELECT
                3 AS TYPE,-- İş bankası hesapları arası farklı işlem kodlarına sahip döviz alım satım işlemleri için
                WDB_ACTION_ID,
                ACCOUNT_ID,
                TARIH,
				DEKONTNO,
                MIKTAR,
				ACIKLAMA
            FROM
                WODIBA_BANK_ACTIONS
            WHERE
                WDB_ACTION_ID <> :ActionId AND
                BANKAKODU = :BankaKodu AND
                ACCOUNT_ID <> :AccountId AND
                TARIH = :Tarih AND
                ISLEMKODU <> :IslemKodu AND
                PERIOD_ID= :PeriodId AND
				MIKTAR > 0 AND
				DOVIZTURU <> :DovizTuru AND
				ACIKLAMA LIKE '%İNTERNETTEN DÖVİZ SATIŞ%' AND
                BANK_ACTION_ID IS NULL AND
                DOCUMENT_ID IS NULL
            UNION ALL
            SELECT
                4 AS TYPE,-- Farklı bankalar arası aynı para birimi ve tutardaki virman işlemleri için
				WDB_ACTION_ID,
                ACCOUNT_ID,
                TARIH,
				DEKONTNO,
                MIKTAR,
				ACIKLAMA
            FROM
                WODIBA_BANK_ACTIONS
            WHERE
                WDB_ACTION_ID <> :ActionId AND
                BANKAKODU <> :BankaKodu AND
                ACCOUNT_ID <> :AccountId AND
                PERIOD_ID= :PeriodId AND
                MIKTAR = :Miktar AND
				DOVIZTURU = :DovizTuru AND
                TARIH <= DATEADD(day, :daterange, :Tarih) AND
                TARIH >= :Tarih AND
                KARSIIBAN = (SELECT ACCOUNT_OWNER_CUSTOMER_NO FROM #arguments.Dsn3#.ACCOUNTS WHERE ACCOUNT_ID =:AccountId) AND
                BANK_ACTION_ID IS NULL AND
                DOCUMENT_ID IS NULL
            UNION ALL
            SELECT
                5 AS TYPE,-- Aynı banka hesabında aynı işlem kodu, para birimi ve tutarda gerçekleşen vadeli mevduat işlemleri için, 
				WDB_ACTION_ID,
                ACCOUNT_ID,
                TARIH,
				DEKONTNO,
                MIKTAR,
				ACIKLAMA
            FROM
                WODIBA_BANK_ACTIONS
            WHERE
                WDB_ACTION_ID <> :ActionId AND
                BANKAKODU = :BankaKodu AND
                ACCOUNT_ID = :AccountId AND
                PERIOD_ID= :PeriodId AND
                MIKTAR = :Miktar AND
				DOVIZTURU = :DovizTuru AND
                TARIH <= DATEADD(day, :daterange, :Tarih) AND
                TARIH >= :Tarih AND
                ISLEMKODU = :IslemKodu AND
                BANK_ACTION_ID IS NULL AND
                DOCUMENT_ID IS NULL
			UNION ALL
            SELECT
                5 AS TYPE,-- Garanti bankası farklı işlem kodu, aynı para birimi ve tutarda gerçekleşen vadeli mevduat işlemleri için, 
				WDB_ACTION_ID,
                ACCOUNT_ID,
                TARIH,
				DEKONTNO,
                MIKTAR,
				ACIKLAMA
            FROM
                WODIBA_BANK_ACTIONS
            WHERE
                WDB_ACTION_ID <> :ActionId AND
                BANKAKODU = 62 AND
                ACCOUNT_ID = :AccountId AND
                PERIOD_ID= :PeriodId AND
                MIKTAR = :Miktar AND
				DOVIZTURU = :DovizTuru AND
                TARIH <= DATEADD(day, :daterange, :Tarih) AND
                TARIH >= :Tarih AND
                BANK_ACTION_ID IS NULL AND
                DOCUMENT_ID IS NULL) AS T1 ORDER BY TARIH";
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetLoggerInfo(
        required numeric ActionId,
        required string LogType){
        dsn      = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="ActionId",value="#arguments.ActionId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="LogType",value="#arguments.LogType#",cfsqltype="VARCHAR");
        sql="SELECT * FROM WODIBA_LOGS WHERE WDB_ACTION_ID = :ActionId AND LOG_TYPE = :LogType";
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public query function GetLoggerInfo2(
        required numeric ActionId){
        dsn      = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="ActionId",value="#arguments.ActionId#",cfsqltype="NUMERIC");
        sql="SELECT * FROM WODIBA_LOGS WHERE WDB_ACTION_ID = :ActionId ORDER BY REC_DATE DESC";
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    public void function WodibaLogger(
        required string message,
        required string extraInfo,
        required string LogType,
        required integer IsBugLog,
        required integer ActionId,
        required integer rec_user){
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="message",value="#arguments.message#",cfsqltype="VARCHAR");
        queryObj.addParam(name="extraInfo",value="#arguments.extraInfo#",cfsqltype="VARCHAR");
        queryObj.addParam(name="LogType",value="#arguments.LogType#",cfsqltype="VARCHAR");
        queryObj.addParam(name="IsBugLog",value="#arguments.IsBugLog#",cfsqltype="NUMERIC");
        queryObj.addParam(name="ActionId",value="#arguments.ActionId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="rec_user",value="#arguments.rec_user#",cfsqltype="NUMERIC");
        sql="
            INSERT INTO 
                WODIBA_LOGS
                (
                    MESSAGE,
                    DETAILS,
                    LOG_TYPE,
                    IS_BUGLOG,
                    WDB_ACTION_ID,
                    REC_DATE,
                    REC_IP,
                    REC_USER
                )
            VALUES
                (
                    :message,
                    :extraInfo,
                    :LogType,
                    :IsBugLog,
                    :ActionId,
                    #Now()#,
                    '#CGI.REMOTE_ADDR#',
                    :rec_user

                )"
        queryObj.execute(sql=sql);
        queryObj.clearParams();
                if(isDefined("application.bugLog") and arguments.IsBugLog eq 1){
                    application.bugLog.notifyService(
                        message=arguments.message,
                        extraInfo=arguments.extraInfo,
                        severityCode="WARN",
                        AppName="WODIBA");
                } 
    }

    remote string function getBankAcc(
        required numeric param_1,
        required string param_2) returnformat="JSON" {
        dsn      = application.systemParam.systemParam().dsn;
        dsn3     = "#dsn#_#session.ep.company_id#";
        queryObj = new Query();
        queryObj.setDatasource(dsn3);
        queryObj.addParam(name="param_1",value="#arguments.param_1#",cfsqltype="NUMERIC");
        queryObj.addParam(name="param_2",value="#arguments.param_2#",cfsqltype="VARCHAR");
        sql="
            SELECT  
                A.ACCOUNT_NAME,
                A.ACCOUNT_CURRENCY_ID,
                A.ACCOUNT_ID 
            FROM ACCOUNTS AS A 
            LEFT JOIN BANK_BRANCH AS BB ON BB.BANK_BRANCH_ID = A.ACCOUNT_BRANCH_ID 
            LEFT JOIN #dsn#.SETUP_BANK_TYPES AS SBT ON SBT.BANK_ID = BB.BANK_ID 
            WHERE SBT.BANK_ID = :param_1 AND A.ACCOUNT_CURRENCY_ID =:param_2";
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        result = serializeJSON(result);
        queryObj.clearParams();
        
        writeOutput(replace(result,"//","","all"));
    }

    //taslak olarak kayıt edildi, değiştirilebilir
    public query function GetCreditCardBankPayment(
		required string dsn2,
		required numeric AccountId,
        required numeric Miktar,
        required date ProcessDate){
        
        queryObj = new Query();
        queryObj.setDatasource("#arguments.dsn2#");
		queryObj.addParam(name="AccountId",value="#arguments.AccountId#",cfsqltype="NUMERIC");
		queryObj.addParam(name="Miktar",value="#arguments.Miktar#",cfsqltype="NUMERIC");
        queryObj.addParam(name="TransactionCode",value="#arguments.TransactionCode#",cfsqltype="VARCHAR");
        sql="SELECT
                CCBPR.CREDITCARD_PAYMENT_ID,
                CCBP.PAYMENT_TYPE_ID
            FROM
                CREDIT_CARD_BANK_PAYMENTS AS CCBP
                INNER JOIN CREDIT_CARD_BANK_PAYMENTS_ROWS AS CCBPR ON  CCBPR.CREDITCARD_PAYMENT_ID = CCBP.CREDITCARD_PAYMENT_ID
        	WHERE
				CCBP.ACTION_TO_ACCOUNT_ID = 36 AND
				CCBP.ACTION_TYPE_ID IN (241,2410) AND
				CCBP.SALES_CREDIT = 86882 AND
				CCBPR.BANK_ACTION_ID IS NULL AND
				CCBPR.BANK_ACTION_PERIOD_ID IS NULL";
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

    /**
        * todo:İlgili fatura listesi
        * ? bank_action.ACTION_FROM_COMPANY_ID=invoice.COMPANY_ID
        * todo :(** COMPANY_ID      = #companyId# AND,CONSUMER_ID     = #consumerId# AND) eklenecek.. todo: DEBT_AMOUNT_VALUE,CLAIM_AMOUNT_VALUE (INSERT CARI_CLOSED)
    */
    public query function GetInvoice(
		required string dsn2,
		required string invoiceNumber,
        required numeric companyId,
        required numeric consumerId,
        required boolean purchaseSales,
        required numeric expenseCostType){

        queryObj = new Query();
        queryObj.setDatasource("#arguments.dsn2#");
        queryObj.addParam(name="invoiceNumber",value="#arguments.invoiceNumber#",cfsqltype="VARCHAR");
        queryObj.addParam(name="companyId",value="#arguments.companyId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="consumerId",value="#arguments.consumerId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="purchaseSales",value="#arguments.purchaseSales#",cfsqltype="BIT");
        queryObj.addParam(name="expenseCostType",value="#arguments.expenseCostType#",cfsqltype="BIT");
        sql="SELECT
                COMPANY_ID,
                INVOICE_ID,
                OTHER_MONEY,
                INVOICE_CAT,
                NETTOTAL,
				OTHER_MONEY_VALUE
            FROM
				INVOICE
            WHERE
				INVOICE_NUMBER  = '#invoiceNumber#' AND
                PURCHASE_SALES  = #purchaseSales#";
        if (arguments.companyId Gt 0) {
            sql=sql & ' AND COMPANY_ID=:companyId';
        }
        if (arguments.consumerId Gt 0) {
            sql=sql & 'AND CONSUMER_ID=:consumerId';
        }
		if (Not find('-',invoiceNumber) And Len(invoiceNumber) Eq 16) {
			invoiceNumber = left(invoiceNumber,3) & '-' & right(invoiceNumber,13);
		}
        sql=sql & " UNION
        	SELECT
				CH_COMPANY_ID AS COMPANY_ID,
				EXPENSE_ID,
				OTHER_MONEY,
				EXPENSE_COST_TYPE,
				TOTAL_AMOUNT_KDVLI,
				OTHER_MONEY_NET_TOTAL
          	FROM
			  	EXPENSE_ITEM_PLANS
         	WHERE
			 	PAPER_NO='#invoiceNumber#' AND
               	EXPENSE_COST_TYPE  = #expenseCostType#";
		if (arguments.companyId Gt 0) {
            sql=sql & ' AND CH_COMPANY_ID=:companyId';
        }
        if (arguments.consumerId Gt 0) {
            sql=sql & 'AND CH_CONSUMER_ID=:consumerId';
        }

        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();
        return result;
    }

	public query function GetRuleSetRowParam(required numeric RuleSetRowId, required string ParamName){
        dsn      = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="RuleSetRowId",value="#arguments.RuleSetRowId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="ParamName",value="#arguments.ParamName#",cfsqltype="VARCHAR");
        sql="SELECT PARAM_VALUE FROM WODIBA_RULE_SET_ROW_PARAMS WHERE RULE_SET_ROW_ID = :RuleSetRowId AND PARAM_NAME = :ParamName";
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        return result;
    }

	public void function AddRuleSetRowParam(required numeric RuleSetRowId, required string ParamName, required string ParamValue){
        dsn      = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="RuleSetRowId",value="#arguments.RuleSetRowId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="ParamName",value="#arguments.ParamName#",cfsqltype="VARCHAR");
        queryObj.addParam(name="ParamValue",value="#arguments.ParamValue#",cfsqltype="VARCHAR");
        sql="DELETE WODIBA_RULE_SET_ROW_PARAMS WHERE RULE_SET_ROW_ID = :RuleSetRowId AND PARAM_NAME = :ParamName";
		if(Len(arguments.ParamValue)){
			sql= sql & " INSERT INTO WODIBA_RULE_SET_ROW_PARAMS (RULE_SET_ROW_ID, PARAM_NAME, PARAM_VALUE) VALUES (:RuleSetRowId, :ParamName, :ParamValue)";
		}
        queryObj.execute(sql=sql);
        queryObj.clearParams();
    }

	public void function DelRuleSetRowParam(required numeric RuleSetRowId, required string ParamName){
        dsn      = application.systemParam.systemParam().dsn;
        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        queryObj.addParam(name="RuleSetRowId",value="#arguments.RuleSetRowId#",cfsqltype="NUMERIC");
        queryObj.addParam(name="ParamName",value="#arguments.ParamName#",cfsqltype="VARCHAR");
        sql="DELETE WODIBA_RULE_SET_ROW_PARAMS WHERE RULE_SET_ROW_ID = :RuleSetRowId AND PARAM_NAME = :ParamName";
        queryObj.execute(sql=sql);
        queryObj.clearParams();
    }
}