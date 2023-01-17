
<!-- Description : COMPANY_PARTNER_DENIED Tablosu Proteine Göre Düzenlendi
Developer: Semih Akartuna
Company : Yazımsa
Destination: main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'COMPANY_PARTNER_DENIED' AND COLUMN_NAME = 'CONSUMER_ID')
    BEGIN
        ALTER TABLE COMPANY_PARTNER_DENIED ADD
        CONSUMER_CAT_ID int NULL,
        CONSUMER_ID int NULL
    END;
</querytag>