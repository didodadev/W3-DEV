<cfsavecontent variable="title"><cf_get_lang dictionary_id="57205.Anlaşma-Aksiyon Koşullarına Uygunluk"></cfsavecontent>
    <cfif isnumeric(attributes.iid)>
        <cfinclude template="../query/get_sale_det.cfm">
        <cfscript>
            get_bill_action = createObject("component", "V16.invoice.cfc.get_bill");
            CHK_SEND_INV= get_bill_action.CHK_SEND_INV(iid:attributes.iid);
            CHK_SEND_ARC= get_bill_action.CHK_SEND_ARC(iid:attributes.iid);
            CONTROL_EARCHIVE= get_bill_action.CONTROL_EARCHIVE(iid:attributes.iid);
            CONTROL_EINVOICE= get_bill_action.CONTROL_EINVOICE(iid:attributes.iid);
        </cfscript>
    <cfelse>
        <cfset get_sale_det.recordcount = 0>
    </cfif>
    <cfif not get_sale_det.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    <cfelse>
    <cf_catalystHeader>
    <cfif not listfindnocase(denied_pages,'invoice.popup_get_contract_comparison')>
        <div class="col col-9 col-md-9 col-xs-12">
            <cf_box 
                title="#title#" 
                closable="0"
                box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_get_contract_comparison&iid=#url.iid#&type=1">
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