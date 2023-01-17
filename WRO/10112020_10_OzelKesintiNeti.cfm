<!-- Description : Brüt kesinti neti için yeni alan açıldı
Developer: Esma R. Uysal
Company : Workcube
Destination: main-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'OZEL_KESINTI_2_NET')
        BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD 
        OZEL_KESINTI_2_NET float
        END;
</querytag>