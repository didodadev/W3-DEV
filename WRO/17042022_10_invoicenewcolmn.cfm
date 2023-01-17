<!-- Description : Fatura ödeme kurulus alanı eklendi
Developer: İlker Altındal
Company : Workcube
Destination: Period -->
<querytag>  
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='INVOICE' AND COLUMN_NAME='PAYMENT_COMPANY_ID')
    BEGIN
        ALTER TABLE INVOICE ADD PAYMENT_COMPANY_ID int;
    END;
</querytag>