<cfscript>
	deep_level2 = 0;
	function isIncludeSubProduct2(_deep_level_)
	{
		is_ok=1;
		for (lind = _deep_level_;lind gte 1; lind = lind-1)
		{
			if(isdefined('type2_#lind#') and Evaluate('type2_#lind#') eq 3 and is_ok eq 1)
				is_ok = 1;
			else
				is_ok = 0;
		}
		return is_ok;
	}
	function get_subs2(spect_main_id,next_stock_id,type)
	{										
		if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #spect_main_id#';
		SQLStr = "
				SELECT
					PRODUCT_TREE_ID RELATED_ID,
					ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID,
					ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID
				FROM 
					PRODUCT_TREE PT
				WHERE
					#where_parameter#
				ORDER BY
					ISNULL(PT.RELATED_ID,0)
			";
		query2 = cfquery(SQLString : SQLStr, Datasource : dsn3);
		stock_id_ary='';
		'type2_#deep_level2#' = type;
		for (str_i=1; str_i lte query2.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query2.RELATED_ID[str_i],'█');
			stock_id_ary=listappend(stock_id_ary,query2.OPERATION_TYPE_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query2.STOCK_RELATED_ID[str_i],'§');
		}
		if(deep_level2 gt 0 and isIncludeSubProduct2(deep_level2) eq 1)
		{		

			new_tree_id_list2 = listdeleteduplicates(ListAppend(new_tree_id_list2,ValueList(query2.RELATED_ID,','),','));
		}
		return stock_id_ary;
	}
	function writeTree2(next_spect_main_id,next_stock_id,type)
	{
		var i2 = 1;
		var sub_products2 = get_subs2(next_spect_main_id,next_stock_id,type);
		deep_level2 = deep_level2 + 1;
		for (i2=1; i2 lte listlen(sub_products2,'█'); i2 = i2+1)
		{
			_next_spect_main_id_ = ListGetAt(ListGetAt(sub_products2,i2,'█'),1,'§');//alt+987 = █ --//alt+789 = §
			_n_operation_id_ = ListGetAt(ListGetAt(sub_products2,i2,'█'),2,'§');
			_n_stock_related_id_= ListGetAt(ListGetAt(sub_products2,i2,'█'),3,'§');
			if(_next_spect_main_id_ gt 0) new_tree_id_list = listappend(new_tree_id_list,_next_spect_main_id_);
			if(_n_operation_id_ gt 0) type_=3;else type_=0;
			writeTree2(_next_spect_main_id_,_n_stock_related_id_,type_);
		}
		deep_level2 = deep_level2 - 1;
	}
</cfscript>

