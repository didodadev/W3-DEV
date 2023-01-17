<cfparam name="attributes.maxrows" default="25">
<cfparam name="attributes.product_order_by" default="1">
<cfparam name="attributes.product_order_type" default="ASC">
<cfparam name="attributes.product_order_element" default="PRODUCT_NAME">
<cfparam name="attributes.view_mode" default="product_list">
<cfparam name="attributes.view_mode_col" default="col-md-4 col-sm-4 col-12">

<cfif (isdefined("attributes.is_stock_search_product") and attributes.is_stock_search_product eq 1) or (isdefined('attributes.is_product_order_by') and attributes.is_product_order_by eq 1) or (isdefined('attributes.is_list_types') and attributes.is_list_types eq 1)>
    <div class="product_filter">
        <cfform name="form_product_top_filter" id="form_product_top_filter" method="post" action="#request.self#">
            <cfinput type="hidden" name="view_mode" id="view_mode" value="#attributes.view_mode#">
            <cfinput type="hidden" name="view_mode_col" id="view_mode_col" value="#attributes.view_mode_col#">
            <cfinput type="hidden" name="brand_id" id="brand_id" value="#attributes.brand_id?:''#">
            <cfinput type="hidden" name="variation_select" id="variation_select" value="#attributes.variation_select?:''#">
            <div class="form-row">
                <cfif isdefined('attributes.is_product_order_by') and attributes.is_product_order_by eq 1>
                    <div class="form-group">
                        <select name="product_order_by" id="product_order_by"  onchange="form_product_top_filter.submit();">
                            <option value="1" <cfif attributes.product_order_by eq 1>selected</cfif>><cf_get_lang dictionary_id='34282.Ürün Adına Göre'></option>
                            <option value="3" <cfif attributes.product_order_by eq 3>selected</cfif>><cf_get_lang dictionary_id='35875.Fiyata Göre Artan'></option>
                            <option value="4" <cfif attributes.product_order_by eq 4>selected</cfif>><cf_get_lang dictionary_id='35876.Fiyata Göre Azalan'></option>
                        </select>
                    </div>
                </cfif>
                <cfif isdefined('attributes.is_sayfalama') and attributes.is_sayfalama eq 1>
                    <div class="form-group">
                        <select name="maxrows" id="maxrows" onchange="form_product_top_filter.submit();">
                            <option value="10" <cfif attributes.maxrows eq 10>selected</cfif>>10</option>
                            <option value="25" <cfif attributes.maxrows eq 25>selected</cfif>>25</option>
                            <option value="50" <cfif attributes.maxrows eq 50>selected</cfif>>50</option>
                            <option value="100" <cfif attributes.maxrows eq 100>selected</cfif>>100</option>
                        </select>
                    </div>
                </cfif>
                <!--- <cfif isdefined("attributes.product_order_by") and attributes.product_order_by eq 1> --->
                    <div class="form-group">
                        <select name="product_order_type" id="product_order_type"  onchange="form_product_top_filter.submit();">
                            <option value="ASC" <cfif attributes.product_order_type eq "ASC">selected</cfif>>A'dan Z'ye</option>
                            <option value="DESC" <cfif attributes.product_order_type eq "DESC">selected</cfif>>Z'den A'ya</option>
                        </select>	
                    </div>
                <!--- </cfif> --->
                <div class="form-group">
                    <cfif isdefined("attributes.is_stock_search_product") and attributes.is_stock_search_product eq 1>
                        <label class="checkbox-container" style="padding:0 0 0 30px !important;">
                            <cf_get_lang dictionary_id='34734.Stokta Olan Ürünler'>
                            <input type="checkbox" name="is_saleable_stock" id="is_saleable_stock" value="1" <cfif isdefined("attributes.is_saleable_stock")>checked</cfif> onclick="form_product_top_filter.submit();">
                            <span class="checkmark"></span>
                        </label>  
                    </cfif>
                </div>
            </div>
        </cfform>
        <div class="product_filter_navbar">
            <ul>
                <li><a href="javascript://" onclick = "setViewMode('product_list', 'col-md-4 col-ms-4 col-12', 0)"><i class="fa fa-th <cfoutput>#attributes.view_mode eq 'product_list' ? 'text-color-5' : ''#</cfoutput>"></i></a></li>
                <li><a href="javascript://" onclick = "setViewMode('product_list product_list-type2', 'col-md-12 col-ms-12 col-12', 1)"><i class="fa fa-th-list <cfoutput>#attributes.view_mode eq 'product_list product_list-type2' ? 'text-color-5' : ''#</cfoutput>"></i></a></li>
                <li><a href="javascript://" onclick = "setViewMode('product_table')"><i class="fa fa-bars <cfoutput>#attributes.view_mode eq 'product_table' ? 'text-color-5' : ''#</cfoutput>"></i></a></li>
            </ul>
        </div>
    </div>
    <script>
        function setViewMode( viewMode, viewModeCol = '', index = '' ){
            
            <cfif attributes.view_mode eq 'product_table'>
                $("#view_mode").val( viewMode );
                $("#view_mode_col").val( viewModeCol );
                $("#form_product_top_filter").submit();
            <cfelse>
                if( viewMode != 'product_table' ){
                    $("#product_bar [data-bar=product_bar_col]").removeClass().addClass( viewModeCol );
                    $("#product_bar").removeClass().addClass( viewMode );
                    $(".product_filter_navbar > ul > li a i").removeClass('text-color-5');
                    $(".product_filter_navbar > ul > li:eq("+ index +")").find('> a > i').addClass('text-color-5');
                }
                else{
                    $("#view_mode").val( viewMode );
                    $("#form_product_top_filter").submit();
                }
            </cfif>

        }
    </script>
</cfif>