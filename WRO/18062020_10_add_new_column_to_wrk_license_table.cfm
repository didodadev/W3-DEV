<!-- Description :  add new columns to WRK_LICENSE table
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'PATCH_NO')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        PATCH_NO nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'PATCH_DATE')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        PATCH_DATE datetime NULL
    END;
</querytag>