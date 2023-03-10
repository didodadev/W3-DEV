<!-- Description : Gelir fişi İstisna alanları
Developer: Fatih Ayık
Company : ForceBT
Destination: Period -->

<querytag>
   IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='EXPENSE_ITEMS_ROWS' AND COLUMN_NAME='REASON_NAME')
   BEGIN
      ALTER TABLE EXPENSE_ITEMS_ROWS
      ADD REASON_NAME nvarchar(250);
   END;

   IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='EXPENSE_ITEMS_ROWS' AND COLUMN_NAME='REASON_CODE')
   BEGIN
      ALTER TABLE EXPENSE_ITEMS_ROWS
      ADD REASON_CODE nvarchar(10);
   END;
</querytag>