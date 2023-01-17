<!-- Description :Icra Islemleri sayfasına alan eklendi..(2.Amir onay)
Developer: Gülbahar Inan
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY_LAW_REQUEST' AND COLUMN_NAME = 'CARI_ACTION_ID')
    BEGIN
    ALTER TABLE COMPANY_LAW_REQUEST ADD 
        CARI_ACTION_ID int NULL
    END;
</querytag>