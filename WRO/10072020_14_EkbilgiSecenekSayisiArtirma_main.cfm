<!-- Description : Ek bilgi seçenekleri 40 adete çıkartıldı.
Developer: Gülbahar Inan
Company : Workcube
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY21_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY22_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY23_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY24_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY25_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY26_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY27_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY28_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY29_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY30_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY31_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY32_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY33_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY34_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY35_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY36_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY37_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY38_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY39_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40_NAME')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY40_NAME nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY21_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY22_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY23_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY24_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY25_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY26_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY27_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY28_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY29_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY30_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY31_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY32_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY33_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY34_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY35_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY36_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY37_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY38_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY39_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40_REQ')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY40_REQ bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY21_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY22_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY23_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY24_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY25_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY26_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY27_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY28_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY29_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY30_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY31_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY32_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY33_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY34_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY35_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY36_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY37_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY38_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY39_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40_TYPE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY40_TYPE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY21_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY22_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY23_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY24_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY25_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY26_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY27_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY28_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY29_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY30_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY31_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY32_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY33_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY34_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY35_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY36_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY37_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY38_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY39_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40_RANGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY40_RANGE nvarchar(43) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY21_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY22_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY23_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY24_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY25_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY26_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY27_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY28_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY29_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY30_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY31_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY32_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY33_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY34_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY35_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY36_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY37_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY38_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY39_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40_MESSAGE')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY40_MESSAGE nvarchar(250) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY21_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY22_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY23_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY24_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY25_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY26_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY27_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY28_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY29_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY30_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY31_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY32_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY33_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY34_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY35_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY36_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY37_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY38_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY39_NO int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_INFOPLUS_NAMES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40_NO')
        BEGIN
        ALTER TABLE SETUP_INFOPLUS_NAMES ADD
        PROPERTY40_NO int NULL
    END;
</querytag>
