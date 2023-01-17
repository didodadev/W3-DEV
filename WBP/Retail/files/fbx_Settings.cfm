<cfset b2b_screens = "retail.list_order,retail.purchase_sale_report,retail.popup_product_stocks,retail.list_manage_products">
<cfset b2b_screens = listappend(b2b_screens,'retail.speed_manage_product_new')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popupflush_add_speed_manage_product_new')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_old_prices')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_form_add_order_new')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_print_speed_manage_product')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_get_table_object')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_get_new_layout_system')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_print_siparis')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_print_speed_manage_product')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_calc_price_window')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_detail_rival_prices')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_detail_product_cost')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_detail_product_price')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_detail_product_others')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_seller_limit_table')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_get_short_cuts')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_product_stocks_pre')>
<cfset b2b_screens = listappend(b2b_screens,'retail.popup_product_stocks')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_detail_product_price')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_detail_product_price_inner')>
<cfset b2b_screens = listappend(b2b_screens,'retail.emptypopup_get_company_orders')>
<cfif isdefined("session.ep.user_level") and not listgetat(session.ep.user_level,39)>
	<cfsavecontent variable="session.error_text">
	<cf_get_lang_main no='491.Kuruma Özel Modül'>
	<cfoutput>&nbsp;</cfoutput><cf_get_lang_main no='127.module_error'></cfsavecontent>
	<cflocation url="#request.self#?fuseaction=home.welcome" addtoken="No">
	<cfabort>
</cfif>
<cfset denied_list = "">
<cf_denied_control denied_page='#denied_list#'>

<cfset page_list = "">
<cf_page_control page_list='#page_list#' page_control_type="0">
<cf_get_lang_set>
<cfparam name="attributes.fuseaction" default="retail.welcome">
<cfparam name="request.self" default="index.cfm">
<cfset fusebox.layoutdir="">
<cfset fusebox.layoutfile="">
<cfsetting showdebugoutput="yes">
<cfinclude template="fbx_workcube_funcs.cfm">