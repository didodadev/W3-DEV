<!-- Description : Employee_puantaj_rows tablosuna 5746 kanunu için damga vergisi velir vergisi ve ssk matrah kolonu açıldı.
Developer: Yunus Özay
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME='DAMGA_VERGISI_MATRAH_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        DAMGA_VERGISI_MATRAH_5746 float NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME='GELIR_VERGISI_MATRAH_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        GELIR_VERGISI_MATRAH_5746 float NULL
    END;  
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME='SSK_MATRAH_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        SSK_MATRAH_5746 float NULL
    END;  
</querytag>