<!-- Description : EXPENSE_ITEM_PLAN_REQUESTS tablosuna Harcama Onay alanı eklendi
Developer: Esma Uysal
Company : Workcube
Destination: period-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND COLUMN_NAME = 'HEALTH_APPROVE')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD 
        HEALTH_APPROVE bit NULL
    END
</querytag>