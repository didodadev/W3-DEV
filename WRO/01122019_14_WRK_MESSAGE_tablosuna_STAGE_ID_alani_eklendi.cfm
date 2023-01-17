<!-- Description : WRK_MESSAGE tablosuna STAGE_ID alanı eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_MESSAGE' AND COLUMN_NAME='STAGE_ID')
    BEGIN
        ALTER TABLE WRK_MESSAGE ADD
        STAGE_ID int NULL
    END  

</querytag>
