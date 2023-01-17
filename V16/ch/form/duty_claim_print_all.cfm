<!---  kurumsal bilgileri ve muhasebe bilgileri alınıyor --->
<cfsetting showdebugoutput="no">
<cfset tarih_ = now()>
<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
	<cf_date tarih="attributes.finishdate2">
	<cfset tarih_ = attributes.finishdate2>
</cfif>
<cfset list_company = "">
<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
	<cfloop from="1" to="#listlen(attributes.member_cat_type,',')#" index="ix">
		<cfset list_getir = listgetat(attributes.member_cat_type,ix,',')>
		<cfif listfirst(list_getir,'-') eq 1 and listlast(list_getir,'-') neq 0>
			<cfset list_company = listappend(list_company,listlast(list_getir,'-'),'-')>
		</cfif>
		<cfset list_company = listsort(listdeleteduplicates(replace(list_company,"-",",","all"),','),'numeric','ASC',',')>
	</cfloop>
</cfif>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 	
		ALL_ROWS.FULLNAME AS FULLNAME,
		ALL_ROWS.COMP_ID AS COMPANY_ID,	
		SUM(BORC1-ALACAK1) AS BAKIYE,
		SUM(BORC1) AS BORC,
		SUM(ALACAK1) AS ALACAK
	FROM 
	(	
		SELECT
			SUM(CRS.ACTION_VALUE) AS BORC1,
			0 as ALACAK1,
			CRS.TO_CMP_ID AS COMP_ID,
			CRS.ACTION_DATE AS TARIH,
			C.FULLNAME AS FULLNAME
		FROM
			#dsn2#.CARI_ROWS CRS,
			COMPANY C
			<cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>
			,WORKGROUP_EMP_PAR WEP
			</cfif>
		WHERE
			CRS.TO_CMP_ID IS NOT NULL
			AND C.COMPANY_ID = CRS.TO_CMP_ID
			AND COMPANY_STATUS = 1
			<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name) and attributes.member_type is 'partner'>
					AND	C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.COMPANY_ID = WEP.COMPANY_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.COMPANY_ID IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND C.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
					AND C.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.FULLNAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
				</cfif>
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
					AND CRS.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
				<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
					AND CRS.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
				<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
					AND CRS.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and len(list_company)>
					AND C.COMPANYCAT_ID IN (#list_company#)
				</cfif>
				<cfif isDefined("attributes.city") and len(attributes.city)>
					AND C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
				</cfif>
				<cfif isDefined("attributes.country") and len(attributes.country)>
					AND C.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
				</cfif>
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate2') and len(attributes.finishdate2)>
					AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
				</cfif>	
				<cfif isdefined('attributes.startdate2') and len(attributes.startdate2)>
					AND CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					AND
					(
					(CRS.ACTION_TABLE ='CHEQUE' AND CRS.ACTION_ID IN (SELECT CHEQUE_ID FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (3,7) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
					OR	
					(CRS.ACTION_TABLE ='PAYROLL' AND CRS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM #dsn2_alias#.CHEQUE C,#dsn2_alias#.CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CRS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (3,7) OR (C.CHEQUE_STATUS_ID = 4 AND C.CHEQUE_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
					OR 
					(CRS.ACTION_TABLE ='VOUCHER' AND CRS.ACTION_ID IN (SELECT VOUCHER_ID FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (3,7) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
					OR	
					(CRS.ACTION_TABLE ='VOUCHER_PAYROLL' AND CRS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM #dsn2_alias#.VOUCHER V,#dsn2_alias#.VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CRS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (3,7) OR (V.VOUCHER_STATUS_ID = 4 AND V.VOUCHER_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
					OR 
					(CRS.ACTION_TABLE <>'PAYROLL' AND CRS.ACTION_TABLE <> 'CHEQUE' AND CRS.ACTION_TABLE <> 'VOUCHER' AND CRS.ACTION_TABLE <> 'VOUCHER_PAYROLL')
					)			
				</cfif>
				<!--- BK 20100329 Odenmemis Talimatlari Getirme secili ise calisan blok --->
				<cfif isdefined("attributes.is_pay_bankorders")>
					AND
					(
						CRS.ACTION_TYPE_ID IN (260,251) AND CRS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM #dsn2#.BANK_ORDERS WHERE IS_PAID = 1) OR
						CRS.ACTION_TYPE_ID NOT IN (260,251)
					)
				</cfif>	
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
				</cfif>
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfind(attributes.member_cat_type,'3-0',',')>
					AND C.IS_RELATED_COMPANY = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
					AND C.IS_BUYER = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
					AND C.IS_SELLER= 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL = 1
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif isdefined("attributes.money_info") and len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur degerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <><cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
					</cfif>
					AND CRS.TO_CMP_ID IN
					(SELECT 
						COMPANY_BRANCH_RELATED.COMPANY_ID
					FROM 
						BRANCH, 
						EMPLOYEE_POSITION_BRANCHES,
						COMPANY_BRANCH_RELATED
					WHERE 
						EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
						EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID  AND
						COMPANY_BRANCH_RELATED.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID)
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
			<!--- <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				AND	C.COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and len(list_company)>
				AND	C.COMPANYCAT_ID IN (#list_company#)
			</cfif>
            <cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
                AND C.IS_BUYER = 1
            </cfif>
            <cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
                AND C.IS_SELLER= 1
            </cfif>
            <cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
                AND C.ISPOTANTIAL = 1
            </cfif>
			<cfif isdefined("attributes.country") and len(attributes.country)>
				AND	C.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"> 
			</cfif>
			<cfif isdefined("attributes.city") and len(attributes.city)>
				AND	C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
			</cfif>
			<cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>
				AND C.COMPANY_ID = WEP.COMPANY_ID
				AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#session.ep.company_id#"> AND WEP.COMPANY_ID IS NOT NULL
			</cfif>
			<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
				AND C.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
			</cfif>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND C.FULLNAME LIKE <cfif len(attributes.keyword) gte 3><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
			</cfif>
			<cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
				AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
			</cfif>
			<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
				AND
				(
					CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
					CRS.DUE_DATE IS NULL
				)
				AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
			</cfif> --->
		GROUP BY 
			C.FULLNAME,
			CRS.TO_CMP_ID,
			CRS.ACTION_DATE

		UNION
		
		SELECT
			0 AS BORC1,		
			SUM(CRS.ACTION_VALUE) AS ALACAK1,
									
			CRS.FROM_CMP_ID AS COMP_ID,
			CRS.ACTION_DATE,
			C.FULLNAME
		FROM
			#dsn2#.CARI_ROWS CRS,
			COMPANY C
			<cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>
			,WORKGROUP_EMP_PAR WEP
			</cfif>
		WHERE
			CRS.FROM_CMP_ID IS NOT NULL AND
			C.COMPANY_ID = CRS.FROM_CMP_ID AND
			COMPANY_STATUS = 1
            <cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name) and attributes.member_type is 'partner'>
					AND	C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.COMPANY_ID = WEP.COMPANY_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.COMPANY_ID IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND C.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
					AND C.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.FULLNAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
				</cfif>
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
					AND CRS.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
				<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
					AND CRS.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
				<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
					AND CRS.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and len(list_company)>
					AND C.COMPANYCAT_ID IN (#list_company#)
				</cfif>
				<cfif isDefined("attributes.city") and len(attributes.city)>
					AND C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
				</cfif>
				<cfif isDefined("attributes.country") and len(attributes.country)>
					AND C.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
				</cfif>
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate2') and len(attributes.finishdate2)>
					AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
				</cfif>	
				<cfif isdefined('attributes.startdate2') and len(attributes.startdate2)>
					AND CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					AND
					(
					(CRS.ACTION_TABLE ='CHEQUE' AND CRS.ACTION_ID IN (SELECT CHEQUE_ID FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (3,7) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
					OR	
					(CRS.ACTION_TABLE ='PAYROLL' AND CRS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM #dsn2_alias#.CHEQUE C,#dsn2_alias#.CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CRS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (3,7) OR (C.CHEQUE_STATUS_ID = 4 AND C.CHEQUE_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
					OR 
					(CRS.ACTION_TABLE ='VOUCHER' AND CRS.ACTION_ID IN (SELECT VOUCHER_ID FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (3,7) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
					OR	
					(CRS.ACTION_TABLE ='VOUCHER_PAYROLL' AND CRS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM #dsn2_alias#.VOUCHER V,#dsn2_alias#.VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CRS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (3,7) OR (V.VOUCHER_STATUS_ID = 4 AND V.VOUCHER_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
					OR 
					(CRS.ACTION_TABLE <>'PAYROLL' AND CRS.ACTION_TABLE <> 'CHEQUE' AND CRS.ACTION_TABLE <> 'VOUCHER' AND CRS.ACTION_TABLE <> 'VOUCHER_PAYROLL')
					)			
				</cfif>
				<!--- BK 20100329 Odenmemis Talimatlari Getirme secili ise calisan blok --->
				<cfif isdefined("attributes.is_pay_bankorders")>
					AND
					(
						CRS.ACTION_TYPE_ID IN (260,251) AND CRS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM #dsn2#.BANK_ORDERS WHERE IS_PAID = 1) OR
						CRS.ACTION_TYPE_ID NOT IN (260,251)
					)
				</cfif>	
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
				</cfif>
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfind(attributes.member_cat_type,'3-0',',')>
					AND C.IS_RELATED_COMPANY = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
					AND C.IS_BUYER = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
					AND C.IS_SELLER= 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL = 1
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif isdefined("attributes.money_info") and len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur degerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <><cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
					</cfif>
					AND CRS.TO_CMP_ID IN
					(SELECT 
						COMPANY_BRANCH_RELATED.COMPANY_ID
					FROM 
						BRANCH, 
						EMPLOYEE_POSITION_BRANCHES,
						COMPANY_BRANCH_RELATED
					WHERE 
						EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
						EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID  AND
						COMPANY_BRANCH_RELATED.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID)
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
			<!--- <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				AND	C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and len(list_company)>
				AND	C.COMPANYCAT_ID IN (#list_company#)
			</cfif>
             <cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
                AND C.IS_BUYER = 1
            </cfif>
            <cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
                AND C.IS_SELLER= 1
            </cfif>
            <cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
                AND C.ISPOTANTIAL = 1
            </cfif>
			<cfif isdefined("attributes.country") and len(attributes.country)>
				AND	C.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
			</cfif>
			<cfif isdefined("attributes.city") and len(attributes.city)>
				AND	C.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"> 
			</cfif>
			<cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>
				AND C.COMPANY_ID = WEP.COMPANY_ID
				AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.COMPANY_ID IS NOT NULL
			</cfif>
			<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
				AND C.OZEL_KOD =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
			</cfif>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                AND (
                	C.FULLNAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                	OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                   	)
            </cfif>
			<cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
				AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
			</cfif>
			<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
				AND
				(
					CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
					CRS.DUE_DATE IS NULL
				)
				AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
			</cfif> --->
		GROUP BY 
			C.FULLNAME,
			CRS.FROM_CMP_ID,
			CRS.ACTION_DATE
	) AS ALL_ROWS
	GROUP BY 
		ALL_ROWS.COMP_ID,
		ALL_ROWS.FULLNAME
	<cfif isDefined("attributes.duty_claim") and len(attributes.duty_claim)>
		<cfif attributes.duty_claim eq 1>
			<cfif isdefined("attributes.is_zero_bakiye")>
				HAVING ROUND(SUM(BORC1-ALACAK1),2) >= 0
			<cfelse>
				HAVING ROUND(SUM(BORC1-ALACAK1),2) >= 0	
			</cfif>
		<cfelseif attributes.duty_claim eq 2>
			HAVING ROUND(SUM(BORC1-ALACAK1),2)  < 0
		</cfif>
	<cfelseif isdefined("attributes.is_zero_bakiye")>
		HAVING ROUND(SUM(BORC1-ALACAK1),2) <> 0 
	</cfif>
	ORDER BY 
		ALL_ROWS.FULLNAME
</cfquery>
<cfif len(get_company.company_id)>
	<cfquery name="get_member_name_" datasource="#dsn#">
		SELECT
			COMPANY_ID,
			FULLNAME MEMBER_NAME,
			TAXOFFICE TAXOFFICE,
			TAXNO TAXNO,
			COMPANY_ADDRESS MEMBER_ADDRESS,
			COMPANY_TELCODE MEMBER_TELCODE,
			COMPANY_TEL1 MEMBER_TEL,
			COMPANY_FAX MEMBER_FAKS,
			ISNULL(COUNTY,0) MEMBER_COUNTY,
			ISNULL(CITY,0) MEMBER_CITY,
			ISNULL(COUNTRY,0) MEMBER_COUNTRY,
			SEMT MEMBER_SEMT
		FROM
			COMPANY
		WHERE 
			COMPANY_ID IN (#valuelist(get_company.company_id)#)
	</cfquery>
	<cfquery name="get_city" datasource="#DSN#">
		SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#listdeleteduplicates(valuelist(get_member_name_.member_city))#)
	</cfquery>
	<cfquery name="get_county" datasource="#DSN#">
		SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#listdeleteduplicates(valuelist(get_member_name_.member_county))#)
	</cfquery>
	<cfquery name="get_country" datasource="#dsn#">
		SELECT COUNTRY_ID, COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#listdeleteduplicates(valuelist(get_member_name_.member_country))#)
	</cfquery>
	<cfquery name="get_our_company_info" datasource="#dsn#">
		SELECT ASSET_FILE_NAME3,COMPANY_NAME,ADDRESS,TAX_OFFICE,TAX_NO,TEL_CODE,TEL,TEL2,FAX,FAX2,EMAIL FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
	</cfquery>
</cfif>
<!-- sil -->
<table style="width:190mm;" border="0" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td  style="text-align:right;"><cf_workcube_file_action  mail='1' doc='1' print='1'></td>
		<td align="left"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=ch.popup_duty_claim_print_all_pdf&#page_code#</cfoutput>','small')"><img src="images/pdf.gif" alt="PDF" title="PDF" border="0"></a></td>
	</tr>
</table>
<!-- sil -->
<cfoutput query="GET_COMPANY">
	<table style="width:195mm; height:290mm;" border="0" cellpadding="0" cellspacing="0">
		<tr align="left">
			<td style="width:7mm;">&nbsp;</td>
			<td colspan="2" align="center" style="height:40mm;width:188mm;">
				<cfif len(get_our_company_info.asset_file_name3)>
					<img src="#user_domain##file_web_path#settings/#get_our_company_info.asset_file_name3#" alt="" border="0">
				</cfif>
			</td>
		</tr>
		<tr>
			<td style="text-align:right;" style="width:7mm;">&nbsp;</td>
			<td style="text-align:right;" valign="top" style="width:188mm;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr style="height:10mm;">
					<td>&nbsp;</td>
					<td class="txtbold" style="text-align:right;">Tarih: #dateformat(now(),dateformat_style)#</td>
				</tr>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr style="height:10mm;">
					<cfif len(get_company.company_id)>
						<cfquery name="get_member_name" dbtype="query">
							SELECT * FROM get_member_name_ WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
						</cfquery>
						<cfif get_member_name.recordcount and len(get_member_name.member_county)>
						<cfquery name="get_county_" dbtype="query">
							SELECT * FROM get_county WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member_name.member_county#">
						</cfquery>
						</cfif>
						<cfif get_member_name.recordcount and len(get_member_name.member_city)>
						<cfquery name="get_city_" dbtype="query">
							SELECT * FROM get_city WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member_name.member_city#">
						</cfquery>
						</cfif>
						<cfif get_member_name.recordcount and len(get_member_name.member_country)>
						<cfquery name="get_country_" dbtype="query">
							SELECT * FROM get_country WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member_name.member_country#">
						</cfquery>
						</cfif>
					</cfif>
					<td style="height:45mm;">
						<br/><br/><br/>
						Sayın,<br/><br/>
						<b>#get_member_name.member_name#</b><br/>
						#get_member_name.member_address# #get_member_name.member_semt#<br/>
						<cfif len(get_company.company_id) and len(get_member_name.member_county)>#get_county_.county_name# /</cfif>
						<cfif len(get_company.company_id) and len(get_member_name.member_city)>#get_city_.city_name# /</cfif>
						<cfif len(get_company.company_id) and len(get_member_name.member_country)>#get_country_.country_name#</cfif><br/>
						Vergi D : #get_member_name.taxoffice# - Vergi No : #get_member_name.taxno#<br/>
						Tel : #get_member_name.member_telcode# #get_member_name.member_tel# - Fax : #get_member_name.member_faks#<br/>
					</td>
				</tr>
			</table>
			<table width="100%" border="0" style="height:70mm;" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td><cfset myNumber = abs(filterNum(tlformat(bakiye)))>
						<cf_n2txt number="myNumber">
						Nezdimizdeki Cari Hesabınız <strong>&nbsp;#DateFormat(tarih_,dateformat_style)#&nbsp;</strong> tarihi itibari ile <strong>#TLFormat(abs(bakiye))#
						#session.ep.money# <cfif len(bakiye) and bakiye neq 0>(#myNumber#)</cfif>&nbsp;&nbsp;<cfif BORC gt ALACAK>Borç<cfelseif BORC lt ALACAK>Alacak</cfif>&nbsp;&nbsp;</strong> <cf_get_lang dictionary_id="33290.bakiye göstermektedir">.<br/>
						<br/>
						<cf_get_lang dictionary_id="33289.Mutabık olup olmadığımızı bildirmenizi rica ederiz">.
						<br/><br/>
					</td>
				</tr>
				<tr align="left">
					<td valign="top">
					<table border="0" width="100%">
						<tr>
							<!--- <td style="width:130mm;">&nbsp;</td> --->
							<td align="left">
								<cfquery name="get_position" datasource="#dsn#">
									SELECT
										EP.EMPLOYEE_NAME,
										EP.EMPLOYEE_SURNAME,
										PC.POSITION_CAT
									FROM
										EMPLOYEE_POSITIONS EP,
										SETUP_POSITION_CAT PC
									WHERE
										EP.POSITION_CAT_ID = PC.POSITION_CAT_ID AND
										EP.IS_MASTER = 1 AND
										EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
								</cfquery>
								<cfif Len(get_position.position_cat)>
									<br/>
									<strong>
									#get_position.employee_name# #get_position.employee_surname# <br/>
									#get_position.position_cat#
									</strong>
								</cfif>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="bottom">
					<td><u><strong><cf_get_lang dictionary_id="49048.HATA VE UNUTMA İSTİSNADIR"></strong></u><br/><br/>
						1-) <cf_get_lang dictionary_id="30423.Mutabakat veya itirazınızı 1 ay içerisinde bildirmediğiniz takdirde T.T.K. nun 92. maddesi gereğince bakiyede mutabık sayılacağımızı hatırlatırız">.<br/>
						2-) <cf_get_lang dictionary_id="30411.Bakiyede mutabık olmadığınız takdirde hesap ekstrenizi aşağıda belirtilen faks numaralarına veya mail adresine göndermenizi rica ederiz">.<br/>
					</td>
				</tr>
			</table>
			<br/><hr style="border-style:groove;">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td style="text-align:right;">....../....../............</td>
				</tr>
				<tr>
					<td>Sayın, <br/><br/>
						<strong>#get_our_company_info.company_name#</strong><br/>
						#get_our_company_info.address#<br/>
						Vergi D: #get_our_company_info.tax_office# - Vergi No: #get_our_company_info.tax_no#<br/>
						Tel: #get_our_company_info.tel_code# #get_our_company_info.tel# - #get_our_company_info.tel2#<br/>
						Fax: #get_our_company_info.tel_code# #get_our_company_info.fax# - #get_our_company_info.fax2#<br/>
						E-Mail : #get_our_company_info.email#
						<br/><br/>
					    Nezdimizdeki cari hesabınız ....../....../............ tarihi itibariyle ........................................... #session.ep.money# Borç/Alacak bakiye vermektedir.
						<cf_get_lang dictionary_id="30410.Mutabık olduğumuzu/olmadığımızı bildiririz">.
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	<cfif currentrow neq recordcount>
		<div style="page-break-after: always"></div>
	</cfif>
</cfoutput>
