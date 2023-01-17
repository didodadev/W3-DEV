<cfparam  name="attributes.is_slider" default="1">
<cfset comp = createObject("component","V16.objects2.product.cfc.data") />
<cfif isdefined("attributes.product_id")>
	<cfset product_cat = comp.GET_PRODUCT_CAT(
    product_category_id : attributes.product_category_id,
    product_id : attributes.product_id,
    max_product_num : attributes.max_product_num,
    site: GET_PAGE.PROTEIN_SITE
)/>
<cfelse>
    <cfset product_cat = comp.GET_PRODUCT_CAT(
    product_category_id : attributes.product_category_id,
    max_product_num : attributes.max_product_num,
    site: GET_PAGE.PROTEIN_SITE
)/>
</cfif>

<cfif product_cat.recordcount>
    <div class="product_slider row" style="display:flex">
        <cfoutput query="product_cat">
            <div class="col-md-4 col-12 mb-5">
                <div style="background-color:##e7f5ec;" class="product_slider_item">
                    <cfif isDefined("attributes.product_image") and attributes.product_image eq 1>
                        <div class="product_slider_item_img">
                            <img src="/documents/product/#path#" alt="">
                        </div>
                    <cfelseif isDefined("attributes.product_image") and attributes.product_image eq 2>
                        <div class="product_slider_item_img">
                            <img src="/documents/product/#PATH_ICON#" alt="">
                        </div>
                    </cfif>
                    <div class="product_slider_item_text">
                        <cfif isDefined("attributes.product_name") and attributes.product_name eq 1>
                            <h2 style="color:##21b251">#PRODUCT_NAME#</h2>
                        </cfif>
                        <cfif isDefined("attributes.product_detail") and attributes.product_detail eq 1>
                            <span>#PRODUCT_DETAIL#</span>
                        </cfif>
                        <cfif isDefined('attributes.product_detail_btn') and attributes.product_detail_btn eq 1>
                            <a style="background-color:##21b251;" href="#USER_FRIENDLY_URL#"><cf_get_lang dictionary_id='64219.Daha Fazla Bilgi'></a>
                        </cfif>
                    </div>
                </div>
            </div>
        </cfoutput>
    </div>
    <cfif attributes.is_slider EQ 1>
        <script>
            $(function(){
                $('.product_slider').slick({
                    slidesToShow: 3,
                    slidesToScroll: 1,
                    dots:false,
                    speed: 700,
                    responsive: 
                    [
                        {
                        breakpoint: 821, //820px breakpoint for iPad Air tablet
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
    </cfif>
<cfelse>
    <cfset widget_live = "die">
</cfif>

