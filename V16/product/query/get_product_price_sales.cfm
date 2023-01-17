<!--- 
	Bu sayfadan objects*query icindede var orayida update ediniz.arzubt 05112003
--->
<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
	<cfif (isdefined('x_dsp_stock_based_price') and x_dsp_stock_based_price eq 1)> <!--- stok bazında fiyat listelenecekse --->
		SELECT 
			TABLE_1.*,
			STOCKS.STOCK_CODE
		FROM
			(
	</cfif>
		SELECT
			ISNULL(P.STOCK_ID,0) AS STOCK_ID,
			<cfif isdefined('x_dsp_spec_based_price') and x_dsp_spec_based_price eq 1>
				ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,	
			</cfif>
			P.PRICE_ID,
			P.PRICE,
			P.PRICE_KDV,
			P.IS_KDV,
			P.MONEY,
			P.RECORD_EMP,
			P.STARTDATE,
			P.FINISHDATE,
			PU.ADD_UNIT,
			PU.WEIGHT,
			PU.UNIT_MULTIPLIER,
			PU.UNIT_MULTIPLIER_STATIC,
			PC.PRICE_CAT,
			PC.PRICE_CATID
		FROM
			PRICE P,
			PRICE_CAT PC,
			PRODUCT_UNIT PU
		WHERE
			PU.PRODUCT_UNIT_STATUS = 1 AND
			P.PRODUCT_ID = #URL.PID# AND
			P.PRICE_CATID = PC.PRICE_CATID AND		 
			PU.PRODUCT_ID = P.PRODUCT_ID AND
			<cfif not (isdefined('x_dsp_spec_based_price') and x_dsp_spec_based_price eq 1)>
				ISNULL(P.SPECT_VAR_ID,0)=0 AND
			</cfif>
			<cfif not (isdefined('x_dsp_stock_based_price') and x_dsp_stock_based_price eq 1)>
				ISNULL(P.STOCK_ID,0)=0 AND
			</cfif>
			(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
			P.UNIT = PU.PRODUCT_UNIT_ID
	<cfif (isdefined('x_dsp_stock_based_price') and x_dsp_stock_based_price eq 1)>
	) 
	AS TABLE_1
	LEFT JOIN STOCKS
		ON  STOCKS.STOCK_ID = TABLE_1.STOCK_ID
	</cfif>
	ORDER BY PRICE_CAT
</cfquery>

