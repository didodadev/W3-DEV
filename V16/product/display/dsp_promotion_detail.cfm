<cfsetting showdebugoutput="no">
<cfquery name="get_prom_detail" datasource="#dsn3#">
	SELECT * FROM PROMOTIONS WHERE PROM_ID = #attributes.prom_id#
</cfquery>
<cfif len(get_prom_detail.price_catid)>
	<cfquery name="get_price_1" datasource="#dsn3#">
		SELECT PRICE_CAT FROM PRICE_CAT WHERE PRICE_CATID = #get_prom_detail.price_catid#
	</cfquery>
	<cfif get_price_1.recordcount>
		<cfset price_cat_1 = get_price_1.price_cat>
	</cfif>
<cfelse>
	<cfset price_cat_1 = ''>
</cfif>
<cfif len(get_prom_detail.condition_price_catid)>
<cfquery name="get_price_1" datasource="#dsn3#">
		SELECT PRICE_CAT FROM PRICE_CAT WHERE PRICE_CATID = #get_prom_detail.condition_price_catid#
	</cfquery>
	<cfif get_price_1.recordcount>
		<cfset price_cat_2 = get_price_1.price_cat>
	</cfif>
<cfelse>
	<cfset price_cat_2 = ''>
</cfif>
<cfquery name="get_prom_products" datasource="#dsn3#">
	SELECT 
		P.PRODUCT_ID,
		P.PRODUCT_CODE,
		P.PRODUCT_CODE_2,
		P.PRODUCT_NAME,
		PP.*
	FROM 
		PROMOTION_PRODUCTS PP,
		PRODUCT P
	WHERE 
		PP.PROMOTION_ID = #attributes.prom_id#
		AND P.PRODUCT_ID = PP.PRODUCT_ID
</cfquery>
<cfquery name="get_cond_products" datasource="#dsn3#">
	SELECT 
		P.PRODUCT_ID,
		P.PRODUCT_CODE,
		P.PRODUCT_CODE_2,
		P.PRODUCT_NAME ,
		PC.CATALOG_ID
	FROM 
		PROMOTION_CONDITIONS_PRODUCTS PP,
		PROMOTION_CONDITIONS PC,
		PRODUCT P
	WHERE 
		PP.PROM_CONDITION_ID IN(SELECT PROM_CONDITION_ID FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID = #attributes.prom_id#)
		AND PP.PROM_CONDITION_ID = PC.PROM_CONDITION_ID
		AND PP.PRODUCT_ID = P.PRODUCT_ID 
</cfquery>
<cfset product_id_list = ''>
<cfset product_id_list2 = ''>
<cfoutput query="get_prom_products">
	<cfif not listfind(product_id_list,product_id)>
		<cfset product_id_list=listappend(product_id_list,product_id)>
	</cfif>
</cfoutput>
<cfoutput query="get_cond_products">
	<cfif not listfind(product_id_list,product_id)>
		<cfset product_id_list=listappend(product_id_list,product_id)>
	</cfif>
	<cfif not listfind(product_id_list2,product_id)>
		<cfset product_id_list2=listappend(product_id_list2,product_id)>
	</cfif>
</cfoutput>
<cfif listlen(product_id_list)>
	<cfset product_id_list=listsort(product_id_list,"numeric","ASC",',')>
	<cfif len(get_prom_detail.price_catid)>
		<cfquery name="get_price" datasource="#dsn3#">
			SELECT
				PRICE_KDV,
				MONEY,
				PRODUCT_ID
			FROM 
				PRICE 
			WHERE
				PRODUCT_ID IN (#product_id_list#)
				<!---AND ISNULL(STOCK_ID,0)=0--->
				AND ISNULL(SPECT_VAR_ID,0)=0
				AND PRICE_CATID = #get_prom_detail.price_catid#
				AND STARTDATE <= #createodbcdatetime(get_prom_detail.record_date)#
				AND (FINISHDATE >= #createodbcdatetime(get_prom_detail.record_date)# OR FINISHDATE IS NULL)
			ORDER BY
				PRODUCT_ID
		</cfquery>
		<cfset main_product_id_list = listsort(listdeleteduplicates(valuelist(get_price.PRODUCT_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(get_prom_detail.catalog_id)>
		<cfquery name="get_catalog" datasource="#dsn3#">
			SELECT
				PAGE_NO
			FROM 
				CATALOG_PROMOTION_PRODUCTS 
			WHERE
				PRODUCT_ID IN (#product_id_list#)
				AND CATALOG_ID = #get_prom_detail.catalog_id#
			ORDER BY
				PRODUCT_ID
		</cfquery>
	</cfif>
</cfif>
<cfif listlen(product_id_list2)>
	<cfset product_id_list2=listsort(product_id_list2,"numeric","ASC",',')>
	<cfif len(get_prom_detail.condition_price_catid)>
		<cfquery name="get_price2" datasource="#dsn3#">
			SELECT
				PRICE_KDV,
				MONEY,
				PRODUCT_ID
			FROM 
				PRICE 
			WHERE
				PRODUCT_ID IN (#product_id_list2#)
				<!---AND ISNULL(STOCK_ID,0)=0--->
				AND ISNULL(SPECT_VAR_ID,0)=0
				AND PRICE_CATID = #get_prom_detail.condition_price_catid#
				AND STARTDATE <= #createodbcdatetime(get_prom_detail.record_date)#
				AND (FINISHDATE >= #createodbcdatetime(get_prom_detail.record_date)# OR FINISHDATE IS NULL)
			ORDER BY
				PRODUCT_ID
		</cfquery>
		<cfset main_product_id_list2 = listsort(listdeleteduplicates(valuelist(get_price2.PRODUCT_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(get_cond_products.catalog_id) and len(product_id_list2)>
		<cfquery name="get_catalog_2" datasource="#dsn3#">
			SELECT
				PAGE_NO
			FROM 

				CATALOG_PROMOTION_PRODUCTS 
			WHERE
				PRODUCT_ID IN (#product_id_list2#)
				AND CATALOG_ID = #get_cond_products.catalog_id#
			ORDER BY
				PRODUCT_ID
		</cfquery>
	</cfif>
</cfif>
<table width="100%">
	<tr>
    	<td valign="top">
        	<table align="center">
                <tr>
                    <td class="txtbold">&nbsp;<cf_get_lang dictionary_id='37243.Promosyon'></td>
                    <td>: <cfoutput>#get_prom_detail.prom_head#</cfoutput></td>
                </tr>		
                <tr>
                    <td class="txtbold">&nbsp;<cf_get_lang dictionary_id='57629.Açıklama'></td>
                    <td>: <cfoutput>#get_prom_detail.prom_detail#</cfoutput></td>
                </tr>
        	</table>
        </td>
        <td valign="top">
			<cf_medium_list>
            	<thead>
                    <tr>
                        <th colspan="5"><cf_get_lang dictionary_id='37252.Promosyona Dahil Ürünler'></th>
                    </tr>
                    <tr>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <cfif isdefined("attributes.is_product_code_2")>
                            <th width="80"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                        <cfelse>	
                            <th width="80"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                        </cfif>
                        <th width="100"><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                        <cfif len(get_cond_products.catalog_id)>
                            <th width="60"><cf_get_lang dictionary_id='37936.Sayfa No'></th>
                        </cfif>
                        <cfif len(price_cat_2)><th width="100"><cfoutput>#price_cat_2#</cfoutput></th></cfif>
                        <cfif len(price_cat_1)><th width="100"><cfoutput>#price_cat_1#</cfoutput></th></cfif>
                    </tr>
                </thead>
                <tbody>
					<cfoutput query="get_cond_products">
                        <tr>
                            <td class="color-row">#currentrow#</td>
                            <cfif isdefined("attributes.is_product_code_2")>
                                <td class="color-row">#product_code_2#</td>
                            <cfelse>	
                                <td class="color-row">#product_code#</td>
                            </cfif>
                            <td class="color-row">#product_name#</td>
                            <cfif len(get_cond_products.catalog_id) and len(product_id_list2)>
                                <td align="right" class="color-row" style="text-align:right;">
                                    <cfif len(product_id)>
                                        #get_catalog_2.page_no[listfind(product_id_list2,product_id,',')]#
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif len(price_cat_2)>
                                <td align="right" class="color-row" style="text-align:right;">
                                    <cfif len(product_id)>
                                        #tlformat(get_price2.price_kdv[listfind(main_product_id_list2,product_id,',')])#&nbsp;#get_price2.money[listfind(main_product_id_list2,product_id,',')]#
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif len(price_cat_1)>
                                <td align="right" class="color-row" style="text-align:right;">
                                    <cfif len(product_id)>
                                        #tlformat(get_price.price_kdv[listfind(main_product_id_list,product_id,',')])#&nbsp;#get_price.money[listfind(main_product_id_list,product_id,',')]#
                                    </cfif>
                                </td>
                            </cfif>
                        </tr>
                    </cfoutput>	
                </tbody>					
            </cf_medium_list>
        </td>
        <td valign="top">
            <cf_medium_list>
                <thead>
                    <tr>
                         <th colspan="5"><cf_get_lang dictionary_id='37253.Promosyonda Verilen Ürünler'></th>
                    </tr>
                    <tr>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <cfif isdefined("attributes.is_product_code_2")>
                            <th width="80"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                        <cfelse>	
                            <th width="80"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                        </cfif>
                        <th width="100"><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                        <cfif len(get_prom_detail.catalog_id)>
                            <th width="60"><cf_get_lang dictionary_id='37936.Sayfa No'></th>
                        </cfif>
                        <cfif len(price_cat_2)><th width="100"><cfoutput>#price_cat_2#</cfoutput></th></cfif>
                        <cfif len(price_cat_1)><th width="100"><cfoutput>#price_cat_1#</cfoutput></th></cfif>
                    </tr>
                 </thead>
                 <tbody>
                 <cfoutput query="get_prom_products">
                    <tr>
                        <td class="color-row">#currentrow#</td>
                        <cfif isdefined("attributes.is_product_code_2")>
                            <td class="color-row">#product_code_2#</td>
                        <cfelse>	
                            <td class="color-row">#product_code#</td>
                        </cfif>
                        <td class="color-row">#product_name#</td>
                        <cfif len(get_prom_detail.catalog_id)>
                            <td align="right" class="color-row" style="text-align:right;">
                                <cfif len(product_id)>
                                    #get_catalog.page_no[listfind(product_id_list,product_id,',')]#
                                </cfif>
                            </td>
                        </cfif>
                        <cfif len(price_cat_2)>
                            <td align="right" class="color-row" style="text-align:right;">
                                <cfif len(product_price_other_list)>#tlformat(product_price_other_list)#<cfelse>#tlformat(0)#</cfif>
                            </td>
                        </cfif>
                        <cfif len(price_cat_1)>
                            <td align="right" class="color-row" style="text-align:right;">
                                <cfif len(product_price)>#tlformat(product_price)#<cfelse>#tlformat(0)#</cfif>
                            </td>
                        </cfif>
                    </tr>
                </cfoutput>
               </tbody>
            </cf_medium_list>
        </td>
    </tr>	
</table>


