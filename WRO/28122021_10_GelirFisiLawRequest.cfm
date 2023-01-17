<!-- Description : EXPENSE_ITEM_PLANS tablosuna LAW_REQUEST_ID alanı eklendi.
Developer: Fatih Kara
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLANS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'LAW_REQUEST_ID')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLANS ADD
        LAW_REQUEST_ID int NULL;
    END;
</querytag>