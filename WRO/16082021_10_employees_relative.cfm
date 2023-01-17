<!-- Description : EMPLOYEES_RELATIVE Tablosu company alanının karakter kısıtı 500 e çıkarıldı.
Developer: Ece Yıldırım
Company : Workcube
Destination: MAIN -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='COMPANY')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES ALTER COLUMN COMPANY nvarchar (500) NULL
    END
</querytag>