<cfif fusebox.use_period>
	<cfset db_alias_ = dsn2_alias>
<cfelse>
	<cfset db_alias_ = dsn_alias>
</cfif>
<cfset aylist = "">
<cfloop from="#attributes.startdate#" to="#attributes.finishdate#" index="aaa">
	<cfset aylist = listappend(aylist,aaa)>
</cfloop>
<cfquery name="CHECK_TABLE" datasource="#dsn2#">
	IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_EXPENSE_CENTER_ITEM_#session.ep.userid#')
    DROP TABLE ####GET_EXPENSE_CENTER_ITEM_#session.ep.userid#
</cfquery>
<cfquery name="GET_EXPENSE_CENTER_ITEM" datasource="#dsn2#">
    SELECT 
    	EXPENSE.EXPENSE_ID,
        EXPENSE.EXPENSE,
        EXPENSE.ACTIVITY_ID,
    	EXPENSE.EXPENSE_CODE,
        EXPENSE_ITEM.EXPENSE_ITEM_ID,
        EXPENSE_ITEM.EXPENSE_ITEM_NAME,
        EXPENSE_ITEM.ACCOUNT_CODE,
        EXPENSE_ITEM.EXPENSE_CAT_NAME
    INTO ####GET_EXPENSE_CENTER_ITEM_#session.ep.userid#
    FROM
    (	
        SELECT
            EXPENSE_ID,
            EXPENSE,
            EXPENSE_CODE,
            ACTIVITY_ID
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
            EXPENSE_CATEGORY.EXPENSE_CAT_NAME
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

<cfquery name="check_table" datasource="#dsn2#">
	IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_PLANLANAN_#session.ep.userid#_ay')
    DROP TABLE ####GET_PLANLANAN_#session.ep.userid#_ay
</cfquery>
<cfquery name="ROW_INCOME" datasource="#dsn2#">
SELECT 	
    <cfloop list="#aylist#" index="ay">
    	[ROW_TOTAL_INCOME_#ay#], [ROW_TOTAL_EXPENSE_#ay#],[ROW_TOTAL_INCOME_2_#ay#],[ROW_TOTAL_EXPENSE_2_#ay#],
    </cfloop>
    BUDGET_ITEM_ID,
    EXP_INC_CENTER_ID
   <!--- [2_ROW_TOTAL_INCOME], [2_ROW_TOTAL_EXPENSE],[2_ROW_TOTAL_INCOME_2],[2_ROW_TOTAL_EXPENSE_2],
    [3_ROW_TOTAL_INCOME], [3_ROW_TOTAL_EXPENSE],[3_ROW_TOTAL_INCOME_2],[3_ROW_TOTAL_EXPENSE_2],
    [4_ROW_TOTAL_INCOME], [4_ROW_TOTAL_EXPENSE],[4_ROW_TOTAL_INCOME_2],[4_ROW_TOTAL_EXPENSE_2],
    [5_ROW_TOTAL_INCOME], [5_ROW_TOTAL_EXPENSE],[5_ROW_TOTAL_INCOME_2],[5_ROW_TOTAL_EXPENSE_2],
    [6_ROW_TOTAL_INCOME], [6_ROW_TOTAL_EXPENSE],[6_ROW_TOTAL_INCOME_2],[6_ROW_TOTAL_EXPENSE_2],
    [7_ROW_TOTAL_INCOME], [7_ROW_TOTAL_EXPENSE],[7_ROW_TOTAL_INCOME_2],[7_ROW_TOTAL_EXPENSE_2],
    [8_ROW_TOTAL_INCOME], [8_ROW_TOTAL_EXPENSE],[8_ROW_TOTAL_INCOME_2],[8_ROW_TOTAL_EXPENSE_2],
    [9_ROW_TOTAL_INCOME], [9_ROW_TOTAL_EXPENSE],[9_ROW_TOTAL_INCOME_2],[9_ROW_TOTAL_EXPENSE_2],
    [10_ROW_TOTAL_INCOME], [10_ROW_TOTAL_EXPENSE],[10_ROW_TOTAL_INCOME_2],[10_ROW_TOTAL_EXPENSE_2],
    [11_ROW_TOTAL_INCOME], [11_ROW_TOTAL_EXPENSE],[11_ROW_TOTAL_INCOME_2],[11_ROW_TOTAL_EXPENSE_2],
    [12_ROW_TOTAL_INCOME], [12_ROW_TOTAL_EXPENSE],[12_ROW_TOTAL_INCOME_2],[12_ROW_TOTAL_EXPENSE_2]--->
INTO ####GET_PLANLANAN_#session.ep.userid#_ay
FROM 
(	 
     SELECT 
        CAST(COL AS NVARCHAR)+'_'+CAST(AY AS NVARCHAR(50)) AS COL,
        BUDGET_ITEM_ID,
        EXP_INC_CENTER_ID,
        VALUE
     FROM 
     
     (
        SELECT 
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME),0) ROW_TOTAL_INCOME,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE),0) ROW_TOTAL_EXPENSE,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2),0) ROW_TOTAL_INCOME_2,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2),0) ROW_TOTAL_EXPENSE_2,
                BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
                BUDGET_PLAN_ROW.BUDGET_ITEM_ID,
                MONTH(BUDGET_PLAN_ROW.PLAN_DATE) AS AY
            FROM
                #DSN_ALIAS#.BUDGET_PLAN,
                #DSN_ALIAS#.BUDGET_PLAN_ROW 
            WHERE 
                BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
                BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
                BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
                MONTH(BUDGET_PLAN_ROW.PLAN_DATE) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#aylist#" list="yes">)
                <cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
                    AND BUDGET_PLAN_ROW.BUDGET_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #db_alias_#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID IN (#attributes.expense_cat#)) 
                </cfif>
                <cfif isdefined("attributes.plan_process_cat") and len(attributes.plan_process_cat)>
                    AND BUDGET_PLAN.PROCESS_CAT IN (#attributes.plan_process_cat#)
                </cfif>
            GROUP BY
                BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
                BUDGET_PLAN_ROW.BUDGET_ITEM_ID,
                MONTH(BUDGET_PLAN_ROW.PLAN_DATE)

     ) AS SRC
    unpivot
    (
        value
        for col in (ROW_TOTAL_INCOME, ROW_TOTAL_EXPENSE,ROW_TOTAL_INCOME_2,ROW_TOTAL_EXPENSE_2)
    ) unpiv
)  S
pivot
(
  sum(value)
      for col in (
                    <cfloop list="#aylist#" index="ay">
                    	<cfif listfirst(aylist) neq ay >,</cfif>
                        [ROW_TOTAL_INCOME_#ay#], [ROW_TOTAL_EXPENSE_#ay#],[ROW_TOTAL_INCOME_2_#ay#],[ROW_TOTAL_EXPENSE_2_#ay#]
                    </cfloop>
                )
) piv
</cfquery>


<cfquery name="check_table" datasource="#dsn2#">
	IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_GERCEKLESEN_#session.ep.userid#_ay')
    DROP TABLE ####GET_GERCEKLESEN_#session.ep.userid#_ay
</cfquery>

<cfquery name="INS_PLANLANAN" datasource="#dsn2#">
	SELECT 	
	
    <cfloop list="#aylist#" index="ay">
		[TOTAL_AMOUNT_BORC_#ay#], [TOTAL_AMOUNT_ALACAK_#ay#],[TOTAL_AMOUNT_2_BORC_#ay#],[TOTAL_AMOUNT_2_ALACAK_#ay#],
    </cfloop>
	<!---[2_TOTAL_AMOUNT_BORC], [2_TOTAL_AMOUNT_ALACAK],[2_TOTAL_AMOUNT_2_BORC],[2_TOTAL_AMOUNT_2_ALACAK],
	[3_TOTAL_AMOUNT_BORC], [3_TOTAL_AMOUNT_ALACAK],[3_TOTAL_AMOUNT_2_BORC],[3_TOTAL_AMOUNT_2_ALACAK],
	[4_TOTAL_AMOUNT_BORC], [4_TOTAL_AMOUNT_ALACAK],[4_TOTAL_AMOUNT_2_BORC],[4_TOTAL_AMOUNT_2_ALACAK],
	[5_TOTAL_AMOUNT_BORC], [5_TOTAL_AMOUNT_ALACAK],[5_TOTAL_AMOUNT_2_BORC],[5_TOTAL_AMOUNT_2_ALACAK],
	[6_TOTAL_AMOUNT_BORC], [6_TOTAL_AMOUNT_ALACAK],[6_TOTAL_AMOUNT_2_BORC],[6_TOTAL_AMOUNT_2_ALACAK],
	[7_TOTAL_AMOUNT_BORC], [7_TOTAL_AMOUNT_ALACAK],[7_TOTAL_AMOUNT_2_BORC],[7_TOTAL_AMOUNT_2_ALACAK],
	[8_TOTAL_AMOUNT_BORC], [8_TOTAL_AMOUNT_ALACAK],[8_TOTAL_AMOUNT_2_BORC],[8_TOTAL_AMOUNT_2_ALACAK],
	[9_TOTAL_AMOUNT_BORC], [9_TOTAL_AMOUNT_ALACAK],[9_TOTAL_AMOUNT_2_BORC],[9_TOTAL_AMOUNT_2_ALACAK],
	[10_TOTAL_AMOUNT_BORC], [10_TOTAL_AMOUNT_ALACAK],[10_TOTAL_AMOUNT_2_BORC],[10_TOTAL_AMOUNT_2_ALACAK],
	[11_TOTAL_AMOUNT_BORC], [11_TOTAL_AMOUNT_ALACAK],[11_TOTAL_AMOUNT_2_BORC],[11_TOTAL_AMOUNT_2_ALACAK],
	[12_TOTAL_AMOUNT_BORC], [12_TOTAL_AMOUNT_ALACAK],[12_TOTAL_AMOUNT_2_BORC],[12_TOTAL_AMOUNT_2_ALACAK]--->
    EXPENSE_ITEM_ID,
	EXPENSE_CENTER_ID
INTO ####GET_GERCEKLESEN_#session.ep.userid#_ay
FROM 
(	
		SELECT 
            CAST(COL AS NVARCHAR)+'_'+CAST(AY AS NVARCHAR(50)) AS COL,
			EXPENSE_ITEM_ID,
			EXPENSE_CENTER_ID,
			VALUE
		FROM 
		(
			SELECT
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS  TOTAL_AMOUNT_BORC,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS  TOTAL_AMOUNT_ALACAK,
                SUM( CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_BORC,
                SUM( CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_ALACAK,
                EXPENSE_CENTER_ID,
                EXPENSE_ITEM_ID,
                AY
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
                    EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,
                    month(EXPENSE_ITEMS_ROWS.EXPENSE_DATE) as AY
                FROM
                    EXPENSE_ITEMS_ROWS
                WHERE
                    TOTAL_AMOUNT > 0					
                    AND month(EXPENSE_ITEMS_ROWS.EXPENSE_DATE) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#aylist#" list="yes">)
                    <cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
                        AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #db_alias_#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID IN (#attributes.expense_cat#)) 
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND EXPENSE_ITEMS_ROWS.PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
                    </cfif>
                    <cfif isDefined("attributes.process_cat") and len(attributes.process_cat)>
                        AND EXPENSE_COST_TYPE IN (#attributes.process_cat#)
                    </cfif>
            )T1
            GROUP BY
                EXPENSE_CENTER_ID,
                EXPENSE_ITEM_ID,
                AY
		) AS SRC
		unpivot
		(
			value
			for col in (TOTAL_AMOUNT_BORC, TOTAL_AMOUNT_ALACAK,TOTAL_AMOUNT_2_BORC,TOTAL_AMOUNT_2_ALACAK)
		) unpiv
)  S
pivot
(
  sum(value)
  for col in (
  
  				<cfloop list="#aylist#" index="ay">
                	<cfif listfirst(aylist) neq ay >,</cfif>
                    [TOTAL_AMOUNT_BORC_#ay#], [TOTAL_AMOUNT_ALACAK_#ay#],[TOTAL_AMOUNT_2_BORC_#ay#],[TOTAL_AMOUNT_2_ALACAK_#ay#]
                </cfloop>
				<!---[1_TOTAL_AMOUNT_BORC], [1_TOTAL_AMOUNT_ALACAK],[1_TOTAL_AMOUNT_2_BORC],[1_TOTAL_AMOUNT_2_ALACAK],
				[2_TOTAL_AMOUNT_BORC], [2_TOTAL_AMOUNT_ALACAK],[2_TOTAL_AMOUNT_2_BORC],[2_TOTAL_AMOUNT_2_ALACAK],
				[3_TOTAL_AMOUNT_BORC], [3_TOTAL_AMOUNT_ALACAK],[3_TOTAL_AMOUNT_2_BORC],[3_TOTAL_AMOUNT_2_ALACAK],
				[4_TOTAL_AMOUNT_BORC], [4_TOTAL_AMOUNT_ALACAK],[4_TOTAL_AMOUNT_2_BORC],[4_TOTAL_AMOUNT_2_ALACAK],
				[5_TOTAL_AMOUNT_BORC], [5_TOTAL_AMOUNT_ALACAK],[5_TOTAL_AMOUNT_2_BORC],[5_TOTAL_AMOUNT_2_ALACAK],
				[6_TOTAL_AMOUNT_BORC], [6_TOTAL_AMOUNT_ALACAK],[6_TOTAL_AMOUNT_2_BORC],[6_TOTAL_AMOUNT_2_ALACAK],
				[7_TOTAL_AMOUNT_BORC], [7_TOTAL_AMOUNT_ALACAK],[7_TOTAL_AMOUNT_2_BORC],[7_TOTAL_AMOUNT_2_ALACAK],
				[8_TOTAL_AMOUNT_BORC], [8_TOTAL_AMOUNT_ALACAK],[8_TOTAL_AMOUNT_2_BORC],[8_TOTAL_AMOUNT_2_ALACAK],
				[9_TOTAL_AMOUNT_BORC], [9_TOTAL_AMOUNT_ALACAK],[9_TOTAL_AMOUNT_2_BORC],[9_TOTAL_AMOUNT_2_ALACAK],
				[10_TOTAL_AMOUNT_BORC], [10_TOTAL_AMOUNT_ALACAK],[10_TOTAL_AMOUNT_2_BORC],[10_TOTAL_AMOUNT_2_ALACAK],
				[11_TOTAL_AMOUNT_BORC], [11_TOTAL_AMOUNT_ALACAK],[11_TOTAL_AMOUNT_2_BORC],[11_TOTAL_AMOUNT_2_ALACAK],
				[12_TOTAL_AMOUNT_BORC], [12_TOTAL_AMOUNT_ALACAK],[12_TOTAL_AMOUNT_2_BORC],[12_TOTAL_AMOUNT_2_ALACAK]--->
			)
) piv
</cfquery>

<cfquery name="GET_EXPENSE_BUDGET" datasource="#dsn2#">
	
WITH CTE1 AS (
	SELECT 
            GEC.EXPENSE_ID,
            GEC.EXPENSE,
            GEC.EXPENSE_CODE,
            GEC.ACTIVITY_ID,
            GEC.EXPENSE_ITEM_ID,
            GEC.EXPENSE_ITEM_NAME,
            GEC.ACCOUNT_CODE,
            GEC.EXPENSE_CAT_NAME
            <cfloop list="#aylist#" index="ay">
                ,ISNULL([ROW_TOTAL_INCOME_#ay#],0) AS ROW_TOTAL_INCOME_#ay#, ISNULL([ROW_TOTAL_EXPENSE_#ay#],0) AS ROW_TOTAL_EXPENSE_#ay# ,ISNULL([ROW_TOTAL_INCOME_2_#ay#],0) AS ROW_TOTAL_INCOME_2_#ay# ,ISNULL([ROW_TOTAL_EXPENSE_2_#ay#],0) AS ROW_TOTAL_EXPENSE_2_#ay#
            </cfloop>
            <cfloop list="#aylist#" index="ay">
                ,ISNULL([TOTAL_AMOUNT_BORC_#ay#],0) AS TOTAL_AMOUNT_BORC_#ay#, ISNULL([TOTAL_AMOUNT_ALACAK_#ay#],0) AS TOTAL_AMOUNT_ALACAK_#ay# ,ISNULL([TOTAL_AMOUNT_2_BORC_#ay#],0) AS TOTAL_AMOUNT_2_BORC_#ay# ,ISNULL([TOTAL_AMOUNT_2_ALACAK_#ay#],0) AS TOTAL_AMOUNT_2_ALACAK_#ay#
            </cfloop>
    FROM
    	####GET_EXPENSE_CENTER_ITEM_#session.ep.userid# AS GEC
    LEFT JOIN    
        (
        	SELECT 
               	*
            FROM
              	####GET_PLANLANAN_#session.ep.userid#_ay
        ) AS PLANLANAN
     ON
     	PLANLANAN.EXP_INC_CENTER_ID = GEC.EXPENSE_ID AND PLANLANAN.BUDGET_ITEM_ID = GEC.EXPENSE_ITEM_ID
     LEFT JOIN
     	(
        	SELECT * FROM ####GET_GERCEKLESEN_#session.ep.userid#_ay
        ) AS GERCEKLESEN  
     ON
     	   GERCEKLESEN.EXPENSE_CENTER_ID =  GEC.EXPENSE_ID AND GEC.EXPENSE_ITEM_ID = GERCEKLESEN.EXPENSE_ITEM_ID 
     WHERE 
     	  PLANLANAN.EXP_INC_CENTER_ID IS NOT NULL  OR GERCEKLESEN.EXPENSE_CENTER_ID IS NOT NULL
	) 

	SELECT 
		 CTE1.*,
		(
		 <cfloop list="#aylist#" index="ay">
			 	<cfif ay neq 1 >+</cfif>
				ROW_TOTAL_INCOME_#ay#
		</cfloop>
		) as  TOPLAM_ROW_TOTAL_INCOME,
		(
		 <cfloop list="#aylist#" index="ay">
			 	<cfif ay neq 1 >+</cfif>
				ROW_TOTAL_EXPENSE_#ay#
		</cfloop>
		) as  TOPLAM_ROW_TOTAL_EXPENSE,

		(
		 <cfloop list="#aylist#" index="ay">
			 	<cfif ay neq 1 >+</cfif>
				ROW_TOTAL_INCOME_2_#ay#
		</cfloop>
		) as  TOPLAM_ROW_TOTAL_INCOME_2,

		(
		 <cfloop list="#aylist#" index="ay">
			 	<cfif ay neq 1 >+</cfif>
				ROW_TOTAL_EXPENSE_2_#ay#
		</cfloop>
		) as  TOPLAM_ROW_TOTAL_EXPENSE_2,

		(
		 <cfloop list="#aylist#" index="ay">
			 	<cfif ay neq 1 >+</cfif>
				TOTAL_AMOUNT_BORC_#ay#
		</cfloop>
		) as  TOPLAM_TOTAL_AMOUNT_BORC,
		(
		 <cfloop list="#aylist#" index="ay">
			 	<cfif ay neq 1 >+</cfif>
				TOTAL_AMOUNT_ALACAK_#ay#
		</cfloop>
		) as  TOPLAM_TOTAL_AMOUNT_ALACAK,

		(
		 <cfloop list="#aylist#" index="ay">
			 	<cfif ay neq 1 >+</cfif>
				TOTAL_AMOUNT_2_BORC_#ay#
		</cfloop>
		) as  TOPLAM_TOTAL_AMOUNT_2_BORC,

		(
		 <cfloop list="#aylist#" index="ay">
			 	<cfif ay neq 1 >+</cfif>
				TOTAL_AMOUNT_2_ALACAK_#ay#
		</cfloop>
		) as  TOPLAM_TOTAL_AMOUNT_2_ALACAK
	FROM 
		CTE1 
</cfquery>
	<cfset myCol = 0>
	<cfset myCol2 = 0>
	<cfif isdefined("attributes.is_income")>
        <thead>	
            <tr>
                <th style="text-align:left;" colspan="84" nowrap height="25"><cf_get_lang dictionary_id='58089.Gelirler'></th>
            </tr>
            <tr>
                <cfset colspan_no_ = 5>
                <cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
                    <cfset colspan_no_ = colspan_no_ + 1>
                </cfif>
                <cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1 or (isdefined("attributes.is_activity_type") and len(attributes.is_activity_type))>
                    <cfset colspan_no_ = colspan_no_ + 1>
                </cfif>
                <th  nowrap colspan="<cfoutput>#colspan_no_#</cfoutput>"></th>
                <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                    <cfif isdefined("attributes.is_diff")>
                        <cfset colspan_info = 13>
                    <cfelse>
                        <cfset colspan_info = 9>
                    </cfif>
                <cfelse>
                    <cfif isdefined("attributes.is_diff")>
                        <cfset colspan_info = 6>
                    <cfelse>
                        <cfset colspan_info = 4>
                    </cfif>
                </cfif>
                <cfoutput>
                    <cfloop list="#aylist#" index="ay">
                        <cfif isdefined("attributes.is_income")>
                                
                            <th colspan="<cfoutput>#colspan_info#</cfoutput>" align="center" nowrap><cfoutput>#listgetat(aylar,ay,',')#</cfoutput></th>
                        </cfif>
                    </cfloop>
                </cfoutput>	
                <th colspan="<cfoutput>#colspan_info#</cfoutput>" align="center" nowrap><cf_get_lang dictionary_id='57492.Toplam'></th>
            </tr>
            <tr>
                <th width="25" nowrap><cf_get_lang dictionary_id='57487.No'></th><cfset myCol = myCol + 1>
                <cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
                <th  nowrap><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th><cfset myCol = myCol + 1>
                </cfif>
                <th nowrap><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th><cfset myCol = myCol + 1>
                <th nowrap><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th><cfset myCol = myCol + 1>
                <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
                    <th><cf_get_lang no='90.Aktivite Tipi'></th><cfset myCol = myCol + 1>
                </cfif>
                <cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
                    <th nowrap><cf_get_lang dictionary_id='49109.Masraf Merkezi Kodu'></th><cfset myCol = myCol + 1>
                </cfif>
                <th  nowrap><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th><cfset myCol = myCol + 1>
                <cfoutput>
                    <cfloop list="#aylist#" index="ay">
                        <cfif isdefined("attributes.is_income")>                            
                            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                            <cfif isdefined("attributes.is_diff")>
                                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol + 1>
                                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                            </cfif>
                            
                            <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol + 1>
                                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'> </th><cfset myCol = myCol + 1>
                                <th width="110" align="center" nowrap></th><cfset myCol = myCol + 1>
                                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                                <cfif isdefined("attributes.is_diff")>
                                    <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol + 1>
                                    <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfloop>
                    <cfif isdefined("attributes.is_income")>                    
                        <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol + 1>
                        <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                        <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol + 1>
                        <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                        <cfif isdefined("attributes.is_diff")>
                            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                        </cfif>                        
                        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'> </th><cfset myCol = myCol + 1>
                            <th width="110" align="center" nowrap></th><cfset myCol = myCol + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                            <cfif isdefined("attributes.is_diff")>
                                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol + 1>
                                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfoutput>
            </tr>
        </thead>
	    <cfparam name="attributes.totalrecords" default='#GET_EXPENSE_BUDGET.recordcount#'>
        <cfif GET_EXPENSE_BUDGET.recordcount>
            <cfoutput query="GET_EXPENSE_BUDGET" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
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
                        <cfloop list="#aylist#" index="ay">
                            <cfif isdefined("attributes.is_income")>                            
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.ROW_TOTAL_INCOME_#ay#"))#</td>
                                <td>&nbsp;#session.ep.money#</td>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOTAL_AMOUNT_ALACAK_#ay#"))#</td>
                                <td>&nbsp;#session.ep.money#</td>
                                <cfif isdefined("attributes.is_diff")>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.ROW_TOTAL_INCOME_#ay#")-evaluate("GET_EXPENSE_BUDGET.TOTAL_AMOUNT_ALACAK_#ay#"))#</td>
                                    <td>&nbsp;#session.ep.money#</td>
                                </cfif>
                                <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.ROW_TOTAL_INCOME_2_#ay#"))#</td>
                                    <td>&nbsp;#session.ep.money2#</td>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOTAL_AMOUNT_2_ALACAK_#ay#"))#</td>
                                    <td>&nbsp;#session.ep.money2#</td>
                                    <cfif isdefined("attributes.is_diff")>
                                        <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.ROW_TOTAL_INCOME_2_#ay#")-evaluate("GET_EXPENSE_BUDGET.TOTAL_AMOUNT_2_ALACAK_#ay#"))#</td>
                                        <td>&nbsp;#session.ep.money2#</td>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("attributes.is_income")>
                        
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_ROW_TOTAL_INCOME"))#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_TOTAL_AMOUNT_ALACAK"))#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_ROW_TOTAL_INCOME")-evaluate("GET_EXPENSE_BUDGET.TOPLAM_TOTAL_AMOUNT_ALACAK"))#</td>
                                <td>&nbsp;#session.ep.money#</td>
                            </cfif>
                            <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_ROW_TOTAL_INCOME_2"))#</td>
                                <td>&nbsp;#session.ep.money2#</td>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_TOTAL_AMOUNT_2_ALACAK"))#</td>
                                <td>&nbsp;#session.ep.money2#</td>
                                <cfif isdefined("attributes.is_diff")>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_ROW_TOTAL_INCOME_2")-evaluate("GET_EXPENSE_BUDGET.TOPLAM_TOTAL_AMOUNT_2_ALACAK"))#</td>
                                    <td>&nbsp;#session.ep.money2#</td>
                                </cfif>
                            </cfif>
                        </cfif>
                    </tr>
            </cfoutput>
            <tbody>
                <tr>
                    <td class="txtbold" style="text-align:right;" colspan="<cfoutput>#colspan_no_#</cfoutput>"><cf_get_lang dictionary_id='57492.Toplam'></td>
                    <cfquery name="get_toplam" dbtype="query">
                        SELECT
                            <cfloop list="#aylist#" index="ay">
                                <cfif listfirst(aylist) neq ay>,</cfif>
                                SUM(ROW_TOTAL_INCOME_#ay#) AS ROW_TOTAL_INCOME_#ay#,
                                SUM(TOTAL_AMOUNT_ALACAK_#ay#) AS TOTAL_AMOUNT_ALACAK_#ay#
                                <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                    ,SUM(ROW_TOTAL_INCOME_2_#ay#) AS ROW_TOTAL_INCOME_2_#ay#
                                    ,SUM(TOTAL_AMOUNT_2_ALACAK_#ay#) AS TOTAL_AMOUNT_2_ALACAK_#ay#
                                </cfif>
                            </cfloop>
                            ,SUM(TOPLAM_ROW_TOTAL_INCOME) AS TOPLAM_ROW_TOTAL_INCOME
                            ,SUM(TOPLAM_TOTAL_AMOUNT_ALACAK) AS TOPLAM_TOTAL_AMOUNT_ALACAK
                            ,SUM(TOPLAM_ROW_TOTAL_INCOME_2) AS TOPLAM_ROW_TOTAL_INCOME_2
                            ,SUM(TOPLAM_TOTAL_AMOUNT_2_ALACAK) AS TOPLAM_TOTAL_AMOUNT_2_ALACAK
                        FROM 
                            GET_EXPENSE_BUDGET
                    </cfquery>
                    <cfoutput>
                        <cfloop list="#aylist#" index="ay">
                            <cfif isdefined("attributes.is_income")>
                            
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.ROW_TOTAL_INCOME_#ay#"))#</td>
                                <td>&nbsp;#session.ep.money#</td>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOTAL_AMOUNT_ALACAK_#ay#"))#</td>
                                <td>&nbsp;#session.ep.money#</td>
                                <cfif isdefined("attributes.is_diff")>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.ROW_TOTAL_INCOME_#ay#")-evaluate("get_toplam.TOTAL_AMOUNT_ALACAK_#ay#"))#</td>
                                    <td>&nbsp;#session.ep.money#</td>
                                </cfif>
                                <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.ROW_TOTAL_INCOME_2_#ay#"))#</td>
                                    <td>&nbsp;#session.ep.money2#</td>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOTAL_AMOUNT_2_ALACAK_#ay#"))#</td>
                                    <td>&nbsp;#session.ep.money2#</td>
                                    <cfif isdefined("attributes.is_diff")>
                                        <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.ROW_TOTAL_INCOME_2_#ay#")-evaluate("get_toplam.TOTAL_AMOUNT_2_ALACAK_#ay#"))#</td>
                                        <td>&nbsp;#session.ep.money2#</td>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("attributes.is_income")>
                        
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_ROW_TOTAL_INCOME"))#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_TOTAL_AMOUNT_ALACAK"))#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_ROW_TOTAL_INCOME")-evaluate("get_toplam.TOPLAM_TOTAL_AMOUNT_ALACAK"))#</td>
                                <td>&nbsp;#session.ep.money#</td>
                            </cfif>
                            <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_ROW_TOTAL_INCOME_2"))#</td>
                                <td>&nbsp;#session.ep.money2#</td>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_TOTAL_AMOUNT_2_ALACAK"))#</td>
                                <td>&nbsp;#session.ep.money2#</td>
                                <cfif isdefined("attributes.is_diff")>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_ROW_TOTAL_INCOME_2")-evaluate("get_toplam.TOPLAM_TOTAL_AMOUNT_2_ALACAK"))#</td>
                                    <td>&nbsp;#session.ep.money2#</td>
                                </cfif>
                            </cfif>
                        </cfif>	
                    </cfoutput>
                </tr>
            </tbody>
        <cfelse>
            <tbody>
                <tr>
                    <td colspan="<cfoutput>#myCol#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </tbody>
        </cfif>
	</cfif>
	<cfif isdefined("attributes.is_expense")>
	<thead>	
		<tr>
			<th style="text-align:left;" colspan="84" nowrap height="25"><cf_get_lang no='47.Giderler'></th>
		</tr>
		<tr>
			<cfset colspan_no_ = 5>
			<cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
				<cfset colspan_no_ = colspan_no_ + 1>
			</cfif>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<cfset colspan_no_ = colspan_no_ + 1>
			</cfif>
			<th  nowrap colspan="<cfoutput>#colspan_no_#</cfoutput>"></th>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<cfif isdefined("attributes.is_diff")>
					<cfset colspan_info = 13>
				<cfelse>
					<cfset colspan_info = 9>
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.is_diff")>
					<cfset colspan_info = 6>
				<cfelse>
					<cfset colspan_info = 4>
				</cfif>
			</cfif>
            <cfoutput>
                <cfloop list="#aylist#" index="ay">
                    <cfif isdefined("attributes.is_expense")>
                        <th colspan="<cfoutput>#colspan_info#</cfoutput>" align="center" nowrap><cfoutput>#listgetat(aylar,ay,',')#</cfoutput></th>
                    </cfif>
                </cfloop>
				
                <th colspan="<cfoutput>#colspan_info#</cfoutput>" align="center" nowrap><cf_get_lang dictionary_id='57492.Toplam'></th>
            </cfoutput>
		</tr>
		<tr>
			<th width="25" nowrap><cf_get_lang dictionary_id='57487.No'></th><cfset myCol2 = myCol2 + 1>
			<cfif isdefined('is_show_account_code') and is_show_account_code eq 1>
			<th  nowrap><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th><cfset myCol2 = myCol2 + 1>
			</cfif>
			<th nowrap><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th><cfset myCol2 = myCol2 + 1>
            <th nowrap><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th><cfset myCol2 = myCol2 + 1>
            <cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
                <th><cf_get_lang no='90.Aktivite Tipi'></th><cfset myCol2 = myCol2 + 1>
            </cfif>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<th nowrap><cf_get_lang dictionary_id='49109.Masraf Merkezi Kodu'></th><cfset myCol2 = myCol2 + 1>
			</cfif>
			<th  nowrap><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th><cfset myCol2 = myCol2 + 1>
			<cfoutput>
                <cfloop list="#aylist#" index="ay">
                    <cfif isdefined("attributes.is_expense")>
                        
                        <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2 + 1>
                        <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                        <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2 + 1>
                        <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                        <cfif isdefined("attributes.is_diff")>
                            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2 + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                        </cfif>
                        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2 + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2 + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                            <cfif isdefined("attributes.is_diff")>
                                <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2 + 1>
                                <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
				<cfif isdefined("attributes.is_expense")>
                    
                    <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2 + 1>
                    <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                    <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2 + 1>
                    <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                    <cfif isdefined("attributes.is_diff")>
                        <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2 + 1>
                        <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                    </cfif>
                    <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                        <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2 + 1>
                        <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                        <th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2 + 1>
                        <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                        <cfif isdefined("attributes.is_diff")>
                            <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2 + 1>
                            <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                        </cfif>
                    </cfif>
                </cfif>
            </cfoutput>
		</tr>
 	</thead>
	<cfparam name="attributes.totalrecords" default='#GET_EXPENSE_BUDGET.recordcount#'>
	<cfif GET_EXPENSE_BUDGET.recordcount>
		<cfoutput query="GET_EXPENSE_BUDGET" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
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
					<cfloop list="#aylist#" index="ay">
						<cfif isdefined("attributes.is_expense")>
                            
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.ROW_TOTAL_EXPENSE_#ay#"))#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOTAL_AMOUNT_BORC_#ay#"))# </td>
                            <td>&nbsp;#session.ep.money#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.ROW_TOTAL_EXPENSE_#ay#")-evaluate("GET_EXPENSE_BUDGET.TOTAL_AMOUNT_BORC_#ay#"))# </td>
                                <td>&nbsp;#session.ep.money#</td>
                            </cfif>
                            <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.ROW_TOTAL_EXPENSE_2_#ay#"))#</td>
                                <td>&nbsp;#session.ep.money2#</td>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOTAL_AMOUNT_2_BORC_#ay#"))# </td>
                                <td>&nbsp;#session.ep.money2#</td>
                                <cfif isdefined("attributes.is_diff")>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.ROW_TOTAL_EXPENSE_2_#ay#")-evaluate("GET_EXPENSE_BUDGET.TOTAL_AMOUNT_2_BORC_#ay#"))# </td>
                                    <td>&nbsp;#session.ep.money2#</td>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfloop>
					<cfif isdefined("attributes.is_expense")>
                        
                        <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_ROW_TOTAL_EXPENSE"))#</td>
                        <td>&nbsp;#session.ep.money#</td>
                        <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_TOTAL_AMOUNT_BORC"))# </td>
                        <td>&nbsp;#session.ep.money#</td>
                        <cfif isdefined("attributes.is_diff")>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_ROW_TOTAL_EXPENSE")-evaluate("GET_EXPENSE_BUDGET.TOPLAM_TOTAL_AMOUNT_BORC"))# </td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_ROW_TOTAL_EXPENSE_2"))#</td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_TOTAL_AMOUNT_2_BORC"))# </td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("GET_EXPENSE_BUDGET.TOPLAM_ROW_TOTAL_EXPENSE_2")-evaluate("GET_EXPENSE_BUDGET.TOPLAM_TOTAL_AMOUNT_2_BORC"))# </td>
                                <td>&nbsp;#session.ep.money2#</td>
                            </cfif>
                        </cfif>
					</cfif>
				</tr>
		</cfoutput>
		<tbody>
            <tr>
                <td class="txtbold" style="text-align:right;" colspan="<cfoutput>#colspan_no_#</cfoutput>">Toplam</td>

				<cfquery name="get_toplam" dbtype="query">
                    SELECT
                        <cfloop list="#aylist#" index="ay">
                            <cfif listfirst(aylist) neq ay>,</cfif>
                            SUM(ROW_TOTAL_EXPENSE_#ay#) AS ROW_TOTAL_EXPENSE_#ay#,
                            SUM(TOTAL_AMOUNT_BORC_#ay#) AS TOTAL_AMOUNT_BORC_#ay#
                            <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                ,SUM(ROW_TOTAL_EXPENSE_2_#ay#) AS ROW_TOTAL_EXPENSE_2_#ay#
                                ,SUM(TOTAL_AMOUNT_2_BORC_#ay#) AS TOTAL_AMOUNT_2_BORC_#ay#
                            </cfif>
                        </cfloop>
						,SUM(TOPLAM_ROW_TOTAL_EXPENSE) AS TOPLAM_ROW_TOTAL_EXPENSE
						,SUM(TOPLAM_TOTAL_AMOUNT_BORC) AS TOPLAM_TOTAL_AMOUNT_BORC
						,SUM(TOPLAM_ROW_TOTAL_EXPENSE_2) AS TOPLAM_ROW_TOTAL_EXPENSE_2
						,SUM(TOPLAM_TOTAL_AMOUNT_2_BORC) AS TOPLAM_TOTAL_AMOUNT_2_BORC
                    FROM 
                        GET_EXPENSE_BUDGET
                </cfquery>
				<cfoutput>
                    <cfloop list="#aylist#" index="ay">
                        <cfif isdefined("attributes.is_expense")>
                           
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.ROW_TOTAL_EXPENSE_#ay#"))#</td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOTAL_AMOUNT_BORC_#ay#"))# </td>
                            <td>&nbsp;#session.ep.money#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.ROW_TOTAL_EXPENSE_#ay#")-evaluate("get_toplam.TOTAL_AMOUNT_BORC_#ay#"))# </td>
                                <td>&nbsp;#session.ep.money#</td>
                            </cfif>
                            <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.ROW_TOTAL_EXPENSE_2_#ay#"))#</td>
                                <td>&nbsp;#session.ep.money2#</td>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOTAL_AMOUNT_2_BORC_#ay#"))# </td>
                                <td>&nbsp;#session.ep.money2#</td>
                                <cfif isdefined("attributes.is_diff")>
                                    <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.ROW_TOTAL_EXPENSE_2_#ay#")-evaluate("get_toplam.TOTAL_AMOUNT_2_BORC_#ay#"))# </td>
                                    <td>&nbsp;#session.ep.money2#</td>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfloop>
					<cfif isdefined("attributes.is_expense")>
                        
                        <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_ROW_TOTAL_EXPENSE"))#</td>
                        <td>&nbsp;#session.ep.money#</td>
                        <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_TOTAL_AMOUNT_BORC"))# </td>
                        <td>&nbsp;#session.ep.money#</td>
                        <cfif isdefined("attributes.is_diff")>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_ROW_TOTAL_EXPENSE")-evaluate("get_toplam.TOPLAM_TOTAL_AMOUNT_BORC"))# </td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                        <cfif isdefined("attributes.is_money") and len(session.ep.money2)>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_ROW_TOTAL_EXPENSE_2"))#</td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_TOTAL_AMOUNT_2_BORC"))# </td>
                            <td>&nbsp;#session.ep.money2#</td>
                            <cfif isdefined("attributes.is_diff")>
                                <td  style="text-align:right;" format="numeric">#TlFormat(evaluate("get_toplam.TOPLAM_ROW_TOTAL_EXPENSE_2")-evaluate("get_toplam.TOPLAM_TOTAL_AMOUNT_2_BORC"))# </td>
                                <td>&nbsp;#session.ep.money2#</td>
                            </cfif>
                        </cfif>
                    </cfif>
				</cfoutput>
            </tr>
        </tbody>
	<cfelse>
		<tbody>
			<tr>
               
				<td colspan="<cfoutput>#myCol2#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                
			</tr>
		</tbody>
	</cfif>
	</cfif>


