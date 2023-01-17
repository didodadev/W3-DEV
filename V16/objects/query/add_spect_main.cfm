<cfscript>
	main_stock_id=attributes.value_stock_id;
	main_product_id=attributes.value_product_id;
	spec_name='#attributes.spect_name#';
	satir=0;
	stock_id_list="";
	product_id_list="";
	product_name_list="";
	amount_list="";
	sevk_list="";
	configure_list="";
	is_property_list="";
	property_id_list = "";
	variation_id_list = "";
	total_min_list = "";
	total_max_list = "";
	tolerance_list = "";
	spect_status = 1;
	if(len(attributes.tree_record_num) and attributes.tree_record_num gt 0)
		for(i=1;i lte attributes.tree_record_num;i=i+1)
			if(isdefined("attributes.tree_row_kontrol#i#") and evaluate("attributes.tree_row_kontrol#i#") eq 1 and (listlen(evaluate('attributes.tree_product_id#i#'),',') or len(evaluate("attributes.tree_product_id#i#")) ))
			{
				satir=satir+1;
				if(listlen(evaluate('attributes.tree_product_id#i#'),',') gt 1)
					stock_id_list = listappend(stock_id_list,listgetat(evaluate("attributes.tree_product_id#i#"),2,","),',');
				else
					stock_id_list = listappend(stock_id_list,evaluate("attributes.tree_stock_id#i#"),',');
				if(listlen(evaluate('attributes.tree_product_id#i#'),',') gt 1)
					product_id_list = listappend(product_id_list,listgetat(evaluate("attributes.tree_product_id#i#"),1,","),',');
				else
					product_id_list = listappend(product_id_list,evaluate("attributes.tree_product_id#i#"),',');
				if(listlen(evaluate('attributes.tree_product_id#i#'),',') gt 1)
					product_name_list = listappend(product_name_list,listgetat(evaluate("attributes.tree_product_id#i#"),3,","),',');
				else
					product_name_list = listappend(product_name_list,evaluate("attributes.tree_product_name#i#"),',');
				amount_list = listappend(amount_list,evaluate("attributes.tree_amount#i#"),',');
				if(isdefined('attributes.tree_is_sevk#i#'))
					sevk_list = listappend(sevk_list,1,',');
				else
					sevk_list = listappend(sevk_list,0,',');

				if(isdefined('attributes.tree_is_configure#i#') and evaluate('attributes.tree_is_configure#i#') eq 1)
					configure_list = listappend(configure_list,1,',');
				else
					configure_list = listappend(configure_list,0,',');
				is_property_list=listappend(is_property_list,0,',');
				property_id_list = listappend(property_id_list,0,',');
				variation_id_list = listappend(variation_id_list,0,',');
				total_min_list = listappend(total_min_list,'-',',');
				total_max_list = listappend(total_max_list,'-',',');
				tolerance_list = listappend(tolerance_list,'-',',');
			}

		if (isdefined("attributes.record_num") and len(attributes.record_num))
		for(i=1;i lte attributes.record_num;i=i+1)
			if(isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1 and len(evaluate("attributes.stock_id#i#")))
			{
				satir=satir+1;
				stock_id_list = listappend(stock_id_list,evaluate("attributes.stock_id#i#"),',');
				product_id_list = listappend(product_id_list,evaluate("attributes.product_id#i#"),',');
				amount_list = listappend(amount_list,evaluate("attributes.amount#i#"),',');
				if(isdefined('attributes.is_sevk#i#'))
					sevk_list = listappend(sevk_list,1,',');
				else
					sevk_list = listappend(sevk_list,0,',');
				product_name_list = listappend(product_name_list,evaluate("attributes.product_name#i#"),',');
				
				configure_list = listappend(configure_list,0,',');
				
				is_property_list=listappend(is_property_list,1,',');
				property_id_list = listappend(property_id_list,evaluate("attributes.property_id#i#"),',');
				variation_id_list = listappend(variation_id_list,evaluate("attributes.variation_id#i#"),',');
				total_min_list = listappend(total_min_list,'-',',');
				total_max_list = listappend(total_max_list,'-',',');
				tolerance_list = listappend(tolerance_list,'-',',');
			}
</cfscript>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
		s_list=specer(
				dsn_type: dsn3,
				spec_type: session.ep.our_company_info.spect_type,
				spec_is_tree: 0,
				only_main_spec: 1,
				main_stock_id: main_stock_id,
				main_product_id: main_product_id,
				spec_name: spec_name,
				spec_row_count: satir,
				stock_id_list: stock_id_list,
				product_id_list: product_id_list,
				product_name_list: product_name_list,
				amount_list: amount_list,
				is_sevk_list: sevk_list,	
				is_configure_list: configure_list,
				is_property_list: is_property_list,
				property_id_list: property_id_list,
				variation_id_list: variation_id_list,
				total_min_list: total_min_list,
				total_max_list : total_max_list,
				tolerance_list : tolerance_list,
				spect_status : 1
			);
		</cfscript>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=objects.popup_upd_spect_main&SPECT_MAIN_ID=#listgetat(s_list,1,',')#" addtoken="no">
