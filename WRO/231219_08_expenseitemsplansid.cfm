<!-- Description : Masraf fişi EXPENSE_ITEM_PLANS_ID alanı açıldı
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEM_PLANS' AND COLUMN_NAME = 'EXPENSE_ITEM_PLANS_ID')
        BEGIN
                ALTER TABLE EXPENSE_ITEM_PLANS 
                ADD EXPENSE_ITEM_PLANS_ID INT NULL
        END;
</querytag>