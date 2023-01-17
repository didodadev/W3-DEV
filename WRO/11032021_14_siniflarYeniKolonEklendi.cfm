<!-- Description : Sınıflar sayfasına süreç-aşama yönetimi için, TRAINING_CLASS_GROUPS tablosuna PROCESS_STAGE alanı açıldı.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TRAINING_CLASS_GROUPS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROCESS_STAGE')
    BEGIN
        ALTER TABLE TRAINING_CLASS_GROUPS ADD
        PROCESS_STAGE int NULL
    END;
</querytag>