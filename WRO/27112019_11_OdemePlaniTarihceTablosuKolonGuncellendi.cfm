<!-- Description : Ödeme Planı Tarihçe tablosu detay kolonu değeri değiştirildi.
Developer: Canan Ebret
Company : Workcube
Destination: Company -->
<querytag>
    IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL')
    BEGIN
    ALTER TABLE @_dsn_company_@.SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL ALTER 
    COLUMN DETAIL NVARCHAR(100) NULL 
    END
</querytag>
