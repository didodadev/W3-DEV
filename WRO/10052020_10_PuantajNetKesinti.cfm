<!-- Description : Puantaj tablosunda net kesintiler için yeni alan açıldı.
Developer: Yunus Özay
Company : Team Yazılım
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'OZEL_KESINTI_2_NET_FARK ')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        OZEL_KESINTI_2_NET_FARK  float NULL
    END;
</querytag>