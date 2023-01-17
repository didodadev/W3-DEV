<cfquery name="PRODUCT_CATS" datasource="#DSN1_alias#">
	SELECT 
        PC.PRODUCT_CATID,
    	PC.HIERARCHY,
        PC.PRODUCT_CAT,
        PC.PROFIT_MARGIN,
        PC.PROFIT_MARGIN_MAX,
        PC.LIST_ORDER_NO,
        PC.USER_FRIENDLY_URL,
        PC.DETAIL,
        PC.IS_PUBLIC,
        PC.IS_CUSTOMIZABLE,
        PC.IS_INSTALLMENT_PAYMENT,
        PC.IMAGE_CAT,
        PC.IMAGE_CAT_SERVER_ID,
        PC.STOCK_CODE_COUNTER  
	FROM 
		PRODUCT_CAT PC	
	WHERE 
        PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
    ORDER BY 
    	HIERARCHY
</cfquery>
<cfquery name="CATEGORY" dbtype="query">
	SELECT 
    	* 
    FROM 
    	PRODUCT_CATS 
    WHERE 
    	PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
</cfquery>
<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY
	ORDER BY
		NICK_NAME
</cfquery>

<div class="row">
    <cfoutput query="PRODUCT_CATS">  
        <div class="col-md-12">       
            <cf_get_lang dictionary_id='57486.Kategori'>: #PRODUCT_CAT#     
        </div>
        <div class="col-md-12">
            <cf_get_lang dictionary_id='57629.Açıklama'>: #DETAIL#
        </div>
        <div class="col-md-12">        
            <cf_get_lang dictionary_id='58017.İlişkili Şirketler'>: #GET_OUR_COMPANIES.nick_name#
        </div>
        <div class="col-md-12">
            <cf_get_lang dictionary_id='32775.Kategori Kodu'>:#hierarchy#        
        </div>
        <div class="col-md-12">
            <cf_get_lang dictionary_id='33021.Marj'> <cf_get_lang dictionary_id='37321.Minimum'>: #filternum(category.profit_margin,0)#        
        </div>
        <div class="col-md-12">
            <cf_get_lang dictionary_id='33021.Marj'> <cf_get_lang dictionary_id='37319.Maksimum'>:  #filternum(category.profit_margin_max,0)#        
        </div>
        <div class="col-md-12">
            <cf_get_lang dictionary_id='37545.Listeleme Sırası'>:  #category.list_order_no#        
        </div>
        <div class="col-md-12">
            <cf_get_lang dictionary_id='61459.Stok Kodu Sayacı'>:  #category.STOCK_CODE_COUNTER#        
        </div>
        <div class="col-md-12">
            <cfif len(IMAGE_CAT)>
                <cf_get_lang dictionary_id='29762.İmaj'> : <img src="documents/#IMAGE_CAT#" height="80px" width="80px"> 
            </cfif>       
        </div>       
    </cfoutput>
</div>