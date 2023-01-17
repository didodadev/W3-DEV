<!--- 20050325 get_stock_reserved query dikkatli kullanilmalidir cunku kayit dondurmedigi zaman recordcount=1
	olur ancak kolonlarda NULL yazmaktadir --->

<cfquery name="GET_STOCK_RESERVED" datasource="#dsn3#">
	SELECT SUM(STOCK_AZALT) as azalan, sum(STOCK_ARTIR) as artan from get_stock_reserved where PRODUCT_ID = #attributes.pid#
</cfquery>

<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#DSN2#">
	SELECT
		SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK
	FROM
		STOCKS_ROW SR
	WHERE
		SR.PRODUCT_ID = #attributes.pid#
</cfquery>

<cfquery name="LOCATION_BASED_TOTAL_STOCK" datasource="#DSN2#">
	SELECT
		SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_LOCATION_STOCK
	FROM
		STOCKS_ROW SR,
		#dsn_alias#.STOCKS_LOCATION SL 
	WHERE
		SR.PRODUCT_ID = #attributes.pid# AND
		SR.STORE = SL.DEPARTMENT_ID AND
		SR.STORE_LOCATION = SL.LOCATION_ID
		AND SL.NO_SALE = 1
</cfquery>

<cfquery name="GET_PROD_RESERVED" datasource="#DSN3#"><!--- üretim emrinden gelen stok rezerv --->
	SELECT
		SUM(STOCK_AZALT) AS AZALAN,
		SUM(STOCK_ARTIR) AS ARTAN
	FROM
		GET_PRODUCTION_RESERVED
	WHERE
		PRODUCT_ID = #attributes.pid#
</cfquery>
<cfif isdefined('attributes.main_spec_id')><!--- spec id gelirse specli sotklar görünsün --->
	<cfquery name="GET_STOCK_RESERVED_SPEC" datasource="#DSN3#"><!--- siparisler stoktan dusulecek veya eklenecekse toplamını alalım--->
		SELECT
			SUM(STOCK_AZALT) AS AZALAN,
			SUM(STOCK_ARTIR) AS ARTAN
		FROM
			GET_STOCK_RESERVED_SPECT
		WHERE
			SPECT_MAIN_ID = #attributes.main_spec_id# AND
			PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cfquery name="PRODUCT_TOTAL_STOCK_SPEC" datasource="#DSN2#">
		SELECT
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK
		FROM
			STOCKS_ROW SR
		WHERE
			SR.SPECT_VAR_ID = #attributes.main_spec_id# AND
			SR.PRODUCT_ID = #attributes.pid#
	</cfquery>
	
	<cfquery name="LOCATION_BASED_TOTAL_STOCK_SPEC" datasource="#DSN2#">
		SELECT
			SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_LOCATION_STOCK
		FROM
			STOCKS_ROW SR,
			#dsn_alias#.STOCKS_LOCATION SL 
		WHERE
			SR.SPECT_VAR_ID = #attributes.main_spec_id# AND
			SR.PRODUCT_ID = #attributes.pid# AND
			SR.STORE = SL.DEPARTMENT_ID AND
			SR.STORE_LOCATION = SL.LOCATION_ID
			AND SL.NO_SALE = 1
	</cfquery>
	
	<cfquery name="GET_PROD_RESERVED_SPEC" datasource="#DSN3#"><!--- üretim emrinden gelen stok rezerv --->
		SELECT
			SUM(STOCK_AZALT) AS AZALAN,
			SUM(STOCK_ARTIR) AS ARTAN
		FROM
			GET_PRODUCTION_RESERVED_SPECT
		WHERE
			SPECT_MAIN_ID = #attributes.main_spec_id# AND
			PRODUCT_ID = #attributes.pid#
	</cfquery>
</cfif>
<cfquery name="SCRAP_LOCATION_TOTAL_STOCK" datasource="#DSN2#">
	SELECT
		SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_SCRAP_STOCK
	FROM
		STOCKS_ROW SR,
		#dsn_alias#.STOCKS_LOCATION SL 
	WHERE
       	SR.PRODUCT_ID = #attributes.pid# AND
		SR.STORE = SL.DEPARTMENT_ID AND
		SR.STORE_LOCATION = SL.LOCATION_ID AND
		ISNULL(SL.IS_SCRAP,0) = 1
</cfquery>
<cfquery name="get_nosale_location_reserve_stock" datasource="#dsn3#"><!--- satış yapılamaz lokasyonlarda rezerve edilen satınalma siparişleri --->
SELECT
	SUM(STOCK_ARTIR) AS NOSALE_RESERVE_STOCK
FROM
(
	SELECT 
		SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
		S.STOCK_ID,
		S.PRODUCT_ID
	 FROM
		STOCKS S,
		GET_ORDER_ROW_RESERVED ORR, 
		ORDERS ORDS,
		SPECTS_ROW SR,
		#dsn_alias#.STOCKS_LOCATION SL,
		PRODUCT_UNIT PU
	 WHERE
		
		<cfif isdefined('attributes.sid')>
        	ORR.STOCK_ID = #attributes.sid# and 
        <cfelse>
        	ORR.PRODUCT_ID = #attributes.pid# and
        </cfif>
        SR.STOCK_ID = S.STOCK_ID AND 
		ORR.SPECT_VAR_ID=SR.SPECT_ID AND
		SR.IS_SEVK=1 AND
		ORDS.RESERVED = 1 AND
		ORDS.ORDER_STATUS = 1 AND
		ORR.ORDER_ID = ORDS.ORDER_ID AND
		ORDS.PURCHASE_SALES=0 AND
		ORDS.ORDER_ZONE=0 AND
		ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
		ORDS.LOCATION_ID=SL.LOCATION_ID AND
		ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
		SL.NO_SALE = 1 AND		
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
	GROUP BY 			
		S.STOCK_ID,
		S.PRODUCT_ID
UNION
	SELECT
		SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
		S.STOCK_ID,
		S.PRODUCT_ID
	 FROM
		STOCKS S,
		GET_ORDER_ROW_RESERVED ORR, 
		ORDERS ORDS,
		#dsn_alias#.STOCKS_LOCATION SL,	
		PRODUCT_UNIT PU
	 WHERE
     	<cfif isdefined('attributes.sid')>
        	ORR.STOCK_ID = #attributes.sid# and 
        <cfelse>
        	ORR.PRODUCT_ID = #attributes.pid# and
        </cfif>
		ORR.STOCK_ID = S.STOCK_ID AND 
		ORDS.RESERVED = 1 AND
		ORDS.ORDER_STATUS = 1 AND
		ORR.ORDER_ID = ORDS.ORDER_ID AND		
		ORDS.PURCHASE_SALES=0 AND
		ORDS.ORDER_ZONE=0 AND
		ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
		ORDS.LOCATION_ID=SL.LOCATION_ID AND
		ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
		SL.NO_SALE =1 AND
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
	GROUP BY 			
		S.STOCK_ID,
		S.PRODUCT_ID
)
	AS NOSALE_LOCATION_RESERVE
WHERE
	<cfif isdefined('attributes.sid')>
	STOCK_ID = #attributes.sid#
	<cfelse>
	PRODUCT_ID = #attributes.pid#
	</cfif>
</cfquery>

