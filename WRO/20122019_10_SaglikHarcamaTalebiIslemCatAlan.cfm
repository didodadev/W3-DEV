<!--Description :Sağlık Harcama talebine İşlem Kategorisi eklendiği için PROCESS_CAT alanı eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Period-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND COLUMN_NAME = 'PROCESS_CAT')
        BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD 
        PROCESS_CAT INT NULL
        END
</querytag>