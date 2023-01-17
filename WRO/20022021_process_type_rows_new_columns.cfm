<!-- Description : PROCESS_TYPE_ROWS Tablosuna yeni alan eklendi.
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='PROCESS_TYPE_ROWS' AND COLUMN_NAME='IS_STAGE_ACTION')
    BEGIN
        ALTER TABLE PROCESS_TYPE_ROWS ADD IS_STAGE_ACTION bit NULL;
    END;
</querytag>