<!-- Description : Call center başvuru için WRK_PROCESS_TEMPLATES'e action file eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS(SELECT WRK_PROCESS_TEMPLATE_ID FROM WRK_PROCESS_TEMPLATES WHERE PROCESS_TEMPLATE_PATH = 'V16/process/files/call_center_application_main_action.cfm')
    BEGIN
        INSERT [WRK_PROCESS_TEMPLATES] ([WRK_PROCESS_TEMPLATE_NAME], [IS_ACTIVE], [IS_ACTION], [IS_DISPLAY], [IS_STAGE], [IS_MAIN], [BEST_PRACTISE_CODE], [PROCESS_TEMPLATE_DETAIL], [WORKCUBE_PRODUCT_ID], [LICENCE_TYPE], [RELATED_WO], [AUTHOR_PARTNER_ID], [AUTHOR_NAME], [PROCESS_TEMPLATE_ICON_PATH], [PROCESS_TEMPLATE_PATH], [PROCESS_TEMPLATE_SECTORS], [WRK_PROCESS_STAGE], [MODULE_ID], [PROCESS_TEMPLATE_VERSION], [RECORD_DATE], [RECORD_EMP], [RECORD_IP], [UPDATE_DATE], [UPDATE_EMP], [UPDATE_IP]) VALUES (N'Call Center Başvuru Main Action', 1, 1, 0, 0, 1, N'', N'Çağrı merkezi süreç aşamalarına eklenir. Eklenen süreç aşaması başvuruda seçilmesi durumunda işlem yapılan tarih ve saatti bitiş tarihi olarak atar ve başvuruyu pasife alır. Çözüme Ulaştı ve Kapatıldı vb. gibi süreç aşamaları için kullanılmalıdır. Çağrı başvurusunun ne kadar sürede çözüldüğünü belirlemek ve performansı ölçmek amacıyla kullanılır.', NULL, 1, N'call.list_service', NULL, N'Gramoni-Mahmut Çifçi', N'', N'V16/process/files/call_center_application_main_action.cfm', N'41,1,2,56,42,3,4,43,57,44,62,5,6,7,45,8,9,10,11,12,58,13,14,15,16,46,47,17,18,48,59,19,20,21,22,23,24,25,49,50,63,26,27,28,51,52,60,29,30,53,61,31,54,32,33,34,55,35,36,37,38,39,40', 863, 11, N'v19', CAST(N'2021-02-04T10:08:08.000' AS DateTime), 10, N'78.163.126.97', NULL, NULL, NULL)
    END;
</querytag>