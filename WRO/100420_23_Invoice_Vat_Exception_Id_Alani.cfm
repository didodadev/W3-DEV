<!-- Description : Invoice Tablosuna Vat Exception Alanı Açıldı
Developer: Emine Yılmaz
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE' AND COLUMN_NAME = 'VAT_EXCEPTION_ID' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        ALTER TABLE INVOICE ADD
        VAT_EXCEPTION_ID int NULL
    END;
   
</querytag>