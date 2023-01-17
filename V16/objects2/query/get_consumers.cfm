<!---20131112--->
<cfif isdefined('analysis_id') and len(analysis_id)>
	<cfquery name="GET_ANALYSIS_CONSUMERS" datasource="#DSN#">
		SELECT ANALYSIS_CONSUMERS FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#analysis_id#">
	</cfquery>
    <cfset analysis_consumers = listdeleteduplicates(valuelist(get_analysis_consumers.analysis_consumers,','))>
</cfif>
<!---20131112--->
<cfif isdefined('session.ep.our_company_info.sales_zone_followup') and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
		SELECT
			DISTINCT
			SZ_HIERARCHY
		FROM
			SALES_ZONES_ALL_1 WITH (NOLOCK)
		WHERE
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfset row_block = 500>
</cfif>
<cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
	SELECT 
		IS_STORE_FOLLOWUP 
	FROM 
		OUR_COMPANY_INFO 
	WHERE 
		<cfif isdefined('session.ep.company_id')>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfelseif isdefined('session.pp.our_company_id')>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
		<cfelseif isdefined('session.pda.our_company_id')>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
		</cfif>
</cfquery>
<cfif isdefined("attributes.kontrol_conscat_id") and len(attributes.kontrol_conscat_id)>
	<cfquery name="GET_MIN_CAT" datasource="#DSN#">
		SELECT MIN_CONSCAT_ID,MAX_CONSCAT_ID FROM CONSUMER_CAT WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kontrol_conscat_id#">
	</cfquery>
	<!--- İlgili seviyede minimum seviyenin hierarsi degeri bulunur. BK 20120124 --->
	<cfif get_min_cat.recordcount and len(get_min_cat.min_conscat_id)>
		<cfquery name="GET_CONS_CAT" datasource="#DSN#">
			SELECT HIERARCHY FROM CONSUMER_CAT WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_min_cat.min_conscat_id#">
		</cfquery>
	<cfelse>
		<cfset get_cons_cat.recordcount = 0>
	</cfif>
	<!--- İlgili seviyede maximum seviyenin hierarsi degeri bulunur. BK 20120124 --->
	<cfif get_min_cat.recordcount and len(get_min_cat.max_conscat_id)>
		<cfquery name="GET_CONS_CAT2" datasource="#DSN#">
			SELECT HIERARCHY FROM CONSUMER_CAT WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_min_cat.max_conscat_id#">
		</cfquery>
	<cfelse>
		<cfset get_cons_cat2.recordcount = 0>
	</cfif>	
</cfif>
<cfquery name="GET_CONSUMERS" datasource="#DSN#">

	SELECT
        <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
            t1.acc,
            T1.acc_type_Id,
            T1.ACC_TYPE,
        </cfif>
		CONSUMER.FATHER,
		CONSUMER.TC_IDENTY_NO,
		CONSUMER.CONSUMER_ID,
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_USERNAME,
		CONSUMER.CONSUMER_SURNAME,		
		CONSUMER.COMPANY,
		CONSUMER.HOMEADDRESS,
		CONSUMER.HOME_COUNTRY_ID,
		CONSUMER.HOME_COUNTY_ID,
		CONSUMER.HOME_CITY_ID,
		CONSUMER.HOME_DISTRICT_ID,
		CONSUMER.HOMEPOSTCODE,
		CONSUMER.HOMESEMT,
		CONSUMER.TAX_ADRESS WORKADDRESS,
		CONSUMER.TAX_POSTCODE WORKPOSTCODE,
		CONSUMER.TAX_SEMT WORKSEMT,
		CONSUMER.TAX_COUNTY_ID WORK_COUNTY_ID,
		CONSUMER.TAX_CITY_ID WORK_CITY_ID,
		CONSUMER.TAX_COUNTRY_ID WORK_COUNTRY_ID,
		CONSUMER.TAX_DISTRICT_ID WORK_DISTRICT_ID,
		CONSUMER.MEMBER_CODE,
		CONSUMER.OZEL_KOD,
		CONSUMER.CONSUMER_EMAIL,
		CONSUMER.CONSUMER_WORKTELCODE,
		CONSUMER.CONSUMER_WORKTEL,
		CONSUMER.CONSUMER_HOMETELCODE,
		CONSUMER.CONSUMER_HOMETEL,
		CONSUMER.REF_POS_CODE,
		CONSUMER.CONSUMER_REFERENCE_CODE,
		CONSUMER.MOBIL_CODE,
		CONSUMER.MOBILTEL,
		CONSUMER.MOBIL_CODE_2,
		CONSUMER.MOBILTEL_2,
		CONSUMER.VOCATION_TYPE_ID,
		CONSUMER.TAX_OFFICE,
		CONSUMER.IMS_CODE_ID,
		CONSUMER.TAX_NO,
		CONSUMER.IMCAT_ID,
		CONSUMER.IM,
		CONSUMER.TITLE,
		CONSUMER.MISSION,
		CONSUMER.DEPARTMENT,
		CONSUMER.SEX,
		CONSUMER.CONSUMER_TEL_EXT,
		CONSUMER.CONSUMER_FAXCODE,
		CONSUMER.CONSUMER_FAX,
		CONSUMER.HOMEPAGE,
		CONSUMER.USE_EFATURA,
		GET_MY_CONSUMERCAT.CONSCAT
	FROM 
        <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
        (
		    SELECT ACC,
            CONSUMER_ID,
            CASE 
                WHEN acc_type_Id = 'ACCOUNT_CODE'
                THEN -1
                WHEN acc_type_Id = 'RECEIVED_GUARANTEE_ACCOUNT'
                THEN -6
                WHEN acc_type_Id = 'GIVEN_GUARANTEE_ACCOUNT'
                THEN -7
                WHEN acc_type_Id = 'RECEIVED_ADVANCE_ACCOUNT'
                THEN -4
                WHEN acc_type_Id = 'ADVANCE_PAYMENT_CODE'
                THEN -5
                WHEN acc_type_Id = 'KONSINYE_CODE'
                THEN -8
                WHEN acc_type_Id = 'SALES_ACCOUNT'
                THEN -2	
                WHEN acc_type_Id = 'PURCHASE_ACCOUNT'
                THEN -3
                    
                else -1
                end as ACC_TYPE_ID,
            CASE 
                WHEN acc_type_Id = 'ACCOUNT_CODE'
                THEN 'Standart Kayıt'
                WHEN acc_type_Id = 'RECEIVED_GUARANTEE_ACCOUNT'
                THEN 'Alınan Teminat Hesabı'
                WHEN acc_type_Id = 'GIVEN_GUARANTEE_ACCOUNT'
                THEN 'Verilen Teminat Hesabı'	
                WHEN acc_type_Id = 'RECEIVED_ADVANCE_ACCOUNT'
                THEN 'Alınan Avans Hesabı'
                WHEN acc_type_Id = 'ADVANCE_PAYMENT_CODE'
                THEN 'Verilen Avans Hesabı'	
                WHEN acc_type_Id = 'KONSINYE_CODE'
                THEN 'Konsinye Satış Hesabı'	
                WHEN acc_type_Id = 'SALES_ACCOUNT'
                THEN 'Satış Hesabı'		
                WHEN acc_type_Id = 'PURCHASE_ACCOUNT'
                THEN 'Alış Hesabı'	
                    
                else 'Standart Kayıt'
                end as ACC_TYPE
			FROM
			(
			  SELECT CONSUMER_ID, 
			  ACCOUNT_CODE,
				PERIOD_DATE,
				KONSINYE_CODE,
				ADVANCE_PAYMENT_CODE,
				SALES_ACCOUNT,
				PURCHASE_ACCOUNT,
				RECEIVED_GUARANTEE_ACCOUNT,
				GIVEN_GUARANTEE_ACCOUNT,
				RECEIVED_ADVANCE_ACCOUNT
				
			  FROM workcube_devcatalyst.CONSUMER_PERIOD
			  where PERIOD_ID = 5

			) AS cp
			UNPIVOT 
			(
			  acc FOR acc_type_Id IN (
				ACCOUNT_CODE,
				KONSINYE_CODE,
				ADVANCE_PAYMENT_CODE,
				SALES_ACCOUNT,
				PURCHASE_ACCOUNT,
				RECEIVED_GUARANTEE_ACCOUNT,
				GIVEN_GUARANTEE_ACCOUNT,
				RECEIVED_ADVANCE_ACCOUNT
				
			  )
			) AS up
			WHERE 
			ACC IS NOT NULL AND ACC <> ''
			) as t1
        JOIN   CONSUMER ON T1.CONSUMER_ID = CONSUMER.CONSUMER_ID
        <cfelse>
             CONSUMER
        </cfif>
		JOIN GET_MY_CONSUMERCAT ON CONSUMER.CONSUMER_CAT_ID = GET_MY_CONSUMERCAT.CONSCAT_ID  
        <cfif isdefined("session.ep.userid")>AND GET_MY_CONSUMERCAT.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"></cfif> AND GET_MY_CONSUMERCAT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_company_id#">
	WHERE
        1 = 1
		<cfif isDefined("attributes.type") and attributes.type eq 2>
            AND CONSUMER.HIERARCHY_ID = <cfif isdefined("session.ww.our_company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"></cfif> 
            AND CONSUMER_CAT.IS_INTERNET = 1
		<cfelse>	
			<cfif not IsDefined("attributes.account_period")>
                <cfif (isdefined("attributes.period_id") and len(attributes.period_id))<!--- Dönemden bağımsız bireysel üye isteği üzerine kapatıldı. PY  or (isdefined("attributes.period_id") and isdefined("period_id_list") and len(period_id_list))--->>
                    AND CONSUMER.CONSUMER_ID IN (
                                                    SELECT
                                                        CP.CONSUMER_ID
                                                    FROM
                                                        CONSUMER_PERIOD CP
                                                    WHERE
                                                        CONSUMER.CONSUMER_ID = CP.CONSUMER_ID AND
                                                        <cfif isdefined('attributes.period_id') and len(attributes.period_id) and listgetat(attributes.period_id,1,';') eq 1>
                                                            CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.period_id,3,';')#">
                                                        <cfelseif isdefined('attributes.period_id') and len(attributes.period_id)>
                                                            CP.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.period_id,2,';')#">)
                                                        <cfelse>
                                                            CP.PERIOD_ID IN (#period_id_list#)
                                                        </cfif>
                                                )
                </cfif>
			</cfif>
            <cfif isdefined("attributes.pos_code") and isdefined("attributes.pos_code_text") and len(attributes.pos_code) and len(attributes.pos_code_text)>
                AND CONSUMER.CONSUMER_ID IN (
                                        SELECT 
                                            CONSUMER_ID
                                         FROM 
                                            WORKGROUP_EMP_PAR 
                                         WHERE 
                                            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND
                                            IS_MASTER = 1 AND
                                            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_company_id#"> AND
                                            CONSUMER_ID IS NOT NULL
                                        ) 
            </cfif>			
            <cfif isDefined("attributes.search_status") and len(attributes.search_status)>AND CONSUMER.CONSUMER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_status#"></cfif>	
            <cfif isDefined("attributes.type") and (attributes.type eq 0) and isDefined("attributes.search_status") and attributes.search_status neq 0>
                AND CONSUMER.ISPOTANTIAL = 0
            <cfelseif isDefined("attributes.type") and (attributes.type eq 1)>
                AND CONSUMER.ISPOTANTIAL = 1
            </cfif>
            <cfif isDefined("get_consumer_cat")>
                <cfif get_consumer_cat.recordcount>
                    AND CONSUMER.CONSUMER_CAT_ID IN (#valuelist(get_consumer_cat.conscat_id,',')#) 
                <cfelse>
                    AND 1 = 2<!--- Hicbir kategori yoksa o uye gelmemeli FBS 20120627 --->
                </cfif>
            </cfif>
            <cfif isDefined('attributes.is_my_extre_page') and is_my_extre_page eq 1 > <!--- Bu popup My Extre sayfasından geliyorsa, sadece temsilcisi olunan kurumsal üyeleri göstersin CD20140929 --->
                AND CONSUMER_ID IN (
                                        SELECT 
                                            CONSUMER_ID
                                         FROM 
                                            WORKGROUP_EMP_PAR 
                                         WHERE 
                                            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                            IS_MASTER = 1 AND
                                            CONSUMER_ID IS NOT NULL
                                        ) 
            </cfif>
            <cfif isdefined('analysis_consumers') and len(analysis_consumers)> <!---20131211--->
                AND CONSUMER.CONSUMER_CAT_ID IN (#analysis_consumers#)
            <cfelseif isdefined('analysis_consumers') and not len(analysis_consumers)>
                AND 1 = 2
            </cfif>
            <cfif isDefined("attributes.consumer_cat") and Len(attributes.consumer_cat)>
                AND CONSUMER.CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_cat#">
            </cfif>
            <cfif isDefined("attributes.cons_ids")>
                AND CONSUMER.CONSUMER_ID IN (#attributes.cons_ids#)
            </cfif>
            <cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
                <cfif len(attributes.keyword) eq 1>
                    AND CONSUMER.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                <cfelse>
                    AND 
                    (
                        
                        CONSUMER_NAME + ' ' + CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR                          
                        CONSUMER.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        CONSUMER.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
                        CONSUMER.COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        CONSUMER.MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR 
                        CONSUMER.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                    )
                </cfif>
            </cfif>
            <cfif isdefined("attributes.identity_no") and len(attributes.identity_no)>
                AND CONSUMER.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.identity_no#"> 
            </cfif>
            <cfif  isDefined("attributes.var_new") and  attributes.var_new eq "invoice_bill">
                AND CONSUMER.IS_CARI = 1
                AND CONSUMER.ISPOTANTIAL = 0
            </cfif>
            <cfif isdefined("attributes.consumer_cat") and len(attributes.consumer_cat)>
                AND CONSUMER.CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_cat#">
            </cfif>
            <cfif isdefined("attributes.ref_code") and len(attributes.ref_code) and len(attributes.ref_code_name)> AND CONSUMER.REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ref_code#"></cfif>
            <cfif isdefined("attributes.is_store_module") and get_ourcmp_info.is_store_followup eq 1>
                AND CONSUMER.CONSUMER_ID IN 
                (
                    SELECT 
                        COMPANY_BRANCH_RELATED.CONSUMER_ID
                    FROM 
                        EMPLOYEE_POSITION_BRANCHES,
                        COMPANY_BRANCH_RELATED
                    WHERE
                        COMPANY_BRANCH_RELATED.CONSUMER_ID IS NOT NULL AND
                        EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                        EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
                        COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL
                )
            </cfif>
            <cfif isdefined("attributes.kontrol_conscat_id") and len(attributes.kontrol_conscat_id)>
                <cfif get_cons_cat2.recordcount and len(get_cons_cat2.hierarchy)>
                    AND ISNULL(CONSUMER_CAT.HIERARCHY,0) >= #get_cons_cat.hierarchy#
                </cfif>
                <!--- BK ekledi max seviye icin 20120124 --->
                <cfif get_cons_cat2.recordcount and len(get_cons_cat2.hierarchy)>
                    AND ISNULL(CONSUMER_CAT.HIERARCHY,0) <= #get_cons_cat2.hierarchy#
                </cfif>
            </cfif>
            <cfif isdefined('session.ep.our_company_info.sales_zone_followup') and session.ep.our_company_info.sales_zone_followup eq 1>
                <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
                AND 
                (
                    CONSUMER.IMS_CODE_ID IN (
                                                SELECT
                                                    IMS_ID
                                                FROM
                                                    SALES_ZONES_ALL_2
                                                WHERE
                                                    POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
                                                    AND (CONSUMER_CAT_IDS IS NULL OR (CONSUMER_CAT_IDS IS NOT NULL AND ','+CONSUMER_CAT_IDS+',' LIKE '%,'+CAST(CONSUMER.CONSUMER_CAT_ID AS NVARCHAR)+',%'))
                                             )
                    <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                    <cfif get_hierarchies.recordcount>
                        OR CONSUMER.IMS_CODE_ID IN (
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
                                                                        <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
                                                                    </cfloop>                                                                
                                                                )
                                                                <cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>							
                                                            </cfloop>											
                                                    )
                    </cfif>						
                )
            </cfif>
        </cfif>
        
    </cfquery>
