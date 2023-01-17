<!-- Description : Abone Planı Aktarım Tipleri Tanım Ekranları
Developer: Tolga Sütlü
Company : Workcube
Destination: main -->
<querytag>
IF NOT EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'settings.subscription_payment_plan_import_type'
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
            ,79
            ,'Ödeme Planı Aktarım Tipleri'
            ,45168
            ,NULL
            ,'settings.subscription_payment_plan_import_type'
            ,'settings/display/subscription_payment_plan_import_type.cfm'
            ,'WBO/controller/SubscriptionPaymentPlanImportTypeController.cfm'
            ,1
            ,'Deployment'
            ,0
            ,'normal'
            ,'v 11.1'
            ,0
            ,0
            ,0
            ,'Devonomy'
            ,93
            ,'192.168.18.34'
            ,1898
            ,'2010-11-25 15:53:42.823'
            ,'127.0.0.1'
            ,173
            ,'2019-12-25 16:02:22.333'
            ,'HTTP'
            ,2176
            ,'Settings'
            ,'Subscription Management'
            ,'subscription_payment_plan_import_type'
            ,'subscription_payment_plan_import_type.cfm'
            ,NULL
            ,NULL
            ,NULL
            ,0
            ,0
            ,NULL
            ,0
            ,0
            ,0
            ,0
            ,0
            ,0
            ,1 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
</querytag>