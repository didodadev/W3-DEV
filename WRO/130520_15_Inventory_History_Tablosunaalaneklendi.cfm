<!-- Description : INVENTORY_HISTORY Tablolarına Yeni Alanları Eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INVENTORY_HISTORY' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'INVENTORY_DURATION_IFRS')
        BEGIN
            ALTER TABLE INVENTORY_HISTORY ADD INVENTORY_DURATION_IFRS INT NULL
        END;
</querytag>