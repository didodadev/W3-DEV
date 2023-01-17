<!-- Description : SURVEY_MAIN tablosuna SURVEY_PERIOD kolonu eklendi.
Developer: Yunus Özay
Company : Team Yazılım
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'SURVEY_MAIN' AND COLUMN_NAME = 'SURVEY_PERIOD')
    BEGIN
        ALTER TABLE SURVEY_MAIN ADD SURVEY_PERIOD int NULL
    END;
</querytag>