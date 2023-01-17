<!-- Description : Banka Tipine Göre Bakiye Getiren Sayfa için obje eklendi.
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.ajax_group_bank_type_list')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 19, N'Banka Tiplerine Göre Bakiye Getiren Ajax', 38609, N'AjaxBankTypes', N'bank.ajax_group_bank_type_list', NULL, N'bank/display/ajax_group_bank_type_list.cfm', NULL, NULL, 1, NULL, N'Development', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, N'127.0.0.1', 67, CAST(N'2019-11-27 11:41:58.000' AS DateTime), N'192.168.71.8', 57, CAST(N'2019-11-30 09:55:17.667' AS DateTime), N'HTTP', 2176, NULL, NULL, N'bank', N'ajax_group_bank_type_list', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 1, 0, 0, 10, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    UPDATE SETUP_LANGUAGE_TR SET ITEM='Banka Tiplerine Göre Bakiye Getiren Ajax', ITEM_TR='Banka Tiplerine Göre Bakiye Getiren Ajax', ITEM_ENG='Debit-Credi According to Bank Type for Rate' WHERE DICTIONARY_ID = 38609

</querytag>