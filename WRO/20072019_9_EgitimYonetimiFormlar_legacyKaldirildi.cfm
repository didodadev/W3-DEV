<!-- Description :Eğitim Yönetimi Formlar sayfası Legacy Özelliği Kaldırıldı.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'training_management.list_detail_survey_report'
</querytag>