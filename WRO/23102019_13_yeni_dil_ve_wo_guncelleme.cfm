
<!-- Description :dashboard_list sayfası için dil eklendi ve type dashboard olmayan sayfaların type'ları değiştirildi.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Dashboard Welcome', ITEM_TR='Dashboard Welcome', ITEM_ENG='Dashboard Welcome' WHERE DICTIONARY_ID = 51637
    UPDATE WRK_OBJECTS SET TYPE = 13 WHERE FULL_FUSEACTION = 'report.business_family_using'
    UPDATE WRK_OBJECTS SET TYPE = 13 WHERE FULL_FUSEACTION = 'report.project_work_board'
    UPDATE WRK_OBJECTS SET TYPE = 13 WHERE FULL_FUSEACTION = 'call.dashboard'
</querytag>