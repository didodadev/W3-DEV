<cf_catalystHeader>
<cfset cmp = createObject("component","V16.worknet.cfc.worknet")>
<cfset get_catalog = cmp.get_catalog(catalog_id : attributes.id)>

<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
    <cf_box title="#getLang('','özet',58052)#">
        <div class="ui-info-text">  
            <cfoutput query="get_catalog">
                <h1>#catalog_head#</h1>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12 pl-0">
                    <p><span class="bold"><cf_get_lang dictionary_id='42408.Katalog No'></span>: #catalog_no#</p>
                    <p><span class="bold"><cf_get_lang dictionary_id='63171.Friendly'></span>: #friendly_url#</p>
                    <p><span class="bold"><cf_get_lang dictionary_id='29533.Tedarikçi'></span>: #fullname#</p>
                    <p><span class="bold"><cf_get_lang dictionary_id='29775.Hazırlayan'></span>: #name#</p>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12 pl-0">
                    <p><span class="bold"><cf_get_lang dictionary_id='58859.Süreç'></span>: #stage#</p>
                    <p><span class="bold"><cf_get_lang dictionary_id='58053.Başlangıç tarihi'></span>: #Dateformat(startdate,dateformat_style)#</p>
                    <p><span class="bold"><cf_get_lang dictionary_id='57700.bitiş tarihi'></span>: #Dateformat(finishdate,dateformat_style)#</p>
                    <p><span class="bold"><cf_get_lang dictionary_id='57446.Kampanya'></span>: #camp_head#</p>
                </div>
            </cfoutput>        
        </div>
    </cf_box>
    <cf_box 
        title="#getLang('','İlişkili Ürünler',37101)#"
        add_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_products_only&catalog_id=#attributes.id#&product_id=add_product_relation.related_product_id&field_name=add_product_relation.product_name&is_related_catalogs=1');"
        widget_load="catalogProducts&id=#attributes.id#" 
        id="list_related_products"
        closable="0">
    </cf_box>
</div>
<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
    <cf_box title="#getLang('','İlişkili promosyonlar',49331)#" widget_load="relatedPromotions&catalog_id=#attributes.id#"></cf_box>
    <cf_box title="#getLang('','İlişkili aksiyonlar',49235)#" widget_load="relatedActions&catalog_id=#attributes.id#"></cf_box>
</div>