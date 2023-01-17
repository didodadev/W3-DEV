<!-- Description : Holistic için popup sayfası pasife alındı.
Developer: Gülbahar İnan
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_ACTIVE = 0, IS_MENU = 0 WHERE FULL_FUSEACTION = 'account.popup_list_period'
</querytag>