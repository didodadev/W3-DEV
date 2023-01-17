<!-- Description : Çalışan ödenek sayfasına sağlık harcaması butonu eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SALARYPARAM_PAY' AND COLUMN_NAME='EXPENSE_HEALTH_ID')
    BEGIN
        ALTER TABLE SALARYPARAM_PAY ADD EXPENSE_HEALTH_ID int NULL
    END;
</querytag>