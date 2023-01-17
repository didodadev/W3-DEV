<!-- Description : PRODUCTION_ORDERS tablosuna QUANTITY_2 ve UNIT_2 alanları eklendi.
Developer: Fatih Ekin
Company : Gramoni
Destination: company -->

<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCTION_ORDERS' AND COLUMN_NAME = 'QUANTITY_2' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        ALTER TABLE PRODUCTION_ORDERS
        ADD QUANTITY_2 int;
    END;   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCTION_ORDERS' AND COLUMN_NAME = 'UNIT_2' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        ALTER TABLE PRODUCTION_ORDERS
        ADD UNIT_2 nvarchar(50);
    END;     
</querytag>