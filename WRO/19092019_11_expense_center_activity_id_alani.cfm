<!-- Description : EXPENSE_CENTER tablosuna ACTIVITY_ID alanı açıldı
Developer: Uğur Hamurpet
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_CENTER' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'ACTIVITY_ID')
    BEGIN
        ALTER TABLE EXPENSE_CENTER ADD ACTIVITY_ID INT NULL
    END;
</querytag>