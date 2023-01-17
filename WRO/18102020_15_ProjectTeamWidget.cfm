<!-- Description : Proje ekip boxı widgeta dönüştürüldü.
Developer : Emine Yılmaz
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT WIDGETID FROM WRK_WIDGET WHERE WIDGET_FUSEACTION = 'sales.list_subscription_contract' AND WIDGET_FRIENDLY_NAME='subscriberTeam') 
    BEGIN
        INSERT [WRK_WIDGET] ([WIDGET_FUSEACTION], [WIDGET_TITLE], [WIDGET_EVENT_TYPE], [WIDGET_VERSION], [WIDGET_STRUCTURE], [WIDGET_CODE], [WIDGET_STATUS], [WIDGET_STAGE], [WIDGET_TOOL], [WIDGET_FILE_PATH], [WIDGETSOLUTIONID], [WIDGETSOLUTION], [WIDGETFAMILYID], [WIDGETFAMILY], [WIDGETMODULEID], [WIDGETMODULE], [WIDGET_DESCRIPTION], [WIDGET_LICENSE], [WIDGET_AUTHOR], [WIDGET_DEPENDS], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [WIDGET_NAME], [IS_PUBLIC], [IS_EMPLOYEE], [IS_COMPANY], [IS_CONSUMER], [IS_EMPLOYEE_APP], [IS_MACHINES], [IS_LIVESTOCK], [IS_TEMPLATE_WIDGET], [XML_PATH], [WIDGET_FRIENDLY_NAME]) VALUES (N'sales.list_subscription_contract', N'Ekip', N'list', N'v19', NULL, NULL, N'Analys', N'0', N'code', N'v16\project\display\list_workgroup.cfm', 10, N'SUBO', 19, N'Abonelik', 79, N'Abone Yönetimi', N'<p>Abone veya projeye göre ekibi getiren widget.</p>', N'1', N'Emine Yılmaz', NULL, N'127.0.0.1', 124, CAST(N'2020-10-19T12:54:16.000' AS DateTime), NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, 0, 0, 0, NULL, N'subscriberTeam')
    END;
</querytag>