<cfset product_action = createObject("component", "cfc.data")>
<cfinclude template="last_visited_5_products_cookie.cfm">
<cfif not isdefined("attributes.product_id")>
	<cfquery name="GET_PRODUCT_ID" datasource="#DSN3#">
		SELECT 
			PRODUCT_ID 
		FROM 
			STOCKS 
		WHERE 
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
	</cfquery>
	<cfset attributes.pid = get_product_id.product_id>
<cfelse>
	<cfset attributes.pid = attributes.product_id>
</cfif> 

<cfif isdefined("attributes.pid") and not isdefined("attributes.stock_id")>
	<cfquery name="GET_STOCK_ID" datasource="#DSN3#" maxrows="1">
		SELECT 
			STOCK_ID
		FROM 
			STOCKS 
		WHERE 
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>
	<cfset attributes.sid = get_stock_id.stock_id>
	<cfset attributes.stock_id = get_stock_id.stock_id>
</cfif>


	<cfif not isdefined("attributes.price_catid_2") and not isdefined("attributes.price_kdv")>
		<cfset fiyat_product_id = attributes.pid>
		<cfset fiyat_stock_id = attributes.stock_id>
		<cfinclude template="get_product_fiyat.cfm">
		<cfif not get_active_product.recordcount>
			<script type="text/javascript">
				alert('<cf_get_lang dictionary_id='62453.STOKTA YOK'>');
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfquery name="GET_PRICE" dbtype="query">
			SELECT * FROM GET_ACTIVE_PRODUCT
		</cfquery>
	</cfif>


<cfquery name="GET_LOGO_ICON" datasource="#DSN3#" maxrows="1">
    SELECT 
        PATH 
    FROM 
        PRODUCT_IMAGES 
    WHERE 
        IMAGE_SIZE = 3 AND        
        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
    ORDER BY 
    	PRODUCT_IMAGEID DESC
</cfquery>

<cfquery name="GET_IMAGE" datasource="#DSN3#" maxrows="1">
    SELECT 
        PATH 
    FROM 
        PRODUCT_IMAGES 
    WHERE 
        (IMAGE_SIZE = 0 OR IMAGE_SIZE = 1 OR IMAGE_SIZE = 2) AND        
        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
    ORDER BY 
    	PRODUCT_IMAGEID DESC
</cfquery>

<cfif isdefined("attributes.prom_id") and len(attributes.prom_id)>
	<cfquery name="GET_PRO" datasource="#DSN3#">
		SELECT 
			P.PROM_ID,
			P.DISCOUNT,
			P.AMOUNT_DISCOUNT,
			P.AMOUNT_DISCOUNT_MONEY_1,
			P.TOTAL_PROMOTION_COST,
			P.FREE_STOCK_ID,
			P.LIMIT_VALUE,
			P.FREE_STOCK_AMOUNT,
			P.FREE_STOCK_PRICE,
			P.AMOUNT_1_MONEY
		FROM 						
			PROMOTIONS P
		WHERE 
			P.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
	</cfquery>
	<cfif get_pro.recordcount>
		<cfscript>
			prom_id = get_pro.prom_id;
			prom_discount = get_pro.discount;
			prom_amount_discount = get_pro.amount_discount;
			if(len(get_pro.amount_discount_money_1))
				prom_amount_discount_money = get_pro.amount_discount_money_1;
			else
				prom_amount_discount_money = attributes.price_money;
			prom_cost = get_pro.total_promotion_cost;
			prom_free_stock_id =  get_pro.free_stock_id;
			if(len(get_pro.limit_value)) prom_stock_amount = get_pro.limit_value;
			if(len(get_pro.free_stock_amount)) prom_free_stock_amount = get_pro.free_stock_amount;
			if(len(get_pro.free_stock_price)) prom_free_stock_price = get_pro.free_stock_price;
			if(len(get_pro.amount_1_money)) 
				prom_free_stock_money = get_pro.amount_1_money;
			else if(len(get_pro.amount_discount_money_1))
				prom_free_stock_money = get_pro.amount_discount_money_1;
		</cfscript>
	</cfif>
</cfif>

<div class="product_detail_layout">
    <cfoutput query="get_active_product">  
        <div class="product_detail d-flex flex-wrap flex-sm-nowrap" > 
            <div class="col-lg-2 col-md-2 col-sm-3 px-0 mx-1">  
                <div class="product_detail_text_img">  
                    <cfif isDefined("attributes.is_image") and attributes.is_image eq 1>
                        <img src="/documents/product/#GET_IMAGE.PATH#">
                    <cfelseif isDefined("attributes.is_image") and attributes.is_image eq 2>
                        <img src="/documents/product/#GET_LOGO_ICON.PATH#">
                    </cfif>  
                </div>   
            </div>
            <div class="col-lg-10 col-md-10 col-sm-9 px-0 mx-1">          
                <div class="product_detail_text">
                    <cfif attributes.is_product_code eq 1>
                        <span>#product_code#</span> 
                    </cfif>
                    <cfif isdefined("attributes.is_stock_code") and attributes.is_stock_code eq 1>
                        <span>#product_code_2#</span>   
                    </cfif>                    
                    <h1>
                        #product_name#
                    </h1>                
                    <cfif attributes.is_detail eq 1>
                        <p class="product_det">#product_detail#</p>
                    </cfif>
                    <cfif attributes.is_detail2 eq 1>
                        <p>#product_detail2#</p>                       
                    </cfif>   
                </div>               
            </div>
        </div>
    </cfoutput>
</div>