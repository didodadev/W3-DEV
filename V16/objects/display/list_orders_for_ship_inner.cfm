<!--- rezerve --->
<cfquery name="get_reserved_info" datasource="#dsn3#">
	SELECT
		abs(SUM((RESERVE_STOCK_IN-STOCK_IN)-(RESERVE_STOCK_OUT-STOCK_OUT))) AS RESERVED_AMOUNT,
		STOCK_ID,
		PRODUCT_ID,
		ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID
	FROM
		GET_ORDER_ROW_RESERVED
	WHERE
		ORDER_ID = #attributes.order_id_#
	GROUP BY
		PRODUCT_ID,
		STOCK_ID,
		ISNULL(SPECT_VAR_ID,0)
	ORDER BY STOCK_ID
</cfquery>
<cfquery name="get_order_inv_periods" datasource="#dsn3#">
	SELECT DISTINCT PERIOD_ID FROM ORDERS_INVOICE WHERE ORDER_ID = #attributes.order_id_#
</cfquery>
<cfif get_order_inv_periods.recordcount>
	<cfset orders_ship_period_list = valuelist(get_order_inv_periods.PERIOD_ID)>
	<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
		<cfquery name="get_processed_amount" datasource="#dsn2#">
			SELECT
				SUM(IR.AMOUNT) AS SHIP_AMOUNT,
				IR.STOCK_ID,
				ISNULL(IR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
				ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
			FROM
				INVOICE I,
				INVOICE_ROW IR
			WHERE
				I.INVOICE_ID=IR.INVOICE_ID
				AND IR.ORDER_ID=#attributes.order_id_#
				AND ((IR.WRK_ROW_RELATION_ID = '#get_order_list.wrk_row_id#') OR IR.WRK_ROW_RELATION_ID IS NULL)
			GROUP BY
				IR.STOCK_ID,
				IR.SPECT_VAR_ID,
				ISNULL(IR.WRK_ROW_RELATION_ID,0)
		</cfquery>
	<cfelse>
		<cfquery name="get_period_dsns" datasource="#dsn#">
			SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
		</cfquery>
		<cfquery name="get_processed_amount" datasource="#dsn2#">
			SELECT
				SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
				A1.STOCK_ID,
				A1.SPECT_VAR_ID,
				A1.WRK_ROW_RELATION_ID
			FROM
			(
			<cfloop query="get_period_dsns">
				SELECT
					SUM(IR.AMOUNT) AS SHIP_AMOUNT,
					IR.STOCK_ID,
					ISNULL(IR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
					ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
				FROM
					#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE I,
					#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
				WHERE
					I.INVOICE_ID=IR.INVOICE_ID
					AND IR.ORDER_ID=#attributes.order_id_#
					AND ((IR.WRK_ROW_RELATION_ID = '#get_order_list.wrk_row_id#') OR IR.WRK_ROW_RELATION_ID IS NULL)
				GROUP BY
					IR.STOCK_ID,
					IR.SPECT_VAR_ID,
					ISNULL(IR.WRK_ROW_RELATION_ID,0)
				<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
			</cfloop> ) AS A1
				GROUP BY
					A1.STOCK_ID,
					A1.SPECT_VAR_ID,
					A1.WRK_ROW_RELATION_ID
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="get_order_ship_periods" datasource="#dsn3#">
		SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID =#attributes.order_id_#
	</cfquery>
	<cfif get_order_ship_periods.recordcount>
		<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
		<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
			<cfquery name="get_processed_amount" datasource="#dsn2#">
				SELECT
					SUM(SR.AMOUNT) AS SHIP_AMOUNT,
					SR.STOCK_ID,
					ISNULL(SR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
					ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID 
				FROM
					SHIP S,
					SHIP_ROW SR
				WHERE
					S.SHIP_ID=SR.SHIP_ID
					AND SR.ROW_ORDER_ID=#attributes.order_id_#
					AND ((SR.WRK_ROW_RELATION_ID = '#get_order_list.wrk_row_id#') OR SR.WRK_ROW_RELATION_ID IS NULL)
				GROUP BY
					SR.STOCK_ID,
					SR.SPECT_VAR_ID,
					ISNULL(SR.WRK_ROW_RELATION_ID,0)
			</cfquery>
		<cfelse>
			<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
				<cfquery name="get_period_dsns" datasource="#dsn2#">
					SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
				</cfquery>
				<cfquery name="get_processed_amount" datasource="#dsn2#">
					SELECT
						SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
						A1.STOCK_ID,
						A1.SPECT_VAR_ID,
						A1.WRK_ROW_RELATION_ID
					FROM
					(
					<cfloop query="get_period_dsns">
						SELECT
							SUM(SR.AMOUNT) AS SHIP_AMOUNT,
							SR.STOCK_ID,
							ISNULL(SR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
						FROM
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
						WHERE
							S.SHIP_ID=SR.SHIP_ID
							AND SR.ROW_ORDER_ID=#attributes.order_id_#
							AND ((SR.WRK_ROW_RELATION_ID = '#get_order_list.wrk_row_id#') OR SR.WRK_ROW_RELATION_ID IS NULL)
						GROUP BY
							SR.STOCK_ID,
							SR.SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0)
						<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
					</cfloop> ) AS A1
						GROUP BY
							A1.STOCK_ID,
							A1.SPECT_VAR_ID,
							A1.WRK_ROW_RELATION_ID
				</cfquery>
			</cfif>
	<cfelse>
		<cfset get_order_ship_periods.recordcount =0>
	</cfif>
</cfif>
<cfscript>
	for(inv_k=1; inv_k lte get_reserved_info.recordcount; inv_k=inv_k+1)
		{
		'reserved_amount_#get_reserved_info.STOCK_ID[inv_k]#_#get_reserved_info.SPECT_VAR_ID[inv_k]#' = get_reserved_info.RESERVED_AMOUNT[inv_k];
		}
	if(isdefined("get_processed_amount"))
		for(xxx=1; xxx lte get_processed_amount.recordcount; xxx=xxx+1)
		{
			if(len(get_processed_amount.WRK_ROW_RELATION_ID[xxx]) and get_processed_amount.WRK_ROW_RELATION_ID[xxx] neq 0)
				if(isdefined('row_processed_amount_#get_processed_amount.WRK_ROW_RELATION_ID[xxx]#'))
					'row_processed_amount_#get_processed_amount.WRK_ROW_RELATION_ID[xxx]#' = evaluate('row_processed_amount_#get_processed_amount.WRK_ROW_RELATION_ID[xxx]#')+get_processed_amount.SHIP_AMOUNT[xxx];
				else
					'row_processed_amount_#get_processed_amount.WRK_ROW_RELATION_ID[xxx]#' = get_processed_amount.SHIP_AMOUNT[xxx];
			else
				'processed_amount_#get_processed_amount.STOCK_ID[xxx]#_#get_processed_amount.SPECT_VAR_ID[xxx]#' = get_processed_amount.SHIP_AMOUNT[xxx];
		}
</cfscript>

<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=(QUANTITY-CANCEL_AMOUNT)><!--- sipariş satır miktarı-iptal edilen miktar --->
<cfif RESERVE_TYPE neq -3>
	<cfset 'add_reserve_amount_#STOCK_ID#_#SPECT_VAR_ID#'=QUANTITY>
<cfelse>
	<cfset 'add_reserve_amount_#STOCK_ID#_#SPECT_VAR_ID#'=0>
</cfif>
<cfif isdefined('row_processed_amount_#WRK_ROW_ID#') and len(evaluate('row_processed_amount_#WRK_ROW_ID#'))>
	<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')-evaluate('row_processed_amount_#WRK_ROW_ID#')>
	<cfset row_dsp_amount_=evaluate('row_processed_amount_#WRK_ROW_ID#')>
<cfelse>
	<cfset row_dsp_amount_=0>
</cfif>
<cfif isdefined('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#') and len(evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#')) and evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0>
	<cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0 and evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#') gte evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
		<cfset row_dsp_amount_=row_dsp_amount_+evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
		<cfset 'processed_amount_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#')-evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
		<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=0>
	<cfelseif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0 and evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#') lt evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
		<cfset row_dsp_amount_=row_dsp_amount_+evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
		<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')-evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
		<cfset 'processed_amount_#STOCK_ID#_#SPECT_VAR_ID#'=0>
	</cfif>
</cfif>
