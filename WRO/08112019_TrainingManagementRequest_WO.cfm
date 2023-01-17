<!-- Description : Eğitim Talebi Yönetimi WO controller eklenmesi
Developer: Tolga Sütlü
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE 
        WRK_OBJECTS 
    SET
		CONTROLLER_FILE_PATH = 'WBO/controller/TrainingManagementRequestController.cfm'
    WHERE
        FULL_FUSEACTION='training_management.list_class_requests'
        AND (CONTROLLER_FILE_PATH IS NULL OR CONTROLLER_FILE_PATH = '')
        AND ( ADDOPTIONS_CONTROLLER_FILE_PATH IS NULL OR ADDOPTIONS_CONTROLLER_FILE_PATH  = '' )
</querytag>