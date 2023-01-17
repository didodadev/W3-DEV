<!-- Description : Add PAPER_NO TO PAGE_WARNINGS
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'PAPER_NO')
    BEGIN
        ALTER TABLE PAGE_WARNINGS ADD 
        PAPER_NO nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE PAGE_WARNINGS 
        ALTER COLUMN PAPER_NO nvarchar(50)
    END
</querytag>