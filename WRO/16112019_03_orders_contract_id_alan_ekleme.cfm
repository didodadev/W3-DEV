<!-- Description : Siparişler tablosuna sözleşme ilişkisini tutabilmek için CONTRACT_ID alanı eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'ORDERS' AND COLUMN_NAME = 'CONTRACT_ID')
    BEGIN
        ALTER TABLE ORDERS ADD CONTRACT_ID int NULL
    END;
</querytag>