<!-- Description : Sabit icra tutarı için, COMMANDMENT ve COMMANDMENT_HISTORY tablolarına, RATE_VALUE_STATIC kolonu eklendi.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'COMMANDMENT' AND COLUMN_NAME = 'RATE_VALUE_STATIC')
    BEGIN
        ALTER TABLE COMMANDMENT ADD 
        RATE_VALUE_STATIC float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'COMMANDMENT_HISTORY' AND COLUMN_NAME = 'RATE_VALUE_STATIC')
    BEGIN
        ALTER TABLE COMMANDMENT_HISTORY ADD 
        RATE_VALUE_STATIC float NULL
    END;
</querytag>