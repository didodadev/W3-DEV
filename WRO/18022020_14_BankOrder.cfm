<!-- Description : Giden Banka Talimatı işlem tipi güncelleme
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
    UPDATE BANK_ORDERS set BANK_ORDER_TYPE = 260 WHERE BANK_ORDER_TYPE = 250
    UPDATE ACCOUNT_CARD SET ACTION_TYPE = 260 WHERE ACTION_TYPE = 250 AND ACTION_CAT_ID IN (SELECT PROCESS_CAT_ID FROM @_dsn_company_@.SETUP_PROCESS_CAT  WHERE PROCESS_TYPE = 250)
    UPDATE CARI_ROWS SET ACTION_TYPE_ID = 260 WHERE ACTION_TABLE = 'BANK_ORDERS'
    UPDATE @_dsn_company_@.SETUP_PROCESS_CAT SET PROCESS_TYPE = 260 where PROCESS_TYPE = 250
</querytag>