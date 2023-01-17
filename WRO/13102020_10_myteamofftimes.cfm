
<!-- Description : Benim ekibim çalıpşması ekibim ve departmanım widget
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT WIDGETID FROM WRK_WIDGET WHERE WIDGET_FRIENDLY_NAME = 'TravelOfftimeTraining') BEGIN
       INSERT [WRK_WIDGET] ( [WIDGET_FUSEACTION], [WIDGET_TITLE], [WIDGET_EVENT_TYPE], [WIDGET_VERSION], [WIDGET_STRUCTURE], [WIDGET_CODE], [WIDGET_STATUS], [WIDGET_STAGE], [WIDGET_TOOL], [WIDGET_FILE_PATH], [WIDGETSOLUTIONID], [WIDGETSOLUTION], [WIDGETFAMILYID], [WIDGETFAMILY], [WIDGETMODULEID], [WIDGETMODULE], [WIDGET_DESCRIPTION], [WIDGET_LICENSE], [WIDGET_AUTHOR], [WIDGET_DEPENDS], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [WIDGET_NAME], [WIDGET_FRIENDLY_NAME], [IS_PUBLIC], [IS_EMPLOYEE], [IS_COMPANY], [IS_CONSUMER], [IS_EMPLOYEE_APP], [IS_MACHINES], [IS_LIVESTOCK], [IS_TEMPLATE_WIDGET], [XML_PATH]) VALUES (N'ehesap.offtimes', N'İzinler', N'info', N'v19', NULL, NULL, N'Development', N'0', N'code', N'V16/hr/ehesap/display/myteam_state.cfm', 5, N'HR - İK', 9, N'Özlük-Bordo', 69, N'Devam ve Kontrol', N'<p><br></p>', N'1', N'Workcube Team', NULL, N'127.0.0.1', 124, CAST(N'2020-10-13T10:40:20.000' AS DateTime), NULL, NULL, NULL, NULL, N'TravelOfftimeTraining', 0, 0, 0, 0, 0, 0, 0, 0, NULL)
    END
</querytag>


