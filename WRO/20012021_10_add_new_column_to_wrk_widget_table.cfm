
<!-- Description : Add new column to WRK_WIDGET
Developer: Uğur Hamurpet
Company : Workcube
Destination: main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_WIDGET' AND COLUMN_NAME = 'WIDGET_TITLE_DICTIONARY_ID')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD
        WIDGET_TITLE_DICTIONARY_ID int NULL
    END;
</querytag>