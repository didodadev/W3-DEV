<!-- Description : WRK_FAMILY tablosuna RECORD ve UPDATE bilgilerini tutan kolonlar eklendi
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'RECORD_DATE')
    BEGIN
        ALTER TABLE WRK_FAMILY ADD
        RECORD_DATE datetime NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'RECORD_EMP')
    BEGIN
        ALTER TABLE WRK_FAMILY ADD
        RECORD_EMP int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'RECORD_IP')
    BEGIN
        ALTER TABLE WRK_FAMILY ADD
        RECORD_IP nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'UPDATE_DATE')
    BEGIN
        ALTER TABLE WRK_FAMILY ADD
        UPDATE_DATE datetime NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'UPDATE_EMP')
    BEGIN
        ALTER TABLE WRK_FAMILY ADD
        UPDATE_EMP int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'UPDATE_IP')
    BEGIN
        ALTER TABLE WRK_FAMILY ADD
        UPDATE_IP nvarchar(50) NULL
    END;
</querytag>