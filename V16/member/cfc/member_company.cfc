<cfcomponent>
    <cfparam name="dsn" default="#application.SystemParam.SystemParam().dsn#">

    <cfif IsDefined("session.ep")>
        <cfparam name="session_base" default="#session.ep#">
    <cfelseif IsDefined("session.pp")>
        <cfparam name="session_base" default="#session.pp#">
    <cfelseif IsDefined("session.ww")>
        <cfparam name="session_base" default="#session.ww#">
    <cfelseif IsDefined("session.qq")>
        <cfparam name="session_base" default="#session.qq#">
    </cfif>
	<cfset upload_folder="#application.systemParam.systemParam().upload_folder#">

    <cffunction name="add_partner_protein" access="remote" returntype="any" returnformat="json">
        <cfset result = StructNew()>
        <cftry>
            <cfif isdefined("arguments.password") and len(arguments.password)>
                <CF_CRYPTEDPASSWORD	PASSWORD='#arguments.password#' OUTPUT='arguments.password' MOD=1>
            </cfif>
            <cftransaction>
                <cfquery name="add_partner_protein" datasource="#dsn#" result="MAX_ID">
                    INSERT INTO COMPANY_PARTNER(
                        COMPANY_ID,
                        COMPANY_PARTNER_STATUS,
                        COMPANY_PARTNER_NAME,
                        COMPANY_PARTNER_SURNAME,
                        MISSION,
                        CP_STATUS_ID,
                        COMPANY_PARTNER_EMAIL,
                        MOBIL_CODE,
                        MOBILTEL,
                        SEX,
                        COMPANY_PARTNER_USERNAME,
                        COMPANY_PARTNER_PASSWORD,
                        RECORD_DATE
                    )
                    VALUES(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                        1,
                        <cfif isdefined('arguments.company_partner_name') and len(arguments.company_partner_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_partner_name#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.company_partner_surname') and len(arguments.company_partner_surname)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_partner_surname#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.mission') and len(arguments.mission)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mission#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.status_id') and len(arguments.status_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status_id#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.company_partner_email') and len(arguments.company_partner_email)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_partner_email#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.mobilcat_id') and len(arguments.mobilcat_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.mobilcat_id#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.mobiltel') and len(arguments.mobiltel)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.mobiltel#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.sex') and len(arguments.sex)><cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.sex#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.username') and len(arguments.username)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.username#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.password') and len(arguments.password)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.password#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
                </cfquery>
                <cfquery name="UPD_MEMBER_CODE" datasource="#dsn#">
                    UPDATE
                        COMPANY_PARTNER
                    SET
                        MEMBER_CODE = <cfqueryparam value="CP#MAX_ID.IDENTITYCOL#" cfsqltype="cf_sql_nvarchar">
                    WHERE
                        PARTNER_ID = <cfqueryparam value="#MAX_ID.IDENTITYCOL#" cfsqltype="cf_sql_integer">
                </cfquery> 
            </cftransaction>
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <!---<cfset result.identity = arguments.company_id>--->
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="upd_partner_protein" access="remote" returntype="any" returnformat="json">
        <cfset result = StructNew()>
        <cftry>       
            <cfif isdefined("arguments.password") and len(arguments.password)>
                <CF_CRYPTEDPASSWORD	PASSWORD='#arguments.password#' OUTPUT='arguments.password' MOD=1>
            </cfif>
            <cftransaction>
                <cfquery name="upd_partner_protein" datasource="#dsn#">
                    UPDATE
                        COMPANY_PARTNER
                    SET
                        COMPANY_PARTNER_NAME = <cfif isdefined('arguments.company_partner_name') and len(arguments.company_partner_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_partner_name#"><cfelse>NULL</cfif>,
                        COMPANY_PARTNER_SURNAME = <cfif isdefined('arguments.company_partner_surname') and len(arguments.company_partner_surname)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_partner_surname#"><cfelse>NULL</cfif>,
                        MISSION = <cfif isdefined('arguments.mission') and len(arguments.mission)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mission#"><cfelse>NULL</cfif>,
                        CP_STATUS_ID = <cfif isdefined('arguments.status_id') and len(arguments.status_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status_id#"><cfelse>NULL</cfif>,
                        COMPANY_PARTNER_EMAIL = <cfif isdefined('arguments.company_partner_email') and len(arguments.company_partner_email)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_partner_email#"><cfelse>NULL</cfif>,
                        <cfif isdefined('form.file') and len(form.file) and form.file neq "undefined">PHOTO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#form.file#">,</cfif>
                        MOBIL_CODE = <cfif isdefined('arguments.mobilcat_id') and len(arguments.mobilcat_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.mobilcat_id#"><cfelse>NULL</cfif>,
                        MOBILTEL = <cfif isdefined('arguments.mobiltel') and len(arguments.mobiltel)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.mobiltel#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.username') and len(arguments.username)>COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.username#">,</cfif>
                        <cfif isdefined('arguments.password') and len(arguments.password)>COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.password#">,</cfif>
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                </cfquery>
            </cftransaction>
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <!---<cfset result.identity = arguments.company_id>--->
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
    <cffunction name="upd_partner_img" access="remote" returntype="any" returnformat="json">
        <cfset result = StructNew()>
        <cftry>
            <cfif isDefined("arguments.avatar") and len(arguments.avatar) and arguments.avatar neq "undefined">               
                <cfquery name="resim" datasource="#DSN#">
                    SELECT 
                        PHOTO,
                        PHOTO_SERVER_ID,
                        PARTNER_ID
                    FROM 
                        COMPANY_PARTNER
                    WHERE 
                        PARTNER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                </cfquery>
                <cfset upload_folder = "#upload_folder#/hr/">
                <cfif len(resim.photo) and fileExists("#upload_folder##resim.photo#")>
                    <cffile action="delete" file="#upload_folder##resim.photo#">
                </cfif>            
                <cffile
                    action="UPLOAD" 
                    filefield="avatar" 
                    destination="#upload_folder#" 
                    mode="777" 
                    nameconflict="MAKEUNIQUE"
                    >                   

                <cfset file_name = createUUID()>
                <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
                <cfset arguments.avatar = '#file_name#.#cffile.serverfileext#'>
                <cfquery name="upd_partner_protein" datasource="#dsn#">
                    UPDATE
                        COMPANY_PARTNER
                    SET
                        <cfif isdefined('arguments.avatar') and len(arguments.avatar) and arguments.avatar neq "undefined">PHOTO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.avatar#">,</cfif>
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                </cfquery>
                <cfset result.status = true>
                <cfset result.success_message = "Upload success">
            <cfelse>
                <cfset result.status = false>
                <cfset result.danger_message = "Upload error">
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Upload error">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>       
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
    <cffunction name="upd_member_protein" access="remote" returntype="any" returnformat="json">
        <cfset result = StructNew()>
        <cftry>
            <cftransaction>
                <cfquery name="upd_member_protein" datasource="#dsn#">
                    UPDATE
                        COMPANY 
                    SET
                        FULLNAME = <cfif isdefined('arguments.fullname') and len(arguments.fullname)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fullname#"><cfelse>NULL</cfif>,
                        TAXOFFICE = <cfif isdefined('arguments.taxoffice') and len(arguments.taxoffice)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.taxoffice#"><cfelse>NULL</cfif>,
                        TAXNO = <cfif isdefined('arguments.taxno') and len(arguments.taxno)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.taxno#"><cfelse>NULL</cfif>,
                        COMPANY_EMAIL = <cfif isdefined('arguments.company_email') and len(arguments.company_email)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_email#"><cfelse>NULL</cfif>,
                        HOMEPAGE = <cfif isdefined('arguments.homepage') and len(arguments.homepage)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.homepage#"><cfelse>NULL</cfif>,
                        COMPANY_TELCODE = <cfif isdefined('arguments.company_telcode') and len(arguments.company_telcode)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_telcode#"><cfelse>NULL</cfif>,
                        COMPANY_TEL1 = <cfif isdefined('arguments.company_tel1') and len(arguments.company_tel1)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_tel1#"><cfelse>NULL</cfif>,
                        MANAGER_PARTNER_ID = <cfif isdefined('arguments.manager_partner_id') and len(arguments.manager_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.manager_partner_id#"><cfelse>NULL</cfif>,
                        COUNTRY = <cfif isdefined('arguments.country') and len(arguments.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#"><cfelse>NULL</cfif>,
                        CITY = <cfif isdefined('arguments.city_id') and len(arguments.city_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"><cfelse>NULL</cfif>,
                        COMPANY_ADDRESS = <cfif isdefined('arguments.company_address') and len(arguments.company_address)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_address#"><cfelse>NULL</cfif>,
                        COUNTY = <cfif isdefined('arguments.county_id') and len(arguments.county_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"><cfelse>NULL</cfif>,
                        SEMT = <cfif isdefined('arguments.semt') and len(arguments.semt)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.semt#"><cfelse>NULL</cfif>,
                        DISTRICT_ID = <cfif isdefined('arguments.district_id') and len(arguments.district_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.district_id#"><cfelse>NULL</cfif>,
                        COMPANY_POSTCODE = <cfif isdefined('arguments.company_postcode') and len(arguments.company_postcode)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.company_postcode#"><cfelse>NULL</cfif>
                    WHERE
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfquery>
            </cftransaction>
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <!---<cfset result.identity = arguments.company_id>--->
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- List page query --->
    <cffunction name="GET_SALES_ZONES" returntype="query">
        <cfargument name="language" default="#session_base.language#">
        <cfquery name="GET_SALES_ZONES" datasource="#DSN#">
            SELECT SZ_ID,#dsn#.Get_Dynamic_Language(SZ_ID,'#arguments.language#','SALES_ZONES','SZ_NAME',null,null,SZ_NAME) AS SZ_NAME ,SZ_HIERARCHY+'_' SZ_HIERARCHY FROM SALES_ZONES ORDER BY SZ_NAME
        </cfquery>
        <cfreturn GET_SALES_ZONES>
    </cffunction>

    <cffunction name="GET_PERIOD" returntype="query">
        <cfargument name="emp_id" default="#session_base.userid#">
        <cfquery name="GET_PERIOD" datasource="#DSN#">
            SELECT
                OUR_COMPANY.COMP_ID,
                OUR_COMPANY.COMPANY_NAME,
                SETUP_PERIOD.PERIOD_ID,
                SETUP_PERIOD.PERIOD
            FROM
                SETUP_PERIOD WITH (NOLOCK),
                OUR_COMPANY WITH (NOLOCK),
                EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK)
            WHERE 
                EPP.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
                EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #arguments.emp_id# AND IS_MASTER = 1) AND
                SETUP_PERIOD.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
            ORDER BY 
                OUR_COMPANY.COMPANY_NAME,
                SETUP_PERIOD.PERIOD_YEAR
        </cfquery>
        <cfreturn GET_PERIOD>
    </cffunction>

    <cffunction name="GET_COMP" returntype="query">
        <cfquery name="GET_COMP" dbtype="query">
            SELECT DISTINCT COMP_ID,COMPANY_NAME FROM GET_PERIOD ORDER BY COMPANY_NAME
        </cfquery>
        <cfreturn GET_COMP>
    </cffunction>

    <cffunction name="GET_PERIODID" returntype="query">
        <cfargument name="comp_id" default="">
        <cfquery name="GET_PERIODID" dbtype="query">
            SELECT COMP_ID,PERIOD_ID,PERIOD FROM GET_PERIOD WHERE COMP_ID = #arguments.comp_id#
        </cfquery>
        <cfreturn GET_PERIODID>
    </cffunction>

    <cffunction name="GET_CUSTOMER_VALUE" returntype="query">
        <cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
            SELECT
                CUSTOMER_VALUE_ID,
                CUSTOMER_VALUE 
            FROM
                SETUP_CUSTOMER_VALUE WITH (NOLOCK)
            ORDER BY
                CUSTOMER_VALUE
        </cfquery>
        <cfreturn GET_CUSTOMER_VALUE>
    </cffunction>

    <cffunction name="GET_COMPANY_STAGE" returntype="query">
        <cfargument name="language" default="#session_base.language#">
        <cfargument name="company_id" default="#session_base.company_id#">
        <cfquery name="GET_COMPANY_STAGE" datasource="#DSN#">
            SELECT
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE PTR.STAGE
                END AS STAGE
                ,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR WITH (NOLOCK)
                 LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTR.PROCESS_ROW_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language#">
                ,
                PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
                PROCESS_TYPE PT WITH (NOLOCK)
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_list_company%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_COMPANY_STAGE>
    </cffunction>

    <cffunction name="GET_COMPANYCAT" returntype="query">
        <cfargument name="language" default="#session_base.language#">
        <cfargument name="company_id" default="#session_base.company_id#">
        <cfargument name="emp_id" default="#session_base.userid#">
        <cfquery name="GET_COMPANYCAT" datasource="#DSN#">
            SELECT DISTINCT	
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE COMPANYCAT
                END AS COMPANYCAT,
                COMPANYCAT_ID
            FROM
                GET_MY_COMPANYCAT WITH (NOLOCK)
                LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = GET_MY_COMPANYCAT.COMPANYCAT_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMPANYCAT">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMPANY_CAT">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language#">
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"> AND
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            ORDER BY
                COMPANYCAT
        </cfquery>
        <cfreturn GET_COMPANYCAT>
    </cffunction>

    <cffunction name="GET_OURCMP_INFO" returntype="query">
        <cfargument name="company_id" default="#session_base.company_id#">
        <cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
            SELECT IS_STORE_FOLLOWUP, ISNULL(IS_WATALOGY_INTEGRATED,0) AS IS_WATALOGY_INTEGRATED, WATALOGY_MEMBER_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn GET_OURCMP_INFO>
    </cffunction>

    <cffunction name="get_company_list_fnc_protein" returntype="query">
        <cfargument name="cpid" default="">
        <cfquery name="GET_COMPANY" datasource="#DSN#">
            SELECT
                C.*
            FROM
                COMPANY C WITH (NOLOCK)
            WHERE
                C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#">
        </cfquery>
        <cfreturn GET_COMPANY>
    </cffunction>

    <cffunction name="get_company_list_fnc" returntype="query">
        <cfargument name="cpid" default="">
        <cfargument name="row_block" default="">
        <cfargument name="get_hierarchies_recordcount" default="0">
        <cfargument name="is_store_followup" default="">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfargument name="position_code" default="#session_base.position_code#">
        <cfargument name="sales_zone_followup" default="#session_base.our_company_info.sales_zone_followup#">
        <cfargument name="isBranchAuthorization" default="#session_base.isBranchAuthorization#">
        <cfif arguments.sales_zone_followup eq 1>
            <cfquery name="GET_HIERARCHIES" datasource="#DSN#">
                SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
            </cfquery>
        </cfif>
        <cfquery name="GET_COMPANY" datasource="#DSN#">
            SELECT
                C.*,
                C.VISIT_CAT_ID
            FROM
                COMPANY C WITH (NOLOCK)
            <cfif arguments.isBranchAuthorization and arguments.is_store_followup eq 1>
                ,COMPANY_BRANCH_RELATED
            </cfif>
            WHERE
                C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#">
                <cfif len(company_cat_list)>
                    AND C.COMPANYCAT_ID IN (#company_cat_list#)
                </cfif>
                  <cfif arguments.isBranchAuthorization and arguments.is_store_followup eq 1>
                    AND COMPANY_BRANCH_RELATED.COMPANY_ID = C.COMPANY_ID
                    AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL
                    AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">)
                </cfif>
                <cfif arguments.sales_zone_followup eq 1>
                    <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
                    AND ( C.IMS_CODE_ID IN ( SELECT IMS_ID FROM SALES_ZONES_ALL_2 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#"> AND (COMPANY_CAT_IDS IS NULL OR (COMPANY_CAT_IDS IS NOT NULL AND ','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(C.COMPANYCAT_ID AS NVARCHAR)+',%')))
                        <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                        <cfif get_hierarchies.recordcount>
                            OR C.IMS_CODE_ID IN (
                                                    SELECT
                                                        IMS_ID
                                                    FROM
                                                        SALES_ZONES_ALL_1
                                                    WHERE											
                                                        <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                                            <cfset start_row=(page_stock*row_block)+1>	
                                                            <cfset end_row=start_row+(row_block-1)>
                                                            <cfif (end_row) gte get_hierarchies.recordcount>
                                                                <cfset end_row=get_hierarchies.recordcount>
                                                            </cfif>
                                                                (
                                                                <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                                    <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#.%'
                                                                </cfloop>
                                                                
                                                                )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                                        </cfloop>											
                                                )
                         </cfif>						
                    )
                </cfif>
        </cfquery>
        <cfreturn GET_COMPANY>
    </cffunction>

    <cffunction name="get_company_list_fnc2" returntype="query">
        <cfargument name="cpid" default="">
        <cfargument name="is_store_followup" default="">
        <cfargument name="get_hierarchies_recordcount" default="">
        <cfargument name="row_block" default="">
        <cfargument name="period_id" default="">
        <cfargument name="responsible_branch_id" default="">
        <cfargument name="blacklist_status" default="">
        <cfargument name="get_companycat_recordcount" default="">
        <cfargument name="process_stage_type" default="">
        <cfargument name="record_emp" default="">
        <cfargument name="record_name" default="">
        <cfargument name="city" default="">
        <cfargument name="sales_zones" default="">
        <cfargument name="sector_cat_id" default="">
        <cfargument name="pos_code" default="">
        <cfargument name="pos_code_text" default="">
        <cfargument name="search_potential" default="">
        <cfargument name="is_related_company" default="">
        <cfargument name="comp_cat" default="">
        <cfargument name="search_status" default="">
        <cfargument name="customer_value" default="">
        <cfargument name="country_id" default="">
        <cfargument name="city_id" default="">
        <cfargument name="county_id" default="">
        <cfargument name="keyword" default="">
        <cfargument name="watalogy_code" type="string" default="">
		<cfargument name="marketplace" type="string" default="">
        <cfargument name="is_sale_purchase" default="">
        <cfargument name="keyword_partner" default="">
        <cfargument name="database_type" default="">
        <cfargument name="get_companycat_companycat_id" default="">	
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="#session_base.maxrows#">
        <cfargument name="is_fulltext_search" default="">
        <cfargument name="use_efatura" default="">
        <cfargument name="tax_no" default="">
        <cfargument name="tc_identity" default="">
        <cfargument name="private_code" default="">
        <cfargument name="sales_zone_followup" default="#session_base.our_company_info.sales_zone_followup#">
        <cfargument name="position_code" default="#session_base.position_code#">
        <cfargument name="isBranchAuthorization" default="#session_base.isBranchAuthorization#">
        <cfargument name="ep_company_id" default="#session_base.company_id#">
        <cfargument name="user_location" default="#session_base.user_location#">

        <cfif arguments.sales_zone_followup eq 1>
            <cfquery name="GET_HIERARCHIES" datasource="#DSN#">
                SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
            </cfquery>
        </cfif>	
        <cfquery name="GET_COMPANY" datasource="#DSN#">
        WITH CTE1 AS(	
            SELECT
                <cfif (len(arguments.period_id) and (listgetat(arguments.period_id,2,',') eq 0)) or arguments.isBranchAuthorization and arguments.is_store_followup eq 1>DISTINCT</cfif>
                COMPANY.COMPANY_STATUS COMPANY_STATUS,
                COMPANY.COMPANY_ID COMPANY_ID,
                COMPANY.FULLNAME FULLNAME,
                COMPANY.MANAGER_PARTNER_ID MANAGER_PARTNER_ID,
                COMPANY.COMPANYCAT_ID COMPANYCAT_ID,
                COMPANY.MEMBER_CODE MEMBER_CODE,
                COMPANY.OZEL_KOD OZEL_KOD,
                COMPANY.CITY,
                COMPANY.COUNTY,
                COMPANY.SEMT,
                COMPANY.COUNTRY,
                COMPANY.WATALOGY_MEMBER_CODE,
                COMPANY.COORDINATE_1,
                COMPANY.COORDINATE_2,
                COMPANY.RECORD_EMP,
                COMPANY.RECORD_PAR,
                COMPANY.CAMPAIGN_ID,
                COMPANY.ISPOTANTIAL ISPOTANTIAL,
                COMPANY.VISIT_CAT_ID,
                (	
                    SELECT
                        TOP 1 POSITION_CODE 
                    FROM
                        WORKGROUP_EMP_PAR
                    WHERE
                        IS_MASTER = 1 AND
                        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ep_company_id#"> AND 
                        COMPANY_ID = COMPANY.COMPANY_ID AND
                        COMPANY_ID IS NOT NULL
                ) POSITION_CODE
            FROM
                <cfif len(arguments.keyword_partner) or len(arguments.tc_identity)>COMPANY_PARTNER WITH (NOLOCK),</cfif>
                <cfif arguments.isBranchAuthorization and arguments.is_store_followup eq 1>COMPANY_BRANCH_RELATED WITH (NOLOCK),</cfif>
                <cfif isDefined('arguments.responsible_branch_id') and len(arguments.responsible_branch_id)>SALES_ZONES WITH (NOLOCK),</cfif>
                <cfif len(arguments.period_id)>COMPANY_PERIOD WITH (NOLOCK),</cfif>
                COMPANY WITH (NOLOCK)
                <cfif len(arguments.marketplace)>
					LEFT JOIN WORKNET_RELATION_COMPANY WRC ON COMPANY.COMPANY_ID = WRC.COMPANY_ID
				</cfif>
            WHERE
                COMPANY.COMPANY_ID IS NOT NULL
                <cfif len(arguments.marketplace)>
					AND WRC.WORKNET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.marketplace#">
				</cfif>
                <cfif len(arguments.watalogy_code)>
					AND WATALOGY_MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.watalogy_code#%">
				</cfif>
                 <cfif arguments.isBranchAuthorization and arguments.is_store_followup eq 1>
                    AND COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID
                    AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL
                    AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (#ListGetAt(arguments.user_location,2,'-')#)
                    AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">)
                </cfif>
                <cfif isdefined("arguments.blacklist_status") and len(arguments.blacklist_status)>
                AND COMPANY.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_CREDIT WHERE IS_BLACKLIST = 1)
                </cfif>
                <cfif get_companycat_recordcount>
                    AND COMPANY.COMPANYCAT_ID IN (#arguments.get_companycat_companycat_id#)
                <cfelse>
                    AND COMPANY.COMPANYCAT_ID IS NULL
                </cfif>
                <cfif len(arguments.tax_no)>
                    AND COMPANY.TAXNO LIKE   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_no#%">
                </cfif>
                <cfif len(arguments.period_id)>
                    AND COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID
                    <cfif listgetat(arguments.period_id,2,',') eq 1>
                        AND COMPANY_PERIOD.PERIOD_ID = #listgetat(arguments.period_id,4,',')#
                    <cfelse>
                        AND COMPANY_PERIOD.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(arguments.period_id,3,',')#)
                    </cfif>
                </cfif>
                <cfif isdefined("arguments.process_stage_type") and len(arguments.process_stage_type)>
                    AND COMPANY.COMPANY_STATE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage_type#">
                </cfif>
                <cfif len(arguments.record_emp) and len(arguments.record_name)>
                    AND COMPANY.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp#">
                </cfif>
                  <cfif isDefined("arguments.city") and len(arguments.city)>AND COMPANY.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#"></cfif>
                  <cfif isDefined("arguments.sales_zones") and len(arguments.sales_zones)><!--- Kendisi ve alt kirilimlarinin da gelmesi icin --->
                    <cfset arguments.sales_zones = replace(arguments.sales_zones,'_','')>
                    AND COMPANY.SALES_COUNTY IN (SELECT SZ_ID FROM SALES_ZONES WHERE (SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sales_zones#"> OR SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sales_zones#.%">))
                  </cfif>
                <cfif isDefined("arguments.sector_cat_id") and len(arguments.sector_cat_id)>
                    AND (
                            COMPANY.COMPANY_ID IN (
                                                    SELECT 
                                                        COMPANY_ID 
                                                    FROM 
                                                        COMPANY_SECTOR_RELATION CSR1 
                                                    WHERE 
                                                        CSR1.SECTOR_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sector_cat_id#">
                                                 )
                        )
                </cfif>
                  <cfif isDefined("arguments.pos_code") and len(arguments.pos_code) and len(arguments.pos_code_text)>
                    AND COMPANY.COMPANY_ID IN 
                    (SELECT COMPANY_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_code#"> AND IS_MASTER=1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ep_company_id#"> AND COMPANY_ID IS NOT NULL)
                  </cfif>
                  <cfif isDefined("arguments.search_potential") and len(arguments.search_potential)>AND COMPANY.ISPOTANTIAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.search_potential#"></cfif>
                  <cfif isDefined("arguments.is_related_company") and len(arguments.is_related_company)>AND COMPANY.IS_RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_related_company#"></cfif>
                  <cfif isDefined("arguments.comp_cat") and len(arguments.comp_cat)>AND COMPANY.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_cat#"></cfif>
                  <cfif isDefined('arguments.search_status') and len(arguments.search_status)>AND COMPANY.COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.search_status#"></cfif>
                  <cfif isdefined("arguments.customer_value") and len(arguments.customer_value)> AND COMPANY.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.customer_value#"></cfif>
                  <cfif isdefined('arguments.country_id') and len(arguments.country_id)>AND COMPANY.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country_id#"></cfif>
                  <cfif isdefined('arguments.city_id') and len(arguments.city_id)>AND COMPANY.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"></cfif>
                  <cfif isdefined('arguments.county_id') and len(arguments.county_id)>AND COMPANY.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"></cfif>
                  <cfif isDefined('arguments.keyword') and len(arguments.keyword)>
                    
                    
                    <cfif isdefined("arguments.is_fulltext_search") and arguments.is_fulltext_search eq 1 >
                        AND CONTAINS(COMPANY.*,'"#arguments.keyword#*"')
                    <cfelse>
                                AND
                            (
                                <cfif len(arguments.keyword) gt 2>
                                    COMPANY.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.OZEL_KOD_1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.OZEL_KOD_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI	
                                <cfelse>
                                    COMPANY.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.OZEL_KOD_1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.OZEL_KOD_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                    COMPANY.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                                </cfif>
                            )
                    </cfif>
                  </cfif>
                <cfif isdefined('arguments.private_code') and len (arguments.private_code)>
                    AND COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.private_code#%">
                </cfif>
                  <cfif isDefined('arguments.is_sale_purchase') and arguments.is_sale_purchase is 1>
                    AND COMPANY.IS_BUYER = 1
                  <cfelseif isDefined('arguments.is_sale_purchase') and arguments.is_sale_purchase is 2>
                    AND COMPANY.IS_SELLER = 1
                  </cfif>
                  <cfif len(arguments.keyword_partner) or len(arguments.tc_identity)>
                    AND COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1
                    AND COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID 
                    AND (
                        <cfif len(arguments.keyword_partner)>
                            (COMPANY_PARTNER.TITLE LIKE '<cfif len(arguments.keyword_partner) gt 1>%</cfif>#arguments.keyword_partner#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                            COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '<cfif len(arguments.keyword_partner) gt 1>%</cfif>#arguments.keyword_partner#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
                             <cfif len(arguments.tc_identity)>
                                  <cfif len(arguments.keyword_partner)> AND </cfif>COMPANY_PARTNER.TC_IDENTITY LIKE '<cfif len(arguments.tc_identity) gt 1>%</cfif>#arguments.tc_identity#%'
                            </cfif>
                        <cfelseif len(arguments.tc_identity)>
                              COMPANY_PARTNER.TC_IDENTITY LIKE '<cfif len(arguments.tc_identity) gt 1>%</cfif>#arguments.tc_identity#%'                    
                        </cfif>
                       
                        )                    
                </cfif>
                <cfif arguments.sales_zone_followup eq 1>
        
                    <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
                    AND (COMPANY.IMS_CODE_ID IN ( 
                        SELECT
                             IMS_ID 
                        FROM 
                            SALES_ZONES_ALL_2
                         WHERE 
                            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">  
                            AND (COMPANY_CAT_IDS IS NULL OR (COMPANY_CAT_IDS IS NOT NULL AND ','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(COMPANY.COMPANYCAT_ID AS NVARCHAR)+',%'))
                    )
            
                    <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                    <cfif get_hierarchies.recordcount>
                        OR COMPANY.IMS_CODE_ID IN (
                                                    SELECT
                                                        IMS_ID
                                                    FROM
                                                        SALES_ZONES_ALL_1
                                                    WHERE											
                                                        <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                                            <cfset start_row=(page_stock*row_block)+1>	
                                                            <cfset end_row=start_row+(row_block-1)>
                                                            <cfif (end_row) gte get_hierarchies.recordcount>
                                                                <cfset end_row=get_hierarchies.recordcount>
                                                            </cfif>
                                                                (
                                                                <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                                    <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#.%'
                                                                </cfloop>
                                                                
                                                                )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                                        </cfloop>											
                                                    )
                    </cfif>						
                    )
                </cfif>
                <cfif len(arguments.use_efatura)>
                    AND COMPANY.USE_EFATURA = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.use_efatura#">
                </cfif>
                GROUP BY  COMPANY.COMPANY_ID,
                COMPANY.MEMBER_CODE,
                COMPANY.OZEL_KOD,
                COMPANY.OZEL_KOD_1,
                COMPANY.OZEL_KOD_2 ,
                COMPANY.NICKNAME,
                COMPANY.COMPANY_STATUS,
                COMPANY.COMPANY_ID ,
                COMPANY.FULLNAME ,
                COMPANY.MANAGER_PARTNER_ID ,
                COMPANY.COMPANYCAT_ID ,
                COMPANY.OZEL_KOD ,
                COMPANY.CITY,
                COMPANY.COUNTY,
                COMPANY.SEMT,
                COMPANY.COUNTRY,
                COMPANY.WATALOGY_MEMBER_CODE,
                COMPANY.COORDINATE_1,
                COMPANY.COORDINATE_2,
                COMPANY.RECORD_EMP,
                COMPANY.RECORD_PAR,
                COMPANY.CAMPAIGN_ID,
                COMPANY.ISPOTANTIAL ,
                COMPANY.VISIT_CAT_ID
            ),
            CTE2 AS 
                (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (ORDER BY FULLNAME ASC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
        </cfquery>
        <cfreturn GET_COMPANY>
    </cffunction>

    <cffunction name="GET_COUNTRY" returntype="query">
        <cfargument name="COUNTRY" default="">
        <cfquery name="GET_COUNTRY" datasource="#DSN#">
            SELECT COUNTRY_ID, COUNTRY_NAME ,IS_DEFAULT FROM SETUP_COUNTRY WHERE 1=1 <cfif len(arguments.COUNTRY)>AND COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COUNTRY#"></cfif>
        </cfquery>
        <cfreturn GET_COUNTRY>
    </cffunction>

    <cffunction name="GET_CITY" returntype="query">
        <cfargument name="country_id" default="">
        <cfargument name="event" default="">
        <cfquery name="GET_CITY" datasource="#dsn#">
            SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE 1 = 1 <cfif isDefined("arguments.country_id") and len(arguments.country_id)>AND COUNTRY_ID = #arguments.country_id# ORDER BY CITY_NAME</cfif>
        </cfquery>
        <cfreturn GET_CITY>
    </cffunction>

    <cffunction name="GET_COUNTY" returntype="query">
        <cfargument name="city_id" default="">
        <cfquery name="get_county" datasource="#DSN#">
            SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE 1 = 1 <cfif isDefined("arguments.city_id") and len(arguments.city_id)>AND CITY = #arguments.city_id# ORDER BY COUNTY_NAME</cfif>
        </cfquery>
        <cfreturn get_county>
    </cffunction>

    <cffunction name="GET_PARTNER" returntype="query">
        <cfargument name="partner_id_list" default="">
        <cfquery name="GET_PARTNER" datasource="#DSN#">
            SELECT
                COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                COMPANY_PARTNER.PARTNER_ID,
                COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                COMPANY.NICKNAME,
                COMPANY.COMPANY_ID
            FROM
                COMPANY_PARTNER,
                COMPANY
            WHERE
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                COMPANY_PARTNER.PARTNER_ID IN (#arguments.partner_id_list#)
            ORDER BY
                COMPANY_PARTNER.PARTNER_ID
        </cfquery>
        <cfreturn GET_PARTNER>
    </cffunction>

    <cffunction name="GET_BAKIYE" returntype="query">
        <cfargument name="company_id_list" default="">
        <cfargument name="dsn2" default="">
        <cfquery name="GET_BAKIYE" datasource="#arguments.dsn2#">
            SELECT
                BAKIYE,
                COMPANY_ID
            FROM
                COMPANY_REMAINDER
            WHERE
                COMPANY_ID IN (#arguments.company_id_list#)
                ORDER BY COMPANY_ID
        </cfquery>
        <cfreturn GET_BAKIYE>
    </cffunction>

    <cffunction name="GET_POS_CODE" returntype="query">
        <cfargument name="pos_code_list" default="">
        <cfquery name="GET_POS_CODE" datasource="#DSN#">
            SELECT
                POSITION_CODE,
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME,
                EMPLOYEE_ID
            FROM
                EMPLOYEE_POSITIONS
            WHERE
                POSITION_STATUS = 1 AND
                POSITION_CODE IN (#arguments.pos_code_list#)
            ORDER BY
                POSITION_CODE
        </cfquery>
        <cfreturn GET_POS_CODE>
    </cffunction>

    <cffunction name="GET_COMPANY_CAT" returntype="query">
        <cfargument name="company_cat_id_list" default="">
        <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
            SELECT
                COMPANYCAT_ID,
                COMPANYCAT
            FROM
                COMPANY_CAT
            WHERE
                COMPANYCAT_ID IN (#arguments.company_cat_id_list#)
            ORDER BY
                COMPANYCAT_ID
        </cfquery>
        <cfreturn GET_COMPANY_CAT>
    </cffunction>

    <cffunction name="GET_COMPANY_CITY" returntype="query">
        <cfargument name="city_list" default="">
        <cfquery name="GET_COMPANY_CITY" datasource="#DSN#">
            SELECT
                CITY_ID,
                CITY_NAME
            FROM
                SETUP_CITY
            WHERE
                CITY_ID IN (#arguments.city_list#)
            ORDER BY
                CITY_ID
        </cfquery>
        <cfreturn GET_COMPANY_CITY>
    </cffunction>

    <cffunction name="GET_COMPANY_COUNTY" returntype="query">
        <cfargument name="county_list" default="">
        <cfquery name="GET_COMPANY_COUNTY" datasource="#DSN#">
            SELECT
                COUNTY_ID,
                COUNTY_NAME
            FROM
                SETUP_COUNTY
            WHERE
                COUNTY_ID IN (#arguments.county_list#)
            ORDER BY
                COUNTY_ID
        </cfquery>
        <cfreturn GET_COMPANY_COUNTY>
    </cffunction>
    <!---  --->

    <!--- Add page query --->

    <cffunction name="GET_COMPANY_SECTOR_UPPER" returntype="query">
        <cfquery name="GET_COMPANY_SECTOR_UPPER" datasource="#DSN#">
            SELECT 
                SECTOR_UPPER_ID,
                SECTOR_CAT
            FROM 
                SETUP_SECTOR_CAT_UPPER
            ORDER BY 
                SECTOR_CAT
        </cfquery>
        <cfreturn GET_COMPANY_SECTOR_UPPER>
    </cffunction>
    <cffunction name="GET_COMPANY_SECTOR" returntype="query">
        <cfquery name="GET_COMPANY_SECTOR" datasource="#DSN#">
            SELECT 
                SECTOR_CAT_ID,
                SECTOR_CAT
            FROM 
                SETUP_SECTOR_CATS WITH (NOLOCK) 
            ORDER BY 
                SECTOR_CAT
        </cfquery>
        <cfreturn GET_COMPANY_SECTOR>
    </cffunction>

    <cffunction name="GET_COMPANY_SIZE" returntype="query">
        <cfquery name="GET_COMPANY_SIZE" datasource="#DSN#">
            SELECT 
                COMPANY_SIZE_CAT_ID,
                COMPANY_SIZE_CAT
            FROM 
                SETUP_COMPANY_SIZE_CATS
        </cfquery>
        <cfreturn GET_COMPANY_SIZE>
    </cffunction>

    <cffunction name="GET_PARTNER_POSITIONS" returntype="query">
        <cfquery name="GET_PARTNER_POSITIONS" datasource="#DSN#">
            SELECT
                PARTNER_POSITION_ID,
                PARTNER_POSITION
            FROM
                SETUP_PARTNER_POSITION WITH (NOLOCK)
            ORDER BY
                PARTNER_POSITION
        </cfquery>
        <cfreturn GET_PARTNER_POSITIONS>
    </cffunction>
    
    <cffunction name="GET_PARTNER_DEPARTMENTS" returntype="query">
        <cfargument name="language" default="#session_base.language#">
        <cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#DSN#">
            SELECT
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE PARTNER_DEPARTMENT
                END AS PARTNER_DEPARTMENT
                ,PARTNER_DEPARTMENT_ID
            FROM
                SETUP_PARTNER_DEPARTMENT WITH (NOLOCK)
                LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_PARTNER_DEPARTMENT.PARTNER_DEPARTMENT_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PARTNER_DEPARTMENT">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PARTNER_DEPARTMENT">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language#">
            ORDER BY
                PARTNER_DEPARTMENT 
        </cfquery>
        <cfreturn GET_PARTNER_DEPARTMENTS>
    </cffunction>

    <cffunction name="PERIODS" returntype="query">
        <cfquery name="PERIODS" datasource="#DSN#">
            SELECT 
                SETUP_PERIOD.PERIOD,
                SETUP_PERIOD.PERIOD_ID,
                SETUP_PERIOD.OUR_COMPANY_ID
            FROM
                SETUP_PERIOD,
                OUR_COMPANY
            WHERE
                OUR_COMPANY.COMP_ID = SETUP_PERIOD.OUR_COMPANY_ID
        </cfquery>
        <cfreturn PERIODS>
    </cffunction>

    <cffunction name="GET_MEMBER_ADD_OPTIONS" returntype="query">
        <cfquery name="GET_MEMBER_ADD_OPTIONS" datasource="#DSN#">
            SELECT
                MEMBER_ADD_OPTION_ID,
                MEMBER_ADD_OPTION_NAME
            FROM
                SETUP_MEMBER_ADD_OPTIONS
            ORDER BY
                MEMBER_ADD_OPTION_NAME
        </cfquery>
        <cfreturn GET_MEMBER_ADD_OPTIONS>
    </cffunction>

    <cffunction name="SZ" returntype="query">
        <cfquery name="SZ" datasource="#DSN#">
            SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE = 1
        </cfquery>
        <cfreturn SZ>
    </cffunction>

    <cffunction name="GET_OUR_COMPANIES" returntype="query">
        <cfargument name="our_company_id" default="">
        <cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
            SELECT OUR_COMPANY_ID FROM COMPANY WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
        </cfquery>
        <cfreturn GET_OUR_COMPANIES>
    </cffunction>

    <cffunction name="GET_COMPANY_CODE" returntype="query">
        <cfargument name="company_code" default="">
        <cfargument name="company_id" default="">
        <cfquery name="GET_COMPANY_CODE" datasource="#DSN#">
            SELECT COMPANY_ID FROM COMPANY WHERE MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_code#"><cfif len(arguments.company_id)> AND COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"></cfif>
        </cfquery>
        <cfreturn GET_COMPANY_CODE>
    </cffunction>

    <cffunction name="GET_COMP_BY_NAME" returntype="query">
        <cfargument name="fullname" default="">
        <cfargument name="nickname" default="">
        <cfquery name="GET_COMP" datasource="#DSN#">
            SELECT COMPANY_ID FROM COMPANY WHERE FULLNAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fullname#"> AND NICKNAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.nickname#">
        </cfquery>
        <cfreturn GET_COMP>
    </cffunction>

    <cffunction name="ADD_COMPANY" returntype="any">
        <cfargument name="asset1" default="">
        <cfargument name="asset2" default="">
        <cfargument name="wrk_id" default="">
        <cfargument name="companycat_id" default="">
        <cfargument name="fullname" default="">
        <cfargument name="taxno" default="">
        <cfargument name="userid" default="#iif(isdefined('session_base.userid'),'session_base.userid',DE(''))#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="record_date" default="#now()#">
        <cfargument name="is_person" default="">
        <cfquery name="ADD_COMPANY" datasource="#DSN#" result="my_result">
			INSERT INTO 
				COMPANY
			    (
                    WRK_ID,
                    FULLNAME,
                    TAXNO,
                    COMPANYCAT_ID,
                    RECORD_EMP,
                    RECORD_IP,
                    IS_PERSON,
                    RECORD_DATE,
                    IS_CIVIL_COMPANY,
                    COMPANY_STATE,
                    COMPANY_STATUS,
                    PERIOD_ID,
                    OUR_COMPANY_ID,
                    MEMBER_CODE,
                    HIERARCHY_ID,
                    NICKNAME,
                    TAXOFFICE,
                    COMPANY_EMAIL,
                    COMPANY_KEP_ADDRESS,
                    HOMEPAGE,
                    COMPANY_TELCODE,
                    COMPANY_TEL1,    
                    COMPANY_TEL2,
                    COMPANY_TEL3,
                    COMPANY_FAX,
                    MOBIL_CODE,
                    MOBILTEL,
                    COMPANY_POSTCODE,
                    COMPANY_ADDRESS,
                    DISTRICT_ID,
                    COUNTY,
                    CITY,
                    COUNTRY,
                    ISPOTANTIAL,
                    COMPANY_SIZE_CAT_ID,
                    SALES_COUNTY,
                    IS_SELLER,
                    IS_BUYER,
                    RESOURCE_ID,
                    COMPANY_RATE,
                    COMPANY_VALUE_ID,
                    GLNCODE,
                <cfif isDefined("arguments.asset1") and len(arguments.asset1)>
                    ASSET_FILE_NAME1,
                    ASSET_FILE_NAME1_SERVER_ID,
                </cfif>
                <cfif isDefined("arguments.asset2") and len(arguments.asset2)>
                    ASSET_FILE_NAME2,
                    ASSET_FILE_NAME2_SERVER_ID,
                </cfif>
                    START_DATE,
                    ORG_START_DATE,
                    IMS_CODE_ID,
                    SEMT,
                    OZEL_KOD,
                    OZEL_KOD_1,
                    OZEL_KOD_2,
                    IS_RELATED_COMPANY,
                    MEMBER_ADD_OPTION_ID,
                    COORDINATE_1,
                    COORDINATE_2,
                    CAMPAIGN_ID,
                    FIRM_TYPE,
                    IS_EXPORT,
                    VISIT_CAT_ID,
                    PROFILE_ID,
                    USE_EARCHIVE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wrk_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fullname#">,
                    <cfif isDefined("arguments.taxno") and len(arguments.taxno)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.taxno#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companycat_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remote_addr#">,
                    <cfif isdefined("arguments.is_person") and arguments.is_person eq 1>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">,
                    <cfif isDefined("arguments.is_civil") and len(arguments.is_civil)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_civil#"><cfelse>0</cfif>,
                    <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.company_status") and arguments.company_status eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined("arguments.period_id") and len(arguments.period_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.our_company_id') and len(arguments.our_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"><cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.company_code") and len(arguments.company_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_code#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.hierarchy_id') and len(arguments.hierarchy_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hierarchy_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.nickname") and len(arguments.nickname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.taxoffice") and len(arguments.taxoffice)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.taxoffice#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.email") and len(arguments.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.kep_address") and len(arguments.kep_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.kep_address#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.homepage") and len(arguments.homepage)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homepage#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.telcod") and len(arguments.telcod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.telcod#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.tel1") and len(arguments.tel1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel1#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.tel2") and len(arguments.tel2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel2#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.tel3") and len(arguments.tel3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel3#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.fax") and len(arguments.fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fax#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.mobilcat_id") and len(arguments.mobilcat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobilcat_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.mobiltel") and len(arguments.mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobiltel#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.postcod") and len(arguments.postcod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postcod#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.adres") and len(arguments.adres)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adres#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.district_id") and Len(arguments.district_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.district_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.county_id") and len(arguments.county_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.city_id") and len(arguments.city_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.country") and len(arguments.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.ispotantial") and arguments.ispotantial eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('arguments.company_size_cat_id') and len(arguments.company_size_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_size_cat_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.sales_county') and len(arguments.sales_county)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_county#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.is_seller") and arguments.is_seller eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined("arguments.is_buyer") and arguments.is_buyer eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('arguments.resource') and len(arguments.resource)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.resource#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.company_rate') and len(arguments.company_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.company_rate#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.customer_value') and len(arguments.customer_value)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.customer_value#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.glncode") and Len(arguments.glncode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.glncode#"><cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.asset1") and len(arguments.asset1)>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.asset1#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_machine#">,
                    </cfif>
                    <cfif isDefined("arguments.asset2") and len(arguments.asset2)>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.asset2#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_machine#">,
                    </cfif>
                    <cfif isdefined("arguments.startdate") and len(arguments.startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.organization_start_date") and len(arguments.organization_start_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.organization_start_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.ims_code_id') and len(arguments.ims_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ims_code_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.semt") and len(arguments.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.semt#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.ozel_kod") and len(arguments.ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ozel_kod#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.ozel_kod_1") and len(arguments.ozel_kod_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ozel_kod_1#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.ozel_kod_2") and len(arguments.ozel_kod_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ozel_kod_2#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.is_related_company") and arguments.is_related_company eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('arguments.member_add_option_id') and len(arguments.member_add_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_add_option_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.coordinate_1") and len(arguments.coordinate_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate_1#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.coordinate_2") and len(arguments.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate_2#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.camp_id') and Len(arguments.camp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.firm_type') and len(arguments.firm_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firm_type#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.is_export') and arguments.is_export eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('arguments.visit_cat_id') and len(arguments.visit_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.visit_cat_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.profile_id") and len(arguments.profile_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.profile_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.use_earchive') and arguments.use_earchive eq 1>1<cfelse>0</cfif>
                )
            SELECT SCOPE_IDENTITY() MAX_COMPANY
        </cfquery>
        <cfreturn ADD_COMPANY>
    </cffunction>

    <cffunction name="ADD_WORKGROUP_MEMBER" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="our_company_id" default="#session_base.company_id#">
        <cfargument name="pos_code" default="">
        <cfargument name="userid" default="#session_base.userid#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="record_date" default="#now()#">
        <cfquery name="ADD_WORKGROUP_MEMBER" datasource="#DSN#">
            INSERT INTO 
                WORKGROUP_EMP_PAR
            (
                COMPANY_ID,
                OUR_COMPANY_ID,
                POSITION_CODE,
                IS_MASTER,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_code#">,
                1,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.record_date#">
            )
        </cfquery> 
    </cffunction>

    <cffunction name="ADD_COMP_PERIOD" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="period_id" default="">
        <cfquery name="ADD_COMP_PERIOD" datasource="#DSN#">
			INSERT INTO
				COMPANY_PERIOD
			(
				COMPANY_ID,
				PERIOD_ID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
			)
		</cfquery>
    </cffunction>

    <cffunction name="ADD_PARTNER" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="name" default="">
        <cfargument name="soyad" default="">
        <cfargument name="company_partner_status" default="">
        <cfargument name="title" default="">
        <cfargument name="sex" default="">
        <cfargument name="language" default="#iif(isdefined('session_base.language'),'session_base.language',DE('tr'))#">
        <cfargument name="department" default="">
        <cfargument name="company_partner_email" default="">
        <cfargument name="mobilcat_id_partner" default="">
        <cfargument name="mobiltel_partner" default="">
        <cfargument name="telcod" default="">
        <cfargument name="tel1" default="">
        <cfargument name="tel_local" default="">
        <cfargument name="fax" default="">
        <cfargument name="homepage" default="">
        <cfargument name="mission" default="">
        <cfargument name="record_date" default="#now()#">
        <cfargument name="userid" default="#iif(isdefined('session_base.userid'),'session_base.userid',DE(''))#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="adres" default="">
        <cfargument name="postcod" default="">
        <cfargument name="county_id" default="">
        <cfargument name="city_id" default="">
        <cfargument name="country" default="">
        <cfargument name="semt" default="">
        <cfargument name="tc_identity" default="">
        <cfargument name="birthdate" default="">
        <cfargument name="partner_username" default="">
        <cfargument name="partner_password" default="">
        <cfquery name="ADD_PARTNER" datasource="#DSN#" result="result">
			INSERT INTO 
            COMPANY_PARTNER 
            (
                COMPANY_ID,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME,
                COMPANY_PARTNER_STATUS,
                TITLE,
                SEX,
                LANGUAGE_ID,
                DEPARTMENT,
                COMPANY_PARTNER_EMAIL,
                MOBIL_CODE,
                MOBILTEL,
                COMPANY_PARTNER_TELCODE,
                COMPANY_PARTNER_TEL,
                COMPANY_PARTNER_TEL_EXT,
                COMPANY_PARTNER_FAX,
                HOMEPAGE,
                MISSION,
                RECORD_DATE,
                MEMBER_TYPE,
                RECORD_MEMBER,
                RECORD_IP,		
                COMPANY_PARTNER_ADDRESS,
                COMPANY_PARTNER_POSTCODE,
                COUNTY,
                CITY,
                COUNTRY,		
                SEMT,
                TC_IDENTITY,
                BIRTHDATE,
                COMPANY_PARTNER_USERNAME,
                COMPANY_PARTNER_PASSWORD
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.soyad#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.company_partner_status#">,
                <cfif isdefined("arguments.title") and len(arguments.title)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.title#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.sex") and len(arguments.sex)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sex#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.language#">,
                <cfif isdefined("arguments.department") and len(arguments.department)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_email#">,
                <cfif isdefined('arguments.mobilcat_id_partner') and len(arguments.mobilcat_id_partner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobilcat_id_partner#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.mobiltel_partner') and len(arguments.mobiltel_partner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobiltel_partner#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.telcod') and len(arguments.telcod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.telcod#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.tel1') and len(arguments.tel1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel1#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.tel_local') and len(arguments.tel_local)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_local#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.fax') and len(arguments.fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fax#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.homepage') and len(arguments.homepage)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homepage#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.mission') and len(arguments.mission)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mission#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.record_date#">,
                1,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remote_addr#">,
                <cfif isdefined('arguments.adres') and len(arguments.adres)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adres#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.postcod') and len(arguments.postcod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postcod#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.county_id") and len(arguments.county_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.city_id") and len(arguments.city_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.country") and len(arguments.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.semt") and len(arguments.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.semt#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.tc_identity") and len(arguments.tc_identity)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tc_identity#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.birthdate') and len(arguments.birthdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.birthdate#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.partner_username') and len(arguments.partner_username)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.partner_username#"><cfelse>NULL</cfif>,
                <cfif isdefined('arguments.partner_password') and len(arguments.partner_password)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.partner_password#"><cfelse>NULL</cfif>
            )
		</cfquery>
        <cfreturn result>
    </cffunction>

    <cffunction name="GET_MAX_PARTNER" returntype="query">
        <cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
			SELECT
				MAX(PARTNER_ID) MAX_PARTNER_ID
			FROM
				COMPANY_PARTNER
        </cfquery>
        <cfreturn GET_MAX_PARTNER>
    </cffunction>

    <cffunction name="UPD_MEMBER_CODE" returntype="any">
        <cfargument name="partner_id" default="">
        <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER
			SET
				MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="CP#arguments.partner_id#">
			WHERE
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
		</cfquery>
    </cffunction>

    <cffunction name="ADD_COMPANY_PARTNER_DETAIL" returntype="any">
        <cfargument name="partner_id" default="">
        <cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
			INSERT INTO
				COMPANY_PARTNER_DETAIL
			(
				PARTNER_ID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
			)
		</cfquery>
    </cffunction>

    <cffunction name="ADD_PART_SETTINGS" returntype="any">
        <cfargument name="partner_id" default="">
        <cfargument name="language" default="#session_base.language#">
        <cfquery name="ADD_PART_SETTINGS" datasource="#DSN#">
			INSERT INTO 
            MY_SETTINGS_P 
			(
				PARTNER_ID,
				LANGUAGE_ID,
				TIME_ZONE,
				MAXROWS,
				TIMEOUT_LIMIT
			)
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.language#">,
				2,
				20,
				15
			)
		</cfquery>
    </cffunction>

    <cffunction name="UPD_MEMBER_CODE_COMPANY" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="member_code" default="">
        <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE 
				COMPANY 
			SET		
				MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_code#">
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
		</cfquery>
    </cffunction>

    <cffunction name="UPD_MANAGER_PARTNER" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="partner_id" default="">
        <cfquery name="UPD_MANAGER_PARTNER" datasource="#DSN#">
			UPDATE
				COMPANY
			SET
				MANAGER_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
		</cfquery>
    </cffunction>

    <cffunction name="GET_BRANCH_CID" returntype="query">
        <cfargument name="user_location" default="">
        <cfquery name="GET_BRANCH_CID" datasource="#DSN#"><!--- Subenin company_id si --->
            SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_location#">
        </cfquery>
        <cfreturn GET_BRANCH_CID>
    </cffunction>

    <cffunction name="ADD_BRANCH_RELATED" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="our_company_id" default="">
        <cfargument name="user_location" default="">
        <cfargument name="open_date" default="#now()#">
        <cfargument name="userid" default="#session_base.userid#">
        <cfargument name="record_date" default="#now()#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfquery name="ADD_BRANCH_RELATED" datasource="#DSN#">
            INSERT INTO
                COMPANY_BRANCH_RELATED
            (
                COMPANY_ID,
                OUR_COMPANY_ID,
                BRANCH_ID,
                OPEN_DATE,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_location#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.open_date#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remote_addr#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="ADD_PRODUTCT_CAT" returntype="any">
        <cfargument name="catid" default="">
        <cfargument name="company_id" default="">
        <cfquery name="ADD_PRODUTCT_CAT" datasource="#DSN#">
            INSERT INTO 
                WORKNET_RELATION_PRODUCT_CAT
            (
                PRODUCT_CATID,
                COMPANY_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.catid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="ADD_COMP_SECTOR" returntype="any">
        <cfargument name="sector_id" default="">
        <cfargument name="company_id" default="">
        <cfquery name="ADD_COMP_SECTOR" datasource="#DSN#">
            INSERT INTO 
                COMPANY_SECTOR_RELATION
            (
                SECTOR_ID,
                COMPANY_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sector_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="add_related_brands" returntype="any">
        <cfargument name="brand_id" default="">
        <cfargument name="company_id" default="">
        <cfquery name="add_related_brands" datasource="#DSN#">
            INSERT INTO 
                RELATED_BRANDS
            (
                RELATED_BRAND_ID,
                RELATED_COMPANY_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="ADD_RELATION_EXPORT_COUNTRIES" returntype="any">
        <cfargument name="country_id" default="">
        <cfargument name="company_id" default="">
        <cfquery name="ADD_RELATION_EXPORT_COUNTRIES" datasource="#DSN#">
            INSERT INTO 
                COMPANY_RELATION_EXPORT_COUNTRIES
            (
                COUNTRY_ID,
                COMPANY_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            )
        </cfquery>
    </cffunction>
    <!---  --->

    <!--- Upd page query --->
    <cffunction name="VIEW_CONTROL" returntype="query">
        <cfargument name="cpid" default="">
        <cfargument name="our_company_id" default="#session_base.company_id#">
        <cfargument name="position_code" default="#session_base.position_code#">
        <cfquery name="VIEW_CONTROL" datasource="#DSN#">
            SELECT
                IS_MASTER
            FROM
                WORKGROUP_EMP_PAR
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"> AND
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND
                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
        </cfquery>
        <cfreturn VIEW_CONTROL>
    </cffunction>

    <cffunction name="GET_WORK_POS" returntype="query">
        <cfargument name="cpid" default="">
        <cfargument name="our_company_id" default="#session_base.company_id#">
        <cfquery name="GET_WORK_POS" datasource="#DSN#">
            SELECT
                COMPANY_ID,
                OUR_COMPANY_ID,
                POSITION_CODE,
                IS_MASTER
            FROM
                WORKGROUP_EMP_PAR
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"> AND
                COMPANY_ID IS NOT NULL AND
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND
                IS_MASTER = 1
        </cfquery>
        <cfreturn GET_WORK_POS>
    </cffunction>
    
    <cffunction name="GET_COMPANYCAT_TYPE" returntype="query">
        <cfquery name="GET_COMPANYCAT" datasource="#DSN#">
			SELECT DISTINCT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 1 ORDER BY COMPANYCAT
		</cfquery>
        <cfreturn GET_COMPANYCAT>
    </cffunction>

    <cffunction name="get_partner_" returntype="query">
        <cfargument name="cpid" default="">
        <cfargument name="partner_id" default="">
        <cfquery name="get_partner_" datasource="#DSN#">
            SELECT 
                CP.PARTNER_ID,
                CP.PHOTO,
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME,
                CP.TC_IDENTITY,
                CP.MISSION,
                CP.COMPANY_PARTNER_EMAIL,
                CP.MOBIL_CODE,
                CP.MOBILTEL,
                CP.RECORD_DATE,
                CP.SEX,
                CP.COMPANY_PARTNER_USERNAME,
                CP.CP_STATUS_ID
            FROM
                COMPANY_PARTNER CP, 
                COMPANY C
            WHERE 
                CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"> AND 
                CP.COMPANY_ID = C.COMPANY_ID AND
                COMPANY_PARTNER_STATUS = 1
                <cfif isdefined("arguments.partner_id") and len(arguments.partner_id)>
                    AND CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                </cfif>
            ORDER BY 
                CP.COMPANY_PARTNER_NAME
        </cfquery>
        <cfreturn get_partner_>
    </cffunction>

    <cffunction name="get_tc" returntype="query">
        <cfargument name="manager_partner_id" default="">
        <cfquery name="get_tc" dbtype="query">
            SELECT TC_IDENTITY
            FROM GET_PARTNER_
            WHERE PARTNER_ID = #arguments.manager_partner_id#
        </cfquery>
        <cfreturn get_tc>
    </cffunction>

    <cffunction name="GET_COUNTRY_" returntype="query">
        <cfargument name="language" default="#session_base.language#">
        <cfquery name="GET_COUNTRY" datasource="#DSN#">
            SELECT
                COUNTRY_ID,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE COUNTRY_NAME
                END AS COUNTRY_NAME,
                COUNTRY_PHONE_CODE,
                COUNTRY_CODE,
                IS_DEFAULT
            FROM
                SETUP_COUNTRY
                LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COUNTRY.COUNTRY_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COUNTRY_NAME">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COUNTRY">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language#">
            ORDER BY
                COUNTRY_NAME
        </cfquery>
        <cfreturn GET_COUNTRY>
    </cffunction>

    <cffunction name="GET_PARTNER_ID" returntype="query">
        <cfargument name="cpid" default="">
        <cfquery name="GET_PARTNER_ID" datasource="#DSN#">
            SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#">
        </cfquery>
        <cfreturn GET_PARTNER_ID>
    </cffunction>

    <cffunction name="GET_USER_URL" returntype="query">
        <cfargument name="cpid" default="">
        <cfquery name="GET_USER_URL" datasource="#DSN#">
            SELECT USER_FRIENDLY_URL FROM USER_FRIENDLY_URLS WHERE ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMPANY_ID"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#">
        </cfquery>
        <cfreturn GET_USER_URL>
    </cffunction>

    <cffunction name="GET_COMPANYCAT_ID" returntype="query">
        <cfargument name="cpid" default="">
        <cfquery name="GET_COMPANYCAT_ID" datasource="#DSN#">
            SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"> 
        </cfquery>
        <cfreturn GET_COMPANYCAT_ID>
    </cffunction>

    <cffunction name="DENIED_PAGE" returntype="query">
        <cfargument name="par_ids" default="">
        <cfargument name="companycat_id" default="">
        <cfquery name="DENIED_PAGE" datasource="#DSN#">
			SELECT DENIED_PAGE_ID,DENIED_PAGE FROM COMPANY_PARTNER_DENIED WHERE PARTNER_ID IN (#arguments.par_ids#) OR COMPANY_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companycat_id#">
		</cfquery>
        <cfreturn DENIED_PAGE>
    </cffunction>

    <cffunction name="get_sector_id" returntype="query">
        <cfargument name="cpid" default="">
        <cfquery name="get_sector_id" datasource="#dsn#">
            SELECT 
                SECTOR_ID
            FROM
                COMPANY_SECTOR_RELATION
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"> 
        </cfquery>
        <cfreturn get_sector_id>
    </cffunction>

    <cffunction name="get_sector_name" returntype="query">
        <cfargument name="cpid" default="">
        <cfquery name="get_sector_name" datasource="#dsn#">
            SELECT 
                SCU.SECTOR_CAT + ' > ' + SC.SECTOR_CAT AS SECTOR_CAT,
                SCU.SECTOR_CAT_CODE AS UPPER_SECTOR_CAT_CODE, 
                SC.SECTOR_CAT_CODE,
                SC.SECTOR_CAT_ID,
                SCU.SECTOR_CAT_CODE 
            FROM 
                SETUP_SECTOR_CAT_UPPER SCU,
                SETUP_SECTOR_CATS SC,
                COMPANY_SECTOR_RELATION CSR
            WHERE 
                SC.SECTOR_UPPER_ID = SCU.SECTOR_UPPER_ID AND
                CSR.SECTOR_ID = SC.SECTOR_CAT_ID AND 
                CSR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#">
        </cfquery>
        <cfreturn get_sector_name>
    </cffunction>

    <cffunction name="getBrandName" returntype="query">
        <cfargument name="related_brand_id" default="">
        <cfargument name="dsn1" default="">
        <cfquery name="getBrandName" datasource="#arguments.dsn1#">
            SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_brand_id#">
        </cfquery>
        <cfreturn getBrandName>
    </cffunction>

    <cffunction name="getCat" returntype="query">
        <cfargument name="hierarchy" default="">
        <cfargument name="dsn1" default="">
        <cfquery name="getCat" datasource="#arguments.dsn1#">
            SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE HIERARCHY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.hierarchy#">
        </cfquery>
        <cfreturn getCat>
    </cffunction>

    <cffunction name="get_district_name" returntype="query">
        <cfargument name="county_id" default="">
        <cfquery name="get_district_name" datasource="#dsn#">
            SELECT DISTRICT_ID,DISTRICT_NAME,POST_CODE,PART_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#">
        </cfquery>
        <cfreturn get_district_name>
    </cffunction>

    <cffunction name="get_country_phone" returntype="query">
        <cfargument name="country" default="">
        <cfquery name="get_country_phone" dbtype="query">
            SELECT COUNTRY_PHONE_CODE FROM GET_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#">
        </cfquery>
        <cfreturn get_country_phone>
    </cffunction>

    <cffunction name="getExportCountries" returntype="query">
        <cfargument name="company_id" default="">
        <cfquery name="getExportCountries" datasource="#dsn#">
            SELECT COUNTRY_ID FROM COMPANY_RELATION_EXPORT_COUNTRIES WHERE COMPANY_ID = #arguments.company_id#
        </cfquery>
        <cfreturn getExportCountries>
    </cffunction>

    <cffunction name="GET_UPPER_COMPANY" returntype="query">
        <cfargument name="hierarchy_id" default="">
        <cfquery name="GET_UPPER_COMPANY" datasource="#DSN#">
            SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hierarchy_id#">
        </cfquery>
        <cfreturn GET_UPPER_COMPANY>
    </cffunction>

    <cffunction name="GET_OUR_COMPANY_NAME" returntype="query">
        <cfargument name="comp_id" default="">
        <cfquery name="GET_OUR_COMPANY_NAME" datasource="#dsn#">
            SELECT 
                *
            FROM 
                OUR_COMPANY
            WHERE
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
        </cfquery>
        <cfreturn GET_OUR_COMPANY_NAME>
    </cffunction>

    <cffunction name="periods_company" returntype="query">
        <cfargument name="cpid" default="">
        <cfquery name="periods" datasource="#dsn#">
            SELECT 
                SETUP_PERIOD.PERIOD,
                SETUP_PERIOD.PERIOD_ID,
                SETUP_PERIOD.OUR_COMPANY_ID
            FROM 
                SETUP_PERIOD, 
                OUR_COMPANY,
                COMPANY_PERIOD 
            WHERE 
                OUR_COMPANY.COMP_ID = SETUP_PERIOD.OUR_COMPANY_ID AND
                COMPANY_PERIOD.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
                COMPANY_PERIOD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#">
        </cfquery>
        <cfreturn periods>
    </cffunction>

    <cffunction name="GET_IMS" returntype="query">
        <cfargument name="ims_code_id" default="">
        <cfquery name="GET_IMS" datasource="#DSN#">
            SELECT IMS_CODE_ID,IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ims_code_id#">
        </cfquery>
        <cfreturn GET_IMS>
    </cffunction>

    <cffunction name="GET_ASSET_COMPANY" returntype="query">
        <cfargument name="company_id" default="">
        <cfquery name="GET_ASSET_COMPANY" datasource="#DSN#">
            SELECT ASSET_FILE_NAME1,ASSET_FILE_NAME2,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2_SERVER_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn GET_ASSET_COMPANY>
    </cffunction>

    <cffunction name="UPD_ASSET1" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="file_name" default="">
        <cfargument name="server_id" default="">
        <cfquery name="UPD_ASSET1" datasource="#DSN#">
            UPDATE  
                COMPANY
            SET 
                ASSET_FILE_NAME1 = <cfif len(arguments.file_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.file_name#"><cfelse>NULL</cfif>,
                ASSET_FILE_NAME1_SERVER_ID = <cfif len(arguments.server_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_id#"><cfelse>NULL</cfif>
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
    </cffunction>

    <cffunction name="UPD_ASSET2" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="file_name" default="">
        <cfargument name="server_id" default="">
        <cfquery name="UPD_ASSET2" datasource="#DSN#">
            UPDATE  
                COMPANY
            SET 
                ASSET_FILE_NAME2 = <cfif len(arguments.file_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.file_name#"><cfelse>NULL</cfif>,
                ASSET_FILE_NAME2_SERVER_ID = <cfif len(arguments.server_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_id#"><cfelse>NULL</cfif>
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
    </cffunction>

    <cffunction name="GET_COMP_NAME_CONTROL" returntype="query">
        <cfargument name="company_id" default="">
        <cfargument name="fullname" default="">
        <cfargument name="nickname" default="">
        <cfquery name="GET_COMP" datasource="#DSN#">
            SELECT
                COMPANY_ID
            FROM
                COMPANY
            WHERE
                COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fullname#"> AND
                NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#">
        </cfquery>
        <cfreturn GET_COMP>
    </cffunction>
    <cffunction name="DEL_USER_FRIENDLY" returntype="any">
        <cfargument name="company_id" default="">
        <cfquery name="DEL_USER_FRIENDLY" datasource="#DSN#">
            DELETE FROM USER_FRIENDLY_URLS WHERE ACTION_TYPE = 'COMPANY_ID' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>  
    </cffunction>
    <cffunction name="hist_cont" returntype="query">
        <cfargument name="wg_company_id" default="">
        <cfargument name="our_company_id" default="#session_base.company_id#">
        <cfargument name="company_id" default="">
        <cfquery name="hist_cont" datasource="#dsn#">
			SELECT
				C.*,
				(SELECT MAX(POSITION_CODE) POS_CODE FROM WORKGROUP_EMP_PAR WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wg_company_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND IS_MASTER = 1) AGENT_POS_CODE
			FROM
				COMPANY C
			WHERE
				C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
		</cfquery>
        <cfreturn hist_cont>
    </cffunction>
    <cffunction name="upd_company" returntype="any">
           <cfargument name="UPDATE_IP" default="#cgi.remote_addr#">
           <cfargument name="UPDATE_EMP" default="#session_base.userid#">
           <cfargument name="UPDATE_DATE" default="#now()#">
           <cfargument name="company_id" default="">
           <cfquery name="upd_company" datasource="#DSN#">
            UPDATE 
                COMPANY 
            SET
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                <cfif isdefined("arguments.process_stage")>
                    ,COMPANY_STATE = <cfif len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>
                </cfif> 
                <cfif isdefined("arguments.member_code")>
                    ,MEMBER_CODE =<cfif isdefined("arguments.member_code")><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.member_code)#"><cfelse>NULL</cfif> 
                </cfif>
                <cfif isdefined("arguments.company_status")>
                    ,COMPANY_STATUS = <cfif isdefined("arguments.company_status") and arguments.company_status eq 1>1<cfelse>0</cfif>
                </cfif>
                <cfif isdefined("arguments.companycat_id")>
                    ,COMPANYCAT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companycat_id#">
                </cfif>
                <cfif isdefined("arguments.period_id")>
                    ,PERIOD_ID = <cfif isdefined("arguments.period_id") and len(arguments.period_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.manager_partner_id")>
                    ,MANAGER_PARTNER_ID = <cfif isDefined("arguments.manager_partner_id") and len(arguments.manager_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.manager_partner_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.fullname")>
                    ,FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fullname#">
                </cfif>
                <cfif isdefined("arguments.company_size_cat_id")>
                    ,COMPANY_SIZE_CAT_ID = <cfif len(arguments.company_size_cat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_size_cat_id#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.customer_value")>
                    ,COMPANY_VALUE_ID = <cfif len(arguments.customer_value)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.customer_value#"><cfelse>NULL</cfif>
                </cfif> 
                <cfif isdefined("arguments.taxoffice")>   
                    ,TAXOFFICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.taxoffice#">
                </cfif>
                <cfif isdefined("arguments.taxno")>
                    ,TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.taxno#" null="#not len(arguments.taxno)#">
                </cfif>
                <cfif isdefined("arguments.company_email")>    
                    ,COMPANY_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_email#">
                </cfif>
                <cfif isdefined("arguments.company_kep_address")>    
                    ,COMPANY_KEP_ADDRESS = <cfif isdefined("arguments.company_kep_address") and len(arguments.company_kep_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_kep_address#"><cfelse>NULL</cfif>
                </cfif> 
                <cfif isdefined("arguments.homepage")>   
                    ,HOMEPAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homepage#">
                </cfif> 
                <cfif isdefined("arguments.company_telcode")>   
                    ,COMPANY_TELCODE = <cfif len(arguments.company_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_telcode#"><cfelse>NULL</cfif>
                </cfif>  
                <cfif isdefined("arguments.company_tel1")>  
                    ,COMPANY_TEL1 = <cfif len(arguments.company_tel1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_tel1#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.COMPANY_TEL2")>
                    ,COMPANY_TEL2 = <cfif len(arguments.company_tel2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_tel2#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.company_tel3")>
                    ,COMPANY_TEL3 = <cfif len(arguments.company_tel3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_tel3#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.company_fax")>
                    ,COMPANY_FAX =  <cfif len(arguments.company_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_fax#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.mobilcat_id")>
                    ,MOBIL_CODE = <cfif len(arguments.mobilcat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobilcat_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.mobiltel")>    
                    ,MOBILTEL = <cfif len(arguments.mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobiltel#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.company_postcode")>    
                    ,COMPANY_POSTCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_postcode#">
                </cfif>    
                <cfif isdefined("arguments.company_address")> 
                    ,COMPANY_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_address#">
                </cfif>   
                <cfif isdefined("arguments.district_id")>
                    ,DISTRICT_ID = <cfif isdefined("arguments.district_id") and len(arguments.district_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.district_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.county_id")>
                    ,COUNTY = <cfif len(arguments.county_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.city_id")>    
                    ,CITY = <cfif len(arguments.city_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"><cfelse>NULL</cfif>
                </cfif> 
                <cfif isdefined("arguments.country")>
                    ,COUNTRY = <cfif len(arguments.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.watalogy_code")>
                    ,WATALOGY_MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.watalogy_code#">
                </cfif>  
                <cfif isdefined("arguments.ispotantial")>
                    ,ISPOTANTIAL = <cfif isdefined("arguments.ispotantial") and len(arguments.ispotantial)>1<cfelse>0</cfif>
                </cfif>  
                <cfif isdefined("arguments.hierarchy_id")>  
                    ,HIERARCHY_ID = <cfif isDefined("arguments.hierarchy_id") and len(arguments.hierarchy_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hierarchy_id#"><cfelse>NULL</cfif>
                </cfif>     
                <cfif isdefined("arguments.sales_county")> 
                    ,SALES_COUNTY = <cfif isDefined("arguments.sales_county") and len(arguments.sales_county)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_county#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.is_buyer")>
                    ,IS_BUYER = <cfif isdefined("arguments.is_buyer") and len(arguments.is_buyer)>1<cfelse>0</cfif>
                </cfif>
                <cfif isdefined("arguments.is_seller")>    
                    ,IS_SELLER = <cfif isdefined("arguments.is_seller") and len(arguments.is_seller)>1<cfelse>0</cfif>
                </cfif> 
                <cfif isdefined("arguments.is_related_company")>   
                    ,IS_RELATED_COMPANY = <cfif isdefined("arguments.is_related_company") and len(arguments.is_related_company)>1<cfelse>0</cfif>
                </cfif> 
                <cfif isdefined("arguments.resource") and len(arguments.resource)>
                    ,RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.resource#">
                </cfif> 
                <cfif isdefined("arguments.ozel_kod")>
                    ,OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ozel_kod#">
                </cfif>
                <cfif isdefined("arguments.ozel_kod_1")>
                    ,OZEL_KOD_1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ozel_kod_1#">
                </cfif>    
                <cfif isdefined("arguments.ozel_kod_2")>
                    ,OZEL_KOD_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ozel_kod_2#">
                </cfif> 
                <cfif isdefined("arguments.nickname")>   
                    ,NICKNAME = <cfif len(arguments.nickname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#"><cfelse>NULL</cfif>
                </cfif>  
                <cfif isdefined("arguments.startdate")>  
                    ,START_DATE= <cfif isdefined("arguments.startdate") and len(arguments.startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"><cfelse>NULL</cfif> 
                </cfif>  
                <cfif isdefined("arguments.organization_start_date")>  
                    ,ORG_START_DATE = <cfif isdefined("arguments.organization_start_date") and len(arguments.organization_start_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.organization_start_date#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.our_company_id")>    
                    ,OUR_COMPANY_ID = <cfif isdefined("arguments.our_company_id") and len(arguments.our_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.ims_code_id")>    
                    ,IMS_CODE_ID = <cfif isDefined("arguments.ims_code_id") and len(arguments.ims_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ims_code_id#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.POS_CODE")>
                    ,POS_CODE = <cfif len(arguments.POS_CODE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.POS_CODE#"><cfelse>NULL</cfif>
                </cfif>   
                <cfif isdefined("arguments.semt")>  
                    ,SEMT = <cfif len(arguments.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.semt#"><cfelse>NULL</cfif>
                </cfif> 
                <cfif isdefined("arguments.member_add_option_id")>   
                    ,MEMBER_ADD_OPTION_ID = <cfif len(arguments.member_add_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_add_option_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.glncode")>   
                    ,GLNCODE = <cfif isdefined("arguments.glncode") and Len(arguments.glncode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.glncode#"><cfelse>NULL</cfif>
                </cfif> 
                <cfif isdefined("arguments.coordinate_1")>   
                    ,COORDINATE_1 = <cfif isdefined("arguments.coordinate_1") and len(arguments.coordinate_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate_1#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.coordinate_2")>    
                    ,COORDINATE_2 = <cfif isdefined("arguments.coordinate_2") and len(arguments.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate_2#"><cfelse>NULL</cfif>
                </cfif>   
                <cfif isdefined("arguments.camp_name") and  isdefined('arguments.camp_id')>  
                    ,CAMPAIGN_ID = <cfif isdefined('arguments.camp_name') and len(arguments.camp_name) and isdefined('arguments.camp_id') and Len(arguments.camp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.firm_type")>    
                    ,FIRM_TYPE = <cfif isDefined ('arguments.firm_type') and len (arguments.firm_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firm_type#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined("arguments.company_rate")>     
                    ,COMPANY_RATE = <cfif isdefined('arguments.company_rate') and len(arguments.company_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.company_rate#"><cfelse>NULL</cfif>
                </cfif> 
                <cfif isdefined("arguments.is_export")>                  
                    ,IS_EXPORT =  <cfif isdefined('arguments.is_export') and arguments.is_export eq 1>1<cfelse>0</cfif>
                </cfif>
                <cfif isdefined("arguments.visit_cat_id")>     
                    ,VISIT_CAT_ID = <cfif isdefined('arguments.visit_cat_id') and len(arguments.visit_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.visit_cat_id#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.profile_id")>
                        ,PROFILE_ID = <cfif isdefined('arguments.profile_id') and len(arguments.profile_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.profile_id#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isdefined("arguments.is_person")> 
                    ,IS_PERSON =  <cfif isdefined('arguments.is_person') and len(arguments.is_person)>1<cfelse>0</cfif>
                </cfif>
                <cfif isdefined('arguments.earchive_sending_type')> 
                    ,EARCHIVE_SENDING_TYPE = <cfif len(arguments.earchive_sending_type)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.earchive_sending_type#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isdefined('arguments.is_civil')>
                    ,IS_CIVIL_COMPANY = <cfif len(arguments.is_civil) and is_civil eq 1>1<cfelse>0</cfif>
                </cfif>
                ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">
            WHERE                      
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery> 
    </cffunction> 
    <!---  --->
    <cffunction name="GET_COMP_ADDRESS" returntype="query">
        <cfargument name="company_id" default="">
        <cfargument name="cpid" default="">
        <cfargument name="GET_COMPANY" default="">
        <cfquery name="GET_COMP_ADDRESS" datasource="#DSN#">
            SELECT 
                COUNTY,
                CITY,
                COUNTRY,
                SEMT,
                DISTRICT_ID,
                COMPANY_POSTCODE,
                COMPANY_ADDRESS,
                COMPANY_RATE,
                COMPANY_ID,
                FULLNAME,
                COMPANYCAT_ID,
                COMPANY_TELCODE,
                COMPANY_TEL1,
                COMPANY_FAX,
                HOMEPAGE
            FROM 
                COMPANY 
            WHERE 
                <cfif isdefined("GET_COMPANY") and GET_COMPANY eq 1>   <!--- çalışan ekle sayfasından çağırılıyorsa ---> 
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"> 
                <cfelse>
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
		</cfquery>
        <cfreturn GET_COMP_ADDRESS>
    </cffunction>
    <cffunction name="UPD_COMP_PAR_ADDRESS" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="UPDATE_IP" default="#cgi.remote_addr#">
        <cfargument name="update_member" default="#session_base.userid#">
        <cfargument name="update_date" default="#now()#">
        <cfquery name="UPD_COMP_PAR_ADDRESS" datasource="#DSN#">
            UPDATE 
                COMPANY_PARTNER
            SET
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            <cfif isdefined("arguments.company_postcode")> 
                ,COMPANY_PARTNER_POSTCODE = <cfif isdefined("arguments.company_postcode") and len(arguments.company_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_postcode#"><cfelse>NULL</cfif>
            </cfif>   
            <cfif isdefined("arguments.company_address")> 
                ,COMPANY_PARTNER_ADDRESS = <cfif isdefined("arguments.company_address") and len(arguments.company_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_address#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isdefined("arguments.county")>   
                ,COUNTY = <cfif isdefined("arguments.county") and len(arguments.county)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.county#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isdefined("arguments.city")>      
                ,CITY = <cfif isdefined("arguments.city") and len(arguments.city)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#"><cfelse>NULL</cfif>
            </cfif>  
            <cfif isdefined("arguments.country")>  
                ,COUNTRY = <cfif isdefined("arguments.country") and len(arguments.country)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isdefined("arguments.semt")>    
                ,SEMT = <cfif isdefined("arguments.semt") and len(arguments.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.semt#"><cfelse>NULL</cfif>
            </cfif>
            ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            ,UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                COMPANY_PARTNER_STATUS = 1
			</cfquery>
    </cffunction>
    <cffunction name="del_member_product_cat" returntype="any">
        <cfargument name="company_id" default="">
        <cfquery name="del_member_product_cat" datasource="#dsn#"> 
            DELETE 
            FROM 
                RELATED_BRANDS 
            WHERE 
                RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
    </cffunction>
    <cffunction name="del_member_product_cat_export" returntype="any">
        <cfargument name="company_id" default="">
        <cfquery name="del_member_product_cat" datasource="#dsn#"> 
            DELETE FROM COMPANY_RELATION_EXPORT_COUNTRIES WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
    </cffunction>
    <cffunction name="UPD_ADDRESSBOOK" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="company_status" default="">
        <cfquery name="UPD_ADDRESSBOOK" datasource="#DSN#">
			UPDATE 
               ADDRESSBOOK 
            SET 
               IS_ACTIVE = <cfif isdefined("arguments.company_status")>1<cfelse>0</cfif> 
            WHERE       
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
		</cfquery>
    </cffunction>
    <cffunction name="GET_WORKGROUP_MASTER" returntype="query">
        <cfargument name="company_id" default="">
        <cfargument name="OUR_COMPANY_ID" default="#session_base.company_id#">
        <cfquery name="GET_WORKGROUP_MASTER" datasource="#DSN#">
            SELECT
                COMPANY_ID,
                OUR_COMPANY_ID,
                IS_MASTER 
            FROM 
                WORKGROUP_EMP_PAR 
            WHERE
                IS_MASTER = 1 AND
                COMPANY_ID IS NOT NULL AND
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
        </cfquery>
        <cfreturn GET_WORKGROUP_MASTER>
    </cffunction>
    <cffunction name="UPD_IS_MASTER" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="OUR_COMPANY_ID" default="#session_base.company_id#">
        <cfquery name="UPD_IS_MASTER" datasource="#DSN#">
            UPDATE 
                WORKGROUP_EMP_PAR 
            SET 
                IS_MASTER = 0 
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
        </cfquery>
    </cffunction>
    <cffunction name="ADD_WORK_MEMBER" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="OUR_COMPANY_ID" default="#session_base.company_id#">
        <cfargument name="pos_code" default="">
        <cfargument name="RECORD_EMP" default="#session_base.userid#">
        <cfargument name="RECORD_IP" default="#cgi.remote_addr#">
        <cfargument name="RECORD_DATE" default="#now()#">
        <cfquery name="ADD_WORK_MEMBER" datasource="#DSN#">
            INSERT INTO
                WORKGROUP_EMP_PAR
            (
                COMPANY_ID,
                OUR_COMPANY_ID,
                POSITION_CODE,
                IS_MASTER,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_code#">,
                1,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
        </cfquery>
    </cffunction>
    <cffunction name="del_workgroup_emp_par" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="OUR_COMPANY_ID" default="#session_base.company_id#">
        <cfargument name="old_pos_code" default="">
        <cfquery name="del_workgroup_emp_par" datasource="#dsn#">
            DELETE 
            FROM 
                WORKGROUP_EMP_PAR 
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND 
                COMPANY_ID IS NOT NULL AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND 
                IS_MASTER = 1 AND 
                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.old_pos_code#">
        </cfquery>
    </cffunction>
    <cffunction name="del_member_product_cat_worknet" returntype="any">
        <cfargument name="company_id" default="">
        <cfquery name="del_member_product_cat" datasource="#dsn#"> 
            DELETE 
            FROM 
                WORKNET_RELATION_PRODUCT_CAT 
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
    </cffunction>
    <cffunction name="del_member_product_cat_sector" returntype="any">
        <cfargument name="company_id" default="">
        <cfquery name="del_member_product_cat" datasource="#dsn#"> 
             DELETE 
             FROM 
                COMPANY_SECTOR_RELATION 
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
    </cffunction>
    <cffunction name="UPD_COMP_PART_TC" returntype="any">
        <cfargument name="tckimlikno" default="">
        <cfargument name="UPDATE_IP" default="#cgi.remote_addr#">
        <cfargument name="UPDATE_MEMBER" default="#session_base.userid#">
        <cfargument name="UPDATE_DATE" default="#now()#">
        <cfargument name="manager_partner_id" default="">
        <cfquery name="UPD_COMP_PART_TC" datasource="#DSN#">
            UPDATE
                COMPANY_PARTNER
            SET
                TC_IDENTITY = <cfif len(arguments.tckimlikno)><cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.tckimlikno#"><cfelse>NULL</cfif>,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            WHERE
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.manager_partner_id#">
        </cfquery>
    </cffunction>
<!--- Calisanlar --->
    <cffunction name="GET_PARTNER_EMP" returntype="query">
        <cfargument name="partner_status" default="">
        <cfargument name="cpid" default="">
        <cfargument name="pid" default="">    
        <cfargument name="is_only_active_partners" default="">
        <cfquery name="GET_PARTNER" datasource="#DSN#">
            SELECT 
                CP.*,
				C.*,
				CP.WANT_CALL,
				CP.RESOURCE_ID
            FROM
                COMPANY_PARTNER CP, 
                COMPANY C
            WHERE 
            1=1
            <cfif isDefined("arguments.partner_status") and Len(arguments.partner_status)>
                AND CP.COMPANY_PARTNER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_status#">
            </cfif>
            <cfif isdefined("arguments.is_only_active_partners") and arguments.is_only_active_partners eq 1>
                AND CP.COMPANY_PARTNER_STATUS = 1
            </cfif>
            <cfif isDefined("arguments.cpid") and len(arguments.cpid)>
                AND CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"> AND 
                CP.COMPANY_ID = C.COMPANY_ID
            <cfelseif isDefined("arguments.pid") and Len(arguments.pid)>
                AND CP.PARTNER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND
                CP.COMPANY_ID = C.COMPANY_ID
            </cfif>
            ORDER BY 
                CP.COMPANY_PARTNER_NAME
        </cfquery>
        <cfreturn GET_PARTNER>
    </cffunction>
    <cffunction name="GET_PARTS_EMPS" returntype="query">
        <cfargument name="partner_status" default="">
        <cfargument name="cpid" default="">
        <cfargument name="pid" default="">
        <cfargument name="proid" default="">
        <cfargument name="is_only_active_partners" default="">
        <cfif isDefined("arguments.proid") and len(arguments.proid) and arguments.proid neq 0>
            <cfquery name="get_pro_emps" datasource="#DSN#">
                SELECT PARTNER_ID,EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.proid#" list="yes">)
            </cfquery>
            <cfset partnerId = len(get_pro_emps.partner_id)?valueList(get_pro_emps.partner_id):''>
            <cfset empId = len(get_pro_emps.employee_id)?valueList(get_pro_emps.employee_id):''>
        </cfif>
        <cfquery name="get_parts_emps" datasource="#DSN#">
            SELECT 
                1 TYPE,
                CP.PARTNER_ID AS ID_CE,
                CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS NAME_SURNAME,
                CP.COMPANY_PARTNER_EMAIL AS EMAIL
            FROM
                COMPANY_PARTNER CP, 
                COMPANY C
            WHERE 
            1=1
            <cfif isDefined("arguments.partner_status") and Len(arguments.partner_status)>
                AND CP.COMPANY_PARTNER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_status#">
            </cfif>
            <cfif isdefined("arguments.is_only_active_partners") and arguments.is_only_active_partners eq 1>
                AND CP.COMPANY_PARTNER_STATUS = 1
            </cfif>
            <cfif isDefined("arguments.cpid") and len(arguments.cpid)>
                AND CP.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#" list="yes">) AND 
                CP.COMPANY_ID = C.COMPANY_ID
            <cfelseif isDefined("arguments.pid") and Len(arguments.pid)>
                AND CP.PARTNER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND
                CP.COMPANY_ID = C.COMPANY_ID
            </cfif>
            <cfif isDefined("partnerId") and len(partnerId)>AND CP.PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#partnerId#" list="yes">)</cfif>
            UNION ALL 
                SELECT 
                    2 TYPE,
                    EP.EMPLOYEE_ID AS ID_CE,
                    EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS NAME_SURNAME,
                    EP.EMPLOYEE_EMAIL AS EMAIL
                FROM
                    EMPLOYEES AS EP
                WHERE 
                    EP.EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    <cfif isDefined("empId") and len(empId)>AND EP.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#empId#" list="yes">)</cfif>            
        </cfquery>
        <cfreturn get_parts_emps>
    </cffunction>
    <cffunction name="GET_CONS" returntype="query">
        <cfargument name="consumer_id" default="">
        <cfquery name="get_cons" datasource="#dsn#">
            SELECT 
                3 TYPE,
                CONSUMER_ID AS ID_CE,
                CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS NAME_SURNAME,
                CONSUMER_EMAIL AS EMAIL
            FROM
                CONSUMER
            WHERE 
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
        </cfquery>
        <cfreturn get_cons>
    </cffunction>
    <cffunction name="GET_PARTNER_SECOND" returntype="query">
        <cfargument name="brid" default="">
        <cfargument name="company_partner_username" default="">
        <cfargument name="company_partner_password" default="">
        <cfargument name="PASS" default="">
        <cfargument name="partner_id" default="">
        <cfargument name="CHECK_USERNAME" default="">
        <cfargument name="GET_PHOTO" default="">
        <cfquery name="GET_PARTNER" datasource="#DSN#">
            SELECT 
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME,
                PARTNER_ID,
                IMCAT_ID,
                IM,
                IMCAT2_ID,
                IM2,
                PHOTO,
                PHOTO_SERVER_ID
            FROM 
                COMPANY_PARTNER 
            WHERE 
            <cfif isDefined("CHECK_USERNAME") and CHECK_USERNAME eq 1> <!---Çalışan güncelleme sayfasından çağırılıyorsa --->
                COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_username#"> AND 
			    COMPANY_PARTNER_PASSWORD = <cfif isDefined("arguments.company_partner_password") and len(arguments.company_partner_password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PASS#"><cfelse>NULL</cfif>  AND
                PARTNER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
            <cfelseif isdefined("GET_PHOTO") and GET_PHOTO eq 1>    <!---Çalışan güncelleme sayfasından çağırılıyorsa --->
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
            <cfelse>    
                COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brid#">
            </cfif>    
        </cfquery>
        <cfreturn GET_PARTNER>
    </cffunction>
    <cffunction name="UPD_PHOTO_PARTNER" returntype="any">
        <cfargument name="partner_id" default="">
        <cfquery name="UPD_PHOTO" datasource="#DSN#">
			UPDATE COMPANY_PARTNER SET PHOTO = '' WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
		</cfquery>
    </cffunction>
    <cffunction name="get_imscat" returntype="query">
        <cfargument name="im_cats" default="">
        <cfquery name="get_ims" datasource="#DSN#">   
            SELECT
                IMCAT_ICON,
                IMCAT_LINK_TYPE,
                IMCAT_ID 
            FROM 
                SETUP_IM 
            WHERE 
                IMCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.im_cats#" list="yes">) 
            ORDER BY 
                IMCAT_ID
        </cfquery>
        <cfreturn get_ims>
    </cffunction>  
    <cffunction name="GET_PARTNER_BRANCH" returntype="query">
        <cfargument name="PARTNER_ID" default="">
        <cfquery name="GET_PARTNER_BRANCH" datasource="#DSN#">
            SELECT 
                B.COMPBRANCH_ID,
                B.COMPBRANCH__NICKNAME,
                B.COMPBRANCH__NAME
            FROM
                COMPANY_BRANCH B,
                COMPANY_PARTNER P
            WHERE
                P.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PARTNER_ID#"> AND
                P.COMPBRANCH_ID = B.COMPBRANCH_ID
        </cfquery>
        <cfreturn GET_PARTNER_BRANCH>
    </cffunction> 
  <!---   detail_partner sayfası --->
    <cffunction name="GET_IM" returntype="query">
        <cfquery name="GET_IM" datasource="#DSN#">
            SELECT 
                IMCAT_ID, 
                IMCAT 
            FROM 
                SETUP_IM
            ORDER BY
                IMCAT
        </cfquery>
        <cfreturn GET_IM>
    </cffunction> 
    <cffunction name="GET_LANGUAGE" returntype="query">
        <cfquery name="GET_LANGUAGE" datasource="#DSN#">
            SELECT 
                LANGUAGE_SHORT,
                LANGUAGE_SET
            FROM 
                SETUP_LANGUAGE
        </cfquery>
        <cfreturn GET_LANGUAGE>
    </cffunction> 
    <cffunction name="GET_BRANCH" returntype="query">
        <cfargument name="pid" default="">
        <cfquery name="GET_BRANCH" datasource="#DSN#">
            SELECT 
                B.COMPBRANCH_ID, 
                B.COMPBRANCH__NAME 
            FROM 
                COMPANY_BRANCH B, 
                COMPANY_PARTNER CP
            WHERE 
                CP.COMPANY_ID = B.COMPANY_ID AND
                CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
            ORDER BY
                B.COMPBRANCH__NAME 
        </cfquery>
        <cfreturn GET_BRANCH>
    </cffunction> 
    <cffunction name="GET_BRANCH_SECOND" returntype="query">
        <cfargument name="ZONE" default="">
        <cfquery name="GET_BRANCH" datasource="#DSN#">
            SELECT 
                BRANCH_ID, 
                ZONE_ID, 
                BRANCH_NAME
            FROM 
                BRANCH
            <cfif isDefined("URL.ZONE")>
            WHERE 
                ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ZONE#">
            </cfif>
        </cfquery>
        <cfreturn GET_BRANCH>
    </cffunction> 
    <cffunction name="GET_STATUS" returntype="query">
        <cfquery name="GET_STATUS" datasource="#DSN#">
            SELECT 
                CPS_ID,
                STATUS_NAME,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                UPDATE_DATE,
                UPDATE_IP,
                UPDATE_EMP
             FROM 
                 COMPANY_PARTNER_STATUS 
             ORDER BY 
                 STATUS_NAME
        </cfquery>
        <cfreturn GET_STATUS>
    </cffunction> 
    <cffunction name="GET_PARTNER_SETTINGS" returntype="query">
        <cfargument name="pid" default="">
        <cfquery name="GET_PARTNER_SETTINGS" datasource="#DSN#">
            SELECT
                TIME_ZONE,
                TIMEOUT_LIMIT
            FROM
                MY_SETTINGS_P
            WHERE
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
        </cfquery>
        <cfreturn GET_PARTNER_SETTINGS>
    </cffunction>
    <cffunction name="GET_COMPANY_PARTNER" returntype="query">
        <cfargument name="company_id" default="">
        <cfquery name="GET_COMPANY" datasource="#DSN#">
            SELECT
                MANAGER_PARTNER_ID,
                COMPANY_ADDRESS,
                COMPANY_POSTCODE,
                SEMT,
                COUNTY,
                CITY,
                COMPANY_TELCODE,
                COMPANY_TEL1,
                COMPANY_FAX,
                ISNULL(TAXNO,'') TAXNO
            FROM 
                COMPANY 
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn GET_COMPANY>
    </cffunction>
    <cffunction name="GET_HIER_PARTNER" returntype="query">
        <cfargument name="company_id" default="">
        <cfargument name="pid" default="">
        <cfargument name="cpid" default="">
        <cfargument name="GET_PARTNER" default="">
        <cfargument name="pdks_number" default="">
        <cfargument name="partner_id" default="">
        <cfargument name="PAR_PDKS_NUMBER" default="">
        <cfquery name="GET_HIER_PARTNER" datasource="#dsn#">
            SELECT 
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME,
                PARTNER_ID,
                PHOTO
            FROM 
                COMPANY_PARTNER 
            WHERE 
                <cfif isdefined("GET_PARTNER") and GET_PARTNER eq 1> <!---çalışan ekle sayfasından çağırılıyorsa --->
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cpid#"> 
                <cfelseif isdefined("PAR_PDKS_NUMBER") and  PAR_PDKS_NUMBER eq 1> <!---çalışan güncelle sayfasından çağırılıyorsa --->
                    PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pdks_number#"> AND
                    COMPANY_PARTNER_STATUS = 1 AND
                    PARTNER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                <cfelse>
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND 
                    PARTNER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> 
                </cfif>
        </cfquery>
        <cfreturn GET_HIER_PARTNER>
    </cffunction>
    <cffunction name="GET_COMP_COUNTY" returntype="query">
        <cfargument name="county" default="">
        <cfquery name="GET_COMP_COUNTY" datasource="#DSN#">
            SELECT 
                COUNTY_NAME,
                COUNTY_ID,  
                CITY, 
                SPECIAL_STATE_CAT_ID,
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP
            FROM 
                SETUP_COUNTY 
            WHERE 
                COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county#">    
        </cfquery>
        <cfreturn GET_COMP_COUNTY>
    </cffunction>
    <cffunction name="GET_COMP_CITY" returntype="query">
        <cfargument name="city" default="">
        <cfquery name="GET_COMP_CITY" datasource="#DSN#">
            SELECT 
                CITY_ID,
                CITY_NAME,
                PHONE_CODE, 
                PLATE_CODE, 
                COUNTRY_ID, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP,
                UPDATE_DATE,
                UPDATE_EMP,
                UPDATE_IP,
                PRIORITY 
            FROM 
                SETUP_CITY 
            WHERE 
                CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#">
        </cfquery>
        <cfreturn GET_COMP_CITY>
    </cffunction>
    <cffunction name="GET_COMPANY_BRANCH" returntype="query">
        <cfargument name="compid" default="">
        <cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
            SELECT
                CB.COUNTY_ID,
                CB.COMPBRANCH_ID,
                CB.COMPBRANCH__NAME,
                CB.COMPBRANCH_ADDRESS,
                CB.COMPBRANCH_POSTCODE,
                CB.COMPBRANCH_TELCODE,
                CB.COMPBRANCH_TEL1,
                CB.COMPBRANCH_FAX,					 
                CB.SEMT,
                CB.CITY_ID,
                SC.COUNTY_NAME,
                STPC.CITY_NAME
            FROM 
                COMPANY_BRANCH CB,
                SETUP_COUNTY SC,
                SETUP_CITY STPC 
            WHERE 
                CB.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.compid#"> AND
                SC.COUNTY_ID = CB.COUNTY_ID AND
                STPC.CITY_ID = CB.CITY_ID	
        UNION	
            SELECT
                CB.COUNTY_ID,
                CB.COMPBRANCH_ID,
                CB.COMPBRANCH__NAME,
                CB.COMPBRANCH_ADDRESS,
                CB.COMPBRANCH_POSTCODE,
                CB.COMPBRANCH_TELCODE,
                CB.COMPBRANCH_TEL1,
                CB.COMPBRANCH_FAX,					 
                CB.SEMT,
                CB.CITY_ID,
                '' COUNTY_NAME,
                STPC.CITY_NAME
            FROM 
                COMPANY_BRANCH CB,
                SETUP_CITY STPC 
            WHERE 
                CB.COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.compid#"> AND
                STPC.CITY_ID = CB.CITY_ID AND
                CB.COUNTY_ID IS NULL		
        UNION
            SELECT
                CB.COUNTY_ID,
                CB.COMPBRANCH_ID,
                CB.COMPBRANCH__NAME,
                CB.COMPBRANCH_ADDRESS,
                CB.COMPBRANCH_POSTCODE,
                CB.COMPBRANCH_TELCODE,
                CB.COMPBRANCH_TEL1,
                CB.COMPBRANCH_FAX,					 
                CB.SEMT,
                CB.CITY_ID,
                '' COUNTY_NAME,
                '' CITY_NAME
            FROM 
                COMPANY_BRANCH CB
            WHERE 
                CB.COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.compid#"> AND
                CB.CITY_ID IS NULL AND
                CB.COUNTY_ID IS NULL
            ORDER BY
                COMPBRANCH__NAME
        </cfquery>
        <cfreturn GET_COMPANY_BRANCH>
    </cffunction>
    <!--- upd_partner--->
    <cffunction name="UPD_PHOTO" returntype="any">
        <cfargument name="SERVERFILE" default="">
        <cfargument name="partner_id" default="">
        <cfquery name="UPD_PHOTO" datasource="#DSN#">
			UPDATE
               COMPANY_PARTNER 
            SET 
               PHOTO = <cfif isdefined("arguments.SERVERFILE") and len(arguments.SERVERFILE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SERVERFILE#"><cfelse>NULL</cfif>
            WHERE 
               PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
		</cfquery>
    </cffunction>
    <cffunction name="UPD_PHOTO_SECOND" returntype="any">
        <cfargument name="SERVERFILE" default="">
        <cfargument name="server_machine" default="">
        <cfargument name="partner_id" default="">
        <cfquery name="UPD_PHOTO" datasource="#DSN#">
			UPDATE 
				COMPANY_PARTNER 
			SET 
				PHOTO = <cfif isdefined("arguments.SERVERFILE") and len(arguments.SERVERFILE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SERVERFILE#"><cfelse>NULL</cfif>,
				PHOTO_SERVER_ID= <cfif isdefined("arguments.server_machine")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_machine#"><cfelse>NULL</cfif>
			WHERE 
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
		</cfquery>
    </cffunction>
    <cffunction name="UPD_PARTNER" returntype="any">
        <cfargument name="UPDATE_DATE" default="#now()#">
        <cfargument name="UPDATE_MEMBER" default="#session_base.userid#">
        <cfargument name="UPDATE_IP" default="#cgi.remote_addr#">
        <cfargument name="partner_id" default="">
        <cfquery name="UPD_PARTNER" datasource="#DSN#">
            UPDATE
                COMPANY_PARTNER 
            SET
                UPDATE_DATE =<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                <cfif isDefined("arguments.company_partner_username")> 
                    ,COMPANY_PARTNER_USERNAME= <cfif isDefined("arguments.company_partner_username") and len(arguments.company_partner_username)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_username#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.company_partner_password") and len(arguments.company_partner_password)>    
                    ,COMPANY_PARTNER_PASSWORD=  <cfif isDefined("arguments.company_partner_password") and len(arguments.company_partner_password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.COMPANY_PARTNER_PASSWORD#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isDefined("arguments.tc_identity")> 
                    ,TC_IDENTITY= <cfif isDefined("arguments.tc_identity") and len(arguments.tc_identity)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tc_identity#"><cfelse>NULL</cfif>
                </cfif>   
                <cfif isDefined("arguments.company_partner_name")>  		
                    ,COMPANY_PARTNER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_name#">
                </cfif> 
                <cfif isDefined("arguments.company_partner_surname")>   
                    ,COMPANY_PARTNER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_surname#">
                </cfif> 
                <cfif isDefined("arguments.company_partner_status")>   
                    ,COMPANY_PARTNER_STATUS = <cfif isDefined("arguments.company_partner_status") and len(arguments.company_partner_status)>1<cfelse>0</cfif>
                </cfif>    
                <cfif isDefined("arguments.mission")>
                    ,MISSION = <cfif isDefined("arguments.mission") and len(arguments.mission)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mission#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.department")>    
                    ,DEPARTMENT= <cfif isDefined("arguments.department") and  len(arguments.department)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.title")>
                    ,TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
                </cfif>
                <cfif isDefined("arguments.company_partner_email")>    
                    ,COMPANY_PARTNER_EMAIL = <cfif isDefined("arguments.company_partner_email") and len(arguments.company_partner_email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_email#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.partner_kep_adress")>    
                    ,PARTNER_KEP_ADRESS = <cfif isDefined("arguments.partner_kep_adress") and len(arguments.partner_kep_adress)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.partner_kep_adress#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.sex")>    
                    ,SEX= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sex#">
                </cfif>
                <cfif isDefined("arguments.imcat_id")>
                    ,IMCAT_ID = <cfif isDefined("arguments.imcat_id") and len(arguments.imcat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.imcat_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.im")>    
                    ,IM =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.im#">
                </cfif>
                <cfif isDefined("arguments.imcat2_ID")>
                    ,IMCAT2_ID = <cfif isDefined("arguments.imcat2_ID") and len(arguments.imcat2_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.imcat2_ID#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.im2")>    
                    ,IM2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.im2#">
                </cfif>
                <cfif isDefined("arguments.mobilcat_id")>
                    ,MOBIL_CODE = <cfif isDefined("arguments.mobilcat_id") and len(arguments.mobilcat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobilcat_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.mobiltel")>
                    ,MOBILTEL = <cfif isDefined("arguments.mobiltel") and len(arguments.mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobiltel#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.company_partner_telcode")>    
                    ,COMPANY_PARTNER_TELCODE = <cfif isDefined("arguments.company_partner_telcode") and len(arguments.company_partner_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_telcode#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.company_partner_tel")>    
                    ,COMPANY_PARTNER_TEL = <cfif isDefined("arguments.company_partner_tel") and len(arguments.company_partner_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_tel#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.company_partner_tel_ext")>    
                    ,COMPANY_PARTNER_TEL_EXT = <cfif isDefined("arguments.company_partner_tel_ext") and len(arguments.company_partner_tel_ext)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_tel_ext#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isDefined("arguments.company_partner_fax")>    
                    ,COMPANY_PARTNER_FAX = <cfif isDefined("arguments.company_partner_fax") and len(arguments.company_partner_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_fax#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.homepage")>    
                    ,HOMEPAGE = <cfif isDefined("arguments.homepage") and len(arguments.homepage)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homepage#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.language_id")>    
                    ,LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">
                </cfif>    
                    ,UPDATE_MEMBER_TYPE = 1
                    ,UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.userid#">
                    ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                <cfif isDefined("arguments.start_date")>     
                    ,START_DATE = <cfif isDefined("arguments.start_date") and len(arguments.start_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.finish_date")> 
                    ,FINISH_DATE = <cfif isDefined("arguments.finish_date") and len(arguments.finish_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finish_date#"><cfelse>NULL</cfif>
                </cfif> 
                <cfif isDefined("arguments.hier_partner_id")>    
                    ,HIERARCHY_PARTNER_ID = <cfif isDefined("arguments.hier_partner_id") and len(arguments.hier_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hier_partner_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.pdks_number")>     
                    ,PDKS_NUMBER=<cfif isDefined("arguments.pdks_number") and len(arguments.pdks_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pdks_number#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isDefined("arguments.pdks_type_id")>
                    ,PDKS_TYPE_ID=<cfif isDefined("arguments.pdks_type_id") and len(arguments.pdks_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pdks_type_id#"><cfelse>NULL</cfif>
                </cfif>   
                <cfif isDefined("arguments.compbranch_id")> 
                    ,COMPBRANCH_ID = #listfirst(arguments.compbranch_id,';')#
                </cfif>
                <cfif isDefined("arguments.company_partner_address")>               
                    ,COMPANY_PARTNER_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_address#">
                </cfif>
                <cfif isDefined("arguments.company_partner_postcode")>     
                    ,COMPANY_PARTNER_POSTCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_postcode#">
                </cfif>
                <cfif isDefined("arguments.county_id")>     
                    ,COUNTY = <cfif isDefined("arguments.county_id") and len(arguments.county_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.city_id")>     
                    ,CITY = <cfif isDefined("arguments.city_id") and len(arguments.city_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.semt")>     
                    ,SEMT= <cfif isdefined("arguments.semt") and len(arguments.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.semt#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.district_id")>     
                    ,DISTRICT_ID = <cfif isdefined("arguments.district_id") and len(arguments.district_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.district_id#"><cfelse>NULL</cfif>
                </cfif>  
                <cfif isDefined("arguments.country")> 
                    ,COUNTRY = <cfif isDefined("arguments.country") and len(arguments.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#"><cfelse>NULL</cfif>
                </cfif>    
                <cfif isDefined("arguments.photo") and len(arguments.photo)>
                    ,PHOTO='#file_name#.#arguments.serverfileext#'
                </cfif>
                <cfif isDefined("arguments.photo") and len(arguments.photo)>
                    ,PHOTO_SERVER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.server_machine#">
                </cfif>
                <cfif isDefined("arguments.status_id")>
                    ,CP_STATUS_ID = <cfif isDefined("arguments.status_id") and len(arguments.status_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status_id#"><cfelse>NULL</cfif>
                </cfif>
                <cfif isDefined("arguments.not_want_email")>    
                    ,WANT_EMAIL = <cfif isdefined('arguments.not_want_email') and len(arguments.not_want_email)>0<cfelse>1</cfif>
                </cfif>
                <cfif isDefined("arguments.not_want_sms")>    
                    ,WANT_SMS = <cfif isdefined('arguments.not_want_sms') and len(arguments.not_want_sms)>0<cfelse>1</cfif>
                </cfif>
                <cfif isDefined("arguments.send_finance_mail")>    
                    ,IS_SEND_FINANCE_MAIL = <cfif isdefined('arguments.send_finance_mail') and len(arguments.send_finance_mail)>1<cfelse>0</cfif>
                </cfif>
                <cfif isDefined("arguments.send_earchive_mail")>    
                    ,IS_SEND_EARCHIVE_MAIL = <cfif isdefined('arguments.send_earchive_mail') and len(arguments.send_earchive_mail)>1<cfelse>0</cfif>
                </cfif>
                <cfif isDefined("arguments.birthdate")>    
                    ,BIRTHDATE = <cfif isdefined("arguments.birthdate") and len(arguments.birthdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.birthdate#"><cfelse>NULL</cfif>
                </cfif>
				<cfif isDefined("arguments.resource")>    
                    ,RESOURCE_ID = <cfif isdefined("arguments.resource") and len(arguments.resource)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.resource#"><cfelse>NULL</cfif>
                </cfif>
				<cfif isDefined("arguments.not_want_call")>    
                    ,WANT_CALL = <cfif isdefined('arguments.not_want_call') and len(arguments.not_want_call)>0<cfelse>1</cfif>
                </cfif>
            WHERE 
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
        </cfquery>
    </cffunction>
    <!--- Iliskili Bireysel Uye--->
    <cffunction name="GET_RELATED_CONSUMER_CONTROL" returntype="query">
        <cfargument name="partner_id" default="">
        <cfquery name="GET_RELATED_CONSUMER_CONTROL" datasource="#DSN#">
            SELECT
               RELATED_CONSUMER_ID 
            FROM 
               COMPANY_PARTNER 
            WHERE 
               PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"> AND 
               RELATED_CONSUMER_ID IS NOT NULL
        </cfquery>
        <cfreturn GET_RELATED_CONSUMER_CONTROL>
    </cffunction>
    <cffunction name="UPD_RELATED_CONSUMER" returntype="any">
        <cfargument name="UPDATE_DATE" default="#now()#">
        <cfargument name="UPDATE_EMP" default="#session_base.userid#">
        <cfargument name="UPDATE_IP" default="#cgi.remote_addr#">
        <cfargument name="related_consumer_id" default="">
        <cfquery name="UPD_RELATED_CONSUMER" datasource="#DSN#">
            UPDATE
                CONSUMER
            SET
                UPDATE_DATE =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            <cfif isDefined("arguments.company_partner_username")> 
                ,CONSUMER_USERNAME = <cfif isdefined("arguments.company_partner_username") and len(arguments.company_partner_username)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_username#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" null="yes"></cfif>
            </cfif>     
            <cfif isDefined("arguments.company_partner_password")>   
                ,CONSUMER_PASSWORD = <cfif isdefined("arguments.company_partner_password") and len(arguments.company_partner_password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_password#"></cfif>
            </cfif>
            <cfif isDefined("arguments.tc_identity")>     
                ,TC_IDENTY_NO =  <cfif isdefined("arguments.tc_identity") and len(arguments.tc_identity)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tc_identity#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" null="yes"></cfif>
            </cfif>
            <cfif isDefined("arguments.company_partner_name")>    		
                ,CONSUMER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_name#">
            </cfif>    
            <cfif isDefined("arguments.company_partner_surname")>  
                ,CONSUMER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_surname#">
            </cfif>    
                <!--- CONSUMER_STATUS = <cfif isDefined("arguments.company_partner_status")><cfqueryparam cfsqltype="cf_sql_bigint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bigint" value="0"></cfif>, --->
            <cfif isDefined("arguments.mission")>  
                ,MISSION = <cfif isdefined("arguments.mission") and len(arguments.mission)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mission#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.department")>      
                ,DEPARTMENT= <cfif isdefined("arguments.department") and len(arguments.department)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.title")>      
                ,TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
            </cfif>
            <cfif isDefined("arguments.company_partner_email")>      
                ,CONSUMER_EMAIL = <cfif isdefined("arguments.company_partner_email") and len(arguments.company_partner_email)><cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.company_partner_email#"><cfelse>NULL</cfif>
            </cfif> 
            <cfif isDefined("arguments.partner_kep_adress")>      
                ,CONSUMER_KEP_ADDRESS = <cfif isdefined("arguments.partner_kep_adress") and len(arguments.partner_kep_adress)><cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.partner_kep_adress#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.partner_kep_adress")>     
                ,CONSUMER_KEP_ADDRESS = <cfif isdefined("arguments.partner_kep_adress") and len(arguments.partner_kep_adress)><cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.partner_kep_adress#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.sex")>      
                ,SEX = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.sex#">
            </cfif>
            <cfif isDefined("arguments.imcat_id")>      
                ,IMCAT_ID = <cfif isdefined("arguments.imcat_id") and len(arguments.imcat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.imcat_id#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.im")>      
                ,IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.im#">
            </cfif>
            <cfif isDefined("arguments.mobilcat_id")>      
                ,MOBIL_CODE = <cfif isdefined("arguments.mobilcat_id") and len(arguments.mobilcat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobilcat_id#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.mobiltel")>      
                ,MOBILTEL = <cfif isdefined("arguments.mobiltel") and len(arguments.mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobiltel#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.company_partner_telcode")>      
                ,CONSUMER_WORKTELCODE = <cfif isdefined("arguments.company_partner_telcode") and len(arguments.company_partner_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_telcode#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.company_partner_tel")>      
                ,CONSUMER_WORKTEL = <cfif isdefined("arguments.company_partner_tel") and len(arguments.company_partner_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_tel#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.company_partner_tel_ext")>      
                ,CONSUMER_TEL_EXT = <cfif isdefined("arguments.company_partner_tel_ext") and len(arguments.company_partner_tel_ext)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_tel_ext#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.company_partner_telcode")>      
                ,CONSUMER_FAXCODE = <cfif isdefined("arguments.company_partner_telcode") and len(arguments.company_partner_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_telcode#"><cfelse>NULL</cfif>
            </cfif>    
            <cfif isDefined("arguments.company_partner_fax")>      
                ,CONSUMER_FAX = <cfif isdefined("arguments.company_partner_fax") and len(arguments.company_partner_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_fax#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.homepage")>      
                ,HOMEPAGE = <cfif isdefined("arguments.homepage") and len(arguments.homepage)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homepage#"><cfelse>NULL</cfif>
            </cfif>  
            <cfif isDefined("arguments.language_id")>    
                ,LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">
            </cfif>    
                ,UPDATE_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">
                ,UPDATE_CONS = NULL
                ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remote_addr#">
            <cfif isDefined("arguments.start_date")> 
                START_DATE = <cfif isdefined("arguments.start_date") and len(arguments.start_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.company_partner_address")>     
                ,TAX_ADRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_address#">
            </cfif>
            <cfif isDefined("arguments.company_partner_postcode")>     
                ,TAX_POSTCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_partner_postcode#">
            </cfif>
            <cfif isDefined("arguments.county_id")>     
                ,TAX_COUNTY_ID = <cfif isdefined("arguments.county_id") and len(arguments.county_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.city_id")>     
                ,TAX_CITY_ID = <cfif isdefined("arguments.city_id") and len(arguments.city_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.semt")>     
                ,TAX_SEMT = <cfif isdefined("arguments.semt") and len(arguments.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.semt#"><cfelse>NULL</cfif>
            </cfif>
            <cfif isDefined("arguments.country")>     
                ,TAX_COUNTRY_ID = <cfif isdefined("arguments.country") and len(arguments.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#"><cfelse>NULL</cfif>
            </cfif>    
            WHERE
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_consumer_id#">
        </cfquery>
    </cffunction>
    <cffunction name="GET_COMPANY_NAME" returntype="query">
        <cfargument name="company_id" default="">
        <cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
            SELECT 
                TOP 1 CSR.SECTOR_ID,
                C.FULLNAME 
            FROM 
                COMPANY C LEFT JOIN COMPANY_SECTOR_RELATION CSR ON C.COMPANY_ID = CSR.COMPANY_ID
            WHERE 
                C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn GET_COMPANY_NAME>
    </cffunction>
    <cffunction name="CONTROL_" returntype="query">
        <cfargument name="partner_id" default="">
        <cfquery name="CONTROL_" datasource="#DSN#">
            SELECT PARTNER_ID FROM MY_SETTINGS_P WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
        </cfquery>
        <cfreturn CONTROL_>
    </cffunction>
    <cffunction name="UPD_PARTNER_SETTINGS" returntype="any">
        <cfargument name="language_id" default="">
        <cfargument name="time_zone" default="">
        <cfargument name="timeout_limit" default="">
        <cfargument name="partner_id" default="">
        <cfquery name="UPD_PARTNER_SETTINGS" datasource="#DSN#">
            UPDATE
                MY_SETTINGS_P
            SET
                LANGUAGE_ID =  <cfif isdefined("arguments.language_id")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#"><cfelse>NULL</cfif> ,
                TIME_ZONE =  <cfif isdefined("time_zone")> <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.time_zone#"><cfelse>NULL</cfif>,
                TIMEOUT_LIMIT =  <cfif isdefined("timeout_limit")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.timeout_limit#"><cfelse>NULL</cfif> 
            WHERE
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
        </cfquery>
    </cffunction>
    <cffunction name="ADD_PART_SETTINGS_PARNER" returntype="any">
        <cfargument name="partner_id" default="">
        <cfargument name="time_zone" default="">
        <cfargument name="language_id" default="">
        <cfargument name="timeout_limit" default="">
        <cfquery name="ADD_PART_SETTINGS" datasource="#DSN#">
            INSERT INTO 
            MY_SETTINGS_P 
            (
                PARTNER_ID,
                TIME_ZONE,
                LANGUAGE_ID,
                MAXROWS,
                TIMEOUT_LIMIT
            ) 
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">,
                <cfif isdefined("time_zone")> <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.time_zone#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.language_id")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#"><cfelse>NULL</cfif>,
                20,
                <cfif isdefined("timeout_limit")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.timeout_limit#"><cfelse>NULL</cfif>
            )
        </cfquery>
    </cffunction>
     <cffunction name="DEL_WRK_APP" returntype="any">
        <cfargument name="partner_id" default="">
        <cfquery name="DEL_WRK_APP" datasource="#DSN#">
            DELETE FROM WRK_SESSION WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"> AND USER_TYPE = 1
        </cfquery>
    </cffunction>
    <cffunction name="get_control" returntype="query">
        <cfargument name="company_id" default="">
        <cfargument name="pid" default="">
        <cfquery name="get_control" datasource="#dsn#">
            SELECT 
                PARTNER_ID
            FROM 
                COMPANY_PARTNER 
            WHERE 
                COMPANY_ID = <cfif isdefined("arguments.company_id") and len(arguments.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>null</cfif> AND
                HIERARCHY_PARTNER_ID =<cfif isdefined("arguments.pid") and len(arguments.pid)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"><cfelse>null</cfif>
        </cfquery>
        <cfreturn get_control>
    </cffunction>
    <cffunction name="get_pdks_types" returntype="query">
        <cfquery name="get_pdks_types" datasource="#dsn#">
            SELECT PDKS_TYPE_ID,PDKS_TYPE FROM SETUP_PDKS_TYPES
        </cfquery>
        <cfreturn get_pdks_types>
    </cffunction>
    <cffunction name="detail_partner_city" returntype="query">
        <cfargument name="country" default="">
        <cfquery name="GET_CITY" datasource="#DSN#">
            SELECT CITY_ID, CITY_NAME FROM SETUP_CITY 
            <cfif len(arguments.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#"></cfif>
        </cfquery>
        <cfreturn GET_CITY>
    </cffunction>
    <cffunction name="detail_partner_county" returntype="query">
        <cfargument name="city" default="">
        <cfquery name="GET_COUNTY" datasource="#DSN#">
            SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(arguments.city)> WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#"></cfif>
        </cfquery>
        <cfreturn GET_COUNTY>
    </cffunction>
    <cffunction name="detail_partner_district" returntype="query">
        <cfargument name="county" default="">
        <cfquery name="get_district_name" datasource="#dsn#">
            SELECT DISTRICT_ID,DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfif isdefined("arguments.county") and len(arguments.county)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county#"><cfelse>null</cfif>
        </cfquery>
        <cfreturn get_district_name>
    </cffunction>
    <cffunction name="start_watalogy" returntype="any">
        <cfargument name="subscription_no" required="false" default="" hint="abone no">
        <cfargument name="watalogy_code" required="false" default="" hint="watalogy code">
        <cfargument name="worknet_id" required="false" default="" hint="pazaryeri id">
        <cfargument name="title" required="false" default="">
        <cfargument name="tax_office" required="false" default="">
        <cfargument name="tax_no" required="false" default="">
        <cfargument name="name" required="false" default="">
        <cfargument name="surname" required="false" default="">
        <cfargument name="mail" required="false" default="">
        <cfargument name="phone" required="false" default="">
        <cfargument name="phone_code" required="false" default="">
        <cfargument name="mobil_code" required="false" default="">
        <cfargument name="mobile_phone" required="false" default="">
        <cfargument name="modal_id" required="false" default="">
        <cfargument name="nickname" required="false" default="#session.ep.company_nick#">
        <cfargument name="domain" required="false" default="#session.ep.company_nick#">
        <cfargument name="period_id" required="false" default="#session.ep.period_id#">
        <cfargument name="period_year" required="false" default="#session.ep.period_year#">
        <cfargument name="money" required="false" default="#session.ep.money#">
        <cfset arguments.our_company_id = session.ep.company_id>
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="get_domain" datasource="#dsn#">
                SELECT WEBSITE FROM WORKNET WHERE WORKNET_ID = <cfqueryparam value = "#arguments.worknet_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfset arguments.domain = get_domain.WEBSITE>
            <cfscript>
                chars="ABCDEFGHIJKLMNOPQRSTUVYZ0123456789";
                var i = 0;
                var arguments.watalogy_code = "";
                for (i = 0; i < 12; i++) {
                    arguments.watalogy_code &= Mid(chars, RandRange(1, len(chars), "SHA1PRNG"), 1);
                }
            </cfscript>           
            <cfhttp url="https://networg.workcube.com/wex.cfm/watalogyServices/start" result="response" charset="utf-8" method="POST">            
                <cfhttpparam name="data" type="formfield" value="#Replace(serializeJSON(arguments),"//","")#">            
            </cfhttp>
            <cfset response = DeserializeJson(response.Filecontent)>
            
            <cfif response.status>
                <cfhttp url="http://watalogy.workcube.com/wex.cfm/watalogyServices/start" result="result" charset="utf-8" method="POST">
                    <cfhttpparam name="data" type="formfield" value="#Replace(serializeJSON(arguments),"//","")#">            
                </cfhttp>
                <cfset result = DeserializeJson(result.Filecontent)>
                <cfif result.status>
                    <cfquery name="UPD_OUR_COMPANY_INFO" datasource="#DSN#">
                        UPDATE
                            OUR_COMPANY_INFO
                        SET
                            IS_WATALOGY_INTEGRATED = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                            WATALOGY_MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.watalogy_code#">							
                        WHERE
                            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    </cfquery>
                    <cfquery name="insert_relation_worknet" datasource="#dsn#" result="result">
                        INSERT INTO
                            WORKNET_RELATION_COMPANY
                            (
                                WORKNET_ID,
                                WORKNET_DOMAIN,
                                OUR_COMPANY_ID,
                                SUBSCRIPTION_NO,
                                WATALOGY_CODE,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                        VALUES
                            (
                                <cfqueryparam value = "#arguments.worknet_id#" CFSQLType = "cf_sql_integer">,
                                <cfqueryparam value = "#arguments.domain#" CFSQLType = "cf_sql_nvarchar">,
                                <cfqueryparam value = "#session.ep.company_id#" CFSQLType = "cf_sql_integer">,
                                <cfqueryparam value = "#arguments.subscription_no#" CFSQLType = "cf_sql_nvarchar">,
                                <cfqueryparam value = "#arguments.watalogy_code#" CFSQLType = "cf_sql_nvarchar">,
                                <cfqueryparam value = "#now()#" CFSQLType = "cf_sql_date">,
                                <cfqueryparam value = "#session.ep.userid#" CFSQLType = "cf_sql_integer">,
                                <cfqueryparam value = "#cgi.remote_addr#" CFSQLType = "cf_sql_nvarchar">
                            )
                    </cfquery>
                    <cfset responseStruct.identity = result.IDENTITYCOL>
                    <cfset responseStruct.message = arguments.watalogy_code>
                    <cfset responseStruct.status = true>
                    <cfset responseStruct.draggable = true>
                </cfif>             
            </cfif>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
                <cfset responseStruct.modal_id = arguments.modal_id>
                <cfset responseStruct.draggable = true>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction name="update_company_member_code">
        <cfargument name="company_id" default="">
        <cfquery name="q_update_company_member_code" datasource="#dsn#">
            UPDATE COMPANY SET MEMBER_CODE = 'C#arguments.company_id#' WHERE COMPANY_ID = #arguments.company_id#
        </cfquery>
    </cffunction>
</cfcomponent>