<cfsetting showdebugoutput="no">
 <cfscript>
	AMOUNT_LIST = Left(AMOUNT_LIST,len(AMOUNT_LIST)-1);
	DIFF_PRICE_LIST = Left(DIFF_PRICE_LIST,len(DIFF_PRICE_LIST)-1);
	IS_CONFIGURE_LIST = Left(IS_CONFIGURE_LIST,len(IS_CONFIGURE_LIST)-1);
	IS_PROPERTY_LIST = Left(IS_PROPERTY_LIST,len(IS_PROPERTY_LIST)-1);
	IS_SEVK_LIST = Left(IS_SEVK_LIST,len(IS_SEVK_LIST)-1);
	PRODUCT_ID_LIST = Left(PRODUCT_ID_LIST,len(PRODUCT_ID_LIST)-1);
	PRODUCT_MONEY_LIST = Left(PRODUCT_MONEY_LIST,len(PRODUCT_MONEY_LIST)-1);
	PRODUCT_NAME_LIST = Left(PRODUCT_NAME_LIST,len(PRODUCT_NAME_LIST)-3);
	PRODUCT_PRICE_LIST = Left(PRODUCT_PRICE_LIST,len(PRODUCT_PRICE_LIST)-1);
	PROPERTY_ID_LIST = Left(PROPERTY_ID_LIST,len(PROPERTY_ID_LIST)-1);
	STOCK_ID_LIST =Left(STOCK_ID_LIST,len(STOCK_ID_LIST)-1) ;
	TOLERANCE_LIST = Left(TOLERANCE_LIST,len(TOLERANCE_LIST)-1);
	TOTAL_MAX_LIST= Left(TOTAL_MAX_LIST,len(TOTAL_MAX_LIST)-1);
	TOTAL_MIN_LIST= Left(TOTAL_MIN_LIST,len(TOTAL_MIN_LIST)-1);
	VARIATION_ID_LIST = Left(VARIATION_ID_LIST,len(VARIATION_ID_LIST)-1);
	RELATED_SPECT_MAIN_ID_LIST = Left(RELATED_SPECT_MAIN_ID_LIST,len(RELATED_SPECT_MAIN_ID_LIST)-1);
	if(isdefined('attributes.line_number_list'))
		line_number_list = Left(line_number_list,len(line_number_list)-1);
	else
		line_number_list = "";	
	a=specer(
			dsn_type : dsn3,
			only_main_spec : 1,
			spec_type : 1,
			spec_is_tree : 0,
			main_stock_id : attributes.main_stock_id,
			main_product_id : attributes.main_product_id,
			spec_name : '#attributes.spec_name#',
			spec_total_value : attributes.spec_total_value,
			main_product_money : '#attributes.main_product_money#',
			spec_other_total_value : attributes.spec_other_total_value,
			other_money : '#attributes.other_money#',
			spec_row_count : attributes.spec_row_count,
			stock_id_list : '#STOCK_ID_LIST#',
			product_id_list : '#PRODUCT_ID_LIST#',
			product_name_list : '#PRODUCT_NAME_LIST#',
			amount_list : '#AMOUNT_LIST#',
			is_sevk_list : '#IS_SEVK_LIST#',
			is_configure_list : '#IS_CONFIGURE_LIST#',
			is_property_list : '#IS_PROPERTY_LIST#',
			property_id_list : '#PROPERTY_ID_LIST#',
			variation_id_list : '#VARIATION_ID_LIST#',
			total_min_list : '#TOTAL_MIN_LIST#',
			total_max_list : '#TOTAL_MAX_LIST#',
			diff_price_list : '#DIFF_PRICE_LIST#',
			product_price_list : '#PRODUCT_PRICE_LIST#',
			product_money_list : '#PRODUCT_MONEY_LIST#',
			tolerance_list : '#TOLERANCE_LIST#',
			related_spect_id_list :'#RELATED_SPECT_MAIN_ID_LIST#',
			line_number_list : '#line_number_list#'
		);
</cfscript>
<script type="text/javascript">
	<cfoutput>
		document.getElementById('related_spect_main_id#attributes.satir#').value = '#listgetat(a,1,',')#';
	</cfoutput>
</script>
