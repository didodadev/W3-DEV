<!-- Description : Ödeme Planı Tablosuna Ödeme Planı Importdan gelenler için IMPORT ID eklenmesi ve Açıklama
Developer: Tolga Sütlü
Company : Devonomy
Destination: Company-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SUBSCRIPTION_PAYMENT_PLAN_ROW' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ROW_ID')
        BEGIN
                ALTER TABLE SUBSCRIPTION_PAYMENT_PLAN_ROW ADD 
                SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ROW_ID  int NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SUBSCRIPTION_PAYMENT_PLAN_ROW' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'ROW_DESCRIPTION')
        BEGIN
                ALTER TABLE SUBSCRIPTION_PAYMENT_PLAN_ROW ADD 
                ROW_DESCRIPTION  nvarchar(200) NULL
        END;
</querytag>


		


