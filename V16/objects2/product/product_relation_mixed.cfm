<cfparam  name="attributes.header_dic_id" default="">
<cfset comp = createObject("component","V16.objects2.product.cfc.productOther") />
<cfset mixed_product = comp.GET_RELATED_MIXED_PRODUCT(
    pid : attributes.product_id,
    site: GET_PAGE.PROTEIN_SITE
)/>

<cfif mixed_product.recordCount>
    <div class="description description-type2">
        <h6><cfoutput>#getLang('','',attributes.header_dic_id)#</cfoutput></h6>        
        <ul class="description_list-type2">            
            <cfoutput query="mixed_product">            
                <li>
                    <a href="#site_language_path#/#USER_FRIENDLY_URL#">
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
</cfif>