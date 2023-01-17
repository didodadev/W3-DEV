<!-- Description : Eğitim - İş Tecrübesi Dil Bölümüne Belge Adı, Belge Tarihi ve Dil puanı eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_APP_LANGUAGE' AND COLUMN_NAME='PAPER_NAME')
    BEGIN
        ALTER TABLE EMPLOYEES_APP_LANGUAGE ADD
        PAPER_NAME nvarchar(250) NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_APP_LANGUAGE' AND COLUMN_NAME='PAPER_DATE')
    BEGIN
        ALTER TABLE EMPLOYEES_APP_LANGUAGE ADD
        PAPER_DATE datetime NULL
    END;  
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_APP_LANGUAGE' AND COLUMN_NAME='LANG_POINT')
    BEGIN
        ALTER TABLE EMPLOYEES_APP_LANGUAGE ADD
        LANG_POINT float NULL
    END;  
</querytag>