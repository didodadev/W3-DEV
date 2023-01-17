<!--Description : MEMBER_ANALYSIS tablosu Google Forms Url alanı eklendi.
Developer: Doğukan Adıgüzel
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MEMBER_ANALYSIS' AND COLUMN_NAME = 'GOOGLE_FORMS_URL')
    BEGIN
    ALTER TABLE MEMBER_ANALYSIS ADD
    GOOGLE_FORMS_URL nvarchar(500) NULL
    END;
</querytag>