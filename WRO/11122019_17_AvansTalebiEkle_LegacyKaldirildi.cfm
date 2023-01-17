<!-- Description : Avans talebi ekle sayfası Legacy Özelliği Kaldırıldı.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'myhome.form_add_payment_request'
</querytag>