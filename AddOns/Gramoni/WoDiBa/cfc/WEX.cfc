/*
    File: WEX.cfc
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 28.10.2019
    Description:
        WEX entegrasyonu için kullanılan sınıftır
    History:
        
    To Do:
        
*/

component {
    remote string function GetTransactionCount() returnformat="JSON" {
        /*
            WEX tarafından işlem adetlerinin alınması için kullanılır
            toplam banka işlem adedi ve Wodiba entegrasyon başlangıç tarihini döndürür
            Mahmut Çifçi 28.10.2019 21:55
        */
        dsn     = application.systemParam.systemParam().dsn;

        queryObj = new Query();
        queryObj.setDatasource("#dsn#");
        sql = "SELECT Count(WDB_ACTION_ID) AS ACTION_COUNT FROM WODIBA_BANK_ACTIONS";
        result = queryObj.execute(sql=sql);
        result = result.getResult();
        queryObj.clearParams();

        queryObj1 = new Query();
        queryObj1.setDatasource("#dsn#");
        sql1 = "SELECT WDB_START_DATE FROM WODIBA_API_DEFINITIONS";
        result1 = queryObj1.execute(sql=sql1);
        result1 = result1.getResult();
        queryObj1.clearParams();

        start_date  = dateFormat(result1.WDB_START_DATE,"yyyy-mm-dd") & " " & timeFormat(result1.WDB_START_DATE,"HH:mm:ss") & ".000";

        bank_actions                = structNew('ordered');
        bank_actions.action_count   = result.ACTION_COUNT;
        bank_actions.start_date     = start_date;
        bank_actions                = serializeJSON(bank_actions);
        bank_actions                = reReplace(bank_actions,"/","","ALL");
        return bank_actions;
    }
}