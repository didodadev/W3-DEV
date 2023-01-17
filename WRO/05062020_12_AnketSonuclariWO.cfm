<!-- Description :form Generator sayfasından anketi kimin cevapladığının görüntülenmesi için yeni wo eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.list_detail_survey_employee')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FILE_PATH], [CONTROLLER_FILE_PATH], [LICENCE], [STATUS], [IS_MENU], [WINDOW], [VERSION], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [AUTHOR], [OBJECTS_COUNT], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [MODUL_SHORT_NAME], [FUSEACTION], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [IS_WBO_DENIED], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH])
        VALUES (0, 7, 'Anket Sonuçları', 34597, NULL, 'settings.list_detail_survey_employee', 'objects/display/list_detail_survey_employee.cfm', NULL, 1, 'Deployment', 0, NULL, 'v16', 0, 0, 0, 'Workcube Core', NULL, '127.0.0.1', 124, '2020-06-04 14:50:07.0', '127.0.0.1', 124, '2020-06-05 11:19:59.87', 'Standart', NULL, NULL, 'settings', 'list_detail_survey_employee', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 2 , NULL , NULL , 0, NULL)
    END   
</querytag>