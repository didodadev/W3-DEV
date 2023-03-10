<!-- Description : IS_EXPENSING_BSMV ve DIRECT_EXPENSE_CODE alanları açıldı
Developer: Uğur Hamurpet
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PROCESS_CAT' AND COLUMN_NAME = 'IS_EXPENSING_BSMV' )
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD IS_EXPENSING_BSMV BIT NULL DEFAULT 0
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_BSMV' AND COLUMN_NAME = 'DIRECT_EXPENSE_CODE' )
    BEGIN
        ALTER TABLE SETUP_BSMV ADD DIRECT_EXPENSE_CODE nvarchar(50) NULL
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_BSMV' AND COLUMN_NAME = 'EXPENSE_ITEM_ID' )
    BEGIN
        ALTER TABLE SETUP_BSMV ADD EXPENSE_ITEM_ID int NULL
    END
</querytag>