<!-- Description : blok grubu ekle ve güncelle sayfası aktif güncellemesi yapıldı ve project dashboard sayfası type'ı dashboard olarak güncellendi.
Developer: Canan ebret
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.form_add_block_group') 
    BEGIN
    UPDATE WRK_OBJECTS SET IS_ACTIVE = 1 WHERE FULL_FUSEACTION = 'settings.form_add_block_group'
    END;

    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.form_upd_block_group') 
    BEGIN
    UPDATE WRK_OBJECTS SET IS_ACTIVE = 1 WHERE FULL_FUSEACTION = 'settings.form_upd_block_group'
    END;

    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.project_summary') 
    BEGIN
    UPDATE WRK_OBJECTS SET TYPE = 13 WHERE FULL_FUSEACTION = 'report.project_summary'
    END
</querytag>