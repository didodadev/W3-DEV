<!-- Description : Arge Bordrosu için Puantaj tablolarında yeni kolonlar ve açıldı.
Developer: Yunus Özay
Company : Team Yazılım
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'DAMGA_VERGISI_INDIRIMI_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        DAMGA_VERGISI_INDIRIMI_5746 float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALARYPARAM_PAY' AND COLUMN_NAME = 'IS_RD_DAMGA')
    BEGIN
        ALTER TABLE SALARYPARAM_PAY ADD
        IS_RD_DAMGA bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALARYPARAM_PAY' AND COLUMN_NAME = 'IS_RD_GELIR')
    BEGIN
        ALTER TABLE SALARYPARAM_PAY ADD
        IS_RD_GELIR int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALARYPARAM_PAY' AND COLUMN_NAME = 'IS_RD_SSK')
    BEGIN
        ALTER TABLE SALARYPARAM_PAY ADD
        IS_RD_SSK int NULL
    END;
</querytag>