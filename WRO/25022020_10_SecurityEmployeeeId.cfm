<!-- Description : Güvenlik tablolarına çalışan ID eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_SECURE_BANNED_IP' AND COLUMN_NAME='EMPLOYEE_ID')
    BEGIN
        ALTER TABLE WRK_SECURE_BANNED_IP ADD
        EMPLOYEE_ID int null
    END  

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_SECURE_LOG' AND COLUMN_NAME='EMPLOYEE_ID')
    BEGIN
        ALTER TABLE WRK_SECURE_LOG ADD
        EMPLOYEE_ID int null
    END  

</querytag>
