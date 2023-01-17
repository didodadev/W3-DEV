
<!-- Description : Add new columns to WRK_MESSAGE
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_MESSAGE' AND COLUMN_NAME = 'IS_DELETED')
    BEGIN
        ALTER TABLE WRK_MESSAGE ADD
        IS_DELETED bit NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_MESSAGE' AND COLUMN_NAME = 'IS_DELIVERED')
    BEGIN
        ALTER TABLE WRK_MESSAGE ADD
        IS_DELIVERED bit NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_MESSAGE' AND COLUMN_NAME = 'DELETED_DATE')
    BEGIN
        ALTER TABLE WRK_MESSAGE ADD
        DELETED_DATE datetime NULL
    END;
</querytag>