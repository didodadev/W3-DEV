<!-- Description : Alter RESPONSIBLE_EMP_POS sql
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GENERAL_PAPER' AND COLUMN_NAME='RESPONSIBLE_EMP_POS')
    BEGIN
        ALTER TABLE GENERAL_PAPER ADD
        RESPONSIBLE_EMP_POS int null
    END  

</querytag>
