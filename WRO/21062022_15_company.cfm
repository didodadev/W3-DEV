<!-- Description : Holistic.22.1 Company objects
Developer: Fatih Kara
Company : Workcube
Destination: Company -->
<querytag>  
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'ICON_PATCH')
    BEGIN
    ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD ICON_PATCH nvarchar(50);    
    END;
</querytag>