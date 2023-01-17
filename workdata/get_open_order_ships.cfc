<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfif isdefined("session.ep")>
		<cfset session_base = evaluate('session.ep')>
	<cfelseif isdefined("session.pp")>
		<cfset session_base = evaluate('session.pp')>
	<cfelseif isdefined("session.ww")>
		<cfset session_base = evaluate('session.ww')>
	</cfif>
	<cfif isdefined("session.ep.company_id")><cfset session_base.our_company_id = session.ep.company_id></cfif>
    <cffunction name="getCompenentFunction">
		<cfargument name="our_company_id" required="no" type="string" default="#session_base.our_company_id#">
		<cfargument name="is_purchase" required="no" type="string" default="0">
		<cfquery name="get_open_order_ships" datasource="#dsn#">
				SELECT 
					ISNULL(SUM(ORDER_TOTAL),0) ORDER_TOTAL,
					ISNULL(SUM(SHIP_TOTAL),0) SHIP_TOTAL  
				<cfif len(session_base.money2)>
					,ISNULL(SUM(ORDER_TOTAL2),0) ORDER_TOTAL2
					,ISNULL(SUM(SHIP_TOTAL2),0) SHIP_TOTAL2
				</cfif>
				FROM 
				(
					<cfset count = 0>
					<cfloop list="#arguments.our_company_id#" index="kk">
						<cfset count = count + 1>
						<cfquery name="CHECK_COMPANY_RISK_TYPE" datasource="#DSN#">
							SELECT 
								ISNULL(IS_DETAILED_RISK_INFO,0) IS_DETAILED_RISK_INFO 
							FROM 
								OUR_COMPANY_INFO 
							WHERE 
								COMP_ID = #kk#
						</cfquery>
						<cfset dsn_alias = "#dsn#">
						<cfset dsn3 = "#dsn#_#kk#">
						<cfset dsn3_alias = "#dsn#_#kk#">
						<cfset dsn2_alias = "#dsn#_#session_base.period_year#_#kk#">
						<cfif check_company_risk_type.IS_DETAILED_RISK_INFO eq 1><!--- Detaylı risk takibi yapılıyor ise --->
							SELECT 
								((ORD_ROW.QUANTITY - ISNULL(ORD_ROW.CANCEL_AMOUNT,0) - ISNULL(ORD_ROW.DELIVER_AMOUNT,0)) * (((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT),1)) * (ORD_ROW.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1))*( ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100))))/ORD_ROW.QUANTITY)) ORDER_TOTAL,
								<cfif len(session_base.money2)>
									((ORD_ROW.QUANTITY - ISNULL(ORD_ROW.CANCEL_AMOUNT,0) - ISNULL(ORD_ROW.DELIVER_AMOUNT,0)) * (((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT),1)) * (ORD_ROW.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1))*( ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100))))/RATE2/ORD_ROW.QUANTITY)) ORDER_TOTAL2
								<cfelse>
									0 ORDER_TOTAL2
								</cfif>,
								0 SHIP_TOTAL,
								0 SHIP_TOTAL2
							FROM 
								#dsn3_alias#.ORDERS O,
								#dsn3_alias#.ORDER_ROW ORD_ROW
								<cfif len(session_base.money2)>
									,#dsn3_alias#.ORDER_MONEY
								</cfif>
							WHERE 
								ISNULL(O.IS_MEMBER_RISK,1) = 1 AND 
								O.ORDER_STATUS = 1 AND 
								O.ORDER_ID = ORD_ROW.ORDER_ID AND
								((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT) > 0 AND 
								ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)
							<cfif arguments.is_purchase eq 1>
								AND O.PURCHASE_SALES=0 AND ORDER_ZONE = 0
							<cfelse>
								AND ((O.PURCHASE_SALES=1 
								AND O.ORDER_ZONE=0) OR (O.PURCHASE_SALES=0 AND O.ORDER_ZONE=1)) 
							</cfif>
							AND IS_PAID<>1 
							<cfif isdefined("arguments.company_id") and len(arguments.company_id)>
								AND O.COMPANY_ID = #arguments.company_id#
							<cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
								AND O.CONSUMER_ID = #arguments.consumer_id#
							<cfelseif isdefined("arguments.employee_id") and len(arguments.employee_id)>
								AND O.EMPLOYEE_ID = #arguments.employee_id#
							</cfif>
							<cfif len(session_base.money2)>
								AND O.ORDER_ID = ORDER_MONEY.ACTION_ID
								AND ORDER_MONEY.MONEY_TYPE = '#session_base.money2#'
							</cfif>
							UNION ALL
							SELECT
								0 ORDER_TOTAL,
								0 ORDER_TOTAL2,
								((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW IR WHERE IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/#dsn_alias#.IS_ZERO(SR.AMOUNT,1)) SHIP_TOTAL,
							<cfif len(session_base.money2)>
								((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW IR WHERE IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/#dsn_alias#.IS_ZERO(SR.AMOUNT,1)/RATE2) SHIP_TOTAL2
							<cfelse>
								0 SHIP_TOTAL2
							</cfif>
							FROM
								#dsn2_alias#.SHIP S,
								#dsn2_alias#.SHIP_ROW SR
							<cfif len(session_base.money2)>
								,#dsn2_alias#.SHIP_MONEY SM
							</cfif>
							WHERE
								S.SHIP_ID = SR.SHIP_ID AND 
								ISNULL(S.SHIP_STATUS,0) = 1 AND 
								S.IS_WITH_SHIP = 0 AND 
								ISNULL(S.IS_SHIP_IPTAL,0) = 0 AND 
								(SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW IR WHERE IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0
							<cfif arguments.is_purchase eq 1>
								AND S.PURCHASE_SALES = 0
							<cfelse>
								AND S.PURCHASE_SALES = 1
							</cfif>
							<cfif isdefined("arguments.company_id") and len(arguments.company_id)>
								AND S.COMPANY_ID = #arguments.company_id#
							<cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
								AND S.CONSUMER_ID = #arguments.consumer_id#
							<cfelseif isdefined("arguments.employee_id") and len(arguments.employee_id)>
								AND S.EMPLOYEE_ID = #arguments.employee_id#
							</cfif>
							<cfif len(session_base.money2)>
								AND S.SHIP_ID = SM.ACTION_ID
								AND SM.MONEY_TYPE = '#session_base.money2#'
							</cfif>
						<cfelse>
						<!---
							SELECT 
							CASE WHEN ORDERS.NETTOTAL = 0 THEN 0 ELSE (1- (ORDERS.SA_DISCOUNT)/#DSN#.IS_ZERO(((ORDERS.NETTOTAL)-ORDERS.TAXTOTAL+ORDERS.SA_DISCOUNT),1)) * (ORD_R.NETTOTAL) + (((((1- (ORDERS.SA_DISCOUNT)/#DSN#.IS_ZERO((ORDERS.NETTOTAL-ORDERS.TAXTOTAL+ORDERS.SA_DISCOUNT),1))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) END AS ORDER_TOTAL
							<cfif len(session_base.money2)>
								,CASE WHEN ORDERS.NETTOTAL = 0 THEN 0 ELSE (1- (ORDERS.SA_DISCOUNT)/#DSN#.IS_ZERO(((ORDERS.NETTOTAL)-ORDERS.TAXTOTAL+ORDERS.SA_DISCOUNT),1)) * (ORD_R.NETTOTAL) + (((((1- (ORDERS.SA_DISCOUNT)/#DSN#.IS_ZERO((ORDERS.NETTOTAL-ORDERS.TAXTOTAL+ORDERS.SA_DISCOUNT),1))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) END / RATE2     ORDER_TOTAL2
							</cfif>,
								0 SHIP_TOTAL,
								0 SHIP_TOTAL2
							FROM 
								#dsn3_alias#.ORDERS ORDERS JOIN #dsn3_alias#.ORDER_ROW ORD_R ON ORDERS.ORDER_ID =ORD_R.ORDER_ID
							<cfif len(session_base.money2)>
								,#dsn3_alias#.ORDER_MONEY ORDER_MONEY
							</cfif>
							WHERE 
								ISNULL(IS_MEMBER_RISK,1) = 1 AND 
								(ORD_R.WRK_ROW_ID IN(SELECT GI.WRK_ROW_RELATION_ID FROM #dsn3_alias#.GET_ALL_INVOICE_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID) OR
								ORD_R.WRK_ROW_ID IN(SELECT GS.WRK_ROW_RELATION_ID FROM #dsn3_alias#.GET_ALL_INVOICE_ROW GI,#dsn3_alias#.GET_ALL_SHIP_ROW GS WHERE GS.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID AND GS.WRK_ROW_ID = GI.WRK_ROW_RELATION_ID)) AND
								ORD_R.WRK_ROW_ID NOT IN(SELECT GI.WRK_ROW_RELATION_ID FROM #dsn3_alias#.GET_ALL_SHIP_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID) AND 
								
								ORDER_STATUS = 1 AND 
								IS_PAID <> 1 

							---->

							SELECT 
								ISNULL(SUM(NETTOTAL),0) ORDER_TOTAL
							<cfif len(session_base.money2)>
								,SUM(NETTOTAL/RATE2) ORDER_TOTAL2
							</cfif>,
								0 SHIP_TOTAL,
								0 SHIP_TOTAL2
							FROM 
								#dsn3_alias#.ORDERS ORDERS
							<cfif len(session_base.money2)>
								,#dsn3_alias#.ORDER_MONEY ORDER_MONEY
							</cfif>
							WHERE 
								ISNULL(IS_MEMBER_RISK,1) = 1 AND 
								ORDER_ID NOT IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_INVOICE) AND 
								ORDER_ID NOT IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP) AND 
								ORDER_STATUS = 1 AND 
								IS_PAID <> 1

							<cfif arguments.is_purchase eq 1>
								AND ORDERS.PURCHASE_SALES=0 AND ORDER_ZONE = 0
							<cfelse>
								AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) 
							</cfif>
							<cfif isdefined("arguments.company_id") and len(arguments.company_id)>
								AND ORDERS.COMPANY_ID = #arguments.company_id#
							<cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
								AND ORDERS.CONSUMER_ID = #arguments.consumer_id#
							<cfelseif isdefined("arguments.employee_id") and len(arguments.employee_id)>
								AND ORDERS.EMPLOYEE_ID = #arguments.employee_id#
							</cfif>
							<cfif len(session_base.money2)>
								AND ORDERS.ORDER_ID = ORDER_MONEY.ACTION_ID
								AND ORDER_MONEY.MONEY_TYPE = '#session_base.money2#'
							</cfif>
							UNION ALL
							SELECT 
								0 ORDER_TOTAL,
								0 ORDER_TOTAL2,
								SUM(SR.GROSSTOTAL) SHIP_TOTAL
							<cfif len(session_base.money2)>
								,SUM(SR.GROSSTOTAL/RATE2) SHIP_TOTAL2
							</cfif>
							FROM 
								#dsn2_alias#.SHIP S,
								#dsn2_alias#.SHIP_ROW SR 
							<cfif len(session_base.money2)>
								,#dsn2_alias#.SHIP_MONEY AS SHIP_MONEY
							</cfif>
							WHERE 
								S.SHIP_ID = SR.SHIP_ID AND
								S.IS_WITH_SHIP = 0 AND 
								ISNULL(S.IS_SHIP_IPTAL,0) = 0 AND 
								S.SHIP_ID NOT IN (SELECT SHIP_ID FROM #dsn2_alias#.INVOICE_SHIPS)
							<cfif arguments.is_purchase eq 1>
								AND S.PURCHASE_SALES = 0
							<cfelse>
								AND S.PURCHASE_SALES = 1
							</cfif>
							<cfif isdefined("arguments.company_id") and len(arguments.company_id)>
								AND S.COMPANY_ID = #arguments.company_id#
							<cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
								AND S.CONSUMER_ID = #arguments.consumer_id#
							<cfelseif isdefined("arguments.employee_id") and len(arguments.employee_id)>
								AND S.EMPLOYEE_ID = #arguments.employee_id#
							</cfif>
							<cfif len(session_base.money2)>
								AND S.SHIP_ID = SHIP_MONEY.ACTION_ID
								AND SHIP_MONEY.MONEY_TYPE = '#session_base.money2#'
							</cfif>
						</cfif>
						<cfif count neq listlen(arguments.our_company_id)>UNION ALL</cfif>
					</cfloop>
				) AS A1
		</cfquery>
		<cfreturn get_open_order_ships>
	</cffunction>
</cfcomponent>
