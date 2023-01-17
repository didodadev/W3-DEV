<cfset productData = createObject("component","cfc.data")>
<cfset get_simple_product = productData.GET_SIMPLE_PRODUCT(
    is_product_cat_id :attributes.is_product_cat_id,
    site:GET_PAGE.PROTEIN_SITE)>
<cfif isdefined("attributes.simple_product_maxrow") and isnumeric(attributes.simple_product_maxrow)>
	<cfset max_ = attributes.simple_product_maxrow>
<cfelse>
	<cfset max_ = 20>
</cfif>
<div class="col-md-12 col-sm-12 col-xs-12">
    <div class="product_naming_list">
        <div class="product_naming_list_title">
            Best Practise Uygulamalar
        </div>
        <ul class="product_naming_list_item">
            <cfif  get_simple_product.recordcount>
                <cfoutput query="get_simple_product" maxrows="#max_#">
                    <li>
                        <a href="#USER_FRIENDLY_URL#" title="#product_name#">#product_name# <!--- <span>yeni</span> ---></a>
                    </li>
                </cfoutput>
            </cfif>
        </ul>
    </div>
</div>	



