<!---
	fonksiyon name i dosya adıyla aynı olmalıdır.
---><!---TolgaS 20080722
Autocomplate için yapıldı aranan kritere uygun tüm aktif üyeleri getirir
select_list ifadesi 1 ise kurumsal,2 ise bireysel,3 ise calisanlar listelenir
is_store_module subeden listelenecekse 1 olarak gonderilir
is_potantial_1 değeri 0 ise kurumsal uye caridir 1 ise potansiyeldir bos gelirse tum kurumsal uyeler listelenir
is_potantial_2 değeri 0 ise bireysel uye caridir 1 ise potansiyeldir bos gelirse tum bireysel uyeler listelenir
is_buyer_seller uyelerin alıcı mı satici mı oldugunu belirtir
member_status uyelerin durumunu belirtir 0 ise pasif,1 ise aktif
is_company_info partnerlar gelsin mi gelmesin mi
1,0,0
--->
<cffunction name="get_autocomplete" access="public" returnType="query" output="yes">
	<cfargument name="nickname" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="select_list" required="no" type="string" default="1,2,3">
	<cfargument name="is_store_module" required="no" type="string" default="0">
	<cfargument name="is_potantial_1" required="no" type="string" default="0,1">
    <cfargument name="is_potantial_2" required="no" type="string" default="0,1">
	<cfargument name="is_buyer_seller" required="no" type="string" default="2">
	<cfargument name="member_status" required="no" type="string" default="1">
	<cfargument name="is_company_info" required="no" type="string" default="0">
	<cfoutput>#nickname#</cfoutput>
	<cfif isdefined("session.ep")>
		<cfif fusebox.use_period and (ListFind(arguments.select_list,1,',') or ListFind(arguments.select_list,2,','))>
			<cfquery name="GET_PERIOD" datasource="#DSN#">
				SELECT
					SETUP_PERIOD.PERIOD_ID,
					SETUP_PERIOD.PERIOD
				FROM
					SETUP_PERIOD,
					EMPLOYEE_POSITION_PERIODS EPP
				WHERE 
					EPP.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
					EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1)
			</cfquery>
			<cfset period_id_list = listsort(listdeleteduplicates(valueList(get_period.period_id,',')),'numeric','ASC',',')>
		</cfif>		
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>
			<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
				SELECT
					DISTINCT
					SZ_HIERARCHY
				FROM
					SALES_ZONES_ALL_1
				WHERE
					POSITION_CODE = #session.ep.position_code#
			</cfquery>
			<cfset row_block = 500>
		</cfif>		
		<cfif ListFind(arguments.select_list,1,',')>
			<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
				SELECT 
					COMPANYCAT_ID
				FROM
					GET_MY_COMPANYCAT
				WHERE
					EMPLOYEE_ID = #session.ep.userid#
			</cfquery>
		</cfif>
	</cfif>
	<cfif isdefined("arguments.is_store_module") and arguments.is_store_module eq 1>
		<cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
			SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = #session_base.company_id#
		</cfquery>
	</cfif>	
	<cfquery name="GET_COMPANY_PARTNER" datasource="#DSN#">
		<cfif ListFind(arguments.select_list,1,',')>
			SELECT DISTINCT
				'partner' as MEMBER_TYPE,
				0 AUTOCOMPLETE_TYPE,
				C.COMPANY_ID AS MEMBER_ID,
				NULL CONSUMER_ID,
				C.COMPANY_ID,
				NULL EMPLOYEE_ID,
				CP.PARTNER_ID AS PARTNER_CODE,
				'' AS POSITION_ID,
				C.NICKNAME,
				<cfif isdefined("period_id_list") and len(period_id_list)>
					CEP.ACCOUNT_CODE,
				<cfelse>
					'' ACCOUNT_CODE,
				</cfif>
				<cfif database_type is 'MSSQL'>
					CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME,
				<cfelseif database_type is 'DB2'>
					CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME,
				</cfif>
				<cfif database_type is 'MSSQL'>
					CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME2,
				<cfelseif database_type is 'DB2'>
					CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME2,
				</cfif>
				C.MEMBER_CODE AS MEMBER_CODE,
				CP.PARTNER_ID,
				CP.PARTNER_ID AS PARTNER_ID2,
				NULL  POSITION_CODE,
				'' IS_MASTER,
				C.FULLNAME AS MEMBER_NAME,
				C.FULLNAME AS MEMBER_NAME2,
				'' CONSUMER_REFERENCE_CODE,
				CP.COMPANY_PARTNER_EMAIL AS EMAIL,
				C.COMPANY_TELCODE AS MEMBER_TEL_CODE,
				C.COMPANY_TEL1 AS MEMBER_TEL_NUMBER,
				C.COMPANY_ADDRESS WORK_ADDRESS
			FROM 
				COMPANY C,
				COMPANY_PARTNER CP
			<cfif isdefined("arguments.is_store_module") and isdefined("get_ourcmp_info") and get_ourcmp_info.is_store_followup>
				,COMPANY_BRANCH_RELATED
			</cfif>
			<cfif isdefined("period_id_list") and len(period_id_list)>
				,COMPANY_PERIOD CEP
			</cfif>
			WHERE
				1 = 1
				AND C.COMPANY_ID = CP.COMPANY_ID
			<cfif isdefined("session.ep") and get_companycat.recordcount>
				AND C.COMPANYCAT_ID IN (#valuelist(get_companycat.companycat_id,',')#)
			</cfif>
			<cfif arguments.is_company_info eq 1>
				AND CP.PARTNER_ID = C.MANAGER_PARTNER_ID
			</cfif>	
			<cfif isdefined("arguments.member_status") and arguments.member_status eq 1>
				AND C.COMPANY_STATUS = 1
				AND CP.COMPANY_PARTNER_STATUS = 1
			</cfif>
			<cfif arguments.is_potantial_1 eq 1>
				AND C.ISPOTANTIAL = 1 
			<cfelseif arguments.is_potantial_1 eq 0>
				AND C.ISPOTANTIAL = 0
			</cfif>
			<cfif isDefined("arguments.is_buyer_seller") and arguments.is_buyer_seller eq 0>
				AND	C.IS_BUYER = 1
			<cfelseif isDefined("arguments.is_buyer_seller") and arguments.is_buyer_seller eq 1>
				AND	C.IS_SELLER = 1
			</cfif>
			<cfif isdefined("arguments.is_store_module")  and isdefined("get_ourcmp_info") and get_ourcmp_info.is_store_followup>
				AND COMPANY_BRANCH_RELATED.COMPANY_ID = C.COMPANY_ID
				AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->
				AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (
					SELECT 
						BRANCH.BRANCH_ID
					FROM 
						BRANCH, 
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
						EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID)
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
			<cfif len(arguments.nickname)>
				AND
				(
					C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
					C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
					C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
					<cfif database_type is 'MSSQL'>
						CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
					<cfelseif database_type is 'DB2'>
						CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
					</cfif>
				)
			</cfif>
			<cfif isdefined("period_id_list") and len(period_id_list)>
				AND CEP.COMPANY_ID = C.COMPANY_ID
				AND CEP.PERIOD_ID = #session_base.period_id#
			</cfif>		
		</cfif>
		<cfif ListFind(arguments.select_list,1,',') and ListFind(arguments.select_list,2,',')>
			UNION ALL
		</cfif>
		<cfif ListFind(arguments.select_list,2,',')>
			SELECT DISTINCT
				'consumer' AS MEMBER_TYPE,
				1 AUTOCOMPLETE_TYPE,
				C.CONSUMER_ID AS MEMBER_ID,
				C.CONSUMER_ID,
				NULL COMPANY_ID,
				NULL EMPLOYEE_ID, 
				C.CONSUMER_ID AS PARTNER_CODE,
				'' AS POSITION_ID,
				' '  NICKNAME,
				<cfif isdefined("period_id_list") and len(period_id_list)>
					CEP.ACCOUNT_CODE,
				<cfelse>
					'' ACCOUNT_CODE,
				</cfif>
				''  MEMBER_PARTNER_NAME,
				<cfif database_type is 'MSSQL'>
					C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME AS MEMBER_PARTNER_NAME2,
				<cfelseif database_type is 'DB2'>
					C.CONSUMER_NAME || ' ' || C.CONSUMER_SURNAME AS MEMBER_PARTNER_NAME2,	
				</cfif>
				C.MEMBER_CODE,
				NULL PARTNER_ID,
				C.CONSUMER_ID AS PARTNER_ID2,
				NULL POSITION_CODE,
				'' IS_MASTER,
				<cfif database_type is 'MSSQL'>
					C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME AS MEMBER_NAME,	
				<cfelseif database_type is 'DB2'>
					C.CONSUMER_NAME || ' ' || C.CONSUMER_SURNAME AS MEMBER_NAME,
				</cfif>
				'' MEMBER_NAME2,
				C.CONSUMER_REFERENCE_CODE,
				C.CONSUMER_EMAIL AS EMAIL,
				C.CONSUMER_WORKTELCODE AS MEMBER_TEL_CODE,
				C.CONSUMER_WORKTEL AS MEMBER_TEL_NUMBER,
				C.WORKADDRESS WORK_ADDRESS
			FROM 
				CONSUMER C
			<cfif isdefined("period_id_list") and len(period_id_list)>
				,CONSUMER_PERIOD CEP
			</cfif>
			WHERE
				1 = 1
			<cfif isdefined("arguments.member_status") and arguments.member_status eq 1>
				AND C.CONSUMER_STATUS = 1
			</cfif>
			<cfif arguments.is_potantial_2 eq 1>
				AND C.ISPOTANTIAL = 1 
			   <cfelseif arguments.is_potantial_2 eq 0>
				AND C.ISPOTANTIAL = 0
			</cfif>
			<cfif isdefined("arguments.is_store_module") and isdefined("get_ourcmp_info") and get_ourcmp_info.is_store_followup>
				AND C.CONSUMER_ID IN (
				SELECT 
					COMPANY_BRANCH_RELATED.CONSUMER_ID
				FROM 
					EMPLOYEE_POSITION_BRANCHES,
					COMPANY_BRANCH_RELATED
				WHERE
					COMPANY_BRANCH_RELATED.CONSUMER_ID IS NOT NULL AND
					EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
					EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
					COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL )
			</cfif>
			<cfif len(arguments.nickname)>
				AND
				(
					C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
					<cfif database_type is 'MSSQL'>
					C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
					<cfelseif database_type is 'DB2'>
					C.CONSUMER_NAME || ' ' || C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
					</cfif>
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
			<cfif isdefined("period_id_list") and len(period_id_list)>
				AND CEP.CONSUMER_ID = C.CONSUMER_ID
				AND CEP.PERIOD_ID = #session_base.period_id#
			</cfif>	
		</cfif>
		<cfif (ListFind(arguments.select_list,1,',') and ListFind(arguments.select_list,2,',') and ListFind(arguments.select_list,3,',')) or (ListFind(arguments.select_list,1,',') and ListFind(arguments.select_list,3,',')) or (ListFind(arguments.select_list,2,',') and ListFind(arguments.select_list,3,','))>
			UNION ALL
		</cfif>
		<cfif ListFind(arguments.select_list,3,',')>
			SELECT
				'employee' AS MEMBER_TYPE,
				2 AUTOCOMPLETE_TYPE,
				EP.EMPLOYEE_ID AS MEMBER_ID,
				NULL CONSUMER_ID,
				NULL COMPANY_ID,
				EP.EMPLOYEE_ID,
				POSITION_CODE AS PARTNER_CODE,
				POSITION_ID,
				' '  NICKNAME,
				(SELECT EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session_base.period_id# AND (EIOP.ACCOUNT_CODE IS NOT NULL OR EIOP.ACCOUNT_CODE <> '')) AS ACCOUNT_CODE,
				''  MEMBER_PARTNER_NAME,
				<cfif database_type is 'MSSQL'>
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' || ' + POSITION_NAME AS MEMBER_PARTNER_NAME2,
				<cfelseif database_type is 'DB2'>
				EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' || ' || POSITION_NAME AS MEMBER_PARTNER_NAME2,
				</cfif>
				NULL MEMBER_CODE,
				NULL PARTNER_ID,
				EP.EMPLOYEE_ID PARTNER_ID2,
				POSITION_CODE,
				EP.IS_MASTER,
				<cfif database_type is 'MSSQL'>
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' || ' + POSITION_NAME AS MEMBER_NAME,<!--- POSITION_NAME eklendi, birden fazla pozisyonu olan kisileri secerken sorun olusuyordu FBS 20100601 --->
				<cfelseif database_type is 'DB2'>
				EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' || ' || POSITION_NAME AS MEMBER_NAME,
				</cfif>
				'' MEMBER_NAME2,
				'' CONSUMER_REFERENCE_CODE,
				E.EMPLOYEE_EMAIL AS EMAIL,
				E.DIRECT_TELCODE AS MEMBER_TEL_CODE,
				E.DIRECT_TEL AS MEMBER_TEL_NUMBER,
				'' WORK_ADDRESS
			FROM 
				EMPLOYEE_POSITIONS EP,
				EMPLOYEES E
			WHERE 
				E.EMPLOYEE_STATUS = 1 AND
				EP.POSITION_STATUS = 1 AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND			
				<cfif database_type is 'MSSQL'>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
				<cfelseif database_type is 'DB2'>
					EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
				</cfif>
		</cfif>
		ORDER BY 
			MEMBER_NAME
	</cfquery>
	<cfreturn get_company_partner>
</cffunction>
