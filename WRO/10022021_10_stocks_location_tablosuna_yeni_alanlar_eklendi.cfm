<!-- Description :  STOCKS_LOCATION tablosuna yeni alanlar eklendi
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='STOCKS_LOCATION' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='TEMPERATURE')
    BEGIN
        ALTER TABLE STOCKS_LOCATION
        ADD TEMPERATURE float NULL
    END;
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='STOCKS_LOCATION' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='PRESSURE')
    BEGIN
        ALTER TABLE STOCKS_LOCATION
        ADD PRESSURE float NULL
    END;
</querytag>