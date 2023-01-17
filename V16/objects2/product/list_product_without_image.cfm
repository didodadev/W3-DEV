<cfset productData = createObject("component","cfc.data")>
<cfset GET_HOMEPAGE_PRODUCTS = productData.GET_HOMEPAGE_PRODUCTS(is_prices_category : attributes.is_prices_category, site: GET_PAGE.PROTEIN_SITE)>
<cfif isdefined("attributes.simple_product_maxrow") and isnumeric(attributes.simple_product_maxrow)>
	<cfset max_ = attributes.simple_product_maxrow>
<cfelse>
	<cfset max_ = 20>
</cfif>

<div class="product_list product_list-type3">
    <cfif  GET_HOMEPAGE_PRODUCTS.recordcount>    
        <cfoutput query="GET_HOMEPAGE_PRODUCTS" maxrows="#max_#">
            <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
                SELECT
                    (RATE2/RATE1) RATE
                FROM 
                    SETUP_MONEY
                WHERE
                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
            </cfquery>      
            <cfset my_width_ = 12/attributes.is_product_mode>
            <div class="product_item">		
                <div class="product_item_text">
                    <div class="product_item_brand">
                        <!--- <a href="#USER_FRIENDLY_URL#">#product_name#</a> --->
                        #product_name#
                    </div>							
                    <div class="product_item_desc">
                        <p>								
                            <cfif isDefined('attributes.is_detail') and attributes.is_detail eq 1>
                                #product_detail# <br>
                            </cfif>
                            <cfif isDefined('attributes.is_detail2') and attributes.is_detail2 eq 1>
                                #product_detail2#
                            </cfif>	
                            <cfif isDefined('attributes.is_supplier') and attributes.is_supplier eq 1>
                                <cfif len(company_id)><cf_get_lang dictionary_id='46544.Geliştirici'>: #get_par_info(company_id,1,0,0)#	</cfif>	
                            </cfif>			
                        </p>                            
                    </div>
                    
                    <div class="product_item_price">                          
                        <cfif isDefined('attributes.is_price_view') and attributes.is_price_view eq 1>                           
                            #TLFormat(PRICE_KDV * get_money_info.rate)#
                            <cfif isdefined("session.ww.money")>#session.ww.money#<cfelse>#session.pp.money#</cfif>
                        </cfif>                            
                    </div>
                    
                    <div class="product_item_basket">
                        <cfif (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
                            <cfif not isdefined('attributes.is_basket_standart') or attributes.is_basket_standart eq 1>
                                <cfif true>
                                    <div class="product_item_basket_top">                                        
                                        <div class="product_item_basket_bottom">
                                            <a href="##" onclick="add_product(#stock_id#,1,#widget.id#);"><cf_get_lang dictionary_id='44630.Ekle'></a>
                                        </div>
                                    </div>
                                <cfelse>
                                    <div class="product_item_basket_top">
                                        <div class="product_item_basket_bottom">
                                            <a style="background-color:##E8F2F6;" href="##">
                                                <cf_get_lang dictionary_id='34730.STOKTA YOK'>	
                                            </a>
                                        </div>
                                    </div>
                                </cfif>                                
                            </cfif>
                        </cfif>
                    </div>
                </div>
            </div>		
        </cfoutput> 
       <!---  <a href="Product"><h3>>Tüm Eklentiler</h3></a> --->
    </cfif>
</div>