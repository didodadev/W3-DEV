<!-- Description : Retail FILE_IMPORTS
Developer: Gülbahar Erol
Company : Workcube
Destination: Period-->
<querytag>   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FILE_IMPORTS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'IS_TRANSFER')
    BEGIN
        ALTER TABLE FILE_IMPORTS ADD
        [IS_TRANSFER] [bit] NULL
    END;
</querytag>