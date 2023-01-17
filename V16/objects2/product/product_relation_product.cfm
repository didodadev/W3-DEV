<cfparam  name="attributes.header_dic_id" default="">
<cfset product_other = createObject("component", "cfc.productOther")>

<cfif isdefined('attributes.prod_relation_theme') and attributes.prod_relation_theme eq 0> 
<cfif isdefined("attributes.product_id")>
	<cfset attributes.pid = attributes.product_id>
</cfif>
<cfparam name="attributes.price_catid" default="-2">
<cfif isdefined('attributes.prod_relation_prod_price') and attributes.prod_relation_prod_price neq 0><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
	<cfinclude template="../query/get_price_cats_moneys.cfm">
</cfif>

<cfset GET_RELATED_PRODUCT = product_other.GET_RELATED_PRODUCT(pid : attributes.pid, last_user_price_list: '#IIf(IsDefined("attributes.last_user_price_list"),"attributes.last_user_price_list",DE(''))#')>

<cfif isdefined('attributes.prod_relation_prod_price') and attributes.prod_relation_prod_price eq 1><!--- fiyat yoksa bu bloga girmez --->
	<cfinclude template="../query/get_price_all.cfm">
	<cfset add_basket_express_prod_id_list = ''><!--- kesinlikle silinmesin yo29122008 --->
	<cfset catalog_list = valuelist(get_price_all.catalog_id)>
	<cfset catalog_list = listsort(catalog_list,"numeric","ASC")>
	<cfif listlen(catalog_list)>
		<cfquery name="GET_CATALOGS" datasource="#DSN3#">
			SELECT CATALOG_ID,CATALOG_HEAD FROM CATALOG_PROMOTION WHERE CATALOG_ID IN (#catalog_list#)
		</cfquery>
	</cfif>
</cfif>

<cfif session_base.language neq 'tr'>
    <cfquery name="GET_LANGUAGE_INFOS" datasource="#DSN#">
        SELECT
        	LANGUAGE,
            COLUMN_NAME,
            TABLE_NAME,
            ITEM,
            UNIQUE_COLUMN_ID
        FROM
            SETUP_LANGUAGE_INFO
        WHERE
            <cfif isdefined('session.pp')>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
            <cfelse>
                LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
            </cfif>
            (
            	(COLUMN_NAME = 'PRODUCT_NAME' AND TABLE_NAME = 'PRODUCT') OR
            	(COLUMN_NAME = 'USER_FRIENDLY_URL' AND TABLE_NAME = 'PRODUCT')
            )
    </cfquery>
</cfif>

<cfif get_related_product.recordcount>
	<cfset product_id_list = ''>
	<cfset all_product_id_list = ''>

    <div id="product_related" class="product_slider" style="display:flex;height:auto;margin-top:-30px;">         
        <cfoutput query="get_related_product">
            <div class="pr-md-2">
				<div class="product_slider_item" style="padding:0px;">
                    <cfif not listfindnocase(product_id_list,get_related_product.product_id)>
                        <cfset product_id_list = listappend(product_id_list,get_related_product.product_id,',')>
                    </cfif>
                    <cfif not listfindnocase(all_product_id_list,get_related_product.product_id)>
                        <cfset all_product_id_list = listappend(all_product_id_list,get_related_product.product_id,',')>
                    </cfif>
                    <cfif listlen(product_id_list)>
                        <cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
                            SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
                        </cfquery>
                        <cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.product_id,','),'numeric','ASC',',')>
                        <cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
                    </cfif>
                    <cfif isdefined('attributes.prod_relation_prod_price') and attributes.prod_relation_prod_price eq 1><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
                        <cfif isDefined("money")>
                            <cfset attributes.money = money>
                        </cfif>
                        <cfloop query="moneys">
                            <cfif moneys.money is attributes.money>
                                <cfset row_money = money >
                                <cfset row_money_rate1 = moneys.rate1>
                                <cfset row_money_rate2 = moneys.rate2>
                            </cfif>
                        </cfloop>
                        <cfset pro_price = price>
                        <cfset pro_price_kdv = price_kdv>
                        <cfif attributes.price_catid neq -2>
                            <cfquery name="GET_P" dbtype="query">
                                SELECT * FROM GET_PRICE_ALL WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_unit_id[currentrow]#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                            </cfquery>
                            <cfscript>
                                catalog_id_ = get_p.catalog_id;
                                if(get_p.recordcount and len(get_p.price)){
                                    musteri_pro_price = get_p.price; 
                                    musteri_pro_price_kdv = get_p.price_kdv; 
                                    musteri_row_money=get_p.money;
                                }
                                else{
                                    musteri_pro_price = pro_price;
                                    musteri_pro_price_kdv = pro_price_kdv;
                                    musteri_row_money=attributes.money;
                                } //musteriye ozel fiyat yoksa son kullanici gecerli
                            </cfscript>
                            <cfloop query="moneys">
                                <cfif moneys.money is musteri_row_money>
                                    <cfset musteri_row_money_rate1 = moneys.rate1>
                                    <cfset musteri_row_money_rate2 = moneys.rate2>
                                </cfif>
                            </cfloop>				
                            <cfscript>
                                if(musteri_row_money is default_money.money){
                                    musteri_str_other_money = musteri_row_money; 
                                    musteri_flt_other_money_value = musteri_pro_price;
                                    musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;	
                                    musteri_flag_prc_other = 0;
                                }
                                else{
                                    musteri_flag_prc_other = 1 ;{
                                        musteri_str_other_money = musteri_row_money; 
                                        musteri_flt_other_money_value = musteri_pro_price;
                                        musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;
                                    }
                                    musteri_pro_price = musteri_pro_price*(musteri_row_money_rate2/musteri_row_money_rate1);
                                }
                            </cfscript>
                        <cfelse>
                            <cfscript>
                                catalog_id_ = '';
                                musteri_flt_other_money_value = pro_price;
                                musteri_flt_other_money_value_kdv = pro_price_kdv;	
                                musteri_str_other_money = row_money;
                                musteri_row_money = row_money;
                                {
                                    musteri_flag_prc_other = 1;
                                    musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
                                    musteri_str_other_money = default_money.money;
                                }
                            </cfscript>
                        </cfif>
                    </cfif>
                    <cfif attributes.prod_relation_prod_image eq 1>
                        <div class="product_slider_item_img">
                            <cfif listfindnocase(product_id_list,product_id) and len(get_product_images.path)>
                                <img src="/documents/product/#get_product_images.path[listfind(product_id_list,product_id)]#" height="150px" width="150px" style="object-fit: contain;object-position: center;">
                            </cfif>
                        </div>
                    </cfif>
                    <div class="product_slider_item_text" style="padding:0px 4px;">
                        <cfif attributes.prod_relation_prod_name eq 1>
                            <div class="product_item_name">
                                <a href="#site_language_path#/ProductDetail/#product_id#/#stock_id#" title="#product_name# #property#">#product_name# #property#</a>
                            </div>
                        </cfif>
                        <div class="product_item_desc" style="-webkit-line-clamp:2!important;height:40px;">
                            <cfif attributes.prod_relation_prod_detail eq 1>
                                <p>#product_detail#</p>
                            <cfelseif attributes.prod_relation_prod_detail eq 2>
                                <p>#product_detail2#</p>
                            </cfif>
                        </div>
                        <div class="product_item_price">
                            <cfif isdefined('attributes.prod_relation_prod_price') and attributes.prod_relation_prod_price neq 0>
                                <cfif isdefined('session_base.userid') and isdefined("musteri_flt_other_money_value_kdv") and len(musteri_flt_other_money_value_kdv)>
                                    <cfif attributes.is_price_kdvsiz eq 1>
                                        #TLFormat(musteri_flt_other_money_value)# #musteri_row_money# + <cf_get_lang_main no='227.KDV'>
                                    <cfelse>
                                        #TLFormat(musteri_flt_other_money_value_kdv)# #musteri_row_money# / <cf_get_lang dictionary_id='34463.Including VAT'>
                                    </cfif>
                                <cfelse>
                                    <cfif attributes.prod_relation_prod_price eq 1>
                                        <cfif attributes.is_price_kdvsiz eq 1>
                                            #TLFormat(price)# #musteri_row_money# + <cf_get_lang_main no='227.KDV'>
                                        <cfelse>
                                            #TLFormat(price_kdv)# #musteri_row_money# / <cf_get_lang dictionary_id='34463.Including VAT'>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </div>
                        <div class="amount_detail font-weight-bold"><cfif isdefined("attributes.add_unit")>#add_unit#</cfif></div>
                        <cfif attributes.prod_relation_prod_price eq 1>
                            <cfif attributes.product_relation_sepet neq 0><!--- Xml sepetli hayırsa buraya girmesi gerekmez --->
                                <div class="product_item_basket" <cfif isdefined("attributes.product_alternative_position") and attributes.product_alternative_position eq 1>style="width:50%;margin:auto"</cfif>>
                                    <div class="product_item_basket_top">
                                        <span><i class="fa fa-minus"  onClick="document.getElementById('miktar_#currentrow#').value != 1 ? document.getElementById('miktar_#currentrow#').value-- : 1;"></i></span>
                                        <input type="text" id="miktar_#currentrow#" min="1" max="999" value="1" readonly/> 
                                        <span><i class="fa fa-plus"  onClick="document.getElementById('miktar_#currentrow#').value++;"></i></span>
                                        <div class="product_item_basket_bottom">
                                            <a href="javascript://" onclick="add_product(#stock_id#,document.getElementById('miktar_#currentrow#').value,#widget.id#);">
                                                <cfif attributes.product_relation_sepet eq 1><cf_get_lang dictionary_id='52116.Sepete Ekle'></cfif>
                                                <i class="fa fa-shopping-cart"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </cfif>
                        </cfif>
                    </div>
                </div>
            </div>
        </cfoutput>
    </div>

        <script type="text/javascript">
            $(function(){
                $('#product_related').slick({
                    infinite: false,
                    slidesToShow: <cfif isDefined('attributes.max_show_relation_prod_count') and isNumeric(attributes.max_show_relation_prod_count)><cfoutput>#attributes.max_show_relation_prod_count#</cfoutput><cfelse>2</cfif>,
                    slidesToScroll: 1,
                    dots:false,
                    speed: 700,
                    <cfif isdefined('attributes.prod_relation_prod_position') and attributes.prod_relation_prod_position eq 1>
                        vertical: true,
                        arrows:false,
                    </cfif>
                    responsive: 
                    [
                        {
                        breakpoint: 1315,
                        settings: {
                            slidesToShow: 2
                        }
                        },
                        {
                        breakpoint: 1020,
                        settings: {
                            slidesToShow: 2
                        }
                        },
                        {
                        breakpoint: 480,
                        settings: {
                            slidesToShow: 1,
                        }
                        }
                    ]
                });
            })
        </script>
<cfelse>
	<cfset widget_live = "die">
</cfif> 
<cfelse>
    <cfset GET_RELATED_PRODUCT = product_other.GET_RELATED_PRODUCT(pid : iif(isdefined("attributes.product_id"),'attributes.product_id','attributes.pid'), site : GET_PAGE.PROTEIN_SITE)>
    <cfif get_related_product.recordcount>
        <div class="description description-type2">
            <h6><cfoutput>#getLang('','',attributes.header_dic_id)#</cfoutput></h6>        
            <ul class="description_list-type2">
                <cfoutput query="get_related_product">           
                    <li>
                        <a href="#USER_FRIENDLY_URL#">                      
                            <cfif PIMAGEICON NEQ 0>           
                                <img src="/documents/product/#PIMAGEICON#"> 
                            <cfelseif len(PIMAGE)>
                                <img src="/documents/product/#PIMAGE#"> 
                            <cfelse>
                            </cfif> 
                            #PRODUCT_NAME#
                        </a>
                    </li>
                </cfoutput>
            </ul>
        </div>  
    <cfelse>
	    <cfset widget_live = "die">
    </cfif>
</cfif>


    