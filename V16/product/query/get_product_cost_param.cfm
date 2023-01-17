
<cfquery name="GET_PRODUCT" datasource="#dsn3#"><!--- Burada ürün ismi ve calc_type getiriliyor --->
	SELECT PRODUCT_NAME, IS_PRODUCTION, PRODUCT_CODE FROM  PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#">
</cfquery>
<cfquery name="GET_PERIOD" datasource="#dsn#"><!--- Burada ürün ismi ve calc_type getiriliyor --->
	SELECT INVENTORY_CALC_TYPE FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfquery name="GET_PRODUCT_COST" DATASOURCE="#DSN3#" MAXROWS="5"><!---Ürün tutarları ve para birimi  --->
	<cfif session.ep.isBranchAuthorization eq 0>
		SELECT
			(SELECT S.STOCK_CODE FROM STOCKS S WHERE S.STOCK_ID = PRODUCT_COST.STOCK_ID) STOCK_CODE,
			*
		FROM 
			PRODUCT_COST 
		WHERE 
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#">
		ORDER BY 
			START_DATE DESC,RECORD_DATE DESC, PRODUCT_COST_ID DESC
	<cfelse>
		SELECT 
			(SELECT S.STOCK_CODE FROM STOCKS S WHERE S.STOCK_ID = PC.STOCK_ID) STOCK_CODE,
			PC.*,
			DEPARTMENT_HEAD
			<cfif database_type is 'MSSQL'>
			+'-'+
			<cfelseif database_type is 'DB2'>
			||'-'||
			</cfif>
			  SL.COMMENT AS DEPARTMENT
		FROM 
			PRODUCT_COST PC,
			#DSN_ALIAS#.STOCKS_LOCATION SL,
			#DSN_ALIAS#.DEPARTMENT D
		WHERE 
			PC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
			AND SL.LOCATION_ID = PC.LOCATION_ID
			AND SL.DEPARTMENT_ID = PC.DEPARTMENT_ID
			AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID
			AND PC.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
		ORDER BY 
			PC.START_DATE DESC,
            PC.PRODUCT_COST_ID DESC,
			PC.RECORD_DATE DESC
			
	</cfif>
</cfquery>
<cfswitch expression="#GET_PERIOD.inventory_calc_type#">

	<cfcase value="3"><!--- Ağırlıklı ortalamaya göre--->
		<cfquery name="GET_UNIT" datasource="#DSN1#">
			SELECT
				MAIN_UNIT,
				MAIN_UNIT_ID
			FROM
				PRODUCT_UNIT
			WHERE
				product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#">
		</cfquery>
		<cfset product_unit = GET_UNIT.MAIN_UNIT_ID>
		<cfset product_unit_name = GET_UNIT.MAIN_UNIT>
	</cfcase>

	<cfcase value="4"><!--- son alis fiyatına göre  --->
		<cfquery name="GET_STANDART_COST_LAST" datasource="#dsn2#" maxrows="1">
			SELECT 
				IR.PRICE AS PRICE,
				PU.PRODUCT_UNIT_ID AS UNIT_ID,
				PU.MAIN_UNIT AS UNIT
			FROM 	
				INVOICE_ROW AS IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT AS PU
			WHERE 	
				IR.INVOICE_ID = I.INVOICE_ID AND 
				IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#"> AND 
				IR.PURCHASE_SALES=0 AND 
				IR.UNIT = PU.MAIN_UNIT
			ORDER BY
				I.INVOICE_DATE DESC
		</cfquery>
		<cfquery name="GET_UNIT" datasource="#DSN#">
			SELECT
				*
			FROM
				SETUP_UNIT
			WHERE
				UNIT='#get_standart_cost_last.unit#'
		</cfquery>
		<cfset product_unit = get_unit.unit_id>
		<cfset product_unit_name = get_unit.unit>
		<cfset product_price = get_standart_cost_last.price>
	</cfcase>

	<cfcase value="5"><!--- ilk alış fiyatına göre --->
		<cfquery name="GET_STANDART_COST_FIRST" datasource="#dsn2#" maxrows="1">
			SELECT 
				IR.PRICE AS PRICE,
				PU.PRODUCT_UNIT_ID AS UNIT_ID,
				PU.MAIN_UNIT AS UNIT
			FROM 	
				INVOICE_ROW AS IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT AS PU
			WHERE 	
				IR.INVOICE_ID = I.INVOICE_ID AND 
				IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#"> AND 
				IR.PURCHASE_SALES=0 AND 
				IR.UNIT = PU.MAIN_UNIT
			ORDER BY
				I.INVOICE_DATE
		</cfquery>
		<cfquery name="GET_UNIT" datasource="#DSN#">
			SELECT
				*
			FROM
				SETUP_UNIT
			WHERE
				UNIT='#get_standart_cost_first.unit#'
		</cfquery>
		<cfset product_unit = get_unit.unit_id>
		<cfset product_unit_name = get_unit.unit>
		<cfset product_price = get_standart_cost_first.price>		
		
	</cfcase>
	<cfcase value="6"><!--- Üretim Maliyeti --->
		<cfquery name="get_product_unıt" datasource="#dsn3#">
			SELECT
				MAIN_UNIT
			FROM
				PRODUCT_UNIT
			WHERE
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#">
		</cfquery>
		<cfquery name="GET_PRODUCTION_COST" DATASOURCE="#DSN3#">
				SELECT
					S.PRODUCT_ID,
					PT.AMOUNT,
					PT.UNIT_ID
				FROM
					STOCKS AS S,
					PRODUCT_TREE AS PT
				WHERE
					S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#"> AND
					PT.STOCK_ID = S.STOCK_ID AND
                    PT.UNIT_ID IS NOT NULL
		</cfquery>
		<cfset toplam = 0>
		<cfloop query="GET_PRODUCTION_COST">
			<cfquery name="GET_PRICE_STD_PRODUCT" datasource="#DSN3#" maxrows="1">
				SELECT
					S.PRODUCT_ID,
					PS.PRICE,
					PS.MONEY
				FROM	
					STOCKS AS S,
					PRICE_STANDART AS PS
				WHERE
					S.PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRODUCTION_COST.UNIT_ID#"> AND
					PS.PURCHASESALES = 0 AND
					PS.PRODUCT_ID = S.PRODUCT_ID
				ORDER BY
					PS.RECORD_DATE DESC
			</cfquery>
			<cfset carpim = GET_PRICE_STD_PRODUCT.PRICE*GET_PRODUCTION_COST.amount>
			<cfset toplam = toplam + carpim>
		</cfloop>
		<cfset totalprice = toplam>
		<cfquery name="GET_UNIT" datasource="#DSN#">
			SELECT
				*
			FROM
				SETUP_UNIT
			WHERE
				UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_product_unıt.main_unit#">
		</cfquery>
		<cfset product_unit_name = get_unit.unit>
		<cfset product_unit = get_unit.unit_id>
		<cfset product_price = totalprice>
	</cfcase>
	
	<cfcase value="2"><!--- Son Giren ilk Çıkar --->
		<cfquery name="GET_STANDART_COST_PURCHASE" datasource="#dsn2#">
				SELECT
					IR.AMOUNT,
					I.INVOICE_DATE,
					IR.PRICE,
					IR.UNIT
				FROM
					INVOICE_ROW AS IR,
					INVOICE I
				WHERE
					IR.INVOICE_ID = I.INVOICE_ID AND
					IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#"> AND
					IR.PURCHASE_SALES = 0
				ORDER BY 
					I.INVOICE_DATE DESC
		</cfquery>
		<cfquery name="GET_STANDART_COST_SALES" datasource="#dsn2#">
				SELECT
					IR.AMOUNT,
					I.INVOICE_DATE,
					IR.PRICE,
					IR.UNIT
				FROM
					INVOICE_ROW AS IR,
					INVOICE I
				WHERE
					IR.INVOICE_ID = I.INVOICE_ID AND
					IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#"> AND
					IR.PURCHASE_SALES = 1
				ORDER BY 
					I.INVOICE_DATE DESC
		</cfquery>
 		<cfset toplam_satis = 0>
		<cfloop query="GET_STANDART_COST_SALES">
			<cfset toplam_satis = GET_STANDART_COST_SALES.amount + toplam_satis>
		</cfloop>		
		<cfset toplam_alis = 0>
		<cfloop query="GET_STANDART_COST_PURCHASE">
			<cfset toplam_alis = GET_STANDART_COST_PURCHASE.amount + toplam_alis>
		</cfloop>	
		<cfset alis_lifo = arraynew(2)>
		<cfset satis_lifo = arraynew(2)>
		<cfset vr=0>
		<cfloop query="get_standart_cost_purchase">
			<cfscript>
				vr=vr+1;
				alis_lifo[vr][1]=get_standart_cost_purchase.amount;
				alis_lifo[vr][2]=get_standart_cost_purchase.price;
			</cfscript>
		</cfloop>
		<cfset vr=0>
		<cfloop query="get_standart_cost_sales">
			<cfscript>
				vr=vr+1;
				satis_lifo[vr][1]=get_standart_cost_sales.amount;
				satis_lifo[vr][2]=get_standart_cost_sales.price;
			</cfscript>
		</cfloop>
		<cfoutput>
		<cfset product_price=0>
		<cfset satis = 0>
		<cfset alis_toplam = 0>
		<cfset k=1>
		<cfset toplam = 0>
		<cfset lifo_toplam =0>
		<!--- Herşey burada başlıyor --->
		<cfloop from="1" to="#arraylen(satis_lifo)#" index="i">
			<cfset satis = satis_lifo[i][1]>
			<cfloop from="#k#" to="#arraylen(alis_lifo)#" index="j">
				<cfif satis gt alis_toplam>
					<cfset alis_toplam = alis_toplam + alis_lifo[j][1]>
				<cfelse>
					<cfset alis_toplam = alis_toplam - satis>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfset carpim = satis_lifo[i][1]*alis_lifo[j-1][2]>
			<cfset lifo_toplam = lifo_toplam + carpim>
			<cfset k=j>
			<cfif k gt 4>
				<cfset alis_toplam = alis_toplam - satis>
			</cfif>
		</cfloop>
		<!--- Herşey burada başlıyor --->
		<cfif toplam_satis gt 0>
			<cfset price_lifo = lifo_toplam/toplam_satis>
		<cfelse>
			<cfset price_lifo = lifo_toplam>
		</cfif>
	</cfoutput>
		<cfquery name="GET_UNIT" datasource="#DSN#">
			SELECT
				*
			FROM
				SETUP_UNIT
			WHERE
				UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_standart_cost_sales.unit#">
		</cfquery>
		<cfset product_unit_name = get_unit.unit>
		<cfset product_unit = get_unit.unit_id>
		<cfset product_price = price_lifo>
	</cfcase>		

	<cfdefaultcase><!--- Standart Alış fiyatına Göre --->
		<cfquery name="GET_STANDART_COST" datasource="#dsn3#">
			SELECT
				MAX(PRICE_STANDART.PRICE) AS PRICE,
				PRICE_STANDART.MONEY,
				PRODUCT_UNIT.ADD_UNIT AS UNIT,
				PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID
			FROM
				PRICE_STANDART,
				PRODUCT_UNIT
			WHERE
				PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#"> AND
				PRICE_STANDART.PURCHASESALES = 0 AND
				PRICESTANDART_STATUS = 1 AND
				PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
			GROUP BY
				MONEY,PRODUCT_UNIT.PRODUCT_UNIT_ID,PRODUCT_UNIT.ADD_UNIT
		</cfquery>
		<cfquery name="GET_UNIT" datasource="#DSN#">
			SELECT
				*
			FROM
				SETUP_UNIT
			WHERE
				UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_standart_cost.unit#">
		</cfquery>
		<cfscript>
			product_unit_name = get_unit.unit;
			product_unit = get_unit.unit_id;
			product_price = get_standart_cost.PRICE;
		</cfscript>
	</cfdefaultcase>
</cfswitch>
<cfif not len(product_unit)>
	<cfquery name="GET_STANDART_COST" datasource="#dsn3#">
		SELECT
			MAX(PRICE_STANDART.PRICE) AS PRICE,
			PRICE_STANDART.MONEY,
			PRODUCT_UNIT.ADD_UNIT AS UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID AS UNIT_ID
		FROM
			PRICE_STANDART,
			PRODUCT_UNIT
		WHERE
			PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#"> AND
			PRICE_STANDART.PURCHASESALES = 0 AND
			PRICESTANDART_STATUS = 1 AND
			PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
		GROUP BY
			MONEY,PRODUCT_UNIT.PRODUCT_UNIT_ID,PRODUCT_UNIT.ADD_UNIT
	</cfquery>
	<cfquery name="GET_UNIT" datasource="#DSN#">
		SELECT
			*
		FROM
			SETUP_UNIT
		WHERE
			UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_standart_cost.unit#">
	</cfquery>
	<cfscript>
		product_unit_name = get_unit.unit;
		product_unit = get_unit.unit_id;
		product_price = get_standart_cost.PRICE;
	</cfscript>
</cfif>
