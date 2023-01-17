<!-- Description : Target type eklendi.
Developer: Cemil Durgan
Company : Durgan
Destination: Main -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ACCOUNT_WIZARD' AND COLUMN_NAME = 'TARGET_TYPE')
        BEGIN
                ALTER TABLE ACCOUNT_WIZARD ADD 
                TARGET_TYPE int NULL
        END;
</querytag>