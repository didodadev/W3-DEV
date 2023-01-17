<!-- Description : EXPENSE_ITEM_PLAN_REQUESTS tablosuna kurum adı alanı eklendi.
Developer: Botan Kaygan
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'COMPANY_NAME')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD
        COMPANY_NAME nvarchar(250) NULL;
    END;
</querytag>