<!-- Description :Sağlık Harcama Fişi Wo eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Main -->
<querytag>
      UPDATE SETUP_LANGUAGE_TR SET ITEM='Sağlık Harcama Fişleri', ITEM_TR='Sağlık Harcama Fişleri' WHERE DICTIONARY_ID = 46609    
      IF NOT EXISTS(SELECT * FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'health.expenses')
      BEGIN
            INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 70, N'Sağlık Harcama Fişleri', 46609, N'health.expenses', N'health.expenses', NULL, N'cost/display/list_expense_income.cfm', N'WBO/controller/HealthExpensesController.cfm', NULL, 2, NULL, N'Analys', NULL, 1, NULL, N'Alfa', NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, N'127.0.0.1', 69, CAST(N'2019-11-25 11:45:08.000' AS DateTime), N'127.0.0.1', 69, CAST(N'2019-11-25 12:16:11.673' AS DateTime), N'HTTP', 2176, NULL, NULL, N'health', N'expenses', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
      END;
</querytag>