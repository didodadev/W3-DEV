<!-- Description : Sepet içinde Sepet kullanımı için objeler oluşturuldu
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'objects.basket_in_basket_choose'
        )
        BEGIN
            INSERT [WRK_OBJECTS] (
                [IS_ACTIVE]
                ,[MODULE_NO]
                ,[HEAD]
                ,[DICTIONARY_ID]
                ,[FRIENDLY_URL]
                ,[FULL_FUSEACTION]
                ,[FILE_PATH]
                ,[CONTROLLER_FILE_PATH]
                ,[LICENCE]
                ,[STATUS]
                ,[IS_MENU]
                ,[WINDOW]
                ,[VERSION]
                ,[USE_PROCESS_CAT]
                ,[USE_SYSTEM_NO]
                ,[USE_WORKFLOW]
                ,[AUTHOR]
                ,[OBJECTS_COUNT]
                ,[RECORD_IP]
                ,[RECORD_EMP]
                ,[RECORD_DATE]
                ,[UPDATE_IP]
                ,[UPDATE_EMP]
                ,[UPDATE_DATE]
                ,[SECURITY]
                ,[STAGE]
                ,[MODUL]
                ,[MODUL_SHORT_NAME]
                ,[FUSEACTION]
                ,[FILE_NAME]
                ,[IS_ADD]
                ,[IS_UPDATE]
                ,[IS_DELETE]
                ,[IS_WBO_DENIED]
                ,[IS_WBO_LOCK]
                ,[IS_WBO_LOG]
                ,[IS_SPECIAL]
                ,[EVENT_ADD]
                ,[EVENT_DASHBOARD]
                ,[EVENT_DETAIL]
                ,[EVENT_LIST]
                ,[EVENT_UPD]
                ,[TYPE]
                ,[POPUP_TYPE]
                ,[EXTERNAL_FUSEACTION]
                ,[IS_LEGACY]
                ,[ADDOPTIONS_CONTROLLER_FILE_PATH]
                )
            VALUES (
                1
                ,47
                ,'Alışveriş Sepeti'
                ,35366
                ,'BasketinBasketChoose'
                ,'objects.basket_in_basket_choose'
                ,'objects/display/basket_in_basket_choose.cfm'
                ,NULL
                ,1
                ,'Development'
                ,0
                ,NULL
                ,'v16'
                ,0
                ,0
                ,0
                ,NULL
                ,NULL
                ,'127.0.0.1'
                ,67
                ,'2020-10-29 12:38:54.0'
                ,NULL
                ,NULL
                ,NULL
                ,'Standart'
                ,2176
                ,NULL
                ,'objects'
                ,'basket_in_basket_choose'
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,0
                ,0
                ,0
                ,1
                ,0
                ,0 
                ,NULL 
                ,NULL 
                ,0
                ,NULL
                )
        END;

        IF NOT EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'objects.basket_in_basket'
            )
            BEGIN
                INSERT [WRK_OBJECTS] (
                    [IS_ACTIVE]
                    ,[MODULE_NO]
                    ,[HEAD]
                    ,[DICTIONARY_ID]
                    ,[FRIENDLY_URL]
                    ,[FULL_FUSEACTION]
                    ,[FILE_PATH]
                    ,[CONTROLLER_FILE_PATH]
                    ,[LICENCE]
                    ,[STATUS]
                    ,[IS_MENU]
                    ,[WINDOW]
                    ,[VERSION]
                    ,[USE_PROCESS_CAT]
                    ,[USE_SYSTEM_NO]
                    ,[USE_WORKFLOW]
                    ,[AUTHOR]
                    ,[OBJECTS_COUNT]
                    ,[RECORD_IP]
                    ,[RECORD_EMP]
                    ,[RECORD_DATE]
                    ,[UPDATE_IP]
                    ,[UPDATE_EMP]
                    ,[UPDATE_DATE]
                    ,[SECURITY]
                    ,[STAGE]
                    ,[MODUL]
                    ,[MODUL_SHORT_NAME]
                    ,[FUSEACTION]
                    ,[FILE_NAME]
                    ,[IS_ADD]
                    ,[IS_UPDATE]
                    ,[IS_DELETE]
                    ,[IS_WBO_DENIED]
                    ,[IS_WBO_LOCK]
                    ,[IS_WBO_LOG]
                    ,[IS_SPECIAL]
                    ,[EVENT_ADD]
                    ,[EVENT_DASHBOARD]
                    ,[EVENT_DETAIL]
                    ,[EVENT_LIST]
                    ,[EVENT_UPD]
                    ,[TYPE]
                    ,[POPUP_TYPE]
                    ,[EXTERNAL_FUSEACTION]
                    ,[IS_LEGACY]
                    ,[ADDOPTIONS_CONTROLLER_FILE_PATH]
                    )
                VALUES (
                    1
                    ,47
                    ,'Alışveriş Sepeti'
                    ,35366
                    ,'BasketinBasket'
                    ,'objects.basket_in_basket'
                    ,'objects/display/basket_in_basket.cfm'
                    ,NULL
                    ,1
                    ,'Deployment'
                    ,0
                    ,NULL
                    ,'v16'
                    ,0
                    ,0
                    ,0
                    ,NULL
                    ,NULL
                    ,'127.0.0.1'
                    ,67
                    ,'2020-10-22 16:17:03.0'
                    ,NULL
                    ,NULL
                    ,NULL
                    ,'Standart'
                    ,2176
                    ,NULL
                    ,'objects'
                    ,'basket_in_basket'
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,0
                    ,0
                    ,0
                    ,1
                    ,0
                    ,0 
                    ,NULL 
                    ,NULL 
                    ,0
                    ,NULL
                    )
            END;
        
</querytag>