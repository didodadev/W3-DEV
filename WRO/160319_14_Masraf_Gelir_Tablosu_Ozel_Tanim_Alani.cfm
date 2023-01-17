<!-- Description : Masraf-Gelir tablosuna özel tanım alanı eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Period -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEM_PLANS' AND COLUMN_NAME = 'SPECIAL_DEFINITION_ID')
        BEGIN
        ALTER TABLE EXPENSE_ITEM_PLANS ADD 
        SPECIAL_DEFINITION_ID [int] NULL
        END;
</querytag>