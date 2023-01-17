<!-- Description : Gunluk Bakım Planı Ve Bakım Planı Legacy Kaldirildi.
Developer: Murat Can Aygüneş
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'assetcare.list_assetp_period'
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'assetcare.dsp_care_calender'
</querytag>