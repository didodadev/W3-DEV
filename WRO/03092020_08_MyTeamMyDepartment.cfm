
<!-- Description : Benim ekibim çalıpşması ekibim ve departmanım widget
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT WIDGETID FROM WRK_WIDGET WHERE WIDGET_FRIENDLY_NAME = 'myDepartments') 
    BEGIN
        INSERT  [WRK_WIDGET] ( [WIDGET_FUSEACTION], [WIDGET_TITLE], [WIDGET_EVENT_TYPE], [WIDGET_VERSION], [WIDGET_STRUCTURE], [WIDGET_CODE], [WIDGET_STATUS], [WIDGET_STAGE], [WIDGET_TOOL], [WIDGET_FILE_PATH], [WIDGETSOLUTIONID], [WIDGETSOLUTION], [WIDGETFAMILYID], [WIDGETFAMILY], [WIDGETMODULEID], [WIDGETMODULE], [WIDGET_DESCRIPTION], [WIDGET_LICENSE], [WIDGET_AUTHOR], [WIDGET_DEPENDS], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [WIDGET_NAME], [WIDGET_FRIENDLY_NAME]) VALUES ( N'hr.list_depts', N'Yöneticiye Özet', N'info', N'v19', NULL, NULL, N'Development', N'0', N'code', N'V16/hr/ehesap/display/myteam_departments.cfm', 5, N'HR - İK', 9, N'Özlük-Bordo', 69, N'Devam ve Kontrol', N'', N'1', N'Workcube Team', NULL, N'127.0.0.1', 124, CAST(N'2020-09-02T11:20:02.000' AS DateTime), NULL, NULL, NULL, NULL, N'myDepartments')
    END
    IF NOT EXISTS(SELECT WIDGETID FROM WRK_WIDGET WHERE WIDGET_FRIENDLY_NAME = 'myTeam') 
    BEGIN
        INSERT [WRK_WIDGET] ([WIDGET_FUSEACTION], [WIDGET_TITLE], [WIDGET_EVENT_TYPE], [WIDGET_VERSION], [WIDGET_STRUCTURE], [WIDGET_CODE], [WIDGET_STATUS], [WIDGET_STAGE], [WIDGET_TOOL], [WIDGET_FILE_PATH], [WIDGETSOLUTIONID], [WIDGETSOLUTION], [WIDGETFAMILYID], [WIDGETFAMILY], [WIDGETMODULEID], [WIDGETMODULE], [WIDGET_DESCRIPTION], [WIDGET_LICENSE], [WIDGET_AUTHOR], [WIDGET_DEPENDS], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [WIDGET_NAME], [WIDGET_FRIENDLY_NAME]) VALUES (N'hr.myteam_list_positions', N'Ekibim', N'info', N'v19', NULL, NULL, N'Development', N'0', N'code', N'V16/hr/ehesap/display/myteam_positions.cfm', 5, N'HR - İK', 13, N'Planlama', 3, N'Organizasyon Planlama', N'', N'1', N'Workcube Team', NULL, N'127.0.0.1', 124, CAST(N'2020-09-01T15:42:01.000' AS DateTime), N'127.0.0.1', 124, CAST(N'2020-09-01T15:45:09.000' AS DateTime), NULL, N'myTeam')
    END
</querytag>