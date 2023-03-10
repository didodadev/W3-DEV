<!-- Description : EXPENSE_ITEMS_ROWS tablosuna IS_EXPENSING_OIV VE IS_EXPENSING_OIV alanları eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEMS_ROWS' AND COLUMN_NAME = 'IS_EXPENSING_OIV' )
    BEGIN
        ALTER TABLE EXPENSE_ITEMS_ROWS ADD IS_EXPENSING_OIV BIT NULL DEFAULT 0
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEMS_ROWS' AND COLUMN_NAME = 'IS_EXPENSING_OTV' )
    BEGIN
        ALTER TABLE EXPENSE_ITEMS_ROWS ADD IS_EXPENSING_OTV BIT NULL DEFAULT 0
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEMS_ROWS' AND COLUMN_NAME = 'PROCESS_CAT' )
    BEGIN
        ALTER TABLE EXPENSE_ITEMS_ROWS ADD PROCESS_CAT INT NULL
    END
</querytag>