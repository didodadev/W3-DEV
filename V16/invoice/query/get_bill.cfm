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
<cfquery name="GET_BILL" datasource="#DSN2#">
	SELECT
		INVOICE.INVOICE_ID,
		<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
			INVOICE_ROW.NAME_PRODUCT,
			STOCKS.STOCK_CODE,
			INVOICE_ROW.GROSSTOTAL/IM.RATE2 ROW_OTHER_VALUE,
			INVOICE_ROW.OTHER_MONEY ROW_MONEY,
			INVOICE_ROW.NETTOTAL,
			INVOICE_ROW.TAXTOTAL,
			ISNULL(INVOICE_ROW.OTVTOTAL,0) OTVTOTAL,
			INVOICE_ROW.PRODUCT_ID,
			INVOICE_ROW.AMOUNT,
			INVOICE_ROW.PRICE,
			INVOICE_ROW.INVOICE_ROW_ID,
			ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID) PROJECT_ID,
		<cfelse>
			INVOICE.NETTOTAL,
			INVOICE.TAXTOTAL,
			INVOICE.PROJECT_ID,
		</cfif>
		INVOICE.PURCHASE_SALES,
		INVOICE.SERIAL_NUMBER,
		INVOICE.SERIAL_NO,
		INVOICE.INVOICE_NUMBER,
		INVOICE.GROSSTOTAL,
		INVOICE.SA_DISCOUNT,
		INVOICE.OTHER_MONEY_VALUE,
		INVOICE.OTHER_MONEY,
		INVOICE.COMPANY_ID,
		INVOICE.PARTNER_ID,	
		INVOICE.EMPLOYEE_ID,		
		INVOICE.CONSUMER_ID AS CON_ID,
		INVOICE.INVOICE_DATE,
		INVOICE.IS_IPTAL,
		INVOICE.INVOICE_CAT,
		INVOICE.PROCESS_CAT,
		INVOICE.DEPARTMENT_ID,
		INVOICE.PAY_METHOD,
		INVOICE.SALE_EMP,
		INVOICE.SALE_PARTNER,
		INVOICE.RECORD_DATE,
		INVOICE.REF_NO,
		INVOICE.PRINT_COUNT,
		INVOICE.TEVKIFAT_ORAN,
		INVOICE.INVOICE_MULTI_ID,
		INVOICE_MULTI.INVOICE_MULTI_ID AS INV_MULTI_ID<!---hobim-sadece rapordan gelen faturaları goruntulemek icin eklendi(is_from_report = 1--->
		<!--- (SELECT INVOICE_MULTI_ID FROM INVOICE_MULTI IM WHERE IM.INVOICE_MULTI_ID = INVOICE.INVOICE_MULTI_ID AND IM.IS_FROM_REPORT = 1) AS INV_MULTI_ID ---><!---hobim-sadece rapordan gelen faturaları goruntulemek icin eklendi(is_from_report = 1)--->
	FROM 
		INVOICE WITH (NOLOCK)
		LEFT JOIN INVOICE_MULTI ON INVOICE_MULTI.INVOICE_MULTI_ID = INVOICE.INVOICE_MULTI_ID AND INVOICE_MULTI.IS_FROM_REPORT = 1
		<cfif isdefined('attributes.control') and (attributes.control eq 0)>
			,INVOICE_CONTROL WITH (NOLOCK)
		</cfif>
		<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
			,INVOICE_ROW WITH (NOLOCK)
			,INVOICE_MONEY IM WITH (NOLOCK)
			,#dsn3_alias#.STOCKS STOCKS WITH (NOLOCK)
		</cfif>
	WHERE
		INVOICE.INVOICE_ID > 0
		<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
			AND INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
			AND INVOICE.INVOICE_ID = IM.ACTION_ID
			AND IM.MONEY_TYPE = INVOICE_ROW.OTHER_MONEY
			AND INVOICE_ROW.STOCK_ID = STOCKS.STOCK_ID
			AND INVOICE_ROW.PRODUCT_ID = STOCKS.PRODUCT_ID
		</cfif>
		<cfif isdefined ("attributes.project_id") and len(attributes.project_id) and isdefined ("attributes.project_head") and len(attributes.project_head)>
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
				AND ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			<cfelse>
				AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
		</cfif>
		<cfif isdefined("attributes.budget_record") and attributes.budget_record eq 1>
			AND INVOICE.INVOICE_ID IN (
										SELECT 
											IR.INVOICE_ID
										FROM 
											EXPENSE_ITEMS_ROWS EIR,
											INVOICE_ROW IR
										WHERE 
											EIR.ACTION_ID=IR.INVOICE_ROW_ID AND
											IR.INVOICE_ID=INVOICE.INVOICE_ID)
		<cfelseif isdefined("attributes.budget_record") and attributes.budget_record eq 0>
			AND INVOICE.INVOICE_ID NOT IN (
										SELECT 
											IR.INVOICE_ID
										FROM 
											EXPENSE_ITEMS_ROWS EIR,
											INVOICE_ROW IR
										WHERE 
											EIR.ACTION_ID=IR.INVOICE_ROW_ID AND
											IR.INVOICE_ID=INVOICE.INVOICE_ID)
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND (
				INVOICE.RECORD_EMP IN
				(
					SELECT 
						EMPLOYEE_ID
					FROM 
						#dsn_alias#.EMPLOYEE_POSITIONS EP,
						#dsn_alias#.DEPARTMENT D
					WHERE
						EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
						D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
				)
			OR
				DEPARTMENT_ID IN
				(
					SELECT 
						DEPARTMENT_ID
					FROM 
						#dsn_alias#.DEPARTMENT D
					WHERE
						D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
				)
			)
		</cfif>
		<cfif isdefined('attributes.control') and len(attributes.control)>
			AND INVOICE.PURCHASE_SALES = 0
			<cfif not attributes.control>
				AND INVOICE.INVOICE_ID = INVOICE_CONTROL.INVOICE_ID AND INVOICE_CONTROL.IS_CONTROL = 1
			<cfelseif attributes.control>
				AND INVOICE.INVOICE_ID NOT IN (SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE IS_CONTROL = 1)
			</cfif>
		</cfif>
		<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0 and attributes.member_type is 'partner'>
			AND INVOICE.COMPANY_ID=	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0 and attributes.member_type is 'consumer'>
			AND INVOICE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0 and attributes.member_type is 'employee'>
			AND INVOICE.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
		</cfif>
		<cfif isdefined('attributes.empo_id') and len(attributes.empo_id)>
			AND INVOICE.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empo_id#">
		<cfelseif isdefined('attributes.parto_id') and len(attributes.parto_id)>
			AND INVOICE.SALE_PARTNER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parto_id#">
		</cfif>
		<cfif isdefined('attributes.detail') and len(attributes.detail)>
			AND (INVOICE.NOTE LIKE '<cfif len(attributes.detail) gt 5>%</cfif>#attributes.detail#%')
		</cfif>
		<cfif Len(attributes.cat)>
			<cfif ListLen(attributes.cat,'-') eq 1 and attributes.cat eq 0><!--- Sadece Alislar --->
				AND INVOICE.PURCHASE_SALES = 0
			<cfelseif ListLen(attributes.cat,'-') eq 1 and attributes.cat eq 1><!--- Sadece Satislar --->
				AND INVOICE.PURCHASE_SALES = 1 
				AND INVOICE.INVOICE_CAT NOT IN(67,69)
			<cfelseif ListLen(attributes.cat,'-') eq 1><!--- Ana Islem Tipleri --->
				AND INVOICE.INVOICE_CAT IN (#ListFirst(attributes.cat,'-')#)
			<cfelseif ListLen(attributes.cat,'-') gt 1><!--- Alt Islem Tipleri --->
				AND(<cfloop list="#attributes.cat#" index="indx">
					INVOICE.PROCESS_CAT IN (#ListLast(indx,'-')#) <cfif indx neq listlast(attributes.cat)>OR</cfif>
				</cfloop>)
			<cfelse>
				AND INVOICE.INVOICE_CAT NOT IN(67,69)
			</cfif>
		<cfelseif isdefined('attributes.turned_to_total_inv')><!--- hobim raporundan geliyorsa --->
			AND INVOICE.PROCESS_CAT IN (50,52,53,531,532,56,58,62,561,54,48,36)
		<cfelse>
			AND INVOICE.INVOICE_CAT NOT IN(67,69)
		</cfif>
		<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)>
			AND INVOICE.PAY_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
		</cfif>
		<cfif isdefined('attributes.control') and len(attributes.control)>
			AND INVOICE.PURCHASE_SALES = 0
			<cfif not attributes.control>
				AND INVOICE.INVOICE_ID = INVOICE_CONTROL.INVOICE_ID AND INVOICE_CONTROL.IS_CONTROL = 1
			<cfelseif attributes.control>
				AND INVOICE.INVOICE_ID NOT IN (SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE IS_CONTROL = 1)
			</cfif>
		</cfif>
		
		<cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
			AND (
					(INVOICE.INVOICE_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%') 
					<cfif isnumeric(attributes.belge_no)> OR (INVOICE.INVOICE_ID = #attributes.belge_no#)</cfif>
				)
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND ((INVOICE.NOTE LIKE <cfif len(attributes.keyword) gte 3><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>) OR (INVOICE.REF_NO LIKE <cfif len(attributes.keyword) gte 3><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>))
		</cfif>
		<cfif (len(attributes.department_txt) and len(attributes.department_id) and len(attributes.location_id))>
			AND INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
		</cfif>
		<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
			AND INVOICE.RECORD_EMP = #attributes.record_emp_id#
		</cfif>
		<!--- kayit tarih araligi(record_date2) hobim raporuna gore duzenlendi --->
		<cfif isdate(attributes.record_date) or (isdefined("attributes.record_date2") and isdate(attributes.record_date2))>
			AND INVOICE.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#"> <cfif isdefined("attributes.record_date2") and len(attributes.record_date2)>AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.record_date2)#"><cfelse>AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.record_date)#"></cfif>
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		<cfelseif isdate(attributes.start_date)>
			AND INVOICE.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		<cfelseif isdate(attributes.finish_date)>
			AND INVOICE.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
		<cfif len(attributes.iptal_invoice)>
			AND INVOICE.IS_IPTAL = #attributes.iptal_invoice#
		</cfif>
		<cfif isdefined('attributes.product_id') and  len(attributes.product_id) and len(attributes.product_name)>
			<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
				AND INVOICE_ROW.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
			<cfelse>
				AND INVOICE.INVOICE_ID IN(SELECT INVOICE_ID FROM INVOICE_ROW WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">)
			</cfif>
		</cfif>
		<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') eq '1'>
			AND INVOICE.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#) 
		<cfelseif isdefined("attributes.member_cat_type") and attributes.member_cat_type eq 1>
			AND INVOICE.COMPANY_ID IN (SELECT C.COMPANY_ID  FROM #dsn_alias#.COMPANY C,#dsn_alias#.COMPANY_CAT CAT WHERE C.COMPANYCAT_ID = CAT.COMPANYCAT_ID)
		</cfif>
		<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') eq '2'>
			AND INVOICE.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(attributes.member_cat_type,'-')#)
		<cfelseif isdefined("attributes.member_cat_type") and attributes.member_cat_type eq 2>
			AND INVOICE.CONSUMER_ID IN (SELECT C.CONSUMER_ID FROM #dsn_alias#.CONSUMER C,#dsn_alias#.CONSUMER_CAT CAT WHERE C.CONSUMER_CAT_ID = CAT.CONSCAT_ID)
		</cfif>
		<cfif isdefined("attributes.is_tevkifat") and len(attributes.is_tevkifat)>
			AND INVOICE.TEVKIFAT=1
		</cfif>
		<!--- hobim-toplu faturalamadan olusan faturalar rapora gelmesin --->
		<!--- <cfif isdefined("attributes.report_id") and isdefined("attributes.report_type") and attributes.report_type eq 0><!---hobim-invoice_multi_id si bos yani toplu faturaya donusturulmemis tum satis faturalari--->
			AND INVOICE.INVOICE_MULTI_ID IS NULL 
		 <cfelseif isdefined("attributes.report_id") and isdefined("attributes.report_type") and attributes.report_type eq 1>hobim-sadece rapordan toplu faturaya donusturulmuş tum satis faturalari
			AND INVOICE.INVOICE_MULTI_ID IN (SELECT INVOICE_MULTI_ID FROM INVOICE_MULTI IM WHERE IM.INVOICE_MULTI_ID = INVOICE.INVOICE_MULTI_ID AND IM.IS_FROM_REPORT = 1)
		</cfif> --->
		<!---hobim--->
		 <cfif isdefined("attributes.turned_to_total_inv") and attributes.turned_to_total_inv eq 1>
			AND INVOICE.INVOICE_MULTI_ID IS NOT NULL AND INVOICE_MULTI.IS_FROM_REPORT = 1
		<cfelseif isdefined("attributes.turned_to_total_inv") and attributes.turned_to_total_inv eq 0>
			AND INVOICE.INVOICE_MULTI_ID IS NULL 
		</cfif> 
		<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
			AND INVOICE.ACC_TYPE_ID = #attributes.acc_type_id#
    	</cfif>
		<!---hobim--->
	<cfif isDefined('attributes.oby') and attributes.oby eq 2>
		ORDER BY INVOICE.INVOICE_DATE
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
		ORDER BY INVOICE.INVOICE_NUMBER
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
		ORDER BY INVOICE.INVOICE_NUMBER DESC
	<cfelse>
		ORDER BY INVOICE.INVOICE_DATE DESC
	</cfif>
</cfquery>
