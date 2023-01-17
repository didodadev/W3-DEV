<!-- Description : Alter GENERAL_PAPER_PARENT_ID sql
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GENERAL_PAPER' AND COLUMN_NAME='GENERAL_PAPER_PARENT_ID')
    BEGIN
        ALTER TABLE GENERAL_PAPER ADD
        GENERAL_PAPER_PARENT_ID int null
    END  

</querytag>