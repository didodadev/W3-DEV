<cfparam name="attributes.module_id_control" default="49,1">
<cfinclude template="report_authority_control.cfm">
<cf_get_lang_set module_name="report">
<cf_xml_page_edit fuseact="report.cost_analyse_report">
<cfparam name="attributes.expense_cat" default="">
<cfparam name="attributes.search_date1" default='#dateformat(now(),dateformat_style)#'>
<cfparam name="attributes.search_date2" default='#dateformat(now(),dateformat_style)#'>
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_name" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.partner_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.process_typeReport" default="">
<cfparam name="attributes.report_sort" default="0">
<cfparam name="attributes.is_expence" default="0">
<cfparam name="attributes.is_expence_item" default="0">
<cfparam name="attributes.is_activity" default="0">
<cfparam name="attributes.is_expence_cat" default="0">
<cfparam name="attributes.is_expence_member" default="0">
<cfparam name="attributes.is_date" default="0">
<cfparam name="attributes.is_other_money" default="0">
<cfparam name="attributes.is_asset" default="0">
<cfparam name="attributes.is_stock" default="0">
<cfparam name="attributes.is_detail" default="0">
<cfparam name="attributes.is_project" default="0">
<cfparam name="attributes.is_work" default="0">
<cfparam name="attributes.is_opp" default="0">
<cfparam name="attributes.is_row" default="0">
<cfparam name="attributes.is_cumulative" default="0">
<cfparam name="attributes.opp_id_" default="">
<cfparam name="attributes.opp_head_" default="">
<cfparam name="attributes.work_id_" default="">
<cfparam name="attributes.work_head_" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.company_id_" default="">
<cfparam name="attributes.company_" default="">
<cfparam name="attributes.consumer_id_" default="">
<cfparam name="attributes.employee_id_" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfif isdefined('attributes.ajax')><!--- Kümüle Raporlar için Dönem ve şirket farklı gönderilebilir! --->
	<cfif isdefined('attributes.new_sirket_data_source')>
		<cfset dsn3 = attributes.new_sirket_data_source>
	</cfif>
	<cfif isdefined('attributes.new_donem_data_source')>
		<cfset dsn2 = attributes.new_donem_data_source>
	</cfif>
</cfif>
<!--- <cfif not (attributes.is_expence or attributes.is_asset or attributes.is_stock or attributes.is_detail or attributes.is_project or attributes.is_work or attributes.is_opp or attributes.is_row or attributes.is_other_money or attributes.is_date or attributes.is_expence_item or attributes.is_activity or attributes.is_expence_cat or attributes.is_expence_member)>
	<cfset attributes.form_exist = 0>
</cfif> --->
<cfif len(attributes.search_date1)>
	<cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
	<cf_date tarih='attributes.search_date2'>
</cfif>
 <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY EXPENSE_ITEM_NAME
</cfquery> 
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER 
	<cfif x_authorized_branch eq 1>
		WHERE
			EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			AND EXPENSE_DEPARTMENT_ID IN(SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	ORDER BY EXPENSE_CODE
</cfquery>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfoutput query="GET_ACTIVITY_TYPES">
	<cfset 'ACTIVITY_NAME#ACTIVITY_ID#' = ACTIVITY_NAME>
</cfoutput>
<cfquery name="GET_EXPENSE_CAT" datasource="#dsn2#">
	SELECT * FROM EXPENSE_CATEGORY ORDER BY EXPENSE_CAT_NAME
</cfquery>
<cfquery name="get_tax" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif isDefined("attributes.form_exist") and len(attributes.form_exist)>
	<cfquery name="GET_EXPENSE_ITEM_ROW_ALL" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#" >
        WITH CTE1 AS (
            SELECT
                EXPENSE_ITEMS_ROWS.IS_INCOME,
                EXPENSE_ITEMS_ROWS.INVOICE_ID,
            <cfif attributes.is_expence>
                EXPENSE_CENTER.EXPENSE,
                <cfif attributes.is_row eq 0>
                    EXPENSE_CENTER.EXPENSE_ID,
                </cfif>
            </cfif>
            <cfif attributes.is_expence_item>
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_ITEMS.EXPENSE_ITEM_ID,
                <cfif attributes.is_row eq 1>EXPENSE_ITEMS_ROWS.EXPENSE_ACCOUNT_CODE ACCOUNT_CODE<cfelse>EXPENSE_ITEMS.ACCOUNT_CODE</cfif>,
            </cfif>
            <cfif attributes.is_activity>
                EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE,
            </cfif>
            <cfif attributes.is_expence_cat>
                EXPENSE_ITEMS.EXPENSE_CATEGORY_ID,
            </cfif>
            <cfif attributes.is_expence_member and attributes.is_row eq 0>
                EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
                EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
                EXPENSE_ITEMS_ROWS.COMPANY_ID,
            </cfif>
            <cfif attributes.is_date>
                EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
            </cfif>
            <cfif attributes.is_other_money>
                <cfif attributes.is_row eq 0>
                    SUM(ISNULL(EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL,0)) OTHER_MONEY_GROSS_TOTAL,
                <cfelse>
                    ISNULL(EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL,0) OTHER_MONEY_GROSS_TOTAL,
                </cfif>
                EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
            </cfif>
            <cfif attributes.is_asset>
                EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID,
            </cfif>
            <cfif attributes.is_stock>
                EXPENSE_ITEMS_ROWS.PRODUCT_ID,
                EXPENSE_ITEMS_ROWS.STOCK_ID_2,
                <cfif x_show_quantity_with_stock eq 1>EXPENSE_ITEMS_ROWS.QUANTITY,</cfif>
            </cfif>
            <cfif attributes.is_detail and attributes.is_row eq 0>
                SUBSTRING(EXPENSE_ITEMS_ROWS.DETAIL,1,50) DETAIL,
            </cfif>
            <cfif attributes.is_project>
                P.PROJECT_HEAD,
            </cfif>
            <cfif attributes.is_work>
                EXPENSE_ITEMS_ROWS.WORK_ID,
            </cfif>
            <cfif attributes.is_opp>
                EXPENSE_ITEMS_ROWS.OPP_ID,
            </cfif>
            <cfif attributes.is_row eq 0>
                SUM(ISNULL(EXPENSE_ITEMS_ROWS.AMOUNT,0)*(ISNULL(EXPENSE_ITEMS_ROWS.QUANTITY,1))) AMOUNT,
                SUM(ISNULL(EXPENSE_ITEMS_ROWS.AMOUNT_KDV,0)) AMOUNT_KDV,
                SUM(ISNULL(EXPENSE_ITEMS_ROWS.AMOUNT_OTV,0)) AMOUNT_OTV,
                SUM(ISNULL(EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT,0)) TOTAL_AMOUNT,
            <cfelse>
                EXPENSE_ITEMS_ROWS.EXPENSE_ID EXP_ID_,
                EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
                EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
                EXPENSE_ITEMS_ROWS.COMPANY_ID,
                SUBSTRING(EXPENSE_ITEMS_ROWS.DETAIL,1,50) DETAIL,
                ISNULL(EXPENSE_ITEMS_ROWS.AMOUNT,0)*(ISNULL(EXPENSE_ITEMS_ROWS.QUANTITY,1)) AMOUNT,
                ISNULL(EXPENSE_ITEMS_ROWS.AMOUNT_KDV,0) AMOUNT_KDV,
                ISNULL(EXPENSE_ITEMS_ROWS.AMOUNT_OTV,0) AMOUNT_OTV,
                ISNULL(EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT,0) TOTAL_AMOUNT,
                EXPENSE_ITEMS_ROWS.RECORD_EMP,
                ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL((SELECT INV.COMPANY_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_COMPANY_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))) CH_COMPANY_ID,
                ISNULL((SELECT INV.CONSUMER_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_CONSUMER_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)) CH_CONSUMER_ID,
                ISNULL((SELECT INV.EMPLOYEE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)) CH_EMPLOYEE_ID,
                ISNULL(ROW_PAPER_NO,ISNULL((SELECT EXP.PAPER_NO FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID),(SELECT II.INVOICE_NUMBER FROM INVOICE II WHERE II.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID))) PAPER_NO,
                EXPENSE_ITEMS_ROWS.RECORD_DATE,
            </cfif>
            ROW_NUMBER() OVER ( ORDER BY EXPENSE_ITEMS_ROWS.IS_INCOME ) AS ROWNUM
            FROM 
                EXPENSE_ITEMS_ROWS
                    <cfif attributes.is_project>LEFT JOIN #dsn_alias#.PRO_PROJECTS P ON P.PROJECT_ID = EXPENSE_ITEMS_ROWS.PROJECT_ID</cfif>,
                EXPENSE_ITEMS,
                EXPENSE_CENTER
            WHERE 
                EXPENSE_ITEMS_ROWS.IS_INCOME = 0 AND
                EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND
                EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
                <cfif session.ep.isBranchAuthorization>
                    AND EXPENSE_CENTER.EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
                <cfif len(attributes.company_id_) and len(attributes.company_)>
                    AND EXPENSE_ITEMS_ROWS.EXPENSE_ID IN (
                                                        SELECT 
                                                            EX.EXPENSE_ID	
                                                        FROM
                                                            EXPENSE_ITEM_PLANS EX
                                                        WHERE
                                                            EX.CH_COMPANY_ID = #attributes.company_id_#
                                                         )
                </cfif>
                <cfif len(attributes.consumer_id_) and len(attributes.company_)>
                    AND EXPENSE_ITEMS_ROWS.EXPENSE_ID IN (
                                                        SELECT 
                                                            EX.EXPENSE_ID	
                                                        FROM
                                                            EXPENSE_ITEM_PLANS EX
                                                        WHERE
                                                            EX.CH_CONSUMER_ID = #attributes.consumer_id_#
                                                         )
                </cfif>
                <cfif len(attributes.employee_id_) and len(attributes.company_)>
                    AND EXPENSE_ITEMS_ROWS.EXPENSE_ID IN (
                                                        SELECT 
                                                            EX.EXPENSE_ID	
                                                        FROM
                                                            EXPENSE_ITEM_PLANS EX
                                                        WHERE
                                                            EX.CH_EMPLOYEE_ID = #attributes.employee_id_#
                                                         )
                </cfif>
                <cfif len(attributes.expense_cat)>AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID IN (#attributes.expense_cat#)</cfif>
                <cfif not get_module_power_user(48)>
                    AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID NOT IN (SELECT EC.EXPENSE_CAT_ID FROM EXPENSE_CATEGORY EC WHERE ISNULL(EC.EXPENCE_IS_HR,0) = 1)
                </cfif>
                <cfif len(attributes.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#"></cfif>
                <cfif len(attributes.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add("d",1,attributes.search_date2)#"></cfif>
                <cfif len(attributes.member_name) and len(attributes.member_type) and len(attributes.member_id)>
                    AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_type#">
                    AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#member_id#">
                </cfif>
                <cfif len(attributes.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID IN (#attributes.expense_item_id#)</cfif>
                <cfif len(attributes.expense_center_id)>
                    AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID IN (#attributes.expense_center_id#)
                <cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center")>
                    <cfif len(get_expense_center.expense_id)>
                        AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center.expense_id,','))#)
                    <cfelse>
                        AND 1=0
                    </cfif>
                </cfif>
                <cfif len(attributes.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE IN (#attributes.activity_type#)</cfif>
                <cfif len(attributes.asset) and len(attributes.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#"></cfif>
                <cfif len(attributes.project) and len(attributes.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"></cfif>
                <cfif len(attributes.subscription_name) and len(attributes.subscription_id)>AND EXPENSE_ITEMS_ROWS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#"></cfif>
                <cfif len(attributes.process_typeReport)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ID IN (SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLANS WHERE PROCESS_CAT IN (#attributes.process_typeReport#))</cfif>
                <cfif isdefined("attributes.work_id_") and len(attributes.work_id_) and isdefined("attributes.work_head_") and len(attributes.work_head_)>AND EXPENSE_ITEMS_ROWS.WORK_ID IN (#attributes.work_id_#)</cfif>
                <cfif isdefined("attributes.opp_id_") and len(attributes.opp_id_) and isdefined("attributes.opp_head_") and len(attributes.opp_head_)>AND EXPENSE_ITEMS_ROWS.OPP_ID IN (#attributes.opp_id_#)</cfif>
                <cfif attributes.is_row eq 1 and len(attributes.record_emp_id) and len(attributes.record_emp_name)>AND EXPENSE_ITEMS_ROWS.RECORD_EMP = #attributes.record_emp_id#</cfif>
            <cfif attributes.is_row eq 0>
                GROUP BY
                    <cfif attributes.is_expence>
                        EXPENSE_CENTER.EXPENSE,
                        EXPENSE_CENTER.EXPENSE_ID,
                    </cfif>
                    <cfif attributes.is_expence_item>
                        EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                        EXPENSE_ITEMS.EXPENSE_ITEM_ID,
                        EXPENSE_ITEMS.ACCOUNT_CODE,
                    </cfif>
                    <cfif attributes.is_activity>
                        EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE,
                    </cfif>
                    <cfif attributes.is_expence_cat>
                        EXPENSE_ITEMS.EXPENSE_CATEGORY_ID,
                    </cfif>
                    <cfif attributes.is_expence_member>
                        EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
                        EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
                        EXPENSE_ITEMS_ROWS.COMPANY_ID,
                    </cfif>
                    <cfif attributes.is_date>
                        EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
                    </cfif>
                    <cfif attributes.is_other_money>
                        EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
                    </cfif>
                    <cfif attributes.is_asset>
                        EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID,
                    </cfif>
                    <cfif attributes.is_stock>
                        EXPENSE_ITEMS_ROWS.PRODUCT_ID,
                        EXPENSE_ITEMS_ROWS.STOCK_ID_2,
                        <cfif x_show_quantity_with_stock eq 1>EXPENSE_ITEMS_ROWS.QUANTITY,</cfif>
                    </cfif>
                    <cfif attributes.is_detail>
                        SUBSTRING(EXPENSE_ITEMS_ROWS.DETAIL,1,50),
                    </cfif>
                    <cfif attributes.is_project>
                        P.PROJECT_HEAD,
                    </cfif>
                    <cfif attributes.is_work>
                        EXPENSE_ITEMS_ROWS.WORK_ID,
                    </cfif>
                    <cfif attributes.is_opp>
                        EXPENSE_ITEMS_ROWS.OPP_ID,
                    </cfif>
                    EXPENSE_ITEMS_ROWS.IS_INCOME,
                    EXPENSE_ITEMS_ROWS.INVOICE_ID
            </cfif>
            ),
            CTE2 AS (
            	SELECT
                	ROUND(SUM(ISNULL(AMOUNT,0)),2) AS ALL_TOTAL,
                    ROUND(SUM(ISNULL(AMOUNT_KDV,0)),2) AS ALL_KDV_TOTAL,
                    ROUND(SUM(ISNULL(AMOUNT_OTV,0)),2) AS ALL_OTV_TOTAL,
                    ROUND(SUM(ISNULL(TOTAL_AMOUNT,0)),2) AS ALL_GRAND_TOTAL
                FROM
                	CTE1
            ),
            CTE3 AS (
            	SELECT
                	ROUND(SUM(ISNULL(AMOUNT,0)),2) AS PAGE_TOTAL,
                    ROUND(SUM(ISNULL(AMOUNT_KDV,0)),2) AS PAGE_KDV_TOTAL,
                    ROUND(SUM(ISNULL(AMOUNT_OTV,0)),2) AS PAGE_OTV_TOTAL,
                    ROUND(SUM(ISNULL(TOTAL_AMOUNT,0)),2) AS PAGE_GRAND_TOTAL
                FROM
                	CTE1
                <cfif  attributes.is_excel neq 1>
                    WHERE
                	    ROWNUM BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
                </cfif>
            ),
            CTE4 AS (
            	SELECT
                	ROUND(SUM(ISNULL(AMOUNT,0)),2) AS CUM_TOTAL,
                    ROUND(SUM(ISNULL(TOTAL_AMOUNT,0)),2) AS CUM_GRAND_TOTAL
                FROM
                	CTE1
                <cfif attributes.is_excel neq 1>
                    WHERE
                	    ROWNUM <= #attributes.startrow#+(#attributes.maxrows#-1)
                </cfif>
            )
            
            SELECT
            	CTE1.*,
                (SELECT PAGE_TOTAL FROM CTE3) AS PAGE_TOTAL,
                (SELECT PAGE_KDV_TOTAL FROM CTE3) AS PAGE_KDV_TOTAL,
                (SELECT PAGE_OTV_TOTAL FROM CTE3) AS PAGE_OTV_TOTAL,
                (SELECT PAGE_GRAND_TOTAL FROM CTE3) AS PAGE_GRAND_TOTAL,
                (SELECT ALL_TOTAL FROM CTE2) AS ALL_TOTAL,
                (SELECT ALL_KDV_TOTAL FROM CTE2) AS ALL_KDV_TOTAL,
                (SELECT ALL_OTV_TOTAL FROM CTE2) AS ALL_OTV_TOTAL,
                (SELECT ALL_GRAND_TOTAL FROM CTE2) AS ALL_GRAND_TOTAL,
                (SELECT CUM_TOTAL FROM CTE4) AS CUM_TOTAL,
                (SELECT CUM_GRAND_TOTAL FROM CTE4) AS CUM_GRAND_TOTAL,
			<cfif attributes.is_row>
                (CASE WHEN CTE1.CH_COMPANY_ID IS NOT NULL THEN COMP.FULLNAME WHEN CTE1.CH_CONSUMER_ID IS NOT NULL THEN CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME WHEN CTE1.CH_EMPLOYEE_ID IS NOT NULL THEN EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME ELSE NULL END) AS CARI_HESAP,
            </cfif>
            <cfif attributes.is_work>
                PW.WORK_HEAD,
            </cfif>
            <cfif attributes.is_opp>
            	O.OPP_HEAD,
            </cfif>
            <cfif attributes.is_expence_cat>
                EC.EXPENSE_CAT_NAME,
            </cfif>
            <cfif attributes.is_row>
                REC_EMP.EMPLOYEE_NAME + ' ' + REC_EMP.EMPLOYEE_SURNAME AS REC_EMP_FULLNAME,
            </cfif>
            <cfif attributes.is_expence_member>
                EXP_EMP.EMPLOYEE_NAME + ' ' + EXP_EMP.EMPLOYEE_SURNAME AS EXPENSE_EMPLOYEE,
            </cfif>
            <cfif attributes.is_activity>
            	SA.ACTIVITY_NAME,
            </cfif>
            <cfif attributes.is_asset>
                A.ASSETP,
            </cfif>
            <cfif attributes.is_stock>
                S.PRODUCT_NAME,
            </cfif>
			<cfif attributes.is_cumulative and attributes.is_expence_item>
                ROUND((SUM(AMOUNT) OVER (<cfif is_expence_item>PARTITION BY EI.EXPENSE_ITEM_ID</cfif> ORDER BY TOTAL_AMOUNT DESC ROWS UNBOUNDED PRECEDING)),2) AS CUM_TOTAL,
                ROUND((SUM(TOTAL_AMOUNT) OVER (<cfif is_expence_item>PARTITION BY EI.EXPENSE_ITEM_ID</cfif> ORDER BY TOTAL_AMOUNT DESC ROWS UNBOUNDED PRECEDING)),2) CUM_LAST_TOTAL,
                '#session.ep.money#' CUM_MONEY,
            </cfif>
                (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
            FROM
            	CTE1
				<cfif attributes.is_work>
                    LEFT JOIN #dsn_alias#.PRO_WORKS PW ON PW.WORK_ID = CTE1.WORK_ID
                </cfif>
                <cfif attributes.is_opp>
                    LEFT JOIN #dsn3_alias#.OPPORTUNITIES O ON O.OPP_ID = CTE1.OPP_ID
                </cfif>
                <cfif attributes.is_expence_cat>
                    LEFT JOIN #dsn2_alias#.EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = CTE1.EXPENSE_CATEGORY_ID
                </cfif>
                <cfif attributes.is_expence_item>
                    LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = CTE1.EXPENSE_ITEM_ID
                </cfif>
                <cfif attributes.is_expence_member>
                    LEFT JOIN #dsn_alias#.EMPLOYEES EXP_EMP ON EXP_EMP.EMPLOYEE_ID = CTE1.COMPANY_PARTNER_ID
                </cfif>
                <cfif attributes.is_activity>
                    LEFT JOIN #dsn_alias#.SETUP_ACTIVITY SA ON SA.ACTIVITY_ID = CTE1.ACTIVITY_TYPE
                </cfif>
                <cfif attributes.is_asset>
                    LEFT JOIN #dsn_alias#.ASSET_P A ON A.ASSETP_ID = CTE1.PYSCHICAL_ASSET_ID
                </cfif>
                <cfif attributes.is_stock>
                    LEFT JOIN #dsn3_alias#.STOCKS S ON S.STOCK_ID = CTE1.STOCK_ID_2
                </cfif>
                <cfif attributes.is_row>
                    LEFT JOIN #dsn_alias#.EMPLOYEES REC_EMP ON REC_EMP.EMPLOYEE_ID = CTE1.RECORD_EMP
                    LEFT JOIN #dsn_alias#.COMPANY COMP ON COMP.COMPANY_ID = CTE1.CH_COMPANY_ID
                    LEFT JOIN #dsn_alias#.CONSUMER CONS ON CONS.CONSUMER_ID = CTE1.CH_CONSUMER_ID
                    LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = CTE1.CH_EMPLOYEE_ID
                </cfif>
            <cfif attributes.is_excel neq 1>
                WHERE
            	    ROWNUM BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
            </cfif>
            ORDER BY
            	CTE1.ROWNUM
	</cfquery>
<cfelse>
	<cfset get_expense_item_row_all.recordcount = 0>
    <cfset get_expense_item_row_all.QUERY_COUNT = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_expense_item_row_all.QUERY_COUNT#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39154.Detaylı Harcama Analiz Raporu'></cfsavecontent>
<cf_report_list_search title="#title#">
    <cf_report_list_search_area>
        <cfform name="search_asset" action="#request.self#?fuseaction=#fusebox.circuit#.cost_analyse_report" method="post">
        <input name="form_exist" id="form_exist" type="hidden" value="1">
        <div class="row"> 
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-3 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-expense_center_id">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <select name="expense_center_id" id="expense_center_id" style="width:200px;height:75px;" class="txt" multiple>
                                        <cfoutput query="get_expense_center">
                                            <option value="#EXPENSE_ID#" <cfif listfind(attributes.expense_center_id,EXPENSE_ID,',')>selected</cfif>>
                                                <cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">
                                                    &nbsp;
                                                </cfloop>
                                                #expense#
                                            </option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-expense_item_id">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <select name="expense_item_id" id="expense_item_id" style="width:200px;height:130px;" class="txt" multiple>
                                        <cfoutput query="get_expense_item">
                                            <option value="#EXPENSE_ITEM_ID#" <cfif listfind(attributes.expense_item_id,EXPENSE_ITEM_ID,',')>selected</cfif>>#EXPENSE_ITEM_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-expense_cat">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <select name="expense_cat" id="expense_cat" style="width:200px;height:85px;" multiple>
                                        <cfoutput query="get_expense_cat">
                                            <option value="#expense_cat_id#" <cfif listfind(attributes.expense_cat,expense_cat_id,',')>selected</cfif>>#expense_cat_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-GET_PROCESS_CAT">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
                                        SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="120,122">) ORDER BY PROCESS_CAT
                                    </cfquery>
                                    <select name="process_typeReport" id="process_typeReport" style="width:165px;height:165px;" multiple>
                                        <cfoutput query="get_process_cat">
                                            <option value="#process_cat_id#" <cfif listfind(attributes.process_typeReport,process_cat_id,',')>selected</cfif>>#process_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-activity_type">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39173.Aktivite Tipi'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <select name="activity_type" id="activity_type" style="width:165px;height:130px;" class="txt" multiple>
                                        <cfoutput query="get_activity_types">
                                            <option value="#ACTIVITY_ID#" <cfif listfind(attributes.activity_type,ACTIVITY_ID,',')>selected</cfif>>#ACTIVITY_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>                            
                        </div>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                            <div class="form-group" id="item-asset">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29452.Varlık'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cfif len(attributes.asset) and len(attributes.asset_id)>
                                            <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
                                            <input type="text" name="asset" id="asset" onfocus="AutoComplete_Create('asset','ASSETP','ASSETP','get_assept','3','ASSETP_ID','asset_id','',3,160);" value="<cfoutput>#attributes.asset#</cfoutput>">
                                        <cfelse>
                                            <input type="hidden" name="asset_id" id="asset_id" value="">
                                            <input type="text" name="asset" id="asset" onfocus="AutoComplete_Create('asset','ASSETP','ASSETP','get_assept','3','ASSETP_ID','asset_id','',3,160);" value="">
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=search_asset.asset_id&field_name=search_asset.asset&event_id=0&motorized_vehicle=0','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-project">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cfif len(attributes.project_id) and len(attributes.project)>
                                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                            <input type="text" name="project" id="project" onfocus="AutoComplete_Create('project','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','',3,160);" value="<cfoutput>#attributes.project#</cfoutput>">
                                        <cfelse>
                                            <input type="hidden" name="project_id" id="project_id" value="">
                                            <input type="text" name="project" id="project" onfocus="AutoComplete_Create('project','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','',3,160);" value="" >					
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_asset.project_id&project_head=search_asset.project');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-work_head_">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="work_id_" id="work_id_" value="<cfif isdefined("attributes.work_id_")><cfoutput>#attributes.work_id_#</cfoutput></cfif>">
                                        <input type="text" name="work_head_" id="work_head_" value="<cfif isdefined("attributes.work_head_")><cfoutput>#attributes.work_head_#</cfoutput></cfif>" onfocus="AutoComplete_Create('work_head_','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id_','',3,160);" >
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=search_asset.work_id_&field_name=search_asset.work_head_','list')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-opp_head_">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57612.Fırsat'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="opp_id_" id="opp_id_" value="<cfoutput>#attributes.opp_id_#</cfoutput>">
                                        <input type="text" name="opp_head_" id="opp_head_"  onfocus="AutoComplete_Create('opp_head_','OPP_HEAD','OPP_HEAD','get_opportunity','3','OPP_ID','opp_id_','',3,160);" value="<cfif isdefined("attributes.opp_head_")><cfoutput>#attributes.opp_head_#</cfoutput></cfif>">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_opportunities&field_opp_id=search_asset.opp_id_&field_opp_head=search_asset.opp_head_','list')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-member_name">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39157.Harcama Yapan'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                                        <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#attributes.member_id#</cfoutput>">
                                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                        <input type="text"  name="member_name" id="member_name" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,2,3','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID','member_type,member_id,company_id','',3,160);" value="<cfoutput>#attributes.member_name#</cfoutput>" class="txt">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_company();"></span>
										
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-record_emp_name">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                                        <input type="text" name="record_emp_name" id="record_emp_name"  onfocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','search_asset','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_asset.record_emp_name&field_emp_id=search_asset.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false" title="<cf_get_lang dictionary_id='57899.Kaydeden'>"></span>
                                    </div>
                                </div>
                            </div>
                             <div class="form-group" id="item-company_">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id_" id="consumer_id_" value="<cfif isdefined('attributes.consumer_id_') and len(attributes.company_)><cfoutput>#attributes.consumer_id_#</cfoutput></cfif>">
                                        <input type="hidden" name="company_id_" id="company_id_" value="<cfif len(attributes.company_)><cfoutput>#attributes.company_id_#</cfoutput></cfif>">
                                        <input type="hidden" name="employee_id_"  id="employee_id_"value="<cfif isdefined("attributes.employee_id_") and len(attributes.employee_id_)><cfoutput>#attributes.employee_id_#</cfoutput></cfif>">
                                        <input type="hidden" name="member_type_" id="member_type_" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                        <input type="text" name="company_" id="company_"  onfocus="AutoComplete_Create('company_','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id_,consumer_id_,employee_id_,member_type_','form','3','250');" value="<cfif len(attributes.company_)><cfoutput>#attributes.company_#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_asset.company_&field_comp_id=search_asset.company_id_&field_name=search_asset.company_&field_consumer=search_asset.consumer_id_&field_emp_id=search_asset.employee_id_&field_member_name=search_asset.company_&select_list=1,2,3,9','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-subscription_name">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58832.Abone'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cfif len(attributes.subscription_id) and len(attributes.subscription_name)>
                                            <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#attributes.subscription_id#</cfoutput>">
                                            <input type="text" name="subscription_name" id="subscription_name" onfocus="AutoComplete_Create('subscription_name','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','160');" value="<cfoutput>#attributes.subscription_name#</cfoutput>" >
                                        <cfelse>
                                            <input type="hidden" name="subscription_id" id="subscription_id" value="">
                                            <input type="text" name="subscription_name" id="subscription_name" onfocus="AutoComplete_Create('subscription_name','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','160');" value="" >					
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=search_asset.subscription_id&field_no=search_asset.subscription_name','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-report_sort">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58924.Sıralama'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <select name="report_sort" id="report_sort" class="txt" onchange="kontrol_report_sort();">
                                        <option value="0" <cfif attributes.report_sort eq 0>selected</cfif>><cf_get_lang dictionary_id='57673.Tutar'></option>
                                        <option value="4" <cfif attributes.report_sort eq 4>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
                                        <option value="1" <cfif attributes.report_sort eq 1>selected</cfif>><cf_get_lang dictionary_id='58460.Masraf Merkezi'></option>
                                        <option value="2" <cfif attributes.report_sort eq 2>selected</cfif>><cf_get_lang dictionary_id='58551.Gider Kalemi'></option>
                                        <option value="5" <cfif attributes.report_sort eq 5>selected</cfif>><cf_get_lang dictionary_id="58460.Masraf Merkezi"> <cf_get_lang dictionary_id="57989.ve"> <cf_get_lang dictionary_id="58551.Gider Kalemi"></option>
                                        <option value="3" <cfif attributes.report_sort eq 3>selected</cfif>><cf_get_lang dictionary_id='58690.Tarih'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-graph_type">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39741.Grafik'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <select name="graph_type" id="graph_type">
                                        <option value="" selected><cf_get_lang dictionary_id='57950.Grafik Format'></option>
                                        <option value="radar" <cfif attributes.graph_type eq 'radar'> selected</cfif>><cf_get_lang dictionary_id='60666.Radar'></option>
                                        <option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
                                        <option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-search_dates">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                        <cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes">                                                                              
                                        <cfif not isdefined('attributes.ajax')>
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
                                        </cfif>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                        <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes">
                                        <cfif not isdefined('attributes.ajax')>
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
                                        </cfif>
                                    </div>
                                </div>
                            </div>                            
                        </div>
                        <div class="col col-2 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-report_baz">
                                <div class="col col-9 col-xs-12">
                                    <label class="col col-12"><cf_get_lang dictionary_id='39174.Rapor Baz'></label> 
                                    <cfset list_num = 0>
                                    <label class="col col-12"><input name="is_project" id="is_project" value="1" type="checkbox" <cfif attributes.is_project eq 1 >checked<cfset list_num = list_num +1></cfif>><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <label class="col col-12"><input name="is_work" id="is_work" value="1" type="checkbox" <cfif attributes.is_work eq 1 >checked<cfset list_num = list_num + 1></cfif>><cf_get_lang dictionary_id='58445.İş'></label>
                                    <label class="col col-12"><input name="is_opp" id="is_opp" value="1" type="checkbox" <cfif attributes.is_opp eq 1 >checked<cfset list_num = list_num + 1></cfif>><cf_get_lang dictionary_id='57612.Fırsat'></label>
                                    <label class="col col-12"><input name="is_expence" id="is_expence" value="1" type="checkbox" <cfif attributes.is_expence eq 1 >checked<cfset list_num = list_num +1></cfif>><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                                    <label class="col col-12"><input name="is_expence_cat" id="is_expence_cat" value="1" type="checkbox" <cfif attributes.is_expence_cat eq 1 >checked<cfset list_num = list_num +1></cfif>><cf_get_lang dictionary_id='39175.Gider Kategori'></label>
                                    <label class="col col-12"><input name="is_expence_item" id="is_expence_item" value="1" type="checkbox" <cfif attributes.is_expence_item eq 1 >checked<cfset list_num = list_num +1></cfif>><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                                    <label class="col col-12"><input name="is_activity" id="is_activity" value="1" type="checkbox" <cfif attributes.is_activity eq 1 >checked<cfset list_num = list_num +1></cfif>><cf_get_lang dictionary_id='39173.Aktivite Tipi'></label>
                                    <label class="col col-12"><input name="is_expence_member" id="is_expence_member" value="1" type="checkbox" <cfif attributes.is_expence_member eq 1 >checked<cfset list_num = list_num +1></cfif>><cf_get_lang dictionary_id='39157.Harcama Yapan'></label>
                                    <label class="col col-12"><input name="is_date" id="is_date" value="1" type="checkbox" <cfif attributes.is_date eq 1 >checked<cfset list_num = list_num +1></cfif>><cf_get_lang dictionary_id='58690.Tarih'></label>
                                    <label class="col col-12"><input name="is_other_money" id="is_other_money" value="1" type="checkbox" <cfif attributes.is_other_money eq 1 >checked<cfset list_num = list_num +2></cfif>><cf_get_lang dictionary_id='57677.Döviz'></label>
                                    <label class="col col-12"><input name="is_asset" id="is_asset" value="1" type="checkbox" <cfif attributes.is_asset eq 1>checked<cfset list_num = list_num +1></cfif>><cf_get_lang dictionary_id='29452.Varlık'></label>
                                    <label class="col col-12"><input name="is_stock" id="is_stock" value="1" type="checkbox" <cfif attributes.is_stock eq 1>checked<cfif x_show_quantity_with_stock eq 1><cfset list_num = list_num +2><cfelse><cfset list_num = list_num +1></cfif></cfif>><cf_get_lang dictionary_id='57452.Stok'></label>
                                    <label class="col col-12"><input name="is_detail" id="is_detail" value="1" type="checkbox" <cfif attributes.is_detail eq 1 >checked<cfif attributes.is_row eq 0><cfset list_num = list_num +1></cfif></cfif>><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <label class="col col-12"><input name="is_row" id="is_row" value="1" type="checkbox" <cfif attributes.is_row eq 1 >checked<cfset list_num = list_num + 4></cfif>><cf_get_lang dictionary_id='58508.Satır'></label>
                                    <label class="col col-12"><input name="is_cumulative" id="is_cumulative" value="1" type="checkbox" <cfif attributes.is_cumulative eq 1>checked</cfif>><cf_get_lang dictionary_id="39838.Kümüle Tutar"></label>
                                </div>
                            </div>                                               
                        </div>                        
                    </div>                
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
                        <cfelse>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                        </cfif>            
                        <cf_wrk_report_search_button search_function='degistir_action()' button_type='1' is_excel='1'>
                    </div>
                </div>
            </div>
        </div>
    </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename="sale_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="content-type" content="text/plain; charset=utf-16">
    <cfset type_ = 1 >
<cfelse>
    <cfset type_ = 0 >
</cfif>
<cfif isdefined("attributes.form_exist") and len(attributes.form_exist)>
    <cf_report_list>
        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset type_ = 1>
            <cfset attributes.startrow=1>
            <cfset attributes.maxrows = get_expense_item_row_all.QUERY_COUNT>	
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <cfif isdefined('attributes.ajax')>
            <cfset style="display:none;">
        <cfelse>
            <cfset style="">
        </cfif>
        <thead>
            <tr>
                <th class="form-title" width="25"><cf_get_lang dictionary_id='57487.No'></th>
                <cfif attributes.is_detail and attributes.is_row eq 0>
                    <th class="form-title" width="180"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                </cfif>
                <cfif attributes.is_project>
                    <th class="form-title" width="180"><cf_get_lang dictionary_id='57416.Proje'></th>
                </cfif>
                <cfif attributes.is_work>
                    <th class="form-title" width="130"><cf_get_lang dictionary_id='58445.İş'></th>
                </cfif>
                <cfif attributes.is_opp>
                    <th class="form-title" width="130"><cf_get_lang dictionary_id='57612.Fırsat'></th>
                </cfif>
                <cfif attributes.is_expence>
                    <th class="form-title" width="170"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
                </cfif>
                <cfif attributes.is_expence_cat>
                    <th class="form-title" width="180"><cf_get_lang dictionary_id='39175.Gider Kat'></th>
                </cfif>
                <cfif attributes.is_expence_item>
                    <th class="form-title" width="170"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
                    <cfif isdefined("x_show_account_code") and x_show_account_code eq 1><th class="form-title" width="100"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th></cfif>
                </cfif>
                <cfif attributes.is_row>
                    <th class="form-title" width="180"><cf_get_lang dictionary_id='57880.Belge No'></th>
                    <th class="form-title" width="100"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                    <th class="form-title" width="100"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th class="form-title" width="100"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                </cfif>
                <cfif attributes.is_date>
                    <th class="form-title"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></th>
                </cfif>
                <cfif attributes.is_detail and attributes.is_project and attributes.is_work and attributes.is_date and attributes.is_row>
                    <th class="form-title"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                </cfif>
                <cfif attributes.is_expence_member>
                    <th class="form-title" width="180"><cf_get_lang dictionary_id='39157.Harcama Yapan'></th>
                </cfif>
                <cfif attributes.is_activity>
                    <th class="form-title" width="180"><cf_get_lang dictionary_id='39180.Aktivite'></th>
                </cfif>
                <cfif attributes.is_asset>
                    <th class="form-title" width="180"><cf_get_lang dictionary_id='29452.Varlık'></th>
                </cfif>
                <cfif attributes.is_stock>
                    <th class="form-title" width="180"><cf_get_lang dictionary_id='57452.Stok'></th>
                    <cfif x_show_quantity_with_stock eq 1><th class="form-title" width="60"><cf_get_lang dictionary_id='57635.Miktar'></th></cfif>
                </cfif>
                <cfif attributes.is_other_money>
                    <th width="120"  align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
                    <th align="center" class="form-title" ><cf_get_lang dictionary_id='58474.Birim'></th>
                </cfif>
                <th width="120" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                <th align="center" class="form-title" ><cf_get_lang dictionary_id='58474.Birim'></th>
                <th width="120" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
                <th align="center" class="form-title" ><cf_get_lang dictionary_id='58474.Birim'></th>		 
                <th width="120" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58021.ÖTV'></th>
                <th align="center" class="form-title" ><cf_get_lang dictionary_id='58474.Birim'></th>		 
                <th width="120" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57644.Son Toplam'></th>
                <th align="center" class="form-title" ><cf_get_lang dictionary_id='58474.Birim'></th>	
                <cfif attributes.is_cumulative and attributes.is_expence_item>
                    <th width="120" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="39838.Kümüle Tutar"></th>
                    <th width="135" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="39842.Kümüle Son Toplam"></th>
                    <th align="center" class="form-title" ><cf_get_lang dictionary_id='58474.Birim'></th>
                </cfif>
            </tr>
        </thead>
        <cfif get_expense_item_row_all.recordcount>
            <cfquery name="GET_ACTIVITY_TYPES_1" dbtype="query">
                SELECT ACTIVITY_ID, ACTIVITY_NAME FROM GET_ACTIVITY_TYPES ORDER BY ACTIVITY_ID
            </cfquery>
            <cfquery name="GET_EXPENSE_CAT_1" dbtype="query">
                SELECT EXPENSE_CAT_ID, EXPENSE_CAT_NAME FROM GET_EXPENSE_CAT ORDER BY EXPENSE_CAT_ID
            </cfquery>
            <cfoutput query="get_tax">
                <cfset 'genel_toplam_#tax#' = 0>
            </cfoutput>
                <cfif isdefined('attributes.ajax')><!--- Kümülatif raporlar oluşturuluyorsa! --->
                    <cfoutput query="get_expense_item_row_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfinclude template="../../settings/cumulative/cumulative_expense_month.cfm">
                    </cfoutput>
                    <cfif get_expense_item_row_all.recordcount gte (attributes.startrow+attributes.maxrows)>
                        <script type="text/javascript">
                            user_info_show_div(<cfoutput>#attributes.page+1#,#(((attributes.startrow+attributes.maxrows)*100)/get_expense_item_row_all.recordcount)#</cfoutput>);
                        </script>
                    <cfelse>
                        <script type="text/javascript">
                            user_info_show_div(1,1,1);
                        </script>
                        <cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
                            UPDATE 
                                REPORT_SYSTEM 
                            SET 
                                PROCESS_FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                PROCESS_ROW_COUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense_item_row_all.recordcount#">
                            WHERE 
                                REPORT_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#"> AND 
                                PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#"> AND 
                                PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_month#"> AND 
                                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_our_company_id#">
                        </cfquery>
                    </cfif>
                    <cfabort>
                <cfelse> 
                    <tbody>   
                        <cfoutput query="get_expense_item_row_all">
                            <cfif isDefined("INVOICE_ID") and len(INVOICE_ID)>
                                <cfquery name="get_product_name" datasource="#dsn2#">
                                    SELECT PRODUCT_ID,NAME_PRODUCT,AMOUNT FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#INVOICE_ID#">
                                </cfquery>
                            </cfif>
                            <tr>
                                <td>#ROWNUM#</td>
                                <cfif attributes.is_detail and attributes.is_row eq 0>
                                    <td>#DETAIL#</td>					
                                </cfif>
                                <cfif attributes.is_project>
                                    <td>
                                        #PROJECT_HEAD#
                                    </td>					
                                </cfif>
                                <cfif attributes.is_work>
                                    <td>
                                        #WORK_HEAD#
                                    </td>
                                </cfif>
                                <cfif attributes.is_opp>
                                    <td>
                                        #OPP_HEAD#
                                    </td>					
                                </cfif>
                                <cfif attributes.is_expence>
                                    <td>#expense#</td>
                                </cfif>
                                <cfif attributes.is_expence_cat>
                                    <td>#EXPENSE_CAT_NAME#</td>
                                </cfif>
                                <cfif attributes.is_expence_item>
                                    <td>#expense_item_name#</td>
                                    <cfif isdefined("x_show_account_code") and x_show_account_code eq 1><td>#account_code#</td></cfif>
                                </cfif>
                                <cfif attributes.is_row>
                                    <td>
                                        <cfif EXP_ID_ gt 0>
                                            <a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#EXP_ID_#" class="tableyazi">#PAPER_NO#</a>
                                        <cfelse>
                                                #PAPER_NO#
                                        </cfif>
                                    </td>
                                    <td width="150">
                                        #CARI_HESAP#
                                    </td>
                                    <td>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#REC_EMP_FULLNAME#</a>
                                    </td>
                                    <td width="150">#DETAIL#</td>					
                                </cfif>
                                <cfif attributes.is_date>
                                    <td format="date">#dateformat(expense_date,dateformat_style)#</td>
                                </cfif>
                                <cfif attributes.is_detail and attributes.is_project and attributes.is_work and attributes.is_date and attributes.is_row>
                                    <td format="date">#dateformat(RECORD_DATE,dateformat_style)#</td>
                                </cfif>
                                <cfif attributes.is_expence_member>
                                    <cfif MEMBER_TYPE eq 'partner'>
                                        <cfset item_value = left('#get_par_info(company_partner_id,0,-1,0)#-#get_par_info(company_partner_id,0,1,0)#' ,30)>
                                    <cfelseif MEMBER_TYPE eq 'consumer'>
                                        <cfset item_value = left('#get_cons_info(company_partner_id,0,0)#-#get_cons_info(company_id,2,0)#',30)>
                                    <cfelseif MEMBER_TYPE eq 'employee'>
                                        <cfset item_value = left('#get_emp_info(company_partner_id,0,0)#',30)>
                                    <cfelse>
                                        <cfset item_value = left('#get_emp_info(company_partner_id,0,0)#',30)>
                                    </cfif>
                                    <td>                                        
                                        #item_value#
                                    </td>
                                </cfif>
                                <cfif attributes.is_activity>
                                    <td>
                                        <cfif isdefined('ACTIVITY_NAME#ACTIVITY_TYPE#')>
                                            #Evaluate('ACTIVITY_NAME#ACTIVITY_TYPE#')#
                                        <cfelse>
                                            #ACTIVITY_TYPE#
                                        </cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_asset>
                                    <td>
                                        #ASSETP#
                                    </td>					
                                </cfif>
                                <cfif attributes.is_stock>
                                    <td>
                                        <cfif len(PRODUCT_NAME)>
                                            #PRODUCT_NAME#
                                        <cfelseif isDefined("get_product_name.NAME_PRODUCT")>
                                            #get_product_name.NAME_PRODUCT#
                                        </cfif>
                                    </td>
                                    <cfif x_show_quantity_with_stock eq 1>
                                        <td align="right" format="numeric">
                                            <cfif len(Quantity)>
                                                #TLFormat(Quantity)#
                                            <cfelseif isDefined("get_product_name.AMOUNT")>
                                                #TLFormat(get_product_name.AMOUNT)#
                                            </cfif>
                                        </td>
                                    </cfif>
                                </cfif>
                                <cfif attributes.is_other_money>
                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(other_money_gross_total)#</td>
                                    <td align="center">#money_currency_id#</td>
                                </cfif>
                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(amount)#</td>
                                <td align="center">#session.ep.money#</td>
                                <td align="right" style="text-align:right;" format="numeric"><cfif len(amount_kdv)>#TLFormat(amount_kdv)#</cfif></td>
                                <td align="center"><cfif len(amount_kdv)>#session.ep.money# <cfelse>0 #session.ep.money#</cfif></td>
                                <td align="right" style="text-align:right;" format="numeric"><cfif len(amount_otv)>#TLFormat(amount_otv)#</cfif></td>
                                <td align="center"><cfif len(amount_kdv)>#session.ep.money# <cfelse>0 #session.ep.money#</cfif></td>
                                <td align="right" style="text-align:right;" format="numeric">#TLFormat(total_amount)#</td>
                                <td align="center">#session.ep.money#</td>
                                <cfif attributes.is_cumulative and attributes.is_expence_item>
                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(CUM_TOTAL)#</td>
                                    <td align="right" style="text-align:right;" format="numeric">#TLFormat(CUM_LAST_TOTAL)#</td>
                                    <td align="center">#CUM_MONEY#</td>
                                </cfif>
                            </tr>
                            <cfif attributes.is_cumulative and attributes.is_expence_item and expense_item_id[currentrow] neq expense_item_id[currentrow+1]>
                                <tr class="total">
                                    <cfif attributes.is_expence_item eq 1 and (isdefined("x_show_account_code") and x_show_account_code eq 1)>
                                        <cfset colspan= #list_num# + 10>
                                    <cfelse>
                                        <cfset colspan= #list_num# +10>
                                    </cfif>
                                    <cfif attributes.is_detail and attributes.is_project and attributes.is_work and attributes.is_date and attributes.is_row>
                                        <cfset colspan=colspan+1><!--- kayıt tarihi sütunu için --->
                                    </cfif>
                                    <td colspan="#colspan#" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id="57565.Ara"> <cf_get_lang dictionary_id="57492.Toplam"></td>
                                    <td align="right" class="txtbold" style="text-align:right;" format="numeric">#TLFormat(CUM_TOTAL)#</td>
                                    <td align="right" class="txtbold" style="text-align:right;" format="numeric">#TLFormat(CUM_LAST_TOTAL)#</td>
                                    <td align="center" class="txtbold">#CUM_MONEY#</td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                        <cfif attributes.is_excel neq 1>
                            <tr>
                                <cfif attributes.is_expence_item eq 1 and (isdefined("x_show_account_code") and x_show_account_code eq 1)>
                                    <cfset colspan=#list_num#+2>
                                <cfelse>
                                    <cfset colspan=#list_num#+1>
                                </cfif>
                                <cfif attributes.is_detail and attributes.is_project and attributes.is_work and attributes.is_date and attributes.is_row>
                                    <cfset colspan=colspan+1><!--- kayıt tarihi sütunu için --->
                                </cfif>
                                <td colspan="<cfoutput>#colspan#</cfoutput>" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='39183.Sayfa Toplam'></td>
                                <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.page_total)#</cfoutput></td>
                                <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.page_kdv_total)#</cfoutput></td>
                                <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.page_otv_total)#</cfoutput></td>
                                <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.page_grand_total)#</cfoutput></td>
                                <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                <cfif attributes.is_cumulative and attributes.is_expence_item>
                                    <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.cum_total)#</cfoutput></td>
                                    <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.cum_grand_total)#</cfoutput></td>
                                    <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                </cfif>
                            </tr>
                        </cfif>
                            <tr>
                                <cfif attributes.is_expence_item eq 1 and (isdefined("x_show_account_code") and x_show_account_code eq 1)>
                                    <cfset colspan=#list_num#+2>
                                <cfelse>
                                    <cfset colspan=#list_num#+1>
                                </cfif>
                                <cfif attributes.is_detail and attributes.is_project and attributes.is_work and attributes.is_date and attributes.is_row>
                                    <cfset colspan=colspan+1><!--- kayıt tarihi sütunu için --->
                                </cfif>
                                <td colspan="<cfoutput>#colspan#</cfoutput>" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                                <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.all_total)#</cfoutput></td>
                                <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.all_kdv_total)#</cfoutput></td>
                                <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.all_otv_total)#</cfoutput></td>
                                <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.all_grand_total)#</cfoutput></td>
                                <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                <cfif attributes.is_cumulative and attributes.is_expence_item>
                                    <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.all_total)#</cfoutput></td>
                                    <td align="right" class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TLFormat(get_expense_item_row_all.all_grand_total)#</cfoutput></td>
                                    <td class="txtbold" align="center"><cfoutput>#session.ep.money#</cfoutput></td>
                                </cfif>
                            </tr>
                    </tfoot>
                </cfif>
        <cfelse>
            <cfif isdefined('attributes.ajax')>
                <script type="text/javascript">
                    user_info_show_div(1,1,1);
                </script>
            </cfif> 
            <cfset colspan_ = 25>
            <cfif isdefined("attributes.is_row") and len(attributes.is_row)>
                <cfset colspan_ = colspan_ + 2>
            </cfif>
            <tr class="color-row">
                <td colspan="<cfoutput>#colspan_+5#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            </tr>
        </cfif>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfscript>
        url_str = "" ;
        url_str = "#url_str#&is_expence=#attributes.is_expence#";
        url_str = "#url_str#&is_asset=#attributes.is_asset#";
        url_str = "#url_str#&is_stock=#attributes.is_stock#";
        url_str = "#url_str#&is_detail=#attributes.is_detail#";
        url_str = "#url_str#&is_project=#attributes.is_project#";
        url_str = "#url_str#&is_work=#attributes.is_work#";
        url_str = "#url_str#&is_opp=#attributes.is_opp#";
        url_str = "#url_str#&is_expence_item=#attributes.is_expence_item#";
        url_str = "#url_str#&is_activity=#attributes.is_activity#";
        url_str = "#url_str#&is_expence_cat=#attributes.is_expence_cat#";
        url_str = "#url_str#&is_expence_member=#attributes.is_expence_member#";
        url_str = "#url_str#&is_date=#attributes.is_date#&is_row=#attributes.is_row#";
        url_str = "#url_str#&is_other_money=#attributes.is_other_money#";
        url_str = "#url_str#&is_cumulative=#attributes.is_cumulative#";
        url_str = "#url_str#&report_sort=#attributes.report_sort#&process_typeReport=#attributes.process_typeReport#";
        url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#";
        if ( len(attributes.asset_id) )
            url_str = "#url_str#&asset_id=#attributes.asset_id#&asset=#attributes.asset#";
        if ( len(attributes.project_id) )
            url_str = "#url_str#&project_id=#attributes.project_id#&project=#attributes.project#";
        if ( len(attributes.subscription_id) )
            url_str = "#url_str#&subscription_id=#attributes.subscription_id#&subscription_name=#attributes.subscription_name#";
        if ( len(attributes.member_type) )
            url_str = "#url_str#&member_type=#attributes.member_type#";
        if ( len(attributes.member_id) )
            url_str = "#url_str#&member_id=#attributes.member_id#";
        if ( len(attributes.company_id) )
            url_str = "#url_str#&company_id=#attributes.company_id#";
        if ( len(attributes.member_name) )
            url_str = "#url_str#&member_name=#attributes.member_name#";
        if ( len(attributes.expense_item_id) )
            url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
        if ( len(attributes.expense_center_id) )
            url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
        if ( len(attributes.activity_type) )
            url_str = "#url_str#&activity_type=#attributes.activity_type#";
        if ( len(attributes.form_exist) )
            url_str = "#url_str#&form_exist=#attributes.form_exist#";
        if ( len(attributes.expense_cat) )
            url_str = "#url_str#&expense_cat=#attributes.expense_cat#";
        if ( len(attributes.record_emp_id) )
            url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#";
        if ( len(attributes.record_emp_name) )
            url_str = "#url_str#&record_emp_name=#attributes.record_emp_name#";
        if ( len(attributes.graph_type) )
            url_str = "#url_str#&graph_type=#attributes.graph_type#";
    </cfscript>
    <cf_paging 
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#attributes.fuseaction#&#url_str#">
</cfif>
<cfif isdefined("attributes.form_exist") and get_expense_item_row_all.recordcount and len(attributes.graph_type) and not isdefined('attributes.ajax')><!--- Grafik Başlangıç --->
<br>
    <cfoutput query="GET_EXPENSE_ITEM_ROW_ALL">
        <cfset item_value = ''>
        <cfif attributes.is_expence>
            <cfset item_value = '#item_value#-#left(expense,30)#'>
        </cfif>
        <cfif attributes.is_expence_item>
            <cfset item_value = '#item_value#-#left(expense_item_name,30)#'>
        </cfif>
        <cfif attributes.is_expence_member>
            <cfif MEMBER_TYPE eq 'partner'>
                <cfset item_value = left('#item_value#-#get_par_info(company_partner_id,0,-1,0)# - #item_value#-#get_par_info(company_partner_id,0,1,0)#' ,30)>
            <cfelseif MEMBER_TYPE eq 'consumer'>
                <cfset item_value = left('#item_value#-#get_cons_info(company_partner_id,0,0)# - #item_value#-#get_cons_info(company_id,2,0)#',30)>
            <cfelseif MEMBER_TYPE eq 'employee'>
                <cfset item_value = left('#item_value#-#get_emp_info(company_partner_id,0,0)#',30)>
            <cfelse>
                <cfset item_value = left('#item_value#-#get_emp_info(company_partner_id,0,0)#',30)>
            </cfif>
        </cfif> 
        <cfif attributes.is_date>
        <cfset item_value = '#item_value#-#dateformat(expense_date,dateformat_style)#'>
        </cfif>
        <cfif attributes.is_activity>
            <cfset item_value = left('#item_value#-#ACTIVITY_TYPE#',30)>
        </cfif>
        <cfif attributes.is_expence_cat>
            <cfset item_value = left('#item_value#-#EXPENSE_CAT_NAME#',30)>
        </cfif>
        <cfif attributes.is_asset>
            <cfset item_value = left('#item_value#-#ASSETP#',30)>
        </cfif>
        <cfif attributes.is_stock>
            <cfset item_value = left('#item_value#-#PRODUCT_NAME#',30)>
        </cfif>
        <cfif attributes.is_detail>
            <cfset item_value = left('#item_value#-#DETAIL#',30)>
        </cfif>
        <cfif attributes.is_project>
            <cfset item_value = left('#item_value#-#PROJECT_HEAD#',30)>
        </cfif>
        <cfset 'item_#currentrow#'="#item_value#">
        <cfset 'value_#currentrow#'="#amount#">
    </cfoutput>
    <script src="JS/Chart.min.js"></script> 
    <canvas id="myChart" style="float:left;max-width:500px;max-height:500px;"></canvas>
    <script>
        var ctx = document.getElementById('myChart');
            var myChart = new Chart(ctx, {
                type: '<cfoutput>#graph_type#</cfoutput>',
                data: {
                    labels: [<cfloop from="1" to="#GET_EXPENSE_ITEM_ROW_ALL.recordcount#" index="jj">
                                        <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                    datasets: [{
                        label: "Detaylı Harcama Analiz",
                        backgroundColor: [<cfloop from="1" to="#GET_EXPENSE_ITEM_ROW_ALL.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                        data: [<cfloop from="1" to="#GET_EXPENSE_ITEM_ROW_ALL.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
                    }]
                },
                options: {}
        });
    </script>
<br />
</cfif>
<script type="text/javascript">
function pencere_ac_company()
{
	eval("document.search_asset.member_type").value = '';
	eval("document.search_asset.member_id").value = '';
	eval("document.search_asset.company_id").value = '';
	eval("document.search_asset.member_name").value = '';
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.member_id&field_id=search_asset.member_id&field_comp_name=search_asset.member_name&field_name=search_asset.member_name&field_comp_id=search_asset.company_id&field_type=search_asset.member_type&select_list=1,2,3','list');
}
function kontrol_report_sort()
{
	if(document.search_asset.is_cumulative.checked == true)
	{
		if(document.search_asset.report_sort.value == 0)
		{
			document.search_asset.is_expence.checked = false;
			document.search_asset.is_expence_item.checked = false;
			document.search_asset.is_row.checked = false; 
		}
		else if (document.search_asset.report_sort.value == 1)
		{
			document.search_asset.is_expence.checked = false;
			document.search_asset.is_expence_item.checked = false;
			document.search_asset.is_row.checked = false; 
		}
		else if (document.search_asset.report_sort.value == 2)
		{
			document.search_asset.is_expence.checked = false;
			document.search_asset.is_expence_item.checked = true;
			document.search_asset.is_row.checked = true; 
		}
		else if (document.search_asset.report_sort.value == 3)
		{
			document.search_asset.is_expence.checked = false;
			document.search_asset.is_expence_item.checked = false;
			document.search_asset.is_row.checked = false; 
		}
		else if (document.search_asset.report_sort.value == 4)
		{
			document.search_asset.is_expence.checked = false;
			document.search_asset.is_expence_item.checked = false;
			document.search_asset.is_row.checked = false; 
		}
		else
		{
			document.search_asset.is_expence.checked = true;
			document.search_asset.is_expence_item.checked = true;
			document.search_asset.is_row.checked = true; 
		}
	}
	return true;
}
function degistir_action()
    {
        if ((document.search_asset.search_date1.value != '') && (document.search_asset.search_date2.value != '') &&
	    !date_check(search_asset.search_date1,search_asset.search_date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;        
        if(document.getElementById("is_excel").checked == false)
		{
			document.search_asset.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.cost_analyse_report</cfoutput>";
			return true;
		}
		else
		{
			document.search_asset.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_cost_analyse_report</cfoutput>";
		}
        if(document.search_asset.report_sort.value == 0 && document.search_asset.is_cumulative.checked == true)
        {
            alert("<cf_get_lang dictionary_id='60667.Kümüle Tutar ile Tutar Sıralama Birlikte Seçilemez'>!");
            return false;
        }
        if(document.search_asset.report_sort.value == 1 && document.search_asset.is_cumulative.checked == true)
        {
            alert("<cf_get_lang dictionary_id='60668.Kümüle Tutar ile Masraf Merkezi Sıralama Birlikte Seçilemez'>!");
            return false;
        }
        if(document.search_asset.report_sort.value == 3 && document.search_asset.is_cumulative.checked == true)
        {
            alert("<cf_get_lang dictionary_id='60669.Kümüle Tutar ile Tarih Aralığı Sıralama Birlikte Seçilemez'>!");
            return false;
        }
        if(document.search_asset.report_sort.value == 4 && document.search_asset.is_cumulative.checked == true)
        {
            alert("<cf_get_lang dictionary_id='60670.Kümüle Tutar ile Proje Sıralama Birlikte Seçilemez'>!");
            return false;
        }
    }
</script>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
