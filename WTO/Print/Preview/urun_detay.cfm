<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfquery name="CHECK" datasource="#DSN#">
  SELECT 
  ASSET_FILE_NAME2,
  ASSET_FILE_NAME2_SERVER_ID,
  COMPANY_NAME
  FROM 
    OUR_COMPANY 
  WHERE 
    <cfif isdefined("attributes.our_company_id")>
      COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
    <cfelse>
      <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
        COMP_ID = #session.ep.company_id#
      <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
        COMP_ID = #session.pp.company_id#
      <cfelseif isDefined("session.ww.our_company_id")>
        COMP_ID = #session.ww.our_company_id#
      <cfelseif isDefined("session.cp.our_company_id")>
        COMP_ID = #session.cp.our_company_id#
      </cfif> 
    </cfif>    
</cfquery>
<cfif not isdefined("attributes.iid")>
	<cfset attributes.product_id = listdeleteduplicates(attributes.id)>
<cfelse>
	<cfset attributes.product_id = attributes.iid>
</cfif>
<cfquery name="GET_PRODUCT" datasource="#DSN_product#">
    SELECT 
    	* 
    FROM 
    	PRODUCT
    WHERE	
      	<cfif not isDefined("attributes.product_id")>
         PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
      	<cfelse>
          PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
      	</cfif> 
</cfquery>
<cfquery name="GET_PROCURRENCY" datasource="#dsn#">
    SELECT
      STAGE,
      PROCESS_ROW_ID 
    FROM
      PROCESS_TYPE_ROWS 
    WHERE
      PROCESS_ROW_ID =#GET_PRODUCT.PRODUCT_STAGE#
</cfquery>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN_product#">
	SELECT 
		PRODUCT_CATID, 
		PRODUCT_CAT
	FROM
		PRODUCT_CAT
	WHERE
		PRODUCT_CATID =#get_product.Product_catid# 
</cfquery>
<cfparam  name="attributes.brand_id"default=0>
<cfif len(GET_PRODUCT.BRAND_ID)>
	<cfset attributes.brand_id=GET_PRODUCT.BRAND_ID>
	<cfquery name ="GET_PRODUCT_BRAND" datasource="#DSN_product#">
		SELECT 
		BRAND_ID,
		BRAND_NAME
		FROM
		PRODUCT_BRANDS
		WHERE
		BRAND_ID = 
		#attributes.brand_id#
	</cfquery>
	<cfelse>
		<cfset GET_PRODUCT_BRAND.recordcount=0>
</cfif>
<cfquery name="GET_SEGMENTS" datasource="#DSN1#">
	SELECT * FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT
</cfquery>
<cfquery name="GET_PRODUCT_COMP" datasource="#DSN3#">
	SELECT 
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE COMPETITIVE
		END AS COMPETITIVE,
		COMPETITIVE_ID 
	FROM 
		PRODUCT_COMP
		LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_COMP.COMPETITIVE_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMPETITIVE">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_COMP">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY COMPETITIVE
</cfquery>
<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
        CASE
        	WHEN LEN(ITEM) > 0 THEN ITEM
            ELSE PTR.STAGE
        END AS STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR
        	LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTR.PROCESS_ROW_ID
            AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
            AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
            AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_product%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfoutput>
<table style="width:210mm">
    <tr>
      	<td>
			<table width="100%">
				<tr class="row_border">
					<td class="print-head">
						<table style="width:100%;">
							<tr>
								<td class="print_title"><cf_get_lang dictionary_id='57657.Ürün'></td>
								<td style="text-align:right;">
									<cfif len(check.asset_file_name2)>
									<cfset attributes.type = 1>
										<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
									</cfif>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class="row_border"class="row_border">
					<td>
						<table>
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='57657.Ürün'></b></td>
								<td style="width:170px">#get_product.product_name#</td> 
								<td style="width:150px"><b><cf_get_lang dictionary_id='57486.Kategori'></b></td>
								<td style="width:180px"><cfif get_product.product_catid eq get_product_cat.product_catid>#get_product_cat.product_cat#<cfelse>&nbsp;</cfif></td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='58800.Ürün Kodu'></b></td>
								<td style="width:170px">#get_product.product_code#</td>
								<td style="width:150px"><b><cf_get_lang dictionary_id='57633.Barkod'></b></td>
								<td style="width:180px">#get_product.barcod#</td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='57634.Üretici Kodu'></b></td>
								<td style="width:170px"><cfif len(#get_product.manufact_code#)>#get_product.manufact_code#<cfelse>&nbsp;</cfif></td>
								<td style="width:150px"><b><cf_get_lang dictionary_id='37040.S D Tarihi'></b></td>
								<td style="width:180px"><cfif isdate(get_product.update_date)>#dateformat(get_product.update_date,dateformat_style)#<cfelse>#dateformat(get_product.record_date,dateformat_style)#</cfif></td>
							</tr>
							<tr>
							<tr>
								<td style="width:140"><b><cf_get_lang dictionary_id='57639.KDV'></b></td>
								<td style="width:170px">#get_product.tax_purchase#</td>
								<td style="width:150px"><b><cf_get_lang_main no='672.Fiyat'></b></td>
								<cfquery name="GET_PRICE" datasource="#DSN3#">
								SELECT
									PRICE,
									MONEY,
									IS_KDV,
									PRICE_KDV
								FROM 
									PRICE_STANDART,
									PRODUCT_UNIT
								WHERE 
									PRICE_STANDART.PURCHASESALES = 1 AND 
									PRODUCT_UNIT.IS_MAIN = 1 AND 
									PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
									PRICE_STANDART.PRODUCT_ID = #attributes.iid# AND					
									PRODUCT_UNIT.PRODUCT_ID = #attributes.iid# 
								</cfquery>
								<cfquery name="get_money_info" datasource="#dsn2#">
								SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY = '#get_price.money#'
								</cfquery>
								<td style="width:180px">#TLFormat(get_price.price)#	#get_price.money# + <cf_get_lang dictionary_id='57639.KDV'></td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='58847.Marka'></b></td>
								<td style="width:170px"><cfif get_product_brand.recordcount neq 0 >#get_product_brand.brand_name#<cfelse>&nbsp;</cfif></td>
							</tr>
						</table>
					</td> 
				</tr>
		
				<table style="width:210mm">
					<tr class="process-tr">
						<td style="width:140px"><b><cf_get_lang dictionary_id='58859.Süreç'>/<cf_get_lang dictionary_id='57482.Aşama'></b></td>
						<td><cfif get_procurrency.PROCESS_ROW_ID eq GET_PRODUCT.PRODUCT_STAGE>#get_procurrency.stage#</cfif></td>
					</tr>
				</table>
				<table style="width:210mm">
					<td style="font-size:12px"><b><cf_get_lang dictionary_id='58166.Stoklar'></b></td>
					<table style="width:210mm;" border="0"  cellpadding="1" cellspacing="1" >
						<tr>
							<td valign="top">
								<table width="75%" cellpadding="3" cellspacing="0" border="1">	
									<tr class="txtbold">
										<td ><b><cf_get_lang dictionary_id='57518.Stok Kodu'></b></td>
										<td ><b><cf_get_lang dictionary_id='57633.Barkod'></b></td>
										<td ><b><cf_get_lang dictionary_id='57629.Açıklama'></b></td>
									</tr>
									<tr class="txtbold">
										<td style="text-align:right;">#get_product.product_code#</td>
										<td style="text-align:right;">#get_product.barcod#</td>
										<td><cfif len(get_product.product_detail)>#get_product.product_detail#<cfelse>&nbsp;</cfif></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</table>
				<br>
					<table>
						<tr class="fixed">
							<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
						</tr>
					</table>
				</br>	
			</table>
		</td>
	</tr>
</table>
</cfoutput>

