<!-- Description : WRK_OUTPUT_TEMPLATES Tablosuna yeni alanlar eklendi.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='USE_LOGO')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD USE_LOGO bit NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='USE_ADRESS')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD USE_ADRESS bit NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='PAGE_WIDTH')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD PAGE_WIDTH float NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='PAGE_HEIGHT')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD PAGE_HEIGHT float NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='PAGE_MARGIN_LEFT')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD PAGE_MARGIN_LEFT float NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='PAGE_MARGIN_RIGHT')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD PAGE_MARGIN_RIGHT float NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='PAGE_MARGIN_TOP')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD PAGE_MARGIN_TOP float NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='PAGE_MARGIN_BOTTOM')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD PAGE_MARGIN_BOTTOM float NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='PAGE_HEADER_HEIGHT')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD PAGE_HEADER_HEIGHT float NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='PAGE_FOOTER_HEIGHT')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD PAGE_FOOTER_HEIGHT float NULL;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WRK_OUTPUT_TEMPLATES' AND COLUMN_NAME='RULE_UNIT')
    BEGIN
        ALTER TABLE WRK_OUTPUT_TEMPLATES ADD RULE_UNIT int NULL;
    END;
</querytag>