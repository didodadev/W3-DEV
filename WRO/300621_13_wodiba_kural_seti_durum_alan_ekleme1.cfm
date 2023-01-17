<!-- Description : WoDiBa kural seti tablosuna durum alanı eklendi1.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>
  IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WODIBA_RULE_SET_ROWS' AND COLUMN_NAME = 'STATUS' )
  BEGIN
      ALTER TABLE WODIBA_RULE_SET_ROWS ADD [STATUS] [bit] NULL
  END;
</querytag>