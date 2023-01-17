<cfquery name="GET_CONTENT_RESULTS" datasource="#DSN#">
	SELECT
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_SUMMARY,
		C.USER_FRIENDLY_URL,
		C.HIT 
	FROM 
		CONTENT C,
		CONTENT_CAT CCAT, 
		CONTENT_CHAPTER CC
	WHERE 
		C.STAGE_ID = -2 AND	 
		C.CONTENT_STATUS = 1 AND
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
            (
				<cfif isdefined("is_fulltext_search") and is_fulltext_search eq 1 >
				  	CONTAINS(C.*,'"#attributes.keyword#*"') 
				<cfelse>
					C.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
					C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
					C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>				
            )
            AND 
        </cfif>
		C.CHAPTER_ID = CC.CHAPTER_ID AND 
		CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND 
		<cfif isdefined("session.ww.language")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
		<cfelseif isdefined("session.pp.language")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
		<cfelseif isdefined("session.cp")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#"> AND
		</cfif>
		<cfif isdefined("session.pp.company_category")>
			C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">)
		<cfelseif isdefined("session.ww.consumer_category")>
			C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
		<cfelseif isdefined("session.cp")>
			CAREER_VIEW = 1 AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">)
		<cfelse>
			INTERNET_VIEW = 1  AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
		</cfif>
		ORDER BY 
			C.CONTENT_ID DESC
</cfquery>
<cfquery name="GET_PRODUCTS" datasource="#DSN3#">
	SELECT
		DISTINCT 
		STOCKS.STOCK_ID,
		STOCKS.PROPERTY,
		STOCKS.BARCOD,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_UNIT_ID,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.TAX,
		PRODUCT.IS_ZERO_STOCK,
		PRODUCT.BRAND_ID,
		PRODUCT.USER_FRIENDLY_URL,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.PRODUCT_DETAIL,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.RECORD_DATE,
		PRODUCT.IS_PRODUCTION,
		PRODUCT.IS_PROTOTYPE,
		PRODUCT.SEGMENT_ID,
		PRODUCT.COMPANY_ID,
		PRICE_STANDART.PRICE PRICE,
		PRICE_STANDART.MONEY MONEY,
		PRICE_STANDART.IS_KDV IS_KDV,
		PRICE_STANDART.PRICE_KDV PRICE_KDV,
		PRODUCT.PRODUCT_DETAIL2,
		PRODUCT.PRODUCT_CODE_2
	FROM
		PRODUCT,
		PRODUCT_CAT,
		#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
		STOCKS,
		PRICE_STANDART,
		PRODUCT_UNIT
	WHERE
		<cfif isdefined("attributes.is_saleable_stock") and stock_mod_ gte 1>
			(
			<cfloop from="1" to="#stock_mod_#" index="ccc">
				STOCKS.STOCK_ID IN (#evaluate("last_stock_list_#ccc#")#)
				<cfif ccc neq stock_mod_>OR</cfif>
			</cfloop>
			)
			AND
		</cfif>
		STOCKS.STOCK_STATUS = 1 AND
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
		PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam value="#session_base.our_company_id#" cfsqltype="cf_sql_integer"> AND
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
		PRODUCT_UNIT.IS_MAIN = 1 AND			
		<cfif isdefined("session.pp")>PRODUCT.IS_EXTRANET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND<cfelse>PRODUCT.IS_INTERNET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND</cfif>
		PRICE_STANDART.PRICE ><cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
		PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
		PRICE_STANDART.PURCHASESALES = 1 AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
		PRODUCT.PRODUCT_STATUS = 1		
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            AND 
            (
                PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
                PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
                PRODUCT.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
                PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
                PRODUCT.PRODUCT_CODE LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
                PRODUCT.USER_FRIENDLY_URL LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> OR
				PRODUCT.PRODUCT_ID IN (
                                            SELECT 
                                                DISTINCT
                                                PDP.PRODUCT_ID 
                                            FROM 
                                                #dsn1_alias#.PRODUCT_DT_PROPERTIES PDP
                                            WHERE 
                                                PDP.IS_INTERNET = 1 AND
                                                (
                                                    PDP.PROPERTY_ID IN 
                                                    				(
                                                                        SELECT 
                                                                            PPD.PROPERTY_DETAIL_ID 
                                                                        FROM 
                                                                            #dsn1_alias#.PRODUCT_PROPERTY_DETAIL PPD
                                                                        WHERE 
                                                                            PPD.IS_ACTIVE = 1 AND
                                                                            PPD.PROPERTY_DETAIL LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar">  
                                                                    )  OR
                                                    PDP.VARIATION_ID IN 
                                                    				(
                                                                        SELECT 
                                                                            PPD.PROPERTY_DETAIL_ID 
                                                                        FROM 
                                                                            #dsn1_alias#.PRODUCT_PROPERTY_DETAIL PPD
                                                                        WHERE 
                                                                            PPD.IS_ACTIVE = 1 AND
                                                                            PPD.PROPERTY_DETAIL LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar"> 
                                                                    )
                                                )
            							)
            )
        </cfif>
	ORDER BY
		PRODUCT.PRODUCT_NAME
</cfquery>

<cfif get_products.recordcount>
	<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
		<cfoutput query="get_products">
			<tr style="height:29px;">
				<td class=baslik colspan="2">
				<b><a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#','#user_friendly_url#')#">#product_name#</a></b>
				</td>
			</tr>
			<!--- <tr>
				<td width="14">
				<img border="0" src="/documents/templates/hayat/img/man.png" width="8" height="10"></td>
				<td class=icerik" width="96%">#nickname#</td>
			</tr> --->
			<tr style="height:15px;">
				<td valign="bottom" colspan="2">
				<p align="left">
				<img border="0" src="/images/alt_yazarlar.jpg" width="649" height="1"></td>
				<td></td>
			</tr>
		</cfoutput>
	</table>
<cfelse>
	<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
		<tr>
			<td colspan="2">İlgili Anahtar Kelime İle İlgili Ürün Kaydı Yok!</td>
		</tr>
	</table>
</cfif>

<cfif get_content_results.recordcount>
	<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
		<cfoutput query="get_content_results">
			<tr class="color-list">
				<td style="width:20px;"><img src="/images/notkalem.gif" title="<cf_get_lang_main no='241.İçerik'>" alt="<cf_get_lang_main no='241.İçerik'>" border="0" /></td> 
				<td><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="label">#cont_head#</a></td>
			</tr>  
			<tr>
				<td colspan="2">#cont_summary#</td>
			</tr> 
		</cfoutput>
	</table>
<cfelse>
	<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
		<tr>
			<td colspan="2">İlgili Anahtar Kelime İle İlgili İçerik Kaydı Yok!</td>
		</tr>
	</table>
</cfif>
