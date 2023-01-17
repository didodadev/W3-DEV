<!-- Description :Senet tahsilat için sözlüğe yeni dil eklenmiştir.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SETUP_LANGUAGE_TR' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        IF EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_LANGUAGE_TR' AND COLUMN_NAME='ITEM')
        BEGIN
        UPDATE SETUP_LANGUAGE_TR SET ITEM='Kapanacak Tutar Kalan Tutardan Büyük Olamaz!', ITEM_TR='Kapanacak Tutar Kalan Tutardan Büyük Olamaz!', ITEM_ENG='The amount can not be greater than the remaining amount!' WHERE DICTIONARY_ID = 49742
        END
    END
</querytag>