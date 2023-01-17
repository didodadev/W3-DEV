
<!-- Description : Ekibim Calısması Bütçe Widget
Developer : İlker Altındal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT WIDGETID FROM WRK_WIDGET WHERE WIDGET_FRIENDLY_NAME = 'MyBudgetStatus') 
    BEGIN
        INSERT [WRK_WIDGET] ([WIDGET_FUSEACTION], [WIDGET_TITLE], [WIDGET_NAME], [WIDGET_EVENT_TYPE], [WIDGET_VERSION], [WIDGET_STRUCTURE], [WIDGET_CODE], [WIDGET_STATUS], [WIDGET_STAGE], [WIDGET_TOOL], [WIDGET_FILE_PATH], [WIDGETSOLUTIONID], [WIDGETSOLUTION], [WIDGETFAMILYID], [WIDGETFAMILY], [WIDGETMODULEID], [WIDGETMODULE], [WIDGET_DESCRIPTION], [WIDGET_LICENSE], [WIDGET_AUTHOR], [WIDGET_DEPENDS], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [IS_PUBLIC], [IS_EMPLOYEE], [IS_COMPANY], [IS_CONSUMER], [IS_EMPLOYEE_APP], [IS_MACHINES], [IS_LIVESTOCK], [IS_TEMPLATE_WIDGET], [WIDGET_FRIENDLY_NAME], [XML_PATH]) 
        VALUES (N'myhome.myTeam', N'Bütçe Uygunluk Kontrolü', NULL, N'dashboard', N'v19', NULL, NULL, N'Analys', N'0', N'code', N'V16/myhome/display/my_budget_status.cfm', 3, N'Intranet', 5, N'MyPortal', 82, N'Diğer İşlemler', N'<p>MyTeam dashboardında ki Bütçe Durumu widgetini temsil eder</p>', N'1', N'İlker Altındal', NULL, N'127.0.0.1', 67, CAST(N'2020-09-23T20:37:10.000' AS DateTime), N'127.0.0.1', 67, CAST(N'2020-09-23T21:09:38.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'MyBudgetStatus', NULL)
    END
</querytag>