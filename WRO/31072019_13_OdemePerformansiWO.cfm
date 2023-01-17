<!-- Description : Yaşlandırma sayfası Ödeme performansı sayfası olarak isimi değiştirildi değiştirildi.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE 
        WRK_OBJECTS 
    SET
        HEAD = 'Ödeme Performansı (Yaşlandırma)', 
        DICTIONARY_ID = 49388
    WHERE
        FULL_FUSEACTION='ch.dsp_make_age'

</querytag>