<!-- Description :bsmv oiv otv ve kdv için fuseaction ve type durumu güncellendii.
Developer: Zehra dere
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'settings.list_tax',TYPE = 1 WHERE FULL_FUSEACTION = 'settings.form_add_tax' 
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'settings.list_bsmv',TYPE = 1 WHERE FULL_FUSEACTION = 'settings.form_add_bsmv' 
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'settings.list_oiv',TYPE = 1 WHERE FULL_FUSEACTION = 'settings.form_add_oiv' 
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'settings.list_otv',TYPE = 1 WHERE FULL_FUSEACTION = 'settings.form_add_otv' 
</querytag>