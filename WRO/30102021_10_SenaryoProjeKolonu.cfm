<!-- Description : Senaryo Proje Kolonu
Developer: Fatih Kara
Company : Workcube
Destination: Company-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SCEN_EXPENSE_PERIOD_ROWS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROJECT_ID')
    BEGIN
            ALTER TABLE SCEN_EXPENSE_PERIOD_ROWS ADD PROJECT_ID int NULL
    END;
</querytag>