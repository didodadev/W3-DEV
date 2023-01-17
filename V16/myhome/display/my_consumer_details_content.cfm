<cfinclude template="my_consumer_detail.cfm">
<!---<cfinclude template="my_consumer_address_detail.cfm">---><!--- Adresler --->

<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='31388.Adresler'></cfsavecontent>
    <cf_box 
        id="box_cons_addres_detail" 
        title="#title#"
        closable="0" 
        collapsed="1"
        box_page="#request.self#?fuseaction=myhome.my_consumer_address_detail&cid=#attributes.cid#">
    </cf_box>
</div>

<!--- notlar --->

<cfif (isdefined('note') and note eq 1) or not isdefined('note')>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='57422.Notlar'></cfsavecontent>
        <cf_box
            id="cons_notes"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_notes&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#request.self#?fuseaction=objects.popup_form_add_note&action=consumer_id&action_id=#attributes.cid#&is_special=0&action_type=0">
        </cf_box>
    </div>
</cfif>

<!--- Etkilesimler --->
<cfif (isdefined('etkilesim') and etkilesim eq 1) or not isdefined('etkilesim')>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58729.Etkileşimler'></cfsavecontent>
        <cf_box
            id="cons_helps"
            title="#title#"
            closable="0"		
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_helps&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#request.self#?fuseaction=call.helpdesk&event=add&consumer_id=#attributes.cid#&member_type=consumer">
        </cf_box>
    </div>
</cfif>

<!--- Kampanyalar --->
<cfif (isdefined('kampanya') and kampanya eq 1) or not isdefined('kampanya')>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31098.Kampanyalar'></cfsavecontent>
        <cf_box
            id="cons_campaings"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_sending_member_campaings&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#request.self#?fuseaction=campaign.list_campaign&event=add&cid=#attributes.cid#&member_type=consumer">
        </cf_box>
    </div>
</cfif>

<!--- Yazışmalar --->
<cfif (isdefined('yazisma') and yazisma eq 1) or not isdefined('yazisma')>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id ='57459.Yazışmalar'></cfsavecontent>
        <cf_box
            id="cons_correspondences"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_consumer_correspondence&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#request.self#?fuseaction=correspondence.add_correspondence&to_mail_id=#attributes.cid#&member_type=consumer">
        </cf_box>
    </div>
</cfif>

<!--- Eğitimler --->
<cfif (isdefined('eğitim') and eğitim eq 1) or not isdefined('eğitim')>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='29912.Eğitimler'></cfsavecontent>
        <cf_box
            id="cons_learnings"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_member_learnings&cid=#attributes.cid#&maxrows=#attributes.maxrows#">
        </cf_box>
    </div>
</cfif>

<!--- Eğitimler --->
<cfif (isdefined('etkinlik') and eğitim eq 1) or not isdefined('etkinlik')>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='46909.Etkinlikler'></cfsavecontent>
        <cf_box
            id="cons_organizations"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_member_organizations&cid=#attributes.cid#&maxrows=#attributes.maxrows#">
        </cf_box>
    </div>
</cfif>

<!--- Toplantılar- Ziyaretler --->
<cfif (isdefined('visit') and visit eq 1) or not isdefined('visit')>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(6)>
            <cfset addLink = "#request.self#?fuseaction=agenda.view_daily&event=add&consumer_id=#attributes.cid#">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31374.Toplantılar/Ziyaretler'></cfsavecontent>
        <cf_box
            id="cons_events"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_events&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!--- Fırsatlar --->
<cfif isdefined('firsat') and firsat eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(11)>
            <cfset addLink = "#request.self#?fuseaction=sales.list_opportunity&event=add&cpid=#attributes.cid#&member_id=#attributes.cid#&member_type=consumer">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58694.Fırsatlar'></cfsavecontent>
        <cf_box
            id="cons_opportunuties"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_opportunities&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!--- Teklifler --->
<cfif isdefined('teklif') and teklif eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfset infoLink = "">
    
        <cfif get_cons_info.consumer_status eq 1>
            <cfif get_module_user(11)>
                <cfset addLink = "#request.self#?fuseaction=sales.list_offer&event=add&member_type=consumer&consumer_id=#attributes.cid#">
            </cfif>
    
            <cfif get_module_user(12)>
                <cfset infoLink = "#request.self#?fuseaction=purchase.list_offer&event=add">
            </cfif>
        </cfif>
        
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31104.Teklifler'></cfsavecontent>
        <cf_box
            id="cons_offers"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_offers&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#"
            add_href_2="#infoLink#">
        </cf_box>
    </div>
</cfif>

<!--- Siparisler --->
<cfif isdefined('siparis') and siparis eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfset infoLink = "">
        <cfset box_page = "#request.self#?fuseaction=myhome.popupajax_my_company_orders&cid=#attributes.cid#&maxrows=#attributes.maxrows#">
    
        <cfif isDefined("is_fast_display") and is_fast_display eq 1>
            <cfset box_page = box_page & "&is_fast_display=1">
        </cfif>
    
        <cfif get_cons_info.consumer_status eq 1>
            <cfif get_module_user(11)>
                <cfset addLink = "#request.self#?fuseaction=sales.list_order&event=add&consumer_id=#attributes.cid#&company_id&partner_id&member_type=consumer">
            </cfif>
    
            <cfif get_module_user(12)>
                <cfset infoLink = "#request.self#?fuseaction=purchase.list_order&event=add&cpid=#attributes.cid#&member_id=#attributes.cid#&member_type=consumer">
            </cfif>
        </cfif>
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31106.Siparişler'></cfsavecontent>
        <cf_box
            id="cons_orders"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#box_page#"
            add_href="#addLink#"
            add_href_2="#infoLink#">
        </cf_box>
    </div>
</cfif>

<!--- Taksitli Satislar --->
<cfif isdefined('taksit') and taksit eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(11)>
            <cfset addLink = "#request.self#?fuseaction=sales.list_order_instalment&event=add&consumer_id=#attributes.cid#&company_id&partner_id&member_type=consumer">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58208.Taksitli Satışlar'></cfsavecontent>
        <cf_box
            id="cons_instalment_orders"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_is_instalment_orders&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!---Faturalar  --->
<cfif isdefined('is_invoice') and is_invoice eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfset infoLink = "">
        <cfset box_page = "#request.self#?fuseaction=myhome.popupajax_my_company_invoice&cid=#attributes.cid#&maxrows=#attributes.maxrows#">
    
        <cfif isdefined("is_fast_display") and is_fast_display eq 1>
            <cfset box_page = box_page & "&is_fast_display=1">
        </cfif>
    
        <cfif get_cons_info.consumer_status eq 1>
            <cfif get_module_user(20)>
                <cfset addLink = "#request.self#?fuseaction=invoice.form_add_bill&consumer_id=#attributes.cid#">
                <cfset infoLink = "#request.self#?fuseaction=invoice.form_add_bill_purchase&consumer_id=#attributes.cid#">
            </cfif>
        </cfif>
        
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58917.Faturalar'></cfsavecontent>
        <cf_box
            id="cons_invoices"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#box_page#"
            add_href="#addLink#"
            add_href_2="#infoLink#">
        </cf_box>
    </div>
</cfif>

<!---Servis Başvuruları  --->
<cfif isdefined('service') and service eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(14)>
            <cfset addLink = "#request.self#?fuseaction=service.list_service&event=add&cpid=#attributes.cid#&member_id=#attributes.cid#&member_type=consumer">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='30039.Servis Başvuruları'></cfsavecontent>
        <cf_box
            id="cons_services"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_service&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!--- Call Center Başvuruları --->
<cfif isdefined('call_center') and call_center eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(27)>
            <cfset addLink = "#request.self#?fuseaction=call.list_service&event=add&consumer_id=#attributes.cid#">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58468.Call Center Başvuruları'></cfsavecontent>
        <cf_box
            id="cons_call_services"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_call_service&cid=#attributes.cid#&maxrows=#attributes.maxrows#&is_call_detail=#is_call_detail#&is_call_subcat=#is_call_subcat#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!--- Sistemler --->
<cfif isdefined('system') and system eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(11)>
            <cfset addLink = "#request.self#?fuseaction=sales.list_subscription_contract&event=add&cpid=#attributes.cid#&consumer_id=#attributes.cid#&member_type=consumer">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58832.Aboneler'></cfsavecontent>
        <cf_box
            id="cons_systems"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_systems&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!--- Icra Takip --->
<cfif isdefined('takip') and takip eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(33)>
            <cfset addLink = "#request.self#?fuseaction=ch.list_law_request&event=add&consumer_id=#attributes.cid#&member_type=consumer">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31751.İcra Takip'></cfsavecontent>
        <cf_box
            id="cons_law_request"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_company_law_request&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!--- Projeler --->
<cfif isdefined('project') and project eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(12)>
            <cfset addLink = "#request.self#?fuseaction=project.projects&event=add&consumer_id=#attributes.cid#&member_id=#attributes.cid#&member_type=consumer">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='58015.Projeler'></cfsavecontent>
        <cf_box
            id="cons_projects"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_project_list&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!--- Referans Üyeler --->
<cfif isdefined('reference') and reference eq 1>
    <div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
        <cfset addLink = "">
        <cfif get_module_user(12)>
            <cfset addLink = "#request.self#?fuseaction=member.consumer_list&event=add">
        </cfif>
    
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='31909.Referans Üyeler'></cfsavecontent>
        <cf_box
            id="cons_ref_member"
            title="#title#"
            closable="0"
            unload_body="1"
            box_page="#request.self#?fuseaction=myhome.popupajax_my_consumer_ref_member&cid=#attributes.cid#&maxrows=#attributes.maxrows#"
            add_href="#addLink#">
        </cf_box>
    </div>
</cfif>

<!--- Odeme Performansı --->
<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='57802.Ödeme Performansı'></cfsavecontent>
    <cf_box
        id="cons_list_extre"
        title="#title#"
        closable="0"
        unload_body="1"
        box_page="#request.self#?fuseaction=myhome.emptypopup_dsp_make_age_manuel&is_ajax_popup&is_view=1&is_process_cat=1&consumer_id=#attributes.cid#">
    </cf_box>
</div>
<!--- Iade Talepleri --->
<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='31995.İade Talepleri'></cfsavecontent>
    <cf_box
        id="cons_return_demands"
        title="#title#"
        closable="0"
        unload_body="1"
        box_page="#request.self#?fuseaction=myhome.popupajax_my_consumer_return_demands&cid=#attributes.cid#&maxrows=#attributes.maxrows#">
    </cf_box>
</div>
<!--- Satis Takipleri --->
<div index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='31996.Satış Takipleri'></cfsavecontent>
    <cf_box
        id="cons_order_demands"
        title="#title#"
        closable="0"
        unload_body="1"
        box_page="#request.self#?fuseaction=myhome.popupajax_my_consumer_order_demands&cid=#attributes.cid#&maxrows=#attributes.maxrows#">
    </cf_box>
</div>
