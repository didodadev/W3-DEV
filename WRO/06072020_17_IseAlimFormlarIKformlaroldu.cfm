<!-- Description : İşe Alım Formlar sayfası IK Formlar olarak değiştirildi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE 
        WRK_OBJECTS 
    SET
        HEAD = 'Ik Formlar', 
        DICTIONARY_ID = 61026
    WHERE
        FULL_FUSEACTION='hr.list_detail_survey_report'
</querytag>