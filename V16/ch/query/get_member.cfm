<!--- FB 20070724 degistirdi 
	Uye kategorilerinin multiple secilebilir olmasi icin degisiklikler yapildi(1-0 gibi),
	ilk deger uye turu ikinci deger de kategoriye gore secim yapmayi saglar
	Kullanilan member_cat_value degeri popuptan uye secilerek arama yapildiginda gereksiz querylerin calismamasi icin getirildi
  --->
<!--- Vade tarihi filtresinde çek,senetlerde işlem tarihini eses alarak arama yapıyor. SM 20070809 --->
<!---  Bu query de yapılan degisiklikler duty_claim_print_all.cfm ve duty_claim_print_all_pdf.cfm sayfalarında da yapılmalı SS 20110623--->
<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
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
		<cfif listfirst(list_getir,'_') eq 1 and listlast(list_getir,'_') neq 0>
			<cfset list_company = listappend(list_company,listlast(list_getir,'_'),'_')>
		<cfelseif listfirst(list_getir,'_') eq 2 and listlast(list_getir,'_') neq 0>
			<cfset list_consumer = listappend(list_consumer,listlast(list_getir,'_'),'_')>
		<cfelseif listfirst(list_getir,'_') eq 5 and replace(list_getir,'#listfirst(list_getir,'_')#_','') neq 0>
			<cfset list_acc_type_id = listappend(list_acc_type_id,replace(list_getir,'#listfirst(list_getir,'_')#_',''),',')>
		</cfif>
		<cfset list_company = listsort(listdeleteduplicates(replace(list_company,"_",",","all"),','),'numeric','ASC',',')>
		<cfset list_consumer = listsort(listdeleteduplicates(replace(list_consumer,"_",",","all"),','),'numeric','ASC',',')>
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
		<cfif listfind(attributes.member_cat_type ,'1_0',',') or listfind(attributes.member_cat_type ,'3_0',',') or len(list_company) or not len(attributes.member_cat_type)>
			SELECT 	
				ALL_ROWS.FULLNAME FULLNAME,
                '' ACCOUNT_NO,
				ALL_ROWS.COMP_ID MEMBER_ID,
				ALL_ROWS.MEMBERCAT MEMBERCAT,
				ALL_ROWS.MEMBER_CODE MEMBER_CODE,
                ALL_ROWS.COMPANY_TEL1 COMPANY_TEL1,
                ALL_ROWS.COMPANY_TELCODE COMPANY_TELCODE,
				ALL_ROWS.CITY,
				'' EMP_ACCOUNT_CODE,
				0 KONTROL,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				(SELECT BAKIYE FROM #dsn2_alias#.COMPANY_REMAINDER WHERE COMPANY_ID =  ALL_ROWS.COMP_ID) MAIN_BAKIYE,
                0 MAIN_BORC,
                0 MAIN_ALACAK,
			</cfif>	
				SUM((BORC1-BORC_CLOSED_VALUE)-(ALACAK1-ALA_CLOSED_VALUE)) BAKIYE,
				SUM(BORC1-BORC_CLOSED_VALUE) BORC,
				SUM(ALACAK1-ALA_CLOSED_VALUE) ALACAK,
				CASE WHEN SUM(BORC1-BORC_CLOSED_VALUE)= 0 THEN SUM((BORC1-BORC_CLOSED_VALUE)*DATE_DIFF) ELSE ROUND((SUM(((BORC1-BORC_CLOSED_VALUE)*DATE_DIFF))/SUM(BORC1-BORC_CLOSED_VALUE)),0) END AS VADE_BORC_1,
				CASE WHEN SUM((ALACAK1-ALA_CLOSED_VALUE))= 0 THEN SUM((ALACAK1-ALA_CLOSED_VALUE)*DATE_DIFF) ELSE ROUND((SUM(((ALACAK1-ALA_CLOSED_VALUE)*DATE_DIFF))/SUM(ALACAK1-ALA_CLOSED_VALUE)),0) END AS VADE_ALACAK_1,
				SUM((BORC1-BORC_CLOSED_VALUE)*DATE_DIFF) VADE_BORC_ARATOPLAM,
				SUM((ALACAK1-ALA_CLOSED_VALUE)*DATE_DIFF) VADE_ALACAK_ARATOPLAM,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				SUM((BORC3-BORC_CLOSED_VALUE_3)-(ALACAK3-ALA_CLOSED_VALUE_3)) BAKIYE3,
				SUM(BORC3-BORC_CLOSED_VALUE_3) BORC3,
				SUM(ALACAK3-ALA_CLOSED_VALUE_3) ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3-BORC_CLOSED_VALUE_3)= 0 THEN SUM(((BORC3-BORC_CLOSED_VALUE_3)*DATE_DIFF)) ELSE ROUND((SUM(((BORC3-BORC_CLOSED_VALUE_3)*DATE_DIFF))/SUM(BORC3-BORC_CLOSED_VALUE_3)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK3-ALA_CLOSED_VALUE_3)= 0 THEN SUM(((ALACAK3-ALA_CLOSED_VALUE_3)*DATE_DIFF)) ELSE ROUND((SUM(((ALACAK3-ALA_CLOSED_VALUE_3)*DATE_DIFF))/SUM(ALACAK3-ALA_CLOSED_VALUE_3)),0) END AS VADE_ALACAK,
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				ALL_ROWS.PROJECT_ID PROJECT_ID,
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				ALL_ROWS.ASSETP_ID ASSETP_ID,
			</cfif>
			<cfif isdefined("attributes.is_subscription_group")>
				ALL_ROWS.SUBSCRIPTION_ID SUBSCRIPTION_ID,
			</cfif>
			<cfif isdefined("attributes.is_acc_type_group")>
				ALL_ROWS.ACC_TYPE_ID ACC_TYPE_ID,
			<cfelse>
				0 AS ACC_TYPE_ID,
			</cfif>
				SUM((BORC2-BORC_CLOSED_VALUE_2)-(ALACAK2-ALA_CLOSED_VALUE_2)) BAKIYE2,
				SUM(BORC2-BORC_CLOSED_VALUE_2) BORC2,
				SUM(ALACAK2-ALA_CLOSED_VALUE_2) ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					SUM(BORC_CHEQUE_VOUCHER_VALUE3-ALA_CHEQUE_VOUCHER_VALUE3) CHEQUE_VOUCHER_VALUE3,
					SUM(BORC_CHEQUE_VOUCHER_VALUE_CH3-ALA_CHEQUE_VOUCHER_VALUE_CH3) CHEQUE_VOUCHER_VALUE_CH3,
					SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER3-ALA_CHEQUE_VOUCHER_VALUE_OTHER3) CHEQUE_VOUCHER_VALUE_OTHER3,
				</cfif>
				SUM(BORC_CHEQUE_VOUCHER_VALUE-ALA_CHEQUE_VOUCHER_VALUE) CHEQUE_VOUCHER_VALUE,
				SUM(BORC_CHEQUE_VOUCHER_VALUE2-ALA_CHEQUE_VOUCHER_VALUE2) CHEQUE_VOUCHER_VALUE2,
				SUM(BORC_CHEQUE_VOUCHER_VALUE_CH-ALA_CHEQUE_VOUCHER_VALUE_CH) CHEQUE_VOUCHER_VALUE_CH,
				SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER-ALA_CHEQUE_VOUCHER_VALUE_OTHER) CHEQUE_VOUCHER_VALUE_OTHER,
				SUM(BORC_CHEQUE_VOUCHER_VALUE_CH2-ALA_CHEQUE_VOUCHER_VALUE_CH2) CHEQUE_VOUCHER_VALUE_CH2,
				SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER2-ALA_CHEQUE_VOUCHER_VALUE_OTHER2) CHEQUE_VOUCHER_VALUE_OTHER2
			FROM
			(
				SELECT
					SUM(CRS.ACTION_VALUE) BORC1,
					0 ALACAK1,
					SUM(ISNULL(CRS.ACTION_VALUE_2,0)) BORC2,
					0 ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS BORC3,
					0 ALACAK3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				</cfif>
					CRS.TO_CMP_ID COMP_ID,
					C.FULLNAME FULLNAME,
					C.MEMBER_CODE,
                    C.COMPANY_TEL1,
                    C.COMPANY_TELCODE,
					C.CITY,
					0 KONTROL,
					CC.COMPANYCAT MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					0 AS ALA_CHEQUE_VOUCHER_VALUE,
					0 AS ALA_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE,
					0 AS BORC_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
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
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					AND
					(
						(C.COMPANY_ID IS NULL) 
						OR (C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
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
					AND C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.FULLNAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
							CRS.DUE_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> )
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
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '3_0'>
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
				<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
					AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
				<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
                    C.COMPANY_TEL1,
                    C.COMPANY_TELCODE,
					C.CITY,
					CRS.ACTION_DATE,
					CRS.DUE_DATE,
					CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,CRS.SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,CRS.ACC_TYPE_ID
				</cfif>
			<cfif isdefined("attributes.is_pay_cheques")>
			UNION ALL
				SELECT
					0 BORC1,
					0 ALACAK1,
					0 BORC2,
					0 ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 AS BORC3,
					0 ALACAK3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE3,
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS BORC_CHEQUE_VOUCHER_VALUE3,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.OTHER_CASH_ACT_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.OTHER_CASH_ACT_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				</cfif>
					CRS.TO_CMP_ID COMP_ID,
					C.FULLNAME FULLNAME,
					C.MEMBER_CODE,
                    C.COMPANY_TEL1,
                    C.COMPANY_TELCODE,
					C.CITY,
					0 KONTROL,
					CC.COMPANYCAT MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					0 AS ALA_CHEQUE_VOUCHER_VALUE,
					0 AS ALA_CHEQUE_VOUCHER_VALUE2,
					SUM(CRS.ACTION_VALUE) AS BORC_CHEQUE_VOUCHER_VALUE,
					SUM(ISNULL(CRS.ACTION_VALUE_2,0)) AS BORC_CHEQUE_VOUCHER_VALUE2,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_CH,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.ACTION_VALUE_2)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.ACTION_VALUE_2)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,					
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
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
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					AND
					(
						(C.COMPANY_ID IS NULL) 
						OR (C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
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
					AND C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND (C.FULLNAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif> 
                OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>) 
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
							CRS.DUE_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> )
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
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '3_0'>
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
				<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
					AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
				<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
                    C.COMPANY_TEL1,
                    C.COMPANY_TELCODE,
					C.CITY,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,CRS.SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,CRS.ACC_TYPE_ID
				</cfif>
			</cfif>
			UNION ALL
				SELECT
					0 AS BORC1,		
					SUM(CRS.ACTION_VALUE) ALACAK1,
					0 BORC2,
					SUM(ISNULL(CRS.ACTION_VALUE_2,0)) ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 BORC3,
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALACAK3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				</cfif>
					CRS.FROM_CMP_ID COMP_ID,
					C.FULLNAME,
					C.MEMBER_CODE,
                    C.COMPANY_TEL1,
                    C.COMPANY_TELCODE,
					C.CITY,
					0 KONTROL,
					CC.COMPANYCAT MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					0 AS ALA_CHEQUE_VOUCHER_VALUE,
					0 AS ALA_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE,
					0 AS BORC_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
						0 AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
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
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
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
					AND C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.FULLNAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '3_0'>
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
				<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
					AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
				<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
                    C.COMPANY_TEL1,
                    C.COMPANY_TELCODE,
					C.CITY,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,CRS.SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,CRS.ACC_TYPE_ID
				</cfif>
		<cfif isdefined("attributes.is_pay_cheques")>
			UNION ALL		
				SELECT
					0 AS BORC1,		
					0 ALACAK1,
					0 BORC2,
					0 ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 BORC3,
					0 AS ALACAK3,
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALA_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE3 ,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.OTHER_CASH_ACT_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.OTHER_CASH_ACT_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				</cfif>
					CRS.FROM_CMP_ID COMP_ID,
					C.FULLNAME,
					C.MEMBER_CODE,
                    C.COMPANY_TEL1,
                    C.COMPANY_TELCODE,
					C.CITY,
					0 KONTROL,
					CC.COMPANYCAT MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					SUM(ACTION_VALUE) AS ALA_CHEQUE_VOUCHER_VALUE,
					SUM(ACTION_VALUE_2) AS ALA_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE,
					0 AS BORC_CHEQUE_VOUCHER_VALUE2,
					0 BORC_CHEQUE_VOUCHER_VALUE_CH,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.ACTION_VALUE_2)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.ACTION_VALUE_2)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
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
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
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
					AND C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.FULLNAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif> 
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '3_0'>
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
				<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
					AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
				<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
                    C.COMPANY_TEL1,
                    C.COMPANY_TELCODE,
					C.CITY,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,CRS.SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,CRS.ACC_TYPE_ID
				</cfif>
			</cfif>
			)
				AS ALL_ROWS
			GROUP BY
				ALL_ROWS.COMP_ID,
				ALL_ROWS.FULLNAME,
				ALL_ROWS.MEMBERCAT,
				ALL_ROWS.MEMBER_CODE,
                ALL_ROWS.COMPANY_TEL1,
                ALL_ROWS.COMPANY_TELCODE,
				ALL_ROWS.CITY
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					,OTHER_MONEY
				</cfif>
				<cfif isdefined("attributes.is_project_group")>
					,PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,ACC_TYPE_ID
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
	<cfif attributes.member_cat_value neq 1 and attributes.member_cat_value neq 2 and  attributes.member_cat_value neq 5 and not len(attributes.company_id) and not len(attributes.employee_id)>
		<cfif not len(attributes.member_cat_type) or ((listfind(attributes.member_cat_type,'1_0',',') or listfind(attributes.member_cat_type,'3_0',',') or len(list_company)) and (listfind(attributes.member_cat_type,'2_0',',') or listfind(attributes.member_cat_type,'4_0',',') or len(list_consumer)))>
			UNION ALL
		</cfif>
	</cfif>
	<cfif attributes.member_cat_value neq 1 and  attributes.member_cat_value neq 5 and not len(attributes.company_id) and not len(attributes.employee_id)>
		<cfif listfind(attributes.member_cat_type,'2_0',',') or listfind(attributes.member_cat_type,'4_0',',') or len(list_consumer) or not len(attributes.member_cat_type)>
			SELECT
			  <cfif database_type is "MSSQL">
				ALL_ROWS.CONSUMER_NAME + ' ' + ALL_ROWS.CONSUMER_SURNAME FULLNAME,
			  <cfelseif database_type is "DB2">
				ALL_ROWS.CONSUMER_NAME || ' ' || ALL_ROWS.CONSUMER_SURNAME FULLNAME,
			  </cfif>
				'' ACCOUNT_NO,
                ALL_ROWS.CONSUMER_ID MEMBER_ID,
				ALL_ROWS.MEMBERCAT,
				ALL_ROWS.MEMBER_CODE,
                ALL_ROWS.CONSUMER_WORKTEL COMPANY_TEL1,
                ALL_ROWS.CONSUMER_WORKTELCODE COMPANY_TELCODE,
				ALL_ROWS.CITY,
				'' EMP_ACCOUNT_CODE,
				1 KONTROL,	
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				(SELECT BAKIYE FROM #dsn2_alias#.CONSUMER_REMAINDER WHERE CONSUMER_ID =  ALL_ROWS.CONSUMER_ID) MAIN_BAKIYE,
                0 MAIN_BORC,
                0 MAIN_ALACAK,	
			</cfif>				
				SUM((BORC1-BORC_CLOSED_VALUE)-(ALACAK1-ALA_CLOSED_VALUE)) BAKIYE,
				SUM(BORC1-BORC_CLOSED_VALUE) BORC,
				SUM(ALACAK1-ALA_CLOSED_VALUE) ALACAK,
				CASE WHEN SUM(BORC1-BORC_CLOSED_VALUE)= 0 THEN SUM((BORC1-BORC_CLOSED_VALUE)*DATE_DIFF) ELSE ROUND((SUM((BORC1-BORC_CLOSED_VALUE*DATE_DIFF))/SUM(BORC1-BORC_CLOSED_VALUE)),0) END AS VADE_BORC_1,
				CASE WHEN SUM((ALACAK1-ALA_CLOSED_VALUE))= 0 THEN SUM((ALACAK1-ALA_CLOSED_VALUE)*DATE_DIFF) ELSE ROUND((SUM(((ALACAK1-ALA_CLOSED_VALUE)*DATE_DIFF))/SUM(ALACAK1-ALA_CLOSED_VALUE)),0) END AS VADE_ALACAK_1,
				SUM((BORC1-BORC_CLOSED_VALUE)*DATE_DIFF) VADE_BORC_ARATOPLAM,
				SUM((ALACAK1-ALA_CLOSED_VALUE)*DATE_DIFF) VADE_ALACAK_ARATOPLAM,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				SUM((BORC3-BORC_CLOSED_VALUE_3)-(ALACAK3-ALA_CLOSED_VALUE_3)) BAKIYE3,
				SUM(BORC3-BORC_CLOSED_VALUE_3) BORC3,
				SUM(ALACAK3-ALA_CLOSED_VALUE_3) ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3-BORC_CLOSED_VALUE_3)= 0 THEN SUM(((BORC3-BORC_CLOSED_VALUE_3)*DATE_DIFF)) ELSE ROUND((SUM(((BORC3-BORC_CLOSED_VALUE_3)*DATE_DIFF))/SUM(BORC3-BORC_CLOSED_VALUE_3)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK3-ALA_CLOSED_VALUE_3)= 0 THEN SUM(((ALACAK3-ALA_CLOSED_VALUE_3)*DATE_DIFF)) ELSE ROUND((SUM(((ALACAK3-ALA_CLOSED_VALUE_3)*DATE_DIFF))/SUM(ALACAK3-ALA_CLOSED_VALUE_3)),0) END AS VADE_ALACAK,
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				ALL_ROWS.PROJECT_ID PROJECT_ID,
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				ALL_ROWS.ASSETP_ID ASSETP_ID,
			</cfif>
			<cfif isdefined("attributes.is_subscription_group")>
				ALL_ROWS.SUBSCRIPTION_ID SUBSCRIPTION_ID,
			</cfif>
			<cfif isdefined("attributes.is_acc_type_group")>
				ALL_ROWS.ACC_TYPE_ID ACC_TYPE_ID,
			<cfelse>
				0 AS ACC_TYPE_ID,
			</cfif>
				SUM((BORC2-BORC_CLOSED_VALUE_2)-(ALACAK2-ALA_CLOSED_VALUE_2)) BAKIYE2,
				SUM(BORC2-BORC_CLOSED_VALUE_2) BORC2,
				SUM(ALACAK2-ALA_CLOSED_VALUE_2) ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					SUM(BORC_CHEQUE_VOUCHER_VALUE3-ALA_CHEQUE_VOUCHER_VALUE3) CHEQUE_VOUCHER_VALUE3,
					SUM(BORC_CHEQUE_VOUCHER_VALUE_CH3-ALA_CHEQUE_VOUCHER_VALUE_CH3) CHEQUE_VOUCHER_VALUE_CH3,
					SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER3-ALA_CHEQUE_VOUCHER_VALUE_OTHER3) CHEQUE_VOUCHER_VALUE_OTHER3,
				</cfif>
				SUM(BORC_CHEQUE_VOUCHER_VALUE-ALA_CHEQUE_VOUCHER_VALUE) CHEQUE_VOUCHER_VALUE,
				SUM(BORC_CHEQUE_VOUCHER_VALUE2-ALA_CHEQUE_VOUCHER_VALUE2) CHEQUE_VOUCHER_VALUE2,
				SUM(BORC_CHEQUE_VOUCHER_VALUE_CH-ALA_CHEQUE_VOUCHER_VALUE_CH) CHEQUE_VOUCHER_VALUE_CH,
				SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER-ALA_CHEQUE_VOUCHER_VALUE_OTHER) CHEQUE_VOUCHER_VALUE_OTHER,
                SUM(BORC_CHEQUE_VOUCHER_VALUE_CH2-ALA_CHEQUE_VOUCHER_VALUE_CH2) CHEQUE_VOUCHER_VALUE_CH2,				
				SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER2-ALA_CHEQUE_VOUCHER_VALUE_OTHER2) CHEQUE_VOUCHER_VALUE_OTHER2
			FROM 
			(
				SELECT
					SUM(CRS.ACTION_VALUE) BORC1,
					0 ALACAK1,
					SUM(ISNULL(CRS.ACTION_VALUE_2,0)) BORC2,
					0 ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS BORC3,
					0 ALACAK3,
					0 ALA_CHEQUE_VOUCHER_VALUE3,
					0 BORC_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
				<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>		
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				</cfif>
					CRS.TO_CONSUMER_ID CONSUMER_ID,
					C.CONSUMER_NAME CONSUMER_NAME,
					C.CONSUMER_SURNAME CONSUMER_SURNAME,
					C.MEMBER_CODE,
                    C.CONSUMER_WORKTEL CONSUMER_WORKTEL,
                    C.CONSUMER_WORKTELCODE CONSUMER_WORKTELCODE,
					C.WORK_CITY_ID AS CITY,
					1 KONTROL,
					CC.CONSCAT MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					0 ALA_CHEQUE_VOUCHER_VALUE,
					0 ALA_CHEQUE_VOUCHER_VALUE2,
					0 BORC_CHEQUE_VOUCHER_VALUE,
					0 BORC_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
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
					AND CONSUMER_STATUS =<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name) and attributes.member_type is 'consumer'>
					AND	C.CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					AND
					(
						(C.CONSUMER_ID IS NULL) 
						OR (C.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
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
					AND C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.CONSUMER_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
							CRS.DUE_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> )
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
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '4_0'>
					AND C.IS_RELATED_CONSUMER = 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
					AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
				<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
                    C.CONSUMER_WORKTEL,
                    C.CONSUMER_WORKTELCODE,
					C.WORK_CITY_ID,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,CRS.SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,CRS.ACC_TYPE_ID
				</cfif>
			<cfif isdefined("attributes.is_pay_cheques")>
				UNION ALL
				SELECT
					0 BORC1,
					0 ALACAK1,
					0 BORC2,
					0 ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 AS BORC3,
					0 ALACAK3,
					0 ALA_CHEQUE_VOUCHER_VALUE3,
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) BORC_CHEQUE_VOUCHER_VALUE3,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.OTHER_CASH_ACT_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.OTHER_CASH_ACT_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
				<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>		
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				</cfif>
					CRS.TO_CONSUMER_ID CONSUMER_ID,
					C.CONSUMER_NAME CONSUMER_NAME,
					C.CONSUMER_SURNAME CONSUMER_SURNAME,
					C.MEMBER_CODE,
                    C.CONSUMER_WORKTEL CONSUMER_WORKTEL,
                    C.CONSUMER_WORKTELCODE CONSUMER_WORKTELCODE,
					C.WORK_CITY_ID AS CITY,
					1 KONTROL,
					CC.CONSCAT MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					0 AS ALA_CHEQUE_VOUCHER_VALUE,
					0 AS ALA_CHEQUE_VOUCHER_VALUE2,
					SUM(CRS.ACTION_VALUE) BORC_CHEQUE_VOUCHER_VALUE,
					SUM(ISNULL(CRS.ACTION_VALUE_2,0)) BORC_CHEQUE_VOUCHER_VALUE2,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_CH,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.ACTION_VALUE_2)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
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
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					AND
					(
						(C.CONSUMER_ID IS NULL) 
						OR (C.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
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
					AND C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.CONSUMER_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
							CRS.DUE_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
					<cfelse>
						AND
						(
							CRS.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
						AND
						(
							CRS.DUE_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">  OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
					<cfelse>
						AND
						(
							CRS.DUE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> OR
							CRS.DUE_DATE IS NULL
						)
						AND (CRS.ACTION_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> )
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
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '4_0'>
					AND C.IS_RELATED_CONSUMER = 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
					AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
				<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
                    C.CONSUMER_WORKTEL,
                    C.CONSUMER_WORKTELCODE,
					C.WORK_CITY_ID,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,CRS.SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,CRS.ACC_TYPE_ID
				</cfif>
			</cfif>
			UNION ALL
				SELECT
					0 BORC1,		
					SUM(CRS.ACTION_VALUE) ALACAK1,
					0 BORC2,
					SUM(ISNULL(CRS.ACTION_VALUE_2,0)) ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 BORC3,
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALACAK3,
					0 ALA_CHEQUE_VOUCHER_VALUE3,
					0 BORC_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>	
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				</cfif>
					CRS.FROM_CONSUMER_ID CONSUMER_ID,
					C.CONSUMER_NAME CONSUMER_NAME,
					C.CONSUMER_SURNAME CONSUMER_SURNAME,
					C.MEMBER_CODE,
                    C.CONSUMER_WORKTEL CONSUMER_WORKTEL,
                    C.CONSUMER_WORKTELCODE CONSUMER_WORKTELCODE,
					C.WORK_CITY_ID AS CITY,
					1 KONTROL,
					CC.CONSCAT MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					0 ALA_CHEQUE_VOUCHER_VALUE,
					0 ALA_CHEQUE_VOUCHER_VALUE2,
					0 BORC_CHEQUE_VOUCHER_VALUE,
					0 BORC_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
						0 AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
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
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					AND
					(
						(C.CONSUMER_ID IS NULL) 
						OR (C.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
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
					AND C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND (C.CONSUMER_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif> 
                OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '4_0'>
					AND C.IS_RELATED_CONSUMER = 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
					AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
				<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
                    C.CONSUMER_WORKTEL,
                    C.CONSUMER_WORKTELCODE,
					C.WORK_CITY_ID,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,CRS.SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,CRS.ACC_TYPE_ID
				</cfif>
			<cfif isdefined("attributes.is_pay_cheques")>
			UNION ALL
				SELECT
					0 BORC1,		
					0 ALACAK1,
					0 BORC2,
					0 ALACAK2,
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					0 BORC3,
					0 ALACAK3,
					SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALA_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.OTHER_CASH_ACT_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.OTHER_CASH_ACT_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
					<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
				</cfif>	
				<cfif isdefined("attributes.is_project_group")>
					ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
				</cfif>
					CRS.FROM_CONSUMER_ID CONSUMER_ID,
					C.CONSUMER_NAME CONSUMER_NAME,
					C.CONSUMER_SURNAME CONSUMER_SURNAME,
					C.MEMBER_CODE,
                    C.CONSUMER_WORKTEL CONSUMER_WORKTEL,
                    C.CONSUMER_WORKTELCODE CONSUMER_WORKTELCODE,
					C.WORK_CITY_ID AS CITY,
					1 KONTROL,
					CC.CONSCAT MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					SUM(CRS.ACTION_VALUE) ALA_CHEQUE_VOUCHER_VALUE,
					SUM(CRS.ACTION_VALUE_2) ALA_CHEQUE_VOUCHER_VALUE2,
					0 BORC_CHEQUE_VOUCHER_VALUE,
					0 BORC_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
						THEN
							SUM(CRS.ACTION_VALUE_2)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.ACTION_VALUE)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					CASE WHEN (ACTION_TABLE = 'CHEQUE')
					THEN
					(
						CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
						THEN
							SUM(CRS.ACTION_VALUE_2)
						ELSE
							0
						END
					)
					ELSE
					(
						0
					)
					END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
						0 AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
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
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					AND
					(
						(C.CONSUMER_ID IS NULL) 
						OR (C.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					)
				</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
					AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
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
					AND C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
				</cfif>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND C.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">
				</cfif>
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND (C.CONSUMER_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
                    OR C.MEMBER_CODE LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
				<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and attributes.member_cat_type eq '4_0'>
					AND C.IS_RELATED_CONSUMER = 1
				</cfif>
				<cfif len(attributes.project_head) and attributes.project_id eq -1>
					AND CRS.PROJECT_ID IS NULL
				<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
					AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
				<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
					AND	(CRS.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CRS.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
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
                    C.CONSUMER_WORKTEL,
                    C.CONSUMER_WORKTELCODE,
					C.WORK_CITY_ID,
					CRS.ACTION_DATE,
					CRS.DUE_DATE
					,CRS.OTHER_MONEY
				<cfif isdefined("attributes.is_project_group")>
					,CRS.PROJECT_ID
				</cfif>
				<cfif isdefined("attributes.is_asset_group")>
					,CRS.ASSETP_ID
				</cfif>
				<cfif isdefined("attributes.is_subscription_group")>
					,CRS.SUBSCRIPTION_ID
				</cfif>
				<cfif isdefined("attributes.is_acc_type_group")>
					,CRS.ACC_TYPE_ID
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
            ALL_ROWS.CONSUMER_WORKTEL,
            ALL_ROWS.CONSUMER_WORKTELCODE,
			ALL_ROWS.MEMBER_CODE,
			ALL_ROWS.CITY
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				,OTHER_MONEY
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				,PROJECT_ID
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				,ASSETP_ID
			</cfif>
			<cfif isdefined("attributes.is_subscription_group")>
				,SUBSCRIPTION_ID
			</cfif>
			<cfif isdefined("attributes.is_acc_type_group")>
				,ACC_TYPE_ID
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
    <cfif attributes.member_cat_value neq 5>
		<cfif 
            (
                (-
                    (listfind(attributes.member_cat_type,'1_0',',') or listfind(attributes.member_cat_type,'3_0',',') or len(list_company)) 
                    or 
                    (listfind(attributes.member_cat_type,'2_0',',') or listfind(attributes.member_cat_type,'4_0',',') or len(list_consumer))
                ) 
                and 
                (
                    (isDefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listFind(attributes.member_cat_type,'5_0',',')) or (isDefined("attributes.member_cat_value") and attributes.member_cat_value eq 5) or len(list_acc_type_id)
                )
            )
            or 
            (
                not len(attributes.member_cat_type) and not len(attributes.company_id) and not len(attributes.consumer_id)
            )
        >
	    	UNION ALL 
    	</cfif>
    </cfif>    
	<cfif (isDefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listFind(attributes.member_cat_type,'5_0',',')) or (isDefined("attributes.member_cat_value") and attributes.member_cat_value eq 5) or len(list_acc_type_id) or (not len(attributes.member_cat_type) and not len(attributes.company_id) and not len(attributes.consumer_id))><!--- çalışan borç alacak dökümü --->
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
            ALL_ROWS.COMPANY_TEL1 COMPANY_TEL1,
            ALL_ROWS.COMPANY_TELCODE COMPANY_TELCODE,
			ALL_ROWS.CITY,
			EMP_ACCOUNT_CODE,
			2 KONTROL,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				(SELECT SUM(BAKIYE) AS BAKIYE FROM #dsn2_alias#.EMPLOYEE_REMAINDER WHERE EMPLOYEE_ID = ALL_ROWS.EMPLOYEE_ID <cfif isdefined("attributes.is_acc_type_group")>AND ISNULL(EMPLOYEE_REMAINDER.ACC_TYPE_ID,0)=ISNULL(ALL_ROWS.ACC_TYPE_ID,0)</cfif>) MAIN_BAKIYE,
				(SELECT SUM(BORC) AS BORC FROM #dsn2_alias#.EMPLOYEE_REMAINDER WHERE EMPLOYEE_ID = ALL_ROWS.EMPLOYEE_ID <cfif isdefined("attributes.is_acc_type_group")>AND ISNULL(EMPLOYEE_REMAINDER.ACC_TYPE_ID,0)=ISNULL(ALL_ROWS.ACC_TYPE_ID,0)</cfif>) MAIN_BORC,
				(SELECT SUM(ALACAK) AS ALACAK FROM #dsn2_alias#.EMPLOYEE_REMAINDER WHERE EMPLOYEE_ID = ALL_ROWS.EMPLOYEE_ID <cfif isdefined("attributes.is_acc_type_group")>AND ISNULL(EMPLOYEE_REMAINDER.ACC_TYPE_ID,0)=ISNULL(ALL_ROWS.ACC_TYPE_ID,0)</cfif>) MAIN_ALACAK,
			</cfif>	
			SUM(BORC1-ALACAK1) BAKIYE,
			SUM(BORC1) BORC,
			SUM(ALACAK1) ALACAK,
			CASE WHEN SUM(BORC1)= 0 THEN SUM((BORC1*DATE_DIFF)) ELSE ROUND((SUM((BORC1*DATE_DIFF))/SUM(BORC1)),0) END AS VADE_BORC_1,
			CASE WHEN SUM(ALACAK1)= 0 THEN SUM((ALACAK1*DATE_DIFF)) ELSE ROUND((SUM((ALACAK1*DATE_DIFF))/SUM(ALACAK1)),0) END AS VADE_ALACAK_1,
			SUM(BORC1*DATE_DIFF) VADE_BORC_ARATOPLAM,
			SUM(ALACAK1*DATE_DIFF) VADE_ALACAK_ARATOPLAM,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				SUM(BORC3-ALACAK3) BAKIYE3,
				SUM(BORC3) BORC3,
				SUM(ALACAK3) ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK,
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				ALL_ROWS.PROJECT_ID PROJECT_ID,
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				ALL_ROWS.ASSETP_ID ASSETP_ID,
			</cfif>
			<cfif isdefined("attributes.is_subscription_group")>
				ALL_ROWS.SUBSCRIPTION_ID SUBSCRIPTION_ID,
			</cfif>
			<!---	<cfif isdefined("attributes.is_acc_type_group")>--->
					ALL_ROWS.ACC_TYPE_ID ACC_TYPE_ID,
			<!---	<cfelse>
				0 AS ACC_TYPE_ID,
			</cfif> --->
			SUM(BORC2-ALACAK2) BAKIYE2,
			SUM(BORC2) BORC2,
			SUM(ALACAK2) ALACAK2,
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				SUM(BORC_CHEQUE_VOUCHER_VALUE3-ALA_CHEQUE_VOUCHER_VALUE3) CHEQUE_VOUCHER_VALUE3,
				SUM(BORC_CHEQUE_VOUCHER_VALUE_CH3-ALA_CHEQUE_VOUCHER_VALUE_CH3) CHEQUE_VOUCHER_VALUE_CH3,
				SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER3-ALA_CHEQUE_VOUCHER_VALUE_OTHER3) CHEQUE_VOUCHER_VALUE_OTHER3,
			</cfif>
			SUM(BORC_CHEQUE_VOUCHER_VALUE-ALA_CHEQUE_VOUCHER_VALUE) CHEQUE_VOUCHER_VALUE,
			SUM(BORC_CHEQUE_VOUCHER_VALUE2-ALA_CHEQUE_VOUCHER_VALUE2) CHEQUE_VOUCHER_VALUE2,
			SUM(BORC_CHEQUE_VOUCHER_VALUE_CH-ALA_CHEQUE_VOUCHER_VALUE_CH) CHEQUE_VOUCHER_VALUE_CH,			
			SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER-ALA_CHEQUE_VOUCHER_VALUE_OTHER) CHEQUE_VOUCHER_VALUE_OTHER,
            SUM(BORC_CHEQUE_VOUCHER_VALUE_CH2-ALA_CHEQUE_VOUCHER_VALUE_CH2) CHEQUE_VOUCHER_VALUE_CH2,
			SUM(BORC_CHEQUE_VOUCHER_VALUE_OTHER2-ALA_CHEQUE_VOUCHER_VALUE_OTHER2) CHEQUE_VOUCHER_VALUE_OTHER2<!--- Asagida cekildigi icin bu blok kapatildi 20140129 EsraNur ,
			<cfif isdefined("attributes.is_closed_invoice")>
				0 AS ALA_CLOSED_VALUE,
				0 AS ALA_CLOSED_VALUE_2,
				0 AS ALA_CLOSED_VALUE_3
				ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
				ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_2,
				ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
			<cfelse>
				0 AS ALA_CLOSED_VALUE,
				0 AS ALA_CLOSED_VALUE_2,
				0 AS ALA_CLOSED_VALUE_3,
				0 AS BORC_CLOSED_VALUE,
				0 AS BORC_CLOSED_VALUE_2,
				0 AS BORC_CLOSED_VALUE_3
			</cfif>		 --->
		FROM
		(
				SELECT
					E.EMPLOYEE_ID,
					<cfif isdefined("attributes.is_acc_type_group")>
						ISNULL((SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND ((ISNULL(CRS.ACC_TYPE_ID,0) <> 0 AND EIOP.ACC_TYPE_ID = ISNULL(CRS.ACC_TYPE_ID,0)) OR ISNULL(CRS.ACC_TYPE_ID,0) = 0)),(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#)) EMP_ACCOUNT_CODE,
					<cfelse>
						'' AS EMP_ACCOUNT_CODE,
					</cfif>
					(SELECT TOP 1 EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO FROM EMPLOYEES_BANK_ACCOUNTS WHERE E.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID) ACCOUNT_NO,
					SUM(CRS.ACTION_VALUE) BORC1,
					0 ALACAK1,
					SUM(ISNULL(CRS.ACTION_VALUE_2,0)) BORC2,
					0 ALACAK2,
					<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
						SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS BORC3,
						0 ALACAK3,
						0 AS ALA_CHEQUE_VOUCHER_VALUE3,
						0 AS BORC_CHEQUE_VOUCHER_VALUE3,
						0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
						0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
						0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
						0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
						<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
					</cfif>
					<cfif isdefined("attributes.is_project_group")>
						ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
					</cfif>
					<cfif isdefined("attributes.is_asset_group")>
						ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
					</cfif>
					<cfif isdefined("attributes.is_subscription_group")>
						ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
					</cfif>
					<!---	<cfif isdefined("attributes.is_acc_type_group")>--->
							ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
					<!---	</cfif>--->
					CRS.TO_EMPLOYEE_ID MEMBER_ID,
					E.EMPLOYEE_NAME EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
					E.EMPLOYEE_NO MEMBER_CODE,
					E.DIRECT_TEL COMPANY_TEL1,
					E.DIRECT_TELCODE COMPANY_TELCODE,
					0 CITY,
					2 KONTROL,
					'' MEMBERCAT,
					<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
						CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
					<cfelse>
						CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
					</cfif>
					0 AS ALA_CHEQUE_VOUCHER_VALUE,
					0 AS ALA_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE,
					0 AS BORC_CHEQUE_VOUCHER_VALUE2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
					0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
					<cfif isdefined("attributes.is_closed_invoice")>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
						ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_2,
						ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
					<cfelse>
						0 AS ALA_CLOSED_VALUE,
						0 AS ALA_CLOSED_VALUE_2,
						0 AS ALA_CLOSED_VALUE_3,
						0 AS BORC_CLOSED_VALUE,
						0 AS BORC_CLOSED_VALUE_2,
						0 AS BORC_CLOSED_VALUE_3
					</cfif>		
				FROM
					#dsn2#.CARI_ROWS CRS,
					EMPLOYEES E
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						,WORKGROUP_EMP_PAR WEP
					</cfif>
				WHERE
				<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)>
					CRS.TO_EMPLOYEE_ID IS NOT NULL AND
				<cfelse>
					CRS.TO_EMPLOYEE_ID IS NULL AND
				</cfif>
					E.EMPLOYEE_ID = CRS.TO_EMPLOYEE_ID
					<cfif not isdefined("from_rate_valuation")>
						AND CRS.ACTION_VALUE > 0
					</cfif>
					<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
						AND E.EMPLOYEE_ID = WEP.EMPLOYEE_ID
						AND WEP.IS_MASTER = 1
						AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.EMPLOYEE_ID IS NOT NULL
					</cfif>
					<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
						AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
					</cfif>
					<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.member_name) and attributes.member_type is 'employee'>
						AND	E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
					</cfif>
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
						AND CRS.ACC_TYPE_ID = #attributes.acc_type_id#
					</cfif>
					<cfif len(list_acc_type_id)>
						AND CRS.ACC_TYPE_ID IN(#list_acc_type_id#)
					</cfif>
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
						AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
					</cfif>
					<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
						AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
					</cfif>
					<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
						AND E.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
					</cfif>
					<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
						AND (E.EMPLOYEE_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
						OR E.EMPLOYEE_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
									CRS.DUE_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
									CRS.DUE_DATE IS NULL
								)
								AND (CRS.ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
							<cfelse>
								AND
								(
									CRS.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
									CRS.DUE_DATE IS NULL
								)
								AND (CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
							</cfif>
						</cfif>
						<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
							<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
								AND
								(
									CRS.DUE_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">  OR
									CRS.DUE_DATE IS NULL
								)
								AND (CRS.ACTION_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
							<cfelse>
								AND
								(
									CRS.DUE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> OR
									CRS.DUE_DATE IS NULL
								)
								AND (CRS.ACTION_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> )
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
					<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
						AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
					<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
						AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
					
					<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
						AND 
						(
							(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_EMPLOYEE_ID,CRS2.TO_EMPLOYEE_ID) = E.EMPLOYEE_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
							OR 
							(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_EMPLOYEE_ID,CRS2.TO_EMPLOYEE_ID) = E.EMPLOYEE_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
						)
					</cfif>
					
					GROUP BY 
						E.EMPLOYEE_ID,
						CRS.TO_EMPLOYEE_ID,
						CRS.ACTION_TYPE_ID,
						CRS.ACTION_TABLE,
						CRS.CARI_ACTION_ID,
						CRS.ACTION_ID,
						E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME,
						E.EMPLOYEE_NO,
						E.DIRECT_TEL,
						E.DIRECT_TELCODE,
						CRS.ACTION_DATE,
						CRS.DUE_DATE,
						CRS.OTHER_MONEY
					<cfif isdefined("attributes.is_project_group")>
						,CRS.PROJECT_ID
					</cfif>
					<cfif isdefined("attributes.is_asset_group")>
						,CRS.ASSETP_ID
					</cfif>
					<cfif isdefined("attributes.is_subscription_group")>
						,CRS.SUBSCRIPTION_ID
					</cfif>
					<!---	<cfif isdefined("attributes.is_acc_type_group")>---->
						,CRS.ACC_TYPE_ID
					<!---	</cfif>--->
				<cfif isdefined("attributes.is_pay_cheques")>
					UNION ALL
						SELECT
							E.EMPLOYEE_ID,
							<cfif isdefined("attributes.is_acc_type_group")>
								ISNULL((SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND ((ISNULL(CRS.ACC_TYPE_ID,0) <> 0 AND EIOP.ACC_TYPE_ID = ISNULL(CRS.ACC_TYPE_ID,0)) OR ISNULL(CRS.ACC_TYPE_ID,0) = 0)),(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#)) EMP_ACCOUNT_CODE,
							<cfelse>
								'' EMP_ACCOUNT_CODE,
							</cfif>
							(SELECT TOP 1 EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO FROM EMPLOYEES_BANK_ACCOUNTS WHERE E.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID) ACCOUNT_NO,
							0 BORC1,
							0 ALACAK1,
							0 BORC2,
							0 ALACAK2,
						<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
							0 AS BORC3,
							0 ALACAK3,
							0 AS ALA_CHEQUE_VOUCHER_VALUE3,
							SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS BORC_CHEQUE_VOUCHER_VALUE3,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
								THEN
									SUM(CRS.OTHER_CASH_ACT_VALUE)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
								THEN
									SUM(CRS.OTHER_CASH_ACT_VALUE)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
						<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
						</cfif>
						<cfif isdefined("attributes.is_project_group")>
							ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
						</cfif>
						<cfif isdefined("attributes.is_asset_group")>
							ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
						</cfif>
						<cfif isdefined("attributes.is_subscription_group")>
							ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
						</cfif>
					<!---	<cfif isdefined("attributes.is_acc_type_group")>--->
							ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
					<!----	</cfif>--->
							CRS.TO_EMPLOYEE_ID MEMBER_ID,
							E.EMPLOYEE_NAME EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
							E.EMPLOYEE_NO MEMBER_CODE,
							E.DIRECT_TEL COMPANY_TEL1,
							E.DIRECT_TELCODE COMPANY_TELCODE,
							0 CITY,
							2 KONTROL,
							'' MEMBERCAT,
							<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
								CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
							<cfelse>
								CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
							</cfif>
							0 AS ALA_CHEQUE_VOUCHER_VALUE,
							0 AS ALA_CHEQUE_VOUCHER_VALUE2,
							SUM(CRS.ACTION_VALUE) AS BORC_CHEQUE_VOUCHER_VALUE,
							SUM(ISNULL(CRS.ACTION_VALUE_2,0)) AS BORC_CHEQUE_VOUCHER_VALUE2,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
								THEN
									SUM(CRS.ACTION_VALUE)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS BORC_CHEQUE_VOUCHER_VALUE_CH,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
								THEN
									SUM(CRS.ACTION_VALUE_2)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
								THEN
									SUM(CRS.ACTION_VALUE)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
								THEN
									SUM(CRS.ACTION_VALUE_2)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
							<cfif isdefined("attributes.is_closed_invoice")>
								0 AS ALA_CLOSED_VALUE,
								0 AS ALA_CLOSED_VALUE_2,
								0 AS ALA_CLOSED_VALUE_3,
								ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE,
								ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_2,
								ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS BORC_CLOSED_VALUE_3
							<cfelse>
								0 AS ALA_CLOSED_VALUE,
								0 AS ALA_CLOSED_VALUE_2,
								0 AS ALA_CLOSED_VALUE_3,
								0 AS BORC_CLOSED_VALUE,
								0 AS BORC_CLOSED_VALUE_2,
								0 AS BORC_CLOSED_VALUE_3
							</cfif>		
						FROM
							#dsn2#.CARI_ROWS CRS,
							EMPLOYEES E
							<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
								,WORKGROUP_EMP_PAR WEP
							</cfif>
						WHERE
							CRS.TO_EMPLOYEE_ID IS NOT NULL AND
							E.EMPLOYEE_ID = CRS.TO_EMPLOYEE_ID
						<cfif not isdefined("from_rate_valuation")>
							AND CRS.ACTION_VALUE > 0
						</cfif>
						<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
							AND E.EMPLOYEE_ID = WEP.EMPLOYEE_ID
							AND WEP.IS_MASTER = 1
							AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.EMPLOYEE_ID IS NOT NULL
						</cfif>
						<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
							AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
						</cfif>
						<cfif len(list_acc_type_id)>
							AND CRS.ACC_TYPE_ID IN(#list_acc_type_id#)
						</cfif>
						<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.member_name) and attributes.member_type is 'employee'>
							AND	E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfif>
						<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
							AND CRS.ACC_TYPE_ID = #attributes.acc_type_id#
						</cfif>
						<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
							AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
						</cfif>
						<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
							AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
						</cfif>
						<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
							AND E.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
						</cfif>
						<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
							AND (E.EMPLOYEE_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
							OR E.EMPLOYEE_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
									CRS.DUE_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
									CRS.DUE_DATE IS NULL
								)
								AND (CRS.ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
							<cfelse>
								AND
								(
									CRS.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">  OR
									CRS.DUE_DATE IS NULL
								)
								AND (CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
							</cfif>
						</cfif>
						<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
							<cfif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
								AND
								(
									CRS.DUE_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">  OR
									CRS.DUE_DATE IS NULL
								)
								AND (CRS.ACTION_DATE <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
							<cfelse>
								AND
								(
									CRS.DUE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> OR
									CRS.DUE_DATE IS NULL
								)
								AND (CRS.ACTION_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> )
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
						<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
							AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
						
						<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
							AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
						
						<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
							AND 
							(
								(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_EMPLOYEE_ID,CRS2.TO_EMPLOYEE_ID) = E.EMPLOYEE_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
								OR 
								(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_EMPLOYEE_ID,CRS2.TO_EMPLOYEE_ID) = E.EMPLOYEE_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
							)
						</cfif>
						
						GROUP BY 
							E.EMPLOYEE_ID,
							CRS.TO_EMPLOYEE_ID,
							CRS.ACTION_TYPE_ID,
							CRS.ACTION_TABLE,
							CRS.CARI_ACTION_ID,
							CRS.ACTION_ID,
							E.EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME,
							E.EMPLOYEE_NO,
							E.DIRECT_TEL,
							E.DIRECT_TELCODE,
							CRS.ACTION_DATE,
							CRS.DUE_DATE
							,CRS.OTHER_MONEY
						<cfif isdefined("attributes.is_project_group")>
							,CRS.PROJECT_ID
						</cfif>
						<cfif isdefined("attributes.is_asset_group")>
							,CRS.ASSETP_ID
						</cfif>
						<cfif isdefined("attributes.is_subscription_group")>
							,CRS.SUBSCRIPTION_ID
						</cfif>
					<!---	<cfif isdefined("attributes.is_acc_type_group")>--->
							,CRS.ACC_TYPE_ID
					<!---	</cfif>--->
				</cfif>
				<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)>
					UNION ALL
						SELECT
							E.EMPLOYEE_ID,
							<cfif isdefined("attributes.is_acc_type_group")>
								ISNULL((SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND ((ISNULL(CRS.ACC_TYPE_ID,0) <> 0 AND EIOP.ACC_TYPE_ID = ISNULL(CRS.ACC_TYPE_ID,0)) OR ISNULL(CRS.ACC_TYPE_ID,0) = 0)),(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#)) EMP_ACCOUNT_CODE,
							<cfelse>
								'' EMP_ACCOUNT_CODE,
							</cfif>
							(SELECT TOP 1 EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO FROM EMPLOYEES_BANK_ACCOUNTS WHERE E.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID) ACCOUNT_NO,
							0 AS BORC1,		
							SUM(CRS.ACTION_VALUE) ALACAK1,
							0 BORC2,
							SUM(ISNULL(CRS.ACTION_VALUE_2,0)) ALACAK2,
							<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
								0 BORC3,
								SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALACAK3,
								0 AS ALA_CHEQUE_VOUCHER_VALUE3,
								0 AS BORC_CHEQUE_VOUCHER_VALUE3,
								0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
								0 AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
								0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
								0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
								<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
							</cfif>
							<cfif isdefined("attributes.is_project_group")>
								ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
							</cfif>
							<cfif isdefined("attributes.is_asset_group")>
								ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
							</cfif>
							<cfif isdefined("attributes.is_subscription_group")>
								ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
							</cfif>
							<!---	<cfif isdefined("attributes.is_acc_type_group")>--->
								ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
							<!---</cfif>--->
							CRS.FROM_EMPLOYEE_ID MEMBER_ID,
							E.EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME,
							E.EMPLOYEE_NO MEMBER_CODE,
							E.DIRECT_TEL COMPANY_TEL1,
							E.DIRECT_TELCODE COMPANY_TELCODE,
							0 CITY,
							2 KONTROL,
							'' MEMBERCAT,
							<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
								CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
							<cfelse>
								CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
							</cfif>
							0 AS ALA_CHEQUE_VOUCHER_VALUE,
							0 AS ALA_CHEQUE_VOUCHER_VALUE2,
							0 AS BORC_CHEQUE_VOUCHER_VALUE,
							0 AS BORC_CHEQUE_VOUCHER_VALUE2,
							0 AS BORC_CHEQUE_VOUCHER_VALUE_CH,
							0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_CH,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
							0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
							0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
							0 AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
							<cfif isdefined("attributes.is_closed_invoice")>
								ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
								ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_2,
								ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
								0 AS BORC_CLOSED_VALUE,
								0 AS BORC_CLOSED_VALUE_2,
								0 AS BORC_CLOSED_VALUE_3
							<cfelse>
								0 AS ALA_CLOSED_VALUE,
								0 AS ALA_CLOSED_VALUE_2,
								0 AS ALA_CLOSED_VALUE_3,
								0 AS BORC_CLOSED_VALUE,
								0 AS BORC_CLOSED_VALUE_2,
								0 AS BORC_CLOSED_VALUE_3
							</cfif>		
						FROM
							#dsn2#.CARI_ROWS CRS,
							EMPLOYEES E
							<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
								,WORKGROUP_EMP_PAR WEP
							</cfif>
						WHERE
							CRS.FROM_EMPLOYEE_ID IS NOT NULL AND
							E.EMPLOYEE_ID = CRS.FROM_EMPLOYEE_ID
							<cfif not isdefined("from_rate_valuation")>
								AND CRS.ACTION_VALUE > 0
							</cfif>
							<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
								AND E.EMPLOYEE_ID = WEP.EMPLOYEE_ID
								AND WEP.IS_MASTER = 1
								AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.EMPLOYEE_ID IS NOT NULL
							</cfif>
							<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
								AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
							</cfif>
							<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.member_name) and attributes.member_type is 'employee'>
								AND	E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
							</cfif>
							<cfif len(list_acc_type_id)>
								AND CRS.ACC_TYPE_ID IN(#list_acc_type_id#)
							</cfif>
							<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
								AND CRS.ACC_TYPE_ID = #attributes.acc_type_id#
							</cfif>
							<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
								AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
							</cfif>
							<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
								AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
							</cfif>
							<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
								AND E.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
							</cfif>
							<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
								AND (E.EMPLOYEE_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
								OR E.EMPLOYEE_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
							<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
								AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
						
							<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
								AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
							
							<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
								AND 
								(
									(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_EMPLOYEE_ID,CRS2.TO_EMPLOYEE_ID) = E.EMPLOYEE_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
									OR 
									(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_EMPLOYEE_ID,CRS2.TO_EMPLOYEE_ID) = E.EMPLOYEE_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
								)
							</cfif>
						GROUP BY 
							E.EMPLOYEE_ID,
							CRS.FROM_EMPLOYEE_ID,
							CRS.ACTION_TYPE_ID,
							CRS.ACTION_TABLE,
							CRS.CARI_ACTION_ID,
							CRS.ACTION_ID,
							E.EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME,
							E.EMPLOYEE_NO,
							E.DIRECT_TEL,
							E.DIRECT_TELCODE,
							CRS.ACTION_DATE,
							CRS.DUE_DATE
							,CRS.OTHER_MONEY
							<cfif isdefined("attributes.is_project_group")>
								,CRS.PROJECT_ID
							</cfif>
							<cfif isdefined("attributes.is_asset_group")>
								,CRS.ASSETP_ID
							</cfif>
							<cfif isdefined("attributes.is_subscription_group")>
								,CRS.SUBSCRIPTION_ID
							</cfif>
							<!---	<cfif isdefined("attributes.is_acc_type_group")>--->
								,CRS.ACC_TYPE_ID
							<!---	</cfif> --->
				</cfif>
				<cfif isdefined("attributes.is_pay_cheques")>
					UNION ALL		
						SELECT
							E.EMPLOYEE_ID,
							<cfif isdefined("attributes.is_acc_type_group")>
								ISNULL((SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT EIO,EMPLOYEES_ACCOUNTS EIOP WHERE EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIOP.PERIOD_ID = #session.ep.period_id# AND ((ISNULL(CRS.ACC_TYPE_ID,0) <> 0 AND EIOP.ACC_TYPE_ID = ISNULL(CRS.ACC_TYPE_ID,0)) OR ISNULL(CRS.ACC_TYPE_ID,0) = 0)),(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID AND EIOP.PERIOD_ID = #session.ep.period_id#)) EMP_ACCOUNT_CODE,
							<cfelse>
								'' EMP_ACCOUNT_CODE,
							</cfif>
							(SELECT TOP 1 EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO FROM EMPLOYEES_BANK_ACCOUNTS WHERE E.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID) ACCOUNT_NO,
							0 AS BORC1,		
							0 ALACAK1,
							0 BORC2,
							0 ALACAK2,
							<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
								0 BORC3,
								0 AS ALACAK3,
								SUM(ISNULL(CRS.OTHER_CASH_ACT_VALUE,CRS.ACTION_VALUE_2)) AS ALA_CHEQUE_VOUCHER_VALUE3,
								0 AS BORC_CHEQUE_VOUCHER_VALUE3 ,
								0 AS BORC_CHEQUE_VOUCHER_VALUE_CH3,
								CASE WHEN (ACTION_TABLE = 'CHEQUE')
								THEN
								(
									CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
									THEN
										SUM(CRS.OTHER_CASH_ACT_VALUE)
									ELSE
										0
									END
								)
								ELSE
								(
									0
								)
								END AS ALA_CHEQUE_VOUCHER_VALUE_CH3,
								0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER3,
								CASE WHEN (ACTION_TABLE = 'CHEQUE')
								THEN
								(
									CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
									THEN
										SUM(CRS.OTHER_CASH_ACT_VALUE)
									ELSE
										0
									END
								)
								ELSE
								(
									0
								)
								END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER3,
								<cfif len(session.ep.money2)>ISNULL(CRS.OTHER_MONEY,'#session.ep.money2#')<cfelse>CRS.OTHER_MONEY</cfif> OTHER_MONEY,
							</cfif>
							<cfif isdefined("attributes.is_project_group")>
								ISNULL(CRS.PROJECT_ID,0) PROJECT_ID,
							</cfif>
							<cfif isdefined("attributes.is_asset_group")>
								ISNULL(CRS.ASSETP_ID,0) ASSETP_ID,
							</cfif>
							<cfif isdefined("attributes.is_subscription_group")>
								ISNULL(CRS.SUBSCRIPTION_ID,0) SUBSCRIPTION_ID,
							</cfif>
							<!---	<cfif isdefined("attributes.is_acc_type_group")>--->
									ISNULL(CRS.ACC_TYPE_ID,0) ACC_TYPE_ID,
							<!---	</cfif>--->
							CRS.FROM_EMPLOYEE_ID MEMBER_ID,
							E.EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME,
							E.EMPLOYEE_NO MEMBER_CODE,
							E.DIRECT_TEL COMPANY_TEL1,
							E.DIRECT_TELCODE COMPANY_TELCODE,
							0 CITY,
							2 KONTROL,
							'' MEMBERCAT,
							<cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
								CASE WHEN DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,CRS.ACTION_DATE,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE)) END AS DATE_DIFF,
							<cfelse>
								CASE WHEN DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(CRS.DUE_DATE,CRS.ACTION_DATE),GETDATE()) END AS DATE_DIFF,
							</cfif>
							SUM(ACTION_VALUE) AS ALA_CHEQUE_VOUCHER_VALUE,
							SUM(ACTION_VALUE_2) AS ALA_CHEQUE_VOUCHER_VALUE2,
							0 AS BORC_CHEQUE_VOUCHER_VALUE,
							0 AS BORC_CHEQUE_VOUCHER_VALUE2,
							0 BORC_CHEQUE_VOUCHER_VALUE_CH,
							0 AS BORC_CHEQUE_VOUCHER_VALUE_CH2,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
								THEN
									SUM(CRS.ACTION_VALUE)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS ALA_CHEQUE_VOUCHER_VALUE_CH,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 1)
								THEN
									SUM(CRS.ACTION_VALUE_2)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS ALA_CHEQUE_VOUCHER_VALUE_CH2,
							0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER,
							0 AS BORC_CHEQUE_VOUCHER_VALUE_OTHER2,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
								THEN
									SUM(CRS.ACTION_VALUE)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER,
							CASE WHEN (ACTION_TABLE = 'CHEQUE')
							THEN
							(
								CASE WHEN(ISNULL((SELECT CHEQUE.SELF_CHEQUE FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = CRS.ACTION_ID),0) = 0)
								THEN
									SUM(CRS.ACTION_VALUE_2)
								ELSE
									0
								END
							)
							ELSE
							(
								0
							)
							END AS ALA_CHEQUE_VOUCHER_VALUE_OTHER2,
							<cfif isdefined("attributes.is_closed_invoice")>
								ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE,
								ISNULL((SELECT SUM(CLOSED_AMOUNT)/(SUM(ISNULL(CRS.ACTION_VALUE,0))/#dsn_alias#.IS_ZERO(SUM(ISNULL(CRS.ACTION_VALUE_2,1)),SUM(CRS.ACTION_VALUE))) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_2,
								ISNULL((SELECT SUM(OTHER_CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CRS.ACTION_TYPE_ID AND ((CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CRS.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CRS.ACTION_TABLE = 'INVOICE' OR CRS.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CRS.DUE_DATE = C_CL_R.DUE_DATE) OR (CRS.ACTION_TABLE <> 'INVOICE' AND CRS.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CRS.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CRS.ACTION_ID),0) AS ALA_CLOSED_VALUE_3,
								0 AS BORC_CLOSED_VALUE,
								0 AS BORC_CLOSED_VALUE_2,
								0 AS BORC_CLOSED_VALUE_3
							<cfelse>
								0 AS ALA_CLOSED_VALUE,
								0 AS ALA_CLOSED_VALUE_2,
								0 AS ALA_CLOSED_VALUE_3,
								0 AS BORC_CLOSED_VALUE,
								0 AS BORC_CLOSED_VALUE_2,
								0 AS BORC_CLOSED_VALUE_3
							</cfif>					
						FROM
							#dsn2#.CARI_ROWS CRS,
							EMPLOYEES E,
							EMPLOYEES_IN_OUT EIO
							<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
								,WORKGROUP_EMP_PAR WEP
							</cfif>
						WHERE
							CRS.FROM_EMPLOYEE_ID IS NOT NULL AND
							E.EMPLOYEE_ID = CRS.FROM_EMPLOYEE_ID
							<cfif not isdefined("from_rate_valuation")>
								AND CRS.ACTION_VALUE > 0
							</cfif>
							<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text) and isdefined('attributes.pos_code') and  len(attributes.pos_code)>
								AND E.EMPLOYEE_ID = WEP.EMPLOYEE_ID
								AND WEP.IS_MASTER = 1
								AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.EMPLOYEE_ID IS NOT NULL
							</cfif>
							<cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
								AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
							</cfif>
							<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.member_name) and attributes.member_type is 'employee'>
								AND	E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
							</cfif>
							<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
								AND CRS.ACC_TYPE_ID = #attributes.acc_type_id#
							</cfif>
							<cfif len(list_acc_type_id)>
								AND CRS.ACC_TYPE_ID IN(#list_acc_type_id#)
							</cfif>
							<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
								AND CRS.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
							</cfif>
							<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
								AND CRS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
							</cfif>
							<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
								AND E.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ozel_kod#%">
							</cfif>
							<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
								AND (E.EMPLOYEE_NAME LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif> 
								OR E.EMPLOYEE_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>)
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
							<cfelseif len(attributes.project_head) and attributes.project_id eq -2> <!--- tüm projeler gelsin --->
								AND CRS.PROJECT_ID IS NOT NULL AND CRS.PROJECT_ID <> -1
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
							
							<cfif session.ep.isBranchAuthorization and is_show_store_acts eq 0>
								AND	(CRS.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#"> OR CRS.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(session.ep.user_location,2,'-')#">)
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
							
							<cfif isdefined('attributes.valuation_date') and len(attributes.valuation_date)>
								AND 
								(
									(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_EMPLOYEE_ID,CRS2.TO_EMPLOYEE_ID) = E.EMPLOYEE_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valuation_date#">
									OR 
									(SELECT TOP 1 CRS2.ACTION_DATE FROM #dsn2#.CARI_ROWS CRS2 WHERE ISNULL(CRS2.FROM_EMPLOYEE_ID,CRS2.TO_EMPLOYEE_ID) = E.EMPLOYEE_ID AND CRS2.ACTION_TYPE_ID IN(45,46) ORDER BY CRS2.ACTION_DATE DESC) IS NULL
								)
							</cfif>
						
						GROUP BY 
							E.EMPLOYEE_ID,
							CRS.FROM_EMPLOYEE_ID,
							CRS.ACTION_TYPE_ID,
							CRS.ACTION_TABLE,
							CRS.CARI_ACTION_ID,
							CRS.ACTION_ID,
							E.EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME,
							E.EMPLOYEE_NO,
							E.DIRECT_TEL,
							E.DIRECT_TELCODE,
							CRS.ACTION_DATE,
							CRS.DUE_DATE
							,CRS.OTHER_MONEY
						<cfif isdefined("attributes.is_project_group")>
							,CRS.PROJECT_ID
						</cfif>
						<cfif isdefined("attributes.is_asset_group")>
							,CRS.ASSETP_ID
						</cfif>
						<cfif isdefined("attributes.is_subscription_group")>
							,CRS.SUBSCRIPTION_ID
						</cfif>
					<!---	<cfif isdefined("attributes.is_acc_type_group")>--->
							,CRS.ACC_TYPE_ID
					<!---	</cfif>--->
				</cfif>
			)
			AS ALL_ROWS
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
            ALL_ROWS.COMPANY_TEL1,
            ALL_ROWS.COMPANY_TELCODE,
			ALL_ROWS.CITY,
            ALL_ROWS.EMPLOYEE_ID,
			ALL_ROWS.EMP_ACCOUNT_CODE
			<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
				,OTHER_MONEY
			</cfif>
			<cfif isdefined("attributes.is_project_group")>
				,PROJECT_ID
			</cfif>
			<cfif isdefined("attributes.is_asset_group")>
				,ASSETP_ID
			</cfif>
			<cfif isdefined("attributes.is_subscription_group")>
				,SUBSCRIPTION_ID
			</cfif>
			<!---<cfif isdefined("attributes.is_acc_type_group")>--->
				,ACC_TYPE_ID
			<!--- </cfif>--->
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
	<cfif isdefined("print_order_money_info")><!--- Printten geliyor silmeyin --->
	ORDER BY BAKIYE3 DESC
	<cfelse>
		<cfif isDefined('attributes.order_type') and attributes.order_type eq 1>
			ORDER BY FULLNAME,MEMBER_ID
		<cfelseif isDefined('attributes.order_type') and attributes.order_type eq 2>
			<cfif attributes.duty_claim eq 1>
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					ORDER BY MAIN_BAKIYE ASC
				<cfelse>
					ORDER BY BAKIYE ASC
				</cfif>
			<cfelse>
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					ORDER BY MAIN_BAKIYE DESC
				<cfelse>
					ORDER BY BAKIYE DESC
				</cfif>
			</cfif>
		<cfelseif isDefined('attributes.order_type') and attributes.order_type eq 3>
			<cfif attributes.duty_claim eq 1>
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					ORDER BY MAIN_BAKIYE DESC
				<cfelse>
					ORDER BY BAKIYE DESC
				</cfif>	
			<cfelse>
				<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
					ORDER BY MAIN_BAKIYE ASC
				<cfelse>
					ORDER BY BAKIYE ASC
				</cfif>
			</cfif>
		<cfelseif isdefined('attributes.order_type') and attributes.order_type eq 4>
			ORDER BY MEMBERCAT,FULLNAME
		</cfif>
		<cfif isdefined('attributes.is_project_group')>
			,PROJECT_ID
		</cfif>
		<cfif isdefined('attributes.is_asset_group')>
			,ASSETP_ID
		</cfif>
		<cfif isdefined('attributes.is_subscription_group')>
			,SUBSCRIPTION_ID
		</cfif>
		<cfif isdefined('attributes.is_acc_type_group')>
			,ACC_TYPE_ID
		</cfif>
	</cfif>
</cfquery>
<cfsetting showdebugoutput="yes">