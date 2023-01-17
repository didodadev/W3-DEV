<!-- Description : Project material sayfası cfcye bağlandığından query sayfalarına bağlı wolar silindi
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main -->
<querytag>
    DELETE FROM WRK_OBJECTS  where FULL_FUSEACTION = 'project.emptypopup_add_project_material'
    DELETE FROM WRK_OBJECTS where FULL_FUSEACTION = 'project.emptypopup_upd_project_material'
<querytag>