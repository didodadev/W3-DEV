<!-- Description : Masraf fişi tablosuna IS_INVENTORY_ASSET_VALUATION ,INVENTORY_ID alanları eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEMS_ROWS' AND COLUMN_NAME = 'IS_INVENTORY_ASSET_VALUATION ')
        BEGIN
        ALTER TABLE EXPENSE_ITEMS_ROWS ADD IS_INVENTORY_ASSET_VALUATION  bit NULL DEFAULT 0
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEMS_ROWS' AND COLUMN_NAME = 'INVENTORY_ID ')
    BEGIN
        ALTER TABLE EXPENSE_ITEMS_ROWS ADD INVENTORY_ID int NULL
    END;
</querytag>