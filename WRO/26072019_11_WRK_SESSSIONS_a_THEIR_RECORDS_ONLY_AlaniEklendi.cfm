<!-- Description : WRK_SESSION tablosuna THEIR_RECORDS_ONLY kolonu eklendi
Developer: Cemil Durgan
Company : Workcube
Destination: Main -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SESSION' AND COLUMN_NAME = 'THEIR_RECORDS_ONLY')
        BEGIN
        ALTER TABLE WRK_SESSION ADD 
        THEIR_RECORDS_ONLY [bit] NULL
        END
</querytag>