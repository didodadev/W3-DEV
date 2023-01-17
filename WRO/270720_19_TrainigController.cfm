<!-- Description : Eğitim Talep Ekle ve güncelle controller düzenlendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = '' WHERE FULL_FUSEACTION = 'myhome.form_upd_training_request'
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = '' WHERE FULL_FUSEACTION = 'myhome.form_add_training_request'
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/TrainingController.cfm' WHERE FULL_FUSEACTION = 'myhome.list_my_tranings'
</querytag>