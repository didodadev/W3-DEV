<!-- Description : EMPLOYEES_RELATIVES_HISTORY Tablosu company alanının karakter kısıtı 500'e çıkarıldı.
Developer: Ece Yıldırım
Company : Workcube
Destination: MAIN -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='COMPANY')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES_HISTORY ALTER COLUMN COMPANY nvarchar (500) NULL
    END
</querytag>

