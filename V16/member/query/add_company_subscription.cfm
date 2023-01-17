<cfinclude template="../../objects/functions/get_basket_money_js.cfm">
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT MONEY MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY
</cfquery>
<cfquery name="GET_COMP_INFO" datasource="#dsn#">
	SELECT * FROM COMPANY WHERE COMPANY_ID = #attributes.subs_member_id#
</cfquery>
<cfquery name="GET_UNIT" datasource="#dsn3#">
	SELECT * FROM PRODUCT_UNIT WHERE PRODUCT_ID = #attributes.product_id#
</cfquery>
<cfscript>
	for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
	{
		'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY_TYPE[stp_mny];
		'attributes.txt_rate1_#stp_mny#'=GET_MONEY_INFO.RATE1[stp_mny];	
		'attributes.txt_rate2_#stp_mny#'=GET_MONEY_INFO.RATE2[stp_mny];
		if(GET_MONEY_INFO.MONEY_TYPE[stp_mny] eq attributes.money_type)
			curr_multp = GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny];
		if(len(session.ep.other_money))
			other_money_info = session.ep.other_money;
		else
			other_money_info = session.ep.money;
		if(GET_MONEY_INFO.MONEY_TYPE[stp_mny] eq other_money_info)
		{
			curr_multp_other = GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny];
			attributes.BASKET_RATE1 = GET_MONEY_INFO.RATE1[stp_mny];
			attributes.BASKET_RATE2 = GET_MONEY_INFO.RATE2[stp_mny];
		}
	}
	attributes.kur_say=GET_MONEY_INFO.RECORDCOUNT;
	attributes.invoice_company_id = attributes.subs_member_id;//sadece company için yapıldı
	attributes.invoice_consumer_id = '';
	attributes.invoice_member_name = attributes.subs_member_id;// alan kontrolleri için
	attributes.invoice_partner_id = attributes.subs_partner_id;
	attributes.member_type = 'partner';
	attributes.company_id = attributes.subs_member_id;
	attributes.partner_id = attributes.subs_partner_id;
	attributes.consumer_id = '';
	//paper_code & '-' & paper_number
	attributes.is_active = 1;
	attributes.subscription_head = attributes.subscription_head;
	attributes.subscription_type = attributes.subscription_type;
	attributes.process_stage = attributes.process_stage;
	attributes.sales_emp_id = '';
	attributes.sales_member_type = '';
	attributes.sales_member_id = '';
	attributes.sales_company_id = '';
	attributes.sales_member_comm_value = '';
	attributes.sales_member_comm_money = '';
	attributes.ref_member_type = '';
	attributes.ref_company = '';
	attributes.subscription_product_id = '';
	attributes.subscription_stock_id = '';
	attributes.subscription_product_name = '';
	attributes.contract_no = attributes.contract_no;
	attributes.montage_emp_id = '';
	attributes.payment_type_id = '';
	attributes.montage_date = attributes.montage_date;
	attributes.start_date = attributes.start_date;
	attributes.finish_date = attributes.finish_date;
	attributes.detail = attributes.detail;
	attributes.inv_detail = '';
	attributes.special_code = '';
	attributes.ship_address = get_comp_info.company_address;
	attributes.ship_postcode = get_comp_info.company_postcode;
	attributes.ship_semt = get_comp_info.semt;
	attributes.ship_county_id = GET_COMP_INFO.COUNTY;
	attributes.ship_city_id = GET_COMP_INFO.CITY;
	attributes.ship_country_id = GET_COMP_INFO.COUNTRY;
	attributes.ship_coordinate_1 = GET_COMP_INFO.COORDINATE_1;
	attributes.ship_coordinate_2 = GET_COMP_INFO.COORDINATE_2;
	attributes.invoice_address = get_comp_info.company_address;
	attributes.invoice_postcode = get_comp_info.company_postcode;
	attributes.invoice_semt = get_comp_info.semt;
	attributes.invoice_county_id = GET_COMP_INFO.COUNTY;
	attributes.invoice_city_id = GET_COMP_INFO.CITY;
	attributes.invoice_country_id = GET_COMP_INFO.COUNTRY;
	attributes.invoice_coordinate_1 = GET_COMP_INFO.COORDINATE_1;
	attributes.invoice_coordinate_2 = GET_COMP_INFO.COORDINATE_2;
	attributes.contact_address = get_comp_info.company_address;
	attributes.contact_postcode = get_comp_info.company_postcode;
	attributes.contact_semt = get_comp_info.semt;
	attributes.contact_county_id = GET_COMP_INFO.COUNTY;
	attributes.contact_city_id = GET_COMP_INFO.CITY;
	attributes.contact_country_id = GET_COMP_INFO.COUNTRY;
	attributes.contact_coordinate_1 = GET_COMP_INFO.COORDINATE_1;
	attributes.contact_coordinate_2 = GET_COMP_INFO.COORDINATE_2;
	attributes.premium_value = '';
	amount_info = wrk_round(filterNum(attributes.amount)*curr_multp);
	attributes.basket_net_total = amount_info;
	attributes.basket_gross_total = amount_info;
	attributes.basket_tax_total = 0;
	attributes.basket_otv_total = 0;
	attributes.basket_money = other_money_info;
	attributes.subs_add_option = '';
	attributes.sales_add_option = '';
	attributes.project_id = '';
	attributes.project_head = '';
	form.genel_indirim = 0;
	attributes.asset_id = attributes.asset_id;
	
	attributes.rows_ = 1;
	rows_info = 1;
	'attributes.product_name#rows_info#' = attributes.product_name;
	'attributes.stock_id#rows_info#' = attributes.stock_id;
	'attributes.product_id#rows_info#' = attributes.product_id;
	'attributes.amount#rows_info#' = 1;
	'attributes.unit#rows_info#' = GET_UNIT.MAIN_UNIT;
	'attributes.unit_id#rows_info#' = GET_UNIT.UNIT_ID;
	'attributes.tax#rows_info#' = 0;
	'attributes.price#rows_info#' = amount_info;
	'attributes.row_lasttotal#rows_info#' = amount_info;
	'attributes.row_nettotal#rows_info#' = amount_info;
	'attributes.row_taxtotal#rows_info#' = 0;
	'attributes.other_money_#rows_info#' = attributes.money_type;
	'attributes.other_money_value_#rows_info#' = wrk_round(amount_info/curr_multp);
	'attributes.price_other#rows_info#' = wrk_round(amount_info/curr_multp);
	'attributes.other_money_gross_total#rows_info#' = wrk_round(amount_info/curr_multp);
	'attributes.otv_oran#rows_info#' = 0;
	'attributes.row_otvtotal#rows_info#' = 0;
</cfscript>
<cfinclude template="../../sales/query/add_subscription_contract.cfm">
