<!-- Description : PROCESS_TYPE_ROWS tablosuna IS_REQUIRED_PREVIEW ve IS_REQUIRED_ACTION_LINK alanları eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROCESS_TYPE_ROWS' AND COLUMN_NAME='IS_REQUIRED_PREVIEW')
    BEGIN
        ALTER TABLE PROCESS_TYPE_ROWS ADD
        IS_REQUIRED_PREVIEW bit NULL
    END

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROCESS_TYPE_ROWS' AND COLUMN_NAME='IS_REQUIRED_ACTION_LINK')
    BEGIN
        ALTER TABLE PROCESS_TYPE_ROWS ADD
        IS_REQUIRED_ACTION_LINK bit NULL
    END

</querytag>
