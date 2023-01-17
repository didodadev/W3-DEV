<!-- Description : Eğitim bilgileri sayfası, Başlangıç ve Bitiş yılı kolonları tarih formatına çevrildi.
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_APP_EDU_INFO' AND COLUMN_NAME = 'EDU_START')
    BEGIN
        ALTER TABLE EMPLOYEES_APP_EDU_INFO
        ALTER COLUMN EDU_START datetime;
    END
     IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_APP_EDU_INFO' AND COLUMN_NAME = 'EDU_FINISH')
    BEGIN
        ALTER TABLE EMPLOYEES_APP_EDU_INFO
        ALTER COLUMN EDU_FINISH datetime;
    END
</querytag>