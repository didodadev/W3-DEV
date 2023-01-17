<!-- Description : CASH_ACTIONS tablosuna abone kolonu eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CASH_ACTIONS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'SUBSCRIPTION_ID ')
    BEGIN
        ALTER TABLE CASH_ACTIONS ADD 
		SUBSCRIPTION_ID  int NULL
    END;
</querytag>