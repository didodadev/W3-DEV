<!--Description : Stok işlemleri sayfası için süreç eklendi ve gerekli tablolara süreç alanı eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Period-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'STOCK_EXCHANGE' AND COLUMN_NAME = 'PROCESS_STAGE')
        BEGIN
            ALTER TABLE STOCK_EXCHANGE ADD 
            PROCESS_STAGE int NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'STOCK_FIS' AND COLUMN_NAME = 'PROCESS_STAGE')
        BEGIN
            ALTER TABLE STOCK_FIS ADD 
            PROCESS_STAGE int NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'SHIP' AND COLUMN_NAME = 'PROCESS_STAGE')
        BEGIN
            ALTER TABLE SHIP ADD 
            PROCESS_STAGE int NULL
        END
</querytag>