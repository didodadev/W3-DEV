<!-- Description : EMPLOYEES_PUANTAJ_ROWS Tablosu DAMGA_VERGISI_INDIRIMI_5746  kolonu float'a çevirildi. 
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'DAMGA_VERGISI_INDIRIMI_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        DAMGA_VERGISI_INDIRIMI_5746 float NULL;
    END
    ELSE
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS
        ALTER COLUMN DAMGA_VERGISI_INDIRIMI_5746 float;
    END
</querytag>