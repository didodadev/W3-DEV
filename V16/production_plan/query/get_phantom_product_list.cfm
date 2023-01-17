<cfscript>
	function get_subs_order(spect_id)
	{										
		SQLStr = "
				SELECT
					AMOUNT,
					ISNULL(RELATED_MAIN_SPECT_ID,0) RELATED_MAIN_SPECT_ID,
					ISNULL(STOCK_ID,0) STOCK_ID,
					ISNULL(LINE_NUMBER, 0) LINE_NUMBER
				FROM 
					SPECT_MAIN_ROW SM
				WHERE
					SPECT_MAIN_ID = #spect_id#
					AND IS_PHANTOM = 1
			";
		query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
		stock_id_ary='';
		for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'█');
			stock_id_ary=listappend(stock_id_ary,query1.RELATED_MAIN_SPECT_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.LINE_NUMBER[str_i],'§');
		}
		return stock_id_ary;
	}
	function writeTree_order(spect_main_id,old_amount)
	{
		var i = 1;
		var sub_products = get_subs_order(spect_main_id);
		for (i=1; i lte listlen(sub_products,'█'); i = i+1)
		{
			_next_amount_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
			_next_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
			_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
			_next_line_number_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
			phantom_spec_main_id_list = listappend(phantom_spec_main_id_list,_next_spect_id_,',');
			phantom_stock_id_list = listappend(phantom_stock_id_list,_next_stock_id_,',');
			phantom_line_number_list = listappend(phantom_line_number_list,_next_line_number_,',');
			if(_next_spect_id_ gt 0)
			{
				'multipler_#_next_spect_id_#' = _next_amount_*old_amount;
				writeTree_order(_next_spect_id_,_next_amount_*old_amount);
			}
		 }
	}
	function get_subs_operation(next_stock_id,next_spec_id,next_product_tree_id,type)
	{
		if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #next_product_tree_id#';							
		SQLStr = "
				SELECT
					PRODUCT_TREE_ID,
					AMOUNT,
					ISNULL(SPECT_MAIN_ID,0) SPECT_MAIN_ID,
					ISNULL(RELATED_ID,0) STOCK_ID,
					ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID
				FROM
					PRODUCT_TREE PT
				WHERE
					#where_parameter#
				ORDER BY LINE_NUMBER ASC
			";
		query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
		stock_id_ary='';
		'type_#attributes.deep_level_op#' = type;
		for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_TREE_ID[str_i],'█');
			stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,attributes.deep_level_op,'§');
		}
		return stock_id_ary;
	}
	function writeTree_operation(next_stock_id,next_spec_id,next_product_tree_id,type)
	{
		var i = 1;
		var sub_products = get_subs_operation(next_stock_id,next_spec_id,next_product_tree_id,type);
		attributes.deep_level_op = attributes.deep_level_op + 1;
		for (i=1; i lte listlen(sub_products,'█'); i = i+1)
		{
			_next_product_tree_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
			_next_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
			_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
			_next_amount_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
			_next_operation_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),5,'§');
			_next_deep_level_ = ListGetAt(ListGetAt(sub_products,i,'█'),6,'§');
			product_tree_id_list = listappend(product_tree_id_list,_next_product_tree_id_,',');
			operation_type_id_list = listappend(operation_type_id_list,_next_operation_id_,',');
			amount_list = listappend(amount_list,_next_amount_,',');
			"deep_level_#_next_operation_id_#" = _next_deep_level_;
			deep_level_list = listappend(deep_level_list,_next_deep_level_,',');
			if(_next_operation_id_ gt 0) type_=3;else type_=0;

			if(attributes.deep_level_op lt 40)
			{
				writeTree_operation(_next_stock_id_,_next_spect_id_,_next_product_tree_id_,type_);
			}
		 }
	}
	function WriteRelatedProduction2(P_ORDER_ID)
	{
		var i = 1;
		QueryText = '
				SELECT 
					P_ORDER_ID
				FROM 
					PRODUCTION_ORDERS
				WHERE 
					PO_RELATED_ID = #P_ORDER_ID#';
		'GET_RELATED_PRODUCTION#P_ORDER_ID#' = cfquery(SQLString : QueryText, Datasource : dsn3);
		if(Evaluate('GET_RELATED_PRODUCTION#P_ORDER_ID#').recordcount) 
		{
			for(i=1;i lte Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").recordcount;i=i+1)
			{
				related_production_list = ListAppend(related_production_list,Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i],',');
				WriteRelatedProduction2(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]);
			}
		}
	}
	
	

</cfscript>
