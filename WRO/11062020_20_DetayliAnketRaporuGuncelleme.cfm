<!-- Description : Detaylı anket raporu standart raporlar altına alındı..
Developer: Gülbahar
Company : Workcube
Destination: Main-->
<querytag>
    UPDATE 
        WRK_OBJECTS 
    SET    
        FULL_FUSEACTION = 'report.list_employee_survey_detail',
        IS_ACTIVE = 1,
        MODULE_NO =66,
        TYPE=8
    WHERE 
        FULL_FUSEACTION = 'settings.list_employee_survey_detail'
</querytag>