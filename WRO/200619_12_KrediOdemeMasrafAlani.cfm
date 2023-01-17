<!-- Description : Bank Actions tablosunda masrafın dövizli karşılığının tutulması için alan eklendi.
Developer: İlker Altındal
Company : Workcube
Destination: Period-->
<querytag>
   IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'BANK_ACTIONS' AND COLUMN_NAME = 'OTHER_COST')
   BEGIN 
      ALTER TABLE BANK_ACTIONS ADD OTHER_COST float
   END;
</querytag>