<!-- Description : Rapor Ekle Legacy Özelliği Kaldırıldı.
Developer: Murat Can Aygüneş
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'report.form_add_report_special'
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'report.form_upd_report_special'
</querytag>