<!-- Description : ASSET_P_FUEL_PASSWORD tablosuna CARD_NO alanı eklendi.
Developer: Umut Burak Akgün
Company : Workcube
Destination: main -->

<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_P_FUEL_PASSWORD' AND COLUMN_NAME = 'CARD_NO' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        ALTER TABLE ASSET_P_FUEL_PASSWORD
        ADD CARD_NO nvarchar (50)
    END  
</querytag>