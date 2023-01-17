<!-- Description : Cari Actions tablosuna FROM_DUE_DATE alanı açıldı
Developer: Melek KOCABEY
Company : Workcube
Destination: period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CARI_ACTIONS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'FROM_DUE_DATE')
    BEGIN
        ALTER TABLE CARI_ACTIONS ADD
        FROM_DUE_DATE DATETIME NULL
    END;
</querytag>