<!-- Description : EXPENSE_ITEM_PLAN_REQUESTS tablosuna TREATED alanı eklendi
Developer: Canan Ebret
Company : Workcube
Destination: period-->
<querytag>
   
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND COLUMN_NAME = 'TREATED')
        BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD 
        TREATED INT NULL
        END

</querytag>