<!-- Description : EXPENSE_ITEM_PLANS tablosuna EXPENSE_DATE_TIME kolonu eklenmesi
Developer: Melek KOCABEY
Company : Workcube
Destination: period-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLANS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'EXPENSE_DATE_TIME')
    BEGIN
    ALTER TABLE EXPENSE_ITEM_PLANS ADD EXPENSE_DATE_TIME datetime
    END;
</querytag>