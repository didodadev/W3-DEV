<!-- Description : Fatura ve masrafa işlem tarihi eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVOICE' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PROCESS_DATE')
    BEGIN
        ALTER TABLE INVOICE ADD
        PROCESS_DATE datetime NULL
    END;
     IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEM_PLANS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PROCESS_DATE')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLANS ADD
        PROCESS_DATE datetime NULL
    END;
</querytag>