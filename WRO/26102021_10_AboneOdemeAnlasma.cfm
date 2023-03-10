<!-- Description :  Abone ödeme anlaşma satırları
Developer: Fatih Kara
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SUBSCRIPTION_PAYMENT_PLAN_ROW' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='CONTRACT_ID')
    BEGIN
        ALTER TABLE SUBSCRIPTION_PAYMENT_PLAN_ROW
        ADD CONTRACT_ID INT NULL
    END;
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SUBSCRIPTION_PAYMENT_PLAN' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='CONTRACT_ID')
    BEGIN
        ALTER TABLE SUBSCRIPTION_PAYMENT_PLAN
        ADD CONTRACT_ID INT NULL
    END;
</querytag>