﻿<!-- Description : Ek bilgi seçenekleri 40 adete çıkartıldı.
Developer: Yücel AYDIN
Company : Mifa Bilgi Sistemleri
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY21 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY22 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY23 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY24 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY25 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY26 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY27 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY28 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY29 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY30 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY31 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY32 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY33 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY34 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY35 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY36 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY37 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY38 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY39 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40')
        BEGIN
        ALTER TABLE INFO_PLUS ADD
        PROPERTY40 nvarchar(500) NULL
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY21 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY22 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY23 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY24 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY25 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY26 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY27 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY28 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY29 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY30 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY31 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY32 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY33 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY34 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY35 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY36 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY37 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY38 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY39 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INFO_PLUS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40')
        BEGIN
        ALTER TABLE INFO_PLUS_HISTORY ADD
        PROPERTY40 nvarchar(500) NULL
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY21')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY21 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY22')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY22 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY23')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY23 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY24')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY24 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY25')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY25 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY26')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY26 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY27')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY27 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY28')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY28 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY29')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY29 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY30')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY30 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY31')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY31 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY32')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY32 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY33')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY33 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY34')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY34 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY35')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY35 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY36')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY36 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY37')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY37 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY38')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY38 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY39')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY39 nvarchar(500) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'PROPERTY40')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS ADD
        PROPERTY40 nvarchar(500) NULL
    END;
</querytag>