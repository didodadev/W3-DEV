<!-- Description : PROCESS_TYPE tablosuna IS_STAGE_MANUEL_CHANGE alanı eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: main-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE' AND COLUMN_NAME = 'IS_STAGE_MANUEL_CHANGE')
        BEGIN
            ALTER TABLE PROCESS_TYPE ADD 
            IS_STAGE_MANUEL_CHANGE bit null
        END;
</querytag>