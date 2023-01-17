<!-- Description : Departmanlar tablosuna özel kod kolonu eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DEPARTMENT' AND COLUMN_NAME='SPECIAL_CODE')
    BEGIN
        ALTER TABLE DEPARTMENT ADD 
        SPECIAL_CODE nvarchar(50) NULL
    END;
</querytag>