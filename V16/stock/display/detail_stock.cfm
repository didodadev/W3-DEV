<cf_xml_page_edit fuseact="stock.detail_stock">
<cfscript>
	get_product_list_action = createObject("component", "V16.stock.cfc.get_product");
	get_product_list_action.dsn3 = dsn3;
	get_product = get_product_list_action.get_product_fnc2(
		pid : '#iif(isdefined("attributes.pid"),"attributes.pid",DE(""))#'
	);
</cfscript>
<cfset pageHead = "#getlang('main',754)#: #left(Replace(get_product.product_name,"'"," "),50)#">
<cf_catalystHeader>
<div class="row">
	<div class="col col-12 col-xs-12 uniqueRow">
        <div class="row">
            <cf_box title="#getLang('main',40)# #getLang('main',359)#" closable="0" collapsed="0">
                <div class="row" type="row">
                    <div class="col col-4 col-xs-12 " type="column" index="1" sort="true">
                        <cfinclude template="list_product_info.cfm">
                    </div>
                    <div class="col col-8 col-xs-12" type="column" index="2" sort="true">
                        <cfinclude template="../../objects/display/stock_status_info.cfm">
                    </div>
                </div>
            </cf_box>
            <div class="uniqueBox">
                <!--- stok stratejileri --->
                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58635.Stok Stratejileri'></cfsavecontent>
                <cf_box 
                    id="strategy_menu"
                    title="#message#"
                    closable="0"
                    box_page="#request.self#?fuseaction=stock.emptypopup_list_stock_strategy&pid=#pid#">
                </cf_box>
            </div>
            <div class="uniqueBox">
                <!--- stok depo detayları --->
                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='45567.Stok Detay'></cfsavecontent>
                <cf_box id="stock_detail_acc"
                        title="#message#"
                        box_page="#request.self#?fuseaction=stock.emptypopup_detail_stock_acc_to_unit&pid=#pid#&is_prod=#get_product.is_production#"
                        closable="0">
                </cf_box>
            </div>
            <cfif isdefined('is_show_alternative_prod_info') and is_show_alternative_prod_info eq 1><!--- alternatif ürün stok bilgileri gösterilsin --->
                <div class="row">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='45311.Alternatif Ürünler'></cfsavecontent>
                    <cf_box
                        title="#message#"
                        id="alternative_prod_acc"
                        box_page="#request.self#?fuseaction=stock.emptypopup_detail_stock_acc_to_unit&pid=#pid#&is_prod=#get_product.is_production#&show_alternative_prod=1"
                        closable="0">
                    </cf_box>
                </div>
            </cfif>
        </div>
    </div>

</div>



