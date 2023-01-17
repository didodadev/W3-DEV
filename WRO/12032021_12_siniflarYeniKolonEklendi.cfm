<!-- Description : Sınıflar sayfasına, TRAINING_CLASS_GROUPS tablosuna QUOTA alanı açıldı.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TRAINING_CLASS_GROUPS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'QUOTA')
    BEGIN
        ALTER TABLE TRAINING_CLASS_GROUPS ADD
        QUOTA int NULL
    END;
</querytag>