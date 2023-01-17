<!-- Description :SETUP_TAX tablosuna EXPENSE_ITEM_ID alanı eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'SETUP_TAX' AND COLUMN_NAME = 'EXPENSE_ITEM_ID')
    BEGIN
        ALTER TABLE SETUP_TAX ADD 
        EXPENSE_ITEM_ID int NULL
    END;
</querytag>