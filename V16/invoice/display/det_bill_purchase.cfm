<cfif isnumeric(attributes.iid)>
    <cfinclude template="../query/get_purchase_det.cfm">
<cfelse>
    <cfset get_sale_det.recordcount = 0>
</cfif>
<cfif not get_sale_det.recordcount>
    <cfset hata  = 11>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="57205.Anlaşma-Aksiyon Koşullarına Uygunluk"></cfsavecontent>
<cf_catalystHeader>
<cfif not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.popup_get_contract_comparison')>
    <div class="col col-9 col-md-9 col-xs-12">
        <cf_box 
            title="#title#" 
            closable="0"
            box_page="#request.self#?fuseaction=invoice.popup_get_contract_comparison&iid=#attributes.iid#&type=0">
        </cf_box>
    </div>
</cfif>
<cfif not listfindnocase(denied_pages,'objects.popup_list_pursuits_documents_plus')>
<div class="col col-3 col-md-3 col-xs-12">
    <cfset attributes.action_id = attributes.iid>
    <cfset attributes.pursuit_type = "is_sale_invoice">
    <cfinclude template="../../objects/display/list_pursuits_documents_plus.cfm">
</div>
</cfif>
</cfif>