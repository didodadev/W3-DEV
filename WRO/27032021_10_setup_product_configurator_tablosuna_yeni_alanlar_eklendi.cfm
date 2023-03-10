<!-- Description : SETUP_PRODUCT_CONFIGURATOR tablosuna yeni kolonlar eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Company -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SETUP_PRODUCT_CONFIGURATOR' AND COLUMN_NAME='ORIGIN')
    BEGIN
        ALTER TABLE SETUP_PRODUCT_CONFIGURATOR ADD
        ORIGIN int NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SETUP_PRODUCT_CONFIGURATOR' AND COLUMN_NAME='WIDGET_ID')
    BEGIN
        ALTER TABLE SETUP_PRODUCT_CONFIGURATOR ADD
        WIDGET_ID int NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SETUP_PRODUCT_CONFIGURATOR' AND COLUMN_NAME='BRAND_ID')
    BEGIN
        ALTER TABLE SETUP_PRODUCT_CONFIGURATOR ADD
        BRAND_ID int NULL
    END;

</querytag>
