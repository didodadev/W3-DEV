 <!-- Description : Kullanılmayan Depolama Alanı Sayfası Siliniyor.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.form_add_storage_system')
    BEGIN
        DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.form_add_storage_system'
    END;
</querytag>