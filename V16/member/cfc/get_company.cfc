<cffunction name="get_company_list_fnc" returntype="query">
	<cfargument name="cpid" default="">
	<cfargument name="row_block" default="">
	<cfargument name="get_hierarchies_recordcount" default="0">
	<cfargument name="is_store_followup" default="">
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfif session.ep.our_company_info.sales_zone_followup eq 1>
		<cfquery name="GET_HIERARCHIES" datasource="#this.DSN#">
			SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
	</cfif>
	<cfquery name="GET_COMPANY" datasource="#this.DSN#">
		SELECT
			C.*,
            C.VISIT_CAT_ID
		FROM
			COMPANY C WITH (NOLOCK)
		<cfif session.ep.isBranchAuthorization and is_store_followup eq 1>
			,COMPANY_BRANCH_RELATED
		</cfif>
		WHERE
			C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cpid#">
			<cfif isdefined("company_cat_list") and len(company_cat_list)>
				AND C.COMPANYCAT_ID IN (#company_cat_list#)
			</cfif>
		  	<cfif session.ep.isBranchAuthorization and is_store_followup eq 1>
				AND COMPANY_BRANCH_RELATED.COMPANY_ID = C.COMPANY_ID
				AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL
				AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif session.ep.our_company_info.sales_zone_followup eq 1>
				<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
				AND ( C.IMS_CODE_ID IN ( SELECT IMS_ID FROM SALES_ZONES_ALL_2 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND (COMPANY_CAT_IDS IS NULL OR (COMPANY_CAT_IDS IS NOT NULL AND ','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(C.COMPANYCAT_ID AS NVARCHAR)+',%')))
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
	<cfargument name="is_sale_purchase" default="">
	<cfargument name="keyword_partner" default="">
	<cfargument name="database_type" default="">
	<cfargument name="get_companycat_companycat_id" default="">	
	<cfargument name="startrow" default="1">
	<cfargument name="maxrows" default="#session.ep.maxrows#">
    <cfargument name="is_fulltext_search" default="">
    <cfargument name="use_efatura" default="">
    <cfargument name="tax_no" default="">
    <cfargument name="tc_identity" default="">
	<cfargument name="private_code" default="">
	<cfif session.ep.our_company_info.sales_zone_followup eq 1>
		<cfquery name="GET_HIERARCHIES" datasource="#this.DSN#">
			SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
	</cfif>	
	<cfquery name="GET_COMPANY" datasource="#this.DSN#">
	WITH CTE1 AS(	
		SELECT
			<cfif (len(period_id) and (listgetat(period_id,2,',') eq 0)) or session.ep.isBranchAuthorization and is_store_followup eq 1>DISTINCT</cfif>
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
					OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
					COMPANY_ID = COMPANY.COMPANY_ID AND
					COMPANY_ID IS NOT NULL
			) POSITION_CODE
		FROM
			<cfif len(keyword_partner) or len(tc_identity)>COMPANY_PARTNER WITH (NOLOCK),</cfif>
			<cfif session.ep.isBranchAuthorization and is_store_followup eq 1>COMPANY_BRANCH_RELATED WITH (NOLOCK),</cfif>
			<cfif isDefined('responsible_branch_id') and len(responsible_branch_id)>SALES_ZONES WITH (NOLOCK),</cfif>
			<cfif len(period_id)>COMPANY_PERIOD WITH (NOLOCK),</cfif>
			COMPANY WITH (NOLOCK)
		WHERE
			COMPANY.COMPANY_ID IS NOT NULL
			 <cfif session.ep.isBranchAuthorization and is_store_followup eq 1>
				AND COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID
				AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL
				AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (#ListGetAt(session.ep.user_location,2,'-')#)
				AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isdefined("blacklist_status") and len(blacklist_status)>
			AND COMPANY.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_CREDIT WHERE IS_BLACKLIST = 1)
			</cfif>
			<cfif get_companycat_recordcount>
				AND COMPANY.COMPANYCAT_ID IN (#get_companycat_companycat_id#)
			<cfelse>
				AND COMPANY.COMPANYCAT_ID IS NULL
			</cfif>
            <cfif len(tax_no)>
            	AND COMPANY.TAXNO LIKE   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_no#%">
            </cfif>
			<cfif len(period_id)>
				AND COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID
				<cfif listgetat(period_id,2,',') eq 1>
					AND COMPANY_PERIOD.PERIOD_ID = #listgetat(period_id,4,',')#
				<cfelse>
					AND COMPANY_PERIOD.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(period_id,3,',')#)
				</cfif>
			</cfif>
			<cfif isdefined("process_stage_type") and len(process_stage_type)>
				AND COMPANY.COMPANY_STATE = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_stage_type#">
			</cfif>
			<cfif len(record_emp) and len(record_name)>
				AND COMPANY.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_emp#">
			</cfif>
		  	<cfif isDefined("city") and len(city)>AND COMPANY.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#"></cfif>
		  	<cfif isDefined("sales_zones") and len(sales_zones)><!--- Kendisi ve alt kirilimlarinin da gelmesi icin --->
				<cfset sales_zones = replace(sales_zones,'_','')>
				AND COMPANY.SALES_COUNTY IN (SELECT SZ_ID FROM SALES_ZONES WHERE (SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#sales_zones#"> OR SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#sales_zones#.%">))
		  	</cfif>
            <cfif isDefined("sector_cat_id") and len(sector_cat_id)>
	            AND (
                        COMPANY.COMPANY_ID IN (
                        						SELECT 
                                                	COMPANY_ID 
                                                FROM 
                                                	COMPANY_SECTOR_RELATION CSR1 
                                                WHERE 
                                                	CSR1.SECTOR_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#sector_cat_id#">
                                             )
	                )
            </cfif>
		  	<cfif isDefined("pos_code") and len(pos_code) and len(pos_code_text)>
				AND COMPANY.COMPANY_ID IN 
				(SELECT COMPANY_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE= <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND IS_MASTER=1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND COMPANY_ID IS NOT NULL)
		  	</cfif>
		  	<cfif isDefined("search_potential") and len(search_potential)>AND COMPANY.ISPOTANTIAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#search_potential#"></cfif>
		  	<cfif isDefined("is_related_company") and len(is_related_company)>AND COMPANY.IS_RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="#is_related_company#"></cfif>
		  	<cfif isDefined("comp_cat") and len(comp_cat)>AND COMPANY.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_cat#"></cfif>
		  	<cfif isDefined('search_status') and len(search_status)>AND COMPANY.COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#search_status#"></cfif>
		  	<cfif isdefined("customer_value") and len(customer_value)> AND COMPANY.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#customer_value#"></cfif>
		  	<cfif isdefined('country_id') and len(country_id)>AND COMPANY.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#country_id#"></cfif>
		  	<cfif isdefined('city_id') and len(city_id)>AND COMPANY.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#city_id#"></cfif>
		  	<cfif isdefined('county_id') and len(county_id)>AND COMPANY.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#county_id#"></cfif>
		  	<cfif isDefined('keyword') and len(keyword)>
				
				
				<cfif isdefined("is_fulltext_search") and is_fulltext_search eq 1 >
					AND CONTAINS(COMPANY.*,'"#keyword#*"')
				<cfelse>
							AND
						(
							<cfif len(keyword) gt 2>
								COMPANY.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.OZEL_KOD_1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.OZEL_KOD_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI	
							<cfelse>
								COMPANY.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.OZEL_KOD_1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.OZEL_KOD_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
								COMPANY.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
							</cfif>
						)
				</cfif>
		  	</cfif>
			<cfif isdefined('private_code') and len (private_code)>
				AND COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#private_code#%">
			</cfif>
		  	<cfif isDefined('is_sale_purchase') and is_sale_purchase is 1>
				AND COMPANY.IS_BUYER = 1
		  	<cfelseif isDefined('is_sale_purchase') and is_sale_purchase is 2>
				AND COMPANY.IS_SELLER = 1
		  	</cfif>
		  	<cfif len(keyword_partner) or len(tc_identity)>
				AND COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID 
				AND (
                	<cfif len(keyword_partner)>
                        (COMPANY_PARTNER.TITLE LIKE '<cfif len(keyword_partner) gt 1>%</cfif>#keyword_partner#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '<cfif len(keyword_partner) gt 1>%</cfif>#keyword_partner#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
 						<cfif len(tc_identity)>
                      		<cfif len(keyword_partner)> AND </cfif>COMPANY_PARTNER.TC_IDENTITY LIKE '<cfif len(tc_identity) gt 1>%</cfif>#tc_identity#%'
                    	</cfif>
                    <cfelseif len(tc_identity)>
                    	  COMPANY_PARTNER.TC_IDENTITY LIKE '<cfif len(tc_identity) gt 1>%</cfif>#tc_identity#%'                    
                    </cfif>
                   
                    )                    
			</cfif>
			<cfif session.ep.our_company_info.sales_zone_followup eq 1>
	
				<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
				AND (COMPANY.IMS_CODE_ID IN ( 
					SELECT
						 IMS_ID 
					FROM 
						SALES_ZONES_ALL_2
					 WHERE 
						POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">  
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
            <cfif len(use_efatura)>
            	AND COMPANY.USE_EFATURA = <cfqueryparam cfsqltype="cf_sql_smallint" value="#use_efatura#">
            </cfif>
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
