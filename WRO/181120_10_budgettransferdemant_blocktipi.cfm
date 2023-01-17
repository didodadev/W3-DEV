<!-- Description : BUDGET_TRANSFER_DEMAND_ROWS tablosuna blok tipi eklendi
Developer: İlker Altındal
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'BLOCK_TYPE')
    BEGIN
        ALTER TABLE BUDGET_TRANSFER_DEMAND_ROWS ADD BLOCK_TYPE bit DEFAULT 0         
    END;
</querytag>