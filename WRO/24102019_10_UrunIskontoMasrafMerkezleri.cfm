<!-- Description : Ürün Muhasebe Kod yapısına iskonto masraf merkezi gider kalemi eklenmesi
Developer: Tolga Sütlü
Company : Devonomy
Destination: Company-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'DISCOUNT_EXPENSE_CENTER_ID ')
        BEGIN
                ALTER TABLE PRODUCT_PERIOD ADD 
                DISCOUNT_EXPENSE_CENTER_ID  int NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'DISCOUNT_EXPENSE_ITEM_ID ')
        BEGIN
                ALTER TABLE PRODUCT_PERIOD ADD 
                DISCOUNT_EXPENSE_ITEM_ID  int NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'DISCOUNT_ACTIVITY_TYPE_ID ')
        BEGIN
                ALTER TABLE PRODUCT_PERIOD ADD 
                DISCOUNT_ACTIVITY_TYPE_ID  int NULL
        END;
</querytag>