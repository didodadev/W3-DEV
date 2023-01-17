<!-- Description : Kalite Kontrol Kolonu
Developer: Fatih Kara
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDERS' AND COLUMN_NAME = 'STOCKS_JSON')
    BEGIN
        ALTER TABLE PRODUCTION_ORDERS ADD STOCKS_JSON nvarchar(4000) NULL
    END;
</querytag>