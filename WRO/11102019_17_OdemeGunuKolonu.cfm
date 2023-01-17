<!-- Description : Puantaj Sayfasına Ödeme Günü alanı eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ' AND COLUMN_NAME = 'PAYMENT_DATE')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ ADD
        PAYMENT_DATE datetime NULL
    END;
</querytag>