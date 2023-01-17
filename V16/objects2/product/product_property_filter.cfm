<cfparam name="attributes.kategori" default="">
<cfparam name="attributes.hierarchy" default=''>
<cfparam name="attributes.brand_id" default=''>
<cfparam name="attributes.variation_select" default=''>
<cfparam name="attributes.max_view_filter_item" default='5'>
<cfparam name="attributes.search" default=''>

<cfset product_action = createObject("component", "cfc.data")>
<cfset product_properties_get_2 = product_action.get_product_properties_2( hierarchy : '#attributes.hierarchy#', kategori:'#attributes.kategori#', our_company_id: session_base.our_company_id )>
<cfset product_brands_get = product_action.get_product_brands( hierarchy : '#attributes.hierarchy#', our_company_id: session_base.our_company_id )>
<cfset get_product_hierarchy = product_action.GET_PRODUCT_HIERARCHY(is_filter:1,is_public:1)>
<cfif product_brands_get.recordcount or product_properties_get_2.recordcount>
    <div class="product_property_filter">
        <form name="form_product_property_filter" id="form_product_property_filter" method="post">
            <input type="hidden" value="<cfoutput>#attributes.search#</cfoutput>" id="search" name="search">

            <cfif product_brands_get.recordcount>
                <!-- Marka -->
                <div class="product_filter_item">   
                    <div class="product_filter_content_title">
                        <cf_get_lang dictionary_id='42904.Markalar'>
                        <i class="fa fa-angle-down"></i>
                    </div>
                    <div class="product_filter_content">
                        <ul>
                            <cfoutput query="product_brands_get">
                                <li class="#(currentrow gt attributes.max_view_filter_item and product_brands_get.recordcount gt attributes.max_view_filter_item) ? 'show_more_item' : ''#">
                                    <label class="checkbox-container">#BRAND_NAME#
                                        <input type="checkbox" id="#BRAND_NAME#" name="brand_id" value="#BRAND_ID#" <cfif listfind(attributes.brand_id, BRAND_ID)>checked</cfif>><span class="checkmark"></span>
                                    </label>   
                                </li>
                                <cfif currentrow eq attributes.max_view_filter_item and product_brands_get.recordcount gt attributes.max_view_filter_item>
                                    <li class="show_more"><a href="javascript://">#getLang('','Hepsini Göster',64184)#</a></li>
                                </cfif>
                            </cfoutput>
                        </ul>
                    </div>
                </div>
            </cfif>
            <cfif product_properties_get_2.recordcount>

                <cfquery name="get_property" dbtype="query">
                    SELECT PROPERTY_ID, PROPERTY FROM product_properties_get_2 GROUP BY PROPERTY_ID, PROPERTY
                </cfquery>

                <!-- Özellikler -->
                <div class="product_filter_item">
                    <div class="product_filter_content_title">
                        <cf_get_lang dictionary_id='60320.Özellikler'>
                        <i class="fa fa-angle-down"></i>
                    </div>
                    <div class="product_filter_content">
                        <ul>
                            <cfoutput query="get_property">
                                <cfset propertyCounter = currentrow />
                                <cfset showMoreItemClass = (propertyCounter gt attributes.max_view_filter_item and get_property.recordcount gt attributes.max_view_filter_item) ? 'show_more_item' : '' />
                                <li class="header #showMoreItemClass#">#PROPERTY#</li>
                                <cfquery name="get_property_detail" dbtype="query">
                                    SELECT * FROM product_properties_get_2 WHERE PROPERTY_ID = #PROPERTY_ID#
                                </cfquery>
                                <cfloop query="#get_property_detail#">
                                    <li class="#showMoreItemClass#">
                                        <label class="checkbox-container">#get_property_detail.PROPERTY_DETAIL#
                                            <input type="checkbox" id="prop_#get_property_detail.property_detail_id#" name="variation_select" value="#get_property_detail.property_id#*#get_property_detail.property_detail_id#" <cfif listfind(attributes.variation_select, '#get_property_detail.property_id#*#get_property_detail.property_detail_id#')>checked</cfif>><span class="checkmark"></span>
                                        </label>  
                                    </li>
                                </cfloop>
                                <cfif propertyCounter eq attributes.max_view_filter_item and get_property.recordcount gt attributes.max_view_filter_item>
                                    <li class="show_more"><a href="javascript://">#getLang('','Hepsini Göster',64184)#</a></li>
                                </cfif>
                            </cfoutput>
                        </ul>
                    </div>
                </div>
            </cfif>
            <div class="product_filter_item">
                <div class="product_filter_content_title">
                    <cf_get_lang dictionary_id='57486.Kategori'>
                    <i class="fa fa-angle-down"></i>
                </div>
                <div class="product_filter_content">
                    <ul>
                        <cfoutput query="get_product_hierarchy">
                            <li <cfif currentrow gt 5>class="show_more_item"</cfif>>
                                <label class="checkbox-container">
                                    #PRODUCT_CAT#
                                    <input type="checkbox" id="product_catid" name="product_catid" value="#PRODUCT_CATID#"<cfif isDefined("attributes.product_catid") and listfind(attributes.product_catid,PRODUCT_CATID)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                        </cfoutput>   
                        <li class="show_more"><a href="javascript://"><cfoutput>#getLang('','Hepsini Göster',64184)#</cfoutput></a></li>                        
                    </ul>
                </div>
            </div>
            <cfif isdefined("attributes.is_product_features") and attributes.is_product_features eq 1>
                <div class="product_filter_item">
                    <div class="product_filter_content_title">
                        <cf_get_lang dictionary_id='33614.Product Features'>
                        <i class="fa fa-angle-down"></i>
                    </div>
                    <div class="product_filter_content">
                        <ul>
                            <li>
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='58079.İnternet'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="9"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,9)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li>
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='58019.Extranet'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="12"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,12)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li>
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37170.Tedarik Edilmiyor'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="5"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,5)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37061.Tedarik Ediliyor'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="1"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,1)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37090.Hizmetler'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="2"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,2)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37055.Envantere Dahil'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="16"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,16)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37423.Mallar'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="3"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,3)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37066.Terazi'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="4"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,4)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37057.Üretiliyor'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="6"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,6)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37556.Maliyet Takip Ediliyor'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="13"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,13)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id="37254.Kalite"> <cf_get_lang dictionary_id="37175.Takip Ediliyor">
                                    <input type="checkbox" id="product_types_" name="product_types" value="15"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,15)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37557.Seri No Takip'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="7"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,7)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37467.Karma Koli'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="8"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,8)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>                        
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37063.Özelleştirilebilir'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="10"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,10)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37558.Sıfır Stok İle Çalış'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="11"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,11)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37059.Satışta'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="14"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,14)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37922.Stoklarla Sınırlı'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="18"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,18)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more_item">
                                <label class="checkbox-container">
                                    <cf_get_lang dictionary_id='37155.Lot No'>
                                    <input type="checkbox" id="product_types_" name="product_types" value="17"<cfif isDefined("attributes.product_types") and listfind(attributes.product_types,17)> checked</cfif>>
                                    <span class="checkmark"></span>
                                </label>  
                            </li>
                            <li class="show_more"><a href="javascript://"><cfoutput>#getLang('','Hepsini Göster',64184)#</cfoutput></a></li>
                        </ul>
                    </div>
                </div>
            </cfif>
            <div class="product_filter_button">
                <button type="submit" class="btn btn-block btn-outline-info font-weight-bold text-uppercase" id="searchBtn"><i class="fa fa-search"></i> <cf_get_lang dictionary_id='57565.Ara'></button>
            </div>
        </form>
    </div>

    <script>
        $("li.show_more > a").click(function(){
            $(this).closest('ul').find('li.show_more_item').toggle();
        });
    </script>
</cfif>