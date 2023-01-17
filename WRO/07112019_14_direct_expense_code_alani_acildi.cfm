<!-- Description : SETUP_TAX tablosuna DIRECT_EXPENSE_CODE alanı açıldı
Developer: Uğur Hamurpet
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'SETUP_TAX' AND COLUMN_NAME = 'DIRECT_EXPENSE_CODE' )
    BEGIN
        ALTER TABLE SETUP_TAX ADD DIRECT_EXPENSE_CODE nvarchar(50) NULL
    END
</querytag>