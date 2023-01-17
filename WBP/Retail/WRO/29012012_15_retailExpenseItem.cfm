<!-- Description : Retail [EXPENSE_ITEMS] Alanlar
Developer: Gülbahar Erol
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EXPENSE_ITEMS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME='STOCK_ID')
    BEGIN
        ALTER TABLE EXPENSE_ITEMS ADD 
        [STOCK_ID] [int] NULL
    END;
</querytag>
