<!---
    File: audit_cmb_control.cfc
    Author: Pınar Yıldız
    Description:
       Cari, muhasebe ve bütçe kayıtlarının işlem tipi ve ID'sine göre belirli bir tarih aralığında raporlanması ve farkların bulunması.
--->
<cfcomponent displayname="Get_cmb_records"  hint="Get_cmb_records">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    
    <cffunction name="get_records" access="remote"  returntype="any">
        <cfargument name="employee_id">
        <cfargument name="employee_name">
        <cfargument name="sal_mon">
        <cfargument name="sal_year">
        <cfargument name="comp_ids">
        <cfargument name="department_id">
        <cfargument name="branch_ids">
		<cfargument name="acc_code1_1" default="">
		<cfargument name="acc_code2_1" default="">
		<cfargument name="expense_item_id" default="">
       <cfquery name="get_records" datasource="#dsn2#">
	    WITH CTE1 as 
		(
		SELECT 
			max(PAPER_NO) as PAPER_NO,
			ACTION_TYPE,
			ACTION_ID,
			MAX(MUHASEBE) AS MUHASEBE,
			MAX(CARI) AS CARI,
			MAX(BUTCE) AS BUTCE,
			IS_INCOME
			
		FROM
		(
				select 
					AC.PAPER_NO,
					AC.ACTION_TYPE,
					AC.ACTION_ID,
					SUM(ACR.AMOUNT) AS MUHASEBE,
					0 AS CARI,
					0 AS BUTCE,
					'' AS IS_INCOME
				--	,'' EXPENSE_ITEM_ID
				--	,ACCOUNT_ID
				from 
				ACCOUNT_CARD AC
				JOIN ACCOUNT_CARD_ROWS ACR ON AC.CARD_ID = ACR.CARD_ID AND ACR.BA = 0
				WHERE
					1 = 1 
				<cfif len(arguments.process_type)>
					AND AC.ACTION_TYPE IN (#arguments.process_type#)
				</cfif>
				<cfif len(arguments.startdate)>
					AND AC.ACTION_DATE >= #arguments.startdate#
				</cfif>
				<cfif len(arguments.finishdate)>
					AND AC.ACTION_DATE <= #arguments.finishdate#
				</cfif>
				<cfif isDefined("arguments.acc_code1_1") and len(evaluate("arguments.acc_code1_1"))>
					AND ACR.ACCOUNT_ID >= '#evaluate("arguments.acc_code1_1")#'
				</cfif>
				<cfif isDefined("arguments.acc_code2_1") and len(evaluate("arguments.acc_code2_1"))>
					AND ACR.ACCOUNT_ID <= '#evaluate("arguments.acc_code2_1")#'
				</cfif>
				
				GROUP BY
					AC.PAPER_NO,
					AC.ACTION_TABLE,
					AC.ACTION_TYPE,
					AC.ACTION_ID
				--	,ACCOUNT_ID
				UNION ALL
				select 
					PAPER_NO,
					ACTION_TYPE_ID AS ACTION_TYPE,
					ACTION_ID,
					0 AS MUHASEBE,
					ACTION_VALUE AS CARI,
					0 AS BUTCE,
					'' AS IS_INCOME
					--,'' EXPENSE_ITEM_ID
					--,'' ACCOUNT_ID
				from 
				CARI_ROWS
				WHERE
					1 = 1 
					<cfif len(arguments.process_type)>
						AND ACTION_TYPE_ID IN (#arguments.process_type#)
					</cfif>
					<cfif len(arguments.startdate)>
						AND ACTION_DATE >= #arguments.startdate#
					</cfif>
					<cfif len(arguments.finishdate)>
						AND ACTION_DATE <=#arguments.finishdate#
					</cfif>
				UNION ALL
				SELECT
				    PAPER_NO, 
					ACTION_TYPE,
					ACTION_ID,
					MUHASEBE,
					CARI,
					SUM(BUTCE) AS BUTCE,
					'' IS_INCOME--,
					--EXPENSE_ITEM_ID
					--,'' ACCOUNT_ID
					FROM
					(
						select 
							ROW_PAPER_NO AS PAPER_NO, 
							EXPENSE_COST_TYPE AS ACTION_TYPE,
							ISNULL(ISNULL(INVOICE_ID,NULLIF(EXPENSE_ID,0)),ACTION_ID) AS ACTION_ID,
							0 AS MUHASEBE,
							0 AS CARI,
							QUANTITY*AMOUNT AS BUTCE,
							IS_INCOME,
							EXPENSE_ITEM_ID
						from 
						EXPENSE_ITEMS_ROWS
						WHERE
							1 = 1 
							<cfif len(arguments.process_type)>
								AND EXPENSE_COST_TYPE IN (#arguments.process_type#)
							</cfif>
							<cfif len(arguments.startdate)>
								AND EXPENSE_DATE >= #arguments.startdate#
							</cfif>
							<cfif len(arguments.finishdate)>
								AND EXPENSE_DATE <= #arguments.finishdate#
							</cfif>
							<cfif len(arguments.expense_item_id)>
								AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #arguments.expense_item_id#
							</cfif>
					) AS TTT
					GROUP BY 
					PAPER_NO, 
					ACTION_TYPE,
					ACTION_ID,
					MUHASEBE,
					CARI,
					IS_INCOME
				--	,EXPENSE_ITEM_ID

		) AS T1
		WHERE 
		1 = 1
	<!---	<cfif len(arguments.expense_item_id)>
			AND EXPENSE_ITEM_ID = #arguments.expense_item_id#
		</cfif>
		<cfif isDefined("arguments.acc_code1_1") and len(evaluate("arguments.acc_code1_1"))>
				AND ACCOUNT_ID >= '#evaluate("arguments.acc_code1_1")#'
			</cfif>
			<cfif isDefined("arguments.acc_code2_1") and len(evaluate("arguments.acc_code2_1"))>
				AND ACCOUNT_ID <= '#evaluate("arguments.acc_code2_1")#'
			</cfif> --->
			<!--- <cfif isDefined("arguments.acc_code1_1") and len(evaluate("arguments.acc_code1_1"))>
			and
			t1.MUHASEBE > 0
			</cfif>
			<cfif len(arguments.expense_item_id)>
			and
			t1.BUTCE > 0
		</cfif> --->
		GROUP BY 
			--PAPER_NO,
			ACTION_TYPE,
			ACTION_ID,
			IS_INCOME
			<cfif (isDefined("arguments.acc_code1_1") and len(evaluate("arguments.acc_code1_1"))) or   len(arguments.expense_item_id)>
			HAVING
			<cfif isDefined("arguments.acc_code1_1") and len(evaluate("arguments.acc_code1_1"))>
				max(t1.MUHASEBE) > 0
			</cfif>
			<cfif len(arguments.expense_item_id)>
				max(t1.BUTCE) > 0
			</cfif>
			</cfif>
		 ),
             CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY ACTION_ID ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
				 <cfif not (isdefined('arguments.is_excel') and arguments.is_excel eq 1)>
                WHERE
                    RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
					</cfif>
	</cfquery>
    <cfreturn get_records>
    </cffunction>
</cfcomponent>