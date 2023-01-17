<!--- 
	son alis fiyati yontemi:
	--verilen action_id ve type a gore invoice,ship v.s. den kayitlari ceker 
	--deger yollanan para birimine gore kurla carpilir degerler yollanir (kur setup moneyden geliyor sorun olabilir nasil yapilmasi gerektigi bakilmali)
 --->
<cfif not isdefined('arguments.action_type') or arguments.action_type eq 1>
	<!--- fatura fiyat farkı v.s. olabilir veya fiyat farkı kesilmiş bir fatura olabilir --->
	<cfquery name="GET_INVOICE_COMPARISON" datasource="#arguments.period_dsn_type#">
		SELECT 
			DIFF_INVOICE_ID,
			MAIN_INVOICE_ID
		FROM 
			INVOICE_CONTRACT_COMPARISON
		WHERE
			INVOICE_CONTRACT_COMPARISON.MAIN_INVOICE_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif GET_INVOICE_COMPARISON.RECORDCOUNT>
		<!--- <cfset arguments.action_id=GET_INVOICE_COMPARISON.MAIN_INVOICE_ID> --->
		<cfquery name="GET_DIFF_INV" datasource="#arguments.period_dsn_type#">
			SELECT
			 <cfif arguments.tax_inc IS 1>
				(INVOICE_ROW.NETTOTAL / INVOICE_ROW.AMOUNT * (1 - (ISNULL(INVOICE.SA_DISCOUNT,0) / INVOICE.GROSSTOTAL)) * (1 + (INVOICE_ROW.TAX/100))) / (INVOICE_MONEY.RATE2/INVOICE_MONEY.RATE1) INV_DIFF_PRICE
			 <cfelse>
				(INVOICE_ROW.NETTOTAL / INVOICE_ROW.AMOUNT * (1 - (ISNULL(INVOICE.SA_DISCOUNT,0) / INVOICE.GROSSTOTAL))) / (INVOICE_MONEY.RATE2/INVOICE_MONEY.RATE1) INV_DIFF_PRICE
			 </cfif>
			FROM 
				INVOICE,
				INVOICE_ROW,
				INVOICE_MONEY,
				INVOICE_CONTRACT_COMPARISON
			WHERE
				INVOICE_CONTRACT_COMPARISON.MAIN_INVOICE_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
				INVOICE.INVOICE_ID=INVOICE_CONTRACT_COMPARISON.DIFF_INVOICE_ID AND
				INVOICE_ROW.INVOICE_ID=INVOICE.INVOICE_ID AND
				INVOICE_MONEY.ACTION_ID=INVOICE.INVOICE_ID AND
				INVOICE_MONEY.MONEY_TYPE = <cfqueryparam value="#arguments.cost_money#" cfsqltype="cf_sql_varchar"> AND
				<cfif arguments.is_product_stock is 1>
					INVOICE_ROW.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
				<cfelseif arguments.is_product_stock is 2>
					INVOICE_ROW.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
				</cfif>
				INVOICE.GROSSTOTAL > 0 AND
				INVOICE.IS_IPTAL = 0
		</cfquery>
	</cfif>

	<cfquery name="GET_INV_SHIP_" datasource="#arguments.period_dsn_type#"><!--- faturadan irsaliye oluşmuşsa fatura satırındaki ship_id bos oldugu icin irsaliyenin nasıl oluştuğunu anlamak için--->
		SELECT IS_WITH_SHIP FROM INVOICE_SHIPS WHERE INVOICE_SHIPS.INVOICE_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif GET_INV_SHIP_.IS_WITH_SHIP eq  0>
		<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
			SELECT
			 <cfif arguments.tax_inc IS 1>
				(IR.NETTOTAL / IR.AMOUNT * (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) * (1 + (TAX/100))) / (IM.RATE2/IM.RATE1) <cfif isdefined('GET_DIFF_INV') and GET_DIFF_INV.RECORDCOUNT>- #GET_DIFF_INV.INV_DIFF_PRICE#</cfif> PRICE,
			 <cfelse>
				(IR.NETTOTAL / IR.AMOUNT * (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL))) / (IM.RATE2/IM.RATE1) <cfif isdefined('GET_DIFF_INV') and GET_DIFF_INV.RECORDCOUNT>- #GET_DIFF_INV.INV_DIFF_PRICE#</cfif> PRICE,
			 </cfif>
				IR.COST_PRICE / (IM.RATE2/IM.RATE1) COST_PRICE,
				IR.AMOUNT,
				IR.SPECT_VAR_ID,
				IR.STOCK_ID,
				IR.PRODUCT_ID,
				IR.EXTRA_COST/(IM.RATE2/IM.RATE1) EXTRA_COST,
				PU.MULTIPLIER,
				ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
				I.PURCHASE_SALES PURCHASE_SALES,
				I.INVOICE_CAT ACTION_CAT,
				I.RECORD_DATE,
				I.DEPARTMENT_ID ACT_DEPARTMENT_ID,
				I.DEPARTMENT_LOCATION ACT_LOCATION_ID,
				S.SHIP_ID
			FROM
				SHIP S,
				INVOICE_ROW IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT PU,
				INVOICE_MONEY IM
			WHERE
				I.INVOICE_ID = IM.ACTION_ID AND
				IM.MONEY_TYPE = <cfqueryparam value="#arguments.cost_money#" cfsqltype="cf_sql_varchar"> AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				IR.SHIP_ID=S.SHIP_ID AND
				<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
					I.INVOICE_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
				</cfif>
				<cfif isdefined('arguments.action_row_id') and arguments.action_row_id gt 0>
					IR.INVOICE_ROW_ID = <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"> AND
				</cfif>
				<cfif arguments.is_product_stock is 1>
					IR.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
				<cfelseif arguments.is_product_stock is 2>
					IR.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
				</cfif>
				IR.PRODUCT_ID = PU.PRODUCT_ID AND
				IR.UNIT = PU.ADD_UNIT AND
				I.GROSSTOTAL > 0 AND
				I.IS_IPTAL = 0
				<cfif GET_NOT_DEP_COST.RECORDCOUNT>
				AND I.INVOICE_ID NOT IN 
					( SELECT INVOICE_ID FROM INVOICE WHERE
					<cfset rw_count=0>
					<cfloop query="GET_NOT_DEP_COST">
						<cfset rw_count=rw_count+1>
						(INVOICE.DEPARTMENT_LOCATION = <cfqueryparam value="#GET_NOT_DEP_COST.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND INVOICE.DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
						<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
					</cfloop>
					)
				</cfif>
			ORDER BY
				I.INVOICE_DATE,I.PURCHASE_SALES,I.INVOICE_ID
		</cfquery>
	<cfelse>
		<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
			SELECT
			 <cfif arguments.tax_inc IS 1>
				 (IR.NETTOTAL / IR.AMOUNT * (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) * (1 + (TAX/100))) / (IM.RATE2/IM.RATE1)<cfif isdefined('GET_DIFF_INV') and GET_DIFF_INV.RECORDCOUNT>- #GET_DIFF_INV.INV_DIFF_PRICE#</cfif> PRICE,
			 <cfelse>
				 (IR.NETTOTAL / IR.AMOUNT * (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL))) / (IM.RATE2/IM.RATE1)<cfif isdefined('GET_DIFF_INV') and GET_DIFF_INV.RECORDCOUNT>- #GET_DIFF_INV.INV_DIFF_PRICE#</cfif> PRICE,
			 </cfif>
				IR.COST_PRICE / (IM.RATE2/IM.RATE1) COST_PRICE,
				IR.AMOUNT,
				IR.SPECT_VAR_ID,
				IR.STOCK_ID,
				IR.PRODUCT_ID,
				IR.EXTRA_COST / (IM.RATE2/IM.RATE1) EXTRA_COST,
				PU.MULTIPLIER,
				ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
				I.PURCHASE_SALES PURCHASE_SALES,
				I.INVOICE_CAT ACTION_CAT,
				I.RECORD_DATE,
				I.DEPARTMENT_ID ACT_DEPARTMENT_ID,
				I.DEPARTMENT_LOCATION ACT_LOCATION_ID,
				S.SHIP_ID
			FROM 
				SHIP S,
				INVOICE_SHIPS INV_SHIP,
				INVOICE_ROW IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT PU,
				INVOICE_MONEY IM
			WHERE
				I.INVOICE_ID = IM.ACTION_ID AND
				IM.MONEY_TYPE = <cfqueryparam value="#arguments.cost_money#" cfsqltype="cf_sql_varchar"> AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				INV_SHIP.SHIP_ID=S.SHIP_ID AND
				INV_SHIP.INVOICE_ID=I.INVOICE_ID AND
				<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
					I.INVOICE_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
				</cfif>
				<cfif isdefined('arguments.action_row_id') and arguments.action_row_id gt 0>
					IR.INVOICE_ROW_ID = <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"> AND
				</cfif>
				<cfif arguments.is_product_stock is 1>
					IR.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
				<cfelseif arguments.is_product_stock is 2>
					IR.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
				</cfif>
				IR.PRODUCT_ID = PU.PRODUCT_ID AND 
				IR.UNIT = PU.ADD_UNIT AND
				I.GROSSTOTAL > 0 AND
				I.IS_IPTAL = 0
				<cfif GET_NOT_DEP_COST.RECORDCOUNT>
				AND I.INVOICE_ID NOT IN 
					( SELECT INVOICE_ID FROM INVOICE WHERE
					<cfset rw_count=0>
					<cfloop query="GET_NOT_DEP_COST">
						<cfset rw_count=rw_count+1>
						(INVOICE.DEPARTMENT_LOCATION = <cfqueryparam value="#GET_NOT_DEP_COST.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND INVOICE.DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
						<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
					</cfloop>
					)
				</cfif>
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
		 	SR.COST_PRICE / (SM.RATE2/SM.RATE1) COST_PRICE,
			SR.AMOUNT,
			SR.SPECT_VAR_ID,
			SR.STOCK_ID,
			SR.PRODUCT_ID,
			SR.EXTRA_COST / (SM.RATE2/SM.RATE1) EXTRA_COST,
			PU.MULTIPLIER,
			ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
			S.PURCHASE_SALES PURCHASE_SALES,
			S.SHIP_TYPE ACTION_CAT,
			S.RECORD_DATE,
			S.DEPARTMENT_IN ACT_DEPARTMENT_ID,
			S.LOCATION_IN ACT_LOCATION_ID,
			S.DELIVER_STORE_ID ACT_OUT_DEPARTMENT_ID,
			S.LOCATION ACT_OUT_LOCATION_ID,
			SR.TAX,
			SM.RATE2 RATE2,
			SM.RATE1 RATE1
		FROM 
			SHIP_ROW SR,
			SHIP S,
			#dsn3_alias#.PRODUCT_UNIT PU,
			SHIP_MONEY SM
		WHERE
			S.SHIP_ID = SM.ACTION_ID AND
			SM.MONEY_TYPE = <cfqueryparam value="#arguments.cost_money#" cfsqltype="cf_sql_varchar"> AND
			S.SHIP_ID = SR.SHIP_ID AND
			<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
				S.SHIP_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
			</cfif>
			<cfif arguments.is_product_stock is 1>
				SR.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
			<cfelseif arguments.is_product_stock is 2>
				SR.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND		
			</cfif>
			SR.PRODUCT_ID = PU.PRODUCT_ID AND 
			SR.UNIT = PU.ADD_UNIT AND
			(S.GROSSTOTAL > 0 OR SR.COST_PRICE > 0)<!--- TUTAR 0 OLABİLİR AMA İADELER COST_PRICE DAN OLUŞUR --->
			<cfif GET_NOT_DEP_COST.RECORDCOUNT>
			AND S.SHIP_ID NOT IN 
				( SELECT SHIP_ID FROM SHIP WHERE
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST">
					<cfset rw_count=rw_count+1>
					(SHIP.LOCATION_IN = <cfqueryparam value="#GET_NOT_DEP_COST.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND SHIP.DEPARTMENT_IN = <cfqueryparam value="#GET_NOT_DEP_COST.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
				</cfloop>
				)
			</cfif>
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
			SFR.EXTRA_COST / (SFM.RATE2/SFM.RATE1) EXTRA_COST,
			PU.MULTIPLIER MULTIPLIER,
			SF.FIS_DATE ACTION_DATE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			0 PURCHASE_SALES,
			SF.FIS_TYPE ACTION_CAT,
			SF.RECORD_DATE,
			SF.DEPARTMENT_IN ACT_DEPARTMENT_ID,
			SF.LOCATION_IN ACT_LOCATION_ID
			,SF.DEPARTMENT_OUT ACT_OUT_DEPARTMENT_ID,
			SF.LOCATION_OUT ACT_OUT_LOCATION_ID,
			SFR.TAX,
			SFM.RATE2,
			SFM.RATE1
		FROM 
			STOCK_FIS SF,
			STOCK_FIS_ROW SFR,
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_UNIT PU,
			STOCK_FIS_MONEY SFM
		WHERE 
			SF.FIS_ID = SFM.ACTION_ID AND
			SFM.MONEY_TYPE = <cfqueryparam value="#arguments.cost_money#" cfsqltype="cf_sql_varchar"> AND
			SF.FIS_ID = SFR.FIS_ID AND
			S.STOCK_ID = SFR.STOCK_ID AND
			SF.FIS_TYPE IN (114,110,115,113) AND
		<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
			SF.FIS_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
		</cfif>
		<cfif arguments.is_product_stock is 1>
			S.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND		
		<cfelseif arguments.is_product_stock is 2>
			S.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND		
		</cfif>
			S.PRODUCT_ID = PU.PRODUCT_ID AND 
			SFR.UNIT = PU.ADD_UNIT
			<cfif GET_NOT_DEP_COST.RECORDCOUNT>
			AND SF.FIS_ID NOT IN 
				( SELECT FIS_ID FROM STOCK_FIS WHERE
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST">
					<cfset rw_count=rw_count+1>
					(STOCK_FIS.LOCATION_IN = <cfqueryparam value="#GET_NOT_DEP_COST.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND STOCK_FIS.DEPARTMENT_IN = <cfqueryparam value="#GET_NOT_DEP_COST.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
				</cfloop>
				)
			</cfif>
	</cfquery>
<cfelseif isdefined('arguments.action_type') and arguments.action_type eq 4>
<cfquery name="GET_ACT" datasource="#DSN3#">
		SELECT 
			POR.FINISH_DATE ACTION_DATE,
			PORR.AMOUNT,
			PORR.SPECT_ID SPEC_ID,
			PORR.PURCHASE_NET_SYSTEM / (SM.RATE2/SM.RATE1) PRICE,<!--- PORR.PURCHASE_NET_SYSTEM_TOTAL/PORR.AMOUNT --->
			PORR.PURCHASE_EXTRA_COST_SYSTEM / (SM.RATE2/SM.RATE1) EXTRA_COST,
			PORR.SPECT_ID SPECT_VAR_ID,
			PU.MULTIPLIER MULTIPLIER,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			0 PURCHASE_SALES,
			PORR.PR_ORDER_ID ACTION_ID,
			POR.PROCESS_ID ACTION_CAT,
			POR.RECORD_DATE,
			POR.PRODUCTION_DEP_ID ACT_DEPARTMENT_ID,
			POR.PRODUCTION_LOC_ID ACT_LOCATION_ID
		FROM 
			PRODUCTION_ORDERS PO,
			PRODUCTION_ORDER_RESULTS POR,
			PRODUCTION_ORDER_RESULTS_ROW PORR,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn3_alias#.PRODUCT_UNIT PU,
			#dsn1_alias#.PRODUCT PRODUCT,
			#arguments.period_dsn_type#.SETUP_MONEY SM
		WHERE
			POR.PR_ORDER_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
			<cfif arguments.is_product_stock is 1>
				STOCKS.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
			<cfelseif arguments.is_product_stock is 2>
				STOCKS.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
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
			SM.MONEY = <cfqueryparam value="#arguments.cost_money#" cfsqltype="cf_sql_varchar">
			<cfif GET_NOT_DEP_COST.RECORDCOUNT>
			AND POR.PR_ORDER_ID NOT IN 
				( SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST">
					<cfset rw_count=rw_count+1>
					(PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID = <cfqueryparam value="#GET_NOT_DEP_COST.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID = <cfqueryparam value="#GET_NOT_DEP_COST.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
				</cfloop>
				)
			</cfif>
	</cfquery>
</cfif>

<cfif GET_ACT.RECORDCOUNT>
	<cfscript>
		rate_list_fonk=get_cost_rate(action_id : arguments.action_id,
								action_type : arguments.action_type,
								action_date : createodbcdate(GET_ACT.ACTION_DATE),
								dsn_period_money : arguments.period_dsn_type,
								dsn_money : DSN);
		if(isdefined('rate_list_fonk') and listfind(rate_list_fonk,arguments.cost_money,';'))
			rate_system=listgetat(rate_list_fonk,listfind(rate_list_fonk,arguments.cost_money,';')-1,';');
		else
			rate_system=1;
		if(isdefined('rate_list_fonk') and listfind(rate_list_fonk,arguments.cost_money_system_2,';'))
			rate_system_2=listgetat(rate_list_fonk,listfind(rate_list_fonk,arguments.cost_money_system_2,';')-1,';');
		else
			rate_system_2=1;

		nettotal_cost = 0;
		stock_cost = 0;
		nettotal_cost_extra = 0;
		stock_cost_extra = 0;
		stock_amount_total = 0;
	</cfscript>
	
	<cfoutput query="GET_ACT">
		<cfscript>
			if(listfind('55,54,73,74,114,115',ACTION_CAT,',')) price_=COST_PRICE; else price_=PRICE;//iade odugunda maliyet alani fiyat gibi islem gormeli acilis fiside maliyet alanindan yapmali
			if(not price_ gte 0)price_=0;
			
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
	<cfif (arguments.is_cost_zero_row eq 0 and stock_cost gt 0) or arguments.is_cost_zero_row eq 1><!--- 0 tutarlı satırlar maliyet oluştursun dendi ise 0 dan büyük ise girer bloğa --->
		<cfif (listfind('55,54,73,74,114,110,115,113',GET_ACT.ACTION_CAT,',') and stock_cost gt 0) or not listfind('55,54,73,74,114,110,115,113',GET_ACT.ACTION_CAT,',')><!--- iadelerde net maliyet 0 ise malyet oluşturmasın 0 dan büyükse oluştursun her koşulda maliyeti --->
			
			<cfquery name="GET_STOCK_ACT_ALL" datasource="#arguments.period_dsn_type#">
				SELECT
					SUM(STOCK_IN - STOCK_OUT) AS AMOUNT_ALL,
					PRODUCT_ID,
					STORE_LOCATION LOCATION_ID,
					STORE DEPARTMENT_ID,
					SPECT_VAR_ID,
					PROCESS_DATE,
					PROCESS_TYPE
				FROM
					STOCKS_ROW
				WHERE
					PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
					AND PROCESS_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
					AND PROCESS_TYPE NOT IN (72,75) <!--- konsinye çıkış faturası kesilmemiş olanlar --->
					<!--- AND PROCESS_TYPE <> 81 departman bazında maliyette sevklerde isleme tabi--->
					<cfif GET_NOT_DEP_COST.RECORDCOUNT>
					AND
						( 
						<cfset rw_count=0>
						<cfloop query="GET_NOT_DEP_COST">
							<cfset rw_count=rw_count+1>
							NOT (STORE_LOCATION = <cfqueryparam value="#GET_NOT_DEP_COST.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND STORE = <cfqueryparam value="#GET_NOT_DEP_COST.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
							<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif>
						</cfloop>
						)
					</cfif>
				GROUP BY
					PRODUCT_ID,
					STORE_LOCATION,
					STORE,
					SPECT_VAR_ID,
					PROCESS_DATE,
					PROCESS_TYPE
			</cfquery>
			<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
				<cfquery name="GET_STOCK" dbtype="query">
					SELECT
						SUM(AMOUNT_ALL) AS PRODUCT_STOCK, 
						PRODUCT_ID
					FROM
						GET_STOCK_ACT_ALL
					WHERE
						SPECT_VAR_ID IS NULL
						AND PROCESS_TYPE NOT IN (81,811)
					GROUP BY
						PRODUCT_ID
				</cfquery>
				<cfif len(GET_ACT.ACT_DEPARTMENT_ID)>
					<cfquery name="GET_STOCK_LOCATION" dbtype="query">
						SELECT
							SUM(AMOUNT_ALL) AS PRODUCT_STOCK, 
							PRODUCT_ID
						FROM
							GET_STOCK_ACT_ALL
						WHERE
							SPECT_VAR_ID IS NULL
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
						GROUP BY
							PRODUCT_ID
					</cfquery>
				</cfif>
			<cfelse>
				<cfif isdefined('arguments.spec_id') and len(arguments.spec_id)>
					<cfquery name="GET_SPEC_" datasource="#DSN3#">
						SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam value="#arguments.spec_id#" cfsqltype="cf_sql_integer">
					</cfquery>
				<cfelse>
					<cfset GET_SPEC_.SPECT_MAIN_ID=arguments.spec_main_id>
				</cfif>
				<cfquery name="GET_STOCK" dbtype="query">
					SELECT
						SUM(AMOUNT_ALL) AS PRODUCT_STOCK,
						PRODUCT_ID,
						SPECT_VAR_ID
					FROM
						GET_STOCK_ACT_ALL
					WHERE
						SPECT_VAR_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
						AND PROCESS_TYPE NOT IN (81,811)
					GROUP BY
						PRODUCT_ID,
						SPECT_VAR_ID
				</cfquery>
				<cfif len(GET_ACT.ACT_DEPARTMENT_ID)>
					<cfquery name="GET_STOCK_LOCATION" dbtype="query">
						SELECT
							SUM(AMOUNT_ALL) AS PRODUCT_STOCK, 
							PRODUCT_ID
						FROM
							GET_STOCK_ACT_ALL
						WHERE
							SPECT_VAR_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
						GROUP BY
							PRODUCT_ID
					</cfquery>
				</cfif>
			</cfif>
			<cfscript>
				if(GET_STOCK.RECORDCOUNT and len(GET_STOCK.PRODUCT_STOCK))
					product_stock_=GET_STOCK.PRODUCT_STOCK;
				else
					product_stock_=0;
				if(isdefined('GET_STOCK_LOCATION') and GET_STOCK_LOCATION.RECORDCOUNT and len(GET_STOCK_LOCATION.PRODUCT_STOCK))
					product_stock_location=GET_STOCK_LOCATION.PRODUCT_STOCK;
				else
					product_stock_location=0;
				if(isdefined('arguments.cost_money_system') and len(arguments.cost_money_system))
				{
					price_system=price_*rate_system;
					stock_cost_system=stock_cost*rate_system;
					stock_cost_extra_system=stock_cost_extra*rate_system;
				}
			</cfscript>
		</cfif>
	</cfif><!---// 0 tutarlı satırlar maliyet oluştursun dendi ise 0 dan büyük ise girer bloğa --->
</cfif>
<cfif not isdefined('price_system')><cfset price_system=price_></cfif>
<cfif not isdefined('product_stock_')><cfset product_stock_=0></cfif>
<cfif not isdefined('stock_cost_system')><cfset stock_cost_system=0></cfif>
<cfif not isdefined('stock_cost_extra_system')><cfset stock_cost_extra_system=0></cfif>
<cfif not isdefined('stock_cost_system_2')><cfset stock_cost_system_2=0></cfif>
<cfif not isdefined('stock_cost_extra_system_2')><cfset stock_cost_extra_system_2=0></cfif>
<cfif not isdefined('product_stock_location')><cfset product_stock_location=0></cfif>
<cfif not isdefined('stock_cost_system')><cfset stock_cost_system_location=0></cfif>
<cfif not isdefined('stock_cost_extra_system')><cfset stock_cost_extra_system_location=0></cfif>
<cfif not isdefined('stock_cost_system_2')><cfset stock_cost_system_2_location=0></cfif>
<cfif not isdefined('stock_cost_extra_system_2')><cfset stock_cost_extra_system_2_location=0></cfif>
<cfset stock_cost = "#stock_cost#;#stock_cost_extra#;#product_stock_#;#stock_cost_system#;#stock_cost_extra_system#;#stock_cost_system_2#;#stock_cost_extra_system_2#;#product_stock_location#;#stock_cost#;#stock_cost_extra#;#stock_cost_system#;#stock_cost_extra_system#;#stock_cost_system_2#;#stock_cost_extra_system_2#;#price_system#">
