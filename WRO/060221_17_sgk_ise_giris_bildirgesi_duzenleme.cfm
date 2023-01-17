<!-- Description : Description : Holictic menüde Sgk İşe Giriş Bildirgesi sayfası tipi değiştirildi. 
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'ehesap.popup_ssk_start_work') 
    BEGIN
        UPDATE WRK_OBJECTS SET TYPE = 10 WHERE FULL_FUSEACTION = 'ehesap.popup_ssk_start_work'
    END;

    IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'ehesap.popup_job_entry_declaration') 
    BEGIN
        UPDATE WRK_OBJECTS SET TYPE = 0 WHERE FULL_FUSEACTION = 'ehesap.popup_job_entry_declaration'
    END;
</querytag>