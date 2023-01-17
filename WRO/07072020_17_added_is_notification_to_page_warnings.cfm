<!-- Description : PAGE_WARNINGS tablosuna IS_NOTIFICATION kolonu eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PAGE_WARNINGS' AND COLUMN_NAME = 'IS_NOTIFICATION' )
    BEGIN
        ALTER TABLE PAGE_WARNINGS 
        ADD IS_NOTIFICATION BIT NULL
    END;
</querytag>