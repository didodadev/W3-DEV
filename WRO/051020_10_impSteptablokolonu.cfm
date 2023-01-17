<!-- Description :  imp steps tablosuna tablo alanı acıldı
Developer: ilker altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_IMPLEMENTATION_STEP' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='WRK_RELATED_TABLE_COLUMN')
    BEGIN
        ALTER TABLE WRK_IMPLEMENTATION_STEP ADD 
        WRK_RELATED_TABLE_COLUMN nvarchar(250) NULL
    END;
</querytag>