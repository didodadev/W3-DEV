<!-- Description : Bütçe planlama fişine fatura id eklendi.
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BUDGET_PLAN' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'INVOICE_ID')
        BEGIN
            ALTER TABLE BUDGET_PLAN ADD INVOICE_ID INT
        END;
</querytag>
