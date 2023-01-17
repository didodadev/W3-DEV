<!-- Description : WoDiBa kural seti tanım tablosuna yeni alanlar eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WODIBA_RULE_SET_DEFINITIONS' AND COLUMN_NAME = 'REC_USER' )
    BEGIN
        ALTER TABLE WODIBA_RULE_SET_DEFINITIONS ADD [REC_USER] [int] NULL,
	[REC_DATE] [datetime] NULL,
	[REC_IP] [nvarchar](50) NULL,
	[UPD_USER] [int] NULL,
	[UPD_DATE] [datetime] NULL,
	[UPD_IP] [nvarchar](50) NULL
    END;
</querytag>