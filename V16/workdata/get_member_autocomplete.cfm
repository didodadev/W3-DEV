<!---20131112 E.A fulltextsearch özelliği eklendi --->
<!---TolgaS 20080722 
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
<cffunction name="get_member_autocomplete" access="public" returntype="query" output="no">
	<cfargument name="nickname" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="select_list" required="no" type="string" default="1,2,3">
	<cfargument name="is_store_module" required="no" type="string" default="0">
	<cfargument name="is_potantial_1" required="no" type="string" default="0,1">
    <cfargument name="is_potantial_2" required="no" type="string" default="0,1">
	<cfargument name="is_buyer_seller" required="no" type="string" default="2">
	<cfargument name="member_status" required="no" type="string" default="1">
	<cfargument name="is_company_info" required="no" type="string" default="0">
	<cfargument name="is_cari_action" required="no" type="string" default="0">
	<cfargument name="is_search_full" required="no" type="string" default="0">
	<cfargument name="is_workgroup_emp" required="no" type="string" default="0">
    
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
					EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1)
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
					POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
			</cfquery>
			<cfset row_block = 500>
		</cfif>		
		<cfif ListFind(arguments.select_list,1,',')>
			<!--- Kurumsal Uye Kategorilerinde Sirket ve Kullanici Yetkileri --->
			<cfquery name="get_companycat" datasource="#dsn#">
				<!--- SELECT COMPANYCAT_ID FROM GET_MY_COMPANYCAT WHERE EMPLOYEE_ID = #session.ep.userid# --->
				SELECT 
					DISTINCT
					CT.COMPANYCAT_ID, 
					CT.COMPANYCAT
				FROM
					GET_MY_COMPANYCAT CT,
					COMPANY_CAT_OUR_COMPANY CO
				WHERE
					CT.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					CT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
					CT.COMPANYCAT_ID = CO.COMPANYCAT_ID
			</cfquery>
		</cfif>
		<cfif ListFind(arguments.select_list,2,',')>
			<!--- Bireysel Uye Kategorilerinde Sirket ve Kullanici Yetkileri --->
			<cfquery name="get_consumercat" datasource="#dsn#">
				SELECT 
					DISTINCT
					CT.CONSCAT_ID, 
					CT.CONSCAT,
					CT.HIERARCHY
				FROM
					GET_MY_CONSUMERCAT CT,
					CONSUMER_CAT_OUR_COMPANY CO
				WHERE
					CT.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					CT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
					CT.CONSCAT_ID = CO.CONSCAT_ID
			</cfquery>
		</cfif>
	</cfif>
	<cfif isdefined("arguments.is_store_module") and arguments.is_store_module eq 1>
		<cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
			SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
		</cfquery>
	</cfif>	
	<cfset query_union_list_ = ''>
	<cfif ListFind(arguments.select_list,1,',')>
		<cfquery name="get_1" datasource="#dsn#">
					SELECT DISTINCT TOP 10
						'partner' as MEMBER_TYPE,
						0 AUTOCOMPLETE_TYPE,
						CAST(C.COMPANY_ID AS NVARCHAR) AS MEMBER_ID,
						NULL CONSUMER_ID,
						C.COMPANY_ID,
						'' EMPLOYEE_ID,
						CP.PARTNER_ID AS PARTNER_CODE,
						NULL AS POSITION_ID,
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
						<cfif database_type is 'MSSQL'>
							CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME + ' - ' + C.NICKNAME AS MEMBER_PARTNER_NAME3,
						<cfelseif database_type is 'DB2'>
							CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME || ' - ' || C.NICKNAME AS MEMBER_PARTNER_NAME3,
						</cfif>
						C.MEMBER_CODE AS MEMBER_CODE,
						CP.PARTNER_ID,
						CP.PARTNER_ID AS PARTNER_ID2,
						0 IN_OUT_ID,
						NULL  POSITION_CODE,
						0 IS_MASTER,
                       <cfif isDefined('arguments.is_workgroup_emp') and arguments.is_workgroup_emp eq 1>
                        	 EP.EMPLOYEE_ID WORKGROUP_EMP_ID, 
                             EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS WORKGROUP_EMP_NAME, 
                        </cfif> 
						C.FULLNAME AS MEMBER_NAME,
						C.FULLNAME AS MEMBER_NAME2,
						'' CONSUMER_REFERENCE_CODE,
						CP.COMPANY_PARTNER_EMAIL AS EMAIL,
						C.COMPANY_TELCODE AS MEMBER_TEL_CODE,
						C.COMPANY_TEL1 AS MEMBER_TEL_NUMBER,
						C.COMPANY_ADDRESS WORK_ADDRESS,
						'' BRANCH_DEPT
					FROM 
						COMPANY C
                     	<cfif isDefined('arguments.is_workgroup_emp') and arguments.is_workgroup_emp eq 1>
                            LEFT JOIN WORKGROUP_EMP_PAR WEP ON C.COMPANY_ID = WEP.COMPANY_ID 
                            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = WEP.POSITION_CODE 
    					</cfif>,
						COMPANY_PARTNER CP
					<cfif isdefined("arguments.is_store_module") and isdefined("get_ourcmp_info") and get_ourcmp_info.is_store_followup>
						,COMPANY_BRANCH_RELATED
					</cfif>
					<cfif isdefined("period_id_list") and len(period_id_list)>
						,COMPANY_PERIOD CEP
					</cfif>
					WHERE
						C.COMPANY_ID = CP.COMPANY_ID
					<cfif isdefined("session.ep") and get_companycat.recordcount>
						AND C.COMPANYCAT_ID IN (#valuelist(get_companycat.companycat_id,',')#)
					</cfif>
					<cfif arguments.is_company_info eq 1>
						AND CP.PARTNER_ID = C.MANAGER_PARTNER_ID
					</cfif>	
					<cfif isdefined("arguments.member_status") and (arguments.member_status eq 1 or len(arguments.member_status) eq 0)>
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
						AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemek için --->
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
																<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
															</cfloop>
															)
														<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
													</cfloop>											
											)
						  </cfif>						
						)
					</cfif>
					<cfif len(arguments.nickname)>
						AND
						(
							<cfif isdefined("is_fulltext_search") and is_fulltext_search  eq 1 >
								CONTAINS (CP.COMPANY_PARTNER_NAME,'"#arguments.nickname#*"')
							<cfelse>
								<cfif database_type is 'MSSQL'>
									CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
								<cfelseif database_type is 'DB2'>
									CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
								</cfif>
							</cfif>		
						)
					</cfif>
					<cfif isdefined("period_id_list") and len(period_id_list)>
						AND CEP.COMPANY_ID = C.COMPANY_ID
						AND CEP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
					</cfif>
				UNION ALL
					SELECT DISTINCT TOP 10
						'partner' as MEMBER_TYPE,
						0 AUTOCOMPLETE_TYPE,
						CAST(C.COMPANY_ID AS NVARCHAR) AS MEMBER_ID,
						NULL CONSUMER_ID,
						C.COMPANY_ID,
						'' EMPLOYEE_ID,
						CP.PARTNER_ID AS PARTNER_CODE,
						NULL AS POSITION_ID,
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
						<cfif database_type is 'MSSQL'>
							CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME + ' - ' + C.NICKNAME AS MEMBER_PARTNER_NAME3,
						<cfelseif database_type is 'DB2'>
							CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME || ' - ' || C.NICKNAME AS MEMBER_PARTNER_NAME3,
						</cfif>
						C.MEMBER_CODE AS MEMBER_CODE,
						CP.PARTNER_ID,
						CP.PARTNER_ID AS PARTNER_ID2,
						0 IN_OUT_ID,
						NULL  POSITION_CODE,
						0 IS_MASTER,
                       <cfif isDefined('arguments.is_workgroup_emp') and arguments.is_workgroup_emp eq 1>
                        	 EP.EMPLOYEE_ID WORKGROUP_EMP_ID, 
                             EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS WORKGROUP_EMP_NAME, 
                        </cfif> 
						C.FULLNAME AS MEMBER_NAME,
						C.FULLNAME AS MEMBER_NAME2,
						'' CONSUMER_REFERENCE_CODE,
						CP.COMPANY_PARTNER_EMAIL AS EMAIL,
						C.COMPANY_TELCODE AS MEMBER_TEL_CODE,
						C.COMPANY_TEL1 AS MEMBER_TEL_NUMBER,
						C.COMPANY_ADDRESS WORK_ADDRESS,
						'' BRANCH_DEPT
					FROM 
						COMPANY C                       	
						<cfif isDefined('arguments.is_workgroup_emp') and arguments.is_workgroup_emp eq 1>
                            LEFT JOIN WORKGROUP_EMP_PAR WEP ON C.COMPANY_ID = WEP.COMPANY_ID 
                            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = WEP.POSITION_CODE 
    					</cfif>,
						COMPANY_PARTNER CP
					<cfif isdefined("arguments.is_store_module") and isdefined("get_ourcmp_info") and get_ourcmp_info.is_store_followup>
						,COMPANY_BRANCH_RELATED
					</cfif>
					<cfif isdefined("period_id_list") and len(period_id_list)>
						,COMPANY_PERIOD CEP
					</cfif>
					WHERE
						C.COMPANY_ID = CP.COMPANY_ID
					<cfif isdefined("session.ep") and get_companycat.recordcount>
						AND C.COMPANYCAT_ID IN (#valuelist(get_companycat.companycat_id,',')#)
					</cfif>
					<cfif arguments.is_company_info eq 1>
						AND CP.PARTNER_ID = C.MANAGER_PARTNER_ID
					</cfif>	
					<cfif isdefined("arguments.member_status") and (arguments.member_status eq 1 or len(arguments.member_status) eq 0)>
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
						AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemek için --->
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
																<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
															</cfloop>
															)
														<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
													</cfloop>											
											)
						  </cfif>						
						)
					</cfif>
					<cfif len(arguments.nickname)>
						AND
						(
							
							<cfif isdefined("is_fulltext_search") and is_fulltext_search  eq 1 >
								CONTAINS (C.*,'"#arguments.nickname#*"')
							<cfelse>	

								C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%"> OR
								C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%"> OR
								C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
								
							</cfif>
						)
					</cfif>
					<cfif isdefined("period_id_list") and len(period_id_list)>
						AND CEP.COMPANY_ID = C.COMPANY_ID
						AND CEP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
					</cfif>
		</cfquery>
		<cfset query_union_list_ = listappend(query_union_list_,'get_1')>
		
	</cfif>
	<cfif ListFind(arguments.select_list,2,',')>
		<cfquery name="get_2" datasource="#dsn#">
			SELECT DISTINCT top 10
				'consumer' AS MEMBER_TYPE,
				1 AUTOCOMPLETE_TYPE,
				CAST(C.CONSUMER_ID AS NVARCHAR) AS MEMBER_ID,
				C.CONSUMER_ID,
				NULL COMPANY_ID,
				'' EMPLOYEE_ID, 
				C.CONSUMER_ID AS PARTNER_CODE,
				NULL AS POSITION_ID,
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
				<cfif database_type is 'MSSQL'>
					C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME AS MEMBER_PARTNER_NAME3,
				<cfelseif database_type is 'DB2'>
					C.CONSUMER_NAME || ' ' || C.CONSUMER_SURNAME AS MEMBER_PARTNER_NAME3,	
				</cfif>
				C.MEMBER_CODE,
				NULL PARTNER_ID,
				C.CONSUMER_ID AS PARTNER_ID2,
				0 IN_OUT_ID,
				NULL POSITION_CODE,
				0 IS_MASTER,
			   	<cfif isDefined('arguments.is_workgroup_emp') and arguments.is_workgroup_emp eq 1>
                     EP.EMPLOYEE_ID WORKGROUP_EMP_ID, 
                     EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS WORKGROUP_EMP_NAME, 
                </cfif> 
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
				C.WORKADDRESS WORK_ADDRESS,
				'' BRANCH_DEPT
			FROM 
				CONSUMER C
				<cfif isDefined('arguments.is_workgroup_emp') and arguments.is_workgroup_emp eq 1>
                    LEFT JOIN WORKGROUP_EMP_PAR WEP ON C.CONSUMER_ID = WEP.CONSUMER_ID 
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = WEP.POSITION_CODE 
                </cfif>
				<cfif isdefined("period_id_list") and len(period_id_list)>
					,CONSUMER_PERIOD CEP
				</cfif>
			WHERE
				1 = 1
				<cfif isdefined("session.ep") and get_consumercat.recordcount>
					AND C.CONSUMER_CAT_ID IN (#valuelist(get_consumercat.conscat_id,',')#)
				</cfif>
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
							C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%"> OR
						<cfif database_type is 'MSSQL'>
							C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
						<cfelseif database_type is 'DB2'>
							C.CONSUMER_NAME || ' ' || C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
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
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
												AND (CONSUMER_CAT_IDS IS NULL OR (CONSUMER_CAT_IDS IS NOT NULL AND ','+CONSUMER_CAT_IDS+',' LIKE '%,'+CAST(C.CONSUMER_CAT_ID AS NVARCHAR)+',%'))
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
														
														)
													<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)
					  </cfif>						
					)
				</cfif>
				<cfif isdefined("period_id_list") and len(period_id_list)>
					AND CEP.CONSUMER_ID = C.CONSUMER_ID
					AND CEP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
				</cfif>
		</cfquery>
		<cfset query_union_list_ = listappend(query_union_list_,'get_2')>
	</cfif>
	<cfif ListFind(arguments.select_list,3,',')>
		<cfquery name="get_position_list_xml_" datasource="#dsn#">
			SELECT 
				PROPERTY_VALUE,
				PROPERTY_NAME
			FROM
				FUSEACTION_PROPERTY
			WHERE
				OUR_COMPANY_ID = #session_base.company_id# AND
				FUSEACTION_NAME = 'objects.popup_list_positions' AND
				(PROPERTY_NAME = 'x_add_multi_acc' OR PROPERTY_NAME = 'xml_branch_control')
		</cfquery>
		<cfquery name="get_position_list_xml" dbtype="query">
			SELECT PROPERTY_VALUE,PROPERTY_NAME FROM get_position_list_xml_ WHERE PROPERTY_NAME = 'x_add_multi_acc'
		</cfquery>
		<cfquery name="get_position_list_xml2" dbtype="query">
			SELECT PROPERTY_VALUE,PROPERTY_NAME FROM get_position_list_xml_ WHERE PROPERTY_NAME = 'xml_branch_control'
		</cfquery>
		<cfinclude template="../V16/objects/query/get_acc_types.cfm">
		<cfquery name="get_3" datasource="#dsn#">
				SELECT
					top 10
					'employee' AS MEMBER_TYPE,
					2 AUTOCOMPLETE_TYPE,
					<cfif get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1 and arguments.is_cari_action eq 1>
						CAST(EP.EMPLOYEE_ID AS NVARCHAR)+'_'+CAST(EA.ACC_TYPE_ID AS NVARCHAR) AS MEMBER_ID,
					<cfelse>
						CAST(EP.EMPLOYEE_ID AS NVARCHAR) AS MEMBER_ID,
					</cfif>
					NULL CONSUMER_ID,
					NULL COMPANY_ID,
					<cfif get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1 and arguments.is_cari_action eq 1>
						CAST(EP.EMPLOYEE_ID AS NVARCHAR)+'_'+CAST(EA.ACC_TYPE_ID AS NVARCHAR) AS EMPLOYEE_ID,
					<cfelse>
						CAST(EP.EMPLOYEE_ID AS NVARCHAR) AS EMPLOYEE_ID,
					</cfif>
					EP.POSITION_CODE AS PARTNER_CODE,
					EP.POSITION_ID,
					' '  NICKNAME,
					<cfif get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1 and arguments.is_cari_action eq 1>
						EA.ACCOUNT_CODE,
					<cfelse>
						(SELECT EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session_base.period_id# AND (EIOP.ACCOUNT_CODE IS NOT NULL OR EIOP.ACCOUNT_CODE <> '')) AS ACCOUNT_CODE,
					</cfif>
					''  MEMBER_PARTNER_NAME,
					<cfif database_type is 'MSSQL'>
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' - ' + REPLACE(EP.POSITION_NAME,'&','') AS MEMBER_PARTNER_NAME2,
					<cfelseif database_type is 'DB2'>
						EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' || ' || REPLACE(EP.POSITION_NAME,'&','') AS MEMBER_PARTNER_NAME2,
					</cfif>
					<cfif database_type is 'MSSQL'>
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' - ' + REPLACE(EP.POSITION_NAME,'&','') AS MEMBER_PARTNER_NAME3,
					<cfelseif database_type is 'DB2'>
						EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' || ' || REPLACE(EP.POSITION_NAME,'&','') AS MEMBER_PARTNER_NAME3,
					</cfif>
					E.MEMBER_CODE MEMBER_CODE,
					NULL PARTNER_ID,
					EP.EMPLOYEE_ID PARTNER_ID2,
					EIO.IN_OUT_ID IN_OUT_ID,
					EP.POSITION_CODE,
					EP.IS_MASTER,
					<cfif get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1 and arguments.is_cari_action eq 1>
						<cfif database_type is 'MSSQL'>
							EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' - ' + (SELECT SAT.ACC_TYPE_NAME FROM SETUP_ACC_TYPE SAT WHERE SAT.ACC_TYPE_ID=EA.ACC_TYPE_ID) + ' - ' + B2.BRANCH_NAME + ' - ' +REPLACE(EP.POSITION_NAME,'&','')  AS MEMBER_NAME,<!--- POSITION_NAME eklendi, birden fazla pozisyonu olan kisileri secerken sorun olusuyordu FBS 20100601 --->
						<cfelseif database_type is 'DB2'>
							EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' || ' || REPLACE(EP.POSITION_NAME,'&','') || ' || ' || B2.BRANCH_NAME || ' || ' || (SELECT SAT.ACC_TYPE_NAME FROM SETUP_ACC_TYPE SAT WHERE SAT.ACC_TYPE_ID=EA.ACC_TYPE_ID) AS MEMBER_NAME,
						</cfif>
					<cfelse>
						<cfif database_type is 'MSSQL'>
							EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' - ' + REPLACE(EP.POSITION_NAME,'&','') + ' - ' + B2.BRANCH_NAME AS MEMBER_NAME,<!--- POSITION_NAME eklendi, birden fazla pozisyonu olan kisileri secerken sorun olusuyordu FBS 20100601 --->
						<cfelseif database_type is 'DB2'>
							EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' || ' || REPLACE(EP.POSITION_NAME,'&','') || ' || ' || B2.BRANCH_NAME  AS MEMBER_NAME,
						</cfif>
					</cfif>
					'' MEMBER_NAME2,
					'' CONSUMER_REFERENCE_CODE,
					E.EMPLOYEE_EMAIL AS EMAIL,
					E.DIRECT_TELCODE AS MEMBER_TEL_CODE,
					E.DIRECT_TEL AS MEMBER_TEL_NUMBER,
					'' WORK_ADDRESS,
					(SELECT B.BRANCH_NAME + '/' + D.DEPARTMENT_HEAD AS BRANCH_DEPT FROM DEPARTMENT D WHERE EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND EIO.BRANCH_ID = B.BRANCH_ID) BRANCH_DEPT
				FROM 
					EMPLOYEES_IN_OUT EIO
					<cfif get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1 and arguments.is_cari_action eq 1>
						LEFT JOIN EMPLOYEES_ACCOUNTS EA ON EA.IN_OUT_ID = EIO.IN_OUT_ID AND EA.PERIOD_ID = #session_base.period_id# 
					</cfif>
					,EMPLOYEES E
					,EMPLOYEE_POSITIONS EP
					LEFT JOIN DEPARTMENT D2 ON D2.DEPARTMENT_ID = EP.DEPARTMENT_ID
					LEFT JOIN BRANCH B2 ON B2.BRANCH_ID = D2.BRANCH_ID
					,BRANCH B
				WHERE 
					EIO.BRANCH_ID = B.BRANCH_ID AND
					EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
					EIO.FINISH_DATE IS NULL AND
					E.EMPLOYEE_STATUS = 1 AND
					EP.POSITION_STATUS = 1 AND
					EP.EMPLOYEE_ID = E.EMPLOYEE_ID
				<cfif len(arguments.nickname)>
					AND
					(				
						E.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%"> OR		
						<cfif database_type is 'MSSQL'>
							EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
						<cfelseif database_type is 'DB2'>
							EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
						</cfif>
					)
				</cfif>
				<cfif get_position_list_xml2.recordcount and get_position_list_xml2.property_value eq 1>
					AND EP.DEPARTMENT_ID IN(SELECT D.DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES EPB,BRANCH B,DEPARTMENT D WHERE EPB.BRANCH_ID = B.BRANCH_ID AND B.BRANCH_ID = D.BRANCH_ID AND EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>		
				<cfif get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1 and arguments.is_cari_action eq 1 and (len(hr_type_list) or len(ehesap_type_list) or len(other_type_list))>
					AND #control_acc_type_list#
				</cfif>
		</cfquery>
		<cfquery name="get_4" datasource="#dsn#">
			SELECT
				top 10
				'employee' AS MEMBER_TYPE,
				2 AUTOCOMPLETE_TYPE,
				CAST(EP.EMPLOYEE_ID AS NVARCHAR) AS MEMBER_ID,
				NULL CONSUMER_ID,
				NULL COMPANY_ID,
				CAST(EP.EMPLOYEE_ID AS NVARCHAR) AS EMPLOYEE_ID,
				POSITION_CODE AS PARTNER_CODE,
				POSITION_ID,
				' '  NICKNAME,
				'' AS ACCOUNT_CODE,
				''  MEMBER_PARTNER_NAME,
				<cfif database_type is 'MSSQL'>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' - ' + REPLACE(POSITION_NAME,'&','') AS MEMBER_PARTNER_NAME2,
				<cfelseif database_type is 'DB2'>
					EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' || ' || REPLACE(POSITION_NAME,'&','') AS MEMBER_PARTNER_NAME2,
				</cfif>
				<cfif database_type is 'MSSQL'>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' - ' + REPLACE(EP.POSITION_NAME,'&','') AS MEMBER_PARTNER_NAME3,
				<cfelseif database_type is 'DB2'>
					EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' ' || REPLACE(EP.POSITION_NAME,'&','') AS MEMBER_PARTNER_NAME3,
				</cfif>
				E.MEMBER_CODE MEMBER_CODE,
				NULL PARTNER_ID,
				EP.EMPLOYEE_ID PARTNER_ID2,
				0 IN_OUT_ID,
				POSITION_CODE,
				EP.IS_MASTER,
				<cfif database_type is 'MSSQL'>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME + ' - ' + REPLACE(POSITION_NAME,'&','') AS MEMBER_NAME,<!--- POSITION_NAME eklendi, birden fazla pozisyonu olan kisileri secerken sorun olusuyordu FBS 20100601 --->
				<cfelseif database_type is 'DB2'>
					EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME || ' ' || REPLACE(POSITION_NAME,'&','') AS MEMBER_NAME,
				</cfif>
				'' MEMBER_NAME2,
				'' CONSUMER_REFERENCE_CODE,
				E.EMPLOYEE_EMAIL AS EMAIL,
				E.DIRECT_TELCODE AS MEMBER_TEL_CODE,
				E.DIRECT_TEL AS MEMBER_TEL_NUMBER,
				'' WORK_ADDRESS,
				'' BRANCH_DEPT
			FROM 
				EMPLOYEE_POSITIONS EP,
				EMPLOYEES E
			WHERE 
				E.EMPLOYEE_ID NOT IN(SELECT EIO.EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.FINISH_DATE IS NULL) AND
				E.EMPLOYEE_STATUS = 1 AND
				EP.POSITION_STATUS = 1 AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID	
			<cfif len(arguments.nickname)>
				AND
				(				
					E.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%"> OR		
					<cfif database_type is 'MSSQL'>
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
					<cfelseif database_type is 'DB2'>
						EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(arguments.is_search_full eq 1,DE('%'),DE(''))##arguments.nickname#%">
					</cfif>
				)
			</cfif>
			<cfif get_position_list_xml2.recordcount and get_position_list_xml2.property_value eq 1>
				AND EP.DEPARTMENT_ID IN(SELECT D.DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES EPB,BRANCH B,DEPARTMENT D WHERE EPB.BRANCH_ID = B.BRANCH_ID AND B.BRANCH_ID = D.BRANCH_ID AND EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>						
		</cfquery>
		<cfset query_union_list_ = listappend(query_union_list_,'get_3')>
		<cfset query_union_list_ = listappend(query_union_list_,'get_4')>
	</cfif>
	<cfquery name="get_company_partner" dbtype="query" maxrows="#arguments.maxrows#">
		<cfset c_ = 0><cfloop list="#query_union_list_#" index="ccm"><cfset c_ = c_ + 1>SELECT * FROM #ccm# <cfif c_ lt listlen(query_union_list_)>UNION ALL </cfif></cfloop> ORDER BY MEMBER_NAME
	</cfquery>
	<cfreturn get_company_partner>
</cffunction>

