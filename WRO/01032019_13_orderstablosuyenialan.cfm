<!-- Description : Orders tablosuna postcode ve email alanları eklendi
Developer: İlker Altındal
Company : Workcube
Destination: Company-->
<querytag>
   
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'ORDERS' AND COLUMN_NAME = 'POSTCODE')
        BEGIN
        ALTER TABLE ORDERS ADD 
        POSTCODE INT NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'ORDERS' AND COLUMN_NAME = 'EMAIL')
        BEGIN
        ALTER TABLE ORDERS ADD 
        EMAIL nvarchar(50) NULL
        END;
</querytag>