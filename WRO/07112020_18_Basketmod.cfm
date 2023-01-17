<!-- Description :  Basket mod özelliği page designere eklende
Developer: Halit Yurttaş
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_BASKET' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='BASKET_MOD')
    BEGIN
        ALTER TABLE SETUP_BASKET ADD
        BASKET_MOD int NULL
    END;
</querytag>