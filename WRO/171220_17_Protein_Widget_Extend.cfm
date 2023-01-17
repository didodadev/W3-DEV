<!-- Description : PROTEIN_WIDGETS Tablosuna WIDGET_EXTEND Alanı Açıldı
Developer: Semih Akartuna
Company : Yazılımsa
Destination: main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PROTEIN_WIDGETS' AND COLUMN_NAME = 'WIDGET_EXTEND')
    BEGIN
        ALTER TABLE PROTEIN_WIDGETS ADD
        WIDGET_EXTEND nvarchar(250) NULL
    END;   
</querytag>