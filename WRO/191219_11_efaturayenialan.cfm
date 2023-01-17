<!-- Description : gelen faturaya şube ve departman eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EINVOICE_RECEIVING_DETAIL' AND COLUMN_NAME = 'BRANCH_ID')
        BEGIN
                ALTER TABLE EINVOICE_RECEIVING_DETAIL
                ADD BRANCH_ID INT NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EINVOICE_RECEIVING_DETAIL' AND COLUMN_NAME = 'DEPARTMENT_ID')
        BEGIN
                ALTER TABLE EINVOICE_RECEIVING_DETAIL
                ADD DEPARTMENT_ID INT NULL
        END;
</querytag>