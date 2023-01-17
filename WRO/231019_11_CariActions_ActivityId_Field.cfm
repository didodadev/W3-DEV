<!-- Description : CARI_ACTIONS tablosuna ACTIVITY_ID alanı açıldı
Developer: Melek KOCABEY
Company : Workcube
Destination: Period -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='CARI_ACTIONS' AND COLUMN_NAME ='ACTIVITY_ID')
        BEGIN  
            ALTER TABLE CARI_ACTIONS ADD ACTIVITY_ID INT NULL
        END;
</querytag>