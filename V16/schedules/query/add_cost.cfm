<!--- TolgaS 20070726 bir gün önceki belgeler üzerinden çalışmayan maliyet işlemleri varsa onları çalıştırır (add_optionda da var birtane ordaki fark ekran çıktısını mail atması )--->
<cfsetting showdebugoutput="no">
<cfquery name="get_per_schedule" datasource="#dsn#"><!--- Şirketler ve Periodlar. --->
	SELECT 
		SETUP_PERIOD.OUR_COMPANY_ID,
		SETUP_PERIOD.PERIOD_ID,
		SETUP_PERIOD.PERIOD_YEAR,
		OUR_COMPANY.COMPANY_NAME
	FROM 
		SETUP_PERIOD,
		OUR_COMPANY_INFO,
		OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID = OUR_COMPANY_INFO.COMP_ID AND
		OUR_COMPANY_INFO.COMP_ID=SETUP_PERIOD.OUR_COMPANY_ID AND
		OUR_COMPANY_INFO.IS_COST = 1 AND
		PERIOD_YEAR = #YEAR(NOW())#
	ORDER BY
		OUR_COMPANY.COMP_ID
</cfquery>
<cfparam name="attributes.aktarim_date1" default="#dateformat(date_add('d',-1,now()),dateformat_style)#">
<cf_date tarih='attributes.aktarim_date1'>
<cfloop from="1" to="#get_per_schedule.recordcount#" index="per_ind_id">
	<cfscript>
		attributes.aktarim_kaynak_company = evaluate('get_per_schedule.OUR_COMPANY_ID[#per_ind_id#]');
		attributes.aktarim_kaynak_period = evaluate('get_per_schedule.PERIOD_ID[#per_ind_id#]');
		attributes.aktarim_kaynak_year = evaluate('get_per_schedule.PERIOD_YEAR[#per_ind_id#]');
		
		dsn3 = '#dsn#_#attributes.aktarim_kaynak_company#';
		dsn3_alias = '#dsn#_#attributes.aktarim_kaynak_company#';
		if(database_type eq "MSSQL")
		{
			dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#';
			dsn2_alias = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#';
		}
		else if(database_type eq "DB2")
		{
			dsn2 = '#dsn#_#MID(attributes.aktarim_kaynak_year,3,2)#_#attributes.aktarim_kaynak_company#';
			dsn2_alias = '#dsn#_#MID(attributes.aktarim_kaynak_year,3,2)#_#attributes.aktarim_kaynak_company#';
		}
		attributes.dsn_type = dsn3;
		attributes.period_dsn_type = dsn2;
		attributes.user_id = 1;
		attributes.period_id = attributes.aktarim_kaynak_period;
		attributes.company_id = attributes.aktarim_kaynak_company;
		attributes.is_print = 1;
		attributes.not_close_page = 1;
		attributes.is_schedules = cgi.REMOTE_ADDR;
	</cfscript>
	<cfoutput><br/><br/><b>#dsn3#---#dsn2#</b><br/><br/></cfoutput>
	<!--- maliyet islemi yapacak kategori varmi --->
	<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
		SELECT
			PROCESS_CAT_ID,
			PROCESS_TYPE,
			IS_COST
		FROM 
			SETUP_PROCESS_CAT
		WHERE 
			IS_COST = 1
	</cfquery>
	<cfif GET_PROCESS_CAT.RECORDCOUNT>
		<cfset proc_list=valuelist(GET_PROCESS_CAT.PROCESS_CAT_ID,',')>
	</cfif>

	<cfquery name="GET_NOT_DEP_COST_" datasource="#DSN#">
		SELECT 
			DEPARTMENT_ID,LOCATION_ID 
		FROM 
			STOCKS_LOCATION STOCKS_LOCATION
		WHERE 
			ISNULL(IS_COST_ACTION,0)=1
	</cfquery>
	<!--- <cfinclude template="../../objects/functions/cost_action.cfm"> --->
		
	
	<!--- silmeeeeeeeeee --->
	<b>1. Adım Silinmiş Belgelerden Maliyeti Silinmeyenler</b><br/>
    <cfquery name="GET_DELETE_PAPER" datasource="#dsn3#">
		SELECT DISTINCT
			ACTION_ID,
			PRODUCT_COST_ID,
			ACTION_TYPE,
			START_DATE ACTION_DATE
		FROM
			PRODUCT_COST
		WHERE
			START_DATE >= #CreateDateTime(DateFormat(now(),'YYYY'),1,1,00,00,00)# AND
            (
				(ACTION_TYPE = 1 AND ACTION_PERIOD_ID = #attributes.aktarim_kaynak_period# AND ACTION_ID NOT IN(SELECT INVOICE_ID FROM #dsn2#.INVOICE WHERE IS_IPTAL<>1))
			OR
				(ACTION_TYPE = 2 AND ACTION_PERIOD_ID = #attributes.aktarim_kaynak_period# AND ACTION_ID NOT IN(SELECT SHIP_ID FROM #dsn2#.SHIP WHERE IS_SHIP_IPTAL<>1))
			OR
				(ACTION_TYPE = 3 AND ACTION_PERIOD_ID = #attributes.aktarim_kaynak_period# AND ACTION_ID NOT IN(SELECT FIS_ID FROM #dsn2#.STOCK_FIS))
			OR
				(ACTION_TYPE = 4 AND ACTION_PERIOD_ID = #attributes.aktarim_kaynak_period# AND ACTION_ID NOT IN(SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS))
			OR
				(ACTION_TYPE = 5 AND ACTION_PERIOD_ID = #attributes.aktarim_kaynak_period# AND ACTION_ID NOT IN(SELECT STOCK_EXCHANGE_ID FROM #dsn2#.STOCK_EXCHANGE))
			)
    </cfquery>
	<cfoutput>Toplam #GET_DELETE_PAPER.RECORDCOUNT# adet belgenin maliyetleri silinecek.<br /></cfoutput>
	<cfset attributes.query_type=3>
	<cfif GET_DELETE_PAPER.RECORDCOUNT>
		<cfoutput query="GET_DELETE_PAPER">
			<cfif ACTION_TYPE eq 1>Fatura ID:<cfelseif ACTION_TYPE eq 2>İrsaliye ID:<cfelseif ACTION_TYPE eq 3>Stok Fişi ID:<cfelseif ACTION_TYPE eq 4>Üretim Sonucu:<cfelse>Stok Virman</cfif>#ACTION_ID# Tarih:#dateformat(ACTION_DATE,'dd:mm:yyyy')#<br />
			<cfset attributes.action_type=#ACTION_TYPE#>
			<cfset attributes.action_id=#ACTION_ID#>
			<cfinclude template="../../objects/query/cost_action.cfm"><br />
		</cfoutput>
	</cfif>
	<!--- //silmeeeeeeeeee --->	

	<!--- maliyet islemi yapacak kategori varmi --->
	<b>2. Maliyetleri Oluşturma</b>
	<cfquery name="GET_INVOICE" datasource="#dsn2#">
		SELECT DISTINCT
			1 ACTION_TYPE,
			2 QUERY_TYPE,
			INVOICE.INVOICE_ID ACTION_ID,
			INVOICE.INVOICE_DATE ACTION_DATE,
			INVOICE.RECORD_DATE INSERT_DATE,
			INVOICE.INVOICE_NUMBER AS PAPER_NUMBER_
		FROM 
			INVOICE,
			INVOICE_ROW,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
			INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
			INVOICE_ROW.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			PRODUCT.IS_COST=1 AND
			PROCESS_CAT IN (#proc_list#)
			AND INVOICE.INVOICE_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=1)
			AND	INVOICE.RECORD_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
			<cfif GET_NOT_DEP_COST_.RECORDCOUNT>
			AND
				( 
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST_">
					<cfset rw_count=rw_count+1>
					NOT (DEPARTMENT_LOCATION = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
				</cfloop>
				)
			</cfif>
	UNION ALL
		SELECT  DISTINCT
			2 ACTION_TYPE,
			2 QUERY_TYPE,
			SHIP.SHIP_ID ACTION_ID,
			SHIP.SHIP_DATE ACTION_DATE,
			SHIP.RECORD_DATE INSERT_DATE,
			SHIP.SHIP_NUMBER AS PAPER_NUMBER_
		FROM 
			SHIP,
			SHIP_ROW,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
			SHIP.SHIP_ID=SHIP_ROW.SHIP_ID AND
			SHIP_ROW.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			PRODUCT.IS_COST=1 AND
			PROCESS_CAT	 IN (#proc_list#) AND
			SHIP.SHIP_ID NOT IN (
						SELECT 
							SHIP_ID 
						FROM 
							INVOICE_SHIPS,INVOICE 
						WHERE 
							INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND 
							INVOICE.PROCESS_CAT IN (#proc_list#) 
						)
			AND SHIP.SHIP_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=2)
			AND	SHIP.RECORD_DATE >= #attributes.aktarim_date1#
			<cfif GET_NOT_DEP_COST_.RECORDCOUNT>
			AND
				( 
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST_">
					<cfset rw_count=rw_count+1>
					NOT (LOCATION_IN = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND DEPARTMENT_IN = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
				</cfloop>
				)
			</cfif>
	UNION ALL
		SELECT DISTINCT
			3 ACTION_TYPE,
			2 QUERY_TYPE,
			STOCK_FIS.FIS_ID ACTION_ID,
			STOCK_FIS.FIS_DATE ACTION_DATE,
			STOCK_FIS.RECORD_DATE INSERT_DATE,
			STOCK_FIS.FIS_NUMBER AS PAPER_NUMBER_
		FROM 
			STOCK_FIS,
			STOCK_FIS_ROW,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
			STOCK_FIS.FIS_ID=STOCK_FIS_ROW.FIS_ID AND
			STOCKS.STOCK_ID=STOCK_FIS_ROW.STOCK_ID AND
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			PRODUCT.IS_COST=1 AND
			PROCESS_CAT IN (#proc_list#)
			AND STOCK_FIS.FIS_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=3)
			AND	STOCK_FIS.RECORD_DATE >= #attributes.aktarim_date1#
			<cfif GET_NOT_DEP_COST_.RECORDCOUNT>
			AND
				( 
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST_">
					<cfset rw_count=rw_count+1>
					NOT (LOCATION_IN = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND DEPARTMENT_IN = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
				</cfloop>
				)
			</cfif>
	UNION ALL
		SELECT DISTINCT
			5 ACTION_TYPE,
			2 QUERY_TYPE,
			STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ID,
			STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
			STOCK_EXCHANGE.RECORD_DATE INSERT_DATE,
			'' AS PAPER_NUMBER_
		FROM 
			STOCK_EXCHANGE,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
			STOCKS.STOCK_ID=STOCK_EXCHANGE.STOCK_ID AND
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			PRODUCT.IS_COST=1 AND
			PROCESS_CAT IN (#proc_list#)
			AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=5)
			AND	STOCK_EXCHANGE.RECORD_DATE >= #attributes.aktarim_date1#
			AND STOCK_EXCHANGE.STOCK_EXCHANGE_TYPE=1
			<cfif GET_NOT_DEP_COST_.RECORDCOUNT>
			AND
				( 
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST_">
					<cfset rw_count=rw_count+1>
					NOT (LOCATION_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
				</cfloop>
				)
			</cfif>
	UNION ALL
		SELECT DISTINCT
			7 ACTION_TYPE,
			2 QUERY_TYPE,
			STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ID,
			STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
			STOCK_EXCHANGE.RECORD_DATE INSERT_DATE,
			'' AS PAPER_NUMBER_
		FROM 
			STOCK_EXCHANGE,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
			STOCKS.STOCK_ID=STOCK_EXCHANGE.STOCK_ID AND
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			PRODUCT.IS_COST=1 AND
			PROCESS_CAT IN (#proc_list#)
			AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=7)
			AND	STOCK_EXCHANGE.RECORD_DATE >= #attributes.aktarim_date1#
			AND STOCK_EXCHANGE.STOCK_EXCHANGE_TYPE=0
			<cfif GET_NOT_DEP_COST_.RECORDCOUNT>
			AND
				( 
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST_">
					<cfset rw_count=rw_count+1>
					NOT (LOCATION_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
				</cfloop>
				)
			</cfif>
	UNION ALL
		SELECT DISTINCT
			8 ACTION_TYPE,
			2 QUERY_TYPE,
			PRODUCT_COST_INVOICE.INVOICE_ID ACTION_ID,
			PRODUCT_COST_INVOICE.COST_DATE ACTION_DATE,
			PRODUCT_COST_INVOICE.RECORD_DATE INSERT_DATE,
			'' AS PAPER_NUMBER_
		FROM 
			PRODUCT_COST_INVOICE,
			INVOICE,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
			STOCKS.STOCK_ID=PRODUCT_COST_INVOICE.STOCK_ID AND
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			PRODUCT.IS_COST=1 AND
			PROCESS_CAT IN (#proc_list#)
			AND INVOICE.INVOICE_ID = PRODUCT_COST_INVOICE.INVOICE_ID
			AND PRODUCT_COST_INVOICE.INVOICE_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=8)
			AND	PRODUCT_COST_INVOICE.RECORD_DATE >= #attributes.aktarim_date1#
			<cfif GET_NOT_DEP_COST_.RECORDCOUNT>
			AND
				( 
				<cfset rw_count=0>
				<cfloop query="GET_NOT_DEP_COST_">
					<cfset rw_count=rw_count+1>
					NOT (DEPARTMENT_LOCATION = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
					<cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
				</cfloop>
				)
			</cfif>
	ORDER BY 
		ACTION_DATE,
		INSERT_DATE
	</cfquery>
	
	<cfoutput>Toplam #GET_INVOICE.RECORDCOUNT# adet belge var.<br /></cfoutput>
	<cfif GET_INVOICE.RECORDCOUNT>
		<cfset attributes.query_type=2>
		<cfoutput query="GET_INVOICE">
			Belge Numarası: #PAPER_NUMBER_# <cfif ACTION_TYPE eq 1>Fatura ID:<cfelseif ACTION_TYPE eq 2>İrsaliye ID:<cfelseif ACTION_TYPE eq 3>Stok Fişi ID:<cfelseif ACTION_TYPE eq 5>Stok Virman:</cfif> #ACTION_ID# Tarih:#dateformat(ACTION_DATE,'dd:mm:yyyy')#<br/>
			<cfset attributes.action_type=#ACTION_TYPE#>
			<cfset attributes.action_id=#ACTION_ID#>
			<cfinclude template="../../objects/query/cost_action.cfm"><br />
		</cfoutput>
	</cfif>
	<!--- //maliyet islemi yapacak kategori varmi --->
	
	
	<!--- uretim maliyetlerinin eklenmesi --->
	<!--- maliyet islemi yapacak kategori varmi --->
	<b>3. Üretimden Maliyetleri Oluşturma</b>
	
	<!--- malyiet olusturmamıs uretim sonucları --->
	<cfquery name="GET_PROD" datasource="#dsn3#">
		SELECT
			4 ACTION_TYPE,
			2 QUERY_TYPE,
			PORR.PR_ORDER_ID ACTION_ID,
			POR.FINISH_DATE ACTION_DATE,<!--- bitisi aldık cunku bu uretim sırasında baska bir alt uretim varsa o uretim once --->
			PR_ORDER_ROW_ID,
			POR.PRODUCTION_ORDER_NO,
			POR.RESULT_NO,
			PORR.AMOUNT,
			PORR.PRODUCT_ID,
			PORR.STOCK_ID,
			PORR.KDV_PRICE TAX,
			POR.START_DATE
		FROM 
			PRODUCTION_ORDERS PO,
			PRODUCTION_ORDER_RESULTS POR,
			PRODUCTION_ORDER_RESULTS_ROW PORR,
			#dsn1_alias#.STOCKS STOCKS,
			#dsn1_alias#.PRODUCT PRODUCT
		WHERE
		<cfif not isdefined('attributes.aktarim_is_cost_again')>
			POR.PR_ORDER_ID NOT IN (SELECT ACTION_ID FROM #dsn2#.PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=4) AND
		</cfif>
			POR.PROCESS_ID IN (#proc_list#) AND
			PO.P_ORDER_ID = POR.P_ORDER_ID AND
			POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
			STOCKS.STOCK_ID = PORR.STOCK_ID AND
			STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			PRODUCT.IS_COST = 1 AND
			PORR.TYPE = 1 AND
			PO.IS_DEMONTAJ <> 1
			AND	POR.RECORD_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
		ORDER BY 
			POR.FINISH_DATE,
			POR.RECORD_DATE
	</cfquery>
	
	<cfset attributes.query_type=2>
	<cfoutput query="GET_PROD">
		<!--- SARF SATIRLARINI ALIYORUZ --->
		<cfquery name="GET_RESULT_SARF" datasource="#dsn3#">
			SELECT 
				PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
				PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
				PRODUCTION_ORDER_RESULTS.START_DATE,
				PRODUCTION_ORDER_RESULTS.FINISH_DATE,
				PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID,
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
				PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
				PRODUCTION_ORDER_RESULTS_ROW.KDV_PRICE TAX,
				ISNULL(PRODUCTION_ORDER_RESULTS_ROW.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
				PRODUCT.IS_PRODUCTION
			FROM
				PRODUCTION_ORDERS,
				PRODUCTION_ORDER_RESULTS,
				PRODUCTION_ORDER_RESULTS_ROW,
				#dsn1_alias#.STOCKS STOCKS,
				#dsn1_alias#.PRODUCT PRODUCT
			WHERE
				PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = #ACTION_ID# AND
				IS_DEMONTAJ <>1 AND
				PRODUCTION_ORDER_RESULTS_ROW.TYPE=2 AND
				STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
				PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND 
				PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID
		</cfquery>
		<cfset purchase_net_sarf_total=0>
		<cfset purchase_extra_sarf_total=0>
		<cfloop query="GET_RESULT_SARF">
			<cfquery name="GET_COST" datasource="#DSN3#" maxrows="1">
				SELECT
					PRODUCT_COST_ID,
					PURCHASE_NET,
					PURCHASE_NET_MONEY,
					PURCHASE_NET_SYSTEM,
					PURCHASE_EXTRA_COST,
					PURCHASE_EXTRA_COST_SYSTEM,
					PURCHASE_NET_SYSTEM_MONEY
				FROM
					PRODUCT_COST
				WHERE
					PRODUCT_ID = #GET_RESULT_SARF.PRODUCT_ID# AND
					START_DATE <= #createodbcdate(GET_RESULT_SARF.FINISH_DATE)# AND
					SPECT_MAIN_ID<cfif GET_RESULT_SARF.SPECT_MAIN_ID gt 0>=#GET_RESULT_SARF.SPECT_MAIN_ID#<cfelse> IS NULL</cfif>
				ORDER BY
					START_DATE DESC, 
					RECORD_DATE DESC,
					PURCHASE_NET_SYSTEM DESC
			</cfquery>
			<cfif GET_COST.RECORDCOUNT>
				<cfset price_=GET_COST.PURCHASE_NET_SYSTEM>
				<cfset amount_=AMOUNT>
				<cfset extra_cost_=GET_COST.PURCHASE_EXTRA_COST_SYSTEM>
				<cfset other_money_=GET_COST.PURCHASE_NET_MONEY>
				<cfset price_other_=GET_COST.PURCHASE_NET>
				<cfset other_total_=price_other_*AMOUNT>
				<cfset total_=GET_COST.PURCHASE_NET_SYSTEM*AMOUNT>
				<cfset extra_cost_total_=GET_COST.PURCHASE_EXTRA_COST_SYSTEM*AMOUNT>
				<cfif TAX gt 0>
					<cfset total_tax_=((price_*AMOUNT)*TAX)/100>
				<cfelse>
					<cfset total_tax_=0>
				</cfif>
				<cfquery name="UPD_FIS" datasource="#dsn2#">
					UPDATE
						STOCK_FIS_ROW
					SET
						TOTAL=#total_#,
						TOTAL_TAX=#total_tax_#,
						NET_TOTAL=#total_#,
						PRICE=#price_#,
						TAX=#TAX#,
						OTHER_MONEY='#other_money_#',
						PRICE_OTHER=#price_other_#,
						COST_PRICE=#price_#,
						EXTRA_COST=#extra_cost_#,
						COST_ID=#GET_COST.PRODUCT_COST_ID#
					WHERE
						FIS_ID IN(SELECT 
									STOCK_FIS.FIS_ID
								FROM 
									STOCK_FIS
								WHERE 
									STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#PR_ORDER_ID#
									AND FIS_TYPE=111)
						AND STOCK_ID=#STOCK_ID#
						AND AMOUNT=#AMOUNT#
				</cfquery>
				<cfquery name="UPD_RESULT_ROW" datasource="#dsn3#">
					UPDATE
						PRODUCTION_ORDER_RESULTS_ROW
					SET
						COST_ID=#GET_COST.PRODUCT_COST_ID#,
						PURCHASE_NET_SYSTEM=#price_#,
						PURCHASE_NET_SYSTEM_MONEY='#GET_COST.PURCHASE_NET_SYSTEM_MONEY#',
						PURCHASE_EXTRA_COST_SYSTEM=#extra_cost_#,
						PURCHASE_NET_SYSTEM_TOTAL=#total_#,
						PURCHASE_NET=#price_other_#,
						PURCHASE_NET_MONEY='#other_money_#',
						PURCHASE_EXTRA_COST=#GET_COST.PURCHASE_EXTRA_COST#,
						PURCHASE_NET_TOTAL=#other_total_#
					WHERE
						PR_ORDER_ROW_ID=#PR_ORDER_ROW_ID#
				</cfquery>
				<cfset purchase_net_sarf_total=purchase_net_sarf_total+total_>
				<cfset purchase_extra_sarf_total=purchase_extra_sarf_total+extra_cost_total_>
			<cfelse>
				<font color="red">Üretim satırındaki Ürünün Kayıtlı Maliyeti Yok: Üretim Emri:#evaluate('GET_PROD.PRODUCTION_ORDER_NO[#GET_PROD.CURRENTROW#]')#  Üretim Sonuç ID:#evaluate('GET_PROD.RESULT_NO[#GET_PROD.CURRENTROW#]')# Ürün ID:#GET_RESULT_SARF.PRODUCT_ID# <cfif GET_RESULT_SARF.SPECT_MAIN_ID gt 0>Main Spec ID:#GET_RESULT_SARF.SPECT_MAIN_ID#</cfif></font><br/>
				<cfquery name="UPD_FIS" datasource="#dsn2#">
					UPDATE
						STOCK_FIS_ROW
					SET
						TOTAL=0,
						TOTAL_TAX=0,
						NET_TOTAL=0,
						PRICE=0,
						TAX=#TAX#,
						OTHER_MONEY='USD',
						PRICE_OTHER=0,
						COST_PRICE=0,
						EXTRA_COST=0,
						COST_ID=NULL
					WHERE
						FIS_ID IN(SELECT 
									STOCK_FIS.FIS_ID 
								FROM 
									STOCK_FIS
								WHERE 
									STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#PR_ORDER_ID#
									AND FIS_TYPE=111)
						AND STOCK_ID=#STOCK_ID#
				</cfquery>
				<cfquery name="UPD_RESULT_ROW" datasource="#dsn3#">
					UPDATE
						PRODUCTION_ORDER_RESULTS_ROW
					SET
						COST_ID=NULL,
						PURCHASE_NET_SYSTEM=0,
						PURCHASE_NET_SYSTEM_MONEY='#session.ep.money#',
						PURCHASE_EXTRA_COST_SYSTEM=0,
						PURCHASE_NET_SYSTEM_TOTAL=0,
						PURCHASE_NET=0,
						PURCHASE_NET_MONEY='USD',
						PURCHASE_EXTRA_COST=0,
						PURCHASE_NET_TOTAL=0
					WHERE
						PR_ORDER_ROW_ID=#PR_ORDER_ROW_ID#
				</cfquery>
			</cfif>
			
		</cfloop>
		
		<cfquery name="GET_STANDART_COST_MONEY_PURCHASE" datasource="#dsn3#">
			SELECT 
				MAX(PRICE) AS PRICE,
				MONEY 
			FROM
				PRICE_STANDART
			WHERE
				PRODUCT_ID=#GET_PROD.PRODUCT_ID# AND
				PURCHASESALES=0 AND
				PRICESTANDART_STATUS=1
			GROUP BY MONEY
		</cfquery>
		<cfif GET_STANDART_COST_MONEY_PURCHASE.RECORDCOUNT and GET_STANDART_COST_MONEY_PURCHASE.PRICE>
			<cfset cost_money = GET_STANDART_COST_MONEY_PURCHASE.MONEY>
		<cfelse>
			<cfset cost_money = 'USD'>
		</cfif>
		<cfif cost_money neq session.ep.money>
			<cfquery name="GET_MONEY" datasource="#dsn#">
				SELECT
					(RATE2/RATE1) AS RATE,MONEY 
				FROM 
					MONEY_HISTORY
				WHERE 
					RECORD_DATE < #CreateODBCDate(GET_PROD.ACTION_DATE)#
					AND PERIOD_ID = #attributes.aktarim_kaynak_period#
					AND MONEY = '#cost_money#'
				ORDER BY 
					MONEY_HISTORY_ID DESC
			</cfquery>
			<cfif GET_MONEY.RECORDCOUNT>
				<cfset rate_=GET_MONEY.RATE>
			<cfelse>
				<cfquery name="GET_MONEY" datasource="#dsn2#">
					SELECT
						(RATE2/RATE1) AS RATE,MONEY 
					FROM 
						SETUP_MONEY
					WHERE
						PERIOD_ID = #attributes.aktarim_kaynak_period#
						AND MONEY = '#cost_money#'
				</cfquery>
				<cfset rate_=GET_MONEY.RATE>
			</cfif>
		<cfelse>
			<cfset rate_=1>
		</cfif>
		<cfif purchase_net_sarf_total gt 0 AND GET_PROD.AMOUNT gt 0 AND rate_ gt 0>
			<cfset total_net=(purchase_net_sarf_total/GET_PROD.AMOUNT)/rate_>
		<cfelse>
			<cfset total_net=0>
		</cfif>
		<cfif purchase_extra_sarf_total gt 0 AND GET_PROD.AMOUNT gt 0 AND rate_ gt 0>
			<cfset total_extra=(purchase_extra_sarf_total/GET_PROD.AMOUNT)/rate_>
		<cfelse>
			<cfset total_extra=0>
		</cfif>
	
		<cfquery name="UPD_RESULT_ROW" datasource="#dsn3#">
			UPDATE
				PRODUCTION_ORDER_RESULTS_ROW
			SET
				COST_ID=NULL,
				PURCHASE_NET_SYSTEM=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
				PURCHASE_NET_SYSTEM_MONEY='#session.ep.money#',
				PURCHASE_EXTRA_COST_SYSTEM=#purchase_extra_sarf_total/GET_PROD.AMOUNT#,
				PURCHASE_NET_SYSTEM_TOTAL=#purchase_net_sarf_total#,
				PURCHASE_NET=#total_net#,
				PURCHASE_NET_MONEY='#cost_money#',
				PURCHASE_EXTRA_COST=#total_extra#,
				PURCHASE_NET_TOTAL=#total_net#*#GET_PROD.AMOUNT#
			WHERE
				PR_ORDER_ROW_ID=#GET_PROD.PR_ORDER_ROW_ID#
		</cfquery>
		<cfif GET_PROD.TAX gt 0>
			<cfset total_tax_=((purchase_net_sarf_total/GET_PROD.AMOUNT)*GET_PROD.TAX)/100>
		<cfelse>
			<cfset total_tax_=0>
		</cfif>
		<cfquery name="UPD_FIS" datasource="#dsn2#">
			UPDATE
				STOCK_FIS_ROW
			SET
				TOTAL=#purchase_net_sarf_total#,
				TOTAL_TAX=#total_tax_#,
				NET_TOTAL=#purchase_net_sarf_total#,
				PRICE=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
				TAX=#GET_PROD.TAX#,
				OTHER_MONEY='#cost_money#',
				PRICE_OTHER=#total_net#,
				COST_PRICE=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
				EXTRA_COST=#purchase_extra_sarf_total/GET_PROD.AMOUNT#,
				COST_ID=NULL
			WHERE
				FIS_ID IN(SELECT 
							STOCK_FIS.FIS_ID
						FROM 
							STOCK_FIS
						WHERE 
							STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#ACTION_ID#
							AND FIS_TYPE=110)
				AND STOCK_ID=#GET_PROD.STOCK_ID#
				AND AMOUNT=#GET_PROD.AMOUNT#
		</cfquery>
			
		Üretim Emri No:#PRODUCTION_ORDER_NO#  Üretim Sonuç No:#GET_PROD.RESULT_NO#  Tarih:#dateformat(ACTION_DATE,'dd:mm:yyyy')#<br/>
		<cfset attributes.action_type=4>
		<cfset attributes.action_id=#ACTION_ID#>
		<cfinclude template="../../objects/query/cost_action.cfm">
	</cfoutput>
</cfloop>
