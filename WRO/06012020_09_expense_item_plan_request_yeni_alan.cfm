<!-- Description : EXPENSE_ITEM_PLAN_REQUESTS tablosuna Tedaviye esas tutar alanı eklendi.
Developer: Botan Kaygan
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'TREATMENT_AMOUNT')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD
        TREATMENT_AMOUNT float NULL;
    END;
</querytag>