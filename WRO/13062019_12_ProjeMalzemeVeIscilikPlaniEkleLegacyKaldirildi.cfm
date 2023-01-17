<!-- Description : Proje Malzeme ve İşçilik Planı Ekle Legacy Özelliği Kaldırıldı.
Developer: Ahmet Yolcu
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'project.popup_add_project_material'
</querytag>