<!-- Description : WRK Objects tablosuna display ve action file özelliği eklendi
Developer: Halit Yurttaş
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'DISPLAY_BEFORE_PATH')
    BEGIN
        ALTER TABLE WRK_OBJECTS ADD
        DISPLAY_BEFORE_PATH NVARCHAR(250) NULL
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'DISPLAY_AFTER_PATH')
    BEGIN
        ALTER TABLE WRK_OBJECTS ADD
        DISPLAY_AFTER_PATH NVARCHAR(250) NULL
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'ACTION_BEFORE_PATH')
    BEGIN
        ALTER TABLE WRK_OBJECTS ADD
        ACTION_BEFORE_PATH NVARCHAR(250) NULL
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'ACTION_AFTER_PATH')
    BEGIN
        ALTER TABLE WRK_OBJECTS ADD
        ACTION_AFTER_PATH NVARCHAR(250) NULL
    END;

</querytag>