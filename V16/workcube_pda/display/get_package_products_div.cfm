<cfsetting showdebugoutput="no">
<cf_date tarih='attributes.price_date'>

<!--- Xml Kullanim mantigi degistirildi bu yuzden uygun sekilde duzenlenip burasi kaldirilacak FBS 20111020
<cffile action="read" file="#session.pda.pda_settings_xml_file_path#" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfloop from="1" to="500" index="i">
	<cftry>
		<cfif attributes.package_type is i>
			<cfset offer_package_products = dosyam.WORKCUBE_PDA_SETTINGS.OFFER.PACKAGE[i].PRODUCT_IDS.XmlText>
			<cfset offer_package_amounts = dosyam.WORKCUBE_PDA_SETTINGS.OFFER.PACKAGE[i].AMOUNTS.XmlText>
			<cfbreak>
		</cfif>		
		<cfcatch>
			<cfbreak>
		</cfcatch>
	</cftry>
</cfloop> --->

<cfquery name="GET_PRODUCT_INFO" datasource="#dsn3#">
	SELECT
		STOCKS.PRODUCT_ID,
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_CODE,
		STOCKS.BARCOD,
		STOCKS.PROPERTY,		
		STOCKS.STOCK_ID,
		STOCKS.TAX,
		STOCKS.MANUFACT_CODE,
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		PU.MULTIPLIER
	<cfif isdefined('attributes.offer_type_id') and attributes.offer_type_id is 0>
		,
		PRICE.PRICE,
		PRICE.MONEY		
	<cfelseif isdefined('attributes.offer_type_id') and attributes.offer_type_id gt 0>
		,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY
	<cfelse>
		,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY
	</cfif>		
	FROM
		STOCKS,
		PRODUCT_UNIT AS PU
	<cfif isdefined('attributes.offer_type_id') and attributes.offer_type_id is 0>
		,PRICE
	<cfelseif isdefined('attributes.offer_type_id') and attributes.offer_type_id gt 0>
		,PRICE_STANDART
	<cfelse>
		,PRICE_STANDART
	</cfif>		
	WHERE
		STOCKS.PRODUCT_STATUS = 1 AND
		STOCKS.STOCK_STATUS = 1 AND
		STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		STOCKS.PRODUCT_ID = PU.PRODUCT_ID AND
		PU.MAIN_UNIT = PU.ADD_UNIT AND
			
	<cfif isdefined('attributes.offer_type_id') and attributes.offer_type_id is 0>
		STOCKS.PRODUCT_ID = PRICE.PRODUCT_ID AND
		ISNULL(PRICE.STOCK_ID,0)=0 AND
		ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND
		PRICE.PRICE_CATID = #session.pda.offer_subs_price_cat_id# AND
		(
			PRICE.STARTDATE <= #attributes.price_date# AND
			(PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
		)
	<cfelseif isdefined('attributes.offer_type_id') and attributes.offer_type_id gt 0>
		STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
		PRICE_STANDART.PURCHASESALES = 1 AND
		PRICE_STANDART.PRICESTANDART_STATUS = 1 
	<cfelse>
		STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
		PRICE_STANDART.PURCHASESALES = 1 AND
		PRICE_STANDART.PRICESTANDART_STATUS = 1 
	</cfif>
		AND STOCKS.PRODUCT_ID IN (#offer_package_products#)
	ORDER BY
		STOCKS.PRODUCT_NAME, STOCKS.PROPERTY
</cfquery>
<cfif GET_PRODUCT_INFO.recordcount>
	<script type="text/javascript">
		<cfoutput query="GET_PRODUCT_INFO">
			<cfquery name="GET_PRODUCT_CODE_2" datasource="#dsn3#">
			SELECT PRODUCT_CODE_2 FROM PRODUCT WHERE PRODUCT_ID = #PRODUCT_ID#
			</cfquery>
			<cfquery name="GET_PRODUCT_INFO_PLUS" datasource="#dsn3#">
			SELECT PROPERTY1 FROM PRODUCT_INFO_PLUS WHERE PRODUCT_ID = #PRODUCT_ID#
			</cfquery>
			<cfif GET_PRODUCT_INFO_PLUS.recordcount><cfset property1=GET_PRODUCT_INFO_PLUS.PROPERTY1><cfelse><cfset property1=''></cfif>
			i = parseInt(document.getElementById('row_count').value) + 1;
			add_product(document.getElementById('row_count').value ,'#STOCK_ID#','#PRODUCT_ID#','#PRODUCT_NAME# <cfif len(PROPERTY)> #PROPERTY#</cfif>','#PRICE#','#MONEY#','#ADD_UNIT#','#PRODUCT_UNIT_ID#','#TAX#','#MANUFACT_CODE#','#GET_PRODUCT_CODE_2.PRODUCT_CODE_2#','#property1#');
			eval('document.all.amount'+i).value = #listgetat(offer_package_amounts,listfind(offer_package_products,PRODUCT_ID))#;
		</cfoutput>
		toplam_hesapla();
	</script>			
<!--- <cfelse> --->
</cfif>

