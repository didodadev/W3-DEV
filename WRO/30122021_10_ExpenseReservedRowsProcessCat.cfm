<!-- Description : EXPENSE_RESERVED_ROWS tablosuna PROCESS_CAT alanı eklendi.
Developer: Fatih Kara
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_RESERVED_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PROCESS_CAT')
    BEGIN
        ALTER TABLE EXPENSE_RESERVED_ROWS ADD
        PROCESS_CAT INT NULL;
    END;
</querytag>