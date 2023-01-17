<cfscript>
if (DateFormat(now(),'dd/mm/') IS '01/01/')
	{
	yearnow = YEAR(NOW())-1;
	tarih1 = CreateDate( yearnow, 1, 1 );
	tarih2 = CreateDate( yearnow, 12, 31 );
	}
</cfscript>
<cfif (DateFormat(now(),'dd/mm/') IS '01/01/')>
	<!--- 
	,	#GET_TOTAL_FOR_PRODUCT(
		get_type3 		1:COMPANY, diğer: CONSUMER
		get_id 			COMPANY_ID,CONSUMER_ID
		get_type2		1:PRODUCT, diğer: PRODUCT_CAT
		pro_cat			PRODUCT_ID, PRODUCT_CATID
		get_type		1:AMOUNT, diğer: GROSSTOTAL
		get_id2			AMOUNT,GROSSTOTAL
		date1			küçük tarih
		date2			büyük tarih
								)
	 --->
	<CFFUNCTION name="GET_TOTAL_FOR_PRODUCT" >
		<cfargument name="get_type3">
		<cfargument name="get_id">
		<cfargument name="get_type2">
		<cfargument name="pro_cat">
		<cfargument name="get_type">
		<cfargument name="get_id2">
		<cfargument name="date1">
		<cfargument name="date2">
		<cfquery name="GET_TOTAL_OF_PRODUCT" datasource="#DSN2#">
			SELECT
			<cfif get_type eq 1 >
				SUM(IR.AMOUNT)AS TOTAL
			<cfelse>
				SUM(IR.GROSSTOTAL)AS TOTAL
			</cfif>
			FROM
				INVOICE_ROW IR,
				INVOICE
			WHERE
				INVOICE.INVOICE_ID = IR.INVOICE_ID
				AND
			<cfif get_type2 eq 1 >
				IR.PRODUCT_ID = #pro_cat#
			<cfelse>
				IR.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_CATID = #pro_cat#)
			</cfif>
			AND
			<cfif get_type3 eq 1>
				INVOICE.COMPANY_ID=#get_id#
			<cfelse>	
				INVOICE.CONSUMER_ID=#get_id#
			</cfif>
			AND
			<cfif get_type eq 1 >
				IR.AMOUNT >= #get_id2#
			<cfelse>
				IR.GROSSTOTAL >= #get_id2#
			</cfif>
			AND 
			IR.PURCHASE_SALES=0	
			AND
			INVOICE.INVOICE_DATE >= #date1# 
			AND
			INVOICE.INVOICE_DATE <= #date2# 
		</cfquery>
		<cfreturn GET_TOTAL_OF_PRODUCT.TOTAL>
	</CFFUNCTION>
	
	<cfquery datasource="#DSN3#" name="GET_CONTRACT_PURCHASE_GENERAL_PREMIUM">
	SELECT
		CONTRACT.COMPANY, CPCP.*
	FROM
		CONTRACT,
		CONTRACT_PURCHASE_CAT_PREMIUM AS CPCP
	WHERE
		OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
		AND
		CONTRACT.CONTRACT_ID = CPCP.CONTRACT_ID
		AND
		CONTRACT.STATUS = 1 
		AND
		CPCP.PERIOD = 3 <!--- 1:AYLIK, 2: 3 AYLIK, 3: YILLIK --->
	</cfquery>
	
	<cfoutput query="GET_CONTRACT_PURCHASE_GENERAL_PREMIUM">
		<cfset COMPANY_ID = ListFirst(ListSort(COMPANY,"numeric"))>
		<cfif IsNumeric(PRODUCT_CAT_ID) AND PRODUCT_CAT_ID GT 0>
			<cfset prod_or_prodcat = 2>
			<cfset prod_prodcat = PRODUCT_CAT_ID>
		<cfelseif IsNumeric(PRODUCT_ID) AND PRODUCT_ID GT 0>
			<cfset prod_or_prodcat = 1>
			<cfset prod_prodcat = PRODUCT_ID>
		</cfif>
		<cfif len(UNIT)>
			<cfquery datasource="#DSN3#" name="GET_UNIT">SELECT ADD_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = #UNIT#</cfquery>
			<cfset unit_money = GET_UNIT.ADD_UNIT>
		<cfelseif len(MONEY)>
			<cfset unit_money = MONEY>
		</cfif>
		<cfset total = GET_TOTAL_FOR_PRODUCT(1,COMPANY_ID,prod_or_prodcat,prod_prodcat,IS_TUTAR_ADET,TUTAR_ADET,tarih1,tarih2)>
		<cfif total IS "">
			<cfset total = 0>
		</cfif>
		<cfif IsNumeric(TUTAR_ADET) AND IsNumeric(PREMIUM) AND total GTE TUTAR_ADET>
			<cfset primmiktar = total*PREMIUM/100>
		<cfelse>
			<cfset primmiktar = 0>
		</cfif>
		<cfif primmiktar GT 0>
			<cfquery datasource="#DSN3#" name="INS_CONTRACT_PREMIUM">
			INSERT INTO
				CONTRACT_INVOICE_COMMANDS
				(
				CONTRACT_ID, COMPANY_ID, AMOUNT, IS_INVOICE, 
				REASON, 
				PRODUCT_CAT_ID, 
				PRODUCT_ID, 
				UNIT_MONEY
				)
			VALUES
				(
				#CONTRACT_ID#, #COMPANY_ID#, #primmiktar#, 0, 
				'Ürün <cfif prod_or_prodcat IS 2> Kategorisi</cfif> Yıllık ciro primi', 
				<cfif prod_or_prodcat IS 2>#prod_prodcat#<cfelse>NULL</cfif>,
				<cfif prod_or_prodcat IS 1>#prod_prodcat#<cfelse>NULL</cfif>,
				'#unit_money#'
				)
			</cfquery>
		</cfif>
	</cfoutput> 

</cfif>

