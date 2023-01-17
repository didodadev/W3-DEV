<!-- Description : Ürün Karma Koli full_fusection yollu değiştirildi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE 
        WRK_OBJECTS 
    SET
        FULL_FUSEACTION = 'product.dsp_karma_contents'
    WHERE
        FULL_FUSEACTION='product.popup_dsp_karma_contents'

</querytag>