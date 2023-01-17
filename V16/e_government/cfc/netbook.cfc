<!---
    File: netbook.cfc
    Folder: V16\e_government\cfc
    Author:
    Date:
    Description:
        E-defter metodlarının yer aldığı sınıf
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
    To Do:

--->

<cfcomponent>
    <cffunction name="getAccountants" access="public" returntype="query" hint="Muhasebeci tanımları get">
        <cfquery name="get" datasource="#this.dsn#">
            SELECT
                ACCOUNTANT.ACC_ID,
                ACCOUNTANT.ACC_COMPANY_ID,
                COMPANY.NICKNAME,
                COMPANY.FULLNAME,
                ACCOUNTANT.ACC_PARTNER_ID,
                CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME PARTNER_FULLNAME,
                ACCOUNTANT.ACC_CONSUMER_ID,
                CONSUMER.CONSUMER_NAME +' '+ CONSUMER.CONSUMER_SURNAME CONSUMER_FULLNAME,
                ACCOUNTANT.CONTRACT_NO,
                ACCOUNTANT.CONTRACT_DATE,
                ACCOUNTANT.DESCRIPTION,
                ACCOUNTANT.RECORD_EMP AS UPDATE_EMP,
                ACCOUNTANT.RECORD_DATE AS UPDATE_DATE
                <!--- sayfanin altinda kayit yerine guncelleme yazsin diye bu sekilde yaptim. cunku kaydet denildiginde tablodaki kayitlari silerek tekrar yaziyor --->
            FROM
                ACCOUNTANT
                    LEFT JOIN COMPANY ON COMPANY.COMPANY_ID = ACCOUNTANT.ACC_COMPANY_ID
                    LEFT JOIN COMPANY_PARTNER CP ON COMPANY.COMPANY_ID = CP.COMPANY_ID AND ACC_PARTNER_ID = CP.PARTNER_ID
                    LEFT JOIN CONSUMER ON CONSUMER.CONSUMER_ID = ACCOUNTANT.ACC_CONSUMER_ID
            WHERE
                ACCOUNTANT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfreturn get>
    </cffunction>

    <cffunction name="delAccountants" access="public" returntype="any" hint="Muhasebeci tanimlari: del">
        <cfquery name="del" datasource="#this.dsn#">
            DELETE FROM ACCOUNTANT WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
    </cffunction>

    <cffunction name="addAccountant" access="public" returntype="any" hint="Muhasebeci tanimlari: add">
        <cfargument type="numeric" name="consumer_id" default="0">
        <cfargument type="numeric" name="company_id" default="0">
        <cfargument type="numeric" name="partner_id" default="0">
        <cfargument type="string" name="contract_date" default="">
        <cfargument type="string" name="contract_no" default="">
        <cfargument type="string" name="description" default="">
        <cfquery name="add" datasource="#this.dsn#">
            INSERT INTO
                ACCOUNTANT
            (
                ACC_CONSUMER_ID,
                ACC_COMPANY_ID,
                ACC_PARTNER_ID,
                CONTRACT_DATE,
                OUR_COMPANY_ID,
                CONTRACT_NO,
                DESCRIPTION,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE
            )
                VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">,
                #arguments.contract_date#,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contract_no#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_host#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="getNetbooks" access="public" returntype="query" hint="E-Defterler: get">
        <cfargument type="numeric" name="defter_status" default="">
        <cfargument name="record_start_date" default="">
        <cfargument name="record_finish_date" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument type="string" name="status_message" default="">
        <cfargument type="string" name="type" default="">
        <cfargument type="string" name="file_name" default="">
        <cfargument type="numeric" name="topCount" default="0">
        
        <cfquery name="get" datasource="#this.dsn2#">
            SELECT
                <cfif arguments.topCount gt 0>TOP #arguments.topCount#</cfif> 
                N.NETBOOK_ID,
                N.UNIQUE_FILE_NAME,
                N.STATUS,
                ND.START_DATE,
                ND.FINISH_DATE,
                N.DETAIL,
                N.ERROR_DETAIL,
                N.BILL_START_NUMBER,
                N.BILL_FINISH_NUMBER,
                N.BILL_START_ROW_NUMBER,
                N.BILL_FINISH_ROW_NUMBER,
                N.RECORD_DATE,
                N.RECORD_EMP,
                N.INTEGRATION_ID,
                ISNULL(ND.INTEGRATION_DOCUMENT_ID,0) AS INTEGRATION_DOCUMENT_ID,
                ND.FILE_NAME,
                ND.FILE_PATH,
                ND.TYPE,
                CASE WHEN ND.STATUS_CODE IS NOT NULL THEN ND.STATUS_CODE ELSE -1 END AS STATUS_CODE,
                ND.STATUS_MESSAGE,
                ND.UNIQUEID,
                EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME AS RECORD_NAME
            FROM
                NETBOOKS N
                INNER JOIN #this.dsn#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = N.RECORD_EMP
                LEFT JOIN NETBOOK_DOCUMENTS ND ON N.UNIQUE_FILE_NAME = ND.UNIQUE_FILE_NAME
            WHERE
                1 = 1
                <cfif len(arguments.start_date)>
                    AND N.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                </cfif>
                <cfif len(arguments.finish_date)>
                    AND N.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_date)#">
                </cfif>
                <cfif arguments.defter_status eq -1>
                    AND N.STATUS = -1
                <cfelseif arguments.defter_status eq 1>
                    AND N.STATUS = 1
                </cfif>
                <cfif len(arguments.record_start_date)>
                    AND N.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_start_date#">
                </cfif>
                <cfif len(arguments.record_finish_date)>
                    AND N.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.record_finish_date)#">
                </cfif>
                <cfif len(arguments.status_message) and arguments.status_message neq 'nbNotCreated'>
                    AND ND.STATUS_MESSAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status_message#">
                <cfelseif len(arguments.status_message) and arguments.status_message eq 'nbNotCreated'>
                    AND INTEGRATION_DOCUMENT_ID IS NULL
                </cfif>
                <cfif len(arguments.type)>
                    AND ND.TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">
                </cfif>
                <cfif len(arguments.file_name)>
                    AND (
                            ND.FILE_NAME LIKE (<cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.file_name#%">) OR
                            ND.UNIQUE_FILE_NAME LIKE (<cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.file_name#%">)
                        )
                </cfif>
            ORDER BY N.NETBOOK_ID DESC
        </cfquery>
        <cfreturn get>
    </cffunction>

    <cffunction name="addNetbook" access="public" returntype="any" hint="E-Defterler: add">
        <cfargument name="file_name" default="">
        <cfargument name="netbook_detail" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="bill_start_number" default="">
        <cfargument name="bill_finish_number" default="">
        <cfargument name="bill_start_row_number" default="">
        <cfargument name="bill_finish_row_number" default="">
        <cfargument name="Result" default="0">
        <cfargument name="CustomerId" default="0">
        <cfquery name="add" datasource="#this.dsn2#">
            INSERT INTO
                NETBOOKS
            (
            UNIQUE_FILE_NAME,
            STATUS,
            DETAIL,
            START_DATE,
            FINISH_DATE,
            BILL_START_NUMBER,
            BILL_FINISH_NUMBER,
            BILL_START_ROW_NUMBER,
            BILL_FINISH_ROW_NUMBER,
            INTEGRATION_ID,
            CUSTOMER_ID,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
            )
            VALUES
            (
                '#listfirst(arguments.file_name,'.')#',
                1,
                '#arguments.netbook_detail#',
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bill_start_number#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bill_finish_number#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bill_start_row_number#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bill_finish_row_number#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Result#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CustomerId#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="getNetbookIntegration" access="public" returntype="query" hint="Sirket ve entegrasyon bilgileri">
        <cfargument name="control_date" default="#now()#">
        <cfquery name="get" datasource="#this.dsn#">
            SELECT TOP 1
                OC.COMPANY_NAME,
                OC.TAX_OFFICE,
                OC.TAX_NO,
                OC.TEL_CODE,
                OC.TEL,
                OC.FAX,
                OC.WEB,
                OC.EMAIL,
                OC.ADDRESS,
                OC.POSTAL_CODE,
                OC.CITY_ID,
                OC.COUNTRY_ID,
                OC.STREET_NAME,
                OC.DISTRICT_NAME,
                OC.COUNTY_ID,
                OC.BUILDING_NUMBER,
                OC.NACE_CODE,
                SCI.CITY_NAME AS CITY,
                SCO.COUNTRY_NAME AS COUNTRY,
                NETBOOK_INTEGRATION_TYPE,
                CASE WHEN NETBOOK_TEST_SYSTEM = 1 THEN NETBOOK_TEST_WEBSERVICE_URL ELSE NETBOOK_WEBSERVICE_URL END AS NETBOOK_WEBSERVICE_URL,
                CASE WHEN NETBOOK_TEST_SYSTEM = 1 THEN NETBOOK_TEST_COMPANY_CODE ELSE NETBOOK_COMPANY_CODE END AS NETBOOK_COMPANY_CODE,
                CASE WHEN NETBOOK_TEST_SYSTEM = 1 THEN NETBOOK_TEST_USERNAME ELSE NETBOOK_USERNAME END AS NETBOOK_USERNAME,
                CASE WHEN NETBOOK_TEST_SYSTEM = 1 THEN NETBOOK_TEST_PASSWORD ELSE NETBOOK_PASSWORD END AS NETBOOK_PASSWORD,
                CASE WHEN NETBOOK_TEST_SYSTEM = 1 THEN NETBOOK_TEST_FTP_SERVER ELSE NETBOOK_FTP_SERVER END AS NETBOOK_FTP_SERVER,
                CASE WHEN NETBOOK_TEST_SYSTEM = 1 THEN NETBOOK_TEST_FTP_PORT ELSE NETBOOK_FTP_PORT END AS NETBOOK_FTP_PORT,
                CASE WHEN NETBOOK_TEST_SYSTEM = 1 THEN NETBOOK_TEST_FTP_USERNAME ELSE NETBOOK_FTP_USERNAME END AS NETBOOK_FTP_USERNAME,
                CASE WHEN NETBOOK_TEST_SYSTEM = 1 THEN NETBOOK_TEST_FTP_PASSWORD ELSE NETBOOK_FTP_PASSWORD END AS NETBOOK_FTP_PASSWORD,
                AC.CONTRACT_NO,
                AC.CONTRACT_DATE,
                AC.DESCRIPTION,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN C.CONSUMER_NAME +' '+C.CONSUMER_SURNAME ELSE '' END AS ACCOUNTANT_NAME,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_EMAIL WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN C.CONSUMER_EMAIL ELSE '' END AS ACCOUNTANT_EMAIL,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_ADDRESS WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN C.WORKADDRESS ELSE '' END AS ACCOUNTANT_ADDRESS,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_POSTCODE WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN C.WORKPOSTCODE ELSE '' END AS ACCOUNTANT_POSTCODE,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN CP.SEMT WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN C.WORKSEMT ELSE '' END AS ACCOUNTANT_SEMT,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN (SELECT A_SCI.CITY_NAME FROM SETUP_CITY A_SCI WHERE A_SCI.CITY_ID = CP.CITY) WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN (SELECT A_SCI.CITY_NAME FROM SETUP_CITY A_SCI WHERE A_SCI.CITY_ID = C.WORK_CITY_ID) ELSE '' END AS ACCOUNTANT_CITY,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN (SELECT A_SC.COUNTRY_NAME FROM SETUP_COUNTRY A_SC WHERE A_SC.COUNTRY_ID= CP.COUNTRY) WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN (SELECT A_SC.COUNTRY_NAME FROM SETUP_COUNTRY A_SC WHERE A_SC.COUNTRY_ID=C.WORK_COUNTRY_ID) ELSE '' END AS ACCOUNTANT_COUNTRY,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_TELCODE +''+ CP.COMPANY_PARTNER_TEL WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN C.CONSUMER_WORKTELCODE +''+ C.CONSUMER_WORKTEL ELSE '' END AS ACCOUNTANT_TEL,
                CASE WHEN AC.ACC_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_TELCODE +''+ CP.COMPANY_PARTNER_FAX WHEN AC.ACC_CONSUMER_ID IS NOT NULL THEN C.CONSUMER_FAXCODE +''+ C.CONSUMER_FAX ELSE '' END AS ACCOUNTANT_FAX
            FROM
                OUR_COMPANY OC
                RIGHT JOIN NETBOOK_INTEGRATION_INFO NI ON NI.COMP_ID = OC.COMP_ID
                RIGHT JOIN ACCOUNTANT AC ON AC.OUR_COMPANY_ID = OC.COMP_ID
                LEFT JOIN SETUP_CITY SCI ON SCI.CITY_ID = OC.CITY_ID
                LEFT JOIN SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = OC.COUNTRY_ID
                LEFT JOIN COMPANY_PARTNER CP ON CP.COMPANY_ID = AC.ACC_COMPANY_ID AND CP.PARTNER_ID = AC.ACC_PARTNER_ID
                LEFT JOIN CONSUMER C ON C.CONSUMER_ID = AC.ACC_CONSUMER_ID
            WHERE
                OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                AND (AC.CONTRACT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.control_date#"> OR AC.CONTRACT_DATE IS NULL)
            ORDER BY
                AC.CONTRACT_DATE DESC
        </cfquery>
        <cfreturn get />
    </cffunction>

    <cffunction name="getAccountCard" access="public" returntype="query" hint="defter data">
        <cfargument name="acc_card_type" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfquery name="get" datasource="#this.dsn2#">
            SELECT
                AC.CARD_ID,
                ACR.CARD_ROW_ID,
                AC.BILL_NO,
                CASE WHEN LEN(PAPER_NO) > 0 THEN PAPER_NO ELSE '1' END AS PAPER_NO,
                AC.ACTION_ID,
                AC.ACTION_DATE,
                AC.DUE_DATE,<!--- cek ve senet islemlerinde vade tarihi gonderiliyor --->
                AC.CARD_TYPE,
                AC.CARD_CAT_ID,
                CASE WHEN AC.CARD_TYPE_NO IS NOT NULL THEN AC.CARD_TYPE_NO ELSE 1 END AS CARD_TYPE_NO,
                AC.CARD_DETAIL,
                AC.ACTION_TYPE,
                ACR.ACCOUNT_ID,
                ROUND(ACR.AMOUNT,2) AS AMOUNT,
                CASE WHEN LEN(ACR.DETAIL)>1 THEN ACR.DETAIL ELSE AC.CARD_DETAIL END AS ROW_DETAIL,
                CASE ACR.BA WHEN 0 THEN 'D' ELSE 'C' END AS DEBIT_CREDIT_CODE,
                CAST(ACR.BA AS INT) BA,
                E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME AS RECORD_NAME,
                AP.ACCOUNT_CODE AS ALT_HESAP,
                CASE WHEN CHARINDEX('.',ACR.ACCOUNT_ID) > 0 THEN AP1.ACCOUNT_CODE ELSE AP.ACCOUNT_CODE END AS ANA_HESAP,
                AP.ACCOUNT_NAME AS ALT_HESAP_DETAY,
                CASE WHEN CHARINDEX('.',ACR.ACCOUNT_ID) > 0 THEN AP1.ACCOUNT_NAME ELSE AP.ACCOUNT_NAME END AS ANA_HESAP_DETAY,
                ACDT.DOCUMENT_TYPE_ID,
                CASE WHEN ACDT.IS_OTHER = 1 THEN 'other' ELSE ACDT.DOCUMENT_TYPE END AS DOCUMENT_TYPE,
                ACPT.PAYMENT_TYPE_ID,
                ACPT.PAYMENT_TYPE,
                CASE WHEN ACDT.IS_OTHER = 1 THEN ACDT.DOCUMENT_TYPE END AS DOCUMENT_TYPE_DEFINITION
            FROM
                ACCOUNT_CARD AC
                RIGHT JOIN ACCOUNT_CARD_ROWS ACR ON AC.CARD_ID = ACR.CARD_ID
                RIGHT JOIN ACCOUNT_PLAN AP ON AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
                LEFT JOIN ACCOUNT_PLAN AP1 ON AP1.ACCOUNT_CODE= SUBSTRING(ACR.ACCOUNT_ID,0,CHARINDEX('.',ACR.ACCOUNT_ID))
                LEFT JOIN #this.dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = AC.RECORD_EMP
                LEFT JOIN #this.dsn#.ACCOUNT_CARD_DOCUMENT_TYPES ACDT ON ACDT.DOCUMENT_TYPE_ID = AC.CARD_DOCUMENT_TYPE
                LEFT JOIN #this.dsn#.ACCOUNT_CARD_PAYMENT_TYPES ACPT ON ACPT.PAYMENT_TYPE_ID = AC.CARD_PAYMENT_METHOD
            WHERE
                ACR.CARD_ID IS NOT NULL
                <cfif len(arguments.acc_card_type)><!---muhasebe islem kategorilerine gore arama --->
                    AND (
                    <cfloop list="#arguments.acc_card_type#" delimiters="," index="type_ii">
                        (AC.CARD_TYPE = #listfirst(type_ii,'-')# AND AC.CARD_CAT_ID = #listlast(type_ii,'-')#)
                        <cfif type_ii neq listlast(arguments.acc_card_type,',') and listlen(arguments.acc_card_type,',') gte 1> OR</cfif>
                    </cfloop>
                        )
                </cfif>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            ORDER BY
                ACTION_DATE,
                BILL_NO
        </cfquery>
        <cfreturn get />
    </cffunction>

    <cffunction name="getIntegrationDefinitions" access="public" returntype="query" hint="Entegrasyon tanimlari: get">
        <cfquery name="get" datasource="#this.dsn#">
            SELECT
                NETBOOK_INTEGRATION_INFO.ID,
                NETBOOK_INTEGRATION_INFO.COMP_ID,
                NETBOOK_INTEGRATION_INFO.NETBOOK_INTEGRATION_TYPE,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_SYSTEM,
                NETBOOK_INTEGRATION_INFO.NETBOOK_WEBSERVICE_URL,
                NETBOOK_INTEGRATION_INFO.NETBOOK_COMPANY_CODE,
                NETBOOK_INTEGRATION_INFO.NETBOOK_USERNAME,
                NETBOOK_INTEGRATION_INFO.NETBOOK_PASSWORD,
                NETBOOK_INTEGRATION_INFO.NETBOOK_FTP_SERVER,
                NETBOOK_INTEGRATION_INFO.NETBOOK_FTP_PORT,
                NETBOOK_INTEGRATION_INFO.NETBOOK_FTP_USERNAME,
                NETBOOK_INTEGRATION_INFO.NETBOOK_FTP_PASSWORD,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_WEBSERVICE_URL,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_COMPANY_CODE,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_USERNAME,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_PASSWORD,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_FTP_SERVER,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_FTP_PORT,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_FTP_USERNAME,
                NETBOOK_INTEGRATION_INFO.NETBOOK_TEST_FTP_PASSWORD,
                NETBOOK_INTEGRATION_INFO.RECORD_DATE,
                NETBOOK_INTEGRATION_INFO.RECORD_EMP,
                NETBOOK_INTEGRATION_INFO.RECORD_IP,
                NETBOOK_INTEGRATION_INFO.UPDATE_DATE,
                NETBOOK_INTEGRATION_INFO.UPDATE_EMP,
                NETBOOK_INTEGRATION_INFO.UPDATE_IP,
                OUR_COMPANY_INFO.COMP_ID,
                ISNULL(OUR_COMPANY_INFO.IS_EDEFTER,0) AS IS_EDEFTER
            FROM
                NETBOOK_INTEGRATION_INFO
                LEFT JOIN OUR_COMPANY_INFO ON NETBOOK_INTEGRATION_INFO.COMP_ID = OUR_COMPANY_INFO.COMP_ID
            WHERE
                NETBOOK_INTEGRATION_INFO.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">;
        </cfquery>
        <cfreturn get />
    </cffunction>

    <cffunction name="updIntegrationDefinitions" access="public" returntype="any" hint="Entegrasyon tanimlari: upd">
        <cfargument type="numeric" name="netbook_integration_type" default="">
        <cfargument type="numeric" name="netbook_test_system" default="">
        <cfargument type="string" name="netbook_test_webservice_url" default="">
        <cfargument type="string" name="netbook_test_company_code" default="">
        <cfargument type="string" name="netbook_test_username" default="">
        <cfargument type="string" name="netbook_test_password" default="">
        <cfargument type="string" name="netbook_webservice_url" default="">
        <cfargument type="string" name="netbook_company_code" default="">
        <cfargument type="string" name="netbook_username" default="">
        <cfargument type="string" name="netbook_password" default="">
    
        <cfargument type="string" name="netbook_ftp_server" default="">
        <cfargument type="string" name="netbook_ftp_port" default="">
        <cfargument type="string" name="netbook_ftp_username" default="">
        <cfargument type="string" name="netbook_ftp_password" default="">
        
        <cfargument type="string" name="netbook_test_ftp_server" default="">
        <cfargument type="string" name="netbook_test_ftp_port" default="">
        <cfargument type="string" name="netbook_test_ftp_username" default="">
        <cfargument type="string" name="netbook_test_ftp_password" default="">
        
        <cfquery name="upd" datasource="#this.dsn#">
            UPDATE
                NETBOOK_INTEGRATION_INFO
            SET
                NETBOOK_INTEGRATION_TYPE = <cfif len(arguments.netbook_integration_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.netbook_integration_type#"></cfif>,
                NETBOOK_TEST_SYSTEM = <cfif arguments.netbook_test_system eq 1>1<cfelse>0</cfif>,
                <cfif arguments.netbook_test_system eq 1>
                    NETBOOK_TEST_WEBSERVICE_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_webservice_url#">,
                    NETBOOK_TEST_COMPANY_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_company_code#">,
                    NETBOOK_TEST_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_username#">,
                    NETBOOK_TEST_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_password#">,
                    NETBOOK_TEST_FTP_SERVER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_ftp_server#">,
                    NETBOOK_TEST_FTP_PORT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_ftp_port#">,
                    NETBOOK_TEST_FTP_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_ftp_username#">,
                    NETBOOK_TEST_FTP_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_ftp_password#">,
                <cfelse>
                    NETBOOK_WEBSERVICE_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_webservice_url#">,
                    NETBOOK_COMPANY_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_company_code#">,
                    NETBOOK_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_username#">,
                    NETBOOK_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_password#">,
                    NETBOOK_FTP_SERVER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_ftp_server#">,
                    NETBOOK_FTP_PORT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_ftp_port#">,
                    NETBOOK_FTP_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_ftp_username#">,
                    NETBOOK_FTP_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_ftp_password#">,
                </cfif>
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
    </cffunction>

    <cffunction name="addIntegrationDefinitions" access="public" returntype="any" hint="Entegrasyon tanimlari: add">
        <cfargument type="numeric" name="netbook_integration_type" default="">
        <cfargument type="numeric" name="netbook_test_system" default="">
        <cfargument type="string" name="netbook_test_webservice_url" default="">
        <cfargument type="string" name="netbook_test_company_code" default="">
        <cfargument type="string" name="netbook_test_username" default="">
        <cfargument type="string" name="netbook_test_password" default="">
        <cfargument type="string" name="netbook_webservice_url" default="">
        <cfargument type="string" name="netbook_company_code" default="">
        <cfargument type="string" name="netbook_username" default="">
        <cfargument type="string" name="netbook_password" default="">
        <cfargument type="string" name="netbook_ftp_server" default="">
        <cfargument type="string" name="netbook_ftp_port" default="">
        <cfargument type="string" name="netbook_ftp_username" default="">
        <cfargument type="string" name="netbook_ftp_password" default="">
        <cfargument type="string" name="netbook_test_ftp_server" default="">
        <cfargument type="string" name="netbook_test_ftp_port" default="">
        <cfargument type="string" name="netbook_test_ftp_username" default="">
        <cfargument type="string" name="netbook_test_ftp_password" default="">
        
        <cfquery name="add" datasource="#this.dsn#">
            INSERT INTO
                NETBOOK_INTEGRATION_INFO
            (
                COMP_ID,
                NETBOOK_INTEGRATION_TYPE,
                NETBOOK_TEST_SYSTEM,
                <cfif arguments.netbook_test_system eq 1>
                    NETBOOK_TEST_WEBSERVICE_URL,
                    NETBOOK_TEST_COMPANY_CODE,
                    NETBOOK_TEST_USERNAME,
                    NETBOOK_TEST_PASSWORD,
                    NETBOOK_TEST_FTP_SERVER,
                    NETBOOK_TEST_FTP_PORT,
                    NETBOOK_TEST_FTP_USERNAME,
                    NETBOOK_TEST_FTP_PASSWORD,
                <cfelse>
                    NETBOOK_WEBSERVICE_URL,
                    NETBOOK_COMPANY_CODE,
                    NETBOOK_USERNAME,
                    NETBOOK_PASSWORD,
                    NETBOOK_FTP_SERVER,
                    NETBOOK_FTP_PORT,
                    NETBOOK_FTP_USERNAME,
                    NETBOOK_FTP_PASSWORD,
                </cfif>
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.netbook_integration_type#">,
                <cfif arguments.netbook_test_system eq 1>1<cfelse>0</cfif>,
                <cfif arguments.netbook_test_system eq 1>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_webservice_url#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_company_code#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_username#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_password#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_ftp_server#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_ftp_port#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_ftp_username#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_test_ftp_password#">,
                <cfelse>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_webservice_url#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_company_code#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_username#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_password#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_ftp_server#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_ftp_port#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_ftp_username#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.netbook_ftp_password#">,
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
    </cffunction>

    <!---
    <cffunction name="updEdefterInfo" access="public" returntype="any" hint="Entegrasyon tanimlari: e-defter kullaniliyor mu upd, BK 20150728 E-Defter durumu guncellenmiyor">
        <cfargument type="numeric" name="is_edefter" default="">
        <cfquery name ="upd" datasource="#this.dsn#">
            UPDATE
                OUR_COMPANY_INFO
            SET
                IS_EDEFTER = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_edefter#">
            WHERE
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
    </cffunction>--->

    <cffunction name="getAccountCardDocumentTypes" access="public" returntype="query" hint="Belge tipleri: get">
        <cfargument type="numeric" name="is_company" default="0">
        <cfargument type="numeric" name="is_active" default="0">
        <cfargument name="doc_type_id" default="">
        <cfquery name="get" datasource="#this.dsn#">
            SELECT
                OUR_COMPANY_ID,
                IS_ACTIVE,
                IS_OTHER,
                DOCUMENT_TYPE_ID,
                #this.dsn#.Get_Dynamic_Language(DOCUMENT_TYPE_ID,'#session.ep.language#','ACCOUNT_CARD_DOCUMENT_TYPES','DOCUMENT_TYPE',NULL,NULL,DOCUMENT_TYPE) AS DOCUMENT_TYPE,
                #this.dsn#.Get_Dynamic_Language(DOCUMENT_TYPE_ID,'#session.ep.language#','ACCOUNT_CARD_DOCUMENT_TYPES','DETAIL',NULL,NULL,DETAIL) AS DETAIL,
                RECORD_IP,
                RECORD_EMP,
                RECORD_DATE,
                UPDATE_IP,
                UPDATE_EMP,
                UPDATE_DATE
            FROM
                ACCOUNT_CARD_DOCUMENT_TYPES
            WHERE
                1 = 1
                <cfif arguments.is_company eq 1>
                    AND OUR_COMPANY_ID LIKE '%#session.ep.company_id#%'
                </cfif>
                <cfif arguments.is_active eq 1>
                    AND IS_ACTIVE = 1
                </cfif>
                <cfif isNumeric(arguments.doc_type_id)>
                    AND DOCUMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doc_type_id#">
                </cfif>
            ORDER BY
                DOCUMENT_TYPE
        </cfquery>
        <cfreturn get />
    </cffunction>

    <cffunction name="delAccountCardDocumentType" access="public" returntype="any" hint="Belge tipleri: del">
        <cfargument name="doc_type_id" default="">
        <cfquery name="get" datasource="#this.dsn#">
            DELETE FROM ACCOUNT_CARD_DOCUMENT_TYPES WHERE DOCUMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doc_type_id#">
        </cfquery>
    </cffunction>

    <cffunction name="checkDocumentTypeIfUsed" access="public" returntype="numeric" hint="Belge tipleri: check doc type if used">
        <cfargument name="doc_type_id" default="">
        <cfquery name="periodcount" datasource="#this.dsn#">
            SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD
        </cfquery>
        <cfoutput query="periodcount">
            <cfquery name="get" datasource="#this.dsn#">
                SELECT TOP 1
                    AC.ACTION_DATE,
                    AC.CARD_DOCUMENT_TYPE,
                    N.START_DATE,
                    N.FINISH_DATE
                FROM
                    #this.dsn#_#period_year#_#our_company_id#.ACCOUNT_CARD AC,
                    #this.dsn#_#period_year#_#our_company_id#.NETBOOKS N
                WHERE
                    AC.ACTION_DATE BETWEEN N.START_DATE AND N.FINISH_DATE AND
                    AC.CARD_DOCUMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doc_type_id#">
            </cfquery>
            <cfif get.recordcount>
                <cfreturn get.recordcount>
            </cfif>
        </cfoutput>
        <cfreturn 0>
    </cffunction>

    <cffunction name="updAccountCardDocumentTypes" access="public" returntype="any" hint="Belge tipleri: upd">
        <cfargument type="numeric" name="is_active" default="">
        <cfargument type="numeric" name="is_other" default="">
        <cfargument type="string" name="document_type" default="">
        <cfargument type="string" name="detail" default="">
        <cfargument type="string" name="our_company_id" default="">
        <cfargument type="numeric" name="document_type_id" default="">
        <cfquery name="upd" datasource="#this.dsn#">
            UPDATE
                ACCOUNT_CARD_DOCUMENT_TYPES
            SET
                <cfif arguments.document_type_id gte 0>
                    DOCUMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.document_type#">,
                    IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                    IS_OTHER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_other#">,
                </cfif>
                DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.our_company_id#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                DOCUMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.document_type_id#">
        </cfquery>
    </cffunction>

    <cffunction name="addAccountCardDocumentTypes" access="public" returntype="any" hint="Belge tipleri: add">
        <cfargument type="numeric" name="is_active" default="">
        <cfargument type="numeric" name="is_other" default="">
        <cfargument type="string" name="document_type" default="">
        <cfargument type="string" name="detail" default="">
        <cfargument type="string" name="our_company_id" default="">
        <cfquery name="max" datasource="#this.dsn#">
            SELECT
                MAX(DOCUMENT_TYPE_ID) AS max_id
            FROM
                ACCOUNT_CARD_DOCUMENT_TYPES
        </cfquery>
        <cfscript>
            if (max.max_id eq '')
                max_id = 1;
            else max_id = max.max_id + 1;
        </cfscript>
        <cfquery name="add" datasource="#this.dsn#" result="MAX_ID">
            INSERT INTO
                ACCOUNT_CARD_DOCUMENT_TYPES
            (
                IS_ACTIVE,
                IS_OTHER,
                DOCUMENT_TYPE_ID,
                DOCUMENT_TYPE,
                DETAIL,
                OUR_COMPANY_ID,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_other#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#max_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#DOCUMENT_TYPE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#OUR_COMPANY_ID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="getAccountCardPaymentTypes" access="public" returntype="query" hint="Odeme sekilleri: get">
        <cfargument name="is_active" default="0">
        <cfargument name="payment_type_id" default="">
        <cfquery name="get" datasource="#this.dsn#">
            SELECT
                IS_ACTIVE,
                PAYMENT_TYPE_ID,
                #this.dsn#.Get_Dynamic_Language(PAYMENT_TYPE_ID,'#session.ep.language#','ACCOUNT_CARD_PAYMENT_TYPES','PAYMENT_TYPE',NULL,NULL,PAYMENT_TYPE) AS PAYMENT_TYPE,
                DETAIL,
                RECORD_IP,
                RECORD_EMP,
                RECORD_DATE,
                UPDATE_IP,
                UPDATE_EMP,
                UPDATE_DATE
            FROM
                ACCOUNT_CARD_PAYMENT_TYPES
            WHERE
                1 = 1
                <cfif arguments.is_active eq 1>
                    AND IS_ACTIVE = 1
                </cfif>
                <cfif len(arguments.payment_type_id)>
                    AND PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payment_type_id#">
                </cfif>
            ORDER BY
                PAYMENT_TYPE
        </cfquery>
        <cfreturn get />
    </cffunction>

    <cffunction name="delAccountCardPaymentType" access="public" returntype="any" hint="Belge tipleri: del">
        <cfargument name="payment_type_id" default="">
        <cfquery name="get" datasource="#this.dsn#">
            DELETE FROM ACCOUNT_CARD_PAYMENT_TYPES WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payment_type_id#">
        </cfquery>
    </cffunction>

    <cffunction name="checkPaymentTypeIfUsed" access="public" returntype="numeric" hint="odeme sekilleri: check if used">
        <cfargument name="payment_type_id" default="">
        <cfquery name="periodcount" datasource="#this.dsn#">
            SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD
        </cfquery>
        <cfoutput query="periodcount">
            <cfquery name="get" datasource="#this.dsn#">
                SELECT TOP 1
                    AC.ACTION_DATE,
                    AC.CARD_PAYMENT_METHOD,
                    N.START_DATE,
                    N.FINISH_DATE
                FROM
                    #this.dsn#_#period_year#_#our_company_id#.ACCOUNT_CARD AC,
                    #this.dsn#_#period_year#_#our_company_id#.NETBOOKS N
                WHERE
                    AC.ACTION_DATE BETWEEN N.START_DATE AND N.FINISH_DATE AND
                    AC.CARD_PAYMENT_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payment_type_id#">
            </cfquery>
            <cfif get.recordcount>
                <cfreturn get.recordcount>
            </cfif>
        </cfoutput>
        <cfreturn 0>
    </cffunction>

    <cffunction name="updAccountCardPaymentTypes" access="public" returntype="any" hint="odeme sekilleri: upd">
        <cfargument type="numeric" name="is_active" default="1">
        <cfargument type="string" name="payment_type" default="">
        <cfargument type="string" name="detail" default="">
        <cfargument type="numeric" name="payment_type_id" default="">
        <cfquery name="upd" datasource="#this.dsn#">
            UPDATE
                ACCOUNT_CARD_PAYMENT_TYPES
            SET
                <cfif arguments.payment_type_id gte 0>
                    IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">,
                    PAYMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.payment_type#">,
                </cfif>
                DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payment_type_id#">
        </cfquery>
    </cffunction>

    <cffunction name="addAccountCardPaymentTypes" access="public" returntype="any" hint="odeme sekilleri: add">
        <cfargument type="numeric" name="is_active" default="">
        <cfargument type="string" name="payment_type" default="">
        <cfargument type="string" name="detail" default="">
        <cfquery name="GET_ID_MAX" datasource="#this.dsn#">
            SELECT
                MAX(PAYMENT_TYPE_ID) AS max_id
            FROM
                ACCOUNT_CARD_PAYMENT_TYPES
        </cfquery>
        <cfscript>
            if (GET_ID_MAX.max_id eq '')
                max_id = 1;
            else max_id = GET_ID_MAX.max_id + 1;
        </cfscript>
        <cfquery name="add" datasource="#this.dsn#" result="MAX_ID">
            INSERT INTO
                ACCOUNT_CARD_PAYMENT_TYPES
            (
                IS_ACTIVE,
                PAYMENT_TYPE_ID,
                PAYMENT_TYPE,
                DETAIL,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#max_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.payment_type#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            )
        </cfquery>
    </cffunction>
</cfcomponent>
