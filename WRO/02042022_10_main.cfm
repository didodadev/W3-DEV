<!-- Description : Holistic.22 main objects
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>  
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WORKNET_RELATION_COMPANY' AND COLUMN_NAME = 'WORKNET_DOMAIN')
    BEGIN
        ALTER TABLE WORKNET_RELATION_COMPANY ADD WORKNET_DOMAIN nvarchar(250);
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'INCLUDED_IN_TAX')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD INCLUDED_IN_TAX bit;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER' AND COLUMN_NAME = 'IS_ACCOUNTS')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER ADD IS_ACCOUNTS bit;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER' AND COLUMN_NAME = 'IS_CONTACTS')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER ADD IS_CONTACTS bit;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER' AND COLUMN_NAME = 'IS_EMPLOYEE')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER ADD IS_EMPLOYEE bit;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER' AND COLUMN_NAME = 'OUR_COMPANY_ID')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER ADD OUR_COMPANY_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER_COMMITTEE' AND COLUMN_NAME = 'EMPLOYEE_ID')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER_COMMITTEE ADD EMPLOYEE_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER_COMMITTEE' AND COLUMN_NAME = 'ROLE_ID')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER_COMMITTEE ADD ROLE_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER_COMMITTEE' AND COLUMN_NAME = 'CONSUMER_ID')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER_COMMITTEE ADD CONSUMER_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER_COMMITTEE' AND COLUMN_NAME = 'COMPANY_ID')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER_COMMITTEE ADD COMPANY_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'GDPR_DATA_OFFICER_COMMITTEE' AND COLUMN_NAME = 'PARTNER_ID')
    BEGIN
        ALTER TABLE GDPR_DATA_OFFICER_COMMITTEE ADD PARTNER_ID int;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'REFINERY_LAB_TESTS' AND COLUMN_NAME = 'PRODUCT_SAMPLE_ID')
    BEGIN
        ALTER TABLE REFINERY_LAB_TESTS ADD PRODUCT_SAMPLE_ID int;
    END;
</querytag>