<!-- Description : Şifreleme Sistemi Legacy Özelliği Kaldırıldı.
Developer: Murat Can Aygüneş
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'settings.form_add_password_inf'
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'settings.form_upd_password_inf'
</querytag>