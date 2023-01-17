<!-- Description : LOT_NO_COUNTER tablosu eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Product -->
<querytag>
    IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LOT_NO_COUNTER' ) )
    BEGIN
       CREATE TABLE [LOT_NO_COUNTER](
        [LOT_NO] [nvarchar](100) NOT NULL,
        [STOCK_ID] [int] NOT NULL,
        [LOT_NUMBER] [nvarchar](50) NOT NULL
    ) ON [PRIMARY]
    
    END;
</querytag>