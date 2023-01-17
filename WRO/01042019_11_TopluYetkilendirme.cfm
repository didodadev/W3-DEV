<!-- Description : Toplu yetkilendime linki sol menüden kaldırıldı.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_MENU = 0 WHERE FULL_FUSEACTION = 'objects.popup_list_positions_poweruser'
</querytag>
