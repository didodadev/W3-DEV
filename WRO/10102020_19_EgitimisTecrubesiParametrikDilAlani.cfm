<!-- Description : Eğitim - İş Tecrübesi Dil Bölümüne Parametrik Belge Adı eklendi.
Developer: Gülbahar İnan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_APP_LANGUAGE' AND COLUMN_NAME='LANG_PAPER_NAME')
    BEGIN
        ALTER TABLE EMPLOYEES_APP_LANGUAGE ADD
        LANG_PAPER_NAME int NULL
    END;
</querytag>