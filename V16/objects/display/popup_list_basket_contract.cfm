<cfsavecontent variable="message"><cf_get_lang dictionary_id='33034.Çalışma Koşulları'></cfsavecontent>
<div class="col col-12 col-xs-12">
    <cf_box title="#message#">
        <cfif isdefined("attributes.order_id")>
            <cfinclude template="basket_sales_contracts.cfm">
            <cfinclude template="basket_purchase_contracts.cfm"> 
        </cfif>
    </cf_box>
    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
        <!---<cfinclude template="../../contract/form/member_special_price_cat.cfm">--->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='60157.Çalışan Fiyat Listeleri'></cfsavecontent>
        <cf_box 
            closable="0"
            id="special_price"
            box_page="#request.self#?fuseaction=contract.list_member_special_price_cat&company_id=#attributes.company_id#"
            title="#message#">
        </cf_box>
        <!---<cfinclude template="../../contract/form/member_special_prices.cfm">--->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='50958.Özel Fiyatlar ve İskonto'></cfsavecontent>
        <cf_box 
            closable="0"
            id="price_cat"
            box_page="#request.self#?fuseaction=contract.list_member_special_prices&company_id=#attributes.company_id#"
            title="#message#">
        </cf_box>
        <!---<cfinclude template="../../contract/form/company_related_discount.cfm">--->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='50931.Genel İskontolar'></cfsavecontent>
        <cf_box 
            closable="0"
            id="related_discount"
            box_page="#request.self#?fuseaction=contract.list_company_related_discount&company_id=#attributes.company_id#"
            title="#message#">
        </cf_box>
    </cfif>
</div>

