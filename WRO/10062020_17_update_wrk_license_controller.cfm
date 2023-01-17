<!-- Description : Update wrk license information controller
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/WorkcubeLicense.cfm' WHERE FULL_FUSEACTION = 'settings.workcube_license' 
</querytag>