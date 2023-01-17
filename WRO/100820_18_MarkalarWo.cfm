<!-- Description : Markalar sayfasının başlığı ve type değiştirildi..
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.upd_brand') 
    BEGIN
        UPDATE WRK_OBJECTS SET HEAD = 'Markalar',DICTIONARY_ID = 41606 WHERE FULL_FUSEACTION = 'settings.upd_brand'
    END;
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.upd_brand_type') 
    BEGIN
        UPDATE WRK_OBJECTS SET HEAD = 'Marka Tipi Güncelle',DICTIONARY_ID = 42211,TYPE=1 WHERE FULL_FUSEACTION = 'settings.upd_brand_type'
    END;
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.upd_brand_type_cat') 
    BEGIN
        UPDATE WRK_OBJECTS SET HEAD = 'Marka Kategorisi(Güncelle)',DICTIONARY_ID = 38920,TYPE=1 WHERE FULL_FUSEACTION = 'settings.upd_brand_type_cat'
    END;
</querytag>