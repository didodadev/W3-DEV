<!-- Description : Eğitim Talep Ekle ve güncelle Fuseaction düzenlendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'myhome.form_upd_training_request' WHERE FULL_FUSEACTION = 'myhome.popup_form_upd_training_request'
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'myhome.form_add_training_request' WHERE FULL_FUSEACTION = 'myhome.popup_form_add_training_request'
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/TrainingController.cfm' WHERE FULL_FUSEACTION = 'myhome.form_upd_training_request'
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/TrainingController.cfm' WHERE FULL_FUSEACTION = 'myhome.form_add_training_request'
</querytag>