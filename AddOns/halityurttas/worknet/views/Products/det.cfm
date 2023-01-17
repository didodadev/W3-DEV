<cfinclude template="../../config.cfm">
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.products.product")>
<cfset getProduct = cmp.getProduct(product_id:attributes.pid)>

<cfif not getProduct.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1230.Urun Kaydı Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../../../dsp_hata.cfm">
</cfif>

<cfsavecontent variable="pageHead">
    <cfif attributes.event eq "det">
        <cf_get_lang_main no ='245.Ürün'>
    <cfelse>
        <cf_get_lang no='154.Katalog'>
    </cfif>: <cfoutput>#getProduct.product_name#</cfoutput>
</cfsavecontent>
<cf_catalystHeader>

<div class="row">
    <div class="col col-9 col-xs-12 uniqueRow" id="content">
        <cfinclude template="_det_content.cfm">
    </div>
    <div class="col col-3 col-xs-12 uniqueRow" id="right">
        <cfinclude template="_det_right.cfm">
    </div>
</div>