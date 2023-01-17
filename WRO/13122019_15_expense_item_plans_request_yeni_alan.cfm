<!-- Description : EXPENSE_ITEM_PLAN_REQUESTS tablosuna MONEY alanı eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'MONEY')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD
        MONEY nvarchar(50) NULL
    END;
</querytag>