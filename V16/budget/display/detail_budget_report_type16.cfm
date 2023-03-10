<cfif fusebox.use_period>
	<cfset db_alias_ = dsn2_alias>
<cfelse>
	<cfset db_alias_ = dsn_alias>
</cfif>
<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
<cfquery name="GET_ACTIVITY_TYPE" datasource="#dsn#">	
    SELECT
        ACTIVITY_ID
    FROM
        SETUP_ACTIVITY
</cfquery>
</cfif>
<cfquery name="CHECK_TABLE" datasource="#dsn2#">
	IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_EXPENSE_CENTER_ITEM_#session.ep.userid#')
    DROP TABLE ####GET_EXPENSE_CENTER_ITEM_#session.ep.userid#
</cfquery>
<cfquery name="GET_EXPENSE_CENTER_ITEM" datasource="#dsn2#">
    SELECT 
    	EXPENSE.EXPENSE_ID,
        EXPENSE.EXPENSE,
    	EXPENSE.EXPENSE_CODE,
        EXPENSE_ITEM.EXPENSE_ITEM_ID,
        EXPENSE_ITEM.EXPENSE_ITEM_NAME,
        EXPENSE_ITEM.ACCOUNT_CODE,
        EXPENSE_ITEM.EXPENSE_CAT_NAME,
        EXPENSE_ITEM.EXPENSE_CAT_ID
        <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)> 
            ,SETUP_ACTIVITY.ACTIVITY_ID
        </cfif>
    INTO ####GET_EXPENSE_CENTER_ITEM_#session.ep.userid#
    FROM
    <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
            (
            SELECT
                ACTIVITY_ID
            FROM
                #dsn#.SETUP_ACTIVITY
            
            UNION ALL

            SELECT NULL
        ) AS SETUP_ACTIVITY,
    </cfif>
    (
    SELECT
        EXPENSE_ID,
        EXPENSE,
        EXPENSE_CODE
    FROM
        EXPENSE_CENTER
    WHERE
            EXPENSE_ID IS NOT NULL AND
            EXPENSE_ACTIVE = 1
            <cfif len(exp_inc_center_list)>AND EXPENSE_ID IN (#exp_inc_center_list#)</cfif>
            <cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
                AND EXPENSE_ID IN (#attributes.expense_center_id#)
            <cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
                <cfif len(get_expense_center_.expense_id)>
                    AND EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
                <cfelse>
                    AND 1=0
                </cfif>
            </cfif>
            <cfif session.ep.isBranchAuthorization>
                AND EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
    ) AS EXPENSE,
    (
        SELECT 
            EXPENSE_ITEM_ID, 
            EXPENSE_ITEM_NAME,
            ACCOUNT_CODE,
            EXPENSE_CATEGORY.EXPENSE_CAT_NAME,
            EXPENSE_CATEGORY.EXPENSE_CAT_ID
        FROM 
            EXPENSE_ITEMS,
            EXPENSE_CATEGORY
        WHERE
            EXPENSE_ITEMS.EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID AND
            EXPENSE_ITEM_ID IS NOT NULL
        <cfif len(exp_inc_center_list2)>
            AND EXPENSE_ITEM_ID IN (#exp_inc_center_list2#)
        </cfif>
        <cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id)>
            AND EXPENSE_ITEM_ID IN (#attributes.expense_item_id#)
        </cfif>
        <cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
            AND EXPENSE_CATEGORY_ID IN (#attributes.expense_cat#)
        </cfif>
    ) AS EXPENSE_ITEM
</cfquery>

<cfquery name="GET_EXPENSE_BUDGET" datasource="#dsn2#">
	WITH CTE1 AS(
	SELECT 
            GEC.EXPENSE_ID,
            GEC.EXPENSE,
            GEC.EXPENSE_CODE,
            GEC.EXPENSE_ITEM_ID,
            GEC.EXPENSE_ITEM_NAME,
            GEC.ACCOUNT_CODE,
            GEC.EXPENSE_CAT_NAME,
            GEC.EXPENSE_CAT_ID,
            <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)> 
            GEC.ACTIVITY_ID,
            </cfif>
            ISNULL(ROW_TOTAL_INCOME,0) ROW_TOTAL_INCOME,
           ISNULL( ROW_TOTAL_EXPENSE,0) ROW_TOTAL_EXPENSE,
            ISNULL(ROW_TOTAL_INCOME_2,0) ROW_TOTAL_INCOME_2,
           ISNULL( ROW_TOTAL_EXPENSE_2,0) ROW_TOTAL_EXPENSE_2,
            ISNULL(TOTAL_AMOUNT_BORC,0) AS TOTAL_AMOUNT_BORC,
           	ISNULL(TOTAL_AMOUNT_ALACAK,0)  AS TOTAL_AMOUNT_ALACAK,
            ISNULL(TOTAL_AMOUNT_2_BORC,0) AS TOTAL_AMOUNT_BORC_2,
            ISNULL(TOTAL_AMOUNT_2_ALACAK,0) AS TOTAL_AMOUNT_ALACAK_2,
            ISNULL(TRANSFER_AMOUNT_BORC,0) TRANSFER_AMOUNT_BORC,
            ISNULL(TRANSFER_AMOUNT_ALACAK,0) TRANSFER_AMOUNT_ALACAK

    FROM
    	####GET_EXPENSE_CENTER_ITEM_#session.ep.userid# AS GEC
     LEFT JOIN    
        (
        	SELECT 
                SUM(CASE WHEN IS_TRANSFER = 1 THEN BUDGET_PLAN_ROW.ROW_TOTAL_INCOME ELSE 0 END) AS  TRANSFER_AMOUNT_ALACAK,
                SUM(CASE WHEN IS_TRANSFER = 1 THEN BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE ELSE 0 END) AS  TRANSFER_AMOUNT_BORC,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME),0) ROW_TOTAL_INCOME,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE),0) ROW_TOTAL_EXPENSE,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2),0) ROW_TOTAL_INCOME_2,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2),0) ROW_TOTAL_EXPENSE_2,
                BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
                BUDGET_PLAN_ROW.BUDGET_ITEM_ID
               <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
                    <cfif len(GET_ACTIVITY_TYPE.activity_id)>
                        ,#GET_ACTIVITY_TYPE.activity_id# AS ACTIVITY_TYPE_ID
                    <cfelse>
                        ,NULL AS ACTIVITY_TYPE_ID
                    </cfif>
                </cfif>
            FROM
                #DSN_ALIAS#.BUDGET_PLAN,
                #DSN_ALIAS#.BUDGET_PLAN_ROW 
            WHERE 
                BUDGET_PLAN.BUDGET_ID  IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
                BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
                BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID 
                <cfif len(attributes.search_date1)>
                    AND BUDGET_PLAN_ROW.PLAN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
                </cfif>
                <cfif len(attributes.search_date2)>
                    AND BUDGET_PLAN_ROW.PLAN_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
                </cfif>
                <cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
                    AND BUDGET_PLAN_ROW.BUDGET_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #db_alias_#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID IN (#attributes.expense_cat#)) 
                </cfif>
                <cfif isdefined("attributes.plan_process_cat") and len(attributes.plan_process_cat)>
                    AND BUDGET_PLAN.PROCESS_CAT IN (#attributes.plan_process_cat#)
                </cfif>
                <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
                    <cfif  len(GET_ACTIVITY_TYPE.ACTIVITY_ID)>
                        AND BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID = #GET_ACTIVITY_TYPE.activity_id#
                    <cfelse>
                        AND BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID IS NULL
                    </cfif>
                </cfif>
            GROUP BY
                BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
                BUDGET_PLAN_ROW.BUDGET_ITEM_ID
                <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)> 
                ,BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
                </cfif>
        ) AS PLANLANAN
     ON
     	PLANLANAN.EXP_INC_CENTER_ID = GEC.EXPENSE_ID AND PLANLANAN.BUDGET_ITEM_ID = GEC.EXPENSE_ITEM_ID
     LEFT JOIN
     	(
        	SELECT
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS  TOTAL_AMOUNT_BORC,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS  TOTAL_AMOUNT_ALACAK,
                SUM( CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_BORC,
                SUM( CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_ALACAK,
                EXPENSE_CENTER_ID,
                EXPENSE_ITEM_ID
                <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)> 
                ,ACTIVITY_ID
                </cfif>
            FROM
            (
                SELECT 
                    <cfif attributes.is_kdv eq 1>
                        EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT TOTAL_AMOUNT,
                        EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                    <cfelse>
                        (EXPENSE_ITEMS_ROWS.AMOUNT*ISNULL(QUANTITY,1)) TOTAL_AMOUNT,
                        CASE WHEN(OTHER_MONEY_VALUE_2 = 0) THEN 0 ELSE (EXPENSE_ITEMS_ROWS.AMOUNT/(TOTAL_AMOUNT/OTHER_MONEY_VALUE_2)*ISNULL(QUANTITY,1)) END AS TOTAL_AMOUNT_2,
                    </cfif>
                    EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID,
                    EXPENSE_ITEMS_ROWS.IS_INCOME,
                    EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
                    <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)> 
                    ,EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE AS ACTIVITY_ID
                    </cfif>
                FROM
                    EXPENSE_ITEMS_ROWS
                WHERE
                    TOTAL_AMOUNT > 0 			
                    <cfif len(attributes.search_date1)>
                        AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
                    </cfif>
                    <cfif len(attributes.search_date2)>
                        AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
                    </cfif>
                    <cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
                        AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #db_alias_#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID IN (#attributes.expense_cat#)) 
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND EXPENSE_ITEMS_ROWS.PROJECT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
                    </cfif>
                    <cfif isDefined("attributes.process_cat") and len(attributes.process_cat)>
						AND EXPENSE_COST_TYPE IN (#attributes.process_cat#)
					</cfif>
                    <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
                        <cfif len(GET_ACTIVITY_TYPE.activity_id)>
                            AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #GET_ACTIVITY_TYPE.activity_id#
                        <cfelse>
                            AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE IS NULL
                        </cfif>
                    </cfif>
            )T1
            GROUP BY
                EXPENSE_CENTER_ID,
                EXPENSE_ITEM_ID
                <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)> 
                ,ACTIVITY_ID
                </cfif>
        ) AS GERCEKLESEN  
     ON GERCEKLESEN.EXPENSE_CENTER_ID =  GEC.EXPENSE_ID AND GEC.EXPENSE_ITEM_ID = GERCEKLESEN.EXPENSE_ITEM_ID  
        <cfif isDefined("attributes.zero_data")>
            WHERE
            <cfif isdefined("attributes.is_expense") and isdefined("attributes.is_income") >
                (TOTAL_AMOUNT_BORC > 0 OR TOTAL_AMOUNT_ALACAK > 0) AND
            <cfelseif isdefined("attributes.is_income")>
                TOTAL_AMOUNT_ALACAK > 0 AND
            <cfelseif isdefined("attributes.is_expense")>
                TOTAL_AMOUNT_BORC > 0 AND
            </cfif>
            (PLANLANAN.EXP_INC_CENTER_ID IS NOT NULL  OR GERCEKLESEN.EXPENSE_CENTER_ID IS NOT NULL)
        </cfif>
            
     ),
         CTE2 AS (
				SELECT
					CTE1.*,
						ROW_NUMBER() OVER (ORDER BY EXPENSE_ID DESC)
                        AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
                ( SELECT SUM(ROW_TOTAL_INCOME) FROM CTE2 WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) ) PAGE_ROW_TOTAL_INCOME,
                ( SELECT SUM(ROW_TOTAL_EXPENSE) FROM CTE2 WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) ) PAGE_ROW_TOTAL_EXPENSE,
                ( SELECT SUM(ROW_TOTAL_INCOME_2) FROM CTE2 WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) ) PAGE_ROW_TOTAL_INCOME_2,
                ( SELECT SUM(ROW_TOTAL_EXPENSE_2) FROM CTE2 WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) ) PAGE_ROW_TOTAL_EXPENSE_2,
                ( SELECT SUM(TOTAL_AMOUNT_BORC) FROM CTE2 WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) ) PAGE_TOTAL_AMOUNT_BORC,
                ( SELECT SUM(TOTAL_AMOUNT_ALACAK) FROM CTE2 WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) ) PAGE_TOTAL_AMOUNT_ALACAK,
                ( SELECT SUM(TOTAL_AMOUNT_BORC_2) FROM CTE2 WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) ) PAGE_TOTAL_AMOUNT_BORC_2,
                ( SELECT SUM(TOTAL_AMOUNT_ALACAK_2) FROM CTE2 WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) ) PAGE_TOTAL_AMOUNT_ALACAK_2,
                ( SELECT SUM(ROW_TOTAL_INCOME) FROM CTE2 ) ALL_ROW_TOTAL_INCOME,
                ( SELECT SUM(ROW_TOTAL_EXPENSE) FROM CTE2 ) ALL_ROW_TOTAL_EXPENSE,
                ( SELECT SUM(ROW_TOTAL_INCOME_2) FROM CTE2 ) ALL_ROW_TOTAL_INCOME_2,
                ( SELECT SUM(ROW_TOTAL_EXPENSE_2) FROM CTE2 ) ALL_ROW_TOTAL_EXPENSE_2,
                ( SELECT SUM(TOTAL_AMOUNT_BORC) FROM CTE2 ) ALL_TOTAL_AMOUNT_BORC,
                ( SELECT SUM(TOTAL_AMOUNT_ALACAK) FROM CTE2 ) ALL_TOTAL_AMOUNT_ALACAK,
                ( SELECT SUM(TOTAL_AMOUNT_BORC_2) FROM CTE2 ) ALL_TOTAL_AMOUNT_BORC_2,
                ( SELECT SUM(TOTAL_AMOUNT_ALACAK_2) FROM CTE2 ) ALL_TOTAL_AMOUNT_ALACAK_2,
                ( SELECT SUM(TRANSFER_AMOUNT_BORC) FROM CTE2 ) ALL_TRANSFER_AMOUNT_BORC,
                ( SELECT SUM(TRANSFER_AMOUNT_ALACAK) FROM CTE2 ) ALL_TRANSFER_AMOUNT_ALACAK,
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)	  
</cfquery>
<cfif GET_EXPENSE_BUDGET.recordcount>
	<cfparam name="attributes.totalrecords" default='#GET_EXPENSE_BUDGET.QUERY_COUNT#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<thead>	
    <tr>
        <th width="25" nowrap></th>
        <cfset colspan_no_ = 3>
        <cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
            <cfset colspan_no_ = colspan_no_ + 1>
        </cfif>
        <cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
            <cfset colspan_no_ = colspan_no_ + 1>
        </cfif>
        <th  nowrap colspan="<cfoutput>#colspan_no_#</cfoutput>"></th>
        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
            <cfif isdefined("attributes.is_diff")>
                <cfset colspan_info = 15>
            <cfelse>
                <cfset colspan_info = 10>
            </cfif>
        <cfelse>
            <cfif isdefined("attributes.is_diff")>
                <cfset colspan_info = 8>
            <cfelse>
                <cfset colspan_info = 5>
            </cfif>
        </cfif>
        <cfif isdefined("attributes.transfer")>				
            <cfset colspan_info = 12>           
        </cfif>
        <cfif isdefined("attributes.is_income")>
            <th colspan="<cfoutput>#colspan_info#</cfoutput>" align="center" nowrap><cf_get_lang dictionary_id='58677.Gelir'></th>
        </cfif>
        <cfif isdefined("attributes.is_expense")>	
            <th colspan="<cfoutput>#colspan_info#</cfoutput>" align="center" nowrap><cf_get_lang dictionary_id='58678.Gider'></th>
        </cfif>
        <cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>
            <th colspan="4" align="center" nowrap><cf_get_lang dictionary_id='57756.Durum'></th>
        </cfif>
        <cfif isdefined("attributes.ei_diff")>				
            <th colspan="16" align="center" nowrap><cf_get_lang dictionary_id='60912.Gelir-Gider Fark??'></th>
        </cfif>
    </tr>
    <tr>
        <th width="25" nowrap><cf_get_lang dictionary_id='57487.No'></th>
        <cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
        <th  nowrap><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
        </cfif>
        <th nowrap><cf_get_lang dictionary_id='58234.B??t??e Kalemi'></th>
        <th nowrap><cf_get_lang dictionary_id='32999.B??t??e Kategorisi'></th>
        <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
            <th><cf_get_lang no='90.Aktivite Tipi'></th>
        </cfif>
        <cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
            <th nowrap><cf_get_lang dictionary_id='49109.Masraf Merkezi Kodu'></th>
        </cfif>
        <th  nowrap><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th>
        <cfif isdefined("attributes.is_income")>
            
            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            <th width="110" colspan="2" align="center" nowrap><cf_get_lang dictionary_id='49176.Ger??ekle??en'> </th>
            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            <cfif isdefined("attributes.is_diff")>
                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            </cfif>
            <th width="35"  nowrap  style="text-align:right;">%</th>
            <cfif isdefined("attributes.transfer")>				
                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='61517.Aktar??lan Tutar'> </th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th width="110" align="center" nowrap>Revize Plan</th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            </cfif>
            <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Ger??ekle??en'></th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <cfif isdefined("attributes.is_diff")>
                    <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
                    <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                </cfif>
                <th width="35"  nowrap  style="text-align:right;">%</th>
            </cfif>
        </cfif>
        <cfif isdefined("attributes.is_expense")>
            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            <th width="110" colspan="2" align="center" nowrap><cf_get_lang dictionary_id='49176.Ger??ekle??en'></th>
            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            <cfif isdefined("attributes.is_diff")>
                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            </cfif>
            <th width="35"  nowrap  style="text-align:right;">%</th>
            <cfif isdefined("attributes.transfer")>				
                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='61517.Aktar??lan Tutar'> </th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th width="110" align="center" nowrap>Revize Plan</th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            </cfif>
            <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Ger??ekle??en'></th>
                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <cfif isdefined("attributes.is_diff")>
                    <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
                    <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                </cfif>
                <th width="35"  nowrap  style="text-align:right;">%</th>
            </cfif>
        </cfif>
        <cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>
            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Ger??ekle??en'></th>
            <th width="35" nowrap  style="text-align:right;"><cf_get_lang dictionary_id='58869.Planlanan'> %</th>
            <th width="35" nowrap style="text-align:right;"><cf_get_lang dictionary_id='49176.Ger??ekle??en'> %</th>
        </cfif>
        <cfif isdefined("attributes.ei_diff")>				
            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Ger??ekle??en'> </th>
        </cfif>
    </tr>
</thead>
<cfparam name="attributes.totalrecords" default='#GET_EXPENSE_BUDGET.recordcount#'>
<cfif GET_EXPENSE_BUDGET.recordcount>
    <tbody>
        <cfoutput query="GET_EXPENSE_BUDGET">
                <tr>
                    <td>#rowNum#</td>
                    <cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
                        <td nowrap>#account_code#</td>
                    </cfif>
                    <td nowrap>#EXPENSE_ITEM_NAME#</td>
                    <td nowrap>#EXPENSE_CAT_NAME#</td>
                    <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
                        <td>
                            <cfif len(ACTIVITY_ID)>
                                <cfquery name="GET_ACTIVITY_TYPE" datasource="#DSN#">
                                    SELECT
                                        ACTIVITY_ID,
                                        ACTIVITY_NAME
                                    FROM
                                        SETUP_ACTIVITY
                                    WHERE
                                        ACTIVITY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTIVITY_ID#">
                                    ORDER BY
                                        ACTIVITY_NAME
                                </cfquery>
                                #GET_ACTIVITY_TYPE.ACTIVITY_NAME#
                            </cfif>
                        </td>
                    </cfif>
                    <cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
                        <td nowrap>#expense_code#</td>
                    </cfif>
                    <td nowrap>#expense#</td>
                    <cfif isdefined("attributes.is_income")>
                        <td  style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL_INCOME)#</td>
                        <td>&nbsp;#session.ep.money#</td>
                        <td  style="text-align:right;" format="numeric">#TlFormat(TOTAL_AMOUNT_ALACAK)#</td>
                        <td width="5" align="center">
                            <a href="#request.self#?fuseaction=budget.budget_income_summery&form_submitted=1<cfif len(attributes.project_id)>&project_id=#attributes.project_id#</cfif><cfif len(attributes.search_date1) and len(attributes.search_date2)>&search_date1=#dateformat(attributes.search_date1,dateformat_style)#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#</cfif>&expense_center_id=#GET_EXPENSE_BUDGET.expense_id#&expense_item_id=#GET_EXPENSE_BUDGET.expense_item_id#&income_cat=#GET_EXPENSE_BUDGET.EXPENSE_CAT_ID#<cfif len(attributes.process_cat)>&process_cat=#attributes.process_cat#</cfif>" class="tableyazi" target="blank_"><i class="icon-ellipsis"></i></a>																							
                        </td>
                        <td>&nbsp;#session.ep.money#</td>
                        <cfif isdefined("attributes.is_diff")>
                            <td  style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL_INCOME-TOTAL_AMOUNT_ALACAK)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                        <td  style="text-align:right;" format="numeric"><cfif ROW_TOTAL_INCOME neq 0>#TLFormat((TOTAL_AMOUNT_ALACAK/ROW_TOTAL_INCOME)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                        <cfif isdefined("attributes.transfer")>				
                            <td  style="text-align:right;" format="numeric">#TLFormat(TRANSFER_AMOUNT_ALACAK)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td  style="text-align:right;" format="numeric">#TLFormat(ROW_TOTAL_INCOME+TRANSFER_AMOUNT_ALACAK)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                            <td  style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL_INCOME_2)#</td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <td  style="text-align:right;" format="numeric">#TlFormat(TOTAL_AMOUNT_ALACAK_2)#</td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL_INCOME_2-TOTAL_AMOUNT_ALACAK_2)#</td>
                                <td>&nbsp;#session.ep.money2#</td>
                            </cfif>
                            <td  style="text-align:right;" format="numeric"><cfif ROW_TOTAL_INCOME_2 neq 0>#TLFormat((TOTAL_AMOUNT_ALACAK_2/ROW_TOTAL_INCOME_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.is_expense")>                           
                        <td  style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL_EXPENSE)#</td>
                        <td>&nbsp;#session.ep.money#</td>
                        <td  style="text-align:right;" format="numeric">#TlFormat(TOTAL_AMOUNT_BORC)#</td>
                        <td width="5" align="center">
                            <a href="#request.self#?fuseaction=cost.list_expense_management&form_exist=1<cfif len(attributes.project_id)>&project_id=#attributes.project_id#</cfif><cfif len(attributes.search_date1) and len(attributes.search_date2)>&search_date1=#dateformat(attributes.search_date1,dateformat_style)#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#</cfif>&expense_center_id=#GET_EXPENSE_BUDGET.expense_id#&expense_item_id=#GET_EXPENSE_BUDGET.expense_item_id#&expense_cat=#GET_EXPENSE_BUDGET.EXPENSE_CAT_ID#<cfif len(attributes.process_cat)>&process_cat=#attributes.process_cat#</cfif>" class="tableyazi" target="blank_"><i class="icon-ellipsis"></i></a>																							
                        </td>
                        <td>&nbsp;#session.ep.money#</td>
                        <cfif isdefined("attributes.is_diff")>
                            <td  style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                        <td  style="text-align:right;" format="numeric"><cfif ROW_TOTAL_EXPENSE neq 0>#TLFormat((TOTAL_AMOUNT_BORC/ROW_TOTAL_EXPENSE)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                        <cfif isdefined("attributes.transfer")>				
                            <td  style="text-align:right;" format="numeric">#TLFormat(TRANSFER_AMOUNT_BORC)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td  style="text-align:right;" format="numeric">#TLFormat(ROW_TOTAL_EXPENSE + TRANSFER_AMOUNT_BORC)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                            <td  style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL_EXPENSE_2)#</td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <td  style="text-align:right;" format="numeric">#TlFormat(TOTAL_AMOUNT_BORC_2)#</td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  style="text-align:right;" format="numeric">#TlFormat(ROW_TOTAL_EXPENSE_2-TOTAL_AMOUNT_BORC_2)#</td>
                                <td>&nbsp;#session.ep.money2#</td>
                            </cfif>
                            <td  style="text-align:right;" format="numeric"><cfif ROW_TOTAL_EXPENSE_2 neq 0>#TLFormat((TOTAL_AMOUNT_BORC_2/ROW_TOTAL_EXPENSE_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>                           
                        <td  style="text-align:right;" format="numeric">#TLFormat(ROW_TOTAL_INCOME-ROW_TOTAL_EXPENSE)#</td>
                        <td  style="text-align:right;" format="numeric">#TLFormat(TOTAL_AMOUNT_BORC-TOTAL_AMOUNT_ALACAK)#</td>		
                        <td  style="text-align:right;" format="numeric"><cfif ROW_TOTAL_EXPENSE neq 0>#TLFormat(((ROW_TOTAL_INCOME-ROW_TOTAL_EXPENSE)/ROW_TOTAL_EXPENSE)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
                        <td  style="text-align:right;" format="numeric"><cfif TOTAL_AMOUNT_BORC neq 0>#TLFormat(((TOTAL_AMOUNT_ALACAK-TOTAL_AMOUNT_BORC)/TOTAL_AMOUNT_BORC)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
                    </cfif>
                    <cfif isdefined("attributes.ei_diff")>
                        <td  style="text-align:right;" format="numeric">#TLFormat(TOTAL_AMOUNT_BORC-TOTAL_AMOUNT_ALACAK)#</td>
                    </cfif>
                </tr>
        </cfoutput>
        <cfoutput>
            <tr>
                <cfset colspan_no_ = 4>
                <cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
                    <cfset colspan_no_ = colspan_no_ + 1>
                </cfif>
                <cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
                    <cfset colspan_no_ = colspan_no_ + 1>
                </cfif>
                <cfif isdefined('attributes.is_activity_type') and len(attributes.is_activity_type)>
                    <cfset colspan_no_ = colspan_no_ + 1>
                </cfif>
                <td colspan="#colspan_no_#" height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                <cfif isdefined("attributes.is_income")>
                    <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME)#</td>
                    <td class="txtbold">&nbsp;#session.ep.money#</td>
                    <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK)#</td>
                    <td></td>
                    <td class="txtbold">&nbsp;#session.ep.money#</td>
                    <cfif isdefined("attributes.is_diff")>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME-GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK)#</td>
                        <td class="txtbold">&nbsp;#session.ep.money#</td>
                    </cfif>
                    <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME neq 0>#TLFormat((GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK/GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                    <cfif isdefined("attributes.transfer")>				
                        <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_TRANSFER_AMOUNT_ALACAK)#</td>
                        <td>&nbsp;#session.ep.money#</td>
                        <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME + GET_EXPENSE_BUDGET.ALL_TRANSFER_AMOUNT_ALACAK)#</td>
                        <td>&nbsp;#session.ep.money#</td>
                    </cfif>
                    <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME_2)#</td>
                        <td class="txtbold">&nbsp;#session.ep.money2#</td>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK_2)#</td>
                        <td class="txtbold">&nbsp;#session.ep.money2#</td>
                        <cfif isdefined("attributes.is_diff")>
                            <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME_2-GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK_2)#</td>
                            <td class="txtbold">&nbsp;#session.ep.money2#</td>
                        </cfif>
                        <td  class="txtbold" style="text-align:right;" format="numeric"><cfif IsDefined("PAGE_ROW_TOTAL_INCOME_2") and PAGE_ROW_TOTAL_INCOME_2 neq 0>#TLFormat((GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK_2/GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                    </cfif>
                </cfif>
                <cfif isdefined("attributes.is_expense")>
                    
                    <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE)#</td>
                    <td class="txtbold">&nbsp;#session.ep.money#</td>
                    <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC)#</td>
                    <td></td>
                    <td class="txtbold">&nbsp;#session.ep.money#</td>
                    <cfif isdefined("attributes.is_diff")>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE-GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC)#</td>
                        <td class="txtbold">&nbsp;#session.ep.money#</td>
                    </cfif>
                    <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE neq 0>#TLFormat((GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC/GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                    <cfif isdefined("attributes.transfer")>				
                        <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_TRANSFER_AMOUNT_BORC)#</td>
                        <td>&nbsp;#session.ep.money#</td>
                        <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE + GET_EXPENSE_BUDGET.ALL_TRANSFER_AMOUNT_BORC)#</td>
                        <td>&nbsp;#session.ep.money#</td>
                    </cfif>
                    <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE_2)#</td>
                        <td class="txtbold">&nbsp;#session.ep.money2#</td>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC_2)#</td>
                        <td class="txtbold">&nbsp;#session.ep.money2#</td>
                        <cfif isdefined("attributes.is_diff")>
                            <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE_2-GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC_2)#</td>
                            <td class="txtbold">&nbsp;#session.ep.money2#</td>
                        </cfif>
                        <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE_2 neq 0>#TLFormat((GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC_2/GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                    </cfif>
                </cfif>
                <cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>                      
                    <td  class="txtbold" style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME-GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE)#</td>
                    <td  class="txtbold" style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC-GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK)#</td>	
                    <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE neq 0>#TLFormat(((GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_INCOME-GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE)/GET_EXPENSE_BUDGET.PAGE_ROW_TOTAL_EXPENSE)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
                    <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK neq 0>#TLFormat(((GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC-GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK)/GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
                </cfif>
                    <cfif isdefined("attributes.ei_diff")>
                        <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_BORC-GET_EXPENSE_BUDGET.PAGE_TOTAL_AMOUNT_ALACAK)#</td>
                    </cfif>
            </tr> 
            <!--- son sayfa ise genel toplam?? g??ster --->
            <cfif attributes.maxrows*attributes.page gte attributes.totalrecords>
                <tr>
                    <cfset colspan_no_ = 4>
                    <cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
                        <cfset colspan_no_ = colspan_no_ + 1>
                    </cfif>
                    <cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
                        <cfset colspan_no_ = colspan_no_ + 1>
                    </cfif>
                    <td colspan="#colspan_no_#" height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                    <cfif isdefined("attributes.is_income")>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME)#</td>
                        <td class="txtbold">&nbsp;#session.ep.money#</td>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)#</td>
                        <td></td>
                        <td class="txtbold">&nbsp;#session.ep.money#</td>
                        <cfif isdefined("attributes.is_diff")>
                            <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)#</td>
                            <td class="txtbold">&nbsp;#session.ep.money#</td>
                        </cfif>
                        <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME neq 0>#TLFormat((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                            <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2)#</td>
                            <td class="txtbold">&nbsp;#session.ep.money2#</td>
                            <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK_2)#</td>
                            <td class="txtbold">&nbsp;#session.ep.money2#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK_2)#</td>
                                <td class="txtbold">&nbsp;#session.ep.money2#</td>
                            </cfif>
                            <td  class="txtbold" style="text-align:right;" format="numeric"><cfif IsDefined("ALL_ROW_TOTAL_INCOME_2") and ALL_ROW_TOTAL_INCOME_2 neq 0>#TLFormat((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK_2/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                        </cfif>
                        <cfif isdefined("attributes.transfer")>				
                            <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_TRANSFER_AMOUNT_ALACAK)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME + GET_EXPENSE_BUDGET.ALL_TRANSFER_AMOUNT_ALACAK)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.is_expense")>
                        
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)#</td>
                        <td class="txtbold">&nbsp;#session.ep.money#</td>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC)#</td>
                        <td></td>
                        <td class="txtbold">&nbsp;#session.ep.money#</td>
                        <cfif isdefined("attributes.is_diff")>
                            <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC)#</td>
                            <td class="txtbold">&nbsp;#session.ep.money#</td>
                        </cfif>
                        <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE neq 0>#TLFormat((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                            <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2)#</td>
                            <td class="txtbold">&nbsp;#session.ep.money2#</td>
                            <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2)#</td>
                            <td class="txtbold">&nbsp;#session.ep.money2#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  class="txtbold" style="text-align:right;" format="numeric">#TlFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2)#</td>
                                <td class="txtbold">&nbsp;#session.ep.money2#</td>
                            </cfif>
                            <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2 neq 0>#TLFormat((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                        </cfif>
                        <cfif isdefined("attributes.transfer")>				
                            <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_TRANSFER_AMOUNT_BORC)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE + GET_EXPENSE_BUDGET.ALL_TRANSFER_AMOUNT_BORC)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>                         
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME-GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)#</td>
                        <td  class="txtbold" style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)#</td>	
                        <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE neq 0>#TLFormat(((GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME-GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
                        <td  class="txtbold" style="text-align:right;" format="numeric"><cfif GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK neq 0>#TLFormat(((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)/GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
                    </cfif>
                    <cfif isdefined("attributes.ei_diff")>
                        <td  style="text-align:right;" format="numeric">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)#</td>
                    </cfif>
                </tr> 
            </cfif>        
        </cfoutput>                       
    </tbody>
    <cfif attributes.maxrows*attributes.page gte attributes.totalrecords>
        <tfoot>	
            <tr>
                <td colspan="40">
                    <cfoutput>
                        <cf_get_lang no='70.Planlanan Gelir Gider Fark??'>: %<cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE neq 0>#TlFormat(((GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE-GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME)/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)*100)#<cfelse>#TlFormat(0)#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang no='69.Ger??ekle??en Gelir Gider Fark??'>: %<cfif GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK neq 0>#TlFormat(((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC)/GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)*100)#<cfelse>#TlFormat(0)#</cfif>
                    </cfoutput>
                </td>
            </tr>
        </tfoot>
    </cfif>
<cfelse>
    <tbody>
        <tr>
            <td colspan="40"><cf_get_lang dictionary_id='57484.Kay??t Yok'>!</td>
        </tr>
    </tbody>
</cfif>

