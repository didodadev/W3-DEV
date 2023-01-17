<!-- Description : Wodiba kural setleri tablosuna banka işlemi açıklama alanında yer alan fatura numarasına göre cari eşleme için alan eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WODIBA_RULE_SETS' AND COLUMN_NAME = 'MATCH_COMPANY_BY_INVOICE_NUMBER')
    BEGIN
        ALTER TABLE WODIBA_RULE_SETS ADD MATCH_COMPANY_BY_INVOICE_NUMBER bit NULL
        ALTER TABLE WODIBA_RULE_SETS ADD CONSTRAINT DF_WODIBA_RULE_SETS_MATCH_COMPANY_BY_INVOICE_NUMBER DEFAULT 0 FOR MATCH_COMPANY_BY_INVOICE_NUMBER
    END;
</querytag>