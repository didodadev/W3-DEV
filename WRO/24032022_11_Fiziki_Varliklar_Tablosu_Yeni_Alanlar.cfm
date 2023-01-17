<!-- Description : Fiziki varlıklar için, COORDINATE_1 ve COORDINATE_2 kolonları eklendi.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P' AND COLUMN_NAME = 'COORDINATE_1')
    BEGIN
        ALTER TABLE ASSET_P ADD 
        COORDINATE_1 float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P' AND COLUMN_NAME = 'COORDINATE_2')
    BEGIN
        ALTER TABLE ASSET_P ADD 
        COORDINATE_2 float NULL
    END;
</querytag>