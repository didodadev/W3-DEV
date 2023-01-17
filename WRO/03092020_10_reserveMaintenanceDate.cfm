<!-- Description : sipariş rezerv bakım sayfası için şirket akış parametrelerinde tarih bilgisi tutuldu
Developer: Pınar Yıldız
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'OUR_COMPANY_INFO' AND COLUMN_NAME = 'STOCK_RESERVE_CLEAN_DATE')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO
		ADD STOCK_RESERVE_CLEAN_DATE  DATETIME
    END;
</querytag>