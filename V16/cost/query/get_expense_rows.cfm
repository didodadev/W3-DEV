<cfif isdefined("attributes.ch_employee_id")>
	<cfscript>
		attributes.acc_type_id = '';
		if(listlen(attributes.ch_employee_id,'_') eq 2)
		{
			attributes.acc_type_id = listlast(attributes.ch_employee_id,'_');
			attributes.employee_id_ = listfirst(attributes.ch_employee_id,'_');
		}
		else
			attributes.employee_id_ = attributes.ch_employee_id;
	</cfscript>
</cfif>
<cfif x_is_project_popup eq 1>
	<cfset attributes.project_id = Replace(attributes.project_id,',','')>
</cfif>
<cfquery name="GET_EXPENSE_ITEM_ROW_ALL" datasource="#DSN2#">
WITH CTE1 AS (
    SELECT 
		EXPENSE_ITEMS_ROWS.EXPENSE_ID,
		EXPENSE_ITEMS_ROWS.EXPENSE_EMPLOYEE,
		EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID,
		EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
		EXPENSE_ITEMS_ROWS.AMOUNT,
		EXPENSE_ITEMS_ROWS.AMOUNT_KDV,
		EXPENSE_ITEMS_ROWS.AMOUNT_OTV,
		EXPENSE_ITEMS_ROWS.AMOUNT_OIV,
		EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
		EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT,
		EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
		EXPENSE_ITEMS_ROWS.DETAIL,
		EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE,
		EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL,
		EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE,
		EXPENSE_ITEMS_ROWS.ACTION_ID,
		EXPENSE_ITEMS_ROWS.INVOICE_ID,
		EXPENSE_ITEMS_ROWS.QUANTITY,
		EXPENSE_ITEMS_ROWS.PROJECT_ID,
		AS1.ASSETP,	
		(CASE WHEN ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.COMPANY_ID,EXP.CH_COMPANY_ID)) > 0 THEN C.FULLNAME WHEN ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.CONSUMER_ID ,EXP.CH_CONSUMER_ID )) > 0 THEN CN.CONSUMER_NAME +' '+ CN.CONSUMER_SURNAME ELSE E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME END)COMPANY_NAME,
        (CASE WHEN ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.COMPANY_ID,EXP.CH_COMPANY_ID)) > 0 THEN C1.COMPANY_ID WHEN ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.CONSUMER_ID ,EXP.CH_CONSUMER_ID )) > 0 THEN CN1.CONSUMER_ID ELSE E1.EMPLOYEE_ID END) COMPANY_PARTNER_ID,
        (CASE WHEN ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.COMPANY_ID,EXP.CH_COMPANY_ID)) > 0 THEN C1.FULLNAME WHEN ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.CONSUMER_ID ,EXP.CH_CONSUMER_ID )) > 0 THEN CN1.CONSUMER_NAME +' '+ CN1.CONSUMER_SURNAME ELSE E1.EMPLOYEE_NAME +' '+ E1.EMPLOYEE_SURNAME END) COMPANY_PARTNER_NAME,
		ISNULL(ROW_PAPER_NO,ISNULL((SELECT EXP.PAPER_NO FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID),(SELECT II.INVOICE_NUMBER FROM INVOICE II WHERE II.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID))) PAPER_NO,
		EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
		EXPENSE_CENTER.EXPENSE,
		BR.BRANCH_NAME BRANCH,
		(SELECT SF.FIS_ID FROM STOCK_FIS_ROW SF WHERE SF.STOCK_FIS_ROW_ID = EXPENSE_ITEMS_ROWS.ACTION_ID) FIS_ID
	FROM 
		EXPENSE_ITEMS_ROWS 
         JOIN EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
         JOIN EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
        LEFT JOIN INVOICE INV ON INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID
        LEFT JOIN EXPENSE_ITEM_PLANS EXP ON EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
        LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = (ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.COMPANY_ID,EXP.CH_COMPANY_ID))) 
        LEFT JOIN #dsn_alias#.CONSUMER CN ON  CN.CONSUMER_ID = (ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.CONSUMER_ID ,EXP.CH_CONSUMER_ID ))) 
        LEFT JOIN #dsn_alias#.EMPLOYEES E ON  E.EMPLOYEE_ID = (ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,CH_EMPLOYEE_ID))
		LEFT JOIN #dsn_alias#.BRANCH BR ON EXPENSE_ITEMS_ROWS.BRANCH_ID=BR.BRANCH_ID        
        LEFT JOIN #dsn_alias#.COMPANY C1 ON C1.COMPANY_ID=EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID 
        LEFT JOIN #dsn_alias#.CONSUMER CN1 ON CN1.CONSUMER_ID = EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID
        LEFT JOIN #dsn_alias#.EMPLOYEES E1 ON E1.EMPLOYEE_ID = EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID
		LEFT JOIN #dsn_alias#.ASSET_P AS1 ON AS1.ASSETP_ID = EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID
	WHERE 
		EXPENSE_ITEMS_ROWS.IS_INCOME = 0 
		<cfif session.ep.isBranchAuthorization>
			AND EXPENSE_ITEMS_ROWS.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)			
		</cfif>
		<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
			AND EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE IN (#attributes.process_cat#)
		</cfif>
		<cfif not get_module_power_user(48)>
			AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID NOT IN (SELECT EC.EXPENSE_CAT_ID FROM EXPENSE_CATEGORY EC WHERE ISNULL(EC.EXPENCE_IS_HR,0) = 1)
		</cfif>
		<cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID = #attributes.expense_cat#</cfif>
		<cfif len(attributes.keyword)>
			AND 
			(
				(EXPENSE_ITEMS_ROWS.ROW_PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
				(EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
				(EXPENSE_ITEMS_ROWS.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
				(EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
							(SELECT 
								EXP.EXPENSE_ID 
							FROM 
								EXPENSE_ITEM_PLANS EXP 
							WHERE 
								EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
								AND EXP.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">))
			)
		</cfif>		
		<cfif len(attributes.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.search_date1#</cfif>
		<cfif len(attributes.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,attributes.search_date2)#</cfif>
		<cfif len(attributes.record_date1)>
			AND EXPENSE_ITEMS_ROWS.RECORD_DATE >= #attributes.record_date1#
		</cfif>
		<cfif len(attributes.record_date2)>
			AND EXPENSE_ITEMS_ROWS.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#
		</cfif>

		<cfif attributes.member_type is 'partner' and len(attributes.expense_part_id) and len(attributes.recorder_name)>
			AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'partner'
			AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #attributes.expense_part_id#
		<cfelseif attributes.member_type is 'consumer' and len(attributes.expense_cons_id) and len(attributes.recorder_name)>
			AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'consumer'
			AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #attributes.expense_cons_id#
		<cfelseif attributes.member_type is 'employee' and len(attributes.expense_emp_id) and len(attributes.recorder_name)>
			AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'employee'
			AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #attributes.expense_emp_id#
		</cfif> 
		<cfif attributes.ch_member_type is 'partner' and len(attributes.ch_company_id) and len(attributes.ch_company)>
			AND 
			(
				(EXPENSE_ITEMS_ROWS.MEMBER_TYPE='partner' AND EXPENSE_ITEMS_ROWS.COMPANY_ID=#attributes.ch_company_id#) OR
				ISNULL((SELECT INV.COMPANY_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_COMPANY_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))=#attributes.ch_company_id#
			)
		<cfelseif attributes.ch_member_type is 'consumer' and len(attributes.ch_consumer_id) and len(attributes.ch_company)>
			AND 
			(
				(EXPENSE_ITEMS_ROWS.MEMBER_TYPE='consumer' AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.ch_consumer_id#) OR
				ISNULL((SELECT INV.CONSUMER_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_CONSUMER_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))=#attributes.ch_consumer_id#
			)
		<cfelseif attributes.ch_member_type is 'employee' and len(attributes.ch_employee_id) and len(attributes.ch_company)>
			AND 
			(
				(EXPENSE_ITEMS_ROWS.MEMBER_TYPE='employee' AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.employee_id_#) OR
				ISNULL((SELECT INV.EMPLOYEE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))=#attributes.employee_id_#
			)
		</cfif>
		<cfif not get_module_power_user(48)><!--- Ehesap Yetkisi Yoksa Calisanlari Gormesin --->
			AND
			(	(ISNULL(EXPENSE_ITEMS_ROWS.INVOICE_ID,0) <> 0 AND ISNULL((SELECT INV.EMPLOYEE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),0)= 0) OR
				(ISNULL(EXPENSE_ITEMS_ROWS.EXPENSE_ID,0) <> 0 AND ISNULL((SELECT EXP.CH_EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID),0) = 0) OR
				(ISNULL(EXPENSE_ITEMS_ROWS.EXPENSE_ID,0) = 0 AND (ISNULL(EXPENSE_ITEMS_ROWS.MEMBER_TYPE,0) <> 'employee'))
			)
		</cfif>
		<cfif len(attributes.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #attributes.expense_item_id#</cfif>
		<cfif isdefined("attributes.expense_center_id_list") and len(attributes.expense_center_id_list)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID IN (#attributes.expense_center_id_list#)</cfif>
		<cfif len(attributes.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #attributes.activity_type#</cfif>
		<cfif len(attributes.asset) and len(attributes.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #attributes.asset_id#</cfif>
		<cfif len(attributes.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID IN (#attributes.project_id#)</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND EXPENSE_ITEMS_ROWS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
		<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
			AND EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
							(SELECT 
								EXP.EXPENSE_ID 
							FROM 
								EXPENSE_ITEM_PLANS EXP 
							WHERE 
								EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
								AND EXP.ACC_TYPE_ID = #attributes.acc_type_id#)
		</cfif>
		<cfif isdefined("attributes.expense_paper_type") and len(attributes.expense_paper_type)>
			AND EXPENSE_ITEMS_ROWS.PAPER_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_paper_type#">
		</cfif>
   ),
   CTE2 AS (
            SELECT
                CTE1.*,
                ROW_NUMBER() OVER (ORDER BY EXPENSE_DATE,EXP_ITEM_ROWS_ID DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT,
            	XXX.*
            FROM
                CTE1
                	OUTER APPLY
						(
							SELECT 
                                SUM((AMOUNT*ISNULL(QUANTITY,1))) AS toplam1,
                                SUM(amount_kdv) AS toplam2,
                                SUM(amount_otv) AS toplam8, 
								SUM(AMOUNT_OIV) AS toplam_oiv, 
                                SUM((AMOUNT*ISNULL(QUANTITY,1))+amount_kdv+amount_otv) AS toplam3
							FROM CTE1 
						) AS XXX
       	  )
        SELECT
            CTE2.*
        FROM
            CTE2
        WHERE
            RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)      
</cfquery>
