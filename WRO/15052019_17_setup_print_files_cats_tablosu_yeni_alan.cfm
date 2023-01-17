<!-- Description :Sistem İçi Yazıcı Belgeleri sayfasında karşılığı olmayan dileri gösterebilmek için tabloya eklenen alan adı Dictionary_id yanlış olduğundan dolayı silindi.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SETUP_PRINT_FILES_CATS' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        IF EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRINT_FILES_CATS' AND COLUMN_NAME ='DICTIONARY_ID'  )
        BEGIN
        ALTER TABLE SETUP_PRINT_FILES_CATS DROP COLUMN DICTIONARY_ID;
        END
    END
</querytag>
