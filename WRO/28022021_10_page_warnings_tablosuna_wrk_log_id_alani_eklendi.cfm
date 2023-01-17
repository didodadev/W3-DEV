<!-- Description : PAGE_WARNINGS tablosuna WRK_LOG_ID kolonu eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>  
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PAGE_WARNINGS' AND COLUMN_NAME='WRK_LOG_ID')
    BEGIN
        ALTER TABLE PAGE_WARNINGS ADD WRK_LOG_ID int;
    END;  
</querytag>