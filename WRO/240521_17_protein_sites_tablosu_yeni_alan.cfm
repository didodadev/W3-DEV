<!-- Description : PROTEIN_SITES Tablosu plevne was için security kolunu eklendi
Developer: Semih Akartuna
Company : Yazılımsa
Destination: main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROTEIN_SITES' AND COLUMN_NAME = 'SECURITY_DATA' AND TABLE_SCHEMA = '@_dsn_@')
    BEGIN
        ALTER TABLE PROTEIN_SITES ADD
        SECURITY_DATA text NULL
    END;
</querytag>