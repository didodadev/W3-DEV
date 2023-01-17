<cfcomponent>
<cffunction name="get_bill_fnc" returntype="query">
	<cfargument name="listing_type" default="">
	<cfargument name="control" default="">
	<cfargument name="project_id" default="">
	<cfargument name="project_head" default="">
	<cfargument name="budget_record" default="">
	<cfargument name="module_name" default="">
	<cfargument name="company" default="">
	<cfargument name="company_id" default="">
	<cfargument name="member_type" default="">
	<cfargument name="consumer_id" default="">
	<cfargument name="employee_id" default="">
	<cfargument name="empo_id" default="">
	<cfargument name="parto_id" default="">
	<cfargument name="detail" default="">
	<cfargument name="cat" default="">    
	<cfargument name="card_paymethod_id" default="">
	<cfargument name="payment_type_id" default="">
    <cfargument name="old_process_type" default="">
	<cfargument name="payment_type" default="">
	<cfargument name="belge_no" default="">
	<cfargument name="keyword" default="">
	<cfargument name="department_txt" default="">
    <cfargument name="product_cat_code" default=""/>
	<cfargument name="product_cat_name" default=""/>
	<cfargument name="department_id" default="">
	<cfargument name="location_id" default="">
	<cfargument name="record_emp_id" default="">
	<cfargument name="record_emp_name" default="">
	<cfargument name="record_date" default="">
	<cfargument name="record_date2" default="">
	<cfargument name="start_date" default="">
	<cfargument name="finish_date" default="">
	<cfargument name="iptal_invoice" default="">
	<cfargument name="product_id" default="">
	<cfargument name="product_name" default="">
	<cfargument name="member_cat_type" default="">
	<cfargument name="is_tevkifat" default="">
	<cfargument name="turned_to_total_inv" default="">
	<cfargument name="acc_type_id" default="">
	<cfargument name="oby" default="">
    <cfargument name="rec_date1" default="">
    <cfargument name="rec_date2" default="">
    <cfargument name="EMP_PARTNER_NAMEO" default="">
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfargument name="efatura_type" default="">
    <cfargument name="earchive_type" default="">
    <cfargument name="authorized_emp" default="">
    <cfif Len(arguments.authorized_emp)>
        <cfquery name="getEmployeePosition" datasource="#this.dsn2#">
            SELECT POSITION_CODE, POSITION_CAT_ID FROM #this.dsn_alias#.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authorized_emp#">
        </cfquery>
    </cfif>
    <cfquery name="GET_BILL" datasource="#this.DSN2#">
        WITH CTE1 AS (
		SELECT
            INVOICE.INVOICE_ID,
            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
                INVOICE_ROW.STOCK_ID,
				INVOICE_ROW.TAX,
				INVOICE_ROW.UNIT, 
				INVOICE_ROW.UNIT_ID,
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
				INVOICE_ROW.ROW_EXP_CENTER_ID,
				EXPENSE_CENTER.EXPENSE,
				INVOICE_ROW.ROW_EXP_ITEM_ID,
				EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                INVOICE_ROW.ROW_ACC_CODE,
                INVOICE_ROW.ACTIVITY_TYPE_ID,
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
            INVOICE.DEPARTMENT_ID,
            INVOICE.PAY_METHOD,
            SP.PAYMETHOD,
            CPT.CARD_NO,
            INVOICE.SALE_EMP,
            INVOICE.SALE_PARTNER,
            INVOICE.RECORD_DATE,
            INVOICE.REF_NO,
            INVOICE.PRINT_COUNT,
            INVOICE.TEVKIFAT_ORAN,
            INVOICE.INVOICE_MULTI_ID,
			INVOICE.DUE_DATE,
            (SELECT INVOICE_MULTI_ID FROM INVOICE_MULTI IM WHERE IM.INVOICE_MULTI_ID = INVOICE.INVOICE_MULTI_ID AND IM.IS_FROM_REPORT = 1) AS INV_MULTI_ID,<!---hobim-sadece rapordan gelen faturaları goruntulemek icin eklendi(is_from_report = 1)--->
        	COMP.FULLNAME,
            CONS.CONSUMER_NAME,
            CONS.CONSUMER_SURNAME,
            DEP_BRANCH.BRANCH_NAME,
            PRO_PROJECTS.PROJECT_HEAD,
            SPC.PROCESS_CAT_ID,
            SPC.PROCESS_CAT,
            SPC.INVOICE_TYPE_CODE,
            COMPANY.MEMBER_CODE,
            CASE
            	WHEN COMPANY.COMPANY_ID IS NOT NULL THEN COMPANY.USE_EFATURA
                WHEN CONSUMER.CONSUMER_ID IS NOT NULL THEN CONSUMER.USE_EFATURA
            END AS 
            	USE_EFATURA
            <cfif session.ep.our_company_info.is_efatura>
                ,ER.PATH
                ,ER.STATUS
                ,ER.PROFILE_ID
                ,ER.EINVOICE_ID
                ,ER.STATUS_CODE
                ,ER.SENDER_TYPE
                ,(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') EINVOICE_COUNT
                ,(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.INVOICE_ID = INVOICE.INVOICE_ID) EFATURA_COUNT
                ,(SELECT COUNT(*) COUNT FROM EINVOICE_RELATION ER WHERE ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE') EINVOICE_CONTROL
            </cfif>
			<cfif session.ep.our_company_info.is_earchive>
                ,ERA.PATH PATH_EINVOICE
                ,ERA.STATUS STATUS_EINVOICE
                ,ERA.STATUS_CODE STATUS_CODE_EINVOICE
                ,ERA.EARCHIVE_ID
                ,ISNULL(ERA.IS_CANCEL,0) IS_CANCEL
                ,(SELECT COUNT(*) COUNT FROM EARCHIVE_RELATION ER WHERE ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE') EARCHIVE_CONTROL
            </cfif>
        FROM 
            INVOICE WITH (NOLOCK)
            	LEFT JOIN INVOICE_CASH_POS ICP ON ICP.INVOICE_ID = INVOICE.INVOICE_ID
                LEFT JOIN #this.dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = INVOICE.COMPANY_ID 
                <cfif len(arguments.earchive_type)> LEFT JOIN #this.dsn_alias#.COMPANY C2 ON C2.COMPANY_ID = INVOICE.COMPANY_ID AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= INVOICE.INVOICE_DATE</cfif>
                LEFT JOIN #this.dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID 
                LEFT JOIN #this.dsn_alias#.COMPANY COMP ON COMP.COMPANY_ID = INVOICE.COMPANY_ID
                LEFT JOIN #this.dsn_alias#.CONSUMER CONS ON CONS.CONSUMER_ID = INVOICE.CONSUMER_ID
                LEFT JOIN
                    (
                        SELECT
                           B.BRANCH_NAME,
                           D.DEPARTMENT_ID
                        FROM 
                           #this.dsn_alias#.BRANCH B,
                           #this.dsn_alias#.DEPARTMENT D
                        WHERE
                            B.BRANCH_ID = D.BRANCH_ID
                    ) AS  DEP_BRANCH
                    ON DEP_BRANCH.DEPARTMENT_ID = INVOICE.DEPARTMENT_ID 
                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 1>
                    LEFT JOIN #this.dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = INVOICE.PROJECT_ID
                </cfif>
                <cfif session.ep.our_company_info.is_efatura>
                	LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
                	LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
                </cfif>
                <cfif session.ep.our_company_info.is_earchive>
                	LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = INVOICE.INVOICE_ID AND ERA.ACTION_TYPE = 'INVOICE'
                	LEFT JOIN EARCHIVE_SENDING_DETAIL ES ON ES.ACTION_ID = INVOICE.INVOICE_ID AND ES.ACTION_TYPE = 'INVOICE' AND ES.SENDING_DETAIL_ID = (SELECT MAX(ES2.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ES2 WHERE ES2.ACTION_ID=INVOICE.INVOICE_ID AND ES2.ACTION_TYPE = 'INVOICE')
                </cfif>
                LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = INVOICE.PAY_METHOD
                LEFT JOIN #this.dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = INVOICE.CARD_PAYMETHOD_ID,
			#this.dsn3_alias#.SETUP_PROCESS_CAT SPC
			<cfif isdefined('arguments.control') and (arguments.control eq 0)>
            	,INVOICE_CONTROL WITH (NOLOCK)
            </cfif>
            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
                ,INVOICE_ROW WITH (NOLOCK)
                LEFT JOIN #this.dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = INVOICE_ROW.ROW_PROJECT_ID
                LEFT JOIN EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = INVOICE_ROW.ROW_EXP_CENTER_ID 
				LEFT JOIN EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = INVOICE_ROW.ROW_EXP_ITEM_ID
				,INVOICE_MONEY IM WITH (NOLOCK)
                ,#this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) 
				
            </cfif>
        WHERE
        	INVOICE.PROCESS_CAT = SPC.PROCESS_CAT_ID AND
            INVOICE.INVOICE_ID > 0
            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
                AND INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
                AND INVOICE.INVOICE_ID = IM.ACTION_ID
                AND IM.MONEY_TYPE = INVOICE_ROW.OTHER_MONEY
                AND INVOICE_ROW.STOCK_ID = STOCKS.STOCK_ID
                AND INVOICE_ROW.PRODUCT_ID = STOCKS.PRODUCT_ID
            </cfif>
            <cfif isdefined ("arguments.project_id") and len(arguments.project_id) and isdefined ("arguments.project_head") and len(arguments.project_head)>
                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                    AND ISNULL(INVOICE_ROW.ROW_PROJECT_ID,INVOICE.PROJECT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                <cfelse>
                    <cfif len(arguments.project_head) and arguments.project_id eq -1>
                        AND INVOICE.PROJECT_ID IS NULL
                    <cfelseif len(arguments.project_head) and arguments.project_id eq -2>
                        AND INVOICE.PROJECT_ID IS NOT NULL AND INVOICE.PROJECT_ID <> -1
                    <cfelse>
                         AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                    </cfif>
                </cfif>
            </cfif>
            <cfif isdefined("arguments.budget_record") and arguments.budget_record eq 1>
                AND INVOICE.INVOICE_ID IN (
                                            SELECT 
                                                IR.INVOICE_ID
                                            FROM 
                                                EXPENSE_ITEMS_ROWS EIR,
                                                INVOICE_ROW IR
                                            WHERE 
                                                EIR.ACTION_ID=IR.INVOICE_ROW_ID AND
                                                IR.INVOICE_ID=INVOICE.INVOICE_ID)
            <cfelseif isdefined("arguments.budget_record") and arguments.budget_record eq 0>
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
                            #this.dsn_alias#.EMPLOYEE_POSITIONS EP,
                            #this.dsn_alias#.DEPARTMENT D
                        WHERE
                            EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                            D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
                    )
                OR
                    INVOICE.DEPARTMENT_ID IN
                    (
                        SELECT 
                            DEPARTMENT_ID
                        FROM 
                            #this.dsn_alias#.DEPARTMENT D
                        WHERE
                            D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
                    )
                )
            </cfif>
            <cfif len(arguments.product_cat_code) and len(arguments.product_cat_name)>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            AND INVOICE_ROW.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn3_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                        <cfelse>
                            AND INVOICE.INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE_ROW IR, #this.dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID = IR.PRODUCT_ID AND P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                        </cfif>
                    </cfif>
            <cfif isdefined('arguments.control') and len(arguments.control)>
                <cfif not arguments.control>
                    AND INVOICE.INVOICE_ID = INVOICE_CONTROL.INVOICE_ID AND INVOICE_CONTROL.IS_CONTROL = 1
                <cfelseif arguments.control>
                    AND INVOICE.INVOICE_ID NOT IN (SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE IS_CONTROL = 1)
                </cfif>
            </cfif>
            <cfif len(arguments.company) and len(arguments.company_id) and arguments.company_id neq 0 and arguments.member_type is 'partner'>
                AND INVOICE.COMPANY_ID=	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            </cfif>
            <cfif len(arguments.company) and len(arguments.consumer_id) and arguments.consumer_id neq 0 and arguments.member_type is 'consumer'>
                AND INVOICE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
            </cfif>
            <cfif len(arguments.company) and len(arguments.employee_id) and arguments.employee_id neq 0 and arguments.member_type is 'employee'>
                AND INVOICE.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.employee_id,'_')#">
            </cfif>
            <cfif len(arguments.empo_id) and len(arguments.EMP_PARTNER_NAMEO)>
                AND INVOICE.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empo_id#">
            <cfelseif isdefined('arguments.parto_id') and len(arguments.parto_id) and len(arguments.EMP_PARTNER_NAMEO)>
                AND INVOICE.SALE_PARTNER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parto_id#">
            </cfif>
            <cfif isdefined('arguments.detail') and len(arguments.detail)>
                AND (INVOICE.NOTE LIKE '<cfif len(arguments.detail) gt 5>%</cfif>#arguments.detail#%')
            </cfif>
            <cfif Len(arguments.cat)>
                <cfif ListLen(arguments.cat,'-') eq 1 and arguments.cat eq 0><!--- Sadece Alislar --->
                    AND INVOICE.PURCHASE_SALES = 0
                <cfelseif ListLen(arguments.cat,'-') eq 1 and arguments.cat eq 1><!--- Sadece Satislar --->
                    AND INVOICE.PURCHASE_SALES = 1 
                    AND INVOICE.INVOICE_CAT NOT IN(67,69)
                <cfelseif ListLen(arguments.cat,'-') eq 1><!--- Ana Islem Tipleri --->
                    AND INVOICE.INVOICE_CAT IN (#ListFirst(arguments.cat,'-')#)
                <cfelseif ListLen(arguments.cat,'-') gt 1><!--- Alt Islem Tipleri --->
                    AND(<cfloop list="#arguments.cat#" index="indx">
                        INVOICE.PROCESS_CAT IN (#ListLast(indx,'-')#) <cfif indx neq listlast(arguments.cat)>OR</cfif>
                    </cfloop>)
                <cfelse>
                    AND INVOICE.INVOICE_CAT NOT IN(67,69)
                </cfif>
            <cfelse>
                AND INVOICE.INVOICE_CAT NOT IN(67,69)
            </cfif>
            <cfif isdefined('arguments.payment_type_id') and len(arguments.payment_type_id) and isdefined('arguments.payment_type') and len(arguments.payment_type)>
                AND INVOICE.PAY_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payment_type_id#">
            </cfif>
            <cfif isdefined('arguments.card_paymethod_id') and len(arguments.card_paymethod_id) and isdefined('arguments.payment_type') and len(arguments.payment_type)>
            	<cfif arguments.cat neq 52>
                AND INVOICE.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_paymethod_id#">
                <cfelse>
                AND ICP.POS_ID IN (#arguments.card_paymethod_id#)
                </cfif>
            </cfif>
            <cfif isdefined('arguments.control') and len(arguments.control)>
                <cfif not arguments.control>
                    AND INVOICE.INVOICE_ID = INVOICE_CONTROL.INVOICE_ID AND INVOICE_CONTROL.IS_CONTROL = 1
                <cfelseif arguments.control>
                    AND INVOICE.INVOICE_ID NOT IN (SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE IS_CONTROL = 1)
                </cfif>
            </cfif>
            <cfif isdefined("arguments.belge_no") and len(arguments.belge_no)>
                AND (
                        (INVOICE.INVOICE_NUMBER LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%') 
                        <cfif isnumeric(arguments.belge_no)> OR (INVOICE.INVOICE_ID = #arguments.belge_no#)</cfif>
                    )
            </cfif>
            <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                AND 
				(
					INVOICE.NOTE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					OR 
					INVOICE.REF_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					<cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
					OR 
					INVOICE_ROW.LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					</cfif>
				)
            </cfif>
            <cfif len(arguments.department_txt) and len(arguments.department_id)>
                AND INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
            </cfif>
            <cfif len(arguments.location_id)>
                AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">
			</cfif>
            <cfif len(arguments.record_emp_id) and len(arguments.record_emp_name)>
                AND INVOICE.RECORD_EMP = #arguments.record_emp_id#
            </cfif>
            <!--- kayit tarih araligi(record_date2) hobim raporuna gore duzenlendi --->
            <cfif isdate(arguments.record_date) or (isdefined("arguments.record_date2") and isdate(arguments.record_date2))>
                AND INVOICE.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#"> <cfif isdefined("arguments.record_date2") and len(arguments.record_date2)>AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.rec_date1#"><cfelse>AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.rec_date2#"></cfif>
            </cfif>
            <cfif isdate(arguments.start_date) and isdate(arguments.finish_date)>
                AND INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            <cfelseif isdate(arguments.start_date)>
                AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
            <cfelseif isdate(arguments.finish_date)>
                AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
            <cfif len(arguments.iptal_invoice)>
                AND INVOICE.IS_IPTAL = #arguments.iptal_invoice#
            </cfif>
            <cfif isdefined('arguments.product_id') and  len(arguments.product_id) and len(arguments.product_name)>
                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
                    AND INVOICE_ROW.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                <cfelse>
                    AND INVOICE.INVOICE_ID IN(SELECT INVOICE_ID FROM INVOICE_ROW WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">)
                </cfif>
            </cfif>
            <cfif isdefined("arguments.member_cat_type") and listlen(arguments.member_cat_type,'-') eq 2 and listfirst(arguments.member_cat_type,'-') eq '1'>
                AND INVOICE.COMPANY_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(arguments.member_cat_type,'-')#) 
            <cfelseif isdefined("arguments.member_cat_type") and arguments.member_cat_type eq 1>
                AND INVOICE.COMPANY_ID IN (SELECT C.COMPANY_ID  FROM #this.dsn_alias#.COMPANY C,#this.dsn_alias#.COMPANY_CAT CAT WHERE C.COMPANYCAT_ID = CAT.COMPANYCAT_ID)
            </cfif>
            <cfif isdefined("arguments.member_cat_type") and listlen(arguments.member_cat_type,'-') eq 2 and listfirst(arguments.member_cat_type,'-') eq '2'>
                AND INVOICE.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #this.dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(arguments.member_cat_type,'-')#)
            <cfelseif isdefined("arguments.member_cat_type") and arguments.member_cat_type eq 2>
                AND INVOICE.CONSUMER_ID IN (SELECT C.CONSUMER_ID FROM #this.dsn_alias#.CONSUMER C,#this.dsn_alias#.CONSUMER_CAT CAT WHERE C.CONSUMER_CAT_ID = CAT.CONSCAT_ID)
            </cfif>
            <cfif isdefined("arguments.is_tevkifat") and len(arguments.is_tevkifat)>
                AND INVOICE.TEVKIFAT=1
            </cfif>
            <cfif len(arguments.efatura_type) and arguments.efatura_type neq 5>
            	AND ((COMPANY.COMPANY_ID IS NOT NULL OR CONSUMER.CONSUMER_ID IS NOT NULL) AND (SPC.INVOICE_TYPE_CODE IS NOT NULL OR INVOICE.PURCHASE_SALES = 0))
				<cfif arguments.efatura_type eq 1>                    
                    AND ((ER.STATUS IS NULL AND SPC.INVOICE_TYPE_CODE IS NOT NULL AND COMPANY.USE_EFATURA = 1
                    AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0) OR (ER.STATUS_CODE IN (50,60,80,110) AND ER.SENDER_TYPE = 5))
                    <cfif isdefined("session.ep.our_company_info.is_earchive") and session.ep.our_company_info.is_earchive eq 1>
                        AND (SELECT COUNT(RELATION_ID) FROM EARCHIVE_RELATION ER WHERE ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE') <= 0
                    </cfif>
                	AND INVOICE.INVOICE_DATE >= #createodbcdatetime(session.ep.our_company_info.efatura_date)#
                <cfelseif arguments.efatura_type eq 2>
                    AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) > 0
							AND ER.PATH IS NOT NULL
						)
						OR
						(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.INVOICE_ID = INVOICE.INVOICE_ID) > 0
					)
                <cfelseif arguments.efatura_type eq 6>
                    AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0 
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE <> 1) > 0 
						)
					)
                <cfelseif arguments.efatura_type eq 7>
                    AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) > 0 
							AND ER.PATH IS NOT NULL
						)
						AND (ER.STATUS IS NULL AND ER.PROFILE_ID <> 'TEMELFATURA')
					)
                <cfelseif arguments.efatura_type eq 3>
                    AND (ER.STATUS = 1)
                <cfelseif arguments.efatura_type eq 4>
                    AND ER.STATUS = 0
                </cfif>
            </cfif>
            <cfif arguments.efatura_type eq 5>
            	AND SPC.INVOICE_TYPE_CODE IS NOT NULL AND COMPANY.USE_EFATURA = 0
            </cfif>
            <cfif len(arguments.invoice_type)>
            	<cfif arguments.invoice_type eq 1>
                    AND INVOICE.INVOICE_MULTI_ID IN(SELECT IM.INVOICE_MULTI_ID FROM INVOICE_MULTI IM WHERE IS_GROUP_INVOICE = 0)
            	<cfelseif arguments.invoice_type eq 2>
                    AND INVOICE.INVOICE_MULTI_ID IN(SELECT IM.INVOICE_MULTI_ID FROM INVOICE_MULTI IM WHERE IS_GROUP_INVOICE = 1)
            	<cfelseif arguments.invoice_type eq 3>
                    AND INVOICE.INVOICE_MULTI_ID IS NULL
                </cfif>
            </cfif>
			<cfif len(arguments.earchive_type)>
            	AND SPC.INVOICE_TYPE_CODE IS NOT NULL
				<cfif arguments.earchive_type eq 1>
                	AND INVOICE_DATE >=#createodbcdatetime(session.ep.our_company_info.earchive_date)#
                    AND C2.COMPANY_ID IS NULL 
                    AND 
                    (
                        (
                        	(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') = 0
                            AND ERA.STATUS IS NULL
                            AND SPC.INVOICE_TYPE_CODE IS NOT NULL
                            AND INVOICE.IS_IPTAL =  0
                            AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) = 0
                        )
                       	OR
                        (
                        	(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') = 0
                        	AND INVOICE.IS_IPTAL = 1
                            AND SPC.INVOICE_TYPE_CODE IS NOT NULL
                            AND ISNULL(ERA.IS_CANCEL,0)=0
                            AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) > 0 
                        )
                    )
				<cfelseif arguments.earchive_type eq 2>
                    AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) > 0 
							AND ERA.PATH IS NOT NULL
                            AND (ERA.STATUS = 1 OR ERA.STATUS IS NULL)
                            AND ERA.EARCHIVE_SENDING_TYPE = 0
						)
					)
				<cfelseif arguments.earchive_type eq 3>
					AND ERA.STATUS = 0
                <cfelseif arguments.earchive_type eq 4>
                	AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND STATUS_CODE = 1) > 0 
							AND ERA.PATH IS NOT NULL
                            AND (ERA.STATUS = 1 OR ERA.STATUS IS NULL)
                            AND ERA.EARCHIVE_SENDING_TYPE = 1
						)
					) 
                </cfif>
            </cfif>
			<cfif len(arguments.output_type)>
				AND ES.OUTPUT_TYPE IN(#arguments.output_type#)
            </cfif>
            <cfif Len(arguments.authorized_emp)>
            	AND INVOICE.PROCESS_CAT IN (
                                                SELECT 
                                                    PROCESS_CAT_ID
                                                FROM
                                                    #this.dsn3_alias#.SETUP_PROCESS_CAT_ROWS
                                                WHERE
                                                    POSITION_CODE = #getEmployeePosition.POSITION_CODE#
                                                    OR POSITION_CAT_ID = #getEmployeePosition.POSITION_CAT_ID#
                                            )
            </cfif>
        GROUP BY
			INVOICE.INVOICE_ID,
            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
                INVOICE_ROW.STOCK_ID,
				INVOICE_ROW.TAX,
				INVOICE_ROW.UNIT, 
				INVOICE_ROW.UNIT_ID,
			    INVOICE_ROW.NAME_PRODUCT,
                STOCKS.STOCK_CODE,
                INVOICE_ROW.GROSSTOTAL,
                IM.RATE2,
                INVOICE_ROW.OTHER_MONEY,
                INVOICE_ROW.NETTOTAL,
                INVOICE_ROW.TAXTOTAL,
                INVOICE_ROW.OTVTOTAL,
                INVOICE_ROW.PRODUCT_ID,
                INVOICE_ROW.AMOUNT,
                INVOICE_ROW.PRICE,
                INVOICE_ROW.INVOICE_ROW_ID,
                INVOICE_ROW.ROW_PROJECT_ID,
                INVOICE.PROJECT_ID,
				INVOICE_ROW.ROW_EXP_CENTER_ID,
				EXPENSE_CENTER.EXPENSE,
				INVOICE_ROW.ROW_EXP_ITEM_ID,
				EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                INVOICE_ROW.ROW_ACC_CODE,
                INVOICE_ROW.ACTIVITY_TYPE_ID,
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
            INVOICE.CONSUMER_ID,
            INVOICE.INVOICE_DATE,
            INVOICE.IS_IPTAL,
            INVOICE.INVOICE_CAT,
            INVOICE.DEPARTMENT_ID,
            INVOICE.PAY_METHOD,
            SP.PAYMETHOD,
            CPT.CARD_NO,
            INVOICE.SALE_EMP,
            INVOICE.SALE_PARTNER,
            INVOICE.RECORD_DATE,
            INVOICE.REF_NO,
            INVOICE.PRINT_COUNT,
            INVOICE.TEVKIFAT_ORAN,
            INVOICE.INVOICE_MULTI_ID,
			INVOICE.DUE_DATE,
			COMP.FULLNAME,
            CONS.CONSUMER_NAME,
            CONS.CONSUMER_SURNAME,
            DEP_BRANCH.BRANCH_NAME,
            PRO_PROJECTS.PROJECT_HEAD,
            SPC.PROCESS_CAT_ID,
            SPC.PROCESS_CAT,
            SPC.INVOICE_TYPE_CODE,
            COMPANY.MEMBER_CODE,
			COMPANY.COMPANY_ID,
			COMPANY.USE_EFATURA,
			CONSUMER.CONSUMER_ID,
			CONSUMER.USE_EFATURA
			<cfif session.ep.our_company_info.is_efatura>
                ,ER.PATH
                ,ER.STATUS
                ,ER.PROFILE_ID
                ,ER.EINVOICE_ID
                ,ER.STATUS_CODE
                ,ER.SENDER_TYPE
            </cfif>
			<cfif session.ep.our_company_info.is_earchive>
                ,ERA.PATH
                ,ERA.STATUS
                ,ERA.STATUS_CODE
                ,ERA.EARCHIVE_ID
                ,ERA.IS_CANCEL
            </cfif>           	
            ),
				
				CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (  
		<cfif isDefined('arguments.oby') and arguments.oby eq 2>
            ORDER BY INVOICE_DATE
        <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
            ORDER BY INVOICE_NUMBER
        <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
            ORDER BY INVOICE_NUMBER DESC
        <cfelse>
            ORDER BY INVOICE_DATE DESC, INVOICE_ID DESC
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
    <cfreturn get_bill>
</cffunction>
</cfcomponent>
