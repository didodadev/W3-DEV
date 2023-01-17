<!-- Description :  SUBSCRIPTION_CONTRACT tablosuna yeni alan eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SUBSCRIPTION_CONTRACT' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='PRODUCT_KEY')
    BEGIN
        ALTER TABLE SUBSCRIPTION_CONTRACT
        ADD PRODUCT_KEY nvarchar(50) NULL
    END;
</querytag>