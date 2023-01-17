<cfquery name="get_all_quotas" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		SUM(ISNULL(ROW_TOTAL,0)) ROW_TOTAL,
		SUM(ISNULL(ROW_PROFIT,0)) ROW_PROFIT,
		SUM(ISNULL(NET_TOTAL,0)) NET_TOTAL,
		SUM(ISNULL(NET_KAR,0)) NET_KAR,
		<cfif isdefined("attributes.is_doviz2")>
			SUM(ROW_TOTAL2) ROW_TOTAL2,
			SUM(NET_TOTAL2) NET_TOTAL2,
		</cfif>
		<cfif attributes.report_type eq 1>
			EMPLOYEE_ID,
		<cfelseif attributes.report_type eq 2>
			ZONE_ID,
		<cfelseif attributes.report_type eq 3>
			BRANCH_ID,
		<cfelseif attributes.report_type eq 4>
			TEAM_ID,
		<cfelseif attributes.report_type eq 5>
			IMS_CODE_ID,	
		<cfelseif attributes.report_type eq 6>
			COMPANY_ID,
		<cfelseif attributes.report_type eq 7>
			PRODUCTCAT_ID,
		<cfelseif attributes.report_type eq 8>
			BRAND_ID,
		<cfelseif attributes.report_type eq 9>
			COMPANYCAT_ID,
		</cfif>
		MONTH_VALUE
	FROM
	(
		SELECT 
			SQR.ROW_TOTAL,
			SQR.ROW_PROFIT,
			0 AS NET_TOTAL,
			0 AS NET_KAR,
			<cfif isdefined("attributes.is_doviz2")>
				SQR.ROW_TOTAL2,
				0 AS NET_TOTAL2,
			</cfif>
			<cfif attributes.report_type eq 1>
				SQR.EMPLOYEE_ID EMPLOYEE_ID,
			<cfelseif attributes.report_type eq 2>
				SQR.SUB_ZONE_ID ZONE_ID,
			<cfelseif attributes.report_type eq 3>
				SQR.SUB_BRANCH_ID BRANCH_ID,
			<cfelseif attributes.report_type eq 4>
				SQR.TEAM_ID TEAM_ID,
			<cfelseif attributes.report_type eq 5>
				SQR.IMS_ID IMS_CODE_ID,
			<cfelseif attributes.report_type eq 6>
				SQR.CUSTOMER_COMP_ID COMPANY_ID,
			<cfelseif attributes.report_type eq 7>
				SQR.PRODUCTCAT_ID PRODUCTCAT_ID,
			<cfelseif attributes.report_type eq 8>
				SQR.BRAND_ID BRAND_ID,
			<cfelseif attributes.report_type eq 9>
				SQR.COMPANYCAT_ID COMPANYCAT_ID,
			</cfif>
			SQR.QUOTE_MONTH AS MONTH_VALUE
		FROM
			SALES_QUOTES_GROUP SQ,
			SALES_QUOTES_GROUP_ROWS SQR
		WHERE
			SQ.SALES_QUOTE_ID = SQR.SALES_QUOTE_ID
			AND SQ.IS_PLAN = 1
			<cfif attributes.report_type eq 1>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.EMPLOYEE_ID = #attributes.process_id#
				<cfelse>
					AND SQR.EMPLOYEE_ID IS NOT NULL
				</cfif>
			<cfelseif attributes.report_type eq 2>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.SUB_ZONE_ID = #attributes.process_id#
				<cfelse>
					AND SQR.SUB_ZONE_ID IS NOT NULL
				</cfif>
			<cfelseif attributes.report_type eq 3>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.SUB_BRANCH_ID = #attributes.process_id#
				<cfelse>
					AND SQR.SUB_BRANCH_ID IS NOT NULL
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.TEAM_ID = #attributes.process_id#
				<cfelse>
					AND SQR.TEAM_ID IS NOT NULL
				</cfif>
			<cfelseif attributes.report_type eq 5>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.IMS_ID = #attributes.process_id#
				<cfelse>
					AND SQR.IMS_ID IS NOT NULL
				</cfif>
			<cfelseif attributes.report_type eq 6>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.CUSTOMER_COMP_ID = #attributes.process_id#
				<cfelse>
					AND SQR.CUSTOMER_COMP_ID IS NOT NULL
				</cfif>
			<cfelseif attributes.report_type eq 7>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.PRODUCTCAT_ID = #attributes.process_id#
				<cfelse>
					AND SQR.PRODUCTCAT_ID IS NOT NULL
				</cfif>
			<cfelseif attributes.report_type eq 8>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.BRAND_ID = #attributes.process_id#
				<cfelse>
					AND SQR.BRAND_ID IS NOT NULL
				</cfif>
			<cfelseif attributes.report_type eq 9>
				<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
					AND SQR.COMPANYCAT_ID = #attributes.process_id#
				<cfelse>
					AND SQR.COMPANYCAT_ID IS NOT NULL
				</cfif>
			</cfif>
			AND SQR.QUOTE_MONTH IN (#month_list#)
			AND SQ.QUOTE_YEAR = #attributes.plan_year#
	UNION ALL
		SELECT
			0 AS ROW_TOTAL,
			0 AS ROW_PROFIT,
			<cfif attributes.report_action_type eq 1>
				CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN -1*((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) ELSE ((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) END AS NET_TOTAL,
			<cfelseif attributes.report_action_type eq 2>
				ORR.NETTOTAL NET_TOTAL,
			</cfif>
			<cfif attributes.report_action_type eq 1>
				CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN 
					-1*ISNULL((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - 
						ISNULL((
								SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM
								)+ISNULL(PROM_COST,0)
							FROM 
								#dsn3_alias#.PRODUCT_COST PRODUCT_COST
							WHERE 
								PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
								PRODUCT_COST.START_DATE <= I.INVOICE_DATE
							ORDER BY
								PRODUCT_COST.START_DATE DESC,
								PRODUCT_COST.RECORD_DATE DESC,
								PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							),0)
					,0) 
				ELSE 
					ISNULL((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - 
						ISNULL((
								SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM
								)+ISNULL(PROM_COST,0)
							FROM 
								#dsn3_alias#.PRODUCT_COST PRODUCT_COST
							WHERE 
								PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
								PRODUCT_COST.START_DATE <= I.INVOICE_DATE
							ORDER BY
								PRODUCT_COST.START_DATE DESC,
								PRODUCT_COST.RECORD_DATE DESC,
								PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							),0)
					,0)
				END AS NET_KAR,
			<cfelseif attributes.report_action_type eq 2>
				ISNULL((
						SELECT TOP 1 ORR.QUANTITY*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM
						)+PROM_COST
					FROM 
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=ORR.PRODUCT_ID AND
						PRODUCT_COST.START_DATE <= O.ORDER_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0)  AS NET_KAR,
			</cfif>
			<cfif isdefined("attributes.is_doviz2")>
				0 AS ROW_TOTAL2,
				<cfif attributes.report_action_type eq 1>
					CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN -1*(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)/(INV_M.RATE2/INV_M.RATE1)) ELSE (((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)/(INV_M.RATE2/INV_M.RATE1)) END AS NET_TOTAL2,
				<cfelseif attributes.report_action_type eq 2>
					ORR.NETTOTAL/(OM.RATE2/OM.RATE1) AS NET_TOTAL2,
				</cfif>
			</cfif>
			<cfif attributes.report_action_type eq 1>
				<cfif attributes.report_type eq 1>
					I.SALE_EMP EMPLOYEE_ID,
				<cfelseif attributes.report_type eq 2>
					I.ZONE_ID ZONE_ID,
				<cfelseif attributes.report_type eq 3>
					(SELECT B.BRANCH_ID FROM DEPARTMENT D,BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND D.DEPARTMENT_ID = I.DEPARTMENT_ID) AS BRANCH_ID,
				<cfelseif attributes.report_type eq 4>
					SZT.TEAM_ID TEAM_ID,
				<cfelseif attributes.report_type eq 5>
					I.IMS_CODE_ID IMS_CODE_ID,
				<cfelseif attributes.report_type eq 6>
					I.COMPANY_ID COMPANY_ID,
				<cfelseif attributes.report_type eq 7>
					P.PRODUCT_CATID PRODUCTCAT_ID,
				<cfelseif attributes.report_type eq 8>
					P.BRAND_ID BRAND_ID,
				<cfelseif attributes.report_type eq 9>
					C.COMPANYCAT_ID COMPANYCAT_ID,	
				</cfif>
				MONTH(I.INVOICE_DATE) AS MONTH_VALUE
			<cfelseif attributes.report_action_type eq 2>
				<cfif attributes.report_type eq 1>
					O.ORDER_EMPLOYEE_ID EMPLOYEE_ID,
				<cfelseif attributes.report_type eq 2>
					O.ZONE_ID ZONE_ID,
				<cfelseif attributes.report_type eq 3>
					(SELECT B.BRANCH_ID FROM DEPARTMENT D,BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND D.DEPARTMENT_ID = O.DELIVER_DEPT_ID) AS BRANCH_ID,
				<cfelseif attributes.report_type eq 4>
					SZT.TEAM_ID TEAM_ID,
				<cfelseif attributes.report_type eq 5>
					O.IMS_CODE_ID IMS_CODE_ID,
				<cfelseif attributes.report_type eq 6>
					O.COMPANY_ID COMPANY_ID,
				<cfelseif attributes.report_type eq 7>
					P.PRODUCT_CATID PRODUCTCAT_ID,
				<cfelseif attributes.report_type eq 8>
					P.BRAND_ID BRAND_ID,
				<cfelseif attributes.report_type eq 9>
					C.COMPANYCAT_ID COMPANYCAT_ID,	
				</cfif>
				MONTH(O.ORDER_DATE) AS MONTH_VALUE
			</cfif>
		FROM
			<cfif attributes.report_action_type eq 1>
				#new_dsn2#.INVOICE I,
				#new_dsn2#.INVOICE_ROW IR
				<cfif isdefined("attributes.is_doviz2")>
					,#new_dsn2#.INVOICE_MONEY INV_M
				</cfif>
			<cfelseif attributes.report_action_type eq 2>
				#dsn3_alias#.ORDERS O,
				#dsn3_alias#.ORDER_ROW ORR
				<cfif isdefined("attributes.is_doviz2")>
					,#dsn3_alias#.ORDER_MONEY OM
				</cfif>
			</cfif>
			<cfif attributes.report_type eq 4>
				,SALES_ZONES_TEAM SZT
				,SALES_ZONES_TEAM_ROLES SZTR
				,EMPLOYEE_POSITIONS EP
			<cfelseif listfind('7,8',attributes.report_type)>
				<cfif attributes.report_action_type eq 1>
					,#dsn3_alias#.PRODUCT P
				<cfelseif attributes.report_action_type eq 2>
					,#dsn3_alias#.PRODUCT P
				</cfif>
			<cfelseif attributes.report_type eq 9>
				,#dsn_alias#.COMPANY C
			</cfif>
		WHERE
			<cfif attributes.report_action_type eq 1>
				IR.INVOICE_ID = I.INVOICE_ID
				AND I.INVOICE_CAT IN (50,52,53,531,58,561,54,55,51,63,48,49)
				AND I.IS_IPTAL = 0
				AND I.NETTOTAL > 0 
				<cfif len(attributes.process_type)>
					AND I.PROCESS_CAT IN (#attributes.process_type#)
				</cfif>
				<cfif len(attributes.price_catid)>
					AND IR.PRICE_CAT IN (#attributes.price_catid#)
				</cfif>
				<cfif isdefined("attributes.is_doviz2")>
					AND I.INVOICE_ID = INV_M.ACTION_ID 
					AND INV_M.MONEY_TYPE = '#session.ep.money2#' 
				</cfif>
				<cfif attributes.report_type eq 1>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND I.SALE_EMP = #attributes.process_id#
					<cfelse>
						AND I.SALE_EMP IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 2>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND I.ZONE_ID = #attributes.process_id#
					<cfelse>
						AND I.ZONE_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 3>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND (SELECT B.BRANCH_ID FROM DEPARTMENT D,BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND D.DEPARTMENT_ID = I.DEPARTMENT_ID) = #attributes.process_id#
					<cfelse>
						AND I.DEPARTMENT_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 4>
					AND SZT.TEAM_ID = SZTR.TEAM_ID 
					AND SZTR.POSITION_CODE = EP.POSITION_CODE
					AND EP.EMPLOYEE_ID = I.SALE_EMP
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND SZT.TEAM_ID = #attributes.process_id#
					<cfelse>
						AND SZT.TEAM_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 5>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND I.IMS_CODE_ID = #attributes.process_id#
					<cfelse>
						AND I.IMS_CODE_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 6>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND I.COMPANY_ID = #attributes.process_id#
					<cfelse>
						AND I.COMPANY_ID IS NOT NULL
					</cfif>
					<cfif isdefined("attributes.company_cat") and len(attributes.company_cat)>
						AND I.COMPANY_ID IN(SELECT CC_.COMPANY_ID FROM COMPANY CC_ WHERE CC_.COMPANYCAT_ID = #attributes.company_cat#)
					</cfif>
				<cfelseif attributes.report_type eq 7>
					AND P.PRODUCT_ID = IR.PRODUCT_ID
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND P.PRODUCT_CATID = #attributes.process_id#
					<cfelse>
						AND P.PRODUCT_CATID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 8>
					AND P.PRODUCT_ID = IR.PRODUCT_ID
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND P.BRAND_ID = #attributes.process_id#
					<cfelse>
						AND P.BRAND_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 9>
					AND C.COMPANY_ID = I.COMPANY_ID
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND C.COMPANYCAT_ID = #attributes.process_id#
					<cfelse>
						AND C.COMPANYCAT_ID IS NOT NULL
					</cfif>
				</cfif>
				AND MONTH(I.INVOICE_DATE) IN (#month_list#)
				AND YEAR(I.INVOICE_DATE) = #attributes.plan_year#
			<cfelseif attributes.report_action_type eq 2>
				(
					(	
						O.PURCHASE_SALES = 1 AND
						O.ORDER_ZONE = 0
					 )  
					OR
					(	
						O.PURCHASE_SALES = 0 AND
						O.ORDER_ZONE = 1
					)
				)
				AND O.NETTOTAL > 0 
				AND ORR.ORDER_ID = O.ORDER_ID
				AND O.ORDER_STATUS = 1
				<cfif isdefined("attributes.is_doviz2")>
					AND O.ORDER_ID = OM.ACTION_ID 
					AND OM.MONEY_TYPE = '#session.ep.money2#' 
				</cfif>
				<cfif attributes.report_type eq 1>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND O.ORDER_EMPLOYEE_ID = #attributes.process_id#
					<cfelse>
						AND O.ORDER_EMPLOYEE_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 2>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND O.ZONE_ID = #attributes.process_id#
					<cfelse>
						AND O.ZONE_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 3>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND (SELECT B.BRANCH_ID FROM DEPARTMENT D,BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND D.DEPARTMENT_ID = O.DELIVER_DEPT_ID) = #attributes.process_id#
					<cfelse>
						AND O.DELIVER_DEPT_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 4>	
					AND SZT.TEAM_ID = SZTR.TEAM_ID 
					AND SZTR.POSITION_CODE = EP.POSITION_CODE
					AND EP.EMPLOYEE_ID = O.ORDER_EMPLOYEE_ID
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND SZT.TEAM_ID = #attributes.process_id#
					<cfelse>
						AND SZT.TEAM_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 5>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND O.IMS_CODE_ID = #attributes.process_id#
					<cfelse>
						AND O.IMS_CODE_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 6>
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND O.COMPANY_ID = #attributes.process_id#
					<cfelse>
						AND O.COMPANY_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 7>
					AND P.PRODUCT_ID = ORR.PRODUCT_ID
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND P.PRODUCT_CATID = #attributes.process_id#
					<cfelse>
						AND P.PRODUCT_CATID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 8>
					AND P.PRODUCT_ID = ORR.PRODUCT_ID
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND P.BRAND_ID = #attributes.process_id#
					<cfelse>
						AND P.BRAND_ID IS NOT NULL
					</cfif>
				<cfelseif attributes.report_type eq 9>
					AND C.COMPANY_ID = O.COMPANY_ID
					<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
						AND C.COMPANYCAT_ID = #attributes.process_id#
					<cfelse>
						AND C.COMPANYCAT_ID IS NOT NULL
					</cfif>
				</cfif>
				AND MONTH(O.ORDER_DATE) IN (#month_list#)
				AND YEAR(O.ORDER_DATE) = #attributes.plan_year#
			</cfif>
		)T1
	GROUP BY
		<cfif attributes.report_type eq 1>
			EMPLOYEE_ID,
		<cfelseif attributes.report_type eq 2>
			ZONE_ID,
		<cfelseif attributes.report_type eq 3>
			BRANCH_ID,
		<cfelseif attributes.report_type eq 4>
			TEAM_ID,
		<cfelseif attributes.report_type eq 5>
			IMS_CODE_ID,
		<cfelseif attributes.report_type eq 6>
			COMPANY_ID,
		<cfelseif attributes.report_type eq 7>
			PRODUCTCAT_ID,
		<cfelseif attributes.report_type eq 8>
			BRAND_ID,
		<cfelseif attributes.report_type eq 9>
			COMPANYCAT_ID,
		</cfif>
		MONTH_VALUE
</cfquery>

