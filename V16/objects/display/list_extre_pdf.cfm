<!--- Toplu ekstre alındığında sayfayı PDF e aktarmak için eklenen ekstre sayfasıdır. 20070713 SM --->
<cfparam name="attributes.list_type" default="">
<cfset session_base = evaluate('session.ep')>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session_base.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfif isdefined("attributes.is_page") and attributes.is_page eq 1>
	<cfset action = "#listgetat(attributes.fuseaction,1,'.')#.list_extre">
	<cfset action1 = "#listgetat(attributes.fuseaction,1,'.')#.emptypopup_list_extre">
<cfelse>
	<cfset action = "objects.popup_list_extre">
	<cfset action1 = "objects.emptypopup_list_extre">
</cfif>
<cfif isdefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
	<cf_date tarih = "attributes.due_date_2">
</cfif>
<cfif isdefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
	<cf_date tarih = "attributes.action_date_1">
</cfif>
<cfif isdefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
	<cf_date tarih = "attributes.action_date_2">
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih = "attributes.date1">
<cfelse>
	<cfset date1="01/01/#session_base.period_year#">
	<cfparam name="attributes.date1" default="#date1#">
</cfif>
<cfif isdefined('attributes.date2') and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date2">
<cfelse>
	<cfset date2 = "31/12/#session_base.period_year#">
	<cfparam name="attributes.date2" default="#date2#">
</cfif>
<cfif session.ep.isBranchAuthorization>
	<cfset module_name = 'ch'>
	<cfset module = 32>
<cfelse>
	<cfset module_name = 'ch'>
	<cfset module = 23>
</cfif>
<cfif isDefined('session.pp.userid')>
	<cfset invoice_partner_link = "objects.popup_detail_invoice">
</cfif>
<cfset yilbasi = createodbcdatetime('#session_base.period_year#-01-01')>
<cfset min_name = ''>
<cfset max_name = ''>
<cfif isdefined("attributes.is_collacted") and attributes.is_collacted eq 1>
  	 <cfif isdefined("attributes.comp_name") and len(attributes.comp_name)>
		 <cfset max_name = attributes.comp_name>
		 <cfif isdefined("attributes.comp_name2") and len(attributes.comp_name2)>
			 <cfset min_name = attributes.comp_name2>
			 <cfif max_name lt min_name and len(min_name)>
				<cfset max_name = attributes.comp_name2>
				<cfset min_name = attributes.comp_name>
			 </cfif>
		 </cfif>
		<cfif len(attributes.COMPANY_ID) and attributes.member_type eq 'partner'>
			   <cfquery name="GET_CMP_IDS" datasource="#dsn#">
					SELECT 
						COMPANY.COMPANY_ID,
						FULLNAME,
						POSITION_CODE
					FROM 
						COMPANY,
						WORKGROUP_EMP_PAR
					WHERE
						<cfif len(max_name) and LEN(min_name)>
							FULLNAME >= '#min_name#' AND 
							FULLNAME <= '#max_name#'
						<cfelseif LEN(max_name)>
							FULLNAME >= '#max_name#' 
						</cfif>
						AND WORKGROUP_EMP_PAR.COMPANY_ID = COMPANY.COMPANY_ID
						AND WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL 
						AND WORKGROUP_EMP_PAR.OUR_COMPANY_ID = #session.ep.company_id# 
						AND WORKGROUP_EMP_PAR.IS_MASTER = 1
						AND COMPANY_STATUS = 1
					UNION ALL
					SELECT 
						COMPANY.COMPANY_ID,
						FULLNAME,
						'' POSITION_CODE 
					FROM 
						COMPANY
					WHERE
						<cfif len(max_name) and LEN(min_name)>
							FULLNAME >= '#min_name#' AND 
							FULLNAME <= '#max_name#'
						<cfelseif LEN(max_name)>
							FULLNAME >= '#max_name#' 
						</cfif>
						AND COMPANY.COMPANY_ID NOT IN(SELECT COMPANY_ID FROM WORKGROUP_EMP_PAR WHERE COMPANY_ID IS NOT NULL AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_MASTER = 1)
						AND COMPANY_STATUS = 1	
					ORDER BY
						<cfif isdefined("attributes.is_pos_group")>
						POSITION_CODE,	
						</cfif>
						FULLNAME
			  </cfquery> 
		<cfelseif len(attributes.consumer_id)  and attributes.member_type eq 'consumer'> 
			 <cfquery name="GET_CMP_IDS" datasource="#dsn#">
					SELECT 
						CONSUMER_ID COMPANY_ID,
						CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME
					FROM 
						CONSUMER
					WHERE
						<cfif len(max_name) and LEN(min_name)>
							CONSUMER_NAME + ' ' +CONSUMER_SURNAME >= '#min_name#' AND 
							CONSUMER_NAME + ' ' +CONSUMER_SURNAME <= '#max_name#'
						<cfelseif LEN(max_name)>
							CONSUMER_NAME + ' ' +CONSUMER_SURNAME >= '#max_name#' 
						</cfif>
						AND CONSUMER_STATUS = 1
					ORDER BY
						FULLNAME
		  </cfquery> 
		<cfelseif len(attributes.employee_id) and attributes.member_type eq 'employee'>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
					SELECT 
						EMPLOYEE_ID COMPANY_ID,
						EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME FULLNAME
					FROM 
						EMPLOYEES
					WHERE
						<cfif len(max_name) and LEN(min_name)>
							EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#min_name#' AND 
							EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME <= '#max_name#'
						<cfelseif LEN(max_name)>
							EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#max_name#' 
						</cfif>
						AND EMPLOYEE_STATUS = 1
					ORDER BY
						FULLNAME
		  </cfquery> 
		</cfif> 
	<cfelseif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') eq '1'>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
					SELECT 
						COMPANY.COMPANY_ID,
						FULLNAME,
						POSITION_CODE
					FROM 
						COMPANY,
						WORKGROUP_EMP_PAR
					WHERE
						COMPANY.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#) AND
						WORKGROUP_EMP_PAR.COMPANY_ID = COMPANY.COMPANY_ID AND
						WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL AND
						WORKGROUP_EMP_PAR.OUR_COMPANY_ID = #session.ep.company_id# AND
						WORKGROUP_EMP_PAR.IS_MASTER = 1 AND
						COMPANY_STATUS = 1
					UNION ALL
					SELECT 
						COMPANY.COMPANY_ID,
						FULLNAME,
						'' POSITION_CODE 
					FROM 
						COMPANY
					WHERE
						COMPANY.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#)
						AND COMPANY.COMPANY_ID NOT IN(SELECT COMPANY_ID FROM WORKGROUP_EMP_PAR WHERE COMPANY_ID IS NOT NULL AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_MASTER = 1)
						AND COMPANY_STATUS = 1	
					ORDER BY
						<cfif isdefined("attributes.is_pos_group")>
						POSITION_CODE,	
						</cfif>
						FULLNAME
			  </cfquery> 	
	<cfelseif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') eq '2'>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
					SELECT 
						CONSUMER_ID COMPANY_ID,
						CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME
					FROM 
						CONSUMER
					WHERE
						CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(attributes.member_cat_type,'-')#) 
						AND CONSUMER_STATUS = 1
					ORDER BY
						FULLNAME
			  </cfquery> 
	 <cfelseif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>	
	 		<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT
					C.COMPANY_ID,
					C.FULLNAME,
					WP.POSITION_CODE
				FROM
					WORKGROUP_EMP_PAR WP,
					COMPANY C
				WHERE
					WP.COMPANY_ID = C.COMPANY_ID AND
					WP.COMPANY_ID IS NOT NULL AND
					WP.OUR_COMPANY_ID = #session.ep.company_id# AND
					WP.IS_MASTER = 1 AND
					WP.POSITION_CODE = #attributes.pos_code#
				ORDER BY
					WP.POSITION_CODE
		  </cfquery> 		
	 </cfif>
<cfelseif isdefined("attributes.member_type") and attributes.member_type is 'partner'>
	<cfquery name="GET_CMP_IDS" datasource="#dsn#">
	SELECT 
		COMPANY_ID,
		FULLNAME 
	FROM 
		COMPANY 
	WHERE
		COMPANY_ID = #attributes.company_id#
  </cfquery>  
<cfelseif isdefined("attributes.member_type") and attributes.member_type is 'consumer'>
	<cfquery name="GET_CMP_IDS" datasource="#dsn#">
	SELECT 
		CONSUMER_ID COMPANY_ID,
		CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME
	FROM 
		CONSUMER 
	WHERE
		CONSUMER_ID = #attributes.consumer_id#
  </cfquery> 
<cfelseif isdefined("attributes.member_type") and attributes.member_type is 'employee'>
	<cfquery name="GET_CMP_IDS" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID COMPANY_ID,
		EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME FULLNAME
	FROM 
		EMPLOYEES 
	WHERE
		EMPLOYEE_ID = #attributes.employee_id#
  </cfquery>   
</cfif>
<cfif isdefined('attributes.is_make_age')>
	<cfif listfind(attributes.list_type,9) and not (isdefined("attributes.is_collacted") and attributes.is_collacted eq 1)>
		<cfinclude template="dsp_extre_summary.cfm">
	</cfif>
	<cfinclude template="dsp_make_age.cfm">
<cfelse>
	<cfif isdefined('attributes.form_submit')>	
		<cfquery name="get_periods" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				SETUP_PERIOD 
			WHERE 
				OUR_COMPANY_ID = #session_base.company_id# AND
				PERIOD_YEAR >= #dateformat(attributes.date1,'yyyy')# 
				AND PERIOD_YEAR <= #dateformat(attributes.date2,'yyyy')#
			ORDER BY 
				OUR_COMPANY_ID,
				PERIOD_YEAR 
		</cfquery> 
		<cfdocument format="pdf" orientation="portrait" backgroundvisible="false" pagetype="custom" unit="cm" pageheight="28" pagewidth="21">
			<style type="text/css">
				table{font-size:7px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : #333333;}
			</style>
			<cfset filename1 = "#createuuid()#">
			<cfheader name="Content-Disposition" value="attachment; filename=#filename1#.pdf">
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
			<cfif GET_CMP_IDS.recordcount> 
			<cfloop query="GET_CMP_IDS">
			<cfset pos_code_ = get_cmp_ids.position_code>
			<cfset attributes.COMPANY_ID=COMPANY_ID>
			<cfset attributes.CONSUMER_ID=COMPANY_ID>
			<cfset attributes.EMPLOYEE_ID=COMPANY_ID>
			<cfset attributes.company=fullname>
			<cfloop query="get_periods"> 
				<cfset new_dsn = '#dsn#_#get_periods.PERIOD_YEAR#_#get_periods.OUR_COMPANY_ID#'>
				<cfif isdefined('attributes.form_submit')>	
					<cfif listfind(attributes.list_type,4)>
						<cfquery name="GET_PAYMETHOD" datasource="#dsn#">
							SELECT PAYMETHOD_ID,DUE_DAY,DUE_MONTH FROM SETUP_PAYMETHOD ORDER BY PAYMETHOD_ID
						</cfquery>
						<cfset pay_method_id_list = ''>
						<cfset pay_method_gun_list = ''>
						<cfoutput query="GET_PAYMETHOD">
							<cfif len(DUE_DAY)>
								<cfset pay_method_id_list = listappend(pay_method_id_list,PAYMETHOD_ID,',')>
								<cfset pay_method_gun_list = listappend(pay_method_gun_list,DUE_DAY,',')>
							<cfelseif len(DUE_MONTH)>
								<cfset pay_method_id_list = listappend(pay_method_id_list,PAYMETHOD_ID,',')>
								<cfset pay_method_gun_list = listappend(pay_method_gun_list,(DUE_MONTH*30)/2,',')>
							</cfif>
						</cfoutput>
					</cfif>
					<cfquery name="CARI_ROWS_ALL" datasource="#new_dsn#">
						SELECT 
							CR.ACTION_ID,
							CR.ACTION_TYPE_ID,
							CR.ACTION_TABLE,
							CR.OTHER_MONEY,
							CR.PAPER_NO,
							CR.ACTION_NAME,
							CR.PROCESS_CAT,
							CR.PROJECT_ID,
							CR.TO_CMP_ID,
							CR.TO_CONSUMER_ID,
							CR.DUE_DATE,
							CR.ACTION_DETAIL,
							CR.ACTION_DATE AS ACTION_DATE, 
							0 AS BORC, 
							0 AS BORC2,
							0 AS BORC_OTHER,
							CR.ACTION_VALUE AS ALACAK,
							CR.ACTION_VALUE_2 AS ALACAK2,
							CR.OTHER_CASH_ACT_VALUE AS ALACAK_OTHER,
							0 AS PAY_METHOD,
							CR.IS_PROCESSED,
							0 DETAIL_TYPE,
							'' STOCK_CODE,
							'' NAME_PRODUCT,
							0 AMOUNT,
							'' UNIT,
							0 PRICE,
							0 TAX,
							0 GROSSTOTAL
						FROM 
							CARI_ROWS CR
						WHERE 
							ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
							<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
								AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
							</cfif>
							<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
								AND CR.FROM_CMP_ID = #attributes.COMPANY_ID#
							<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
								AND CR.FROM_CONSUMER_ID = #attributes.consumer_id#
							<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
								AND CR.FROM_EMPLOYEE_ID = #attributes.employee_id#
							</cfif>
							<cfif isDefined("attributes.action_type") and len(attributes.action_type)>
								AND ACTION_TYPE_ID = #attributes.action_type# 
							</cfif>
							<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
								AND OTHER_MONEY = '#attributes.other_money#'
							</cfif>
							<cfif session.ep.isBranchAuthorization or isdefined("is_store_module")>
								AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
								AND CR.PROJECT_ID = #attributes.project_id#
							</cfif>
							<cfif isdefined("attributes.is_pay_cheques")>
								AND
								(
								(CR.ACTION_TABLE = 'CHEQUE' AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7,4,9,8)))
								OR	
								(CR.ACTION_TABLE = 'PAYROLL' AND CR.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM CHEQUE C,CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CR.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND  C.CHEQUE_STATUS_ID IN (3,7,4,9,8)))
								OR 
								(CR.ACTION_TABLE = 'VOUCHER' AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7,4,9,8)))
								OR	
								(CR.ACTION_TABLE = 'VOUCHER_PAYROLL' AND CR.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM VOUCHER V,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CR.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND  V.VOUCHER_STATUS_ID IN (3,7,4,9,8)))
								OR 
								(CR.ACTION_TABLE <> 'PAYROLL' AND CR.ACTION_TABLE <> 'CHEQUE' AND CR.ACTION_TABLE <> 'VOUCHER' AND CR.ACTION_TABLE <> 'VOUCHER_PAYROLL')
								)			
							</cfif>
						UNION ALL
					
						SELECT
							CR.ACTION_ID,
							CR.ACTION_TYPE_ID,
							CR.ACTION_TABLE,
							CR.OTHER_MONEY,
							CR.PAPER_NO,
							CR.ACTION_NAME,
							CR.PROCESS_CAT,
							CR.PROJECT_ID,
							CR.TO_CMP_ID,
							CR.TO_CONSUMER_ID,
							CR.DUE_DATE,
							CR.ACTION_DETAIL,
							CR.ACTION_DATE AS ACTION_DATE, 
							CR.ACTION_VALUE AS BORC,
							CR.ACTION_VALUE_2 AS BORC2,
							CR.OTHER_CASH_ACT_VALUE AS BORC_OTHER,
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
							0 GROSSTOTAL
						FROM 
							CARI_ROWS CR
						WHERE
							ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
							<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
								AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
							</cfif>
							<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
								AND CR.TO_CMP_ID = #attributes.COMPANY_ID#
							<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
								AND CR.TO_CONSUMER_ID = #attributes.consumer_id#
							<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
								AND CR.TO_EMPLOYEE_ID = #attributes.employee_id#
							</cfif>
							<cfif isDefined("attributes.action_type") and len(attributes.action_type)>
								AND ACTION_TYPE_ID = #attributes.action_type# 
							</cfif>
							<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
								AND OTHER_MONEY = '#attributes.other_money#' 
							</cfif>
							<cfif session.ep.isBranchAuthorization or isdefined("is_store_module")>
								AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
								AND CR.PROJECT_ID = #attributes.project_id#
							</cfif>
							<cfif isdefined("attributes.is_pay_cheques")>
								AND
								(
								(CR.ACTION_TABLE = 'CHEQUE' AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7,4,9,8)))
								OR	
								(CR.ACTION_TABLE = 'PAYROLL' AND CR.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM CHEQUE C,CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CR.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND  C.CHEQUE_STATUS_ID IN (3,7,4,9,8)))
								OR 
								(CR.ACTION_TABLE = 'VOUCHER' AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7,4,9,8)))
								OR	
								(CR.ACTION_TABLE = 'VOUCHER_PAYROLL' AND CR.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM VOUCHER V,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CR.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND  V.VOUCHER_STATUS_ID IN (3,7,4,9,8)))
								OR 
								(CR.ACTION_TABLE <> 'PAYROLL' AND CR.ACTION_TABLE <> 'CHEQUE' AND CR.ACTION_TABLE <> 'VOUCHER' AND CR.ACTION_TABLE <> 'VOUCHER_PAYROLL')
								)			
							</cfif>
					<cfif listfind(attributes.list_type,10)>
						UNION ALL
							SELECT
								CR.ACTION_ID,
								CR.ACTION_TYPE_ID,
								CR.ACTION_TABLE,
								CR.OTHER_MONEY,
								CR.PAPER_NO,
								CR.ACTION_NAME,
								CR.PROCESS_CAT,
								CR.PROJECT_ID,
								CR.TO_CMP_ID,
								CR.TO_CONSUMER_ID,
								CR.DUE_DATE,
								CR.ACTION_DETAIL,
								CR.ACTION_DATE, 
								0 BORC,
								0 BORC2,
								0 BORC_OTHER,
								0 ALACAK,
								0 ALACAK2,
								0 ALACAK_OTHER,
								0 PAY_METHOD,
								0 IS_PROCESSED,
								1 DETAIL_TYPE,
								S.STOCK_CODE,
								INVOICE_ROW.NAME_PRODUCT,
								INVOICE_ROW.AMOUNT,
								INVOICE_ROW.UNIT,
								INVOICE_ROW.PRICE,
								INVOICE_ROW.TAX,
								INVOICE_ROW.GROSSTOTAL
							FROM 
								CARI_ROWS CR,
								INVOICE,
								INVOICE_ROW,
								#dsn3_alias#.STOCKS S
							WHERE
								INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
								INVOICE.INVOICE_ID = CR.ACTION_ID AND
								INVOICE.INVOICE_CAT = CR.ACTION_TYPE_ID AND
								CR.ACTION_TABLE = 'INVOICE' AND
								S.STOCK_ID = INVOICE_ROW.STOCK_ID AND
								S.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID AND
								ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
							<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
								AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
							</cfif>
							<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
								AND (CR.TO_CMP_ID = #attributes.COMPANY_ID# OR CR.FROM_CMP_ID = #attributes.COMPANY_ID#)
							<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
								AND CR.TO_CONSUMER_ID = #attributes.consumer_id#
							<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
								AND CR.TO_EMPLOYEE_ID = #attributes.employee_id#
							</cfif>
							<cfif isDefined("attributes.action_type") and len(attributes.action_type)>
								AND ACTION_TYPE_ID = #attributes.action_type# 
							</cfif>
							<cfif isDefined("attributes.other_money") and len(attributes.other_money)>
								AND CR.OTHER_MONEY = '#attributes.other_money#' 
							</cfif>
							<cfif session.ep.isBranchAuthorization or isdefined("is_store_module")>
								AND	(CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
							</cfif>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
								AND CR.PROJECT_ID = #attributes.project_id#
							</cfif>
							<cfif isdefined("attributes.is_pay_cheques")>
								AND
								(
								(CR.ACTION_TABLE = 'CHEQUE' AND CR.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CR.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7,4,9,8)))
								OR	
								(CR.ACTION_TABLE = 'PAYROLL' AND CR.ACTION_ID IN (SELECT CH.PAYROLL_ID FROM CHEQUE C,CHEQUE_HISTORY CH WHERE CH.PAYROLL_ID = CR.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND  C.CHEQUE_STATUS_ID IN (3,7,4,9,8)))
								OR 
								(CR.ACTION_TABLE = 'VOUCHER' AND CR.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CR.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7,4,9,8)))
								OR	
								(CR.ACTION_TABLE = 'VOUCHER_PAYROLL' AND CR.ACTION_ID IN (SELECT VH.PAYROLL_ID FROM VOUCHER V,VOUCHER_HISTORY VH WHERE VH.PAYROLL_ID = CR.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND  V.VOUCHER_STATUS_ID IN (3,7,4,9,8)))
								OR 
								(CR.ACTION_TABLE <> 'PAYROLL' AND CR.ACTION_TABLE <> 'CHEQUE' AND CR.ACTION_TABLE <> 'VOUCHER' AND CR.ACTION_TABLE <> 'VOUCHER_PAYROLL')
								)			
							</cfif>
					</cfif>
						ORDER BY
							ACTION_DATE,
							ACTION_ID,
							DETAIL_TYPE
					</cfquery>
				<cfelse>
					<cfset CARI_ROWS_ALL.recordcount = 0>
				</cfif>
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows=CARI_ROWS_ALL.recordcount>
				<cfparam name="attributes.page" default = "1">
				<cfparam name="attributes.totalrecords" default = "#CARI_ROWS_ALL.recordcount#">
				<cfif (isdefined("attributes.is_bakiye") and CARI_ROWS_ALL.recordcount gt 0) or not isdefined("attributes.is_bakiye")>
					<br/>
					<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
						<tr class="color-list">
							<td colspan="15" class="txtbold" height="20"><cfoutput><cfif isdefined ('attributes.company') and len(attributes.company)>#attributes.company# </cfif> #get_periods.period_year#</cfoutput>&nbsp;<cf_get_lang dictionary_id='57860.Dönemi Hesap Ekstresi'><cfif isdefined("attributes.is_pos_group")><cf_get_lang dictionary_id='57908.Temsilci'> : <cfoutput>#get_emp_info(pos_code_,1,0)#</cfoutput></cfif></td>
						</tr>
					</table>
					<table cellpadding="2" cellspacing="1" border="0" width="98%" align="center" class="color-border">
						<tr height="22" class="color-header">
							<td class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
							<td class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></td>
							<cfif listfind(attributes.list_type,4)>
							<td class="form-title"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
							<td class="form-title"><cf_get_lang dictionary_id='57490.Gün'></td>
							</cfif> 
							<cfif listfind(attributes.list_type,5)><td class="txtboldblue"><cf_get_lang dictionary_id='57416.Proje'></td></cfif>
							<td class="form-title"><cf_get_lang dictionary_id='57468.Belge'></td>
							<td class="form-title"><cf_get_lang dictionary_id='57692.İşlem'></td>
							<cfif listfind(attributes.list_type,8)><td class="form-title"><cf_get_lang dictionary_id='57629.Açıklama'></td></cfif>
							<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
							<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
							<cfif listfind(attributes.list_type,2)>		
							<td  class="form-title" style="text-align:right;">2.<cf_get_lang dictionary_id='57587.Borç'></td>
							<td  class="form-title" style="text-align:right;">2.<cf_get_lang dictionary_id='57588.Alacak'></td>
							</cfif>
							<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>	
							<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57862.İşlem Dövizi Borç'></td>
							<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57863.İşlem Dövizi Alacak'></td>
							<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57648.Kur'></td>
							</cfif>
							<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></td>
							<cfif listfind(attributes.list_type,3)><td width="100"  class="form-title" style="text-align:right;">2.<cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57589.Bakiye'></td></cfif>
						</tr>
					  <cfset money_list_borc_2 = ''>
					  <cfset money_list_borc_1 = ''>
					  <cfset money_list_alacak_2 = ''>
					  <cfset money_list_alacak_1 = ''>
						<cfscript>
							devir_total = 0;
							devir_borc = 0;
							devir_alacak = 0;
							bakiye = 0;
							devir_total_2 = 0;
							devir_borc_2 = 0;
							devir_alacak_2 = 0;
							bakiye_2 = 0;
							gen_borc_top = 0;
							gen_ala_top = 0;
							gen_bak_top = 0;
							gen_bak_top_2 = 0;
							gen_borc_top_2 = 0;
							gen_ala_top_2 = 0;
							gen_borc_top_other = 0;
							gen_ala_top_other = 0;
						</cfscript>	
						<cfoutput query="get_money">
							<cfset 'devir_borc_#money#' = 0>
							<cfset 'devir_alacak_#money#' = 0>
						</cfoutput>
						<cfif datediff('d',yilbasi,date1) neq 0>
							<cfquery name="get_tarih_devir" dbtype="query">
								SELECT
									SUM(BORC) BORC,
									SUM(ALACAK) ALACAK,
									SUM(BORC-ALACAK) DEVIR_TOTAL,
									SUM(BORC2) BORC2,
									SUM(ALACAK2) ALACAK2,
									SUM(BORC2-ALACAK2) DEVIR_TOTAL2
								FROM
									CARI_ROWS_ALL
								 WHERE
									ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
							</cfquery>
							<cfif get_tarih_devir.recordcount>
								<cfset devir_borc = get_tarih_devir.BORC>
								<cfset devir_alacak = get_tarih_devir.ALACAK>
								<cfset devir_total = get_tarih_devir.DEVIR_TOTAL>
								<cfset devir_borc_2 = get_tarih_devir.BORC2>
								<cfset devir_alacak_2 = get_tarih_devir.ALACAK2>
								<cfset devir_total_2 = get_tarih_devir.DEVIR_TOTAL2>
							</cfif>
						</cfif>
						<cfif attributes.page gt 1>
							<cfset max_=(attributes.page-1)*attributes.maxrows>
							<cfoutput query="CARI_ROWS_ALL" startrow="1" maxrows="#max_#">
								<cfset devir_borc = devir_borc + borc>
								<cfset devir_alacak = devir_alacak + alacak>
								<cfset devir_total = devir_borc - devir_alacak>
								<cfif len(borc2)><cfset devir_borc_2 = devir_borc_2 + borc2></cfif>
								<cfif len(alacak2)><cfset devir_alacak_2 = devir_alacak_2 + alacak2></cfif>
								<cfset devir_total_2 = devir_borc_2 - devir_alacak_2>
								<cfset 'devir_borc_#other_money#' = evaluate('devir_borc_#other_money#') +borc_other>
								<cfset 'devir_alacak_#other_money#' = evaluate('devir_alacak_#other_money#') +alacak_other>
							</cfoutput>
						</cfif>
						<cfif devir_borc neq 0 and devir_alacak neq 0><cfoutput>
						<tr height="20" class="color-row">
							<td colspan="<cfif listfind(attributes.list_type,4)>6<cfelse>4</cfif>"  style="text-align:right;"><b><cf_get_lang dictionary_id='57864.Devir'></b></td>
							<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
							<td  style="text-align:right;">#TLFormat(devir_borc)# #session_base.money#</td>
							<td  style="text-align:right;">#TLFormat(devir_alacak)# #session_base.money#</td>
							<cfif listfind(attributes.list_type,2)>
								<td  style="text-align:right;">#TLFormat(devir_borc_2)# #session_base.money2#</td>
								<td  style="text-align:right;">#TLFormat(devir_alacak_2)# #session_base.money2#</td>
							</cfif>	
							<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
								<td  style="text-align:right;">
									<cfloop query="get_money">
										<cfif evaluate('devir_borc_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_#get_money.money#'))# #get_money.money#<br/></cfif>
									</cfloop>
								</td>
								<td  style="text-align:right;">
									<cfloop query="get_money">
										<cfif evaluate('devir_alacak_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_#get_money.money#'))# #get_money.money#<br/></cfif>
									</cfloop>
								</td>
								<td></td>
							</cfif>
								<td  style="text-align:right;">#TLFormat(ABS(devir_total))# #session_base.money# <cfif devir_borc gt devir_alacak>-B<cfelseif devir_borc lt devir_alacak>-A</cfif></td> 
								<cfif listfind(attributes.list_type,3)><td  style="text-align:right;">#TLFormat(ABS(devir_total_2))# #session_base.money2# <cfif devir_borc_2 gt devir_alacak_2>-B<cfelseif devir_borc_2 lt devir_alacak_2>-A</cfif></td></cfif> 
						  </tr></cfoutput>
						
						</cfif>
						<cfif CARI_ROWS_ALL.recordcount>
							<cfset bank_order_list="">
							<cfoutput query="CARI_ROWS_ALL">
								<cfif (CARI_ROWS_ALL.ACTION_TYPE_ID eq 260)>
									<cfset bank_order_list=listappend(bank_order_list,CARI_ROWS_ALL.ACTION_ID)>
								</cfif>
							</cfoutput>
							<cfif len(bank_order_list)>
								<cfset bank_order_list=listsort(bank_order_list,"numeric","desc",",")>
								<cfquery name="GET_BANK_ORDER" datasource="#new_dsn#">
									SELECT 
										BANK_ORDER_ID,
										PAYMENT_DATE
									FROM
										BANK_ORDERS
									WHERE
										BANK_ORDER_ID IN (#bank_order_list#)
									ORDER BY
										BANK_ORDER_ID DESC
								</cfquery>
							</cfif>
						<cfif get_periods.recordcount eq 1>
							 <cfset process_cat_id_list = ''>
							 <cfset project_id_list = "">
							 <cfif listfind(attributes.list_type,7)>
							 <cfoutput query="CARI_ROWS_ALL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
									<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
								</cfif>
								<cfif len(project_id) and project_id neq 0 and not listfind(project_id_list,project_id)>
									<cfset project_id_list = Listappend(project_id_list,project_id)>
								</cfif>
							 </cfoutput>		  	
							<cfif len(process_cat_id_list)>
								<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
								<cfquery name="get_process_cat" datasource="#DSN3#">
									SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
								</cfquery>
								<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
							</cfif>
							<cfif len(project_id_list)>
								<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>			
								<cfquery name="get_project_name" datasource="#dsn#">
									SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
								</cfquery>
								<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
							</cfif>
							</cfif>	
							<cfoutput query="CARI_ROWS_ALL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif len(borc_other)>
								<cfset bakiye_borc_2 = borc_other>
								<cfset bakiye_borc_1 = borc>
							<cfelse>
								<cfset bakiye_borc_2 = 0>
								<cfset bakiye_borc_1 = 0>
							</cfif>
							<cfif len(alacak_other)>
								<cfset bakiye_alacak_2 = alacak_other>
								<cfset bakiye_alacak_1 = alacak>
							<cfelse>
								<cfset bakiye_alacak_2 = 0>
								<cfset bakiye_alacak_1 = 0>
							</cfif>
							<cfset money_2 = other_money>
							<cfset money_1 = session_base.money>
							<cfif bakiye_borc_2 gt 0>
								<cfset money_list_borc_2 = listappend(money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
								<cfset money_list_borc_1 = listappend(money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
							</cfif>	
							<cfif bakiye_alacak_2 gt 0>
								<cfset money_list_alacak_2 = listappend(money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
								<cfset money_list_alacak_1 = listappend(money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
							</cfif>
							<cfset type="">
							<cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251',ACTION_TYPE_ID,',')>
								<cfset page_type = 'small'>
							<cfelse>
								<cfset page_type = 'page'>
							</cfif>
						<cfif DETAIL_TYPE eq 0>
						 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td>
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#currentrow#</font><!--- Borc ise kirmizi alacak ise mavi renk yapiliyor--->
									<cfelse>
										#currentrow#
									</cfif>
								</td>
								<td>
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#dateformat(action_date,dateformat_style)#</font>
									<cfelse>
										#dateformat(action_date,dateformat_style)#
									</cfif>
								</td>
								<cfif listfind(attributes.list_type,4)>
								<cfif len(DUE_DATE)>
								<td>#dateformat(DUE_DATE,dateformat_style)#</td>
								<td>#datediff('d',ACTION_DATE,DUE_DATE)#</td>
								<cfelseif len(PAY_METHOD) and PAY_METHOD neq 0 and ListFind(pay_method_id_list,PAY_METHOD,',')>
								<td>#dateformat(date_add('d', listgetat(pay_method_gun_list,ListFind(pay_method_id_list,PAY_METHOD,','),','), action_date),dateformat_style)#</td>
								<td>#listgetat(pay_method_gun_list,ListFind(pay_method_id_list,PAY_METHOD,','),',')#</td>
								<cfelseif listfind(bank_order_list,ACTION_ID)>
								<td>#dateformat(GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)],dateformat_style)#</td>
								<td>#datediff('d',ACTION_DATE,GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)])#</td>					
								<cfelse>
								<td></td>
								<td></td>
								</cfif>
								</cfif> 
								<cfif listfind(attributes.list_type,5)><td><cfif len(project_id) and len(project_id_list)>#get_project_name.project_head[listfind(project_id_list,project_id,',')]#<cfelse>&nbsp;</cfif></td></cfif>
								<td>
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#paper_no#</font>
									<cfelse>
										#paper_no#
									</cfif>
								</td>
								<td>
							  <cfif listfind('24,25,26,27,31,32,34,35,36,40,41,42,43,90,91,92,93,94,95',ACTION_TYPE_ID) and (not get_module_user(module) and structkeyexists(fusebox.circuits,module_name))>
										<cfif listfind(attributes.list_type,7)><!--- İslem tipi secili ise --->
											<cfif listfind(process_cat_id_list,process_cat,',')>
												<cfif listfind(attributes.list_type,6)>
													<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</font>
													<cfelse>
														#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
											  </cfif>
											<cfelse>
												<cfif listfind(attributes.list_type,6)>
													<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
													<cfelse>
													#action_name#
												</cfif>
											</cfif>					
										<cfelse>
											<cfif listfind(attributes.list_type,6)>
												<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
												<cfelse>
												#action_name#
											</cfif>
										</cfif>
									<cfelseif not len(type)>
										<cfif listfind(attributes.list_type,6)>
											<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
										<cfelse>
											#action_name#
										</cfif>
										<cfif listfind(attributes.list_type,8)><td>#action_detail#</td></cfif>
									<cfelse>
										<cfif listfind("291,292",action_type_id)>
											<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#&period_id=#session_base.period_id#&our_company_id=#session_base.company_id#','#page_type#');">
										<cfelseif ACTION_TABLE is 'CHEQUE'> 
											<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&ID=#ACTION_ID#','small')">
										<cfelseif ACTION_TABLE is 'VOUCHER'> 
											<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#ACTION_ID#','small')">
										<cfelse>
											<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=#type#&ID=#ACTION_ID#','#page_type#');">
										</cfif>
										<cfif listfind(attributes.list_type,7)>
											<cfif listfind(process_cat_id_list,process_cat,',')>
												<cfif listfind(attributes.list_type,6)>
													<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</font>
												<cfelse>
													#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
												</cfif>
											<cfelse>
												<cfif listfind(attributes.list_type,6)>
													<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
												<cfelse>
													#action_name#
												</cfif>
											</cfif>					
										<cfelse>
											<cfif listfind(attributes.list_type,6)>
												<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
											<cfelse>
												#action_name#
											</cfif>
										</cfif>
										</a>
										<cfif listfind(attributes.list_type,8)>
										<td>
											#action_detail#
											<cfif listfind(attributes.list_type,4)>
												<cfif ACTION_TYPE_ID eq 260 and len(bank_order_list)>
													(#dateformat(GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)],dateformat_style)#)
													<cfif IS_PROCESSED eq 1>(Havale Oluşturulmuş)</cfif>
												</cfif>
											<cfelseif ACTION_TYPE_ID eq 260 and IS_PROCESSED eq 1>
												(Havale Oluşturulmuş)
											</cfif>
										</td>	
										</cfif>
							  </cfif>
								</td>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc)# #session_base.money#</font>
									<cfelse>
										#TLFormat(borc)# #session_base.money#
									</cfif>
								</td>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak)# #session_base.money#</font>
									<cfelse>
										#TLFormat(alacak)# #session_base.money#
									</cfif>
								</td>
								<cfif listfind(attributes.list_type,2)>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc2)# #session_base.money2#</font>
									<cfelse>
										#TLFormat(borc2)# #session_base.money2#
									</cfif>
								</td>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak2)# #session_base.money2#</font>
									<cfelse>
										#TLFormat(alacak2)# #session_base.money2#
									</cfif>
								</td>
								</cfif>
								<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc_other)# #other_money#</font>
									<cfelse>
										#TLFormat(borc_other)# #other_money#
									</cfif>
								</td>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak_other)# #other_money#</font>
									<cfelse>
										#TLFormat(alacak_other)# #other_money#
									</cfif>
								</td>
								<cfif (borc_other gt 0 or alacak_other gt 0)>
									<cfif borc_other gt 0>
										<cfset other_tutar = borc_other>
										<cfset tutar = borc>
									<cfelse>
										<cfset other_tutar = alacak_other>
										<cfset tutar = alacak>
									</cfif>
									<td  style="text-align:right;">
									<cfif other_money neq session.ep.money>
										<cfif listfind(attributes.list_type,6)>
											<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(tutar/other_tutar,session.ep.our_company_info.rate_round_num)#</font>
										<cfelse>
											#TLFormat(tutar/other_tutar,session.ep.our_company_info.rate_round_num)#
										</cfif>
									<cfelse>
									&nbsp;
									</cfif>
									</td>
								</cfif>
								</cfif>
								<td  style="text-align:right;">
								  <cfif (currentrow mod attributes.maxrows) eq 1>
									<cfset bakiye = devir_total + borc - alacak>
									<cfset gen_borc_top = devir_borc + borc + gen_borc_top>
									<cfset gen_ala_top = devir_alacak + alacak + gen_ala_top>
									<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = devir_total_2 + borc2 - alacak2></cfif>
									<cfif len(borc2)><cfset gen_borc_top_2 = devir_borc_2 + borc2 + gen_borc_top_2></cfif>
									<cfif len(alacak2)><cfset gen_ala_top_2 = devir_alacak_2 + alacak2 + gen_ala_top_2></cfif>
								  <cfelse>
									<cfset bakiye = borc - alacak >
									<cfset gen_borc_top = borc + gen_borc_top>
									<cfset gen_ala_top = alacak + gen_ala_top>
									<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = borc2 - alacak2></cfif>
									<cfif len(borc2)><cfset gen_borc_top_2 = borc2 + gen_borc_top_2></cfif>
									<cfif len(alacak2)><cfset gen_ala_top_2 = alacak2 + gen_ala_top_2></cfif>
								  </cfif>
								  <cfset gen_bak_top = bakiye + gen_bak_top>
								  <cfset gen_bak_top_2 = bakiye_2 + gen_bak_top_2>
								  <cfif listfind(attributes.list_type,6)>
									<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0>- B<cfelse>- A</cfif></font>
								  <cfelse>
									#TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0>- B<cfelse>- A</cfif>
								  </cfif>
								</td>
								<cfif listfind(attributes.list_type,3)>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top_2))# #session_base.money2# <cfif gen_bak_top_2 gt 0>- B<cfelse>- A</cfif></font>
									<cfelse>
										#TLFormat(abs(gen_bak_top_2))# #session_base.money2# <cfif gen_bak_top_2 gt 0>- B<cfelse>- A</cfif>
									</cfif>
								</td>
								</cfif>
							</tr>
							<cfelse>
								<tr class="color-row">
									<td colspan="20">
										<table cellpadding="2" cellspacing="1">
											<cfif DETAIL_TYPE[currentrow-1] eq 0>
												<tr class="color-list">
													<td class="txtboldblue" width="100"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
													<td class="txtboldblue" width="200"><cf_get_lang dictionary_id='57629.Açıklama'></td>
													<td width="60"   class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
													<td class="txtboldblue" width="40"><cf_get_lang dictionary_id='57636.Birim'></td>
													<td width="80"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'></td>
													<td width="40"   class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></td>
													<td width="100"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='41113.Satır Toplamı'></td>
												</tr>
											</cfif>
											<tr>
												<td width="100">#STOCK_CODE#</td>
												<td width="200">#NAME_PRODUCT#</td>
												<td width="60"   style="text-align:right;">#AMOUNT#</td>
												<td width="40">#UNIT#</td>
												<td width="80"  style="text-align:right;">#TLFormat(PRICE)#</td>
												<td width="40"   style="text-align:right;">#TAX#</td>
												<td width="100"  style="text-align:right;">#TLFormat(GROSSTOTAL)#</td>
											</tr>
										</table>
									</td>
								</tr>
							</cfif>
						 </cfoutput>
						<cfelse>
							 <cfset process_cat_id_list = ''>
							 <cfset project_id_list = "">
							 <cfif listfind(attributes.list_type,7)>
							 <cfoutput query="CARI_ROWS_ALL">
								<cfif len(process_cat) and not listfind(process_cat_id_list,process_cat)>
									<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
								</cfif>
								<cfif len(project_id) and project_id neq 0 and not listfind(project_id_list,project_id)>
									<cfset project_id_list = Listappend(project_id_list,project_id)>
								</cfif>
							 </cfoutput>		  	
							<cfif len(process_cat_id_list)>
								<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
								<cfquery name="get_process_cat" datasource="#DSN3#">
									SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
								</cfquery>
								<cfset process_cat_id_list = valuelist(get_process_cat.PROCESS_CAT_ID,',')>		
							</cfif>
							<cfif len(project_id_list)>
								<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>			
								<cfquery name="get_project_name" datasource="#dsn#">
									SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
								</cfquery>
								<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
							</cfif>
							</cfif>
						 <cfoutput query="CARI_ROWS_ALL">		  	
							<cfset type="">
							<cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251',ACTION_TYPE_ID,',')>
								<cfset page_type = 'small'>
							<cfelse>
								<cfset page_type = 'page'>
							</cfif>
							<cfif len(borc_other)>
								<cfset bakiye_borc_2 = borc_other>
								<cfset bakiye_borc_1 = borc>
							<cfelse>
								<cfset bakiye_borc_2 = 0>
								<cfset bakiye_borc_1 = 0>
							</cfif>
							<cfif len(alacak_other)>
								<cfset bakiye_alacak_2 = alacak_other>
								<cfset bakiye_alacak_1 = alacak>
							<cfelse>
								<cfset bakiye_alacak_2 = 0>
								<cfset bakiye_alacak_1 = 0>
							</cfif>
							<cfset money_2 = other_money>
							<cfset money_1 = session_base.money>
							<cfif bakiye_borc_2 gt 0>
								<cfset money_list_borc_2 = listappend(money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
								<cfset money_list_borc_1 = listappend(money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
							</cfif>	
							<cfif bakiye_alacak_2 gt 0>
								<cfset money_list_alacak_2 = listappend(money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
								<cfset money_list_alacak_1 = listappend(money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
							</cfif>	
						  <cfif DETAIL_TYPE eq 0>
							 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td>
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#currentrow#</font><!--- Borc ise kirmizi alacak ise mavi renk yapiliyor--->
									<cfelse>
										#currentrow#
									</cfif>
								</td>
								<td>
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#dateformat(action_date,dateformat_style)#</font>
									<cfelse>
										#dateformat(action_date,dateformat_style)#
									</cfif>
								</td>
								<cfif listfind(attributes.list_type,4)>
								<cfif len(DUE_DATE)>
								<td>#dateformat(DUE_DATE,dateformat_style)#</td>
								<td>#datediff('d',ACTION_DATE,DUE_DATE)#</td>
								<cfelseif len(PAY_METHOD) and PAY_METHOD neq 0 and ListFind(pay_method_id_list,PAY_METHOD,',')>
								<td>#dateformat(date_add('d', listgetat(pay_method_gun_list,ListFind(pay_method_id_list,PAY_METHOD,','),','), action_date),dateformat_style)#</td>
								<td>#listgetat(pay_method_gun_list,ListFind(pay_method_id_list,PAY_METHOD,','),',')#</td>
								<cfelseif listfind(bank_order_list,ACTION_ID)>
								<td>#dateformat(GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)],dateformat_style)#</td>
								<td>#datediff('d',ACTION_DATE,GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)])#</td>					
								<cfelse>
								<td></td>
								<td></td>
								</cfif>
								</cfif> 
								<cfif listfind(attributes.list_type,5)><td><cfif len(project_id) and len(project_id_list)>#get_project_name.project_head[listfind(project_id_list,project_id,',')]#<cfelse>&nbsp;</cfif></td></cfif>
								<td>
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#paper_no#</font>
									<cfelse>
										#paper_no#
									</cfif>
								</td>
								<td>
							  <cfif listfind('24,25,26,27,31,32,34,35,36,40,41,42,43,90,91,92,93,94,95',ACTION_TYPE_ID) and (not get_module_user(module) and structkeyexists(fusebox.circuits,module_name))>
										<cfif listfind(attributes.list_type,7)>
											<cfif listfind(process_cat_id_list,process_cat,',')>
												<cfif listfind(attributes.list_type,6)>
													<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</font>
												<cfelse>
													#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
												</cfif>
											<cfelse>
												<cfif listfind(attributes.list_type,6)>
													<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
												<cfelse>
													#action_name#
												</cfif>
											</cfif>					
										<cfelse>
											<cfif listfind(attributes.list_type,6)>
												<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
												<cfelse>
												#action_name#
											</cfif>
										</cfif>
									<cfelseif not len(type)>
										<cfif listfind(attributes.list_type,6)>
											<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
										<cfelse>
											#action_name#
										</cfif>
										<cfif listfind(attributes.list_type,8)><td>#action_detail#</td></cfif>
									<cfelse>
										<cfif listfind("291,292",action_type_id)>
											<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#&period_id=#session_base.period_id#&our_company_id=#session_base.company_id#','#page_type#');">
										<cfelseif ACTION_TABLE is 'CHEQUE'> 
											<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&ID=#ACTION_ID#','small')">
										<cfelseif ACTION_TABLE is 'VOUCHER'> 
											<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#ACTION_ID#','small')">
										<cfelse>
											<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=#type#&ID=#ACTION_ID#','#page_type#');">
										</cfif>
										<cfif listfind(attributes.list_type,7)>
											<cfif listfind(process_cat_id_list,process_cat,',')>
												<cfif listfind(attributes.list_type,6)>
													<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>
													#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</font>
												<cfelse>
													#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
												</cfif>
											<cfelse>
												<cfif listfind(attributes.list_type,6)>
													<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
												<cfelse>
													#action_name#
												</cfif>
											</cfif>					
										<cfelse>
											<cfif listfind(attributes.list_type,6)>
												<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
											<cfelse>
												#action_name#
											</cfif>
										</cfif>
										</a>
										<cfif listfind(attributes.list_type,8)>
										<td>
											#action_detail#
											<cfif listfind(attributes.list_type,4)>
												<cfif ACTION_TYPE_ID eq 260 and len(bank_order_list)>
													(#dateformat(GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)],dateformat_style)#)
													<cfif IS_PROCESSED eq 1>(<cf_get_lang dictionary_id='49981.Havale Oluşturulmuş'>)</cfif>
												</cfif>
											<cfelseif ACTION_TYPE_ID eq 260 and IS_PROCESSED eq 1>
												(<cf_get_lang dictionary_id='49981.Havale Oluşturulmuş'>)
											</cfif>
										</td>	
										</cfif>
							  </cfif>
								</td>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc)# #session_base.money#</font>
									<cfelse>
										#TLFormat(borc)# #session_base.money#
									</cfif>
								</td>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak)# #session_base.money#</font>
									<cfelse>
										#TLFormat(alacak)# #session_base.money#
									</cfif>
								</td>
								<cfif listfind(attributes.list_type,2)>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc2)# #session_base.money2#</font>
									<cfelse>
										#TLFormat(borc2)# #session_base.money2#
									</cfif>
								</td>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak2)# #session_base.money2#</font>
									<cfelse>
										#TLFormat(alacak2)# #session_base.money2#
									</cfif>
								</td>
								</cfif>
								<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc_other)# #other_money#</font>
									<cfelse>
										#TLFormat(borc_other)# #other_money#
									</cfif>
								</td>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak_other)# #other_money#</font>
									<cfelse>
										#TLFormat(alacak_other)# #other_money#
									</cfif>
								</td>
								<cfif (borc_other gt 0 or alacak_other gt 0)>
									<cfif borc_other gt 0>
										<cfset other_tutar = borc_other>
										<cfset tutar = borc>
									<cfelse>
										<cfset other_tutar = alacak_other>
										<cfset tutar = alacak>
									</cfif>
									<td  style="text-align:right;">
									<cfif other_money neq session.ep.money>
										<cfif listfind(attributes.list_type,6)>
											<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(tutar/other_tutar,session.ep.our_company_info.rate_round_num)#</font>
										<cfelse>
											#TLFormat(tutar/other_tutar,session.ep.our_company_info.rate_round_num)#
										</cfif>
									<cfelse>
									&nbsp;
									</cfif>
									</td>
								</cfif>
								</cfif>
								<td  style="text-align:right;">
								  <cfif (currentrow mod attributes.maxrows) eq 1>
									<cfset bakiye = devir_total + borc - alacak>
									<cfset gen_borc_top = devir_borc + borc + gen_borc_top>
									<cfset gen_ala_top = devir_alacak + alacak + gen_ala_top>
									<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = devir_total_2 + borc2 - alacak2></cfif>
									<cfif len(borc2)><cfset gen_borc_top_2 = devir_borc_2 + borc2 + gen_borc_top_2></cfif>
									<cfif len(alacak2)><cfset gen_ala_top_2 = devir_alacak_2 + alacak2 + gen_ala_top_2></cfif>
								  <cfelse>
									<cfset bakiye = borc - alacak >
									<cfset gen_borc_top = borc + gen_borc_top>
									<cfset gen_ala_top = alacak + gen_ala_top>
									<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = borc2 - alacak2></cfif>
									<cfif len(borc2)><cfset gen_borc_top_2 = borc2 + gen_borc_top_2></cfif>
									<cfif len(alacak2)><cfset gen_ala_top_2 = alacak2 + gen_ala_top_2></cfif>
								  </cfif>
								  <cfset gen_bak_top = bakiye + gen_bak_top>
								  <cfset gen_bak_top_2 = bakiye_2 + gen_bak_top_2>
								  <cfif listfind(attributes.list_type,6)>
									<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0>- B<cfelse>- A</cfif></font>
								  <cfelse>
									#TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0>- B<cfelse>- A</cfif>
								  </cfif>
								</td>
								<cfif listfind(attributes.list_type,3)>
								<td  style="text-align:right;">
									<cfif listfind(attributes.list_type,6)>
										<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top_2))# #session_base.money2# <cfif gen_bak_top_2 gt 0>- B<cfelse>- A</cfif></font>
									<cfelse>
										#TLFormat(abs(gen_bak_top_2))# #session_base.money2# <cfif gen_bak_top_2 gt 0>- B<cfelse>- A</cfif>
									</cfif>
								</td>
								</cfif>
						  </tr>
						  <cfelse>
						  	<tr class="color-row">
								<td colspan="20">
									<table cellpadding="2" cellspacing="1">
										<cfif DETAIL_TYPE[currentrow-1] eq 0>
											<tr class="color-list">
												<td class="txtboldblue" width="100"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
												<td class="txtboldblue" width="200"><cf_get_lang dictionary_id='36199.Açıklama'></td>
												<td width="60"   class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
												<td class="txtboldblue" width="40"><cf_get_lang dictionary_id='57636.Birim'></td>
												<td width="80"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'></td>
												<td width="40"   class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></td>
												<td width="100"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='41113.Satır Toplamı'></td>
											</tr>
										</cfif>
										<tr>
											<td width="100">#STOCK_CODE#</td>
											<td width="200">#NAME_PRODUCT#</td>
											<td width="60"   style="text-align:right;">#AMOUNT#</td>
											<td width="40">#UNIT#</td>
											<td width="80"  style="text-align:right;">#TLFormat(PRICE)#</td>
											<td width="40"   style="text-align:right;">#TAX#</td>
											<td width="100"  style="text-align:right;">#TLFormat(GROSSTOTAL)#</td>
										</tr>
									</table>
								</td>
							</tr>
						  </cfif>
						 </cfoutput>
						</cfif> 
						 <tr height="20" class="color-row">
							<td colspan="<cfif listfind(attributes.list_type,4)>6<cfelse>4</cfif>"  style="text-align:right;"><b><cf_get_lang dictionary_id='57680.Genel Toplam'></b></td>
							<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>	
							<td  style="text-align:right;"><cfoutput>#TLFormat(gen_borc_top)# #session_base.money#</cfoutput></td>
							<td  style="text-align:right;"><cfoutput>#TLFormat(gen_ala_top)# #session_base.money#</cfoutput></td>
							<cfif listfind(attributes.list_type,2)>
								<td  style="text-align:right;"><cfoutput>#TLFormat(gen_borc_top_2)# #session_base.money2#</cfoutput></td>
								<td  style="text-align:right;"><cfoutput>#TLFormat(gen_ala_top_2)# #session_base.money2#</cfoutput></td>
							</cfif>
							<cfif listfind(attributes.list_type,1) or  listfind(attributes.list_type,9)>
								<td style="width:125px;" >
									<cfoutput query="get_money">
									  <cfset toplam_ara_2 = 0>
									  <cfif len(money_list_borc_2)>
										  <cfloop list="#money_list_borc_2#" index="i">
											  <cfset tutar_ = listfirst(i,';')>
											 <cfset money_ = listgetat(i,2,';')>
											<cfif money_ eq money>
											  <cfset toplam_ara_2 = toplam_ara_2 + tutar_>
											</cfif>
										  </cfloop> 
									  </cfif>
									  <cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_borc_#money#')>
									  <cfif toplam_ara_2 neq 0>
										#TLFormat(ABS(toplam_ara_2))# #money#<br/>
									  </cfif>
									</cfoutput>  
								</td>
								<td style="width:125px;" >
									<cfoutput query="get_money">
									  <cfset toplam_ara_2 = 0>
									 <cfif len(money_list_alacak_2)>
										 <cfloop list="#money_list_alacak_2#" index="i">
											  <cfset tutar_ = listfirst(i,';')>
											  <cfset money_ = listgetat(i,2,';')>
											<cfif money_ eq money>
											  <cfset toplam_ara_2 = toplam_ara_2 + tutar_>
											</cfif>
									   </cfloop> 
									  </cfif>
									  <cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_alacak_#money#') >
									  <cfif toplam_ara_2 neq 0>
										#TLFormat(ABS(toplam_ara_2))# #money#<br/>
									  </cfif>
									</cfoutput>  
								</td>
								<td>&nbsp;</td>
							</cfif>
							<td  style="text-align:right;"> 
							<cfoutput>
								#TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0> -B<cfelse> -A</cfif>
							</cfoutput>
							</td>
							<cfif listfind(attributes.list_type,3)>
							<td  style="text-align:right;"> 
							<cfoutput>
								#TLFormat(abs(gen_bak_top_2))# #session_base.money2# <cfif gen_bak_top_2 gt 0> -B<cfelse> -A</cfif>
							</cfoutput>
							</td>
							</cfif>			
						  </tr>	
						<cfelse>
							<tr>
								<td colspan="20" class="color-row" height="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
							</tr>	  	       
						</cfif>
					</table>
				</cfif>
			  	<cfif isdefined('attributes.is_make_age_manuel') and (isdefined("attributes.is_bakiye") and CARI_ROWS_ALL.recordcount gt 0) or not isdefined("attributes.is_bakiye")> 
					<cfset is_from_collacted = 1>
					<cfset is_pdf = 1>
					<cfif not isDefined("attributes.is_pdf") and attributes.is_pdf neq 1> 
						<cfinclude template="dsp_make_age_manuel.cfm">
					</cfif>
			  </cfif>
			  </cfloop>			  
			  <cfif isdefined("attributes.is_cari_page")>
					<div style="page-break-before: always"></div>
			  </cfif>
			  </cfloop>
			</cfif>
		</cfdocument> 
	</cfif>
<br/>
</cfif>
