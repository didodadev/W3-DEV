<cfscript>
	function get_spect_row(spect_id)
	{										
		SQLStr = "
				SELECT
					AMOUNT,
					ISNULL(RELATED_MAIN_SPECT_ID,0) RELATED_MAIN_SPECT_ID,
					STOCK_ID
				FROM 
					SPECT_MAIN_ROW SM
				WHERE
					SPECT_MAIN_ID = #spect_id#
					AND IS_PHANTOM = 1
			";
		query1 = cfquery(SQLString : SQLStr, Datasource : new_dsn3);
		stock_id_ary='';
		for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'█');
			stock_id_ary=listappend(stock_id_ary,query1.RELATED_MAIN_SPECT_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
		}
		return stock_id_ary;
	}
	function writeProductTree(spect_main_id,old_amount)
	{
		var i = 1;
		var sub_products = get_spect_row(spect_main_id);
		for (i=1; i lte listlen(sub_products,'█'); i = i+1)
		{
			_next_amount_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
			_next_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
			_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
			phantom_spec_main_id_list = listdeleteduplicates(listappend(phantom_spec_main_id_list,_next_spect_id_,','));
			phantom_stock_id_list = listdeleteduplicates(listappend(phantom_stock_id_list,_next_stock_id_,','));
			'multipler_#_next_spect_id_#' = _next_amount_;
			if(_next_spect_id_ gt 0)
			{
				'multipler_#_next_spect_id_#' = _next_amount_*old_amount;
				writeProductTree(_next_spect_id_,_next_amount_*old_amount);
			}
		 }
	}
</cfscript>
