<!-- Description : Etkileşimlere PROCESS_CAT alanı açıldı
Developer: Gülbahar İnan
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'CUSTOMER_HELP' AND COLUMN_NAME = 'PROCESS_CAT' )
    BEGIN
        ALTER TABLE CUSTOMER_HELP ADD PROCESS_CAT INT NULL 
    END
</querytag>