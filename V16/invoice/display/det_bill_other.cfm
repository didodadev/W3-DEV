<!---
    File: det_bill_other.cfm
    Controller: InvoiceStopageController.cfm
    Folder: invoice\display\det_bill_other.cfm
    Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
    Date: 2020/03/25 15:18:00
    Description:Stopajlı Alış Faturaları detay sayfasıdır(anlaşmaya uygunluk,takip,belgeler ve değerlendirme formları içerir)   
    History:      
    To Do:
--->
<cfsavecontent variable="title"><cf_get_lang dictionary_id="57205.Anlaşma-Aksiyon Koşullarına Uygunluk"></cfsavecontent>
    <cf_catalystHeader> 
    <div class="col col-9 col-md-9 col-xs-12">
        <cfif not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.popup_get_contract_comparison')>
            <cf_box 
                title="#title#" 
                closable="0"
                box_page="#request.self#?fuseaction=invoice.popup_get_contract_comparison&iid=#attributes.iid#&type=0">
            </cf_box>
        </cfif>
        <cfif not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders')>
            <cf_box 
                title="#getlang(dictionary_id:38506)#"
                closable="0"
                box_page="#request.self#?fuseaction=invoice.popup_list_invoice_orders&invoice_id=#attributes.iid#">
            </cf_box>  
        </cfif>  
    </div>
    <cfif not listfindnocase(denied_pages,'objects.popup_list_pursuits_documents_plus')>
    <div class="col col-3 col-md-3 col-xs-12">
        <cfset attributes.action_id = attributes.iid>
        <cfset attributes.pursuit_type = "is_sale_invoice">
        <cfinclude template="../../objects/display/list_pursuits_documents_plus.cfm">
    </div>
    </cfif>
