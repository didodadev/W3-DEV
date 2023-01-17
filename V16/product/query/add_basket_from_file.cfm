<cfset upload_folder = "#upload_folder#product#dir_seperator#" >
<cftry> 
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cffile action="delete" file="#dosya_yolu#">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfloop from="2" to="#line_count#" index="k">
	<cfquery name="get_product_main" datasource="#dsn3#" maxrows="1">
	SELECT
		STOCKS.COMPANY_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.PRODUCT_NAME,
		STOCKS.MANUFACT_CODE,
		STOCKS.PRODUCT_CODE,
		STOCKS.PRODUCT_CODE_2,
		STOCKS.BARCOD,
		STOCKS.TAX,
		STOCKS.TAX_PURCHASE,
		STOCKS.PRODUCT_CATID,
		STOCKS.STOCK_ID,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY,
		PS2.PRICE_KDV,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER,
		ISNULL(PRODUCT_CAT.PROFIT_MARGIN,0) PROFIT_MARGIN
	FROM
		STOCKS,
		PRODUCT_CAT,
		PRODUCT_UNIT,
		PRICE_STANDART,
		PRICE_STANDART PS2
	WHERE
		STOCKS.PRODUCT_CODE_2 = '#ListGetAt(dosya[k],1,";")#' AND 
		STOCKS.PRODUCT_STATUS = 1 AND 	
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
		STOCKS.IS_SALES = 1 AND
		PRODUCT_UNIT.IS_MAIN = 1 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1	AND 
		PRICE_STANDART.PURCHASESALES = 0 AND 
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND 
		PS2.PRICESTANDART_STATUS = 1 AND 
		PS2.PURCHASESALES = 1 AND 
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND 
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
		PRODUCT_CAT.PRODUCT_CATID = STOCKS.PRODUCT_CATID		
	ORDER BY
		STOCKS.PRODUCT_NAME
	</cfquery>
	<cfscript>
		page_no = ListGetAt(dosya[k],2,";");
		page_type = ListGetAt(dosya[k],3,";");
		paper_type = ListGetAt(dosya[k],4,";");
		new_price_kdv1 = ListGetAt(dosya[k],5,";");
		new_price_kdv2 = ListGetAt(dosya[k],6,";");
		detail_info = ListGetAt(dosya[k],8,";");
		ref_info = ListGetAt(dosya[k],9,";");
		cons_count = ListGetAt(dosya[k],10,";");
		unit_sale = ListGetAt(dosya[k],11,";");
		if(listlen(dosya[k],';') gte 12)
			sale_type_info = ListGetAt(dosya[k],12,";");
		else
			sale_type_info = 0;
	</cfscript>
	<cfoutput query="get_product_main">
		<script type="text/javascript">		
			add_row('1','#product_id#','#stock_id#','#product_name#', '#manufact_code#', '#iif(len(tax),tax,0)#','#iif(len(tax_purchase),tax_purchase,0)#','#add_unit#','#product_unit_id#','#money#','0','0','0','0','0','0','0','0','0','0','#iif(IsNumeric(price),price,0)#','#iif(IsNumeric(price_kdv),price_kdv,0)#','0','0','0','0','0','0','0','0','0','#product_code#','#barcod#','#product_code_2#','0','#profit_margin#','0','#page_no#','#page_type#','#paper_type#','#new_price_kdv1#','#new_price_kdv2#','#detail_info#','#ref_info#','#cons_count#','#unit_sale#','#sale_type_info#');
		</script>
	</cfoutput>
</cfloop>
