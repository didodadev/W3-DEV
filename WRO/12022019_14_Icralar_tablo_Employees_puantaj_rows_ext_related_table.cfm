<!-- Description : EMPLOYEES_PUANTAJ_ROWS_EXT tablosuna RELATED_TABLE kolonu eklenmesi
Developer: Kayhan KAYA
Company : Workcube
Destination: Main-->
<querytag>
    IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS_EXT' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo'  )
    BEGIN
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS_EXT' AND COLUMN_NAME = 'RELATED_TABLE')
        BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS_EXT ADD 
        RELATED_TABLE nvarchar(200)
        END
    END
</querytag>