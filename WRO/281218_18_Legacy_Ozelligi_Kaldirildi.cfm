<!--
    Description : Para Birimi,Muhasebe Dönemi,Şirket Genel Bilgileri  ekle/güncelle Legacy Özelliği Kaldırıldı.
    Developer: Murat Can Aygüneş
    Company : Workcube
    Destination: Main
-->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'settings.form_upd_money'

    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'settings.form_upd_period'

    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'settings.form_add_our_company'

    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'settings.form_upd_our_company'

    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'settings.form_add_money'

    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'settings.form_add_period'
</querytag>