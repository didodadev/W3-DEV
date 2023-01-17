<!-- Description : siparişlere PROCESS_CAT alanı açıldı
Developer: İlker Altındal
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'ORDERS' AND COLUMN_NAME = 'PROCESS_CAT' )
    BEGIN
        ALTER TABLE ORDERS ADD PROCESS_CAT INT NULL 
    END
</querytag>