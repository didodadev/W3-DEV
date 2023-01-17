<!-- Description : PROCESS_TYPE_ROWS tablosuna IS_MANDATE alanı eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROCESS_TYPE_ROWS' AND COLUMN_NAME='IS_MANDATE')
    BEGIN
        ALTER TABLE PROCESS_TYPE_ROWS ADD
        IS_MANDATE bit NULL
    END

</querytag>
