<cfsetting showdebugoutput="false">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startdate2" default="">
<cfparam name="attributes.finishdate2" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.member_cat_value" default="">
<cfparam name="attributes.money_info" default="">
<cfparam name="attributes.due_info" default="1">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.resource" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.buy_status" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.comp_status" default="">
<cfparam name="attributes.ims_code_id" default=""> 
<cfparam name="attributes.money_type_info" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.special_definition_type" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.branch_id" default="">
<style>
@media print
 {
	html,body {background: white;}
	table{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
	tr{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
	td{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
}

@media screen
{
	html,body{height: 100%;width:100%;}
	table{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color: #333333;}
	tr{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
	td{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
}
</style>
<cfif isdefined('attributes.is_submit') and attributes.is_submit eq 1>
	<cffunction name="make_pdf" output="false">
		<cfargument name="file_name" default="pdf_file">
		<cfargument name="pdf_content" default="">
		<cfdocument format="pdf" pagetype="a4" filename="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##arguments.file_name#.pdf" marginleft="0" marginright="0" margintop="0" overwrite="yes">
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html xmlns="http://www.w3.org/1999/xhtml">
				<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<title><cf_get_lang dictionary_id='58650.Puantaj'> PDF</title>
				</head>
			<body>
				<cfoutput>#arguments.pdf_content#</cfoutput>
			</body>
		</html>
		</cfdocument>
	</cffunction> 
	<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
	<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
		<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
	</cfif>
    <cfif isdefined("attributes.is_project_group") or isdefined("attributes.is_asset_group")>
		<cfset attributes.money_info = ''>
	</cfif>
	<cfset list_acc_type_id = "">
<cfset list_company = "">
<cfset list_consumer = "">
<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfif isdefined("attributes.employee_id")>
	<cfscript>
    	attributes.acc_type_id = '';
		if(listlen(attributes.employee_id,'_') eq 2)
		{
			attributes.acc_type_id = listlast(attributes.employee_id,'_');
			attributes.emp_id = listfirst(attributes.employee_id,'_');
		}
		else
			attributes.emp_id = attributes.employee_id;
    </cfscript>
</cfif>
<cfif len(attributes.member_cat_type)>
	<cfloop from="1" to="#listlen(attributes.member_cat_type,',')#" index="ix">
		<cfset list_getir = listgetat(attributes.member_cat_type,ix,',')>
		<cfif listfirst(list_getir,'-') eq 1 and listlast(list_getir,'-') neq 0>
			<cfset list_company = listappend(list_company,listlast(list_getir,'-'),'-')>
		<cfelseif listfirst(list_getir,'-') eq 2 and listlast(list_getir,'-') neq 0>
			<cfset list_consumer = listappend(list_consumer,listlast(list_getir,'-'),'-')>
		<cfelseif listfirst(list_getir,'-') eq 5 and replace(list_getir,'#listfirst(list_getir,'-')#-','') neq 0>
			<cfset list_acc_type_id = listappend(list_acc_type_id,replace(list_getir,'#listfirst(list_getir,'-')#-',''),',')>
		</cfif>
		<cfset list_company = listsort(listdeleteduplicates(replace(list_company,"-",",","all"),','),'numeric','ASC',',')>
		<cfset list_consumer = listsort(listdeleteduplicates(replace(list_consumer,"-",",","all"),','),'numeric','ASC',',')>
	</cfloop>
</cfif>
<cfif isDefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
<cfif isDefined("attributes.startdate2") and len(attributes.startdate2)><cf_date tarih="attributes.startdate2"></cfif>
<cfif isDefined("attributes.finishdate2") and len(attributes.finishdate2)><cf_date tarih="attributes.finishdate2"></cfif>
<cfif isDefined("attributes.valuation_date") and len(attributes.valuation_date)><cf_date tarih="attributes.valuation_date"></cfif>
<cfif isDefined("attributes.finishdate2") and len(attributes.finishdate2) and attributes.finishdate2 lt now()>
	<cfset new_date = attributes.finishdate2>
<cfelse>
	<cfif session.ep.period_year lt year(now())>
		<cfset new_date = createodbcdatetime('31/12/#session.ep.period_year#')>
    <cfelse>
		<cfset new_date = now()>
	</cfif>
</cfif>
<cfquery name="get_icra_comp" datasource="#dsn#">
	SELECT CONSUMER_ID,COMPANY_ID FROM COMPANY_LAW_REQUEST CLR WHERE CLR.REQUEST_STATUS = 1
</cfquery>
<cfif get_icra_comp.recordcount>
	<cfset icra_list_comp = listsort(listdeleteduplicates(valuelist(get_icra_comp.COMPANY_ID,',')),'numeric','ASC',',')>
	<cfset icra_list_cons = listsort(listdeleteduplicates(valuelist(get_icra_comp.CONSUMER_ID,',')),'numeric','ASC',',')>
</cfif>
<cfquery name="get_member" datasource="#dsn#">
	<cfif attributes.member_cat_value neq 2 and attributes.member_cat_value neq 5>
		<cfif listfind(attributes.member_cat_type ,'1-0',',') or listfind(attributes.member_cat_type ,'3-0',',') or len(list_company) or not len(attributes.member_cat_type)>
			SELECT 	
				ALL_ROWS.FULLNAME FULLNAME,
				ALL_ROWS.COMP_ID MEMBER_ID,
				ALL_ROWS.MEMBERCAT MEMBERCAT,
				ALL_ROWS.MEMBER_CODE MEMBER_CODE,
				ALL_ROWS.EMAIL EMAIL,
				0 EMP_ACCOUNT_CODE,
                0 ACC_TYPE_ID,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				SUM(BORC3-BORC_CLOSED_VALUE_3) BORC3,
				SUM(ALACAK3-ALA_CLOSED_VALUE_3) ALACAK3,
				OTHER_MONEY,
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				ALL_ROWS.PROJECT_ID PROJECT_ID,
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				ALL_ROWS.ASSETP_ID ASSETP_ID,
			</cfif>
				0 KONTROL
			FROM
			(
				SELECT
					SUM(CRS.ACTION_VALUE) BORC1,
					0 ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS BORC3,
					0 ALACAK3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.TO_CMP_ID COMP_ID,
					C.FULLNAME FULLNAME,
					C.MEMBER_CODE,
					C.COMPANY_EMAIL EMAIL,
					0 KONTROL,
					CC.COMPANYCAT MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>		
				FROM
					#dsn2#.CARI_ROWS CRS,
					COMPANY C,
					COMPANY_CAT CC
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
					CRS.TO_CMP_ID IS NOT NULL AND
                    C.MEMBER_CODE IS NOT NULL AND
					C.COMPANY_ID = CRS.TO_CMP_ID AND
					C.COMPANYCAT_ID = CC.COMPANYCAT_ID 
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name) and attributes.member_type is 'partner'>
					AND	C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
					AND	C.COMPANY_ID IN (#attributes.company_ids#)
				<cfelseif (isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)) or (isdefined("attributes.employee_ids") and len(attributes.employee_ids))>
					AND	C.COMPANY_ID NOT IN (SELECT COMPANY_ID FROM COMPANY)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.COMPANY_ID = WEP.COMPANY_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.COMPANY_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.icra_takibi') and len(attributes.icra_takibi) and isdefined("icra_list_comp") and len(icra_list_comp)>
				 	<cfif attributes.icra_takibi eq 1>
						AND C.COMPANY_ID IN (#icra_list_comp#)
					<cfelseif attributes.icra_takibi eq 2>
						AND C.COMPANY_ID NOT IN (#icra_list_comp#)
					</cfif>
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
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
                	AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.special_definition_type#)
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
						CRS.ACTION_TYPE_ID IN (250,251) AND CRS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM #dsn2#.BANK_ORDERS WHERE IS_PAID = 1) OR
						CRS.ACTION_TYPE_ID NOT IN (250,251)
					)
				</cfif>	
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
				</cfif>
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '3-0'>
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
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
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
				<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
					AND 
					(
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.COMPANY_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
						OR 
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.COMPANY_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
					)
				</cfif>
				GROUP BY 
					CRS.TO_CMP_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					C.FULLNAME,
					CC.COMPANYCAT,
					C.MEMBER_CODE,
					C.COMPANY_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE,
					CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
			<cfif isdefined("attributes.is_pay_cheques")>
			UNION ALL
				SELECT
					0 BORC1,
					0 ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 AS BORC3,
					0 ALACAK3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.TO_CMP_ID COMP_ID,
					C.FULLNAME FULLNAME,
					C.MEMBER_CODE,
					C.COMPANY_EMAIL EMAIL,
					0 KONTROL,
					CC.COMPANYCAT MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>		
				FROM
					#dsn2#.CARI_ROWS CRS,
					COMPANY C,
					COMPANY_CAT CC
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
					CRS.TO_CMP_ID IS NOT NULL AND
                    C.MEMBER_CODE IS NOT NULL AND
					C.COMPANY_ID = CRS.TO_CMP_ID AND
					C.COMPANYCAT_ID = CC.COMPANYCAT_ID
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND COMPANY_STATUS =<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name) and attributes.member_type is 'partner'>
					AND	C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
					AND	C.COMPANY_ID IN (#attributes.company_ids#)
				<cfelseif (isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)) or (isdefined("attributes.employee_ids") and len(attributes.employee_ids))>
					AND	C.COMPANY_ID NOT IN (SELECT COMPANY_ID FROM COMPANY)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.COMPANY_ID = WEP.COMPANY_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.COMPANY_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.icra_takibi') and len(attributes.icra_takibi) and isdefined("icra_list_comp") and len(icra_list_comp)>
				 	<cfif attributes.icra_takibi eq 1>
						AND C.COMPANY_ID IN (#icra_list_comp#)
					<cfelseif attributes.icra_takibi eq 2>
						AND C.COMPANY_ID NOT IN (#icra_list_comp#)
					</cfif>
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
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
					AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
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
				AND (CRS.ACTION_TABLE ='CHEQUE' OR CRS.ACTION_TABLE ='PAYROLL' OR CRS.ACTION_TABLE ='VOUCHER' OR CRS.ACTION_TABLE ='VOUCHER_PAYROLL')
				AND
				(
				(CRS.ACTION_TABLE ='CHEQUE' AND CRS.ACTION_ID IN (SELECT CHEQUE_ID FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) = 4 AND CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='PAYROLL' AND CRS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM #dsn2_alias#.CHEQUE C,#dsn2_alias#.CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CRS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 4 AND C.CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR 
				(CRS.ACTION_TABLE ='VOUCHER' AND CRS.ACTION_ID IN (SELECT VOUCHER_ID FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) = 4 AND VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='VOUCHER_PAYROLL' AND CRS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM #dsn2_alias#.VOUCHER V,#dsn2_alias#.VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CRS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) = 4 AND V.VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				)		
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
				</cfif>
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '3-0'>
					AND C.IS_RELATED_COMPANY = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
					AND C.IS_BUYER = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
					AND C.IS_SELLER= 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL= 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur değerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
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
				<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
					AND 
					(
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.COMPANY_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
						OR 
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.COMPANY_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
					)
				</cfif>
				GROUP BY 
					CRS.TO_CMP_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					C.FULLNAME,
					CC.COMPANYCAT,
					C.MEMBER_CODE,
					C.COMPANY_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
			</cfif>
			UNION ALL
				SELECT
					0 AS BORC1,		
					SUM(CRS.ACTION_VALUE) ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 BORC3,
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALACAK3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.FROM_CMP_ID COMP_ID,
					C.FULLNAME,
					C.MEMBER_CODE,
					C.COMPANY_EMAIL EMAIL,
					0 KONTROL,
					CC.COMPANYCAT MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>					
				FROM
					#dsn2#.CARI_ROWS CRS,
					COMPANY C,
					COMPANY_CAT CC
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
					CRS.FROM_CMP_ID IS NOT NULL AND
					C.COMPANY_ID = CRS.FROM_CMP_ID AND
					C.COMPANYCAT_ID = CC.COMPANYCAT_ID
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND COMPANY_STATUS =<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name) and attributes.member_type is 'partner'>
					AND	C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
					AND	C.COMPANY_ID IN (#attributes.company_ids#)
				<cfelseif (isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)) or (isdefined("attributes.employee_ids") and len(attributes.employee_ids))>
					AND	C.COMPANY_ID NOT IN (SELECT COMPANY_ID FROM COMPANY)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.COMPANY_ID = WEP.COMPANY_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.COMPANY_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.icra_takibi') and len(attributes.icra_takibi) and isdefined("icra_list_comp") and len(icra_list_comp)>
				 	<cfif attributes.icra_takibi eq 1>
						AND C.COMPANY_ID IN (#icra_list_comp#)
					<cfelseif attributes.icra_takibi eq 2>
						AND C.COMPANY_ID NOT IN (#icra_list_comp#)
					</cfif>
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
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
					AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
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
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
				</cfif>
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
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
				<cfif isdefined("attributes.is_pay_bankorders")>
					AND
					(
						CRS.ACTION_TYPE_ID IN (250,251) AND CRS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM #dsn2#.BANK_ORDERS WHERE IS_PAID = 1) OR
						CRS.ACTION_TYPE_ID NOT IN (250,251)
					)
				</cfif>				
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '3-0'>
					AND C.IS_RELATED_COMPANY = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
					AND C.IS_BUYER = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
					AND C.IS_SELLER= 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL= 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
					</cfif>
					AND CRS.FROM_CMP_ID IN
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
					AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
				<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
					AND 
					(
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.COMPANY_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
						OR 
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.COMPANY_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
					)
				</cfif>
				GROUP BY 
					CRS.FROM_CMP_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					C.FULLNAME,
					CC.COMPANYCAT,
					C.MEMBER_CODE,
					C.COMPANY_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
		<cfif isdefined("attributes.is_pay_cheques")>
			UNION ALL		
				SELECT
					0 AS BORC1,		
					0 ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 BORC3,
					0 AS ALACAK3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.FROM_CMP_ID COMP_ID,
					C.FULLNAME,
					C.MEMBER_CODE,
					C.COMPANY_EMAIL EMAIL,
					0 KONTROL,
					CC.COMPANYCAT MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>		
				FROM
					#dsn2#.CARI_ROWS CRS,
					COMPANY C,
					COMPANY_CAT CC
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
					CRS.FROM_CMP_ID IS NOT NULL AND
					C.COMPANY_ID = CRS.FROM_CMP_ID AND
					C.COMPANYCAT_ID = CC.COMPANYCAT_ID
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND COMPANY_STATUS =<cfqueryparam cfsqltype="cf_sql_bit"  value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name) and attributes.member_type is 'partner'>
					AND	C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
					AND	C.COMPANY_ID IN (#attributes.company_ids#)
				<cfelseif (isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)) or (isdefined("attributes.employee_ids") and len(attributes.employee_ids))>
					AND	C.COMPANY_ID NOT IN (SELECT COMPANY_ID FROM COMPANY)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.COMPANY_ID = WEP.COMPANY_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.COMPANY_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.icra_takibi') and len(attributes.icra_takibi) and isdefined("icra_list_comp") and len(icra_list_comp)>
				 	<cfif attributes.icra_takibi eq 1>
						AND C.COMPANY_ID IN (#icra_list_comp#)
					<cfelseif attributes.icra_takibi eq 2>
						AND C.COMPANY_ID NOT IN (#icra_list_comp#)
					</cfif>
				</cfif>
				<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND C.IMS_CODE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
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
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
					AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
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
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
				</cfif>
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate2') and len(attributes.finishdate2)>
					AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
				</cfif>	
				<cfif isdefined('attributes.startdate2') and len(attributes.startdate2)>
					AND CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
				</cfif>	
				AND 
                (CRS.ACTION_TABLE = 'CHEQUE' OR CRS.ACTION_TABLE = 'PAYROLL' OR CRS.ACTION_TABLE = 'VOUCHER' OR CRS.ACTION_TABLE = 'VOUCHER_PAYROLL')
				AND
				(
				(CRS.ACTION_TABLE ='CHEQUE' AND CRS.ACTION_ID IN (SELECT CHEQUE_ID FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) = 4 AND CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='PAYROLL' AND CRS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM #dsn2_alias#.CHEQUE C,#dsn2_alias#.CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CRS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 4 AND C.CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR 
				(CRS.ACTION_TABLE ='VOUCHER' AND CRS.ACTION_ID IN (SELECT VOUCHER_ID FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) = 4 AND VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='VOUCHER_PAYROLL' AND CRS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM #dsn2_alias#.VOUCHER V,#dsn2_alias#.VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CRS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) = 4 AND V.VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				)			
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '3-0'>
					AND C.IS_RELATED_COMPANY = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
					AND C.IS_BUYER = 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
					AND C.IS_SELLER= 1
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL= 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
					</cfif>
					AND CRS.FROM_CMP_ID IN
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
					AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
				<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
					AND 
					(
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.COMPANY_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
						OR 
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.COMPANY_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
					)
				</cfif>
				GROUP BY 
					CRS.FROM_CMP_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					C.FULLNAME,
					CC.COMPANYCAT,
					C.MEMBER_CODE,
					C.COMPANY_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
			</cfif>
			)
				AS ALL_ROWS
			GROUP BY
				ALL_ROWS.COMP_ID,
				ALL_ROWS.FULLNAME,
				ALL_ROWS.MEMBERCAT,
				ALL_ROWS.MEMBER_CODE,
				ALL_ROWS.EMAIL
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					,OTHER_MONEY
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					,PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,ASSETP_ID
				</cfif>
			<cfif len(attributes.duty_claim)>
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					<cfif attributes.duty_claim eq 1>
						<cfif isdefined("attributes.is_zero_bakiye")>
							HAVING ROUND(SUM(BORC3-ALACAK3),2) > 0
						<cfelse>
							HAVING ROUND(SUM(BORC3-ALACAK3),2)  > 0	
						</cfif>
					<cfelseif attributes.duty_claim eq 2>
						HAVING ROUND(SUM(BORC3-ALACAK3),2)  < 0
					</cfif>
				<cfelse>
					<cfif attributes.duty_claim eq 1>
						<cfif isdefined("attributes.is_zero_bakiye")>
							HAVING ROUND(SUM(BORC1-ALACAK1),2) > 0
						<cfelse>
							HAVING ROUND(SUM(BORC1-ALACAK1),2)  > 0	
						</cfif>
					<cfelseif attributes.duty_claim eq 2>
						HAVING ROUND(SUM(BORC1-ALACAK1),2)  < 0
					</cfif>
				</cfif>
			<cfelseif isdefined("attributes.is_zero_bakiye")>
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					HAVING ROUND(SUM(BORC3-ALACAK3),2) <>0 
				<cfelse>
					HAVING ROUND(SUM(BORC1-ALACAK1),2) <>0 
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<cfif attributes.member_cat_value neq 1 and attributes.member_cat_value neq 2 and  attributes.member_cat_value neq 5>
		<cfif not len(attributes.member_cat_type) or ((listfind(attributes.member_cat_type,'1-0',',') or listfind(attributes.member_cat_type,'3-0',',') or len(list_company)) and (listfind(attributes.member_cat_type,'2-0',',') or listfind(attributes.member_cat_type,'4-0',',') or len(list_consumer)))>
			UNION ALL
		</cfif>
	</cfif>
	<cfif attributes.member_cat_value neq 1 and  attributes.member_cat_value neq 5>
		<cfif listfind(attributes.member_cat_type,'2-0',',') or listfind(attributes.member_cat_type,'4-0',',') or  len(list_consumer) or not len(attributes.member_cat_type)>
			SELECT
			  <cfif database_type is "MSSQL">
				ALL_ROWS.CONSUMER_NAME + ' ' + ALL_ROWS.CONSUMER_SURNAME FULLNAME,
			  <cfelseif database_type is "DB2">
				ALL_ROWS.CONSUMER_NAME || ' ' || ALL_ROWS.CONSUMER_SURNAME FULLNAME,
			  </cfif>
				ALL_ROWS.CONSUMER_ID MEMBER_ID,
				ALL_ROWS.MEMBERCAT,
				ALL_ROWS.MEMBER_CODE,
				ALL_ROWS.EMAIL EMAIL,
				0 EMP_ACCOUNT_CODE,
                0 ACC_TYPE_ID,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				SUM(BORC3-BORC_CLOSED_VALUE_3) BORC3,
				SUM(ALACAK3-ALA_CLOSED_VALUE_3) ALACAK3,
				OTHER_MONEY,
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				ALL_ROWS.PROJECT_ID PROJECT_ID,
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				ALL_ROWS.ASSETP_ID ASSETP_ID,
			</cfif>
			1 KONTROL
			FROM 
			(
				SELECT
					SUM(CRS.ACTION_VALUE) BORC1,
					0 ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS BORC3,
					0 ALACAK3,
				<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>		
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.TO_CONSUMER_ID CONSUMER_ID,
					C.CONSUMER_NAME CONSUMER_NAME,
					C.CONSUMER_SURNAME CONSUMER_SURNAME,
					C.MEMBER_CODE,
					C.CONSUMER_EMAIL EMAIL,
					1 KONTROL,
					CC.CONSCAT MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>		
				FROM
					#dsn2#.CARI_ROWS CRS,
					CONSUMER C,
					CONSUMER_CAT CC
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
                	C.MEMBER_CODE IS NOT NULL AND
					CRS.TO_CONSUMER_ID IS NOT NULL AND
					C.CONSUMER_ID = CRS.TO_CONSUMER_ID AND
					C.CONSUMER_CAT_ID = CC.CONSCAT_ID
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND CONSUMER_STATUS =<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name) and attributes.member_type is 'consumer'>
					AND	C.CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)>
					AND	C.CONSUMER_ID IN (#attributes.consumer_ids#)
				<cfelseif (isdefined("attributes.company_ids") and len(attributes.company_ids)) or (isdefined("attributes.employee_ids") and len(attributes.employee_ids))>
					AND	C.CONSUMER_ID NOT IN (SELECT CONSUMER_ID FROM CONSUMER)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.CONSUMER_ID = WEP.CONSUMER_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.CONSUMER_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.icra_takibi') and len(attributes.icra_takibi) and isdefined("icra_list_cons") and len(icra_list_cons)>
				 	<cfif attributes.icra_takibi eq 1>
						AND C.CONSUMER_ID IN (#icra_list_cons#)
					<cfelseif attributes.icra_takibi eq 2>
						AND C.CONSUMER_ID NOT IN (#icra_list_cons#)
					</cfif>
				</cfif>
				<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND C.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
					AND C.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.CONSUMER_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
				</cfif>
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
					AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
                </cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and len(list_consumer)>
					AND C.CONSUMER_CAT_ID IN (#list_consumer#)
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL= 1
				</cfif>
				<cfif isDefined("attributes.city") and len(attributes.city)>
					AND C.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
				</cfif>
				<cfif isDefined("attributes.country") and len(attributes.country)>
					AND C.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
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
						CRS.ACTION_TYPE_ID IN (250,251) AND CRS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM #dsn2#.BANK_ORDERS WHERE IS_PAID = 1) OR
						CRS.ACTION_TYPE_ID NOT IN (250,251)
					)
				</cfif>				
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '4-0'>
					AND C.IS_RELATED_CONSUMER = 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID =<cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif> 
				<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
					</cfif>
					AND CRS.TO_CONSUMER_ID IN
					(SELECT 
						COMPANY_BRANCH_RELATED.CONSUMER_ID
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
					AND C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
				<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
					AND 
					(
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.CONSUMER_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
						OR 
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.CONSUMER_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
					)
				</cfif>
				GROUP BY 
					CRS.TO_CONSUMER_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					C.CONSUMER_NAME,
					C.CONSUMER_SURNAME,
					CC.CONSCAT,
					C.MEMBER_CODE,
					C.CONSUMER_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
			<cfif isdefined("attributes.is_pay_cheques")>
				UNION ALL
				SELECT
					0 BORC1,
					0 ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 AS BORC3,
					0 ALACAK3,
				<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>		
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.TO_CONSUMER_ID CONSUMER_ID,
					C.CONSUMER_NAME CONSUMER_NAME,
					C.CONSUMER_SURNAME CONSUMER_SURNAME,
					C.MEMBER_CODE,
					C.CONSUMER_EMAIL EMAIL,
					1 KONTROL,
					CC.CONSCAT MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>		
				FROM
					#dsn2#.CARI_ROWS CRS,
					CONSUMER C,
					CONSUMER_CAT CC
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
					CRS.TO_CONSUMER_ID IS NOT NULL AND
					C.CONSUMER_ID = CRS.TO_CONSUMER_ID AND
					C.CONSUMER_CAT_ID = CC.CONSCAT_ID
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND CONSUMER_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name) and attributes.member_type is 'consumer'>
					AND	C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)>
					AND	C.CONSUMER_ID IN (#attributes.consumer_ids#)
				<cfelseif (isdefined("attributes.company_ids") and len(attributes.company_ids)) or (isdefined("attributes.employee_ids") and len(attributes.employee_ids))>
					AND	C.CONSUMER_ID NOT IN (SELECT CONSUMER_ID FROM CONSUMER)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.CONSUMER_ID = WEP.CONSUMER_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.CONSUMER_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.icra_takibi') and len(attributes.icra_takibi) and isdefined("icra_list_cons") and len(icra_list_cons)>
				 	<cfif attributes.icra_takibi eq 1>
						AND C.CONSUMER_ID IN (#icra_list_cons#)
					<cfelseif attributes.icra_takibi eq 2>
						AND C.CONSUMER_ID NOT IN (#icra_list_cons#)
					</cfif>
				</cfif>
				<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND C.IMS_CODE_ID =<cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.ims_code_id#">
				</cfif>
				<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
					AND C.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.CONSUMER_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
				</cfif>
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
					AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
                </cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL= 1
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and len(list_consumer)>
					AND C.CONSUMER_CAT_ID IN (#list_consumer#)
				</cfif>
				<cfif isDefined("attributes.city") and len(attributes.city)>
					AND C.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
				</cfif>
				<cfif isDefined("attributes.country") and len(attributes.country)>
					AND C.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
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
				AND (CRS.ACTION_TABLE = 'CHEQUE' OR CRS.ACTION_TABLE = 'PAYROLL' OR CRS.ACTION_TABLE = 'VOUCHER' OR CRS.ACTION_TABLE = 'VOUCHER_PAYROLL')
				AND
				(
				(CRS.ACTION_TABLE ='CHEQUE' AND CRS.ACTION_ID IN (SELECT CHEQUE_ID FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) = 4 AND CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='PAYROLL' AND CRS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM #dsn2_alias#.CHEQUE C,#dsn2_alias#.CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CRS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 4 AND C.CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR 
				(CRS.ACTION_TABLE ='VOUCHER' AND CRS.ACTION_ID IN (SELECT VOUCHER_ID FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) = 4 AND VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='VOUCHER_PAYROLL' AND CRS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM #dsn2_alias#.VOUCHER V,#dsn2_alias#.VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CRS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) = 4 AND V.VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				)		
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '4-0'>
					AND C.IS_RELATED_CONSUMER = 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
					</cfif>

					AND CRS.TO_CONSUMER_ID IN
					(SELECT 
						COMPANY_BRANCH_RELATED.CONSUMER_ID
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
					AND C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
				<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
					AND 
					(
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.CONSUMER_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
						OR 
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.CONSUMER_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
					)
				</cfif>
				GROUP BY 
					CRS.TO_CONSUMER_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					C.CONSUMER_NAME,
					C.CONSUMER_SURNAME,
					CC.CONSCAT,
					C.MEMBER_CODE,
					C.CONSUMER_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
			</cfif>
			UNION ALL
				SELECT
					0 BORC1,		
					SUM(CRS.ACTION_VALUE) ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 BORC3,
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALACAK3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>	
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.FROM_CONSUMER_ID CONSUMER_ID,
					C.CONSUMER_NAME CONSUMER_NAME,
					C.CONSUMER_SURNAME CONSUMER_SURNAME,
					C.MEMBER_CODE,
					C.CONSUMER_EMAIL EMAIL,
					1 KONTROL,
					CC.CONSCAT MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>					
				FROM
					#dsn2#.CARI_ROWS CRS,
					CONSUMER C,
					CONSUMER_CAT CC
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
					CRS.FROM_CONSUMER_ID IS NOT NULL AND
					C.CONSUMER_ID = CRS.FROM_CONSUMER_ID AND
					C.CONSUMER_CAT_ID = CC.CONSCAT_ID
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND CONSUMER_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL= 1
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name) and attributes.member_type is 'consumer'>
					AND	C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)>
					AND	C.CONSUMER_ID IN (#attributes.consumer_ids#)
				<cfelseif (isdefined("attributes.company_ids") and len(attributes.company_ids)) or (isdefined("attributes.employee_ids") and len(attributes.employee_ids))>
					AND	C.CONSUMER_ID NOT IN (SELECT CONSUMER_ID FROM CONSUMER)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.CONSUMER_ID = WEP.CONSUMER_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.CONSUMER_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.icra_takibi') and len(attributes.icra_takibi) and isdefined("icra_list_cons") and len(icra_list_cons)>
				 	<cfif attributes.icra_takibi eq 1>
						AND C.CONSUMER_ID IN (#icra_list_cons#)
					<cfelseif attributes.icra_takibi eq 2>
						AND C.CONSUMER_ID NOT IN (#icra_list_cons#)
					</cfif>
				</cfif>
				<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND C.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
					AND C.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND (C.CONSUMER_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif> 
                OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
				</cfif>
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
					AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
                </cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and len(list_consumer)>
					AND C.CONSUMER_CAT_ID IN (#list_consumer#)
				</cfif>	
				<cfif isDefined("attributes.city") and len(attributes.city)>
					AND C.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
				</cfif>	
				<cfif isDefined("attributes.country") and len(attributes.country)>
					AND C.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
				</cfif>
				<cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
				</cfif>
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
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
						CRS.ACTION_TYPE_ID IN (250,251) AND CRS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM #dsn2#.BANK_ORDERS WHERE IS_PAID = 1) OR
						CRS.ACTION_TYPE_ID NOT IN (250,251)
					)
				</cfif>				
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '4-0'>
					AND C.IS_RELATED_CONSUMER = 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
					</cfif>
					AND CRS.FROM_CONSUMER_ID IN
					(SELECT 
						COMPANY_BRANCH_RELATED.CONSUMER_ID
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
					AND C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
				<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
					AND 
					(
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.CONSUMER_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
						OR 
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.CONSUMER_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
					)
				</cfif>
				GROUP BY 
					CRS.FROM_CONSUMER_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					C.CONSUMER_NAME,
					C.CONSUMER_SURNAME,				
					CC.CONSCAT,
					C.MEMBER_CODE,
					C.CONSUMER_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
			<cfif isdefined("attributes.is_pay_cheques")>
			UNION ALL
				SELECT
					0 BORC1,		
					0 ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 BORC3,
					0 ALACAK3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>	
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.FROM_CONSUMER_ID CONSUMER_ID,
					C.CONSUMER_NAME CONSUMER_NAME,
					C.CONSUMER_SURNAME CONSUMER_SURNAME,
					C.MEMBER_CODE,
					C.CONSUMER_EMAIL EMAIL,
					1 KONTROL,
					CC.CONSCAT MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>		
				FROM
					#dsn2#.CARI_ROWS CRS,
					CONSUMER C,
					CONSUMER_CAT CC
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
					CRS.FROM_CONSUMER_ID IS NOT NULL AND
					C.CONSUMER_ID = CRS.FROM_CONSUMER_ID AND
					C.CONSUMER_CAT_ID = CC.CONSCAT_ID
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND CONSUMER_STATUS =<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
					AND C.ISPOTANTIAL= 1
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name) and attributes.member_type is 'consumer'>
					AND	C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)>
					AND	C.CONSUMER_ID IN (#attributes.consumer_ids#)
				<cfelseif (isdefined("attributes.company_ids") and len(attributes.company_ids)) or (isdefined("attributes.employee_ids") and len(attributes.employee_ids))>
					AND	C.CONSUMER_ID NOT IN (SELECT CONSUMER_ID FROM CONSUMER)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
					AND C.CONSUMER_ID = WEP.CONSUMER_ID
					AND WEP.IS_MASTER = 1
					AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.CONSUMER_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.icra_takibi') and len(attributes.icra_takibi) and isdefined("icra_list_cons") and len(icra_list_cons)>
				 	<cfif attributes.icra_takibi eq 1>
						AND C.CONSUMER_ID IN (#icra_list_cons#)
					<cfelseif attributes.icra_takibi eq 2>
						AND C.CONSUMER_ID NOT IN (#icra_list_cons#)
					</cfif>
				</cfif>
				<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND C.IMS_CODE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
					AND C.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.CONSUMER_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
				</cfif>
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
					AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
                </cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and len(list_consumer)>
					AND C.CONSUMER_CAT_ID IN (#list_consumer#)
				</cfif>	
				<cfif isDefined("attributes.city") and len(attributes.city)>
					AND C.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#">
				</cfif>
				<cfif isDefined("attributes.country") and len(attributes.country)>
					AND C.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
				</cfif>	
				<cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zones#">
				</cfif>
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate2') and len(attributes.finishdate2)>
					AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
				</cfif>		
				<cfif isdefined('attributes.startdate2') and len(attributes.startdate2)>
					AND CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
				</cfif>		
				AND (CRS.ACTION_TABLE = 'CHEQUE' OR CRS.ACTION_TABLE = 'PAYROLL' OR CRS.ACTION_TABLE = 'VOUCHER' OR CRS.ACTION_TABLE = 'VOUCHER_PAYROLL')
				AND
				(
				(CRS.ACTION_TABLE ='CHEQUE' AND CRS.ACTION_ID IN (SELECT CHEQUE_ID FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) = 4 AND CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='PAYROLL' AND CRS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM #dsn2_alias#.CHEQUE C,#dsn2_alias#.CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CRS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 4 AND C.CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR 
				(CRS.ACTION_TABLE ='VOUCHER' AND CRS.ACTION_ID IN (SELECT VOUCHER_ID FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) = 4 AND VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='VOUCHER_PAYROLL' AND CRS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM #dsn2_alias#.VOUCHER V,#dsn2_alias#.VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CRS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) = 4 AND V.VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				)		
				<cfif isDefined("attributes.resource") and len(attributes.resource)>
					AND C.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '4-0'>
					AND C.IS_RELATED_CONSUMER = 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur değerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
					</cfif>
					AND CRS.FROM_CONSUMER_ID IN
					(SELECT 
						COMPANY_BRANCH_RELATED.CONSUMER_ID
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
						AND C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
				<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
					AND 
					(
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.CONSUMER_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
						OR 
						(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_CMP_ID,CRS2.TO_CMP_ID) = C.CONSUMER_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
					)
				</cfif>
				GROUP BY 
					CRS.FROM_CONSUMER_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					C.CONSUMER_NAME,
					C.CONSUMER_SURNAME,				
					CC.CONSCAT,
					C.MEMBER_CODE,
					C.CONSUMER_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
			</cfif>
			)
				AS ALL_ROWS
			GROUP BY
			<cfif database_type is "MSSQL">
				ALL_ROWS.CONSUMER_NAME + ' ' + ALL_ROWS.CONSUMER_SURNAME,
			<cfelseif database_type is "DB2">
				ALL_ROWS.CONSUMER_NAME || ' ' || ALL_ROWS.CONSUMER_SURNAME,
			</cfif>
			ALL_ROWS.CONSUMER_ID,
			ALL_ROWS.MEMBERCAT,
			ALL_ROWS.MEMBER_CODE,
			ALL_ROWS.EMAIL
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				,OTHER_MONEY
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				,PROJECT_ID
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				,ASSETP_ID
			</cfif>
			<cfif len(attributes.duty_claim)>
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					<cfif attributes.duty_claim eq 1>
						<cfif isdefined("attributes.is_zero_bakiye")>
							HAVING ROUND(SUM(BORC3-ALACAK3),2) > 0
						<cfelse>
							HAVING ROUND(SUM(BORC3-ALACAK3),2)  > 0	
						</cfif>
					<cfelseif attributes.duty_claim eq 2>
						HAVING ROUND(SUM(BORC3-ALACAK3),2)  < 0
					</cfif>
				<cfelse>
					<cfif attributes.duty_claim eq 1>
						<cfif isdefined("attributes.is_zero_bakiye")>
							HAVING ROUND(SUM(BORC1-ALACAK1),2) > 0
						<cfelse>
							HAVING ROUND(SUM(BORC1-ALACAK1),2)  > 0	
						</cfif>
					<cfelseif attributes.duty_claim eq 2>
						HAVING ROUND(SUM(BORC1-ALACAK1),2)  < 0
					</cfif>
				</cfif>
			<cfelseif isdefined("attributes.is_zero_bakiye")>
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					HAVING ROUND(SUM(BORC3-ALACAK3),2) <>0 
				<cfelse>
					HAVING ROUND(SUM(BORC1-ALACAK1),2) <>0 
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<cfif (isDefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 5) or (isDefined("attributes.member_cat_value") and attributes.member_cat_value eq 5)><!--- çalışan borç alacak dökümü --->
		SELECT 	
		  <cfif database_type is "MSSQL">
			ALL_ROWS.EMPLOYEE_NAME + ' ' + ALL_ROWS.EMPLOYEE_SURNAME FULLNAME,
		  <cfelseif database_type is "DB2">
			ALL_ROWS.EMPLOYEE_NAME || ' ' || ALL_ROWS.EMPLOYEE_SURNAME FULLNAME,
		  </cfif>
			ALL_ROWS.ACCOUNT_NO,
			ALL_ROWS.MEMBER_ID MEMBER_ID,
			ALL_ROWS.MEMBERCAT MEMBERCAT,
			ALL_ROWS.MEMBER_CODE MEMBER_CODE,
			ALL_ROWS.EMPLOYEE_EMAIL,
			EMP_ACCOUNT_CODE,
            ACC_TYPE_ID,
		<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
			(SELECT BORC FROM #dsn2_alias#.EMPLOYEE_REMAINDER WHERE EMPLOYEE_ID = ALL_ROWS.EMPLOYEE_ID AND ISNULL(EMPLOYEE_REMAINDER.ACC_TYPE_ID,0)=ISNULL(ALL_ROWS.ACC_TYPE_ID,0)) MAIN_BORC,
			(SELECT ALACAK FROM #dsn2_alias#.EMPLOYEE_REMAINDER WHERE EMPLOYEE_ID = ALL_ROWS.EMPLOYEE_ID AND ISNULL(EMPLOYEE_REMAINDER.ACC_TYPE_ID,0)=ISNULL(ALL_ROWS.ACC_TYPE_ID,0)) MAIN_ALACAK,
		</cfif>
		<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
			SUM(BORC3) BORC3,
			SUM(ALACAK3) ALACAK3,
			OTHER_MONEY,
		</cfif>
		<cfif isdefined("attributes.is_project_group")>
			ALL_ROWS.PROJECT_ID PROJECT_ID,
		</cfif>
		<cfif isdefined("attributes.is_asset_group")>
			ALL_ROWS.ASSETP_ID ASSETP_ID,
		</cfif>
			2 KONTROL
		FROM
		(
			SELECT
				E.EMPLOYEE_ID,
				ISNULL((SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND ((ISNULL(CRS.ACC_TYPE_ID,0) <> 0 AND EIOP.ACC_TYPE_ID = ISNULL(CRS.ACC_TYPE_ID,0)) OR ISNULL(CRS.ACC_TYPE_ID,0) = 0)),(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#)) EMP_ACCOUNT_CODE,
                ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				(SELECT TOP 1 EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO FROM EMPLOYEES_BANK_ACCOUNTS WHERE E.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID) ACCOUNT_NO,
				SUM(CRS.ACTION_VALUE) BORC1,
				0 ALACAK1,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS BORC3,
				0 ALACAK3,
				<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
			</cfif>
				CRS.TO_EMPLOYEE_ID MEMBER_ID,
				E.EMPLOYEE_NAME EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				E.EMPLOYEE_NO MEMBER_CODE,
				E.EMPLOYEE_EMAIL EMAIL,
				2 KONTROL,
				0 MEMBERCAT,
				<cfif isdefined("attributes.is_closed_invoice")>
					0 AS ALA_CLOSED_VALUE,
					0 AS ALA_CLOSED_VALUE_3,
					ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
					ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
				<cfelse>
					0 AS ALA_CLOSED_VALUE,
					0 AS ALA_CLOSED_VALUE_3,
					0 AS BORC_CLOSED_VALUE,
					0 AS BORC_CLOSED_VALUE_3
				</cfif>		
			FROM
				#dsn2#.CARI_ROWS CRS,
				EMPLOYEES E
			WHERE
				CRS.TO_EMPLOYEE_ID IS NOT NULL AND
				E.EMPLOYEE_ID = CRS.TO_EMPLOYEE_ID
			<cfif not isdefined("from_rate_valuation")>
				AND CRS.ACTION_VALUE > 0
			</cfif>
			<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
				AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
			</cfif>
			<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.member_name) and attributes.member_type is 'employee'>
				AND	E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
			</cfif>
			<cfif isdefined("attributes.employee_ids") and len(attributes.employee_ids)>
				AND	E.EMPLOYEE_ID IN (#attributes.employee_ids#)
			<cfelseif (isdefined("attributes.company_ids") and len(attributes.company_ids)) or (isdefined("attributes.consumer_ids") and len(attributes.consumer_ids))>
				AND	E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES)
			</cfif>
			<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
				AND CRS.ACC_TYPE_ID = #attributes.acc_type_id#
			</cfif>
			<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
				AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
			</cfif>
			<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
				AND E.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
			</cfif>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND (E.EMPLOYEE_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                OR E.EMPLOYEE_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
			</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
				<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
					AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
				<cfelse>	
					AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
				</cfif>
			</cfif>
			<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
				AND #control_acc_type_list#
			</cfif>
			<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
				AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
			</cfif>
			<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
				AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
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
					CRS.ACTION_TYPE_ID IN (250,251) AND CRS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM #dsn2#.BANK_ORDERS WHERE IS_PAID = 1) OR
					CRS.ACTION_TYPE_ID NOT IN (250,251)
				)
			</cfif>				
			<cfif len(attributes.project_head) and attributes.project_id eq -1>
				AND CRS.PROJECT_ID IS NULL
			<cfelseif len(attributes.project_id) and len(attributes.project_head)>
				AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
				AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
			</cfif>
			<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
				AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
			</cfif>
			<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
				AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
			</cfif>
			<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
				AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
			</cfif>
			<cfif session.ep.isBranchAuthorization>
				<cfif is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
				</cfif>
				AND CRS.TO_EMPLOYEE_ID IN
				(
					SELECT
						EMPLOYEE_POSITIONS.EMPLOYEE_ID
					FROM 
						BRANCH,
						EMPLOYEE_POSITIONS,
						DEPARTMENT
					WHERE
						BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
						AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
						DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID)	
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND E.EMPLOYEE_ID IN
				(
					SELECT
						EMPLOYEE_POSITIONS.EMPLOYEE_ID
					FROM 
						BRANCH,
						EMPLOYEE_POSITIONS,
						DEPARTMENT
					WHERE
						BRANCH.BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
						AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
						DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
				)	
			</cfif>
			GROUP BY 
				E.EMPLOYEE_ID,
                ISNULL(CRS.ACC_TYPE_ID,0),
				CRS.TO_EMPLOYEE_ID,
				CRS.ACTION_TYPE_ID,
				CRS.ACTION_TABLE,
				CRS.CARI_ACTION_ID,
				CRS.ACTION_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_NO,
				E.EMPLOYEE_EMAIL,
				CRS.ACTION_DATE,
				CRS.DUE_DATE
				,CRS.OTHER_MONEY
			<cfif isdefined("attributes.is_project_group")>
				,CRS.PROJECT_ID
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				,CRS.ASSETP_ID
			</cfif>
		<cfif isdefined("attributes.is_pay_cheques")>
			UNION ALL
				SELECT
					E.EMPLOYEE_ID,
					ISNULL((SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND ((ISNULL(CRS.ACC_TYPE_ID,0) <> 0 AND EIOP.ACC_TYPE_ID = ISNULL(CRS.ACC_TYPE_ID,0)) OR ISNULL(CRS.ACC_TYPE_ID,0) = 0)),(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#)) EMP_ACCOUNT_CODE,
                    ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
					(SELECT TOP 1 EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO FROM EMPLOYEES_BANK_ACCOUNTS WHERE E.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID) ACCOUNT_NO,
					0 BORC1,
					0 ALACAK1,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 AS BORC3,
					0 ALACAK3,
				<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
					CRS.TO_EMPLOYEE_ID MEMBER_ID,
					E.EMPLOYEE_NAME EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
					E.EMPLOYEE_NO MEMBER_CODE,
					E.EMPLOYEE_EMAIL EMAIL,
					2 KONTROL,
					0 MEMBERCAT,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>		
				FROM
					#dsn2#.CARI_ROWS CRS,
					EMPLOYEES E
				WHERE
					CRS.TO_EMPLOYEE_ID IS NOT NULL AND
					E.EMPLOYEE_ID = CRS.TO_EMPLOYEE_ID
				<cfif not isdefined("from_rate_valuation")>
					AND CRS.ACTION_VALUE > 0
				</cfif>
				<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
					AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.member_name) and attributes.member_type is 'employee'>
					AND	E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
				</cfif>
				<cfif isdefined("attributes.employee_ids") and len(attributes.employee_ids)>
					AND	E.EMPLOYEE_ID IN (#attributes.employee_ids#)
				<cfelseif (isdefined("attributes.company_ids") and len(attributes.company_ids)) or (isdefined("attributes.consumer_ids") and len(attributes.consumer_ids))>
					AND	E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES)
				</cfif>
				<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
					AND CRS.ACC_TYPE_ID = #attributes.acc_type_id#
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
					AND E.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (E.EMPLOYEE_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                    OR E.EMPLOYEE_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
				</cfif>
				<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
					AND #control_acc_type_list#
				</cfif>
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
					<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
						AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
					<cfelse>	
						AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
					</cfif>
				</cfif>
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
					AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
				</cfif>
				<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
					AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
                </cfif>
				<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
					<cfif isdefined('is_revenue_duedate') and is_revenue_duedate eq 1>
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
				AND (CRS.ACTION_TABLE = 'CHEQUE' OR CRS.ACTION_TABLE = 'PAYROLL' OR CRS.ACTION_TABLE = 'VOUCHER' OR CRS.ACTION_TABLE = 'VOUCHER_PAYROLL')
				AND
				(
				(CRS.ACTION_TABLE ='CHEQUE' AND CRS.ACTION_ID IN (SELECT CHEQUE_ID FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) = 4 AND CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='PAYROLL' AND CRS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM #dsn2_alias#.CHEQUE C,#dsn2_alias#.CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CRS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID)= 4 AND C.CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR 
				(CRS.ACTION_TABLE ='VOUCHER' AND CRS.ACTION_ID IN (SELECT VOUCHER_ID FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) = 4 AND VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				OR	
				(CRS.ACTION_TABLE ='VOUCHER_PAYROLL' AND CRS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM #dsn2_alias#.VOUCHER V,#dsn2_alias#.VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CRS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) = 4 AND V.VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
				)		
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_id) and len(attributes.project_head)>
					AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
					AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
				</cfif>
				<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
					AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
				</cfif>
				<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
					AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				</cfif>
				<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
					AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
				</cfif>
				<cfif session.ep.isBranchAuthorization>
					<cfif is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
					</cfif>
					AND CRS.TO_EMPLOYEE_ID IN
					(
					SELECT
						EMPLOYEE_POSITIONS.EMPLOYEE_ID
					FROM 
						BRANCH,
						EMPLOYEE_POSITIONS,
						DEPARTMENT
					WHERE
						BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
						AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
						DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID)	
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND E.EMPLOYEE_ID IN
					(
						SELECT
							EMPLOYEE_POSITIONS.EMPLOYEE_ID
						FROM 
							BRANCH,
							EMPLOYEE_POSITIONS,
							DEPARTMENT
						WHERE
							BRANCH.BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
							AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
							DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
					)	
				</cfif>
				GROUP BY 
					E.EMPLOYEE_ID,
                    ISNULL(CRS.ACC_TYPE_ID,0),
					CRS.TO_EMPLOYEE_ID,
					CRS.ACTION_TYPE_ID,
					CRS.ACTION_TABLE,
					CRS.CARI_ACTION_ID,
					CRS.ACTION_ID,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					E.EMPLOYEE_NO,
					E.EMPLOYEE_EMAIL,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
		</cfif>
		UNION ALL
			SELECT
				E.EMPLOYEE_ID,
				ISNULL((SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND ((ISNULL(CRS.ACC_TYPE_ID,0) <> 0 AND EIOP.ACC_TYPE_ID = ISNULL(CRS.ACC_TYPE_ID,0)) OR ISNULL(CRS.ACC_TYPE_ID,0) = 0)),(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#)) EMP_ACCOUNT_CODE,
                ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				(SELECT TOP 1 EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO FROM EMPLOYEES_BANK_ACCOUNTS WHERE E.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID) ACCOUNT_NO,
				0 AS BORC1,		
				SUM(CRS.ACTION_VALUE) ALACAK1,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				0 BORC3,
				SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALACAK3,
				<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
			</cfif>
				CRS.FROM_EMPLOYEE_ID MEMBER_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_NO MEMBER_CODE,
				E.EMPLOYEE_EMAIL EMAIL,
				2 KONTROL,
				0 MEMBERCAT,
				<cfif isdefined("attributes.is_closed_invoice")>
					ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
					ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
					0 AS BORC_CLOSED_VALUE,
					0 AS BORC_CLOSED_VALUE_3
				<cfelse>
					0 AS ALA_CLOSED_VALUE,
					0 AS ALA_CLOSED_VALUE_3,
					0 AS BORC_CLOSED_VALUE,
					0 AS BORC_CLOSED_VALUE_3
				</cfif>		
			FROM
				#dsn2#.CARI_ROWS CRS,
				EMPLOYEES E
			WHERE
				CRS.FROM_EMPLOYEE_ID IS NOT NULL AND
				E.EMPLOYEE_ID = CRS.FROM_EMPLOYEE_ID
			<cfif not isdefined("from_rate_valuation")>
				AND CRS.ACTION_VALUE > 0
			</cfif>
			<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
				AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
			</cfif>
			<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.member_name) and attributes.member_type is 'employee'>
				AND	E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
			</cfif>
			<cfif isdefined("attributes.employee_ids") and len(attributes.employee_ids)>
				AND	E.EMPLOYEE_ID IN (#attributes.employee_ids#)
			<cfelseif (isdefined("attributes.company_ids") and len(attributes.company_ids)) or (isdefined("attributes.consumer_ids") and len(attributes.consumer_ids))>
				AND	E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES)
			</cfif>
			<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
				AND CRS.ACC_TYPE_ID = #attributes.acc_type_id#
			</cfif>
			<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
				AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
			</cfif>
			<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
				AND E.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
			</cfif>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND (E.EMPLOYEE_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
                OR E.EMPLOYEE_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
			</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
				<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
					AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
				<cfelse>	
					AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
				</cfif>
			</cfif>
			<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
				AND #control_acc_type_list#
			</cfif>
			<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
				AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
			</cfif>
			<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
				AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
            </cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
					AND
					(
						CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
						CRS.DUE_DATE IS NULL
					)
					AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
				<cfelse>
					AND
					(
						CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
						CRS.DUE_DATE IS NULL
					)
					AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
				</cfif>
			</cfif>
			<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
				<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
					AND
					(
						CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
						CRS.DUE_DATE IS NULL
					)
					AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
				<cfelse>
					AND
					(
						CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
						CRS.DUE_DATE IS NULL
					)
					AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
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
					CRS.ACTION_TYPE_ID IN (250,251) AND CRS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM #dsn2#.BANK_ORDERS WHERE IS_PAID = 1) OR

					CRS.ACTION_TYPE_ID NOT IN (250,251)
				)
			</cfif>				
			<cfif len(attributes.project_head) and attributes.project_id eq -1>
				AND CRS.PROJECT_ID IS NULL
			<cfelseif len(attributes.project_id) and len(attributes.project_head)>
				AND CRS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
				AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
			</cfif>
			<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
				AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
			</cfif>
			<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
				AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
			</cfif>
			<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
				AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
			</cfif>
			<cfif session.ep.isBranchAuthorization>
				<cfif is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
				</cfif>
				AND CRS.FROM_EMPLOYEE_ID IN
				(
					SELECT
						EMPLOYEE_POSITIONS.EMPLOYEE_ID
					FROM 
						BRANCH,
						EMPLOYEE_POSITIONS,
						DEPARTMENT
					WHERE
						BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
						AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
						DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID)
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND E.EMPLOYEE_ID IN
				(
					SELECT
						EMPLOYEE_POSITIONS.EMPLOYEE_ID
					FROM 
						BRANCH,
						EMPLOYEE_POSITIONS,
						DEPARTMENT
					WHERE
						BRANCH.BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
						AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
						DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
				)	
			</cfif>
			GROUP BY 
				E.EMPLOYEE_ID,
                ISNULL(CRS.ACC_TYPE_ID,0),
				CRS.FROM_EMPLOYEE_ID,
				CRS.ACTION_TYPE_ID,
				CRS.ACTION_TABLE,
				CRS.CARI_ACTION_ID,
				CRS.ACTION_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_NO,
				E.EMPLOYEE_EMAIL,
				CRS.ACTION_DATE,
				CRS.DUE_DATE
				,CRS.OTHER_MONEY
			<cfif isdefined("attributes.is_project_group")>
				,CRS.PROJECT_ID
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				,CRS.ASSETP_ID
			</cfif>
			<cfif isdefined("attributes.is_pay_cheques")>
				UNION ALL		
					SELECT
						E.EMPLOYEE_ID,
						ISNULL((SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND ((ISNULL(CRS.ACC_TYPE_ID,0) <> 0 AND EIOP.ACC_TYPE_ID = ISNULL(CRS.ACC_TYPE_ID,0)) OR ISNULL(CRS.ACC_TYPE_ID,0) = 0)),(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#)) EMP_ACCOUNT_CODE,
                        ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
						(SELECT TOP 1 EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO FROM EMPLOYEES_BANK_ACCOUNTS WHERE E.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID) ACCOUNT_NO,
						0 AS BORC1,		
						0 ALACAK1,
					<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
						0 BORC3,
						0 AS ALACAK3,
						<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
					</cfif>
					<cfif isdefined("attributes.is_project_group")>
						ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
					</cfif>
					<cfif isdefined("attributes.is_asset_group")>
						ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
					</cfif>
						CRS.FROM_EMPLOYEE_ID MEMBER_ID,
						E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME,
						E.EMPLOYEE_NO MEMBER_CODE,
						E.EMPLOYEE_EMAIL EMAIL,
						2 KONTROL,
						0 MEMBERCAT,
						<cfif isdefined("attributes.is_closed_invoice")>
							ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
							ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
							0 AS BORC_CLOSED_VALUE,
							0 AS BORC_CLOSED_VALUE_3
						<cfelse>
							0 AS ALA_CLOSED_VALUE,
							0 AS ALA_CLOSED_VALUE_3,
							0 AS BORC_CLOSED_VALUE,
							0 AS BORC_CLOSED_VALUE_3
						</cfif>					
					FROM
						#dsn2#.CARI_ROWS CRS,
						EMPLOYEES E,
						EMPLOYEES_IN_OUT EIO
					WHERE
						CRS.FROM_EMPLOYEE_ID IS NOT NULL AND
						E.EMPLOYEE_ID = CRS.FROM_EMPLOYEE_ID
					<cfif not isdefined("from_rate_valuation")>
						AND CRS.ACTION_VALUE > 0
					</cfif>
					<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
						AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
					</cfif>
					<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.member_name) and attributes.member_type is 'employee'>
						AND	E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
					</cfif>
					<cfif isdefined("attributes.employee_ids") and len(attributes.employee_ids)>
						AND	E.EMPLOYEE_ID IN (#attributes.employee_ids#)
					<cfelseif (isdefined("attributes.company_ids") and len(attributes.company_ids)) or (isdefined("attributes.consumer_ids") and len(attributes.consumer_ids))>
						AND	E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES)
					</cfif>
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
						AND CRS.ACC_TYPE_ID = #attributes.acc_type_id#
					</cfif>
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
						AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
					</cfif>
					<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
						AND E.OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">
					</cfif>
					<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
						AND (E.EMPLOYEE_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif> 
                        OR E.EMPLOYEE_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>)
					</cfif>
					<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
						AND #control_acc_type_list#
					</cfif>
					<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
						<cfif isdefined("x_select_cost_info_project") and x_select_cost_info_project eq 1>
							AND CRS.PROJECT_ID IN(SELECT PP.PROJECT_ID FROM PRO_PROJECTS PP WHERE PP.EXPENSE_CODE IN(SELECT EXPENSE_CODE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">))
						<cfelse>	
							AND CRS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
						</cfif>
					</cfif>
					<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>
						AND CRS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
					</cfif>
					<cfif isDefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
                        AND CRS.SPECIAL_DEFINITION_ID IN (#attributes.SPECIAL_DEFINITION_TYPE#)
                    </cfif>
					<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
						<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
							AND
							(
								CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
								CRS.DUE_DATE IS NULL
							)
							AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
						<cfelse>
							AND
							(
								CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
								CRS.DUE_DATE IS NULL
							)
							AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
						</cfif>
					</cfif>
					<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
						<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
							AND
							(
								CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
								CRS.DUE_DATE IS NULL
							)
							AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
						<cfelse>
							AND
							(
								CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
								CRS.DUE_DATE IS NULL
							)
							AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
						</cfif>
					</cfif>
					<cfif isdefined('attributes.finishdate2') and len(attributes.finishdate2)>
						AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
					</cfif>	
					<cfif isdefined('attributes.startdate2') and len(attributes.startdate2)>
						AND CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
					</cfif>	
					AND (CRS.ACTION_TABLE = 'CHEQUE' OR CRS.ACTION_TABLE = 'PAYROLL' OR CRS.ACTION_TABLE = 'VOUCHER' OR CRS.ACTION_TABLE = 'VOUCHER_PAYROLL')
					AND
                    (
                    (CRS.ACTION_TABLE ='CHEQUE' AND CRS.ACTION_ID IN (SELECT CHEQUE_ID FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),CHEQUE.CHEQUE_STATUS_ID) = 4 AND CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
                    OR	
                    (CRS.ACTION_TABLE ='PAYROLL' AND CRS.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM #dsn2_alias#.CHEQUE C,#dsn2_alias#.CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CRS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 CHH.STATUS FROM #dsn2_alias#.CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID)= 4 AND C.CHEQUE_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
                    OR 
                    (CRS.ACTION_TABLE ='VOUCHER' AND CRS.ACTION_ID IN (SELECT VOUCHER_ID FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_ID = CRS.ACTION_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),VOUCHER.VOUCHER_STATUS_ID) = 4 AND VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
                    OR	
                    (CRS.ACTION_TABLE ='VOUCHER_PAYROLL' AND CRS.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM #dsn2_alias#.VOUCHER V,#dsn2_alias#.VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CRS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (1,2,5,6) OR (ISNULL((SELECT TOP 1 VHH.STATUS FROM #dsn2_alias#.VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#"> ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) = 4 AND V.VOUCHER_DUEDATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_date#">))))
                    )			
					<cfif len(attributes.project_head) and attributes.project_id eq -1>
						AND CRS.PROJECT_ID IS NULL
					<cfelseif len(attributes.project_id) and len(attributes.project_head)>
						AND CRS.PROJECT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
						AND CRS.PROJECT_ID IN (SELECT PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PRO_PROJECTS.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">)
					</cfif>
					<cfif len(attributes.money_info) and attributes.money_info eq 2 and isDefined("attributes.money_type_info") and len(attributes.money_type_info)>
						AND CRS.OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type_info#">
					</cfif>
					<cfif isdefined("from_rate_valuation")><!--- Kur deeğerleme ekranından çağrılıyorsa tl kayıtlar gelmesin --->
						AND CRS.OTHER_MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
					</cfif>
					<cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
						AND C.MEMBER_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_addoptions#">
					</cfif>
					<cfif session.ep.isBranchAuthorization>
						<cfif is_show_store_acts eq 0>
							AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
						</cfif>
						AND CRS.FROM_EMPLOYEE_ID IN
						(
							SELECT
								EMPLOYEE_POSITIONS.EMPLOYEE_ID
							FROM 
								BRANCH,
								EMPLOYEE_POSITIONS,
								DEPARTMENT
							WHERE
								BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
								AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
								DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID)
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND E.EMPLOYEE_ID IN
						(
							SELECT
								EMPLOYEE_POSITIONS.EMPLOYEE_ID
							FROM 
								BRANCH,
								EMPLOYEE_POSITIONS,
								DEPARTMENT
							WHERE
								BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
								AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
								DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
						)	
					</cfif>
					GROUP BY 
						E.EMPLOYEE_ID,
                        ISNULL(CRS.ACC_TYPE_ID,0),
						CRS.FROM_EMPLOYEE_ID,
						CRS.ACTION_TYPE_ID,
						CRS.ACTION_TABLE,
						CRS.CARI_ACTION_ID,
						CRS.ACTION_ID,
						E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME,
						E.EMPLOYEE_NO,
						E.EMPLOYEE_EMAIL,
						CRS.ACTION_DATE,
						CRS.DUE_DATE
						,CRS.OTHER_MONEY
					<cfif isdefined("attributes.is_project_group")>
						,CRS.PROJECT_ID
					</cfif>
					<cfif isdefined("attributes.is_asset_group")>
						,CRS.ASSETP_ID
					</cfif>
				</cfif>
				)
			AS ALL_ROWS
        <cfif len(list_acc_type_id)>
			WHERE ACC_TYPE_ID IN(#list_acc_type_id#)
		</cfif>
		GROUP BY
			ALL_ROWS.ACCOUNT_NO,
			ALL_ROWS.MEMBER_ID,
		<cfif database_type is "MSSQL">
			ALL_ROWS.EMPLOYEE_NAME + ' ' + ALL_ROWS.EMPLOYEE_SURNAME,
		<cfelseif database_type is "DB2">
			ALL_ROWS.EMPLOYEE_NAME || ' ' || ALL_ROWS.EMPLOYEE_SURNAME,
		</cfif>
			ALL_ROWS.MEMBERCAT,
			ALL_ROWS.MEMBER_CODE,
			ALL_ROWS.EMAIL,
            ALL_ROWS.EMPLOYEE_ID,
			ALL_ROWS.EMP_ACCOUNT_CODE,
            ALL_ROWS.ACC_TYPE_ID
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				,OTHER_MONEY
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				,PROJECT_ID
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				,ASSETP_ID
			</cfif>
		<cfif len(attributes.duty_claim)>
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				<cfif attributes.duty_claim eq 1>
					<cfif isdefined("attributes.is_zero_bakiye")>
						HAVING ROUND(SUM(BORC3-ALACAK3),2) > 0
					<cfelse>
						HAVING ROUND(SUM(BORC3-ALACAK3),2)  > 0	
					</cfif>
				<cfelseif attributes.duty_claim eq 2>
					HAVING ROUND(SUM(BORC3-ALACAK3),2)  < 0
				</cfif>
			<cfelse>
				<cfif attributes.duty_claim eq 1>
					<cfif isdefined("attributes.is_zero_bakiye")>
						HAVING ROUND(SUM(BORC1-ALACAK1),2) > 0
					<cfelse>
						HAVING ROUND(SUM(BORC1-ALACAK1),2)  > 0	
					</cfif>
				<cfelseif attributes.duty_claim eq 2>
					HAVING ROUND(SUM(BORC1-ALACAK1),2)  < 0
				</cfif>
			</cfif>
		<cfelseif isdefined("attributes.is_zero_bakiye")>
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				HAVING ROUND(SUM(BORC3-ALACAK3),2) <>0 
			<cfelse>
				HAVING ROUND(SUM(BORC1-ALACAK1),2) <>0 
			</cfif>
		</cfif>
	</cfif>
</cfquery>
    <cfif get_member.recordcount>
    	<cfoutput query="get_member">
        	<cfif isDefined("attributes.startdate") and len(attributes.startdate)><cfset attributes.startdate = dateformat(attributes.startdate,dateformat_style)></cfif>
			<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)><cfset attributes.finishdate = dateformat(attributes.finishdate,dateformat_style)></cfif>
			<cfif isDefined("attributes.startdate2") and len(attributes.startdate2)><cfset attributes.startdate2 = dateformat(attributes.startdate2,dateformat_style)></cfif>
			<cfif isDefined("attributes.finishdate2") and len(attributes.finishdate2)><cfset attributes.finishdate2 = dateformat(attributes.finishdate2,dateformat_style)></cfif>
			<cfif isDefined("attributes.valuation_date") and len(attributes.valuation_date)><cf_date tarih="attributes.valuation_date"></cfif>
    		<cfif kontrol eq 0>
    			<cfset attributes.company_id = member_id>
    		<cfelseif kontrol eq 1>
    			<cfset attributes.consumer_id = member_id>
    		<cfelseif kontrol eq 2>
    			<cfset attributes.employee_id = member_id>
    		</cfif>
    		<cfsavecontent variable="mail_cont">
    			<div id="objects">
				<cfif isdefined("attributes.form_type")> 
					<cfquery name="GET_FORM" datasource="#dsn3#">
						SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = #attributes.form_type# ORDER BY IS_XML,NAME
					</cfquery>
					<cfif isdefined("attributes.iid") and len(attributes.iid) and GET_FORM.PROCESS_TYPE eq 10>
						<cfquery name="GET_PRINT_COUNT" datasource="#dsn2#">
							SELECT PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = #attributes.iid#
						</cfquery>
						<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
							<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
						<cfelse>
							<cfset PRINT_COUNT = 1>
						</cfif>	
						<cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
							UPDATE INVOICE SET PRINT_COUNT = #PRINT_COUNT#,PRINT_DATE = #now()# WHERE INVOICE_ID = #attributes.iid#
						</cfquery>
					</cfif>								
					<cfif isdefined("attributes.action_id") and len(attributes.action_id) and GET_FORM.PROCESS_TYPE eq 73>
						<cfif isdefined("attributes.action_type") and attributes.action_type is "commands">
							<cfquery name="GET_PRINT_COUNT" datasource="#dsn3#">
								SELECT PRINT_COUNT FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
							</cfquery>
							<cfif len(get_print_count.print_count)>
								<cfset PRINT_COUNT = get_print_count.print_count + 1>
							<cfelse>
								<cfset PRINT_COUNT = 1>
							</cfif>	
							<cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
								UPDATE ORDERS SET PRINT_COUNT = #PRINT_COUNT# WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
							</cfquery>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.action_id") and len(attributes.action_id) and GET_FORM.PROCESS_TYPE eq 281>
						<cfquery name="GET_PRINT_COUNT" datasource="#dsn3#">
							SELECT PRINT_COUNT FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
						</cfquery>
						<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
							<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
						<cfelse>
							<cfset PRINT_COUNT = 1>
						</cfif>	
						<cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
							UPDATE PRODUCTION_ORDERS SET PRINT_COUNT = #PRINT_COUNT# WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
						</cfquery>								
					</cfif>
					<cfif get_form.is_standart eq 1>
						<cfinclude template="/#get_form.template_file#">
					<cfelse>
						<cfif ListLast(get_form.template_file,'.') is 'xml'>
				        	<cfinclude template="print_files_xml.cfm">
						<cfelse>
							<cfinclude template="#file_web_path#settings/#get_form.template_file#">
						</cfif>
					</cfif>
				<cfelse>
					<cf_get_lang no='328.Otomatik Baskı Şablonu Oluşturulmamış'>!
				</cfif>
				</div>
    		</cfsavecontent>
    		<cfif isdefined('attributes.mail_pdf') and mail_pdf eq 1>
				<cfset filename = "#fullname#_Mutabakat_Mektubu">
	    		#make_pdf(file_name:'#filename#',pdf_content:'#mail_cont#')#
			</cfif>
			<cfif len(email)>
	        	<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#email#" subject="Mutabakat" type="html">
	               	<cfif isdefined('attributes.mail_pdf') and mail_pdf eq 1>
		    			<cfmailparam file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.pdf">
		    			Mutabakat Mektubu ektedir.
		    		<cfelse>
			            #mail_cont#
					</cfif>
	            </cfmail>
            </cfif>
        </cfoutput>
        <script type="text/javascript">
			alert("Mail gönderilmiştir !");
			window.close();
		</script>
    </cfif>
<cfelse>
    <cf_popup_box title="#getLang('objects',902)#">
        <cfform name="form_mail" method="post" action="#request.self#?fuseaction=objects.popup_send_mail_duty_claim&is_submit=1">
        	<cfif isdefined("attributes.member_cat_value")>
            	<input type="hidden" name="member_cat_value" id="member_cat_value" value="<cfoutput>#attributes.member_cat_value#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.member_cat_type")>
            	<input type="hidden" name="member_cat_type" id="member_cat_type" value="<cfoutput>#attributes.member_cat_type#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.project_head")>
            	<input type="hidden" name="project_head" id="project_head" value="<cfoutput>#attributes.project_head#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.project_id")>
            	<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.money_info")>
            	<input type="hidden" name="money_info" id="money_info" value="<cfoutput>#attributes.money_info#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.duty_claim")>
            	<input type="hidden" name="duty_claim" id="duty_claim" value="<cfoutput>#attributes.duty_claim#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.from_rate_valuation")>
            	<input type="hidden" name="from_rate_valuation" id="from_rate_valuation" value="<cfoutput>#attributes.from_rate_valuation#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
            	<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.asset_name") and len(attributes.asset_name)>
            	<input type="hidden" name="asset_name" id="asset_name" value="<cfoutput>#attributes.asset_name#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            	<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.buy_status") and len(attributes.buy_status)>
            	<input type="hidden" name="buy_status" id="buy_status" value="<cfoutput>#attributes.buy_status#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.city") and len(attributes.city)>
            	<input type="hidden" name="city" id="city" value="<cfoutput>#attributes.city#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.country") and len(attributes.country)>
            	<input type="hidden" name="country" id="country" value="<cfoutput>#attributes.country#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
            	<input type="hidden" name="comp_status" id="comp_status" value="<cfoutput>#attributes.comp_status#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
            	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
            	<input type="hidden" name="company_ids" id="company_ids" value="<cfoutput>#attributes.company_ids#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)>
            	<input type="hidden" name="consumer_ids" id="consumer_ids" value="<cfoutput>#attributes.consumer_ids#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
            	<input type="hidden" name="customer_value" id="customer_value" value="<cfoutput>#attributes.customer_value#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
            	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.employee_ids") and len(attributes.employee_ids)>
            	<input type="hidden" name="employee_ids" id="employee_ids" value="<cfoutput>#attributes.employee_ids#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
            	<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput>#attributes.expense_center_id#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
            	<input type="hidden" name="expense_center_name" id="expense_center_name" value="<cfoutput>#attributes.expense_center_name#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id)>
            	<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#attributes.expense_item_id#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.expense_item_name") and len(attributes.expense_item_name)>
            	<input type="hidden" name="expense_item_name" id="expense_item_name" value="<cfoutput>#attributes.expense_item_name#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            	<cf_date tarih="attributes.finishdate">
            	<input type="hidden" name="finishdate" id="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
            	<cf_date tarih="attributes.finishdate2">
            	<input type="hidden" name="finishdate2" id="finishdate2" value="<cfoutput>#dateformat(attributes.finishdate2,dateformat_style)#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.form_type") and len(attributes.form_type)>
            	<input type="hidden" name="form_type" id="form_type" value="<cfoutput>#attributes.form_type#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.icra_list_comp") and len(attributes.icra_list_comp)>
            	<input type="hidden" name="icra_list_comp" id="icra_list_comp" value="<cfoutput>#attributes.icra_list_comp#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.icra_takibi") and len(attributes.icra_takibi)>
            	<input type="hidden" name="icra_takibi" id="icra_takibi" value="<cfoutput>#attributes.icra_takibi#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id)>
            	<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.ims_code_name") and len(attributes.ims_code_name)>
            	<input type="hidden" name="ims_code_name" id="ims_code_name" value="<cfoutput>#attributes.ims_code_name#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.is_pay_bankorders") and len(attributes.is_pay_bankorders)>
            	<input type="hidden" name="is_pay_bankorders" id="is_pay_bankorders" value="<cfoutput>#attributes.is_pay_bankorders#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.is_pay_cheques") and len(attributes.is_pay_cheques)>
            	<input type="hidden" name="is_pay_cheques" id="is_pay_cheques" value="<cfoutput>#attributes.is_pay_cheques#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.is_revenue_duedate") and len(attributes.is_revenue_duedate)>
            	<input type="hidden" name="is_revenue_duedate" id="is_revenue_duedate" value="<cfoutput>#attributes.is_revenue_duedate#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            	<input type="hidden" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.mail_pdf") and len(attributes.mail_pdf)>
            	<input type="hidden" name="mail_pdf" id="mail_pdf" value="<cfoutput>#attributes.mail_pdf#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.member_addoptions") and len(attributes.member_addoptions)>
            	<input type="hidden" name="member_addoptions" id="member_addoptions" value="<cfoutput>#attributes.member_addoptions#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.member_name") and len(attributes.member_name)>
            	<input type="hidden" name="member_name" id="member_name" value="<cfoutput>#attributes.member_name#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.member_type") and len(attributes.member_type)>
            	<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.money_type_info") and len(attributes.money_type_info)>
            	<input type="hidden" name="money_type_info" id="money_type_info" value="<cfoutput>#attributes.money_type_info#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.ozel_kod") and len(attributes.ozel_kod)>
            	<input type="hidden" name="ozel_kod" id="ozel_kod" value="<cfoutput>#attributes.ozel_kod#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
            	<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#attributes.pos_code#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.pos_code_text") and len(attributes.pos_code_text)>
            	<input type="hidden" name="pos_code_text" id="pos_code_text" value="<cfoutput>#attributes.pos_code_text#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
            	<input type="hidden" name="process_catid" id="process_catid" value="<cfoutput>#attributes.process_catid#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.resource") and len(attributes.resource)>
            	<input type="hidden" name="resource" id="resource" value="<cfoutput>#attributes.resource#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
            	<input type="hidden" name="sales_zones" id="sales_zones" value="<cfoutput>#attributes.sales_zones#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.special_definition_type") and len(attributes.special_definition_type)>
            	<input type="hidden" name="special_definition_type" id="special_definition_type" value="<cfoutput>#attributes.special_definition_type#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            	<cf_date tarih="attributes.startdate">
            	<input type="hidden" name="startdate" id="startdate" value="<cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.startdate2") and len(attributes.startdate2)>
            	<cf_date tarih="attributes.startdate2">
            	<input type="hidden" name="startdate2" id="startdate2" value="<cfoutput>#dateformat(attributes.startdate2,dateformat_style)#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.valuation_date") and len(attributes.valuation_date)>
            	<cf_date tarih="attributes.valuation_date">
            	<input type="hidden" name="valuation_date" id="valuation_date" value="<cfoutput>#dateformat(attributes.valuation_date,dateformat_style)#</cfoutput>" />
            </cfif>
            <cfif isdefined("attributes.x_select_cost_info_project") and len(attributes.x_select_cost_info_project)>
            	<input type="hidden" name="x_select_cost_info_project" id="x_select_cost_info_project" value="<cfoutput>#attributes.x_select_cost_info_project#</cfoutput>" />
            </cfif>
            <table>
                <tr>
                	<td width="100%">&nbsp;</td>
                    <td align="right" nowrap><cf_workcube_buttons insert_info='Mail Gönder'></td>
                </tr>
            </table>
        </cfform>
    </cf_popup_box>﻿
</cfif>
