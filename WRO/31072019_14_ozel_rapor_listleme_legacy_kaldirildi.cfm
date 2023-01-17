<!-- Description : Özel Rapor Detay Legacy Özelliği Kaldırıldı.
Developer: Murat Can Aygüneş
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'report.detail_report'
</querytag>