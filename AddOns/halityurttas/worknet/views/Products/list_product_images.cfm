<cfinclude template="../../config.cfm">
<cfsetting showdebugoutput="no">
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.products.product")>
<cfset getProductImages = cmp.getProductImage(product_id:attributes.pid)>

<div class="col col-12 uniqueRow">
    <cfif getProductImages.recordcount>
        <cfoutput query="getProductImages">
            <div class="row" type="row">
                <div class="col col-10">
                    <a target="_blank" href="#file_web_path#product/#path#" class="tableyazi">#detail#</a>
                </div>
                <div class="col col-2 text-right">
                    <a href="javascript://" onClick="AjaxPageLoad('#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['upd-product-image']['fuseaction']#&pimageid=#product_image_id#&pid=#attributes.pid#','body_product_images',1,'Loading..')"><img src="/images/update_list.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                </div>
            </div>
        </cfoutput>
    <cfelse>
        <div class="row" type="row">
            <cf_get_lang_main no='72.Kayıt Yok'> !
        </div>
    </cfif>
</div>