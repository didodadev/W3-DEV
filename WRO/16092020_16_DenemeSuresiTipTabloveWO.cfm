<!-- Description : Deneme Süresi ile ilgili WO sayfaları oluşturuldu.
Developer: Gülbahar İnan
Company : Workcube
Destination: Main -->

<querytag>
     IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EMPLOYEES_TEST_TIME_TYPE')
     BEGIN

        CREATE TABLE [EMPLOYEES_TEST_TIME_TYPE](
            [EMPLOYEES_TEST_TIME_TYPE_ID] [int] IDENTITY(1,1) NOT NULL,
            [TEST_TIME_TYPE_NAME] [nvarchar](150) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_EMPLOYEES_TEST_TIME_TYPE] PRIMARY KEY CLUSTERED 
        (
            [EMPLOYEES_TEST_TIME_TYPE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]


     END;

     IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EMPLOYEES_TEST_TIME')
     BEGIN

        CREATE TABLE [EMPLOYEES_TEST_TIME](
            [TEST_TIME_ID] [int] IDENTITY(1,1) NOT NULL,
            [EMPLOYEE_ID] [int] NOT NULL,
            [QUIZ_ID] [int] NOT NULL,
            [TEST_TIME_STAGE] [int]  NULL,
            [TEST_TIME_TYPE] [int]  NULL,
            [TEST_TIME_DAY] int NULL,
            [CAUTION_TIME_DAY] int NULL,
            [CAUTION_EMP_ID] int NULL,
            [TEST_TIME_DETAIL] [nvarchar](500) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_EMPLOYEES_TEST_TIME] PRIMARY KEY CLUSTERED 
        (
            [TEST_TIME_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
     END;
     IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'settings.form_add_test_time_type'
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
                ,3
                ,'Değerlendirme Form Tipleri'
                ,61263
                ,NULL
                ,'settings.form_add_test_time_type'
                ,'settings/form/form_add_test_time_type.cfm'
                ,NULL
                ,1
                ,'Analys'
                ,0
                ,NULL
                ,'V19'
                ,0
                ,0
                ,0
                ,'Workcube Team'
                ,NULL
                ,'127.0.0.1'
                ,124
                ,'2020-09-16 16:39:23.0'
                ,NULL
                ,NULL
                ,NULL
                ,'Standart'
                ,NULL
                ,NULL
                ,'settings'
                ,'form_add_test_time_type'
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
                ,0
                ,0
                ,1 
                ,NULL 
                ,NULL 
                ,0
                ,NULL
                )
        END
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'hr.popup_list_emp_test_time'
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
                ,3
                ,'Deneme Süresi Bilgileri'
                ,55325
                ,NULL
                ,'hr.popup_list_emp_test_time'
                ,'hr/display/list_emp_test_time.cfm'
                ,NULL
                ,1
                ,'Analys'
                ,1
                ,NULL
                ,'V19'
                ,0
                ,0
                ,0
                ,'Workcube Team'
                ,NULL
                ,'127.0.0.1'
                ,124
                ,'2020-09-15 13:32:28.0'
                ,'127.0.0.1'
                ,124
                ,'2020-09-29 17:55:03.99'
                ,'Standart'
                ,NULL
                ,NULL
                ,'hr'
                ,'popup_list_emp_test_time'
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
                ,0
                ,0
                ,10 
                ,NULL 
                ,NULL 
                ,0
                ,NULL
                )
        END
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'report.survey_test_time_report'
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
                ,65
                ,'Değerlendirme Formları Raporu'
                ,61261
                ,NULL
                ,'report.survey_test_time_report'
                ,'report/standart/survey_test_time_report.cfm'
                ,NULL
                ,1
                ,'Analys'
                ,0
                ,NULL
                ,'V19'
                ,0
                ,0
                ,0
                ,'Workcube Team'
                ,NULL
                ,'127.0.0.1'
                ,124
                ,'2020-09-29 16:26:04.0'
                ,NULL
                ,NULL
                ,NULL
                ,'Standart'
                ,NULL
                ,NULL
                ,'report'
                ,'survey_test_time_report'
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
                ,0
                ,0
                ,8 
                ,NULL 
                ,NULL 
                ,0
                ,NULL
                )
        END
    IF NOT EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'report.emptypopup_survey_test_time_report'
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
                    ,65
                    ,'Değerlendirme Formları Raporu (Excel)'
                    ,61262
                    ,NULL
                    ,'report.emptypopup_survey_test_time_report'
                    ,'report/standart/survey_test_time_report.cfm'
                    ,NULL
                    ,1
                    ,'Analys'
                    ,0
                    ,NULL
                    ,'V19'
                    ,0
                    ,0
                    ,0
                    ,NULL
                    ,NULL
                    ,'127.0.0.1'
                    ,124
                    ,'2020-09-29 16:45:29.0'
                    ,NULL
                    ,NULL
                    ,NULL
                    ,'Standart'
                    ,NULL
                    ,NULL
                    ,'report'
                    ,'emptypopup_survey_test_time_report'
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
                    ,0
                    ,0
                    ,10 
                    ,NULL 
                    ,NULL 
                    ,0
                    ,NULL
                    )
            END
    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EMPLOYEES_TEST_TIME')
    BEGIN
        INSERT INTO EMPLOYEES_TEST_TIME (EMPLOYEE_ID, QUIZ_ID, TEST_TIME_DAY,CAUTION_TIME_DAY,CAUTION_EMP_ID,TEST_TIME_DETAIL,RECORD_DATE,RECORD_EMP,RECORD_IP)
        SELECT EMPLOYEE_ID, QUIZ_ID, TEST_TIME,CAUTION_TIME,CAUTION_EMP,TEST_DETAIL,RECORD_DATE,RECORD_EMP,RECORD_IP
        FROM EMPLOYEES_DETAIL
        WHERE QUIZ_ID IS NOT NULL
    END
                    
</querytag>