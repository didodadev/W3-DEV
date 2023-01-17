<cfsetting showdebugoutput="no"><cfprocessingdirective suppresswhitespace="Yes">
<cfif attributes.price_catid lt 0>
	<cfquery name="get_product" datasource="#dsn3#">
		SELECT 
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			P.PRODUCT_NAME,
			PS.PRICE,
			SB.BARCODE,
			PS.PRICE_KDV,
			PS.IS_KDV
		FROM
			PRODUCT P,
			PRICE_STANDART PS,
			STOCKS S,
			GET_STOCK_BARCODES SB
		WHERE
			SB.STOCK_ID = S.STOCK_ID AND
			S.PRODUCT_ID = P.PRODUCT_ID AND
			PS.PRODUCT_ID = P.PRODUCT_ID AND
			<cfif attributes.price_catid eq -1>
				PS.PURCHASESALES = 0
			<cfelse>
				PS.PURCHASESALES = 1
			</cfif>
			 AND
 			PS.PRICESTANDART_STATUS = 1 
		<cfif isdefined("attributes.is_product_provision")>
			AND P.IS_PURCHASE = 1 
		</cfif>
		ORDER BY
			SB.BARCODE
	</cfquery>
<cfelse>
	<cfquery name="get_product" datasource="#dsn3#">
		SELECT 
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			P.PRODUCT_NAME,
			PR.PRICE,
			SB.BARCODE,
			PR.PRICE_KDV,
			PR.IS_KDV
		FROM
			PRODUCT P,
			PRICE PR,
			PRICE_CAT PC,
			STOCKS S,
			GET_STOCK_BARCODES SB
		WHERE
			SB.STOCK_ID = S.STOCK_ID AND
			S.PRODUCT_ID = P.PRODUCT_ID AND
			PR.PRODUCT_ID = P.PRODUCT_ID AND
			ISNULL(PR.STOCK_ID,0)=0 AND
			ISNULL(PR.SPECT_VAR_ID,0)=0 AND
			PR.PRICE_CATID = PC.PRICE_CATID AND
			PC.PRICE_CATID = #attributes.price_catid#
		<cfif isdefined("attributes.is_product_provision")>
			AND P.IS_PURCHASE = 1 
		</cfif>
		ORDER BY
			SB.BARCODE
	</cfquery>
</cfif>
<cfscript>
	CRLF=chr(13)&chr(10);
	file_content = ArrayNew(1);
	index_array = 1;
</cfscript>
<cfloop query="get_product">
	<cfscript>
		satir1 = "";
		my_barcode = left(BARCODE,13);
		my_uzun = len(my_barcode);
		my_barcode = my_barcode & repeatString(" ",13-my_uzun);
		satir1 = satir1 & my_barcode & " ";
		my_product = left(PRODUCT_NAME,21);
		my_uzun2 = len(my_product);
		my_product = my_product & repeatString(" ",21-my_uzun2);
		satir1 = satir1 & my_product & " ";
		my_price = left(PRICE_KDV,10);
		my_price = repeatString("0",10-len(my_price)) & my_price;
		satir1 = satir1 & my_price;
		file_content[index_array] = "#satir1#";
		index_array = index_array+1;
	</cfscript>
</cfloop>
<cfset filename = "#createuuid()#">
<cfcontent type="text/plain;charset=utf-8">
<cfheader name="Content-Disposition" value="attachment; filename=#filename#.phl">
<cfoutput>#ArraytoList(file_content,CRLF)#</cfoutput>
</cfprocessingdirective>
