<cfset fuseact_control = replace(fusebox.fuseaction,'autoexcelpopuppage_','','all')>
<cfswitch expression = "#fuseact_control#">
	<cfcase value="welcome,emptypopup_welcome">
    	<cfinclude template="display/welcome.cfm">
    </cfcase>
    <cfcase value="upd_consumer">
    	<cfinclude template="../member/query/upd_consumer.cfm">
    </cfcase>
     <cfcase value="emptypopup_del_consumer">
    	<cfinclude template="../add_options/query/delete_consumer_extra.cfm">
    </cfcase>
  <cfcase value="emptypopup_calc_date">
    	<cfinclude template="form/calc_date.cfm">
    </cfcase>
    <cfcase value="popup_change_card_member">
    	<cfinclude template="form/change_card_member.cfm">
    </cfcase>
    <cfcase value="emptypopup_change_card_member">
    	<cfinclude template="query/change_card_member.cfm">
    </cfcase>
    <cfcase value="popup_add_bonus">
    	<cfinclude template="form/add_bonus.cfm">
    </cfcase>
    <cfcase value="emptypopup_add_bonus">
    	<cfinclude template="query/add_bonus.cfm">
    </cfcase>
    <cfcase value="popup_list_cons">
    	<cfinclude template="display/popup_consumer_list.cfm">
    </cfcase>
    <cfcase value="list_manage_products">
    	<cfinclude template="display/list_manage_products.cfm">
    </cfcase>
    <cfcase value="add_cards">
    	<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="query/add_cards.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
    <cfcase value="detail_consumer">
    	<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
	<cfset folder_ = "/extra/display/">
    	<cfinclude template="form/form_upd_consumer.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
    <cfcase value="form_add_cards">
    	<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="form/form_add_cards.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
    <cfcase value="add_multi_cards">
    	<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="query/add_multi_cards.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
    <cfcase value="form_add_multi_cards">
    	<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="form/form_add_multi_cards.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
    <cfcase value="consumer_list">
    	<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_consumer.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
    <cfcase value="list_consumer_bonus">
    	<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_consumer_bonus.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
    <cfcase value="card_actions">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
		<cfinclude template="display/card_actions.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
    <cfcase value="speed_manage_product">
    	<cfinclude template="form/speed_manage_product.cfm">
    </cfcase>
	<cfcase value="speed_manage_product_new">
    	<cfinclude template="form/speed_manage_product_new.cfm">
    </cfcase>
   <cfcase value="del_speed_manage_product">
    	<cfinclude template="query/del_speed_manage_product.cfm">
    </cfcase>
    <cfcase value="emptypopup_get_search_list_ids">
    	<cfinclude template="form/get_search_list_ids.cfm">
    </cfcase>
    <cfcase value="emptypopup_get_list_save_screen">
    	<cfinclude template="form/get_list_save_screen.cfm">
    </cfcase>
    <cfcase value="emptypopup_add_list_save_screen">
    	<cfinclude template="query/add_list_save_screen.cfm">
    </cfcase>
    <cfcase value="emptypopup_add_speed_manage_product,emptypopupflush_add_speed_manage_product,popupflush_add_speed_manage_product">
    	<cfinclude template="query/add_speed_manage_product.cfm">
    </cfcase>
    <cfcase value="popupflush_add_speed_manage_product_new,emptypopup_add_speed_manage_product_new,emptypopupflush_add_speed_manage_product_new">
    	<cfinclude template="query/add_speed_manage_product_new.cfm">
    </cfcase>
    <cfcase value="popup_add_row_to_speed_manage_product">
    	<cfinclude template="form/add_row_to_speed_manage_product.cfm">
    </cfcase>
    <cfcase value="emptypopup_add_row_to_speed_manage_product,popup_add_row_to_speed_manage_product_in">
    	<cfinclude template="form/add_row_to_speed_manage_product_inner.cfm">
    </cfcase>
    <cfcase value="emptypopup_add_product_row_last">
    	<cfinclude template="form/add_product_row_last.cfm">
    </cfcase>
    <cfcase value="popup_detail_rival_prices">
    	<cfinclude template="display/detail_rival_prices.cfm">
    </cfcase>
    <cfcase value="form_add_order">
    	<cfinclude template="form/add_order.cfm">
	<!--- <cfinclude template="query/add_speed_manage_product.cfm"> --->
    </cfcase>
    <cfcase value="popup_form_add_order2">
    	<cfinclude template="form/add_order2.cfm">
    </cfcase>
    <cfcase value="emptypopup_form_add_order_new">
    	<cfinclude template="form/add_order_new.cfm">
    </cfcase>
    <cfcase value="form_add_ship">
    	<cfinclude template="form/add_ship.cfm">
    </cfcase>
    <cfcase value="form_add_rival_price">
    	<cfinclude template="form/form_add_rival_price.cfm">
    </cfcase>
    <cfcase value="add_rival_price">
    	<cfinclude template="query/add_rival_price.cfm">
    </cfcase>
    <cfcase value="popup_detail_product_price,emptypopup_detail_product_price">
    	<cfinclude template="display/detail_product_price.cfm">
    </cfcase>
<cfcase value="popup_detail_product_price_inner,emptypopup_detail_product_price_inner">
    	<cfinclude template="display/detail_product_price_inner.cfm">
    </cfcase>
    <cfcase value="popup_detail_product_price_group">
    	<cfinclude template="display/detail_product_price_group.cfm">
    </cfcase>
<cfcase value="popup_detail_product_cost">
    	<cfinclude template="display/detail_product_cost.cfm">
    </cfcase>

<cfcase value="emptypopup_detail_product_others">
    	<cfinclude template="display/detail_product_others.cfm">
    </cfcase>

    <cfcase value="popup_old_prices">
    	<cfinclude template="display/old_prices.cfm">
    </cfcase>
    <cfcase value="popup_calc_price_window">
    	<cfinclude template="form/calc_price_window.cfm">
    </cfcase>
    
    <cfcase value="popup_connect_product">
    	<cfinclude template="form/connect_product.cfm">
    </cfcase>
    
    <cfcase value="popup_calc_stock_window">
    	<cfinclude template="form/calc_stock_window.cfm">
    </cfcase>
   <cfcase value="pos">
    	<cfinclude template="display/pos_welcome.cfm">
    </cfcase>
    
   <cfcase value="emptypopupflush_import_sales_cards">
    	<cfinclude template="query/import_sales_cards.cfm">
    </cfcase>
    
    <!---
    <cfcase value="duzenleme">
    	<cfinclude template="display/duzenleme.cfm">
    </cfcase>
	--->
	
	<!--- yazar kasa pos işlemleri --->
    <cfcase value="list_sales_import">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_sales_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_sales_import.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="list_stock_export">
		
    	<cfinclude template="display/list_stock_export.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="list_stock_import">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_sales_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_stock_import.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="list_price_change_genius">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_sales_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_price_change_genius.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="list_price_change_import">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_sales_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_price_change_import.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="list_acnielsen">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_sales_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_acnielsen.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="list_export_promotion">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_sales_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_export_promotion.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	
	<!--- Sayım İşlemleri --->
	<cfcase value="pos_count_welcome">
    		<cfinclude template="display/pos_count_welcome.cfm">
   	</cfcase>
	<cfcase value="emptypopup_del_stock_count">
    	<cfinclude template="query/del_stock_count.cfm">
    </cfcase>
	<cfcase value="popup_add_del_fileimports_total">
    	<cfinclude template="form/add_del_fileimports_total.cfm">
    </cfcase>
	<cfcase value="emptypopup_add_del_fileimports_total">
    	<cfinclude template="query/add_del_fileimports_total.cfm">
    </cfcase>
	<cfcase value="popup_add_del_fileimports_total_all">
    	<cfinclude template="form/add_del_fileimports_total_all.cfm">
    </cfcase>
	<cfcase value="emptypopup_add_del_fileimports_total_all">
    	<cfinclude template="query/add_del_fileimports_total_all.cfm">
    </cfcase>
	<cfcase value="list_file_compare,emptypopup_list_file_compare">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_file_compare.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="list_sayimlar">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_sayimlar.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="list_sayimlar_all">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_sayimlar_all.cfm">
        <cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="emptypopup_add_total_stock_fis">
    	<cfinclude template="query/add_total_stock_fis.cfm">
    </cfcase>
    <cfcase value="emptypopup_del_file_imports_total">
    	<cfinclude template="query/del_file_imports_total.cfm">
    </cfcase> 
	<cfcase value="emptypopup_del_file_imports">
    	<cfinclude template="query/del_file_imports.cfm">
    </cfcase>
	<cfcase value="list_fileimports_total_sayim">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_fileimports_total_sayim.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="emptypopup_file_import_total_initialize">
    	<cfinclude template="query/file_import_total_initialize.cfm">
    </cfcase>
	<cfcase value="emptypopup_del_total_sayim">
    	<cfinclude template="query/del_total_sayim.cfm">
    </cfcase>
	<cfcase value="list_fileimports_report,emptypopup_list_fileimports_report">
		<cfquery name="get_fuseactions" datasource="#dsn#">
        	SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        </cfquery>
		<cfset folder_ = "/extra/display/">
    	<cfinclude template="display/list_fileimports_report.cfm">
		<cfset get_fuseactions.recordcount = 0>
    </cfcase>
	<cfcase value="popup_form_import_stock_count">
    	<cfinclude template="form/import_stock_count.cfm">
    </cfcase>
	<cfcase value="popup_add_import_stock_count_display">
    	<cfinclude template="query/import_stock_count_display.cfm">
    </cfcase>
	<!--- Tanımlar --->
    <cfcase value="definitions">
    	<cfinclude template="display/definitions.cfm">
    </cfcase>
    <cfcase value="price_types">
    	<cfinclude template="display/price_types.cfm">
    </cfcase>
<cfcase value="label_types">
    	<cfinclude template="display/label_types.cfm">
    </cfcase>

<cfcase value="banknote_types">
    	<cfinclude template="display/banknote_types.cfm">
    </cfcase>	
<cfcase value="rival_price_types">
    	<cfinclude template="display/rival_price_types.cfm">
    </cfcase>
<cfcase value="card_types">
    	<cfinclude template="display/card_types.cfm">
    </cfcase>
    <cfcase value="emptypopup_combine_table_codes">
    	<cfinclude template="query/combine_table_codes.cfm">
    </cfcase>
    
    <cfcase value="emptypopup_save_layout">
    	<cfinclude template="form/save_layout.cfm">
    </cfcase>
    
    <cfcase value="emptypopup_save_layout_action">
    	<cfinclude template="query/save_layout_action.cfm">
    </cfcase>
    
    <cfcase value="popup_print_layout">
    	<cfinclude template="display/print_layout.cfm">
    </cfcase>
    
    <cfcase value="popup_product_stocks">
    	<cfinclude template="display/product_stocks.cfm">
    </cfcase>
    
    <cfcase value="popup_product_stocks_pre">
    	<cfinclude template="display/product_stocks_pre.cfm">
    </cfcase>
    
    <cfcase value="popup_form_add_pos">
    	<cfinclude template="form/add_pos.cfm">
    </cfcase>
    
    <cfcase value="popup_form_upd_pos">
    	<cfinclude template="form/upd_pos.cfm">
    </cfcase>

    <cfcase value="popup_form_add_pos_user">
    	<cfinclude template="form/add_pos_user.cfm">
    </cfcase>

<cfcase value="emptypopup_add_pos_user">
    	<cfinclude template="query/add_pos_user.cfm">
    </cfcase>

    <cfcase value="popup_form_upd_pos_user">
    	<cfinclude template="form/upd_pos_user.cfm">
    </cfcase>

<cfcase value="emptypopup_upd_pos_user">
    	<cfinclude template="query/upd_pos_user.cfm">
    </cfcase>


<cfcase value="emptypopup_del_pos_user">
    	<cfinclude template="query/del_pos_user.cfm">
    </cfcase>
   
    <cfcase value="list_pos_equipment">
    	<cfinclude template="display/list_pos_equipment.cfm">
    </cfcase>

 <cfcase value="list_department_extra_info">
    	<cfinclude template="display/list_department_extra_info.cfm">
    </cfcase>

 <cfcase value="emptypopup_add_dept_extra_info">
    	<cfinclude template="query/add_dept_extra_info.cfm">
    </cfcase>

	<cfcase value="list_pos_users">
    	<cfinclude template="display/list_pos_users.cfm">
    </cfcase>
	
    
    <cfcase value="emptypopup_add_pos">
    	<cfinclude template="query/add_pos.cfm">
    </cfcase>
    
    <cfcase value="emptypopup_upd_pos">
    	<cfinclude template="query/upd_pos.cfm">
    </cfcase>
    
    <cfcase value="emptypopup_del_pos">
    	<cfinclude template="query/del_pos.cfm">
    </cfcase>  

	<cfcase value="list_rival_price">
    	<cfinclude template="display/list_rival_prices.cfm">
    </cfcase> 

<cfcase value="popup_select_rival_products">
    	<cfinclude template="display/select_rival_products.cfm">
    </cfcase>
<cfcase value="popup_product_names">
    	<cfinclude template="display/popup_product_names.cfm">
    </cfcase>
<cfcase value="emptypopup_product_names">
    	<cfinclude template="display/popup_product_names_inner.cfm">
    </cfcase>
<cfcase value="emptypopup_select_rival_products">
    	<cfinclude template="display/select_rival_products_inner.cfm">
    </cfcase> 
     <cfcase value="extra_product_types">
    	<cfinclude template="display/extra_product_types.cfm">
    </cfcase>

    <cfcase value="extra_product_types_subs">
    	<cfinclude template="display/extra_product_types_subs.cfm">
    </cfcase>
    
    <cfcase value="popup_add_extra_product_types_subs">
    	<cfinclude template="form/add_extra_product_types_subs.cfm">
    </cfcase>
    <cfcase value="emptypopup_add_extra_product_types_subs">
    	<cfinclude template="query/add_extra_product_types_subs.cfm">
    </cfcase>
    
	<cfcase value="popup_upd_extra_product_types_subs">
    	<cfinclude template="form/upd_extra_product_types_subs.cfm">
    </cfcase>
    <cfcase value="emptypopup_upd_extra_product_types_subs">
    	<cfinclude template="query/upd_extra_product_types_subs.cfm">
    </cfcase>
    <cfcase value="emptypopup_del_extra_product_types_subs">
    	<cfinclude template="query/del_extra_product_types_subs.cfm">
    </cfcase>


 <cfcase value="table_process_types">
    	<cfinclude template="display/table_process_types.cfm">
    </cfcase>

  <cfcase value="genius_general">
    	<cfinclude template="display/genius_general.cfm">
    </cfcase>
  <cfcase value="emptypopup_genius_general">
    	<cfinclude template="query/genius_general.cfm">
    </cfcase>

  <cfcase value="popup_form_export_stock">
    	<cfinclude template="form/export_stock.cfm">
    </cfcase>
<cfcase value="popupflush_export_stock,popup_export_stock">
    	<cfinclude template="query/export_stock.cfm">
    </cfcase>

<cfcase value="popup_control_file">
	<cfinclude template="query/control_file.cfm">
</cfcase>

<cfcase value="list_pos_pay_methods">
    	<cfinclude template="display/list_pos_pay_methods.cfm">
    </cfcase>

<cfcase value="popup_add_pos_pay_method">
    	<cfinclude template="form/add_pos_pay_method.cfm">
    </cfcase>
<cfcase value="emptypopup_add_pos_pay_method">
    	<cfinclude template="query/add_pos_pay_method.cfm">
    </cfcase>
<cfcase value="popup_upd_pos_pay_method">
    	<cfinclude template="form/upd_pos_pay_method.cfm">
    </cfcase>
<cfcase value="emptypopup_upd_pos_pay_method">
    	<cfinclude template="query/upd_pos_pay_method.cfm">
    </cfcase>
<cfcase value="popup_copy_pos_pay_method">
    	<cfinclude template="form/copy_pos_pay_method.cfm">
    </cfcase>
<cfcase value="emptypopup_del_pos_pay_method">
    	<cfinclude template="query/del_pos_pay_method.cfm">
    </cfcase>

<cfcase value="popup_make_process_action">
    	<cfinclude template="form/make_process_action.cfm">
    </cfcase>
<cfcase value="emptypopup_make_process_action">
    	<cfinclude template="query/make_process_action.cfm">
    </cfcase>

<cfcase value="popup_upd_make_process_action">
    	<cfinclude template="form/upd_make_process_action.cfm">
    </cfcase>
<cfcase value="emptypopup_upd_make_process_action">
    	<cfinclude template="query/upd_make_process_action.cfm">
    </cfcase>
<cfcase value="emptypopup_del_make_process_action">
    	<cfinclude template="query/del_make_process_action.cfm">
    </cfcase>

<cfcase value="popup_print_process_action">
    	<cfinclude template="form/print_process_action.cfm">
    </cfcase>

<cfcase value="popup_seller_limit_table,emptypopup_seller_limit_table">
    	<cfinclude template="display/seller_limit_table.cfm">
    </cfcase>


    <cfcase value="list_etiket">
    	<cfinclude template="display/list_etiket.cfm">
    </cfcase>

   <cfcase value="list_etiket_grid">
    	<cfinclude template="display/list_etiket_grid.cfm">
    </cfcase>
    
    <cfcase value="popup_print_etiket">
    	<cfinclude template="display/print_etiket.cfm">
    </cfcase>

<cfcase value="popup_export_terazi">
    <cfinclude template="display/popup_export_terazi.cfm">
</cfcase>

<cfcase value="emptypopup_export_terazi">
    <cfinclude template="query/popup_export_terazi.cfm">
</cfcase>

<cfcase value="popup_add_row_to_speed_manage_product_excel">
    <cfinclude template="form/add_row_to_speed_manage_product_excel.cfm">
</cfcase>

<cfcase value="waiting_orders">
    <cfinclude template="display/waiting_orders.cfm">
</cfcase>

<cfcase value="list_price_changes">
    <cfinclude template="display/list_price_changes.cfm">
</cfcase>


<cfcase value="popup_select_tickets">
    <cfinclude template="display/select_tickets.cfm">
</cfcase>

<cfcase value="emptypopup_del_price">
    <cfinclude template="query/del_price.cfm">
</cfcase>


<cfcase value="popup_send_price_group">
    <cfinclude template="query/send_price_group.cfm">
</cfcase>

<cfcase value="popup_change_drag_table">
    <cfinclude template="form/change_drag_table.cfm">
</cfcase>

<cfcase value="popup_upd_price">
    <cfinclude template="form/upd_price.cfm">
</cfcase>

<cfcase value="emptypopup_upd_price">
    <cfinclude template="query/upd_price.cfm">
</cfcase>

<cfcase value="report">
    <cfinclude template="report/report_welcome.cfm">
</cfcase>

<cfcase value="purchase_consignment_report">
    <cfinclude template="report/purchase_consignment_report.cfm">
</cfcase>

<cfcase value="purchase_sale_report_period">
    <cfinclude template="report/purchase_sale_report_period.cfm">
</cfcase>

<cfcase value="purchase_sale_report">
    <cfinclude template="report/purchase_sale_report.cfm">
</cfcase>

<cfcase value="purchase_sale_report_datagrid">
    <cfinclude template="report/purchase_sale_report_datagrid.cfm">
</cfcase>

<cfcase value="purchase_sale_company_report">
    <cfinclude template="report/purchase_sale_company_report.cfm">
</cfcase>

<cfcase value="popup_purchase_sale_report_datagrid">
    <cfinclude template="report/print_purchase_sale_report_datagrid.cfm">
</cfcase>


<cfcase value="purchase_to_date_report">
    <cfinclude template="report/purchase_to_date_report.cfm">
</cfcase>
<cfcase value="sayım_raporu">
    <cfinclude template="report/sayım_raporu.cfm">
</cfcase>

<cfcase value="depo_stock_report">
    <cfinclude template="report/depo_stock_report.cfm">
</cfcase>

<cfcase value="depo_stock_report_upper">
    <cfinclude template="report/depo_stock_report_upper.cfm">
</cfcase>

<cfcase value="odeme_report">
    <cfinclude template="report/odeme_report.cfm">
</cfcase>

<cfcase value="depo_stock_product_report">
    <cfinclude template="report/depo_stock_product_report.cfm">
</cfcase>

<cfcase value="depo_order_report">
    <cfinclude template="report/depo_order_report.cfm">
</cfcase>

<cfcase value="depo_all_stock_report">
    <cfinclude template="report/depo_all_stock_report.cfm">
</cfcase>

<cfcase value="depo_all_stock_report2">
    <cfinclude template="report/depo_all_stock_report2.cfm">
</cfcase>
<cfcase value="depo_all_stock_report3">
    <cfinclude template="report/depo_all_stock_report3.cfm">
</cfcase>
<cfcase value="depo_all_stock_report4">
    <cfinclude template="report/depo_all_stock_report4.cfm">
</cfcase>
<cfcase value="depo_all_stock_report5">
    <cfinclude template="report/depo_all_stock_report5.cfm">
</cfcase>

<cfcase value="depo_new_stock_report">
    <cfinclude template="report/depo_new_stock_report.cfm">
</cfcase>

<cfcase value="price_report">
    <cfinclude template="report/price_report.cfm">
</cfcase>

<cfcase value="cash_report">
    <cfinclude template="report/cash_report.cfm">
</cfcase>

<cfcase value="cash_report_add">
    <cfinclude template="report/cash_report_add.cfm">
</cfcase>

<cfcase value="periodic_apps">
    <cfinclude template="report/periodic_apps.cfm">
</cfcase>

<cfcase value="periodic_apps_comps">
    <cfinclude template="report/periodic_apps_comps.cfm">
</cfcase>
<cfcase value="periodic_apps_comps_add">
    <cfinclude template="report/periodic_apps_comps_add.cfm">
</cfcase>

<cfcase value="emptypopup_get_product_sales,emptypopup_get_product_sales2">
    <cfinclude template="query/get_product_sales.cfm">
</cfcase>

<cfcase value="form_add_order3">
    	<cfinclude template="form/add_order3.cfm">
	<!--- <cfinclude template="query/add_speed_manage_product.cfm"> --->
    </cfcase>
<!---Çek Yönetimi--->
<cfcase value="cheque_management,autoexcelpopuppage_cheque_management">
    <cfinclude template="form/cheque_management.cfm">
</cfcase>
<cfcase value="emptypopup_save_cheque_management">
    <cfinclude template="query/save_cheque_management.cfm">
</cfcase>
<cfcase value="emptypopup_del_cheque_management">
    <cfinclude template="query/del_cheque_management.cfm">
</cfcase>

<cfcase value="calc_cheque_management">
    <cfinclude template="form/calc_cheque_management.cfm">
</cfcase>
<cfcase value="list_cheque_management">
    <cfinclude template="display/list_cheque_management.cfm">
</cfcase>
<cfcase value="manage_stocks">
    <cfinclude template="form/manage_stocks.cfm">
</cfcase>
<cfcase value="emptypopup_manage_stocks">
    <cfinclude template="query/manage_stocks.cfm">
</cfcase>
<cfcase value="emptypopup_delete_manage_stocks">
    <cfinclude template="query/delete_manage_stocks.cfm">
</cfcase>
<cfcase value="list_manage_stocks">
    <cfinclude template="display/list_manage_stocks.cfm">
</cfcase>
<cfcase value="popup_list_pur">
    <cfinclude template="display/list_pur.cfm">
</cfcase>
<cfcase value="popup_close_action_rows">
    <cfinclude template="display/close_action_rows.cfm">
</cfcase>
<cfcase value="popup_close_action_group_rows">
    <cfinclude template="display/close_action_group_rows.cfm">
</cfcase>
<cfcase value="emptypopup_close_action_group_rows">
    <cfinclude template="query/close_action_group_rows.cfm">
</cfcase>
<cfcase value="popup_hide_action_group_rows">
    <cfinclude template="display/hide_action_group_rows.cfm">
</cfcase>
<cfcase value="emptypopup_hide_action_group_rows">
    <cfinclude template="query/hide_action_group_rows.cfm">
</cfcase>
<cfcase value="emptypopup_add_stocks_row_count_order">
    <cfinclude template="query/add_stocks_count.cfm">
</cfcase>
<cfcase value="emptypopup_del_stocks_row_count_order">
    <cfinclude template="query/del_stocks_count.cfm">
</cfcase>

<cfcase value="popup_print_siparis">
    	<cfinclude template="display/print_siparis.cfm">
    </cfcase>
<cfcase value="popup_print_siparis2">
    	<cfinclude template="display/print_siparis2.cfm">
    </cfcase>
<!--- sayimlar --->
		<cfcase value="list_stock_count_orders,autoexcelpopuppage_list_stock_count_orders">
			<cfquery name="get_fuseactions" datasource="#dsn#">
        		SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        		</cfquery>
			<cfset folder_ = "/extra/display/">
    			<cfinclude template="display/list_stock_count_orders.cfm">
			<cfset get_fuseactions.recordcount = 0>
    		</cfcase>
<cfcase value="list_stock_count_orders_rows,autoexcelpopuppage_list_stock_count_orders_rows">
			<cfquery name="get_fuseactions" datasource="#dsn#">
        		SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        		</cfquery>
			<cfset folder_ = "/extra/display/">
    			<cfinclude template="display/list_stock_count_orders_rows.cfm">
			<cfset get_fuseactions.recordcount = 0>
    		</cfcase>
<cfcase value="list_stock_count_orders_compare,autoexcelpopuppage_list_stock_count_orders_compare">
			<cfquery name="get_fuseactions" datasource="#dsn#">
        		SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        		</cfquery>
			<cfset folder_ = "/extra/display/">
    			<cfinclude template="display/list_stock_count_orders_compare.cfm">
			<cfset get_fuseactions.recordcount = 0>
    		</cfcase>	
<cfcase value="list_stock_count_orders_report_product,autoexcelpopuppage_list_stock_count_orders_report_product">
			<cfquery name="get_fuseactions" datasource="#dsn#">
        		SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        		</cfquery>
			<cfset folder_ = "/extra/display/">
    			<cfinclude template="display/list_stock_count_orders_report_product.cfm">
			<cfset get_fuseactions.recordcount = 0>
    		</cfcase>	
<cfcase value="list_stock_count_orders_report_product_cat,autoexcelpopuppage_list_stock_count_orders_report_product_cat">
			<cfquery name="get_fuseactions" datasource="#dsn#">
        		SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        		</cfquery>
			<cfset folder_ = "/extra/display/">
    			<cfinclude template="display/list_stock_count_orders_report_product_cat.cfm">
			<cfset get_fuseactions.recordcount = 0>
    		</cfcase>
<cfcase value="list_stock_count_orders_report_product_cat_grup,autoexcelpopuppage_list_stock_count_orders_report_product_cat_grup">
			<cfquery name="get_fuseactions" datasource="#dsn#">
        		SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        		</cfquery>
			<cfset folder_ = "/extra/display/">
    			<cfinclude template="display/list_stock_count_orders_report_product_cat_grup.cfm">
			<cfset get_fuseactions.recordcount = 0>
    		</cfcase>
<cfcase value="popup_add_stock_count_order">
    			<cfinclude template="form/add_stock_count_order.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_stock_count_order">
    			<cfinclude template="query/add_stock_count_order.cfm">
		</cfcase>
        
        <cfcase value="emptypopup_delete_stock_count_order_products">
    			<cfinclude template="query/delete_stock_count_order_products.cfm">
		</cfcase>
		
		<cfcase value="popup_transfer_stock_count_order">
    			<cfinclude template="form/transfer_stock_count_order.cfm">
		</cfcase>

		<cfcase value="popup_upd_stock_count_order">
    			<cfinclude template="form/upd_stock_count_order.cfm">
		</cfcase>
		<cfcase value="emptypopup_upd_stock_count_order">
    			<cfinclude template="query/upd_stock_count_order.cfm">
		</cfcase>
		<cfcase value="emptypopup_del_stock_count_order">
    			<cfinclude template="query/del_stock_row_order.cfm">
		</cfcase>
		<cfcase value="compare_orders">
    			<cfinclude template="display/compare_orders.cfm">
		</cfcase>
		<cfcase value="popup_upd_stock_counts_row">
    			<cfinclude template="form/upd_stock_counts_row.cfm">
		</cfcase>
		<cfcase value="emptypopup_upd_stock_counts_row">
    			<cfinclude template="query/upd_stock_counts_row.cfm">
		</cfcase>
		<cfcase value="emptypopup_del_stock_counts_row">
    			<cfinclude template="query/del_stock_counts_row.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_stock_counts_row">
    			<cfinclude template="query/add_stock_counts_row.cfm">
		</cfcase>
		<cfcase value="popup_add_stock_counts_row">
    			<cfinclude template="form/add_stock_counts_row.cfm">
		</cfcase>
		<cfcase value="popup_del_stock_count_order">
    			<cfinclude template="form/del_count_stock_row_order.cfm">
		</cfcase>
		<cfcase value="emptypopup_del_count_stock_row_order">
    			<cfinclude template="query/del_count_stock_row_order.cfm">
		</cfcase>
		<cfcase value="list_stock_count_orders_report_product_cat_product">
			<cfquery name="get_fuseactions" datasource="#dsn#">
        		SELECT 'pos_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
        		</cfquery>
			<cfset folder_ = "/extra/display/">
    			<cfinclude template="display/list_stock_count_orders_report_product_cat_product.cfm">
			<cfset get_fuseactions.recordcount = 0>
    		</cfcase>
	<cfcase value="create_revenue_rows">
		<cfinclude template="display/create_revenue_rows.cfm">
	</cfcase> 
	<cfcase value="create_revenue_rows2">
		<cfinclude template="display/create_revenue_rows2.cfm">
	</cfcase> 
    
    <cfcase value="emptypopup_basket_converter">
		<cfinclude template="form/add_order_new.cfm">
	</cfcase> 
    
    <cfcase value="table_spe">
		<cfinclude template="form/table_spe.cfm">
	</cfcase> 
    
    <cfcase value="emptypopup_table_spe">
		<cfinclude template="query/table_spe.cfm">
	</cfcase> 
    
     <cfcase value="table_spe_user">
		<cfinclude template="form/table_spe_user.cfm">
	</cfcase> 
    
    <cfcase value="emptypopup_table_spe_user">
		<cfinclude template="query/table_spe_user.cfm">
	</cfcase> 
    
    <cfcase value="table_b2b_user">
		<cfinclude template="form/table_b2b_user.cfm">
	</cfcase> 
    
    <cfcase value="emptypopup_table_b2b_user">
		<cfinclude template="query/table_b2b_user.cfm">
	</cfcase> 
    
    <cfcase value="emptypopup_get_new_layout_system">
		<cfinclude template="query/get_new_layout_system.cfm">
	</cfcase> 
    
    <cfcase value="emptypopup_save_layout_new">
    	<cfinclude template="form/save_layout_new.cfm">
    </cfcase>
    
    <cfcase value="emptypopup_save_layout_action_new">
    	<cfinclude template="query/save_layout_action_new.cfm">
    </cfcase>
    
    <cfcase value="emptypopup_get_short_cuts">
    	<cfinclude template="form/get_short_cuts.cfm">
    </cfcase>
    
    <cfcase value="emptypopup_del_product_from_table">
    	<cfinclude template="query/del_product_from_table.cfm">
    </cfcase>
	      
  <cfcase value="popup_change_drag_table_new">
    <cfinclude template="form/change_drag_table_new.cfm">
</cfcase>

<cfcase value="emptypopup_get_table_object">
    	<cfinclude template="form/get_table_object.cfm">
    </cfcase>
    
     <cfcase value="list_prices">
		<cfinclude template="display/list_prices.cfm">
	</cfcase>
    
    <cfcase value="popup_print_speed_manage_product">
		<cfinclude template="form/print_speed_manage_product.cfm">
	</cfcase>
    
    <cfcase value="genius_action_watch_screen">
		<cfinclude template="display/genius_action_watch_screen.cfm">
	</cfcase> 
    
    <cfcase value="emptypopup_genius_action_watch_screen">
		<cfinclude template="display/run_genius_action_watch_screen.cfm">
	</cfcase> 

 <cfcase value="genius_online_sales_screen">
		<cfinclude template="display/genius_online_sales_screen.cfm">
	</cfcase>

 <cfcase value="popup_manage_bad_rows">
	<cfinclude template="display/manage_bad_rows.cfm">
</cfcase>
 <cfcase value="popup_manage_bad_rows_upd">
	<cfinclude template="display/manage_bad_rows_upd.cfm">
</cfcase>
<cfcase value="emptypopup_update_action_row">
	<cfinclude template="query/update_action_row.cfm">
</cfcase>


<cfcase value="emptypopup_get_genius_cash_screen">
	<cfinclude template="display/get_genius_cash_screen.cfm">
</cfcase>

<cfcase value="emptypopup_get_genius_cash_screen2">
	<cfinclude template="display/get_genius_cash_screen2.cfm">
</cfcase>

<cfcase value="popup_get_payment_details,emptypopup_get_payment_details">
	<cfinclude template="display/get_payment_details.cfm">
</cfcase>
<cfcase value="popup_get_payment_details2">
	<cfinclude template="display/get_payment_details2.cfm">
</cfcase>

<cfcase value="autoexcelpopuppage_genius_sales_report,genius_sales_report">
	<cfinclude template="report/genius_sales_report.cfm">
</cfcase>
<cfcase value="autoexcelpopuppage_genius_fis,genius_fis">
	<cfinclude template="report/genius_fis.cfm">
</cfcase>
<cfcase value="popup_update_fis">
	<cfinclude template="form/update_fis.cfm">
</cfcase>
<cfcase value="emptypopup_update_fis">
	<cfinclude template="query/update_fis.cfm">
</cfcase>
<cfcase value="genius_clear_rows">
	<cfinclude template="form/genius_clear_rows.cfm">
</cfcase>
<cfcase value="emptypopup_genius_clear_rows">
	<cfinclude template="query/genius_clear_rows.cfm">
</cfcase>
<cfcase value="popupflush_import_sales_cards_to_actions">
	<cfinclude template="form/import_sales_cards_to_actions.cfm">
</cfcase>
<cfcase value="autoexcelpopuppage_list_genius_in,list_genius_in">
	<cfinclude template="display/list_genius_in.cfm">
</cfcase>


<cfcase value="emptypopup_del_genius_give">
	<cfinclude template="query/del_genius_give.cfm">
</cfcase>
<cfcase value="emptypopup_add_genius_give">
	<cfinclude template="query/add_genius_give.cfm">
</cfcase>
<cfcase value="popup_add_genius_give_1">
	<cfinclude template="form/add_genius_give_1.cfm">
</cfcase>
<cfcase value="popup_get_z_numbers">
	<cfinclude template="form/get_z_numbers.cfm">
</cfcase>
<cfcase value="popup_get_z_numbers_inner">
	<cfinclude template="form/get_z_numbers_inner.cfm">
</cfcase>
<cfcase value="popup_get_z_numbers_inner2">
	<cfinclude template="form/get_z_numbers_inner2.cfm">
</cfcase>
<cfcase value="popup_get_z_numbers_inner3">
	<cfinclude template="form/get_z_numbers_inner3.cfm">
</cfcase>

<cfcase value="offline_import">
	<cfinclude template="form/offline_import.cfm">
</cfcase>
<cfcase value="offline_import_action">
	<cfinclude template="query/offline_import.cfm">
</cfcase>

<cfcase value="card_multi_add">
    <cfquery name="get_fuseactions" datasource="#dsn#">
        SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
    </cfquery>
    <cfset folder_ = "/extra/display/">
    <cfinclude template="form/card_multi_add.cfm">
    <cfset get_fuseactions.recordcount = 0>
</cfcase>

<cfcase value="card_multi_list">
    <cfquery name="get_fuseactions" datasource="#dsn#">
        SELECT 'member_left_menu' AS LEFT_MENU_NAME,0 IS_WBO_FORM_LOCK
    </cfquery>
    <cfset folder_ = "/extra/display/">
    <cfinclude template="display/card_multi_list.cfm">
    <cfset get_fuseactions.recordcount = 0>
</cfcase>

<cfcase value="popup_card_multi_list_inner">
	<cfinclude template="display/card_multi_list_inner.cfm">
</cfcase>


<cfcase value="emptypopup_card_multi_add2">   
    <cfinclude template="query/card_multi_add.cfm">
</cfcase>

<cfcase value="Yillik_izin_reports">
    	<cfinclude template="report/hr_offtimes_report.cfm">
    </cfcase>

<cfcase value="autoexcelpopuppage_list_order,list_order">
    	<cfinclude template="display/list_order.cfm">
    </cfcase>

<cfcase value="detail_order">
    	<cfinclude template="/purchase/form/detail_order.cfm">
    </cfcase>

<cfcase value="purchase_analyse_report_ship">
    	<cfinclude template="report/purchase_analyse_report_ship.cfm">
    </cfcase>

<cfcase value="transfer_branch_all_stocks">
    	<cfinclude template="form/transfer_branch_all_stocks.cfm">
    </cfcase>
<cfcase value="transfer_branch_all_stocks2">
    	<cfinclude template="form/transfer_branch_all_stocks2.cfm">
    </cfcase>
<cfcase value="transfer_branch">
    	<cfinclude template="form/transfer_branch.cfm">
    </cfcase>
<cfcase value="transfer_branch2">
    	<cfinclude template="form/transfer_branch2.cfm">
    </cfcase>
<cfcase value="popup_transfer_branch3">
    	<cfinclude template="form/transfer_branch3.cfm">
    </cfcase>
<cfcase value="popup_transfer_branch4">
    	<cfinclude template="form/transfer_branch4.cfm">
    </cfcase>
<cfcase value="list_waiting_prices">
    	<cfinclude template="display/list_waiting_prices.cfm">
    </cfcase>
<cfcase value="list_promotions">
    	<cfinclude template="display/list_promotions.cfm">
    </cfcase>
<cfcase value="add_promotion">
    	<cfinclude template="form/add_promotion.cfm">
    </cfcase>
<cfcase value="emptypopup_add_promotion">
    	<cfinclude template="query/add_promotion.cfm">
    </cfcase>
<cfcase value="emptypopup_select_promotion_inner">
    	<cfinclude template="form/select_promotion_inner.cfm">
    </cfcase>
<cfcase value="emptypopup_select_promotion_inner2">
    	<cfinclude template="form/select_promotion_inner2.cfm">
    </cfcase>
<cfcase value="upd_promotion">
    	<cfinclude template="form/upd_promotion.cfm">
    </cfcase>
<cfcase value="emptypopup_upd_promotion">
    	<cfinclude template="query/upd_promotion.cfm">
    </cfcase>
<cfcase value="del_promotion">
    	<cfinclude template="query/del_promotion.cfm">
    </cfcase>

<cfcase value="emptypopup_detail_transfers">
    	<cfinclude template="form/detail_transfers.cfm">
    </cfcase>
<cfcase value="popup_detail_transfers_2,emptypopup_detail_transfers_2">
    	<cfinclude template="form/detail_transfers_2.cfm">
    </cfcase>
<cfcase value="emptypopup_get_table_departments">
    	<cfinclude template="form/get_table_departments.cfm">
    </cfcase>
<cfcase value="emptypopup_upd_price_type">
    	<cfinclude template="query/upd_price_type.cfm">
    </cfcase>
<cfcase value="popup_upd_price_type">
    	<cfinclude template="form/upd_price_type.cfm">
    </cfcase>
<cfcase value="popup_update_order_speed_manage_product">
    	<cfinclude template="form/update_order.cfm">
    </cfcase>
<cfcase value="popup_mail_siparis">
    	<cfinclude template="form/mail_siparis.cfm">
    </cfcase>
<cfcase value="popup_manage_company_mails">
    	<cfinclude template="form/manage_company_mails.cfm">
    </cfcase>
<cfcase value="emptypopup_manage_company_mails">
    	<cfinclude template="query/manage_company_mails.cfm">
    </cfcase>
<cfcase value="popup_get_company_mails">
    	<cfinclude template="form/get_company_mails.cfm">
    </cfcase>
<cfcase value="emptypopup_get_company_orders">
    	<cfinclude template="display/get_company_orders.cfm">
    </cfcase>
<cfcase value="fon_management">
    	<cfinclude template="report/fon_management.cfm">
    </cfcase>
<cfcase value="emptypopup_fon_management_inner,fon_management_inner">
    	<cfinclude template="report/fon_management_inner.cfm">
    </cfcase>
<cfcase value="emptypopup_manage_fon_rows">
    	<cfinclude template="report/manage_fon_rows.cfm">
    </cfcase>
<cfcase value="list_consumer_bonus_report">
    	<cfinclude template="report/list_consumer_bonus_report.cfm">
    </cfcase>
<cfcase value="list_consumer_bonus_dash">
    	<cfinclude template="report/list_consumer_bonus_dash.cfm">
    </cfcase>
<cfcase value="emptypopup_get_transfer_stock">
    	<cfinclude template="query/get_transfer_stock.cfm">
    </cfcase>
<cfcase value="emptypopup_get_transfer_stock_upd">
    	<cfinclude template="query/get_transfer_stock_upd.cfm">
    </cfcase>
<cfcase value="emptypopup_get_transfer_stock_upd_action">
    	<cfinclude template="query/get_transfer_stock_upd_action.cfm">
    </cfcase>
<cfcase value="transfer_branch_list">
    	<cfinclude template="display/transfer_branch_list.cfm">
    </cfcase>
<cfcase value="emptypopup_del_transfer_stock">
    	<cfinclude template="query/del_transfer_stock.cfm">
    </cfcase>
<cfcase value="budget_codes">
    	<cfinclude template="display/budget_codes.cfm">
    </cfcase>
<cfcase value="delete_invoice_relations">
    	<cfinclude template="form/delete_invoice_relations.cfm">
    </cfcase>
<cfcase value="delete_invoice_relations_2">
    	<cfinclude template="form/delete_invoice_relations_2.cfm">
    </cfcase>
<cfcase value="emptypopup_delete_invoice_relations">
    	<cfinclude template="query/delete_invoice_relations.cfm">
    </cfcase>
<cfcase value="credit_card_payment_report">
    	<cfinclude template="report/credit_card_payment_report.cfm">
    </cfcase>
<cfcase value="credit_payment_report">
    	<cfinclude template="report/credit_payment_report.cfm">
    </cfcase>
<cfcase value="emptypopup_budget_codes_transfer">
    	<cfinclude template="query/budget_codes_transfer.cfm">
    </cfcase>
<cfcase value="emptypopup_view_transfer">
    	<cfinclude template="query/view_transfer.cfm">
    </cfcase>
<cfcase value="active_stock_order_report">
    	<cfinclude template="report/active_stock_order_report.cfm">
    </cfcase>
<cfcase value="depo_transfer_report">
    	<cfinclude template="report/depo_transfer_report.cfm">
    </cfcase>

<cfcase value="depo_transfer_report_all">
    	<cfinclude template="report/depo_transfer_report_all.cfm">
    </cfcase>


<cfcase value="k1_report">
    	<cfinclude template="report/k1_report.cfm">
    </cfcase>
<cfcase value="k2_report">
    	<cfinclude template="report/k2_report.cfm">
    </cfcase>
<cfcase value="k3_report">
    	<cfinclude template="report/k3_report.cfm">
    </cfcase>
<cfcase value="add_payment_group">
    	<cfinclude template="form/add_payment_group.cfm">
    </cfcase>
<cfcase value="emptypopup_add_payment_group">
    	<cfinclude template="query/add_payment_group.cfm">
    </cfcase>
<cfcase value="upd_payment_group">
    	<cfinclude template="form/upd_payment_group.cfm">
    </cfcase>
<cfcase value="emptypopup_upd_payment_group">
    	<cfinclude template="query/upd_payment_group.cfm">
    </cfcase>
<cfcase value="list_payment_group">
    	<cfinclude template="display/list_payment_group.cfm">
    </cfcase>
<cfcase value="emptypopup_del_payment_group">
    	<cfinclude template="query/del_payment_group.cfm">
    </cfcase>
	
	<cfcase value="set_payment_group">
    	<cfinclude template="form/set_payment_group.cfm">
    </cfcase>

<!--- sayimlar --->
    <cfdefaultcase>
		<cfset hata="5">
        <cfinclude template="../dsp_hata.cfm">
	</cfdefaultcase>
</cfswitch>