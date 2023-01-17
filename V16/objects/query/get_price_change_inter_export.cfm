<cfquery name="GET_STOCKS" datasource="#DSN3#">
	SELECT DISTINCT
		P.PRODUCT_NAME,
		P.PRODUCT_ID,
		P.PRODUCT_CODE,	
		P.BRAND_ID,	
		SB.BARCODE AS BARCOD,
		P.IS_TERAZI,
		P.RECORD_DATE,
		PU.ADD_UNIT,
		PU.IS_MAIN,
		PU.MULTIPLIER,
		S.STOCK_ID,
		S.PROPERTY,
		SB.UNIT_ID AS PRODUCT_UNIT_ID,
		P.PRODUCT_CATID,
		ST.TAX_ID,
		ST.TAX,
		PR.PRICE_KDV,
		PR.PRICE,
		PR.IS_KDV,
		PR.MONEY,
		P.IS_WORKER,
		P.IS_RETIRED
	FROM
		STOCKS S, 
		PRODUCT_UNIT PU,
		#dsn2_alias#.SETUP_TAX ST,
		PRICE_CAT PC, 
		PRICE PR,
		PRODUCT AS P,
		STOCKS_BARCODES AS SB 
	WHERE  
		P.PRODUCT_ID = PU.PRODUCT_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID AND
		P.PRODUCT_ID = PR.PRODUCT_ID AND
		SB.STOCK_ID=S.STOCK_ID AND
		PU.PRODUCT_UNIT_ID=SB.UNIT_ID AND
		S.PRODUCT_ID = PU.PRODUCT_ID AND
		S.PRODUCT_ID = PR.PRODUCT_ID AND
		PR.PRICE_CATID = PC.PRICE_CATID AND
		PR.UNIT = PU.PRODUCT_UNIT_ID AND
		ST.TAX = S.TAX AND
		S.IS_INVENTORY = 1 AND
		S.PRODUCT_STATUS = 1 AND
		PC.PRICE_CAT_STATUS = 1 AND
		P.IS_SALES = 1 AND
		S.STOCK_STATUS = 1 AND
		PR.PRICE > 0 AND
		LEN(SB.BARCODE) > 6 AND
		LEN(SB.BARCODE) < 14 AND
		PR.PRICE < 10000000 AND
		(PR.PRICE <> 0 OR PR.PRICE_KDV <> 0) AND
		PC.BRANCH LIKE '%,#attributes.branch_id#,%'
		<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>AND S.STOCK_CODE LIKE '#attributes.hierarchy#%'</cfif>
		<cfif isdefined("attributes.from_store")><!--- store.list_label sayfasından geliyor ise  --->
			AND PR.STARTDATE <= #now()#
			AND (PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL)
			AND PR.RECORD_DATE <= #attributes.finishdate#
			AND PR.RECORD_DATE > #attributes.startdate# 
		<cfelse>
			<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdefined("attributes.finishdate") and len(attributes.finishdate)>
				AND
				(
					(PR.STARTDATE <= #attributes.finishdate# AND PR.FINISHDATE >= #attributes.startdate#) OR
					(PR.STARTDATE <= #attributes.finishdate# AND PR.FINISHDATE IS NULL)
				)
			<cfelseif isdefined("attributes.startdate") and len(attributes.startdate)>
				<cfset finishdate = date_add("d",1,attributes.startdate)>
				<cfset finishdate = date_add("n",-1,finishdate)>
				AND PR.STARTDATE BETWEEN #attributes.startdate# AND #finishdate#
			<cfelseif isdefined("attributes.finishdate") and len(attributes.finishdate)>
				<cfset finishdate = date_add("s",-1,attributes.finishdate)>
				AND PR.FINISHDATE = #finishdate#
			</cfif>
		</cfif>
		<cfif isdefined("attributes.recorddate") and len(attributes.recorddate)>AND PR.RECORD_DATE >= #attributes.recorddate#</cfif>
</cfquery>
