<cfsetting showdebugoutput="no">
<cfif not len(cgi.referer)>
	Güvenlik İhlali !
	<cfexit method="exittemplate">
<cfelseif Not isDefined('session.ep') and Not isDefined('session.pp') and Not isDefined('session.ww') and Not isDefined('session.cp') and Not isDefined('session.wp')>
	Oturum bulunamadı !
	<cfexit method="exittemplate" />
</cfif>
<cfswitch expression="#attributes.str_code#">
	<cfcase value="time_out_control">
		<cfif isDefined("session.ep.userid")>
			<cfset form.str_sql = "SELECT ACTION_DATE FROM WRK_SESSION WHERE USER_TYPE = 0 AND USERID = #session.ep.userid# AND DATEDIFF(MINUTE, ACTION_DATE, GETDATE()) > TIMEOUT_MIN">
		<cfelseif isdefined("session.pp.userid")>
			<cfset form.str_sql = "SELECT ACTION_DATE FROM WRK_SESSION WHERE USER_TYPE = 1 AND USERID = #session.pp.userid# AND DATEDIFF(MINUTE, ACTION_DATE, GETDATE()) > TIMEOUT_MIN">
		<cfelseif isdefined("session.ww.userid")>
			<cfset form.str_sql = "SELECT ACTION_DATE FROM WRK_SESSION WHERE USER_TYPE = 2 AND USERID = #session.ww.userid# AND DATEDIFF(MINUTE, ACTION_DATE, GETDATE()) > TIMEOUT_MIN">
		<cfelseif isdefined("session.cp.userid")>
			<cfset form.str_sql = "SELECT ACTION_DATE FROM WRK_SESSION WHERE USER_TYPE = 3 AND USERID = #session.cp.userid# AND DATEDIFF(MINUTE, ACTION_DATE, GETDATE()) > TIMEOUT_MIN">
		</cfif>
	</cfcase>
	<cfcase value="cv_sector_cat">
		<cfset form.str_sql = "SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="new_control_process">
		<cfset form.str_sql="SELECT IS_DEFAULT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE=10 AND IS_DEFAULT=1">
	</cfcase>

	<cfcase value="get_product_price_row">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfif param_2 eq 1>
			<cfset query_extra_val = "AND PURCHASESALES = 0">
		<cfelseif param_2 eq 2>
			<cfset query_extra_val = "AND PURCHASESALES = 1">
		<cfelse>
			<cfset query_extra_val = "">
		</cfif>
		<cfset form.str_sql="SELECT MONEY, PRICE FROM PRICE_STANDART WHERE PRODUCT_ID = #param_1# AND PRICESTANDART_STATUS = 1 #query_extra_val#">
	</cfcase>

	<!--- health --->
	<cfcase value="health_expense_paper_no_control">
		<cfset form.str_sql = "SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE PAPER_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="general_paper_control">
		<cfset form.str_sql = "SELECT GENERAL_PAPER_ID FROM GENERAL_PAPER WHERE GENERAL_PAPER_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="health_expense_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfif isDefined("param_5") and len(param_5) and param_5 neq "_">
			<cfset query_extra = "AND EXPENSE_ID <> #param_5#">
		<cfelse>
			<cfset query_extra = "">
		</cfif>
		<cfset form.str_sql="SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EMP_ID = #param_1# AND SYSTEM_RELATION = '#param_2#' AND COMPANY_NAME = '#param_3#' AND EXPENSE_DATE = #param_4# #query_extra#">
	</cfcase>
	<cfcase value="health_expense_control_efatura">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfif isDefined("param_4") and len(param_4) and param_4 neq "_">
			<cfset query_extra = "AND EXPENSE_ID <> #param_4#">
		<cfelse>
			<cfset query_extra = "">
		</cfif>
		<cfset form.str_sql="SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE COMPANY_ID = #param_1# AND INVOICE_NO = '#param_2#' AND INVOICE_DATE = #param_3# #query_extra#">
	</cfcase>
	<cfcase value="get_emp_health_expense">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfif isdefined("param_3") and len(param_3) and listLast(param_3,"_") eq "1">
			<cfset query_extra = "AND TREATED = 1">
		<cfelseif isdefined("param_3") and len(param_3) and listLast(param_3,"_") eq "2">
			<cfset query_extra = 'AND TREATED = 2 AND RELATIVE_ID = #listFirst(param_3,"_")#'>
		<cfelse>
			<cfset query_extra = "">
		</cfif>
		<cfset form.str_sql="SELECT SUM(NET_TOTAL_AMOUNT) AS TOTAL_AMOUNT, SUM(TREATMENT_AMOUNT) AS TREATMENT_AMOUNT, SUM(OUR_COMPANY_HEALTH_AMOUNT) AS COMP_AMOUNT, SUM(EMPLOYEE_HEALTH_AMOUNT) AS EMP_AMOUNT FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE IS_APPROVE = 1 AND ASSURANCE_ID IS NOT NULL AND EMP_ID = #param_1# AND YEAR(EXPENSE_DATE) = #param_2# #query_extra#">
	</cfcase>
	<cfcase value="get_emp_health_expense_by_assurance">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfif isdefined("param_3") and len(param_3) and listLast(param_3,"_") eq "1">
			<cfset query_extra = "AND EIP.TREATED = 1">
		<cfelseif isdefined("param_3") and len(param_3) and listLast(param_3,"_") eq "2">
			<cfset query_extra = 'AND EIP.TREATED = 2 AND EIP.RELATIVE_ID = #listFirst(param_3,"_")#'>
		<cfelse>
			<cfset query_extra = "">
		</cfif>
		<cfset form.str_sql="SELECT SHAT.ASSURANCE AS ASSURANCE, SUM(EIP.NET_TOTAL_AMOUNT) AS TOTAL_AMOUNT, SUM(EIP.TREATMENT_AMOUNT) AS TREATMENT_AMOUNT FROM #dsn#.SETUP_HEALTH_ASSURANCE_TYPE AS SHAT INNER JOIN EXPENSE_ITEM_PLAN_REQUESTS AS EIP ON SHAT.ASSURANCE_ID = EIP.ASSURANCE_ID WHERE EIP.IS_APPROVE = 1 AND EIP.EMP_ID = #param_1# AND EIP.ASSURANCE_ID IS NOT NULL AND YEAR(EXPENSE_DATE) = #param_2# #query_extra# GROUP BY SHAT.ASSURANCE_ID, ASSURANCE">
	</cfcase>
	<cfcase value="get_emp_sum_health_expense">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfif isDefined("param_3") and len(param_3) and param_3 eq "_">
			<cfset query_extra = "AND TREATED = 1">
		<cfelse>
			<cfset query_extra = "AND TREATED = 2 AND RELATIVE_ID = #param_3#">
		</cfif>
		<cfif isDefined("param_4") and len(param_4) and param_4 neq "_">
			<cfset query_extra2 = "AND EXPENSE_ID <> #param_4#">
		<cfelse>
			<cfset query_extra2 = "">
		</cfif>
		<cfset form.str_sql="SELECT SUM(ISNULL(NET_TOTAL_AMOUNT,0)) AS TOTAL_AMOUNT, SUM(ISNULL(TREATMENT_AMOUNT,0)) AS TREATMENT_AMOUNT, SUM(ISNULL(PAYMENT_INTERRUPTION_VALUE,0)) AS PAYMENT_INTERRUPTION_VALUE FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE IS_APPROVE = 1 AND EMP_ID = #param_1# AND ASSURANCE_ID IN (#param_2#) AND YEAR(EXPENSE_DATE) = #session.ep.period_year# #query_extra# #query_extra2#">
	</cfcase>
	<cfcase value="get_limits_by_assurance">
		<cfset form.str_sql="SELECT ISNULL(MIN,0) AS MIN, MAX, ISNULL(RATE,0) AS RATE, ISNULL(PRIVATE_COMP_RATE,0) AS PRIVATE_COMP_RATE FROM SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT WHERE ASSURANCE_ID = #attributes.ext_params# AND IS_ACTIVE = 1">
	</cfcase>
	<cfcase value="get_main_assurance_type">
		<cfset form.str_sql="SELECT SHAT.MAIN_ASSURANCE_TYPE_ID, SHAT2.ASSURANCE FROM SETUP_HEALTH_ASSURANCE_TYPE SHAT LEFT JOIN SETUP_HEALTH_ASSURANCE_TYPE SHAT2 ON SHAT.MAIN_ASSURANCE_TYPE_ID = SHAT2.ASSURANCE_ID WHERE SHAT.ASSURANCE_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="get_group_assurance_ids">
		<cfset form.str_sql="SELECT ASSURANCE_ID FROM SETUP_HEALTH_ASSURANCE_TYPE WHERE MAIN_ASSURANCE_TYPE_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="get_assurance_working_type">
		<cfset form.str_sql="SELECT WORKING_TYPE FROM SETUP_HEALTH_ASSURANCE_TYPE WHERE ASSURANCE_ID = #attributes.ext_params# AND IS_ACTIVE = 1">
	</cfcase>
	<cfcase value="get_assurance_limb_limits">
		<cfset form.str_sql="SELECT SHATL.LIMB_ID, SL.LIMB_NAME, ISNULL(SHATL.MAX,0) AS MAX, 0 AS MIN, ISNULL(SHATL.MONEY_LIMIT,0) AS MONEY_LIMIT, ISNULL(SHATL.PAYMENT_RATE,0) AS PAYMENT_RATE,  ISNULL(SHATL.PAYMENT_RATE,0) AS RATE, ISNULL(SHATL.PAYMENT_RATE,0) AS PRIVATE_COMP_RATE  FROM SETUP_HEALTH_ASSURANCE_TYPE_LIMB SHATL LEFT JOIN SETUP_LIMB SL ON SL.LIMB_ID = SHATL.LIMB_ID WHERE SHATL.ASSURANCE_ID = #attributes.ext_params# ORDER BY SHATL.LIMB_ID">
	</cfcase>
	<cfcase value="get_assurance_treatment_limits">
		<cfset form.str_sql="SELECT SHATT.SETUP_COMPLAINT_ID, SC.COMPLAINT, ISNULL(SHATT.MAX,0) AS MAX,0 AS MIN, ISNULL(SHATT.MONEY_LIMIT,0) AS MONEY_LIMIT, ISNULL(SHATT.PAYMENT_RATE,0) AS PAYMENT_RATE, ISNULL(SHATT.PAYMENT_RATE,0) AS RATE, ISNULL(SHATT.PAYMENT_RATE,0) AS PRIVATE_COMP_RATE FROM SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS SHATT LEFT JOIN SETUP_COMPLAINTS SC ON SC.COMPLAINT_ID = SHATT.SETUP_COMPLAINT_ID WHERE SHATT.ASSURANCE_ID = #attributes.ext_params# ORDER BY SHATT.SETUP_COMPLAINT_ID">
	</cfcase>
	<cfcase value="get_assurance_medication_limits">
		<cfset form.str_sql="SELECT SHATM.DRUG_ID, SD.DRUG_MEDICINE, ISNULL(SHATM.MAX,0) AS MAX,0 AS MIN, ISNULL(SHATM.MONEY_LIMIT,0) AS MONEY_LIMIT, ISNULL(SHATM.PAYMENT_RATE,0) AS PAYMENT_RATE, ISNULL(SHATM.PAYMENT_RATE,0) AS RATE, ISNULL(SHATM.PAYMENT_RATE,0) AS PRIVATE_COMP_RATE FROM SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION SHATM LEFT JOIN SETUP_DECISIONMEDICINE SD ON SD.DRUG_ID = SHATM.DRUG_ID WHERE SHATM.ASSURANCE_ID = #attributes.ext_params# ORDER BY SHATM.DRUG_ID">
	</cfcase>
	<cfcase value="get_use_limb_limits">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfif isDefined("param_4") and len(param_4) and param_4 eq "_">
			<cfset query_extra = "AND EIPR.TREATED = 1">
		<cfelse>
			<cfset query_extra = "AND EIPR.TREATED = 2 AND EIPR.RELATIVE_ID = #param_4#">
		</cfif>
		<cfset form.str_sql="SELECT COUNT(HE.HEALTH_EXPENSE_LIMB) AS MIKTAR, SUM(ISNULL(HE.HEALTH_EXPENSE_TOTAL,0)) AS TOPLAM FROM HEALTH_EXPENSE HE LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS EIPR ON HE.EXPENSE_ID = EIPR.EXPENSE_ID WHERE EIPR.IS_APPROVE = 1 AND EIPR.EMP_ID = #param_1# AND EIPR.ASSURANCE_ID = #param_2# AND YEAR(EIPR.EXPENSE_DATE) = #year(now())# AND HE.HEALTH_EXPENSE_LIMB = #param_3# #query_extra# GROUP BY HE.HEALTH_EXPENSE_LIMB">
	</cfcase>
	<cfcase value="get_use_treatments_limits">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfif isDefined("param_4") and len(param_4) and param_4 eq "_">
			<cfset query_extra = "AND EIPR.TREATED = 1">
		<cfelse>
			<cfset query_extra = "AND EIPR.TREATED = 2 AND EIPR.RELATIVE_ID = #param_4#">
		</cfif>
		<cfset form.str_sql="SELECT SUM(ISNULL(HE.HEALTH_EXPENSE_AMOUNT,0)) AS MIKTAR, SUM(ISNULL(HE.HEALTH_EXPENSE_TOTAL,0)) AS TOPLAM FROM HEALTH_EXPENSE HE LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS EIPR ON HE.EXPENSE_ID = EIPR.EXPENSE_ID WHERE EIPR.IS_APPROVE = 1 AND EIPR.EMP_ID = #param_1# AND EIPR.ASSURANCE_ID = #param_2# AND YEAR(EIPR.EXPENSE_DATE) = #year(now())# AND HE.COMPLAINT_ID = #param_3# #query_extra# GROUP BY HE.COMPLAINT_ID">
	</cfcase>
	<cfcase value="get_use_medication_limits">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfif isDefined("param_4") and len(param_4) and param_4 eq "_">
			<cfset query_extra = "AND EIPR.TREATED = 1">
		<cfelse>
			<cfset query_extra = "AND EIPR.TREATED = 2 AND EIPR.RELATIVE_ID = #param_4#">
		</cfif>
		<cfset form.str_sql="SELECT SUM(ISNULL(HE.HEALTH_EXPENSE_AMOUNT,0)) AS MIKTAR, SUM(ISNULL(HE.HEALTH_EXPENSE_TOTAL,0)) AS TOPLAM FROM HEALTH_EXPENSE HE LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS EIPR ON HE.EXPENSE_ID = EIPR.EXPENSE_ID WHERE EIPR.IS_APPROVE = 1 AND EIPR.EMP_ID = #param_1# AND EIPR.ASSURANCE_ID = #param_2# AND YEAR(EIPR.EXPENSE_DATE) = #year(now())# AND HE.DRUG_ID = #param_3# #query_extra# GROUP BY HE.DRUG_ID">
	</cfcase>
	<cfcase value="get_limit_rate_by_assurance">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfif len(param_2) and (param_2 eq 1 or param_2 eq 0)>
			<cfset query_select = "ISNULL(RATE,0) AS RATE">
		<cfelseif len(param_2) and param_2 eq 2>
			<cfset query_select = "ISNULL(PRIVATE_COMP_RATE,0) AS RATE">
		</cfif>
		<cfset form.str_sql="SELECT TOP 1 #query_select# FROM SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT WHERE ASSURANCE_ID = #param_1# AND IS_ACTIVE = 1 ORDER BY ISNULL(MIN,0)">
	</cfcase>
	<cfcase value="control_expense_account_card">
		<cfset form.str_sql="SELECT E.EXPENSE_ID FROM EXPENSE_ITEM_PLAN_REQUESTS E INNER JOIN ACCOUNT_CARD AC ON AC.ACTION_ID = E.EXPENSE_ID AND AC.ACTION_TYPE = 2503 WHERE E.EXPENSE_ID = #attributes.ext_params#">
	</cfcase>

	<!--- worknet --->
	<cfcase value="get_comp_by_name">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE FULLNAME='#param_1#' AND NICKNAME= '#param_2#'">
	</cfcase>
	<cfcase value="get_comp_by_name_compid">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_ID <> #param_1# AND FULLNAME='#param_2#' AND NICKNAME= '#param_3#'">
	</cfcase>
	<cfcase value="get_cpar_by_email">
		<cfset form.str_sql="SELECT COMPANY_PARTNER_USERNAME FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="get_comp_domain">
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE DOMAIN='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="get_comp_domain_by_id">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_ID <> #param_1# AND DOMAIN='#param_2#'">
	</cfcase>

	<!--- acount --->
	<cfcase value="acc_ctrl_card">
		<cfset form.str_sql="SELECT CARD_ID FROM ACCOUNT_CARD WHERE CARD_TYPE=10 AND CARD_CAT_ID= #attributes.ext_params#">
	</cfcase>
	<cfcase value="acc_new_ctrl_process">
		<cfset form.str_sql="SELECT IS_DEFAULT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE=10 AND IS_DEFAULT=1">
	</cfcase>
	
	<cfcase value="acc_ctrl_acc_card">
		<cfset form.str_sql="SELECT CARD_ID FROM ACCOUNT_CARD WHERE CARD_TYPE=10 AND CARD_CAT_ID= #attributes.ext_params#">
	</cfcase>
	<cfcase value="acc_process_cat">
		<cfset form.str_sql="SELECT IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID=#attributes.ext_params#">
	</cfcase>    
	<!--- assetcare --->
	<cfcase value="ascr_get_care_type_no">
		<cfset form.str_sql="SELECT ASSET_CARE_ID,ASSET_CARE,ASSETP_CAT FROM ASSET_CARE_CAT WHERE ASSETP_CAT= #attributes.ext_params# ORDER BY ASSET_CARE">
	</cfcase>
	<cfcase value="ascr_get_emp_asset">
		<cfset form.str_sql="SELECT ASSET_P.ASSETP_ID,ASSET_P.ASSETP,ASSET_P.POSITION_CODE,ASSET_P.RECORD_DATE,ASSET_P_CAT.ASSETP_CAT FROM ASSET_P,DEPARTMENT,ASSET_P_CAT,BRANCH WHERE BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #attributes.ext_params#) AND ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND ASSET_P.STATUS = 1 AND  POSITION_CODE = #attributes.ext_params#  ORDER BY ASSET_P.ASSETP">
	</cfcase>
	
	<!--- bank --->
	<cfcase value="bnk_get_ord_number">
		<cfset form.str_sql="SELECT O.ORDER_NUMBER FROM ORDER_CASH_POS OCP,ORDERS O WHERE O.ORDER_ID=OCP.ORDER_ID AND POS_ID IS NOT NULL AND POS_ACTION_ID=#attributes.ext_params#">
	</cfcase>
	<cfcase value="bnk_get_ord_number_p">
		<cfset form.str_sql="SELECT PAPER_NO FROM CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID=#attributes.ext_params#">
	</cfcase>
	<cfcase value="bnk_branch_names">
		<cfset form.str_sql="SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME,BRANCH_CODE,SWIFT_CODE FROM BANK_BRANCH WHERE BANK_ID = #attributes.ext_params# ORDER BY BANK_BRANCH_NAME">
	</cfcase>	
	<cfcase value="bnk_get_process_cat">
		<cfset form.str_sql="SELECT IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params#">
	</cfcase>	
	<cfcase value="bnk_paper_no">
		<cfset form.str_sql="SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO ='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="bnk_get_paper_no_pymnt">
		<cfset form.str_sql="SELECT PAPER_NO FROM CREDIT_CARD_BANK_PAYMENTS WHERE PAPER_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="bnk_get_inv_number">
		<cfset form.str_sql="SELECT I.INVOICE_NUMBER FROM INVOICE_CASH_POS ICP,INVOICE I WHERE I.INVOICE_ID=ICP.INVOICE_ID AND POS_PERIOD_ID = #session.ep.period_id# AND POS_ID IS NOT NULL AND POS_ACTION_ID = #attributes.ext_params#">
	</cfcase>	
   	<cfcase value="bnk_get_paper_no">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PAPER_NO FROM CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID <> #param_1# AND PAPER_NO = '#param_2#'">
	</cfcase>
	<cfcase value="bnk_get_acc_1">
    	<cfset param_1 = listgetat(session.ep.user_location,2,"-")>
		<cfset form.str_sql="SELECT ACCOUNT_NAME,ACCOUNT_CURRENCY_ID,ACCOUNT_ID FROM ACCOUNTS WHERE ACCOUNT_STATUS = 1 AND ACCOUNT_CURRENCY_ID = '#attributes.ext_params#' AND ACCOUNT_ID IN(SELECT ABB.ACCOUNT_ID FROM ACCOUNTS_BRANCH ABB WHERE ABB.BRANCH_ID = #param_1#) ORDER BY ACCOUNT_NAME">
	</cfcase>	    
    <cfcase value="bnk_get_acc_2">
		<cfset form.str_sql="SELECT ACCOUNT_NAME,ACCOUNT_CURRENCY_ID,ACCOUNT_ID FROM ACCOUNTS WHERE ACCOUNT_STATUS = 1 AND ACCOUNT_CURRENCY_ID = '#attributes.ext_params#' ORDER BY ACCOUNT_NAME">
	</cfcase>	    
	<cfcase value="bnk_get_acc_3">
    	<cfset param_1 = listgetat(session.ep.user_location,2,"-")>
		<cfset form.str_sql="SELECT ACCOUNT_NAME,ACCOUNT_CURRENCY_ID,ACCOUNT_ID FROM ACCOUNTS WHERE ACCOUNT_CURRENCY_ID = '#attributes.ext_params#' AND ACCOUNT_ID IN(SELECT ABB.ACCOUNT_ID FROM ACCOUNTS_BRANCH ABB WHERE ABB.BRANCH_ID = #param_1#) ORDER BY ACCOUNT_NAME">
	</cfcase>	   
    <cfcase value="bnk_get_acc_4">
		<cfset form.str_sql="SELECT ACCOUNT_NAME,ACCOUNT_CURRENCY_ID,ACCOUNT_ID FROM ACCOUNTS WHERE ACCOUNT_CURRENCY_ID = '#attributes.ext_params#' ORDER BY ACCOUNT_NAME">
	</cfcase>	
	<cfcase value="bnk_get_paymethod">
		<cfset form.str_sql="SELECT SP.PAYMETHOD,SP.PAYMETHOD_ID FROM SETUP_PAYMETHOD SP,SETUP_PAYMETHOD_OUR_COMPANY SPOC WHERE SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID AND SPOC.OUR_COMPANY_ID = #session.ep.company_id# AND SP.BANK_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="bnk_get_paymethod_2">
		<cfset form.str_sql="SELECT SP.PAYMETHOD,SP.PAYMETHOD_ID FROM SETUP_PAYMETHOD SP,SETUP_PAYMETHOD_OUR_COMPANY SPOC WHERE SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID AND SPOC.OUR_COMPANY_ID = #session.ep.company_id# ORDER BY SP.PAYMETHOD">
	</cfcase>
	        	
	<!--- budget --->	
	<cfcase value="bdg_get_process_cat">
		<cfset form.str_sql="SELECT IS_ACCOUNT,IS_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params#">
	</cfcase>	
	<cfcase value="bdg_get_position_department_name">
		<cfset form.str_sql="SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = #attributes.ext_params# ORDER BY DEPARTMENT_HEAD">
	</cfcase>
	
	<!--- callcenter --->
	<cfcase value="clcr_get_sub_category">
    	<cfif len(attributes.ext_params)>
			<cfset form.str_sql="SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB WHERE IS_STATUS = 1 AND (OUR_COMPANY_ID LIKE '#session.ep.company_id#' OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#' OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%' OR	OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%')  and  SERVICECAT_ID =#attributes.ext_params#">
        <cfelse>
			<cfset form.str_sql="SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB WHERE IS_STATUS = 1 AND (OUR_COMPANY_ID LIKE '#session.ep.company_id#' OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#' OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%' OR	OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%')">
        </cfif>
	</cfcase>
	<cfcase value="clcr_get_sub_tree_category">
    	<cfif len(attributes.ext_params)>
			<cfset form.str_sql="SELECT SERVICE_SUB_STATUS_ID,SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS WHERE IS_STATUS = 1 AND (OUR_COMPANY_ID LIKE '#session.ep.company_id#' OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#' OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%' OR	OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%') AND SERVICE_SUB_CAT_ID =#attributes.ext_params#">
		<cfelse>
			<cfset form.str_sql="SELECT SERVICE_SUB_STATUS_ID,SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS WHERE IS_STATUS = 1 AND (OUR_COMPANY_ID LIKE '#session.ep.company_id#' OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#' OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%' OR	OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%')">
        </cfif>
    </cfcase>    
    <cfcase value="clcr_get_service_result">
		<cfset form.str_sql="SELECT RESULT_ID,SERVICE_RESULT_NAME,SERVICECAT_ID FROM SETUP_SERVICE_RESULT WHERE SERVICECAT_ID = #attributes.ext_params#">
	</cfcase>				
	<cfcase value="clcr_get_consumer">
		<cfset form.str_sql="SELECT MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID = #attributes.ext_params#">
	</cfcase>
     <cfcase value="clcr_get_temsilci">
		<cfset form.str_sql="SELECT EMPLOYEE_POSITIONS.EMPLOYEE_ID AS EMPLOYEE_ID FROM EMPLOYEE_POSITIONS,WORKGROUP_EMP_PAR WHERE EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE AND WORKGROUP_EMP_PAR.COMPANY_ID = #attributes.ext_params# AND WORKGROUP_EMP_PAR.IS_MASTER = 1 ">
	</cfcase>

	<!--- cash --->
	<cfcase value="csh_get_paper_no">
		<cfset form.str_sql="SELECT PAPER_NO FROM CASH_ACTIONS WHERE PAPER_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="csh_get_process_cat">
		<cfset form.str_sql="SELECT IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params#">
	</cfcase>
   	<cfcase value="csh_get_paper_no_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PAPER_NO FROM CASH_ACTIONS WHERE ACTION_ID <> #param_1# AND PAPER_NO = '#param_2#' ">
    </cfcase> 
	<cfcase value="get_cashier">
		<cfset form.str_sql="SELECT CASHIER1 FROM POS_EQUIPMENT WHERE POS_ID = #attributes.ext_params#">
	</cfcase>
	
	<!--- ch --->
	<cfcase value="ch_get_process_cat">
		<cfset form.str_sql="SELECT IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="ch_get_account_code">
		<cfset form.str_sql="SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="ch_get_expense_center">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT EIOP.EXPENSE_CENTER_ID,EIOP.EXPENSE_CODE_NAME,EIOP.EXPENSE_ITEM_ID,EIOP.EXPENSE_ITEM_NAME FROM EMPLOYEES_IN_OUT_PERIOD EIOP, EMPLOYEES_IN_OUT EIO WHERE EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_ID = #param_1# AND EIO.EMPLOYEE_ID = #param_2# AND EIO.START_DATE <= #CreateDate(year(now()),month(now()),daysinmonth(CreateDate(year(now()),month(now()),1)))# AND ((EIO.FINISH_DATE >= #CreateDate(year(now()),month(now()),1)#) OR EIO.FINISH_DATE IS NULL)">
    </cfcase> 
	<!--- cheque --->
	<cfcase value="chq_get_ord_number">
		<cfset form.str_sql="SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = #attributes.ext_params#">
	</cfcase>	
	<cfcase value="chq_get_company">
		<cfset form.str_sql="SELECT EP.EMPLOYEE_ID,C.COMP_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B,OUR_COMPANY C WHERE EP.POSITION_STATUS=1 AND D.BRANCH_ID =B.BRANCH_ID AND C.COMP_ID = B.COMPANY_ID AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND EP.EMPLOYEE_ID= #attributes.ext_params#">
	</cfcase>				 
	<cfcase value="chq_get_cash_3">
		<cfset form.str_sql="SELECT TRANSFER_CHEQUE_ACC_CODE FROM CASH WHERE CASH_STATUS = 1 AND CASH_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="chq_get_cash_1">
		<cfset form.str_sql="SELECT CASH_ID,CASH_NAME,BRANCH_ID,CASH_CURRENCY_ID FROM CASH WHERE CASH_STATUS = 1 ORDER BY CASH_ID">
	</cfcase>				 
	<cfcase value="chq_get_cash_2">
		<cfset form.str_sql="SELECT CASH_ID,CASH_NAME,BRANCH_ID,CASH_CURRENCY_ID FROM CASH WHERE CASH_STATUS = 1 AND BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# ORDER BY CASH_ID">
	</cfcase>				 
	<cfcase value="chq_get_process_cat">
		<cfset form.str_sql="SELECT IS_ACCOUNT,ISNULL(IS_CHEQUE_BASED_ACTION,0) IS_CHEQUE_BASED_ACTION FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params#">
	</cfcase>	
	<cfcase value="chq_get_cheque_no">
		<cfset form.str_sql="SELECT TOP 1 CHEQUE_NO MAX_ID FROM CHEQUE WHERE ACCOUNT_ID = #attributes.ext_params# ORDER BY RECORD_DATE DESC">
	</cfcase>
	<cfcase value="chq_get_cash_3_3">
		<cfset form.str_sql="SELECT TRANSFER_VOUCHER_ACC_CODE FROM CASH WHERE CASH_STATUS = 1 AND CASH_ID = #attributes.ext_params# ">
	</cfcase>
	<cfcase value="chq_get_cheque_detail">
		<cfset form.str_sql="SELECT * FROM CHEQUE WHERE CHEQUE_ID = #attributes.ext_params#">
	</cfcase>	
 
 	<!--- content --->
	<!---<cfcase value="cont_is_rule_popup">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT CONTENT_ID FROM CONTENT WHERE VIEW_DATE_START < #param_1# AND VIEW_DATE_FINISH > #param_1# AND CONTENT_ID <> #param_2# AND IS_RULE_POPUP = 1">
	</cfcase>--->
	<!--- content --->
    
	<!--- correspondence --->
	<cfcase value="corr_get_mail_account">
		<cfset form.str_sql="SELECT EMPLOYEE_ID FROM CUBE_MAIL WHERE EMAIL='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="corr_get_temp_">
		<cfset form.str_sql="SELECT DETAIL FROM SETUP_CORR WHERE CORRCAT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="corr_get_temp_2">
		<cfset form.str_sql="SELECT * FROM CUBE_MAIL_SIGNATURE WHERE SIGNATURE_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="corr_get_temp_3">
		<cfset form.str_sql = "SELECT DETAIL FROM SETUP_CORR WHERE CORRCAT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="corr_get_intrnldmnd">
		<cfset form.str_sql="SELECT SPECT_VAR_ID,STOCK_ID FROM INTERNALDEMAND_ROW WHERE I_ROW_ID = #attributes.ext_params#">
	</cfcase>
	
	<!--- mailbox.id ??? --->
	<cfcase value="corr_mailbox_id_control">
		<cfset form.str_sql="SELECT MAILBOX_ID FROM MAILS WHERE MAILBOX_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="get_active_account">
		<cfset form.str_sql = "SELECT EMAIL FROM CUBE_MAIL WHERE MAILBOX_ID = #attributes.ext_params#">
	</cfcase>
	
	<!--- mail entegrasyon --->
	<cfcase value="server_name_kontrol">
		<cfset form.str_sql="SELECT SERVER_NAME_ID FROM MAIL_SERVER_SETTINGS WHERE SERVER_NAME = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="mail_account_kontrol">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT MAIL_ACCOUNT_ID FROM WRK_MAIL_ACCOUNTS_SETTINGS WHERE MAIL_ACCOUNT='#param_1#' AND SERVER_NAME_ID='#param_2#'">
	</cfcase>

	<!--- cost --->
	<cfcase value="get_expense_items_amount">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset param_7 = listgetat(attributes.ext_params,7,"*")>
		<cfif session.ep.isBranchAuthorization>
			<cfset sql_str_1 = " AND EXPENSE_ITEMS_ROWS.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)">
		<cfelse>
			<cfset sql_str_1 = "">
		</cfif>
		<cfif param_2 neq '_'><cfset sql_str_2 = " AND EXPENSE_CENTER_ID = #param_2#"><cfelse><cfset sql_str_2 = ""></cfif>
		<cfif param_3 neq '_'><cfset sql_str_3 = " AND EXPENSE_ITEM_ID = #param_3#"><cfelse><cfset sql_str_3 = ""></cfif>
		<cfif param_4 neq '_'><cfset sql_str_4 = " AND ACTIVITY_TYPE = #param_4#"><cfelse><cfset sql_str_4 = ""></cfif>
		<cfif param_5 neq '_'><cfset sql_str_5 = " AND EXPENSE_DATE >= #param_5#"><cfelse><cfset sql_str_5 = ""></cfif>
		<cfif param_6 neq '_'><cfset sql_str_6 = " AND EXPENSE_DATE <= #param_6#"><cfelse><cfset sql_str_6 = ""></cfif>
		<cfset form.str_sql="SELECT (ISNULL(SUM(AMOUNT),0) - (SELECT ISNULL(SUM(AMOUNT),0) FROM EXPENSE_ITEMS_ROWS WHERE IS_INCOME=#param_7##sql_str_1##sql_str_2##sql_str_3##sql_str_4##sql_str_5##sql_str_6#)) AS TOTAL_AMOUNT FROM EXPENSE_ITEMS_ROWS WHERE IS_INCOME=#param_1##sql_str_1##sql_str_2##sql_str_3##sql_str_4##sql_str_5##sql_str_6#">
	</cfcase>
	<cfcase value="cst_get_temp_rows">
		<cfset form.str_sql="SELECT ETR.PROMOTION_ID,ETR.WORKGROUP_ID,ETR.PROJECT_ID,ETR.ASSET_ID,ETR.COMPANY_ID,ETR.COMPANY_PARTNER_ID,ETR.MEMBER_TYPE,ISNULL(ETR.RATE,0) RATE,ETR.EXPENSE_CENTER_ID,ETR.EXPENSE_ITEM_ID,EC.EXPENSE,EI.EXPENSE_ITEM_NAME,EI.ACCOUNT_CODE,EI.EXPENSE_CATEGORY_ID FROM EXPENSE_PLANS_TEMPLATES_ROWS ETR,EXPENSE_CENTER EC,EXPENSE_ITEMS EI WHERE ETR.EXPENSE_CENTER_ID = EC.EXPENSE_ID AND ETR.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID AND TEMPLATE_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="cst_get_temp_type">
		<cfset form.str_sql="SELECT IS_INCOME FROM EXPENSE_PLANS_TEMPLATES WHERE TEMPLATE_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="get_expense_cat_name">
		<cfset form.str_sql="SELECT EXPENSE_CAT_NAME FROM EXPENSE_CATEGORY WHERE EXPENSE_CAT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="cst_get_pro_name">
		<cfset form.str_sql="SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="cst_get_pro_name_2">
		<cfset form.str_sql="SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="cst_get_company">
		<cfset form.str_sql="SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="cst_get_comp_name">
		<cfset form.str_sql="SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="cst_get_cons_name_2">
		<cfset form.str_sql="SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="cst_get_emp_name">
		<cfset form.str_sql="SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE =#attributes.ext_params#">
	</cfcase>
	
	<!--- credit --->
	<cfcase value="crd_get_crd_all">
		<cfset form.str_sql="SELECT MONEY_TYPE FROM CREDIT_LIMIT WHERE CREDIT_LIMIT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="crd_get_process_cat">
		<cfset form.str_sql="SELECT IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params#">
	</cfcase>
	
	<!--- crm --->
	<cfcase value="crm_get_TaxNumber_Control">
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE TAXNO = '#attributes.ext_params#'">
	</cfcase>	
	<cfcase value="crm_get_TcIdentity_Control">
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE TC_IDENTITY = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="crm_get_CariHesap_Control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT RELATED_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND CARIHESAPKOD = '#param_1#' AND BRANCH_ID = #param_2#">
    </cfcase> 
   	<cfcase value="crm_get_carihesapkod">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT CARIHESAPKOD FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #param_1# AND BRANCH_ID = #param_2#">
    </cfcase> 
    <!--- design --->
  	<cfcase value="dgn_get_fuseaction_">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT MODUL,FUSEACTION FROM WRK_OBJECTS WHERE FUSEACTION =  '#param_1#' OR HEAD = '#param_2#'">
    </cfcase>     
    <cfcase value="dgn_get_modul_">
		<cfset form.str_sql="SELECT MODUL_SHORT_NAME FROM MODULES WHERE MODUL_NAME = '#attributes.ext_params#'">
	</cfcase>
    
	<!---development --->
	
	<cfcase value="table_control_">
		<cfset param_1 = listgetat(attributes.ext_params,1,';')>
		<cfset param_2 = listgetat(attributes.ext_params,2,';')>
		<cfset form.str_sql = "SELECT OBJECT_ID FROM WRK_OBJECT_INFORMATION WHERE OBJECT_NAME = '#param_1#' and DB_NAME = '#param_2#'">
	</cfcase>
	<cfcase value="obj_get_table">
		<cfset form.str_sql = "SELECT * FROM WRK_OBJECT_INFORMATION WHERE OBJECT_NAME='#attributes.ext_params#'"> 
	</cfcase>
	<cfcase value="check_relationship">
		<cfset param_1 = listgetat(attributes.ext_params,1,";")>
		<cfset param_2 = listgetat(attributes.ext_params,2,";")>
		<cfset form.str_sql="SELECT RELATIONSHIP_ID FROM WRK_TABLE_RELATION_SHIP WHERE PARENT_COLUMN_ID=#param_1# and CHILD_COLUMN_ID=#param_2#" >
	</cfcase>
	
	<!--- extra --->
	<cfcase value="ext_cnsr_ctrl">
		<cfset form.str_sql="SELECT CONSUMER_ID FROM CONSUMER WHERE TC_IDENTY_NO='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="ext_get_project">
		<cfset form.str_sql="SELECT TOP 1 PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_HEAD='#attributes.ext_params#' ORDER BY PROJECT_ID">
	</cfcase>
	
	<!--- finance --->
	<cfcase value="fin_belge_no_control">
		<cfset form.str_sql="SELECT INVOICE_NUMBER FROM INVOICE WHERE INVOICE_NUMBER = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="fin_basket_zero_stock_status">
		<cfset form.str_sql="SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE B_TYPE=1 AND TITLE='zero_stock_status' AND BASKET_ID = #attributes.ext_params#">
	</cfcase>      
	<cfcase value="fin_DEVREDEN_INFO">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT DEVREDEN FROM STORE_REPORT WHERE STORE_REPORT_DATE >= #param_1# AND STORE_REPORT_DATE < #param_2# AND BRANCH_ID = #param_3#">
    </cfcase>       
	<cfcase value="fin_BELGE_NO_CONTROL_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT INVOICE_NUMBER FROM INVOICE WHERE INVOICE_ID <> #param_1# AND INVOICE_NUMBER = '#param_2#' ">
    </cfcase>
	<!--- hr --->
	<cfcase value="hr_get_tc_control">
		<cfset form.str_sql="SELECT EI.TC_IDENTY_NO, E.EMPLOYEE_NAME + ' ' +E.EMPLOYEE_SURNAME EMP_NAME FROM EMPLOYEES E, EMPLOYEES_IDENTY EI WHERE E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND E.EMPLOYEE_STATUS = 1 AND EI.TC_IDENTY_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="hr_get_name_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NAME = '#param_1#' AND EMPLOYEE_SURNAME = '#param_2#'">
	</cfcase>
	<cfcase value="hr_get_username_control">
		<cfset form.str_sql="SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_USERNAME = '#attributes.ext_params#'">
	</cfcase>
    <cfcase value="hr_get_emp_name">
    	<cfif listLen(attributes.ext_params,"_") eq 2>
			<cfset param_1 = listgetat(attributes.ext_params,1,"_")>
            <cfset param_2 = listgetat(attributes.ext_params,2,"_")>
            <cfset form.str_sql="SELECT EMPLOYEE_NAME+ ' '+ EMPLOYEE_SURNAME+ '-'+ACC_TYPE_NAME AS NAME FROM EMPLOYEES, SETUP_ACC_TYPE WHERE EMPLOYEE_ID = '#param_1#' AND ACC_TYPE_ID = '#param_2#'">
        <cfelse>
        	<cfset form.str_sql="SELECT EMPLOYEE_NAME+ ' '+ EMPLOYEE_SURNAME AS NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = '#attributes.ext_params#'">
        </cfif>
    </cfcase>
	<cfcase value="hr_offtime_plan">
		<cfset form.str_sql="SELECT TOP 1 OFFTIME_ID,EMPLOYEE_ID,IN_OUT_ID,FINISHDATE,WORK_STARTDATE FROM OFFTIME WHERE IN_OUT_ID = #attributes.ext_params#">	
	</cfcase>
	<cfcase value="hr_offtime_in_out">
		<cfset form.str_sql="SELECT E.EMPLOYEE_NAME, E.EMPLOYEE_SURNAME,EIO.START_DATE,EIO.EMPLOYEE_ID,EIO.IN_OUT_ID from EMPLOYEES_IN_OUT EIO, EMPLOYEES E where EIO.IN_OUT_ID = #attributes.ext_params# AND EIO.EMPLOYEE_ID = E.EMPLOYEE_ID">
	</cfcase>
	<cfcase value="hr_employee_no_qry">
		<cfset form.str_sql="SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="hr_emp_detail">
		<!---<cfset form.str_sql="SELECT MAX(CONVERT(FLOAT,SUBSTRING(EMPLOYEE_NO,5,(LEN(EMPLOYEE_NO)-4)))) AS BIGGEST_NUMBER FROM EMPLOYEES WHERE EMPLOYEE_NO LIKE '#attributes.ext_params#-%' AND ISNUMERIC(SUBSTRING(EMPLOYEE_NO,5,(LEN(EMPLOYEE_NO)-4))) = 1">--->
		<cfset form.str_sql ="SELECT 
            MAX(CONVERT(FLOAT,SUBSTRING(EMPLOYEE_NO,(CHARINDEX('-', EMPLOYEE_NO)+1),(LEN(EMPLOYEE_NO)-CHARINDEX('-', EMPLOYEE_NO))))) AS BIGGEST_NUMBER 
        FROM 
            EMPLOYEES 
        WHERE 
            EMPLOYEE_NO LIKE '#attributes.ext_params#-%' AND 
            ISNUMERIC(SUBSTRING(EMPLOYEE_NO,(CHARINDEX('-', EMPLOYEE_NO)+1),(LEN(EMPLOYEE_NO)-CHARINDEX('-', EMPLOYEE_NO)))) = 1">
    </cfcase>				 
	<cfcase value="hr_wrk_grp">
		<cfset form.str_sql="SELECT * FROM WORK_GROUP WHERE HIERARCHY = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="hr_emp_no">
		<cfset form.str_sql="SELECT EMPLOYEE_NUMBER,EMPLOYEE_NO FROM GENERAL_PAPERS_MAIN">
	</cfcase>
	<cfcase value="hr_get_emp_cv_new">
		<cfset form.str_sql="SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #attributes.ext_params#">
	</cfcase>                
	<cfcase value="hr_get_emp_task_cv_new"> 
		<cfset form.str_sql="SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #attributes.ext_params#">
	</cfcase>			     
	<cfcase value="hr_get_edu_part_name">
		<cfset form.str_sql="SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = #attributes.ext_params#">
	</cfcase>			   	 
	<cfcase value="hr_get_cv_edu_new">
		<cfset form.str_sql="SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #attributes.ext_params#">
	</cfcase>			     
	<cfcase value="hr_cv_edu_high_part_id_q">
		<cfset form.str_sql="SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #attributes.ext_params#">
	</cfcase>			     
	<cfcase value="hr_cv_edu_part_id_q">	
		<cfset form.str_sql="SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #attributes.ext_params#">
	</cfcase>			     
	<cfcase value="hr_get_ilce">
		<cfset form.str_sql="SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE CITY IN (#attributes.ext_params#)">
	</cfcase>
	<cfcase value="hr_get_city">
		<cfset form.str_sql="SELECT PLATE_CODE FROM SETUP_CITY WHERE CITY_ID IN (#attributes.ext_params#)">
	</cfcase>
	<cfcase value="hr_get_branches">
		<cfset form.str_sql="SELECT BRANCHES_ID,BRANCHES_NAME FROM SETUP_APP_BRANCHES">
	</cfcase>
	<cfcase value="hr_get_dep">
		<cfset form.str_sql="SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="hr_get_department_name">
		<cfset form.str_sql="SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID IN (#attributes.ext_params#)">
	</cfcase>                
	<cfcase value="hr_get_dep_list">
		<cfset form.str_sql="SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID =#attributes.ext_params#">
	</cfcase>   	
	<cfcase value="hr_get_employee_no_query">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NO = '#param_1#' AND EMPLOYEE_ID <> #param_2#">
    </cfcase>  
    <cfcase value="hr_get_puantaj_hierarchy">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset param_7 = listgetat(attributes.ext_params,7,"*")>
		<cfif len(param_5) AND  param_6 eq 2 and param_5>
			<cfif len(listgetat(attributes.ext_params,6,"*"))>
				<cfset param_8 = listgetat(attributes.ext_params,7,"*")>
			<cfelse>
				<cfset param_8 = 0>
			</cfif>
			<cfset form.str_sql= "SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY = '#param_5#' AND STATUE = #param_6# AND STATUE_TYPE = #param_7# AND ISNULL(STATUE_TYPE_INDIVIDUAL,0) = #param_8#">
		<cfelseif len(param_5) AND  param_6 neq 2 and param_5 neq '-999'>
			<cfset form.str_sql= "SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY = '#param_5#' AND STATUE = #param_6#">
		<cfelseif param_6 eq 2> 
			<cfset form.str_sql= "SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY IS NULL AND STATUE = #param_6# AND STATUE_TYPE = #param_7#">
		<cfelse>
			<cfset form.str_sql= "SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY IS NULL AND STATUE = #param_6#">
		</cfif>
    </cfcase>
	<cfcase value="hr_get_puantaj_">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset param_7 = listgetat(attributes.ext_params,7,"*")>
		<cfif param_5 eq 2> 
			<cfset form.str_sql= "SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY IS NULL AND STATUE = #param_5# AND STATUE_TYPE = #param_6# AND ISNULL(STATUE_TYPE_INDIVIDUAL,0) = #param_7#">
		<cfelse>
			<cfset form.str_sql= "SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY IS NULL AND STATUE = #param_5#">
		</cfif>
    </cfcase>
	<cfcase value="hr_get_puantaj_4">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY IS NULL">
    </cfcase>
	<cfcase value="hr_get_puantaj_5">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY IS NOT NULL">
    </cfcase>
    <cfcase value="hr_get_branch_id">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT EIO.BRANCH_ID FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID=#param_3# AND EIO.START_DATE <= #CreateDate(param_2,param_1,daysinmonth(CreateDate(param_2,param_1,1)))# AND((EIO.FINISH_DATE >= #CreateDate(param_2,param_1,1)#) OR EIO.FINISH_DATE IS NULL)">
    </cfcase>
	<cfcase value="hr_get_puantaj_5_1">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT EP.PUANTAJ_ID FROM EMPLOYEES_PUANTAJ EP,EMPLOYEES_PUANTAJ_ROWS EPR WHERE EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND SAL_MON = #param_1# AND SAL_YEAR = #param_2# AND EPR.EMPLOYEE_ID=#param_3# AND PUANTAJ_TYPE = #param_4# AND HIERARCHY IS NOT NULL">
    </cfcase>
   	<cfcase value="hr_get_puantaj_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		
		<cfif len(listgetat(attributes.ext_params,5,"*"))>
			<cfset param_5 = listgetat(attributes.ext_params,5,"*")>
			<cfset param_6 = listgetat(attributes.ext_params,6,"*")>
			<cfif len(listgetat(attributes.ext_params,6,"*"))>
				<cfset param_7 = listgetat(attributes.ext_params,7,"*")>
			<cfelse>
				<cfset param_7 = 0>
			</cfif>
			<cfset form.str_sql= "SELECT PUANTAJ_ID,SAL_MON,SAL_YEAR FROM EMPLOYEES_PUANTAJ WHERE ((SAL_MON > #param_1# AND SAL_YEAR = #param_2#) OR SAL_YEAR > #param_2#) AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4# AND STATUE = #param_5# AND STATUE_TYPE =  #param_6# AND ISNULL(STATUE_TYPE_INDIVIDUAL,0) = #param_7# ORDER BY SAL_YEAR,SAL_MON">
		<cfelse>
			<cfset form.str_sql= "SELECT PUANTAJ_ID,SAL_MON,SAL_YEAR FROM EMPLOYEES_PUANTAJ WHERE ((SAL_MON > #param_1# AND SAL_YEAR = #param_2#) OR SAL_YEAR > #param_2#) AND SSK_BRANCH_ID = #param_3# AND PUANTAJ_TYPE = #param_4#  ORDER BY SAL_YEAR,SAL_MON">
		</cfif>
    </cfcase>
   	<cfcase value="hr_get_puantaj_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT EP.PUANTAJ_ID FROM EMPLOYEES_PUANTAJ EP,EMPLOYEES_PUANTAJ_ROWS EPR WHERE EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND ((SAL_MON > #param_1# AND SAL_YEAR = #param_2#) OR SAL_YEAR > #param_2#) AND EPR.EMPLOYEE_ID=#param_3# AND PUANTAJ_TYPE = #param_4#">
    </cfcase>
    <cfcase value="hr_get_puantaj_3_1">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT EP.PUANTAJ_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,EP.SAL_YEAR,EP.SAL_MON FROM EMPLOYEES_PUANTAJ EP,EMPLOYEES_PUANTAJ_ROWS EPR,EMPLOYEES_IN_OUT EIO,EMPLOYEES E WHERE EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND ((SAL_MON > #param_1# AND SAL_YEAR = #param_2#) OR SAL_YEAR > #param_2#) AND EIO.EMPLOYEE_ID=E.EMPLOYEE_ID AND EIO.EMPLOYEE_ID=EPR.EMPLOYEE_ID AND EIO.IN_OUT_ID IN (#param_3#) AND PUANTAJ_TYPE = #param_4#">
    </cfcase>
	<cfcase value="hr_notice_no_qry">
		<cfset form.str_sql="SELECT NOTICE_ID FROM NOTICES WHERE NOTICE_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="hr_notice_detail">
		<cfset form.str_sql="SELECT MAX(CONVERT(FLOAT,SUBSTRING(NOTICE_NO,5,(LEN(NOTICE_NO)-4)))) AS BIGGEST_NUMBER FROM NOTICES WHERE NOTICE_NO LIKE '#attributes.ext_params#-%' AND ISNUMERIC(SUBSTRING(NOTICE_NO,5,(LEN(NOTICE_NO)-4))) = 1">
	</cfcase>
	<cfcase value="hr_employee_mandate">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql="SELECT MANDATE_MASTER_ID FROM EMPLOYEE_MANDATE WHERE ( (#param_1# >= MANDATE_STARTDATE  AND #param_2# <= MANDATE_FINISHDATE))  AND MASTER_EMPLOYEE_ID= #param_3#">
	</cfcase>
	<!--- invoice --->
	<cfcase value="inv_basket_zero_stock_status">
		<cfset form.str_sql="SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE B_TYPE=1 AND TITLE='zero_stock_status' AND BASKET_ID = #attributes.ext_params#">
	</cfcase>				 
	<cfcase value="inv_get_inv_control">
		<cfset form.str_sql="SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM INVOICE_ROW WHERE INVOICE_ID IN(SELECT I.INVOICE_ID FROM INVOICE I WHERE I.IS_IPTAL = 0) AND WRK_ROW_RELATION_ID = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="inv_get_ship_control2">
		<cfset form.str_sql="SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM SHIP_ROW WHERE SHIP_ID IN(SELECT S.SHIP_ID FROM SHIP S WHERE S.SHIP_TYPE = 75 AND S.IS_SHIP_IPTAL = 0) AND WRK_ROW_RELATION_ID = '#attributes.ext_params#'">
	</cfcase>		
	<cfcase value="inv_get_ship_control3">
		<cfset form.str_sql="SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM SHIP_ROW WHERE SHIP_ID IN(SELECT S.SHIP_ID FROM SHIP S WHERE S.SHIP_TYPE = 74 AND S.IS_SHIP_IPTAL = 0) AND WRK_ROW_RELATION_ID = '#attributes.ext_params#'">
	</cfcase>		 
	<cfcase value="inv_get_period">
		<cfset form.str_sql="SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = '#attributes.ext_params#'">
	</cfcase>				 
	<cfcase value="inv_get_ship_control">
		<cfset form.str_sql="SELECT AMOUNT FROM SHIP_ROW WHERE WRK_ROW_ID = '#attributes.ext_params#'">
	</cfcase>				 
	<cfcase value="inv_process_info">
		<cfset form.str_sql="SELECT IS_PAYMETHOD_BASED_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params# ">
	</cfcase>			     
	<cfcase value="inv_risk_info">
		<cfset form.str_sql="SELECT TOTAL_RISK_LIMIT,BAKIYE,CEK_ODENMEDI,SENET_ODENMEDI,CEK_KARSILIKSIZ,SENET_KARSILIKSIZ FROM COMPANY_RISK WHERE COMPANY_ID = #attributes.ext_params#">
	</cfcase>				 
	<cfcase value="inv_risk_info2">
		<cfset form.str_sql="SELECT TOTAL_RISK_LIMIT,BAKIYE,CEK_ODENMEDI,SENET_ODENMEDI,CEK_KARSILIKSIZ,SENET_KARSILIKSIZ FROM CONSUMER_RISK WHERE CONSUMER_ID = #attributes.ext_params#">
	</cfcase>			
	<cfcase value="inv_ship_q">
		<cfset form.str_sql="SELECT SHIP_ID FROM INVOICE_SHIPS WHERE INVOICE_ID = #attributes.ext_params#">
	</cfcase>
   	<cfcase value="inv_closed_info">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 COMPANY_ID,CONSUMER_ID FROM CARI_CLOSED,CARI_CLOSED_ROW WHERE CARI_CLOSED.CLOSED_ID = CARI_CLOSED_ROW.CLOSED_ID AND CARI_CLOSED_ROW.ACTION_ID = #param_1# AND CARI_CLOSED_ROW.ACTION_TYPE_ID = #param_2#">
    </cfcase>  				
   	<cfcase value="inv_get_inv_control_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(AMOUNT),0) AMOUNT FROM INVOICE_ROW WHERE INVOICE_ID <> #param_1# AND WRK_ROW_RELATION_ID = '#param_2#' AND INVOICE_ID NOT IN (SELECT INVOICE_ID FROM INVOICE WHERE IS_IPTAL = 1)">
    </cfcase>  	    		
   	<cfcase value="inv_closed_info_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 COMPANY_ID,CONSUMER_ID,CARI_CLOSED.CLOSED_ID FROM CARI_CLOSED,CARI_CLOSED_ROW WHERE CARI_CLOSED.CLOSED_ID = CARI_CLOSED_ROW.CLOSED_ID AND CARI_CLOSED_ROW.ACTION_ID = #param_1# AND CARI_CLOSED_ROW.ACTION_TYPE_ID = #param_2#">
    </cfcase>
	<cfcase value="inv_payment_plan">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 COMPANY_ID FROM INVOICE_PAYMENT_PLAN WHERE INVOICE_ID = #param_1# AND PERIOD_ID = #param_2#">
    </cfcase>  
	<cfcase value="get_inv_payment_plan_bank">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT INVOICE_PAYMENT_PLAN_ID,INVOICE_NUMBER FROM INVOICE_PAYMENT_PLAN WHERE INVOICE_ID = #param_1#  AND PERIOD_ID = '#SESSION.EP.PERIOD_ID#' AND IS_BANK=1">
    </cfcase>  

    <!--- EFatura --->    
	<cfcase value="chk_efatura_count">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT 1 FROM EINVOICE_SENDING_DETAIL WHERE ACTION_ID = #param_1# AND STATUS_CODE = 1">
    </cfcase> 
    
	<!--- EArsiv --->  
    <cfcase value="chk_earchive_count">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT 1 FROM EARCHIVE_SENDING_DETAIL WHERE ACTION_ID = #param_1# AND STATUS_CODE = 1">
	</cfcase> 
	
	<!--- Eirsaliye --->
	<cfcase value="chk_eshipment_count">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT 1 FROM ESHIPMENT_SENDING_DETAIL WHERE ACTION_ID = #param_1# AND STATUS_CODE = 1">
	</cfcase> 

    <cfcase value="chk_product_serial1">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset form.str_sql= "SELECT IS_SERIAL_NO,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #param_1#">
    </cfcase>
    
    <!--- JS --->
	<cfcase value="js_get_credit_all">
		<cfset form.str_sql="SELECT PAYMENT_RATE_TYPE,MONEY FROM COMPANY_CREDIT WHERE COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_CREDIT.COMPANY_ID = #attributes.ext_params#" >
	</cfcase>				
    <cfcase value="js_get_credit_all_2">
		<cfset form.str_sql="SELECT PAYMENT_RATE_TYPE,MONEY FROM COMPANY_CREDIT WHERE COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_CREDIT.CONSUMER_ID = #attributes.ext_params#" >
	</cfcase>					
    <cfcase value="js_get_money_info">
		<cfset form.str_sql="SELECT MONEY AS MONEY_TYPE,RATE1,RATE2,0 AS IS_SELECTED,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID=#session.ep.company_id# AND VALIDATE_DATE = #attributes.ext_params# GROUP BY MONEY)" >
	</cfcase>				
	<cfcase value="js_GET_OUR_COMPANY_INFO">
		<cfset form.str_sql="SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.COMPANY_ID#" >
	</cfcase>										        		
	<!--- member --->
	<cfcase value="mr_get_companycat">
		<cfset form.str_sql="SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID =#attributes.ext_params#">
	</cfcase>       
	<cfcase value="mr_get_consumercat">
		<cfset form.str_sql="SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.ext_params#">
	</cfcase>  
	<cfcase value="mr_get_phone_no">
		<cfset form.str_sql="SELECT COUNTRY_PHONE_CODE, COUNTRY_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID = #attributes.ext_params#">
	</cfcase> 
	<cfcase value="mr_get_comp_branch">
		<cfset form.str_sql="SELECT COMPANY_ADDRESS,COMPANY_POSTCODE,SEMT,COMPANY_TELCODE,COMPANY_TEL1,COMPANY_FAX,CITY,COUNTY,COUNTRY FROM COMPANY WHERE COMPANY_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="mr_get_company_branch">
		<cfset form.str_sql="SELECT CAST(COMPBRANCH_ADDRESS AS NVARCHAR(250)) COMPBRANCH_ADDRESS,COMPBRANCH_POSTCODE,SEMT,COMPBRANCH_TELCODE,COMPBRANCH_TEL1,COMPBRANCH_FAX,CITY_ID,COUNTY_ID,COUNTRY_ID FROM COMPANY_BRANCH WHERE COMPBRANCH_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="mr_bank_branch_name">
		<cfset form.str_sql="SELECT BANK_BRANCH_ID, BANK_BRANCH_NAME, BRANCH_CODE,SWIFT_CODE FROM BANK_BRANCH WHERE BANK_ID = #attributes.ext_params# ORDER BY BANK_BRANCH_NAME ">
	</cfcase>   
	<cfcase value="mr_get_company">
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE OZEL_KOD = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="mr_get_company2">
		<cfset form.str_sql="SELECT COMPANY_ID FROM COMPANY WHERE TAXNO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="mr_get_consumer">
		<cfset form.str_sql="SELECT CONSUMER_REFERENCE_CODE FROM CONSUMER WHERE REF_POS_CODE ='#attributes.ext_params#'">
	</cfcase>	             
	<cfcase value="mr_get_unv">
		<cfset form.str_sql="SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_NAME='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="same_customer_card_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT CARD_ID,CARD_NO FROM CUSTOMER_CARDS WHERE CARD_NO = '#param_1#' AND CARD_ID <> #param_2#">
	</cfcase>
   	<cfcase value="mr_GET_RESULTS">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT RESULT_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID =#param_1# AND PARTNER_ID =#param_2# AND PERIOD =#param_3#"> 			
    </cfcase>    
   	<cfcase value="mr_GET_RESULTS_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT RESULT_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = #param_1# AND CONSUMER_ID = #param_2# AND PERIOD =#param_3#">
    </cfcase>  
	<cfcase value="mr_get_ims_code">
		<cfset form.str_sql="SELECT SIC.IMS_CODE_ID,SIC.IMS_CODE AS IMS_CODE,SIC.IMS_CODE_NAME AS IMS_CODE_NAME,SD.POST_CODE,SD.PART_NAME FROM SETUP_DISTRICT SD LEFT JOIN SETUP_IMS_CODE SIC ON SIC.IMS_CODE_ID = SD.IMS_CODE_ID WHERE SD.DISTRICT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="mr_get_district">
		<cfset form.str_sql="SELECT DISTRICT_ID,POST_CODE,PART_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="mr_add_cell_phone">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT CONSUMER_ID FROM CONSUMER WHERE (MOBIL_CODE = '#param_1#' AND MOBILTEL='#param_2#')">
	</cfcase>
	<cfcase value="mr_upd_cell_phone">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql="SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID <> #param_1# AND (MOBIL_CODE = '#param_2#' AND MOBILTEL= '#param_3#')">
	</cfcase>
    	<!--- myhome --->
	<cfcase value="employee_username_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"¶")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"¶")>
		<cfset form.str_sql="SELECT EMPLOYEES.EMPLOYEE_USERNAME FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID <> #param_2# AND EMPLOYEES.EMPLOYEE_USERNAME = '#param_1#'">
	</cfcase>
	<cfcase value="employee_password_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"¶")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"¶")>
	<cfif len(param_1)>
		<CF_CRYPTEDPASSWORD password="#param_1#" output="param_1" mod="1">
	</cfif>
		<cfset form.str_sql="SELECT EMPLOYEE_PASSWORD FROM EMPLOYEES WHERE EMPLOYEE_ID = #param_2# AND EMPLOYEE_PASSWORD = '#param_1#'">
	</cfcase>
	
	<cfcase value="employee_old_password_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"¶")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"¶")>
		<CF_CRYPTEDPASSWORD password="#param_1#" output="param_1" mod="1">
		<cfset form.str_sql="SELECT	NEW_PASSWORD,'#param_1#' AS SON_GELEN FROM EMPLOYEES_HISTORY WHERE IS_PASSWORD_CHANGE = 1 AND EMPLOYEE_ID = #param_2# ORDER BY EMPLOYEE_HISTORY_ID DESC">
	</cfcase>

	<cfcase value="myp_get_cons">
		<cfset form.str_sql="SELECT DISTINCT CONSUMER_ID,CONSUMER2_ID,VALID_TYPE FROM CONSUMER_TO_CONSUMER WHERE CONSUMER_ID = #attributes.ext_params# AND CONSUMER2_ID = #session.ww.userid#">
	</cfcase>	    
    
	<!--- objects --->
	<cfcase value="obj_get_fuseaction">
		<cfset form.str_sql="SELECT MODUL,FUSEACTION FROM WRK_OBJECTS WHERE FUSEACTION = '#attributes.ext_params#' OR HEAD ='#attributes.ext_params#'">
	</cfcase>	
	<cfcase value="obj_get_modul">
		<cfset form.str_sql="SELECT MODUL_SHORT_NAME FROM MODULES WHERE MODUL_NAME = #attributes.ext_params#">
	</cfcase>	
	<cfcase value="obj_get_money_rate">
		<cfset form.str_sql="SELECT RATE1,RATE2,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM SETUP_MONEY WHERE MONEY = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="obj_get_money_rates">
		<cfset form.str_sql="SELECT RATE1,RATE2,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR,MONEY FROM SETUP_MONEY WHERE MONEY IN (#attributes.ext_params#)">
	</cfcase>		  
	<cfcase value="obj_get_money_rate_all">
		<cfset form.str_sql="SELECT RATE1,RATE2,ISNULL(RATE3,1) RATE3,ISNULL(EFFECTIVE_SALE,1) EFFECTIVE_SALE,ISNULL(EFFECTIVE_PUR,1) EFFECTIVE_PUR,MONEY MONEY_TYPE FROM SETUP_MONEY">
	</cfcase>			  
  	<cfcase value="obj_get_serial_rma">
		<cfset form.str_sql="SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE RMA_NO='#attributes.ext_params#'">
	</cfcase>   
 	<cfcase value="obj_product_info">
		<cfset form.str_sql="SELECT  TOP 1 STOCKS.STOCK_ID,STOCKS.PRODUCT_ID,STOCKS.STOCK_CODE,PRODUCT.PRODUCT_NAME,STOCKS.PROPERTY,STOCKS.BARCOD AS BARCOD,PRODUCT.IS_INVENTORY,PRODUCT.IS_PRODUCTION,PRODUCT.TAX AS TAX,PRODUCT.OTV AS OTV,PRODUCT.IS_ZERO_STOCK,PRODUCT.IS_PRODUCTION,PRODUCT.PRODUCT_CATID,PRODUCT.PRODUCT_CODE,PRODUCT.IS_SERIAL_NO,STOCKS.MANUFACT_CODE,PRICE_STANDART.PRICE,PRICE_STANDART.MONEY,PRODUCT_UNIT.ADD_UNIT,PRODUCT_UNIT.PRODUCT_UNIT_ID,PRODUCT_UNIT.MAIN_UNIT,PRODUCT_UNIT.MULTIPLIER FROM PRODUCT,PRODUCT_CAT,STOCKS,PRICE_STANDART,PRODUCT_UNIT,PRODUCT_OUR_COMPANY WHERE PRODUCT_OUR_COMPANY.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = 1 AND PRODUCT.PRODUCT_STATUS = 1 AND STOCKS.STOCK_STATUS = 1 AND PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND PRICE_STANDART.PRICESTANDART_STATUS = 1 AND PRICE_STANDART.PURCHASESALES = 1 AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND STOCKS.STOCK_ID = #attributes.ext_params# ORDER BY PRODUCT_NAME,STOCKS.PROPERTY">
	</cfcase>
	<cfcase value="obj_belge_no_ctrl">
		<cfset form.str_sql="SELECT PAPER_NO FROM EXPENSE_ITEM_PLANS WHERE PAPER_NO ='#attributes.ext_params#'">
	</cfcase>
	<cfcase value="obj_get_company">
		<cfset form.str_sql="SELECT EP.EMPLOYEE_ID,C.COMP_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B,OUR_COMPANY C WHERE EP.POSITION_STATUS=1 AND D.BRANCH_ID =B.BRANCH_ID AND C.COMP_ID = B.COMPANY_ID AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND EP.EMPLOYEE_ID=#attributes.ext_params#">
	</cfcase>                
	<cfcase value="obj_get_acc_code">
		<cfset form.str_sql="SELECT EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIO.EMPLOYEE_ID = #attributes.ext_params# AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#">
	</cfcase>
	<cfcase value="obj_get_acc_code_all">
		<cfset param_1 = listgetat(attributes.ext_params,1,"¶")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"¶")>
		<cfset form.str_sql="SELECT EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = #param_1# EIO.ACC_TYPE_ID = #param_2# AND EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id#">
	</cfcase>
	<cfcase value="obj_get_acc_code_per_adv">
		<cfset form.str_sql="SELECT PERSONAL_ADVANCE_ACCOUNT FROM SETUP_SALARY_PAYROLL_ACCOUNTS">
	</cfcase>
	<cfcase value="obj_get_note">
		<cfset form.str_sql="SELECT ACTION_ID FROM NOTES WHERE COMPANY_ID = #session.ep.company_id# AND ACTION_SECTION = 'SUBSCRIPTION_ID' AND IS_WARNING = 1 AND ACTION_ID = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="obj_get_main_spect">
		<cfset form.str_sql="SELECT SPECT_MAIN_ID,SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID =#attributes.ext_params#">
	</cfcase>			     
	<cfcase value="obj_ctrl_cd">
		<cfset form.str_sql="SELECT SUM(CLOSED_AMOUNT) CLOSED_AMOUNT FROM (SELECT ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0) CLOSED_AMOUNT FROM CREDIT_CARD_BANK_EXPENSE,CREDIT_CARD_BANK_EXPENSE_ROWS WHERE EXPENSE_ID = #attributes.ext_params# AND ACTION_PERIOD_ID = #session.ep.period_id# AND CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID) T1">
	</cfcase>     
	<cfcase value="obj_get_basket_member_info">
		<cfset form.str_sql="SELECT BASKET_ID FROM SETUP_BASKET_ROWS WHERE TITLE='is_member_not_change' AND IS_SELECTED=1 AND BASKET_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="obj_get_basket_project_info">
		<cfset form.str_sql="SELECT BASKET_ID FROM SETUP_BASKET_ROWS WHERE TITLE='is_project_not_change' AND IS_SELECTED=1 AND BASKET_ID =#attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_expense_center">
		<cfset form.str_sql="SELECT EIOP.EXPENSE_CENTER_ID,EIOP.EXPENSE_CODE_NAME,EIOP.EXPENSE_ITEM_ID,EIOP.EXPENSE_ITEM_NAME FROM EMPLOYEES_IN_OUT_PERIOD EIOP, EMPLOYEES_IN_OUT EIO WHERE EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND EIO.EMPLOYEE_ID =#attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_process_cat">
		<cfset form.str_sql="SELECT IS_ACCOUNT,ISNULL(IS_ADD_INVENTORY,0) IS_ADD_INVENTORY FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_proje_merkez">
		<cfset form.str_sql="SELECT EXPENSE_CODE FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.ext_params#">
	</cfcase> 
    <cfcase value="obj_get_project_period">
		<cfset form.str_sql="SELECT COST_EXPENSE_CENTER_ID EXPENSE_CENTER_ID,EXPENSE_ITEM_ID FROM PROJECT_PERIOD WHERE PROJECT_ID = #attributes.ext_params# AND PERIOD_ID = #session.ep.period_id#">
	</cfcase> 
    <cfcase value="obj_get_code">
		<cfset form.str_sql="SELECT EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_CODE = '#attributes.ext_params#'">
	</cfcase>
    <cfcase value="obj_consumer_cc_2">
		<cfset form.str_sql="SELECT ISNULL(TOTAL_RISK_LIMIT,0) TOTAL_RISK_LIMIT,ISNULL(BAKIYE,0) BAKIYE,ISNULL(SENET_KARSILIKSIZ,0) AS SENET_KARSILIKSIZ,ISNULL(CEK_KARSILIKSIZ,0) CEK_KARSILIKSIZ,ISNULL(CEK_ODENMEDI,0) CEK_ODENMEDI,ISNULL(SENET_ODENMEDI,0) SENET_ODENMEDI,ISNULL(KEFIL_SENET_ODENMEDI,0) KEFIL_SENET_ODENMEDI,ISNULL(KEFIL_SENET_KARSILIKSIZ,0) KEFIL_SENET_KARSILIKSIZ FROM CONSUMER_RISK WHERE CONSUMER_ID =  #attributes.ext_params#">
	</cfcase>
	 <cfcase value="obj_company_cc_2">
		<cfset form.str_sql="SELECT ISNULL(TOTAL_RISK_LIMIT,0) TOTAL_RISK_LIMIT,ISNULL(BAKIYE,0) BAKIYE,ISNULL(SENET_KARSILIKSIZ,0) AS SENET_KARSILIKSIZ,ISNULL(CEK_KARSILIKSIZ,0) CEK_KARSILIKSIZ,ISNULL(CEK_ODENMEDI,0) CEK_ODENMEDI,ISNULL(SENET_ODENMEDI,0) SENET_ODENMEDI FROM COMPANY_RISK WHERE COMPANY_ID =  #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_workgroup">
		<cfset form.str_sql="SELECT WORKGROUP_ID FROM PRO_PROJECTS WHERE PROJECT_ID =  #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_stock">
		<cfset form.str_sql="SELECT PRODUCT_NAME,STOCK_CODE FROM STOCKS WHERE IS_ZERO_STOCK=0 AND IS_INVENTORY=1 AND STOCK_ID IN ( #attributes.ext_params# )">
	</cfcase>
    <cfcase value="obj_get_price_cat_detail">
		<cfset form.str_sql="SELECT NUMBER_OF_INSTALLMENT,AVG_DUE_DAY,TARGET_DUE_DATE FROM PRICE_CAT WHERE PRICE_CATID= #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_temp_rows">
		<cfset form.str_sql="SELECT ETR.PROMOTION_ID,ETR.WORKGROUP_ID,ETR.PROJECT_ID,ETR.ASSET_ID,ETR.COMPANY_ID,ETR.COMPANY_PARTNER_ID,ETR.MEMBER_TYPE,ISNULL(ETR.RATE,0) RATE,ETR.EXPENSE_CENTER_ID,ETR.EXPENSE_ITEM_ID,EC.EXPENSE,EI.EXPENSE_ITEM_NAME FROM EXPENSE_PLANS_TEMPLATES_ROWS ETR,EXPENSE_CENTER EC,EXPENSE_ITEMS EI WHERE ETR.EXPENSE_CENTER_ID = EC.EXPENSE_ID AND ETR.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID AND TEMPLATE_ID = #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_pro_name">
		<cfset form.str_sql="SELECT PROJECT_HEAD,PRO_CURRENCY_ID,PROJECT_EMP_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="obj_get_work_name">
		<cfset form.str_sql="SELECT WORK_HEAD FROM PRO_WORKS WHERE WORK_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="work_paper_no_control">
		<cfset form.str_sql = "SELECT WORK_NO FROM PRO_WORKS WHERE WORK_NO = '#attributes.ext_params#'">
	</cfcase>
	<cfcase value="work_paper_no_control2">
		<cfset form.str_sql = "SELECT WORK_NUMBER FROM GENERAL_PAPERS_MAIN">
	</cfcase>
    <cfcase value="obj_get_pro_name_2">
		<cfset form.str_sql="SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_comp_name">
		<cfset form.str_sql="SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.ext_params#">
	</cfcase>
    	<cfcase value="obj_get_par_name">
		<cfset form.str_sql="SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_cons_name">
		<cfset form.str_sql="SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_emp_name">
		<cfset form.str_sql="SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #attributes.ext_params#">
	</cfcase>
    <cfcase value="obj_get_urun_kalem">
		<cfset form.str_sql="SELECT EXPENSE_ITEM_ID FROM PRODUCT_PERIOD WHERE PERIOD_ID = #session.ep.period_id# AND PRODUCT_ID = #attributes.ext_params#">
	</cfcase> 
	<cfcase value="obj_get_member_pricecat">
		<cfset form.str_sql="SELECT PRICE_CAT AS PRICE_CATID FROM COMPANY_CREDIT WHERE OUR_COMPANY_ID=#session.ep.company_id# AND COMPANY_ID = #attributes.ext_params#">
	</cfcase> 
	<cfcase value="obj_get_member_cat">
		<cfset form.str_sql="SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.ext_params#">
	</cfcase> 				 
	<cfcase value="obj_get_member_cat_2">
		<cfset form.str_sql="SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.ext_params#">
	</cfcase>   
	<cfcase value="obj_get_price_cat_detail_2">
		<cfset form.str_sql="SELECT AVG_DUE_DAY,DUE_DIFF_VALUE,EARLY_PAYMENT FROM PRICE_CAT WHERE PRICE_CATID= #attributes.ext_params#">
	</cfcase>     
	<cfcase value="obj_get_installment_rate">
		<cfset form.str_sql="SELECT * FROM SETUP_INTEREST_RATE WHERE MONTH_VALUE = #attributes.ext_params#">
	</cfcase>   
	<cfcase value="obj_get_pymthd_vehicle">
		<cfset form.str_sql="SELECT SP.PAYMENT_VEHICLE FROM SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID= #attributes.ext_params#">
	</cfcase>         
	<cfcase value="obj_get_credit_limit">
		<cfset form.str_sql="SELECT PRICE_CAT FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.ext_params# AND OUR_COMPANY_ID= #session.ep.company_id#">
	</cfcase>   
	<cfcase value="obj_get_credit_limit_pur">
		<cfset form.str_sql="SELECT PRICE_CAT_PURCHASE FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.ext_params# AND OUR_COMPANY_ID= #session.ep.company_id#">
	</cfcase> 
	<cfcase value="obj_get_credit_limit_pur_2">
		<cfset form.str_sql="SELECT PRICE_CAT_PURCHASE FROM COMPANY_CREDIT WHERE CONSUMER_ID = #attributes.ext_params# AND OUR_COMPANY_ID= #session.ep.company_id#">
	</cfcase> 
	<cfcase value="obj_get_comp_cat">
		<cfset form.str_sql="SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID= #attributes.ext_params#">
	</cfcase>    
	<cfcase value="obj_get_credit_limit_2">
		<cfset form.str_sql="SELECT PRICE_CAT FROM COMPANY_CREDIT WHERE CONSUMER_ID = #attributes.ext_params# AND OUR_COMPANY_ID=#session.ep.company_id#" >
    </cfcase>
	<cfcase value="obj_get_comp_cat_2">
		<cfset form.str_sql="SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID= #attributes.ext_params#">
	</cfcase>    
	<cfcase value="obj_get_spect">
		<cfset form.str_sql="SELECT SPECTS.SPECT_MAIN_ID, SPECTS.SPECT_VAR_ID FROM PRODUCT,SPECTS WHERE SPECTS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND SPECTS.PRODUCT_ID IS NOT NULL AND SPECTS.STOCK_ID IS NOT NULL AND IS_ZERO_STOCK=0 AND SPECT_VAR_ID IN (#attributes.ext_params#)">
	</cfcase>       
	<cfcase value="obj_get_spect_row">
		<cfset form.str_sql="SELECT PRODUCT.PRODUCT_NAME,PRODUCT.IS_ZERO_STOCK,SPECTS_ROW.PRODUCT_ID,SPECTS_ROW.STOCK_ID,SPECTS_ROW.AMOUNT_VALUE,SPECTS_ROW.SPECT_ID FROM PRODUCT,SPECTS_ROW WHERE SPECTS_ROW.PRODUCT_ID=PRODUCT.PRODUCT_ID AND SPECTS_ROW.PRODUCT_ID IS NOT NULL AND SPECTS_ROW.STOCK_ID IS NOT NULL AND IS_SEVK = 1 AND IS_ZERO_STOCK=0 AND PRODUCT.IS_INVENTORY=1 AND SPECTS_ROW.SPECT_ID IN (#attributes.ext_params#)">
	</cfcase>     
	<cfcase value="obj_get_spect_row_2">
		<cfset form.str_sql="SELECT PRODUCT.PRODUCT_NAME,PRODUCT.IS_ZERO_STOCK,SPECTS_ROW.PRODUCT_ID,SPECTS_ROW.STOCK_ID,SPECTS_ROW.AMOUNT AS AMOUNT_VALUE,SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID AS SPECT_ID FROM PRODUCT,SPECT_MAIN_ROW WHERE SPECT_MAIN_ROW.PRODUCT_ID=PRODUCT.PRODUCT_ID AND SPECT_MAIN_ROW.PRODUCT_ID IS NOT NULL AND SPECT_MAIN_ROW.STOCK_ID IS NOT NULL AND IS_SEVK = 1 AND IS_ZERO_STOCK=0 AND PRODUCT.IS_INVENTORY=1 AND SPECT_MAIN_ROW.SPECT_MAIN_ID IN (#attributes.ext_params#)">
	</cfcase>      
	<cfcase value="obj_get_tree">
		<cfset form.str_sql="SELECT PRODUCT_TREE.STOCK_ID,PRODUCT_TREE.AMOUNT,PRODUCT_TREE.RELATED_ID FROM PRODUCT_TREE WHERE PRODUCT_TREE.STOCK_ID IN (#attributes.ext_params#) AND IS_SEVK=1">
	</cfcase>         
	<cfcase value="obj_get_prod_control">
		<cfset form.str_sql="SELECT ISNULL(IS_COMMISSION,1) COM_CONTROL FROM PRODUCT WHERE PRODUCT_ID = #attributes.ext_params# ">   
	</cfcase>              	
	<cfcase value="obj_get_price_cat_month">
		<cfset form.str_sql="SELECT PRICE_CATID,NUMBER_OF_INSTALLMENT FROM PRICE_CAT WHERE PRICE_CATID = #attributes.ext_params# ">   
	</cfcase>       
 	<cfcase value="obj_get_shelf_name">
		<cfset form.str_sql="SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID = #attributes.ext_params# ">   
	</cfcase>      
 	<cfcase value="obj_get_stock_2">
		<cfset form.str_sql="SELECT S.PRODUCT_NAME FROM STOCKS S,PRODUCT P WHERE P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND P.IS_INVENTORY=1 AND S.STOCK_ID IN ( #attributes.ext_params# ) ">   
	</cfcase>  
 	<cfcase value="obj_get_stock_3">
		<cfset form.str_sql="SELECT P.SPECT_MAIN_NAME AS PRODUCT_NAME,P.SPECT_MAIN_ID FROM SPECT_MAIN P,STOCKS S WHERE S.STOCK_ID=P.STOCK_ID AND P.SPECT_MAIN_ID IN ( #attributes.ext_params# ) AND S.IS_ZERO_STOCK=0 ">   
	</cfcase> 	
 	<cfcase value="obj_get_comp_proms">
		<cfset form.str_sql="SELECT COMPANY_ID, LIMIT_VALUE, LIMIT_CURRENCY, DISCOUNT, PROM_ID, FREE_STOCK_ID, FREE_STOCK_AMOUNT, FREE_STOCK_PRICE, AMOUNT_1_MONEY, TOTAL_PROMOTION_COST FROM PROMOTIONS WHERE PROM_STATUS = 1 AND PROM_TYPE = 0 AND LIMIT_VALUE IS NOT NULL AND #attributes.ext_params# BETWEEN STARTDATE AND FINISHDATE ORDER BY STARTDATE DESC ">   
	</cfcase> 		
 	<cfcase value="obj_get_stock_proms">
		<cfset form.str_sql="SELECT S.PRODUCT_ID, S.PRODUCT_NAME,S.PRODUCT_DETAIL2, S.STOCK_CODE, S.STOCK_ID, S.BARCOD, S.TAX, S.MANUFACT_CODE, S.IS_INVENTORY, S.IS_PRODUCTION, S.IS_COST ,S.PRODUCT_UNIT_ID, S.PROPERTY, PU.ADD_UNIT FROM STOCKS S,PRODUCT_UNIT PU WHERE S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND S.STOCK_ID= #attributes.ext_params# ">   
	</cfcase> 	
 	<cfcase value="obj_get_prod_acc">
		<cfset form.str_sql="SELECT ACCOUNT_CODE FROM PRODUCT_PERIOD WHERE PERIOD_ID= #session.ep.period_id# AND PRODUCT_ID= #attributes.ext_params# ">   
	</cfcase> 	
 	 <cfcase value="obj_variationQueryText">
		<cfset form.str_sql="SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = #attributes.ext_params# ">   
	</cfcase> 	    
 	<cfcase value="obj_otv_control">
		<cfset form.str_sql="SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = '#SESSION.EP.PERIOD_ID#' AND TAX IN (#attributes.ext_params#) ">   
	</cfcase> 	     
 	<cfcase value="obj_paper_number">
		<cfset form.str_sql="SELECT PAPER_NO FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE PAPER_NO='#attributes.ext_params#' ">   
	</cfcase>     
 	<cfcase value="obj_get_sec">
		<cfset form.str_sql="SELECT SECTION_NAME,TRAINING_SEC_ID FROM TRAINING_SEC WHERE TRAINING_CAT_ID = #attributes.ext_params# ">   
	</cfcase> 	
 	<cfcase value="obj_process_info">
		<cfset form.str_sql="SELECT IS_PAYMETHOD_BASED_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.ext_params# ">   
	</cfcase> 	
 	<cfcase value="obj_get_pay">
		<cfset form.str_sql="SELECT DUE_MONTH,DUE_DATE_RATE,IN_ADVANCE,DUE_START_DAY,DUE_DAY,DUE_START_MONTH FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #attributes.ext_params#">   
	</cfcase> 	    
 	<cfcase value="obj_get_productcat">
		<cfset form.str_sql="SELECT BRAND_ID FROM PRODUCT WHERE BRAND_ID = #attributes.ext_params# ">   
	</cfcase>    
 	<cfcase value="obj_get_stock_karma">
		<cfset form.str_sql="SELECT S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.PRODUCT_NAME, S.STOCK_CODE, S.STOCK_CODE_2, S.STOCK_ID, S.BARCOD, S.TAX, S.OTV, S.MANUFACT_CODE, S.IS_INVENTORY, S.IS_PRODUCTION, S.PRODUCT_UNIT_ID, S.PROPERTY, S.IS_SERIAL_NO, PU.ADD_UNIT FROM STOCKS S,PRODUCT_UNIT PU WHERE S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND S.STOCK_ID= #attributes.ext_params# ">   
	</cfcase>       
 	<cfcase value="obj_get_prod_acc_2">
		<cfset form.str_sql="SELECT ACCOUNT_CODE,ACCOUNT_CODE_PUR,ACCOUNT_PUR_IADE,ACCOUNT_IADE FROM PRODUCT_PERIOD WHERE PERIOD_ID= '#session.ep.period_id#' AND PRODUCT_ID= #attributes.ext_params# " >   
	</cfcase>          
 	<cfcase value="obj_get_spect_product">
		<cfset form.str_sql="SELECT STOCK_ID FROM SPECTS WHERE SPECT_VAR_ID = #attributes.ext_params# ">   
	</cfcase>   
 	<cfcase value="obj_get_prod_acc_3">
		<cfset form.str_sql="SELECT ACCOUNT_CODE,ACCOUNT_CODE_PUR,ACCOUNT_PUR_IADE,ACCOUNT_IADE FROM PRODUCT_PERIOD WHERE PRODUCT_ID= #attributes.ext_params#  AND PERIOD_ID = #session_base.period_id# ">   
	</cfcase>       
 	<cfcase value="obj_get_prjct_name">
		<cfset form.str_sql="SELECT PROJECT_HEAD,PROJECT_ID,PROCESS_CAT FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.ext_params# ">   
	</cfcase>
	<cfcase value="obj_belge_no_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PAPER_NO FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID <> #param_1# AND PAPER_NO = '#param_2#'">
	</cfcase> 
	<cfcase value="obj_get_credit_all">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT COMPANY_CREDIT.MONEY,RATE2,RATE1 FROM COMPANY_CREDIT,#param_1#.SETUP_MONEY  SETUP_MONEY WHERE COMPANY_CREDIT.MONEY = SETUP_MONEY.MONEY AND COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_CREDIT.COMPANY_ID = #param_2#">
	</cfcase>     
 	<cfcase value="obj_get_paper_no">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PAPER_NO FROM #param_1# WHERE PAPER_NO IN (#param_2#) AND ACTION_ID NOT IN (#param_3#)">
	</cfcase>        
 	<cfcase value="obj_get_paper_no_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PAPER_NO FROM #param_1# WHERE PAPER_NO IN (#param_2#)">
	</cfcase>            
 	<cfcase value="obj_get_money_rate_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT RATE2,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM MONEY_HISTORY WHERE MONEY = '#param_1#' AND MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID=#session.ep.company_id# AND PERIOD_ID=#session.ep.period_id# AND VALIDATE_DATE = #param_2# GROUP BY MONEY)">
	</cfcase> 
    <cfcase value="obj_get_credit_all_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT COMPANY_CREDIT.MONEY,RATE2,RATE1 FROM COMPANY_CREDIT,#param_1#.SETUP_MONEY WHERE COMPANY_CREDIT.MONEY = SETUP_MONEY.MONEY AND COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_CREDIT.CONSUMER_ID =  #param_2#">
	</cfcase>       
    <cfcase value="obj_get_member_pricecat_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
		<cfset form.str_sql= "SELECT PRICE_CATID FROM PRICE_CAT PC, #param_1#.COMPANY C WHERE PC.COMPANY_CAT LIKE '%,#param_2#,%' AND C.COMPANY_ID = #param_3#" >
	</cfcase>            
    <cfcase value="obj_get_member_pricecat_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
		<cfset form.str_sql= "SELECT PRICE_CATID FROM PRICE_CAT PC, #param_1#.CONSUMER C WHERE PC.CONSUMER_CAT LIKE '%,#param_2#,%' AND C.CONSUMER_ID =#param_3#" >
	</cfcase>    
    <cfcase value="obj_prj_order_risk_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_4#.ORDERS,#param_4#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2# AND PROJECT_ID=#param_1# AND ORDERS.ORDER_ID<>#param_3# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1" >
	</cfcase>       
    <cfcase value="obj_prj_order_risk_5">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1" >
	</cfcase>        
    <cfcase value="obj_prj_order_risk_6">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0 AND SR.ROW_ORDER_ID <> #param_4#) A1" >
	</cfcase>   
    <cfcase value="obj_prj_order_risk_7">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES = 1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1" >
	</cfcase>                      
    <cfcase value="obj_prj_order_risk_8">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0 AND SR.ROW_ORDER_ID <> #param_4#) A1" >
	</cfcase>  
    <cfcase value="obj_get_prj_discnt">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset form.str_sql= "SELECT COMPANY_ID,CONSUMER_ID,FINISH_DATE,START_DATE,PRICE_CATID,PD.PRO_DISCOUNT_ID,IS_CHECK_RISK,IS_CHECK_PRJ_LIMIT,IS_CHECK_PRJ_PRODUCT,IS_CHECK_PRJ_MEMBER,IS_CHECK_PRJ_PRICE_CAT,BRAND_ID,PRODUCT_CATID,PRODUCT_ID FROM PROJECT_DISCOUNTS PD,PROJECT_DISCOUNT_CONDITIONS PDC WHERE PD.PRO_DISCOUNT_ID=PDC.PRO_DISCOUNT_ID AND PD.PROJECT_ID=#param_1# AND FINISH_DATE >=#param_2# AND START_DATE<=#param_2#" >
	</cfcase>            
    <cfcase value="obj_get_prod_max_discount">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")>
		<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
		<cfset form.str_sql= "SELECT TOP 1 DISCOUNT1 FROM CONTRACT_SALES_PROD_DISCOUNT WHERE PRODUCT_ID =#param_1# AND PAYMETHOD_ID = #param_2# AND (START_DATE < =#param_3# AND (FINISH_DATE IS NULL OR FINISH_DATE >=#param_3# )) ORDER BY START_DATE DESC,RECORD_DATE DESC" >
	</cfcase>            
    <cfcase value="obj_get_branch_disc">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset param_3 = listlast(session.ep.user_location,'-')>
		<cfset form.str_sql= "SELECT MIN(SBD.DISCOUNT) AS MAX_DISCOUNT,P.PRODUCT_ID,P.PRODUCT_NAME  FROM PRODUCT P, SETUP_BRANCH_DISCOUNT SBD WHERE P.PRODUCT_ID IN (#param_1#) AND SBD.BRANCH_ID=#param_3# AND (P.BRAND_ID=SBD.BRAND_ID OR SBD.BRAND_ID IS NULL) AND ( (P.PRODUCT_CODE LIKE '%'+(SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=SBD.PRODUCT_CAT_ID)+'%') OR SBD.PRODUCT_CAT_ID IS NULL) GROUP BY P.PRODUCT_ID,P.PRODUCT_NAME ORDER BY PRODUCT_ID" >
	</cfcase>             
    <cfcase value="obj_get_branch_disc_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset param_3 = listlast(session.ep.user_location,'-')>
		<cfset form.str_sql= "SELECT MIN(SBD.DISCOUNT) AS MAX_DISCOUNT,P.PRODUCT_ID,P.PRODUCT_NAME  FROM PRODUCT P, SETUP_BRANCH_DISCOUNT SBD WHERE P.PRODUCT_ID IN (#param_1#) AND SBD.BRANCH_ID=#param_3# AND (P.BRAND_ID=SBD.BRAND_ID OR SBD.BRAND_ID IS NULL) AND ( (P.PRODUCT_CODE LIKE '%'+(SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=SBD.PRODUCT_CAT_ID)+'%') OR SBD.PRODUCT_CAT_ID IS NULL) AND (PAYMETHOD_ID= #param_2# ) GROUP BY P.PRODUCT_ID,P.PRODUCT_NAME ORDER BY PRODUCT_ID" >
	</cfcase>            
    <cfcase value="obj_get_branch_disc_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset param_3 = listlast(session.ep.user_location,'-')>
		<cfset form.str_sql= "SELECT MIN(SBD.DISCOUNT) AS MAX_DISCOUNT,P.PRODUCT_ID,P.PRODUCT_NAME  FROM PRODUCT P, SETUP_BRANCH_DISCOUNT SBD WHERE P.PRODUCT_ID IN (#param_1#) AND SBD.BRANCH_ID=#param_3# AND (P.BRAND_ID=SBD.BRAND_ID OR SBD.BRAND_ID IS NULL) AND ( (P.PRODUCT_CODE LIKE '%'+(SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=SBD.PRODUCT_CAT_ID)+'%') OR SBD.PRODUCT_CAT_ID IS NULL) AND (CARD_PAYMETHOD_ID= #param_2#) GROUP BY P.PRODUCT_ID,P.PRODUCT_NAME ORDER BY PRODUCT_ID" >
	</cfcase>         
    <cfcase value="obj_get_new_pricecat">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset param_3 = listlast(session.ep.user_location,'-')>
		<cfset form.str_sql= "SELECT TOP 1 P.PRICE,PC.PRICE_CATID,PC.NUMBER_OF_INSTALLMENT FROM PRICE_CAT PC,PRICE P WHERE PC.PRICE_CAT_STATUS=1 AND PC.PRICE_CATID=P.PRICE_CATID AND PC.NUMBER_OF_INSTALLMENT = #param_1# AND P.PRODUCT_ID =#param_2# AND (P.STARTDATE < =#param_3# AND (P.FINISHDATE IS NULL OR P.FINISHDATE >=#param_3# )) ORDER BY P.STARTDATE DESC,P.RECORD_DATE DESC" >
	</cfcase>           
    <cfcase value="obj_get_row_proms">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>  
		<cfset form.str_sql= "SELECT FREE_STOCK_ID,PROM_ID,FREE_STOCK_PRICE,AMOUNT_1_MONEY,LIMIT_VALUE, AMOUNT_1, FREE_STOCK_AMOUNT FROM PROMOTIONS WHERE PROM_ID = #param_6# AND PROM_STATUS = 1 AND PROM_TYPE = 1 AND LIMIT_TYPE =1 AND LIMIT_VALUE < = #param_1# AND (COMPANY_ID IS NULL OR COMPANY_ID = #param_2#) AND (PRICE_CATID =-2 OR PRICE_CATID IN (#param_3#)) AND STOCK_ID = #param_4# AND #param_5# BETWEEN STARTDATE AND FINISHDATE ORDER BY STARTDATE ASC, LIMIT_VALUE DESC" >
	</cfcase>       
 	<cfcase value="obj_get_popup_type">
		<cfset form.str_sql="SELECT DISTINCT SETUP_BASKET.PRODUCT_SELECT_TYPE FROM SETUP_BASKET WHERE SETUP_BASKET.BASKET_ID = #attributes.ext_params# AND SETUP_BASKET.B_TYPE=1">    
    </cfcase>   
	<cfcase value="obj_get_basket_rows">
		<cfset form.str_sql="SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE TITLE_NAME = 'zero_stock_control_date' AND BASKET_ID = #attributes.ext_params# AND B_TYPE=1">    
    </cfcase>          
    <cfcase value="obj_get_main_spec">
		<cfset form.str_sql= "SELECT TOP 1 SPECT_MAIN.SPECT_MAIN_ID FROM SPECT_MAIN_ROW SPECT_MAIN_ROW,SPECT_MAIN SPECT_MAIN,PRODUCT_TREE WHERE SPECT_MAIN.SPECT_STATUS = 1 AND SPECT_MAIN.STOCK_ID=#attributes.ext_params# AND PRODUCT_TREE.STOCK_ID=#attributes.ext_params# AND SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND PRODUCT_TREE.RELATED_ID = SPECT_MAIN_ROW.STOCK_ID AND SPECT_MAIN_ROW.AMOUNT = PRODUCT_TREE.AMOUNT AND SPECT_MAIN_ROW.IS_SEVK = PRODUCT_TREE.IS_SEVK AND SPECT_MAIN_ROW.IS_CONFIGURE=PRODUCT_TREE.IS_CONFIGURE AND (SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=#attributes.ext_params#=(SELECT COUNT(SMR.SPECT_MAIN_ID) FROM SPECT_MAIN_ROW SMR WHERE SMR.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID) GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME HAVING COUNT(SPECT_MAIN.SPECT_MAIN_ID) = (SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=#attributes.ext_params#)" >
	</cfcase>         
    <cfcase value="obj_get_main_spec_2">
		<cfset form.str_sql= "SELECT TOP 1 SPECT_MAIN.SPECT_MAIN_ID FROM SPECT_MAIN_ROW SPECT_MAIN_ROW,SPECT_MAIN SPECT_MAIN,PRODUCT_TREE WHERE SPECT_MAIN.SPECT_STATUS = 1 AND SPECT_MAIN.STOCK_ID=#attributes.ext_params# AND PRODUCT_TREE.STOCK_ID=#attributes.ext_params# AND SPECT_MAIN.IS_LIMITED_STOCK=1 AND SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND PRODUCT_TREE.RELATED_ID = SPECT_MAIN_ROW.STOCK_ID AND SPECT_MAIN_ROW.AMOUNT = PRODUCT_TREE.AMOUNT AND SPECT_MAIN_ROW.IS_SEVK = PRODUCT_TREE.IS_SEVK AND SPECT_MAIN_ROW.IS_CONFIGURE=PRODUCT_TREE.IS_CONFIGURE AND (SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=#attributes.ext_params#)=(SELECT COUNT(SMR.SPECT_MAIN_ID) FROM SPECT_MAIN_ROW SMR WHERE SMR.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID) GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME HAVING COUNT(SPECT_MAIN.SPECT_MAIN_ID) = (SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=#attributes.ext_params#)" >
	</cfcase>     
   <cfcase value="obj_get_main_spec_3">
		<cfset form.str_sql= "SELECT TOP 1 SPECT_MAIN.SPECT_MAIN_ID FROM SPECT_MAIN SPECT_MAIN WHERE SPECT_MAIN.SPECT_STATUS = 1 AND SPECT_MAIN.STOCK_ID=#attributes.ext_params# AND SPECT_MAIN.IS_TREE =1" >
	</cfcase>      
    <cfcase value="obj_get_karma_koli">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset form.str_sql= "SELECT PRODUCT.IS_PRODUCTION,STOCKS.STOCK_ID KARMA_STOCK_ID,KP.STOCK_ID,KP.PRODUCT_NAME,KP.SPEC_MAIN_ID,KP.PRODUCT_AMOUNT FROM KARMA_PRODUCTS AS KP, PRODUCT, #param_1#.STOCKS STOCKS WHERE KP.PRODUCT_ID = PRODUCT.PRODUCT_ID AND KP.KARMA_PRODUCT_ID=STOCKS.PRODUCT_ID AND STOCKS.STOCK_ID IN (#param_2#) AND PRODUCT.IS_INVENTORY=1 AND PRODUCT.IS_ZERO_STOCK=0 AND STOCKS.IS_KARMA=1" >
	</cfcase>          		 

    <cfcase value="obj_get_total_stock">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.PROCESS_DATE <= #param_3# AND STOCKS_ROW_ID NOT IN (SELECT STOCKS_ROW_ID FROM STOCKS_ROW WHERE STOCK_ID = SR.STOCK_ID AND UPD_ID = SR.UPD_ID AND SR.PROCESS_TYPE = SR.PROCESS_TYPE AND PROCESS_DATE = SR.PROCESS_DATE AND UPD_ID = #param_4# ) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME" >
	</cfcase>           
    <cfcase value="obj_get_total_stock_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.PROCESS_DATE <= #param_3# GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME" >
	</cfcase>          
    <cfcase value="obj_get_total_stock_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK, S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID IN (#param_1#) GROUP BY SR.STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID IN (#param_1#) AND ORDER_ID NOT IN (#param_4#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_PRODUCTION_RESERVED WHERE STOCK_ID IN (#param_1#) GROUP BY STOCK_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID IN (#param_1#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND (S.IS_ZERO_STOCK=0 AND S.IS_LIMITED_STOCK=1) GROUP BY S.STOCK_ID, S.STOCK_CODE, S.PRODUCT_NAME ORDER BY S.STOCK_ID" >
	</cfcase>        
    <cfcase value="obj_get_total_stock_4">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK, S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID IN (#param_1#) GROUP BY SR.STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID IN (#param_1#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_PRODUCTION_RESERVED WHERE STOCK_ID IN (#param_1#) GROUP BY STOCK_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID  IN (#param_1#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND (S.IS_ZERO_STOCK=0 AND S.IS_LIMITED_STOCK=1) AND S.STOCK_ID  IN (#param_1#) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME ORDER BY S.STOCK_ID" >
	</cfcase>               
   <cfcase value="obj_get_total_stock_5">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
        <cfset param_7 = listgetat(attributes.ext_params,7,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.PROCESS_DATE <= #param_3# AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# AND STOCKS_ROW_ID NOT IN (SELECT STOCKS_ROW_ID FROM STOCKS_ROW WHERE STOCK_ID = SR.STOCK_ID AND UPD_ID = SR.UPD_ID AND SR.PROCESS_TYPE = SR.PROCESS_TYPE AND PROCESS_DATE = SR.PROCESS_DATE AND UPD_ID = #param_6#) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME" >
	</cfcase>
   <cfcase value="obj_get_total_stock_6">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.PROCESS_DATE <= #param_3# AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME" >
	</cfcase>           
   <cfcase value="obj_get_total_stock_7">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
        <cfset param_7 = listgetat(attributes.ext_params,7,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK, S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME FROM (SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_STOCK_RESERVED_ROW_LOCATION WHERE STOCK_ID IN (#param_2#) AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_PRODUCTION_RESERVED_LOCATION WHERE STOCK_ID IN (#param_2#)AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# GROUP BY STOCK_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND ISNULL(NO_SALE,0)=0 AND SR.STORE=#param_3# AND SR.STORE_LOCATION=#param_4# AND SR.PROCESS_DATE <= #param_5# GROUP BY STOCK_ID ) T1, #param_1#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND (S.IS_ZERO_STOCK=0 AND S.IS_LIMITED_STOCK=1) GROUP BY S.STOCK_ID, S.STOCK_CODE, S.PRODUCT_NAME ORDER BY S.STOCK_ID" >
	</cfcase>           
   <cfcase value="obj_get_total_stock_8">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK, S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME FROM (SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_STOCK_RESERVED_ROW_LOCATION WHERE STOCK_ID IN (#param_2#) AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# AND ORDER_ID NOT IN (#param_6#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_PRODUCTION_RESERVED_LOCATION WHERE STOCK_ID IN (#param_2#)AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# GROUP BY STOCK_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND ISNULL(NO_SALE,0)=0 AND SR.STORE=#param_3# AND SR.STORE_LOCATION=#param_4# AND SR.PROCESS_DATE <= #param_5# GROUP BY STOCK_ID ) T1, #param_1#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND (S.IS_ZERO_STOCK=0 AND S.IS_LIMITED_STOCK=1) GROUP BY S.STOCK_ID, S.STOCK_CODE, S.PRODUCT_NAME ORDER BY S.STOCK_ID" >
	</cfcase>               
 	<cfcase value="obj_get_stock_4">
		<cfset form.str_sql="SELECT PRODUCT_NAME,STOCK_CODE FROM STOCKS WHERE IS_ZERO_STOCK=0 AND IS_INVENTORY=1 AND STOCK_ID IN ( #attributes.ext_params#)">    
        </cfcase>   
 	<cfcase value="obj_get_stock_5">
		<cfset form.str_sql="SELECT PRODUCT_NAME,STOCK_CODE FROM STOCKS WHERE IS_ZERO_STOCK=0 AND IS_INVENTORY=1 AND STOCK_ID IN ( #attributes.ext_params#) AND IS_LIMITED_STOCK=1">         
    </cfcase>			  
   <cfcase value="obj_get_total_stock_9">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>  
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID,STOCKS.STOCK_ID,STOCKS.STOCK_CODE FROM #param_1#.STOCKS AS STOCKS, STOCKS_ROW AS SR, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND STOCKS.STOCK_ID = SR.STOCK_ID AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.PROCESS_DATE <= #param_4# AND STOCKS_ROW_ID NOT IN (SELECT STOCKS_ROW_ID FROM STOCKS_ROW WHERE STOCK_ID = SR.STOCK_ID AND UPD_ID = SR.UPD_ID AND SR.PROCESS_TYPE = SR.PROCESS_TYPE AND PROCESS_DATE = SR.PROCESS_DATE AND UPD_ID = #param_3# ) GROUP BY STOCKS.STOCK_ID,STOCKS.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID" >
	</cfcase>       
   <cfcase value="obj_get_total_stock_10">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID,STOCKS.STOCK_ID,STOCKS.STOCK_CODE FROM  #param_1#.STOCKS AS STOCKS, STOCKS_ROW AS SR, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND STOCKS.STOCK_ID = SR.STOCK_ID AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND SR.PROCESS_DATE <= #param_3# GROUP BY STOCKS.STOCK_ID,STOCKS.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID" >
	</cfcase>           
   <cfcase value="obj_get_total_stock_11">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>  
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME,SPECT_MAIN_ID FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID,SR.SPECT_VAR_ID SPECT_MAIN_ID FROM GET_STOCK_SPECT SR WHERE SR.SPECT_VAR_ID IN (#param_1#) GROUP BY SR.STOCK_ID,SR.SPECT_VAR_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_2#.GET_STOCK_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_1#) AND ORDER_ID NOT IN (#param_3#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_2#.GET_PRODUCTION_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_1#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK,SR.STOCK_ID,SPECT_VAR_ID SPECT_MAIN_ID FROM STOCKS_ROW SR,#dsn_alias#.STOCKS_LOCATION SL WHERE SR.SPECT_VAR_ID IN (#param_1#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 AND SR.PROCESS_DATE <= #param_4# GROUP BY STOCK_ID,SPECT_VAR_ID) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 AND S.IS_LIMITED_STOCK=1 AND SPECT_MAIN_ID IN(#param_1#) AND SPECT_MAIN_ID<>0 GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME,SPECT_MAIN_ID" >
	</cfcase>           
   <cfcase value="obj_get_total_stock_12">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME,SPECT_MAIN_ID FROM (SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID,SR.SPECT_VAR_ID AS SPECT_MAIN_ID FROM GET_STOCK_SPECT SR WHERE SR.SPECT_VAR_ID IN (#param_1#) GROUP BY SR.STOCK_ID,SR.SPECT_VAR_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_2#.GET_STOCK_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_1#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_2#.GET_PRODUCTION_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_1#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK,SR.STOCK_ID,SPECT_VAR_ID FROM STOCKS_ROW SR,#dsn_alias#.STOCKS_LOCATION SL WHERE SR.SPECT_VAR_ID IN (#param_1#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 AND SR.PROCESS_DATE <= #param_3# GROUP BY STOCK_ID,SPECT_VAR_ID) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 AND S.IS_LIMITED_STOCK=1 AND SPECT_MAIN_ID IN(#param_1#) AND SPECT_MAIN_ID<>0  GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME,SPECT_MAIN_ID" >
	</cfcase>       
   <cfcase value="obj_get_total_stock_13">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")> 
        <cfset param_7 = listgetat(attributes.ext_params,7,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,ST.STOCK_CODE,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR,#param_1#.STOCKS ST, #param_1#.SPECT_MAIN AS S WHERE SR.PRODUCT_ID = ST.PRODUCT_ID AND SR.STOCK_ID = ST.STOCK_ID AND ST.STOCK_ID=S.STOCK_ID AND SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND ST.IS_ZERO_STOCK = 0  AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# AND SR.PROCESS_DATE <= #param_6# AND STOCKS_ROW_ID NOT IN (SELECT STOCKS_ROW_ID FROM STOCKS_ROW WHERE STOCK_ID = SR.STOCK_ID AND UPD_ID = SR.UPD_ID AND SR.PROCESS_TYPE = SR.PROCESS_TYPE AND PROCESS_DATE = SR.PROCESS_DATE AND UPD_ID = #param_3# ) GROUP BY ST.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID" >
	</cfcase>     
   <cfcase value="obj_get_total_stock_14">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")> 
        <cfset param_7 = listgetat(attributes.ext_params,7,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,ST.STOCK_CODE,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR,#param_1#.STOCKS ST, #param_1#.SPECT_MAIN AS S WHERE ST.STOCK_ID=S.STOCK_ID AND SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND ST.IS_ZERO_STOCK = 0 AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# AND SR.PROCESS_DATE <= #param_6# AND STOCKS_ROW_ID NOT IN (SELECT STOCKS_ROW_ID FROM STOCKS_ROW WHERE STOCK_ID = SR.STOCK_ID AND UPD_ID = SR.UPD_ID AND SR.PROCESS_TYPE = SR.PROCESS_TYPE AND PROCESS_DATE = SR.PROCESS_DATE AND UPD_ID = #param_3# ) GROUP BY ST.STOCK_CODE,S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID" >
	</cfcase>       
  <cfcase value="obj_get_total_stock_15">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")> 
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME,SPECT_MAIN_ID FROM (SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_1#.GET_STOCK_RESERVED_SPECT_LOCATION WHERE SPECT_MAIN_ID IN (#param_2#) AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_1#.GET_PRODUCTION_RESERVED_SPECT_LOCATION WHERE SPECT_MAIN_ID IN (#param_2#) AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,SR.STOCK_ID,SPECT_VAR_ID SPECT_MAIN_ID FROM STOCKS_ROW SR,#dsn_alias#.STOCKS_LOCATION SL WHERE SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND ISNULL(NO_SALE,0)=0 AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# AND SR.PROCESS_DATE <= #param_5# GROUP BY STOCK_ID,SPECT_VAR_ID) T1, #param_1#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 AND S.IS_LIMITED_STOCK=1 GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME,SPECT_MAIN_ID" >
	</cfcase>       
  <cfcase value="obj_get_total_stock_16">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")> 
        <cfset param_6 = listgetat(attributes.ext_params,6,"*")> 
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME,SPECT_MAIN_ID FROM (SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_1#.GET_STOCK_RESERVED_SPECT_LOCATION WHERE SPECT_MAIN_ID IN (#param_2#) AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# AND ORDER_ID NOT IN (#param_6#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_1#.GET_PRODUCTION_RESERVED_SPECT_LOCATION WHERE SPECT_MAIN_ID IN (#param_2#) AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,SR.STOCK_ID,SPECT_VAR_ID SPECT_MAIN_ID FROM STOCKS_ROW SR,#dsn_alias#.STOCKS_LOCATION SL WHERE SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND ISNULL(NO_SALE,0)=0 AND DEPARTMENT_ID=#param_3# AND LOCATION_ID=#param_4# AND SR.PROCESS_DATE <= #param_5# GROUP BY STOCK_ID,SPECT_VAR_ID) T1, #param_1#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 AND S.IS_LIMITED_STOCK=1 GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME,SPECT_MAIN_ID" >
	</cfcase>           
<cfcase value="obj_get_stock_6">
		<cfset form.str_sql="SELECT P.SPECT_MAIN_NAME AS PRODUCT_NAME,P.SPECT_MAIN_ID,S.STOCK_CODE FROM SPECT_MAIN P,STOCKS S WHERE S.STOCK_ID=P.STOCK_ID AND P.SPECT_MAIN_ID IN (#attributes.ext_params#) AND S.IS_ZERO_STOCK=0 ">   
	</cfcase>       
<cfcase value="obj_get_stock_7">
		<cfset form.str_sql="SELECT P.SPECT_MAIN_NAME AS PRODUCT_NAME,P.SPECT_MAIN_ID,S.STOCK_CODE FROM SPECT_MAIN P,STOCKS S WHERE S.STOCK_ID=P.STOCK_ID AND P.SPECT_MAIN_ID IN (#attributes.ext_params#) AND S.IS_ZERO_STOCK=0 AND P.IS_LIMITED_STOCK=1 ">   
	</cfcase>    
   <cfcase value="obj_get_comp_proms_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT COMPANY_ID, LIMIT_VALUE, LIMIT_CURRENCY, DISCOUNT, PROM_ID, FREE_STOCK_ID, FREE_STOCK_AMOUNT, FREE_STOCK_PRICE, AMOUNT_1_MONEY, TOTAL_PROMOTION_COST FROM PROMOTIONS WHERE PROM_STATUS = 1 AND PROM_TYPE = 0 AND LIMIT_VALUE IS NOT NULL AND #param_1# BETWEEN STARTDATE AND FINISHDATE ORDER BY STARTDATE DESC" >
	</cfcase>          
    <cfcase value="obj_get_comp_proms_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT COMPANY_ID, LIMIT_VALUE, LIMIT_CURRENCY, DISCOUNT, PROM_ID, FREE_STOCK_ID, FREE_STOCK_AMOUNT, FREE_STOCK_PRICE, AMOUNT_1_MONEY, TOTAL_PROMOTION_COST FROM PROMOTIONS WHERE PROM_STATUS = 1 AND PROM_TYPE = 0 AND LIMIT_VALUE <= #param_2# AND LIMIT_VALUE IS NOT NULL AND #param_1# BETWEEN STARTDATE AND FINISHDATE ORDER BY STARTDATE DESC" >
	</cfcase>   
	 <cfcase value="obj_get_card_comms">
		<cfset form.str_sql="SELECT S.PRODUCT_ID,S.PRODUCT_DETAIL2, S.PRODUCT_NAME, S.STOCK_CODE, S.STOCK_CODE_2, S.STOCK_ID, S.BARCOD, S.TAX, S.MANUFACT_CODE, S.IS_INVENTORY, S.IS_PRODUCTION, S.PRODUCT_UNIT_ID, S.PROPERTY, S.IS_SERIAL_NO, PU.ADD_UNIT FROM STOCKS S,PRODUCT_UNIT PU,CREDITCARD_PAYMENT_TYPE CCPT WHERE S.STOCK_ID=CCPT.PUBLIC_COMMISSION_STOCK_ID AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND CCPT.IS_ACTIVE = 1 AND CCPT.PAYMENT_TYPE_ID= #attributes.ext_params#">   
	</cfcase>         
	 <cfcase value="obj_get_card_comms_2">
		<cfset form.str_sql="SELECT S.PRODUCT_ID, S.PRODUCT_DETAIL2,S.PRODUCT_NAME, S.STOCK_CODE, S.STOCK_CODE_2, S.STOCK_ID, S.BARCOD, S.TAX, S.MANUFACT_CODE, S.IS_INVENTORY, S.IS_PRODUCTION, S.PRODUCT_UNIT_ID, S.PROPERTY, S.IS_SERIAL_NO, PU.ADD_UNIT FROM STOCKS S,PRODUCT_UNIT PU,CREDITCARD_PAYMENT_TYPE CCPT WHERE S.STOCK_ID=CCPT.COMMISSION_STOCK_ID AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND CCPT.IS_ACTIVE = 1 AND CCPT.PAYMENT_TYPE_ID= #attributes.ext_params#">   
	</cfcase>       
	 <cfcase value="obj_get_stock_proms_2">
		<cfset form.str_sql="SELECT S.PRODUCT_ID, S.PRODUCT_DETAIL2,S.PRODUCT_NAME, S.STOCK_CODE, S.STOCK_ID, S.BARCOD, S.TAX, S.MANUFACT_CODE, S.IS_INVENTORY, S.IS_PRODUCTION, S.IS_COST ,S.PRODUCT_UNIT_ID, S.PROPERTY, PU.ADD_UNIT FROM STOCKS S,PRODUCT_UNIT PU WHERE S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND S.STOCK_ID= #attributes.ext_params#">   
	</cfcase>                 
    <cfcase value="obj_get_stock_cost">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT TOP 1 PURCHASE_NET_SYSTEM,PURCHASE_EXTRA_COST_SYSTEM FROM #param_1#.GET_PRODUCT_COST_PERIOD PC, STOCKS S WHERE S.PRODUCT_ID=PC.PRODUCT_ID AND PC.START_DATE<#param_2# AND S.STOCK_ID=#param_3# ORDER BY PC.START_DATE DESC,PC.RECORD_DATE DESC" >
	</cfcase>   
    <cfcase value="obj_get_shelf_name_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SHELF_CODE,PRODUCT_PLACE_ID FROM PRODUCT_PLACE WHERE PLACE_STATUS=1" >
	</cfcase> 
    <cfcase value="obj_get_shelf_name_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SHELF_CODE,PRODUCT_PLACE_ID FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND (PRODUCT_PLACE_ID= #param_1# OR PRODUCT_PLACE_ID #param_2#)" >
	</cfcase>                
    <cfcase value="obj_get_shelf_name_4">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SHELF_CODE,PRODUCT_PLACE_ID FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID= #param_1#" >
	</cfcase>                
    <cfcase value="obj_get_shelf_name_5">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SHELF_CODE,PRODUCT_PLACE_ID FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID= #param_2#" >
	</cfcase>                
 	<cfcase value="obj_control_basket_prod_acc">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id#) AND PRODUCT_ID IN ( #attributes.ext_params# )">        
    </cfcase>
 	<cfcase value="obj_control_basket_prod_acc_2">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND ACCOUNT_IADE IS NOT NULL AND len(ACCOUNT_IADE)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">        
    </cfcase>        
 	<cfcase value="obj_control_basket_prod_acc_3">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND ACCOUNT_PRICE IS NOT NULL AND len(ACCOUNT_PRICE)<>0)	AND PRODUCT_ID IN (#attributes.ext_params#)">        
    </cfcase>        
 	<cfcase value="obj_control_basket_prod_acc_4">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND ACCOUNT_PRICE_PUR IS NOT NULL AND len(ACCOUNT_PRICE_PUR)<>0)	AND PRODUCT_ID IN (#attributes.ext_params#)">        
    </cfcase>        
 	<cfcase value="obj_control_basket_prod_acc_5">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND ACCOUNT_PUR_IADE IS NOT NULL AND len(ACCOUNT_PUR_IADE)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">        
    </cfcase>        
 	<cfcase value="obj_control_basket_prod_acc_6">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND ACCOUNT_YURTDISI IS NOT NULL AND len(ACCOUNT_YURTDISI)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">        
    </cfcase>        
 	<cfcase value="obj_control_basket_prod_acc_7">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND ACCOUNT_YURTDISI_PUR IS NOT NULL AND len(ACCOUNT_YURTDISI_PUR)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">        
    </cfcase>                
 	<cfcase value="obj_control_basket_prod_acc_8">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND ACCOUNT_CODE IS NOT NULL AND len(ACCOUNT_CODE)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">        					
    </cfcase>                
 	<cfcase value="obj_control_basket_prod_acc_9">
		<cfset form.str_sql= "SELECT PRODUCT_NAME,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN ( #attributes.ext_params# ) AND PERIOD_ID= #session.ep.period_id# AND ACCOUNT_CODE_PUR IS NOT NULL AND len(ACCOUNT_CODE_PUR)<>0) AND PRODUCT_ID IN (#attributes.ext_params#)">        					
    </cfcase>
                           
    <cfcase value="obj_get_new_pricecat_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
		<cfset form.str_sql= "SELECT TOP 1 P.PRICE,PC.PRICE_CATID,PC.NUMBER_OF_INSTALLMENT FROM PRICE_CAT PC,PRICE P WHERE PC.PRICE_CAT_STATUS=1 AND PC.PRICE_CATID=P.PRICE_CATID AND PC.NUMBER_OF_INSTALLMENT =#param_1# AND P.PRODUCT_ID =#param_2# AND (P.STARTDATE < =#param_3# AND (P.FINISHDATE IS NULL OR P.FINISHDATE >=#param_3# )) ORDER BY P.STARTDATE DESC,P.RECORD_DATE DESC" >
	</cfcase>        
 	<cfcase value="obj_get_main_spec_4">
		<cfset form.str_sql= "SELECT TOP 1 SPECT_MAIN.SPECT_MAIN_ID FROM SPECT_MAIN_ROW SPECT_MAIN_ROW,SPECT_MAIN SPECT_MAIN,PRODUCT_TREE WHERE SPECT_MAIN.STOCK_ID=#attributes.ext_params# AND PRODUCT_TREE.STOCK_ID=#attributes.ext_params# AND SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND PRODUCT_TREE.RELATED_ID = SPECT_MAIN_ROW.STOCK_ID AND SPECT_MAIN_ROW.AMOUNT = PRODUCT_TREE.AMOUNT AND	SPECT_MAIN_ROW.IS_SEVK = PRODUCT_TREE.IS_SEVK AND SPECT_MAIN_ROW.IS_CONFIGURE=PRODUCT_TREE.IS_CONFIGURE AND	(SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=#attributes.ext_params#)=(SELECT COUNT(SMR.SPECT_MAIN_ID) FROM SPECT_MAIN_ROW SMR WHERE SMR.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID) GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME HAVING COUNT(SPECT_MAIN.SPECT_MAIN_ID) = (SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=#attributes.ext_params#) ">
	</cfcase>   			
	<cfcase value="obj_get_main_spec_5">
		<cfset form.str_sql= "SELECT TOP 1 SPECT_MAIN.SPECT_MAIN_ID FROM SPECT_MAIN_ROW SPECT_MAIN_ROW,SPECT_MAIN SPECT_MAIN,PRODUCT_TREE	WHERE SPECT_MAIN.STOCK_ID=#attributes.ext_params# AND PRODUCT_TREE.STOCK_ID=#attributes.ext_params# AND	SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND PRODUCT_TREE.RELATED_ID = SPECT_MAIN_ROW.STOCK_ID AND SPECT_MAIN_ROW.AMOUNT = PRODUCT_TREE.AMOUNT AND	SPECT_MAIN_ROW.IS_SEVK = PRODUCT_TREE.IS_SEVK AND SPECT_MAIN_ROW.IS_CONFIGURE=PRODUCT_TREE.IS_CONFIGURE AND(SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=#attributes.ext_params#)=(SELECT COUNT(SMR.SPECT_MAIN_ID) FROM SPECT_MAIN_ROW SMR WHERE SMR.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID)	GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME HAVING COUNT(SPECT_MAIN.SPECT_MAIN_ID) = (SELECT COUNT(SMR.STOCK_ID) FROM PRODUCT_TREE SMR WHERE SMR.STOCK_ID=#attributes.ext_params#)">
	</cfcase>   	    
    <cfcase value="obj_get_karma_koli_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset form.str_sql= "SELECT STOCKS.STOCK_ID KARMA_STOCK_ID,KP.STOCK_ID,KP.PRODUCT_NAME,KP.PRODUCT_AMOUNT FROM KARMA_PRODUCTS AS KP, PRODUCT, #param_1#.STOCKS STOCKS WHERE KP.PRODUCT_ID = PRODUCT.PRODUCT_ID AND KP.KARMA_PRODUCT_ID=STOCKS.PRODUCT_ID AND STOCKS.STOCK_ID IN (#param_2#) AND PRODUCT.IS_INVENTORY=1 AND PRODUCT.IS_ZERO_STOCK=0 AND STOCKS.IS_KARMA=1" >
	</cfcase>       
    <cfcase value="obj_get_total_stock_17">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND UPD_ID NOT IN (#param_3#) GROUP BY S.STOCK_ID,S.PRODUCT_NAME" >
    </cfcase>
    <cfcase value="obj_get_total_stock_18">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.PRODUCT_NAME" >	
	</cfcase>           
    <cfcase value="obj_get_total_stock_19">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,	S.STOCK_ID,	S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE	SR.STOCK_ID IN (#param_2#) GROUP BY SR.STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID IN (#param_2#) AND ORDER_ID NOT IN (#param_3#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_PRODUCTION_RESERVED WHERE STOCK_ID IN (#param_2#) GROUP BY STOCK_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_1#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID, S.PRODUCT_NAME ORDER BY S.STOCK_ID" >	
	</cfcase>                   
    <cfcase value="obj_get_total_stock_20">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,	S.STOCK_ID,	S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE	SR.STOCK_ID IN (#param_2#) GROUP BY SR.STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID IN (#param_2#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_PRODUCTION_RESERVED WHERE STOCK_ID IN (#param_2#) GROUP BY STOCK_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID  IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_1#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID, S.PRODUCT_NAME ORDER BY S.STOCK_ID" >	
	</cfcase>                  
    <cfcase value="obj_get_total_stock_21">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# AND UPD_ID NOT IN (#param_3#) GROUP BY S.STOCK_ID,S.PRODUCT_NAME" >	
	</cfcase>                     
    <cfcase value="obj_get_total_stock_22">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR,#param_1#.PRODUCT P WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# GROUP BY S.STOCK_ID,S.PRODUCT_NAME" >	
	</cfcase>                       
 	<cfcase value="obj_get_card_comms_3">
		<cfset form.str_sql="SELECT S.PRODUCT_ID, S.PRODUCT_DETAIL2,S.PRODUCT_NAME, S.STOCK_CODE, S.STOCK_ID, S.BARCOD, S.TAX, S.MANUFACT_CODE, S.IS_INVENTORY, S.IS_PRODUCTION, S.PRODUCT_UNIT_ID, S.PROPERTY, S.IS_SERIAL_NO, PU.ADD_UNIT FROM STOCKS S,PRODUCT_UNIT PU,CREDITCARD_PAYMENT_TYPE CCPT WHERE S.STOCK_ID=CCPT.PUBLIC_COMMISSION_STOCK_ID AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND CCPT.IS_ACTIVE = 1 AND CCPT.PAYMENT_TYPE_ID= #attributes.ext_params# ">
    </cfcase>                   
 	<cfcase value="obj_get_card_comms_4">
		<cfset form.str_sql="SELECT S.PRODUCT_ID, S.PRODUCT_DETAIL2,S.PRODUCT_NAME, S.STOCK_CODE, S.STOCK_ID, S.BARCOD, S.TAX, S.MANUFACT_CODE, S.IS_INVENTORY, S.IS_PRODUCTION, S.PRODUCT_UNIT_ID, S.PROPERTY, S.IS_SERIAL_NO, PU.ADD_UNIT FROM STOCKS S,PRODUCT_UNIT PU,CREDITCARD_PAYMENT_TYPE CCPT WHERE S.STOCK_ID=CCPT.COMMISSION_STOCK_ID AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND CCPT.IS_ACTIVE = 1 AND CCPT.PAYMENT_TYPE_ID= #attributes.ext_params# ">
    </cfcase>                 
    <cfcase value="obj_get_total_stock_23">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_1#) AND UPD_ID NOT IN (#param_3#) GROUP BY S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID" >	
	</cfcase>                      
    <cfcase value="obj_get_total_stock_24">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID	FROM STOCKS_ROW AS SR, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) GROUP BY S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID" >	
	</cfcase>                     
    <cfcase value="obj_get_total_stock_25">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME,SPECT_MAIN_ID FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID,SR.SPECT_VAR_ID SPECT_MAIN_ID FROM GET_STOCK_SPECT SR WHERE	SR.SPECT_VAR_ID IN (#param_2#) GROUP BY SR.STOCK_ID,SR.SPECT_VAR_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_1#.GET_STOCK_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_2#) AND ORDER_ID NOT IN (#param_3#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_1#.GET_PRODUCTION_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_2#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK,SR.STOCK_ID,SPECT_VAR_ID SPECT_MAIN_ID FROM STOCKS_ROW SR,#dsn_alias#.STOCKS_LOCATION SL WHERE SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID,SPECT_VAR_ID) T1, workcube_cf_1.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.PRODUCT_NAME,SPECT_MAIN_ID" >	
	</cfcase>                         
    <cfcase value="obj_get_total_stock_26">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.PRODUCT_NAME,SPECT_MAIN_ID FROM (SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID,SR.SPECT_VAR_ID AS SPECT_MAIN_ID FROM GET_STOCK_SPECT SR WHERE	SR.SPECT_VAR_ID IN (#param_2#) GROUP BY SR.STOCK_ID,SR.SPECT_VAR_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_1#.GET_STOCK_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_2#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,STOCK_ID,SPECT_MAIN_ID FROM #param_1#.GET_PRODUCTION_RESERVED_SPECT WHERE SPECT_MAIN_ID IN (#param_2#) GROUP BY STOCK_ID,SPECT_MAIN_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK,SR.STOCK_ID,SPECT_VAR_ID FROM STOCKS_ROW SR,#dsn_alias#.STOCKS_LOCATION SL WHERE SR.SPECT_VAR_ID IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID,SPECT_VAR_ID) T1, workcube_cf_1.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.PRODUCT_NAME,SPECT_MAIN_ID" >	
	</cfcase>                      
    <cfcase value="obj_get_total_stock_27">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND UPD_ID NOT IN (#param_3#)  AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# GROUP BY S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID" >	
	</cfcase>                  
    <cfcase value="obj_get_total_stock_28">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")> 
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>  
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, S.SPECT_MAIN_NAME AS PRODUCT_NAME,S.SPECT_MAIN_ID FROM STOCKS_ROW AS SR, #param_1#.SPECT_MAIN AS S WHERE SR.PROCESS_TYPE IS NOT NULL AND S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND SR.SPECT_VAR_ID IN (#param_2#) AND UPD_ID NOT IN (#param_3#)  AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# GROUP BY S.SPECT_MAIN_NAME,S.SPECT_MAIN_ID" >	
	</cfcase>           
    <!--- Kontrol edilmeli, tırnaklarda sorun var(objects/dsp_basket_js_scripts_2.cfm - altında 489/490 satırında bulunmaktadır. objects/dsp_basket_js_scripts_eski_SILMEYIN.cfm dede 413/414 de aynısı bulunmaktadır.)     
 	<cfcase value="obj_get_prod_cat_property">
		<cfset form.str_sql= "SELECT PP.PROPERTY_ID, REPLACE(PP.PROPERTY,'"',' ') PROPERTY FROM PRODUCT_PROPERTY PP WHERE PP.PROPERTY_ID IN (SELECT PRODUCT_CAT_PROPERTY.PROPERTY_ID FROM PRODUCT_CAT_PROPERTY,PRODUCT WHERE PRODUCT_ID=#attributes.ext_params# AND PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID ) ORDER BY PP.PROPERTY">   
	</cfcase>     
    --->
    <cfcase value="obj_get_member_pricecat_4">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PRICE_CATID FROM PRICE_CAT PC, #param_1#.COMPANY C WHERE PC.COMPANY_CAT LIKE '%, #param_2# ,%' AND C.COMPANY_ID =#param_3#" >	
	</cfcase>                       
    <cfcase value="obj_get_member_pricecat_5">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT PRICE_CATID FROM PRICE_CAT PC, #param_1#.CONSUMER C WHERE PC.CONSUMER_CAT LIKE '%,#param_2#,%' AND C.CONSUMER_ID =#param_3#" >	
	</cfcase> 
    <cfcase value="obj_get_credit_all_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfset form.str_sql= "SELECT COMPANY_CREDIT.MONEY,RATE2,RATE1,PAYMENT_RATE_TYPE,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM COMPANY_CREDIT,#param_1#.SETUP_MONEY AS SETUP_MONEY WHERE COMPANY_CREDIT.MONEY = SETUP_MONEY.MONEY AND COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_CREDIT.CONSUMER_ID = #param_2#" >	
	</cfcase>    
    <cfcase value="obj_get_total_stock_29">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND UPD_ID NOT IN (#param_3#) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME" >	
	</cfcase>      
    <cfcase value="obj_get_total_stock_30">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME" >	
	</cfcase>            
    <cfcase value="obj_get_total_stock_31">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK, S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID IN (#param_2#) GROUP BY SR.STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID IN (#param_2#) AND ORDER_ID NOT IN (#param_3#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_PRODUCTION_RESERVED WHERE STOCK_ID IN (#param_2#) GROUP BY STOCK_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_1#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID, S.STOCK_CODE, S.PRODUCT_NAME ORDER BY S.STOCK_IDE" >	
	</cfcase>       
    <cfcase value="obj_get_total_stock_32">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK, S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID IN (#param_2#) GROUP BY SR.STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID IN (#param_2#) GROUP BY STOCK_ID UNION ALL SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_1#.GET_PRODUCTION_RESERVED WHERE STOCK_ID IN (#param_2#) GROUP BY STOCK_ID UNION ALL SELECT (SUM(STOCK_IN - SR.STOCK_OUT)*-1) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID  IN (#param_2#) AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_1#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME ORDER BY S.STOCK_ID" >	
	</cfcase>       
    <cfcase value="obj_get_total_stock_33">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_4# AND SR.STORE = #param_5# AND UPD_ID NOT IN (#param_3#) GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME" >	
	</cfcase>           
    <cfcase value="obj_get_total_stock_34">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME AS PRODUCT_NAME FROM #param_1#.STOCKS S, STOCKS_ROW SR WHERE SR.STOCK_ID=S.STOCK_ID AND SR.STOCK_ID IN (#param_2#) AND S.IS_ZERO_STOCK=0 AND SR.STORE_LOCATION=#param_4# AND SR.STORE =#param_5# GROUP BY S.STOCK_ID,S.STOCK_CODE,S.PRODUCT_NAME" >	
	</cfcase>           
    <cfcase value="obj_PRODUCT_COST_INFO">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 PURCHASE_NET_SYSTEM,PURCHASE_EXTRA_COST_SYSTEM FROM PRODUCT_COST WHERE START_DATE <=  #param_1# AND PRODUCT_ID = '#param_2#' ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC" >	
	</cfcase>             
 	<cfcase value="obj_get_serial">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE (SERIAL_NO='#param_1#' OR REFERENCE_NO='#param_1#' OR LOT_NO='#param_1#') #param_2#">
	</cfcase>             
 	<cfcase value="obj_get_serial_2">
    	<cfset param_1 = listgetat(attributes.ext_params,2,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,1,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE RMA_NO = '#param_1#' AND (SERIAL_NO='#param_2#' OR REFERENCE_NO='#param_2#' OR LOT_NO='#param_2#') #param_3#">
	</cfcase>       
	<cfcase value="obj_get_serial_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>  
		<cfset form.str_sql= "SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE (SERIAL_NO='#param_1#' OR REFERENCE_NO='#param_1#' OR LOT_NO='#param_1#') AND (PURCHASE_COMPANY_ID = #param_2# OR SALE_COMPANY_ID = #param_2#) #param_3# #param_4#">   
	</cfcase>       
	<cfcase value="obj_get_serial_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
		<cfset form.str_sql= "SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE (SERIAL_NO='#param_1#' OR REFERENCE_NO='#param_1#' OR LOT_NO='#param_1#') #param_2# #param_3#">   
	</cfcase>         
	<cfcase value="obj_get_serial_5">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>  
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>  
		<cfset form.str_sql= "SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE (PURCHASE_COMPANY_ID = #param_1# OR SALE_COMPANY_ID = #param_2#) #param_3# #param_4#">   
	</cfcase>           
	<cfcase value="obj_get_seri_sale_control">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset param_2 = listLast(attributes.ext_params,"*")>
        <cfset param_3 = listgetat(SESSION.EP.USER_LOCATION,2,'-')> 
		<cfset form.str_sql= "SELECT TOP 1 SG.GUARANTY_ID,SG.STOCK_ID,SG.DEPARTMENT_ID,SG.LOCATION_ID,SG.UNIT_ROW_QUANTITY,SG.LOT_NO FROM SERVICE_GUARANTY_NEW SG WHERE SG.IN_OUT=1 AND SG.SERIAL_NO = '#param_2#'">
	</cfcase>       
    
	<cfcase value="obj_get_seri_sale_control_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(SESSION.EP.USER_LOCATION,2,'-')> 
		<cfset form.str_sql= "SELECT TOP 1 SG.GUARANTY_ID,SG.STOCK_ID,SG.DEPARTMENT_ID,SG.LOCATION_ID,SG.UNIT_ROW_QUANTITY,SG.LOT_NO FROM SERVICE_GUARANTY_NEW SG  ,#param_1#.DEPARTMENT D WHERE SG.IN_OUT=1 AND SG.DEPARTMENT_ID=D.DEPARTMENT_ID AND D.BRANCH_ID = #param_3# AND SG.SERIAL_NO = '#param_2#'">
	</cfcase>   
           
 	<cfcase value="obj_get_price_cat_3">
		<cfset form.str_sql= "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1">   
	</cfcase> 
    
    <cfcase value="obj_get_price_cat_4">
    <cfset param_1 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND BRANCH LIKE '%,#param_1#,%'">   
	</cfcase>     
    
	<cfcase value="obj_get_product_detail">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PRODUCT_DETAIL2,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER, S.TAX,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,GET_STOCK_BARCODES GSB,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1 AND S.STOCK_ID=GSB.STOCK_ID AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=GSB.UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND GSB.BARCODE = '#param_1#'">   
	</cfcase>       
     
	<cfcase value="obj_get_product_detail_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PRODUCT_DETAIL2,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER, S.TAX_PURCHASE AS TAX,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,GET_STOCK_BARCODES GSB,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1 AND S.STOCK_ID=GSB.STOCK_ID AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=GSB.UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND GSB.BARCODE = '#param_1#'">   
	</cfcase>          
    
	<cfcase value="obj_get_product_detail_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PRODUCT_DETAIL2,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER, S.TAX,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,GET_STOCK_BARCODES GSB,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1AND S.STOCK_ID=GSB.STOCK_ID AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=GSB.UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_2#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID= #param_3# AND GSB.BARCODE = '#param_1#')">   
	</cfcase>            
    
	<cfcase value="obj_get_product_detail_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PRODUCT_DETAIL2,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER, S.TAX_PURCHASE AS TAX,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,GET_STOCK_BARCODES GSB,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1 AND S.STOCK_ID=GSB.STOCK_ID AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=GSB.UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_2#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID= #param_3# AND GSB.BARCODE = '#param_1#')">   
	</cfcase>   

	<cfcase value="obj_get_product_detail_5">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.STOCK_ID=#param_1#">   
	</cfcase> 
                        
	<cfcase value="obj_get_product_detail_6">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,S.TAX_PURCHASE AS TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.STOCK_ID=#param_1#">   
	</cfcase>     
    
	<cfcase value="obj_get_product_detail_7">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,S.TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.STOCK_ID=#param_1# AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_2#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID =  #param_3#)">
	</cfcase>      
    
	<cfcase value="obj_get_product_detail_8">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX_PURCHASE AS TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.STOCK_ID=#param_1# AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_2#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID =  #param_3#)">
	</cfcase>    
    
	<cfcase value="obj_get_product_detail_9">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.STOCK_ID=#param_1#">
	</cfcase>        
    
	<cfcase value="obj_get_product_detail_10">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND (S.STOCK_CODE='#param_2#' OR S.STOCK_CODE LIKE '%.#param_2#')">
	</cfcase>           
    
	<cfcase value="obj_get_product_detail_11">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX_PURCHASE AS TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.STOCK_ID=#param_1#">
	</cfcase>        
    
	<cfcase value="obj_get_product_detail_12">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX_PURCHASE AS TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND (S.STOCK_CODE='#param_2#' OR S.STOCK_CODE LIKE '%.#param_2#')">
	</cfcase>
                
	<cfcase value="obj_get_product_detail_13">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.STOCK_ID=#param_1# AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_3#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID = #param_4#)">
	</cfcase>        
    
	<cfcase value="obj_get_product_detail_14">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_DETAIL2,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND (S.STOCK_CODE='#param_2#' OR S.STOCK_CODE LIKE '%.#param_2#') AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_3#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID = #param_4#)">
	</cfcase>           
    
	<cfcase value="obj_get_product_detail_15">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_DETAIL2,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX_PURCHASE AS TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1 AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.STOCK_ID=#param_1# AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_3#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID = #param_4#)">
	</cfcase>        
    
	<cfcase value="obj_get_product_detail_16">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_DETAIL2,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.BRAND_ID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE, S.TAX_PURCHASE AS TAX,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1	AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=S.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND (S.STOCK_CODE='#param_2#' OR S.STOCK_CODE LIKE '%.#param_2#') AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_3#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID = #param_4#)">
	</cfcase>    
    
	<cfcase value="obj_get_price_exceptions">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT_RATE,DISCOUNT_RATE_2,DISCOUNT_RATE_3,DISCOUNT_RATE_4,DISCOUNT_RATE_5,PRODUCT_ID,PRODUCT_CATID,BRAND_ID,PRICE_CATID FROM PRICE_CAT_EXCEPTIONS WHERE ((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1)) AND COMPANY_ID = #param_1# AND ( PRODUCT_ID = #param_3# OR PRODUCT_CATID=#param_4#) ORDER BY PRODUCT_ID,PRODUCT_CATID,BRAND_ID">
	</cfcase>        
    
	<cfcase value="obj_get_price_exceptions_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT_RATE,DISCOUNT_RATE_2,DISCOUNT_RATE_3,DISCOUNT_RATE_4,DISCOUNT_RATE_5,PRODUCT_ID,PRODUCT_CATID,BRAND_ID,PRICE_CATID FROM PRICE_CAT_EXCEPTIONS WHERE ((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1)) AND CONSUMER_ID = #param_2# AND ( PRODUCT_ID = #param_3# OR PRODUCT_CATID=#param_4#) ORDER BY PRODUCT_ID,PRODUCT_CATID,BRAND_ID">
	</cfcase>           
    
	<cfcase value="obj_get_price_exceptions_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT_RATE,DISCOUNT_RATE_2,DISCOUNT_RATE_3,DISCOUNT_RATE_4,DISCOUNT_RATE_5,PRODUCT_ID,PRODUCT_CATID,BRAND_ID,PRICE_CATID FROM PRICE_CAT_EXCEPTIONS WHERE ((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1)) AND ( PRODUCT_ID = #param_3# OR PRODUCT_CATID=#param_4#) ORDER BY PRODUCT_ID,PRODUCT_CATID,BRAND_ID">
	</cfcase>              
    
	<cfcase value="obj_get_price_exceptions_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT_RATE,DISCOUNT_RATE_2,DISCOUNT_RATE_3,DISCOUNT_RATE_4,DISCOUNT_RATE_5,PRODUCT_ID,PRODUCT_CATID,BRAND_ID,PRICE_CATID FROM PRICE_CAT_EXCEPTIONS WHERE ((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1)) AND COMPANY_ID = #param_1# AND ( PRODUCT_ID = #param_3# OR PRODUCT_CATID=#param_4# OR BRAND_ID=#param_5#) ORDER BY PRODUCT_ID,PRODUCT_CATID,BRAND_ID">
	</cfcase>        
    
	<cfcase value="obj_get_price_exceptions_5">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT_RATE,DISCOUNT_RATE_2,DISCOUNT_RATE_3,DISCOUNT_RATE_4,DISCOUNT_RATE_5,PRODUCT_ID,PRODUCT_CATID,BRAND_ID,PRICE_CATID FROM PRICE_CAT_EXCEPTIONS WHERE ISNULL(IS_GENERAL,0)=0 AND ((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1)) AND CONSUMER_ID = #param_2# AND ( PRODUCT_ID = #param_3# OR PRODUCT_CATID=#param_4# OR BRAND_ID=#param_5#) ORDER BY PRODUCT_ID,PRODUCT_CATID,BRAND_ID">
	</cfcase>           
    
	<cfcase value="obj_get_price_exceptions_6">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
        <cfset param_5 = listgetat(attributes.ext_params,5,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT_RATE,DISCOUNT_RATE_2,DISCOUNT_RATE_3,DISCOUNT_RATE_4,DISCOUNT_RATE_5,PRODUCT_ID,PRODUCT_CATID,BRAND_ID,PRICE_CATID FROM PRICE_CAT_EXCEPTIONS WHERE ((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1)) AND ( PRODUCT_ID = #param_3# OR PRODUCT_CATID=#param_4# OR BRAND_ID=#param_5#) ORDER BY PRODUCT_ID,PRODUCT_CATID,BRAND_ID">
	</cfcase> 
	     
    <cfcase value="obj_get_genaral_discount">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT FROM CONTRACT_SALES_GENERAL_DISCOUNT AS CS_GD,CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES CS_GDB WHERE CS_GD.GENERAL_DISCOUNT_ID = CS_GDB.GENERAL_DISCOUNT_ID AND CS_GDB.BRANCH_ID = #param_1# AND CS_GD.COMPANY_ID = #param_2# AND CS_GD.START_DATE <= #param_3# AND CS_GD.FINISH_DATE >= #param_3# ORDER BY CS_GD.GENERAL_DISCOUNT_ID">
	</cfcase>
	  
	<cfcase value="obj_get_price">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT TOP 1 UNIT,PRICE,PRODUCT_ID,MONEY,PRICE_CATID,CATALOG_ID FROM PRICE WHERE PRODUCT_ID = #param_1# AND PRICE_CATID = #param_2# AND (STARTDATE <= #param_3# AND (FINISHDATE >= #param_3# OR FINISHDATE IS NULL)) AND UNIT=#param_4# ORDER BY STARTDATE">
	</cfcase>          
    
	<cfcase value="obj_get_price_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT TOP 1 UNIT,PRICE,PRODUCT_ID,MONEY,PRICE_CATID,CATALOG_ID FROM PRICE WHERE PRODUCT_ID =#param_1# AND PRICE_CATID = #param_2# AND (STARTDATE <= #param_3# AND (FINISHDATE >= #param_3# OR FINISHDATE IS NULL)) AND UNIT=#param_4# ORDER BY STARTDATE">
	</cfcase>        
    
	<cfcase value="obj_get_price_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PRICE,MONEY, -1 AS PRICE_CATID,'' AS CATALOG_ID FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PRODUCT_ID =#param_1# AND PURCHASESALES = 1 AND UNIT_ID=#param_2#">
	</cfcase>         
    
	<cfcase value="obj_get_price_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
    	<cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT PRICE.PRICE,PRICE.MONEY,PRICE.PRICE_CATID,PRICE.CATALOG_ID FROM PRICE, PRICE_CAT WHERE PRICE_CAT.PRICE_CAT_STATUS = 1 AND PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID AND PRICE.PRODUCT_ID =#param_1# AND PRICE_CAT.PRICE_CATID = #param_2# AND PRICE.STARTDATE <= #param_3# AND (PRICE.FINISHDATE >= #param_3# OR PRICE.FINISHDATE IS NULL) AND PRICE.UNIT= #param_4#">
	</cfcase>       
    
	<cfcase value="obj_get_price_5">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PRICE,MONEY, -1 AS PRICE_CATID,'' AS CATALOG_ID FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PRODUCT_ID = #param_1# AND PURCHASESALES = 0 AND UNIT_ID= #param_2#">
	</cfcase>    
    
	<cfcase value="obj_get_prom_control">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT,AMOUNT_DISCOUNT,AMOUNT_DISCOUNT_MONEY_1,PROM_ID,FREE_STOCK_ID,FREE_STOCK_AMOUNT,FREE_STOCK_PRICE,AMOUNT_1_MONEY FROM PROMOTIONS WHERE PROM_STATUS = 1 AND PROMOTIONS.LIMIT_TYPE=1 AND PRICE_CATID= #param_1# AND (PROMOTIONS.STOCK_ID IS NULL OR PROMOTIONS.STOCK_ID =#param_2#) AND (PROMOTIONS.BRAND_ID IS NULL OR PROMOTIONS.BRAND_ID = (SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID = #param_2#) ) AND (PROMOTIONS.PRODUCT_CATID IS NULL OR PROMOTIONS.PRODUCT_CATID = (SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #param_2#)) AND PROMOTIONS.STARTDATE <= #param_3# AND PROMOTIONS.FINISHDATE > #param_3#">
	</cfcase>        
	<cfcase value="obj_get_prom_control_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT,AMOUNT_DISCOUNT,AMOUNT_DISCOUNT_MONEY_1,PROM_ID,FREE_STOCK_ID,FREE_STOCK_AMOUNT,FREE_STOCK_PRICE,AMOUNT_1_MONEY FROM PROMOTIONS WHERE PROM_STATUS = 1 AND PROMOTIONS.LIMIT_TYPE=1 AND PRICE_CATID= #param_1# AND (PROMOTIONS.STOCK_ID IS NULL OR PROMOTIONS.STOCK_ID =#param_2#) AND (PROMOTIONS.BRAND_ID IS NULL OR PROMOTIONS.BRAND_ID = (SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID = #param_2#) ) AND (PROMOTIONS.PRODUCT_CATID IS NULL OR PROMOTIONS.PRODUCT_CATID = (SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #param_2#)) AND PROMOTIONS.STARTDATE <= #now()# AND PROMOTIONS.FINISHDATE >= #now()#">
	</cfcase>           
    
	<cfcase value="obj_get_basket_info">
		<cfset form.str_sql= "SELECT DISTINCT SETUP_BASKET_ROWS.IS_SELECTED,SETUP_BASKET.PRODUCT_SELECT_TYPE,SETUP_BASKET.USE_PROJECT_DISCOUNT FROM SETUP_BASKET,SETUP_BASKET_ROWS WHERE SETUP_BASKET.BASKET_ID = SETUP_BASKET_ROWS.BASKET_ID AND SETUP_BASKET.B_TYPE=1 AND SETUP_BASKET_ROWS.B_TYPE=1 AND SETUP_BASKET_ROWS.TITLE='zero_stock_status' AND SETUP_BASKET.BASKET_ID = #attributes.ext_params#">       
    </cfcase>  
    
	<cfcase value="obj_get_product_detail_17">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER, S.TAX,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,GET_STOCK_BARCODES GSB,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1AND S.STOCK_ID=GSB.STOCK_ID AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=GSB.UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND GSB.BARCODE = '#param_1#'">
	</cfcase>   
    
	<cfcase value="obj_get_product_detail_18">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER, S.TAX_PURCHASE AS TAX,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,GET_STOCK_BARCODES GSB,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1AND S.STOCK_ID=GSB.STOCK_ID AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=GSB.UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND GSB.BARCODE = '#param_1#'">
	</cfcase>       
    
	<cfcase value="obj_get_product_detail_19">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER, S.TAX,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,GET_STOCK_BARCODES GSB,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1AND S.STOCK_ID=GSB.STOCK_ID AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=GSB.UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_2#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID=#param_3# ) AND GSB.BARCODE = '#param_1#'">
	</cfcase>   
    
	<cfcase value="obj_get_product_detail_20">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_NAME,S.PROPERTY,S.BARCOD,ISNULL(S.OTV,0) AS OTV,S.PRODUCT_CATID,S.PRODUCT_CODE, S.IS_SERIAL_NO,S.IS_INVENTORY,S.IS_PRODUCTION,S.MANUFACT_CODE,PU.PRODUCT_UNIT_ID,PU.MULTIPLIER, S.TAX_PURCHASE AS TAX,PU.ADD_UNIT,PU.UNIT_ID FROM STOCKS S,GET_STOCK_BARCODES GSB,PRODUCT_UNIT PU WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1AND S.STOCK_ID=GSB.STOCK_ID AND PU.PRODUCT_UNIT_STATUS=1 AND PU.PRODUCT_UNIT_ID=GSB.UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID AND S.PRODUCT_ID IN (SELECT DISTINCT PB.PRODUCT_ID FROM #param_2#.PRODUCT_BRANCH PB WHERE PB.BRANCH_ID=#param_3# ) AND GSB.BARCODE = '#param_1#'">
	</cfcase>          
    
	<cfcase value="obj_get_seri_sale_control_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT SG.GUARANTY_ID,SG.STOCK_ID,SG.DEPARTMENT_ID,SG.LOCATION_ID,SG.UNIT_ROW_QUANTITY,SG.LOT_NO FROM SERVICE_GUARANTY_NEW SG WHERE SG.IN_OUT=1 AND SG.SERIAL_NO = '#param_1#'">
	</cfcase>          
        
	<cfcase value="obj_get_seri_sale_control_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")>
		<cfset form.str_sql= "SELECT SG.GUARANTY_ID,SG.STOCK_ID,SG.DEPARTMENT_ID,SG.LOCATION_ID,SG.UNIT_ROW_QUANTITY,SG.LOT_NO FROM SERVICE_GUARANTY_NEW SG #param_2#.DEPARTMENT D WHERE SG.IN_OUT=1 AND SG.DEPARTMENT_ID=D.DEPARTMENT_ID AND D.BRANCH_ID = #param_3# AND SG.SERIAL_NO = '#param_1#'">
	</cfcase>        
     
	<cfcase value="obj_get_prom_control_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT,AMOUNT_DISCOUNT,AMOUNT_DISCOUNT_MONEY_1,PROM_ID,FREE_STOCK_ID,FREE_STOCK_AMOUNT,FREE_STOCK_PRICE,AMOUNT_1_MONEY FROM PROMOTIONS WHERE PROM_STATUS = 1 AND PROMOTIONS.LIMIT_TYPE=1 AND PRICE_CATID= #param_1# AND (PROMOTIONS.STOCK_ID IS NULL OR PROMOTIONS.STOCK_ID =#param_2#) AND (PROMOTIONS.BRAND_ID IS NULL OR PROMOTIONS.BRAND_ID = (SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID = #param_2#) ) AND (PROMOTIONS.PRODUCT_CATID IS NULL OR PROMOTIONS.PRODUCT_CATID = (SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #param_2#)) AND PROMOTIONS.STARTDATE <=#param_3# AND PROMOTIONS.FINISHDATE > #param_3#">
	</cfcase>      
    
	<cfcase value="obj_get_prom_control_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT DISCOUNT,AMOUNT_DISCOUNT,AMOUNT_DISCOUNT_MONEY_1,PROM_ID,FREE_STOCK_ID,FREE_STOCK_AMOUNT,FREE_STOCK_PRICE,AMOUNT_1_MONEY FROM PROMOTIONS WHERE PROM_STATUS = 1 AND PROMOTIONS.LIMIT_TYPE=1 AND PRICE_CATID= #param_1# AND (PROMOTIONS.STOCK_ID IS NULL OR PROMOTIONS.STOCK_ID =#param_2#) AND (PROMOTIONS.BRAND_ID IS NULL OR PROMOTIONS.BRAND_ID = (SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID = #param_2#) ) AND (PROMOTIONS.PRODUCT_CATID IS NULL OR PROMOTIONS.PRODUCT_CATID = (SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #param_2#)) AND PROMOTIONS.STARTDATE <= #now()# AND PROMOTIONS.FINISHDATE >= #now()#">
	</cfcase>       
    
	<cfcase value="obj_get_price_cat_5">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE (PRICE_CAT_STATUS = 1 AND COMPANY_CAT LIKE '%,#param_2#,%') ORDER BY PRICE_CAT">
	</cfcase>           
    
	<cfcase value="obj_get_price_cat_6">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE (PRICE_CAT_STATUS = 1 AND PRICE_CATID = #param_1#) OR (PRICE_CAT_STATUS = 1 AND COMPANY_CAT LIKE '%,#param_2#,%') ORDER BY PRICE_CAT">
	</cfcase>           
    
	<cfcase value="obj_get_price_cat_7">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE (PRICE_CAT_STATUS = 1 AND CONSUMER_CAT LIKE '%,#param_2#,%') ORDER BY PRICE_CAT">
	</cfcase>       
    
	<cfcase value="obj_get_price_cat_8">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE (PRICE_CAT_STATUS = 1 AND PRICE_CATID = #param_1#) OR PRICE_CAT_STATUS = 1 AND CONSUMER_CAT LIKE '%,#param_2#,%') ORDER BY PRICE_CAT">
	</cfcase>    

 	<cfcase value="obj_sp_query_result">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT SPECT_VAR_ID,SPECT_MAIN_ID FROM SPECTS WHERE SPECT_MAIN_ID <> #param_1# AND SPECIAL_CODE_1 = '#param_2#'">   
	</cfcase> 
         
 	<cfcase value="obj_sp_query_result_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>    
		<cfset form.str_sql= "SELECT SPECT_VAR_ID,SPECT_MAIN_ID FROM SPECTS WHERE  SPECT_MAIN_ID <> #param_1# AND SPECIAL_CODE_2 ='#param_2#'">   
	</cfcase>  
    
 	<cfcase value="obj_sp_query_result_3">
		<cfset form.str_sql= "SELECT SPECT_VAR_ID,SPECT_MAIN_ID FROM SPECTS WHERE SPECIAL_CODE_1 = '#attributes.ext_params#'">   
	</cfcase>       			
    
	<cfcase value="obj_sp_query_result_4">
		<cfset form.str_sql= "SELECT SPECT_VAR_ID,SPECT_MAIN_ID FROM SPECTS WHERE SPECIAL_CODE_2 = '#attributes.ext_params#'">   
	</cfcase>         
    
	<cfcase value="obj_closed_info">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 COMPANY_ID,CONSUMER_ID FROM CARI_CLOSED,CARI_CLOSED_ROW WHERE CARI_CLOSED.CLOSED_ID = CARI_CLOSED_ROW.CLOSED_ID AND CARI_CLOSED_ROW.ACTION_ID = #param_1# AND CARI_CLOSED_ROW.ACTION_TYPE_ID = #param_2#">
	</cfcase>       		 
    
	<cfcase value="obj_BELGE_NO_CONTROL_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PAPER_NO FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID <> '#param_1#' AND PAPER_NO = '#param_2#'">
	</cfcase>           
    
	<cfcase value="obj_paper_number_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PAPER_NO FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE PAPER_NO='#param_1#' AND EXPENSE_ID <> #param_2#">
	</cfcase>      
    
	<cfcase value="obj_closed_info_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #param_1# AND ACTION_TYPE_ID = #param_2#">
	</cfcase>      
    
	<cfcase value="obj_product_info_query">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 S.PRODUCT_ID,S.PRODUCT_NAME,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,ISNULL((SELECT TOP 1  PC.PRODUCT_COST FROM PRODUCT_COST AS PC WHERE START_DATE < #param_1# AND PC.PRODUCT_ID = S.PRODUCT_ID AND PC.MONEY = PS.MONEY ORDER BY PC.START_DATE DESC),0) AS PRODUCT_COST FROM STOCKS S,PRICE_STANDART PS WHERE PRODUCT_STATUS = 1 AND PS.PURCHASESALES = 1 AND PS.PRICESTANDART_STATUS = 1 AND S.PRODUCT_ID = PS.PRODUCT_ID AND STOCK_ID = #param_2#">
	</cfcase>         
	<cfcase value="obj_get_member_prj_risk">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE COMPANY_ID = #param_1# AND PROJECT_ID=#param_2#">
	</cfcase>          
    
	<cfcase value="obj_get_member_prj_risk_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM CONSUMER_REMAINDER_PROJECT WHERE CONSUMER_ID = #param_1# AND PROJECT_ID=#param_2#">
	</cfcase>          
    
	<cfcase value="obj_get_prj_order_risk">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_4#.ORDERS,#param_4#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2# AND PROJECT_ID=#param_1# AND ORDERS.ORDER_ID<>#param_3# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">
	</cfcase>   
            
	<cfcase value="obj_get_prj_ship_total">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ( SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0') A1">
	</cfcase>  
    
	<cfcase value="obj_get_prj_ship_total_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ( SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0' AND SR.ROW_ORDER_ID <> #param_4#) A1">
	</cfcase>      
    
	<cfcase value="obj_get_prj_ship_total_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES = 1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">
	</cfcase>          
    
	<cfcase value="obj_get_prj_ship_total_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
        <cfset param_4 = listgetat(attributes.ext_params,4,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES = 1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_1# AND S.PROJECT_ID=#param_1# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0 AND SR.ROW_ORDER_ID <> #param_4# A1">
	</cfcase>    
    
	<cfcase value="obj_get_company_orders">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM ORDERS,ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID=#param_2# AND ORDERS.ORDER_ID<>#param_3# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">
	</cfcase>            
    
	<cfcase value="obj_get_company_orders_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ( SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM ORDERS,ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2# AND ORDERS.ORDER_ID<>#param_3# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">
	</cfcase>
    
	<cfcase value="obj_get_company_orders_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ORDERS WHERE ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_ID NOT IN (SELECT ORDER_ID FROM ORDERS_INVOICE) AND ORDER_ID NOT IN (SELECT ORDER_ID FROM ORDERS_SHIP) AND ORDER_STATUS = 1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID=#param_2# AND ORDER_ID <> #param_3#">
	</cfcase>       
         
	<cfcase value="obj_get_company_orders_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ORDERS WHERE ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDERS_INVOICE) AND ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDERS_SHIP) AND ORDER_STATUS = 1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2#  AND ORDER_ID <> #param_3#">
	</cfcase>
    
	<cfcase value="obj_get_company_ship">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_1#.INVOICE_ROW IR,#param_1#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.IS_IPTAL = 0 AND I.PURCHASE_SALES = S.PURCHASE_SALES AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES=1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_1#.INVOICE_ROW IR,#param_1#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">
	</cfcase>        
    
	<cfcase value="obj_get_company_ship_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_1#.INVOICE_ROW IR,#param_1#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.IS_IPTAL = 0 AND I.PURCHASE_SALES = S.PURCHASE_SALES AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES=1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_2#AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_1#.INVOICE_ROW IR,#param_1#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">
	</cfcase>
    
	<cfcase value="obj_get_company_ship_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_1#.INVOICE_ROW IR,#param_1#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.IS_IPTAL = 0 AND I.PURCHASE_SALES = S.PURCHASE_SALES AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES=1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_1#.INVOICE_ROW IR,#param_1#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0 AND SR.ROW_ORDER_ID <> #param_3#) A1">
	</cfcase>        
    
	<cfcase value="obj_get_company_ship_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_1#.INVOICE_ROW IR,#dsn2_alias#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.IS_IPTAL = 0 AND I.PURCHASE_SALES = S.PURCHASE_SALES AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES=1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_1#.INVOICE_ROW IR,#param_1#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0 AND SR.ROW_ORDER_ID <> #param_3#) A1">
	</cfcase>
         
	<cfcase value="obj_product_info_query_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT TOP 1 S.PRODUCT_ID,S.PRODUCT_NAME,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,ISNULL((SELECT TOP 1  PC.PRODUCT_COST FROM PRODUCT_COST AS PC WHERE START_DATE < #param_1# AND PC.PRODUCT_ID = S.PRODUCT_ID AND PC.MONEY = PS.MONEY ORDER BY PC.START_DATE DESC),0) AS PRODUCT_COST FROM STOCKS S,PRICE_STANDART PS WHERE PRODUCT_STATUS = 1 AND PS.PURCHASESALES = 1 AND PS.PRICESTANDART_STATUS = 1 AND S.PRODUCT_ID = PS.PRODUCT_ID AND STOCK_ID = #param_2#">
	</cfcase>
	
	<cfcase value="obj_get_my_companycat">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfif Len(param_2) and param_2 neq 0>
			<cfset form.str_sql= "SELECT COMPANYCAT_ID,COMPANYCAT FROM GET_MY_COMPANYCAT WITH (NOLOCK) WHERE EMPLOYEE_ID = #param_1# AND OUR_COMPANY_ID IN (#param_2#) GROUP BY COMPANYCAT_ID,COMPANYCAT ORDER BY COMPANYCAT">
		<cfelse>
			<cfset form.str_sql= "SELECT COMPANYCAT_ID,COMPANYCAT FROM GET_MY_COMPANYCAT WITH (NOLOCK) WHERE EMPLOYEE_ID = #param_1# GROUP BY COMPANYCAT_ID,COMPANYCAT ORDER BY COMPANYCAT">
		</cfif>
	</cfcase>
	<cfcase value="obj_get_my_consumercat">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfif Len(param_2) and param_2 neq 0>
			<cfset form.str_sql= "SELECT CONSCAT_ID,CONSCAT FROM GET_MY_CONSUMERCAT WITH (NOLOCK) WHERE EMPLOYEE_ID = #param_1# AND OUR_COMPANY_ID IN (#param_2#) GROUP BY CONSCAT_ID,CONSCAT ORDER BY CONSCAT">
		<cfelse>
			<cfset form.str_sql= "SELECT CONSCAT_ID,CONSCAT FROM GET_MY_CONSUMERCAT WITH (NOLOCK) WHERE EMPLOYEE_ID = #param_1# GROUP BY CONSCAT_ID,CONSCAT ORDER BY CONSCAT">
		</cfif>
	</cfcase>
    
          
   	<!--- objects2 --->
 	<cfcase value="obj2_get_emp_cv_new">
		<cfset form.str_sql= "SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #attributes.ext_params# ">   
	</cfcase>     	
 	<cfcase value="obj2_get_emp_task_cv_new">
		<cfset form.str_sql="SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #attributes.ext_params# ">   
	</cfcase>           
 	<cfcase value="obj2_get_cv_edu_new">
		<cfset form.str_sql="SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #attributes.ext_params# ">   
	</cfcase>            
 	<cfcase value="obj2_get_cv_edu_high_part_id">
		<cfset form.str_sql="SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #attributes.ext_params# ">   
	</cfcase>         
 	<cfcase value="obj2_get_cv_edu_part_id">
		<cfset form.str_sql="SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #attributes.ext_params# ">   
	</cfcase>          
 	<cfcase value="obj2_basket_zero_stock_status">
		<cfset form.str_sql="SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE B_TYPE=1 AND TITLE='zero_stock_status' AND BASKET_ID = #attributes.ext_params# ">   
	</cfcase>           
 	<cfcase value="obj2_get_comp_prod">
		<cfset form.str_sql="SELECT S.TAX,CPT.COMMISSION_STOCK_ID,CPT.COMMISSION_PRODUCT_ID,CPT.COMMISSION_MULTIPLIER FROM STOCKS S,CREDITCARD_PAYMENT_TYPE CPT WHERE S.STOCK_ID=CPT.COMMISSION_STOCK_ID AND PAYMENT_TYPE_ID = #attributes.ext_params# ">   
	</cfcase>               
 	<cfcase value="obj2_get_pay_mtd">
		<cfset form.str_sql="SELECT S.TAX,CPT.POS_TYPE,CPT.NUMBER_OF_INSTALMENT,CPT.COMMISSION_MULTIPLIER FROM STOCKS S,CREDITCARD_PAYMENT_TYPE CPT WHERE S.STOCK_ID=CPT.COMMISSION_STOCK_ID AND PAYMENT_TYPE_ID = #attributes.ext_params# ">   
	</cfcase>          
 	<cfcase value="obj2_get_comp_prod_2">
		<cfset form.str_sql="SELECT TAX,STOCK_ID FROM STOCKS WHERE PRODUCT_ID =  #attributes.ext_params# ">   
	</cfcase>               
 	<cfcase value="obj2_check_prj_disc">
		<cfset form.str_sql="SELECT PRO_DISCOUNT_ID,IS_CHECK_RISK,IS_CHECK_PRJ_LIMIT,IS_CHECK_PRJ_PRODUCT FROM PROJECT_DISCOUNTS WHERE PROJECT_ID= #attributes.ext_params# ">   
	</cfcase>      
 	<cfcase value="obj2_get_pay_mtd_2">
		<cfset form.str_sql="SELECT S.TAX,CPT.POS_TYPE,CPT.NUMBER_OF_INSTALMENT,CPT.COMMISSION_MULTIPLIER FROM STOCKS S,CREDITCARD_PAYMENT_TYPE CPT WHERE S.STOCK_ID=CPT.COMMISSION_STOCK_ID AND CPT.PAYMENT_TYPE_ID = #attributes.ext_params# ">   
	</cfcase>         
 	<cfcase value="obj2_get_total_stock2">
		<cfset form.str_sql="SELECT S.PRODUCT_NAME,S.IS_PRODUCTION FROM STOCKS S,PRODUCT P WHERE P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND S.STOCK_ID = #attributes.ext_params# ">   
	</cfcase>    
 	<cfcase value="obj2_get_company_cc_2">
		<cfset form.str_sql="SELECT * FROM COMPANY_RISK WHERE COMPANY_ID = #attributes.ext_params# ">   
	</cfcase>       
 	<cfcase value="obj2_get_consumer_cc_2">
		<cfset form.str_sql="SELECT * FROM CONSUMER_RISK WHERE CONSUMER_ID = #attributes.ext_params# ">   
	</cfcase>       
 	<cfcase value="obj2_bank_branch_names">
		<cfset form.str_sql="SELECT BANK_BRANCH_ID, BANK_BRANCH_NAME, BRANCH_CODE,SWIFT_CODE FROM BANK_BRANCH WHERE BANK_ID = #attributes.ext_params# ORDER BY BANK_BRANCH_NAME ">   
	</cfcase>        
 	<cfcase value="obj2_get_cons_pro">
		<cfset form.str_sql="SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_STATUS = 1 AND MEMBER_CODE = '#attributes.ext_params#' ">   
	</cfcase>       
 	<cfcase value="obj2_get_cons_pro_2">
		<cfset form.str_sql="SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.ext_params#">   
	</cfcase>          
 	<cfcase value="obj2_country_control">
		<cfset form.str_sql="SELECT COUNTRY_ID FROM SETUP_COUNTRY WHERE IS_DEFAULT=1">   
	</cfcase>              
	<cfcase value="obj2_consumer_control">
		<cfset form.str_sql="SELECT CONSUMER_ID FROM CONSUMER WHERE TC_IDENTY_NO= '#attributes.ext_params#'">   
	</cfcase>       
	<cfcase value="obj2_consumer_control_2">
		<cfset form.str_sql="SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID <>#session.ww.userid# AND TC_IDENTY_NO= '#attributes.ext_params#'">   
	</cfcase>     
	<cfcase value="obj2_get_prom_str">
		<cfset form.str_sql="SELECT PROM_HEAD FROM PROMOTIONS WHERE PROM_ID IN (#attributes.ext_params#)">   
	</cfcase>      
 	<cfcase value="obj2_get_prod_name">
		<cfset form.str_sql="SELECT PRODUCT_NAME,IS_LOT_NO,STOCK_CODE,IS_ZERO_STOCK FROM STOCKS WHERE STOCK_ID = #attributes.ext_params#">   
	</cfcase>     
 	<cfcase value="obj2_get_strategy">
		<cfset form.str_sql="SELECT ISNULL(MAXIMUM_ORDER_STOCK_VALUE,0) AS MAX_VALUE FROM STOCK_STRATEGY WHERE STOCK_ID =  #attributes.ext_params#">   
	</cfcase>         
 	<cfcase value="obj2_get_prom">
		<cfset form.str_sql="SELECT DISTINCT PC.PROMOTION_ID PROMOTION_ID FROM PROMOTION_CONDITIONS_PRODUCTS PCP,PROMOTION_CONDITIONS PC,PROMOTIONS P WHERE P.PROM_ID = PC.PROMOTION_ID AND P.PROM_STATUS = 1 AND PCP.PROM_CONDITION_ID = PC.PROM_CONDITION_ID AND PCP.STOCK_ID = #attributes.ext_params# AND PCP.IS_SALE_WITH_PROM = 1">   
	</cfcase>        
 	<cfcase value="obj2_get_stock">
		<cfset form.str_sql="SELECT S.PRODUCT_NAME, S.PROPERTY, S.IS_PRODUCTION FROM STOCKS S,PRODUCT P WHERE P.PRODUCT_ID=S.PRODUCT_ID AND P.IS_ZERO_STOCK=0 AND S.STOCK_ID =#attributes.ext_params# ">   
	</cfcase>
	<cfcase value="obj2_get_mng_result">
		<cfset form.str_sql="SELECT TOP 1 FATSERI,FATNO FROM MNG WHERE REF_NO = '#attributes.ext_params#' AND FATSERI IS NOT NULL AND FATNO IS NOT NULL ORDER BY FATNO">
	</cfcase>
	<cfcase value="obj2_get_aras_result">
		<cfset form.str_sql="SELECT REF_NO FROM ORDERS WHERE ORDER_ID = #attributes.ext_params# AND REF_NO IS NOT NULL">
	</cfcase>
    <cfcase value="obj2_get_cargos">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SMP.PRODUCT_ID,SMPR.*,C.NICKNAME FROM SHIP_METHOD_PRICE SMP,SHIP_METHOD_PRICE_ROW SMPR,COMPANY C WHERE SMP.CALCULATE_TYPE = 1 AND SMPR.PACKAGE_TYPE_ID = 1 AND SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND SMP.PRODUCT_ID IS NOT NULL AND SMP.COMPANY_ID = C.COMPANY_ID AND SMP.MULTI_CITY_ID LIKE '%,#param_1#,%' AND SMPR.SHIP_METHOD_ID = #param_1# AND SMPR.CUSTOMER_PRICE > 0 AND SMPR.START_VALUE <= #param_3# AND SMPR.FINISH_VALUE >= #param_3#">
	</cfcase>        
    
	<cfcase value="obj2_get_cargo_type">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SMP.SHIP_METHOD_PRICE_ID,SMPR.CUSTOMER_PRICE FROM SHIP_METHOD_PRICE SMP,SHIP_METHOD_PRICE_ROW SMPR,COMPANY C WHERE SMP.CALCULATE_TYPE = 1 AND SMPR.PACKAGE_TYPE_ID = 1 AND SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND SMP.PRODUCT_ID IS NOT NULL AND SMP.COMPANY_ID = C.COMPANY_ID AND SMP.MULTI_CITY_ID LIKE '%,#param_1#,%' AND SMPR.SHIP_METHOD_ID = #param_2# AND SMPR.CUSTOMER_PRICE > 0 AND SMPR.START_VALUE <= #param_3# ORDER BY SMPR.FINISH_VALUE DESC">
	</cfcase>       		  																 
    
	<cfcase value="obj2_get_cargos_2">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SMP.*,C.NICKNAME FROM SHIP_METHOD_PRICE SMP,COMPANY C WHERE SMP.CALCULATE_TYPE = 1 AND SMP.PRODUCT_ID IS NOT NULL AND SMP.COMPANY_ID = C.COMPANY_ID AND SMP.MULTI_CITY_ID LIKE '%,#param_1#,%' AND SMP.PRICE > 0 AND SMP.MAX_LIMIT <= #param_2# AND SMP.SHIP_METHOD_PRICE_ID = #param_3#">
	</cfcase>
    
 	<cfcase value="obj2_get_pay_mtd_3">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>    
		<cfset form.str_sql="SELECT POS_TYPE,NUMBER_OF_INSTALMENT FROM CREDITCARD_PAYMENT_TYPE CPT,CAMPAIGN_PAYMETHODS CP WHERE CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND CP.CAMPAIGN_ID = #param_1# AND CP.USED_IN_CAMPAIGN = 1 AND PAYMENT_TYPE_ID = #param_2# ">   
	</cfcase>  
    
 	<cfcase value="obj2_get_pay_mtd_4">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT CPT.POS_TYPE,CPT.NUMBER_OF_INSTALMENT FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #param_2# ">   
	</cfcase>      
    
 	<cfcase value="obj2_get_member_prj_risk">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE COMPANY_ID = #param_1# AND PROJECT_ID=#param_2#">   
	</cfcase>        		  
    
 	<cfcase value="obj2_get_member_prj_risk_2">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE CONSUMER_ID = #param_1# AND PROJECT_ID=#param_2#">   
	</cfcase>         		  
    
 	<cfcase value="obj2_get_prj_order_risk">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
    <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_3#.ORDERS,#param_3#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2# AND PROJECT_ID=#param_1# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A">   
	</cfcase>             
    
 	<cfcase value="obj2_get_prj_order_risk_2">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
    <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_3#.ORDERS,#param_3#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID=#param_1# AND PROJECT_ID=#param_1# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">   
	</cfcase>                 
    
 	<cfcase value="obj2_get_prj_ship_total">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
    <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ( SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">	 
	</cfcase>           
    
 	<cfcase value="obj2_get_prj_ship_total_2">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
    <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ( SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=>#param_1# AND S.PROJECT_ID= #param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">
	</cfcase>         
    
	<cfcase value="obj2_get_comp_prod_3">
		<cfset form.str_sql= "SELECT S.TAX,CPT.COMMISSION_STOCK_ID,CPT.COMMISSION_PRODUCT_ID,CPT.COMMISSION_MULTIPLIER,CPT.FIRST_INTEREST_RATE FROM STOCKS S,CREDITCARD_PAYMENT_TYPE CPT WHERE S.STOCK_ID=CPT.COMMISSION_STOCK_ID AND PAYMENT_TYPE_ID = #attributes.ext_params#">
	</cfcase>             
    
 	<cfcase value="obj2_get_comp_prod_4">
		<cfset form.str_sql= "SELECT S.TAX,CPT.PUBLIC_COMMISSION_STOCK_ID COMMISSION_STOCK_ID,CPT.PUBLIC_COMMISSION_PRODUCT_ID COMMISSION_PRODUCT_ID,CPT.PUBLIC_COMMISSION_MULTIPLIER COMMISSION_MULTIPLIER,CPT.FIRST_INTEREST_RATE FROM STOCKS S,CREDITCARD_PAYMENT_TYPE CPT WHERE S.STOCK_ID=CPT.PUBLIC_COMMISSION_STOCK_ID AND PAYMENT_TYPE_ID = #attributes.ext_params#">
	</cfcase>          
    
 	<cfcase value="obj2_get_prj_order_risk_3">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
    <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_3#.ORDERS,#param_3#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2# AND PROJECT_ID=#param_1# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">   
	</cfcase>      
    
 	<cfcase value="obj2_get_prj_order_risk_4">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
    <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ( SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_3#.ORDERS,#param_3#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID=#param_2# AND PROJECT_ID=#param_1# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">   
	</cfcase>          
    
 	<cfcase value="obj2_get_prj_ship_total_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">   
	</cfcase>              
    
 	<cfcase value="obj2_get_prj_ship_total_4">
    <cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
    <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ( SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">   
	</cfcase>  
           
	<cfcase value="obj2_get_cargo_type_3">
		<cfif listlen(attributes.ext_params,'*') gte 1>
			<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfelse>
			<cfset param_1 = 0>	
		</cfif>
		<cfif listlen(attributes.ext_params,'*') gte 2>
			<cfset param_2 = listgetat(attributes.ext_params,2,"*")> 
		<cfelse>
			<cfset param_2 = 0>	
		</cfif>
		<cfif listlen(attributes.ext_params,'*') gte 3>
			<cfset param_3 = listgetat(attributes.ext_params,3,"*")> 
		<cfelse>
			<cfset param_3 = 0>	
		</cfif>
		<cfset form.str_sql= "SELECT SMP.PICTURE, SMP.PRODUCT_ID,SMPR.*,C.NICKNAME FROM SHIP_METHOD_PRICE SMP,SHIP_METHOD_PRICE_ROW SMPR,COMPANY C WHERE SMP.CALCULATE_TYPE = 1 AND SMPR.PACKAGE_TYPE_ID = 1 AND SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND SMP.PRODUCT_ID IS NOT NULL AND SMP.COMPANY_ID = C.COMPANY_ID AND SMPR.SHIP_METHOD_ID = #param_2# AND SMPR.CUSTOMER_PRICE > 0 AND SMPR.START_VALUE <= #param_3# AND SMPR.FINISH_VALUE >= #param_3#"><!---SMP.MULTI_CITY_ID LIKE '%,#param_1#,%' AND--->
	</cfcase>  
    
    <cfcase value="obj2_updOrderRowDetailSql">
    	<cfif listlen(attributes.ext_params,'*') gte 2>
			<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
            <cfif len(param_1)>
				<cfset param_1 = replace(param_1,"'"," ")>
                <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
                <cfset form.str_sql= "UPDATE ORDER_PRE_ROWS SET ORDER_ROW_DETAIL = '#param_1#' WHERE ORDER_ROW_ID = #param_2#">
            </cfif>
        </cfif>
	</cfcase>     
    
	<cfcase value="obj2_updOrderRowDetailSql_2">
    	<cfif listlen(attributes.ext_params,'*') gte 2>
			<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
            <cfif len(param_1)>
                <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
                <cfset form.str_sql= "UPDATE ORDER_PRE_ROWS SET ORDER_INFO_TYPE_ID= '#param_1#' WHERE ORDER_ROW_ID = #param_2#">
            </cfif>
        </cfif>
	</cfcase>       
    
	<cfcase value="obj2_get_member_prj_risk_3">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE COMPANY_ID = #param_1# AND PROJECT_ID=#param_2#">
	</cfcase>           
    
	<cfcase value="obj2_get_member_prj_risk_4">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT * FROM CONSUMER_REMAINDER_PROJECT WHERE CONSUMER_ID = #param_1# AND PROJECT_ID=#param_2#">
	</cfcase>          
    
	<cfcase value="obj2_get_prj_order_risk_5">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ( SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_3#.ORDERS,#param_3#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2# AND PROJECT_ID=#param_1# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">
	</cfcase>              
    
	<cfcase value="obj2_get_prj_order_risk_6">
    	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_3#.ORDERS,#param_3#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID=#param_2# AND PROJECT_ID=#param_1# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">
	</cfcase>               
    
	<cfcase value="obj2_get_prj_ship_total_5">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES=1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">   
	</cfcase>      
    
	<cfcase value="obj2_get_prj_ship_total_6">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES=1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_1# AND S.PROJECT_ID=#param_2# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_3#<.INVOICE_ROW IR,#param_3#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">   
	</cfcase>         
    
	<cfcase value="obj2_get_total_stock_js">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK, S.STOCK_ID, S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID = #param_1# GROUP BY SR.STOCK_ID UNION SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID = #param_1# GROUP BY STOCK_ID UNION SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_PRODUCTION_RESERVED WHERE STOCK_ID = #param_1# GROUP BY STOCK_ID UNION SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID = #param_1# AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 AND S.IS_PRODUCTION=0 GROUP BY S.STOCK_ID, S.PRODUCT_NAME ORDER BY S.STOCK_ID">   
	</cfcase>         
    
	<cfcase value="obj2_get_company_orders">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_3#.ORDERS,#param_3#.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID=#param_2# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">   
	</cfcase>              
    
	<cfcase value="obj2_get_company_orders_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM #param_3#.ORDERS INNER JOIN #param_3#.ORDER_ROW ORD_ROW ON  ORDERS.ORDER_ID = ORD_ROW.ORDER_ID WHERE ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2# AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1">   
	</cfcase>      
    
	<cfcase value="obj2_get_company_orders_3">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SUM(NETTOTAL) NETTOTAL, CONSUMER_ID FROM ORDERS WHERE ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_ID NOT IN (SELECT ORDER_ID FROM ORDERS_INVOICE) AND ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDERS_SHIP) AND ORDER_STATUS = 1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID=#param_2# GROUP BY CONSUMER_ID">   
	</cfcase>          		 
    
	<cfcase value="obj2_get_company_orders_4">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SUM(NETTOTAL) NETTOTAL, COMPANY_ID FROM ORDERS WHERE ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDERS_INVOICE) AND ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDERS_SHIP) AND ORDER_STATUS = 1 AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID=#param_2# GROUP BY COMPANY_ID">   
	</cfcase>       
    
	<cfcase value="obj2_get_company_ship">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND S.PURCHASE_SALES=1 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID=#param_1# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_2#.INVOICE_ROW IR,#param_2#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">   
	</cfcase>  
	<cfcase value="obj_get_product_detail_qrcode">
    		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
            <cfset form.str_sql= "SELECT TOP 1 S.STOCK_ID, S.PRODUCT_ID, S.STOCK_CODE, S.PRODUCT_NAME, S.PROPERTY, S.BARCOD, ISNULL(S.OTV,0) AS OTV, S.PRODUCT_CATID, S.BRAND_ID, S.PRODUCT_CODE, S.IS_SERIAL_NO, S.IS_INVENTORY, S.IS_PRODUCTION, S.MANUFACT_CODE,  S.TAX_PURCHASE AS TAX, PU.PRODUCT_UNIT_ID, PU.MULTIPLIER,PU.ADD_UNIT, PU.UNIT_ID FROM #param_2#.STOCKS_ROW AS SR LEFT JOIN STOCKS AS S ON S.STOCK_ID = SR.STOCK_ID LEFT JOIN PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID WHERE S.STOCK_STATUS=1 AND S.IS_PURCHASE=1 AND PU.PRODUCT_UNIT_STATUS=1 AND SR.LOT_NO = '#param_1#'">
	</cfcase>
	<cfcase value="obj_get_product_detail_qrcodeSales">
    		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
            <cfset form.str_sql= "SELECT TOP 1 S.STOCK_ID, S.PRODUCT_ID, S.STOCK_CODE, S.PRODUCT_NAME, S.PROPERTY, S.BARCOD, ISNULL(S.OTV,0) AS OTV, S.PRODUCT_CATID, S.BRAND_ID, S.PRODUCT_CODE, S.IS_SERIAL_NO, S.IS_INVENTORY, S.IS_PRODUCTION, S.MANUFACT_CODE, S.TAX, PU.PRODUCT_UNIT_ID, PU.MULTIPLIER,PU.ADD_UNIT, PU.UNIT_ID FROM #param_2#.STOCKS_ROW AS SR LEFT JOIN STOCKS AS S ON S.STOCK_ID = SR.STOCK_ID LEFT JOIN PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND PU.PRODUCT_ID=S.PRODUCT_ID WHERE S.STOCK_STATUS=1 AND S.IS_SALES=1 AND PU.PRODUCT_UNIT_STATUS=1 AND SR.LOT_NO = '#param_1#'">
	</cfcase>     
	<cfcase value="obj2_get_company_ship_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM (SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND S.PURCHASE_SALES=1 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID=#param_1# AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #param_2#.INVOICE_ROW IR,#param_2#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0) A1">   
	</cfcase>    
          
    <cfcase value="obj2_get_cons_info">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT BG.BLOCK_GROUP_PERMISSIONS FROM COMPANY_BLOCK_REQUEST CBL,BLOCK_GROUP BG WHERE CBL.CONSUMER_ID = #param_1# AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #param_2# AND (BLOCK_FINISH_DATE>=  #param_2# OR BLOCK_FINISH_DATE IS NULL)">
	</cfcase>     			
    
    <cfcase value="obj2_control_pre_prom_str">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT PROM_HEAD FROM PROMOTIONS WHERE PROM_ID IN (#param_1#) AND PROM_ID<> #param_2#">   
	</cfcase>     		    
    
    <cfcase value="obj2_get_total_stock">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,	S.STOCK_ID,	S.PROPERTY, S.PRODUCT_NAME FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID =#param_1# GROUP BY SR.STOCK_ID UNION	SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID =#param_1# GROUP BY STOCK_ID UNION SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_PRODUCTION_RESERVED WHERE STOCK_ID =#param_1# GROUP BY STOCK_ID UNION SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID =#param_1# AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 AND S.IS_PRODUCTION=0 GROUP BY S.STOCK_ID, S.PROPERTY, S.PRODUCT_NAME ORDER BY S.STOCK_ID">   
	</cfcase> 
          
    <cfcase value="obj2_get_total_stock_2">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset param_3 = listgetat(attributes.ext_params,3,"*")>
		<cfset form.str_sql= "SELECT SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK, S.STOCK_ID, S.PRODUCT_NAME, S.PROPERTY FROM ( SELECT SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK, SR.STOCK_ID FROM GET_STOCK_PRODUCT SR WHERE SR.STOCK_ID =#param_1# GROUP BY SR.STOCK_ID UNION	SELECT SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_STOCK_RESERVED_ROW WHERE STOCK_ID =#param_1# GROUP BY STOCK_ID UNION SELECT SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK, STOCK_ID FROM #param_2#.GET_PRODUCTION_RESERVED WHERE STOCK_ID =#param_1# GROUP BY STOCK_ID UNION SELECT SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, SR.STOCK_ID FROM STOCKS_ROW SR, #dsn_alias#.STOCKS_LOCATION SL WHERE SR.STOCK_ID =#param_1# AND SR.STORE =SL.DEPARTMENT_ID AND SR.STORE_LOCATION=SL.LOCATION_ID AND NO_SALE = 1 GROUP BY STOCK_ID ) T1, #param_2#.STOCKS S WHERE S.STOCK_ID=T1.STOCK_ID AND S.IS_ZERO_STOCK=0 GROUP BY S.STOCK_ID, S.PRODUCT_NAME, S.PROPERTY ORDER BY S.STOCK_ID">   
	</cfcase>   
    
    <cfcase value="obj2_get_comp_prod_5">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql= "SELECT S.TAX,CPT.COMMISSION_STOCK_ID,CPT.COMMISSION_PRODUCT_ID,CP.SERVICE_COMM_MULTIPLIER COMMISSION_MULTIPLIER,CPT.FIRST_INTEREST_RATE FROM CREDITCARD_PAYMENT_TYPE CPT,CAMPAIGN_PAYMETHODS CP,STOCKS S WHERE S.STOCK_ID=CPT.COMMISSION_STOCK_ID AND CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND CP.CAMPAIGN_ID = #param_1# AND CPT.PAYMENT_TYPE_ID = #param_2#">   
	</cfcase>  
	 
	<cfcase value="obj2_get_serv_appcat">
   	 	<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset form.str_sql= "SELECT SERVICE_SUB_CAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID IN (#param_1#)">   
	</cfcase>   
	
	<cfcase value="obj2_get_check_consumer">
   		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset form.str_sql= "SELECT CONSUMER_USERNAME FROM CONSUMER WHERE CONSUMER_EMAIL = '#attributes.ext_params#' OR CONSUMER_USERNAME = '#attributes.ext_params#'">   
	</cfcase> 
	
    <cfcase value="obj2_get_alt_prod">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
        <cfset param_2 = listgetat(attributes.ext_params,2,"*")>
        <cfset form.str_sql= "SELECT S.STOCK_ID, P.PRICE, P.PRICE_KDV, P.MONEY FROM STOCKS S, PRICE P WHERE P.PRODUCT_ID = S.PRODUCT_ID AND S.PRODUCT_ID = #param_1# AND P.PRICE_CATID = #param_2#">   
    </cfcase>     
	
	<cfcase value="obj2_get_call_subcat_infos">
   		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset form.str_sql= "SELECT SERVICE_EXPLAIN FROM G_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_STATUS_ID = #param_1#">   
	</cfcase> 
 
	<cfcase value="obj2_getSpecName">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
		<cfset form.str_sql="SELECT SPECT_MAIN_ID,SPECT_STATUS FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #param_1#">
	</cfcase>	   
    <cfcase value="get_ebildirge_type">
		<cfset form.str_sql= "SELECT EBILDIRGE_TYPE_ID FROM SETUP_OFFTIME WHERE OFFTIMECAT_ID = #attributes.ext_params# AND EBILDIRGE_TYPE_ID = 18 ">
	</cfcase>
    <!--- product --->
	<cfcase value="prd_check_code">
		<cfset form.str_sql="SELECT PRODUCT_CODE_2 FROM PRODUCT WHERE PRODUCT_CODE_2 = '#attributes.ext_params#'">
	</cfcase>				 
	<cfcase value="prd_get_prod_info">
		<cfset form.str_sql="SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = '#attributes.ext_params#'">
	</cfcase>	
	<cfcase value="prd_get_product_cat">
		<cfset form.str_sql="SELECT PRODUCT_CATID FROM PRODUCT WHERE PRODUCT_CATID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="prd_get_inv_info">
		<cfset form.str_sql="SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = #attributes.ext_params#">
	</cfcase>
	<cfcase value="prd_get_prod_property">
		<cfset form.str_sql="SELECT RELATED_VARIATION_ID,PROPERTY_DETAIL_ID,PRPT_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL  WHERE PRPT_ID =#attributes.ext_params#">
	</cfcase>
	<cfcase value="prd_related_variations">
		<cfset form.str_sql="SELECT PROPERTY_DETAIL_ID,PRPT_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL  WHERE PROPERTY_DETAIL_ID IN (#attributes.ext_params#)">
	</cfcase>
	<cfcase value="prd_main_barcode_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT S.BARCOD BARCODE FROM STOCKS S WHERE S.STOCK_ID=#param_1# AND S.BARCOD='#param_2#'">
	</cfcase>
	<cfcase value="prd_other_barcode_control">
		<cfset param_1 = listgetat(attributes.ext_params,1,"*")> 
    	<cfset param_2 = listgetat(attributes.ext_params,2,"*")>
		<cfset form.str_sql="SELECT SB.BARCODE BARCODE,PU.ADD_UNIT ADD_UNIT FROM STOCKS S, STOCKS_BARCODES SB,PRODUCT_UNIT PU WHERE S.STOCK_ID = SB.STOCK_ID AND S.PRODUCT_ID = PU.PRODUCT_ID AND PU.PRODUCT_UNIT_ID = SB.UNIT_ID AND PU.MAIN_UNIT_ID <> PU.UNIT_ID AND SB.STOCK_ID = #param_1# AND SB.BARCODE = '#param_2#'">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="get_js_query2_2.cfm">
	</cfdefaultcase>
</cfswitch>


<cfif not isdefined('#attributes.data_source#')><!---20141222  GA Form yazımı hataya sebep olduğu için attributes ile revize edildi.--->
	<cfset 'form.#data_source#' = attributes.data_source>
</cfif>
<!---<cfif not isdefined('#form.data_source#')><!---20081013 FA istenilen datasoruce tanımlı değil ise yollanan ifade datasoruce olarak kullanılıyor --->
	<cfset 'form.#data_source#' = form.data_source>
</cfif>--->

<cfif isDefined('form.str_sql') and len(form.str_sql) and (not form.str_sql contains 'DELETE FROM ')>
	<cfif isDefined('form.maxrows') and len(form.maxrows) and form.maxrows gt 0>
		<cfquery name="get_js_query" datasource="#evaluate('#attributes.data_source#')#" maxrows="#form.maxrows#">
			<cfoutput>#PreserveSingleQuotes(form.str_sql)#</cfoutput>
		</cfquery>
	<cfelse>
		<cfquery name="get_js_query" datasource="#evaluate('#attributes.data_source#')#">
			<cfoutput>#PreserveSingleQuotes(form.str_sql)#</cfoutput>
		</cfquery>
	</cfif>
	<cfif not isdefined('get_js_query.recordcount')>
		<cfset get_js_query.recordcount = 0>
	</cfif>
<cfelse>
	<cfset get_js_query.recordcount = 0>
</cfif>
	var get_js_query=new Object();
	get_js_query.recordcount=<cfoutput>#get_js_query.recordcount#</cfoutput>;
<cfif get_js_query.recordcount>
	get_js_query.columnList='<cfoutput>#get_js_query.columnList#</cfoutput>';
	<cfloop list="#get_js_query.columnList#" index="i_AJAX">
		get_js_query.<cfoutput>#i_AJAX#</cfoutput>=new Array(1);
		<cfoutput query="get_js_query">
			<cfscript>
				get_js_data=replace(evaluate('get_js_query.#i_AJAX#[#get_js_query.currentrow#]'),'"','');
				get_js_data=replace(get_js_data,"'","","all");
			</cfscript>
			get_js_query.#i_AJAX#[#get_js_query.currentrow-1#] = "#get_js_data#";
		</cfoutput>
	</cfloop>
</cfif>
