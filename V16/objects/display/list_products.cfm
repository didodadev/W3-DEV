<cfsetting showdebugoutput="yes">
<cfparam name="attributes.satir" default="">
<cf_xml_page_edit fuseact="objects.popup_products">
<cfif isdefined("is_other_company_stock") and is_other_company_stock eq 1 and isdefined("other_company_id_1") and len(other_company_id_1) and isdefined("other_company_id_2") and len(other_company_id_2) and other_company_id_1 eq session.ep.company_id>
	<cfset new_dsn3 = '#dsn#_#other_company_id_2#'>
	<cfset new_dsn2 = '#dsn#_#session.ep.period_year#_#other_company_id_2#'>
<cfelse>
	<cfset new_dsn3 = dsn3>
	<cfset new_dsn2 = dsn2>
</cfif>
<cfif is_expense_revenue_center eq 0>
	<cfif is_auto_filter eq 1>
		<cfset attributes.form_submitted = 1>
		<cfset attributes.is_submit = 1>
		<cfset attributes.is_submit_form = 1>
	</cfif>
</cfif>
<cfquery name="GET_PROPERTY_VAR" datasource="#DSN1#">
	SELECT
        PP.PROPERTY_ID,
        PP.PROPERTY,
        PPD.PROPERTY_DETAIL_ID,
        PPD.PROPERTY_DETAIL
		<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
			,PCP.PRODUCT_CAT_ID
		</cfif>
    FROM
        PRODUCT_PROPERTY PP,
        PRODUCT_PROPERTY_DETAIL PPD
		<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
			,PRODUCT_CAT_PROPERTY PCP
		</cfif>
    WHERE
        PP.PROPERTY_ID = PPD.PRPT_ID
        <cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
       		AND PP.PROPERTY_ID=PCP.PROPERTY_ID
        	AND PCP.PROPERTY_ID=PPD.PRPT_ID
        	AND PCP.PRODUCT_CAT_ID=#attributes.product_catid#
        </cfif>
        AND PPD.IS_ACTIVE = 1
        AND PP.IS_ACTIVE = 1
    ORDER BY
        PP.PROPERTY,
        PPD.PROPERTY_DETAIL
</cfquery>
<cfinclude template="../query/get_basket_type.cfm">
<cfparam name="url_str" default="">
<cfquery name="BASKET_PROD_LIST" datasource="#DSN3#">
	SELECT DISTINCT
		SETUP_BASKET_ROWS.IS_SELECTED,
		SETUP_BASKET.PRODUCT_SELECT_TYPE,
		SETUP_BASKET.USE_PROJECT_DISCOUNT 
	FROM 
		SETUP_BASKET,
		SETUP_BASKET_ROWS
	WHERE
		SETUP_BASKET.BASKET_ID = SETUP_BASKET_ROWS.BASKET_ID AND
		SETUP_BASKET.BASKET_ID = #attributes.int_basket_id# AND
		SETUP_BASKET.B_TYPE = 1 AND	
		SETUP_BASKET_ROWS.B_TYPE = 1 AND
		SETUP_BASKET_ROWS.TITLE = 'zero_stock_status'	
</cfquery>
<cfquery name="BASKET_PROD_LIST2" datasource="#DSN3#">
    SELECT DISTINCT
        SETUP_BASKET_ROWS.IS_SELECTED
    FROM 
        SETUP_BASKET,
        SETUP_BASKET_ROWS
    WHERE
        SETUP_BASKET.BASKET_ID = SETUP_BASKET_ROWS.BASKET_ID AND
        SETUP_BASKET.BASKET_ID = #attributes.int_basket_id# AND
        SETUP_BASKET.B_TYPE = 1 AND	
        SETUP_BASKET_ROWS.B_TYPE = 1 AND
        SETUP_BASKET_ROWS.TITLE = 'zero_stock_control_date'	
</cfquery>
<!--- Spect sayfasından gelirken sadece 2 numaralı ürün popup'unu kullansın! --->
<cfif isdefined('attributes._spec_page_')>
	<cfset open_stock_popup_type = 6 >
    <cfset basket_prod_list.product_select_type = 6 >
<cfelseif isdefined('attributes.prod_order_result_') and attributes.prod_order_result_ eq 1>
	<cfset open_stock_popup_type = 1 >
    <cfset basket_prod_list.product_select_type = 1 >
</cfif>
<!--- //////////////Spect sayfasından gelirken sadece 2 numaralı ürün popup'unu kullansın! --->
<cfif len(listgetat(session.ep.user_location,1,'-')) and basket_prod_list.product_select_type neq 1>
	<cfquery name="GET_DEPS" datasource="#DSN#">
		SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #listgetat(session.ep.user_location,1,'-')#
	</cfquery>
	<cfset department_name = get_deps.department_head>
	<cfif session.ep.our_company_info.workcube_sector is "it">
		<cfif listfind('6,9',basket_prod_list.product_select_type,',')>
			<cfquery name="GET_ROW_STOCKS" datasource="#new_dsn2#">
				SELECT PRODUCT_STOCK,STOCK_ID,SPECT_VAR_ID FROM GET_STOCK_PRODUCT_SPECT WHERE DEPARTMENT_ID = #listgetat(session.ep.user_location,1,'-')#
			</cfquery>
		<cfelse>
			<cfquery name="GET_ROW_STOCKS" datasource="#new_dsn2#">
				SELECT PRODUCT_STOCK,STOCK_ID FROM GET_STOCK_PRODUCT WHERE DEPARTMENT_ID = #listgetat(session.ep.user_location,1,'-')#
			</cfquery>
		</cfif>	
	</cfif>
<cfelse>
	<cfset department_name = "">
</cfif>
<cfif isdefined('xml_use_prj_disc_price_list') and xml_use_prj_disc_price_list eq 1 and isdefined('attributes.project_id') and len(attributes.project_id)>
<!--- xml setupta "Proje Bağlantı Fiyat Listesi Seçili Gelsin" seçilmişse ve belgede proje varsa --->
	<cfquery name="get_prj_disc_price_list" datasource="#dsn3#">
		SELECT PRICE_CATID FROM PROJECT_DISCOUNTS WHERE PROJECT_ID=#attributes.project_id#
	</cfquery>
	<cfif get_prj_disc_price_list.recordcount>
		<cfset prj_disc_price_catid=get_prj_disc_price_list.PRICE_CATID>
	</cfif>
</cfif>
<cfif isdefined('open_stock_popup_type') and open_stock_popup_type eq 1 or basket_prod_list.product_select_type eq 1>
	<cfinclude template="list_popup_product_sale_1_js.cfm">
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 2) or basket_prod_list.product_select_type eq 2 and attributes.is_sale_product eq 1>
	<cfinclude template="list_products_sales_it.cfm">
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 2) or basket_prod_list.product_select_type eq 2 and attributes.is_sale_product eq 0>
	<cfinclude template="list_products_purchase_it.cfm">
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 2) or basket_prod_list.product_select_type eq 2>
	<cfinclude template="list_products_sales_it.cfm">
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 3) or basket_prod_list.product_select_type eq 3 and (attributes.is_sale_product eq 0 or not len(attributes.is_sale_product))>
	<cfinclude template="list_products_purchase_it.cfm">
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 3) or basket_prod_list.product_select_type eq 3 and attributes.is_sale_product eq 1>
	<cfinclude template="list_products_sales_it.cfm">
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 4) or basket_prod_list.product_select_type eq 4>
	<cfinclude template="list_products_popup_it_js.cfm">
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 5) or basket_prod_list.product_select_type eq 5>
	<cfinclude template="../form/add_spect_property_stock_price.cfm">
<cfelseif (isdefined('open_stock_popup_type') and listfind('6,8,9,11,12,13',open_stock_popup_type)) or listfind('6,8,9,11,12,13',basket_prod_list.product_select_type)><!--- sales_it urun popupı acılıyor --->
	<cfif attributes.is_sale_product eq 0> <!--- alıs karakterli islemse --->
		<cfinclude template="list_products_purchase_it.cfm">
	<cfelse>
		<cfinclude template="list_products_sales_it.cfm">
	</cfif>
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 7) or basket_prod_list.product_select_type eq 7>
	<cfif attributes.is_sale_product eq 1>
		<cfinclude template="list_products_sales_it.cfm">
	<cfelse>
		<cfinclude template="list_products_purchase_it.cfm">
	</cfif>
<cfelseif (isdefined('open_stock_popup_type') and open_stock_popup_type eq 10) or basket_prod_list.product_select_type eq 10>
	<cfinclude template="list_products_strategy.cfm">
<cfelseif basket_prod_list.product_select_type eq 14>
	<cfinclude template="list_specific_weight.cfm">
</cfif>
<!---DIKKAT!!! from_product hidden formunda yapılacak degisiklikler add_basket_row_from_barcod.cfm dosyasına da aktarılmalı --->
<form name="form_product" id="form_product" method="post" action="">
	<input type="Hidden" name="satir" id="satir" value="<cfoutput>#attributes.satir#</cfoutput>">
	<input type="hidden" name="xml_use_other_dept_info_ss" id="xml_use_other_dept_info_ss" value="<cfif isdefined('xml_use_other_dept_info_ss')><cfoutput>#xml_use_other_dept_info_ss#</cfoutput></cfif>">
	<input type="hidden" name="is_chck_dept_based_stock" id="is_chck_dept_based_stock" value="<cfif isdefined('xml_chck_dept_based_stock')><cfoutput>#xml_chck_dept_based_stock#</cfoutput></cfif>">
	<input type="hidden" name="use_paymethod_for_prod_conditions" id="use_paymethod_for_prod_conditions" value="<cfif isdefined('xml_use_paymethod_for_prod_conditions')><cfoutput>#xml_use_paymethod_for_prod_conditions#</cfoutput></cfif>">
	<input type="hidden" name="use_general_price_cat_exceptions" id="use_general_price_cat_exceptions" value="<cfif isdefined('xml_use_general_price_cat_exceptions')><cfoutput>#xml_use_general_price_cat_exceptions#</cfoutput></cfif>">
	<input type="Hidden" name="use_project_discounts" id="use_project_discounts" value="<cfif isdefined('xml_use_project_discounts') and xml_use_project_discounts eq 1><cfoutput>#xml_use_project_discounts#</cfoutput><cfelse>0</cfif>">
	<input type="Hidden" name="is_basket_zero_stock" id="is_basket_zero_stock" value="<cfif len(basket_prod_list.is_selected)><cfoutput>#basket_prod_list.is_selected#</cfoutput><cfelse>0</cfif>">
	<input type="Hidden" name="is_basket_zero_stock_control_date" id="is_basket_zero_stock_control_date" value="<cfif len(basket_prod_list2.is_selected)><cfoutput>#basket_prod_list2.is_selected#</cfoutput><cfelse>0</cfif>">
	<input type="hidden" name="search_process_date" id="search_process_date" value="<cfif isdefined("attributes.search_process_date")><cfoutput>#attributes.search_process_date#</cfoutput></cfif>">
    <input type="Hidden" name="from_price_page" id="from_price_page" value="1">
	<input type="Hidden" name="department_out" id="department_out" value="<cfif isdefined("attributes.department_out")><cfoutput>#attributes.department_out#</cfoutput></cfif>">
    <input type="Hidden" name="department_in" id="department_in" value="<cfif isdefined("attributes.department_in")><cfoutput>#attributes.department_in#</cfoutput></cfif>">
	<input type="Hidden" name="location_out" id="location_out" value="<cfif isdefined("attributes.location_out")><cfoutput>#attributes.location_out#</cfoutput></cfif>">
    <input type="Hidden" name="location_in" id="location_in" value="<cfif isdefined("attributes.location_in")><cfoutput>#attributes.location_in#</cfoutput></cfif>">
	<input type="Hidden" name="update_product_row_id" id="update_product_row_id" value="<cfoutput>#update_product_row_id#</cfoutput>">
    <input type="Hidden" name="product_id" id="product_id" value="" >
	<input type="Hidden" name="stock_id" id="stock_id" value="">
	<input type="Hidden" name="stock_code" id="stock_code" value="">
	<input type="Hidden" name="barcod" id="barcod" value="">
	<input type="Hidden" name="manufact_code" id="manufact_code" value="">
	<input type="Hidden" name="product_name" id="product_name" value="">
	<input type="Hidden" name="bsmv_" id="bsmv_" value="">
	<input type="Hidden" name="oiv_" id="oiv_" value="">
	<input type="Hidden" name="unit_id" id="unit_id" value="">
	<input type="Hidden" name="unit" id="unit"  value="">
	<input type="Hidden" name="is_inventory" id="is_inventory"  value="">
	<input type="Hidden" name="product_code" id="product_code" value="">
	<input type="Hidden" name="amount" id="amount" value="">
	<input type="hidden" name="is_serial_no" id="is_serial_no" value="">
	<input type="hidden" name="unit_multiplier" id="unit_multiplier" value="">	
	<input type="hidden" name="amount_multiplier" id="amount_multiplier" value="">	
	<input type="hidden" name="price_cat_amount_multiplier" id="price_cat_amount_multiplier" value="">
 	<input type="hidden" name="kur_hesapla" id="kur_hesapla" value="">	
	<input type="hidden" name="is_sale_product" id="is_sale_product" value="<cfif isdefined("is_sale_product")><cfoutput>#is_sale_product#</cfoutput><cfelse>-1</cfif>">
	<input type="hidden" name="tax" id="tax" value="">
	<input type="hidden" name="otv" id="otv" value="">
	<input type="hidden" name="flt_price_other_amount" id="flt_price_other_amount"  value="">
	<input type="hidden" name="str_money_currency" id="str_money_currency"  value="">
	<input type="hidden" name="department_id" id="department_id" value="">
	<input type="hidden" name="due_day_value" id="due_day_value" value="">	
	<input type="hidden" name="department_name" id="department_name" value="">
	<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("branch_id")><cfoutput>#branch_id#</cfoutput></cfif>">
	<input type="hidden" name="row_promotion_id" id="row_promotion_id" value="">
	<input type="hidden" name="promosyon_yuzde" id="promosyon_yuzde" value="">
	<input type="hidden" name="promosyon_maliyet" id="promosyon_maliyet" value="">
	<input type="hidden" name="promosyon_form_info" id="promosyon_form_info" value="">
	<input type="hidden" name="basket_id" id="basket_id"><!--- basket_id,perakende sektorunde kullanılan urun listesinden taşındı --->
	<input type="hidden" name="spec_id" id="spec_id" value="">
	<input type="hidden" name="is_production" id="is_production" value="">
	<input type="hidden" name="ek_tutar" id="ek_tutar" value=""><!--- //ek_tutar//work_product_price --->
	<input type="hidden" name="unit_other" id="unit_other" value=""><!--- //unit_other --->
	<input type="hidden" name="price_catid" id="price_catid" value="">
	<input type="hidden" name="shelf_number" id="shelf_number" value="">
	<input type="hidden" name="deliver_date" id="deliver_date" value="">
	<input type="hidden" name="duedate" id="duedate" value="">
	<input type="hidden" name="number_of_installment" id="number_of_installment" value="">
	<input type="hidden" name="list_price" id="list_price" value="">
	<input type="hidden" name="amount_other" id="amount_other" value=""><!--- 2.Miktar --->
	<input type="hidden" name="catalog_id" id="catalog_id" value="">
	<input type="hidden" name="lot_no" id="lot_no" value="">
	<input type="hidden" name="gtip_number" id="gtip_number" value="">
	<input type="hidden" name="expense_center_id" id="expense_center_id" value="">
	<input type="hidden" name="expense_center_name" id="expense_center_name" value="">
	<input type="hidden" name="expense_item_id" id="expense_item_id" value="">
	<input type="hidden" name="expense_item_name" id="expense_item_name" value="">
	<input type="hidden" name="activity_type_id" id="activity_type_id" value="">
	<input type="hidden" name ="product_detail2" id="product_detail2" value="">
	<input type="hidden" name ="reason_code" id="reason_code" value="">
	<cfif isDefined("attributes.config_tree")><input type="hidden" name ="config_tree" id="config_tree" value=""></cfif>
</form>
<script type="text/javascript">
	function gonder_price_page(from_price_page,p_id,s_id,stock_code,barcod,m_code,p_name,unit_id,unit,product_code,amount,kur_hesapla,is_sale_product,tax,otv,flt_price_other_amount,str_money_currency,department_id,department_name,is_inventory,unit_multiplier,row_promotion_id,promosyon_yuzde,promosyon_maliyet,amount_multiplier,promosyon_form_info,spec_id,is_production,ek_tutar,unit_other,price_catid,shelf_number,deliver_date,list_price,number_of_installment,due_day_value,amount_other,catalog_id)
	{	//gonder_price_page(from_price_page,p_id,s_id,stock_code,barcod,m_code,p_name,unit_id,unit,product_code,amount,is_serial_no,kur_hesapla,is_sale_product,tax,flt_price_other_amount,str_money_currency,department_id,department_name,is_inventory,unit_multiplier,row_promotion_id,promosyon_yuzde,promosyon_maliyet,amount_multiplier,promosyon_form_info,spec_id,is_production,ek_tutar,unit_other,price_catid,shelf_number,deliver_date)
		if(check_opener_member())
		{
			form_product.product_id.value = p_id;
			form_product.stock_id.value = s_id;
			form_product.stock_code.value = stock_code;
			form_product.barcod.value = barcod;
			form_product.manufact_code.value = m_code;
			form_product.product_name.value = p_name;
			form_product.unit_id.value = unit_id;
			form_product.unit_id.value = is_inventory;
			form_product.unit.value = unit;
			form_product.unit_multiplier.value = unit;
			form_product.amount.value = amount;
			//form_product.is_serial_no.value = is_serial_no;
			form_product.kur_hesapla.value = kur_hesapla;
			form_product.tax.value = tax;
			form_product.department_id.value = department_id;
			form_product.department_name.value = department_name;
			form_product.str_money_currency.value =str_money_currency;
			form_product.flt_price_other_amount.value=flt_price_other_amount;
			form_product.is_inventory.value=is_inventory;
			form_product.spec_id.value=spec_id;
			form_product.is_production.value=is_production;
			if(price_catid!=undefined) form_product.price_catid.value=price_catid;	else form_product.price_catid.value='';
			if(catalog_id!=undefined && catalog_id!= '') form_product.catalog_id.value=catalog_id; else form_product.catalog_id.value='';
			if(ek_tutar!=undefined) form_product.ek_tutar.value=ek_tutar; else form_product.ek_tutar.value='';
			if(unit_other!=undefined) form_product.unit_other.value=unit_other;	else form_product.unit_other.value='';
			if(shelf_number!=undefined) form_product.shelf_number.value=shelf_number; else form_product.shelf_number.value='';
			if(deliver_date!=undefined) form_product.deliver_date.value=deliver_date; else form_product.deliver_date.value='';
			if(otv!=undefined && otv!= '') form_product.otv.value=otv; else form_product.otv.value=0;
			if(due_day_value!=undefined && due_day_value >= 0) form_product.due_day_value.value=due_day_value; else form_product.due_day_value.value='';
			if(number_of_installment!=undefined) form_product.number_of_installment.value=number_of_installment; else form_product.number_of_installment.value=0;
			if(list_price!=undefined) form_product.list_price.value=list_price; else form_product.list_price.value=0;
			form_product.amount_other.value = filterNum(price_cat.amount_multiplier.value,3);
			if(isNaN(amount_multiplier))
			{
				form_product.amount_multiplier.value = filterNum(price_cat.amount_multiplier.value,3);
				if(form_product.amount_multiplier.value == 0)
				{
					form_product.amount_multiplier.value = 1;
					price_cat.amount_multiplier.value = commaSplit(1,3);
				}
			}
			else
			{
				form_product.amount_multiplier.value = filterNum(price_cat.amount_multiplier.value,3)*amount_multiplier;
				if(form_product.amount_multiplier.value == 0)
				{
					form_product.amount_multiplier.value = amount_multiplier;
					price_cat.amount_multiplier.value = commaSplit(1,3);
				}
			}
			form_product.row_promotion_id.value=row_promotion_id;
			form_product.promosyon_yuzde.value=promosyon_yuzde;
			form_product.promosyon_maliyet.value=promosyon_maliyet;
			form_product.promosyon_form_info.value="";
			form_product.action = '<cfoutput>#request.self#?fuseaction=objects.popup_product_price_history_public_js#url_str#&row_id=-1</cfoutput>';
			form_product.submit();
		}
	}
	/*
	function hesapla_tutar(fiyat, kur, unit_id, unit_)
	{
		opener_row_count = opener.rowCount-1;
		for (i=0; i < opener.moneyArray.length; i++)
			if(opener.moneyArray[i] == kur)
			{
				if((opener.rate1Array[i] == opener.rate2Array[i]) && (opener.rate1Array[i] == 1))
				{
					if(opener.form_basket.product_id.length != undefined)
						opener.form_basket.price[opener_row_count].value = fiyat;
					else
						opener.form_basket.price.value = fiyat;
						opener.setSelectedIndex('other_money_', opener_row_count, i);
				}
				else
				{
					if(opener.form_basket.product_id.length != undefined)
						opener.form_basket.price[opener_row_count].value = (fiyat / opener.rate1Array[i]) * opener.rate2Array[i];
					else
						opener.form_basket.price.value = (fiyat / opener.rate1Array[i]) * opener.rate2Array[i];
						opener.setSelectedIndex('other_money_', opener_row_count, i);
					}
				}
		opener.hesapla('other_money_',opener_row_count+1);
		opener.hesapla('price',opener_row_count+1);	
	}
	*/
	function sepete_ekle(from_price_page,p_id,s_id,stock_code,barcod,m_code,p_name,unit_id,unit,product_code,amount,is_serial_no,kur_hesapla,is_sale_product,tax,otv,flt_price_other_amount,str_money_currency,department_id,department_name,is_inventory,unit_multiplier,row_promotion_id,promosyon_yuzde,promosyon_maliyet,amount_multiplier,promosyon_form_info,spec_id,is_production,ek_tutar,unit_other,price_catid,shelf_number,deliver_date,duedate,list_price,number_of_installment,amount_other,catalog_id,due_day_value,lot_no,gtip_number,expense_center_id,expense_center_name,expense_item_id,expense_item_name,activity_type_id,bsmv_,product_detail2,reason_code,oiv_)
	{
		if(window.opener.basket)
			{
				form_product.basket_id.value = window.opener.basket.hidden_values.basket_id;
				from_basket = 1;
			}
			else
			{
				if(opener.form_basket != undefined)
				form_product.basket_id.value = opener.form_basket.basket_id.value;
				from_basket = 0;
			}
		if(check_opener_member())
		{
			form_product.from_price_page.value=from_price_page;	
			form_product.product_id.value = p_id;
			form_product.stock_id.value = s_id;
			form_product.stock_code.value = stock_code;
			form_product.barcod.value = barcod;
			form_product.manufact_code.value = m_code;
			form_product.product_name.value = p_name;
			form_product.unit_id.value = unit_id;
			form_product.unit.value = unit;
			form_product.unit_multiplier.value = unit_multiplier;
			form_product.amount.value = amount;
			form_product.is_serial_no.value = is_serial_no;
			form_product.kur_hesapla.value = kur_hesapla;
			form_product.tax.value = tax;
			form_product.department_id.value = department_id;
			form_product.department_name.value = department_name;
			form_product.str_money_currency.value =str_money_currency;
			form_product.flt_price_other_amount.value=flt_price_other_amount;
			form_product.is_inventory.value=is_inventory;
			form_product.spec_id.value=spec_id;
			form_product.is_production.value=is_production;
			form_product.gtip_number.value = gtip_number;
			if(lot_no!=undefined) form_product.lot_no.value=lot_no;	else form_product.lot_no.value='';
			if(price_catid!=undefined) form_product.price_catid.value=price_catid; else form_product.price_catid.value='';
			if(due_day_value!=undefined && due_day_value >= 0) form_product.due_day_value.value=due_day_value; else form_product.due_day_value.value='';
			if(ek_tutar!=undefined) form_product.ek_tutar.value=ek_tutar; else form_product.ek_tutar.value='';
			if(unit_other!=undefined) form_product.unit_other.value=unit_other;	else form_product.unit_other.value='';
			if(shelf_number!=undefined) form_product.shelf_number.value=shelf_number; else form_product.shelf_number.value='';
			if(deliver_date!=undefined) form_product.deliver_date.value=deliver_date; else form_product.deliver_date.value='';
			if(otv!=undefined && otv!= '') form_product.otv.value=otv; else form_product.otv.value=0;
			if(number_of_installment!=undefined) form_product.number_of_installment.value=number_of_installment; else form_product.number_of_installment.value=0;
			if(catalog_id!=undefined && catalog_id!= '') form_product.catalog_id.value=catalog_id; else form_product.catalog_id.value='';
			if(list_price!=undefined) form_product.list_price.value=list_price; else form_product.list_price.value=0;
			form_product.amount_other.value = filterNum(price_cat.amount_multiplier.value,3);
			form_product.expense_center_id.value = ( expense_center_id != undefined ) ? expense_center_id : '';
			form_product.expense_center_name.value = ( expense_center_name != undefined ) ? expense_center_name : '';
			form_product.expense_item_id.value = ( expense_item_id != undefined ) ? expense_item_id : '';
			form_product.expense_item_name.value = ( expense_item_name != undefined ) ? expense_item_name : '';
			form_product.activity_type_id.value = ( activity_type_id != undefined ) ? activity_type_id : '';
			form_product.bsmv_.value = ( bsmv_ != undefined ) ? bsmv_ : '';
			form_product.oiv_.value = ( oiv_ != undefined ) ? oiv_ : '';
			form_product.product_detail2.value = ( product_detail2 != undefined ) ? product_detail2 : '';
			form_product.reason_code.value = ( reason_code != undefined ) ? reason_code : '';
			if(isNaN(amount_multiplier))
			{
				form_product.amount_multiplier.value = filterNum(price_cat.amount_multiplier.value,3);
				if(form_product.amount_multiplier.value == 0)
				{
					form_product.amount_multiplier.value = 1;
					price_cat.amount_multiplier.value = commaSplit(1,3);
				}
			}
			else
			{
				form_product.amount_multiplier.value = filterNum(price_cat.amount_multiplier.value,3)*amount_multiplier;
				if(form_product.amount_multiplier.value == 0)
				{
					form_product.amount_multiplier.value = amount_multiplier;
					price_cat.amount_multiplier.value = commaSplit(amount_multiplier,3);
				}
			}
			form_product.price_cat_amount_multiplier.value = filterNum(price_cat.amount_multiplier.value,3);
			form_product.row_promotion_id.value=row_promotion_id;
			form_product.promosyon_yuzde.value=promosyon_yuzde;
			form_product.promosyon_maliyet.value=promosyon_maliyet;
			form_product.promosyon_form_info.value=promosyon_form_info;
			<cfif isDefined("attributes.from_product_config")>
			window.opener.add_spect_variations.stock_id.value = s_id;
			window.opener.box_refresh();
			window.close();
			<cfelse>
			
			if(promosyon_form_info != '')
				form_product.action = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_basket_row_multi#url_str#</cfoutput>';
			else
				form_product.action = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_basket_row#url_str#</cfoutput>';
			form_product.submit();
			</cfif>
		}
	}
	function per_sepete_ekle(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id, unit, amount, is_serial_no, kur_hesapla, tax, otv,unit_multiplier, flag_price_link, is_inventory,is_production,price_catid,shelf_number,deliver_date,list_price,number_of_installment,catalog_id,amount_other,unit_other,amount_multiplier,lot_no,gtip_number,expense_center_id,expense_center_name,expense_item_id,expense_item_name,activity_type_id,bsmv_,product_detail2,reason_code,oiv_)
	{//list_popup_product_sale_1_js.cfm 'de kullanılıyor
		if(check_opener_member())
		{
			form_product.from_price_page.value=0;
			if(window.opener.basket)
			{
				form_product.basket_id.value = window.opener.basket.hidden_values.basket_id;
				from_basket = 1;
			}
			else
			{
				form_product.basket_id.value = opener.form_basket.basket_id.value;
				from_basket = 0;
			}
			form_product.product_id.value = product_id;
			form_product.stock_id.value = stock_id;
			form_product.stock_code.value = stock_code;
			form_product.barcod.value = barcod;
			form_product.manufact_code.value = manufact_code;
			form_product.product_name.value = product_name;
			form_product.unit_id.value = unit_id;
			form_product.unit_multiplier.value = unit_multiplier;
			form_product.unit.value = unit;		
			form_product.amount.value = amount;			
			form_product.is_serial_no.value = is_serial_no;
			form_product.kur_hesapla.value = kur_hesapla;
			form_product.tax.value = tax;
			form_product.is_inventory.value = is_inventory;
			form_product.is_production.value = is_production;
			form_product.gtip_number.value = gtip_number;
			if(lot_no!=undefined) form_product.lot_no.value=lot_no;	else form_product.lot_no.value='';
			if(unit_other!=undefined && unit_other != unit) form_product.unit_other.value=unit_other;	else form_product.unit_other.value='';
			if(price_catid!=undefined) form_product.price_catid.value=price_catid; else form_product.price_catid.value='';
			if(catalog_id!=undefined && catalog_id!= '') form_product.catalog_id.value=catalog_id; else form_product.catalog_id.value='';
			if(shelf_number!=undefined) form_product.shelf_number.value=shelf_number; else form_product.shelf_number.value='';
			if(deliver_date!=undefined) form_product.deliver_date.value=shelf_number; else form_product.deliver_date.value='';
			if(otv!=undefined && otv!= '') form_product.otv.value=otv; else form_product.otv.value=0;
			if(number_of_installment!=undefined) form_product.number_of_installment.value=number_of_installment; else form_product.number_of_installment.value=0;
			if(list_price!=undefined) form_product.list_price.value=list_price; else form_product.list_price.value=0;
			form_product.expense_center_id.value = ( expense_center_id != undefined ) ? expense_center_id : '';
			form_product.expense_center_name.value = ( expense_center_name != undefined ) ? expense_center_name : '';
			form_product.expense_item_id.value = ( expense_item_id != undefined ) ? expense_item_id : '';
			form_product.expense_item_name.value = ( expense_item_name != undefined ) ? expense_item_name : '';
			form_product.activity_type_id.value = ( activity_type_id != undefined ) ? activity_type_id : '';
			form_product.bsmv_.value = ( bsmv_ != undefined ) ? bsmv_ : '';
			form_product.oiv_.value = ( oiv_ != undefined ) ? oiv_ : '';
			form_product.product_detail2.value = ( product_detail2 != undefined ) ? product_detail2 : '';
			form_product.reason_code.value = ( reason_code != undefined ) ? reason_code : '';
			if(isNaN(amount_multiplier))
			{
				form_product.amount_multiplier.value = filterNum(price_cat.amount_multiplier.value,3);
				if(form_product.amount_multiplier.value == 0)
				{
					form_product.amount_multiplier.value = 1;
					price_cat.amount_multiplier.value = commaSplit(1,3);
				}
			}
			else
			{
				form_product.amount_multiplier.value = filterNum(price_cat.amount_multiplier.value,3)*amount_multiplier;
				if(form_product.amount_multiplier.value == 0)
				{
					form_product.amount_multiplier.value = amount_multiplier;
					price_cat.amount_multiplier.value = commaSplit(amount_multiplier,3);
				}
			}
			form_product.amount_other.value = ( amount_other != undefined && amount_other != '') ? amount_other : filterNum(price_cat.amount_multiplier.value,3);
			<cfif isDefined("attributes.from_product_config")>
			window.opener.add_spect_variations.stock_id.value = stock_id;
			window.opener.box_refresh();
			window.close();
			<cfelse>
			if(flag_price_link ==1)
			{
				if(from_basket)
					form_product.action="<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_basket_row#url_str#</cfoutput>&from_basket=1";
				else
					form_product.action="<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_basket_row#url_str#</cfoutput>";
			/*	goster('message_div_main');
				get_wrk_message_div("İşlem Durumu","Ürün Sepete Ekleniyor.");
				gizle('message_div_main');*/
			}
			else
				form_product.action="<cfoutput>#request.self#?fuseaction=objects.popup_product_price_history_public_js#url_str#</cfoutput>";
			form_product.submit();
			</cfif>
			//form_product.action = '';
			/*calisiyor uyari*/
		}
		
	}
	if(window.opener.$("#basket_main_div #basket_due_value").length != 0)
		form_product.due_day_value.value = window.opener.$("#basket_main_div #basket_due_value").val();
	/*if(!opener && !opener.form_basket && !opener.form_basket.basket_due_value)
	{
		form_product.due_day_value.value=opener.form_basket.basket_due_value.value;
	}
	*/
	function change_due_value(paymethod_id,paymethod,due_day)
	{
		if(window.opener.$("#basket_main_div #basket_due_value").length != 0)
		{
			window.opener.$("#basket_main_div #basket_due_value").val(due_day);
			window.opener.$("#basket_main_div #paymethod").val(paymethod);
			window.opener.$("#basket_main_div #paymethod_id").val(paymethod_id);
		}
		
		/*if(opener && opener.form_basket && opener.form_basket.basket_due_value != undefined)
		{
			opener.form_basket.basket_due_value.value = due_day;
			opener.form_basket.paymethod.value = paymethod;
			opener.form_basket.paymethod_id.value = paymethod_id;
		}
		*/
	}
	function add_lot_no(lot_no,deliver_date)
	{//üreteim sonucu sarf ve fire satırlarına lot_no düşürülmesi için.
		<cfif isdefined("attributes.satir") and len(attributes.satir)>
			var satir = <cfoutput>#attributes.satir#</cfoutput>;
			if(window.opener.basket && satir > -1)
			window.opener.updateBasketItemFromPopup(satir, { LOT_NO: lot_no}); // BasketjQuery'de lot no alanına lot no düşürmek için eklendi. 20190410
		<cfelse>
			<cfif isDefined("attributes.lot_no")>
				opener.<cfoutput>#attributes.lot_no#</cfoutput>.value = lot_no;
				<cfif isDefined("attributes.deliver_date")>
					opener.<cfoutput>#attributes.deliver_date#</cfoutput>.value = deliver_date;
				</cfif>
			</cfif>
		</cfif>
		window.close();
	}
	function check_opener_member()
	{
		<!--- Basket yapısı bütün işlem tiplerine uyguladığında kaldırılacaktır. EY 20150720 --->
		<!---urun listesi popupı acıldıktan sonra belgedeki cari degistirilmis mi kontrol ediliyor --->
		<cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined("attributes.int_basket_id")>
			if(window.opener.$("#basket_main_div #company_id") && window.opener.$("#basket_main_div #company_id").val().length && window.opener.$("#basket_main_div #company_id").val() != '<cfoutput>#attributes.company_id#</cfoutput>')
			{
				alert("<cf_get_lang dictionary_id='34272.Ürün Penceresi Açıkken Üye Değiştiremezsiniz'>!");
				return false;
			}
		<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and isdefined("attributes.int_basket_id")>
			if(window.opener.$("#basket_main_div #consumer_id") && window.opener.$("#basket_main_div #consumer_id").val().length && window.opener.$("#basket_main_div #consumer_id").val() != '<cfoutput>#attributes.consumer_id#</cfoutput>')
			{
				alert("<cf_get_lang dictionary_id='34272.Ürün Penceresi Açıkken Üye Değiştiremezsiniz'>!");
				return false;
			}
		</cfif>
		return true;
	}

	/*
	Uğur Hamurpet - 05/05/2020
	Ürün seçimi yaptıktan sonra history.back işlemlerinde tarayıcı tarafından post parametreleri yeniden isteniyor.
	Bunun için ürün filtresindeki parametreler localstorage da depolanıyor ve location.href ile add_basket_row_js.cfm dosyasından yeniden gönderilmesi sağlanıyor
	*/

	<cfset StructDelete(attributes,"FIELDNAMES",true) />
	<cfset StructDelete(attributes,"objects.popup_products",true) />
	<cfset attributes.keyword = URLEncodedFormat(attributes.keyword)>

	if (typeof(Storage) != undefined) {

		localStorage.clear("list_product");
		localStorage.setItem("list_product", '<cfoutput>#Replace(serializeJSON(attributes),"//","")#</cfoutput>');
	
	}

	$( window ).load(function() {
		document.price_cat.keyword.select();
	});
</script>
<br/>
<cfsetting showdebugoutput="no">
