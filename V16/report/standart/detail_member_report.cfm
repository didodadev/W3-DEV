<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.detayli_uye_analizi_raporu">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.companycat_id" default=""> 
<cfparam name="attributes.consumercat_id" default="">
<cfparam name="attributes.search_potential" default="">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.search_type" default="0">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.partner_position" default="">
<cfparam name="attributes.member_status" default="">
<cfparam name="attributes.partner_status" default="">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.startdate_1" default="">
<cfparam name="attributes.startdate_2" default="">
<cfparam name="attributes.recorddate_1" default="">
<cfparam name="attributes.recorddate_2" default="">
<cfparam name="attributes.our_company_id" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.ref_pos_code" default="">
<cfparam name="attributes.ref_pos_code_name" default="">
<cfparam name="attributes.sales_county" default="">
<cfparam name="attributes.process_stage_type_com" default="">
<cfparam name="attributes.process_stage_type_con" default="">
<cfparam name="attributes.paymethod_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.paymethod_name" default="">
<cfparam name="attributes.revmethod_id" default="">
<cfparam name="attributes.card_revmethod_id" default="">
<cfparam name="attributes.revmethod_name" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.resource_type" default="">
<cfparam name="attributes.ims_code" default="">
<cfparam name="attributes.add_info" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.not_want_sms" default="">
<cfparam name="attributes.not_want_email" default="">
<cfparam name="attributes.logo_status" default="">
<cfparam name="attributes.country_id" default="1">
<cfparam name="attributes.use_efatura" default="">
<cfparam name="attributes.is_show_member_team" default="">
<cfparam name="attributes.member_team_roles" default="">
<cfif isdefined("attributes.startdate_1") and isdate(attributes.startdate_1)><cf_date tarih= "attributes.startdate_1"></cfif>
<cfif isdefined("attributes.startdate_2") and isdate(attributes.startdate_2)><cf_date tarih= "attributes.startdate_2"></cfif>
<cfif isdefined("attributes.recorddate_1") and isdate(attributes.recorddate_1)><cf_date tarih= "attributes.recorddate_1"></cfif>
<cfif isdefined("attributes.recorddate_2") and isdate(attributes.recorddate_2)><cf_date tarih= "attributes.recorddate_2"></cfif>
<cfset cmp = createObject("component","V16.settings.cfc.setupCountry") />
<cfset get_Country = cmp.getCountry()>
<cfif len(attributes.country_id)>
<cfquery name="GetCity" datasource="#dsn#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = #attributes.country_id#
</cfquery>
</cfif>
<cfif len(attributes.city_id)>
<cfquery name="GetCounty" datasource="#dsn#">
	SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = #attributes.city_id#
</cfquery>
</cfif>
<cfquery name="GET_CONSUMER_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_COMPANY_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="COMPANY_CAT" datasource="#DSN#">
	SELECT DISTINCT	COMPANYCAT_ID, COMPANYCAT FROM GET_MY_COMPANYCAT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY COMPANYCAT
</cfquery>
<cfset companycat_list = 0>
<cfif company_cat.recordcount>
	<cfset companycat_list = ValueList(company_cat.companycat_id,',')>
</cfif>
<cfquery name="CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT	CONSCAT_ID, CONSCAT FROM GET_MY_CONSUMERCAT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY CONSCAT
</cfquery>
<cfset conscat_list = 0>
<cfif consumer_cat.recordcount>
	<cfset conscat_list = ValueList(consumer_cat.conscat_id,',')>
</cfif>
<cfquery name="GET_SZ" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_COMPANY_SECTOR" datasource="#DSN#">
	SELECT SECTOR_CAT_ID, SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<cfif session.ep.our_company_info.subscription_contract eq 1>
	<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
		SELECT 
        	SC.SUBSCRIPTION_NO,
            SC.COMPANY_ID,
            SC.CONSUMER_ID,
            SC.PARTNER_ID,
            SC.INVOICE_ADDRESS
			<cfif listfind(attributes.list_type,57)>
            ,CT.CITY_NAME
            </cfif> 
            <cfif listfind(attributes.list_type,58)>
            ,CON.COUNTY_NAME
            </cfif>
       FROM 
       		SUBSCRIPTION_CONTRACT SC
			<cfif listfind(attributes.list_type,57)>
            LEFT JOIN #DSN_ALIAS#.SETUP_CITY CT ON CT.CITY_ID=SC.INVOICE_CITY_ID
            </cfif>
            <cfif listfind(attributes.list_type,58)>
            LEFT JOIN #DSN_ALIAS#.SETUP_COUNTY CON ON CON.COUNTY_ID=SC.INVOICE_COUNTY_ID
            </cfif>  
            WHERE 
			<cfif attributes.search_type is 2>
            SC.CONSUMER_ID IS NOT NULL
            <cfelse>
            SC.COMPANY_ID IS NOT NULL</cfif>
	</cfquery>
</cfif>
<cfquery name="GET_PARTNER_POSITIONS" datasource="#DSN#">
	SELECT PARTNER_POSITION_ID, PARTNER_POSITION FROM SETUP_PARTNER_POSITION ORDER BY PARTNER_POSITION
</cfquery>
<cfquery name="GET_DEPT_NAME" datasource="#dsn#">
	SELECT PARTNER_DEPARTMENT_ID,PARTNER_DEPARTMENT FROM SETUP_PARTNER_DEPARTMENT
</cfquery>
<cfquery name="get_pdks_types" datasource="#dsn#">
	SELECT PDKS_TYPE_ID,PDKS_TYPE FROM SETUP_PDKS_TYPES
</cfquery>
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT		
		BRANCH.BRANCH_NAME, 
		BRANCH.BRANCH_ID,
		BRANCH.COMPANY_ID
	FROM 
		BRANCH, 
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND
        EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL AND
		BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		BRANCH.BRANCH_NAME
</cfquery>
<!--- <cfquery name="CHK_COMPANY_SECTOR_RELATION" datasource="#dsn#"><!--- kayıt olmadığında sektorler bos geliyor --->
	SELECT COUNT(*) COUNT FROM COMPANY_SECTOR_RELATION
</cfquery> --->
<cfquery name="get_roles" datasource="#dsn#">
	SELECT PROJECT_ROLES_ID, PROJECT_ROLES FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES
</cfquery>
<cfif isDefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
	<cfif xml_member_analysis_info eq 1 and isDefined("attributes.analyse_id") and isDefined("attributes.analyse_name") and Len(attributes.analyse_id) and Len(attributes.analyse_name)>
		<cfquery name="GET_MEMBER_ANALYSIS" datasource="#dsn#">
			SELECT ANALYSIS_PARTNERS, ANALYSIS_CONSUMERS FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analyse_id#">
		</cfquery>
		<cfset Analyse_CompCat_List = ListSort(ListDeleteDuplicates(ValueList(Get_Member_Analysis.Analysis_Partners,',')),"numeric","asc",",")>
		<cfset Analyse_ConsCat_List = ListSort(ListDeleteDuplicates(ValueList(Get_Member_Analysis.Analysis_Consumers,',')),"numeric","asc",",")>
	</cfif>
	<cfif attributes.search_type eq 0 or attributes.search_type eq 1>
        <cfquery name="GET_MEMBER" datasource="#DSN#">
            SELECT 
                C.COMPANY_ID MEMBER_ID,
                C.SECTOR_CAT_ID,
                C.MANAGER_PARTNER_ID,
            <cfif listfind(attributes.list_type,26)>
	            (
                        SELECT DISTINCT
                            SC.SECTOR_CAT+',' AS [text()]
                        FROM 
                            SETUP_SECTOR_CATS SC,
                            COMPANY_SECTOR_RELATION CSR
                        WHERE 
                            (CSR.COMPANY_ID = C.COMPANY_ID AND
                            CSR.SECTOR_ID = SC.SECTOR_CAT_ID)
                        FOR 
                            XML PATH('')<!--- Satırları tek kolonda getirmek icin eklendi LS --->
                        
                    <!--- </cfif> --->
				)SECTOR_CAT,
            </cfif>                    
                C.NICKNAME,
                C.FULLNAME,
                C.OZEL_KOD,
                C.OZEL_KOD_1,
                C.OZEL_KOD_2,
                C.IMS_CODE_ID,
            <cfif listfind(attributes.list_type,8)>
                (SELECT IMS_CODE FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = C.IMS_CODE_ID) IMS_CODE,
            </cfif>                    			
            <cfif listfind(attributes.list_type,11)>
                (SELECT POSITION_CODE FROM WORKGROUP_EMP_PAR WHERE COMPANY_ID IS NOT NULL AND COMPANY_ID = C.COMPANY_ID AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">) POSITION_CODE,
                (SELECT EP.EMPLOYEE_NAME + ' ' +EP.EMPLOYEE_SURNAME FROM WORKGROUP_EMP_PAR WEP,EMPLOYEE_POSITIONS EP WHERE WEP.COMPANY_ID IS NOT NULL AND WEP.COMPANY_ID = C.COMPANY_ID  AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND EP.POSITION_STATUS = 1 AND EP.POSITION_CODE = WEP.POSITION_CODE ) POSITION_CODE_NAME,
            </cfif>
            <cfif listfind(attributes.list_type,37)>
   				ISNULL((SELECT SP.PAYMETHOD FROM COMPANY_CREDIT CCC,SETUP_PAYMETHOD SP WHERE CCC.COMPANY_ID = C.COMPANY_ID AND CCC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND SP.PAYMETHOD_ID = CCC.PAYMETHOD_ID),'') PAY_METHOD,
   				ISNULL((SELECT SP.PAYMETHOD FROM COMPANY_CREDIT CCC,SETUP_PAYMETHOD SP WHERE CCC.COMPANY_ID = C.COMPANY_ID AND CCC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND SP.PAYMETHOD_ID = CCC.REVMETHOD_ID),'') REV_METHOD,
            </cfif>
                C.COMPANYCAT_ID,
            <cfif listfind(attributes.list_type,2)>
                (SELECT CC.COMPANYCAT FROM COMPANY_CAT CC WHERE CC.COMPANYCAT_ID = C.COMPANYCAT_ID) MEMBER_CAT,
            </cfif>
                C.TAXOFFICE,
                C.TAXNO,
                C.COMPANY_TELCODE,
                C.COMPANY_TEL1,
                C.COMPANY_TEL2,
                C.COMPANY_FAX,
                C.COUNTY,
            <cfif listfind(attributes.list_type,16)>
                (SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = C.COUNTY) COUNTY_NAME,
            </cfif>                    				
                C.CITY,
            <cfif listfind(attributes.list_type,17)>
                (SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = C.CITY) CITY_NAME,
            </cfif>                    
                C.COUNTRY,
            <cfif listfind(attributes.list_type,30)>
                (SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = C.COUNTRY) COUNTRY_NAME,
            </cfif>                    
                C.COUNTY COUNTY2,              			
                C.CITY CITY2,				
            <cfif attributes.search_type eq 0>
                C.MOBILTEL,
                C.MOBIL_CODE,
            </cfif>
                C.MEMBER_CODE,
                C.SALES_COUNTY,
            <cfif listfind(attributes.list_type,9)>
                (SELECT SZ_NAME FROM SALES_ZONES WHERE SZ_ID = C.SALES_COUNTY) SZ_NAME,               
            </cfif>
                C.HIERARCHY_ID,              
                C.COMPANY_ADDRESS,
                C.SEMT,
                C.COMPANY_EMAIL,
                C.START_DATE,
                C.RECORD_PAR,
                C.RECORD_EMP,
        	<!--- kaydeden bilgisi icin case when kullanildi. --->
            <cfif listfind(attributes.list_type,25)>
                CASE WHEN C.RECORD_PAR IS NOT NULL THEN 
                    (SELECT C.NICKNAME+' - '+CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = C.RECORD_PAR)
                WHEN C.RECORD_EMP IS NOT NULL THEN 
                    (SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = C.RECORD_EMP) 
                END AS RECORD_NAME,
            </cfif>                    
                '' REF_POS_CODE,
            <cfif listfind(attributes.list_type,6)>
           		(SELECT TOP 1 ACCOUNT_CODE FROM COMPANY_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND COMPANY_ID = C.COMPANY_ID) ACCOUNT_CODE,
            </cfif>
            <cfif listfind(attributes.list_type,68)>
           		(SELECT TOP 1 SALES_ACCOUNT FROM COMPANY_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND COMPANY_ID = C.COMPANY_ID) SALES_ACCOUNT,
            </cfif>
            <cfif listfind(attributes.list_type,69)>
           		(SELECT TOP 1 PURCHASE_ACCOUNT FROM COMPANY_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND COMPANY_ID = C.COMPANY_ID) PURCHASE_ACCOUNT,
            </cfif>
            <cfif attributes.search_type eq 1>
                CP.COMPANY_ID,
                CP.PARTNER_ID,
                CP.MISSION,
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME,
                CP.COMPANY_PARTNER_EMAIL,
                CP.MOBILTEL,
                CP.MOBIL_CODE,
                CP.BIRTHDATE,
				CP.TITLE,
				CP.START_DATE STARTDATE,
				CP.FINISH_DATE,
				CP.DEPARTMENT,
				CP.PDKS_NUMBER,
				CP.PDKS_TYPE_ID,
				CP.SEX,
            <cfelse>
            	NULL BIRTHDATE,
            </cfif>
			<cfif Len(attributes.is_show_member_team) and attributes.search_type neq 1>
				MEMBER_TEAM_COMPANY.EMP_NAME,
			</cfif>
             	C.RECORD_DATE,
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME,
                CP.TC_IDENTITY TC_IDENTITY,
                CP.COMPANY_PARTNER_EMAIL
            FROM 
                COMPANY C
                ,COMPANY_PARTNER CP
				<cfif Len(attributes.is_show_member_team) and attributes.search_type neq 1>
					LEFT JOIN
					(	SELECT
							WEP.COMPANY_ID,
							EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME EMP_NAME
						FROM
							#DSN_ALIAS#.WORKGROUP_EMP_PAR WEP,
							#DSN_ALIAS#.EMPLOYEE_POSITIONS EP
						WHERE
							WEP.POSITION_CODE = EP.POSITION_CODE AND
							WEP.WORKGROUP_ID IS NULL AND
							<cfif Len(attributes.member_team_roles)>
								WEP.ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_team_roles#"> AND
							</cfif>
							WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						
						UNION ALL
						
						SELECT
							WEP.COMPANY_ID,
							CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME EMP_NAME
						FROM
							#DSN_ALIAS#.WORKGROUP_EMP_PAR WEP,
							#DSN_ALIAS#.COMPANY_PARTNER CP
						WHERE
							WEP.PARTNER_ID = CP.PARTNER_ID AND
							WEP.WORKGROUP_ID IS NULL AND
							<cfif Len(attributes.member_team_roles)>
								WEP.ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_team_roles#"> AND
							</cfif>
							WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					) MEMBER_TEAM_COMPANY ON MEMBER_TEAM_COMPANY.COMPANY_ID = CP.COMPANY_ID
				</cfif>
            WHERE
				<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
					C.USE_EFATURA = 1 AND
                <cfelseif len(attributes.use_efatura) and listfind("0,2,3,4",attributes.use_efatura)>
                	C.USE_EFATURA = 0 AND
                    <cfif attributes.use_efatura eq 2>
                    	C.EARCHIVE_SENDING_TYPE IS NULL AND
                    <cfelseif attributes.use_efatura eq 3>
                    	C.EARCHIVE_SENDING_TYPE = 1 AND
                    <cfelseif attributes.use_efatura eq 4>
                    	C.EARCHIVE_SENDING_TYPE = 0 AND
                    </cfif>
				</cfif>		
                C.COMPANY_ID IS NOT NULL 
           	<cfif attributes.search_type eq 1>
				AND CP.COMPANY_ID = C.COMPANY_ID
            </cfif>
			<cfif isDefined("attributes.related_status") and len(attributes.related_status)>AND C.IS_RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_status#"></cfif>
            <cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
                AND C.COMPANYCAT_ID IN(#attributes.companycat_id#)
            <cfelse>
                AND C.COMPANYCAT_ID IN (#companycat_list#)
            </cfif>
            <cfif len(attributes.company_id) and len(attributes.company)>
                AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            <cfelseif len(attributes.consumer_id) and len(attributes.company)>
                AND 1=0
            </cfif>
            <cfif len(attributes.sector_cat_id)>
	            AND (
                       	C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_SECTOR_RELATION CSR1 WHERE CSR1.SECTOR_ID  = #attributes.sector_cat_id#)
	                )
            </cfif>
            <cfif len(attributes.our_company_id)>
                AND C.COMPANY_ID IN 	(	SELECT
                                                    COMPANY_ID
                                                FROM
                                                    COMPANY_PERIOD CP,
                                                    SETUP_PERIOD SP
                                                WHERE
                                                    CP.PERIOD_ID = SP.PERIOD_ID AND
                                                    SP.OUR_COMPANY_ID IN (#attributes.our_company_id#)
                                            )
            </cfif>
            <cfif isDefined("attributes.search_potential") and len(attributes.search_potential)>
                AND C.ISPOTANTIAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_potential#">
            </cfif>
            <cfif len(attributes.member_status)>
                AND C.COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_status#">
            </cfif>
             
            <cfif isdefined("attributes.customer_value") and len(attributes.customer_value)> 
                AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
            </cfif>
            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                AND
                (
                 <cfif len(attributes.keyword) gt 2>
                    C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">  
					<cfif attributes.search_type eq 1>
						OR CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						CP.PDKS_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
					</cfif>
                 <cfelse>
                    C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
                    C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> 
					<cfif attributes.search_type eq 1>
						OR CP.COMPANY_PARTNER_NAME + ' ' +  CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						CP.PDKS_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">  
					</cfif>
                 </cfif>
                )
            </cfif>
            <cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
                AND C.COMPANY_ID IN (
                                        SELECT 
                                            COMPANY_ID
                                         FROM 
                                            WORKGROUP_EMP_PAR 
                                         WHERE 
                                            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND
                                            IS_MASTER = 1 AND
                                            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                                            COMPANY_ID IS NOT NULL
                                    )
            </cfif>
            <cfif len(attributes.country_id)>
            	AND C.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">
            </cfif>
            <cfif len(attributes.city_id)>
                AND C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
            </cfif>
            <cfif len(attributes.county_id)>
                AND C.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
            </cfif>            
            <cfif len(attributes.company)>
            	AND C.FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.company#">
            </cfif>    
            <cfif len(attributes.record_emp_id) and len(attributes.record_emp)>  
                AND C.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
            </cfif>
            <cfif len(attributes.startdate_1)>
                AND C.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate_1#">
            </cfif>
            <cfif len(attributes.startdate_2)>
                AND C.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate_2#">
            </cfif>
            <cfif len(attributes.recorddate_1)>
                AND C.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.recorddate_1#">
            </cfif>
            <cfif len(attributes.recorddate_2)>
                AND C.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.recorddate_2)#">
            </cfif>	
            <cfif len(attributes.sales_county)>
                AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_county#">
            </cfif>	
            <cfif len(attributes.process_stage_type_com)>
                AND C.COMPANY_STATE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type_com#">
            </cfif>
            <cfif len(attributes.resource_type)>
                AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_type#">
            </cfif>
            <cfif (len(attributes.paymethod_name) or len(attributes.revmethod_name)) and (len(attributes.card_paymethod_id) or len(attributes.paymethod_id) or len(attributes.card_revmethod_id) or len(attributes.revmethod_id))>
                AND C.COMPANY_ID IN (
                                        SELECT 
                                            COMPANY_ID
                                         FROM 
                                            COMPANY_CREDIT 
                                         WHERE 
                                        <cfif len(attributes.paymethod_name)>
                                            <cfif len(attributes.paymethod_id)>
                                                PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#"> AND
                                            </cfif>
                                            <cfif len(attributes.card_paymethod_id)>
                                                CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#"> AND
                                            </cfif>
                                        </cfif>
                                        <cfif len(attributes.revmethod_name)>
                                            <cfif len(attributes.revmethod_id)>
                                                REVMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.revmethod_id#"> AND
                                            </cfif>
                                            <cfif len(attributes.card_revmethod_id)>
                                                CARD_REVMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_revmethod_id#"> AND
                                            </cfif>
                                        </cfif>
                                            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                                            COMPANY_ID IS NOT NULL
                                    )
            </cfif>
            <cfif len(attributes.branch)>
                AND C.COMPANY_ID IN (	SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch#"> AND COMPANY_ID IS NOT NULL	)
            </cfif>
            <!---logo var mi yok mu kontrolu--->
			<cfif Len(attributes.logo_status) and attributes.logo_status eq 1>
            	AND C.ASSET_FILE_NAME1 IS NOT NULL 
            <cfelseif Len(attributes.logo_status) and attributes.logo_status eq 0>
           		AND C.ASSET_FILE_NAME1 IS NULL
            </cfif>
           	<cfif attributes.search_type eq 1>
				<cfif isdefined ('attributes.partner_position') and len(attributes.partner_position)>
                    AND CP.MISSION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_position#">
                </cfif>
				<cfif isdefined('attributes.not_want_sms') and len(attributes.not_want_sms)>
                    AND CP.WANT_SMS <> <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.not_want_sms#">
                </cfif>
            	<cfif isdefined('attributes.not_want_email') and len(attributes.not_want_email)>
                    AND CP.WANT_EMAIL <> <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.not_want_email#">
                </cfif>
                <cfif attributes.search_type eq 1 and Len(attributes.partner_status)>
                    AND CP.COMPANY_PARTNER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_status#">
                </cfif>
           	</cfif>                
			<cfif xml_member_analysis_info eq 1 and isDefined("attributes.analyse_id") and isDefined("attributes.analyse_name") and Len(attributes.analyse_id) and Len(attributes.analyse_name)>
				<!--- Analizler --->
				<cfif isDefined("attributes.analyse_company_id_list") and ListLen(attributes.analyse_company_id_list)>
                    <!--- Popupta secilen sorulari cevaplayan uyeler gelir --->
                    AND C.COMPANY_ID IN (#attributes.analyse_company_id_list#)
                <cfelseif isDefined("attributes.analyse_answer") and Len(attributes.analyse_answer) and attributes.analyse_answer eq 0 and ListLen(Analyse_CompCat_List)>
                    <!--- Popupta hicbir soru secilmemisse, analizde yetkisi olan/analizi goren, ancak henuz hicbir soru cevaplamamis uyeler gelir, bu yuzden kategoriye bakilir --->
                    AND C.COMPANY_ID NOT IN (SELECT COMPANY_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analyse_id#"> AND COMPANY_ID IS NOT NULL)
                    AND C.COMPANYCAT_ID IN (#Analyse_CompCat_List#)
                <cfelseif isDefined("attributes.analyse_answer") and Len(attributes.analyse_answer) and attributes.analyse_answer eq -1>
                    <!--- Popupta soru secmeden direkt ilgili analize cevap girmis uyeler gelir --->
                    AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analyse_id#"> AND COMPANY_ID IS NOT NULL)
                <cfelse>
                    AND C.COMPANY_ID IS NULL
                </cfif>
                <!--- //Analizler --->
            </cfif>
            <cfif len(attributes.ims_code)>AND C.IMS_CODE_ID IN (#attributes.ims_code#)</cfif>
            <cfif listfind(attributes.list_type,5)>AND C.MANAGER_PARTNER_ID = CP.PARTNER_ID</cfif><!---?--->
            AND C.MANAGER_PARTNER_ID = CP.PARTNER_ID
			ORDER BY
				MEMBER_ID
        </cfquery>
		<cfif attributes.search_type eq 1>
            <cfquery name="GET_MEMBER_PARTNER_" dbtype="query">
                SELECT DISTINCT PARTNER_ID FROM GET_MEMBER
            </cfquery>
        </cfif>        
	<cfelse>
		<cfquery name="GET_MEMBER" datasource="#DSN#">
			SELECT 
				CONSUMER.CONSUMER_ID MEMBER_ID,
				SECTOR_CAT_ID,
			<cfif listfind(attributes.list_type,26)>
            	(SELECT SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = CONSUMER.SECTOR_CAT_ID) SECTOR_CAT,
            </cfif>
				CONSUMER_NAME,
				CONSUMER_SURNAME,
				TC_IDENTY_NO,
				OZEL_KOD,
				IMS_CODE_ID,
			<cfif listfind(attributes.list_type,8)>
            	(SELECT IMS_CODE FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = CONSUMER.IMS_CODE_ID) IMS_CODE,
            </cfif>
            <cfif listfind(attributes.list_type,11)>
				(SELECT TOP 1 POSITION_CODE FROM WORKGROUP_EMP_PAR WHERE CONSUMER_ID IS NOT NULL AND CONSUMER_ID = CONSUMER.CONSUMER_ID AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">) POSITION_CODE,
            	(SELECT TOP 1 EP.EMPLOYEE_NAME + ' ' +EP.EMPLOYEE_SURNAME FROM WORKGROUP_EMP_PAR WEP,EMPLOYEE_POSITIONS EP WHERE WEP.CONSUMER_ID IS NOT NULL AND WEP.CONSUMER_ID = CONSUMER.CONSUMER_ID AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND EP.POSITION_STATUS = 1 AND EP.POSITION_CODE = WEP.POSITION_CODE ) POSITION_CODE_NAME,
            </cfif>
            <cfif listfind(attributes.list_type,37)>
				ISNULL((SELECT SP.PAYMETHOD FROM COMPANY_CREDIT CCC,SETUP_PAYMETHOD SP WHERE CCC.CONSUMER_ID = CONSUMER.CONSUMER_ID AND CCC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND SP.PAYMETHOD_ID = CCC.PAYMETHOD_ID),'') PAY_METHOD,
				ISNULL((SELECT SP.PAYMETHOD FROM COMPANY_CREDIT CCC,SETUP_PAYMETHOD SP WHERE CCC.CONSUMER_ID = CONSUMER.CONSUMER_ID AND CCC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND SP.PAYMETHOD_ID = CCC.REVMETHOD_ID),'') REV_METHOD,
            </cfif>
				CONSUMER_CAT_ID,
			<cfif listfind(attributes.list_type,2)>
                (SELECT CONSCAT FROM CONSUMER_CAT WHERE CONSCAT_ID = CONSUMER.CONSUMER_CAT_ID) MEMBER_CAT,
            </cfif>
             <cfif listfind(attributes.list_type,59)>
                (SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = CONSUMER.TAX_CITY_ID) TAX_COUNTRY_NAME, 
            </cfif> 
            <cfif listfind(attributes.list_type,60)>
               (SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = CONSUMER.TAX_COUNTY_ID)  TAX_COUNTY_NAME, 
            </cfif> 
				TAX_OFFICE TAXOFFICE,
				TAX_NO TAXNO,
				CONSUMER_HOMETELCODE, 
				CONSUMER_HOMETEL,
				CONSUMER_WORKTELCODE,
				CONSUMER_WORKTEL,
				MOBIL_CODE,
				MOBILTEL,
				MOBIL_CODE_2,
				MOBILTEL_2,
				HOME_COUNTY_ID COUNTY,
           	<cfif listfind(attributes.list_type,16)>
                (SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = HOME_COUNTY_ID) COUNTY_NAME,
            </cfif>
                HOME_CITY_ID CITY,
            <cfif listfind(attributes.list_type,17)>
                (SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = CONSUMER.HOME_CITY_ID) CITY_NAME,
            </cfif>
				HOME_COUNTRY_ID COUNTRY,
			<cfif listfind(attributes.list_type,30)>
				(SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = CONSUMER.HOME_COUNTRY_ID) COUNTRY_NAME,
            </cfif>
				WORK_COUNTY_ID COUNTY2,
            <cfif listfind(attributes.list_type,34)>
				(SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = WORK_COUNTY_ID) COUNTY_NAME2,               
            </cfif>
				WORK_CITY_ID CITY2,
           	<cfif listfind(attributes.list_type,35)>
                (SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = CONSUMER.WORK_CITY_ID) CITY_NAME2,
            </cfif>		
       	
				MEMBER_CODE,
				SALES_COUNTY,
            <cfif listfind(attributes.list_type,9)>
            	(SELECT SZ_NAME FROM SALES_ZONES WHERE SZ_ID = CONSUMER.SALES_COUNTY) SZ_NAME,               
           	</cfif>
            <cfif listfind(attributes.list_type,14)>
				CASE WHEN TAX_MAIN_STREET IS NOT NULL AND TAX_STREET IS NOT NULL THEN TAX_MAIN_STREET + ' CD.' + ' ' + TAX_STREET + ' SK.' + ' ' + ISNULL(TAX_DOOR_NO,'') ELSE TAX_ADRESS END AS COMPANY_ADDRESS,
            </cfif>
            <cfif listfind(attributes.list_type,44)>
				CASE WHEN HOME_MAIN_STREET IS NOT NULL AND HOME_STREET IS NOT NULL THEN HOME_MAIN_STREET + ' CD.' + ' ' + HOME_STREET + ' SK.' + ' ' + ISNULL(HOME_DOOR_NO,'') ELSE HOMEADDRESS END AS HOMEADDRESS,
           	</cfif>
				HOMESEMT HOMESEMT,
				TAX_SEMT SEMT,
				CONSUMER_EMAIL,
				START_DATE,
			<!--- kaydeden bilgisi icin case when kullanildi. --->
            <cfif listfind(attributes.list_type,25)>
                CASE WHEN CONSUMER.RECORD_CONS IS NOT NULL THEN 
                    (SELECT C3.CONSUMER_NAME + ' ' +C3.CONSUMER_SURNAME FROM CONSUMER C3 WHERE C3.CONSUMER_ID = CONSUMER.RECORD_CONS )
                WHEN CONSUMER.RECORD_PAR IS NOT NULL THEN 
                    (SELECT C.NICKNAME+' - '+CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP,COMPANY C WHERE C.COMPANY_ID = CP.COMPANY_ID AND CP.PARTNER_ID = CONSUMER.RECORD_PAR)
                WHEN CONSUMER.RECORD_MEMBER IS NOT NULL THEN 
                    (SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CONSUMER.RECORD_MEMBER) 
                END AS RECORD_NAME,
            </cfif>
				REF_POS_CODE,
			<cfif listfind(attributes.list_type,29)>
                (SELECT C2.CONSUMER_NAME + ' ' + C2.CONSUMER_SURNAME FROM CONSUMER C2 WHERE C2.CONSUMER_ID = CONSUMER.REF_POS_CODE ) REF_POS_NAME,
            </cfif>
            PROPOSER_CONS_ID,
            <cfif listfind(attributes.list_type,36)>
                (SELECT C4.CONSUMER_NAME + ' ' +C4.CONSUMER_SURNAME FROM CONSUMER C4 WHERE C4.CONSUMER_ID = CONSUMER.PROPOSER_CONS_ID ) PROPOSER_CONS_NAME,
            </cfif>
            <cfif listfind(attributes.list_type,6)>
                (SELECT TOP 1 ACCOUNT_CODE FROM CONSUMER_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND CONSUMER_ID = CONSUMER.CONSUMER_ID) ACCOUNT_CODE,
            </cfif>
            <cfif listfind(attributes.list_type,68)>
                (SELECT TOP 1 SALES_ACCOUNT FROM CONSUMER_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND CONSUMER_ID = CONSUMER.CONSUMER_ID) SALES_ACCOUNT,
            </cfif>
            <cfif listfind(attributes.list_type,69)>
                (SELECT TOP 1 PURCHASE_ACCOUNT FROM CONSUMER_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND CONSUMER_ID = CONSUMER.CONSUMER_ID) PURCHASE_ACCOUNT,
            </cfif>
                BIRTHDATE,
			<cfif Len(attributes.is_show_member_team)>
				MEMBER_TEAM_CONSUMER.EMP_NAME,
			</cfif>
				RECORD_DATE
			FROM 
				CONSUMER
				LEFT JOIN
				(	SELECT
						WEP.CONSUMER_ID,
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME EMP_NAME
					FROM
						#DSN_ALIAS#.WORKGROUP_EMP_PAR WEP,
						#DSN_ALIAS#.EMPLOYEE_POSITIONS EP
					WHERE
						WEP.POSITION_CODE = EP.POSITION_CODE AND
						WEP.WORKGROUP_ID IS NULL AND
						<cfif Len(attributes.member_team_roles)>
							WEP.ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_team_roles#"> AND
						</cfif>
						WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				) MEMBER_TEAM_CONSUMER ON MEMBER_TEAM_CONSUMER.CONSUMER_ID = CONSUMER.CONSUMER_ID
			WHERE
				<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
					CONSUMER.USE_EFATURA = 1 AND
                <cfelseif len(attributes.use_efatura) and listfind("0,2,3,4",attributes.use_efatura)>
                	CONSUMER.USE_EFATURA = 0 AND
                    <cfif attributes.use_efatura eq 2>
                    	CONSUMER.EARCHIVE_SENDING_TYPE IS NULL AND
                    <cfelseif attributes.use_efatura eq 3>
                    	CONSUMER.EARCHIVE_SENDING_TYPE = 1 AND
                    <cfelseif attributes.use_efatura eq 4>
                    	CONSUMER.EARCHIVE_SENDING_TYPE = 0 AND
                    </cfif>
				</cfif>	
				CONSUMER.CONSUMER_ID IS NOT NULL
				<cfif isDefined("attributes.related_status") and len(attributes.related_status)>AND IS_RELATED_CONSUMER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_status#"></cfif>
				<cfif isdefined ('attributes.consumercat_id') and len(attributes.consumercat_id)>
					AND CONSUMER_CAT_ID IN (#attributes.consumercat_id#)
				<cfelse>
					AND CONSUMER_CAT_ID IN (#conscat_list#)
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
               	<cfelseif len(attributes.company_id) and len(attributes.company)>
                	AND 1=0
                </cfif>
				<cfif isdefined("attributes.sector_cat_id") and  len(attributes.sector_cat_id)>
					AND SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">
				</cfif>
				<cfif isdefined ('attributes.partner_position') and len(attributes.partner_position)>
					AND MISSION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_position#">
				</cfif>
				<cfif len(attributes.our_company_id)>
					AND CONSUMER.CONSUMER_ID IN 	(	SELECT
														CONSUMER_ID
													FROM
														CONSUMER_PERIOD CP,
														SETUP_PERIOD SP
													WHERE
														CP.PERIOD_ID = SP.PERIOD_ID AND
														SP.OUR_COMPANY_ID IN (#attributes.our_company_id#)
												)
				</cfif>
				<cfif isDefined("attributes.search_potential") and len(attributes.search_potential)>
					AND ISPOTANTIAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_potential#">
				</cfif>
				<cfif len(attributes.member_status)>  
					AND CONSUMER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_status#">
				</cfif> 
				<cfif isdefined('attributes.not_want_sms') and len(attributes.not_want_sms)>  
					AND WANT_SMS <> <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.not_want_sms#">
				</cfif>
				<cfif isdefined('attributes.not_want_email') and len(attributes.not_want_email)>  
					AND WANT_EMAIL <> <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.not_want_email#">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)> 
					AND CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
					AND
					(
					 <cfif len(attributes.keyword) gt 2>
						CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					 <cfelse>
						CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
						CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
					 </cfif>
					)
				</cfif>
				<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND CONSUMER.CONSUMER_ID IN (
												SELECT 
													CONSUMER_ID
												 FROM 
													WORKGROUP_EMP_PAR 
												 WHERE 
													POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND
													IS_MASTER = 1 AND
													OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
													WORKGROUP_EMP_PAR.CONSUMER_ID IS NOT NULL
												)
				</cfif>
                <cfif len(attributes.country_id)>
					AND (HOME_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#"> 
                    	OR WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">
                        OR TAX_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">)
                </cfif>
				<cfif len(attributes.city_id)>
					AND (HOME_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"> OR WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">)
				</cfif>
                <cfif len(attributes.county_id)>
					AND (HOME_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#"> OR WORK_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">)
				</cfif>
				<cfif len(attributes.record_emp_id) and len(attributes.record_emp)>  
					AND RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
				</cfif>
				<cfif len(attributes.startdate_1)>
					AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate_1#">
				</cfif>
				<cfif len(attributes.startdate_2)>
					AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate_2#">
				</cfif>
				<cfif len(attributes.recorddate_1)>
					AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.recorddate_1#">
				</cfif>
				<cfif len(attributes.recorddate_2)>
					AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.recorddate_2)#">
				</cfif>	
				<cfif len(attributes.sales_county)>
					AND SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_county#">
				</cfif>	
				<cfif len(attributes.process_stage_type_con)>
					AND CONSUMER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type_con#">
				</cfif>		
				<cfif len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name)> 
					AND REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ref_pos_code#">
				</cfif>
				<cfif len(attributes.resource_type)>
					AND RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_type#">
				</cfif>
				<cfif (len(attributes.paymethod_name) or len(attributes.revmethod_name)) and (len(attributes.card_paymethod_id) or len(attributes.paymethod_id) or len(attributes.card_revmethod_id) or len(attributes.revmethod_id))>
					AND CONSUMER.CONSUMER_ID IN (
												SELECT 
													CONSUMER_ID
												 FROM 
													COMPANY_CREDIT 
												 WHERE 
												<cfif len(attributes.paymethod_name)>
													<cfif len(attributes.paymethod_id)>
														PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#"> AND
													</cfif>
													<cfif len(attributes.card_paymethod_id)>
														CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#"> AND
													</cfif>
												</cfif>
												<cfif len(attributes.revmethod_name)>
													<cfif len(attributes.revmethod_id)>
														REVMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.revmethod_id#"> AND
													</cfif>
													<cfif len(attributes.card_revmethod_id)>
														CARD_REVMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_revmethod_id#"> AND
													</cfif>
												</cfif>
													OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
													CONSUMER_ID IS NOT NULL
												)
				</cfif>
				<cfif len(attributes.branch)>
					AND CONSUMER_ID IN ( SELECT CONSUMER_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch#"> AND CONSUMER_ID IS NOT NULL )
				</cfif>
				<cfif xml_member_analysis_info eq 1 and isDefined("attributes.analyse_id") and isDefined("attributes.analyse_name") and Len(attributes.analyse_id) and Len(attributes.analyse_name)>
					<!--- Analizler --->
					<cfif isDefined("attributes.analyse_consumer_id_list") and ListLen(attributes.analyse_consumer_id_list)>
						<!--- Popupta secilen sorulari cevaplayan uyeler gelir --->
						AND CONSUMER_ID IN (#attributes.analyse_consumer_id_list#)
					<cfelseif isDefined("attributes.analyse_answer") and Len(attributes.analyse_answer) and attributes.analyse_answer eq 0 and ListLen(Analyse_ConsCat_List)>
						<!--- Popupta hicbir soru secilmemisse, analizde yetkisi olan/analizi goren, ancak henuz hicbir soru cevaplamamis uyeler gelir, bu yuzden kategoriye bakilir --->
						AND CONSUMER_ID NOT IN (SELECT CONSUMER_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analyse_id#"> AND CONSUMER_ID IS NOT NULL)
						AND CONSUMER_CAT_ID IN (#Analyse_ConsCat_List#)
					<cfelseif isDefined("attributes.analyse_answer") and Len(attributes.analyse_answer) and attributes.analyse_answer eq -1>
						<!--- Popupta soru secmeden direkt ilgili analize cevap girmis uyeler gelir --->
						AND CONSUMER.CONSUMER_ID IN (SELECT CONSUMER_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analyse_id#"> AND CONSUMER_ID IS NOT NULL)
					<cfelse>
						AND CONSUMER.CONSUMER_ID IS NULL
					</cfif>
				</cfif>
				<cfif Len(attributes.ims_code)> AND CONSUMER.IMS_CODE_ID IN (#attributes.ims_code#)</cfif>
				ORDER BY
					CONSUMER_NAME,
                    CONSUMER_SURNAME
		</cfquery>
	</cfif>
	<cfquery name="GET_MEMBER_" dbtype="query">
        SELECT DISTINCT MEMBER_ID FROM GET_MEMBER
    </cfquery>
<cfelse>
	<cfset get_member.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_member.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!---
<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module="member_report_bask_" is_ajax="1">
--->
<cfform name="list_member" method="post" action="#request.self#?fuseaction=report.detayli_uye_analizi_raporu">
<cfsavecontent variable='title'><cf_get_lang dictionary_id='39540.Detaylı Üye Analizi Raporu'></cfsavecontent>
<cf_report_list_search id="member_report_" title="#title#">
<cf_report_list_search_area>
    <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1" >
    <div class="row">
        <div class="col col-12 col-xs-12">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-6 col-xs-12">
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                            <div id="company_cat_2" <cfif isdefined("attributes.search_type") and attributes.search_type eq 2> style="display:none"</cfif>>
                                <div class="col col-9 col-xs-12">
                                    <select name="process_stage_type_com" id="process_stage_type_com">
                                        <option value="" selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfoutput query="get_company_stage">
                                            <option value="#process_row_id#" <cfif isDefined('attributes.process_stage_type_com') and attributes.process_stage_type_com eq process_row_id> selected</cfif>>#stage#</option>
                                        </cfoutput> 
                                    </select>
                                </div>
                            </div>
                            <div id="consumer_cat_2" <cfif not(isdefined("attributes.search_type") and attributes.search_type eq 2)>style="display:none"</cfif>>
                                <div class="col col-9 col-xs-12">
                                <select name="process_stage_type_con" id="process_stage_type_con">
                                    <option value="" selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_consumer_stage">
                                        <option value="#process_row_id#" <cfif isDefined('attributes.process_stage_type_con') and attributes.process_stage_type_con eq process_row_id> selected</cfif>>#stage#</option>
                                    </cfoutput>
                                </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="39530.Üye Tipi"></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="search_potential" id="search_potential">
                                        <option value="" <cfif isdefined("attributes.search_potential")> selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1"<cfif isdefined("attributes.search_potential") and attributes.search_potential is 1> selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>
                                        <option value="0"<cfif isdefined("attributes.search_potential") and attributes.search_potential is 0> selected</cfif>><cf_get_lang dictionary_id='58061.Cari'></option>
                                    </select>
                                </div>				
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="customer_value" id="customer_value">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfoutput query="get_customer_value">
                                        <option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value> selected</cfif>>#customer_value#</option>
                                        </cfoutput>
                                    </select>					
                                </div>	
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="39931.Görev"> / <cf_get_lang dictionary_id="58497.Pozisyon"></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="partner_position" id="partner_position">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfoutput query="get_partner_positions">
                                            <option value="#partner_position_id#" <cfif attributes.partner_position eq partner_position_id> selected</cfif>>#partner_position#</option>
                                        </cfoutput>
                                    </select>						
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="sector_cat_id" id="sector_cat_id">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfoutput query="get_company_sector">
                                            <option value="#sector_cat_id#" <cfif attributes.sector_cat_id eq sector_cat_id> selected</cfif>>#sector_cat#</option>
                                        </cfoutput>
                                    </select>						
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="sales_county" id="sales_county" style="width:130px;">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfoutput query="get_sz">
                                            <option value="#sz_id#" <cfif sz_id eq attributes.sales_county> selected</cfif>>#sz_name#</option>
                                        </cfoutput>
                                    </select>						
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39150.Bağlı Üye'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="related_status" id="related_status">			
                                        <option value="" <cfif isDefined('attributes.related_status') and not len(attributes.related_status)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                        <option value="1" <cfif isDefined('attributes.related_status') and attributes.related_status is 1> selected</cfif>><cf_get_lang dictionary_id='38846.Bağlı Üyeler'></option>
                                        <option value="0" <cfif isDefined('attributes.related_status') and attributes.related_status is 0> selected</cfif>><cf_get_lang dictionary_id='38847.Bağlı Olmayan Üyeler'></option>
                                    </select>						
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57895.Şube İlişkisi'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="branch" id="branch">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfoutput query="get_branch">
                                            <option value="#branch_id#" <cfif attributes.branch eq branch_id> selected</cfif>>#branch_name#</option>
                                        </cfoutput>
                                    </select>						
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'></label>
                                <div class="col col-9 col-xs-12">
                                    <cf_wrk_combo
                                        name="resource_type"
                                        query_name="GET_PARTNER_RESOURCE"
                                        option_name="resource"
                                        option_value="resource_id"
                                        value="#attributes.resource_type#"
                                        width="130">					
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'><cf_get_lang dictionary_id='57756.Durum'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="member_status" id="member_status"> 
                                        <option value="" <cfif isDefined('attributes.member_status')> selected="selected"</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                        <option value="1" <cfif isDefined('attributes.member_status') and attributes.member_status is 1> selected="selected"</cfif>><cf_get_lang dictionary_id="57493.Aktif"><cf_get_lang dictionary_id='57658.Üye'></option>
                                        <option value="0" <cfif isDefined('attributes.member_status') and attributes.member_status is 0> selected="selected"</cfif>><cf_get_lang dictionary_id="57494.Pasif"><cf_get_lang dictionary_id='57658.Üye'></option>	  
                                    </select>						
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12" id="partner_status3_" <cfif isdefined("attributes.search_type") and attributes.search_type eq 2> style="display:none;"</cfif>><cf_get_lang dictionary_id='57576.Çalışan'><cf_get_lang dictionary_id='57756.Durum'></label>
                                <div class="col col-9 col-xs-12" id="partner_status_" <cfif isdefined("attributes.search_type") and attributes.search_type eq 2> style="display:none;"</cfif>>
                                    <select name="partner_status" id="partner_status"> 
                                        <option value="" <cfif isDefined('attributes.partner_status')> selected="selected"</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                        <option value="1" <cfif isDefined('attributes.partner_status') and attributes.partner_status is 1> selected="selected"</cfif>><cf_get_lang dictionary_id="57493.Aktif"><cf_get_lang dictionary_id='57576.Çalışan'></option>
                                        <option value="0" <cfif isDefined('attributes.partner_status') and attributes.partner_status is 0> selected="selected"</cfif>><cf_get_lang dictionary_id="57494.Pasif"><cf_get_lang dictionary_id='57576.Çalışan'></option>	  
                                    </select>						
                                </div>
                                <!---
                                <cfif xml_member_add_info eq 1>
                                    <div class="col col-1">&nbsp;</div>
                                <cfelse>
                                    <div class="col col-2">&nbsp;</div>
                                </cfif>		
                                ---->
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58637.Logo'><cf_get_lang dictionary_id='57756.Durum'></label>
                                <div class="col col-9 col-xs-12"><select name="logo_status" id="logo_status"> 
                                        <option value=""  <cfif isDefined('attributes.logo_status')> selected="selected"</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                        <option value="1" <cfif isDefined('attributes.logo_status') and attributes.logo_status is 1> selected="selected"</cfif>><cf_get_lang dictionary_id="58637.Logo"><cf_get_lang dictionary_id='58564.Var'></option>
                                        <option value="0" <cfif isDefined('attributes.logo_status') and attributes.logo_status is 0> selected="selected"</cfif>><cf_get_lang dictionary_id="58637.Logo"><cf_get_lang dictionary_id='58546.Yok'></option>	  
                                    </select>						
                                </div>
                                <!----
                                <cfif xml_member_add_info eq 1>
                                    <div class="col col-1">&nbsp;</div>
                                <cfelse>
                                    <div class="col col-2">&nbsp;</div>
                                </cfif>
                                ---->
                        </div>

                    </div>
            
                    <div class="col col-3 col-md-6 col-xs-12">
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label> 
                                <div class="col col-9 col-xs-12">
                                    <select name="search_type" id="search_type" style="width:172px;" onchange="ajaxChangeCompany();"><!--- eski: change_company --->
                                        <option value="0" <cfif isDefined('attributes.search_type') and attributes.search_type is 0> selected</cfif>><cf_get_lang dictionary_id='57585.Kurumsal Üye'></option>
                                        <option value="2" <cfif isDefined('attributes.search_type') and attributes.search_type is 2> selected</cfif>><cf_get_lang dictionary_id='57586.Bireysel Üye'></option>	
                                        <option value="1" <cfif isDefined('attributes.search_type') and attributes.search_type is 1> selected</cfif>><cf_get_lang dictionary_id='56690.Kişiler'></option>
                                    </select>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label> 
                                <div class="col col-9 col-xs-12">
                                    <cfset getCountry = cmp.getCountry() />
                                    <select name="country_id" id="country_id" onchange="change_city();">
                                        <option value="">Ülke</option>
                                        <cfoutput query="getCountry">
                                            <option value="#country_id#" <cfif attributes.country_id eq country_id>selected</cfif>>#country_name#</option>
                                           <!---<option value="#country_id#" <cfif is_default eq 1> selected</cfif>>#country_name#</option>--->
                                        </cfoutput>
                                    </select>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="city_id" id="city_id" onchange="change_county();">
                                        <option value="">Şehir</option>
                                            <cfif isdefined("GetCity")>
                                            <cfoutput query="GetCity">
                                                <option value="#city_id#" <cfif attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
                                            </cfoutput>
                                            </cfif>
                                    </select> 
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="county_id" id="county_id">
                                        <option value=""><cf_get_lang dictionary_id='58638.İlçe'></option>
                                        <cfif len(attributes.county_id) and isdefined("GetCounty")>
                                            <cfoutput query="GetCounty">
                                                <option value="#county_id#"<cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
                                            </cfoutput>
                                        </cfif>
                                    </select>
                                </div>
                        </div>
                        <cfif session.ep.our_company_info.is_efatura>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29872.E-Fatura'><cfif session.ep.our_company_info.is_earchive>/<cf_get_lang dictionary_id='59328.E-Arşiv'></cfif></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="use_efatura" id="use_efatura" style="width:170px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> 
                                        <option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='60675.E-Fatura Kullananlar'></option>
                                        <cfif session.ep.our_company_info.is_earchive eq 0>
                                        <option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='60674.E-Fatura Kullanmayanlar'></option></cfif>
                                        <cfif session.ep.our_company_info.is_earchive>
                                        <option value="4"<cfif attributes.use_efatura eq 4>selected="selected"</cfif>><cf_get_lang dictionary_id='29872.E-Fatura'>(<cf_get_lang dictionary_id='41981.KAĞIT'>)</option>
                                        <option value="3"<cfif attributes.use_efatura eq 3>selected="selected"</cfif>><cf_get_lang dictionary_id='29872.E-Fatura'>(<cf_get_lang dictionary_id='59873.ELEKTRONİK'>)</option>
                                        <option value="2"<cfif attributes.use_efatura eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id='29872.E-Fatura'>(<cf_get_lang dictionary_id='55552.BOŞ'>)</option></cfif>
                                    </select>
                                </div>
                        </div>
                        </cfif>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='38844.Alış Ödeme Yöntemi'></label> 
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif len(attributes.paymethod_id)><cfoutput>#attributes.paymethod_id#</cfoutput></cfif>">
                                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif len(attributes.card_paymethod_id)><cfoutput>#attributes.card_paymethod_id#</cfoutput></cfif>">
                                        <input type="text" name="paymethod_name" id="paymethod_name" value="<cfif len(attributes.paymethod_name)><cfoutput>#attributes.paymethod_name#</cfoutput></cfif>">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=list_member.paymethod_id&field_name=list_member.paymethod_name&field_card_payment_id=list_member.card_paymethod_id&field_card_payment_name=list_member.paymethod_name</cfoutput>');"></span>
                                    </div>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='38845.Satış Ödeme Yöntemi'></label> 
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="revmethod_id" id="revmethod_id" value="<cfif len(attributes.revmethod_id)><cfoutput>#attributes.revmethod_id#</cfoutput></cfif>">
                                        <input type="hidden" name="card_revmethod_id" id="card_revmethod_id" value="<cfif len(attributes.card_revmethod_id)><cfoutput>#attributes.card_revmethod_id#</cfoutput></cfif>">
                                        <input type="text" name="revmethod_name" id="revmethod_name" value="<cfif len(attributes.revmethod_name)><cfoutput>#attributes.revmethod_name#</cfoutput></cfif>">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=list_member.revmethod_id&field_name=list_member.revmethod_name&field_card_payment_id=list_member.card_revmethod_id&field_card_payment_name=list_member.revmethod_name</cfoutput>');"></span>
                                    </div>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57908.Temsilci"></label> 
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                                        <input name="pos_code_text" type="text" id="pos_code_text" onfocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','135')" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_member.pos_code&field_name=list_member.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9');return false"></span>
                                    </div>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58636.Referans Üye'></label>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="ref_pos_code" id="ref_pos_code" value="<cfif len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name)><cfoutput>#attributes.ref_pos_code#</cfoutput></cfif>">
                                        <input name="ref_pos_code_name" type="text" id="ref_pos_code_name" onfocus="AutoComplete_Create('ref_pos_code_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','2,0,0,0','CONSUMER_ID','ref_pos_code','list_member','3','250');" value="<cfif len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name)><cfoutput>#get_cons_info(attributes.ref_pos_code,0,0)#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=list_member.ref_pos_code&field_name=list_member.ref_pos_code_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>)"></span>
                                    </div>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
                                        <input type="hidden" name="company_id" id="company_id"<cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                        <input type="text" name="company" id="company" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
                                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=list_member.company&field_comp_id=list_member.company_id&field_consumer=list_member.consumer_id&field_member_name=list_member.company</cfoutput>&keyword='+encodeURIComponent(document.list_member.company.value))"></span>
                                    </div>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57899.Kaydeden"></label>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id) and len(attributes.record_emp)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                                        <input type="text" name="record_emp" id="record_emp" value="<cfif len(attributes.record_emp_id) and len(attributes.record_emp)><cfoutput>#attributes.record_emp#</cfoutput></cfif>" onFocus="AutoComplete_Create('record_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','list_help','3','135');">
                                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_member.record_emp_id&field_name=list_member.record_emp&is_form_submitted=1&select_list=1');"></span>
                                    </div>
                                </div>
                        </div>     
                    </div>

                    <div class="col col-3 col-md-6 col-xs-12">
                        <cfif xml_member_analysis_info eq 1>
                            <div class="form-group">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58799.Analizler'></label>
                                    <div class="col col-9 col-xs-12">
                                        <div class="input-group">
                                            <cfoutput>
                                                <input type="hidden" name="analyse_answer" id="analyse_answer" value="<cfif isDefined("attributes.analyse_answer")>#attributes.analyse_answer#</cfif>">
                                                <input type="hidden" name="analyse_company_id_list" id="analyse_company_id_list" value="<cfif isDefined("attributes.analyse_company_id_list")>#attributes.analyse_company_id_list#</cfif>">
                                                <input type="hidden" name="analyse_consumer_id_list" id="analyse_consumer_id_list" value="<cfif isDefined("attributes.analyse_consumer_id_list")>#attributes.analyse_consumer_id_list#</cfif>">
                                                <input type="hidden" name="analyse_id" id="analyse_id" value="<cfif isDefined("attributes.analyse_id")>#attributes.analyse_id#</cfif>">
                                                <input type="text" name="analyse_name" id="analyse_name" value="<cfif isDefined("attributes.analyse_name")>#attributes.analyse_name#</cfif>">
                                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('#request.self#?fuseaction=report.popup_list_member_analysis');"></span>
                                            </cfoutput>		
                                        </div>					
                                    </div>
                                </div>
                        </cfif>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57486.Kategori"></label>
                                <div class="col col-9 col-xs-12" id="company_cat" <cfif isdefined("attributes.search_type") and attributes.search_type eq 2> style="display:none"</cfif>>
                                    <select name="companycat_id" id="companycat_id" multiple>
                                        <cfoutput query="company_cat">					    
                                            <option value="#companycat_id#" <cfif listfind(attributes.companycat_id,companycat_id)> selected</cfif>>#companycat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                                <div class="col col-9 col-xs-12" id="consumer_cat" <cfif not(isdefined("attributes.search_type") and attributes.search_type eq 2)>style="display:none"</cfif>>
                                    <select name="consumercat_id" id="consumercat_id" multiple>
                                        <cfoutput query="consumer_cat">					    
                                            <option value="#conscat_id#" <cfif listfind(attributes.consumercat_id,conscat_id)> selected</cfif>>#conscat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39815.Liste Kategorisi'>*</label>
                                <div class="col col-9 col-xs-12">
                                    <select name="list_type" id="list_type"multiple="multiple">
                                        <!--- Sayfa yuklendiginde, jquery ile ici dolduruluyor, bkz include : list_category.cfm --->
                                        </select>
                                        <cfinclude template="../../report/display/list_category.cfm">
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57574.Şirket'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="our_company_id" id="our_company_id" multiple>
                                        <cfoutput query="get_our_company">					    
                                            <option value="#comp_id#" <cfif listfind(attributes.our_company_id,comp_id)> selected</cfif>>#company_name#</option>
                                        </cfoutput>
                                    </select>	
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58134.Micro Bölge Kodu'></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="ims_code" id="ims_code" style="width:170px;height:75px;" multiple>
                                        <cfif len(attributes.ims_code)>
                                            <cfquery name="Get_Ims_Info" datasource="#dsn#">
                                                SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID IN (#attributes.ims_code#)
                                            </cfquery>
                                            <cfoutput query="Get_Ims_Info">
                                                <option value="#ims_code_id#">#ims_code# #ims_code_name#</option>
                                            </cfoutput>
                                        </cfif>
                                        </select>	
                                        <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_codes&field_name=list_member.ims_code');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
                                        <a href="javascript://" onclick="remove_field('ims_code');"><img src="/images/delete_list.gif" border="0" title="Sil" style="cursor=hand" align="top"></a>
                                </div>
                        </div>


                    </div>

                    <div class="col col-3 col-md-6 col-xs-12">
                        <cfif xml_member_add_info eq 1>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                                <div class="col col-9 col-xs-12">
                                    <cfoutput>
                                        <select name="add_info" id="add_info" style="width:120px;height:75px;" multiple>
                                            <cfloop from="1" to="20" index="kk">
                                                <option value="#kk#" <cfif listfind(attributes.add_info,kk)>selected</cfif>><cf_get_lang dictionary_id='57810.Ek Bilgi'> #kk#</option>
                                            </cfloop>
                                        </select>
                                    </cfoutput>	
                                </div>
                        </div>
                        </cfif>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57627.Kayıt Tarihi'></cfsavecontent>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                    <cfinput validate="#validate_style#" message="#message#" type="text" name="recorddate_1" value="#dateformat(attributes.recorddate_1,dateformat_style)#">  
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="recorddate_1"></span>            
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput validate="#validate_style#" message="#message#" type="text" name="recorddate_2" value="#dateformat(attributes.recorddate_2,dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="recorddate_2"></span>  
                                    </div>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58425.Üyelik B Tarihi'></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58425.Üyelik B Tarihi'></cfsavecontent>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <cfinput validate="#validate_style#" message="#message#" type="text" name="startdate_1" value="#dateformat(attributes.startdate_1,dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate_1"></span>            
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput validate="#validate_style#" message="#message#" type="text" name="startdate_2" value="#dateformat(attributes.startdate_2,dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate_2"></span>  
                                    </div>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57460.Filtre"></label>
                                <div class="col col-9 col-xs-12">
                                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255">
                                </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12 col-xs-12">
                                <label> <cf_get_lang dictionary_id='40752.Mail Almak İstemeyenleri Getirme'><input type="checkbox" name="not_want_email" id="not_want_email" value="0" <cfif isdefined('attributes.not_want_email') and attributes.not_want_email eq 0>checked</cfif>></label>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12 col-xs-12">
                                <label> <cf_get_lang dictionary_id='40751.SMS Almak İstemeyenleri Getirme'><input type="checkbox" name="not_want_sms" id="not_want_sms" value="0" <cfif isdefined('attributes.not_want_sms') and attributes.not_want_sms eq 0>checked="checked"</cfif>></label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="col col-12 col-xs-12">
                                <label> <cf_get_lang dictionary_id="59150.Üye Ekibi Gelsin">
                                 <input type="checkbox" name="is_show_member_team" id="is_show_member_team" value="1" onclick="gizle_goster(roles_info);" <cfif isDefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>checked<cfelseif attributes.search_type eq 1>disabled</cfif>></label>
                                <div id="roles_info" <cfif isDefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>style="display:'';"<cfelse>style="display:none;"</cfif>>
                                    <select name="member_team_roles" id="member_team_roles" style="width:150px;">
                                        <option value=""><cf_get_lang dictionary_id='55478.Rol'></option>
                                        <cfoutput query="get_roles">
                                            <option value="#project_roles_id#" <cfif Len(attributes.member_team_roles) and attributes.member_team_roles eq project_roles_id>selected</cfif>>#project_roles#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row ReportContentBorder">
                <div class="ReportContentFooter">
                    <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked="checked"</cfif>></label>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
                        <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                        <cfelse>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                        </cfif>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                        <cf_wrk_report_search_button search_function='control1()' insert_info='#message#' button_type='1' is_excel="1">    
                </div>
            </div>
        </div>
    </div>
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
</cfif>
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=get_member.recordcount>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>			
    <cf_report_list>             
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="57487.No"></th>
                <cfif attributes.search_type eq 1><th><cf_get_lang dictionary_id='57631.Ad'><cf_get_lang dictionary_id='58726.Soyad'></th></cfif>
                <cfif listfind(attributes.list_type,40)><th><cf_get_lang dictionary_id='58527.Id'></th></cfif>
                <cfif listfind(attributes.list_type,1)><th nowrap><cf_get_lang dictionary_id="57558.Üye No"></th></cfif>
                <cfif listfind(attributes.list_type,2)><th nowrap><cf_get_lang dictionary_id="57486.Kategori"></th></cfif>
                <cfif attributes.search_type eq 0 or attributes.search_type eq 1>
                    <cfif listfind(attributes.list_type,3)><th nowrap><cf_get_lang dictionary_id="57751.Kısa Ad"></th></cfif>
                </cfif>
                <cfif listfind(attributes.list_type,4)><th nowrap><cf_get_lang dictionary_id="57571.Unvan"></th></cfif>
                <cfif listfind(attributes.list_type,47)><th nowrap><cf_get_lang dictionary_id ='58025.TC Kimlik No'></th></cfif>
                <cfif listfind(attributes.list_type,5)>
                    <cfif attributes.search_type neq 2>
                        <th><cf_get_lang dictionary_id="57578.Yetkili"></th>
                        <th nowrap><cf_get_lang dictionary_id="57578.Yetkili"><cf_get_lang dictionary_id="57428.Email"></th>
                    </cfif>
                </cfif>
                <cfif Len(attributes.is_show_member_team) and attributes.search_type neq 1><th><cf_get_lang dictionary_id="59150.Üye Ekibi Gelsin"> </th></cfif>
                <cfif listfind(attributes.list_type,48) and attributes.search_type eq 1><th><cf_get_lang dictionary_id="39931.Gorev"></th></cfif>
                <cfif listfind(attributes.list_type,49) and attributes.search_type eq 1><th><cf_get_lang dictionary_id="39393.Unvan"></th></cfif>
                <cfif listfind(attributes.list_type,50) and attributes.search_type eq 1><th><cf_get_lang dictionary_id='57764.Cinsiyet'></th></cfif>
                <cfif listfind(attributes.list_type,51) and attributes.search_type eq 1><th><cf_get_lang dictionary_id="38923.İse Giris Tarihi"></th></cfif>
                <cfif listfind(attributes.list_type,52) and attributes.search_type eq 1><th><cf_get_lang dictionary_id="29438.Cikis Tarihi"></th></cfif>
                <cfif listfind(attributes.list_type,53) and attributes.search_type eq 1><th><cf_get_lang dictionary_id="57572.Departman"></th></cfif>
                <cfif listfind(attributes.list_type,54) and attributes.search_type eq 1><th><cf_get_lang dictionary_id="39968.PDKS No"></th></cfif>
                <cfif listfind(attributes.list_type,55) and attributes.search_type eq 1><th><cf_get_lang dictionary_id='29489.PDKS Tipi'></th></cfif>
                <cfif listfind(attributes.list_type,6)><th nowrap><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th></th></cfif>
                <cfif listfind(attributes.list_type,68)><th nowrap><cf_get_lang dictionary_id='38373.Satış Hesabı'></th></cfif>
                <cfif listfind(attributes.list_type,69)><th nowrap><cf_get_lang dictionary_id='38375.Alış Hesabı'></th></cfif>
                <cfif listfind(attributes.list_type,7)><th nowrap><cf_get_lang dictionary_id='57789.Özel Kod'></th></cfif>
                <cfif attributes.search_type eq 0 or attributes.search_type eq 1>
                    <cfif listfind(attributes.list_type,42)><th nowrap><cf_get_lang dictionary_id='57789.Özel Kod'> 2</th></cfif>
                    <cfif listfind(attributes.list_type,43)><th nowrap><cf_get_lang dictionary_id='57789.Özel Kod'> 3</th></cfif> 
                </cfif>
                <cfif listfind(attributes.list_type,8)><th><cf_get_lang dictionary_id="39080.Mikro Bölge"></th></cfif>
                <cfif listfind(attributes.list_type,9)><th><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th></cfif>
                <cfif listfind(attributes.list_type,26)><th><cf_get_lang dictionary_id="57579.Sektör"></th></cfif>
                <cfif attributes.search_type eq 0>
                    <cfif listfind(attributes.list_type,62)><th><cf_get_lang dictionary_id="58847.Marka"></th></cfif>                        
                </cfif>
                <cfif listfind(attributes.list_type,22)><th><cf_get_lang dictionary_id='39816.Üyelik Başlama Tarihi'></th></cfif>
                <cfif listfind(attributes.list_type,10)><th><cf_get_lang dictionary_id='58832.abone'></th></cfif>
                <cfif listfind(attributes.list_type,11)><th><cf_get_lang dictionary_id="57908.Temsilci"></th></cfif>
                <cfif listfind(attributes.list_type,61)><th><cf_get_lang dictionary_id="30124.Temsilci Departmanı"></th></cfif>
                <cfif listfind(attributes.list_type,29)><th nowrap><cf_get_lang dictionary_id='58636.Referans Üye'></th></cfif>
                <cfif listfind(attributes.list_type,31)><th nowrap><cf_get_lang dictionary_id='29449.Banka Hesabı'></th></cfif>
                <cfif listfind(attributes.list_type,41) and attributes.search_type neq 2><th nowrap><cf_get_lang dictionary_id ='39733.İlişkili Şube'> - BSM</th></cfif>
                <cfif listfind(attributes.list_type,27)><th nowrap><cf_get_lang dictionary_id='58813.Cep Telefonu'></th></cfif>
                <cfif attributes.search_type eq 0 or attributes.search_type eq 1>
                    <cfif listfind(attributes.list_type,12)><th><cf_get_lang dictionary_id='57499.Telefon'></th></cfif>
                    <cfif listfind(attributes.list_type,20)><th><cf_get_lang dictionary_id='57499.Telefon'> 2</th></cfif>
                    <cfif listfind(attributes.list_type,21)><th><cf_get_lang dictionary_id='57488.Fax'></th></cfif>
                <cfelse>
                    <cfif listfind(attributes.list_type,12)><th nowrap><cf_get_lang dictionary_id='58814.Ev Telefonu'></th></cfif>
                    <cfif listfind(attributes.list_type,20)><th nowrap><cf_get_lang dictionary_id='58815.İş Telefonu'></th></cfif>
                    <cfif listfind(attributes.list_type,28)><th nowrap><cf_get_lang dictionary_id='58813.Cep Telefonu'>2</th></cfif>
                </cfif>
                <cfif listfind(attributes.list_type,19)><th nowrap><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th></cfif>
                <cfif listfind(attributes.list_type,13)><th nowrap><cf_get_lang dictionary_id="57752.Vergi No"></th></cfif>
                <cfif listfind(attributes.list_type,14)><th nowrap><cf_get_lang dictionary_id="58723.Adres">(<cf_get_lang dictionary_id='57441.Fatura'>)</th></cfif>
                <cfif listfind(attributes.list_type,15)><th nowrap><cf_get_lang dictionary_id='58132.Semt'>(<cf_get_lang dictionary_id='57441.Fatura'>)</th></cfif>
                <cfif listfind(attributes.list_type,44)><th nowrap><cf_get_lang dictionary_id="58723.Adres">(<cf_get_lang dictionary_id="40695.Ev">) </th></cfif>
                <cfif listfind(attributes.list_type,45)><th nowrap><cf_get_lang dictionary_id='58132.Semt'>(<cf_get_lang dictionary_id="40695.Ev">)</th></cfif>					
                <cfif listfind(attributes.list_type,16)><th nowrap><cf_get_lang dictionary_id="58638.İlçe"></th></cfif>
                <cfif listfind(attributes.list_type,17)><th nowrap><cf_get_lang dictionary_id='58608.Il'></th></cfif>
                <cfif listfind(attributes.list_type,34) and attributes.search_type eq 2><th nowrap><cf_get_lang dictionary_id="58638.İlçe"> 2</th></cfif>
                <cfif listfind(attributes.list_type,35) and attributes.search_type eq 2><th nowrap><cf_get_lang dictionary_id='58608.Il'> 2</th></cfif>					
                <cfif listfind(attributes.list_type,30)><th><cf_get_lang dictionary_id="58219.Ulke"></th></cfif>
                <cfif listfind(attributes.list_type,18)><th nowrap><cf_get_lang dictionary_id="57428.Email"></th></cfif>
                <cfif listfind(attributes.list_type,25)><th><cf_get_lang dictionary_id="57899.Kaydeden"></th></cfif>
                <cfif listfind(attributes.list_type,23)><th nowrap><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th></cfif>
                <cfif listfind(attributes.list_type,32) and attributes.search_type neq 0><th nowrap><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th></cfif>
                <cfif listfind(attributes.list_type,36) and attributes.search_type eq 2><th><cf_get_lang dictionary_id='40692.Öneren Üye'></th></cfif>
                <cfif listfind(attributes.list_type,59) and attributes.search_type eq 2><th><cf_get_lang dictionary_id='58608.Il'> <cf_get_lang dictionary_id='58762.Vergi Dairesi'></th></cfif>
                <cfif listfind(attributes.list_type,60) and attributes.search_type eq 2><th><cf_get_lang dictionary_id='58638.İlçe'> <cf_get_lang dictionary_id='58762.Vergi Dairesi'></th></cfif>
                <cfif listfind(attributes.list_type,37)>
                    <th><cf_get_lang dictionary_id='38844.Alış Ödeme Yöntemi'></th>
                    <th><cf_get_lang dictionary_id='38845.Satış Ödeme Yöntemi'></th>
                </cfif>
                <cfif isdefined("attributes.add_info") and len(attributes.add_info)>
                    <cfoutput>
                        <cfquery name="get_info_name" datasource="#dsn#">
                            SELECT
                                *
                            FROM
                                SETUP_INFOPLUS_NAMES
                            WHERE
                                <cfif attributes.search_type eq 0>
                                    OWNER_TYPE_ID = -1 
                                <cfelseif attributes.search_type eq 1>
                                    OWNER_TYPE_ID = -3 
                                <cfelseif attributes.search_type eq 2>
                                    OWNER_TYPE_ID = -2
                                </cfif>
                        </cfquery>
                        <cfloop list="#attributes.add_info#" index="kk">
                            <th>#evaluate("get_info_name.property#kk#_name")#</th>
                        </cfloop>
                    </cfoutput>
                </cfif>
                <cfif listfind(attributes.list_type,46)><th nowrap><cf_get_lang dictionary_id="59007.IBAN Kodu"></th></cfif>
                <cfif listfind(attributes.list_type,56)><th nowrap><cf_get_lang dictionary_id ='29530.Swift Kodu'></th></cfif>
                <cfif listfind(attributes.list_type,57)><th nowrap><cf_get_lang dictionary_id='58608.Il'>(<cf_get_lang dictionary_id='57441.Fatura'>)</th></cfif>
                <cfif listfind(attributes.list_type,58)><th nowrap><cf_get_lang dictionary_id='58638.Ilce'>(<cf_get_lang dictionary_id='57441.Fatura'>)</th></cfif>
                <cfif listfind(attributes.list_type,67)><th nowrap> <cf_get_lang dictionary_id='52268.Üst Şirket'></th></cfif>
            </tr>
        </thead>
        <cfif get_member.recordcount>    
            <cfif listfind(attributes.list_type,31) or listfind(attributes.list_type,46) or listfind(attributes.list_type,56)>
                <cfif attributes.search_type eq 2>
                    <cfquery name="GET_BANK_DETAIL_ALL" datasource="#DSN#">
                        SELECT 
                            CONSUMER_ID MEMBER_ID,
                            CONSUMER_BANK CNAME,
                            CONSUMER_BANK_BRANCH CBRANCH_NAME,
                            CONSUMER_ACCOUNT_NO CACCOUNT,
                            MONEY CMONEY,
                            CONSUMER_IBAN_CODE CIBAN_NO,
                            CONSUMER_SWIFT_CODE CSWIFT_CODE
                        FROM 
                            CONSUMER_BANK
                        ORDER BY 
                            CONSUMER_ID
                    </cfquery>
                <cfelse>
                    <cfquery name="GET_BANK_DETAIL_ALL" datasource="#DSN#">
                        SELECT
                            COMPANY_ID MEMBER_ID,
                            COMPANY_BANK CNAME, 
                            COMPANY_BANK_BRANCH CBRANCH_NAME,
                            COMPANY_ACCOUNT_NO CACCOUNT, 
                            COMPANY_IBAN_CODE CIBAN_NO,
                            COMPANY_BANK_MONEY CMONEY ,
                            COMPANY_SWIFT_CODE CSWIFT_CODE
                        FROM 
                            COMPANY_BANK
                        ORDER BY 
                            COMPANY_ID
                    </cfquery>
                </cfif>
                <cfquery name="GET_BANK_DETAIL" dbtype="query">
                    SELECT GET_BANK_DETAIL_ALL.* FROM GET_BANK_DETAIL_ALL,GET_MEMBER_ WHERE GET_BANK_DETAIL_ALL.MEMBER_ID = GET_MEMBER_.MEMBER_ID ORDER BY GET_MEMBER_.MEMBER_ID
                </cfquery>
            </cfif>
                
            <cfif isdefined("attributes.add_info") and len(attributes.add_info)>
                <cfif get_member_.recordcount or get_member_partner_.recordcount>
                    <cfquery name="GET_INFO_PLUS" datasource="#DSN#">
                        SELECT
                            *
                        FROM
                            INFO_PLUS
                        WHERE
                        <cfif attributes.search_type eq 0>
                            INFO_OWNER_TYPE = -1 
                        <cfelseif attributes.search_type eq 1>
                            INFO_OWNER_TYPE = -3 
                        <cfelseif attributes.search_type eq 2>
                            INFO_OWNER_TYPE = -2
                        </cfif>
                    </cfquery>                  
                    <cfquery name="GET_INFO_PLUS_ALL" dbtype="query">
                        SELECT
                            *
                        FROM
                            GET_INFO_PLUS,
                        <cfif attributes.search_type eq 1>
                            GET_MEMBER_PARTNER_
                        <cfelse>
                            GET_MEMBER_
                        </cfif>
                        WHERE
                        <cfif attributes.search_type eq 1>
                            GET_INFO_PLUS.OWNER_ID = GET_MEMBER_PARTNER_.PARTNER_ID
                        <cfelse>
                            GET_INFO_PLUS.OWNER_ID = GET_MEMBER_.MEMBER_ID
                        </cfif> 
                    </cfquery>						
                </cfif>
            </cfif>
            <!--- Hedef icin kullanilan bir yapı. Bizde kayıt getirmez BK 20110809 --->
            <cfif xml_list_branch_related eq 1 and listfind(attributes.list_type,41)>				
                <cfquery name="GET_RELATED_BRANCH_ALL" datasource="#dsn#">
                    SELECT 
                        CBR.COMPANY_ID,
                        B.BRANCH_ID,
                        B.BRANCH_NAME,
                        CBR.SALES_DIRECTOR
                    FROM
                        COMPANY_BRANCH_RELATED CBR,
                        COMPANY_BOYUT_DEPO_KOD CBDK,
                        OUR_COMPANY OC,
                        BRANCH B
                    WHERE 
                        CBR.MUSTERIDURUM IS NOT NULL AND
                        CBR.COMPANY_ID IS NOT NULL AND 
                        B.BRANCH_ID = CBR.BRANCH_ID AND
                        OC.COMP_ID = B.COMPANY_ID AND
                        CBDK.W_KODU = B.BRANCH_ID
                </cfquery>
                <cfquery name="GET_RELATED_BRANCH" dbtype="query">
                    SELECT GET_RELATED_BRANCH_ALL.* FROM GET_RELATED_BRANCH_ALL,GET_MEMBER_ WHERE GET_MEMBER_.MEMBER_ID = GET_RELATED_BRANCH_ALL.COMPANY_ID ORDER BY  GET_RELATED_BRANCH_ALL.COMPANY_ID
                </cfquery>
            </cfif>
            
            <tbody>
                <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="25" nowrap style="mso-number-format:\@;">#currentrow#</td>
                        <cfif attributes.search_type eq 1><td nowrap style="mso-number-format:\@;">#get_member.company_partner_name# #get_member.company_partner_surname#</td></cfif>   
                        <cfif listfind(attributes.list_type,40)><td><cfif attributes.search_type neq 1>#get_member.member_id#<cfelse>#get_member.partner_id#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,1)><td nowrap style="mso-number-format:\@;">#get_member.member_code#</td></cfif>
                        <cfif attributes.search_type eq 0 or attributes.search_type eq 1>
                            <cfif listfind(attributes.list_type,2)><td nowrap style="mso-number-format:\@;">#get_member.member_cat#</td></cfif>
                        <cfelse>
                            <cfif listfind(attributes.list_type,2)><td nowrap style="mso-number-format:\@;">#get_member.member_cat#</td></cfif>
                        </cfif>
                        <cfif attributes.search_type eq 0 or attributes.search_type eq 1>
                            <cfif listfind(attributes.list_type,3)><td nowrap>#get_member.nickname#</td></cfif>
                            <cfif listfind(attributes.list_type,4)><td nowrap><cfif not len(attributes.is_excel)><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#member_id#" class="tableyazi" target="_blank"></cfif>#get_member.fullname#</a></td></cfif>
                        <cfelse>
                            <cfif listfind(attributes.list_type,4)><td nowrap><cfif not len(attributes.is_excel)><a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#member_id#" class="tableyazi" target="_blank"></cfif>#get_member.consumer_name#&nbsp;#get_member.consumer_surname#</a></td></cfif>
                        </cfif>
                        
                        <cfif attributes.search_type eq 2>
                            <cfif listfind(attributes.list_type,47)><td nowrap>#tc_identy_no#</td></cfif>
                        <cfelseif attributes.search_type eq 0 or attributes.search_type eq 1>
                            <cfif listfind(attributes.list_type,47)><td nowrap>#tc_identity#</td></cfif>
                        </cfif>
                        <cfif listfind(attributes.list_type,5)>
                            <cfif attributes.search_type neq 2>
                                <td nowrap>#get_member.company_partner_name# #get_member.company_partner_surname#</td>
                                <td nowrap>#get_member.COMPANY_PARTNER_EMAIL#</td>
                            </cfif>
                        </cfif>
                        <cfif Len(attributes.is_show_member_team) and attributes.search_type neq 1><td><cfoutput>#emp_name#<br /></cfoutput></td><!--- output query kullanılıyor ---></cfif>
                        <cfif listfind(attributes.list_type,48) and attributes.search_type eq 1>
                            <cfif len(get_member.mission)>
                                <cfquery name="get_partner_positions_" dbtype="query">
                                    SELECT PARTNER_POSITION,PARTNER_POSITION_ID FROM get_partner_positions WHERE PARTNER_POSITION_ID = #get_member.mission#
                                </cfquery>
                            </cfif>
                            <td nowrap><cfif len(get_member.mission)>#get_partner_positions_.partner_position#</cfif></td>
                        </cfif>
                        <cfif listfind(attributes.list_type,49) and attributes.search_type eq 1><td nowrap>#get_member.title#</td></cfif>
                        <cfif listfind(attributes.list_type,50) and attributes.search_type eq 1><td nowrap><cfif get_member.sex eq 1>Erkek<cfelse><cf_get_lang dictionary_id='58958.Kadın'></cfif></td></cfif>
                        <cfif listfind(attributes.list_type,51) and attributes.search_type eq 1><td nowrap>#dateformat(get_member.startdate,dateformat_style)#</td></cfif>
                        <cfif listfind(attributes.list_type,52) and attributes.search_type eq 1><td nowrap>#dateformat(get_member.finish_date,dateformat_style)#</td></cfif>
                        <cfif listfind(attributes.list_type,53) and attributes.search_type eq 1>
                            <cfif len(get_member.department)>
                                <cfquery name="get_dept_name_" dbtype="query">
                                    SELECT PARTNER_DEPARTMENT,PARTNER_DEPARTMENT_ID FROM get_dept_name WHERE PARTNER_DEPARTMENT_ID = #get_member.department#
                                </cfquery>
                            </cfif>
                            <td nowrap><cfif len(get_member.department)>#get_dept_name_.partner_department#</cfif></td>
                        </cfif>
                        <cfif listfind(attributes.list_type,54) and attributes.search_type eq 1><td nowrap style="mso-number-format:\@;">#get_member.pdks_number#</td></cfif>
                        <cfif listfind(attributes.list_type,55) and attributes.search_type eq 1>
                            <cfif len(get_member.pdks_type_id)>
                            <cfquery name="get_pdks_types_" dbtype="query">
                                SELECT PDKS_TYPE_ID,PDKS_TYPE FROM get_pdks_types WHERE PDKS_TYPE_ID = #get_member.pdks_type_id#
                            </cfquery>
                            </cfif> 
                            <td nowrap>
                                <cfif len(get_member.pdks_type_id)>	#get_pdks_types_.PDKS_TYPE#</cfif> 
                            </td>
                        </cfif>
                        <cfif listfind(attributes.list_type,6)><td nowrap style="mso-number-format:\@;">#get_member.account_code#</td></cfif>
                        <cfif listfind(attributes.list_type,68)><td nowrap style="mso-number-format:\@;">#get_member.sales_account#</td></cfif>
                        <cfif listfind(attributes.list_type,69)><td nowrap style="mso-number-format:\@;">#get_member.purchase_account#</td></cfif>
                        <cfif listfind(attributes.list_type,7)><td nowrap style="mso-number-format:\@;">#get_member.ozel_kod#</td></cfif>
                        <cfif attributes.search_type eq 0 or attributes.search_type eq 1>
                            <cfif listfind(attributes.list_type,42)><td nowrap style="mso-number-format:\@;">#get_member.ozel_kod_1#</td></cfif>
                            <cfif listfind(attributes.list_type,43)><td nowrap style="mso-number-format:\@;">#get_member.ozel_kod_2#</td></cfif> 
                        </cfif>
                        <cfif listfind(attributes.list_type,8)><td nowrap style="mso-number-format:\@;"><cfif len(get_member.ims_code_id)>#get_member.ims_code#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,9)><td nowrap><cfif len(get_member.sales_county)>#get_member.sz_name#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,26)>
                            <cfif listlen(get_member.sector_cat) lte 3 and len(get_member.sector_cat)>
                                <td nowrap>#left(get_member.sector_cat,len(get_member.sector_cat)-1)#
                            <cfelseif listlen(get_member.sector_cat) gte 3 and len(get_member.sector_cat)>
                                <td nowrap title="#get_member.sector_cat#">
                                <cfloop from="1" to="3" index="i">#listgetat(get_member.sector_cat,i)#, </cfloop>...
                            <cfelse>
                                <td> </td>
                            </cfif>
                        </cfif>
                        <cfif attributes.search_type eq 0>
                            <cfif listfind(attributes.list_type,62)>
                                <td nowrap>
                                    <cfquery name="Get_Company_Related_Brand" datasource="#dsn#">
                                        SELECT 
                                            PB.BRAND_NAME 
                                        FROM 
                                            RELATED_BRANDS RB
                                            LEFT JOIN #dsn3_alias#.PRODUCT_BRANDS PB ON PB.BRAND_ID = RB.RELATED_BRAND_ID
                                        WHERE 
                                            RB.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.member_id#">
                                    </cfquery>
                                    <cfset Company_Related_List = ValueList(Get_Company_Related_Brand.Brand_Name)>
                                    <cfloop list="#Company_Related_List#" index="mt">
                                        #mt#<br />
                                    </cfloop>
                                </td>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.list_type,22)><td nowrap><cfif len(get_member.start_date)>#dateformat(get_member.start_date,dateformat_style)#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,10)>
                            <td nowrap>
                                <cfquery name="GET_SUBSCRPT" dbtype="query">
                                    SELECT 
                                        SUBSCRIPTION_NO,
                                        INVOICE_ADDRESS
                                    FROM 
                                        GET_SUBSCRIPTION
                                    WHERE 
                                    <cfif attributes.search_type eq 0>
                                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.member_id#">
                                    <cfelseif attributes.search_type eq 1>
                                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.partner_id#">
                                    <cfelse>
                                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.member_id#">
                                    </cfif>
                                </cfquery>
                                <cfif get_subscrpt.recordcount><cfloop query="get_subscrpt">(#get_subscrpt.subscription_no#)-(#get_subscrpt.invoice_address#)<cfif get_subscrpt.currentrow neq get_subscrpt.recordcount><br/></cfif></cfloop></cfif>
                            </td>
                        </cfif>
                        <cfif listfind(attributes.list_type,11)>
                            <td nowrap>
                                <cfif len(get_member.position_code)>
                                    <cfif not len(attributes.is_excel)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_member.position_code#','medium');" class="tableyazi"></cfif>
                                        #get_member.position_code_name#
                                    <cfif not len(attributes.is_excel)></a></cfif>
                                </cfif>
                            </td>
                        </cfif>
                        <cfif listfind(attributes.list_type,61)>
                            <td nowrap>
                                <cfif isDefined("get_member.position_code") and isNumeric(get_member.position_code)>
                                    <cfquery name="get_cpp" datasource="#DSN#">
                                        SELECT
                                            EMPLOYEE_POSITIONS.DEPARTMENT_ID,
                                            DEPARTMENT.DEPARTMENT_HEAD
                                        FROM
                                            EMPLOYEE_POSITIONS
                                                LEFT JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                                        WHERE
                                            EMPLOYEE_POSITIONS.POSITION_CODE = #get_member.position_code# AND
                                            IS_MASTER = 1
                                    </cfquery>
                                    #get_cpp.department_head#
                                </cfif>
                            </td>
                        </cfif>
                        <cfif listfind(attributes.list_type,29)>
                            <td nowrap><cfif len(ref_pos_code)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#ref_pos_code#','medium');" class="tableyazi">#get_member.ref_pos_name#</a></cfif></td>
                        </cfif>	
                        <cfif listfind(attributes.list_type,31)>
                            <td nowrap>
                                <cfquery name="GET_BANK_SUB" dbtype="query">
                                    SELECT * FROM GET_BANK_DETAIL WHERE MEMBER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_id#">
                                </cfquery>
                                <cfloop query="get_bank_sub">#cname# #cbranch_name# / #caccount# - #cmoney#<br/></cfloop>
                            </td>
                        </cfif>
                        
                        <cfif listfind(attributes.list_type,41)>
                            <td nowrap>
                                <cfif len(attributes.company_id)>
                                    <cfquery name="GET_RELATED_BRANCH_SUB" dbtype="query">
                                        SELECT BRANCH_NAME,SALES_DIRECTOR FROM GET_RELATED_BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                                    </cfquery>
                                    <cfloop query="Get_Related_Branch_Sub">
                                        #Get_Related_Branch_Sub.Branch_Name# - #Get_Emp_Info(Get_Related_Branch_Sub.Sales_Director,1,0)#<br />
                                    </cfloop>
                                </cfif>
                            </td>
                        </cfif>	
                        
                        <cfif listfind(attributes.list_type,27)><td nowrap>#mobil_code#&nbsp;#mobiltel#</td></cfif>
                        <cfif attributes.search_type eq 0 or attributes.search_type eq 1>
                            <cfif listfind(attributes.list_type,12)><td nowrap>#get_member.company_telcode#&nbsp;#get_member.company_tel1#</td></cfif>
                            <cfif listfind(attributes.list_type,20)><td nowrap>#get_member.company_telcode#&nbsp;#get_member.company_tel2#</td></cfif>
                            <cfif listfind(attributes.list_type,21)><td nowrap>#get_member.company_telcode#&nbsp;#get_member.company_fax#</td></cfif>
                        <cfelse>
                            <cfif listfind(attributes.list_type,12)><td nowrap>#consumer_hometelcode#&nbsp;#consumer_hometel#</td></cfif>
                            <cfif listfind(attributes.list_type,20)><td nowrap>#consumer_worktelcode#&nbsp;#consumer_worktel#</td></cfif>
                            <cfif listfind(attributes.list_type,28)><td nowrap>#mobil_code_2#&nbsp;#mobiltel_2#</td></cfif>
                        </cfif>
                        <cfif listfind(attributes.list_type,19)><td nowrap>#get_member.taxoffice#</td></cfif>
                        <cfif listfind(attributes.list_type,13)><td nowrap style="mso-number-format:\@;">#get_member.taxno#</td></cfif>
                        <cfif listfind(attributes.list_type,14)><td nowrap>#get_member.company_address#</td></cfif>
                        <cfif listfind(attributes.list_type,44)><td nowrap>#get_member.homeaddress#</td></cfif>
                        <cfif listfind(attributes.list_type,45)><td nowrap>#get_member.homesemt#</td></cfif>
                        <cfif listfind(attributes.list_type,15)><td nowrap>#get_member.semt#</td></cfif>
                        <cfif listfind(attributes.list_type,16)><td nowrap><cfif len(get_member.county)>#get_member.county_name#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,17)><td nowrap><cfif len(get_member.city)>#get_member.city_name#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,34) and attributes.search_type eq 2><td nowrap><cfif len(get_member.county2)>#get_member.county_name2#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,35) and attributes.search_type eq 2><td nowrap><cfif len(get_member.city2)>#get_member.city_name2#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,30)><td nowrap><cfif len(get_member.country)>#get_member.country_name#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,18)><td nowrap><cfif attributes.search_type eq 0>#get_member.company_email#<cfelseif attributes.search_type eq 1>#get_member.company_partner_email#<cfelse>#consumer_email#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,25)><td nowrap>#get_member.record_name#</td></cfif>
                        <cfif listfind(attributes.list_type,23)><td nowrap>#dateformat(get_member.record_date,dateformat_style)#</td></cfif>
                        <cfif listfind(attributes.list_type,32) and attributes.search_type neq 0><td nowrap>#DateFormat(get_member.birthdate,dateformat_style)#</td></cfif>
                        <cfif listfind(attributes.list_type,36) and attributes.search_type eq 2><td nowrap><cfif len(get_member.proposer_cons_id)>#get_member.proposer_cons_name#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,59)and attributes.search_type eq 2><td nowrap><cfif len(get_member.TAX_COUNTRY_NAME)>#get_member.TAX_COUNTRY_NAME#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,60)and attributes.search_type eq 2><td nowrap><cfif len(get_member.TAX_COUNTY_NAME)>#get_member.TAX_COUNTY_NAME#</cfif></td></cfif>
                        <cfif listfind(attributes.list_type,37)>
                            <td width="100">#pay_method#</td>
                            <td>#REV_METHOD#</td>
                        </cfif>
                        <cfif isdefined("attributes.add_info") and len(attributes.add_info)>
                            <cfquery name="GET_INFO_PLUS_ROW" dbtype="query">
                                SELECT 
                                    * 
                                FROM 
                                    GET_INFO_PLUS_ALL 
                                WHERE 
                                    OWNER_ID = <cfif attributes.search_type neq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#member_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#"></cfif>
                            </cfquery>
                            <cfloop list="#attributes.add_info#" index="kk">
                                <td width="100">
                                    <cfif attributes.search_type eq 0>
                                        #evaluate("get_info_plus_row.property#kk#")#
                                    <cfelseif attributes.search_type eq 1>
                                        #evaluate("get_info_plus_row.property#kk#")#
                                    <cfelse>
                                        #evaluate("get_info_plus_row.property#kk#")#
                                    </cfif>
                                </td>
                            </cfloop>
                        </cfif>
                        <cfif listfind(attributes.list_type,46)>
                            <td nowrap>
                                <cfquery name="GET_BANK_SUB" dbtype="query">
                                    SELECT CIBAN_NO FROM GET_BANK_DETAIL WHERE MEMBER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_id#">
                                </cfquery>
                                <cfloop query="get_bank_sub">#ciban_no#<br/></cfloop>
                            </td>
                        </cfif>
                        <cfif listfind(attributes.list_type,56)>
                            <td nowrap>
                                <cfquery name="GET_BANK_SUB2" dbtype="query">
                                    SELECT CSWIFT_CODE FROM GET_BANK_DETAIL WHERE MEMBER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_id#">
                                </cfquery>
                                <cfloop query="GET_BANK_SUB2">#cswift_code#<br/></cfloop>
                            </td>
                        </cfif>
                    <cfif listfind(attributes.list_type,57)>
                            <td nowrap>
                                <cfquery name="GET_CITY_FATURA" dbtype="query">
                                    SELECT 
                                    CITY_NAME
                                    FROM 
                                        GET_SUBSCRIPTION
                                    WHERE 
                                    <cfif attributes.search_type eq 0>
                                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.member_id#">
                                    <cfelseif attributes.search_type eq 1>
                                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.partner_id#">
                                    <cfelse>
                                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.member_id#">
                                    </cfif>
                                </cfquery>
                                <cfif GET_CITY_FATURA.recordcount><cfloop query="GET_CITY_FATURA">#GET_CITY_FATURA.CITY_NAME#<cfif GET_CITY_FATURA.currentrow neq GET_CITY_FATURA.recordcount><br/></cfif></cfloop></cfif>
                            </td>
                    </cfif>
                        <cfif listfind(attributes.list_type,58)>
                            <td nowrap>
                                <cfquery name="GET_COUNTY_FATURA" dbtype="query">
                                    SELECT 
                                    COUNTY_NAME
                                    FROM 
                                        GET_SUBSCRIPTION
                                    WHERE 
                                    <cfif attributes.search_type eq 0>
                                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.member_id#">
                                    <cfelseif attributes.search_type eq 1>
                                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.partner_id#">
                                    <cfelse>
                                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member.member_id#">
                                    </cfif>
                                </cfquery>
                                <cfif GET_COUNTY_FATURA.recordcount><cfloop query="GET_COUNTY_FATURA">#GET_COUNTY_FATURA.COUNTY_NAME#<!---<cfif GET_CITY_FATURA.currentrow neq GET_CITY_FATURA.recordcount><br/></cfif>---></cfloop></cfif>
                            </td>
                        </cfif>
                        <cfif listfind(attributes.list_type,67)><td nowrap>
                                        <cfquery name="GET_COMPANY" datasource="#DSN#">
                                            SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_member.hierarchy_id#">
                                        </cfquery>
                        #get_company.fullname#</td></cfif>
                    </tr>            
                </cfoutput>
            </tbody> 
            <cfelse>
                <tbody>
                    <tr>
                        <cfset colspan_ = 49>
                        <cfset colspan_ = colspan_ + listlen(attributes.list_type)>
                        <td colspan="90"><cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)><cf_get_lang dictionary_id='57484.Kayit Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </tbody>
        </cfif>
    </cf_report_list>	
</cfif>
<cfif get_member.recordcount and (attributes.maxrows lt attributes.totalrecords)>
    <cfset url_str = "report.detayli_uye_analizi_raporu">
    <cfif isdefined("attributes.report_id")>
        <cfset url_str = "#url_str#&report_id=#attributes.report_id#">
    </cfif>
    <cfif len(attributes.is_form_submitted)>
        <cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
    </cfif>
    <cfif len(attributes.companycat_id)>
        <cfset url_str = "#url_str#&companycat_id=#attributes.companycat_id#">
    </cfif>
    <cfif len(attributes.company)>
        <cfset url_str = "#url_str#&company=#attributes.company#">
    </cfif>
    <cfif len(attributes.search_potential)>
        <cfset url_str = "#url_str#&search_potential=#attributes.search_potential#">
    </cfif>
    <cfif len(attributes.search_type)>
        <cfset url_str = "#url_str#&search_type=#attributes.search_type#">
    </cfif>
    <cfif len(attributes.member_status)>
        <cfset url_str = "#url_str#&member_status=#attributes.member_status#">
    </cfif>
    <cfif len(attributes.partner_status)>
        <cfset url_str = "#url_str#&partner_status=#attributes.partner_status#">
    </cfif>
    <cfif len(attributes.partner_position)>
        <cfset url_str = "#url_str#&partner_position=#attributes.partner_position#">
    </cfif>
    <cfif len(attributes.sector_cat_id)>
        <cfset url_str = "#url_str#&sector_cat_id=#attributes.sector_cat_id#">
    </cfif>
    <cfif len(attributes.our_company_id)>
        <cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
    </cfif>
    <cfif len(attributes.customer_value)>
        <cfset url_str = "#url_str#&customer_value=#attributes.customer_value#">
    </cfif>
    <cfif len(attributes.list_type)>
        <cfset url_str = "#url_str#&list_type=#attributes.list_type#">
    </cfif>
    <cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
        <cfset url_str = "#url_str#&pos_code=#attributes.pos_code#&pos_code_text=#attributes.pos_code_text#">
    </cfif>
    <cfif len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name)>
        <cfset url_str = "#url_str#&ref_pos_code=#attributes.ref_pos_code#&ref_pos_code_name=#attributes.ref_pos_code_name#">
    </cfif>
    <cfif len(attributes.city_id)>
        <cfset url_str = "#url_str#&city_id=#attributes.city_id#">
    </cfif>
    <cfif len(attributes.county_id)>
        <cfset url_str = "#url_str#&county_id=#attributes.county_id#">
    </cfif>
    <cfif isdefined("attributes.country_id")>
        <cfset url_str = "#url_str#&country_id=#attributes.country_id#">
    </cfif>
    <cfif len(attributes.record_emp_id) and len(attributes.record_emp)>
        <cfset url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#&record_emp=#attributes.record_emp#">
    </cfif>
    <cfif isdate(attributes.startdate_1)>
        <cfset url_str = "#url_str#&startdate_1=#dateformat(attributes.startdate_1,dateformat_style)#">
    </cfif>
    <cfif isdate(attributes.startdate_2)>
        <cfset url_str = "#url_str#&startdate_2=#dateformat(attributes.startdate_2,dateformat_style)#">
    </cfif>	
    <cfif isdate(attributes.recorddate_1)>
        <cfset url_str = "#url_str#&recorddate_1=#dateformat(attributes.recorddate_1,dateformat_style)#">
    </cfif>
    <cfif isdate(attributes.recorddate_2)>
        <cfset url_str = "#url_str#&recorddate_2=#dateformat(attributes.recorddate_2,dateformat_style)#">
    </cfif>		
    <cfif len(attributes.sales_county)>
        <cfset url_str = "#url_str#&sales_county=#attributes.sales_county#">
    </cfif>		
    <cfif len(attributes.process_stage_type_con)>
        <cfset url_str = "#url_str#&process_stage_type_con=#attributes.process_stage_type_con#">
    </cfif>
    <cfif len(attributes.not_want_sms)>
        <cfset url_str = "#url_str#&not_want_sms=#attributes.not_want_sms#">
    </cfif>
    <cfif len(attributes.not_want_email)>
        <cfset url_str = "#url_str#&not_want_email=#attributes.not_want_email#">
    </cfif>
    <cfif len(attributes.add_info)>
        <cfset url_str = "#url_str#&add_info=#attributes.add_info#">
    </cfif>
    <cfif len(attributes.process_stage_type_com)>
        <cfset url_str = "#url_str#&process_stage_type_com=#attributes.process_stage_type_com#">
    </cfif>	
    <cfif isDefined('attributes.related_status') and len(attributes.related_status)>
        <cfset url_str = "#url_str#&related_status=#attributes.related_status#">
    </cfif>
    <cfif len(attributes.paymethod_name)>
        <cfset url_str = "#url_str#&paymethod_name=#attributes.paymethod_name#">
        <cfif len(attributes.paymethod_id)>
            <cfset url_str = "#url_str#&paymethod_id=#attributes.paymethod_id#">
        </cfif>
        <cfif len(attributes.card_paymethod_id)>
            <cfset url_str = "#url_str#&card_paymethod_id=#attributes.card_paymethod_id#">
        </cfif>
    </cfif>
    <cfif len(attributes.revmethod_name)>
        <cfset url_str = "#url_str#&revmethod_name=#attributes.revmethod_name#">
        <cfif len(attributes.revmethod_id)>
            <cfset url_str = "#url_str#&revmethod_id=#attributes.revmethod_id#">
        </cfif>
        <cfif len(attributes.card_revmethod_id)>
            <cfset url_str = "#url_str#&card_revmethod_id=#attributes.card_revmethod_id#">
        </cfif>
    </cfif>
    <cfif len(attributes.branch)><cfset url_str = "#url_str#&branch=#attributes.branch#"></cfif>
    <cfif len(attributes.resource_type)><cfset url_str = "#url_str#&resource_type=#attributes.resource_type#"></cfif>
    <cfif len(attributes.ims_code)><cfset url_str = "#url_str#&ims_code=#attributes.ims_code#"></cfif>
    <cfif xml_member_analysis_info eq 1><!--- Xml den Analiz Secilmis Ise --->
        <cfif isDefined("attributes.analyse_answer") and Len(attributes.analyse_answer)><cfset url_str = "#url_str#&analyse_answer=#attributes.analyse_answer#"></cfif>
        <cfif isDefined("attributes.analyse_company_id_list") and Len(attributes.analyse_company_id_list)><cfset url_str = "#url_str#&analyse_company_id_list=#attributes.analyse_company_id_list#"></cfif>
        <cfif isDefined("attributes.analyse_consumer_id_list") and Len(attributes.analyse_consumer_id_list)><cfset url_str = "#url_str#&analyse_consumer_id_list=#attributes.analyse_consumer_id_list#"></cfif>
        <cfif isDefined("attributes.analyse_id") and isDefined("attributes.analyse_name") and Len(attributes.analyse_id) and Len(attributes.analyse_name)>
            <cfset url_str = "#url_str#&analyse_id=#attributes.analyse_id#&analyse_name=#attributes.analyse_name#">
        </cfif>
    </cfif>
    <cfif isdefined("attributes.is_show_member_team") and attributes.is_show_member_team eq 1>
        <cfset url_str = "#url_str#&is_show_member_team=#attributes.is_show_member_team#">
    </cfif>
    <cfif Len(attributes.member_team_roles)>
        <cfset url_str = "#url_str#&member_team_roles=#attributes.member_team_roles#">
    </cfif>
    <cfif isdefined("attributes.use_efatura") and len(attributes.use_efatura)>
        <cfset url_str = "#url_str#&use_efatura=#attributes.use_efatura#">
    </cfif>  
    <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_str#">

</cfif> 
<script type="text/javascript">
	function select_all(selected_field)
	{
		var m = eval("document.list_member." + selected_field + ".length");
		for(i=0;i<m;i++)
		{
			eval("document.list_member."+selected_field+"["+i+"].selected=true")
		}
        
	}
	function control1()
	{
		select_all('ims_code');
		if (document.list_member.list_type.value =="")
		{
		   alert ('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="39815.Liste Kategorisi">');
		   return false;
		}
		else 
		{
			if(document.list_member.is_excel.checked==false)
			{
				document.list_member.action="<cfoutput>#request.self#?fuseaction=report.detayli_uye_analizi_raporu</cfoutput>"
				return true;
			}
			else
				document.list_member.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detayli_uye_analizi_raporu</cfoutput>"
		}	
	}
	function remove_field(field_option_name)
	{
		field_option_name_value = eval('document.list_member.' + field_option_name);
		for (i=field_option_name_value.options.length-1;i>-1;i--)
		{
			if (field_option_name_value.options[i].selected==true)
			{
				field_option_name_value.options.remove(i);
			}	
		}
	}
	function change_city()
	{
		var country_ = document.getElementById('country_id').value;
		if(country_.length != 0)
			LoadCity(country_,'city_id','county_id',0);
		else
		{
			document.getElementById('city_id').value = '';
			document.getElementById('county_id').value = '';
			LoadCity(country_,'city_id','county_id',0);
		}
	}
	function change_county()
	{
		var city_ = document.getElementById('city_id').value;
		if(city_.length != 0)		
			LoadCounty(city_,'county_id');
		else
			document.getElementById('county_id').value = '';
	}
	<cfif len(attributes.city_id)>change_county();</cfif>
	<cfif len (attributes.county_id)>
	var optCount  = document.getElementById('county_id').length;
	for (var i = 0; i < optCount; i++)
		{
		  var option = document.getElementById('county_id').options[i];
		  if (option.value == '<cfoutput>#attributes.county_id#</cfoutput>')


		  {
			option.selected = true ;
			break;
		  }
		}
	</cfif>
</script>
