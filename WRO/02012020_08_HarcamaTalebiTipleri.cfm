<!-- Description : harcama taleplerine tip eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: period-->
<querytag>   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'EXPENSE_TYPE')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD
        EXPENSE_TYPE int NULL
    END;
</querytag>