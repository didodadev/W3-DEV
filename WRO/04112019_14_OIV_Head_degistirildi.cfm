<!-- Description : oiv sayfasının başlığı değiştirildi..
Developer: Canan ebret
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.form_add_oiv') 
    BEGIN
    UPDATE WRK_OBJECTS SET HEAD = 'ÖİV Oranları' WHERE FULL_FUSEACTION = 'settings.form_add_oiv'
    END
</querytag>