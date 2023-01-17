<!--Description : health_expense tablosuna LIMB_ID alanı açıldı.
Developer: Melek KOCABEY
Company : Workcube
Destination: Period-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'HEALTH_EXPENSE' AND COLUMN_NAME = 'LIMB_ID')
        BEGIN
        ALTER TABLE HEALTH_EXPENSE ADD 
        LIMB_ID int
        END;
</querytag>