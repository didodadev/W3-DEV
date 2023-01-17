<!---
    File: V16/purchase/display/purchase_dashboard.cfm
    Author: Workcube-Botan Kaygan <botankaygan@workcube.com>
    Date: 11.05.2020
    Controller: WBO/PurchaseDashboardController.cfm
    Description: -
--->
<cf_xml_page_edit fuseact="purchase.purchase_dashboard">

<script src="JS/Chart.min.js"></script>

<cf_catalystHeader>
<div class="col col-6 col-xs-12">
    <!--- Satınalma Siparişleri --->
    <cfif len(x_order_show_ids)>
        <cfset url_str_show_order_ids = "&order_show_ids=#x_order_show_ids#">
    <cfelse>
        <cfset url_str_show_order_ids = "">
    </cfif>
    <cfif len(x_order_hide_ids)>
        <cfset url_str_hide_order_ids = "&order_hide_ids=#x_order_hide_ids#">
    <cfelse>
        <cfset url_str_hide_order_ids = "">
    </cfif>
    <cfsavecontent variable="active_orders"><cf_get_lang dictionary_id="60884.Aktif Satınalma Siparişleri"></cfsavecontent>
    <cf_box id="box_active_orders" closable="0" collapsable="1" title="#active_orders#" uidrop="1" box_page="#request.self#?fuseaction=purchase.emptypopup_active_orders#url_str_show_order_ids##url_str_hide_order_ids#">
    </cf_box>

    <!--- Satınalma Teklifleri --->
    <cfif len(x_offer_show_ids)>
        <cfset url_str_show_offer_ids = "&offer_show_ids=#x_offer_show_ids#">
    <cfelse>
        <cfset url_str_show_offer_ids = "">
    </cfif>
    <cfif len(x_offer_hide_ids)>
        <cfset url_str_hide_offer_ids = "&offer_hide_ids=#x_offer_hide_ids#">
    <cfelse>
        <cfset url_str_hide_offer_ids = "">
    </cfif>
    <cfsavecontent variable="active_offers"><cf_get_lang dictionary_id="60883.Aktif Satınalma Teklifleri"></cfsavecontent>
    <cf_box id="box_active_offers" closable="0" collapsable="1" title="#active_offers#" uidrop="1" box_page="#request.self#?fuseaction=purchase.emptypopup_active_offers#url_str_show_offer_ids##url_str_hide_offer_ids#">
    </cf_box>

    <!--- Satınalma Talepleri --->
    <cfif len(x_demand_show_ids)>
        <cfset url_str_show_demand_ids = "&demand_show_ids=#x_demand_show_ids#">
    <cfelse>
        <cfset url_str_show_demand_ids = "">
    </cfif>
    <cfif len(x_demand_hide_ids)>
        <cfset url_str_hide_demand_ids = "&demand_hide_ids=#x_demand_hide_ids#">
    <cfelse>
        <cfset url_str_hide_demand_ids = "">
    </cfif>
    <cfsavecontent variable="active_demands"><cf_get_lang dictionary_id="60885.Aktif Satınalma Talepleri"></cfsavecontent>
    <cf_box id="box_active_demands" closable="0" collapsable="1" title="#active_demands#" uidrop="1" box_page="#request.self#?fuseaction=purchase.emptypopup_active_demands#url_str_show_demand_ids##url_str_hide_demand_ids#">
    </cf_box>

    <!--- Süper Özet --->
    <cfsavecontent variable="super_summary"><cf_get_lang dictionary_id="60898.Süper Özet"></cfsavecontent>
    <cf_box id="box_super_summary" closable="0" collapsable="1" title="#super_summary#" uidrop="1" box_page="#request.self#?fuseaction=purchase.emptypopup_purchase_super_summary">
    </cf_box>
</div>
<div class="col col-6 col-xs-12">
    <!--- Aylara Göre Satınalma Faaliyetleri --->
    <cfsavecontent variable="purchasing_activity"><cf_get_lang dictionary_id="60891.Aylara Göre Satınalma Faaliyeti"></cfsavecontent>
    <cf_box id="box_purchasing_activity" closable="0" collapsable="1" title="#purchasing_activity#" uidrop="1" box_page="#request.self#?fuseaction=purchase.emptypopup_purchasing_activity">
    </cf_box>

    <!--- En çok alınan mal ve hizmetler --->
    <cfsavecontent variable="top_purchased_products"><cf_get_lang dictionary_id="60896.En Çok Alınan Mal ve Hizmetler"></cfsavecontent>
    <cf_box id="box_top_purchased_products" closable="0" collapsable="1" title="#top_purchased_products#" uidrop="1" box_page="#request.self#?fuseaction=purchase.emptypopup_top_purchased_products">
    </cf_box>

    <!--- Aktif Teminatlar --->
    <cfsavecontent variable="active_securefund"><cf_get_lang dictionary_id="61197.Aktif Teminatlar"></cfsavecontent>
    <cf_box id="box_active_securefund" closable="0" collapsable="1" title="#active_securefund#" uidrop="1" box_page="#request.self#?fuseaction=purchase.emptypopup_active_securefund">
    </cf_box>

    <!--- Alımlarına Göre Tedarikçiler --->
    <cfsavecontent variable="suppliers"><cf_get_lang dictionary_id="60897.Alımlarına Göre Tedarikçiler"></cfsavecontent>
    <cf_box id="box_suppliers" closable="0" collapsable="1" title="#suppliers#" uidrop="1" box_page="#request.self#?fuseaction=purchase.emptypopup_top_suppliers">
    </cf_box>
</div>