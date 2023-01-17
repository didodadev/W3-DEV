<!-- Description : Wodiba WBO
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.wodiba'
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'wodiba.setup_bank_accounts'
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'wodiba.setup_rule_sets'
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.emptypopup_wodiba_list_bank_balances'
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.emptypopup_wodiba_bank_account_summary'
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.wodiba_bank_details'
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.emptypopup_wodiba_api_hesaphareketleri'
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.emptypopup_wodiba_api_hesaplar'
    
    UPDATE WRK_OBJECTS SET [HEAD] = 'WoDiBa Banka Hesap Tanımları', DICTIONARY_ID = 59358 WHERE FULL_FUSEACTION = 'bank.popup_wodiba_setup_bank_account'
</querytag>