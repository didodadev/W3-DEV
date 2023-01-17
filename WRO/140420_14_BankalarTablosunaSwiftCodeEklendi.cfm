<!-- Description : SETUP_BANK_TYPES tablosuna SWIFT_CODE alanı eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_BANK_TYPES' AND COLUMN_NAME = 'SWIFT_CODE')
    BEGIN
        ALTER TABLE SETUP_BANK_TYPES ADD
        SWIFT_CODE nvarchar(50) NULL
    END
</querytag>