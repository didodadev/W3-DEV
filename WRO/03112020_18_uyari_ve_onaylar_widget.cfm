<!-- Description : Onay ve uyarılar widget
Developer : Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT 'Y' FROM WRK_WIDGET WHERE WIDGET_FRIENDLY_NAME = 'myProcess') 
    BEGIN
        INSERT [WRK_WIDGET] ([WIDGET_FUSEACTION], [WIDGET_TITLE], [WIDGET_NAME], [WIDGET_EVENT_TYPE], [WIDGET_VERSION], [WIDGET_STRUCTURE], [WIDGET_CODE], [WIDGET_STATUS], [WIDGET_STAGE], [WIDGET_TOOL], [WIDGET_FILE_PATH], [WIDGETSOLUTIONID], [WIDGETSOLUTION], [WIDGETFAMILYID], [WIDGETFAMILY], [WIDGETMODULEID], [WIDGETMODULE], [WIDGET_DESCRIPTION], [WIDGET_LICENSE], [WIDGET_AUTHOR], [WIDGET_DEPENDS], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [WIDGET_FRIENDLY_NAME], [IS_PUBLIC], [IS_EMPLOYEE], [IS_COMPANY], [IS_CONSUMER], [IS_EMPLOYEE_APP], [IS_MACHINES], [IS_LIVESTOCK], [IS_TEMPLATE_WIDGET], [XML_PATH]) 
        VALUES (N'objects.workflowpages', N'Uyarı ve Onaylar', NULL, N'dashboard', N'V 1.0', NULL, NULL, N'Deployment', N'0', N'code', N'V16/myhome/display/widget_warnings_content.cfm', 15, N'Sistem', 29, N'Genel Kullanım', 47, N'Objeler', N'<p>Ekip üyelerinin dahil olduğu süreç ve aşamaları gösteren widget</p>', N'1', N'Workcube Core', NULL, N'127.0.0.1', 82, CAST(N'2020-11-04 16:02:49.000' AS DateTime), NULL, NULL, NULL, N'myProcess', 0, 0, 0, 0, 0, 0, 0, 0, NULL)
    END
</querytag>