<!-- Description : PROTEIN_WIDGETS Tablosuna WIDGET_SEO_DATA Alanı Açıldı
Developer: Semih Akartuna
Company : Yazılımsa
Destination: main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PROTEIN_WIDGETS' AND COLUMN_NAME = 'WIDGET_SEO_DATA')
    BEGIN
        ALTER TABLE PROTEIN_WIDGETS ADD
        WIDGET_SEO_DATA nvarchar(MAX) NULL
    END;   
</querytag>