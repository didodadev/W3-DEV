<!-- Description : ACCOUNT_TYPE tablosuna ihraç hesap tipleri eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS(SELECT * FROM @_dsn_main_@.ACCOUNT_TYPES WHERE ACCOUNT_TYPE_ID IN (-9,-10))
    BEGIN
        SET IDENTITY_INSERT [ACCOUNT_TYPES] ON 
            INSERT [ACCOUNT_TYPES] ([ACCOUNT_TYPE_ID], [ACCOUNT_TYPE], [UPDATE_DATE], [UPDATE_EMP], [UPDATE_IP]) VALUES (-10, N'İhraç Kayıtlı Alış', NULL, NULL, NULL)
            INSERT [ACCOUNT_TYPES] ([ACCOUNT_TYPE_ID], [ACCOUNT_TYPE], [UPDATE_DATE], [UPDATE_EMP], [UPDATE_IP]) VALUES (-9, N'İhraç Kayıtlı Satış', NULL, NULL, NULL)
        SET IDENTITY_INSERT [ACCOUNT_TYPES] OFF
    END
</querytag>