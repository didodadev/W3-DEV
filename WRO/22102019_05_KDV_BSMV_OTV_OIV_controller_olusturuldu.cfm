<!-- Description : KDV, BSMV, OTV, OIV ekranları için Controller sayfaları oluşturuldu.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/ControllerBSMV.cfm' WHERE FULL_FUSEACTION = 'settings.form_add_bsmv'
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/ControllerOIV.cfm' WHERE FULL_FUSEACTION = 'settings.form_add_oiv'
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/ControllerOTV.cfm' WHERE FULL_FUSEACTION = 'settings.form_add_otv'
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/ControllerTAX.cfm' WHERE FULL_FUSEACTION = 'settings.form_add_tax'
</querytag>