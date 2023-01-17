<!-- Description :  Setup_Invoice tablosuna yeni alan 
Developer: Gülbahar Inan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_INVOICE' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='IHRAC_K_F')
    BEGIN
        ALTER TABLE SETUP_INVOICE ADD IHRAC_K_F nvarchar(50);
    END
</querytag>