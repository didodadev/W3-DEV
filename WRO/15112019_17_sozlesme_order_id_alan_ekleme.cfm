<!-- Description : Sözleşmeler tablosuna sipariş ilişkisini tutabilmek için ORDER_ID alanı eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'RELATED_CONTRACT' AND COLUMN_NAME = 'ORDER_ID')
    BEGIN
        ALTER TABLE RELATED_CONTRACT ADD ORDER_ID [nvarchar](max) NULL
    END;
</querytag>