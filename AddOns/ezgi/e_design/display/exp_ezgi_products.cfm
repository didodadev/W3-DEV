<cfset FileName = "Ürün_Tablosu_#DateFormat(now(),'YYYYMMDD')#_#TimeFormat(DateAdd('h',session.ep.time_zone,now()),'HHMMSS')#.csv">
<cfset myFile = "#upload_folder#production/#FileName#">
<cfset readFile = "#file_web_path#production/#FileName#">
<cfquery name="GetStuff" datasource="#dsn3#">
   	SELECT        
   		S.STOCK_ID, 
    	S.PRODUCT_NAME,
        S.PRODUCT_CODE,
        P.PRODUCT_CAT,
        (SELECT MAIN_UNIT FROM #dsn1_alias#.PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = s.PRODUCT_UNIT_ID) MAIN_UNIT,
        (SELECT PRICE FROM #dsn1_alias#.PRICE_STANDART WHERE PRODUCT_ID = s.PRODUCT_ID AND PRICESTANDART_STATUS = 1 AND PURCHASESALES = 1) SALES_PRICE,
        (SELECT MONEY FROM #dsn1_alias#.PRICE_STANDART WHERE PRODUCT_ID = s.PRODUCT_ID AND PRICESTANDART_STATUS = 1 AND PURCHASESALES = 1) SALES_MONEY,
        (SELECT PRICE FROM #dsn1_alias#.PRICE_STANDART WHERE PRODUCT_ID = s.PRODUCT_ID AND PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0) PURCHASE_PRICE,
        (SELECT MONEY FROM #dsn1_alias#.PRICE_STANDART WHERE PRODUCT_ID = s.PRODUCT_ID AND PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0) PURCHASE_MONEY
	FROM            
    	STOCKS AS S INNER JOIN
   		PRODUCT_CAT AS P ON S.PRODUCT_CATID = P.PRODUCT_CATID
	WHERE        
    	ISNULL(S.PRODUCT_STATUS,0) = 1
	ORDER BY 
    	S.PRODUCT_CODE
</cfquery>
<cffile action="write" file="#myFile#" output="Stok ID;Stok ADI; Ürün Kodu; Kategori; Birim; Satış Fiyat; Satış Para; Alış Fiyat; Alış Para" addnewline="Yes">
<cfloop query="GetStuff">
   <cffile action="append" file="#myFile#" output="#STOCK_ID#;#PRODUCT_NAME#;#PRODUCT_CODE#;#PRODUCT_CAT#;#MAIN_UNIT#;#SALES_PRICE#;#SALES_MONEY#;#PURCHASE_PRICE#;#PURCHASE_MONEY#;" addnewline="Yes">
</cfloop>
<script type="text/javascript">
  	alert('<cfoutput>#FileName#</cfoutput> <cf_get_lang_main no='3043.Adlı Dosya Oluşturulmuştur.'>');
</script>
<table width="100%">
<tr>
	<td height="30px">
		<a href="javascript://" onclick="windowopen('<cfoutput>#readFile#</cfoutput>','medium')" class="tableyazi"><cfoutput>#FileName#</cfoutput></a> Dosyasını Buradan Yükleyiniz
	</td>
</tr>
