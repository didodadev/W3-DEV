<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>

	<cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>
    <cfset dsn3_alias = dsn & "_" & session.ep.company_id>
    <cfset dsn_alias = dsn >
    <cfset dsn1_alias = dsn & "_product">
	<cffunction name="get_branch" access="public" returntype="query">
		<cfargument name="ehesap_control" default="0">
        <cfquery name="get_branches" datasource="#dsn#">
			SELECT 
            	BRANCH_ID,
                BRANCH_NAME,
                COMPANY_ID
			FROM 
            	BRANCH 
			WHERE 
				1=1
                <cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
					AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
             ORDER BY 
             	BRANCH_NAME        
        </cfquery>
  		<cfreturn get_branches>
	</cffunction>
	<cffunction name="get_invoice" access="public" returntype="query">
		<cfargument name="startdate" default="">
		<cfargument name="branch_id" default="">
		<cfquery name="get_invoice" datasource="#dsn2#">
			SELECT 
				I.POS_CASH_ID,
				PE.EQUIPMENT,
				(ISNULL(SUM(CA.CASH_ACTION_VALUE),0) + ISNULL(SUM(CCBP.SALES_CREDIT),0))  AS NETTOTAL_,
				ISNULL(SUM(CA.CASH_ACTION_VALUE),0) AS CASH_ACTION_VALUE_,
				ISNULL(SUM(CCBP.SALES_CREDIT),0) AS AMOUNT_,
				ISNULL(SUM(IR.AMOUNT),0) AS MIKTAR,
				COUNT(I.INVOICE_ID) AS SEPET,
				COUNT(IR.INVOICE_ROW_ID) AS SEPET_URUN,
				DATEPART(HOUR, I.RECORD_DATE) AS REC_DATE
			FROM INVOICE I
				LEFT JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
				LEFT JOIN #dsn3_alias#.POS_EQUIPMENT PE ON PE.POS_ID = I.POS_CASH_ID
				LEFT JOIN INVOICE_CASH_POS ICP ON ICP.INVOICE_ID = I.INVOICE_ID
				LEFT JOIN CASH_ACTIONS CA ON CA.ACTION_ID = ICP.CASH_ID
				LEFT JOIN #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCBP ON CCBP.CREDITCARD_PAYMENT_ID = ICP.POS_ACTION_ID
			WHERE I.INVOICE_CAT = 52 
				AND I.POS_CASH_ID IS NOT NULL
				AND I.OTHER_MONEY = 'TL'
				<cfif isDefined('arguments.is_day')and len(arguments.is_day)>
					AND I.INVOICE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
				</cfif>
				<cfif isDefined('arguments.is_week') and len(arguments.is_week)>
					AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
					AND I.INVOICE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('ww',1,arguments.startdate)#">
				</cfif>
				<cfif isDefined('arguments.is_month') and len(arguments.is_month)>
					AND MONTH(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.startdate#">
				</cfif>
				<cfif isDefined('arguments.is_year') and len(arguments.is_year)>
					AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.startdate#">
				</cfif>
				<cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
					AND  I.DEPARTMENT_ID IN(
						SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#" list="yes">)
					)
				</cfif>
			GROUP BY 
				I.POS_CASH_ID,
				PE.EQUIPMENT,
				DATEPART(HOUR, I.RECORD_DATE)
		</cfquery>
		<cfreturn get_invoice>
	</cffunction>
	<cffunction name="get_invoice_date" access="public" returntype="query">
		<cfargument name="startdate" default="">
		<cfargument name="branch_id" default="">
		<cfquery name="get_invoice_date" datasource="#dsn2#">
		WITH t1 AS
            (
			SELECT 
				DATEPART(HOUR, I.RECORD_DATE) AS REC_DATE,
				(ISNULL(SUM(CA.CASH_ACTION_VALUE),0) + ISNULL(SUM(CCBP.SALES_CREDIT),0))  AS NETTOTAL_,
				ISNULL(SUM(CA.CASH_ACTION_VALUE),0) AS CASH_ACTION_VALUE_,
				ISNULL(SUM(CCBP.SALES_CREDIT),0) AS AMOUNT_,
				ISNULL(SUM(IR.AMOUNT),0) AS MIKTAR,
				COUNT(I.INVOICE_ID) AS SEPET,
				COUNT(IR.INVOICE_ROW_ID) AS SEPET_URUN
			FROM INVOICE I
				LEFT JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
				LEFT JOIN #dsn3_alias#.POS_EQUIPMENT PE ON PE.POS_ID = I.POS_CASH_ID
				LEFT JOIN INVOICE_CASH_POS ICP ON ICP.INVOICE_ID = I.INVOICE_ID
				LEFT JOIN CASH_ACTIONS CA ON CA.ACTION_ID = ICP.CASH_ID
				LEFT JOIN #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCBP ON CCBP.CREDITCARD_PAYMENT_ID = ICP.POS_ACTION_ID
			WHERE I.INVOICE_CAT = 52 
				AND I.POS_CASH_ID IS NOT NULL
				AND I.OTHER_MONEY = 'TL'
				<cfif isDefined('arguments.is_day')and len(arguments.is_day)>
					AND I.INVOICE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
				</cfif>
				<cfif isDefined('arguments.is_week') and len(arguments.is_week)>
					AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
					AND I.INVOICE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('ww',1,arguments.startdate)#">
				</cfif>
				<cfif isDefined('arguments.is_month') and len(arguments.is_month)>
					AND MONTH(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.startdate#">
				</cfif>
				<cfif isDefined('arguments.is_year') and len(arguments.is_year)>
					AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.startdate#">
				</cfif>
				<cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
					AND  I.DEPARTMENT_ID IN(
						SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#" list="yes">)
					)
				</cfif>
			GROUP BY 
			  	DATEPART(HOUR, I.RECORD_DATE)
			<cfloop from="1" to="24" index="i">
				<cfif i lte 9>
					UNION ALL
					SELECT 0#i# REC_DATE ,0 NETTOTAL_,0 CASH_ACTION_VALUE_, 0 AMOUNT_,0 MIKTAR,0 SEPET,0 SEPET_URUN
				<cfelse>
					UNION ALL
					SELECT #i# REC_DATE ,0 NETTOTAL_,0 CASH_ACTION_VALUE_, 0 AMOUNT_,0 MIKTAR,0 SEPET,0 SEPET_URUN
				</cfif>
			</cfloop>
			
			)
				SELECT
							REC_DATE,
				ISNULL(SUM(NETTOTAL_),0) AS NETTOTAL_,
                            ISNULL(SUM(CASH_ACTION_VALUE_),0) AS CASH_ACTION_VALUE_,
                            ISNULL(SUM(AMOUNT_),0) AS AMOUNT_,
							ISNULL(SUM(MIKTAR),0) AS MIKTAR,
                            ISNULL(SUM(SEPET),0) AS SEPET,
							ISNULL(SUM(SEPET_URUN),0) AS SEPET_URUN

                        FROM
                            t1
                        GROUP BY
						REC_DATE
		</cfquery>
		<cfreturn get_invoice_date>
	</cffunction>
	<cffunction name="total_amount" returntype="query">
		<cfquery name="total_amount" dbtype="query">
			SELECT
				SUM(NETTOTAL_) AS TOTAL
				,SUM(CASH_ACTION_VALUE_) AS TOTAL_CASH
				,SUM(AMOUNT_) AS TOTAL_CREDI
				,SUM(SEPET) AS TOTAL_SEPET
				,SUM(SEPET_URUN) AS TOTAL_SEPET_URUN 
			FROM get_invoice
		</cfquery>
		 <cfreturn total_amount>
	</cffunction>
	<cffunction name="get_product_cat" access="public" returntype="query">
		<cfargument name="startdate" default="">
		<cfquery name="get_product_cat" datasource="#dsn2#">
        SELECT 
			I.POS_CASH_ID,
			PC.PRODUCT_CAT,
			ISNULL(SUM(IR.NETTOTAL),0) AS NETTOTAL_ROW
		FROM INVOICE I
			LEFT JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID 
			LEFT JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IR.PRODUCT_ID
			LEFT JOIN #dsn1_alias#.PRODUCT_CAT PC ON P.PRODUCT_CATID = PC.PRODUCT_CATID
		WHERE I.INVOICE_CAT = 52 
			AND I.POS_CASH_ID IS NOT NULL
			AND I.OTHER_MONEY = 'TL'
			<cfif isDefined('arguments.is_day')and len(arguments.is_day)>
				AND I.INVOICE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
			</cfif>
			<cfif isDefined('arguments.is_week') and len(arguments.is_week)>
				AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
				AND I.INVOICE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('ww',1,arguments.startdate)#">
			</cfif>
			<cfif isDefined('arguments.is_month') and len(arguments.is_month)>
				AND MONTH(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.startdate#">
			</cfif>
			<cfif isDefined('arguments.is_year') and len(arguments.is_year)>
				AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.startdate#">
			</cfif>
		<cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
            AND  I.DEPARTMENT_ID IN(
				SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#" list="yes">)
			)
        </cfif>
		GROUP BY 
			I.POS_CASH_ID,
			PC.PRODUCT_CAT
		</cfquery>
		<cfreturn get_product_cat>
	</cffunction>
	<cffunction name="total_cat" returntype="query">
		<cfquery name="total_cat" dbtype="query">
			SELECT
				SUM(NETTOTAL_ROW) AS TOTAL_ROW
			FROM get_product_cat
		</cfquery>
		 <cfreturn total_cat>
	</cffunction>
	<cffunction name="get_pos_equipment" access="public" returntype="query">
		<cfargument name="pos_cash_id" default="0">
	<cfquery name="get_pos_equipment" datasource="#DSN3#">
		SELECT EQUIPMENT, POS_ID FROM POS_EQUIPMENT WHERE POS_ID = #arguments.pos_cash_id#
	</cfquery>
	</cffunction>
</cfcomponent>