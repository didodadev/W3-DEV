<!-- Description : Ek ödenek tablosuna harcırah id kolonu eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALARYPARAM_PAY' AND COLUMN_NAME = 'EXPENSE_PUANTAJ_ID')
    BEGIN
        ALTER TABLE SALARYPARAM_PAY ADD 
        EXPENSE_PUANTAJ_ID INT NULL
    END;
</querytag>