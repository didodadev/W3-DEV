<!-- Description : SALARYPARAM_GET ALAN eklenmesi
Developer: Pınar Yıldız
Company : Workcube
Destination: Main-->
<querytag>
   IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SALARYPARAM_GET' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
   BEGIN
      IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SALARYPARAM_GET' AND COLUMN_NAME = 'RELATED_TABLE')
      BEGIN
      ALTER TABLE SALARYPARAM_GET ADD 
      RELATED_TABLE nvarchar(200)
      END
   END
</querytag>