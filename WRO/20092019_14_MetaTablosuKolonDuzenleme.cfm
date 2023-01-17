<!-- Description : İçerik sayfasında meta tanımlamalarında hata verdiğinden dolayı kolon genişlikleri arttırıldı.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='META_DESCRIPTIONS' AND COLUMN_NAME='META_TITLE')
    BEGIN
        ALTER TABLE META_DESCRIPTIONS
        ALTER COLUMN META_TITLE nvarchar(MAX)
    END;

    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='META_DESCRIPTIONS' AND COLUMN_NAME='META_KEYWORDS')
    BEGIN
        ALTER TABLE META_DESCRIPTIONS
        ALTER COLUMN META_KEYWORDS nvarchar(MAX)
    END;

    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='META_DESCRIPTIONS' AND COLUMN_NAME='META_DESC_HEAD')
    BEGIN
        ALTER TABLE META_DESCRIPTIONS
        ALTER COLUMN META_DESC_HEAD nvarchar(MAX)
    END;

    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='META_DESCRIPTIONS' AND COLUMN_NAME='ACTION_TYPE')
    BEGIN
        ALTER TABLE META_DESCRIPTIONS
        ALTER COLUMN ACTION_TYPE nvarchar(250)
    END;

    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='META_DESCRIPTIONS' AND COLUMN_NAME='LANGUAGE_SHORT')
    BEGIN
        ALTER TABLE META_DESCRIPTIONS
        ALTER COLUMN LANGUAGE_SHORT nvarchar(250)
    END;

    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='META_DESCRIPTIONS' AND COLUMN_NAME='FUSEACTION')
    BEGIN
        ALTER TABLE META_DESCRIPTIONS
        ALTER COLUMN FUSEACTION nvarchar(250)
    END;
</querytag>