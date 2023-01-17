<!-- Description : Dev.wo'da Main Version ve Data Path inputlarına karşılık 2 kolon eklendi.
Developer: Mert Yüce
Company : Workcube
Destination: Main-->

<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'MAIN_VERSION')
    BEGIN        
        ALTER TABLE WRK_OBJECTS ADD MAIN_VERSION nvarchar(250) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'DATA_PATH')
    BEGIN        
        ALTER TABLE WRK_OBJECTS ADD DATA_PATH nvarchar(250) NULL
    END
</querytag>