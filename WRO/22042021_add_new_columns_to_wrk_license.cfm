<!-- Description :  WRK_LICENSE tablosuna yeni alan eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_LICENSE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='MONO')
    BEGIN
        ALTER TABLE WRK_LICENSE
        ADD MONO nvarchar(MAX) NULL
    END;
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_LICENSE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='PROD')
    BEGIN
        ALTER TABLE WRK_LICENSE
        ADD PROD nvarchar(MAX) NULL
    END;
</querytag>