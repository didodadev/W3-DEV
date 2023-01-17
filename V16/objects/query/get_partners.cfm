<!---20131112--->
<cfif isdefined('analysis_id') and len(analysis_id)>
	<cfquery name="get_analysis_partners" datasource="#DSN#">
		SELECT ANALYSIS_PARTNERS FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#analysis_id#">
	</cfquery>
	<cfset analysis_partners = listdeleteduplicates(valuelist(get_analysis_partners.analysis_partners,','))>
</cfif>
<!---20131112--->
<cfif isdefined('session.ep.our_company_info.sales_zone_followup') and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
		SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfset row_block = 500>
</cfif>
<cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
	SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE <cfif isdefined('session.ep.company_id')>COMP_ID = #session.ep.company_id#<cfelseif isdefined('session.pp.our_company_id')>COMP_ID = #session.pp.our_company_id#</cfif>
</cfquery>
<cfquery name="GET_PARTNERS" datasource="#DSN#">
	WITH CTE1 AS(
	SELECT
		<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
			t1.acc,
			T1.acc_type_Id,
			T1.ACC_TYPE,
		</cfif>
		CP.PARTNER_ID,
		CP.COMPANY_PARTNER_NAME COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME,
		CP.COMPANY_PARTNER_EMAIL,
		CP.MISSION,
		C.FULLNAME FULLNAME,
		C.NICKNAME,
		C.COMPANY_ID,
		CC.COMPANYCAT,
		CC.COMPANYCAT_ID,
		<cfif isdefined("attributes.is_partner_address_") and attributes.is_partner_address_ eq 1>
			CP.COMPANY_PARTNER_POSTCODE COMPANY_POSTCODE,
			CP.COMPANY_PARTNER_ADDRESS COMPANY_ADDRESS,
			CP.SEMT SEMT,
			CP.COUNTY COUNTY,
			CP.CITY CITY,
			CP.COUNTRY COUNTRY,
		<cfelse>
			C.COMPANY_POSTCODE,
			C.COMPANY_ADDRESS,
			C.SEMT,
			C.COUNTY,
			C.CITY,
			C.COUNTRY,
		</cfif>
		C.MEMBER_CODE,
		C.OZEL_KOD,
        C.OZEL_KOD_1,
        C.OZEL_KOD_2,
		C.SALES_COUNTY,
		C.COMPANY_EMAIL,
		C.COMPANY_TELCODE,
		C.COMPANY_TEL1,
		C.IMS_CODE_ID,
		C.COMPANY_VALUE_ID,
        C.TAXOFFICE,
        C.TAXNO,
		C.USE_EFATURA
		<cfif isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and xml_is_bakiye>
			,CRM.BAKIYE
		</cfif>
	FROM 
		<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
			(
			SELECT ACC,
					COMPANY_ID,
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
						<!---WHEN acc_type_Id = 'EXPORT_REGISTERED_SALES_ACCOUNT'
						THEN 'İhraç Kayıtlı Satış Hesabı'	
						WHEN acc_type_Id = 'EXPORT_REGISTERED_BUY_ACCOUNT'
						THEN 'İhraç Kayıtlı Alış Hesabı'--->	
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
						<!---WHEN acc_type_Id = 'EXPORT_REGISTERED_SALES_ACCOUNT'
						THEN 'İhraç Kayıtlı Satış Hesabı'	
						WHEN acc_type_Id = 'EXPORT_REGISTERED_BUY_ACCOUNT'
						THEN 'İhraç Kayıtlı Alış Hesabı'--->	
						else 'Standart Kayıt'
						end as ACC_TYPE
			FROM
			(
			  SELECT COMPANY_ID, 
			  ACCOUNT_CODE,
				PERIOD_DATE,
				KONSINYE_CODE,
				ADVANCE_PAYMENT_CODE,
				SALES_ACCOUNT,
				PURCHASE_ACCOUNT,
				RECEIVED_GUARANTEE_ACCOUNT,
				GIVEN_GUARANTEE_ACCOUNT,
				RECEIVED_ADVANCE_ACCOUNT
				<!---,EXPORT_REGISTERED_SALES_ACCOUNT,
				EXPORT_REGISTERED_BUY_ACCOUNT--->
			  FROM COMPANY_PERIOD
			  where PERIOD_ID = #session.ep.period_id#

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
				<!---,EXPORT_REGISTERED_SALES_ACCOUNT,
				EXPORT_REGISTERED_BUY_ACCOUNT--->
			  )
			) AS up
			WHERE 
			ACC IS NOT NULL AND ACC <> ''
			) as t1
			JOIN COMPANY C ON T1.COMPANY_ID = C.COMPANY_ID
		<cfelse>
			COMPANY C
		</cfif>
		JOIN COMPANY_PARTNER CP ON CP.COMPANY_ID = C.COMPANY_ID 
		JOIN COMPANY_CAT CC ON CC.COMPANYCAT_ID = C.COMPANYCAT_ID
		<cfif isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and xml_is_bakiye>
			LEFT JOIN #dsn2_alias#.COMPANY_REMAINDER CRM ON C.COMPANY_ID = CRM.COMPANY_ID
		</cfif>
		<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)><!--- //marinturk icin silmeyin. FA --->
			,RELATION_ASSETP_MEMBER RAM
		</cfif>
		<cfif isdefined("attributes.is_store_module") and get_ourcmp_info.is_store_followup eq 1>
			,COMPANY_BRANCH_RELATED CBR
		</cfif>
	WHERE
		1 = 1 
		<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)><!--- //marinturk icin silmeyin. FA --->
			AND C.COMPANY_ID = RAM.COMPANY_ID 
			AND RAM.ASSETP_ID = #attributes.assetp_id# 
		</cfif>
    	<cfif isdefined("attributes.search_status") and attributes.search_status eq 1>
			AND C.COMPANY_STATUS = 1 AND CP.COMPANY_PARTNER_STATUS = 1  
        <cfelseif isdefined("attributes.search_status") and attributes.search_status eq 0>
        	AND ((C.COMPANY_STATUS = 0 AND CP.COMPANY_PARTNER_STATUS = 0) OR (C.COMPANY_STATUS = 0 AND CP.COMPANY_PARTNER_STATUS = 1)) 
        </cfif>
		<cfif (isdefined("xml_is_cari_one_row") and xml_is_cari_one_row eq 2 and isdefined("is_cari_action") and is_cari_action eq 1) or (isdefined("xml_is_cari_one_row") and xml_is_cari_one_row eq 1)>
			AND CP.PARTNER_ID = C.MANAGER_PARTNER_ID 	
		<cfelse>
			AND CP.COMPANY_ID = C.COMPANY_ID 
		</cfif>
		<cfif IsDefined("attributes.product_cat_id") and len(attributes.product_cat_id)><!---xml' e bağlı olarak ürün kategori ile ilişkili olan carileri getir --->
			AND C.COMPANY_ID IN (
								SELECT 
									COMPANY_ID
								FROM
									WORKNET_RELATION_PRODUCT_CAT WPC,
									#DSN1#.PRODUCT_CAT PC
								WHERE
									PC.PRODUCT_CATID = WPC.PRODUCT_CATID AND
									PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat_hierarchy#%">
								)
		</cfif>
	<cfif not isdefined("attributes.is_company_info")>
		<cfif len(attributes.keyword_partner)>
			<cfif (database_type is 'MSSQL')>
                <cfif isdefined("is_fulltext_search") and is_fulltext_search  eq 1 >
                	AND CONTAINS(CP.*,'"#attributes.keyword_partner#*"')
				<cfelse>
                	AND CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%' 
				</cfif>
			<cfelseif (database_type is 'DB2')>
				AND CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%'
			</cfif>
		</cfif>
	<cfelse>
		AND CP.PARTNER_ID = C.MANAGER_PARTNER_ID
		<cfif len(attributes.keyword_partner)>
			AND C.COMPANY_ID IN(
									SELECT
										CPP.COMPANY_ID
									FROM
										COMPANY_PARTNER CPP
									WHERE
										<cfif (database_type is 'MSSQL')>
											CPP.COMPANY_PARTNER_NAME + ' ' + CPP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%' 
										<cfelseif (database_type is 'DB2')>
											CPP.COMPANY_PARTNER_NAME || ' ' || CPP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%'
										</cfif>
								)
		</cfif>
	</cfif>
	<cfif fusebox.use_period eq true and (not IsDefined("attributes.account_period"))>
        <cfif (isdefined("attributes.period_id") and len(attributes.period_id)) or (attributes.is_period_kontrol eq 1 and isdefined("period_id_list") and len(period_id_list))>
            AND C.COMPANY_ID IN (
                                    SELECT
                                        CPE.COMPANY_ID
                                    FROM
                                        COMPANY_PERIOD CPE
                                    WHERE
                                        C.COMPANY_ID = CPE.COMPANY_ID AND
                                        <cfif isdefined('attributes.period_id') and Len(attributes.period_id) and listgetat(attributes.period_id,1,';') eq 1>
                                            CPE.PERIOD_ID = #listgetat(attributes.period_id,3,';')#
                                        <cfelseif isdefined('attributes.period_id') and Len(attributes.period_id)>
                                            CPE.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(attributes.period_id,2,';')#)
                                        <cfelse>
                                            CPE.PERIOD_ID IN (#period_id_list#)
                                        </cfif>
                                )
        </cfif>
    </cfif>
	<cfif get_comp_cat.recordcount>
		AND C.COMPANYCAT_ID IN (#valuelist(get_comp_cat.companycat_id,',')#) 
	<cfelse>
		AND 1 = 2<!--- Hicbir kategori yoksa o uye gelmemeli FBS 20111122 --->
	</cfif>
    <cfif isdefined('analysis_partners') and len(analysis_partners)> <!---20131211--->
    	AND C.COMPANYCAT_ID IN (#analysis_partners#)
    <cfelseif isdefined('analysis_partners') and not len(analysis_partners)>
    	AND 1 = 2
    </cfif>
	<cfif isDefined("attributes.company_id")>
		AND CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
	</cfif>
	<cfif isDefined("attributes.acc_type") AND LEN(attributes.acc_type)>
		AND T1.ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ACC_TYPE#"> 
	</cfif>
	<cfif isDefined('attributes.comp_cat') and len(attributes.comp_cat)>
		AND C.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_cat#">
	</cfif>
	<cfif isdefined("attributes.city_name") and len(attributes.city_name)>
		AND C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_name#"> 
	</cfif>
	<cfif isDefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 0)>
		AND C.IS_BUYER = 1 
	<cfelseif isDefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 1)>
		AND C.IS_SELLER = 1 
	<cfelseif isDefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 2)>
		AND C.ISPOTANTIAL = 1 
	<cfelseif isDefined("attributes.is_potansiyel") and (attributes.is_potansiyel eq 0)>
		AND C.ISPOTANTIAL != 1 
	</cfif>
	<cfif len(attributes.tax_no)>
        AND C.TAXNO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#%">
    </cfif>
	<cfif len(attributes.keyword) and len(attributes.keyword) eq 1>
		AND
		(
        	<cfif isdefined("is_fulltext_search") and is_fulltext_search  eq 1 >
                CONTAINS (C.FULLNAME,'"#attributes.keyword#*"') OR  CONTAINS (C.NICKNAME,'"#attributes.keyword#*"')  
            <cfelse>
                C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
                C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
			</cfif>
        )
	<cfelseif len(attributes.keyword)>
		AND
		(	
			<cfif isdefined("is_fulltext_search") and is_fulltext_search  eq 1 >
                CONTAINS (C.*,'"#attributes.keyword#*"')
            <cfelse>
                C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">	
			</cfif>
        )
	</cfif>
	<cfif isDefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
		AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_SECTOR_RELATION WHERE SECTOR_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sector_cat_id#">)
	</cfif>
	<cfif isDefined('attributes.sales_zones') and len(attributes.sales_zones)>
		AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
	</cfif>
	<cfif isDefined('attributes.customer_value') and len(attributes.customer_value)>
		AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#"> 
	</cfif>
	<cfif isdefined("attributes.is_store_module") and get_ourcmp_info.is_store_followup eq 1>
		AND CBR.COMPANY_ID = C.COMPANY_ID
		AND CBR.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemek için --->
		AND CBR.BRANCH_ID = #Listgetat(session.ep.user_location,2,'-')#
		AND CBR.BRANCH_ID IN 
							(
								SELECT 
									BRANCH.BRANCH_ID
								FROM 
									BRANCH, 
									EMPLOYEE_POSITION_BRANCHES
								WHERE 
									EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
									EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID
							) 
	</cfif>
	<cfif isDefined('attributes.is_my_extre_page') and attributes.is_my_extre_page eq 1 > <!--- Bu popup My Extre sayfasından geliyorsa, sadece temsilcisi olunan kurumsal üyeleri göstersin CD20140929 --->
		AND C.COMPANY_ID IN (
								SELECT 
									COMPANY_ID
								 FROM 
									WORKGROUP_EMP_PAR 
								 WHERE 
									POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
									IS_MASTER = 1 AND
									<cfif isdefined('session.ep.company_id')>
										OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
									<cfelseif isdefined('session.pp.our_company_id')>
										OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
									</cfif>
									COMPANY_ID IS NOT NULL
								) 
	</cfif>
	<cfif isdefined("attributes.pos_code") and isdefined("attributes.pos_code_text") and len(attributes.pos_code) and len(attributes.pos_code_text)>
		AND C.COMPANY_ID IN (
								SELECT 
									COMPANY_ID
								 FROM 
									WORKGROUP_EMP_PAR 
								 WHERE 
									POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND
									IS_MASTER = 1 AND
									<cfif isdefined('session.ep.company_id')>
										OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
									<cfelseif isdefined('session.pp.our_company_id')>
										OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
									</cfif>
									COMPANY_ID IS NOT NULL
								) 
	</cfif>	
	<cfif isdefined("attributes.pos_code_new") and isdefined("attributes.pos_code_text_new") and len(attributes.pos_code_new) and len(attributes.pos_code_text_new)>
		AND C.COMPANY_ID IN (
								SELECT 
									COMPANY_ID
								 FROM 
									WORKGROUP_EMP_PAR 
								 WHERE 
									POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code_new#"> AND
									IS_MASTER = 1 AND
									<cfif isdefined('session.ep.company_id')>
										OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
									<cfelseif isdefined('session.pp.our_company_id')>
										OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
									</cfif>
									COMPANY_ID IS NOT NULL
								) 
	</cfif>
	<cfif isdefined('session.ep.our_company_info.sales_zone_followup') and session.ep.our_company_info.sales_zone_followup eq 1>
		<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
		AND 
		(
			C.IMS_CODE_ID IN (
								SELECT
									IMS_ID
								FROM
									SALES_ZONES_ALL_2
								WHERE
									POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
									AND (COMPANY_CAT_IDS IS NULL OR (COMPANY_CAT_IDS IS NOT NULL AND ','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(C.COMPANYCAT_ID AS NVARCHAR)+',%'))
							 )
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
												<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
											</cfloop>
											
											)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
									</cfloop>											
							)
		  </cfif>						
		)
	</cfif>
    <cfif (isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and xml_is_bakiye) and (isdefined("attributes.zero_bakiye") and xml_is_zero_bakiye)>	
		AND ROUND(CRM.BAKIYE,2) <> 0 
	</cfif>	
		)
	,CTE2 AS 
			(
			SELECT
					CTE1.*,
						ROW_NUMBER() OVER (ORDER BY  FULLNAME
						<cfif not isdefined("attributes.is_company_info")>
							,COMPANY_PARTNER_NAME
						</cfif>) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
					FROM
						CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)	
</cfquery>
