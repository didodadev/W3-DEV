<!-- Description : Ek bilgi Gdpr Yetki Alanı.
Developer: Gülbahar Inan
Company : Workcube
Destination: company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY1_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY1_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY2_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY2_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY3_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY3_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY4_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY4_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY5_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY5_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY6_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY6_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY7_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY7_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY8_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY8_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY9_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY9_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY10_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY10_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY11_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY11_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY12_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY12_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY13_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY13_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY14_GDPR')
        BEGIN 
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY14_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY15_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY15_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY16_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY16_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY17_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY17_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY18_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY18_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY19_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY19_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY20_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY20_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY21_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY21_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY22_GDPR')
    BEGIN
    ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
    PROPERTY22_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY23_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY23_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY24_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY24_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY25_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY25_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY26_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY26_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY27_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY27_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY28_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY28_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY29_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY29_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY30_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY30_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY31_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY31_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY32_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY32_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY33_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY33_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY34_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY34_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY35_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY35_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY36_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY36_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY37_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY37_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY38_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY38_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY39_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY39_GDPR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY40_GDPR')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY40_GDPR int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY1_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY1_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY2_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY2_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY3_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY3_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY4_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY4_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY5_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY5_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY6_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY6_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY7_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY7_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY8_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY8_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY9_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY9_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY10_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY10_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY11_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY11_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY12_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY12_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY13_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY13_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY14_MASK')
        BEGIN 
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY14_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY15_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY15_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY16_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY16_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY17_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY17_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY18_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY18_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY19_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY19_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY20_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY20_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY21_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY21_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY22_MASK')
    BEGIN
    ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
    PROPERTY22_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY23_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY23_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY24_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY24_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY25_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY25_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY26_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY26_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY27_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY27_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY28_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY28_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY29_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY29_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY30_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY30_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY31_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY31_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY32_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY32_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY33_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY33_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY34_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY34_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY35_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY35_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY36_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY36_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY37_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY37_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY38_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY38_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY39_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY39_MASK bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PROPERTY40_MASK')
        BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD
        PROPERTY40_MASK bit NULL
    END;
</querytag>