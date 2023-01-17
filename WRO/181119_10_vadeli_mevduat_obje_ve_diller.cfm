<!-- Description : Vadeli Mevduat Hesap İşlemi İçin Oluşturulan Yeni Obje ve Diller
Developer: İlker Altındal
Company : Workcube
Destination: Main -->

<querytag>
IF NOT EXISTS(SELECT * FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.form_add_term_deposit')
BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 19, N'Vadeli Mevduat Hesaba Yatır', 51369, N'AddTermDeposit', N'bank.form_add_term_deposit', NULL, N'bank/form/add_term_deposit.cfm', N'WBO/controller/TermDepositController.cfm', NULL, 1, NULL, N'Deployment', NULL, 1, NULL, N'1.0', NULL, NULL, 0, 0, 0, NULL, N'Workcube Core', NULL, NULL, N'127.0.0.1', 67, CAST(N'2019-09-18 15:22:46.000' AS DateTime), N'192.168.69.53', 67, CAST(N'2019-11-16 08:38:06.400' AS DateTime), N'HTTP', 2176, NULL, NULL, N'bank', N'form_add_term_deposit', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, NULL, 1, 1, 1, 0, NULL, 24, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END;

IF NOT EXISTS(SELECT * FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'bank.interest_revenue')
BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 19, N'Vadeli Mevduat Getiri Listesi', 33559, NULL, N'bank.interest_revenue', NULL, N'bank/form/list_interest_revenue.cfm', N'WBO/controller/InterestRevenueController.cfm', NULL, 1, NULL, N'Deployment', NULL, 1, NULL, N'1.0', NULL, NULL, 0, 0, 0, NULL, N'Workcube Core', NULL, NULL, N'192.168.69.53', 67, CAST(N'2019-11-16 08:14:42.000' AS DateTime), N'127.0.0.1', 67, CAST(N'2019-11-16 14:03:07.983' AS DateTime), N'HTTP', 2176, NULL, NULL, N'bank', N'interest_revenue', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, NULL, 0, 1, 1, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END;

UPDATE SETUP_LANGUAGE_TR SET ITEM='Vadeli Mevduat Hesaba Yatır', ITEM_TR='Vadeli Mevduat Hesaba Yatır', ITEM_ENG='Deposit into Term Deposit Account' WHERE DICTIONARY_ID = 51369
UPDATE SETUP_LANGUAGE_TR SET ITEM='Vadeli Mevduat Hesaptan Çek', ITEM_TR='Vadeli Mevduat Hesaptan Çek', ITEM_ENG='Withdraw from Term Deposit Account' WHERE DICTIONARY_ID = 51370
UPDATE SETUP_LANGUAGE_TR SET ITEM='Vadeli Mevduat Hesap İşlemi', ITEM_TR='Vadeli Mevduat Hesap İşlemi', ITEM_ENG='Term Deposit Account Transaction' WHERE DICTIONARY_ID = 51371
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Oranı', ITEM_TR='Getiri Oranı', ITEM_ENG='Interest Yield Rate' WHERE DICTIONARY_ID = 51373
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Tutarı', ITEM_TR='Getiri Tutarı', ITEM_ENG='Yield Amount' WHERE DICTIONARY_ID = 51374
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Ödeme Periyodu', ITEM_TR='Getiri Ödeme Periyodu', ITEM_ENG='Yield Payment Period' WHERE DICTIONARY_ID = 51376
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Tablosu', ITEM_TR='Getiri Tablosu', ITEM_ENG='Yield Table' WHERE DICTIONARY_ID = 51378
UPDATE SETUP_LANGUAGE_TR SET ITEM='Vadeli Mevduat Hesaba Geçiş', ITEM_TR='Vadeli Mevduat Hesaba Geçiş', ITEM_ENG='Transition to Interest Account' WHERE DICTIONARY_ID = 51388
UPDATE SETUP_LANGUAGE_TR SET ITEM='Vadeli Mevduat Hesap Detayı', ITEM_TR='Vadeli Mevduat Hesap Detayı', ITEM_ENG='Term Deposit Account Detail' WHERE DICTIONARY_ID = 51391
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Oranı Girmelisiniz', ITEM_TR='Getiri Oranı Girmelisiniz', ITEM_ENG='You must enter yield rate' WHERE DICTIONARY_ID = 33550
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Ödeme Periyodu Girmelisiniz', ITEM_TR='Getiri Ödeme Periyodu Girmelisiniz', ITEM_ENG='You Must Enter Yield Payment Period' WHERE DICTIONARY_ID = 33551
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Tutarı Girmelisiniz', ITEM_TR='Getiri Tutarı Girmelisiniz', ITEM_ENG='You Must Enter Yield Payment' WHERE DICTIONARY_ID = 33553
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Tahsil Sayısı Girmelisiniz', ITEM_TR='Getiri Tahsil Sayısı Girmelisiniz', ITEM_ENG='You Must Enter Yield Collection Count' WHERE DICTIONARY_ID = 33554
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Tahsil Tutarı Girmelisiniz', ITEM_TR='Getiri Tahsil Tutarı Girmelisiniz', ITEM_ENG='You Must Enter Yield Collection Payment' WHERE DICTIONARY_ID = 33555
UPDATE SETUP_LANGUAGE_TR SET ITEM='Getiri Ödeme Sayısı', ITEM_TR='Getiri Ödeme Sayısı', ITEM_ENG='Yield Collection Count' WHERE DICTIONARY_ID = 33556
UPDATE SETUP_LANGUAGE_TR SET ITEM='Vade Sonu', ITEM_TR='Vade Sonu', ITEM_ENG='Expiration Date' WHERE DICTIONARY_ID = 33558
UPDATE SETUP_LANGUAGE_TR SET ITEM='Vadeli Mevduat Getiri Listesi', ITEM_TR='Vadeli Mevduat Getiri Listesi', ITEM_ENG='Term Deposit Yield List' WHERE DICTIONARY_ID = 33559
UPDATE SETUP_LANGUAGE_TR SET ITEM='Vadeli Mevduat Getiri Hesap Detayı', ITEM_TR='Vadeli Mevduat Getiri Hesap Detayı', ITEM_ENG='Term Deposit Yield Account Detail' WHERE DICTIONARY_ID = 33560
UPDATE SETUP_LANGUAGE_TR SET ITEM='Vadeli Mevduat Getiri Hesaba Geçiş', ITEM_TR='Vadeli Mevduat Getiri Hesaba Geçiş', ITEM_ENG='Yield Transition to Interest Account' WHERE DICTIONARY_ID = 33561
UPDATE SETUP_LANGUAGE_TR SET ITEM='Güncel Değer Tarihi', ITEM_TR='Güncel Değer Tarihi', ITEM_ENG='Current Value Date' WHERE DICTIONARY_ID = 33562
UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahsil Edilmemiş', ITEM_TR='Tahsil Edilmemiş', ITEM_ENG='Uncollected' WHERE DICTIONARY_ID = 33563
UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahsil Edilen', ITEM_TR='Tahsil Edilen', ITEM_ENG='Collected' WHERE DICTIONARY_ID = 33564
UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahsil Türü', ITEM_TR='Tahsil Türü', ITEM_ENG='Collected Type' WHERE DICTIONARY_ID = 33565
UPDATE SETUP_LANGUAGE_TR SET ITEM='Değerleme Tarihi', ITEM_TR='Değerleme Tarihi', ITEM_ENG='Valuation Date' WHERE DICTIONARY_ID = 33566
</querytag>