<cfsetting showdebugoutput="no"><!---depo bazlı maliyet product db add_cost,add_cost_1,dönem db upd_ship_cost stred proc düzenleme yapıldı PY 0616 --->
<!--- 0 attık get_act den deger gelmez ise direk fonksiyondan değer dönüyor ve eski değerleri varsa onlar gidiyor--->
<cfset price_system=0>
<cfset extra_cost_system_=0>
<cfset stock_cost=0>
<cfset stock_cost_extra=0>
<cfset product_stock_amount=0>
<cfset stock_cost_system=0>
<cfset stock_cost_extra_system=0>
<cfset stock_cost_system_2=0>
<cfset stock_cost_extra_system_2=0>
<cfset product_stock_amount_location=0>
<cfset stock_cost_location=0>
<cfset stock_cost_extra_location=0>
<cfset stock_cost_system_location=0>
<cfset stock_cost_extra_system_location=0>
<cfset stock_cost_system_2_location=0>
<cfset stock_cost_extra_system_2_location=0>
<cfset product_stock_amount_department=0>
<cfset stock_cost_department=0>
<cfset stock_cost_extra_department=0>
<cfset stock_cost_system_department=0>
<cfset stock_cost_extra_system_department=0>
<cfset stock_cost_system_2_department=0>
<cfset stock_cost_extra_system_2_department=0>
<cfset stock_cost_reflection = 0>
<cfset stock_cost_reflection_system = 0>
<cfset stock_cost_reflection_system_2 = 0>
<cfset stock_cost_reflection_location = 0>
<cfset stock_cost_reflection_system_location = 0>
<cfset stock_cost_reflection_system_2_location = 0>
<cfset stock_cost_reflection_department = 0>
<cfset stock_cost_reflection_system_department = 0>
<cfset stock_cost_reflection_system_2_department = 0>
<cfset stock_cost_labor = 0>
<cfset stock_cost_labor_system = 0>
<cfset stock_cost_labor_system_2 = 0>
<cfset stock_cost_labor_location = 0>
<cfset stock_cost_labor_system_location = 0>
<cfset stock_cost_labor_system_2_location = 0>
<cfset stock_cost_labor_department = 0>
<cfset stock_cost_labor_system_department = 0>
<cfset stock_cost_labor_system_2_department = 0>
<cfif not isdefined("is_prod_cost_type")>
	<cfset is_prod_cost_type = session.ep.our_company_info.is_prod_cost_type>
</cfif>
<cfif not isdefined("is_stock_based_cost")>
	<cfset is_stock_based_cost = session.ep.our_company_info.is_stock_based_cost>
</cfif>
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
		<cfquery name="GET_INVOICE_ROW" datasource="#arguments.period_dsn_type#">
			SELECT WRK_ROW_ID FROM INVOICE_ROW WHERE INVOICE_ROW_ID = <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer">
		</cfquery>
		<!--- <cfset arguments.action_id=GET_INVOICE_COMPARISON.MAIN_INVOICE_ID> --->
		<cfquery name="GET_DIFF_INV" datasource="#arguments.period_dsn_type#">
			SELECT
			 <cfif arguments.tax_inc IS 1>
				(INVOICE_ROW.NETTOTAL / INVOICE_ROW.AMOUNT * (1 - (ISNULL(INVOICE.SA_DISCOUNT,0) / INVOICE.GROSSTOTAL)) * (1 + (INVOICE_ROW.TAX/100))) INV_DIFF_PRICE
			 <cfelse>
				(INVOICE_ROW.NETTOTAL / INVOICE_ROW.AMOUNT * (1 - (ISNULL(INVOICE.SA_DISCOUNT,0) / INVOICE.GROSSTOTAL))) INV_DIFF_PRICE
			 </cfif>,
			 	INVOICE.INVOICE_CAT,
				INVOICE_CONTRACT_COMPARISON.WRK_ROW_RELATION_ID
			FROM 
				INVOICE,
				INVOICE_ROW,
				INVOICE_CONTRACT_COMPARISON
			WHERE
				INVOICE_CONTRACT_COMPARISON.MAIN_INVOICE_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
				<cfif get_invoice_row.recordcount and len(get_invoice_row.wrk_row_id)>
					(INVOICE_CONTRACT_COMPARISON.WRK_ROW_RELATION_ID IS NULL OR (INVOICE_CONTRACT_COMPARISON.WRK_ROW_RELATION_ID IS NOT NULL AND INVOICE_CONTRACT_COMPARISON.WRK_ROW_RELATION_ID = '#get_invoice_row.wrk_row_id#')) AND
				</cfif>
				INVOICE.INVOICE_ID=INVOICE_CONTRACT_COMPARISON.DIFF_INVOICE_ID AND
				INVOICE_ROW.INVOICE_ID=INVOICE.INVOICE_ID AND
				<cfif arguments.is_product_stock is 1>
					INVOICE_ROW.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
				<cfelseif arguments.is_product_stock is 2>
					INVOICE_ROW.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
				</cfif>
				INVOICE.GROSSTOTAL > 0 AND
				INVOICE.IS_IPTAL = 0
		</cfquery>
	<cfelse>
		<cfset GET_DIFF_INV.RECORDCOUNT=0>
	</cfif>

	<cfquery name="GET_INV_SHIP_" datasource="#arguments.period_dsn_type#"><!--- faturadan irsaliye oluşmuşsa fatura satırındaki ship_id bos oldugu icin irsaliyenin nasıl oluştuğunu anlamak için--->
		SELECT IS_WITH_SHIP FROM INVOICE_SHIPS WHERE INVOICE_SHIPS.INVOICE_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif GET_INV_SHIP_.IS_WITH_SHIP eq  0>
		<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
			SELECT DISTINCT
			 <cfif arguments.tax_inc IS 1>
				(IR.NETTOTAL / IR.AMOUNT * (CASE I.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) END) * (1 + (TAX/100))) <cfif GET_INVOICE_COMPARISON.RECORDCOUNT and GET_DIFF_INV.RECORDCOUNT><cfif listfind('48,50,58',GET_DIFF_INV.INVOICE_CAT)>-<cfelse>+</cfif> #GET_DIFF_INV.INV_DIFF_PRICE#</cfif> PRICE,
			 <cfelse>
				(IR.NETTOTAL / IR.AMOUNT * (CASE I.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) END)) <cfif GET_INVOICE_COMPARISON.RECORDCOUNT and GET_DIFF_INV.RECORDCOUNT><cfif listfind('48,50,58',GET_DIFF_INV.INVOICE_CAT)>-<cfelse>+</cfif> #GET_DIFF_INV.INV_DIFF_PRICE#</cfif> PRICE,
			 </cfif>
				IR.COST_PRICE COST_PRICE,
				IR.AMOUNT,
				IR.SPECT_VAR_ID,
				IR.STOCK_ID,
				IR.PRODUCT_ID,
				IR.INVOICE_ROW_ID,
				ISNULL(IR.EXTRA_COST,0) EXTRA_COST,
				0 as LABOR_COST_SYSTEM,
            	0 as STATION_REFLECTION_COST_SYSTEM,
				PU.MULTIPLIER,
				ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
				I.PURCHASE_SALES PURCHASE_SALES,
				I.INVOICE_CAT ACTION_CAT,
				I.PROCESS_CAT,
				I.RECORD_DATE,
				I.DEPARTMENT_ID ACT_DEPARTMENT_ID,
				I.DEPARTMENT_LOCATION ACT_LOCATION_ID,
				S.SHIP_ID,
				I.INVOICE_DATE,
				I.PURCHASE_SALES,
				I.INVOICE_ID
				,(SELECT top 1 SHIP_ROW_ID FROM SHIP_ROW WHERE  WRK_ROW_ID = IR.WRK_ROW_RELATION_ID) AS SHIP_ROW_ID
			FROM
				SHIP S,
				INVOICE_ROW IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT PU
			WHERE
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
				<cfif not isdefined('arguments.is_cost_zero_row') or arguments.is_cost_zero_row neq 1>
				I.GROSSTOTAL > 0 AND
				</cfif>
				I.IS_IPTAL = 0
				<cfif GET_NOT_DEP_COST.RECORDCOUNT>
				AND I.INVOICE_ID NOT IN 
					( SELECT INVOICE_ID FROM INVOICE WHERE
					<cfset rw_count=0>
					<cfloop query="GET_NOT_DEP_COST">
						<cfset rw_count=rw_count+1>
						(INVOICE.DEPARTMENT_LOCATION =#GET_NOT_DEP_COST.LOCATION_ID# AND INVOICE.DEPARTMENT_ID =#GET_NOT_DEP_COST.DEPARTMENT_ID#)
						<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
					</cfloop>
					)
				</cfif>
			ORDER BY
				ACTION_DATE,I.PURCHASE_SALES,I.INVOICE_ID,IR.PRODUCT_ID,IR.INVOICE_ROW_ID
		</cfquery>
	<cfelse>
		<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
			SELECT DISTINCT
			 <cfif arguments.tax_inc IS 1>
				 (IR.NETTOTAL / IR.AMOUNT * (CASE I.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) END) * (1 + (TAX/100))) <cfif GET_INVOICE_COMPARISON.RECORDCOUNT and GET_DIFF_INV.RECORDCOUNT><cfif listfind('48,50,58',GET_DIFF_INV.INVOICE_CAT)>-<cfelse>+</cfif> #GET_DIFF_INV.INV_DIFF_PRICE#</cfif> PRICE,
			 <cfelse>
				 (IR.NETTOTAL / IR.AMOUNT * (CASE I.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) END)) <cfif GET_INVOICE_COMPARISON.RECORDCOUNT and GET_DIFF_INV.RECORDCOUNT><cfif listfind('48,50,58',GET_DIFF_INV.INVOICE_CAT)>-<cfelse>+</cfif> #GET_DIFF_INV.INV_DIFF_PRICE#</cfif> PRICE,
			 </cfif>
				IR.COST_PRICE COST_PRICE,
				IR.AMOUNT,
				IR.SPECT_VAR_ID,
				IR.STOCK_ID,
				IR.PRODUCT_ID,
				IR.INVOICE_ROW_ID,
				ISNULL(IR.EXTRA_COST,0) EXTRA_COST,
				0 as LABOR_COST_SYSTEM,
				0 as STATION_REFLECTION_COST_SYSTEM,
				PU.MULTIPLIER,
				ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
				I.PURCHASE_SALES PURCHASE_SALES,
				I.INVOICE_CAT ACTION_CAT,
				I.PROCESS_CAT,
				I.RECORD_DATE,
				I.DEPARTMENT_ID ACT_DEPARTMENT_ID,
				I.DEPARTMENT_LOCATION ACT_LOCATION_ID,
				S.SHIP_ID,	
				I.INVOICE_DATE,
				I.PURCHASE_SALES,
				I.INVOICE_ID
				,(SELECT top 1  SHIP_ROW_ID FROM SHIP_ROW WHERE WRK_ROW_RELATION_ID  = IR.WRK_ROW_ID) AS SHIP_ROW_ID
			FROM 
				SHIP S,
				INVOICE_SHIPS INV_SHIP,
				INVOICE_ROW IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT PU
			WHERE
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
				<cfif not isdefined('arguments.is_cost_zero_row') or arguments.is_cost_zero_row neq 1>
				I.GROSSTOTAL > 0 AND
				</cfif>
				I.IS_IPTAL = 0
				<cfif GET_NOT_DEP_COST.RECORDCOUNT>
				AND I.INVOICE_ID NOT IN 
					( SELECT INVOICE_ID FROM INVOICE WHERE
					<cfset rw_count=0>
					<cfloop query="GET_NOT_DEP_COST">
						<cfset rw_count=rw_count+1>
						(INVOICE.DEPARTMENT_LOCATION = #GET_NOT_DEP_COST.LOCATION_ID# AND INVOICE.DEPARTMENT_ID =#GET_NOT_DEP_COST.DEPARTMENT_ID#)
						<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
					</cfloop>
					)
				</cfif>
			ORDER BY 
				ACTION_DATE,I.PURCHASE_SALES,I.INVOICE_ID,IR.PRODUCT_ID,IR.INVOICE_ROW_ID
		</cfquery>
	</cfif>
<cfelseif isdefined('arguments.action_type') and arguments.action_type eq 2>
	<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
		SELECT
		 <cfif arguments.tax_inc IS 1>
			 (SR.NETTOTAL / SR.AMOUNT) * (1 + (TAX/100)) PRICE,<!---  * (1 - (ISNULL(S.SA_DISCOUNT,0) / S.GROSSTOTAL) KALDIRDIK CUNKU NULL GELİYOR --->
		 <cfelse>
			 (SR.NETTOTAL / SR.AMOUNT) PRICE, <!---  * (1 - (ISNULL(S.SA_DISCOUNT,0) / S.GROSSTOTAL))  KALDIRDIK CUNKU NULL GELİYOR --->
		 </cfif>
		 	ISNULL(SR.COST_PRICE,0) COST_PRICE,
			SR.AMOUNT,
			SR.SPECT_VAR_ID,
			SR.STOCK_ID,
			SR.PRODUCT_ID,
			ISNULL(SR.EXTRA_COST,0) EXTRA_COST,
			SR.SHIP_ROW_ID,
			0 as LABOR_COST_SYSTEM,
			0 as STATION_REFLECTION_COST_SYSTEM,
			PU.MULTIPLIER,
			ISNULL(S.DELIVER_DATE,S.SHIP_DATE) ACTION_DATE,
			S.PURCHASE_SALES PURCHASE_SALES,
			S.SHIP_TYPE ACTION_CAT,
			S.PROCESS_CAT,
			S.RECORD_DATE,
			S.DEPARTMENT_IN ACT_DEPARTMENT_ID,
			S.LOCATION_IN ACT_LOCATION_ID,
			S.DELIVER_STORE_ID ACT_OUT_DEPARTMENT_ID,
			S.LOCATION ACT_OUT_LOCATION_ID,
			SR.TAX,
			S.SHIP_ID
		FROM 
			SHIP_ROW SR,
			SHIP S,
			#dsn3_alias#.PRODUCT_UNIT PU
		WHERE
			S.SHIP_ID = SR.SHIP_ID AND
			<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
				S.SHIP_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
			</cfif>
			<!---<cfif isdefined('arguments.action_row_id') and arguments.action_row_id gt 0>
                SR.SHIP_ROW_ID = <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"> AND
            </cfif>  PY 99284--->
			<cfif arguments.is_product_stock is 1>
				SR.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
			<cfelseif arguments.is_product_stock is 2>
				SR.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND		
			</cfif>
			SR.PRODUCT_ID = PU.PRODUCT_ID AND 
			SR.UNIT = PU.ADD_UNIT
			<cfif not isdefined('arguments.is_cost_zero_row') or arguments.is_cost_zero_row neq 1>
			AND (S.GROSSTOTAL > 0 OR SR.COST_PRICE > 0)<!--- TUTAR 0 OLABİLİR AMA İADELER COST_PRICE DAN OLUŞUR --->
			</cfif>
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
			ACTION_DATE,S.PURCHASE_SALES,S.SHIP_ID,SR.PRODUCT_ID,SR.SHIP_ROW_ID
	</cfquery>
<cfelseif isdefined('arguments.action_type') and arguments.action_type eq 3>
	<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
		SELECT
		 <cfif arguments.tax_inc IS 1>
			 (SFR.NET_TOTAL / SFR.AMOUNT * (1 + (SFR.TAX/100))) PRICE,
		 <cfelse>
			 (SFR.NET_TOTAL / SFR.AMOUNT) PRICE,
		 </cfif>
		 	SFR.COST_PRICE COST_PRICE,
			SFR.AMOUNT AMOUNT,
			SFR.SPECT_VAR_ID,
			ISNULL(SFR.EXTRA_COST,0) EXTRA_COST,
			0 as LABOR_COST_SYSTEM,
			0 as STATION_REFLECTION_COST_SYSTEM,
            SFR.STOCK_FIS_ROW_ID,
			PU.MULTIPLIER MULTIPLIER,
			ISNULL(SF.DELIVER_DATE,SF.FIS_DATE) ACTION_DATE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			0 PURCHASE_SALES,
			SF.FIS_TYPE ACTION_CAT,
			SF.PROCESS_CAT,
			ISNULL(SF.RECORD_DATE,FIS_DATE) RECORD_DATE,
			SF.DEPARTMENT_IN ACT_DEPARTMENT_ID,
			SF.LOCATION_IN ACT_LOCATION_ID,
			SF.DEPARTMENT_OUT ACT_OUT_DEPARTMENT_ID,
			SF.LOCATION_OUT ACT_OUT_LOCATION_ID,
			SFR.TAX
		FROM 
			STOCK_FIS SF,
			STOCK_FIS_ROW SFR,
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_UNIT PU
		WHERE 
			SF.FIS_ID = SFR.FIS_ID AND
			S.STOCK_ID = SFR.STOCK_ID AND
			SF.FIS_TYPE IN (110,114,115,113,1182) AND
			--SF.PROD_ORDER_NUMBER IS NULL AND
		<cfif isdefined('arguments.action_id') and len(arguments.action_id)>
			SF.FIS_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
		</cfif>
		<cfif isdefined('arguments.action_row_id') and arguments.action_row_id gt 0>
			SFR.STOCK_FIS_ROW_ID = <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"> AND
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
		ORDER BY
			ACTION_DATE,S.PRODUCT_ID,SFR.STOCK_FIS_ROW_ID
	</cfquery>
<cfelseif isdefined('arguments.action_type') and arguments.action_type eq 4><!--- Üretim Belgelerden Oluşturma.. --->
	<cfquery name="GET_ACT" datasource="#DSN3#">
		--Yeniden Maliyet Oluşturulacak Üretim Belgesinin Bilgilerini Çekiyoruz!!
		SELECT 
		<!---	DATEADD ( hh , (-1*DATEPART( hh ,DATEADD ( n , (-1*DATEPART( n ,
			DATEADD ( s , (-1*DATEPART( s ,POR.FINISH_DATE)), POR.FINISH_DATE ))), 
			DATEADD ( s , (-1*DATEPART( s ,POR.FINISH_DATE)), POR.FINISH_DATE ) ))), 
			DATEADD ( n , (-1*DATEPART( n ,DATEADD ( s , (-1*DATEPART( s ,POR.FINISH_DATE)), POR.FINISH_DATE ))), 
			DATEADD ( s , (-1*DATEPART( s ,POR.FINISH_DATE)), POR.FINISH_DATE ) ) ) ACTION_DATE,--->
			POR.FINISH_DATE ACTION_DATE,
			PORR.AMOUNT,
			PORR.SPECT_ID SPEC_ID,
			(PORR.PURCHASE_NET_SYSTEM+ISNULL(PORR.PURCHASE_EXTRA_COST_SYSTEM,0)) PRICE,<!--- PORR.PURCHASE_NET_SYSTEM_TOTAL/PORR.AMOUNT --->
			(PORR.PURCHASE_NET_SYSTEM+ISNULL(PORR.PURCHASE_EXTRA_COST_SYSTEM,0)) COST_PRICE,
			(PORR.PURCHASE_NET_2+ISNULL(PORR.PURCHASE_EXTRA_COST_SYSTEM_2,0)) COST_PRICE_2,
            (ISNULL(PORR.LABOR_COST_SYSTEM,0)+ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0)) AS EXTRA_COST,
			ISNULL(PORR.LABOR_COST_SYSTEM,0) as LABOR_COST_SYSTEM,
			ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
			PORR.SPECT_ID SPECT_VAR_ID,
			PU.MULTIPLIER MULTIPLIER,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			0 PURCHASE_SALES,
			PORR.PR_ORDER_ID ACTION_ID,
			171 ACTION_CAT,
			POR.PROCESS_ID PROCESS_CAT,
			ISNULL(POR.UPDATE_DATE,POR.RECORD_DATE) RECORD_DATE,
			POR.PRODUCTION_DEP_ID ACT_DEPARTMENT_ID,
			POR.PRODUCTION_LOC_ID ACT_LOCATION_ID,
			'' ACT_OUT_DEPARTMENT_ID,
			'' ACT_OUT_LOCATION_ID
		FROM 
			PRODUCTION_ORDERS PO,
			PRODUCTION_ORDER_RESULTS POR,
			PRODUCTION_ORDER_RESULTS_ROW PORR,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn3_alias#.PRODUCT_UNIT PU,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
			POR.PR_ORDER_ID = #arguments.action_id#<!--- <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> ---> AND
			<cfif arguments.is_product_stock is 1>
				STOCKS.PRODUCT_ID = #arguments.product_stock_id#<!--- <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> ---> AND
			<cfelseif arguments.is_product_stock is 2>
				STOCKS.STOCK_ID = #arguments.product_stock_id#<!--- <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> ---> AND
			</cfif>
			PO.P_ORDER_ID=POR.P_ORDER_ID AND
			POR.PR_ORDER_ID=PORR.PR_ORDER_ID AND
			STOCKS.STOCK_ID=PORR.STOCK_ID AND
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			STOCKS.PRODUCT_ID = PU.PRODUCT_ID AND 
			PORR.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PRODUCT.IS_COST=1 AND
			PORR.TYPE=1 AND
			ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
			PO.IS_DEMONTAJ<>1
			<cfif GET_NOT_DEP_COST.RECORDCOUNT>
			AND POR.PR_ORDER_ID NOT IN 
				( SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST">
					<cfset rw_count=rw_count+1>
					(PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID =#GET_NOT_DEP_COST.LOCATION_ID# <!--- <cfqueryparam value="" cfsqltype="cf_sql_integer"> ---> AND PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID = #GET_NOT_DEP_COST.DEPARTMENT_ID#<!--- <cfqueryparam value="#GET_NOT_DEP_COST.DEPARTMENT_ID#" cfsqltype="cf_sql_integer"> --->)
					<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
				</cfloop>
				)
			</cfif>
				ORDER BY ACTION_DATE,
                ISNULL((SELECT TOP 1 PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PRODUCT_ID = PORR.PRODUCT_ID AND TYPE=2),0) DESC,
				POR.RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined('arguments.action_type') and listfind('5,7',arguments.action_type,',')><!--- stok ve spec virman --->
	<cfif arguments.action_type eq 5><!--- spec virman --->
		<cfset cost_total_sp = 0>
		<cfset extra_cost_total_sp = 0>
		<cfquery name="GET_MAIN_SP_R_" datasource="#dsn3#">
			SELECT
				PRODUCT_ID
			FROM
				SPECT_MAIN_ROW
			WHERE
				<cfif isdefined('arguments.spec_main_id') and len(arguments.spec_main_id)>
					SPECT_MAIN_ID = #arguments.spec_main_id#
				<cfelse>
					1=0
				</cfif>	
		</cfquery>
		<cfloop from="1" to="#GET_MAIN_SP_R_.RECORDCOUNT#" index="sp_rows">
			<cfquery name="GET_SP_ROW_COST" datasource="#dsn3#">
				SELECT 
					PURCHASE_NET_SYSTEM,
					PURCHASE_EXTRA_COST_SYSTEM,
					PURCHASE_NET_SYSTEM_MONEY
				FROM
					PRODUCT_COST
				WHERE
					PRODUCT_ID = #GET_MAIN_SP_R_.PRODUCT_ID[sp_rows]# AND
					START_DATE <= #CreateODBCDate(arguments.cost_date)# 
					<!--- AND SPECT_MAIN_ID  SPECDE SPEC SECİLDİĞİ ZAMAN burası döndürelecek ve öyle hesaplanacak --->
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC,
					PRODUCT_COST_ID DESC
			</cfquery>
			<cfif GET_SP_ROW_COST.RECORDCOUNT>
				<cfset cost_total_sp = cost_total_sp + GET_SP_ROW_COST.PURCHASE_NET_SYSTEM>
				<cfset extra_cost_total_sp = extra_cost_total_sp + GET_SP_ROW_COST.PURCHASE_EXTRA_COST_SYSTEM>
			<cfelse>
				<cfset GET_SP_ROW_COST.RECORDCOUNT = 0>
			</cfif>
		</cfloop>
	</cfif>
	<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
		SELECT
			STOCK_EXCHANGE.STOCK_EXCHANGE_TYPE,
			STOCK_EXCHANGE.PROCESS_DATE RECORD_DATE,
			STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
			STOCK_EXCHANGE.AMOUNT,
			STOCK_EXCHANGE.SPECT_ID SPECT_VAR_ID,
			<cfif arguments.action_type eq 5>
				#cost_total_sp# PRICE,
				#cost_total_sp# COST_PRICE,
				#extra_cost_total_sp# EXTRA_COST,
			<cfelse>
			((
				SELECT TOP 1 PURCHASE_NET_SYSTEM FROM #dsn3_alias#.PRODUCT_COST
				WHERE
					PRODUCT_ID = STOCK_EXCHANGE.EXIT_PRODUCT_ID AND
					START_DATE <= #CreateODBCDate(arguments.cost_date)# 
					<cfif is_prod_cost_type eq 0>
						AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID,0)
					</cfif>
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC,
					PRODUCT_COST_ID DESC
			)*STOCK_EXCHANGE.EXIT_AMOUNT)/STOCK_EXCHANGE.AMOUNT PRICE,
			((
				SELECT TOP 1 PURCHASE_NET_SYSTEM FROM #dsn3_alias#.PRODUCT_COST
				WHERE
					PRODUCT_ID = STOCK_EXCHANGE.EXIT_PRODUCT_ID AND
					START_DATE <= #CreateODBCDate(arguments.cost_date)# 
					<cfif is_prod_cost_type eq 0>
						AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID,0)
					</cfif>
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC,
					PRODUCT_COST_ID DESC
			)*STOCK_EXCHANGE.EXIT_AMOUNT)/STOCK_EXCHANGE.AMOUNT COST_PRICE,
			((
				SELECT TOP 1 PURCHASE_EXTRA_COST_SYSTEM FROM #dsn3_alias#.PRODUCT_COST 
				WHERE
					PRODUCT_ID = STOCK_EXCHANGE.EXIT_PRODUCT_ID AND
					START_DATE <= #CreateODBCDate(arguments.cost_date)# 
					<cfif is_prod_cost_type eq 0>
						AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID,0)
					</cfif>
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC,
					PRODUCT_COST_ID DESC
			)*STOCK_EXCHANGE.EXIT_AMOUNT)/STOCK_EXCHANGE.AMOUNT EXTRA_COST,
			</cfif>
			0 as LABOR_COST_SYSTEM,
           	0 as STATION_REFLECTION_COST_SYSTEM,
			STOCK_EXCHANGE.SPECT_ID SPECT_ID,
			1 MULTIPLIER,
			STOCK_EXCHANGE.STOCK_ID,
			STOCK_EXCHANGE.PRODUCT_ID,
			0 PURCHASE_SALES,
			STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ID,
			STOCK_EXCHANGE.PROCESS_TYPE ACTION_CAT,
			STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
			STOCK_EXCHANGE.DEPARTMENT_ID ACT_DEPARTMENT_ID,
			STOCK_EXCHANGE.LOCATION_ID ACT_LOCATION_ID
		FROM
			STOCK_EXCHANGE,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
			PRODUCT.PRODUCT_ID = STOCK_EXCHANGE.PRODUCT_ID AND
			<!--- ROW İD OLARAK SATIRI GELİYOR VE MUTLAKA GELİYOR O NEDE İLE KONTROL KOYMADIM--->
			STOCK_EXCHANGE.STOCK_EXCHANGE_ID = <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"> AND
			PRODUCT.IS_COST = 1
			<cfif GET_NOT_DEP_COST.RECORDCOUNT>
			AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID NOT IN 
				( SELECT STOCK_EXCHANGE_ID FROM STOCK_EXCHANGE WHERE
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST">
					<cfset rw_count=rw_count+1>
					(STOCK_EXCHANGE.LOCATION_ID = #GET_NOT_DEP_COST.LOCATION_ID# AND STOCK_EXCHANGE.DEPARTMENT_ID = #GET_NOT_DEP_COST.DEPARTMENT_ID#)
					<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>OR</cfif>
				</cfloop>
				)
			</cfif>
	</cfquery>
<cfelseif isdefined('arguments.action_type') and arguments.action_type eq 8><!--- fiyat farkı ekranlar --->
	<cfquery name="GET_ACT" datasource="#arguments.period_dsn_type#">
		SELECT		
			(
			SELECT TOP 1 PURCHASE_NET_SYSTEM FROM #dsn3_alias#.PRODUCT_COST
			WHERE
				PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID AND
				START_DATE <= PRODUCT_COST_INVOICE.COST_DATE
				<cfif is_prod_cost_type eq 0>
					AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST_INVOICE.SPECT_MAIN_ID,0)
				</cfif>
			ORDER BY
				START_DATE DESC,
				RECORD_DATE DESC,
				PRODUCT_COST_ID DESC
			) PRICE,
			(
				SELECT TOP 1 PURCHASE_NET_SYSTEM FROM #dsn3_alias#.PRODUCT_COST
				WHERE
					PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID AND
					START_DATE <= PRODUCT_COST_INVOICE.COST_DATE
					<cfif is_prod_cost_type eq 0>
						AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST_INVOICE.SPECT_MAIN_ID,0)
					</cfif>
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC,
					PRODUCT_COST_ID DESC
			) COST_PRICE,
			(
				SELECT TOP 1 PURCHASE_EXTRA_COST_SYSTEM FROM #dsn3_alias#.PRODUCT_COST 
				WHERE
					PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID AND
					START_DATE <= PRODUCT_COST_INVOICE.COST_DATE
					<cfif is_prod_cost_type eq 0>
						AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST_INVOICE.SPECT_MAIN_ID,0)
					</cfif>
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC,
					PRODUCT_COST_ID DESC
			) EXTRA_COST,
			0 as LABOR_COST_SYSTEM,
           	0 as STATION_REFLECTION_COST_SYSTEM,
			PRODUCT_COST_INVOICE.RECORD_DATE RECORD_DATE,
			PRODUCT_COST_INVOICE.COST_DATE ACTION_DATE,
			PRODUCT_COST_INVOICE.AMOUNT,
			PRODUCT_COST_INVOICE.SPECT_MAIN_ID,
			PRODUCT_COST_INVOICE.PRODUCT_ID,
			PRODUCT_COST_INVOICE.STOCK_ID,
			INVOICE.PROCESS_CAT,
			ISNULL(PRODUCT_COST_INVOICE.DEPARTMENT_ID,INVOICE.DEPARTMENT_ID) ACT_DEPARTMENT_ID,
			INVOICE.DEPARTMENT_LOCATION ACT_LOCATION_ID,
			INVOICE.INVOICE_ID,
			INVOICE.INVOICE_CAT ACTION_CAT,
			INVOICE.PROCESS_CAT,
			1 MULTIPLIER,
			0 PURCHASE_SALES
		FROM
			PRODUCT_COST_INVOICE,
			INVOICE,
			#DSN1_alias#.PRODUCT PRODUCT
		WHERE
			PRODUCT_COST_INVOICE.INVOICE_ID = <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> AND
			<cfif isdefined('arguments.action_row_id') and arguments.action_row_id gt 0>
				PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID = <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"> AND
			</cfif>
			<cfif arguments.is_product_stock is 1>
				PRODUCT_COST_INVOICE.PRODUCT_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
			<cfelseif arguments.is_product_stock is 2>
				PRODUCT_COST_INVOICE.STOCK_ID = <cfqueryparam value="#arguments.product_stock_id#" cfsqltype="cf_sql_integer"> AND
			</cfif>
			PRODUCT_COST_INVOICE.INVOICE_ID = INVOICE.INVOICE_ID AND
			PRODUCT.PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID
		ORDER BY
			PRODUCT_COST_INVOICE.COST_DATE,
			PRODUCT_COST_INVOICE_ID
	</cfquery>
<cfelseif isdefined('arguments.action_cost_id') and arguments.action_cost_id gt 0>
	<cfquery name="GET_ACT" datasource="#DSN3#" maxrows="1"><!--- PRODUCT_COST D 2 KERE BAGLANİYOR CUNKU TUTARLARI BİR ONCEKİ MALİYET DİGER BİLGİLERİ O MALİYET BİLGİSİNDEN ALIYOR --->
		SELECT
			P.START_DATE ACTION_DATE,
			P.RECORD_DATE,
			P2.PURCHASE_NET_SYSTEM PRICE,
			P2.PURCHASE_NET_SYSTEM COST_PRICE,
			P2.PURCHASE_EXTRA_COST_SYSTEM EXTRA_COST,
			P2.PURCHASE_NET_MONEY,
			P.AVAILABLE_STOCK AMOUNT,<!--- +PARTNER_STOCK+ACTIVE_STOCK --->
			P.SPECT_MAIN_ID,
			P.PRODUCT_ID,
			P2.LABOR_COST_SYSTEM,
			P2.STATION_REFLECTION_COST_SYSTEM,
			1 MULTIPLIER,
			0 PURCHASE_SALES,
			0 ACTION_ID,
			0 ACTION_CAT,
			0 PROCESS_CAT,
			P.DEPARTMENT_ID ACT_DEPARTMENT_ID,
			P.LOCATION_ID ACT_LOCATION_ID
		FROM
			PRODUCT_COST P,
			PRODUCT_COST P2
		WHERE
			P.PRODUCT_COST_ID = <cfqueryparam value="#arguments.action_cost_id#" cfsqltype="cf_sql_integer"> AND
			P2.PRODUCT_ID=P.PRODUCT_ID AND
			ISNULL(P.SPECT_MAIN_ID,0) = ISNULL(P2.SPECT_MAIN_ID,0)           
            <cfif arguments.action_row_id gt 0>AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"></cfif>
            AND (
                <!--- aynı gune eklenmis bir belge olabilir ancak kayit tarihi farkli olabilir --->
                    (
                    	P2.START_DATE	< P.START_DATE
                    )
                    OR
                    (
                    	P2.START_DATE = P.START_DATE
						AND P2.RECORD_DATE <cfif arguments.action_row_id gt 0><=<cfelse> < </cfif>P.RECORD_DATE
                    )
                )
		ORDER BY
			P2.START_DATE DESC,
			P2.RECORD_DATE DESC,
			P2.PRODUCT_COST_ID DESC
	</cfquery>
</cfif>
<!--- <br/>GET_ACT:<CFDUMP var="#GET_ACT#"> --->
<cfif GET_ACT.RECORDCOUNT>
	<cfif GET_ACT.PROCESS_CAT gt 0 and ((not isdefined('arguments.is_cost_field') or not len(arguments.is_cost_field)) or (not isdefined('arguments.is_cost_zero_row') or not len(arguments.is_cost_zero_row)))>
		<!--- parametrelerden 0 tutarlı satırlar maliyet oluştursun ve maliyet alanı gelmez ise tanımlanması için bu blok var ( gelmeme durumuda güncelleme idi ancak düzenledik artık geliyor bir süre ne olur ne olmaz adına bekleyecek) --->
		<cfquery name="GET_PROCESS_F" datasource="#DSN3#">
			SELECT 
				PROCESS_TYPE,
				IS_COST,
				IS_COST_ZERO_ROW,
				IS_COST_FIELD
			FROM
				SETUP_PROCESS_CAT 
			WHERE 
				PROCESS_CAT_ID = <cfqueryparam value="#GET_ACT.PROCESS_CAT#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif GET_PROCESS_F.RECORDCOUNT>
			<cfset arguments.is_cost_field = GET_PROCESS_F.IS_COST_FIELD>
			<cfset arguments.is_cost_zero_row = GET_PROCESS_F.IS_COST_ZERO_ROW>
		<cfelse>
			<cfset arguments.is_cost_field = 0>
			<cfset arguments.is_cost_zero_row = 1>
		</cfif>
	<cfelse>
		<cfif not isdefined('arguments.is_cost_field') or not len(arguments.is_cost_field)><cfset arguments.is_cost_field = 0></cfif>
		<cfif not isdefined('arguments.is_cost_zero_row') or not len(arguments.is_cost_zero_row)><cfset arguments.is_cost_zero_row = 1></cfif>
	</cfif>
	<cfscript>
		//belge ise belgedeki değil ise tarihdeki kurlar
		rate_list_fonk=get_cost_rate(action_id : arguments.action_id,
								action_type : arguments.action_type,
								action_date : createodbcdate(GET_ACT.ACTION_DATE),
								dsn_period_money : arguments.period_dsn_type,
								dsn_money : DSN);
		if(isdefined('rate_list_fonk') and listfind(rate_list_fonk,arguments.cost_money,';'))
			rate_cost_money=listgetat(rate_list_fonk,listfind(rate_list_fonk,arguments.cost_money,';')-1,';');
		else
			rate_cost_money=1;
		if(isdefined('rate_list_fonk') and listfind(rate_list_fonk,arguments.cost_money_system_2,';'))
			rate_system_2=listgetat(rate_list_fonk,listfind(rate_list_fonk,arguments.cost_money_system_2,';')-1,';');
		else
			rate_system_2=1;
		system_money_total_cost2 = 0;
		system_money_total_cost = 0;
		system_money_total_cost_extra = 0;
		system_money_total_cost_reflection = 0;
		system_money_total_cost_labor = 0;
		stock_cost_system = 0;
		stock_cost_extra_system = 0;
		stock_amount_total = 0;
	</cfscript>
	<!---  <br/>OUTPUT ONCESI GET_ACT:<cfdump var="#GET_ACT#"><br/> --->
	<cfif not ListFind('113',GET_ACT.ACTION_CAT,',')><!--- ambar ve depolararası sevkde hesaplanmasına gerek yok direk önceki maliyet tutarı ne ise o alınacaktır genel maliyet olarak--->
		<cfoutput query="GET_ACT">
			<!--- eğer fiyat farkı dağılım erkranı ile geliyorsa aynı ürün seçili olabilir budurumda queryden tutarın gelmesi doğru olmuyor her satır için tarihine göre çekilmeli 
			<cfif isdefined('arguments.action_type') and arguments.action_type eq 8>
				<cfquery name="GET_COST_PRICE" datasource="#DSN3#">
					SELECT TOP 1 
						PURCHASE_NET_SYSTEM,
						PURCHASE_EXTRA_COST_SYSTEM
					FROM 
						PRODUCT_COST
					WHERE
						PRODUCT_ID = GET_ACT.PRODUCT_ID AND
						START_DATE <= #CreateODBCDate(GET_COST_PRICE.ACTION_DATE)# 
						AND	ISNULL(SPECT_MAIN_ID,0) = <cfif len(GET_ACT.SPECT_MAIN_ID)>#GET_ACT.SPECT_MAIN_ID#<cfelse>0</cfif>
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				</cfquery>
				<cfset COST_PRICE =GET_COST_PRICE.PURCHASE_NET_SYSTEM>
				<cfset PRICE =GET_COST_PRICE.PURCHASE_NET_SYSTEM>
				<cfset EXTRA_COST =GET_COST_PRICE.PURCHASE_EXTRA_COST_SYSTEM>
			</cfif>--->
			<!--- eğer satır id gelmiyorsa belgede belgedeki aynı ürünler toplanarak ortak maliyet ekleniyordu --->
			<cfscript>
				if(listfind('55,54,73,74,114,115,110,81',ACTION_CAT,',') or arguments.is_cost_field eq 1)//iade odugunda yada islem kategorisinden maliyet alanlarından calış denildi ise maliyet alani fiyat gibi islem gormeli acilis fiside maliyet alanindan yapmali
					price_system=iif(len(COST_PRICE),COST_PRICE,0);
				else 
					price_system=PRICE;
				if(price_system lte 0) price_system=0;
				if(not len(amount) or amount eq '') amount_ = 1; else amount_ = amount;
				if(not len(multiplier) or multiplier eq '') multiplier_ = 1; else multiplier_ = multiplier;
				stock_amount_row = amount_ * multiplier_;//satırdaki miktar
				system_money_cost_row = price_system * stock_amount_row;//satır toplam tutarı
				system_money_total_cost = system_money_cost_row + system_money_total_cost;
				stock_amount_total = stock_amount_total + stock_amount_row;
				if(isdefined("COST_PRICE_2") and len(COST_PRICE_2))
					system_money_total_cost2 = COST_PRICE_2*stock_amount_row;
				extra_cost_system_ = EXTRA_COST;
				if(len(EXTRA_COST))
					system_money_cost_extra_row = EXTRA_COST * stock_amount_row;//satır ekstra toplam tutar
				else
					system_money_cost_extra_row = 0;
					if(len(station_reflection_cost_system))
					system_money_cost_reflection_row = station_reflection_cost_system * stock_amount_row;//satır ekstra toplam tutar
				else
					system_money_cost_reflection_row = 0;
				if(len(labor_cost_system))
					system_money_cost_labor_row = labor_cost_system * stock_amount_row;//satır ekstra toplam tutar
				else
					system_money_cost_labor_row = 0;
				system_money_total_cost_extra = system_money_total_cost_extra + system_money_cost_extra_row;
				system_money_total_cost_reflection = system_money_total_cost_reflection + system_money_cost_reflection_row;
				system_money_total_cost_labor = system_money_total_cost_labor + system_money_cost_labor_row;
				system_station_reflection_cost = station_reflection_cost_system;
				system_labor_cost = labor_cost_system;
				//writeoutput("#stock_amount_total#<br>");
				//writeoutput('BURDA--Sistem Fiyatı(price_system)=#system_money_total_cost#<br/>Toplam Sistem Fiyatı(system_money_total_cost)=#system_money_total_cost#<br/>Satır Miktar(stock_amount_row)=#stock_amount_row#<br/>Toplam Miktar(stock_amount_total)= #stock_amount_total#<br/>Satır Ek Maliyet(system_money_cost_extra_row) = #system_money_cost_extra_row#<br/>Toplam Ek Maliyet(system_money_total_cost_extra) = #system_money_total_cost_extra#<br/>');
			</cfscript>
		</cfoutput>
       <!--- .<br/> GET_ACT BITTI DEVAM....<br/> --->
		<cfscript>
			//belgedeki birim maliyetler
			if(stock_amount_total gt 0)
			{
				stock_cost_system = system_money_total_cost / stock_amount_total;
				if(isdefined("system_money_total_cost2"))
					stock_cost_system2 = system_money_total_cost2 / stock_amount_total;
				stock_cost_extra_system = system_money_total_cost_extra / stock_amount_total;
				stock_cost_reflection_system = system_money_total_cost_reflection / stock_amount_total;
				stock_cost_labor_system = system_money_total_cost_labor / stock_amount_total;
				//writeoutput('XXX system_money_total_cost = #system_money_total_cost#/#stock_amount_total#===#stock_cost_system#');
			}
			else if(stock_amount_total is 0)
			{
				stock_cost_system = 0;
				stock_cost_system2 = 0;
				stock_cost_extra_system = 0;
				stock_cost_reflection_system = 0;
				stock_cost_labor_system = 0;
			}
			if(isdefined('arguments.action_type') and arguments.action_type eq 4)
				stock_cost_system_2 = stock_cost_system2;
			else
				stock_cost_system_2 = stock_cost_system / rate_system_2;
			stock_cost_extra_system_2 = wrk_round(stock_cost_extra_system / rate_system_2,8);
			stock_cost_reflection_system_2 = wrk_round(stock_cost_reflection_system / rate_system_2,8);
			stock_cost_labor_system_2 = wrk_round(stock_cost_labor_system / rate_system_2,8);
			stock_cost = stock_cost_system / rate_cost_money;
			stock_cost_extra = stock_cost_extra_system / rate_cost_money;
			stock_cost_reflection = stock_cost_reflection_system / rate_cost_money;
			stock_cost_labor = stock_cost_labor_system / rate_cost_money;
			//writeoutput('XXX stock_cost_system_2 = #stock_cost_system_2#/');
			//writeoutput('XXX stock_cost = #stock_cost_system#/#rate_cost_money#===#stock_cost#');
		</cfscript>
	<cfelse>
		<cfoutput query="GET_ACT">
			<!--- depolararası sevk v.s. ise dönmesi sırasında sadece miktar yeterli --->
			<cfscript>
				stock_amount_row = amount * multiplier;//satırdaki miktar
				stock_amount_total = stock_amount_total + stock_amount_row;
			</cfscript>
		</cfoutput>
	</cfif>
	<!--- şirket akış parametrelerinde 0 tutarlı satırlar maliyet oluştursun dendi ise blok çalışacaktır. not:iadeler, devir,sayım ve üretimden cıkış fişleri için geçerli değil 0 ise ne olursa olsun maliyet oluşmaz--->
	<cfif (arguments.is_cost_zero_row eq 0 and stock_cost_system gt 0) or arguments.is_cost_zero_row eq 1>
		<cfif (listfind('55,54,73,74,114,110,115',GET_ACT.ACTION_CAT,',') and stock_cost_system gt 0) or not listfind('55,54,73,74,114,110,115',GET_ACT.ACTION_CAT,',')>
			<!--- agirlikli ortalama da bir onceki maliyetti bulunuyor ayrıca depelararası sevk,ambar ve diğer tiplerdede bu tutar belge tutarı olarak kullanılıyor--->
			<cfquery name="GET_NEW_COST_ALL" datasource="#DSN3#">
                SELECT
					PRODUCT_COST_ID,
					PRODUCT_COST,
					PURCHASE_NET,
					PURCHASE_NET_MONEY,
					PURCHASE_EXTRA_COST,
					PRICE_PROTECTION,
					PRICE_PROTECTION_MONEY,
					PRICE_PROTECTION_TYPE,
					PURCHASE_NET_SYSTEM,
					PURCHASE_NET_SYSTEM_MONEY,
					PURCHASE_EXTRA_COST_SYSTEM,
					PRODUCT_COST_SYSTEM,
					PURCHASE_NET_SYSTEM_2,
					PURCHASE_NET_SYSTEM_MONEY_2,
					PURCHASE_EXTRA_COST_SYSTEM_2,
					PRODUCT_COST_LOCATION,
					PURCHASE_NET_LOCATION,
					PURCHASE_NET_MONEY_LOCATION,
					PURCHASE_EXTRA_COST_LOCATION,
					PRICE_PROTECTION_LOCATION,
					PRICE_PROTECTION_MONEY_LOCATION,
					PURCHASE_NET_SYSTEM_LOCATION,
					PURCHASE_NET_SYSTEM_MONEY_LOCATION,
					PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
					PURCHASE_NET_SYSTEM_2_LOCATION,
					PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
					PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
                    PRODUCT_COST_DEPARTMENT,
					PURCHASE_NET_DEPARTMENT,
					PURCHASE_NET_MONEY_DEPARTMENT,
					PURCHASE_EXTRA_COST_DEPARTMENT,
					PRICE_PROTECTION_DEPARTMENT,
					PRICE_PROTECTION_MONEY_DEPARTMENT,
					PURCHASE_NET_SYSTEM_DEPARTMENT,
					PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
					PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
					PURCHASE_NET_SYSTEM_2_DEPARTMENT,
					PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,
					PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,
					ISNULL(UPDATE_DATE,RECORD_DATE) AS UPDATE_DATE,
					RECORD_DATE,
					START_DATE,
					PRODUCT_ID,
					DEPARTMENT_ID,
					LOCATION_ID,
					ACTION_AMOUNT,
					ISNULL(ACTION_ROW_ID,0) ACTION_ROW_ID,
					ACTION_TYPE,
					ACTION_PROCESS_TYPE,
					ISNULL(ACTION_ID,0) ACTION_ID,
					PURCHASE_NET_ALL,
					PURCHASE_NET_SYSTEM_ALL,
					PURCHASE_NET_SYSTEM_2_ALL,
					ISNULL(STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
                    ISNULL(LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM,
                    ISNULL(STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,0) STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,
                    ISNULL(LABOR_COST_SYSTEM_DEPARTMENT,0) LABOR_COST_SYSTEM_DEPARTMENT,
                    ISNULL(STATION_REFLECTION_COST_SYSTEM_LOCATION,0) STATION_REFLECTION_COST_SYSTEM_LOCATION,
                    ISNULL(LABOR_COST_SYSTEM_LOCATION,0) LABOR_COST_SYSTEM_LOCATION,
                    ISNULL(STATION_REFLECTION_COST,0) STATION_REFLECTION_COST,
                    ISNULL(STATION_REFLECTION_COST_SYSTEM_2,0) STATION_REFLECTION_COST_SYSTEM_2,
                    ISNULL(STATION_REFLECTION_COST_LOCATION,0) STATION_REFLECTION_COST_LOCATION,
                    ISNULL(STATION_REFLECTION_COST_SYSTEM_2_LOCATION,0) STATION_REFLECTION_COST_SYSTEM_2_LOCATION,
                    ISNULL(STATION_REFLECTION_COST_DEPARTMENT,0) STATION_REFLECTION_COST_DEPARTMENT,
                    ISNULL(STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT,0) STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT,
                    ISNULL(LABOR_COST,0) LABOR_COST,
                    ISNULL(LABOR_COST_SYSTEM_2,0) LABOR_COST_SYSTEM_2,
                    ISNULL(LABOR_COST_LOCATION,0) LABOR_COST_LOCATION,
                    ISNULL(LABOR_COST_SYSTEM_2_LOCATION,0) LABOR_COST_SYSTEM_2_LOCATION,
                    ISNULL(LABOR_COST_DEPARTMENT,0) LABOR_COST_DEPARTMENT,
                    ISNULL(LABOR_COST_SYSTEM_2_DEPARTMENT,0) LABOR_COST_SYSTEM_2_DEPARTMENT
				FROM
					PRODUCT_COST
				WHERE
					PRODUCT_ID = #GET_ACT.PRODUCT_ID#<!--- <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer"> --->
					AND START_DATE <= #createodbcdatetime(GET_ACT.ACTION_DATE)# <!--- <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> --->
					<cfif isdefined('arguments.spec_main_id') and len(arguments.spec_main_id)>
						AND SPECT_MAIN_ID =#arguments.spec_main_id# <!--- <cfqueryparam value="#arguments.spec_main_id#" cfsqltype="cf_sql_integer"> --->
					<cfelseif is_prod_cost_type eq 0>
						AND ISNULL(IS_SPEC,0)=0
					</cfif>
					<cfif isdefined('arguments.stock_id') and len(arguments.stock_id) and is_stock_based_cost eq 1>
						AND STOCK_ID =#arguments.stock_id#
					<cfelseif is_stock_based_cost eq 0>
						AND STOCK_ID IS NULL
					</cfif>
					<cfif isdefined("arguments.control_type") and arguments.control_type eq -2>
						AND ACTION_TYPE = -2
					</cfif>
					<cfif isdefined('arguments.action_row_id') and arguments.action_row_id gt 0>
						AND ISNULL(ACTION_ROW_ID,0) <> #arguments.action_row_id#<!--- <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"> --->
					<cfelse>
						AND ISNULL(ACTION_ID,0) <> #arguments.action_id#<!--- <cfqueryparam value="#arguments.action_id#" cfsqltype="cf_sql_integer"> ---><!--- ELLEDE EKLENMİS BİR MALİYET OLABİLİR DİYE ISNULL VAR --->
					</cfif>
					<cfif isdefined('arguments.action_comp_period_list') and arguments.action_comp_period_list gt 0>
						AND ACTION_PERIOD_ID IN (#arguments.action_comp_period_list#)
					</cfif>
			</cfquery>
 			<!---  GET_NEW_COST_ALL:<CFDUMP var="#GET_NEW_COST_ALL#"><!--- ---> --->
			<!--- konsinye ürünlerde mal konsinye cıkış yapsa bile fatura kesilmedikce hala stoğumdadır --->
			<cfquery name="GET_STOCK_KONSINYE_ALL" datasource="#arguments.period_dsn_type#">
				SELECT
					ISNULL(SUM(INVOICE_AMOUNT),0) AS TOTAL_KONSINYE,
					PRODUCT_ID,
					ISNULL(SPECT_MAIN_ID,0) SPECT_MAIN_ID,
					DEPARTMENT_ID,
					LOCATION_ID
				FROM
					GET_CONSIGMENT_PRODUCT_SALE
				WHERE
					PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer"> AND 
					ACTION_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
					<cfif GET_NOT_DEP_COST.RECORDCOUNT>
					AND
						( 
						<cfset rw_count=0>
						<cfloop query="GET_NOT_DEP_COST">
							<cfset rw_count=rw_count+1>
							NOT (LOCATION_ID =#GET_NOT_DEP_COST.LOCATION_ID# AND DEPARTMENT_ID =#GET_NOT_DEP_COST.DEPARTMENT_ID#)
							<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif>
						</cfloop>
						)
					</cfif>
				GROUP BY
					PRODUCT_ID,
					SPECT_MAIN_ID,
					DEPARTMENT_ID,
					LOCATION_ID
			</cfquery>
			<!--- ürün için tüm stok miktarı ancak konsinye hareketler hariç çünkü onlar fatura kesilmiş kesilmemiş olarak bulunacak ve ona göre eklenecek --->
			<!--- Verilen Belge Tarihinden  --->
            
            <cfquery name="GET_STOCK_ACT_ALL" datasource="#arguments.period_dsn_type#">
				IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME = '####GET_STOCK_ACT_ALL_REPORT')
                BEGIN
               		SELECT * FROM ####GET_STOCK_ACT_ALL_REPORT WHERE PRODUCT_ID = #GET_ACT.PRODUCT_ID# AND PROCESS_DATE <= #createodbcdatetime(GET_ACT.ACTION_DATE)# 
                END
                ELSE
                BEGIN
                    SELECT
                        SUM(STOCK_IN - STOCK_OUT) AS AMOUNT_ALL,
                        PRODUCT_ID,
                        <cfif is_stock_based_cost eq 1>
                        STOCK_ID,
                        </cfif>
                        STORE_LOCATION LOCATION_ID,
                        STORE DEPARTMENT_ID,
                        ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID,
                        ISNULL(PROCESS_TIME,PROCESS_DATE) PROCESS_DATE,
                        PROCESS_TYPE,
                        STOCK_IN
                    FROM
                        STOCKS_ROW
                    WHERE
                        PRODUCT_ID = #GET_ACT.PRODUCT_ID# <!--- <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer"> --->
                        AND ISNULL(PROCESS_TIME,PROCESS_DATE) <= #createodbcdatetime(GET_ACT.ACTION_DATE)#<!--- <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> --->
                        AND PROCESS_TYPE NOT IN (72,75) <!--- konsinye çıkış faturası kesilmemiş olanlar --->
                    GROUP BY
                        PRODUCT_ID,
                        <cfif is_stock_based_cost eq 1>
                        STOCK_ID,
                        </cfif>
                        STORE_LOCATION,
                        STORE,
                        ISNULL(SPECT_VAR_ID,0),
						PROCESS_TIME,
                        PROCESS_DATE,
                        PROCESS_TYPE,
                        STOCK_IN
                UNION ALL
                <!--- br onceki donemden devretmesi gereken faturalandırılmamıs cıkıs konsinye irsaliyelerindeki miktarda maliyet hesabına katılıyor --->
                    SELECT
                        SUM(STOCK_IN - STOCK_OUT) AS AMOUNT_ALL,
                        PRODUCT_ID,
                        <cfif is_stock_based_cost eq 1>
                        STOCK_ID,
                        </cfif>
                        LOCATION_ID,
                        DEPARTMENT_ID,
                        ISNULL(SPECT_MAIN_ID,0) AS SPECT_VAR_ID,
                        ACTION_DATE AS PROCESS_DATE,
                        72 AS PROCESS_TYPE,
                        STOCK_IN
                    FROM
                        GET_PRE_PERIOD_CONSIGMENT_DETAIL
                    WHERE
                        PRODUCT_ID = #GET_ACT.PRODUCT_ID#
                        AND ACTION_DATE <= #createodbcdatetime(GET_ACT.ACTION_DATE)#
                    GROUP BY
                        PRODUCT_ID,
                        <cfif is_stock_based_cost eq 1>
                        STOCK_ID,
                        </cfif>
                        LOCATION_ID,
                        DEPARTMENT_ID,
                        ISNULL(SPECT_MAIN_ID,0),
                        ACTION_DATE,
                        STOCK_IN
			END
            
            </cfquery>
<!---            <br/> GET_STOCK_ACT_ALL:<cfdump var="#GET_STOCK_ACT_ALL#"> <!--- ---> --->
			<cfquery name="GET_COST_1" dbtype="query" maxrows="1"><!--- agirlikli ortalama da bir onceki maliyetti alıyor (specli olsa bile GET_NEW_COST_ALL de spec koşulu olduğundan burda gerek yok)--->	
				SELECT
					*
				FROM
					GET_NEW_COST_ALL
				WHERE
					PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
					<cfif arguments.action_row_id gt 0>AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"></cfif>
					AND (
						<!--- aynı gune eklenmis bir belge olabilir ancak kayit tarihi farkli olabilir --->
							(
							START_DATE < <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							)
							OR
							(
                                (
                                START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
								<!--- <cfif len(GET_ACT.RECORD_DATE)>
									AND RECORD_DATE <cfif arguments.action_row_id gt 0><=<cfelse> < </cfif><cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp">
								</cfif>20140826 Kaldirildi --->
                                <cfif arguments.action_row_id gt 0 and len(arguments.action_id)>
                                <!--- aynı belgede aynı urunden birden fazla satır varsa, ilk satırın maliyetini yazarken bir sonraki satıra ait maliyeti gormemesi icin --->
                                AND ( ACTION_ID <> #arguments.action_id# OR (ACTION_ROW_ID < #arguments.action_row_id# AND ACTION_ID=#arguments.action_id#))
								</cfif>
                                )
                            )
						)
				ORDER BY 
					START_DATE DESC, 
					<!--- UPDATE_DATE DESC, --->
					PRODUCT_COST_ID DESC
			</cfquery>
<!--- 			 <br/>GET_NEW_COST_ALL:<CFDUMP var="#GET_NEW_COST_ALL#"> --->
			<!---  <br/>daha once eklenmis maliyet var GET_COST_1:<CFDUMP var="#GET_COST_1#"> --->
			<cfif not GET_COST_1.RECORDCOUNT><!--- eğer tarihlerden öütür bir maliye bulamaz ise küçük eşit olsun yeter maliyeti alması için --->
				<cfquery name="GET_COST_1" dbtype="query" maxrows="1">
					SELECT
						*
					FROM
						GET_NEW_COST_ALL
					WHERE
						PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
						AND START_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
					ORDER BY 
						START_DATE DESC, 
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				</cfquery>
             <!--- <br/>diger get_cost_1... <cfoutput>#arguments.action_row_id#</cfoutput>----<cfdump var="#GET_COST_1#"> --->
			</cfif>
		<!--- maliyet kayıt tarihindeki stok işlemleri ve konsinyeye göre anlık stok bulunuyor --->
			<!--- ürün stoğunu buluyoruz spec li ve specsiz olarak if else bloklarında --->
			<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
				<!--- o gün içerisinde yapılan stok hareketleri ancak depolar arası sevk hariç--->
				<cfquery name="GET_STOCK_ACT" datasource="#arguments.period_dsn_type#">
					SELECT
						 SUM(STOCK_IN - STOCK_OUT) AMOUNT,
						PRODUCT_ID
					FROM
						STOCKS_ROW
					WHERE
						PROCESS_TIME = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> 
						AND  PRODUCT_ID = #GET_ACT.PRODUCT_ID#
						AND PROCESS_TYPE NOT IN (72,75)
						<cfif is_prod_cost_type eq 0>
							AND (SPECT_VAR_ID IS NULL OR SPECT_VAR_ID = 0)
						</cfif>
						<cfif isdefined('arguments.stock_id') and len(arguments.stock_id) and is_stock_based_cost eq 1>
							AND STOCK_ID =#arguments.stock_id#
						</cfif>
						<cfif isdefined("get_act.ship_row_id") and len(get_act.ship_row_id)>
							AND ROW_ID >  #get_act.ship_row_id#
							AND UPD_ID = #GET_ACT.SHIP_ID# 
						</cfif>
						<cfif GET_NOT_DEP_COST.RECORDCOUNT>
						AND
							( 
							<cfset rw_count=0>
							<cfloop query="GET_NOT_DEP_COST">
								<cfset rw_count=rw_count+1>
								NOT (STORE_LOCATION = #GET_NOT_DEP_COST.LOCATION_ID# AND STORE =#GET_NOT_DEP_COST.DEPARTMENT_ID#)
								<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif>
							</cfloop>
							)
						</cfif>
					GROUP BY
						PRODUCT_ID
				</cfquery>
				<!--- konsinye miktarı --->
				<cfquery name="GET_STOCK_KONSINYE" dbtype="query">
					SELECT 
						SUM(TOTAL_KONSINYE) TOTAL_KON
					FROM 
						GET_STOCK_KONSINYE_ALL 
					<cfif is_prod_cost_type eq 0>
					WHERE
						SPECT_MAIN_ID = 0
					</cfif>
				</cfquery>
			<cfelse>
				<cfif isdefined('arguments.spec_id') and len(arguments.spec_id)>
					<cfquery name="GET_SPEC_" datasource="#DSN3#">
						SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam value="#arguments.spec_id#" cfsqltype="cf_sql_integer">
					</cfquery>
				<cfelse>
					<cfset GET_SPEC_.SPECT_MAIN_ID=arguments.spec_main_id>
				</cfif>
				<!--- o gün içerisinde yapılan stok hareketleri ancak depolar arası sevk hariç--->
				<cfquery name="GET_STOCK_ACT" datasource="#arguments.period_dsn_type#">
					SELECT
						 SUM(STOCK_IN - STOCK_OUT) AMOUNT,
						PRODUCT_ID,
						SPECT_VAR_ID
					FROM
						STOCKS_ROW
					WHERE
						PROCESS_TIME = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> 
						AND SPECT_VAR_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
						AND  PRODUCT_ID = #GET_ACT.PRODUCT_ID#
						AND PROCESS_TYPE NOT IN (72,75)
						<cfif isdefined("get_act.ship_row_id") and len(get_act.ship_row_id)>
							AND ROW_ID >  #get_act.ship_row_id#
							AND UPD_ID = #GET_ACT.SHIP_ID# 
						</cfif>
						<cfif GET_NOT_DEP_COST.RECORDCOUNT>
						AND
							( 
							<cfset rw_count=0>
							<cfloop query="GET_NOT_DEP_COST">
								<cfset rw_count=rw_count+1>
								NOT (STORE_LOCATION = #GET_NOT_DEP_COST.LOCATION_ID# AND STORE =#GET_NOT_DEP_COST.DEPARTMENT_ID#)
								<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif>
							</cfloop>
							)
						</cfif>
					GROUP BY
						PRODUCT_ID,
						SPECT_VAR_ID
				</cfquery>
				<cfquery name="GET_STOCK_KONSINYE" dbtype="query">
					SELECT 
						SUM(TOTAL_KONSINYE) TOTAL_KON
					FROM 
						GET_STOCK_KONSINYE_ALL 
					WHERE
						SPECT_MAIN_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
			<!--- <br/><cfoutput>
			o gün içerisinde yapılan stok hareketleri ancak depolar arası sevk hariç GET_STOCK_ACT:#GET_STOCK_ACT.AMOUNT#---
			konsinye satıs fat. GET_STOCK_KONSINYE:#GET_STOCK_KONSINYE.TOTAL_KON#</cfoutput>
			<br/> --->
			<!--- //maliyet kayıt tarihindeki stok işlemleri ve konsinyeye göre anlık stok bulunuyor --->
			<cfif isdefined('GET_STOCK_ACT') and GET_STOCK_ACT.RECORDCOUNT AND LEN(GET_STOCK_ACT.AMOUNT)>
				<!--- maliyet işlemlerinde aynı gün içerisinde o ürüne maliyet kaydı var ise ürün alışı olmuş ve maliyetde kaydediği için stok olarak giriş yapmış olacak ancak maliyet kaydı yapmayanda daha stok girişi yapmamış sayılacaktır--->			
				<cfquery name="GET_COST_AMOUNT" dbtype="query" maxrows="1">
					SELECT
						SUM(ACTION_AMOUNT) COST_AMOUNT
					FROM
						GET_NEW_COST_ALL
					WHERE
						START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
						<!--- AND RECORD_DATE <cfif arguments.action_row_id gt 0> <= <cfelse> < </cfif><cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp"> --->
						<cfif arguments.action_row_id gt 0>
							AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer">
							AND (ACTION_ID<>#arguments.action_id# OR (ACTION_ID=#arguments.action_id# AND ACTION_ROW_ID < #arguments.action_row_id#))
						</cfif>
						<cfif GET_NOT_DEP_COST.RECORDCOUNT>
						AND
							( 
							<cfset rw_count=0>
							<cfloop query="GET_NOT_DEP_COST">
								<cfset rw_count=rw_count+1>
								NOT (LOCATION_ID =#GET_NOT_DEP_COST.LOCATION_ID# AND DEPARTMENT_ID = #GET_NOT_DEP_COST.DEPARTMENT_ID#)
								<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif>
							</cfloop>
							)
						</cfif>
						AND ACTION_TYPE NOT IN (8)<!--- FİYAT KORUMA TİPİNDEKİLER STOK GİRİŞİ YAPMAZ O NEDEN İLE SAYILMAMALI --->
						AND ACTION_PROCESS_TYPE NOT IN(113)<!--- stok giriş işlemi yapmadığından alınmaz (811 alınıyor çünkü stok girşi yapılmış bi haraketi ithal mal girişine cekmiş oluyoruz)--->
						AND ACTION_ID IS NOT NULL
				</cfquery>
				
				<cfif GET_COST_AMOUNT.RECORDCOUNT and len(GET_COST_AMOUNT.COST_AMOUNT)><cfset cost_amt=GET_COST_AMOUNT.COST_AMOUNT><cfelse><cfset cost_amt=0></cfif>
				<!--- belge tarihindeki stok hareketlerinin tamamı için öncelikle ogün içindeki hareketler bulunuyor sonra belgedeki miktar cıkarılıyor daha sonrada
				 sonra ogün içerisinde maliyet işlemi yapmışlar çıkarılıyor ve buda daha sonra ki işlemlerde toplam stok miktarından cıkarılıyor 
				 busayade gün içinde belgenin eklendiği andaki miktar bulunuyor--->
				
				<!--- ithal mal girisinde cıkıs depo maliyet yapmıyor giriş depo maliyet yapıyor ise stok miktarını hesaplarken bu belgenin miktarıda katılmalıdır --->
				<cfif GET_ACT.ACTION_CAT eq 811>
					<cfquery name="GET_ACT_NO_DEPT_COST" dbtype="query">
						SELECT * FROM GET_NOT_DEP_COST WHERE DEPARTMENT_ID = #GET_ACT.ACT_OUT_DEPARTMENT_ID# AND LOCATION_ID = #GET_ACT.ACT_OUT_LOCATION_ID#
					</cfquery>
				<cfelse>
					<cfset GET_ACT_NO_DEPT_COST.recordcount = 0>
				</cfif>
				<cfset paper_stock = GET_STOCK_ACT.AMOUNT>
				<!---<cfset today_stock_act2 = 0> çalışma PY --->
				<cfif not listfind('81,113,58,62,811,116',GET_ACT.ACTION_CAT,',') or GET_ACT_NO_DEPT_COST.recordcount eq 1>
					<!---<br/><cfoutput>GET_STOCK_ACT.AMOUNT: #GET_STOCK_ACT.AMOUNT# ----belgedeki stock_amount_total:#stock_amount_total#--gün içindeki maliyeti olan hareket toplam cost_amt:#cost_amt#</cfoutput>
					<br/>  --->	
					<cfset today_stock_act = (GET_STOCK_ACT.AMOUNT-stock_amount_total)-cost_amt>
				<!---	<cfif hour(get_act.action_date) gt 0>
                        <cfset today_stock_act2 =  (GET_STOCK_ACT.AMOUNT-stock_amount_total)-cost_amt>
                    </cfif> ---->
					<!---<cfdump var="#GET_STOCK_ACT.AMOUNT#"><cfdump var="#today_stock_act#"><cfdump var="#stock_amount_total#">aaa <br/>--->
				<cfelse>
					<cfif GET_ACT.ACTION_CAT eq 62>
						<cfset today_stock_act = (GET_STOCK_ACT.AMOUNT)-cost_amt+GET_ACT.AMOUNT>
					<cfelse>
						<cfset today_stock_act = (GET_STOCK_ACT.AMOUNT)-cost_amt>
					</cfif>
					
				</cfif>
			<cfelse>
				<cfset paper_stock = 0>
				<cfset today_stock_act=0>
				<cfset today_stock_act2 = 0> 
			</cfif>
			
			<!--- <cfdump var="#GET_STOCK_ACT.AMOUNT#"><cfdump var="#today_stock_act#"><cfdump var="#stock_amount_total#">aaa <br/> --->
			<!--- <br/><cfoutput>konsinye eklenmemiş stok hareketlerinden today_stock_act:#today_stock_act#</cfoutput> --->
			<cfif isdefined('GET_STOCK_KONSINYE') and GET_STOCK_KONSINYE.RECORDCOUNT><cfset konsinye_stock_amount=GET_STOCK_KONSINYE.TOTAL_KON><cfelse><cfset konsinye_stock_amount=0></cfif>
			<cfset today_stock_act=today_stock_act+konsinye_stock_amount>
         <!---   <cfoutput><br/> #konsinye_stock_amount# adet konsinye eklenmis<font color="red">today_stock_act = #today_stock_act#</font></cfoutput><br/> --->
			<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
				
				<cfquery name="GET_STOCK" dbtype="query">
					SELECT
						SUM(AMOUNT_ALL)-(#konsinye_stock_amount+paper_stock#) AS PRODUCT_STOCK,
						PRODUCT_ID
					FROM
						GET_STOCK_ACT_ALL
					WHERE
						PROCESS_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
						<cfif is_prod_cost_type eq 0>
							AND (SPECT_VAR_ID IS NULL OR SPECT_VAR_ID = 0)
						</cfif>
						<cfif is_stock_based_cost eq 1>
							<cfif isdefined('arguments.stock_id') and len(arguments.stock_id) and is_stock_based_cost eq 1>
								AND STOCK_ID =#arguments.stock_id#
							</cfif>
						</cfif>
						<!---AND PROCESS_TYPE NOT IN (81,811) depolar arası sevk ve ithal mal girişi yolda olabileceğinden burdada hesaba katılmaz --->
						<cfif GET_NOT_DEP_COST.RECORDCOUNT>
						AND
							( 
							<cfset rw_count=0>
							<cfloop query="GET_NOT_DEP_COST">
								<cfset rw_count=rw_count+1>
								NOT (LOCATION_ID = #GET_NOT_DEP_COST.LOCATION_ID# AND DEPARTMENT_ID =#GET_NOT_DEP_COST.DEPARTMENT_ID#)
								<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif>
							</cfloop>
							)
						</cfif>
					GROUP BY
						PRODUCT_ID
				</cfquery>
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
					SUM(AMOUNT_ALL)-(#konsinye_stock_amount+paper_stock#) AS PRODUCT_STOCK,
						PRODUCT_ID,
						SPECT_VAR_ID
					FROM
						GET_STOCK_ACT_ALL
					WHERE
						PROCESS_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> AND
						SPECT_VAR_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
						<cfif is_stock_based_cost eq 1>
							<cfif isdefined('arguments.stock_id') and len(arguments.stock_id) and is_stock_based_cost eq 1>
								AND STOCK_ID =#arguments.stock_id#
							</cfif>
						</cfif>
						<!---AND PROCESS_TYPE NOT IN (81,811) depolar arası sevk ve ithal mal girişi yolda olabileceğinden burdada hesaba katılmaz --->
						<!--- AND PROCESS_TYPE NOT IN (81,811)depolar arası sevk ve ithal mal girişi yolda olabileceğinden burdada hesaba katılmaz --->
						<cfif GET_NOT_DEP_COST.RECORDCOUNT>
						AND
							( 
							<cfset rw_count=0>
							<cfloop query="GET_NOT_DEP_COST">
								<cfset rw_count=rw_count+1>
								NOT (LOCATION_ID = #GET_NOT_DEP_COST.LOCATION_ID# AND DEPARTMENT_ID =#GET_NOT_DEP_COST.DEPARTMENT_ID#)
								<cfif rw_count lt GET_NOT_DEP_COST.RECORDCOUNT>AND</cfif>
							</cfloop>
							)
						</cfif>
					GROUP BY
						PRODUCT_ID,
						SPECT_VAR_ID
				</cfquery>
			</cfif>
			<!---	  <br/>GET_STOCK_ACT_ALL:<cfdump var="#GET_STOCK_ACT_ALL#">
				<br/>GET_STOCK_ACT:<cfdump var="#GET_STOCK_ACT#">
               <br/>GET_STOCK: <cfdump var="#GET_STOCK#">  
			   <cfdump var="#GET_COST_1#">  ---->
			<cfscript>
				//bir önceki maliyet degerleri
				pre_cost_purchase_net = 0;
				pre_cost_purchase_extra_net = 0;
				pre_cost_purchase_net_system = 0;
				pre_cost_purchase_extra_net_system = 0;
				pre_cost_purchase_net_system_2 = 0;
				pre_cost_purchase_extra_net_system_2 = 0;
				pre_product_stock = 0;
				pre_cost_reflection = 0;
				pre_cost_reflection_system = 0;
				pre_cost_reflection_system_2 = 0;
				pre_cost_labor = 0;
				pre_cost_labor_system = 0;
				pre_cost_labor_system_2 = 0;
				if(len(GET_STOCK.PRODUCT_STOCK)) product_stock_amount = GET_STOCK.PRODUCT_STOCK; else product_stock_amount = 0;//mevcut stok

				if(GET_COST_1.RECORDCOUNT)
				{
					if(len(GET_COST_1.STATION_REFLECTION_COST)) pre_cost_reflection = GET_COST_1.STATION_REFLECTION_COST;
					if(len(GET_COST_1.LABOR_COST)) pre_cost_labor = GET_COST_1.LABOR_COST;
					if(len(GET_COST_1.STATION_REFLECTION_COST_SYSTEM)) pre_cost_reflection_system = GET_COST_1.STATION_REFLECTION_COST_SYSTEM;
					if(len(GET_COST_1.LABOR_COST_SYSTEM)) pre_cost_labor_system = GET_COST_1.LABOR_COST_SYSTEM;
					if(len(GET_COST_1.STATION_REFLECTION_COST_SYSTEM_2)) pre_cost_reflection_system_2 = GET_COST_1.STATION_REFLECTION_COST_SYSTEM_2;
					if(len(GET_COST_1.LABOR_COST_SYSTEM_2)) pre_cost_labor_system_2 = GET_COST_1.LABOR_COST_SYSTEM_2;
					if(GET_COST_1.PURCHASE_NET_MONEY neq arguments.cost_money and isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_COST_1.PURCHASE_NET_MONEY,';'))
						rate_purchase_net=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_COST_1.PURCHASE_NET_MONEY,';')-1,';');
					else
						rate_purchase_net=1;
					if(GET_COST_1.PURCHASE_NET_MONEY neq arguments.cost_money)//aynı değil ise kur hesaplarını yapmalı
					{
						if(len(GET_COST_1.PURCHASE_NET)) pre_cost_purchase_net = ((GET_COST_1.PURCHASE_NET_ALL*rate_purchase_net)/rate_cost_money);//fiyat kontrol v.s. düşmek gerek 
						if(len(GET_COST_1.PURCHASE_EXTRA_COST)) pre_cost_purchase_extra_net = (GET_COST_1.PURCHASE_EXTRA_COST*rate_purchase_net)/rate_cost_money;
					}
					else
					{
						if(len(GET_COST_1.PURCHASE_NET)) pre_cost_purchase_net = GET_COST_1.PURCHASE_NET_ALL;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_COST_1.PURCHASE_EXTRA_COST)) pre_cost_purchase_extra_net = GET_COST_1.PURCHASE_EXTRA_COST;
					}
					if(GET_COST_1.PURCHASE_NET neq 0)
					{
						if(len(GET_COST_1.PURCHASE_NET_SYSTEM)) pre_cost_purchase_net_system = GET_COST_1.PURCHASE_NET_SYSTEM_ALL;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_COST_1.PURCHASE_NET_SYSTEM_2)) pre_cost_purchase_net_system_2 = GET_COST_1.PURCHASE_NET_SYSTEM_2_ALL;;//fiyat kontrol v.s. düşmek gerek
					}
					if(len(GET_COST_1.PURCHASE_EXTRA_COST_SYSTEM)) pre_cost_purchase_extra_net_system = GET_COST_1.PURCHASE_EXTRA_COST_SYSTEM;
					if(len(GET_COST_1.PURCHASE_EXTRA_COST_SYSTEM_2)) pre_cost_purchase_extra_net_system_2 = GET_COST_1.PURCHASE_EXTRA_COST_SYSTEM_2;
			}
				//writeoutput('Bir Öncekinin Maliyetlerini Alırken mi Sapitiyor Acebe..[#product_stock_amount#].<br/>');
				if((isdefined('arguments.action_type') and arguments.action_type eq 8))//listfind('113',GET_ACT.ACTION_CAT,',') or 
				{//ambar ve depolararası sevk işlemi veya fiyat farkı dağılımından geliyor ise tutarlar önceki maliyet ile bire bir aynı olacaktır
					stock_cost = pre_cost_purchase_net;
					stock_cost_extra = pre_cost_purchase_extra_net;
					stock_cost_system = pre_cost_purchase_net_system;
					stock_cost_extra_system = pre_cost_purchase_extra_net_system;
					stock_cost_system_2 = pre_cost_purchase_net_system_2;
					stock_cost_extra_system_2 = pre_cost_purchase_extra_net_system_2;
					stock_cost_reflection = pre_cost_reflection;
					stock_cost_labor = pre_cost_labor;
					stock_cost_reflection_system = pre_cost_reflection_system;
					stock_cost_labor_system = pre_cost_labor_system;
					stock_cost_reflection_system_2 = pre_cost_reflection_system_2;
					stock_cost_labor_system_2 = pre_cost_labor_system_2;
				}
				
				if(GET_ACT.ACTION_CAT neq 0)
				{//elle eklenen maliyet stok girisi yapmadigi icin direk stok querysinden gelen degeri alir
					if(get_act.purchase_sales is 0 or listfind('81,113,811',GET_ACT.ACTION_CAT,','))
						all_stock_amount = product_stock_amount - stock_amount_total;//alış işlemi, ithal mal girişi,ambar veya depolararası sevk ise
					else
						all_stock_amount = product_stock_amount + stock_amount_total;
				}else
				{
					all_stock_amount = product_stock_amount;
				}
				//belgedeki toplam ürüm maliyet toplamı
				stock_cost_paper = stock_amount_total * stock_cost;
				stock_cost_extra_paper = stock_amount_total * stock_cost_extra;
				stock_cost_paper_system = stock_amount_total * stock_cost_system;
				stock_cost_extra_paper_system = stock_amount_total * stock_cost_extra_system;
				stock_cost_paper_system_2 = stock_amount_total * stock_cost_system_2;
				stock_cost_extra_paper_system_2 = stock_amount_total * stock_cost_extra_system_2;
				stock_cost_reflection_paper = stock_amount_total * stock_cost_reflection;
				stock_cost_labor_paper = stock_amount_total * stock_cost_labor;
				stock_cost_reflection_paper_system = stock_amount_total * stock_cost_reflection_system;
				stock_cost_labor_paper_system = stock_amount_total * stock_cost_labor_system;
				stock_cost_reflection_paper_system_2 = stock_amount_total * stock_cost_reflection_system_2;
				stock_cost_labor_paper_system_2 = stock_amount_total * stock_cost_labor_system_2;
			//	writeoutput('<br/>Sanırım Burasııı.....#stock_amount_total#*#stock_cost# = #stock_cost_paper#__#pre_cost_purchase_net#.<br/>');
				if(all_stock_amount gt 0 and product_stock_amount gt 0 and GET_ACT.ACTION_CAT neq 0)
				{   //islem yapildigi tarihdeki stok 0 ise veya islem miktari eklendiğinde 1 den küçükse direk tutar maliyet olarak kaydedilecek öyle değil ise bu hesaplar yapılır
					//stoktaki ürünlerin toplam maliyetleri parabirimi cinslerine göre
					if(isdefined('arguments.action_type') and arguments.action_type eq 4){//Sadedece Üretimden Belge Oluştururken buraya girsin.
						if(pre_cost_purchase_net eq 0 and all_stock_amount gt 0){//Önceki net maliyet 0 olarak geliyor fakat toplam stok miktarı ise 0dan büyük ise böyle bir durum ortaya çıkıyor
							//Sadece 2 tane üretim emrinin olduğu caselerde ortaya çıktı//Çünkü aşağıda all_stock_amount*pre_cost_purchase_net dendiği için diyelim toplam stok miktarı 100 olsun all_stock_amount 0 ise toplam stok maliyetini 0 olarak hesaplıyor..M.ER,gereksiz ise kaldırılır ilerde..
							pre_cost_purchase_net = price_system/ rate_cost_money;
							pre_cost_purchase_net_system = price_system;
							pre_cost_purchase_net_system_2 = price_system/rate_system_2;
							pre_cost_purchase_extra_net = (system_money_cost_extra_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_extra_net_system = (system_money_cost_extra_row/stock_amount_row);
							pre_cost_purchase_net_system_2 = (price_system) /rate_system_2;
							//writeoutput('all_stock_extra_cost = #all_stock_amount# * #pre_cost_purchase_extra_net# __#price_system#_<br/>');
						}
					}
					all_stock_cost = all_stock_amount * pre_cost_purchase_net;
					//writeoutput('all_stock_cost = #pre_cost_purchase_net#****#pre_cost_purchase_net_system_2#');
					all_stock_extra_cost = all_stock_amount * pre_cost_purchase_extra_net;
					all_stock_cost_system = all_stock_amount * pre_cost_purchase_net_system;
					all_stock_extra_cost_system = all_stock_amount * pre_cost_purchase_extra_net_system;
					all_stock_cost_system_2 = all_stock_amount * pre_cost_purchase_net_system_2;
					all_stock_extra_cost_system_2 = all_stock_amount * pre_cost_purchase_extra_net_system_2;
					all_stock_cost_reflection = all_stock_amount * pre_cost_reflection;
					all_stock_cost_labor = all_stock_amount * pre_cost_labor;
					all_stock_cost_reflection_system = all_stock_amount * pre_cost_reflection_system;
					all_stock_cost_labor_system = all_stock_amount * pre_cost_labor_system;
					all_stock_cost_reflection_system_2 = all_stock_amount * pre_cost_reflection_system_2;
					all_stock_cost_labor_system_2 = all_stock_amount * pre_cost_labor_system_2;
					if(get_act.purchase_sales eq 0 or listfind('81,113,811',GET_ACT.ACTION_CAT,',') or GET_ACT.ACTION_CAT eq 0)
					{//elle eklenen maliyet ve ithal mal girisinde stok girisi yapmadigi icin
						stock_cost = all_stock_cost + stock_cost_paper;
						stock_cost_extra = all_stock_extra_cost + stock_cost_extra_paper;
						stock_cost_system = all_stock_cost_system + stock_cost_paper_system;
						stock_cost_extra_system = all_stock_extra_cost_system + stock_cost_extra_paper_system;
						stock_cost_system_2 = all_stock_cost_system_2 + stock_cost_paper_system_2;
						stock_cost_extra_system_2 = all_stock_extra_cost_system_2 + stock_cost_extra_paper_system_2;
						stock_cost_reflection = all_stock_cost_reflection + stock_cost_reflection_paper;
						stock_cost_labor = all_stock_cost_labor + stock_cost_labor_paper;
						stock_cost_reflection_system = all_stock_cost_reflection_system + stock_cost_reflection_paper_system;
						stock_cost_labor_system = all_stock_cost_labor_system + stock_cost_labor_paper_system;
						stock_cost_reflection_system_2 = all_stock_cost_reflection_system_2 + stock_cost_reflection_paper_system_2;
						stock_cost_labor_system_2 = all_stock_cost_labor_system_2 + stock_cost_labor_paper_system_2;
					}
					else
					{
						stock_cost = all_stock_cost - stock_cost_paper;
						stock_cost_extra = all_stock_extra_cost - stock_cost_extra_paper;
						stock_cost_system = all_stock_cost_system - stock_cost_paper_system;
						stock_cost_extra_system = all_stock_extra_cost_system - stock_cost_extra_paper_system;
						stock_cost_system_2 = all_stock_cost_system_2 - stock_cost_paper_system_2;
						stock_cost_extra_system_2 = all_stock_extra_cost_system_2 - stock_cost_extra_paper_system_2;
						stock_cost_reflection = all_stock_cost_reflection - stock_cost_reflection_paper;
						stock_cost_labor = all_stock_cost_labor - stock_cost_labor_paper;
						stock_cost_reflection_system = all_stock_cost_reflection_system - stock_cost_reflection_paper_system;
						stock_cost_labor_system = all_stock_cost_labor_system - stock_cost_labor_paper_system;
						stock_cost_reflection_system_2 = all_stock_cost_reflection_system_2 - stock_cost_reflection_paper_system_2;
						stock_cost_labor_system_2 = all_stock_cost_labor_system_2 - stock_cost_labor_paper_system_2;
					}
					//writeoutput('stock_cost = #all_stock_amount#__#stock_cost_paper#****<br>');
					if(GET_ACT.ACTION_CAT neq 0 or not listfind('81,113,811',GET_ACT.ACTION_CAT,','))
					{
						if(product_stock_amount gt 0)
						{
						//writeoutput('Maliyeti Hesaplıyor ve stock_cost =#stock_cost#/product_stock_amount =#product_stock_amount# ===>#stock_cost / product_stock_amount#');
							stock_cost = stock_cost / product_stock_amount;
							stock_cost_extra = stock_cost_extra / product_stock_amount;
							stock_cost_system = stock_cost_system / product_stock_amount;
							stock_cost_extra_system = stock_cost_extra_system / product_stock_amount;
							stock_cost_system_2 = stock_cost_system_2 / product_stock_amount;
							stock_cost_extra_system_2 = stock_cost_extra_system_2 / product_stock_amount;
							stock_cost_reflection = stock_cost_reflection / product_stock_amount;
							stock_cost_labor = stock_cost_labor / product_stock_amount;
							stock_cost_reflection_system = stock_cost_reflection_system / product_stock_amount;
							stock_cost_labor_system = stock_cost_labor_system / product_stock_amount;
							stock_cost_reflection_system_2 = stock_cost_reflection_system_2 / product_stock_amount;
							stock_cost_labor_system_2 = stock_cost_labor_system_2 / product_stock_amount;
						}else
						{
							stock_cost = stock_cost / stock_amount_total;
							stock_cost_extra = stock_cost_extra / stock_amount_total;
							stock_cost_system = stock_cost_system / stock_amount_total;
							stock_cost_extra_system = stock_cost_extra_system / stock_amount_total;
							stock_cost_system_2 = stock_cost_system_2 / stock_amount_total;
							stock_cost_extra_system_2 = stock_cost_extra_system_2 / stock_amount_total;
							stock_cost_reflection = stock_cost_reflection / stock_amount_total;
							stock_cost_labor = stock_cost_labor / stock_amount_total;
							stock_cost_reflection_system = stock_cost_reflection_system / stock_amount_total;
							stock_cost_labor_system = stock_cost_labor_system / stock_amount_total;
							stock_cost_reflection_system_2 = stock_cost_reflection_system_2 / stock_amount_total;
							stock_cost_labor_system_2 = stock_cost_labor_system_2 / stock_amount_total;
						}
					}else
					{
						if(product_stock_amount+stock_amount_total gt 0)
						{
							
							stock_cost = stock_cost/(product_stock_amount+stock_amount_total);
							stock_cost_extra = stock_cost_extra/(product_stock_amount+stock_amount_total);
							stock_cost_system = stock_cost_system/(product_stock_amount+stock_amount_total);
							stock_cost_extra_system = stock_cost_extra_system/(product_stock_amount+stock_amount_total);
							stock_cost_system_2 = stock_cost_system_2/(product_stock_amount+stock_amount_total);
							stock_cost_extra_system_2 = stock_cost_extra_system_2/(product_stock_amount+stock_amount_total);
							stock_cost_reflection = stock_cost_reflection /(product_stock_amount+stock_amount_total);
							stock_cost_labor = stock_cost_labor / (product_stock_amount+stock_amount_total);
							stock_cost_reflection_system = stock_cost_reflection_system /(product_stock_amount+stock_amount_total);
							stock_cost_labor_system = stock_cost_labor_system / (product_stock_amount+stock_amount_total);
							stock_cost_reflection_system_2 = stock_cost_reflection_system_2 /(product_stock_amount+stock_amount_total);
							stock_cost_labor_system_2 = stock_cost_labor_system_2 / (product_stock_amount+stock_amount_total);
						}
					}
				}else
				{
					if(stock_amount_total eq 0)
					{
						stock_cost = 0;
						stock_cost_extra = 0;
						stock_cost_system = 0;
						stock_cost_extra_system = 0;
						stock_cost_system_2 = 0;
						stock_cost_extra_system_2 = 0;
						stock_cost_reflection = 0;
						stock_cost_labor = 0;
						stock_cost_reflection_system = 0;
						stock_cost_labor_system = 0;
						stock_cost_reflection_system_2 = 0;
						stock_cost_labor_system_2 = 0;
					}
				}
				if(arguments.is_cost_calc_type is 1)
				{
					/*eskiden bir parabirimi üstünden gidiyor diğerlerini hesaplıyordu*/
					if(isdefined('arguments.cost_money_system') and len(arguments.cost_money_system))//sistem parabrimi tutarı
					{
						stock_cost=stock_cost_system/rate_cost_money;
						stock_cost_extra=stock_cost_extra_system/rate_cost_money;
						stock_cost_reflection=stock_cost_reflection_system/rate_cost_money;
						stock_cost_labor=stock_cost_labor_system/rate_cost_money;
					}
					if(isdefined('arguments.cost_money_system_2') and len(arguments.cost_money_system_2))//sistem 2. parabrimi tutarı
					{
						stock_cost_system_2=stock_cost_system/rate_system_2;
						stock_cost_extra_system_2=wrk_round(stock_cost_extra_system/rate_system_2,8);
						stock_cost_reflection_system_2=wrk_round(stock_cost_reflection_system/rate_system_2,8);
						stock_cost_labor_system_2=wrk_round(stock_cost_labor_system/rate_system_2,8);
					}
				}

			</cfscript>
			<!--- lokasyon bazında --->
			<cfif ListFind('113',GET_ACT.ACTION_CAT,',')>
				<!--- depolararası sevk,ambar,ithal mal girisi de tutar olarak onceki maliyet kullanılıyor --->
				<cfquery name="GET_LAST_COST_LOC" dbtype="query" maxrows="1">
					SELECT
                    	*
					FROM
						GET_NEW_COST_ALL
					WHERE
						PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
						<cfif arguments.action_row_id gt 0>AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"></cfif>
						<cfif len(GET_ACT.ACT_OUT_DEPARTMENT_ID)>AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_OUT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer"></cfif>
						<cfif len(GET_ACT.ACT_OUT_LOCATION_ID)>AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_OUT_LOCATION_ID#" cfsqltype="cf_sql_integer"></cfif>
						AND 
						(
							<!--- aynı gune eklenmis bir belge olabilir ancak kayit tarihi farkli olabilir --->
							(
								START_DATE < <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							)
							OR
							(
								START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
								AND RECORD_DATE <cfif arguments.action_row_id gt 0> <= <cfelse> < </cfif> <cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp">
							)
						)
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
				</cfquery>
				<cfscript>
				pre_cost_purchase_net_location = 0;
				pre_cost_purchase_extra_net_location=0;
				pre_cost_purchase_net_system_location=0;
				pre_cost_purchase_extra_net_system_location=0;
				pre_cost_purchase_net_system_2_location=0;
				pre_cost_purchase_extra_net_system_2_location=0;
				pre_cost_purchase_reflection_location=0;
				pre_cost_purchase_labor_location=0;
				pre_cost_purchase_reflection_system_location=0;
				pre_cost_purchase_labor_system_location=0;
				pre_cost_purchase_reflection_system_2_location=0;
				pre_cost_purchase_labor_system_2_location=0;
				if(GET_LAST_COST_LOC.RECORDCOUNT)
				{
					if(len(GET_LAST_COST_LOC.PRICE_PROTECTION_LOCATION))//PURCHASE_NET alanında fiyat koruma v.s. tutmadığından tipine göre ekleniyor yada cıkarıyor
					{
						if(GET_COST_1.PRICE_PROTECTION_MONEY neq arguments.cost_money)
						{
							if(isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_LAST_COST_LOC.PRICE_PROTECTION_MONEY_LOCATION,';'))
								rate_price_protection_location=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_LAST_COST_LOC.PRICE_PROTECTION_MONEY_LOCATION,';')-1,';');
							else
								rate_price_protection_location=1;
							pre_price_protection_location=GET_LAST_COST_LOC.PRICE_PROTECTION_LOCATION*rate_price_protection_location;
							pre_price_protection_location=pre_price_protection_location/rate_cost_money;
						}else{
							pre_price_protection_location=GET_LAST_COST_LOC.PRICE_PROTECTION_LOCATION;
						}
						if(len(GET_LAST_COST_LOC.PRICE_PROTECTION_TYPE)) pre_price_protection_location=pre_price_protection_location*GET_LAST_COST_LOC.PRICE_PROTECTION_TYPE;
					}else{pre_price_protection_location=0;}
					if(GET_LAST_COST_LOC.PURCHASE_NET_MONEY_LOCATION neq arguments.cost_money and isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_LAST_COST_LOC.PURCHASE_NET_MONEY_LOCATION,';'))
						rate_purchase_net_location_a=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_LAST_COST_LOC.PURCHASE_NET_MONEY_LOCATION,';')-1,';');
					else
						rate_purchase_net_location_a=1;
					
					if(GET_LAST_COST_LOC.PURCHASE_NET_MONEY_LOCATION neq arguments.cost_money)
					{
						if(len(GET_LAST_COST_LOC.PURCHASE_NET_LOCATION)) pre_cost_purchase_net_location = ((GET_LAST_COST_LOC.PURCHASE_NET_LOCATION*rate_purchase_net_location_a)/rate_cost_money)-pre_price_protection_location;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_LOCATION)) pre_cost_purchase_extra_net_location = (GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_LOCATION*rate_purchase_net_location_a)/rate_cost_money;
						if(len(GET_LAST_COST_LOC.STATION_REFLECTION_COST_LOCATION)) pre_cost_purchase_reflection_location = ((GET_LAST_COST_LOC.STATION_REFLECTION_COST_LOCATION*rate_purchase_net_location_a)/rate_cost_money)-pre_price_protection_location;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_LAST_COST_LOC.LABOR_COST_LOCATION)) pre_cost_purchase_labor_location = (GET_LAST_COST_LOC.LABOR_COST_LOCATION*rate_purchase_net_location_a)/rate_cost_money;
					}
					else
					{
						if(len(GET_LAST_COST_LOC.PURCHASE_NET_LOCATION)) pre_cost_purchase_net_location = GET_LAST_COST_LOC.PURCHASE_NET_LOCATION-pre_price_protection_location;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_LOCATION)) pre_cost_purchase_extra_net_location = GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_LOCATION;
						if(len(GET_LAST_COST_LOC.STATION_REFLECTION_COST_LOCATION)) pre_cost_purchase_reflection_location = GET_LAST_COST_LOC.STATION_REFLECTION_COST_LOCATION;
						if(len(GET_LAST_COST_LOC.LABOR_COST_LOCATION)) pre_cost_purchase_labor_location = GET_LAST_COST_LOC.LABOR_COST_LOCATION;
					}
					if(len(GET_LAST_COST_LOC.PURCHASE_NET_SYSTEM_LOCATION)) pre_cost_purchase_net_system_location = GET_LAST_COST_LOC.PURCHASE_NET_SYSTEM_LOCATION;
					if(len(GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_SYSTEM_LOCATION)) pre_cost_purchase_extra_net_system_location = GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
					if(len(GET_LAST_COST_LOC.PURCHASE_NET_SYSTEM_2_LOCATION)) pre_cost_purchase_net_system_2_location = GET_LAST_COST_LOC.PURCHASE_NET_SYSTEM_2_LOCATION;
					if(len(GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)) pre_cost_purchase_extra_net_system_2_location = GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION;

					if(len(GET_LAST_COST_LOC.STATION_REFLECTION_COST_SYSTEM_LOCATION)) pre_cost_purchase_reflection_system_location = GET_LAST_COST_LOC.STATION_REFLECTION_COST_SYSTEM_LOCATION;
					if(len(GET_LAST_COST_LOC.LABOR_COST_SYSTEM_LOCATION)) pre_cost_purchase_labor_system_location = GET_LAST_COST_LOC.LABOR_COST_SYSTEM_LOCATION;
					if(len(GET_LAST_COST_LOC.STATION_REFLECTION_COST_SYSTEM_2_LOCATION)) pre_cost_purchase_reflection_system_2_location = GET_LAST_COST_LOC.STATION_REFLECTION_COST_SYSTEM_2_LOCATION;
					if(len(GET_LAST_COST_LOC.LABOR_COST_SYSTEM_2_LOCATION)) pre_cost_purchase_labor_system_2_location = GET_LAST_COST_LOC.LABOR_COST_SYSTEM_2_LOCATION;
					
					stock_cost_paper = pre_cost_purchase_net_location*stock_amount_total;
					stock_cost_extra_paper = pre_cost_purchase_extra_net_location*stock_amount_total;
					stock_cost_paper_system = pre_cost_purchase_net_system_location*stock_amount_total;
					stock_cost_extra_paper_system = pre_cost_purchase_extra_net_system_location*stock_amount_total;
					stock_cost_paper_system_2 = pre_cost_purchase_net_system_2_location*stock_amount_total;
					stock_cost_extra_paper_system_2 = pre_cost_purchase_extra_net_system_2_location*stock_amount_total;
					stock_cost_reflection_paper = pre_cost_purchase_reflection_location*stock_amount_total;
					stock_cost_labor_paper = pre_cost_purchase_labor_location*stock_amount_total;
					stock_cost_reflection_paper_system = pre_cost_purchase_reflection_system_location*stock_amount_total;
					stock_cost_labor_paper_system = pre_cost_purchase_labor_system_location*stock_amount_total;
					stock_cost_reflection_paper_system_2 = pre_cost_purchase_reflection_system_2_location*stock_amount_total;
					stock_cost_labor_paper_system_2 = pre_cost_purchase_labor_system_2_location*stock_amount_total;
				}
				else
					{
						stock_cost_paper = 0;
						stock_cost_extra_paper = 0;
						stock_cost_paper_system = 0;
						stock_cost_extra_paper_system = 0;
						stock_cost_paper_system_2 = 0;
						stock_cost_extra_paper_system_2 = 0;
						stock_cost_reflection_paper = 0;
						stock_cost_labor_paper = 0;
						stock_cost_reflection_paper_system = 0;
						stock_cost_labor_paper_system = 0;
						stock_cost_reflection_paper_system_2 = 0;
						stock_cost_labor_paper_system_2 = 0;	
					}
				</cfscript>
			</cfif>
			<cfif len(GET_ACT.ACT_DEPARTMENT_ID)>
				<cfquery name="GET_COST_1_LOCATION" dbtype="query" maxrows="1"><!--- agirlikli ortalama da bir onceki maliyetti bulmaya calisiyor --->
					SELECT
						*
					FROM
						GET_NEW_COST_ALL
					WHERE
						PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
						<cfif arguments.action_row_id gt 0>AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"></cfif>
						AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
						AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
						AND (
							<!--- aynı gune eklenmis bir belge olabilir ancak kayit tarihi farkli olabilir --->
								(
								START_DATE < <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
								)
								OR
								(
								START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
								AND RECORD_DATE <cfif arguments.action_row_id gt 0> <= <cfelse> < </cfif> <cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp">
								)
							)
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				</cfquery>
				<cfif not GET_COST_1_LOCATION.RECORDCOUNT>
					<cfquery name="GET_COST_1_LOCATION" dbtype="query" maxrows="1"><!--- agirlikli ortalama da bir onceki maliyetti bulmaya calisiyor --->
						SELECT
							*
						FROM
							GET_NEW_COST_ALL
						WHERE
							PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
							AND START_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery>
				</cfif>
				<cfif not GET_COST_1_LOCATION.RECORDCOUNT><!--- lokasyonlu olarakda maliyet bulamadı ise onceki maliyet genel maliyetden alınacak --->
					<!--- kapadım PY 1219	<cfquery name="GET_COST_1_LOCATION" dbtype="query" maxrows="1">
						SELECT
							*
						FROM
							GET_NEW_COST_ALL
						WHERE
							PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
							AND START_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery> --->
				</cfif>
				<!--- spec varsa specli stok degilse urun stok bulunuyor --->
				<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
					
					<cfquery name="GET_STOCK_ACT_LOCATION" datasource="#arguments.period_dsn_type#">
						SELECT
							SUM(STOCK_IN - STOCK_OUT) AMOUNT,
							PRODUCT_ID
						FROM
							STOCKS_ROW
						WHERE
							PROCESS_TIME = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> 
							AND PRODUCT_ID = #GET_ACT.PRODUCT_ID#
							AND PROCESS_TYPE NOT IN (72,75)
							<cfif is_prod_cost_type eq 0>
								AND (SPECT_VAR_ID IS NULL OR SPECT_VAR_ID = 0)
							</cfif>
							<cfif isdefined('arguments.stock_id') and len(arguments.stock_id) and is_stock_based_cost eq 1>
								AND STOCK_ID =#arguments.stock_id#
							</cfif>
							<cfif isdefined("arguments.action_row_id") and len(arguments.action_row_id) and arguments.action_row_id gt 0 and ListFind('81',GET_ACT.ACTION_CAT,',')>
								AND ROW_ID > #arguments.action_row_id#
								AND UPD_ID = #arguments.action_id#
							<cfelseif isdefined("get_act.ship_row_id") and len(get_act.ship_row_id)>
								AND ROW_ID >  #get_act.ship_row_id#
								AND UPD_ID = #GET_ACT.SHIP_ID# 
							</cfif>
							AND STORE = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND STORE_LOCATION = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
						GROUP BY
							PRODUCT_ID
					</cfquery>
					<cfquery name="GET_STOCK_KONSINYE_LOCATION" dbtype="query">
						SELECT 
							SUM(TOTAL_KONSINYE) TOTAL_KON
						FROM 
							GET_STOCK_KONSINYE_ALL 
						WHERE
							SPECT_MAIN_ID = 0
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
					</cfquery>
				<cfelse>
					<cfquery name="GET_STOCK_ACT_LOCATION" datasource="#arguments.period_dsn_type#">
						SELECT
							SUM(STOCK_IN - STOCK_OUT) AMOUNT,
							PRODUCT_ID,
							SPECT_VAR_ID
						FROM
							STOCKS_ROW
						WHERE
							PROCESS_TIME = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> 
							AND SPECT_VAR_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
							AND PRODUCT_ID = #GET_ACT.PRODUCT_ID#
							AND PROCESS_TYPE NOT IN (72,75)
							<cfif isdefined("arguments.action_row_id") and len(arguments.action_row_id) and arguments.action_row_id gt 0 and ListFind('81',GET_ACT.ACTION_CAT,',')>
								AND ROW_ID > #arguments.action_row_id#
								AND UPD_ID = #arguments.action_id#
							<cfelseif isdefined("get_act.ship_row_id") and len(get_act.ship_row_id)>
								AND ROW_ID >  #get_act.ship_row_id#
								AND UPD_ID = #GET_ACT.SHIP_ID# 
							</cfif>
							AND STORE = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND STORE_LOCATION = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
						GROUP BY
							PRODUCT_ID,
							SPECT_VAR_ID
					</cfquery>
					<cfquery name="GET_STOCK_KONSINYE_LOCATION" dbtype="query">
						SELECT 
							SUM(TOTAL_KONSINYE) TOTAL_KON
						FROM 
							GET_STOCK_KONSINYE_ALL 
						WHERE
							SPECT_MAIN_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
				<!--- GET_STOCK_ACT_LOCATION : arguments.action_row_id kontrol edilmesi sağlandı. Boş olması durumunda ship_row_id koşuluda bırakıldı. Sevk irsaliyelerinde aynı ürünün birden fazla satırda olması durumunda satır bazında maliyet atarken sürekli ilk satır ship_row_id değeri geliyordu. action_row_id ile satır değeri gönderiliyor. Düzenlendi. 11-2020 SÇ --->
				<cfif isdefined('GET_STOCK_ACT_LOCATION') and GET_STOCK_ACT_LOCATION.RECORDCOUNT AND LEN(GET_STOCK_ACT_LOCATION.AMOUNT)>
					<cfquery name="GET_COST_AMOUNT_LOCATION" dbtype="query" maxrows="1">
						SELECT
							SUM(ACTION_AMOUNT) COST_AMOUNT
						FROM
							GET_NEW_COST_ALL
						WHERE
							START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							AND RECORD_DATE <cfif arguments.action_row_id gt 0> <= <cfelse> < </cfif> <cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp">
							<cfif arguments.action_row_id gt 0>AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"></cfif>
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset paper_stock = GET_STOCK_ACT_LOCATION.AMOUNT>
					<cfif GET_COST_AMOUNT_LOCATION.RECORDCOUNT and len(GET_COST_AMOUNT_LOCATION.COST_AMOUNT)><cfset cost_amt=GET_COST_AMOUNT_LOCATION.COST_AMOUNT><cfelse><cfset cost_amt=0></cfif>
					<cfset today_stock_act=(GET_STOCK_ACT_LOCATION.AMOUNT-stock_amount_total)-cost_amt>
				<cfelse>
					<cfset today_stock_act=0>
					<cfset paper_stock = 0>
				</cfif>
				<cfif isdefined('GET_STOCK_KONSINYE_LOCATION') and GET_STOCK_KONSINYE_LOCATION.RECORDCOUNT><cfset konsinye_stock_amount=GET_STOCK_KONSINYE_LOCATION.TOTAL_KON><cfelse><cfset konsinye_stock_amount=0></cfif>
				<cfif not isdefined("cost_amt")>
					<cfset cost_amt = 0>
				</cfif>
				<cfset today_stock_act=today_stock_act+konsinye_stock_amount-cost_amt>
				<!--- aynı gun içinde depolararası sevk ten sonra benzer bir hareket yapıldığında depodan fazladan bir çıkış bulunuyordu yani 30 adet alınmış ve maliyet oluşmuş sonra 10 tanesi depolar arası sevkle sevk edilmiş ancak stok miktarı 20 olması gerekirken gün içinde eklenen maliyetler querysinden 30 gelmesinden dolayı buquery sevk miktarını bulur ve cıkarır --->
				 <cfquery name="GET_STOCK_SEVK_COST_LOCATION" datasource="#arguments.period_dsn_type#">
					SELECT 
						SUM(STOCK_OUT) STOCK_OUT
					FROM
						STOCKS_ROW,
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE
						PRODUCT_COST.PRODUCT_ID = #GET_ACT.PRODUCT_ID# AND
						PRODUCT_COST.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID AND 
						ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(STOCKS_ROW.SPECT_VAR_ID,0) AND
						PRODUCT_COST.RECORD_DATE < <cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp"> AND
						PRODUCT_COST.START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> AND
						PRODUCT_COST.ACTION_ID = STOCKS_ROW.UPD_ID AND
						PROCESS_TYPE IN (113) AND
						STOCK_OUT > 0 AND
						STORE = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">  AND
						STORE_LOCATION =  <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer"> 
				</cfquery>
				<cfif len(GET_STOCK_SEVK_COST_LOCATION.STOCK_OUT)><cfset today_stock_act=today_stock_act+GET_STOCK_SEVK_COST_LOCATION.STOCK_OUT></cfif>
				<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
					<cfquery name="GET_STOCK_LOCATION" dbtype="query">
						SELECT
							SUM(AMOUNT_ALL)-(#konsinye_stock_amount+paper_stock#) AS PRODUCT_STOCK,
							PRODUCT_ID
						FROM
							GET_STOCK_ACT_ALL
						WHERE
							PROCESS_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							<cfif is_prod_cost_type eq 0>
								AND (SPECT_VAR_ID IS NULL OR SPECT_VAR_ID = 0)
							</cfif>
							<cfif isdefined('arguments.stock_id') and len(arguments.stock_id) and is_stock_based_cost eq 1>
								AND STOCK_ID =#arguments.stock_id#
							</cfif>
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
						GROUP BY
							PRODUCT_ID
					</cfquery>
				<cfelse>
					<cfquery name="GET_STOCK_LOCATION" dbtype="query">
						SELECT
							SUM(AMOUNT_ALL)-(#konsinye_stock_amount+paper_stock#) AS PRODUCT_STOCK,
							PRODUCT_ID,
							SPECT_VAR_ID
						FROM
							GET_STOCK_ACT_ALL
						WHERE
							SPECT_VAR_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
							AND PROCESS_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND LOCATION_ID = <cfqueryparam value="#GET_ACT.ACT_LOCATION_ID#" cfsqltype="cf_sql_integer">
						GROUP BY
							PRODUCT_ID,
							SPECT_VAR_ID
					</cfquery>
				</cfif>
				<cfscript>
				//bir önceki maliyet degerleri
				pre_cost_purchase_net_location = 0;
				pre_cost_purchase_extra_net_location = 0;
				pre_cost_purchase_net_system_location = 0;
				pre_cost_purchase_extra_net_system_location = 0;
				pre_cost_purchase_net_system_2_location = 0;
				pre_cost_purchase_extra_net_system_2_location = 0;
				pre_product_stock_location = 0;
				pre_cost_purchase_extra_net_location = 0;
				pre_cost_purchase_reflection_location=0;
				pre_cost_purchase_labor_location=0;
				pre_cost_purchase_reflection_system_location=0;
				pre_cost_purchase_labor_system_location=0;
				pre_cost_purchase_reflection_system_2_location=0;
				pre_cost_purchase_labor_system_2_location=0;
				if(GET_STOCK_LOCATION.RECORDCOUNT and len(GET_STOCK_LOCATION.PRODUCT_STOCK)) product_stock_amount_location=GET_STOCK_LOCATION.PRODUCT_STOCK; else product_stock_amount_location=0;
	
				if(GET_COST_1_LOCATION.RECORDCOUNT)
				{
					if(len(GET_COST_1_LOCATION.PRICE_PROTECTION_LOCATION))//PURCHASE_NET alanında fiyat koruma v.s. tutmadığından tipine göre ekleniyor yada cıkarıyor
					{
						if(GET_COST_1.PRICE_PROTECTION_MONEY neq arguments.cost_money)
						{
							if(isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_COST_1_LOCATION.PRICE_PROTECTION_MONEY_LOCATION,';'))
								rate_price_protection_location=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_COST_1_LOCATION.PRICE_PROTECTION_MONEY_LOCATION,';')-1,';');
							else
								rate_price_protection_location=1;
							pre_price_protection_location=GET_COST_1_LOCATION.PRICE_PROTECTION_LOCATION*rate_price_protection_location;
							pre_price_protection_location=pre_price_protection_location/rate_cost_money;
						}else{
							pre_price_protection_location=GET_COST_1_LOCATION.PRICE_PROTECTION_LOCATION;
						}
						if(len(GET_COST_1_LOCATION.PRICE_PROTECTION_TYPE)) pre_price_protection_location=pre_price_protection_location*GET_COST_1_LOCATION.PRICE_PROTECTION_TYPE;
					}else{pre_price_protection_location=0;}
					
					if(GET_COST_1.PURCHASE_NET_MONEY_LOCATION neq arguments.cost_money and isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_COST_1.PURCHASE_NET_MONEY_LOCATION,';'))
						rate_purchase_net_location=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_COST_1.PURCHASE_NET_MONEY_LOCATION,';')-1,';');
					else
						rate_purchase_net_location=1;
					
					if(GET_COST_1.PURCHASE_NET_MONEY_LOCATION neq arguments.cost_money)
					{
						if(len(GET_COST_1_LOCATION.PURCHASE_NET_LOCATION)) pre_cost_purchase_net_location = ((GET_COST_1_LOCATION.PURCHASE_NET_LOCATION*rate_purchase_net_location)/rate_cost_money)-pre_price_protection_location;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_COST_1_LOCATION.PURCHASE_EXTRA_COST_LOCATION)) pre_cost_purchase_extra_net_location = (GET_COST_1_LOCATION.PURCHASE_EXTRA_COST_LOCATION*rate_purchase_net_location)/rate_cost_money;
					}
					else
					{
						if(len(GET_COST_1_LOCATION.PURCHASE_NET_LOCATION)) pre_cost_purchase_net_location = GET_COST_1_LOCATION.PURCHASE_NET_LOCATION-pre_price_protection_location;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_COST_1_LOCATION.PURCHASE_EXTRA_COST_LOCATION)) pre_cost_purchase_extra_net_location = GET_COST_1_LOCATION.PURCHASE_EXTRA_COST_LOCATION;
					}					
					if(len(GET_COST_1_LOCATION.PURCHASE_NET_SYSTEM_LOCATION)) pre_cost_purchase_net_system_location = GET_COST_1_LOCATION.PURCHASE_NET_SYSTEM_LOCATION;
					if(len(GET_COST_1_LOCATION.PURCHASE_EXTRA_COST_SYSTEM_LOCATION)) pre_cost_purchase_extra_net_system_location = GET_COST_1_LOCATION.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
					if(len(GET_COST_1_LOCATION.PURCHASE_NET_SYSTEM_2_LOCATION)) pre_cost_purchase_net_system_2_location = GET_COST_1_LOCATION.PURCHASE_NET_SYSTEM_2_LOCATION;
					if(len(GET_COST_1_LOCATION.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)) pre_cost_purchase_extra_net_system_2_location = GET_COST_1_LOCATION.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION;
					if(len(GET_COST_1_LOCATION.STATION_REFLECTION_COST_LOCATION)) pre_cost_purchase_reflection_location = GET_COST_1_LOCATION.STATION_REFLECTION_COST_LOCATION;
					if(len(GET_COST_1_LOCATION.LABOR_COST_LOCATION)) pre_cost_purchase_labor_location = GET_COST_1_LOCATION.LABOR_COST_LOCATION;
					if(len(GET_COST_1_LOCATION.STATION_REFLECTION_COST_SYSTEM_LOCATION)) pre_cost_purchase_reflection_system_location = GET_COST_1_LOCATION.STATION_REFLECTION_COST_SYSTEM_LOCATION;
					if(len(GET_COST_1_LOCATION.LABOR_COST_SYSTEM_LOCATION)) pre_cost_purchase_labor_system_location = GET_COST_1_LOCATION.LABOR_COST_SYSTEM_LOCATION;
					if(len(GET_COST_1_LOCATION.STATION_REFLECTION_COST_SYSTEM_2_LOCATION)) pre_cost_purchase_reflection_system_2_location = GET_COST_1_LOCATION.STATION_REFLECTION_COST_SYSTEM_2_LOCATION;
					if(len(GET_COST_1_LOCATION.LABOR_COST_SYSTEM_2_LOCATION)) pre_cost_purchase_labor_system_2_location = GET_COST_1_LOCATION.LABOR_COST_SYSTEM_2_LOCATION;
				}
								
				if(GET_ACT.ACTION_CAT neq 0)
				{
					if(get_act.purchase_sales is 0 or listfind('81,113,811',GET_ACT.ACTION_CAT,','))
						all_stock_amount_location = product_stock_amount_location - stock_amount_total;
					else
						all_stock_amount_location = product_stock_amount_location + stock_amount_total;
				}else
				{
					all_stock_amount_location = product_stock_amount;
				}
				
				if(all_stock_amount_location gt 0 and product_stock_amount_location gt 0 and GET_ACT.ACTION_CAT neq 0)
				{//islem yapildigi tarihdeki stok 0 ise veya islem miktari eklendiğinde 1 den küçükse direk tutar maliyet olarak kaydedilecek öyle değil ise bu hesaplar yapılır
					//stoktaki ürünlerin toplam maliyetleri parabirimi cinslerine göre
					if(isdefined('arguments.action_type') and arguments.action_type eq 4){//Sadedece Üretimden Belge Oluştururken buraya girsin.
						if(pre_cost_purchase_net_location eq 0 and all_stock_amount gt 0){//Önceki net maliyet 0 olarak geliyor fakat toplam stok miktarı ise 0dan büyük ise böyle bir durum ortaya çıkıyor
							//Sadece 2 tane üretim emrinin olduğu caselerde ortaya çıktı//Çünkü aşağıda all_stock_amount*pre_cost_purchase_net_location dendiği için diyelim toplam stok miktarı 100 olsun all_stock_amount 0 ise toplam stok maliyetini 0 olarak hesaplıyor..M.ER,gereksiz ise kaldırılır ilerde..
							////Çünkü aşağıda all_stock_amount*pre_cost_purchase_net_location dendiği için diyelim toplam stok miktarı 100 olsun all_stock_amount 0 ise toplam stok maliyetini 0 olarak hesaplıyor..M.ER,gereksiz ise kaldırılır ilerde..
							pre_cost_purchase_net_location = price_system/ rate_cost_money;
							pre_cost_purchase_net_system_location = price_system;
							pre_cost_purchase_net_system_2_location = price_system/rate_system_2;
							//lokasyon bazında soru olursa burada düzenleme yapılabilir...
							pre_cost_purchase_extra_net_location = (system_money_cost_extra_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_extra_net_system_location = (system_money_cost_extra_row/stock_amount_row);
							pre_cost_purchase_net_system_2_location = (system_money_cost_extra_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_reflection_location = (system_money_cost_reflection_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_labor_location = (system_money_cost_labor_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_reflection_system_location = (system_money_cost_reflection_row/stock_amount_row);
							pre_cost_purchase_labor_system_location = (system_money_cost_labor_row/stock_amount_row);
							pre_cost_purchase_reflection_system_2_location = (system_money_cost_reflection_row/stock_amount_row)/rate_system_2;
							pre_cost_purchase_labor_system_2_location = (system_money_cost_labor_row/stock_amount_row)/rate_system_2;
							///writeoutput('<br/>aaaaaaaaaaaaaaaaall_stock_extra_cost = #all_stock_amount# * #pre_cost_purchase_extra_net# __#price_system#_<br/>');
						}						
					}

					//writeoutput('price_system-#price_system#-#arguments.action_type#<br>'); //PY
					if((isdefined('arguments.action_type') and arguments.action_type eq 8) or GET_ACT.ACTION_CAT eq 81) // 0919 PY sevk işlemlerinde bir önceki maliyeti lokasyon bazlı bulması için
					{//ambar ve depolararası sevk işlemi veya fiyat farkı dağılımından geliyor ise tutarlar önceki maliyet ile bire bir aynı olacaktır
						str = "SELECT TOP 1 ROUND(ISNULL(PURCHASE_NET_SYSTEM_LOCATION,0),4) AS PRE_COST,ROUND(ISNULL(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0),4) AS PRE_COST_EXTRA,ROUND(ISNULL(PURCHASE_NET_SYSTEM_LOCATION_ALL,0),4) pre_net_system,ROUND(ISNULL(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0),4) pre_net_system_extra,ROUND(ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION_ALL,0),4) pre_net_system_2,ROUND(ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,0),4) as  pre_net_system_extra_2 FROM PRODUCT_COST WHERE START_DATE <=#createodbcdate(GET_ACT.ACTION_DATE)# AND PRODUCT_ID = #GET_ACT.PRODUCT_ID# AND LOCATION_ID = #GET_ACT.ACT_OUT_LOCATION_ID# AND DEPARTMENT_ID = #GET_ACT.ACT_OUT_DEPARTMENT_ID# ORDER BY PRODUCT_COST_ID DESC";
						// birden fazla kayıt olabilir, son maliyet kaydının gelmesi gerekir , düzenlendi SÇ 11-2020
						getprelocation = cfquery(SQLString : str, Datasource : dsn3);
						
						stock_cost_ = getprelocation.PRE_COST;
						stock_cost_extra_ = getprelocation.PRE_COST_EXTRA;
						stock_cost_system_ = getprelocation.pre_net_system;
						stock_cost_extra_system_ = getprelocation.pre_net_system_extra;
						stock_cost_system_2_ = getprelocation.pre_net_system_2;
						stock_cost_extra_system_2_ = getprelocation.pre_net_system_extra_2;
					
						if(stock_cost_ gt 0){
							stock_cost_paper = stock_amount_total * stock_cost_;
							stock_cost_extra_paper = stock_amount_total * stock_cost_extra_;
							stock_cost_paper_system = stock_amount_total * stock_cost_system_;
							stock_cost_extra_paper_system = stock_amount_total * stock_cost_extra_system_;
							stock_cost_paper_system_2 = stock_amount_total * stock_cost_system_2_;
							stock_cost_extra_paper_system_2 = stock_amount_total * stock_cost_extra_system_2_;
						}
						else{
							stock_cost_paper = 0;
							stock_cost_extra_paper = 0;
							stock_cost_paper_system = 0;
							stock_cost_extra_paper_system = 0;
							stock_cost_paper_system_2 = 0;
							stock_cost_extra_paper_system_2 = 0;
						}
					}
					

					all_stock_cost_location = all_stock_amount_location * pre_cost_purchase_net_location;
					all_stock_extra_cost_location = all_stock_amount_location * pre_cost_purchase_extra_net_location;
					all_stock_cost_system_location = all_stock_amount_location * pre_cost_purchase_net_system_location;
					all_stock_extra_cost_system_location = all_stock_amount_location * pre_cost_purchase_extra_net_system_location;
					all_stock_cost_system_2_location = all_stock_amount_location * pre_cost_purchase_net_system_2_location;
					all_stock_extra_cost_system_2_location = all_stock_amount_location * pre_cost_purchase_extra_net_system_2_location;
					all_stock_cost_reflection_location = all_stock_amount_location * pre_cost_purchase_reflection_location;
					all_stock_cost_labor_location = all_stock_amount_location * pre_cost_purchase_labor_location;
					all_stock_cost_reflection_system_location = all_stock_amount_location * pre_cost_purchase_reflection_system_location;
					all_stock_cost_labor_system_location = all_stock_amount_location * pre_cost_purchase_labor_system_location;
					all_stock_cost_reflection_system_2_location = all_stock_amount_location * pre_cost_purchase_reflection_system_2_location;
					all_stock_cost_labor_system_2_location = all_stock_amount_location * pre_cost_purchase_labor_system_2_location;
					
					if(get_act.purchase_sales eq 0 or listfind('81,113,811',GET_ACT.ACTION_CAT,',') or GET_ACT.ACTION_CAT eq 0)
					{//elle eklenen maliyet ve ithal mal girisinde stok girisi yapmadigi icin
						stock_cost_location = all_stock_cost_location + stock_cost_paper;
						stock_cost_extra_location = all_stock_extra_cost_location + stock_cost_extra_paper;
						stock_cost_system_location = all_stock_cost_system_location + stock_cost_paper_system;
						stock_cost_extra_system_location = all_stock_extra_cost_system_location + stock_cost_extra_paper_system;
						stock_cost_system_2_location = all_stock_cost_system_2_location + stock_cost_paper_system_2;
						stock_cost_extra_system_2_location = all_stock_extra_cost_system_2_location + stock_cost_extra_paper_system_2;
						stock_cost_reflection_location = all_stock_cost_reflection_location + stock_cost_reflection_paper;
						stock_cost_labor_location = all_stock_cost_labor_location + stock_cost_labor_paper;
						stock_cost_reflection_system_location = all_stock_cost_reflection_system_location + stock_cost_reflection_paper_system;
						stock_cost_labor_system_location = all_stock_cost_labor_system_location + stock_cost_labor_paper_system;
						stock_cost_reflection_system_2_location = all_stock_cost_reflection_system_2_location + stock_cost_reflection_paper_system_2;
						stock_cost_labor_system_2_location = all_stock_cost_labor_system_2_location + STOCK_COST_LABOR_PAPER_SYSTEM_2;
					}
					else
					{
						stock_cost_location = all_stock_cost_location - stock_cost_paper;
						stock_cost_extra_location = all_stock_extra_cost_location - stock_cost_extra_paper;
						stock_cost_system_location = all_stock_cost_system_location - stock_cost_paper_system;
						stock_cost_extra_system_location = all_stock_extra_cost_system_location - stock_cost_extra_paper_system;
						stock_cost_system_2_location = all_stock_cost_system_2_location - stock_cost_paper_system_2;
						stock_cost_extra_system_2_location = all_stock_extra_cost_system_2_location - stock_cost_extra_paper_system_2;
						stock_cost_reflection_location = all_stock_cost_reflection_location - stock_cost_reflection_paper;
						stock_cost_labor_location = all_stock_cost_labor_location - stock_cost_labor_paper;
						stock_cost_reflection_system_location = all_stock_cost_reflection_system_location - stock_cost_reflection_paper_system;
						stock_cost_labor_system_system_location = all_stock_cost_labor_system_location - stock_cost_labor_paper_system;
						stock_cost_reflection_system_2_location = all_stock_cost_reflection_system_2_location - stock_cost_reflection_paper_system_2;
						stock_cost_labor_system_system_2_location = all_stock_cost_labor_system_2_location - STOCK_COST_LABOR_PAPER_SYSTEM_2;
					}
					if(GET_ACT.ACTION_CAT neq 0 or not listfind('81,113,811',GET_ACT.ACTION_CAT,','))
					{
						if(product_stock_amount_location gt 0)
						{
							stock_cost_location = stock_cost_location / product_stock_amount_location;
							stock_cost_extra_location = stock_cost_extra_location / product_stock_amount_location;
							stock_cost_system_location = stock_cost_system_location / product_stock_amount_location;
							stock_cost_extra_system_location = stock_cost_extra_system_location / product_stock_amount_location;
							stock_cost_system_2_location = stock_cost_system_2_location / product_stock_amount_location;
							stock_cost_extra_system_2_location = stock_cost_extra_system_2_location / product_stock_amount_location;
							stock_cost_reflection_location = stock_cost_reflection_location / product_stock_amount_location;
							stock_cost_labor_location = stock_cost_labor_location / product_stock_amount_location;
							stock_cost_reflection_system_location = stock_cost_reflection_system_location / product_stock_amount_location;
							stock_cost_labor_system_location = stock_cost_labor_system_location / product_stock_amount_location;
							stock_cost_reflection_system_2_location = stock_cost_reflection_system_2_location / product_stock_amount_location;
							stock_cost_labor_system_2_location = stock_cost_labor_system_2_location / product_stock_amount_location;
						}else
						{
							stock_cost_location = stock_cost_location / stock_amount_total;
							stock_cost_extra_location = stock_cost_extra_location / stock_amount_total;
							stock_cost_system_location = stock_cost_system_location / stock_amount_total;
							stock_cost_extra_system_location = stock_cost_extra_system_location / stock_amount_total;
							stock_cost_system_2_location = stock_cost_system_2_location / stock_amount_total;
							stock_cost_extra_system_2_location = stock_cost_extra_system_2_location / stock_amount_total;
							stock_cost_reflection_location = stock_cost_reflection_location / stock_amount_total;
							stock_cost_labor_location = stock_cost_labor_location / stock_amount_total;
							stock_cost_reflection_system_location = stock_cost_reflection_system_location / stock_amount_total;
							stock_cost_labor_system_location = stock_cost_labor_system_location / stock_amount_total;
							stock_cost_reflection_system_2_location = stock_cost_reflection_system_2_location / stock_amount_total;
							stock_cost_labor_system_2_location = stock_cost_labor_system_2_location / stock_amount_total;
						}
					}else
					{
						if(product_stock_amount_location+stock_amount_total gt 0)
						{
							stock_cost_location = stock_cost_location/(product_stock_amount_location+stock_amount_total);
							stock_cost_extra_location = stock_cost_extra_location/(product_stock_amount_location+stock_amount_total);
							stock_cost_system_location = stock_cost_system_location/(product_stock_amount_location+stock_amount_total);
							stock_cost_extra_system_location = stock_cost_extra_system_location/(product_stock_amount_location+stock_amount_total);
							stock_cost_system_2_location = stock_cost_system_2_location/(product_stock_amount_location+stock_amount_total);
							stock_cost_extra_system_2_location = stock_cost_extra_system_2_location/(product_stock_amount_location+stock_amount_total);
							stock_cost_reflection_location = stock_cost_reflection_location / (product_stock_amount_location+stock_amount_total);
							stock_cost_labor_location = stock_cost_labor_location / (product_stock_amount_location+stock_amount_total);
							stock_cost_reflection_system_location = stock_cost_reflection_system_location / (product_stock_amount_location+stock_amount_total);
							stock_cost_labor_system_location = stock_cost_labor_system_location / (product_stock_amount_location+stock_amount_total);
							stock_cost_reflection_system_2_location = stock_cost_reflection_system_2_location / (product_stock_amount_location+stock_amount_total);
							stock_cost_labor_system_2_location = stock_cost_labor_system_2_location / (product_stock_amount_location+stock_amount_total);
						}
					}
				}else
				{
					if(stock_amount_total neq 0)// and not listfind('81,113,811',GET_ACT.ACTION_CAT,',')
					{
						stock_cost_location = stock_cost_paper/ stock_amount_total;
						stock_cost_extra_location = stock_cost_extra_paper/ stock_amount_total;
						stock_cost_system_location = stock_cost_paper_system/ stock_amount_total;
						stock_cost_extra_system_location = stock_cost_extra_paper_system/ stock_amount_total;
						stock_cost_system_2_location = stock_cost_paper_system_2/ stock_amount_total;
						stock_cost_extra_system_2_location = stock_cost_extra_paper_system_2/ stock_amount_total;
						stock_cost_reflection_location = stock_cost_reflection_paper / stock_amount_total;
						stock_cost_labor_location = stock_cost_labor_paper / stock_amount_total;
						stock_cost_reflection_system_location = stock_cost_reflection_paper_system / stock_amount_total;
						stock_cost_labor_system_location = stock_cost_labor_paper_system / stock_amount_total;
						stock_cost_reflection_system_2_location = stock_cost_reflection_paper_system_2 / stock_amount_total;
						stock_cost_labor_system_2_location = stock_cost_labor_paper_system_2 / stock_amount_total;
					}else
					{
						stock_cost_location = 0;
						stock_cost_extra_location = 0;
						stock_cost_system_location = 0;
						stock_cost_extra_system_location = 0;
						stock_cost_system_2_location = 0;
						stock_cost_extra_system_2_location = 0;
						stock_cost_reflection_location = 0;
						stock_cost_labor_location = 0;
						stock_cost_reflection_system_location = 0;
						stock_cost_labor_system_location = 0;
						stock_cost_reflection_system_2_location = 0;
						stock_cost_labor_system_2_location = 0;
					}
				}
				
				if(arguments.is_cost_calc_type is 1)
				{
					if(isdefined('arguments.cost_money_system') and len(arguments.cost_money_system))//sistem parabrimi tutarı
					{
						stock_cost_location = stock_cost_system_location / rate_cost_money;
						stock_cost_extra_location =stock_cost_extra_system_location/ rate_cost_money;
						stock_cost_reflection_location =stock_cost_reflection_system_location/ rate_cost_money;
						stock_cost_labor_location =stock_cost_labor_system_location/ rate_cost_money;
					}
					if(isdefined('arguments.cost_money_system_2') and len(arguments.cost_money_system_2))//sistem 2. parabrimi tutarı
					{
						stock_cost_system_2_location = stock_cost_system_location / rate_system_2;
						stock_cost_extra_system_2_location = wrk_round(stock_cost_extra_system_location / rate_system_2,8);
						stock_cost_labor_system_2_location = wrk_round(stock_cost_labor_system_location / rate_system_2,8);
						stock_cost_reflection_system_2_location = wrk_round(stock_cost_reflection_system_location / rate_system_2,8);
					}
				}
			</cfscript>
			</cfif>
			<!--- //lokasyon bazında --->
            <!--- depo bazlı--->
            <cfif ListFind('113',GET_ACT.ACTION_CAT,',')>
				<!--- depolararası sevk,ambar,ithal mal girisi de tutar olarak onceki maliyet kullanılıyor --->
				<cfquery name="GET_LAST_COST_DEP" dbtype="query" maxrows="1">
					SELECT
                    	*
					FROM
						GET_NEW_COST_ALL
					WHERE
						PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
						<cfif arguments.action_row_id gt 0>AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"></cfif>
						<cfif len(GET_ACT.ACT_OUT_DEPARTMENT_ID)>AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_OUT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer"></cfif>
						AND 
						(
							<!--- aynı gune eklenmis bir belge olabilir ancak kayit tarihi farkli olabilir --->
							(
								START_DATE < <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							)
							OR
							(
								START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
								AND RECORD_DATE <cfif arguments.action_row_id gt 0> <= <cfelse> < </cfif> <cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp">
							)
						)
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
				</cfquery>
				<cfscript>
				pre_cost_purchase_net_department = 0;
				pre_cost_purchase_extra_net_department=0;
				pre_cost_purchase_net_system_department=0;
				pre_cost_purchase_extra_net_system_department=0;
				pre_cost_purchase_net_system_2_department=0;
				pre_cost_purchase_extra_net_system_2_department=0;
				pre_cost_purchase_reflection_department=0;
				pre_cost_purchase_labor_department=0;
				pre_cost_purchase_reflection_system_department=0;
				pre_cost_purchase_labor_system_department=0;
				pre_cost_purchase_reflection_system_2_department=0;
				pre_cost_purchase_labor_system_2_department=0;
				if(GET_LAST_COST_DEP.RECORDCOUNT)
				{
					if(len(GET_LAST_COST_LOC.PRICE_PROTECTION_DEPARTMENT))//PURCHASE_NET alanında fiyat koruma v.s. tutmadığından tipine göre ekleniyor yada cıkarıyor
					{
						if(GET_COST_1.PRICE_PROTECTION_MONEY neq arguments.cost_money)
						{
							if(isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_LAST_COST_LOC.PRICE_PROTECTION_MONEY_DEPARTMENT,';'))
								rate_price_protection_department=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_LAST_COST_LOC.PRICE_PROTECTION_MONEY_DEPARTMENT,';')-1,';');
							else
								rate_price_protection_department=1;
							pre_price_protection_department=GET_LAST_COST_LOC.PRICE_PROTECTION_DEPARTMENT*rate_price_protection_department;
							pre_price_protection_department=pre_price_protection_department/rate_cost_money;
						}else{
							pre_price_protection_department=GET_LAST_COST_LOC.PRICE_PROTECTION_DEPARTMENT;
						}
						if(len(GET_LAST_COST_LOC.PRICE_PROTECTION_TYPE)) pre_price_protection_department=pre_price_protection_department*GET_LAST_COST_LOC.PRICE_PROTECTION_TYPE;
					}else{pre_price_protection_department=0;}
					if(GET_LAST_COST_LOC.PURCHASE_NET_MONEY_DEPARTMENT neq arguments.cost_money and isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_LAST_COST_LOC.PURCHASE_NET_MONEY_DEPARTMENT,';'))
						rate_purchase_net_department_a=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_LAST_COST_LOC.PURCHASE_NET_MONEY_DEPARTMENT,';')-1,';');
					else
						rate_purchase_net_department_a=1;
					
					if(GET_LAST_COST_LOC.PURCHASE_NET_MONEY_DEPARTMENT neq arguments.cost_money)
					{
						if(len(GET_LAST_COST_LOC.PURCHASE_NET_DEPARTMENT)) pre_cost_purchase_net_department = ((GET_LAST_COST_LOC.PURCHASE_NET_DEPARTMENT*rate_purchase_net_department_a)/rate_cost_money)-pre_price_protection_department;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_DEPARTMENT)) pre_cost_purchase_extra_net_department = (GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_DEPARTMENT*rate_purchase_net_department_a)/rate_cost_money;
						if(len(GET_LAST_COST_LOC.STATION_REFLECTION_COST_DEPARTMENT)) pre_cost_purchase_reflection_department = (GET_LAST_COST_LOC.STATION_REFLECTION_COST_DEPARTMENT*rate_purchase_net_department_a)/rate_cost_money;
						if(len(GET_LAST_COST_LOC.LABOR_COST_DEPARTMENT)) pre_cost_purchase_labor_department = (GET_LAST_COST_LOC.LABOR_COST_DEPARTMENT*rate_purchase_net_department_a)/rate_cost_money;
					}
					else
					{
						if(len(GET_LAST_COST_LOC.PURCHASE_NET_DEPARTMENT)) pre_cost_purchase_net_department = GET_LAST_COST_LOC.PURCHASE_NET_DEPARTMENT-pre_price_protection_department;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_DEPARTMENT)) pre_cost_purchase_extra_net_department = GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_DEPARTMENT;
						if(len(GET_LAST_COST_LOC.STATION_REFLECTION_COST_DEPARTMENT)) pre_cost_purchase_reflection_department = (GET_LAST_COST_LOC.STATION_REFLECTION_COST_DEPARTMENT);
						if(len(GET_LAST_COST_LOC.LABOR_COST_DEPARTMENT)) pre_cost_purchase_labor_department = (GET_LAST_COST_LOC.LABOR_COST_DEPARTMENT);
					}
					if(len(GET_LAST_COST_LOC.PURCHASE_NET_SYSTEM_DEPARTMENT)) pre_cost_purchase_net_system_department = GET_LAST_COST_LOC.PURCHASE_NET_SYSTEM_DEPARTMENT;
					if(len(GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT)) pre_cost_purchase_extra_net_system_department = GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT;
					if(len(GET_LAST_COST_LOC.PURCHASE_NET_SYSTEM_2_DEPARTMENT)) pre_cost_purchase_net_system_2_department = GET_LAST_COST_LOC.PURCHASE_NET_SYSTEM_2_DEPARTMENT;
					if(len(GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT)) pre_cost_purchase_extra_net_system_2_department = GET_LAST_COST_LOC.PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT;
					if(len(GET_LAST_COST_LOC.STATION_REFLECTION_COST_SYSTEM_DEPARTMENT)) pre_cost_purchase_reflection_system_department = GET_LAST_COST_LOC.STATION_REFLECTION_COST_SYSTEM_DEPARTMENT;
					if(len(GET_LAST_COST_LOC.LABOR_COST_SYSTEM_LOCATION)) pre_cost_purchase_labor_system_department = GET_LAST_COST_LOC.LABOR_COST_SYSTEM_LOCATION;
					if(len(GET_LAST_COST_LOC.STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT)) pre_cost_purchase_reflection_system_2_department = GET_LAST_COST_LOC.STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT;
					if(len(GET_LAST_COST_LOC.LABOR_COST_SYSTEM_2_LOCATION)) pre_cost_purchase_labor_system_2_department = GET_LAST_COST_LOC.LABOR_COST_SYSTEM_2_LOCATION;
					
					stock_cost_paper = pre_cost_purchase_net_department*stock_amount_total;
					stock_cost_extra_paper = pre_cost_purchase_extra_net_department*stock_amount_total;
					stock_cost_paper_system = pre_cost_purchase_net_system_department*stock_amount_total;
					stock_cost_extra_paper_system = pre_cost_purchase_extra_net_system_department*stock_amount_total;
					stock_cost_paper_system_2 = pre_cost_purchase_net_system_2_department*stock_amount_total;
					stock_cost_extra_paper_system_2 = pre_cost_purchase_extra_net_system_2_department*stock_amount_total;
					stock_cost_reflection_paper = pre_cost_purchase_reflection_department*stock_amount_total;
					stock_cost_labor_paper = pre_cost_purchase_labor_department*stock_amount_total;
					stock_cost_reflection_paper_system = pre_cost_purchase_reflection_system_department*stock_amount_total;
					stock_cost_labor_paper_system = pre_cost_purchase_labor_system_department*stock_amount_total;
					stock_cost_reflection_paper_system_2 = pre_cost_purchase_reflection_system_2_department*stock_amount_total;
					stock_cost_labor_paper_system_2 = pre_cost_purchase_labor_system_2_department*stock_amount_total;
				}
				else
					{
						stock_cost_paper = 0;
						stock_cost_extra_paper = 0;
						stock_cost_paper_system = 0;
						stock_cost_extra_paper_system = 0;
						stock_cost_paper_system_2 = 0;
						stock_cost_extra_paper_system_2 = 0;
						stock_cost_reflection_paper = 0;
						stock_cost_labor_paper = 0;
						stock_cost_reflection_paper_system = 0;
						stock_cost_labor_paper_system = 0;
						stock_cost_reflection_paper_system_2 = 0;
						stock_cost_labor_paper_system_2 = 0;
					}
				</cfscript>
			</cfif>
			<cfif len(GET_ACT.ACT_DEPARTMENT_ID)>
				<cfquery name="GET_COST_1_DEPARTMENT" dbtype="query" maxrows="1"><!--- agirlikli ortalama da bir onceki maliyetti bulmaya calisiyor --->
					SELECT
						*
					FROM
						GET_NEW_COST_ALL
					WHERE
						PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
						<cfif arguments.action_row_id gt 0>AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"></cfif>
						AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
						AND (
							<!--- aynı gune eklenmis bir belge olabilir ancak kayit tarihi farkli olabilir --->
								(
								START_DATE < <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
								)
								OR
								(
								START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
								AND RECORD_DATE <cfif arguments.action_row_id gt 0> <= <cfelse> < </cfif> <cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp">
								)
							)
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				</cfquery>
				<cfif not GET_COST_1_DEPARTMENT.RECORDCOUNT>
					<cfquery name="GET_COST_1_DEPARTMENT" dbtype="query" maxrows="1"><!--- agirlikli ortalama da bir onceki maliyetti bulmaya calisiyor --->
						SELECT
							*
						FROM
							GET_NEW_COST_ALL
						WHERE
							PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
							AND START_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery>
				</cfif>
				<cfif not GET_COST_1_DEPARTMENT.RECORDCOUNT><!--- lokasyonlu olarakda maliyet bulamadı ise onceki maliyet genel maliyetden alınacak --->
					<cfquery name="GET_COST_1_DEPARTMENT" dbtype="query" maxrows="1">
						SELECT
							*

						FROM
							GET_NEW_COST_ALL
						WHERE
							PRODUCT_ID = <cfqueryparam value="#GET_ACT.PRODUCT_ID#" cfsqltype="cf_sql_integer">
							AND START_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					</cfquery>
				</cfif>
				<!--- spec varsa specli stok degilse urun stok bulunuyor --->
				<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
					
					<cfquery name="GET_STOCK_ACT_DEPARTMENT" datasource="#arguments.period_dsn_type#">
					SELECT
						 SUM(STOCK_IN - STOCK_OUT) AMOUNT,
						PRODUCT_ID
					FROM
						STOCKS_ROW
					WHERE
						PROCESS_TIME = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> 
						AND PRODUCT_ID = #GET_ACT.PRODUCT_ID#
						AND PROCESS_TYPE NOT IN (72,75)
						<cfif is_prod_cost_type eq 0>
							AND (SPECT_VAR_ID IS NULL OR SPECT_VAR_ID = 0)
						</cfif>
						<cfif isdefined('arguments.stock_id') and len(arguments.stock_id) and is_stock_based_cost eq 1>
							AND STOCK_ID =#arguments.stock_id#
						</cfif>
						<cfif isdefined("get_act.ship_row_id") and len(get_act.ship_row_id)>
							AND ROW_ID >  #get_act.ship_row_id#
							AND UPD_ID = #GET_ACT.SHIP_ID# 
						</cfif>
						AND STORE = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
					GROUP BY
						PRODUCT_ID
				</cfquery>
					<cfquery name="GET_STOCK_KONSINYE_DEPARTMENT" dbtype="query">
						SELECT 
							SUM(TOTAL_KONSINYE) TOTAL_KON
						FROM 
							GET_STOCK_KONSINYE_ALL 
						WHERE
							SPECT_MAIN_ID = 0
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
					</cfquery>
				<cfelse>
					<cfquery name="GET_STOCK_ACT_DEPARTMENT" datasource="#arguments.period_dsn_type#">
					SELECT
						 SUM(STOCK_IN - STOCK_OUT) AMOUNT,
						PRODUCT_ID,
						SPECT_VAR_ID
					FROM
						STOCKS_ROW
					WHERE
						PROCESS_TIME = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> 
						AND PRODUCT_ID = #GET_ACT.PRODUCT_ID#
						AND SPECT_VAR_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
						AND PROCESS_TYPE NOT IN (72,75)
						<cfif isdefined("get_act.ship_row_id") and len(get_act.ship_row_id)>
							AND ROW_ID >  #get_act.ship_row_id#
							AND UPD_ID = #GET_ACT.SHIP_ID# 
						</cfif>
						AND STORE = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
					GROUP BY
						PRODUCT_ID,
						SPECT_VAR_ID
				</cfquery>
					<cfquery name="GET_STOCK_KONSINYE_DEPARTMENT" dbtype="query">
						SELECT 
							SUM(TOTAL_KONSINYE) TOTAL_KON
						FROM 
							GET_STOCK_KONSINYE_ALL 
						WHERE
							SPECT_MAIN_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
				<cfif isdefined('GET_STOCK_ACT_DEPARTMENT') and GET_STOCK_ACT_DEPARTMENT.RECORDCOUNT AND LEN(GET_STOCK_ACT_DEPARTMENT.AMOUNT)>
					<cfquery name="GET_COST_AMOUNT_DEPARTMENT" dbtype="query" maxrows="1">
						SELECT
							SUM(ACTION_AMOUNT) COST_AMOUNT
						FROM
							GET_NEW_COST_ALL
						WHERE
							START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							AND RECORD_DATE <cfif arguments.action_row_id gt 0> <= <cfelse> < </cfif> <cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp">
							<cfif arguments.action_row_id gt 0>AND ACTION_ROW_ID <> <cfqueryparam value="#arguments.action_row_id#" cfsqltype="cf_sql_integer"></cfif>
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset paper_stock = GET_STOCK_ACT_DEPARTMENT.AMOUNT>
					<cfif GET_COST_AMOUNT_DEPARTMENT.RECORDCOUNT and len(GET_COST_AMOUNT_DEPARTMENT.COST_AMOUNT)><cfset cost_amt=GET_COST_AMOUNT_DEPARTMENT.COST_AMOUNT><cfelse><cfset cost_amt=0></cfif>
					<cfif not listfind('81,113,58,811,62',GET_ACT.ACTION_CAT,',')>
						<cfset today_stock_act = (GET_STOCK_ACT_DEPARTMENT.AMOUNT-stock_amount_total)-cost_amt>
						<!---BURADA  <CFDUMP VAR="#GET_STOCK_ACT.AMOUNT# - #stock_amount_total# - #cost_amt#"> <BR>--->
					<cfelse>
						<cfif GET_ACT.ACTION_CAT eq 62>
							<cfset today_stock_act = (GET_STOCK_ACT_DEPARTMENT.AMOUNT)-cost_amt+GET_ACT.AMOUNT>
						<cfelse>
							<cfset today_stock_act = (GET_STOCK_ACT_DEPARTMENT.AMOUNT)-cost_amt>
						</cfif>
					</cfif>
				<cfelse>
					<cfset today_stock_act=0>
					<cfset paper_stock = 0>
				</cfif>
				
				<cfif isdefined('GET_STOCK_KONSINYE_DEPARTMENT') and GET_STOCK_KONSINYE_DEPARTMENT.RECORDCOUNT><cfset konsinye_stock_amount=GET_STOCK_KONSINYE_DEPARTMENT.TOTAL_KON><cfelse><cfset konsinye_stock_amount=0></cfif>
				<cfset today_stock_act=today_stock_act+konsinye_stock_amount>
				<!--- aynı gun içinde depolararası sevk ten sonra benzer bir hareket yapıldığında depodan fazladan bir çıkış bulunuyordu yani 30 adet alınmış ve maliyet oluşmuş sonra 10 tanesi depolar arası sevkle sevk edilmiş ancak stok miktarı 20 olması gerekirken gün içinde eklenen maliyetler querysinden 30 gelmesinden dolayı buquery sevk miktarını bulur ve cıkarır --->
				 <cfquery name="GET_STOCK_SEVK_COST_DEPARTMENT" datasource="#arguments.period_dsn_type#">
					SELECT 
						SUM(STOCK_OUT) STOCK_OUT
					FROM
						STOCKS_ROW,
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE
						PRODUCT_COST.PRODUCT_ID = #GET_ACT.PRODUCT_ID# AND
						PRODUCT_COST.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID AND 
						ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(STOCKS_ROW.SPECT_VAR_ID,0) AND
						PRODUCT_COST.RECORD_DATE < <cfqueryparam value="#createodbcdatetime(GET_ACT.RECORD_DATE)#" cfsqltype="cf_sql_timestamp"> AND
						PRODUCT_COST.START_DATE = <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp"> AND
						PRODUCT_COST.ACTION_ID = STOCKS_ROW.UPD_ID AND
						PROCESS_TYPE IN (113) AND
						STOCK_OUT > 0 AND
						STORE = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif len(GET_STOCK_SEVK_COST_DEPARTMENT.STOCK_OUT)><cfset today_stock_act=today_stock_act+GET_STOCK_SEVK_COST_DEPARTMENT.STOCK_OUT></cfif>
				<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
					<cfquery name="GET_STOCK_DEPARTMENT" dbtype="query">
						SELECT
							SUM(AMOUNT_ALL)-(#konsinye_stock_amount+paper_stock#) AS PRODUCT_STOCK,
							PRODUCT_ID
						FROM
							GET_STOCK_ACT_ALL
						WHERE
							PROCESS_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							<cfif is_prod_cost_type eq 0>
								AND (SPECT_VAR_ID IS NULL OR SPECT_VAR_ID = 0)
							</cfif>
							<cfif isdefined('arguments.stock_id') and len(arguments.stock_id) and is_stock_based_cost eq 1>
								AND STOCK_ID =#arguments.stock_id#
							</cfif>
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
						GROUP BY
							PRODUCT_ID
					</cfquery>
				<cfelse>
					<cfquery name="GET_STOCK_DEPARTMENT" dbtype="query">
						SELECT
							SUM(AMOUNT_ALL)-(#konsinye_stock_amount+paper_stock#)  AS PRODUCT_STOCK,
							PRODUCT_ID,
							SPECT_VAR_ID
						FROM
							GET_STOCK_ACT_ALL
						WHERE
							SPECT_VAR_ID = <cfqueryparam value="#GET_SPEC_.SPECT_MAIN_ID#" cfsqltype="cf_sql_integer">
							AND PROCESS_DATE <= <cfqueryparam value="#createodbcdatetime(GET_ACT.ACTION_DATE)#" cfsqltype="cf_sql_timestamp">
							AND DEPARTMENT_ID = <cfqueryparam value="#GET_ACT.ACT_DEPARTMENT_ID#" cfsqltype="cf_sql_integer">
						GROUP BY
							PRODUCT_ID,
							SPECT_VAR_ID
					</cfquery>
				</cfif>
				<cfscript>
				//bir önceki maliyet degerleri
				pre_cost_purchase_net_department = 0;
				pre_cost_purchase_extra_net_department = 0;
				pre_cost_purchase_net_system_department = 0;
				pre_cost_purchase_extra_net_system_department = 0;
				pre_cost_purchase_net_system_2_department = 0;
				pre_cost_purchase_extra_net_system_2_department = 0;
				pre_product_stock_department = 0;
				pre_cost_purchase_reflection_department=0;
				pre_cost_purchase_labor_department=0;
				pre_cost_purchase_reflection_system_department=0;
				pre_cost_purchase_labor_system_department=0;
				pre_cost_purchase_reflection_system_2_department=0;
				pre_cost_purchase_labor_system_2_department=0;				
				
				if(GET_STOCK_DEPARTMENT.RECORDCOUNT and len(GET_STOCK_DEPARTMENT.PRODUCT_STOCK)) product_stock_amount_department=GET_STOCK_DEPARTMENT.PRODUCT_STOCK; else product_stock_amount_department=0;
	
				if(GET_COST_1_DEPARTMENT.RECORDCOUNT)
				{
					if(len(GET_COST_1_DEPARTMENT.PRICE_PROTECTION_DEPARTMENT))//PURCHASE_NET alanında fiyat koruma v.s. tutmadığından tipine göre ekleniyor yada cıkarıyor
					{
						if(GET_COST_1.PRICE_PROTECTION_MONEY neq arguments.cost_money)
						{
							if(isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_COST_1_DEPARTMENT.PRICE_PROTECTION_MONEY_DEPARTMENT,';'))
								rate_price_protection_department=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_COST_1_DEPARTMENT.PRICE_PROTECTION_MONEY_DEPARTMENT,';')-1,';');
							else
								rate_price_protection_department=1;
							pre_price_protection_department=GET_COST_1_DEPARTMENT.PRICE_PROTECTION_DEPARTMENT*rate_price_protection_department;
							pre_price_protection_department=pre_price_protection_department/rate_cost_money;
						}else{
							pre_price_protection_department=GET_COST_1_DEPARTMENT.PRICE_PROTECTION_DEPARTMENT;
						}
						if(len(GET_COST_1_DEPARTMENT.PRICE_PROTECTION_TYPE)) pre_price_protection_department=pre_price_protection_department*GET_COST_1_DEPARTMENT.PRICE_PROTECTION_TYPE;
						
						
					}else{pre_price_protection_department=0;}
					
					if(GET_COST_1.PURCHASE_NET_MONEY_DEPARTMENT neq arguments.cost_money and isdefined('rate_list_fonk') and listfind(rate_list_fonk,GET_COST_1.PURCHASE_NET_MONEY_DEPARTMENT,';'))
						rate_purchase_net_department=listgetat(rate_list_fonk,listfind(rate_list_fonk,GET_COST_1.PURCHASE_NET_MONEY_DEPARTMENT,';')-1,';');
					else
						rate_purchase_net_department=1;
					
					if(GET_COST_1.PURCHASE_NET_MONEY_DEPARTMENT neq arguments.cost_money)
					{
						if(len(GET_COST_1_DEPARTMENT.PURCHASE_NET_DEPARTMENT)) pre_cost_purchase_net_department = ((GET_COST_1_DEPARTMENT.PURCHASE_NET_DEPARTMENT*rate_purchase_net_department)/rate_cost_money)-pre_price_protection_department;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_COST_1_DEPARTMENT.PURCHASE_EXTRA_COST_DEPARTMENT)) pre_cost_purchase_extra_net_department = (GET_COST_1_DEPARTMENT.PURCHASE_EXTRA_COST_DEPARTMENT*rate_purchase_net_department)/rate_cost_money;
						if(len(GET_COST_1_DEPARTMENT.STATION_REFLECTION_COST_DEPARTMENT)) pre_cost_purchase_reflection_department = (GET_COST_1_DEPARTMENT.STATION_REFLECTION_COST_DEPARTMENT*rate_purchase_net_department)/rate_cost_money;
						if(len(GET_COST_1_DEPARTMENT.LABOR_COST_DEPARTMENT)) pre_cost_purchase_labor_department = (GET_COST_1_DEPARTMENT.LABOR_COST_DEPARTMENT*rate_purchase_net_department)/rate_cost_money;
					}
					else
					{
						if(len(GET_COST_1_DEPARTMENT.PURCHASE_NET_DEPARTMENT)) pre_cost_purchase_net_department = GET_COST_1_DEPARTMENT.PURCHASE_NET_DEPARTMENT-pre_price_protection_department;//fiyat kontrol v.s. düşmek gerek
						if(len(GET_COST_1_DEPARTMENT.PURCHASE_EXTRA_COST_DEPARTMENT)) pre_cost_purchase_extra_net_department = GET_COST_1_DEPARTMENT.PURCHASE_EXTRA_COST_DEPARTMENT;
						if(len(GET_COST_1_DEPARTMENT.STATION_REFLECTION_COST_DEPARTMENT)) pre_cost_purchase_reflection_department = (GET_COST_1_DEPARTMENT.STATION_REFLECTION_COST_DEPARTMENT);
						if(len(GET_COST_1_DEPARTMENT.LABOR_COST_DEPARTMENT)) pre_cost_purchase_labor_department = (GET_COST_1_DEPARTMENT.LABOR_COST_DEPARTMENT);
					}					
					if(len(GET_COST_1_DEPARTMENT.PURCHASE_NET_SYSTEM_DEPARTMENT)) pre_cost_purchase_net_system_department = GET_COST_1_DEPARTMENT.PURCHASE_NET_SYSTEM_DEPARTMENT;
					if(len(GET_COST_1_DEPARTMENT.PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT)) pre_cost_purchase_extra_net_system_department = GET_COST_1_DEPARTMENT.PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT;
					if(len(GET_COST_1_DEPARTMENT.PURCHASE_NET_SYSTEM_2_DEPARTMENT)) pre_cost_purchase_net_system_2_department = GET_COST_1_DEPARTMENT.PURCHASE_NET_SYSTEM_2_DEPARTMENT;
					if(len(GET_COST_1_DEPARTMENT.PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT)) pre_cost_purchase_extra_net_system_2_department = GET_COST_1_DEPARTMENT.PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT;
					if(len(GET_COST_1_DEPARTMENT.STATION_REFLECTION_COST_SYSTEM_DEPARTMENT)) pre_cost_purchase_reflection_system_department = GET_COST_1_DEPARTMENT.STATION_REFLECTION_COST_SYSTEM_DEPARTMENT;
					if(len(GET_COST_1_DEPARTMENT.LABOR_COST_SYSTEM_LOCATION)) pre_cost_purchase_labor_system_department = GET_COST_1_DEPARTMENT.LABOR_COST_SYSTEM_LOCATION;
					if(len(GET_COST_1_DEPARTMENT.STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT)) pre_cost_purchase_reflection_system_2_department = GET_COST_1_DEPARTMENT.STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT;
					if(len(GET_COST_1_DEPARTMENT.LABOR_COST_SYSTEM_2_LOCATION)) pre_cost_purchase_labor_system_2_department = GET_COST_1_DEPARTMENT.LABOR_COST_SYSTEM_2_LOCATION;
					
					/*stock_cost_paper = stock_amount_total * pre_cost_purchase_net_department;
					stock_cost_extra_paper = stock_amount_total * pre_cost_purchase_extra_net_department;
					stock_cost_paper_system = stock_amount_total * pre_cost_purchase_net_system_department;
					stock_cost_extra_paper_system = stock_amount_total * pre_cost_purchase_extra_net_system_department;
					stock_cost_paper_system_2 = stock_amount_total * pre_cost_purchase_net_system_2_department;
					stock_cost_extra_paper_system_2 = stock_amount_total * pre_cost_purchase_extra_net_system_2_department;*/
					stock_cost_reflection_paper = pre_cost_purchase_reflection_department*stock_amount_total;
					stock_cost_labor_paper = pre_cost_purchase_labor_department*stock_amount_total;
					stock_cost_reflection_paper_system = pre_cost_purchase_reflection_system_department*stock_amount_total;
					stock_cost_labor_paper_system = pre_cost_purchase_labor_system_department*stock_amount_total;
					stock_cost_reflection_paper_system_2 = pre_cost_purchase_reflection_system_2_department*stock_amount_total;
					stock_cost_labor_paper_system_2 = pre_cost_purchase_labor_system_2_department*stock_amount_total;
				}
				
				if(GET_ACT.ACTION_CAT neq 0)
				{
					if(get_act.purchase_sales is 0 or listfind('81,113,811',GET_ACT.ACTION_CAT,','))
						all_stock_amount_department = product_stock_amount_department - stock_amount_total;
					else
						all_stock_amount_department = product_stock_amount_department + stock_amount_total;
				}else
				{
					all_stock_amount_department = product_stock_amount;
				}
				
				
								
				//writeoutput('#product_stock_amount_department#-#stock_amount_total#');
				if(all_stock_amount_department gte 0 and product_stock_amount_department gt 0 and GET_ACT.ACTION_CAT neq 0)
				{//islem yapildigi tarihdeki stok 0 ise veya islem miktari eklendiğinde 1 den küçükse direk tutar maliyet olarak kaydedilecek öyle değil ise bu hesaplar yapılır
					//stoktaki ürünlerin toplam maliyetleri parabirimi cinslerine göre
					if(isdefined('arguments.action_type') and arguments.action_type eq 4){//Sadedece Üretimden Belge Oluştururken buraya girsin.
						if(pre_cost_purchase_net_department eq 0 and all_stock_amount gt 0){//Önceki net maliyet 0 olarak geliyor fakat toplam stok miktarı ise 0dan büyük ise böyle bir durum ortaya çıkıyor
							//Sadece 2 tane üretim emrinin olduğu caselerde ortaya çıktı//Çünkü aşağıda all_stock_amount*pre_cost_purchase_net_department dendiği için diyelim toplam stok miktarı 100 olsun all_stock_amount 0 ise toplam stok maliyetini 0 olarak hesaplıyor..M.ER,gereksiz ise kaldırılır ilerde..
							////Çünkü aşağıda all_stock_amount*pre_cost_purchase_net_department dendiği için diyelim toplam stok miktarı 100 olsun all_stock_amount 0 ise toplam stok maliyetini 0 olarak hesaplıyor..M.ER,gereksiz ise kaldırılır ilerde..
							pre_cost_purchase_net_department = price_system/ rate_cost_money;
							pre_cost_purchase_net_system_department = price_system;
							pre_cost_purchase_net_system_2_department = price_system/rate_system_2;
							//lokasyon bazında soru olursa burada düzenleme yapılabilir...
							pre_cost_purchase_extra_net_department = (system_money_cost_extra_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_extra_net_system_department = (system_money_cost_extra_row/stock_amount_row);
							pre_cost_purchase_net_system_2_department = (system_money_cost_extra_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_reflection_department = (system_money_cost_reflection_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_labor_department = (system_money_cost_labor_row/stock_amount_row) /rate_cost_money;
							pre_cost_purchase_reflection_system_department = (system_money_cost_reflection_row/stock_amount_row);
							pre_cost_purchase_labor_system_department = (system_money_cost_labor_row/stock_amount_row);
							pre_cost_purchase_reflection_system_2_department = (system_money_cost_reflection_row/stock_amount_row)/rate_system_2;
							pre_cost_purchase_labor_system_2_department = (system_money_cost_labor_row/stock_amount_row)/rate_system_2;
							///writeoutput('<br/>aaaaaaaaaaaaaaaaall_stock_extra_cost = #all_stock_amount# * #pre_cost_purchase_extra_net# __#price_system#_<br/>');
						}						
					}

					if((isdefined('arguments.action_type') and arguments.action_type eq 8) or GET_ACT.ACTION_CAT eq 81)  // 0919 PY sevk işlemlerinde bir önceki maliyeti lokasyon bazlı bulması için
					{//ambar ve depolararası sevk işlemi veya fiyat farkı dağılımından geliyor ise tutarlar önceki maliyet ile bire bir aynı olacaktır
						str = "SELECT ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT),4) AS PRE_COST,ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4) AS PRE_COST_EXTRA,ROUND(PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,4) pre_net_system,ROUND(PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,4) pre_net_system_extra,ROUND(PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,4) pre_net_system_2,ROUND(PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,4) as  pre_net_system_extra_2 FROM PRODUCT_COST WHERE START_DATE <=#createodbcdate(GET_ACT.ACTION_DATE)# AND PRODUCT_ID = #GET_ACT.PRODUCT_ID# AND DEPARTMENT_ID = #GET_ACT.ACT_OUT_DEPARTMENT_ID#";
						getprelocation = cfquery(SQLString : str, Datasource : dsn3);
						
						stock_cost_ = getprelocation.PRE_COST;
						stock_cost_extra_ = getprelocation.PRE_COST_EXTRA;
						stock_cost_system_ = getprelocation.pre_net_system;
						stock_cost_extra_system_ = getprelocation.pre_net_system_extra;
						stock_cost_system_2_ = getprelocation.pre_net_system_2;
						stock_cost_extra_system_2_ = getprelocation.pre_net_system_extra_2;
						
						if(stock_cost_ gt 0){
							stock_cost_paper = stock_amount_total * stock_cost_;
							stock_cost_extra_paper = stock_amount_total * stock_cost_extra_;
							stock_cost_paper_system = stock_amount_total * stock_cost_system_;
							stock_cost_extra_paper_system = stock_amount_total * stock_cost_extra_system_;
							stock_cost_paper_system_2 = stock_amount_total * stock_cost_system_2_;
							stock_cost_extra_paper_system_2 = stock_amount_total * stock_cost_extra_system_2_;
						}
						else
						{
							stock_cost_paper = 0;
							stock_cost_extra_paper = 0;
							stock_cost_paper_system = 0;
							stock_cost_extra_paper_system = 0;
							stock_cost_paper_system_2 = 0;
							stock_cost_extra_paper_system_2 = 0;
						}
					}

					all_stock_cost_department = all_stock_amount_department * pre_cost_purchase_net_department;
					all_stock_extra_cost_department = all_stock_amount_department * pre_cost_purchase_extra_net_department;
					all_stock_cost_system_department = all_stock_amount_department * pre_cost_purchase_net_system_department;
					all_stock_extra_cost_system_department = all_stock_amount_department * pre_cost_purchase_extra_net_system_department;
					all_stock_cost_system_2_department = all_stock_amount_department * pre_cost_purchase_net_system_2_department;
					all_stock_extra_cost_system_2_department = all_stock_amount_department * pre_cost_purchase_extra_net_system_2_department;
					all_stock_cost_reflection_department = all_stock_amount_department * pre_cost_purchase_reflection_department;
					all_stock_cost_labor_department = all_stock_amount_department * pre_cost_purchase_labor_department;
					all_stock_cost_reflection_system_department = all_stock_amount_department * pre_cost_purchase_reflection_system_department;
					all_stock_cost_labor_system_department = all_stock_amount_department * pre_cost_purchase_labor_system_department;
					all_stock_cost_reflection_system_2_department = all_stock_amount_department * pre_cost_purchase_reflection_system_2_department;
					all_stock_cost_labor_system_2_department = all_stock_amount_department * pre_cost_purchase_labor_system_2_department;
					if(get_act.purchase_sales eq 0 or listfind('81,113,811',GET_ACT.ACTION_CAT,',') or GET_ACT.ACTION_CAT eq 0)
					{//elle eklenen maliyet ve ithal mal girisinde stok girisi yapmadigi icin
						stock_cost_department = all_stock_cost_department + stock_cost_paper;
						stock_cost_extra_department = all_stock_extra_cost_department + stock_cost_extra_paper;
						stock_cost_system_department = all_stock_cost_system_department + stock_cost_paper_system;
						stock_cost_extra_system_department = all_stock_extra_cost_system_department + stock_cost_extra_paper_system;
						stock_cost_system_2_department = all_stock_cost_system_2_department + stock_cost_paper_system_2;
						stock_cost_extra_system_2_department = all_stock_extra_cost_system_2_department + stock_cost_extra_paper_system_2;
						stock_cost_reflection_department = all_stock_cost_reflection_department + stock_cost_reflection_paper;
						stock_cost_labor_department = all_stock_cost_labor_department + stock_cost_labor_paper;
						stock_cost_reflection_system_department = all_stock_cost_reflection_system_department + stock_cost_reflection_paper_system;
						stock_cost_labor_system_department = all_stock_cost_labor_system_department + stock_cost_labor_paper_system;
						stock_cost_reflection_system_2_department = all_stock_cost_reflection_system_2_department + stock_cost_reflection_paper_system_2;
						stock_cost_labor_system_2_department = all_stock_cost_labor_system_2_department + stock_cost_labor_paper_system_2;
					}
					else
					{
						stock_cost_department = all_stock_cost_department - stock_cost_paper;
						stock_cost_extra_department = all_stock_extra_cost_department - stock_cost_extra_paper;
						stock_cost_system_department = all_stock_cost_system_department - stock_cost_paper_system;
						stock_cost_extra_system_department = all_stock_extra_cost_system_department - stock_cost_extra_paper_system;
						stock_cost_system_2_department = all_stock_cost_system_2_department - stock_cost_paper_system_2;
						stock_cost_extra_system_2_department = all_stock_extra_cost_system_2_department - stock_cost_extra_paper_system_2;
						stock_cost_reflection_department = all_stock_cost_reflection_department - stock_cost_reflection_paper;
						stock_cost_labor_department = all_stock_cost_labor_department - stock_cost_labor_paper;
						stock_cost_reflection_system_department = all_stock_cost_reflection_system_department - stock_cost_reflection_paper_system;
						stock_cost_labor_system_department = all_stock_cost_labor_system_department - stock_cost_labor_paper_system;
						stock_cost_reflection_system_2_department = all_stock_cost_reflection_system_2_department - stock_cost_reflection_paper_system_2;
						stock_cost_labor_system_2_department = all_stock_cost_labor_system_2_department - STOCK_COST_LABOR_PAPER_SYSTEM_2;
					}
					//writeoutput(stock_cost_department);
					if(GET_ACT.ACTION_CAT neq 0 or not listfind('81,113,811',GET_ACT.ACTION_CAT,','))
					{
						if(product_stock_amount_department gt 0)
						{
							stock_cost_department = stock_cost_department / product_stock_amount_department;
							stock_cost_extra_department = stock_cost_extra_department / product_stock_amount_department;
							stock_cost_system_department = stock_cost_system_department / product_stock_amount_department;
							stock_cost_extra_system_department = stock_cost_extra_system_department / product_stock_amount_department;
							stock_cost_system_2_department = stock_cost_system_2_department / product_stock_amount_department;
							stock_cost_extra_system_2_department = stock_cost_extra_system_2_department / product_stock_amount_department;
							stock_cost_reflection_department = stock_cost_reflection_department / product_stock_amount_department;
							stock_cost_labor_department = stock_cost_labor_department / product_stock_amount_department;
							stock_cost_reflection_system_department = stock_cost_reflection_system_department / product_stock_amount_department;
							stock_cost_labor_system_department = stock_cost_labor_system_department / product_stock_amount_department;
							stock_cost_reflection_system_2_department = stock_cost_reflection_system_2_department / product_stock_amount_department;
							stock_cost_labor_system_2_department = stock_cost_labor_system_2_department / product_stock_amount_department;
						}else
						{
							stock_cost_department = stock_cost_department / stock_amount_total;
							stock_cost_extra_department = stock_cost_extra_department / stock_amount_total;
							stock_cost_system_department = stock_cost_system_department / stock_amount_total;
							stock_cost_extra_system_department = stock_cost_extra_system_department / stock_amount_total;
							stock_cost_system_2_department = stock_cost_system_2_department / stock_amount_total;
							stock_cost_extra_system_2_department = stock_cost_extra_system_2_department / stock_amount_total;
							stock_cost_reflection_department = stock_cost_reflection_department / stock_amount_total;
							stock_cost_labor_department = stock_cost_labor_department / stock_amount_total;
							stock_cost_reflection_system_department = stock_cost_reflection_system_department / stock_amount_total;
							stock_cost_labor_system_department = stock_cost_labor_system_department / stock_amount_total;
							stock_cost_reflection_system_2_department = stock_cost_reflection_system_2_department / stock_amount_total;
							stock_cost_labor_system_2_department = stock_cost_labor_system_2_department / stock_amount_total;
						}
					}else
					{
						if(product_stock_amount_department+stock_amount_total gt 0)
						{
							stock_cost_department = stock_cost_department/(product_stock_amount_department+stock_amount_total);
							stock_cost_extra_department = stock_cost_extra_department/(product_stock_amount_department+stock_amount_total);
							stock_cost_system_department = stock_cost_system_department/(product_stock_amount_department+stock_amount_total);
							stock_cost_extra_system_department = stock_cost_extra_system_department/(product_stock_amount_department+stock_amount_total);
							stock_cost_system_2_department = stock_cost_system_2_department/(product_stock_amount_department+stock_amount_total);
							stock_cost_extra_system_2_department = stock_cost_extra_system_2_department/(product_stock_amount_department+stock_amount_total);
							stock_cost_reflection_department = stock_cost_reflection_department / (product_stock_amount_department+stock_amount_total);
							stock_cost_labor_department = stock_cost_labor_department / (product_stock_amount_department+stock_amount_total);
							stock_cost_reflection_system_department = stock_cost_reflection_system_department / (product_stock_amount_department+stock_amount_total);
							stock_cost_labor_system_department = stock_cost_labor_system_department / (product_stock_amount_department+stock_amount_total);
							stock_cost_reflection_system_2_department = stock_cost_reflection_system_2_department / (product_stock_amount_department+stock_amount_total);
							stock_cost_labor_system_2_department = stock_cost_labor_system_2_department / (product_stock_amount_department+stock_amount_total);
						}
					}
				}else
				{
					if(stock_amount_total neq 0)// and not listfind('81,113,811',GET_ACT.ACTION_CAT,',')
					{
						stock_cost_department = stock_cost_paper/ stock_amount_total;
						stock_cost_extra_department = stock_cost_extra_paper/ stock_amount_total;
						stock_cost_system_department = stock_cost_paper_system/ stock_amount_total;
						stock_cost_extra_system_department = stock_cost_extra_paper_system/ stock_amount_total;
						stock_cost_system_2_department = stock_cost_paper_system_2/ stock_amount_total;
						stock_cost_extra_system_2_department = stock_cost_extra_paper_system_2/ stock_amount_total;
						stock_cost_reflection_department = stock_cost_reflection_paper / stock_amount_total;
						stock_cost_labor_department = stock_cost_labor_paper / stock_amount_total;
						stock_cost_reflection_system_department = stock_cost_reflection_paper_system / stock_amount_total;
						stock_cost_labor_system_department = stock_cost_labor_paper_system / stock_amount_total;
						stock_cost_reflection_system_2_department = stock_cost_reflection_paper_system_2 / stock_amount_total;
						stock_cost_labor_system_2_department = STOCK_COST_LABOR_PAPER_SYSTEM_2 / stock_amount_total;
					}else
					{
						stock_cost_department = 0;
						stock_cost_extra_department = 0;
						stock_cost_system_department = 0;
						stock_cost_extra_system_department = 0;
						stock_cost_system_2_department = 0;
						stock_cost_extra_system_2_department = 0;
						stock_cost_reflection_department = 0;
						stock_cost_labor_department = 0;
						stock_cost_reflection_system_department = 0;
						stock_cost_labor_system_department = 0;
						stock_cost_reflection_system_2_department = 0;
						stock_cost_labor_system_2_department = 0;
					}
				}
				
				if(arguments.is_cost_calc_type is 1)
				{
					if(isdefined('arguments.cost_money_system') and len(arguments.cost_money_system))//sistem parabrimi tutarı
					{
						stock_cost_department = stock_cost_system_department / rate_cost_money;
						stock_cost_extra_department =stock_cost_extra_system_department/ rate_cost_money;
						stock_cost_reflection_department =stock_cost_reflection_system_department/ rate_cost_money;
						stock_cost_labor_department =stock_cost_labor_system_department/ rate_cost_money;
					}
					if(isdefined('arguments.cost_money_system_2') and len(arguments.cost_money_system_2))//sistem 2. parabrimi tutarı
					{
						stock_cost_system_2_department = stock_cost_system_department / rate_system_2;
						stock_cost_extra_system_2_department = wrk_round(stock_cost_extra_system_department / rate_system_2,8);
						stock_cost_reflection_system_2_department = wrk_round(stock_cost_reflection_system_department / rate_system_2,8);
						stock_cost_labor_system_2_department = wrk_round(stock_cost_labor_system_department / rate_system_2,8);
					}
				}
			</cfscript>
			</cfif>
            <!---/ depo bazlı--->
		</cfif>
	</cfif><!---// 0 tutarlı satırlar maliyet oluştursun dendi ise 0 dan büyük ise girer bloğa --->
</cfif>
<cfset stock_cost = "#stock_cost#;#stock_cost_extra#;#product_stock_amount#;#stock_cost_system#;#stock_cost_extra_system#;#stock_cost_system_2#;#stock_cost_extra_system_2#;#product_stock_amount_location#;#stock_cost_location#;#stock_cost_extra_location#;#stock_cost_system_location#;#stock_cost_extra_system_location#;#stock_cost_system_2_location#;#stock_cost_extra_system_2_location#;#price_system#;#extra_cost_system_#;#product_stock_amount_department#;#stock_cost_department#;#stock_cost_extra_department#;#stock_cost_system_department#;#stock_cost_extra_system_department#;#stock_cost_system_2_department#;#stock_cost_extra_system_2_department#;#stock_cost_reflection#;#stock_cost_labor#;#stock_cost_reflection_location#;#stock_cost_labor_location#;#stock_cost_reflection_department#;#stock_cost_labor_department#;#stock_cost_reflection_system#;#stock_cost_labor_system#;#stock_cost_reflection_system_location#;#stock_cost_labor_system_location#;#stock_cost_reflection_system_department#;#stock_cost_labor_system_department#;#stock_cost_reflection_system_2#;#stock_cost_labor_system_2#;#stock_cost_reflection_system_2_location#;#stock_cost_labor_system_2_location#;#stock_cost_reflection_system_2_department#;#stock_cost_labor_system_2_department#;">
<!---<cfoutput><font color="blue">[stock_cost :::::[#stock_cost#]***</font></cfoutput> <br>--->