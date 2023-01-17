<cfcomponent>
    <cfset dsn = application.SystemParam.SystemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn_product = "#dsn#_product">

    <cffunction name = "select" access = "public" hint = "Select Worknet">
        <cfquery name="get_all_worknet" datasource="#dsn#">
            SELECT 
                WN.WORKNET_ID,
                WN.WORKNET,
                WN.WORKNET_STATUS,
                WN.IMAGE_PATH,
                WN.COMPANY_ID,
                WN.WEBSITE,
                WN.APPLICATION_WEB_ADRESS,
                WN.DETAIL,
                CMP.NICKNAME,
                CMP.FULLNAME,
                WN.SERVER_IMAGE_PATH_ID,
                WN.PARTNER_ID,
                CMPRT.COMPANY_PARTNER_NAME,
                CMPRT.COMPANY_PARTNER_SURNAME,
                WN.MANAGER_EMP,
                WN.MANAGER,
                WN.MANAGER_EMAIL,
                WN.RECORD_EMP,
                WN.RECORD_DATE,
                WN.UPDATE_EMP,
                WN.UPDATE_DATE
            FROM WORKNET AS WN
            JOIN COMPANY AS CMP ON CMP.COMPANY_ID = WN.COMPANY_ID
            JOIN COMPANY_PARTNER AS CMPRT ON CMPRT.PARTNER_ID = WN.PARTNER_ID
            WHERE
                1=1 
                <cfif isdefined("arguments.wid")>AND WN.WORKNET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wid#"></cfif>
                <cfif isdefined("arguments.status") and arguments.status eq 1>AND WN.WORKNET_STATUS = 1</cfif>
                <cfif isdefined("arguments.status") and arguments.status eq 2>AND WN.WORKNET_STATUS = 0</cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND WN.WORKNET LIKE '%#arguments.keyword#%'
                </cfif>
                <cfif not isdefined("session.ep")>
                    AND WN.IS_INTERNET = 1
                </cfif>
            ORDER BY WN.WORKNET_ID DESC
        </cfquery>
        <cfreturn get_all_worknet>
    </cffunction>

    <cffunction name="get" access="public">
        <cfreturn select()>
    </cffunction>

    <cffunction name = "insert" access = "public" hint = "Insert worknet">
        <cfset response = structNew()>
        <cfset response.status = true>
        <cftry>
            <cfquery name="add_worknet" datasource="#dsn#" result="result">
                INSERT INTO
                WORKNET
                (
                    WORKNET,
                    WEBSITE,
                    APPLICATION_WEB_ADRESS,
                    <!--- imagepath, --->
                    DETAIL,
                    COMPANY_ID,
                    PARTNER_ID,
                    WORKNET_STATUS,
                    STAGE,
                    MANAGER_EMP,
                    MANAGER,
                    MANAGER_EMAIL,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    IMAGE_PATH,
                    SERVER_IMAGE_PATH_ID
                )
                VALUES
                (
                    <cfqueryparam value = "#arguments.worknet#" CFSQLType = "cf_sql_nvarchar">,
                    <cfqueryparam value = "#arguments.website#" CFSQLType = "cf_sql_nvarchar">,
                    <cfqueryparam value = "#arguments.application_web_adress#" CFSQLType = "cf_sql_nvarchar">,
                    <!--- imagepath, --->
                    <cfqueryparam value = "#arguments.detail#" CFSQLType = "cf_sql_nvarchar">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">,
                    <cfqueryparam value = "#arguments.emp_name#" CFSQLType = "cf_sql_nvarchar">,
                    <cfqueryparam value = "#arguments.emp_email#" CFSQLType = "cf_sql_nvarchar">,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#',
                    <cfqueryparam value = "#arguments.image_path#" CFSQLType = "cf_sql_nvarchar">,
                    <cfqueryparam value = "#arguments.server_image_path_id#" CFSQLType = "cf_sql_integer">
                )
            </cfquery>
            <cfset response.result = result>
            <cfcatch type = "any">
                <cfset response.status = false>
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="update" returntype="any">
        <cftry>

            <cfquery name="upd_worknet" datasource="#dsn#" result="result">
                UPDATE
                    WORKNET
                SET
                    WORKNET = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.worknet#">,
                    WEBSITE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.website#">,
                    APPLICATION_WEB_ADRESS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.application_web_adress#">,
                    DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#">,
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">,
                    WORKNET_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                    MANAGER_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">,
                    MANAGER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.emp_name#">,
                    MANAGER_EMAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.emp_email#">,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_IP = '#cgi.remote_addr#',
                    IMAGE_PATH = <cfqueryparam value = "#arguments.image_path#" CFSQLType = "cf_sql_nvarchar">,
                    SERVER_IMAGE_PATH_ID = <cfqueryparam value = "#arguments.server_image_path_id#" CFSQLType = "cf_sql_integer">
                WHERE
                    WORKNET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wid#">
            </cfquery>
            <cfreturn true>
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
            
        </cftry>
    </cffunction>

    <cffunction name="delete" returntype="any">
        <cfquery name="del_worknet" datasource="#dsn#">
            DELETE FROM WORKNET WHERE WORKNET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wid#">
        </cfquery>
    </cffunction>

    <cffunction name="delRelationProduct" returntype="any">
        <cfquery name="del_product_worknet" datasource="#dsn#">
            DELETE FROM WORKNET_RELATION_PRODUCT WHERE WORKNET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wid#">
        </cfquery>
    </cffunction>

    <cffunction name="delRelationCompany" returntype="any">
        <cfquery name="del_company_worknet" datasource="#dsn#">
            DELETE FROM WORKNET_RELATION_COMPANY WHERE WORKNET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wid#">
        </cfquery>
    </cffunction>

    <cffunction name = "get_catalogs" access = "public" hint = "Select catalogs">
        <cfquery name="get_catalogs" datasource="#dsn3#">
            SELECT 
                C.*,
                CMP.FULLNAME,
                CMPS.CAMP_HEAD,
                EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS NAME
            FROM 
                CATALOG C LEFT JOIN  #dsn#.COMPANY CMP ON CMP.COMPANY_ID = C.TARGET_COMPANY
                LEFT JOIN CAMPAIGNS CMPS ON CMPS.CAMP_ID = C.CAMPAIGN_ID                
                LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = C.VALID_EMP                
            WHERE
                1=1
                <cfif isdefined("arguments.catalog_status") and len(arguments.catalog_status)>
                    AND CATALOG_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.catalog_status#">
                </cfif>
                <cfif isdefined("arguments.friendly_url") and len(arguments.friendly_url)>
                    AND FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.friendly_url#%">
                </cfif>
                <cfif isdefined("arguments.catalog_no") and len(arguments.catalog_no)>
                    AND CATALOG_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.catalog_no#%">
                </cfif>
                <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>
                    AND STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                </cfif>
                <cfif isdefined("arguments.target_company") and len(arguments.target_company) and len(arguments.target)>
                    AND TARGET_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="%#arguments.target_company#%">
                </cfif>
                <cfif isdefined("arguments.campaign_id") and len(arguments.campaign_id) and len(arguments.camp_name)>
                    AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="%#arguments.campaign_id#%">
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND (CATALOG_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR CATALOG_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
        </cfquery>
        <cfreturn get_catalogs>
    </cffunction>
    <cffunction name = "get_catalog" access = "public" hint = "Select catalog">
        <cfquery name="get_catalog" datasource="#dsn3#">
            SELECT 
                C.*,
                CMP.FULLNAME,
                CMPS.CAMP_HEAD,
                EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS NAME,
                STAGE
            FROM 
                CATALOG C LEFT JOIN  #dsn#.COMPANY CMP ON CMP.COMPANY_ID = C.TARGET_COMPANY
                LEFT JOIN CAMPAIGNS CMPS ON CMPS.CAMP_ID = C.CAMPAIGN_ID                
                LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = C.VALID_EMP           
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID = C.STAGE_ID
            WHERE
                CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catalog_id#">
        </cfquery>
        <cfreturn get_catalog>
    </cffunction>
    
    <cffunction  name="add_catalog"  access="public" returntype="any" hint="Katalog Ekleme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cf_get_lang_set module_name="worknet">
        <cftry>
            <cfquery name="ADD_CATALOG" datasource="#dsn3#"  result="my_result">
                INSERT INTO CATALOG
                (
                    CATALOG_STATUS
                    ,STAGE_ID
                    ,STARTDATE
                    ,FINISHDATE
                    ,KONDUSYON_DATE
                    ,CATALOG_HEAD
                    ,CATALOG_DETAIL
                    ,VALIDATE_DATE
                    ,VALID_EMP
                    ,VALIDATOR_POSITION_CODE
                    ,VALID
                    ,TARGET_CUSTOMER
                    ,TARGET_COMPANY
                    ,MONEY
                    ,PRICE
                    ,BARCOD
                    ,CATALOG_NO
                    ,MEMBER_TYPE
                    ,FRIENDLY_URL
                    ,CAMPAIGN_ID
                    ,RECORD_EMP
                    ,RECORD_DATE
                    ,RECORD_IP
                    )
                VALUES(
                
                    <cfif isdefined("arguments.CATALOG_STATUS") and len(arguments.CATALOG_STATUS)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.CATALOG_STATUS#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.STARTDATE") and len(arguments.STARTDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.STARTDATE#"><cfelse>NULL</cfif>,  
                    <cfif isdefined("arguments.FINISHDATE") and len(arguments.FINISHDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISHDATE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.KONDUSYON_DATE") and len(arguments.KONDUSYON_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.KONDUSYON_DATE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.CATALOG_HEAD") and len(arguments.CATALOG_HEAD)><cfqueryparam value = "#arguments.CATALOG_HEAD#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.CATALOG_DETAIL") and len(arguments.CATALOG_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATALOG_DETAIL#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.VALIDATE_DATE") and len(arguments.VALIDATE_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.VALIDATE_DATE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.VALID_EMP") and len(arguments.VALID_EMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.VALID_EMP#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.VALIDATOR_POSITION_CODE") and len(arguments.VALIDATOR_POSITION_CODE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.VALIDATOR_POSITION_CODE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.VALID") and len(arguments.VALID)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.VALID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.TARGET_CUSTOMER") and len(arguments.TARGET_CUSTOMER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TARGET_CUSTOMER#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.TARGET_COMPANY") and len(arguments.TARGET_COMPANY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TARGET_COMPANY#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.MONEY") and len(arguments.MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.MONEY#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.PRICE") and len(arguments.PRICE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.PRICE#"><cfelse>NULL</cfif>, 
                    <cfif isdefined("arguments.BARCOD") and len(arguments.BARCOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BARCOD#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.CATALOG_NO") and len(arguments.CATALOG_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATALOG_NO#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.MEMBER_TYPE") and len(arguments.MEMBER_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MEMBER_TYPE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.FRIENDLY_URL") and len(arguments.FRIENDLY_URL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FRIENDLY_URL#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.CAMPAIGN_ID") and len(arguments.CAMPAIGN_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CAMPAIGN_ID#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
            </cfquery>
             <cfquery name="GET_MAX_ORDER" datasource="#dsn3#" maxrows="1">
                SELECT * FROM CATALOG ORDER BY CATALOG_ID DESC
            </cfquery>
            <cfset attributes.is_upd = 0>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = GET_MAX_ORDER.CATALOG_ID>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction  name="upd_catalog"  access="public" returntype="any" hint="Katalog Güncelleme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="upd_catalog" datasource="#dsn3#"  result="my_result">
                UPDATE 
                    CATALOG
                SET
                    CATALOG_STATUS = <cfif isdefined("arguments.CATALOG_STATUS") and len(arguments.CATALOG_STATUS)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.CATALOG_STATUS#"><cfelse>NULL</cfif>,
                    STAGE_ID = <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                    STARTDATE = <cfif isdefined("arguments.STARTDATE") and len(arguments.STARTDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.STARTDATE#"><cfelse>NULL</cfif>,  
                    FINISHDATE = <cfif isdefined("arguments.FINISHDATE") and len(arguments.FINISHDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISHDATE#"><cfelse>NULL</cfif>,
                    KONDUSYON_DATE = <cfif isdefined("arguments.KONDUSYON_DATE") and len(arguments.KONDUSYON_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.KONDUSYON_DATE#"><cfelse>NULL</cfif>,
                    CATALOG_HEAD = <cfif isdefined("arguments.CATALOG_HEAD") and len(arguments.CATALOG_HEAD)><cfqueryparam value = "#arguments.CATALOG_HEAD#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
                    CATALOG_DETAIL = <cfif isdefined("arguments.CATALOG_DETAIL") and len(arguments.CATALOG_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATALOG_DETAIL#"><cfelse>NULL</cfif>,
                    VALIDATE_DATE = <cfif isdefined("arguments.VALIDATE_DATE") and len(arguments.VALIDATE_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.VALIDATE_DATE#"><cfelse>NULL</cfif>,
                    VALID_EMP = <cfif isdefined("arguments.VALID_EMP") and len(arguments.VALID_EMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.VALID_EMP#"><cfelse>NULL</cfif>,
                    VALIDATOR_POSITION_CODE = <cfif isdefined("arguments.VALIDATOR_POSITION_CODE") and len(arguments.VALIDATOR_POSITION_CODE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.VALIDATOR_POSITION_CODE#"><cfelse>NULL</cfif>,
                    VALID = <cfif isdefined("arguments.VALID") and len(arguments.VALID)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.VALID#"><cfelse>NULL</cfif>,
                    TARGET_CUSTOMER = <cfif isdefined("arguments.TARGET_CUSTOMER") and len(arguments.TARGET_CUSTOMER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TARGET_CUSTOMER#"><cfelse>NULL</cfif>,
                    TARGET_COMPANY = <cfif isdefined("arguments.TARGET_COMPANY") and len(arguments.TARGET_COMPANY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TARGET_COMPANY#"><cfelse>NULL</cfif>,
                    MONEY = <cfif isdefined("arguments.MONEY") and len(arguments.MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value = "#arguments.MONEY#"><cfelse>NULL</cfif>,
                    PRICE = <cfif isdefined("arguments.PRICE") and len(arguments.PRICE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.PRICE#"><cfelse>NULL</cfif>, 
                    BARCOD = <cfif isdefined("arguments.BARCOD") and len(arguments.BARCOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BARCOD#"><cfelse>NULL</cfif>,
                    CATALOG_NO =  <cfif isdefined("arguments.CATALOG_NO") and len(arguments.CATALOG_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATALOG_NO#"><cfelse>NULL</cfif>,
                    MEMBER_TYPE = <cfif isdefined("arguments.MEMBER_TYPE") and len(arguments.MEMBER_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MEMBER_TYPE#"><cfelse>NULL</cfif>,
                    FRIENDLY_URL = <cfif isdefined("arguments.FRIENDLY_URL") and len(arguments.FRIENDLY_URL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FRIENDLY_URL#"><cfelse>NULL</cfif>,
                    CAMPAIGN_ID = <cfif isdefined("arguments.CAMPAIGN_ID") and len(arguments.CAMPAIGN_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CAMPAIGN_ID#"><cfelse>NULL</cfif>,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                WHERE 
                    CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catalog_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = arguments.catalog_id>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction  name="del_catalog"  access="public" returntype="any" hint="Katalog Silme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="del_catalog" datasource="#dsn3#">
                DELETE FROM CATALOG WHERE CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catalog_id#"> 
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = arguments.catalog_id>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
    </cffunction>
    <cffunction  name="get_related_product"  access="public" returntype="any" hint="Kataloğa bağlı ürünler">
        <cfquery name="get_related_product" datasource="#dsn3#">
            SELECT
                P.PRODUCT_ID,
                P.PRODUCT_NAME,
                CP.CATALOGPRODUCT_ID,
                CP.CATALOG_ID
            FROM
                CATALOG_PRODUCTS AS CP 
                LEFT JOIN PRODUCT P ON CP.PRODUCT_ID = P.PRODUCT_ID   
            WHERE
                CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catalog_id#">
        </cfquery>
        <cfreturn get_related_product>
    </cffunction>
    <cffunction  name="add_related_product"  access="remote" returntype="any" hint="Numune Ekleme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="add_related_product" datasource="#dsn3#">

                INSERT INTO CATALOG_PRODUCTS
                (
                    CATALOG_ID,
                    PRODUCT_ID,
                    STOCK_ID
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catalog_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                )    
            </cfquery>
            <cfquery name="GET_MAX_ORDER" datasource="#dsn3#" maxrows="1">
                SELECT * FROM CATALOG_PRODUCTS ORDER BY CATALOGPRODUCT_ID DESC
            </cfquery>
            <cfset attributes.is_upd = 0>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = GET_MAX_ORDER.CATALOGPRODUCT_ID>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn Replace(serializeJSON(responseStruct),'//','')>
    </cffunction>
    <cffunction  name="delete_related_product"  access="remote" returntype="any" hint="Kataloğa bağlı ürün siliniyor">
        <cfquery name="delete_related_product" datasource="#dsn3#">
            DELETE FROM
                CATALOG_PRODUCTS  
            WHERE
                CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catalog_id#"> AND 
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> 
        </cfquery>
    </cffunction>
    <cffunction  name="related_promotions"  access="remote" returntype="any" hint="Kataloğa bağlı promosyonlar">
        <cfquery name="related_promotions" datasource="#dsn3#">
            SELECT 
                PROM_HEAD,
                PROM_ID 
            FROM 
                PROMOTIONS  
            WHERE
                CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catalog_id#"> 
        </cfquery>
        <cfreturn related_promotions>
    </cffunction>
    <cffunction  name="related_actions"  access="remote" returntype="any" hint="Kataloğa bağlı promosyonlar">
        <cfquery name="related_actions" datasource="#dsn3#">
            SELECT 
                CATALOG_HEAD,
                CATALOG_ID 
            FROM 
                CATALOG_PROMOTION  
            WHERE
                RELATED_CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catalog_id#"> 
        </cfquery>
        <cfreturn related_actions>
    </cffunction>
</cfcomponent>