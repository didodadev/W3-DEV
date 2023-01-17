<!-- Description :  WRK_DATA_IMPORT_LIBRARY tablosuna IS_COMP ve IS_PERIOD alanları eklendi
Developer: Botan KAYĞAN
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_DATA_IMPORT_LIBRARY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_COMP')
    BEGIN
        ALTER TABLE WRK_DATA_IMPORT_LIBRARY
        ADD IS_COMP bit NULL
    END;
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_DATA_IMPORT_LIBRARY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_PERIOD')
    BEGIN
        ALTER TABLE WRK_DATA_IMPORT_LIBRARY
        ADD IS_PERIOD bit NULL
    END;
</querytag>