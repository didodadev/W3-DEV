<!-- Description : EXPENSE_ITEM_PLAN_REQUESTS TABLOSUNA IS_PAYMENT ALANI EKLENDI
Developer: Botan Kaygan
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'IS_PAYMENT')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD
        IS_PAYMENT bit NULL;
    END;
</querytag>