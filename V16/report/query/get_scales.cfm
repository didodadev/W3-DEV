<cfset project_id_list = attributes.project_id>
<cfif isdefined('attributes.project_head2') and len(attributes.project_head2) and isdefined("attributes.project_id2") and len(attributes.project_id2)>
	<cfset project_id_list = listappend(project_id_list,attributes.project_id2)>          
</cfif>
<cfif isdefined('attributes.project_head3') and len(attributes.project_head3) and isdefined("attributes.project_id3") and len(attributes.project_id3)>
	<cfset project_id_list = listappend(project_id_list,attributes.project_id3)>          
</cfif>
<cfif isdefined('attributes.project_head4') and len(attributes.project_head4) and isdefined("attributes.project_id4") and len(attributes.project_id4)>
	<cfset project_id_list = listappend(project_id_list,attributes.project_id4)>          
</cfif>
<cfif isdefined('attributes.project_head5') and len(attributes.project_head5) and isdefined("attributes.project_id5") and len(attributes.project_id5)>
	<cfset project_id_list = listappend(project_id_list,attributes.project_id5)>          
</cfif>
<cfquery name="GET_ACC_REMAINDER" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		SUM(BAKIYE) AS BAKIYE, 
		SUM(BORC) AS BORC,
		SUM(ALACAK) AS ALACAK, 
	<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
		SUM(OTHER_BAKIYE) AS OTHER_BAKIYE, 
		SUM(OTHER_BORC) AS OTHER_BORC, 
		SUM(OTHER_ALACAK) AS OTHER_ALACAK, 
		OTHER_CURRENCY, 
	</cfif>
	<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
		SUM(BAKIYE_2) AS BAKIYE_2, 
		SUM(BORC_2) AS BORC_2, 
		SUM(ALACAK_2) AS ALACAK_2, 
	</cfif>
	ACCOUNT_CODE,
	ACCOUNT_NAME,
	<cfif attributes.report_type eq 1>
		DEPARTMENT_ID,
	<cfelseif attributes.report_type eq 2>
		BRANCH_ID,
	</cfif>
    ACC_PROJECT_ID,
	ACCOUNT_ID,
	SUB_ACCOUNT
	<cfif isdefined('attributes.is_quantity')>
		,SUM(QUANTITY_ALACAK) AS QUANTITY_ALACAK
		,SUM(QUANTITY_BORC) AS QUANTITY_BORC
	</cfif>	
	FROM
	(
	SELECT
		ACCOUNT_PLAN.SUB_ACCOUNT,
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK),2) AS BAKIYE, 
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC),2) AS BORC,
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK),2) AS ALACAK, 
	<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_BORC - ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_ALACAK),2) AS OTHER_BAKIYE, 
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_BORC),2) AS OTHER_BORC,
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_ALACAK),2) AS OTHER_ALACAK, 
		ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY,
	</cfif>
	<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.AMOUNT2_BORC - ACCOUNT_ACCOUNT_REMAINDER.AMOUNT2_ALACAK),2) AS BAKIYE_2, 
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.AMOUNT2_BORC),2) AS BORC_2,
		ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.AMOUNT2_ALACAK),2) AS ALACAK_2, 
	</cfif>
	<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
		ACCOUNT_PLAN.IFRS_CODE AS ACCOUNT_CODE,
		ACCOUNT_PLAN.IFRS_NAME AS ACCOUNT_NAME,
	<cfelse>
		ACCOUNT_PLAN.ACCOUNT_CODE,
		ACCOUNT_PLAN.ACCOUNT_NAME,
	</cfif>
	<cfif attributes.priority_type eq 1>
		<cfif attributes.report_type eq 1>
			CASE WHEN (ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND CHARINDEX('.',ACCOUNT_CODE) = 0)
			THEN
				0
			ELSE
				DEPARTMENT_ID
			END AS DEPARTMENT_ID,
		<cfelseif attributes.report_type eq 2>
			CASE WHEN (ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND CHARINDEX('.',ACCOUNT_CODE) = 0)
			THEN
				0
			ELSE
				BRANCH_ID
			END AS BRANCH_ID,
		</cfif>
        <cfif attributes.report_type eq 4>
            CASE WHEN (ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND CHARINDEX('.',ACCOUNT_CODE) = 0)
            THEN
                0
            ELSE
                ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACC_PROJECT_ID),ACC_PROJECT_ID)
            END AS ACC_PROJECT_ID,
        <cfelse>	
            CASE WHEN (ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND CHARINDEX('.',ACCOUNT_CODE) = 0)
            THEN
                0
            ELSE
                ACC_PROJECT_ID
            END AS ACC_PROJECT_ID,
        </cfif>
	<cfelse>
		<cfif attributes.report_type eq 1>
			DEPARTMENT_ID,
		<cfelseif attributes.report_type eq 2>
			BRANCH_ID,
		</cfif>	
        <cfif attributes.report_type eq 4>
            ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACC_PROJECT_ID),ACC_PROJECT_ID) ACC_PROJECT_ID,
        <cfelse>	
            ACC_PROJECT_ID,
        </cfif>
	</cfif>
	ACCOUNT_PLAN.ACCOUNT_ID
	<cfif isdefined('attributes.is_quantity')>
		,ISNULL(ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.QUANTITY_ALACAK),2),0) AS QUANTITY_ALACAK
		,ISNULL(ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.QUANTITY_BORC),2),0) AS QUANTITY_BORC
	</cfif>	
	FROM
		(
		SELECT
			0 AS ALACAK,
			 SUM(ROUND(ACCOUNT_CARD_ROWS.AMOUNT,2)) AS BORC,
		<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
			0 AS OTHER_AMOUNT_ALACAK,
			SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS OTHER_AMOUNT_BORC,
			ISNULL(ACCOUNT_CARD_ROWS.OTHER_CURRENCY,'#session.ep.money#') AS OTHER_CURRENCY,
		</cfif>
		<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
			0 AS AMOUNT2_ALACAK,
			SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS AMOUNT2_BORC,
		</cfif>
		<cfif attributes.report_type eq 1>
			ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID AS DEPARTMENT_ID,
		<cfelseif attributes.report_type eq 2>
			ACCOUNT_CARD_ROWS.ACC_BRANCH_ID AS BRANCH_ID,
		</cfif>	
        	ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,
			ACCOUNT_CARD_ROWS.ACCOUNT_ID
		<cfif isdefined('attributes.is_quantity')>
			,0 AS QUANTITY_ALACAK
			,SUM(QUANTITY) QUANTITY_BORC
		</cfif>		
		FROM
			ACCOUNT_CARD_ROWS,ACCOUNT_CARD
		<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1) and ((isDefined("attributes.str_account_code") and len(attributes.str_account_code)) or (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5"))))>
			,ACCOUNT_PLAN ACC_P
		</cfif>
		WHERE
			BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
			AND (
			<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
				(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
				<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
			</cfloop>  
				)
		</cfif>				
		<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
			<cfif (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
				AND ACCOUNT_CARD_ROWS.ACCOUNT_ID=ACC_P.ACCOUNT_CODE
			<cfelseif isDefined("attributes.str_account_code") and len(attributes.str_account_code)>
				AND (ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE ACC_P.ACCOUNT_CODE + '.%' OR ACCOUNT_CARD_ROWS.ACCOUNT_ID = ACC_P.ACCOUNT_CODE)
			</cfif>
			<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
				AND (ACC_P.IFRS_CODE LIKE '#attributes.str_account_code#' OR ACC_P.IFRS_CODE LIKE '#attributes.str_account_code#.%')
			</cfif>
		<cfelse>
			<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
				AND (ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#' OR ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#.%')
			</cfif>
		</cfif>
		<!--- Muhasebe Hesabi Arama Cokluya Cevrildi 20110928 --->
		<cfif (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
			AND
			(
			<cfloop from="1" to="5" index="kk">
				<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
					<cfif kk neq 1>OR</cfif>
					(
						1 = 1
						<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
							AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACC_P.IFRS_CODE<cfelse>ACCOUNT_CARD_ROWS.ACCOUNT_ID</cfif> >= '#evaluate("attributes.acc_code1_#kk#")#'
						</cfif>
						<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
							AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACC_P.IFRS_CODE<cfelse>ACCOUNT_CARD_ROWS.ACCOUNT_ID</cfif> <= '#evaluate("attributes.acc_code2_#kk#")#'
						</cfif>
					)
				</cfif>
			</cfloop>
			)
		</cfif>
		<cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) and isdefined('attributes.expense_center_name') and len(attributes.expense_center_name)>
			AND ACCOUNT_CARD_ROWS.COST_PROFIT_CENTER=#attributes.expense_center_id#
		</cfif>
		<cfif isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
			AND ACTION_DATE BETWEEN #attributes.DATE1# AND #attributes.DATE2#
		</cfif>
		<cfif isdefined('attributes.is_bill_opening')> <!--- acilis fisi hesaba katılmayacaksa --->
			AND ACCOUNT_CARD.CARD_TYPE <> 10
		</cfif>
		<cfif isdefined('attributes.is_bill_close')> <!--- kapanis fisi hesaba katılmayacaksa --->
			AND ACCOUNT_CARD.CARD_TYPE <> 19
		</cfif>
		<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
			AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
		</cfif>
		<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
			<cfif attributes.report_type eq 4>
				AND ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACCOUNT_CARD_ROWS.ACC_PROJECT_ID),ACCOUNT_CARD_ROWS.ACC_PROJECT_ID) = #attributes.project_id#
			<cfelse>	
				AND ACCOUNT_CARD_ROWS.ACC_PROJECT_ID IN (#project_id_list#)
			</cfif>
		</cfif>
		<cfif isdefined("attributes.show_main_account") and attributes.sub_accounts eq -1>
			AND ACCOUNT_CARD_ROWS.ACCOUNT_ID IN(SELECT ACCC.ACCOUNT_CODE FROM ACCOUNT_PLAN ACCC WHERE ACCC.SUB_ACCOUNT = 0)
		</cfif>		
	GROUP BY
			ACCOUNT_CARD_ROWS.ACCOUNT_ID
		<cfif attributes.report_type eq 1>
			,ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID
		<cfelseif attributes.report_type eq 2>
			,ACCOUNT_CARD_ROWS.ACC_BRANCH_ID
		</cfif>	
        ,ACCOUNT_CARD_ROWS.ACC_PROJECT_ID
		<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
			,ACCOUNT_CARD_ROWS.OTHER_CURRENCY
		</cfif>
		<cfif isdefined('attributes.is_quantity')>
			,QUANTITY
		</cfif>		
		HAVING SUM(ROUND(ACCOUNT_CARD_ROWS.AMOUNT,2))<>0
	UNION ALL
		SELECT
			 SUM(ROUND(ACCOUNT_CARD_ROWS.AMOUNT,2)) AS ALACAK,
 			0 AS BORC,
		<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
			SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS OTHER_AMOUNT_ALACAK,
			0 AS OTHER_AMOUNT_BORC,
			ISNULL(ACCOUNT_CARD_ROWS.OTHER_CURRENCY,'#session.ep.money#') AS OTHER_CURRENCY,
		</cfif>
		<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
			SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS AMOUNT2_ALACAK,
			0 AS AMOUNT2_BORC,
		</cfif>
		<cfif attributes.report_type eq 1>
			ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID AS DEPARTMENT_ID,
		<cfelseif attributes.report_type eq 2>
			ACCOUNT_CARD_ROWS.ACC_BRANCH_ID AS BRANCH_ID,
		</cfif>	
        	ACCOUNT_CARD_ROWS.ACC_PROJECT_ID,
			ACCOUNT_CARD_ROWS.ACCOUNT_ID		
		<cfif isdefined('attributes.is_quantity')>
			,SUM(QUANTITY) AS QUANTITY_ALACAK
			,0 AS QUANTITY_BORC
		</cfif>	
		FROM
			ACCOUNT_CARD_ROWS,
			ACCOUNT_CARD
			<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1) and ((isDefined("attributes.str_account_code") and len(attributes.str_account_code)) or (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5"))))>
				,ACCOUNT_PLAN ACC_P
			</cfif>
		WHERE
			BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
			AND (
			<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
				(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
				<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
			</cfloop>  
				)
		</cfif>				
		<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
			<cfif (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
				AND ACCOUNT_CARD_ROWS.ACCOUNT_ID=ACC_P.ACCOUNT_CODE
			<cfelseif isDefined("attributes.str_account_code") and len(attributes.str_account_code)>
				AND (ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE ACC_P.ACCOUNT_CODE + '.%' OR ACCOUNT_CARD_ROWS.ACCOUNT_ID = ACC_P.ACCOUNT_CODE)
			</cfif>
			<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
				AND (ACC_P.IFRS_CODE LIKE '#attributes.str_account_code#' OR ACC_P.IFRS_CODE LIKE '#attributes.str_account_code#.%')
			</cfif>
		<cfelse>
			<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
				AND (ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#' OR ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#.%')
			</cfif>
		</cfif>
		<!--- Muhasebe Hesabi Arama Cokluya Cevrildi 20110928 --->
		<cfif (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
			AND
			(
			<cfloop from="1" to="5" index="kk">
				<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
					<cfif kk neq 1>OR</cfif>
					(
						1 = 1
						<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
							AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACC_P.IFRS_CODE<cfelse>ACCOUNT_CARD_ROWS.ACCOUNT_ID</cfif> >= '#evaluate("attributes.acc_code1_#kk#")#'
						</cfif>
						<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
							AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACC_P.IFRS_CODE<cfelse>ACCOUNT_CARD_ROWS.ACCOUNT_ID</cfif> <= '#evaluate("attributes.acc_code2_#kk#")#'
						</cfif>
					)
				</cfif>
			</cfloop>
			)
		</cfif>
		<cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) and isdefined('attributes.expense_center_name') and len(attributes.expense_center_name)>
			AND ACCOUNT_CARD_ROWS.COST_PROFIT_CENTER=#attributes.expense_center_id#
		</cfif>
		<cfif isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
			AND ACTION_DATE BETWEEN #attributes.DATE1# AND #attributes.DATE2#
		</cfif>
		<cfif isdefined('attributes.is_bill_opening')> <!--- acilis fisi hesaba katılmayacaksa --->
			AND ACCOUNT_CARD.CARD_TYPE <> 10
		</cfif>
		<cfif isdefined('attributes.is_bill_close')> <!--- kapanis fisi hesaba katılmayacaksa --->
			AND ACCOUNT_CARD.CARD_TYPE <> 19
		</cfif>
		<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
			AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
		</cfif>
		<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
			<cfif attributes.report_type eq 4>
				AND ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACCOUNT_CARD_ROWS.ACC_PROJECT_ID),ACCOUNT_CARD_ROWS.ACC_PROJECT_ID) = #attributes.project_id#
			<cfelse>	
				AND ACCOUNT_CARD_ROWS.ACC_PROJECT_ID IN (#project_id_list#)
			</cfif>
		</cfif>
		<cfif isdefined("attributes.show_main_account") and attributes.sub_accounts eq -1>
			AND ACCOUNT_CARD_ROWS.ACCOUNT_ID IN(SELECT ACCC.ACCOUNT_CODE FROM ACCOUNT_PLAN ACCC WHERE ACCC.SUB_ACCOUNT = 0)
		</cfif>		
		GROUP BY
			ACCOUNT_CARD_ROWS.ACCOUNT_ID
		<cfif attributes.report_type eq 1>
			,ACCOUNT_CARD_ROWS.ACC_DEPARTMENT_ID
		<cfelseif attributes.report_type eq 2>
			,ACCOUNT_CARD_ROWS.ACC_BRANCH_ID
		</cfif>	
        ,ACCOUNT_CARD_ROWS.ACC_PROJECT_ID
		<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
			,ACCOUNT_CARD_ROWS.OTHER_CURRENCY
		</cfif>
		<cfif isdefined('attributes.is_quantity')>
			,QUANTITY
		</cfif>	
		HAVING SUM(ROUND(ACCOUNT_CARD_ROWS.AMOUNT,2))<>0 
		<!--- HAREKET GORMEYEN HESAPLAR --->
		<cfif not isdefined("attributes.no_process_accounts")>
		UNION ALL
			SELECT DISTINCT
				0 AS ALACAK,
				0 AS BORC,
			<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
				0 AS OTHER_AMOUNT_ALACAK,
				0 AS OTHER_AMOUNT_BORC,
				'#session.ep.money#' AS OTHER_CURRENCY,
			</cfif>
			<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 2>
				0 AS AMOUNT2_ALACAK,
				0 AS AMOUNT2_BORC,
			</cfif>
			<cfif attributes.report_type eq 1>
				'' AS DEPARTMENT_ID,
			<cfelseif attributes.report_type eq 2>
				'' AS BRANCH_ID,
			</cfif>	
            	'' ACC_PROJECT_ID,
				ACCOUNT_PLAN.ACCOUNT_CODE ACCOUNT_ID
			<cfif isdefined('attributes.is_quantity')>
				,0 AS QUANTITY_ALACAK
				,0 AS QUANTITY_BORC
			</cfif>	
			FROM
				ACCOUNT_PLAN,
				ACCOUNT_PLAN ACCOUNT_ACCOUNT_REMAINDER
			WHERE
				ACCOUNT_PLAN.ACCOUNT_CODE NOT IN 
									(SELECT 
										ACCOUNT_ID 
									FROM 
										ACCOUNT_CARD_ROWS,
										ACCOUNT_CARD
									WHERE
										ACCOUNT_PLAN.ACCOUNT_CODE = ACCOUNT_CARD_ROWS.ACCOUNT_ID AND
										ACCOUNT_CARD_ROWS.CARD_ID = ACCOUNT_CARD.CARD_ID
										<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
											AND (
											<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
												(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
												<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
											</cfloop>  
												)
										</cfif>
										<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
											<cfif (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
												AND ACCOUNT_CARD_ROWS.ACCOUNT_ID=ACCOUNT_PLAN.ACCOUNT_CODE
											<cfelseif isDefined("attributes.str_account_code") and len(attributes.str_account_code)>
												AND (ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE + '.%' OR ACCOUNT_CARD_ROWS.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
											</cfif>
											<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
												AND ( ACCOUNT_PLAN.IFRS_CODE LIKE '#attributes.str_account_code#' OR ACCOUNT_PLAN.IFRS_CODE LIKE '#attributes.str_account_code#.%')
											</cfif>
										<cfelse>
											<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
												AND ( ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#' OR ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#.%')
											</cfif>
										</cfif>
										<!--- Muhasebe Hesabi Arama Cokluya Cevrildi 20110928 --->
										<cfif (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
											AND
											(
											<cfloop from="1" to="5" index="kk">
												<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
													<cfif kk neq 1>OR</cfif>
													(
														1 = 1
														<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
															AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACCOUNT_PLAN.IFRS_CODE<cfelse>ACCOUNT_CARD_ROWS.ACCOUNT_ID</cfif> >= '#evaluate("attributes.acc_code1_#kk#")#'
														</cfif>
														<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
															AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACCOUNT_PLAN.IFRS_CODE<cfelse>ACCOUNT_CARD_ROWS.ACCOUNT_ID</cfif> <= '#evaluate("attributes.acc_code2_#kk#")#'
														</cfif>
													)
												</cfif>
											</cfloop>
											)
										</cfif>
										<cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) and isdefined('attributes.expense_center_name') and len(attributes.expense_center_name)>
											AND ACCOUNT_CARD_ROWS.COST_PROFIT_CENTER=#attributes.expense_center_id#
										</cfif>
										<cfif isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
											AND ACCOUNT_CARD.ACTION_DATE BETWEEN #attributes.DATE1# AND #attributes.DATE2#
										</cfif>
										<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
											AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
										</cfif>
										<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
											<cfif attributes.report_type eq 4>
												AND ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACCOUNT_CARD_ROWS.ACC_PROJECT_ID),ACCOUNT_CARD_ROWS.ACC_PROJECT_ID) = #attributes.project_id#
											<cfelse>	
												AND ACCOUNT_CARD_ROWS.ACC_PROJECT_ID IN  (#project_id_list#)
											</cfif>
										</cfif>
									)
				<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
					<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)>
						AND ( ACCOUNT_PLAN.IFRS_CODE LIKE '#attributes.str_account_code#' OR ACCOUNT_PLAN.IFRS_CODE LIKE '#attributes.str_account_code#.%')
					<cfelse>
						AND ( ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.str_account_code#' OR ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.str_account_code#.%')
					</cfif>
				</cfif>
				<!--- Muhasebe Hesabi Arama Cokluya Cevrildi 20110928 --->
				<cfif (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
					AND
					(
					<cfloop from="1" to="5" index="kk">
						<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
							<cfif kk neq 1>OR</cfif>
							(
								1 = 1
								<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
									AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACCOUNT_PLAN.IFRS_CODE<cfelse>ACCOUNT_PLAN.ACCOUNT_CODE</cfif> >= '#evaluate("attributes.acc_code1_#kk#")#'
								</cfif>
								<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
									AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACCOUNT_PLAN.IFRS_CODE<cfelse>ACCOUNT_PLAN.ACCOUNT_CODE</cfif> <= '#evaluate("attributes.acc_code2_#kk#")#'
								</cfif>
							)
						</cfif>
					</cfloop>
					)
				</cfif>
				<!---AND 
				(
					(
						(
							(
								CHARINDEX('.',ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_CODE) > 0 AND
								ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND
								ACCOUNT_PLAN.ACCOUNT_CODE = LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_CODE,<cfif (isDefined("attributes.sub_accounts") and attributes.sub_accounts EQ 0)>(NULLIF(CHARINDEX('.',ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_CODE)-1,-1))<cfelse>LEN(ACCOUNT_PLAN.ACCOUNT_CODE)</cfif>)
							)
							OR
							(
								CHARINDEX('.',ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_CODE) = 0 AND
								LEN(ACCOUNT_PLAN.ACCOUNT_CODE)>0 AND
								ACCOUNT_PLAN.ACCOUNT_CODE = <cfif (isDefined("attributes.sub_accounts") and attributes.sub_accounts EQ 0)>ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_CODE<cfelse>LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_CODE,LEN(ACCOUNT_PLAN.ACCOUNT_CODE))</cfif>
							)
						)
						<cfif isDefined("attributes.sub_accounts") and attributes.sub_accounts neq 0>
							AND substring(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_CODE,(LEN(ACCOUNT_PLAN.ACCOUNT_CODE)+1),1)='.'
						</cfif>
					)
					<cfif isDefined("attributes.sub_accounts") and attributes.sub_accounts neq 0>
						OR ACCOUNT_PLAN.ACCOUNT_CODE = ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_CODE
					</cfif>
				)--->
				<cfif isDefined("attributes.sub_accounts") and attributes.sub_accounts neq 0 and attributes.sub_accounts neq -1> <!--- ust hesaplar ve 1.,2.,3. alt hesap kırılımları icin--->
					<cfif database_type is 'MSSQL'>
						AND len(replace(ACCOUNT_PLAN.ACCOUNT_CODE, '.', '.' + ' ')) - len(ACCOUNT_PLAN.ACCOUNT_CODE) <= #attributes.sub_accounts# <!--- ust hesapta '. bulunmayacagı icin fark 0'a eşittir--->
					<cfelseif database_type is 'DB2'>
						AND LENGTH(replace(ACCOUNT_PLAN.ACCOUNT_CODE, '.', '.' + ' ')) - LENGTH(ACCOUNT_PLAN.ACCOUNT_CODE) <= #attributes.sub_accounts#
					</cfif>
				</cfif>
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					AND (ACCOUNT_PLAN.ACCOUNT_NAME LIKE '#attributes.keyword#%' OR ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.keyword#%')
				</cfif>
		</cfif>
		)
		AS ACCOUNT_ACCOUNT_REMAINDER,
		ACCOUNT_PLAN
	WHERE
		1=1
		<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
			<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)>
				AND ( ACCOUNT_PLAN.IFRS_CODE LIKE '#attributes.str_account_code#' OR ACCOUNT_PLAN.IFRS_CODE LIKE '#attributes.str_account_code#.%')
			<cfelse>
				AND ( ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.str_account_code#' OR ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.str_account_code#.%')
			</cfif>
		</cfif>
		<!--- Muhasebe Hesabi Arama Cokluya Cevrildi 20110928 --->
		<cfif (isDefined("attributes.acc_code2_1") and len(evaluate("attributes.acc_code2_1"))) or (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
			AND
			(
			<cfloop from="1" to="5" index="kk">
				<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
					<cfif kk neq 1>OR</cfif>
					(
						1 = 1
						<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
							AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACCOUNT_PLAN.IFRS_CODE<cfelse>ACCOUNT_PLAN.ACCOUNT_CODE</cfif> >= '#evaluate("attributes.acc_code1_#kk#")#'
						</cfif>
						<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
							AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACCOUNT_PLAN.IFRS_CODE<cfelse>ACCOUNT_PLAN.ACCOUNT_CODE</cfif> <= '#evaluate("attributes.acc_code2_#kk#")#'
						</cfif>
					)
				</cfif>
			</cfloop>
			)
		</cfif>
		AND (
				(
					(
						(
							CHARINDEX('.',ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID) > 0 AND
							ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND
							ACCOUNT_PLAN.ACCOUNT_CODE = LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,<cfif (isDefined("attributes.sub_accounts") and attributes.sub_accounts EQ 0)>(CHARINDEX('.',ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID)-1)<cfelse>LEN(ACCOUNT_PLAN.ACCOUNT_CODE)</cfif>)
						)
						OR
						(
							CHARINDEX('.',ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID) = 0 AND
							ACCOUNT_PLAN.ACCOUNT_CODE = <cfif (isDefined("attributes.sub_accounts") and attributes.sub_accounts EQ 0)>ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID<cfelse>LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,LEN(ACCOUNT_PLAN.ACCOUNT_CODE))</cfif>
						)
						OR (LEN(ACCOUNT_PLAN.ACCOUNT_CODE) < 3 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE+'%')
					)
					<!--- <cfif isDefined("attributes.sub_accounts") and attributes.sub_accounts neq 0>
						AND substring(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,(LEN(ACCOUNT_PLAN.ACCOUNT_CODE)+1),1)='.'
					</cfif> --->
				)
				<cfif isDefined("attributes.sub_accounts") and attributes.sub_accounts neq 0>
				OR ACCOUNT_PLAN.ACCOUNT_CODE = ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID
				</cfif>
			)
		<cfif isDefined("attributes.sub_accounts") and attributes.sub_accounts neq 0 and attributes.sub_accounts neq -1> <!--- ust hesaplar ve 1.,2.,3. alt hesap kırılımları icin--->
			<cfif database_type is 'MSSQL'>
				<cfif isdefined("attributes.show_main_account") and attributes.sub_accounts neq 0>
					AND len(replace(ACCOUNT_PLAN.ACCOUNT_CODE, '.', '.' + ' ')) - len(ACCOUNT_PLAN.ACCOUNT_CODE) = #attributes.sub_accounts# <!--- ust hesapta '. bulunmayacagı icin fark 0'a eşittir--->
				<cfelse>
					AND len(replace(ACCOUNT_PLAN.ACCOUNT_CODE, '.', '.' + ' ')) - len(ACCOUNT_PLAN.ACCOUNT_CODE) <= #attributes.sub_accounts# <!--- ust hesapta '. bulunmayacagı icin fark 0'a eşittir--->
				</cfif>
			<cfelseif database_type is 'DB2'>
				AND LENGTH(replace(ACCOUNT_PLAN.ACCOUNT_CODE, '.', '.' + ' ')) - LENGTH(ACCOUNT_PLAN.ACCOUNT_CODE) <= #attributes.sub_accounts#
			</cfif>
		</cfif>
		<cfif isdefined("attributes.show_main_account") and attributes.sub_accounts eq -1>
			AND ACCOUNT_PLAN.SUB_ACCOUNT = 0
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
				(ACCOUNT_PLAN.ACCOUNT_NAME LIKE '#attributes.keyword#%'
				OR
				ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.keyword#%')
		</cfif>
	GROUP BY
	<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
		ACCOUNT_PLAN.IFRS_CODE,
		ACCOUNT_PLAN.IFRS_NAME,
	<cfelse>
		ACCOUNT_PLAN.ACCOUNT_CODE, 
		ACCOUNT_PLAN.ACCOUNT_NAME,
	</cfif>
	<cfif attributes.priority_type eq 1>
		ACCOUNT_PLAN.ACCOUNT_CODE,
	</cfif>
	ACCOUNT_PLAN.ACCOUNT_ID,
	ACCOUNT_PLAN.SUB_ACCOUNT
	<cfif attributes.report_type eq 1>
		,DEPARTMENT_ID
	<cfelseif attributes.report_type eq 2>
		,BRANCH_ID
	</cfif>
    ,ACC_PROJECT_ID
	<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
		,ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY
	</cfif>
	<cfif isdefined('attributes.is_bakiye')>
		HAVING round(SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK),2) <> 0
	</cfif>
	)T1
	GROUP BY
		ACCOUNT_CODE, 
		ACCOUNT_NAME,
		ACCOUNT_ID,
		SUB_ACCOUNT
		<cfif attributes.report_type eq 1>
			,DEPARTMENT_ID
		<cfelseif attributes.report_type eq 2>
			,BRANCH_ID
		</cfif>
        ,ACC_PROJECT_ID
		<cfif isdefined('attributes.money_type_') and attributes.money_type_ eq 3>
			,OTHER_CURRENCY
		</cfif>
	<cfif isdefined('attributes.is_bakiye')>
		HAVING round(SUM(T1.BORC - T1.ALACAK),2) <> 0
	</cfif>
	ORDER BY 
	<cfif attributes.priority_type eq 1>
		<cfif attributes.report_type eq 1>
			CASE WHEN (CHARINDEX('.',ACCOUNT_CODE) = 0)
			THEN
			ACCOUNT_CODE+'_'+ISNULL(CAST(DEPARTMENT_ID AS NVARCHAR),0)
			ELSE
			LEFT(ACCOUNT_CODE,CHARINDEX('.',ACCOUNT_CODE)-1)+'_'+ISNULL(CAST(DEPARTMENT_ID AS NVARCHAR),0)
			END
		<cfelseif attributes.report_type eq 2>
			CASE WHEN (CHARINDEX('.',ACCOUNT_CODE) = 0)
			THEN
			ACCOUNT_CODE+'_'+ISNULL(CAST(BRANCH_ID AS NVARCHAR),0)
			ELSE
			LEFT(ACCOUNT_CODE,CHARINDEX('.',ACCOUNT_CODE)-1)+'_'+ISNULL(CAST(BRANCH_ID AS NVARCHAR),0)
			END
		</cfif>
	</cfif>
    	
	<cfif attributes.priority_type eq 1 and len(attributes.report_type) and attributes.report_type gt 0>
		,ACC_PROJECT_ID
        ,ACCOUNT_CODE
	<cfelse>
    	ACC_PROJECT_ID
		,ACCOUNT_CODE
	</cfif>
</cfquery>

