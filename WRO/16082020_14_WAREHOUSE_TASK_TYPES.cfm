<!-- Description : WAREHOUSE_TASK_TYPES tablosu oluşturuldu
Developer: EMİNE YILMAZ
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WAREHOUSE_TASK_TYPES' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [WAREHOUSE_TASK_TYPES](
            [WAREHOUSE_TASK_TYPE_ID] [int] IDENTITY(1,1) NOT NULL,
            [WAREHOUSE_TASK_TYPE] [nvarchar](100) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [WAREHOUSE_TASK_TYPE_ORDER] [int] NULL,
            [WAREHOUSE_TASK_TYPE_DETAIL] [nvarchar](500) NULL
        ) ON [PRIMARY]
    END;
</querytag>
