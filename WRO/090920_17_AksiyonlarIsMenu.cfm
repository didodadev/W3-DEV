<!-- Description :Hediye Çeki ve Promosyonlar show_menu özelliği değiştirildi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'sales.list_money_credits') 
    BEGIN
        UPDATE WRK_OBJECTS SET IS_MENU = 0 WHERE FULL_FUSEACTION = 'sales.list_money_credits'
    END;
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'sales.list_money_credits_gift') 
    BEGIN
        UPDATE WRK_OBJECTS SET IS_MENU = 0 WHERE FULL_FUSEACTION = 'sales.list_money_credits_gift'
    END;
</querytag>