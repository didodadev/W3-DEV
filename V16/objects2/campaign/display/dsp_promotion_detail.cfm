<cfsetting showdebugoutput="no">
<cfquery name="GET_PROM_DETAIL" datasource="#DSN3#">
	SELECT 
    	PRICE_CATID, 
        CONDITION_PRICE_CATID,
        RECORD_DATE,
        CATALOG_ID,
        PROM_HEAD,
        PROM_DETAIL 
    FROM 
    	PROMOTIONS 
    WHERE 
    	PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
</cfquery>
<cfif len(get_prom_detail.price_catid)>
	<cfquery name="GET_PRICE_1" datasource="#DSN3#">
		SELECT PRICE_CAT FROM PRICE_CAT WHERE PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_detail.price_catid#">
	</cfquery>
	<cfif get_price_1.recordcount>
		<cfset price_cat_1 = get_price_1.price_cat>
	</cfif>
<cfelse>
	<cfset price_cat_1 = ''>
</cfif>
<cfif len(get_prom_detail.condition_price_catid)>
	<cfquery name="GET_PRICE_1" datasource="#DSN3#">
		SELECT PRICE_CAT FROM PRICE_CAT WHERE PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_detail.condition_price_catid#">
	</cfquery>
	<cfif get_price_1.recordcount>
		<cfset price_cat_2 = get_price_1.price_cat>
	</cfif>
<cfelse>
	<cfset price_cat_2 = ''>
</cfif>
<cfquery name="GET_PROM_PRODUCTS" datasource="#DSN3#">
	SELECT 
		P.PRODUCT_ID,
		P.PRODUCT_CODE,
		P.PRODUCT_CODE_2,
		P.PRODUCT_NAME,
        PP.PRODUCT_PRICE_OTHER_LIST,
        PP.PRODUCT_PRICE
	FROM 
		PROMOTION_PRODUCTS PP,
		PRODUCT P
	WHERE 
		PP.PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#"> AND 
        P.PRODUCT_ID = PP.PRODUCT_ID
</cfquery>
<cfquery name="GET_COND_PRODUCTS" datasource="#DSN3#">
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
		PP.PROM_CONDITION_ID IN(SELECT PROM_CONDITION_ID FROM PROMOTION_CONDITIONS WHERE PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">) AND 
        PP.PROM_CONDITION_ID = PC.PROM_CONDITION_ID AND 
        PP.PRODUCT_ID = P.PRODUCT_ID 
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
		<cfquery name="GET_PRICE" datasource="#DSN3#">
			SELECT
				PRICE_KDV,
				MONEY,
				PRODUCT_ID
			FROM 
				PRICE 
			WHERE
				PRODUCT_ID IN (#product_id_list#) AND
				ISNULL(STOCK_ID,0)=0 AND
				ISNULL(SPECT_VAR_ID,0)=0 AND
				PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_detail.price_catid#"> AND
				STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_prom_detail.record_date)#"> AND
				(FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_prom_detail.record_date)#"> OR FINISHDATE IS NULL)
			ORDER BY
				PRODUCT_ID
		</cfquery>
		<cfset main_product_id_list = listsort(listdeleteduplicates(valuelist(get_price.product_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(get_prom_detail.catalog_id)>
		<cfquery name="GET_CATALOG" datasource="#DSN3#">
			SELECT
				PAGE_NO
			FROM 
				CATALOG_PROMOTION_PRODUCTS 
			WHERE
				PRODUCT_ID IN (#product_id_list#) AND 
                CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_detail.catalog_id#">
			ORDER BY
				PRODUCT_ID
		</cfquery>
	</cfif>
</cfif>
<cfif listlen(product_id_list2)>
	<cfset product_id_list2=listsort(product_id_list2,"numeric","ASC",',')>
	<cfif len(get_prom_detail.condition_price_catid)>
		<cfquery name="GET_PRICE2" datasource="#DSN3#">
			SELECT
				PRICE_KDV,
				MONEY,
				PRODUCT_ID
			FROM 
				PRICE 
			WHERE
				PRODUCT_ID IN (#product_id_list2#) AND
				ISNULL(STOCK_ID,0)=0 AND
				ISNULL(SPECT_VAR_ID,0)=0 AND
				PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_detail.condition_price_catid#"> AND
				STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_prom_detail.record_date)#"> AND
				(FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_prom_detail.record_date)#"> OR FINISHDATE IS NULL)
			ORDER BY
				PRODUCT_ID
		</cfquery>
		<cfset main_product_id_list2 = listsort(listdeleteduplicates(valuelist(get_price2.PRODUCT_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(get_cond_products.catalog_id) and len(product_id_list2)>
		<cfquery name="GET_CATALOG_2" datasource="#DSN3#">
			SELECT
				PAGE_NO
			FROM 
				CATALOG_PROMOTION_PRODUCTS 
			WHERE
				PRODUCT_ID IN (#product_id_list2#)
				AND CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cond_products.catalog_id#">
			ORDER BY
				PRODUCT_ID
		</cfquery>
	</cfif>
</cfif>

<table>
    <tr>
        <td colspan="3">
            <table>
                <tr>
                    <td class="txtboldblue">&nbsp;<cf_get_lang_main no ='1408.Başlık'></td>
                    <td>: <cfoutput>#get_prom_detail.prom_head#</cfoutput></td>
                </tr>		
                <tr>
                    <td class="txtboldblue">&nbsp;<cf_get_lang_main no ='217.Açıklama'></td>
                    <td>:  <cfoutput>#get_prom_detail.prom_detail#</cfoutput></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table style="width:100%;">
    <tr>
        <td class="txtboldblue"><cf_get_lang no ='203.Promosyona Dahil Ürünler'></td>
    </tr>   
    <tr>
        <td style="vertical-align:top;">
            <table style="width:100%;">
                <tr>
                    <td class="txtbold" style="width:50px;"><cf_get_lang_main no ='75.No'></td>
                    <cfif isdefined("attributes.is_product_code_2")>
                        <td class="txtbold" style="width:30%;"><cf_get_lang_main no ='377.Özel Kod'></td>
                    <cfelse>	
                        <td class="txtbold" style="width:20%;"><cf_get_lang_main no ='1388.Ürün Kodu'></td>
                    </cfif>
                    <td class="txtbold"><cf_get_lang_main no ='809.Ürün Adı'></td>
                    <cfif len(get_cond_products.catalog_id)>
                        <td class="txtbold" style="width:20%;"><cf_get_lang_main no ='169.Sayfa'> <cf_get_lang_main no ='75.No'></td>
                    </cfif>
                    <cfif len(price_cat_2)><td class="txtbold"><cfoutput>#price_cat_2#</cfoutput></td></cfif>
                    <cfif len(price_cat_1)><td class="txtbold"><cfoutput>#price_cat_1#</cfoutput></td></cfif>
                </tr>
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
                            <td class="color-row">
                                <cfif len(product_id)>
                                    #get_catalog_2.page_no[listfind(product_id_list2,product_id,',')]#
                                </cfif>
                            </td>
                        </cfif>
                        <cfif len(price_cat_2)>
                            <td class="color-row">
                                <cfif len(product_id)>
                                    #tlformat(get_price2.price_kdv[listfind(main_product_id_list2,product_id,',')])#&nbsp;#get_price2.money[listfind(main_product_id_list2,product_id,',')]#
                                </cfif>
                            </td>
                        </cfif>
                        <cfif len(price_cat_1)>
                            <td class="color-row">
                                <cfif len(product_id)>
                                    #tlformat(get_price.price_kdv[listfind(main_product_id_list,product_id,',')])#&nbsp;#get_price.money[listfind(main_product_id_list,product_id,',')]#
                                </cfif>
                            </td>
                        </cfif>
                    </tr>
                </cfoutput>					
            </table>
        </td>
    </tr>
</table>
<cfif get_prom_products.recordcount>
    <table style="width:100%;">
        <tr>
            <td class="txtboldblue"><cf_get_lang no ='204.Promosyonda Verilen Ürünler'></td>
        </tr>
        <tr>
            <td>
                <table style="width:100%;">
                    <tr>
                        <td class="txtbold" style="width:50px;"><cf_get_lang_main no ='75.No'></td>
                        <cfif isdefined("attributes.is_product_code_2")>
                            <td class="txtbold" style="width:30%;"><cf_get_lang_main no ='377.Özel Kod'></td>
                        <cfelse>	
                            <td class="txtbold" style="width:20%;"><cf_get_lang_main no ='1388.Ürün Kodu'></td>
                        </cfif>
                        <td class="txtbold"><cf_get_lang_main no ='809.Ürün Adı'></td>
                        <cfif len(get_prom_detail.catalog_id)>
                            <td class="txtbold" style="width:20%;"><cf_get_lang_main no ='169.Sayfa'> <cf_get_lang_main no ='75.No'></td>
                        </cfif>
                        <cfif len(price_cat_2)><td class="txtbold"><cfoutput>#price_cat_2#</cfoutput></td></cfif>
                        <cfif len(price_cat_1)><td class="txtbold"><cfoutput>#price_cat_1#</cfoutput></td></cfif>
                    </tr>
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
                                <td class="color-row">
                                    <cfif len(product_id)>
                                        #get_catalog.page_no[listfind(product_id_list,product_id,',')]#
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif len(price_cat_2)>
                                <td class="color-row">
                                    <cfif len(product_price_other_list)>#tlformat(product_price_other_list)#<cfelse>#tlformat(0)#</cfif>
                                </td>
                            </cfif>
                            <cfif len(price_cat_1)>
                                <td class="color-row">
                                    <cfif len(product_price)>#tlformat(product_price)#<cfelse>#tlformat(0)#</cfif>
                                </td>
                            </cfif>
                        </tr>
                    </cfoutput>
                </table>					
             </td>
        </tr>	
    </table>
</cfif>
