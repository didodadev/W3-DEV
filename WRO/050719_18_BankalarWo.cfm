<!-- Description : Genel Ayarlar sayfasının altında Bankalar sayfasının görünmesi sağlanıldı.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE 
        WRK_OBJECTS 
    SET
        HEAD = 'Bankalar', 
        DICTIONARY_ID = 57987,
        STANDART_ADDON = 7,
        LICENCE = 1,
        EVENT_TYPE = 2
    WHERE
        FULL_FUSEACTION='settings.form_add_bank_type'

</querytag>