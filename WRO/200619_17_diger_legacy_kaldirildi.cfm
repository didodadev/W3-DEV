<!-- Description : Legacy Özelliği Kaldırıldı.
Developer: Murat Can Aygüneş
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'myhome.list_my_quotas'
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'myhome.my_expenses'
</querytag>
