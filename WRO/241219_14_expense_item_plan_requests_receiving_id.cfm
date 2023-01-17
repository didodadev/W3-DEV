<!-- Description : Sağlık harcama talepleri ile gelen e-fatura ilişkilendirmesi için EXPENSE_ITEM_PLAN_REQUESTS tablosuna RECEIVING_ID alanı eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EXPENSE_ITEM_PLAN_REQUESTS' AND COLUMN_NAME = 'RECEIVING_ID')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLAN_REQUESTS ADD RECEIVING_ID int NULL
    END;
</querytag>