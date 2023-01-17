<cfset list_acc_type_id = "">
<cfset list_company = "">
<cfset list_consumer = "">
<cfset ch_alias = 'CR.'>
<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfif is_select_process_cat eq 0>
	<cfif isdefined("attributes.action_type") and len(attributes.action_type)>
		<cfset new_process_type = replacelist(attributes.action_type,"410,420,310,320,240,253,430","41,42,31,32,24,25,43")>
	<cfelse>
		<cfset new_process_type = "">
	</cfif>
<cfelse>
	<cfset new_process_cat = attributes.action_type>
</cfif>
<cfquery name="CARI_ROWS" datasource="#new_dsn#">
	SELECT 
		CR.ACTION_ID,
		CR.CARI_ACTION_ID,
		CR.ACTION_TYPE_ID,
		CR.ACTION_TABLE,
		CR.OTHER_MONEY,
		CR.PAPER_NO,
		CR.ACTION_NAME,
		CR.PROCESS_CAT,
		ISNULL(CR.PROJECT_ID,0) PROJECT_ID,
		ISNULL(CR.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
		ISNULL(CR.ACC_TYPE_ID,0) AS ACC_TYPE_ID,
		CR.TO_CMP_ID,
		CR.TO_CONSUMER_ID,
		CR.TO_EMPLOYEE_ID,
		CR.FROM_CMP_ID,
		CR.FROM_CONSUMER_ID,
		CR.FROM_EMPLOYEE_ID,
		CR.DUE_DATE,
		CR.ACTION_DETAIL,
		CR.ACTION_DATE AS ACTION_DATE, 
		CR.RECORD_DATE, 
		0 AS BORC, 
		0 AS BORC2,
		0 AS BORC_OTHER,
		CR.ACTION_VALUE AS ALACAK,
		CR.ACTION_VALUE_2 AS ALACAK2,
		ISNULL(CR.OTHER_CASH_ACT_VALUE,0) AS ALACAK_OTHER,
		0 AS PAY_METHOD,
		CR.IS_PROCESSED,
		0 DETAIL_TYPE,
		'' STOCK_CODE,
		'' NAME_PRODUCT,
		0 AMOUNT,
		'' UNIT,
		0 PRICE,
		0 TAX,
		0 GROSSTOTAL,
		0 PRICE_OTHER,
		0 OTHER_MONEY_GROSS_TOTAL,
		'' ROW_MONEY,
		'' EXP_DETAIL,
		'' EXPENSE_ITEM_NAME,
		'' EXPENSE_CENTER,
		0 OTV_RATE,
		'' ROW_PROJECT_ID,
		'' SPECT_VAR_NAME,
		'' DISCOUNT1,
		'' DISCOUNT2,
		'' DISCOUNT3,
		'' DISCOUNT4,
		'' DISCOUNT5,
		'' DISCOUNT6,
		'' DISCOUNT7,
		'' DISCOUNT8,
		'' DISCOUNT9,
		'' DISCOUNT10,
		0 ACTION_ROW_ID,
		RATE2,
		'' INV_WRK_ROW_REL_ID,
		'' INV_WRK_ROW_ID
	FROM 
		CARI_ROWS CR
        	LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = CR.PROJECT_ID
	WHERE 
		1 = 1
		AND (FROM_CMP_ID IS NOT NULL OR FROM_CONSUMER_ID IS NOT NULL OR FROM_EMPLOYEE_ID IS NOT NULL)
		<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
			AND CR.FROM_CMP_ID = #attributes.COMPANY_ID#
		<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
			AND CR.FROM_CONSUMER_ID = #attributes.consumer_id#
		<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
			AND CR.FROM_EMPLOYEE_ID = #attributes.employee_id#
		</cfif>
        <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0 and isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
			AND CR.ACC_TYPE_ID = #attributes.acc_type_id#
		</cfif>
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
			AND CR.ASSETP_ID = #attributes.asset_id#
		</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
			AND CR.SUBSCRIPTION_ID = #attributes.subscription_id#
		</cfif>
		 <cfif isdefined("attributes.acc_type") and len(attributes.acc_type) and attributes.acc_type neq 0 and ((isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner'))>
			AND CR.ACC_TYPE_ID = #attributes.acc_type#
		</cfif>
        <cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
        <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
        <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
            AND CR.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
        </cfif>
		<!--- işlem tiplerine göre arama --->
		<cfif isDefined("new_process_type") and len(new_process_type)>
			AND CR.ACTION_TYPE_ID IN (#new_process_type#)
		</cfif>
        <cfif (len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)) and (len(attributes.employee_id) and len(attributes.company) and member_type is 'employee')><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
            AND #control_acc_type_list#
        </cfif>
		<!--- process catlara göre arama --->
		<cfif isDefined("new_process_cat") and len(new_process_cat)>
			AND 
			(
				(CR.PROCESS_CAT <> 0 AND CR.PROCESS_CAT IN (#new_process_cat#))
				OR
				(
					CR.PROCESS_CAT = 0
					AND
					(
						(ACTION_ID IN (SELECT ACT.ACTION_ID FROM BANK_ACTIONS ACT,BANK_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
						OR
						(ACTION_ID IN (SELECT ACT.ACTION_ID FROM CASH_ACTIONS ACT,CASH_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
						OR
						(ACTION_ID IN (SELECT ACT.ACTION_ID FROM CARI_ACTIONS ACT,CARI_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
					)
				)
			)
		</cfif>
		<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
			<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
				AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
			<cfelse>
				AND OTHER_MONEY = '#attributes.other_money#'
			</cfif>
		</cfif>
		<!---<cfif is_show_store_acts eq 0 and (session.ep.isBranchAuthorization or isdefined("is_store_module"))>
			AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
		</cfif>--->
        <!--- multi selectbox sube filtesi --->
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND (CR.FROM_BRANCH_ID IS NOT NULL AND CR.FROM_BRANCH_ID IN (#attributes.branch_id#) OR CR.TO_BRANCH_ID IS NOT NULL AND CR.TO_BRANCH_ID IN (#attributes.branch_id#))

		<cfelseif is_show_store_acts eq 0 and session.ep.isBranchAuthorization>
			AND (
				(CR.FROM_BRANCH_ID IS NOT NULL AND CR.FROM_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">) OR CR.TO_BRANCH_ID IS NOT NULL AND CR.TO_BRANCH_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
				OR 
				(
					CR.FROM_BRANCH_ID IN (
					SELECT 
						BRANCH_ID
					FROM 
						#dsn_alias#.BRANCH 
					WHERE 
						BRANCH_STATUS = 1 
						AND COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				)
			) or (
					CR.TO_BRANCH_ID IN (
					SELECT 
						BRANCH_ID 
					FROM 
						#dsn_alias#.BRANCH 
					WHERE 
						BRANCH_STATUS = 1 
						AND COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				)
			))
		<cfelseif is_show_store_acts eq 0 and (session.ep.isBranchAuthorization or isdefined("is_store_module"))>
			AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
		</cfif>
        <!--- multi selectbox proje kategorisi filtesi --->
        <cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
			AND	PRO_PROJECTS.PROCESS_CAT IN (#attributes.process_catid#)
		</cfif>
		<cfif isdefined('attributes.project_id') and len(attributes.project_head) and attributes.project_id eq -1>
			AND CR.PROJECT_ID IS NULL
		<cfelseif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
			AND CR.PROJECT_ID = #attributes.project_id#
		</cfif>
		<cfif isdefined("attributes.is_pay_cheques")>
			AND
			(
			(CR.ACTION_TABLE = 'CHEQUE' AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #new_date# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (3,7) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#))))
			OR	
			(CR.ACTION_TABLE = 'PAYROLL' AND CR.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM CHEQUE C,CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CR.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND  (ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #new_date# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (3,7) OR (C.CHEQUE_STATUS_ID = 4 AND C.CHEQUE_DUEDATE <= #new_date#))))
			OR 
			(CR.ACTION_TABLE = 'VOUCHER' AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #new_date# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (3,7) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #new_date#))))
			OR	
			(CR.ACTION_TABLE = 'VOUCHER_PAYROLL' AND CR.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM VOUCHER V,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CR.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND  (ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #new_date# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (3,7) OR( V.VOUCHER_STATUS_ID = 4 AND V.VOUCHER_DUEDATE < #new_date#))))
			OR 
			(CR.ACTION_TABLE <> 'PAYROLL' AND CR.ACTION_TABLE <> 'CHEQUE' AND CR.ACTION_TABLE <> 'VOUCHER' AND CR.ACTION_TABLE <> 'VOUCHER_PAYROLL')
			)			
		</cfif>
		<cfif isdefined("attributes.is_pay_bankorders")>
			AND
			(
				CR.ACTION_TYPE_ID IN (260,251) AND CR.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1) OR
				CR.ACTION_TYPE_ID NOT IN (260,251)
			)
		</cfif>
	UNION ALL
	
	SELECT
		CR.ACTION_ID,
		CR.CARI_ACTION_ID,
		CR.ACTION_TYPE_ID,
		CR.ACTION_TABLE,
		CR.OTHER_MONEY,
		CR.PAPER_NO,
		CR.ACTION_NAME,
		CR.PROCESS_CAT,
		ISNULL(CR.PROJECT_ID,0) PROJECT_ID,
		ISNULL(CR.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
		ISNULL(CR.ACC_TYPE_ID,0) AS ACC_TYPE_ID,
		CR.TO_CMP_ID,
		CR.TO_CONSUMER_ID,
		CR.TO_EMPLOYEE_ID,
		CR.FROM_CMP_ID,
		CR.FROM_CONSUMER_ID,
		CR.FROM_EMPLOYEE_ID,
		CR.DUE_DATE,
		CR.ACTION_DETAIL,
		CR.ACTION_DATE AS ACTION_DATE, 
		CR.RECORD_DATE, 
		CR.ACTION_VALUE AS BORC,
		ISNULL(CR.ACTION_VALUE_2,0) AS BORC2,
		ISNULL(CR.OTHER_CASH_ACT_VALUE,0) AS BORC_OTHER,
		0 AS ALACAK,
		0 AS ALACAK2,
		0 AS ALACAK_OTHER,
		0 AS PAY_METHOD,
		CR.IS_PROCESSED,
		0 DETAIL_TYPE,
		'' STOCK_CODE,
		'' NAME_PRODUCT,
		0 AMOUNT,
		'' UNIT,
		0 PRICE,
		0 TAX,
		0 GROSSTOTAL,
		0 PRICE_OTHER,
		0 OTHER_MONEY_GROSS_TOTAL,
		'' ROW_MONEY,
		'' EXP_DETAIL,
		'' EXPENSE_ITEM_NAME,
		'' EXPENSE_CENTER,
		0 OTV_RATE,
		'' ROW_PROJECT_ID,
		'' SPECT_VAR_NAME,
		'' DISCOUNT1,
		'' DISCOUNT2,
		'' DISCOUNT3,
		'' DISCOUNT4,
		'' DISCOUNT5,
		'' DISCOUNT6,
		'' DISCOUNT7,
		'' DISCOUNT8,
		'' DISCOUNT9,
		'' DISCOUNT10,
		0 ACTION_ROW_ID,
		RATE2,
		'' INV_WRK_ROW_REL_ID,
		'' INV_WRK_ROW_ID
	FROM 
		CARI_ROWS CR
        	LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = CR.PROJECT_ID
	WHERE
		1 = 1
		AND (TO_CMP_ID IS NOT NULL OR TO_CONSUMER_ID IS NOT NULL OR TO_EMPLOYEE_ID IS NOT NULL)
		<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
			AND CR.TO_CMP_ID = #attributes.COMPANY_ID#
		<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
			AND CR.TO_CONSUMER_ID = #attributes.consumer_id#
		<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
			AND CR.TO_EMPLOYEE_ID = #attributes.employee_id#
		</cfif>
        <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0 and isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
			AND CR.ACC_TYPE_ID = #attributes.acc_type_id#
		</cfif>
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
			AND CR.ASSETP_ID = #attributes.asset_id#
		</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
			AND CR.SUBSCRIPTION_ID = #attributes.subscription_id#
		</cfif>
		 <cfif isdefined("attributes.acc_type") and len(attributes.acc_type) and attributes.acc_type neq 0 and ((isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner'))>
			AND CR.ACC_TYPE_ID = #attributes.acc_type#
		</cfif>
        <cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
        <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
        <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
            AND CR.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
        </cfif>
		<cfif isDefined("new_process_type") and len(new_process_type)>
			AND CR.ACTION_TYPE_ID IN (#new_process_type#)
		</cfif>
        <cfif (len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)) and (len(attributes.employee_id) and len(attributes.company) and member_type is 'employee')><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
            AND #control_acc_type_list#
        </cfif>
		<!--- process catlara göre arama --->
		<cfif isDefined("new_process_cat") and len(new_process_cat)>
			AND 
			(
				(CR.PROCESS_CAT <> 0 AND CR.PROCESS_CAT IN (#new_process_cat#))
				OR
				(
					CR.PROCESS_CAT = 0
					AND
					(
						(ACTION_ID IN (SELECT ACT.ACTION_ID FROM BANK_ACTIONS ACT,BANK_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
						OR
						(ACTION_ID IN (SELECT ACT.ACTION_ID FROM CASH_ACTIONS ACT,CASH_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
						OR
						(ACTION_ID IN (SELECT ACT.ACTION_ID FROM CARI_ACTIONS ACT,CARI_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
					)
				)
			)
		</cfif>
		<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
			<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
				AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
			<cfelse>
				AND OTHER_MONEY = '#attributes.other_money#'
			</cfif>
		</cfif>
	<!---	<cfif is_show_store_acts eq 0 and (session.ep.isBranchAuthorization or isdefined("is_store_module"))>
			AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
		</cfif>---->
        <!--- multi selectbox sube filtesi --->
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND  (CR.FROM_BRANCH_ID IS NOT NULL AND CR.FROM_BRANCH_ID IN (#attributes.branch_id#) OR CR.TO_BRANCH_ID IS NOT NULL AND CR.TO_BRANCH_ID IN (#attributes.branch_id#))
		<cfelseif is_show_store_acts eq 0 and session.ep.isBranchAuthorization>
			AND (
			 (CR.FROM_BRANCH_ID IS NOT NULL AND CR.FROM_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">) OR CR.TO_BRANCH_ID IS NOT NULL AND CR.TO_BRANCH_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
			 OR 
				(
					CR.FROM_BRANCH_ID IN (
					SELECT 
						BRANCH_ID
					FROM 
						#dsn_alias#.BRANCH 
					WHERE 
						BRANCH_STATUS = 1 
						AND COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				)
			) or (
					CR.TO_BRANCH_ID IN (
					SELECT 
						BRANCH_ID 
					FROM 
						#dsn_alias#.BRANCH 
					WHERE 
						BRANCH_STATUS = 1 
						AND COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				)
			))
		<cfelseif is_show_store_acts eq 0 and (session.ep.isBranchAuthorization or isdefined("is_store_module"))>
			AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
		</cfif>
        <!--- multi selectbox proje kategorisi filtesi --->
        <cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
			AND	PRO_PROJECTS.PROCESS_CAT IN (#attributes.process_catid#)
		</cfif>
		<cfif isdefined('attributes.project_id') and len(attributes.project_head) and attributes.project_id eq -1>
			AND CR.PROJECT_ID IS NULL
		<cfelseif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
			AND CR.PROJECT_ID = #attributes.project_id#
		</cfif>
		<cfif isdefined("attributes.is_pay_cheques")>
			AND
			(
			(CR.ACTION_TABLE = 'CHEQUE' AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #new_date# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (3,7) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#))))
			OR	
			(CR.ACTION_TABLE = 'PAYROLL' AND CR.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM CHEQUE C,CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CR.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND  (ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #new_date# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (3,7) OR (C.CHEQUE_STATUS_ID = 4 AND C.CHEQUE_DUEDATE <= #new_date#))))
			OR 
			(CR.ACTION_TABLE = 'VOUCHER' AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #new_date# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (3,7) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #new_date#))))
			OR	
			(CR.ACTION_TABLE = 'VOUCHER_PAYROLL' AND CR.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM VOUCHER V,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CR.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND  (ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #new_date# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (3,7) OR( V.VOUCHER_STATUS_ID = 4 AND V.VOUCHER_DUEDATE < #new_date#))))
			OR 
			(CR.ACTION_TABLE <> 'PAYROLL' AND CR.ACTION_TABLE <> 'CHEQUE' AND CR.ACTION_TABLE <> 'VOUCHER' AND CR.ACTION_TABLE <> 'VOUCHER_PAYROLL')
			)			
		</cfif>
		<cfif isdefined("attributes.is_pay_bankorders")>
			AND
			(
				CR.ACTION_TYPE_ID IN (260,251) AND CR.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1) OR
				CR.ACTION_TYPE_ID NOT IN (260,251)
			)
		</cfif>
	<cfif listfind(attributes.list_type,10)><!--- stoklu extre için --->
	UNION ALL
		SELECT
			CR.ACTION_ID,
			CR.CARI_ACTION_ID,
			CR.ACTION_TYPE_ID,
			CR.ACTION_TABLE,
			CR.OTHER_MONEY,
			CR.PAPER_NO,
			CR.ACTION_NAME,
			CR.PROCESS_CAT,
			ISNULL(CR.PROJECT_ID,0) PROJECT_ID,
			CR.SUBSCRIPTION_ID,
			ISNULL(CR.ACC_TYPE_ID,0) AS ACC_TYPE_ID,
			CR.TO_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_CMP_ID,
			CR.FROM_CONSUMER_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.DUE_DATE,
			CR.ACTION_DETAIL,
			CR.ACTION_DATE,
			CR.RECORD_DATE,  
			0 BORC,
			0 BORC2,
			0 BORC_OTHER,
			0 ALACAK,
			0 ALACAK2,
			0 ALACAK_OTHER,
			0 PAY_METHOD,
			0 IS_PROCESSED,
			1 DETAIL_TYPE,<!--- STOKLU EXTRE tipi için ve altta gerekli alanlar var --->
			S.STOCK_CODE,
			INVOICE_ROW.NAME_PRODUCT,
			INVOICE_ROW.AMOUNT,
			INVOICE_ROW.UNIT,
			INVOICE_ROW.PRICE,
			INVOICE_ROW.TAX,
			INVOICE_ROW.GROSSTOTAL,
			INVOICE_ROW.PRICE_OTHER,
			INVOICE_ROW.OTHER_MONEY_GROSS_TOTAL,
			INVOICE_ROW.OTHER_MONEY ROW_MONEY,
			'' EXP_DETAIL,
			'' EXPENSE_ITEM_NAME,
			'' EXPENSE_CENTER,
			0 OTV_RATE,
			'' ROW_PROJECT_ID,
			ISNULL(INVOICE_ROW.SPECT_VAR_NAME,' ') SPECT_VAR_NAME,
			INVOICE_ROW.DISCOUNT1,
			INVOICE_ROW.DISCOUNT2,
			INVOICE_ROW.DISCOUNT3,
			INVOICE_ROW.DISCOUNT4,
			INVOICE_ROW.DISCOUNT5,
			INVOICE_ROW.DISCOUNT6,
			INVOICE_ROW.DISCOUNT7,
			INVOICE_ROW.DISCOUNT8,
			INVOICE_ROW.DISCOUNT9,
			INVOICE_ROW.DISCOUNT10,
			INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
			'' RATE2,
			INVOICE_ROW.WRK_ROW_RELATION_ID INV_WRK_ROW_REL_ID,
			INVOICE_ROW.WRK_ROW_ID INV_WRK_ROW_ID			
		FROM 
			CARI_ROWS CR
            	LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = CR.PROJECT_ID,
			INVOICE,
			INVOICE_ROW,
			#dsn3_alias#.STOCKS S
		WHERE
			INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
			INVOICE.INVOICE_ID = CR.ACTION_ID AND
			INVOICE.INVOICE_CAT = CR.ACTION_TYPE_ID AND
			CR.ACTION_TABLE = 'INVOICE' AND
			S.STOCK_ID = INVOICE_ROW.STOCK_ID AND
			S.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID
			AND
			(
				((SELECT COUNT(CRR.ACTION_ID) FROM CARI_ROWS CRR WHERE CRR.ACTION_TYPE_ID = INVOICE.INVOICE_CAT AND CRR.ACTION_ID = INVOICE.INVOICE_ID)  > 1 AND DATEADD(day,INVOICE_ROW.DUE_DATE,INVOICE.INVOICE_DATE) = CR.DUE_DATE AND INVOICE_ROW.OTHER_MONEY = CR.OTHER_MONEY)
				OR 
				(SELECT COUNT(CRR.ACTION_ID) FROM CARI_ROWS CRR WHERE CRR.ACTION_TYPE_ID = INVOICE.INVOICE_CAT AND CRR.ACTION_ID = INVOICE.INVOICE_ID) = 1
			)			
		<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
			AND (CR.TO_CMP_ID = #attributes.COMPANY_ID# OR CR.FROM_CMP_ID = #attributes.COMPANY_ID#)
		<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
			AND (CR.TO_CONSUMER_ID = #attributes.consumer_id# OR CR.FROM_CONSUMER_ID = #attributes.consumer_id#)
		<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
			AND (CR.TO_EMPLOYEE_ID = #attributes.employee_id# OR CR.FROM_EMPLOYEE_ID = #attributes.employee_id#)
		</cfif>
        <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0 and isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
			AND CR.ACC_TYPE_ID = #attributes.acc_type_id#
		</cfif>
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
			AND CR.ASSETP_ID = #attributes.asset_id#
		</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
			AND CR.SUBSCRIPTION_ID = #attributes.subscription_id#
		</cfif>
		 <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0 and ((isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'partner'))>
			AND CR.ACC_TYPE_ID = #attributes.acc_type#
		</cfif>
        <cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
        <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
        <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
            AND CR.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
        </cfif>
		<cfif isDefined("new_process_type") and len(new_process_type)>
			AND CR.ACTION_TYPE_ID IN (#new_process_type#)
		</cfif>
		<!--- process catlara göre arama --->
		<cfif isDefined("new_process_cat") and len(new_process_cat)>
			AND 
			(
				(CR.PROCESS_CAT <> 0 AND CR.PROCESS_CAT IN (#new_process_cat#))
				OR
				(
					CR.PROCESS_CAT = 0
					AND
					(
						(CR.ACTION_ID IN (SELECT ACT.ACTION_ID FROM BANK_ACTIONS ACT,BANK_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
						OR
						(CR.ACTION_ID IN (SELECT ACT.ACTION_ID FROM CASH_ACTIONS ACT,CASH_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
						OR
						(CR.ACTION_ID IN (SELECT ACT.ACTION_ID FROM CARI_ACTIONS ACT,CARI_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
					)
				)
			)
		</cfif>
		<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
			<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
				AND (CR.OTHER_MONEY = 'YTL' OR CR.OTHER_MONEY = 'TL')
			<cfelse>
				AND CR.OTHER_MONEY = '#attributes.other_money#'
			</cfif>
		</cfif>
		<!---<cfif is_show_store_acts eq 0 and (session.ep.isBranchAuthorization or isdefined("is_store_module"))>
			AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
		</cfif>---->
        <!--- multi selectbox sube filtesi --->
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND (CR.FROM_BRANCH_ID IS NOT NULL AND CR.FROM_BRANCH_ID IN (#attributes.branch_id#) OR CR.TO_BRANCH_ID IS NOT NULL AND CR.TO_BRANCH_ID IN (#attributes.branch_id#))
		<cfelseif is_show_store_acts eq 0 and session.ep.isBranchAuthorization>
			AND (
				(CR.FROM_BRANCH_ID IS NOT NULL AND CR.FROM_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">) OR CR.TO_BRANCH_ID IS NOT NULL AND CR.TO_BRANCH_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
				OR 
				(
					CR.FROM_BRANCH_ID IN (
					SELECT 
						BRANCH_ID
					FROM 
						#dsn_alias#.BRANCH 
					WHERE 
						BRANCH_STATUS = 1 
						AND COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				)
			) or (
					CR.TO_BRANCH_ID IN (
					SELECT 
						BRANCH_ID 
					FROM 
						#dsn_alias#.BRANCH 
					WHERE 
						BRANCH_STATUS = 1 
						AND COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				)
			))
		<cfelseif is_show_store_acts eq 0 and (session.ep.isBranchAuthorization or isdefined("is_store_module"))>
			AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
		</cfif>
        <!--- multi selectbox proje kategorisi filtesi --->
        <cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
			AND	PRO_PROJECTS.PROCESS_CAT IN (#attributes.process_catid#)
		</cfif>
		<cfif isdefined('attributes.project_id') and len(attributes.project_head) and attributes.project_id eq -1>
			AND CR.PROJECT_ID IS NULL
		<cfelseif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
			AND CR.PROJECT_ID = #attributes.project_id#
		</cfif>
		<cfif isdefined("attributes.is_pay_cheques")>
			AND
			(
			(CR.ACTION_TABLE = 'CHEQUE' AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND (CHEQUE_STATUS_ID IN (3,7) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#))))
			OR	
			(CR.ACTION_TABLE = 'PAYROLL' AND CR.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM CHEQUE C,CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CR.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND  (C.CHEQUE_STATUS_ID IN (3,7) OR (C.CHEQUE_STATUS_ID = 4 AND C.CHEQUE_DUEDATE <= #new_date#))))
			OR 
			(CR.ACTION_TABLE = 'VOUCHER' AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND (VOUCHER_STATUS_ID IN (3,7) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #new_date#))))
			OR	
			(CR.ACTION_TABLE = 'VOUCHER_PAYROLL' AND CR.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM VOUCHER V,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CR.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND  (V.VOUCHER_STATUS_ID IN (3,7) OR (V.VOUCHER_STATUS_ID = 4 AND V.VOUCHER_DUEDATE < #new_date#))))
			OR 
			(CR.ACTION_TABLE <> 'PAYROLL' AND CR.ACTION_TABLE <> 'CHEQUE' AND CR.ACTION_TABLE <> 'VOUCHER' AND CR.ACTION_TABLE <> 'VOUCHER_PAYROLL')
			)			
		</cfif>
		<cfif isdefined("attributes.is_pay_bankorders")>
			AND
			(
				CR.ACTION_TYPE_ID IN (260,251) AND CR.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1) OR
				CR.ACTION_TYPE_ID NOT IN (260,251)
			)
		</cfif>
	UNION ALL
		SELECT
			CR.ACTION_ID,
			CR.CARI_ACTION_ID,
			CR.ACTION_TYPE_ID,
			CR.ACTION_TABLE,
			CR.OTHER_MONEY,
			CR.PAPER_NO,
			CR.ACTION_NAME,
			CR.PROCESS_CAT,
			ISNULL(CR.PROJECT_ID,0) PROJECT_ID,
			CR.SUBSCRIPTION_ID,
			ISNULL(CR.ACC_TYPE_ID,0) AS ACC_TYPE_ID,
			CR.TO_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.TO_EMPLOYEE_ID,
			CR.FROM_CMP_ID,
			CR.FROM_CONSUMER_ID,
			CR.FROM_EMPLOYEE_ID,
			CR.DUE_DATE,
			CR.ACTION_DETAIL,
			CR.ACTION_DATE,
			CR.RECORD_DATE,  
			0 BORC,
			0 BORC2,
			0 BORC_OTHER,
			0 ALACAK,
			0 ALACAK2,
			0 ALACAK_OTHER,
			0 PAY_METHOD,
			0 IS_PROCESSED,
			2 DETAIL_TYPE,<!--- masraftan gelenler için --->
			'' STOCK_CODE,
			'' NAME_PRODUCT,
			EXPENSE_ITEMS_ROWS.QUANTITY AMOUNT,
			'' UNIT,
			EXPENSE_ITEMS_ROWS.AMOUNT PRICE,
			EXPENSE_ITEMS_ROWS.KDV_RATE TAX,
			EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT GROSSTOTAL,
			0 PRICE_OTHER,
			EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL,
			EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID ROW_MONEY,
			EXPENSE_ITEMS_ROWS.DETAIL EXP_DETAIL,
			EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
			EXPENSE_CENTER.EXPENSE EXPENSE_CENTER,
			EXPENSE_ITEMS_ROWS.OTV_RATE,
			EXPENSE_ITEMS_ROWS.PROJECT_ID AS ROW_PROJECT_ID,
			'' SPECT_VAR_NAME,
			'' DISCOUNT1,
			'' DISCOUNT2,
			'' DISCOUNT3,
			'' DISCOUNT4,
			'' DISCOUNT5,
			'' DISCOUNT6,
			'' DISCOUNT7,
			'' DISCOUNT8,
			'' DISCOUNT9,
			'' DISCOUNT10,
			EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID ACTION_ROW_ID,
			'' RATE2,
			'' INV_WRK_ROW_REL_ID,
			'' INV_WRK_ROW_ID
		FROM 
			CARI_ROWS CR
            	LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = CR.PROJECT_ID,
			EXPENSE_ITEM_PLANS,
			EXPENSE_ITEMS_ROWS,
			EXPENSE_ITEMS,
			EXPENSE_CENTER
		WHERE
			EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND
			EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID AND
			EXPENSE_ITEM_PLANS.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID AND
			EXPENSE_ITEM_PLANS.EXPENSE_ID = CR.ACTION_ID AND
			EXPENSE_ITEM_PLANS.ACTION_TYPE = CR.ACTION_TYPE_ID AND
			CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'
		<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
			AND (CR.TO_CMP_ID = #attributes.COMPANY_ID# OR CR.FROM_CMP_ID = #attributes.COMPANY_ID#)
		<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
			AND (CR.TO_CONSUMER_ID = #attributes.consumer_id# OR CR.FROM_CONSUMER_ID = #attributes.consumer_id#)
		<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
			AND (CR.TO_EMPLOYEE_ID = #attributes.employee_id# OR CR.FROM_EMPLOYEE_ID = #attributes.employee_id#)
		</cfif>
        <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0 and isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
			AND CR.ACC_TYPE_ID = #attributes.acc_type_id#
		</cfif>
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
			AND CR.ASSETP_ID = #attributes.asset_id#
		</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
			AND CR.SUBSCRIPTION_ID = #attributes.subscription_id#
		</cfif>
		 <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0 and ((isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined('attributes.company_id') and  len(attributes.company_id) and len(attributes.company) and member_type is 'company'))>
			AND CR.ACC_TYPE_ID = #attributes.acc_type#
		</cfif>
        <cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
        <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
        <cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
            AND CR.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
        </cfif>
		<cfif isDefined("new_process_type") and len(new_process_type)>
			AND CR.ACTION_TYPE_ID IN (#new_process_type#)
		</cfif>
		<!--- process catlara göre arama --->
		<cfif isDefined("new_process_cat") and len(new_process_cat)>
			AND 
			(
				(CR.PROCESS_CAT <> 0 AND CR.PROCESS_CAT IN (#new_process_cat#))
				OR
				(
					CR.PROCESS_CAT = 0
					AND
					(
						(CR.ACTION_ID IN (SELECT ACT.ACTION_ID FROM BANK_ACTIONS ACT,BANK_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
						OR
						(CR.ACTION_ID IN (SELECT ACT.ACTION_ID FROM CASH_ACTIONS ACT,CASH_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
						OR
						(CR.ACTION_ID IN (SELECT ACT.ACTION_ID FROM CARI_ACTIONS ACT,CARI_ACTIONS_MULTI ACT_MULTI WHERE ACT.MULTI_ACTION_ID = ACT_MULTI.MULTI_ACTION_ID AND ACT.ACTION_ID = CR.ACTION_ID AND ACT.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ACT_MULTI.PROCESS_CAT IN(#new_process_cat#)))
					)
				)
			)
		</cfif>
		<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
			<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
				AND (CR.OTHER_MONEY = 'YTL' OR CR.OTHER_MONEY = 'TL')
			<cfelse>
				AND CR.OTHER_MONEY = '#attributes.other_money#'
			</cfif>
		</cfif>
		<!---<cfif is_show_store_acts eq 0 and (session.ep.isBranchAuthorization or isdefined("is_store_module"))>
			AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
		</cfif> --->
        <!--- multi selectbox sube filtesi --->
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND (CR.FROM_BRANCH_ID IS NOT NULL AND CR.FROM_BRANCH_ID IN (#attributes.branch_id#) OR CR.TO_BRANCH_ID IS NOT NULL AND CR.TO_BRANCH_ID IN (#attributes.branch_id#))
		<cfelseif is_show_store_acts eq 0 and session.ep.isBranchAuthorization>
			AND (
				(CR.FROM_BRANCH_ID IS NOT NULL AND CR.FROM_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">) OR CR.TO_BRANCH_ID IS NOT NULL AND CR.TO_BRANCH_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
				OR 
				(
					CR.FROM_BRANCH_ID IN (
					SELECT 
						BRANCH_ID
					FROM 
						#dsn_alias#.BRANCH 
					WHERE 
						BRANCH_STATUS = 1 
						AND COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				)
			) or (
					CR.TO_BRANCH_ID IN (
					SELECT 
						BRANCH_ID 
					FROM 
						#dsn_alias#.BRANCH 
					WHERE 
						BRANCH_STATUS = 1 
						AND COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						AND BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				)
			))
		<cfelseif is_show_store_acts eq 0 and (session.ep.isBranchAuthorization or isdefined("is_store_module"))>
			AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
		</cfif>
        <!--- multi selectbox proje kategorisi filtesi --->
        <cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
			AND	PRO_PROJECTS.PROCESS_CAT IN (#attributes.process_catid#)
		</cfif>
		<cfif isdefined('attributes.project_id') and len(attributes.project_head) and attributes.project_id eq -1>
			AND CR.PROJECT_ID IS NULL
		<cfelseif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
			AND CR.PROJECT_ID = #attributes.project_id#
		</cfif>
		<cfif isdefined("attributes.is_pay_cheques")>
			AND
			(
			(CR.ACTION_TABLE = 'CHEQUE' AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND (CHEQUE_STATUS_ID IN (3,7) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE <= #new_date#))))
			OR	
			(CR.ACTION_TABLE = 'PAYROLL' AND CR.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM CHEQUE C,CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CR.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND  (C.CHEQUE_STATUS_ID IN (3,7) OR (C.CHEQUE_STATUS_ID = 4 AND C.CHEQUE_DUEDATE <= #new_date#))))
			OR 
			(CR.ACTION_TABLE = 'VOUCHER' AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND (VOUCHER_STATUS_ID IN (3,7) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < #new_date#))))
			OR	
			(CR.ACTION_TABLE = 'VOUCHER_PAYROLL' AND CR.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM VOUCHER V,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CR.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND  (V.VOUCHER_STATUS_ID IN (3,7) OR (V.VOUCHER_STATUS_ID = 4 AND V.VOUCHER_DUEDATE < #new_date#))))
			OR 
			(CR.ACTION_TABLE <> 'PAYROLL' AND CR.ACTION_TABLE <> 'CHEQUE' AND CR.ACTION_TABLE <> 'VOUCHER' AND CR.ACTION_TABLE <> 'VOUCHER_PAYROLL')
			)			
		</cfif>
		<cfif isdefined("attributes.is_pay_bankorders")>
			AND
			(
				CR.ACTION_TYPE_ID IN (260,251) AND CR.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1) OR
				CR.ACTION_TYPE_ID NOT IN (260,251)
			)
		</cfif>
	</cfif>
	ORDER BY
		<cfif isdefined("attributes.is_project_group")>
			PROJECT_ID,
		</cfif>
		<cfif isdefined("attributes.is_subscription_group")>
			SUBSCRIPTION_ID,
		</cfif>
		<cfif isdefined("attributes.is_acc_type_group")>
			ACC_TYPE_ID,
		</cfif>
		ACTION_DATE,
		CR.RECORD_DATE, 
		CR.ACTION_ID,
		DETAIL_TYPE,
		ACTION_ROW_ID
</cfquery>
<cfif isdefined("attributes.is_project_group")>
	<cfquery name="get_project_list" dbtype="query">
		SELECT  DISTINCT
			PROJECT_ID
		FROM 
			cari_rows
		WHERE
			ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
			<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
				AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			</cfif>
	</cfquery>
	<cfif get_project_list.recordcount>
		<cfset project_id_list = valuelist(get_project_list.project_id)>
	<cfelse>
		<cfset project_id_list = 0>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_subscription_group")>
	<cfquery name="get_subscription_list" dbtype="query">
		SELECT  DISTINCT
			SUBSCRIPTION_ID
		FROM 
			cari_rows
		WHERE
			ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
			<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
				AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			</cfif>
	</cfquery>
	<cfif get_subscription_list.recordcount>
		<cfset subscription_id_list = listdeleteduplicates(valuelist(get_subscription_list.subscription_id))>
	<cfelse>
		<cfset subscription_id_list = 0>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_acc_type_group")>
	<cfquery name="get_acc_type_list" dbtype="query">
		SELECT  DISTINCT
			ACC_TYPE_ID
		FROM 
			cari_rows
		WHERE
			ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
			<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
				AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			</cfif>
	</cfquery>
	<cfif get_acc_type_list.recordcount>
		<cfset acc_type_id_list = listdeleteduplicates(valuelist(get_acc_type_list.acc_type_id))>
	<cfelse>
		<cfset acc_type_id_list = 0>
	</cfif>
</cfif>
<cfquery name="CARI_ROWS_ALL" dbtype="query">
	SELECT 
		ACTION_ID,
		CARI_ACTION_ID,
		ACTION_TYPE_ID,
		ACTION_TABLE,
		OTHER_MONEY,
		PAPER_NO,
		ACTION_NAME,
		PROCESS_CAT,
		PROJECT_ID,
		SUBSCRIPTION_ID,
		ACC_TYPE_ID,
		TO_CMP_ID,
		TO_CONSUMER_ID,
		TO_EMPLOYEE_ID,
		FROM_CMP_ID,
		FROM_CONSUMER_ID,
		FROM_EMPLOYEE_ID,
		DUE_DATE,
		ACTION_DETAIL,
		ACTION_DATE, 
		BORC, 
		BORC2,
		BORC_OTHER,
		ALACAK,
		ALACAK2,
		ALACAK_OTHER,
		PAY_METHOD,
		IS_PROCESSED,
		DETAIL_TYPE,
		STOCK_CODE,
		NAME_PRODUCT,
		AMOUNT,
		UNIT,
		PRICE,
		TAX,
		GROSSTOTAL,
		PRICE_OTHER,
		OTHER_MONEY_GROSS_TOTAL,
		ROW_MONEY,
		EXP_DETAIL,
		EXPENSE_ITEM_NAME,
		EXPENSE_CENTER,
		OTV_RATE,
		ROW_PROJECT_ID,
		SPECT_VAR_NAME,
		DISCOUNT1,
		DISCOUNT2,
		DISCOUNT3,
		DISCOUNT4,
		DISCOUNT5,
		DISCOUNT6,
		DISCOUNT7,
		DISCOUNT8,
		DISCOUNT9,
		DISCOUNT10,
		RATE2,
		INV_WRK_ROW_REL_ID,
		INV_WRK_ROW_ID
	FROM 
		cari_rows
	WHERE
    	1 = 1
    	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
			AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
        </cfif>
		<cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
			AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
		</cfif>
	<cfif isdefined("attributes.is_project_group")>
		UNION ALL
			SELECT 
				ACTION_ID,
				CARI_ACTION_ID,
				ACTION_TYPE_ID,
				ACTION_TABLE,
				OTHER_MONEY,
				PAPER_NO,
				ACTION_NAME,
				PROCESS_CAT,
				PROJECT_ID,
				SUBSCRIPTION_ID,
				ACC_TYPE_ID,
				TO_CMP_ID,
				TO_CONSUMER_ID,
				TO_EMPLOYEE_ID,
				FROM_CMP_ID,
				FROM_CONSUMER_ID,
				FROM_EMPLOYEE_ID,
				DUE_DATE,
				ACTION_DETAIL,
				ACTION_DATE, 
				0 BORC, 
				0 BORC2,
				0 BORC_OTHER,
				0 ALACAK,
				0 ALACAK2,
				0 ALACAK_OTHER,
				PAY_METHOD,
				IS_PROCESSED,
				3 DETAIL_TYPE,
				STOCK_CODE,
				NAME_PRODUCT,
				AMOUNT,
				UNIT,
				PRICE,
				TAX,
				0 GROSSTOTAL,
				0 PRICE_OTHER,
				0 OTHER_MONEY_GROSS_TOTAL,
				ROW_MONEY,
				EXP_DETAIL,
				EXPENSE_ITEM_NAME,
				EXPENSE_CENTER,
				OTV_RATE,
				ROW_PROJECT_ID,
				SPECT_VAR_NAME,
				DISCOUNT1,
				DISCOUNT2,
				DISCOUNT3,
				DISCOUNT4,
				DISCOUNT5,
				DISCOUNT6,
				DISCOUNT7,
				DISCOUNT8,
				DISCOUNT9,
				DISCOUNT10,
				RATE2,
				INV_WRK_ROW_REL_ID,
				INV_WRK_ROW_ID
			FROM 
				cari_rows
			WHERE
				PROJECT_ID NOT IN (#project_id_list#)	
	</cfif>
	<cfif isdefined("attributes.is_subscription_group") and len(subscription_id_list)>
		UNION ALL
			SELECT 
				ACTION_ID,
				CARI_ACTION_ID,
				ACTION_TYPE_ID,
				ACTION_TABLE,
				OTHER_MONEY,
				PAPER_NO,
				ACTION_NAME,
				PROCESS_CAT,
				PROJECT_ID,
				SUBSCRIPTION_ID,
				ACC_TYPE_ID,
				TO_CMP_ID,
				TO_CONSUMER_ID,
				TO_EMPLOYEE_ID,
				FROM_CMP_ID,
				FROM_CONSUMER_ID,
				FROM_EMPLOYEE_ID,
				DUE_DATE,
				ACTION_DETAIL,
				ACTION_DATE, 
				0 BORC, 
				0 BORC2,
				0 BORC_OTHER,
				0 ALACAK,
				0 ALACAK2,
				0 ALACAK_OTHER,
				PAY_METHOD,
				IS_PROCESSED,
				3 DETAIL_TYPE,
				STOCK_CODE,
				NAME_PRODUCT,
				AMOUNT,
				UNIT,
				PRICE,
				TAX,
				0 GROSSTOTAL,
				0 PRICE_OTHER,
				0 OTHER_MONEY_GROSS_TOTAL,
				ROW_MONEY,
				EXP_DETAIL,
				EXPENSE_ITEM_NAME,
				EXPENSE_CENTER,
				OTV_RATE,
				ROW_PROJECT_ID,
				SPECT_VAR_NAME,
				DISCOUNT1,
				DISCOUNT2,
				DISCOUNT3,
				DISCOUNT4,
				DISCOUNT5,
				DISCOUNT6,
				DISCOUNT7,
				DISCOUNT8,
				DISCOUNT9,
				DISCOUNT10,
				RATE2,
				INV_WRK_ROW_REL_ID,
				INV_WRK_ROW_ID
			FROM 
				cari_rows
			WHERE
				SUBSCRIPTION_ID NOT IN (#subscription_id_list#)	
	</cfif>
	<cfif isdefined("attributes.is_acc_type_group") and len(acc_type_id_list)>
		UNION ALL
			SELECT 
				ACTION_ID,
				CARI_ACTION_ID,
				ACTION_TYPE_ID,
				ACTION_TABLE,
				OTHER_MONEY,
				PAPER_NO,
				ACTION_NAME,
				PROCESS_CAT,
				PROJECT_ID,
				SUBSCRIPTION_ID,
				ACC_TYPE_ID,
				TO_CMP_ID,
				TO_CONSUMER_ID,
				TO_EMPLOYEE_ID,
				FROM_CMP_ID,
				FROM_CONSUMER_ID,
				FROM_EMPLOYEE_ID,
				DUE_DATE,
				ACTION_DETAIL,
				ACTION_DATE, 
				0 BORC, 
				0 BORC2,
				0 BORC_OTHER,
				0 ALACAK,
				0 ALACAK2,
				0 ALACAK_OTHER,
				PAY_METHOD,
				IS_PROCESSED,
				3 DETAIL_TYPE,
				STOCK_CODE,
				NAME_PRODUCT,
				AMOUNT,
				UNIT,
				PRICE,
				TAX,
				0 GROSSTOTAL,
				0 PRICE_OTHER,
				0 OTHER_MONEY_GROSS_TOTAL,
				ROW_MONEY,
				EXP_DETAIL,
				EXPENSE_ITEM_NAME,
				EXPENSE_CENTER,
				OTV_RATE,
				ROW_PROJECT_ID,
				SPECT_VAR_NAME,
				DISCOUNT1,
				DISCOUNT2,
				DISCOUNT3,
				DISCOUNT4,
				DISCOUNT5,
				DISCOUNT6,
				DISCOUNT7,
				DISCOUNT8,
				DISCOUNT9,
				DISCOUNT10,
				RATE2,
				INV_WRK_ROW_REL_ID,
				INV_WRK_ROW_ID
			FROM 
				cari_rows
			WHERE
				ACC_TYPE_ID NOT IN (#acc_type_id_list#)	
	</cfif>
</cfquery>


