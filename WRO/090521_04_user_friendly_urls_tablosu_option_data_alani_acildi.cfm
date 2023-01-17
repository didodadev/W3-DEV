<!-- Description : USER_FRIENDLY_URLS tablosuna OPTIONS_DATA alanı açılıd, seo için gereken optionları json olarak tutar
Developer: Semih Akartuna
Company : Yazılımsa
Destination: main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'USER_FRIENDLY_URLS' AND COLUMN_NAME = 'OPTIONS_DATA' AND TABLE_SCHEMA = '@_dsn_@')
    BEGIN
        ALTER TABLE USER_FRIENDLY_URLS ADD
        OPTIONS_DATA text NULL
    END; 
</querytag>