<!---
	son giren ilk cikar yontemi (ilk giren ilk cikarla ayni): 
	--verilen action_id ve type a gore invoice,ship v.s. den kayitlari ceker 
************TAMAMLANMADI*************
--->
<cfif not isdefined('arguments.action_type') or arguments.action_type eq 1>
	<cfquery name="GET_INV_SHIP_" datasource="#arguments.period_dsn_type#"><!--- faturadan irsaliye oluşmuşsa fatura satırındaki ship_id bos oldugu icin israliyenin nasıl oluştuğunu anlamak için--->
		SELECT IS_WITH_SHIP FROM INVOICE_SHIPS WHERE INVOICE_SHIPS.INVOICE_ID=#arguments.action_id#
	</cfquery>
	<cfif GET_INV_SHIP_.IS_WITH_SHIP eq  0>
		<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
			SELECT
			 <cfif arguments.tax_inc IS 1>
				 (IR.NETTOTAL / IR.AMOUNT * (1 - (I.SA_DISCOUNT / I.GROSSTOTAL)) * (1 + (TAX/100))) / (IM.RATE2/IM.RATE1) PRICE,
			 <cfelse>
				 (IR.NETTOTAL / IR.AMOUNT * (1 - (I.SA_DISCOUNT / I.GROSSTOTAL))) / (IM.RATE2/IM.RATE1) PRICE,
			 </cfif>
				IR.COST_PRICE / (IM.RATE2/IM.RATE1) COST_PRICE,
				IR.AMOUNT,
				IR.SPECT_VAR_ID,
				IR.STOCK_ID,
				IR.PRODUCT_ID,
				IR.EXTRA_COST,
				PU.MULTIPLIER,
				ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
				I.PURCHASE_SALES PURCHASE_SALES,
				I.INVOICE_CAT ACTION_CAT,
				I.RECORD_DATE
			FROM 
				SHIP S,
				INVOICE_ROW IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT PU,
				INVOICE_MONEY IM
			WHERE
				I.INVOICE_ID = IM.ACTION_ID AND
				IM.MONEY_TYPE = '#arguments.cost_money#' AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				IR.SHIP_ID=S.SHIP_ID AND
				<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
					I.INVOICE_ID =#arguments.action_id# AND	
				</cfif>
				<cfif isdefined('arguments.action_row_id') and arguments.action_row_id gt 0>
					IR.INVOICE_ROW_ID =#arguments.action_row_id# AND	
				</cfif>
				<cfif arguments.is_product_stock is 1>
					IR.PRODUCT_ID = #arguments.product_stock_id# AND
				<cfelseif arguments.is_product_stock is 2>
					IR.STOCK_ID = #arguments.product_stock_id# AND		
				</cfif>
				IR.PRODUCT_ID = PU.PRODUCT_ID AND 
				IR.UNIT = PU.ADD_UNIT AND
				I.GROSSTOTAL > 0 AND
				I.IS_IPTAL = 0
			ORDER BY 
				I.INVOICE_DATE,I.PURCHASE_SALES,I.INVOICE_ID
		</cfquery>
	<cfelse>
		<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
			SELECT
			 <cfif arguments.tax_inc IS 1>
				 (IR.NETTOTAL / IR.AMOUNT * (1 - (I.SA_DISCOUNT / I.GROSSTOTAL)) * (1 + (TAX/100))) / (IM.RATE2/IM.RATE1) PRICE,
			 <cfelse>
				 (IR.NETTOTAL / IR.AMOUNT * (1 - (I.SA_DISCOUNT / I.GROSSTOTAL))) / (IM.RATE2/IM.RATE1) PRICE,
			 </cfif>
				IR.COST_PRICE / (IM.RATE2/IM.RATE1) COST_PRICE,
				IR.AMOUNT,
				IR.SPECT_VAR_ID,
				IR.STOCK_ID,
				IR.PRODUCT_ID,
				IR.EXTRA_COST,
				PU.MULTIPLIER,
				ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
				I.PURCHASE_SALES PURCHASE_SALES,
				I.INVOICE_CAT ACTION_CAT,
				I.RECORD_DATE
			FROM 
				SHIP S,
				INVOICE_SHIPS INV_SHIP,
				INVOICE_ROW IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT PU,
				INVOICE_MONEY IM
			WHERE
				I.INVOICE_ID = IM.ACTION_ID AND
				IM.MONEY_TYPE = '#arguments.cost_money#' AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				INV_SHIP.SHIP_ID=S.SHIP_ID AND
				INV_SHIP.INVOICE_ID=I.INVOICE_ID AND
				<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
					I.INVOICE_ID =#arguments.action_id# AND	
				</cfif>
				<cfif isdefined('arguments.action_row_id') and arguments.action_row_id gt 0>
					IR.INVOICE_ROW_ID =#arguments.action_row_id# AND	
				</cfif>
				<cfif arguments.is_product_stock is 1>
					IR.PRODUCT_ID = #arguments.product_stock_id# AND
				<cfelseif arguments.is_product_stock is 2>
					IR.STOCK_ID = #arguments.product_stock_id# AND		
				</cfif>
				IR.PRODUCT_ID = PU.PRODUCT_ID AND 
				IR.UNIT = PU.ADD_UNIT AND
				I.GROSSTOTAL > 0 AND
				I.IS_IPTAL = 0
			ORDER BY 
				I.INVOICE_DATE,I.PURCHASE_SALES,I.INVOICE_ID
		</cfquery>
	</cfif>
<cfelseif isdefined('arguments.action_type') and arguments.action_type eq 2>
	<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
		SELECT
		 <cfif arguments.tax_inc IS 1>
			 (SR.NETTOTAL / SR.AMOUNT) * (1 + (TAX/100)) / (SM.RATE2/SM.RATE1) PRICE,<!---  * (1 - (ISNULL(S.SA_DISCOUNT,0) / S.GROSSTOTAL) KALDIRDIK CUNKU NULL GELİYOR --->
		 <cfelse>
			 (SR.NETTOTAL / SR.AMOUNT) / (SM.RATE2/SM.RATE1) PRICE, <!---  * (1 - (ISNULL(S.SA_DISCOUNT,0) / S.GROSSTOTAL))  KALDIRDIK CUNKU NULL GELİYOR --->
		 </cfif>
			SR.AMOUNT,
			SR.SPECT_VAR_ID,
			SR.STOCK_ID,
			SR.PRODUCT_ID,
			SR.EXTRA_COST,
			PU.MULTIPLIER,
			ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
			S.PURCHASE_SALES PURCHASE_SALES,
			S.SHIP_TYPE ACTION_CAT,
			S.RECORD_DATE
		FROM 
			SHIP_ROW SR,
			SHIP S,
			#dsn3_alias#.PRODUCT_UNIT PU,
			SHIP_MONEY SM
		WHERE
			S.SHIP_ID = SM.ACTION_ID AND
			SM.MONEY_TYPE = '#arguments.cost_money#' AND
			S.SHIP_ID = SR.SHIP_ID AND
			<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
				S.SHIP_ID =#arguments.action_id# AND
			</cfif>
			<cfif arguments.is_product_stock is 1>
				SR.PRODUCT_ID = #arguments.product_stock_id# AND
			<cfelseif arguments.is_product_stock is 2>
				SR.STOCK_ID = #arguments.product_stock_id# AND		
			</cfif>
			SR.PRODUCT_ID = PU.PRODUCT_ID AND 
			SR.UNIT = PU.ADD_UNIT AND
			S.GROSSTOTAL > 0
		ORDER BY 
			S.SHIP_DATE,S.PURCHASE_SALES,S.SHIP_ID
	</cfquery>
<cfelseif isdefined('arguments.action_type') and arguments.action_type eq 3>
	<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
		SELECT
		 <cfif arguments.tax_inc IS 1>
			 (SFR.NET_TOTAL / SFR.AMOUNT * (1 + (SFR.TAX/100))) / (SFM.RATE2/SFM.RATE1) PRICE,
		 <cfelse>
			 (SFR.NET_TOTAL / SFR.AMOUNT) / (SFM.RATE2/SFM.RATE1) PRICE,
		 </cfif>
		 	SFR.COST_PRICE / (SFM.RATE2/SFM.RATE1) COST_PRICE,
			SFR.AMOUNT AMOUNT,
			SFR.SPECT_VAR_ID,
			0 EXTRA_COST,
			PU.MULTIPLIER MULTIPLIER,
			SF.FIS_DATE ACTION_DATE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			0 PURCHASE_SALES,
			SF.FIS_TYPE ACTION_CAT,
			SF.RECORD_DATE
		FROM 
			STOCK_FIS SF,
			STOCK_FIS_ROW SFR,
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_UNIT PU,
			STOCK_FIS_MONEY SFM
		WHERE 
			SF.FIS_ID = SFM.ACTION_ID AND
			SFM.MONEY_TYPE = '#arguments.cost_money#' AND
			SF.FIS_ID = SFR.FIS_ID AND
			S.STOCK_ID = SFR.STOCK_ID AND
			(SF.FIS_TYPE = 114 OR SF.FIS_TYPE = 110) AND
		<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
			SF.FIS_ID =#arguments.action_id# AND					
		</cfif>
		<cfif arguments.is_product_stock is 1>
			S.PRODUCT_ID = #arguments.product_stock_id# AND		
		<cfelseif arguments.is_product_stock is 2>
			S.STOCK_ID = #arguments.product_stock_id# AND		
		</cfif>
			S.PRODUCT_ID = PU.PRODUCT_ID AND 
			SFR.UNIT = PU.ADD_UNIT 
	</cfquery>
<cfelseif isdefined('arguments.action_type') and arguments.action_type eq 4>
	<cfquery name="GET_ACT" datasource="#DSN3#">
		SELECT 
			POR.FINISH_DATE ACTION_DATE,
			PORR.AMOUNT,
			PORR.SPECT_ID SPEC_ID,
			PORR.PURCHASE_NET_SYSTEM / (SM.RATE2/SM.RATE1) PRICE,<!--- PORR.PURCHASE_NET_SYSTEM_TOTAL/PORR.AMOUNT --->
			PORR.PURCHASE_EXTRA_COST_SYSTEM EXTRA_COST,
			PORR.SPECT_ID SPECT_VAR_ID,
			PU.MULTIPLIER MULTIPLIER,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			0 PURCHASE_SALES,
			PORR.PR_ORDER_ID ACTION_ID,
			POR.PROCESS_ID ACTION_CAT,
			POR.RECORD_DATE
		FROM 
			PRODUCTION_ORDERS PO,
			PRODUCTION_ORDER_RESULTS POR,
			PRODUCTION_ORDER_RESULTS_ROW PORR,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn3_alias#.PRODUCT_UNIT PU,
			#dsn1_alias#.PRODUCT PRODUCT,
			#arguments.period_dsn_type#.SETUP_MONEY SM
		WHERE
			POR.PR_ORDER_ID=#arguments.action_id# AND
			<cfif arguments.is_product_stock is 1>
				STOCKS.PRODUCT_ID = #arguments.product_stock_id# AND		
			<cfelseif arguments.is_product_stock is 2>
				STOCKS.STOCK_ID = #arguments.product_stock_id# AND
			</cfif>
			PO.P_ORDER_ID=POR.P_ORDER_ID AND
			POR.PR_ORDER_ID=PORR.PR_ORDER_ID AND
			STOCKS.STOCK_ID=PORR.STOCK_ID AND
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			STOCKS.PRODUCT_ID = PU.PRODUCT_ID AND 
			PORR.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PRODUCT.IS_COST=1 AND
			PORR.TYPE=1 AND
			PO.IS_DEMONTAJ<>1 AND
			SM.MONEY='#arguments.cost_money#'
	</cfquery>
</cfif>
<cfscript>
	nettotal_cost = 0;
	stock_cost = 0;
	nettotal_cost_extra = 0;
	stock_cost_extra = 0;
	stock_amount_total = 0;
	product_stock_amount = 0;
	product_stock_amount_location = 0;
</cfscript>
<cfif isdefined("GET_ACT") and GET_ACT.RECORDCOUNT>
	<cfquery name="GET_MONEY" datasource="#DSN#" maxrows="1">
		SELECT 
			RATE1,
			RATE2,
			MONEY
		FROM
			MONEY_HISTORY
		WHERE
			MONEY='#arguments.cost_money#' AND
			VALIDATE_DATE <= #CREATEODBCDATE(GET_ACT.ACTION_DATE)#
		ORDER BY 
			MONEY_HISTORY_ID DESC,
			VALIDATE_DATE DESC
	</cfquery>
	<cfif not GET_MONEY.RECORDCOUNT>
		<cfquery name="GET_MONEY" datasource="#arguments.period_dsn_type#">
			SELECT 
				RATE1,
				RATE2,
				MONEY
			FROM
				SETUP_MONEY
			WHERE
				MONEY='#arguments.cost_money#'
		</cfquery>
	</cfif>
	<cfif GET_MONEY.RECORDCOUNT>
		<cfset rate=GET_MONEY.RATE2/GET_MONEY.RATE1>
	<cfelse>
		<cfset rate=1>
	</cfif>
	<cfquery name="GET_MONEY2" datasource="#DSN#" maxrows="1">
		SELECT 
			RATE1,
			RATE2,
			MONEY
		FROM
			MONEY_HISTORY
		WHERE
			MONEY='#arguments.cost_money#' AND
			VALIDATE_DATE <= #CREATEODBCDATE(GET_ACT.ACTION_DATE)#
		ORDER BY 
			MONEY_HISTORY_ID DESC,
			VALIDATE_DATE DESC
	</cfquery>
	<cfif not GET_MONEY2.RECORDCOUNT>
		<cfquery name="GET_MONEY2" datasource="#arguments.period_dsn_type#">
			SELECT 
				RATE1,
				RATE2,
				MONEY
			FROM
				SETUP_MONEY
			WHERE
				MONEY='#arguments.cost_money#'
		</cfquery>
	</cfif>
	<cfif GET_MONEY2.RECORDCOUNT>
		<cfset rate2=GET_MONEY2.RATE2/GET_MONEY2.RATE1>
	<cfelse>
		<cfset rate2=1>
	</cfif>
	<cfoutput query="GET_ACT">
		<cfscript>
			if(listfind('55,54,73,74,114',ACTION_CAT,',')) price_=COST_PRICE; else price_=PRICE;//iade odugunda maliyet alani fiyat gibi islem gormeli acilis fiside maliyet alanindan yapmali
			if(not price_ gte 0)price_=0;
			price_system=price_;
			stock_amount_row = amount * multiplier;
			nettotal_cost_row = price_ * stock_amount_row;
			nettotal_cost = nettotal_cost + nettotal_cost_row;
			stock_amount_total = stock_amount_total + stock_amount_row;
		
			if (len(extra_cost))
				nettotal_cost_extra_row = extra_cost * stock_amount_row;
			else
				nettotal_cost_extra_row = 0;
			nettotal_cost_extra = nettotal_cost_extra + nettotal_cost_extra_row;

			if(stock_amount_total gt 0)
			{
				stock_cost = wrk_round(nettotal_cost / stock_amount_total,4);
				stock_cost_extra = wrk_round(nettotal_cost_extra / stock_amount_total,4);
			}
			else if(stock_amount_total is 0)
			{
				stock_cost = 0;
				stock_cost_extra = 0;
			}
		</cfscript>
	</cfoutput>
	<!--- spec varsa specli stok degilse urun stok bulunuyor --->
	<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
		<cfquery name="GET_STOCK_ACT" datasource="#arguments.period_dsn_type#">
			SELECT
				SUM(STOCK_IN - STOCK_OUT) AS AMOUNT, 
				STOCK_ID
			FROM
				STOCKS_ROW
			WHERE
				STOCK_ID=#GET_ACT.STOCK_ID#
				AND SPECT_VAR_ID IS NULL
				AND PROCESS_DATE = #createodbcdatetime(GET_ACT.ACTION_DATE)#
				AND PROCESS_TYPE<>81
			GROUP BY
				STOCK_ID
		</cfquery>
	<cfelse>
		<cfif isdefined('arguments.spec_id') and len(arguments.spec_id)>
			<cfquery name="GET_SPEC_" datasource="#DSN3#">
				SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID=#arguments.spec_id#
			</cfquery>
		<cfelseif isdefined('arguments.spec_main_id') and len(arguments.spec_main_id)>
			<cfset GET_SPEC_.SPECT_MAIN_ID=arguments.spec_main_id>
		<cfelse>
			<cfset GET_SPEC_.SPECT_MAIN_ID=''>
		</cfif>

		<cfquery name="GET_STOCK_ACT" datasource="#arguments.period_dsn_type#">
			SELECT
				SUM(STOCK_IN - STOCK_OUT) AS AMOUNT, 
				STOCK_ID,
				SPECT_VAR_ID
			FROM
				STOCKS_ROW
			WHERE
				STOCK_ID=#GET_ACT.STOCK_ID#
				AND SPECT_VAR_ID=#GET_SPEC_.SPECT_MAIN_ID#
				AND PROCESS_DATE = #createodbcdatetime(GET_ACT.ACTION_DATE)#
				AND PROCESS_TYPE<>81
			GROUP BY
				STOCK_ID,
				SPECT_VAR_ID
		</cfquery>
	</cfif>
	<cfif isdefined('GET_STOCK_ACT') and GET_STOCK_ACT.RECORDCOUNT AND LEN(GET_STOCK_ACT.AMOUNT)>
			<cfset today_stock_act=GET_STOCK_ACT.AMOUNT-stock_amount_total>
	<cfelse>
		<cfset today_stock_act=0>
	</cfif>
	
	<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
		<cfquery name="GET_STOCK" datasource="#arguments.period_dsn_type#">
			SELECT
				SUM(STOCK_IN - STOCK_OUT)-(#today_stock_act#) AS PRODUCT_STOCK, 
				STOCK_ID
			FROM
				STOCKS_ROW
			WHERE
				STOCK_ID=#GET_ACT.STOCK_ID#
				AND SPECT_VAR_ID IS NULL
				AND PROCESS_DATE <= #createodbcdatetime(GET_ACT.ACTION_DATE)#
				AND PROCESS_TYPE<>81
			GROUP BY
				STOCK_ID
		</cfquery>
	<cfelse>
		<cfif isdefined('arguments.spec_id') and len(arguments.spec_id)>
			<cfquery name="GET_SPEC_" datasource="#DSN3#">
				SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID=#arguments.spec_id#
			</cfquery>
		</cfif>
		<cfquery name="GET_STOCK" datasource="#arguments.period_dsn_type#">
			SELECT
				SUM(STOCK_IN - STOCK_OUT)-(#today_stock_act#) AS PRODUCT_STOCK, 
				STOCK_ID,
				SPECT_VAR_ID
			FROM
				STOCKS_ROW
			WHERE
				STOCK_ID=#GET_ACT.STOCK_ID#
				AND SPECT_VAR_ID=#GET_SPEC_.SPECT_MAIN_ID#
				AND PROCESS_DATE <= #createodbcdatetime(GET_ACT.ACTION_DATE)#
				AND PROCESS_TYPE<>81
			GROUP BY
				STOCK_ID,
				SPECT_VAR_ID
		</cfquery>
	</cfif>
	<cfscript>
		if(isdefined('arguments.cost_money_system') and len(arguments.cost_money_system))
		{
			stock_cost_system=stock_cost*rate;
			stock_cost_extra_system=stock_cost_extra*rate;
			stock_cost_system_2=stock_cost*rate2;
			stock_cost_extra_system_2=stock_cost_extra*rate2;
		}
		if(GET_STOCK.RECORDCOUNT and len(GET_STOCK.PRODUCT_STOCK)) stock_amount_total=GET_STOCK.PRODUCT_STOCK; else stock_amount_total=0;
		if(GET_STOCK.RECORDCOUNT and len(GET_STOCK.PRODUCT_STOCK)) product_stock_amount=GET_STOCK.PRODUCT_STOCK; else product_stock_amount=0;
	</cfscript>
</cfif>
<cfif not isdefined('stock_cost_extra')><cfset stock_cost_extra=0></cfif>
<cfif not isdefined('price_system')><cfset price_system=0></cfif>
<cfif not isdefined('stock_cost_extra_system_2')><cfset stock_cost_extra_system_2=0></cfif>
<cfif not isdefined('stock_cost_system_2')><cfset stock_cost_system_2=0></cfif>
<cfif not isdefined('stock_cost_system')><cfset stock_cost_system=0></cfif>
<cfif not isdefined('stock_cost_extra_system')><cfset stock_cost_extra_system=0></cfif>
<cfset stock_cost = "#stock_cost#;#stock_cost_extra#;#product_stock_amount#;#stock_cost_system#;#stock_cost_extra_system#;#stock_cost_system_2#;#stock_cost_extra_system_2#;#product_stock_amount_location#;0;0;0;0;0;0;#price_system#;#stock_cost_extra#">
