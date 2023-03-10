<!-- Description : holistic 21.5 sürümü tablolar ve kolon değişiklikleri
Developer: Fatih Kara
Company : Workcube
Destination: Main -->
<querytag>  
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'HEALTH_INSURANCE_PREMIUM_WORKER')
BEGIN
    ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD HEALTH_INSURANCE_PREMIUM_WORKER float;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'DEATH_INSURANCE_PREMIUM_WORKER')
BEGIN
    ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD DEATH_INSURANCE_PREMIUM_WORKER float;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'DEATH_INSURANCE_PREMIUM_EMPLOYER')
BEGIN
    ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD DEATH_INSURANCE_PREMIUM_EMPLOYER float;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'SHORT_TERM_PREMIUM_EMPLOYER')
BEGIN
    ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD SHORT_TERM_PREMIUM_EMPLOYER float;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'HEALTH_INSURANCE_PREMIUM_EMPLOYER')
BEGIN
    ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD HEALTH_INSURANCE_PREMIUM_EMPLOYER float;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_MUHTASAR_EXPORTS' AND COLUMN_NAME = 'TOTAL_FILE_NAME')
BEGIN
    ALTER TABLE EMPLOYEES_MUHTASAR_EXPORTS ADD TOTAL_FILE_NAME nvarchar(200);
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PAYROLL_JOB' AND COLUMN_NAME = 'STATUE_TYPE_INDIVIDUAL')
BEGIN
    ALTER TABLE PAYROLL_JOB ADD STATUE_TYPE_INDIVIDUAL int;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PRODUCT_TREE_TYPE' AND COLUMN_NAME = 'WASTE_RATE')
BEGIN
    ALTER TABLE PRODUCT_TREE_TYPE ADD WASTE_RATE float;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_SYSTEM_PARAMS' AND COLUMN_NAME = 'WSP_DOMAIN_WHOPS')
BEGIN
    ALTER TABLE WRK_SYSTEM_PARAMS ADD WSP_DOMAIN_WHOPS nvarchar(250);
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_PUANTAJ' AND COLUMN_NAME = 'STATUE_TYPE_INDIVIDUAL')
BEGIN
    ALTER TABLE EMPLOYEES_PUANTAJ ADD STATUE_TYPE_INDIVIDUAL int;
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SALARYPARAM_PAY' AND COLUMN_NAME = 'PAYMENT_STATUS')
BEGIN
    ALTER TABLE SALARYPARAM_PAY ADD PAYMENT_STATUS bit;
END;
IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_COOKIE' AND COLUMN_NAME = 'CGI_STRUCT')
BEGIN
    ALTER TABLE WRK_COOKIE ALTER COLUMN CGI_STRUCT text NULL;
END;
</querytag>