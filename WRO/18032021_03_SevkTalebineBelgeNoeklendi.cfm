<!-- Description : Sevk Talebine Paper No eklendi.
Developer: Gülbahar İnan
Company : Workcube
Destination: period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SHIP_INTERNAL' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PAPER_NO')
    BEGIN
        ALTER TABLE SHIP_INTERNAL ADD
        PAPER_NO nvarchar(50) NULL
    END
</querytag>