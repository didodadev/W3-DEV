<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
        <!--- <cfargument name="startRow" default="1">
        <cfargument name="maxRows" default="20"> --->
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>
			<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
				SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = #session.ep.position_code#
			</cfquery>
			<cfset row_block = 500>
		</cfif>
		<cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
			SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
		</cfquery>
		<cfquery name="getCompany_" datasource="#DSN#">
<cfparam name="attributes.returnInputValue" default="company_id,consumer_id,partner_id,partner_name,company,member_type"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="COMPANY_ID,CONSUMER_ID,PARTNER_ID,PARTNER_NAME,COMPANY_NAME,MEMBER_TYPE"><!--- queryden gönderilecek değerler.. --->

			SELECT DISTINCT
				'' AS CONSUMER_ID,
				'Partner' AS MEMBER_TYPE,
				CP.PARTNER_ID,
				CP.COMPANY_PARTNER_NAME COMPANY_PARTNER_NAME,
				CP.COMPANY_PARTNER_SURNAME,
				(CP.COMPANY_PARTNER_NAME +' ' + CP.COMPANY_PARTNER_SURNAME) AS PARTNER_NAME,
				CP.COMPANY_PARTNER_EMAIL,
				CP.MISSION, 
				C.FULLNAME FULLNAME,
				C.NICKNAME AS COMPANY_NAME,
				C.COMPANY_ID,
				CC.COMPANYCAT,
				CC.COMPANYCAT_ID,
				C.COMPANY_POSTCODE,
				C.COMPANY_ADDRESS,
				C.SEMT,
				C.COUNTY,
				C.CITY,
				C.COUNTRY,
				C.MEMBER_CODE,
				C.OZEL_KOD,
				C.SALES_COUNTY,
				C.COMPANY_EMAIL,
				C.COMPANY_TELCODE,
				C.COMPANY_TEL1,
				C.COMPANY_VALUE_ID
			FROM 
				COMPANY C,
				COMPANY_PARTNER CP,
				COMPANY_CAT CC
			  <cfif isdefined("arguments.is_store_module") and get_ourcmp_info.is_store_followup eq 1>
				,COMPANY_BRANCH_RELATED CBR
			  </cfif>
			  <cfif (isdefined("arguments.period_id") and len(arguments.period_id)) or (isdefined("period_id_list") and len(period_id_list))>
				,COMPANY_PERIOD CPE
			  </cfif>
			WHERE
				C.COMPANY_STATUS = 1 AND
				CP.COMPANY_PARTNER_STATUS = 1 AND
				CP.COMPANY_ID = C.COMPANY_ID AND
				CC.COMPANYCAT_ID = C.COMPANYCAT_ID
			<cfif (isdefined("arguments.period_id") and len(arguments.period_id)) or (isdefined("period_id_list") and len(period_id_list))>
				AND CPE.COMPANY_ID = C.COMPANY_ID
			  <cfif isdefined('arguments.period_id') and len(arguments.period_id) and listgetat(arguments.period_id,2,',') eq 1>
				AND CPE.PERIOD_ID = #listgetat(arguments.period_id,4,',')#
			  <cfelseif isdefined('arguments.period_id') and len(arguments.period_id)>
				AND CPE.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(arguments.period_id,3,',')#)
			  <cfelse>
				AND CPE.PERIOD_ID IN (#period_id_list#)
			  </cfif>
			</cfif>
			<!--- <cfif get_comp_cat.recordcount> --->
				AND C.COMPANYCAT_ID IN (
											SELECT 
												DISTINCT
												CT.COMPANYCAT_ID
											FROM
												COMPANY_CAT CT,
												COMPANY_CAT_OUR_COMPANY CO
											WHERE
												CT.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
												CO.OUR_COMPANY_ID IN (SELECT DISTINCT	SP.OUR_COMPANY_ID
																		FROM
																			EMPLOYEE_POSITIONS EP,
																			SETUP_PERIOD SP,
																			EMPLOYEE_POSITION_PERIODS EPP,
																			OUR_COMPANY O
																		WHERE 
																			SP.OUR_COMPANY_ID = O.COMP_ID AND
																			SP.PERIOD_ID = EPP.PERIOD_ID AND
																			EP.POSITION_ID = EPP.POSITION_ID AND
																			EP.EMPLOYEE_ID = #session.ep.userid#)
						) 
			<!--- </cfif> --->
			<cfif isDefined("arguments.company_id") and len(arguments.company_id)>
				AND CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> 
			</cfif>
			<cfif isdefined("arguments.city_name") and len(arguments.city_name)>
				AND C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_name#"> 
			</cfif>
			<cfif isDefined("arguments.is_buyer_seller") and (arguments.is_buyer_seller eq 0)>
				AND C.IS_BUYER = 1 
			<cfelseif isDefined("arguments.is_buyer_seller") and (arguments.is_buyer_seller eq 1)>
				AND C.IS_SELLER = 1 
			</cfif>
			<cfif isDefined("arguments.companycat_id") and len(arguments.companycat_id)>
				AND C.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companycat_id#"> 
			</cfif>
			<cfif isDefined("arguments.type") and (arguments.type eq 1)>
				AND C.ISPOTANTIAL = 1 
			<cfelseif isDefined("arguments.type") and (arguments.type eq 0)>
				AND C.ISPOTANTIAL = 0 
			</cfif>
			<cfif isdefined('arguments.keyword') and len(arguments.keyword) and len(arguments.keyword) eq 1>
				AND
				(
					C.FULLNAME LIKE '#arguments.keyword#%' OR
					C.NICKNAME LIKE '#arguments.keyword#%'
				)
			<cfelseif isdefined('arguments.keyword') and len(arguments.keyword)>
				AND
				(	
					C.FULLNAME LIKE '#arguments.keyword#%' OR
					C.NICKNAME LIKE '#arguments.keyword#%' OR
					C.OZEL_KOD LIKE '#arguments.keyword#%' OR
					C.MEMBER_CODE LIKE '#arguments.keyword#%'
				)
			</cfif>
			<cfif isdefined('arguments.keyword_partner') and len(arguments.keyword_partner)>
			  <cfif (database_type is 'MSSQL')>
				AND CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(arguments.keyword_partner) gt 1>%</cfif>#arguments.keyword_partner#%' 
			  <cfelseif (database_type is 'DB2')>
				AND CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(arguments.keyword_partner) gt 1>%</cfif>#arguments.keyword_partner#%'
			  </cfif>
			</cfif>
			<cfif isDefined('arguments.sector_cat_id') and len(arguments.sector_cat_id)>
				AND C.SECTOR_CAT_ID = #arguments.sector_cat_id#
			</cfif>
			<cfif isDefined('arguments.comp_cat') and len(arguments.comp_cat)>
				AND C.COMPANYCAT_ID =#arguments.comp_cat#
			</cfif>
			<cfif isDefined('arguments.sales_zones') and len(arguments.sales_zones)>
				AND C.SALES_COUNTY = #arguments.sales_zones#
			</cfif>
			<cfif isDefined('arguments.customer_value') and len(arguments.customer_value)>
				AND C.COMPANY_VALUE_ID = #arguments.customer_value#
			</cfif>
			<cfif isdefined("arguments.is_store_module") and get_ourcmp_info.is_store_followup eq 1>
				AND CBR.COMPANY_ID = C.COMPANY_ID
				AND CBR.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->
				AND CBR.BRANCH_ID IN 
									(
										SELECT 
											BRANCH.BRANCH_ID
										FROM 
											BRANCH, 
											EMPLOYEE_POSITION_BRANCHES
										WHERE 
											EMPLOYEE_POSITION_BRANCHES.POSITION_CODE =#session.ep.position_code# AND
											EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID
									) 
			</cfif>
			<cfif isdefined("arguments.pos_code") and isdefined("arguments.pos_code_text") and len(arguments.pos_code) and len(arguments.pos_code_text)>
				AND C.COMPANY_ID IN (
										SELECT 
											COMPANY_ID
										 FROM 
											WORKGROUP_EMP_PAR 
										 WHERE 
											POSITION_CODE =#arguments.pos_code# AND
											IS_MASTER = 1 AND
											OUR_COMPANY_ID =#session.ep.company_id# AND
											COMPANY_ID IS NOT NULL
										) 
			</cfif>			
			<cfif session.ep.our_company_info.sales_zone_followup eq 1>
				<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
				AND 
				(
					C.IMS_CODE_ID IN (
										SELECT
											IMS_ID
										FROM
											SALES_ZONES_ALL_2
										WHERE
											POSITION_CODE = #session.ep.position_code#
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
														<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
													</cfloop>
													
													)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
											</cfloop>											
									)
				  </cfif>						
				)
			</cfif>
		
		<cfif not (isdefined('arguments.keyword_partner') and len(arguments.keyword_partner))>
			UNION ALL
			SELECT DISTINCT
				'' AS CONSUMER_ID,
				'Partner' AS MEMBER_TYPE,
				-1 AS PARTNER_ID, 
				'' AS COMPANY_PARTNER_NAME, 
				'' AS COMPANY_PARTNER_SURNAME, 
				'' AS PARTNER_NAME,
				'' AS COMPANY_PARTNER_EMAIL, 
				-1 AS MISSION, 
				C.FULLNAME FULLNAME,
				C.NICKNAME,
				C.COMPANY_ID,
				CC.COMPANYCAT,
				CC.COMPANYCAT_ID,
				C.COMPANY_POSTCODE,
				C.COMPANY_ADDRESS,
				C.SEMT,
				C.COUNTY,
				C.CITY,
				C.COUNTRY,
				C.MEMBER_CODE,
				C.OZEL_KOD,
				C.SALES_COUNTY,
				C.COMPANY_EMAIL,
				C.COMPANY_TELCODE,
				C.COMPANY_TEL1,
				C.COMPANY_VALUE_ID
			FROM 
				COMPANY C,
				COMPANY_CAT CC
			  <cfif isdefined("arguments.is_store_module") and get_ourcmp_info.is_store_followup eq 1>
				,COMPANY_BRANCH_RELATED CBR
			  </cfif>
			  <cfif (isdefined("arguments.period_id") and len(arguments.period_id)) or (isdefined("period_id_list") and len(period_id_list))>
				,COMPANY_PERIOD CPE
			  </cfif>
			WHERE
				C.COMPANY_ID NOT IN (SELECT COMPANY_ID FROM COMPANY_PARTNER) AND
				CC.COMPANYCAT_ID = C.COMPANYCAT_ID
				
			<cfif (isdefined("arguments.period_id") and len(arguments.period_id)) or (isdefined("period_id_list") and len(period_id_list))>
				AND CPE.COMPANY_ID = C.COMPANY_ID
			  <cfif isdefined('arguments.period_id') and len(arguments.period_id) and listgetat(arguments.period_id,2,',') eq 1>
				AND CPE.PERIOD_ID =#listgetat(arguments.period_id,4,',')#
			  <cfelseif isdefined('arguments.period_id') and len(arguments.period_id)>
				AND CPE.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(arguments.period_id,3,',')#)
			  <cfelse>
				AND CPE.PERIOD_ID IN (#period_id_list#)
			  </cfif>
			</cfif>		
			<cfif isDefined("arguments.company_id")>
				AND C.COMPANY_ID =#arguments.company_id# 
			</cfif>
			<cfif isdefined("arguments.city_name") and len(arguments.city_name)>
				AND C.CITY =#arguments.city_name#
			</cfif>
			<cfif isDefined("arguments.is_buyer_seller") and (arguments.is_buyer_seller eq 0)>
				AND C.IS_BUYER = 1 
			<cfelseif isDefined("arguments.is_buyer_seller") and (arguments.is_buyer_seller eq 1)>
				AND C.IS_SELLER = 1 
			</cfif>
			<cfif isDefined("arguments.type") and (arguments.type eq 1)>
				AND C.ISPOTANTIAL = 1 
			<cfelseif isDefined("arguments.type") and (arguments.type eq 0)>
				AND C.ISPOTANTIAL = 0 
			</cfif>
			<cfif len(arguments.keyword) and len(arguments.keyword) eq 1>
				AND
				(
					C.FULLNAME LIKE '#arguments.keyword#%' OR
					C.NICKNAME LIKE '#arguments.keyword#%'
				)
			<cfelseif len(arguments.keyword)>
				AND
				(
					C.FULLNAME LIKE '#arguments.keyword#%' OR
					C.NICKNAME LIKE '#arguments.keyword#%' OR
					C.OZEL_KOD LIKE '#arguments.keyword#%' OR
					C.MEMBER_CODE LIKE '#arguments.keyword#%'
				)
			</cfif>
			<cfif isDefined('arguments.sector_cat_id') and len(arguments.sector_cat_id)>
				AND C.SECTOR_CAT_ID =#arguments.sector_cat_id#
			</cfif>
			<cfif isDefined('arguments.comp_cat') and len(arguments.comp_cat)>
				AND C.COMPANYCAT_ID = #arguments.comp_cat#
			</cfif>
			<cfif isDefined('arguments.sales_zones') and len(arguments.sales_zones)>
				AND C.SALES_COUNTY = #arguments.sales_zones#
			</cfif>
			<cfif session.ep.our_company_info.sales_zone_followup eq 1>
				<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
				AND 
				(
					C.IMS_CODE_ID IN (
										SELECT
											IMS_ID
										FROM
											SALES_ZONES_ALL_2
										WHERE
											POSITION_CODE =#session.ep.position_code#
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
														<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
													</cfloop>
													
													)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
											</cfloop>											
									)
				  </cfif>						
				)
			</cfif>
		
			<cfif isDefined('arguments.customer_value') and len(arguments.customer_value)>
				AND C.COMPANY_VALUE_ID =#arguments.customer_value#
			</cfif>
			<cfif isdefined("arguments.is_store_module") and get_ourcmp_info.is_store_followup eq 1>
				AND CBR.COMPANY_ID = C.COMPANY_ID
				AND CBR.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->
				AND CBR.BRANCH_ID IN 
										(
											SELECT 
												BRANCH.BRANCH_ID
											FROM 
												BRANCH, 
												EMPLOYEE_POSITION_BRANCHES
											WHERE 
												EMPLOYEE_POSITION_BRANCHES.POSITION_CODE =#session.ep.position_code# AND
												EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID
										)
			</cfif>
			<cfif isdefined("arguments.pos_code") and isdefined("arguments.pos_code_text") and len(arguments.pos_code) and len(arguments.pos_code_text)>
				AND C.COMPANY_ID IN 
									(
										SELECT 
											COMPANY_ID
										FROM 
											WORKGROUP_EMP_PAR 
										WHERE 
											POSITION_CODE = #arguments.pos_code# AND
											IS_MASTER = 1 AND
											OUR_COMPANY_ID =#session.ep.company_id# AND
											COMPANY_ID IS NOT NULL
									)
			</cfif>	
		</cfif>
			ORDER BY
				C.FULLNAME,
				CP.COMPANY_PARTNER_NAME
		</cfquery>	  
        <cfreturn getCompany_>
    </cffunction>
</cfcomponent>

