<!-- Description : Satın alma talepleri sayfasına işlem kategorileri eklendi
Developer: Canan Ebret
Company : Workcube
Destination: Company-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INTERNALDEMAND' AND COLUMN_NAME = 'PROCESS_CAT')
        BEGIN
        ALTER TABLE INTERNALDEMAND ADD 
        PROCESS_CAT INT NULL
        END

</querytag>