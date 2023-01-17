<!-- Description : Sabit Kıymet alıştan KK ile ödeme yapıldığında, KK ödeme liste sayfasında ilgili sayfaya yönlenebilmesi için tabloda kolon eklendi.
Developer: İlker Altındal
Company : Workcube
Destination: company-->
<querytag>   
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CREDIT_CARD_BANK_EXPENSE' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'INVOICE_ID')
        BEGIN
                ALTER TABLE CREDIT_CARD_BANK_EXPENSE ADD INVOICE_ID INT
        END;
</querytag>