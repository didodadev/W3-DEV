<!-- Description : Üretim sonuç ekranlarına lot un yanına son kullanım tarihi eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Company-->
<querytag>
   
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS' AND COLUMN_NAME = 'EXPIRATION_DATE')
        BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS ADD 
        EXPIRATION_DATE datetime
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'EXPIRATION_DATE')
        BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD 
        EXPIRATION_DATE datetime
        END;
</querytag>