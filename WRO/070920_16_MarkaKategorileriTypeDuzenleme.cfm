<!-- Description : Marka Kategorisi(Güncelle) tipi değiştirildi. 
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.upd_brand_type_cat') 
    BEGIN
        UPDATE WRK_OBJECTS SET TYPE = 10 WHERE FULL_FUSEACTION = 'settings.upd_brand_type_cat'
    END;

    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.upd_brand_type') 
    BEGIN
        UPDATE WRK_OBJECTS SET TYPE = 10 WHERE FULL_FUSEACTION = 'settings.upd_brand_type'
    END;
</querytag>