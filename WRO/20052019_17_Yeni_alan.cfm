<!-- Description :Sistem İçi Yazıcı Belgeleri sayfasında karşılığı olmayan dileri gösterebilmek için tabloya Dictionary_id alan eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SETUP_PRINT_FILES_CATS' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRINT_FILES_CATS' AND COLUMN_NAME = 'PRINT_DICTIONARY_ID')
        BEGIN
        ALTER TABLE SETUP_PRINT_FILES_CATS ADD 
        PRINT_DICTIONARY_ID INT
        END
    END
</querytag>
