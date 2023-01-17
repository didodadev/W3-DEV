<!-- Description : Ürüne muhasebe kodlarına alış ve satış ödeme yöntemi
Developer: Tolga Sütlü
Company : Devonomy
Destination: Company-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'SALES_PAYMETHOD_ID')
        BEGIN
                ALTER TABLE PRODUCT_PERIOD ADD 
                SALES_PAYMETHOD_ID  int NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PURCHASE_PAYMETHOD_ID')
        BEGIN
                ALTER TABLE PRODUCT_PERIOD ADD 
                PURCHASE_PAYMETHOD_ID  int NULL
        END;
</querytag>


		


