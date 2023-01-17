<!-- Description : EMPLOYEE_POSITIONS tablosuna THEIR_RECORDS_ONLY kolonu eklendi
Developer: Cemil Durgan
Company : Workcube
Destination: Main -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEE_POSITIONS' AND COLUMN_NAME = 'THEIR_RECORDS_ONLY')
        BEGIN
        ALTER TABLE EMPLOYEE_POSITIONS ADD 
        THEIR_RECORDS_ONLY [bit] NULL
        END
</querytag>