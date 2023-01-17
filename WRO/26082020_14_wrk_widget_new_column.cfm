<!-- Description : WRK_WIDGET new column
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='WIDGET_FRIENDLY_NAME')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD 
        WIDGET_FRIENDLY_NAME nvarchar(250);
    END;

</querytag>