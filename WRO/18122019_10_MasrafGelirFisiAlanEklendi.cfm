<!--Description : Masraf ve gelir fişi ve Alış faturası sayfalarına süreç eklendiği için ilgili tablolara PROCESS_STAGE alanı eklendi
Developer: Canan Ebret
Company : Workcube
Destination: Period-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEM_PLANS' AND COLUMN_NAME = 'PROCESS_STAGE')
        BEGIN
            ALTER TABLE EXPENSE_ITEM_PLANS ADD 
            PROCESS_STAGE int NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'INVOICE' AND COLUMN_NAME = 'PROCESS_STAGE')
        BEGIN
            ALTER TABLE INVOICE ADD 
            PROCESS_STAGE int NULL
        END
</querytag>