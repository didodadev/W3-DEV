<!-- Description : Yansıtma Hesapları Kapanış Tanımları Legacy Özelliği Kaldırıldı.
Developer: Murat Can Aygüneş
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'account.form_add_reflecting_acc_def'
</querytag>