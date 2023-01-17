<!--Description : health_expense tablosuna LIMB_ID alanı açıldı.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SURVEY_MAIN_RESULT' AND COLUMN_NAME = 'IS_SHOW_EMPLOYEE')
    BEGIN
        ALTER TABLE SURVEY_MAIN_RESULT ADD IS_SHOW_EMPLOYEE bit
    END
</querytag>