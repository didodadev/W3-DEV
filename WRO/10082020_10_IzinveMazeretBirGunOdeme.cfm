<!-- Description : İzin ve Mazeret Kategorisi için 1 günü şirket öder parametresi eklendi.
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'PAID_A_DAY')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        PAID_A_DAY bit NULL
    END;
</querytag>