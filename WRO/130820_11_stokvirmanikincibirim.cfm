<!-- Description : Stok Virmanda ikinci miktar için alan oluşturuldu
Developer: İlker Altındal
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'STOCK_EXCHANGE' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'AMOUNT2')
    BEGIN
            ALTER TABLE STOCK_EXCHANGE ADD AMOUNT2 float
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'STOCK_EXCHANGE' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'EXIT_AMOUNT2')
    BEGIN
            ALTER TABLE STOCK_EXCHANGE ADD EXIT_AMOUNT2 float
    END;
</querytag>