<cffunction name="get_consumer_list_fnc" returntype="query">
	<cfargument name="is_resource_id" default="">
	<cfargument name="is_record_member" default="">
	<cfargument name="is_customer_value" default="">
	<cfargument name="is_ref_pos_code" default="">
	<cfargument name="list_cons_cat_id" default="">
	<cfargument name="period_id" default="">
	<cfargument name="is_store_followup" default="">
	<cfargument name="member_branch" default="">
	<cfargument name="ref_pos_code" default="">
	<cfargument name="record_emp" default="">
	<cfargument name="customer_value" default="">
	<cfargument name="resource" default="">
	<cfargument name="process_stage_type" default="">
	<cfargument name="search_potential" default="">
	<cfargument name="search_status" default="">
	<cfargument name="related_status" default="">
	<cfargument name="cons_cat" default="">
	<cfargument name="keyword" default="">
	<cfargument name="database_type" default="">
	<cfargument name="sales_county" default="">
	<cfargument name="pos_code" default="">
	<cfargument name="pos_code_text" default="">
	<cfargument name="country_id" default="">
	<cfargument name="city_id" default="">
	<cfargument name="county_id" default="">
	<cfargument name="is_code_filter" default="">
	<cfargument name="mem_code" default="">
	<cfargument name="tc_identy" default="">
	<cfargument name="card_no" default="">
	<cfargument name="row_block" default="">
	<cfargument name="blacklist_status" default="">
	<cfargument name="order_type" default="">
    <cfargument name="startrow" default="1">
    <cfargument name="maxrows" default="">
    <cfargument name="use_efatura" default="">
	<cfif session.ep.our_company_info.sales_zone_followup eq 1>
		<cfquery name="GET_HIERARCHIES" datasource="#this.DSN#">
			SELECT
				DISTINCT
				SZ_HIERARCHY
			FROM
				SALES_ZONES_ALL_1
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
	</cfif>
	<cfquery name="GET_CONS_CT" datasource="#this.DSN#">
	WITH CTE1 AS (
        SELECT
			CONSUMER.CONSUMER_ID,		
			CONSUMER.MEMBER_CODE,
			CONSUMER.OZEL_KOD,
			CONSUMER.CONSUMER_NAME,
			CONSUMER.CONSUMER_SURNAME,
			CONSUMER.CONSUMER_EMAIL,
			CONSUMER.CONSUMER_WORKTEL,
			CONSUMER.CONSUMER_WORKTELCODE,
			CONSUMER.CONSUMER_FAX,
			CONSUMER.CONSUMER_FAXCODE,
			CONSUMER.MOBILTEL,
			CONSUMER.MOBIL_CODE,
			CONSUMER.ISPOTANTIAL,
			CONSUMER.TC_IDENTY_NO,
			CONSUMER.BIRTHDATE,
			CONSUMER.RECORD_DATE,
			CONSUMER.CONSUMER_REFERENCE_CODE,
			CONSUMER_CAT.CONSCAT,		
			(	SELECT TOP 1
					EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME
				FROM
					WORKGROUP_EMP_PAR WEP,
					EMPLOYEE_POSITIONS EP
				WHERE
					WEP.IS_MASTER = 1 AND
					WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
					WEP.CONSUMER_ID = CONSUMER.CONSUMER_ID AND
					WEP.CONSUMER_ID IS NOT NULL AND
					WEP.POSITION_CODE = EP.POSITION_CODE
			)EMP_POSITION_CODE,
			(SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE CONSUMER.CONSUMER_STAGE = PROCESS_ROW_ID) STAGE
			<cfif isdefined('is_resource_id') and is_resource_id eq 1>
				,(SELECT RESOURCE FROM COMPANY_PARTNER_RESOURCE WHERE RESOURCE_ID = CONSUMER.RESOURCE_ID) RESOURCE
			</cfif>
			<cfif isdefined('is_record_member') and is_record_member eq 1>
				,CASE WHEN CONSUMER.RECORD_PAR IS NOT NULL THEN 
					(SELECT C2.NICKNAME+' - '+CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = CONSUMER.RECORD_PAR)
				WHEN CONSUMER.RECORD_MEMBER IS NOT NULL THEN 
					(SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CONSUMER.RECORD_MEMBER)
				WHEN CONSUMER.RECORD_CONS IS NOT NULL THEN
					(SELECT C.CONSUMER_NAME +' ' + C.CONSUMER_SURNAME FROM CONSUMER C WHERE CONSUMER.CONSUMER_ID = C.CONSUMER_ID)
				END AS RECORD_EMP
			</cfif>
			<cfif isdefined('is_customer_value') and is_customer_value eq 1>
				,(SELECT CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE WHERE CUSTOMER_VALUE_ID = CONSUMER.CUSTOMER_VALUE_ID) CUSTOMER_VALUE
			</cfif>
			<cfif isdefined('is_ref_pos_code') and is_ref_pos_code eq 1>
				,(SELECT C2.CONSUMER_NAME +' ' + C2.CONSUMER_SURNAME FROM CONSUMER C2 WHERE C2.CONSUMER_ID = CONSUMER.REF_POS_CODE) REF_CONS_NAME
			</cfif>
		FROM
			CONSUMER,
			CONSUMER_CAT
		WHERE
			CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID AND 
			CONSUMER.CONSUMER_CAT_ID IN (#list_cons_cat_id#)
		<cfif len(period_id)>
			AND CONSUMER.CONSUMER_ID IN 
					(
					SELECT 
						CONSUMER_ID
					FROM 
						CONSUMER_PERIOD 
					WHERE 
						<cfif listgetat(period_id,2,',') eq 1>
							PERIOD_ID = #listgetat(period_id,4,',')#
						<cfelse>
							PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(period_id,3,',')#)
						</cfif>
					)
		</cfif>
		<cfif (session.ep.isBranchAuthorization and is_store_followup eq 1) or len(member_branch)>
			AND
				CONSUMER.CONSUMER_ID IN 
					(
					SELECT 
						CONSUMER_ID 
					FROM 
						COMPANY_BRANCH_RELATED 
					WHERE 
						DEPOT_DAK IS NULL 
						<cfif len(member_branch)>
							AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_branch#">
						</cfif>	
						<cfif session.ep.isBranchAuthorization and is_store_followup eq 1>
							AND
								BRANCH_ID IN (
											SELECT 
												BRANCH_ID
											FROM 
												EMPLOYEE_POSITION_BRANCHES
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
						</cfif>			
					)	
		</cfif>	
		<cfif len(member_branch)>
			AND CONSUMER.CONSUMER_ID IN ( SELECT CONSUMER_ID FROM COMPANY_BRANCH_RELATED WHERE DEPOT_DAK IS NULL AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_branch#">)
		</cfif>
		<cfif len(ref_pos_code) and len(ref_pos_code_name)>
			AND CONSUMER.REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_pos_code#">
		</cfif>
		<cfif len(record_emp) and len(record_name)>
			AND RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_emp#">
		</cfif>
		<cfif isdefined("customer_value") and len(customer_value)>
			AND CONSUMER.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#customer_value#">
		</cfif>
		<cfif isdefined("resource") and len(resource)>
			AND CONSUMER.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#resource#">
		</cfif>
		<cfif isdefined("process_stage_type") and len(process_stage_type)>
			AND CONSUMER.CONSUMER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_stage_type#">
		</cfif>	
		<cfif isDefined("search_potential") and len(search_potential)>
			AND ISPOTANTIAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#search_potential#">
		</cfif>
		<cfif isDefined("search_status") and len(search_status)>
			AND CONSUMER.CONSUMER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#search_status#">
		</cfif>
		<cfif isDefined("related_status") and len(related_status)>
			AND CONSUMER.IS_RELATED_CONSUMER = <cfqueryparam cfsqltype="cf_sql_integer" value="#related_status#">
		</cfif>
		<cfif isDefined("cons_cat") and len(cons_cat)>
			AND CONSUMER.CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cons_cat#"> AND CONSUMER_CAT.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cons_cat#">
		</cfif>
		<cfif isDefined("keyword") and len(keyword)>
		<cfif (database_type is 'MSSQL')>
			AND CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		<cfelseif (database_type is 'DB2')>
			AND CONSUMER.CONSUMER_NAME || ' ' || CONSUMER.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		</cfif>
		<cfif isdefined("sales_county") and len(sales_county)>
			AND CONSUMER.SALES_COUNTY =  <cfqueryparam cfsqltype="cf_sql_integer" value="#sales_county#">
		</cfif>
		<cfif isdefined("pos_code") and len(pos_code) and len(pos_code_text)>
			AND CONSUMER.CONSUMER_ID IN (SELECT CONSUMER_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND CONSUMER_ID IS NOT NULL)
		</cfif>
		<cfif isdefined("country_id") and len(country_id)>
			AND (CONSUMER.HOME_COUNTRY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#country_id#"> 
            	OR CONSUMER.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#country_id#">
                OR CONSUMER.TAX_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#country_id#">)
		</cfif>
		<cfif isdefined("city_id") and len(city_id)>
			AND (CONSUMER.HOME_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#city_id#"> OR CONSUMER.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#city_id#">)
		</cfif>
		<cfif isdefined("county_id") and len(county_id)>
			AND (CONSUMER.HOME_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#county_id#"> OR CONSUMER.WORK_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#county_id#">)
		</cfif>
		<cfif isdefined("customer_value") and len(customer_value)>
			AND CONSUMER.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#customer_value#">
		</cfif>
		<cfif isdefined("is_code_filter") and is_code_filter eq 1>
			<cfif isDefined("mem_code") and len(mem_code)>
			AND (CONSUMER.MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mem_code#"> OR CONSUMER.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mem_code#">)
			</cfif>
		<cfelse>
			<cfif isDefined("mem_code") and len(mem_code)>
			AND (CONSUMER.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#mem_code#%"> OR CONSUMER.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#mem_code#%">)
			</cfif>
		</cfif>
		<cfif isDefined("tc_identy") and len(tc_identy)>AND CONSUMER.TC_IDENTY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#tc_identy#%"></cfif>
		<cfif isDefined("card_no") and len(card_no)>
			AND CONSUMER.CONSUMER_ID IN (SELECT ACTION_ID FROM CUSTOMER_CARDS WHERE ACTION_TYPE_ID = 'CONSUMER_ID' AND CARD_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#card_no#">)
		</cfif>
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			AND 
			(
				CONSUMER.IMS_CODE_ID IN (
											SELECT 
												DISTINCT IMS_ID
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
												DISTINCT IMS_ID
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
															<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
														</cfloop>													
														)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)
			  </cfif>						
			)
		</cfif>
		<cfif len(use_efatura)>
        	AND CONSUMER.USE_EFATURA = #use_efatura#
        </cfif>
		<cfif isdefined("blacklist_status") and len(blacklist_status)>
			AND CONSUMER.CONSUMER_ID IN (SELECT CONSUMER_ID FROM COMPANY_CREDIT WHERE CONSUMER_ID IS NOT NULL AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND IS_BLACKLIST = 1)
        </cfif>),
		
        	CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY <cfif isdefined("order_type") and len(order_type)>
		  <cfif order_type eq 1>
			CONSUMER_NAME,
			CONSUMER_SURNAME
		  <cfelseif order_type eq 2>
			CONSUMER_REFERENCE_CODE DESC
		  <cfelseif order_type eq 3>
			RECORD_DATE DESC
		  </cfif>
		<cfelse>
			RECORD_DATE DESC,
			CONSUMER_NAME,
			CONSUMER_SURNAME
		</cfif>) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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
	<cfreturn GET_CONS_CT>
</cffunction>

