<!-- Description : Özel Rapor Controller Eklendi.
Developer: Murat Can Aygüneş
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/SpecialReportsController.cfm' WHERE FULL_FUSEACTION = 'report.list_reports'
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'report.list_reports'
</querytag>
