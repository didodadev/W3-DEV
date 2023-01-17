<cf_xml_page_edit fuseact ="prod.add_product_tree" default_value="0">
<cfinclude template="../query/get_product_info.cfm">
<cfset getComponent = createObject('component','V16.production_plan.cfc.get_tree')>
<cfset GET_PRO_TREE_ID = getComponent.GET_PRO_TREE_ID(stock_id : attributes.stock_id)>
<cfset attributes.stock_main_id = attributes.stock_id>
<cfquery name="get_product_conf" datasource="#dsn3#">
	SELECT CONFIGURATOR_NAME,PRODUCT_CONFIGURATOR_ID FROM SETUP_PRODUCT_CONFIGURATOR WHERE CONFIGURATOR_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cfset PageHead = "#getlang('prod','Ürün Ağacı',36365)#: #get_product.stock_code#">
<cf_catalystHeader>
    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36632.İstasyon-Kapasite/Saat'></cfsavecontent>
            <cfif attributes.stock_id eq 0>
                <cfset add_buton_url = '&is_upd_workstation=1&operation_type_id=#get_operation_name.OPERATION_TYPE_ID#'>
                <cfset pageURL = '&operation_type_id=#get_operation_name.OPERATION_TYPE_ID#&is_show_station_detail=#is_show_station_detail#'>
                <cfif isdefined("attributes.main_stock_id")>
                        <cfset pageURL = '#pageURL#&main_stock_id=#attributes.main_stock_id#'>
                </cfif>
                <cfif isdefined("attributes.main_stock_id")>
                        <cfset add_buton_url = '#add_buton_url#&main_stock_id=#attributes.main_stock_id#'>
                </cfif>
            <cfelse>
                <cfset add_buton_url ='&main_stock_id=#attributes.stock_id#&is_add_workstation=1&stock_id=#attributes.stock_main_id#'>
                <cfset pageURL = '&stock_id=#attributes.stock_id#&is_show_station_detail=#is_show_station_detail#'>
            </cfif>
            <cf_box
                title="#message#"
                id="list_product_ws_"
                box_page="#request.self#?fuseaction=prod.emptypopup_list_product_ws_ajaxproduct#pageURL#"
                add_href="#request.self#?fuseaction=prod.popup_add_ws_product#add_buton_url#"
                closable="0"
                add_href_size="wwide1">
             </cf_box>

            <cfif len(GET_PRO_TREE_ID.PRODUCT_TREE_ID)>
                <cf_get_workcube_content action_type ='PRODUCT_TREE_ID' company_id='#session.ep.company_id#' action_type_id ='#GET_PRO_TREE_ID.PRODUCT_TREE_ID#' style='0' design='0'>
            </cfif>
            <!--- İş akış tasarımcısı --->
            <cfset action_section = "PRODUCT_TREE">
            <cfset relative_id = attributes.stock_id>
            <cfinclude template="../../process/display/list_designer.cfm"> 

            <!--- Kapatılmamış Siparişler --->

            <cfset attributes.spect_main_id = 0 >
            <cfset attributes.dept_loc_info = '' >
            <cfset attributes.dept_loc_info_stock = '' >
            <cfset attributes.is_calc_row_ = 1 >
            <cfset attributes.pid = attributes.product_id >
            <cfset attributes.sid = attributes.stock_id >
            <cfset attributes.CRTROW = 1>
            <cf_box>
            <cfinclude template="../../objects/display/ajax_order_stock_detail.cfm">
            </cf_box>

    </div>
    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
        <!---Images--->
		<cf_wrk_images pid="#attributes.product_id#" type="product" >
        <!---Notlar--->
        <cf_get_workcube_note action_section='PRODUCT_TREE' action_id='#attributes.stock_id#'>
        <!---Belgeler--->
        <cf_get_workcube_asset asset_cat_id="-3" module_id='35' action_section='PRODUCT_TREE' action_id='#attributes.stock_id#'>
    </div>